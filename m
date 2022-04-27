Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC019510D1C
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 02:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356380AbiD0AZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 20:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356374AbiD0AZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 20:25:48 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1A94ECE7
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 17:22:39 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n18so225509plg.5
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 17:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9ewLJKlH5zy14vPQwt03lQTFufmxKgCiHNQV6gaoQdc=;
        b=Zp0fAJXPYfQHtfD/574b5Ctm9LKGBHi6SdFtrrS9nbSK0rnjaNH/ZflGxIlKAEpgQ7
         fCuqLnT8AdInvq79GrOlL7DhzsSnaJyUI0+tLN6mhM/u5qdyJ1xXaAEcLGmV2ETDTUBK
         1Kq/p8KqfaUcSJ9BtggMPh82WeHPIySE6tv7z4Jniso6L38NOwhnpOteHLqBZ00xCX49
         dJ7z8PE0nrmjDH/VuuPHZoym+WxS/RT0BuniPVSuzrtBmW/75pV+vfYOtgCtDrVlb3Ga
         UOOwRQZPQN0piq9ySZtanVROVE8/WKq2eTu8+qkzxQdOoJYnZ1r6X/T7Gda0bUuZPfYA
         8kpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9ewLJKlH5zy14vPQwt03lQTFufmxKgCiHNQV6gaoQdc=;
        b=nVMNcctJ+NcK82H6xtdx7wd8FxL1n5jVM5vFrc16z0odJTAtgKmyyxmVH5E1LiYgnR
         6DdAp+huCN+UyQZwv8qsp9e4LheejM6D6G5ds/mb6yrL4g7a/D4798dkPt5Fgq1w8ynP
         bY7D2OOMaNH2a2iZqoMRs4C9bW9rqibtkkway2Wc1rbRlw+zk8G21ZYVe5gRJwBuVPBS
         Tad5l2BBbo9rzYU+6wRchSQYakkoA9L0A2uWxEG32S9UoYI9Vj+YYJQHLI/Y2g8qDhDD
         bnjBJ1BR4PxD6rKQwqFycmgeTHzoLUEZVPqFcYCk89GDmd2FJEMHljHUFjF7/eWhpnqs
         RlGg==
X-Gm-Message-State: AOAM532BwgfVXm/quhdNlikL7veRPtZgOHl22J637W3YXrW/NS/c6XMc
        n8r6l5ivJw0UXRlxX+WTXKMm2IeTacY0FQ==
X-Google-Smtp-Source: ABdhPJzEEdQZBsmr7EWIjVk3IQur/XOj0itw/Uu6+82+3t3Y+Rt1zhEsPNHWrcr5W3ZmqzVJhbvpqQ==
X-Received: by 2002:a17:90a:488c:b0:1c7:b62e:8e8c with SMTP id b12-20020a17090a488c00b001c7b62e8e8cmr40228125pjh.157.1651018958588;
        Tue, 26 Apr 2022 17:22:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s4-20020a056a00194400b004fb358ffe84sm16589662pfk.104.2022.04.26.17.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 17:22:38 -0700 (PDT)
Date:   Wed, 27 Apr 2022 00:22:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Subject: Re: [PATCH v3 01/21] x86/virt/tdx: Detect SEAM
Message-ID: <YmiMyk6T5zNhYeRB@google.com>
References: <cover.1649219184.git.kai.huang@intel.com>
 <ab118fb9bd39b200feb843660a9b10421943aa70.1649219184.git.kai.huang@intel.com>
 <334c4b90-52c4-cffc-f3e2-4bd6a987eb69@intel.com>
 <ce325155bada13c829b6213a3ec65294902c72c8.camel@intel.com>
 <15b34b16-b0e9-b1de-4de8-d243834caf9a@intel.com>
 <79ad9dd9373d1d4064e28d3a25bfe0f9e8e55558.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79ad9dd9373d1d4064e28d3a25bfe0f9e8e55558.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022, Kai Huang wrote:
> On Tue, 2022-04-26 at 16:28 -0700, Dave Hansen wrote:
> > On 4/26/22 16:12, Kai Huang wrote:
> > > Hi Dave,
> > > 
> > > Thanks for review!
> > > 
> > > On Tue, 2022-04-26 at 13:21 -0700, Dave Hansen wrote:
> > > > > +config INTEL_TDX_HOST
> > > > > +	bool "Intel Trust Domain Extensions (TDX) host support"
> > > > > +	default n
> > > > > +	depends on CPU_SUP_INTEL
> > > > > +	depends on X86_64
> > > > > +	help
> > > > > +	  Intel Trust Domain Extensions (TDX) protects guest VMs from
> > > > > malicious
> > > > > +	  host and certain physical attacks.  This option enables necessary
> > > > > TDX
> > > > > +	  support in host kernel to run protected VMs.
> > > > > +
> > > > > +	  If unsure, say N.
> > > > 
> > > > Nothing about KVM?
> > > 
> > > I'll add KVM into the context. How about below?
> > > 
> > > "Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> > > host and certain physical attacks.  This option enables necessary TDX
> > > support in host kernel to allow KVM to run protected VMs called Trust
> > > Domains (TD)."
> > 
> > What about a dependency?  Isn't this dead code without CONFIG_KVM=y/m?
> 
> Conceptually, KVM is one user of the TDX module, so it doesn't seem correct to
> make CONFIG_INTEL_TDX_HOST depend on CONFIG_KVM.  But so far KVM is the only
> user of TDX, so in practice the code is dead w/o KVM.
> 
> What's your opinion?

Take a dependency on CONFIG_KVM_INTEL, there's already precedence for this specific
case of a feature that can't possibly have an in-kernel user.  See
arch/x86/kernel/cpu/feat_ctl.c, which in the (very) unlikely event IA32_FEATURE_CONTROL
is left unlocked by BIOS, will deliberately disable VMX if CONFIG_KVM_INTEL=n.
