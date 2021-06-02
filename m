Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CE3397E09
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 03:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhFBB2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 21:28:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229947AbhFBB2L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 21:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622597189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bbDoXFvPzQ6QDiG26eSDKpzL1zjS2CjaZ8yFXa2h+9g=;
        b=Kl4mgQJMXN0WT58AlFKDyL1dMReICkpa0lzVoOYxQhng7/Jlcc73nqHgl1PGfqsUDIQyd6
        jlxQgmSALpHv2Kiikif9GED49dlcs7A5X9zERMOg7qXIj++AwCQ1gBqVm/Ez93EhTQPbTn
        Dp5XW3GC0oTR/h+PF2za29OXKyhjUPY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-z3TfklF3Pr2j6eVRPqvoxQ-1; Tue, 01 Jun 2021 21:26:26 -0400
X-MC-Unique: z3TfklF3Pr2j6eVRPqvoxQ-1
Received: by mail-qv1-f70.google.com with SMTP id w14-20020a056214012eb02901f3a4388530so599058qvs.17
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 18:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bbDoXFvPzQ6QDiG26eSDKpzL1zjS2CjaZ8yFXa2h+9g=;
        b=Idf2UVZjrY7DXjh9QgqfS5+Khq1SdMyG8gyoVWkV+uNbPbNMaDaf0BSEeo0EJCVyHs
         HKPcmt9hoJ3JN50AGodSO4P+oex7qdGjs/B5m8GNKxWd8NPBWtHD9TnbS2IcLpA/dieI
         6LlLulDDV1f543LIeZyKWEPdCCJRAqXAERjKoWyK6vQhEraWouT7tL0rwF0fb03d/DRv
         7A/NMmKEliuK//VwF1Lw460q++uXf7rllktZQIAQpcqDZ5Ehc4zWh2iCAzFlYzcaKn5h
         VcS2DoBuX34iLOxBcVlH+aU7ZozeM3BiscgB6R6xblGjaO+FS67jr35hJWIuMHexaZ11
         ZiNA==
X-Gm-Message-State: AOAM5316QiblLyWj/fnMER/HGrUr9mHit6if0D+tXIx5+Xz1Ab5huH85
        nq3XOYvrFr1Pgjlv6+SxbJ0Jf0L9c2uamqVM2KmqB7okZ43FxDrsouFkqRVNDu4pps9NpVwosb+
        5YfH/MR/M9VOe
X-Received: by 2002:ac8:7581:: with SMTP id s1mr4302267qtq.302.1622597185959;
        Tue, 01 Jun 2021 18:26:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUfwN3AdXw+a0XCt80C3HeE5tnLSZBgepkGG/HwaRrhHJBeh/IzVMb3GJlykVVF/tKlBlx/g==
X-Received: by 2002:ac8:7581:: with SMTP id s1mr4302254qtq.302.1622597185735;
        Tue, 01 Jun 2021 18:26:25 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-61-184-147-118-108.dsl.bell.ca. [184.147.118.108])
        by smtp.gmail.com with ESMTPSA id o5sm12242270qkl.25.2021.06.01.18.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 18:26:25 -0700 (PDT)
Date:   Tue, 1 Jun 2021 21:26:24 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Hyman Huang <huangy81@chinatelecom.cn>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v1 2/6] KVM: introduce dirty_pages into CPUState
Message-ID: <YLbeQMGCl+J3b2JL@t490s>
References: <cover.1622479161.git.huangy81@chinatelecom.cn>
 <78cc154863754a93d88070d1fae9fed6a1ec5f01.1622479161.git.huangy81@chinatelecom.cn>
 <YLbAoEWOE+no+a7H@t490s>
 <2749938b-f775-ec5a-6ac5-d59cde656999@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2749938b-f775-ec5a-6ac5-d59cde656999@chinatelecom.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 08:27:19AM +0800, Hyman Huang wrote:
> 在 2021/6/2 7:20, Peter Xu 写道:
> > On Tue, Jun 01, 2021 at 01:04:06AM +0800, huangy81@chinatelecom.cn wrote:
> > > diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> > > index 044f668a6e..973c193501 100644
> > > --- a/include/hw/core/cpu.h
> > > +++ b/include/hw/core/cpu.h
> > > @@ -375,6 +375,8 @@ struct CPUState {
> > >       struct kvm_run *kvm_run;
> > >       struct kvm_dirty_gfn *kvm_dirty_gfns;
> > >       uint32_t kvm_fetch_index;
> > > +    uint64_t dirty_pages;
> > > +    bool stat_dirty_pages;
> > 
> > Shall we make this bool a global one?  As I don't think we'll be able to only
> > enable it on a subset of cpus?
> Yes, it's a reasonable advice, i'll apply this on the next version

Or even drop the bool and do the accounting unconditionally?  No need to do +1
for each pfn, but do it once before returning from kvm_dirty_ring_reap_one().

-- 
Peter Xu

