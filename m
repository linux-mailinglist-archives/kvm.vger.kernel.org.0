Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0627052EE93
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350544AbiETO7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350534AbiETO7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:59:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47E3175693
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:59:22 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j21so7735637pga.13
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Es5Lh2idWOFyA0As5szqL6vBrypqfoPCbPVPrQMC34k=;
        b=cfPX9Pk+IPZi4iYdg332mLtgghEUD7ZXcOVrEeRN022CcX21O9m4yr8KnqRgsaKx9K
         OLRbyKJtl4wYFOkdTqK+ry2fkJSr31yE3rWEBR/mTvf9+8OUnAPyP7yBBguotSagCwLM
         96+aMDNx/xnYdCMCW/VLTCnD/lGXGn6FsTZE1aSOpkQWhVcjwqGz/KOx2ITmgDkHAC0b
         jU2z2qbryog853YPL2c8yM0AOBRlN0RgA8FFtdD9lSS5DCcS6PJjEQb0yzQIUB+LKT8t
         3WZyxlODnI1YEzxCbywIn+hoI9sJKI/iRG1xwGvxfJu8yI+PXAKz0i7II+5ybCM4XQuP
         lcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Es5Lh2idWOFyA0As5szqL6vBrypqfoPCbPVPrQMC34k=;
        b=5V8jHwV3mgVvTBTzNPNj5mOgCf3NUGu9PwhF7UXfdGtvfxE8TSuSmMIeg6ClIRRU9f
         pgvOFSak1Rr0LImeIBLPIw6WRkQZsRZBsoVLBsCtJgJGm2CgkzMqt1byPHrtoI4FSwLC
         uFznqNGXwfXfhXGpedCmMPaNQJXQ3fivjyuei/4OUmH9Brsz15WALt+S+KlXQ5c9NCas
         5VjZwrmzl9ox82NoZzFFLZihVWMw2MbFfyDdgAOzUYprtwcnhSTf/NjsuUq6cAbNvok/
         bpZ7hKMXSgarxQLy0c5xrnKzUx90UeJl6cIwsHgYVVy2NriO/QR0gbFCb2N/udtiyUgy
         O+tg==
X-Gm-Message-State: AOAM531RCeoplE5wz30tY0j5XDzx4dyJvB1F/1YXC9bhKmyj4fb6UUxq
        h/sYdl8M4726Dr944TP4BDX3fg==
X-Google-Smtp-Source: ABdhPJzFU4PTFahFGf3CsFP172TCoFsIB0Qe2kkVZ4MwspaNK2iFIqmn6yfy4TSE6lhIdkFfexMfBw==
X-Received: by 2002:a05:6a00:e0e:b0:50a:cb86:883c with SMTP id bq14-20020a056a000e0e00b0050acb86883cmr10563434pfb.11.1653058762044;
        Fri, 20 May 2022 07:59:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e17-20020a17090ae4d100b001df47e47d41sm1911981pju.36.2022.05.20.07.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:59:21 -0700 (PDT)
Date:   Fri, 20 May 2022 14:59:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 6/8] KVM: Fix multiple races in gfn=>pfn cache refresh
Message-ID: <YoesxTEUsdlCLgtb@google.com>
References: <20220427014004.1992589-1-seanjc@google.com>
 <20220427014004.1992589-7-seanjc@google.com>
 <035a5300-27e1-e212-1ed7-0449e9d20615@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <035a5300-27e1-e212-1ed7-0449e9d20615@redhat.com>
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

On Fri, May 20, 2022, Paolo Bonzini wrote:
> On 4/27/22 03:40, Sean Christopherson wrote:
> > +		 * Wait for mn_active_invalidate_count, not mmu_notifier_count,
> > +		 * to go away, as the invalidation in the mmu_notifier event
> > +		 * occurs_before_  mmu_notifier_count is elevated.
> > +		 *
> > +		 * Note, mn_active_invalidate_count can change at any time as
> > +		 * it's not protected by gpc->lock.  But, it is guaranteed to
> > +		 * be elevated before the mmu_notifier acquires gpc->lock, and
> > +		 * isn't dropped until after mmu_notifier_seq is updated.  So,
> > +		 * this task may get a false positive of sorts, i.e. see an
> > +		 * elevated count and wait even though it's technically safe to
> > +		 * proceed (becase the mmu_notifier will invalidate the cache
> > +		 *_after_  it's refreshed here), but the cache will never be
> > +		 * refreshed with stale data, i.e. won't get false negatives.
> 
> I am all for lavish comments, but I think this is even too detailed.

Yeah, the false positive/negative stuff is probably overkill.

> What about:
> 
>                 /*
>                  * mn_active_invalidate_count acts for all intents and purposes
>                  * like mmu_notifier_count here; but we cannot use the latter
>                  * because the invalidation in the mmu_notifier event occurs
>                  * _before_ mmu_notifier_count is elevated.

Looks good, though I'd prefer to avoid the "we", and explicitly call out that its
the invalidation of the caches.


		/*
		 * mn_active_invalidate_count acts for all intents and purposes
		 * like mmu_notifier_count here; but the latter cannot be used
		 * here because the invalidation of caches in the mmu_notifier
		 * event occurs _before_ mmu_notifier_count is elevated.
		 *
		 * Note, it does not matter that mn_active_invalidate_count
		 * is not protected by gpc->lock.  It is guaranteed to
		 * be elevated before the mmu_notifier acquires gpc->lock, and
		 * isn't dropped until after mmu_notifier_seq is updated.
		 */


Also, you'll definitely want to look at v3 of this series.  I'm 99% certain I didn't
change the comment though :-)

https://lore.kernel.org/all/20220429210025.3293691-1-seanjc@google.com
