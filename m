Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4597F526217
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 14:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380394AbiEMMfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 08:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380386AbiEMMfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 08:35:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F9469498;
        Fri, 13 May 2022 05:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652445301; x=1683981301;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zv7Qi86HPneMHTnZpf40yaE9hmnJYLH+m3BORrPBcec=;
  b=RoWmQ6iwVOTB8MQ+8HMUo1kgPbBvVVKr0rrJbk6oskwi7rIaCAksbgZQ
   azZqXoVSy7gU1bkLlXUymZoRnIFOO01bLUT2wmiUMSsZ8ylLKhL8rgDmq
   kZoss0zZnSia9fiKra2UlkpFNTf50VFbbyq5a5ue7D93rNJdAo8cXpmRg
   x/V7umKa6WSL5mBXVRspY93Er4LYY30iSxGC2OAS1xFVXz98C/quJex/t
   umpgMyNB8B+StndAG3z0Vm7qEfPMGWKBh+weKbOVWyRP9QT199Gr+btyx
   KdXBlc5JuCdMN83sDRY+X+0ASwp8s642UxNrMGmLNhXqBpucbn5HDvPPN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="356721676"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="356721676"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 05:35:00 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="521405157"
Received: from apamu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.33.218])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 05:34:58 -0700
Message-ID: <a125cfc58ef09367dc4557fd8a854ed9f21c1675.camel@intel.com>
Subject: Re: [RFC PATCH v6 025/104] KVM: TDX: initialize VM with TDX
 specific parameters
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Date:   Sat, 14 May 2022 00:34:55 +1200
In-Reply-To: <20220509151829.GC2789321@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
         <fbc23565f7556e7b33227bcad95441195bb4758d.1651774250.git.isaku.yamahata@intel.com>
         <b3d587fd-1bf2-411c-96a9-6750e9aeefa2@intel.com>
         <20220509151829.GC2789321@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-05-09 at 08:18 -0700, Isaku Yamahata wrote:
> > > +struct kvm_tdx_init_vm {
> > > +	__u64 attributes;
> > > +	__u32 max_vcpus;
> > > +	__u32 tsc_khz;
> > > +	__u64 mrconfigid[6];	/* sha384 digest */
> > > +	__u64 mrowner[6];	/* sha384 digest */
> > > +	__u64 mrownerconfig[6];	/* sha348 digest */
> > > +	union {
> > > +		/*
> > > +		 * KVM_TDX_INIT_VM is called before vcpu creation, thus
> > > before
> > > +		 * KVM_SET_CPUID2.  CPUID configurations needs to be
> > > passed.
> > > +		 *
> > > +		 * This configuration supersedes KVM_SET_CPUID{,2}.
> > > +		 * The user space VMM, e.g. qemu, should make them
> > > consistent
> > > +		 * with this values.
> > > +		 * sizeof(struct kvm_cpuid_entry2) *
> > > KVM_MAX_CPUID_ENTRIES(256)
> > > +		 * = 8KB.
> > > +		 */
> > > +		struct {
> > > +			struct kvm_cpuid2 cpuid;
> > > +			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
> > > +			struct kvm_cpuid_entry2 entries[];
> > > +		};
> > > +		/*
> > > +		 * For future extensibility.
> > > +		 * The size(struct kvm_tdx_init_vm) = 16KB.
> > > +		 * This should be enough given sizeof(TD_PARAMS) = 1024
> > > +		 */
> > > +		__u64 reserved[2028];
> > 
> > I don't think it's a good idea to put the CPUID configs at the end of this
> > structure and put it into a union.
> > 
> > 1. The union makes the Array of Length zero entries[] pointless.
> > 2. It wastes memory that when new field to be added in the future, it has to
> > be put after union instead of inside union.
> 
> Hmm, I checked this as there was a suggestion to do so.
> I have to admit that it's ugly for future reserved area.  The options I can
> think of are
> 
> A. add a pointer to struct kvm_cpuid2 (previous v5 patch)
> B. this patch.

Why can't we just use kvm_cpuid2 here to replace the union?  We can add
additional reserved space before kvm_cpuid2 for future extension.  Is there any
problem?

I don't see there's fundamental difference between putting kvm_cpuid2 directly
here vs putting a 'cpuid' pointer here.  My personal feeling is the former is
clearer than the latter.

-- 
Thanks,
-Kai


