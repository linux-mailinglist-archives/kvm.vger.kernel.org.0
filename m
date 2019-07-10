Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A0D64672
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 14:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfGJMmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 08:42:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:6683 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727439AbfGJMmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 08:42:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 05:42:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="167716553"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2019 05:42:35 -0700
Date:   Wed, 10 Jul 2019 05:42:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: nVMX: add tracepoint for failed nested
 VM-Enter
Message-ID: <20190710124235.GA3712@linux.intel.com>
References: <20190709172402.2934-1-sean.j.christopherson@intel.com>
 <20190709172402.2934-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709172402.2934-2-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 09, 2019 at 10:24:01AM -0700, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6dd20e0ad2fa..3bfce3f507c7 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -950,9 +960,9 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
>  			       u32 *entry_failure_code)
>  {
>  	if (cr3 != kvm_read_cr3(vcpu) || (!nested_ept && pdptrs_changed(vcpu))) {
> -		if (!nested_cr3_valid(vcpu, cr3)) {
> +		if (CC(!nested_cr3_valid(vcpu, cr3))) {
>  			*entry_failure_code = ENTRY_FAIL_DEFAULT;
> -			return -EINVAL;
> +			return 1;

Gah, botched the rebase, I'll send a v3.
