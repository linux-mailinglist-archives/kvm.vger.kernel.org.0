Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F60E30DA41
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 13:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhBCMxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 07:53:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:33631 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhBCMu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 07:50:26 -0500
IronPort-SDR: jgdJPqAAGT7tTGD4zNujWLHgLxcMQePUoqscyz13Zt/BSL0N3LRPM/9SemA6EoT0MLkf601u9E
 PDzEuZLg2TBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="181178569"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="181178569"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 04:47:43 -0800
IronPort-SDR: YYjB9/fWl1Spvw0vurNKuTxblIOskCClI/mVkhs+e0697wKwLmDdCBq6GZNIe16MnyziV1CUvy
 5Zy7YuwGA8Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="371436354"
Received: from unknown (HELO localhost) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2021 04:47:41 -0800
Date:   Wed, 3 Feb 2021 20:59:57 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v15 14/14] KVM: x86: Save/Restore GUEST_SSP to/from SMRAM
Message-ID: <20210203125957.GB6080@local-michael-cet-test>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-15-weijiang.yang@intel.com>
 <55e43685-f4a7-b068-8d4c-931b8789f031@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e43685-f4a7-b068-8d4c-931b8789f031@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 01:07:53PM +0100, Paolo Bonzini wrote:
> On 03/02/21 12:34, Yang Weijiang wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 22eb6b8626a8..f63b713cd71f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8592,6 +8592,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
> >   	for (i = 0; i < 6; i++)
> >   		enter_smm_save_seg_64(vcpu, buf, i);
> > +
> > +	if (kvm_cet_supported()) {
> > +		struct msr_data msr;
> > +
> > +		msr.index = MSR_KVM_GUEST_SSP;
> > +		msr.host_initiated = true;
> > +		/* GUEST_SSP is stored in VMCS at vm-exit. */
> > +		kvm_x86_ops.get_msr(vcpu, &msr);
> > +		put_smstate(u64, buf, 0x7ec8, msr.data);
> > +	}
> >   }
> >   #endif
> > 
> 
> 0x7ec8 is used for I/O instruction restart and auto-halt restart. 0x7f08 is
> a free spot.  We should really document the KVM state save area format.
Thanks for catching the documentation error! 
> 
> Paolo
