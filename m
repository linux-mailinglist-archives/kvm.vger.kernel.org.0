Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0F1652E09
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiLUIiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLUIh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:37:59 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06981900A
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671611878; x=1703147878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=059t+y3jjueqih2iKv0vuhvacm6KzcVU3zoCRngc5NU=;
  b=D1jRx9Ke2F4Vgq4hFrbKGXq2Icf6YRN340GwaqgQYhOqHuu0KiYqUrUs
   65kbFwdxOVh+Z2v/XZGGONx5slAGJyikwSFzHyi2qQ1gqKNafkKQNj/3h
   pPCGe/5mzQ0l93f3AEJN5tkoCdnPGOw6w0iPnqapNXqzkEgxlWqqJTDk4
   1aXgOpFL/9GFSdhZCJVShKxIoVNK2mvfcpo/cdbISJtU3+JkOS7y4LEfx
   cGyjMpHOUeUYGmzDRKBywmRoibD7eutajaU2cdVneexHBqys5wiWf2Asc
   pWfStgVGsKW9IPMjtG44oY2r67KkhmFLECgjf2FLzGyBjyBXk+323Qgbu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="317454658"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="317454658"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:37:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="651340120"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="651340120"
Received: from xruan5-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.248])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:37:53 -0800
Date:   Wed, 21 Dec 2022 16:37:52 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221083752.gv4iuopad2ghy5vg@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221221081439.b4da6avrgvydjo3r@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221081439.b4da6avrgvydjo3r@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 04:14:39PM +0800, Yu Zhang wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9985dbb63e7b..16ddd3fcd3cb 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2134,6 +2134,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		    (!msr_info->host_initiated &&
> >  		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
> >  			return 1;
> > +
> > +		data = kvm_untagged_addr(data, vcpu);
> 
> Do we really need to take pains to trigger the kvm_untagged_addr()
> unconditionally? I mean, LAM may not be enabled by the guest or even
> not exposed to the guest at all.
> 

Ouch... I just realized, that unlike the paging mode, LAM can
be enabled per-thread, instead of per-VM... 

B.R.
Yu
