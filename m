Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3734BC48D
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 02:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240970AbiBSBZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 20:25:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240560AbiBSBZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 20:25:49 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2122D1FC414
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 17:25:31 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j4so8440758plj.8
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 17:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eomPfhD5NoE4ReiW8wh04qcYSzWi8YJKF2p0Yl/Ax40=;
        b=S8xauw5eRNvVHc2VyhqbjiCO2WntkzltXL1GUn0HpbTYNKQOyd6QrAnf0yjbIE8Hv8
         jDEdSSo7qwP82g+foZZwj2v6xMiCARHcjSxxPB/EdYs+qaAWDRS4DNvVlE3MEMgdSXgs
         PJRHrM0NpsOOKzMNWIsblly5o0bToNRMJH1Cs8MKvTiJLWzhyOUNrSi04Ou/NTHpAbgc
         krd+t5Shs8I2aZ4wNxWpOBS6klYiV3r5nXX3+1CbWTS1WAw6UeyfIV3sz4gZMk4F3Mcy
         a/24x+zQnNeQg6rfYUeWaOBVCSY1ifPqPBEdOkAUAz3qthMvrPfeOGCRiPdbnM7ruxTT
         5GBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eomPfhD5NoE4ReiW8wh04qcYSzWi8YJKF2p0Yl/Ax40=;
        b=uM+yznlRI8pEfMldvQp8aTLASB+Go+dqfkbJpeUwwt6tRx8EJSGd1/HBXrhQecQxLA
         +KXK7/aMiKnPU86MwmHzJiVwEkm6V7UoOkBrizUfwo9kJcXTSO6rU9YrTIO0awPy58Fy
         6HDTcgIVUMqkOlS2c2TM9+NbFtEICJwX4u1vQZn9bingsf036+nlOFmL8dAgekSyLrid
         jyTyoJFQokT3EwVU9l31IzVaijEjoGI3U9Utzd6bhRc0I51sc33sJ4zTscPZ/2R2T4DX
         FASnvl9SCDaI+6U3imNTwmZ3QY3TiUj5P17TaiSzv3SG04bZNP+nO7JW2/FGEVKPFx8t
         NGyw==
X-Gm-Message-State: AOAM530XaugPfKTZoVj9V7lMeGGoXHrgiHBqr6EDHsn57gqYUd5Uj3Ia
        E9OQRZlarSpgg1/kjDRtXgrUiQ==
X-Google-Smtp-Source: ABdhPJwKZkMsYoqfoi2MYYRBw1N1Ik+gH49OpV+P7SHPFenQxJmGHAQpLwAa8F22627Bkfl62i8i3Q==
X-Received: by 2002:a17:903:1210:b0:14e:e194:2f2c with SMTP id l16-20020a170903121000b0014ee1942f2cmr9832626plh.130.1645233930397;
        Fri, 18 Feb 2022 17:25:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id kx15-20020a17090b228f00b001bbb3ec3422sm473914pjb.43.2022.02.18.17.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 17:25:29 -0800 (PST)
Date:   Sat, 19 Feb 2022 01:25:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 03/23] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
Message-ID: <YhBHBuObbNZLUQGR@google.com>
References: <20220203010051.2813563-1-dmatlack@google.com>
 <20220203010051.2813563-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203010051.2813563-4-dmatlack@google.com>
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

On Thu, Feb 03, 2022, David Matlack wrote:
> Decompose kvm_mmu_get_page() into separate helper functions to increase
> readability and prepare for allocating shadow pages without a vcpu
> pointer.
> 
> Specifically, pull the guts of kvm_mmu_get_page() into 3 helper
> functions:
> 
> kvm_mmu_get_existing_sp_mabye_unsync() -

Heh, this ain't Java.   Just add two underscores to whatever it's primary caller
ends up being named; that succinctly documents the relationship _and_ suggests
that there's some "danger" in using the inner helper.

>   Walks the page hash checking for any existing mmu pages that match the
>   given gfn and role. Does not attempt to synchronize the page if it is
>   unsync.
> 
> kvm_mmu_get_existing_sp() -

Meh.  We should really be able to distill this down to something like
kvm_mmu_find_sp().  I'm also tempted to say we go with shadow_page instead of
"sp" for these helpers, so long as the line lengths don't get too brutal.  KVM
uses "sp" and "spte" in lots of places, but I suspect it would be helpful to
KVM newbies if the core routines actually spell out shadow_page, a la
to_shadow_page().

>   Gets an existing page from the page hash if it exists and guarantees
>   the page, if one is returned, is synced.  Implemented as a thin wrapper
>   around kvm_mmu_get_existing_page_mabye_unsync. Requres access to a vcpu
>   pointer in order to sync the page.
> 
> kvm_mmu_create_sp()

Probably prefer s/create/alloc to match existing terminology for allocating roots.
Though looking through the series, there's going to be a lot of juggling of names.

It probably makes sense to figure out what names we want to end up with and then
work back from there.  I'll be back next week for a proper bikeshed session. :-)
