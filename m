Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE55594E9D
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbiHPCWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiHPCWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:22:20 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC6F12E269
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 15:35:13 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id c24so7677381pgg.11
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 15:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=n4WnupM8vXXXNjy7VnOnuld2R32X9LJBT/HWc0crthI=;
        b=pmXHI13ylFiN4yx1jiY6trK0HTh22WXq1w7jnMHScIQiaCbP/mvraIUGFnirRzTobr
         ZFhb0j+GkvK0SXAMSX9j7RJ5ufpzCBCzryxBC1XSsLCqjrucYl2e+Fn0zmLm7F0zcCDq
         ue+8trNipL2MLtTMyk8H8XfuFfIglbRflYh2Yi9/t28iUlCThUhNavgDtojTVFfH2q5L
         NYM/FkgkpXsDy4xcywGq+zhTBa9zIZyzadV2mp4I0eCUC9V20e7zvEuhM4UYZOtqURsE
         8WlN19MfQa+rkTWXEr7ABvKgI0K17vwiUQTTKqbZ97TgdE1r3lkn2GE4mn53AotipJ6V
         FkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=n4WnupM8vXXXNjy7VnOnuld2R32X9LJBT/HWc0crthI=;
        b=LwK+Drr1C37xM7tzX10U9f2jHLFemQHSA2HGc8fUOdUKlo62OZnXhd3fL6LtNkwbEE
         F20/ARmWdEiCsBHr3tZXnpvuCyveIEgL+cPBPT+R15iObdjCLK+N3JbP807EUs0M3Yu4
         XjlioV8nvxxIxiDiDc7X1x+YqBtGSZfn22rJll77k6J+zshqBVLg8LQ6zC49h0gHA2ai
         Ovj0Pt0ESS24J6aTuyQ5FHLcrAjzO/abOxD9OUMAAqG2zzQbiTfl/UFnylksj44swYkf
         z0ha6BE/ArgIBKXQdAVy+/5HSv2cUa3bYnS+0+YnFPro0SuuBuQJHPL7D8gK/PpBINby
         MA7Q==
X-Gm-Message-State: ACgBeo1B6WD3pq2PfQw3blmr1tmzIShB3ZjdJLTCyPwKBQtknx+al7/8
        XmhvgmlJ8W86sM60Pm5xZiZnDw==
X-Google-Smtp-Source: AA6agR4P/YkXJVHn+Eb+ntNme0oUKwObXlSN+fMcDh1dOHUzSiNRupT6Dwtj3Iirib9+gBX0aACOEA==
X-Received: by 2002:a05:6a00:234f:b0:525:1f7c:f2bf with SMTP id j15-20020a056a00234f00b005251f7cf2bfmr18562534pfj.14.1660602909639;
        Mon, 15 Aug 2022 15:35:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w62-20020a623041000000b005350ea966c7sm1097210pfw.154.2022.08.15.15.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 15:35:09 -0700 (PDT)
Date:   Mon, 15 Aug 2022 22:35:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on
 module initialization
Message-ID: <YvrKGUSud3F/9Qnm@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
 <d36802ee3d96d0fdac00d2c11be341f94a362ef9.camel@intel.com>
 <YvU+6fdkHaqQiKxp@google.com>
 <283c3155f6f27229d507e6e0efc5179594a36855.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <283c3155f6f27229d507e6e0efc5179594a36855.camel@intel.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022, Huang, Kai wrote:
> On Thu, 2022-08-11 at 17:39 +0000, Sean Christopherson wrote:
> > I've been poking at the "hardware enable" code this week for other reasons, and
> > have come to the conclusion that the current implementation is a mess.
> 
> Thanks for the lengthy reply :)
> 
> First of all, to clarify, I guess by "current implementation" you mean the
> current upstream KVM code, but not this particular patch? :)

Yeah, upstream code.

> > Of course, that path is broken for other reasons too, e.g. needs to prevent CPUs
> > from going on/off-line when KVM is enabling hardware.
> > https://lore.kernel.org/all/20220216031528.92558-7-chao.gao@intel.com
> 
> If I read correctly, the problem described in above link seems only to be true
> after we move CPUHP_AP_KVM_STARTING from STARTING section to ONLINE section, but
> this hasn't been done yet in the current upstream KVM.  Currently,
> CPUHP_AP_KVM_STARTING is still in STARTING section so it is guaranteed it has
> been executed before start_secondary sets itself to online cpu mask. 

The lurking issue is that for_each_online_cpu() can against hotplug, i.e. every
instance of for_each_online_cpu() in KVM is buggy (at least on the x86 side, I
can't tell at a glance whether or not arm pKVM's usage is safe).

https://lore.kernel.org/all/87bl20aa72.ffs@tglx

> Btw I saw v4 of Chao's patchset was sent Feb this year.  It seems that series
> indeed improved CPU compatibility check and hotplug handling.  Any reason that
> series wasn't merged?

AFAIK it was just a lack of reviews/acks for the non-KVM patches.

> Also agreed that kvm_lock should be used.  But I am not sure whether
> cpus_read_lock() is needed (whether CPU hotplug should be prevented).  In
> current KVM, we don't do CPU compatibility check for hotplug CPU anyway, so when
> KVM does CPU compatibility check using for_each_online_cpu(), if CPU hotplug
> (hot-removal) happens, the worst case is we lose compatibility check on that
> CPU.
> 
> Or perhaps I am missing something?

On a hot-add of an incompatible CPU, KVM would potentially skip the compatibility
check and try to enable hardware on an incompatible/broken CPU.

Another possible bug is the checking of hv_get_vp_assist_page(); hot-adding a
CPU that failed to allocate the VP assist page while vmx_init() is checking online
CPUs could result in a NULL pointer deref due to KVM not rejecting the CPU as it
should.	

> > 	mutex_lock(&kvm_lock);
> > 	cpus_read_lock();
> > 	r = kvm_arch_add_vm(kvm, kvm_usage_count);
> 
> Holding cpus_read_lock() here implies CPU hotplug cannot happen during
> kvm_arch_add_vm().  This needs a justification/comment to explain why.  

Oh, for sure, the above was only intended to be a rough sketch, definitely not a
formal patch.

> Also, assuming we have a justification, since (based on your description above)
> arch _may_ choose to enable hardware within it, but it is not a _must_.  So
> maybe remove cpus_read_lock() here and let kvm_arch_add_vm() to decide whether
> to use it?

My thought is that it makes sense to provide a CPU hotplug friendly arch hook since
(a) all architectures except s390 (and maybe PPC) need such a hook (or more likely,
multiple hooks) and (b) cpus_read_lock() will almost never be contended.

In other words, address the problem that's easy to solve (but also easy to forget)
in generic code, but let architectures deal with the hardware enabling problem,
which is a mess to solve in generic code (unless I'm missing something).

All that said, I haven't tried compiling yet, let alone actually running anything,
so it's entirely possible my idea won't pan out.
