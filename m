Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB886A8308
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 14:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCBNAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 08:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCBNAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 08:00:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF501514C
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677762007; x=1709298007;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T5bNjZvSy4oRgG+6bb040xB9/98+WOBdezXZHhLu+SY=;
  b=lJjFJo8J90meVzsd0+fJe7/RM9Pwtkef0Dw9iFh+hAf+9ZykexTaIFv2
   0FcpO2fjuI2GcOzeuT5RX21ALCSHkhzjoOsRhLOkk6STD9/kj1FqBQB8M
   CQfJVVVbQL7YRu1fMiNCVXVmCbeNpdlj7GDF/UBZ+7Al9RgDfmz4hDRdX
   K4HeMUnCx5FVeX2/XIgwNlv/305xsRdZo8ILCacLZ3P4VcpvKCKQv8/yk
   TuLM4l9FqvlVnVTXCEA4Zz0QPDXD/daOGnjbaqcwDL+LhbBESv+AIu18J
   0McKXzeUI2Ca325YWzqFrion0K270h3poJZnpvLHOwszr6Rqi5BwD4UAb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="399500979"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="399500979"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 05:00:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="784811128"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="784811128"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 02 Mar 2023 05:00:05 -0800
Message-ID: <cf8262970256be0de77a4abf4fa5d3a211cc81cd.camel@linux.intel.com>
Subject: Re: [PATCH v5 1/5] KVM: x86: Virtualize CR4.LAM_SUP
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, binbin.wu@linux.intel.com,
        kvm@vger.kernel.org
Date:   Thu, 02 Mar 2023 21:00:04 +0800
In-Reply-To: <ZABNkFpypTK5tvYW@gao-cwp>
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
         <20230227084547.404871-2-robert.hu@linux.intel.com>
         <ZABNkFpypTK5tvYW@gao-cwp>
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

On Thu, 2023-03-02 at 15:17 +0800, Chao Gao wrote:
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 9de72586f406..8ec5cc983062 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32
> > index, u32 type);
> > 		__reserved_bits |= X86_CR4_VMXE;        \
> > 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
> > 		__reserved_bits |= X86_CR4_PCIDE;       \
> > +	if (!__cpu_has(__c, X86_FEATURE_LAM))		\
> > +		__reserved_bits |= X86_CR4_LAM_SUP;	\
> > 	__reserved_bits;                                \
> > })
> 
> Add X86_CR4_LAM_SUP to cr4_fixed1 in
> nested_vmx_cr_fixed1_bits_update()
> to indicate CR4.LAM_SUP is allowed to be 0 or 1 in VMX operation.
> 
Is this going to support nested LAM?

> With this fixed,
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>

