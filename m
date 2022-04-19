Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837BA507A87
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 21:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345807AbiDST5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 15:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344888AbiDST5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 15:57:48 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BF8B7CF
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 12:55:05 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h1so1731662pfv.12
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 12:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i6L4akEkVxKPhVRDAOiT0FePP0EWPGcPFgsC+RRy/gQ=;
        b=bnlPfTSoWYmUXo/nUZ9t0gIb4mbtq/+ury0PkxRLIvhP2n132giaO0/k/ddiyI4vjR
         D6if6T1Dp5dS+ovCaT2bmXVebbUo1/IEMb+aqjsIDHxuky2VnG1jfRHRwN+nOsTqOQIT
         +pbAUJlzGUvLE+tgL44HpCken2Qu2XEzqlpzQDZbQ04wk+zaWlEhU6k6spJzHVNtdWZm
         oQfy0zWk1taM9EC8ZgMBXa+/M9aOIdNEkOJv/oxqqr1lI5jTJuzyGYLqH8Nz1REcGZDC
         +N3A764GiPsmZIBmwmtdLFt7HOF9Com+Fudh+DKy60Bys+SvW2fYdjyLY8ydh1TqFv1S
         fTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i6L4akEkVxKPhVRDAOiT0FePP0EWPGcPFgsC+RRy/gQ=;
        b=KLZHskIktp58fwLJPSSgpdsSLOYnQ2Q94eXcrsoWQ2ZNfnFPyAM42JznBDu9VudSaR
         Pquy+mq1zcc9Q1D+Ldl7p8s/azqQ8BHZVY1dwc7+dPDc4LMukdh033GzV/qHmakQNOuM
         ev0962W5BQOO2j/fvkp6jMX+DO8MK7wZENhImG5saxFjZ72bJhPpP3FibkU+1e5Ylv/s
         VINtBDLmbWD7XSbsWMNh7om4KkYyEJT2x8GOu9bvDRTJ1uYGKw1z8+A/UuAB8KQRukyi
         ZjbSehst7yDIzpVBswwvxdVfrIwy5ulJNSJZzYrR6y569HZ09Q1Rji6RfTBkV6+bkrLk
         BquQ==
X-Gm-Message-State: AOAM532MbLG2gxG4uU9SdOT9mmTIEVU3FRlHtaxxcuC/qT3WdtMqmhUp
        tTk6vk50avTO2I7jqVbelpr7NQ==
X-Google-Smtp-Source: ABdhPJzd7Sb6wK/ijaIdyJ3vw61yEiIZZ5v7n+nHco/OzJHhFQgoWm9yDCXBw6a3J+y81YaEUHZB9g==
X-Received: by 2002:a65:6c10:0:b0:380:437a:c154 with SMTP id y16-20020a656c10000000b00380437ac154mr15914468pgu.549.1650398104459;
        Tue, 19 Apr 2022 12:55:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm16911021pjf.23.2022.04.19.12.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 12:55:03 -0700 (PDT)
Date:   Tue, 19 Apr 2022 19:55:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 042/104] KVM: x86/mmu: Track shadow MMIO
 value/mask on a per-VM basis
Message-ID: <Yl8TlMTQGq5R69E6@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b494b94bf2d6a5d841cb76e63e255d4cff906d83.1646422845.git.isaku.yamahata@intel.com>
 <84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com>
 <20220408184659.GC857847@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408184659.GC857847@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry, missed my name...

On Fri, Apr 08, 2022, Isaku Yamahata wrote:
> On Tue, Apr 05, 2022 at 05:25:34PM +0200,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > > +	if (enable_ept) {
> > > +		const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
> > >   		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
> > > -				      cpu_has_vmx_ept_execute_only());
> > > +				      cpu_has_vmx_ept_execute_only(), init_value);
> > > +		kvm_mmu_set_spte_init_value(init_value);
> > > +	}
> > 
> > I think kvm-intel.ko should use VMX_EPT_SUPPRESS_VE_BIT unconditionally as
> > the init value.  The bit is ignored anyway if the "EPT-violation #VE"
> > execution control is 0.
> > Otherwise looks good, but I have a couple more crazy ideas:
> > 
> > 1) there could even be a test mode where KVM enables the execution control,
> > traps #VE in the exception bitmap, and shouts loudly if it gets a #VE.  That
> > might avoid hard-to-find bugs due to forgetting about
> > VMX_EPT_SUPPRESS_VE_BIT.
> > 
> > 2) or even, perhaps the init_value for the TDP MMU could set bit 63
> > _unconditionally_, because KVM always sets the NX bit on AMD hardware.

Heh, took me a minute to realize you mean EFER.NX.  To clarify:

KVM requires NX support in hardware

	if (!boot_cpu_has(X86_FEATURE_NX)) {
		pr_err_ratelimited("NX (Execute Disable) not supported\n");
		return -EOPNOTSUPP;
	}

and 64-bit or PAE paging to enable NPT

	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
		npt_enabled = false;

and the _kernel_ forces EFER.NX=1 for 64-bit and PAE kernels.

But whether or not EFER.NX is enabled is irrelevant, it's only the initial value,
i.e. the SPTE is guaranteed to be !PRESENT, so hardware will never generate a
reserved bit #PF.

> > That would remove the whole infrastructure to keep shadow_init_value,
> > because it would be constant 0 in mmu.c and constant BIT(63) in tdp_mmu.c.
> > 
> > Sean, what do you think?

I like #2, though I suspect we'll still want shadow_init_value so that the MMU
caches can be shared without creating a mess.   But I still like keeping that
detail in the MMUs and out of the vendor modules, even though there's obviously
a hard dependency on the MMU doing the right thing.

> Then, I'll start with 1) because it's a bit hard for me to test 2) with real AMD
> hardware.  If someone is willing to test 2), I'm quite fine to implement 2)
> on top of 1).  2) isn't exclusive with 1).

I can test #2.

Tangentially related, the kvm_gfn_stolen_mask() exception to MMIO SPTEs is unnecessarily
convoluted and gross.  That's partly my fault as I should have just updated
enable_mmio_caching when hardware can't support it instead of using shadow_mmio_value
to convey that information.  I'll submit a patch to fix that, then is_mmio_spte()
can be left alone in the TDX series.
