Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92F569B83C
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 06:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBRFoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Feb 2023 00:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBRFoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Feb 2023 00:44:39 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3D628D39
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 21:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676699078; x=1708235078;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=haRlkAgcYkhGDvebpMRn/qyHfuXfks9bD1qLIbuHE3A=;
  b=IXE8z6a7IGPlpNaJx9A/VlbZd0VR2a4y/BIaxqFzjoq2pMWya0ZMfFMe
   GVLNePPkikwIPdUD0Ou1GXdAOj9OR07tpIQE6mr3WhxfCgd+CD2z6mCAW
   zx2VgYpy+HL+1tdJ7bscWOavsLyEFmlskFonA95T0bKKHOkT9WNuX+Zgw
   Ltre6vFCfDn6JD3Mz/VvFXyYFYm+Y8t58JIRgDbdZIOf1jjTd+/8iuBgc
   g0H24mWx8/P4lG3LMRDVngPA09wUAZho1RXAurglVtEQZHXr7OVD2N6oD
   EQKp6B4HncY+NigXM3MJKYgp+KTQJlPY2SZ8Jpq16HF/sEcNOQdkXrQkz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="334347022"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="334347022"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 21:44:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="739499997"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="739499997"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 17 Feb 2023 21:44:35 -0800
Message-ID: <f37d51834112f5085c3e635ebc12480b4dba1828.camel@linux.intel.com>
Subject: Re: [PATCH v4 6/9] KVM: x86: When KVM judges CR3 valid or not,
 consider LAM bits
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, isaku.yamahata@intel.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Date:   Sat, 18 Feb 2023 13:44:34 +0800
In-Reply-To: <Y+sn09U4wTIxoDKN@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
         <20230209024022.3371768-7-robert.hu@linux.intel.com>
         <Y+mZ/ja1bt5L9jfl@gao-cwp>
         <cd11d9bd2ab1560f0adce5da32190739f7550b06.camel@linux.intel.com>
         <Y+sn09U4wTIxoDKN@gao-cwp>
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

On Tue, 2023-02-14 at 14:18 +0800, Chao Gao wrote:
> There are two ways that make sense to me:
> option 1:
> 
> patch 1: virtualize CR4.LAM_SUP
> patch 2: virtualize CR3.LAM_U48/U57
> patch 3: virtualize LAM masking on applicable data accesses
And patch 4: KVM emulation: Apply LAM when emulating data access
> patch 4: expose LAM CPUID bit to user sapce VMM

> > > > 	 * the current vCPU mode is accurate.
> > > > 	 */
> > > > -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
> > > > +	if (!kvm_is_valid_cr3(vcpu, cr3))
> > > 
> > > There are other call sites of kvm_vcpu_is_illegal_gpa() to
> > > validate
> > > cr3.
> > > Do you need to modify them?
> > 
> > I don't think so. Others are for gpa validation, no need to change.
> > Here is for CR3.
> 
> how about the call in kvm_is_valid_sregs()? if you don't change it,
> when
> user space VMM tries to set a CR3 with any LAM bits, KVM thinks the
> CR3
> is illegal and returns an error. To me it means live migration
> probably
> is broken.

Agree. Will add this check in v5.
> 
> And the call in nested_vmx_check_host_state()? L1 VMM should be
> allowed to
> program a CR3 with LAM bits set to VMCS's HOST_CR3 field. 

Right, per spec, it should be allowed. 


