Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6746946F3
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 14:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjBMN0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 08:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjBMNZ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 08:25:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCAA1ADC8
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 05:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676294755; x=1707830755;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GJtQLCFFcNY7WdH1m4b75Yc62eRv0h0pOqP1DOMmL+4=;
  b=QmK4/11A4n7crsNxrAdXHDFbSUSQSZU4EpQpEpkMU5RsPCI5ayo9GBui
   G0QZ9YOayJqnfqNofbXy/rmgMFp5Ne1pfx5ZzX15Yz7aeEQnCVRRAnbUn
   OQIl7Z0thGfgVXmw95kFWHkL+HqoF38pbb8BEgX7DC3ZG1cF8v0iRrJfg
   3ui81dKF7Paix/EOF89IAyDqdfysmjGV0umSSPt6JNiYDxTDTRRV5R5R/
   eP3t+aIMrJjtbA8Tdn2te1p0Ambvn4rjlaeHD0w5R06I5ElpHZ7zguleu
   7RuW53ylzaCQ8dSyWEzzY6sfaG9pgBema5gBjxAgd7z+pQQ278e/UiT7a
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="417111986"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="417111986"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 05:25:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="699174148"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="699174148"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 13 Feb 2023 05:25:51 -0800
Message-ID: <cd11d9bd2ab1560f0adce5da32190739f7550b06.camel@linux.intel.com>
Subject: Re: [PATCH v4 6/9] KVM: x86: When KVM judges CR3 valid or not,
 consider LAM bits
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Mon, 13 Feb 2023 21:25:50 +0800
In-Reply-To: <Y+mZ/ja1bt5L9jfl@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-7-robert.hu@linux.intel.com>
         <Y+mZ/ja1bt5L9jfl@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-02-13 at 10:01 +0800, Chao Gao wrote:
> On Thu, Feb 09, 2023 at 10:40:19AM +0800, Robert Hoo wrote:
> > Before apply to kvm_vcpu_is_illegal_gpa(), clear LAM bits if it's
> > valid.
> 
> I prefer to squash this patch into patch 2 because it is also related
> to
> CR3 LAM bits handling.
> 
Though all surround CR3, I would prefer split into pieces, so that
easier for review and accept. I can change their order to group
together. Is is all right for you?
> > 
> > 
> > +static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long
> > cr3)
> 
> Since this function takes a "vcpu" argument, probably
> kvm_vcpu_is_valid_cr3() is slightly better.

OK, to align with kvm_vcpu_is_legal_gpa().
> 
> > +{
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
> 
> check if the vcpu is in the 64 bit long mode?

Emm, looks necessary. 
	(guest_cpuid_has(vcpu, X86_FEATURE_LAM) && is_long_mode(vcpu))
Let me ponder more, e.g. when guest has LAM feature but not in long
mode...
> 
> > +		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> > +
> > +	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
> > +}
> > +
> > int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > {
> > 	bool skip_tlb_flush = false;
> > @@ -1254,7 +1262,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu,
> > unsigned long cr3)
> > 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee
> > that
> > 	 * the current vCPU mode is accurate.
> > 	 */
> > -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
> > +	if (!kvm_is_valid_cr3(vcpu, cr3))
> 
> There are other call sites of kvm_vcpu_is_illegal_gpa() to validate
> cr3.
> Do you need to modify them?

I don't think so. Others are for gpa validation, no need to change.
Here is for CR3.
> 
> > 		return 1;
> > 
> > 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
> > -- 
> > 2.31.1
> > 

