Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACFF79F74
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 05:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfG3DIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 23:08:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:15685 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfG3DIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 23:08:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 20:08:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,325,1559545200"; 
   d="scan'208";a="179599286"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jul 2019 20:08:51 -0700
Date:   Mon, 29 Jul 2019 20:08:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 08/21] KVM: x86: Add kvm_x86_ops hook to short
 circuit emulation
Message-ID: <20190730030850.GM21120@linux.intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
 <20190727055214.9282-9-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190727055214.9282-9-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 26, 2019 at 10:52:01PM -0700, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 48c865a4e5dd..0fb8b60eb136 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7115,10 +7115,25 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  	return -ENODEV;
>  }
>  
> -static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
> +static bool svm_is_emulatable(struct kvm_vcpu *vcpu, void *insn, int insn_len)
>  {
>  	bool is_user, smap;
>  
> +	if (likely(!insn || insn_len))
> +		return true;
> +
> +	/*
> +	 * Under certain conditions insn_len may be zero on #NPF.  This can
> +	 * happen if a guest gets a page-fault on data access but the HW table
> +	 * walker is not able to read the instruction page (e.g instruction
> +	 * page is not present in memory). In those cases we simply restart the
> +	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
> +	 */
> +	if (unlikely(insn && !insn_len)) {
> +		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
> +			return 1;
> +	}

Doh, obviously forgot to compile for SVM when rebasing.
