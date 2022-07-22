Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3577157E4F5
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiGVRFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 13:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiGVRFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 13:05:12 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85DD7650
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 10:05:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x24-20020a17090ab01800b001f21556cf48so8682173pjq.4
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 10:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EIQBR56/tJcNBR6OGH/TjjSrDbmF7UtKhywW9Hj0CUY=;
        b=ll/TN7RHrz3zet8Hb5kr/a0vsvXTl01rS1ijTZRx2gc/6AX7XZlUe25dJ6dyifZAkn
         Vf+suc2mp2Mo7OU49OfAsxW+vzt+VLB/Lhh9jZPHlIOKu6rw5SPMA7lwqcPFOSix23E3
         xidaleqnYRsuyCOp0BBfofLrx0Wp2Js/csk6eMH+TEQ6i1btJRgPyQnM/sYt9CtFFiX0
         9evjlfYud7iuG5e94WVg8HHecjPuvNJTUmjMIxGyFSb6Inhmlbfw5D9ZoAvyRw8qTdiN
         yv0FzfY0EXkrrnsH4/IYTex0Y7BMikYCyw6oHvxJX4k1BdSI043dkl2mssfj9SP1XxAZ
         TP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EIQBR56/tJcNBR6OGH/TjjSrDbmF7UtKhywW9Hj0CUY=;
        b=0zgRZ+AO672icIisJNfLYbK8kV/ZFUsj0YzAT0rles/1rBrfyF8oRa/ySpcXVP1Mfl
         YFb00dlgn9A35JMJh2oJWyrQQ75go0puGurHd9n17x5Iqmin8B4RmCxgYdvxaisFhUlC
         krbjiL3EE1lriTRs+IcTpPQ+pUb0eNj0PC6nTnsnrlM8vA3p3CMiIS4S7QYThUlg3u0p
         SNUNGrqxd1SdqiQq3zqPs8K4CUToRUB9UcmmSek9TS4SJRo/91pKuqeB2sIlmvqPky7Y
         FcRPcB/exta0lGt8mYb52gdok1ZsW44D0OJLToDrGCH86haxCxH/W78nzDcWLzrzeelF
         NdWw==
X-Gm-Message-State: AJIora8L4JciaLVHHU+Fwx8Bu81YzWVl1FThODlGUzeihZuTa4ktaq29
        96ltrfoKsTPdNvUS8t3mTitY3g==
X-Google-Smtp-Source: AGRyM1vFlk9DkZd9UBK770fSURYjd+N7HQh0/nEt16WDmaIMu9aOsXfJxkshzokJ7v3u6ERX5w/m5A==
X-Received: by 2002:a17:902:da85:b0:16c:bf2e:fac7 with SMTP id j5-20020a170902da8500b0016cbf2efac7mr784455plx.166.1658509510994;
        Fri, 22 Jul 2022 10:05:10 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:200:2571:bd04:907d:d32f])
        by smtp.gmail.com with ESMTPSA id f26-20020a631f1a000000b00415320bc31dsm3632484pgf.32.2022.07.22.10.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 10:05:10 -0700 (PDT)
Date:   Fri, 22 Jul 2022 10:04:59 -0700
From:   Peter Collingbourne <pcc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v2 3/7] mm: Add PG_arch_3 page flag
Message-ID: <YtrYu54WBHJa4YMP@google.com>
References: <20220722015034.809663-1-pcc@google.com>
 <20220722015034.809663-4-pcc@google.com>
 <87leslxmf1.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87leslxmf1.wl-maz@kernel.org>
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

On Fri, Jul 22, 2022 at 03:16:34PM +0100, Marc Zyngier wrote:
> On Fri, 22 Jul 2022 02:50:29 +0100,
> Peter Collingbourne <pcc@google.com> wrote:
> > 
> > As with PG_arch_2, this flag is only allowed on 64-bit architectures due
> > to the shortage of bits available. It will be used by the arm64 MTE code
> > in subsequent patches.
> > 
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Steven Price <steven.price@arm.com>
> > [catalin.marinas@arm.com: added flag preserving in __split_huge_page_tail()]
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  fs/proc/page.c                 | 1 +
> >  include/linux/page-flags.h     | 1 +
> >  include/trace/events/mmflags.h | 7 ++++---
> >  mm/huge_memory.c               | 1 +
> >  4 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/proc/page.c b/fs/proc/page.c
> > index a2873a617ae8..438b8aa7249d 100644
> > --- a/fs/proc/page.c
> > +++ b/fs/proc/page.c
> > @@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
> >  	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
> >  #ifdef CONFIG_64BIT
> >  	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
> > +	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_3);
> 
> Are PG_arch_2 and PG_arch_3 supposed to share the same user bit in
> /proc/kpageflags? This seems odd.

No, that was an oversight, thanks for the catch. I will fix it up like
so in v3.

Peter

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 438b8aa7249d..0129aa3cfb7a 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -220,7 +220,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_64BIT
 	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
-	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_3);
+	u |= kpf_copy_bit(k, KPF_ARCH_3,	PG_arch_3);
 #endif
 
 	return u;
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index eee1877a354e..859f4b0c1b2b 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -18,5 +18,6 @@
 #define KPF_UNCACHED		39
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
+#define KPF_ARCH_3		42
 
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 381dcc00cb62..364373f5bba0 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -79,6 +79,7 @@
 #define KPF_UNCACHED		39
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
+#define KPF_ARCH_3		42
 
 /* [47-] take some arbitrary free slots for expanding overloaded flags
  * not part of kernel API
@@ -138,6 +139,7 @@ static const char * const page_flag_names[] = {
 	[KPF_UNCACHED]		= "c:uncached",
 	[KPF_SOFTDIRTY]		= "f:softdirty",
 	[KPF_ARCH_2]		= "H:arch_2",
+	[KPF_ARCH_3]		= "H:arch_3",
 
 	[KPF_ANON_EXCLUSIVE]	= "d:anon_exclusive",
 	[KPF_READAHEAD]		= "I:readahead",
