Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF13C77969D
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 20:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbjHKSCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 14:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjHKSCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 14:02:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E3310F
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 11:02:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d67a458ff66so515372276.3
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 11:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691776933; x=1692381733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ma7a/CvcC7qFVUR/wztxpShWVPAvNO22UGYt8xcZrPE=;
        b=vyhtq7mw6Sok8TLRoNnb2IGBgqG2DuctGPx0sCkRsFzLEc+H7j88xYimth+H6YPf9t
         pb90l8gdn8EMaad/WFDbC1e6W5BI7XlH7KFZLLryKbi8jLFhSmdqi2dMh/Hr5HIBLfZd
         m9AAfJfL01O1s+jphUTgHJdDLc1nRKlSYT5RlkpKyhzlIgh4z2+rvMTSXOnxMlldN59H
         ZfLSCIxX5QkEkxYPN/dTDSog/1HdVfcstnhFiG7tnz7eC13mac/6Pn8/wyHTjiNDTIt9
         FrByPsqmWJNbX1VgsGgZBXjRnXDsgmu/WNVEKEzuFts0yWP5nmTSc/91mBh5+hkJ1OP9
         FkLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691776933; x=1692381733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ma7a/CvcC7qFVUR/wztxpShWVPAvNO22UGYt8xcZrPE=;
        b=MSfmQu97mCus/k01BbIj1NbeeV3mMGSdpK92ccG79fBO+OiAOs1265NKMhcVuJ4xnW
         SxuFOeJ6DVFNAeOWodocrwUyJidrICsUOFOgO9OdjnjknnWBo43lvfK4Me0O6ysmyNYZ
         nI4BKW/U41opTtfKJMPkRXAvzczUlYDwhRbJblwIC4p5+c1fQzKtB1N65K07m1Yu7MNy
         /EtHf3iNyIBHl0IsFLfdFI5Hk72EOczwgg0KaMbbruUrHPWp0chWwy0kLu3GpbUP16EJ
         h/A+HXI4jyKfEhfDUb48bboyKpW9aMW2DWKaKOR8XYh0JkrNHiDwtb4qkojPenZ6Z/h9
         8PzA==
X-Gm-Message-State: AOJu0Ywa3nGb3vO4fp4zstwjrfxqV/ARizUGo5RFqecfc5v6pjddEvxi
        a5au0TIb8+Im9sH4kzhvJUh4DI21450=
X-Google-Smtp-Source: AGHT+IGKIA5LvKpxQc1QTmqZHoMrY0zis6UZ78jc5uBG94hFkrWxWg2Ln36OZayQB7oNw1dHkUGCzDA8XR4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7443:0:b0:d20:7752:e384 with SMTP id
 p64-20020a257443000000b00d207752e384mr42675ybc.3.1691776933032; Fri, 11 Aug
 2023 11:02:13 -0700 (PDT)
Date:   Fri, 11 Aug 2023 11:02:11 -0700
In-Reply-To: <CAG+wEg1wio-0grasdwdfNHr7fHZkZWt2TF2LZtw65WZx42jkyQ@mail.gmail.com>
Mime-Version: 1.0
References: <CAG+wEg3X1Tc_PW6E=pLHKFyAfJD0n2n25Fw2JYCuHrfDC_Ph0Q@mail.gmail.com>
 <ZMp3bR2YkK2QGIFH@google.com> <CAG+wEg2x-oGALCwKkHOxcrcdjP6ceU=K52UoQE2ht6ut1O46ug@mail.gmail.com>
 <ZMqX7TJavsx8WEY2@google.com> <CAG+wEg1d7xViMt3HDusmd=a6NArt_iMbxHwJHBcjyc=GntGK2g@mail.gmail.com>
 <ZNJ2V2vRXckMwPX2@google.com> <e21d306a-bed6-36e1-be99-7cdab6b36d11@ewheeler.net>
 <e1d2a8c-ff48-bc69-693-9fe75138632b@ewheeler.net> <ZNV5rrq1Ja7QgES5@google.com>
 <CAG+wEg1wio-0grasdwdfNHr7fHZkZWt2TF2LZtw65WZx42jkyQ@mail.gmail.com>
Message-ID: <ZNZ3owRcRjGejWFn@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Amaan Cheval <amaan.cheval@gmail.com>
Cc:     Eric Wheeler <kvm@lists.ewheeler.net>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 11, 2023, Amaan Cheval wrote:
> > Since it sounds like you can test with a custom kernel, try running with this
> > patch and then enable the kvm_page_fault tracepoint when a vCPU gets
> > stuck.  The below expands said tracepoint to capture information about
> > mmu_notifiers and memslots generation.  With luck, it will reveal a smoking
> > gun.
> 
> Thanks for the patch there. We tried migrating a locked up guest to a host with
> this modified kernel twice (logs below). The guest "fixed itself" post
> migration, so the results may not have captured the "problematic" kind of
> page-fault, but here they are.

The traces need to be captured from the host where a vCPU is stuck.

> Complete logs of kvm_page_fault tracepoint events, starting just before the
> migration (with 0 guests before the migration, so the first logs should be of
> the problematic guest) as it resolves the lockup:
> 
> 1. https://transfer.sh/QjB3MjeBqh/trace-kvm-kpf2.log
> 2. https://transfer.sh/wEFQm4hLHs/trace-kvm-pf.log
> 
> Truncated logs of `trace-cmd record -e kvm -e kvmmmu` in case context helps:
> 
> 1. https://transfer.sh/FoFsNoFQCP/trace-kvm2.log
> 2. https://transfer.sh/LBFJryOfu7/trace-kvm.log
> 
> Note that for migration #2 in both respectively above (trace-kvm-pf.log and
> trace-kvm.log), we didn't confirm that the guest was locked up before migration
> mistakenly. It most likely was but in case trace #2 doesn't present the same
> symptoms, that's why.
> 
> Off an uneducated glance, it seems like `in_prog = 0x1` at least once for every
> `seq` / kvm_page_fault that seems to be "looping" and staying unresolved -

This is completely expected.   The "in_prog" thing is just saying that a vCPU
took a fault while there was an mmu_notifier event in-progress.

> indicating a lock contention, perhaps, in trying to invalidate/read/write the
> same page range?

No, just a collision between the primary MMU invalidating something, e.g. to move
a page or do KSM stuff, and a vCPU accessing the page in question.

> We do know this issue _occurs_ as late as 6.1.38 at least (i.e. hosts running
> 6.1.38 have had guests lockup - we don't have hosts on more recent kernels, so
> this isn't proof that it's been fixed since then, nor is migration proof of
> that, IMO).

Note, if my hunch is correct, it's the act of migrating to a different *host* that
resolves the problem, not the fact that the migration is to a different kernel.
E.g. I would expect that migrating to the exact same kernel would still unstick
the vCPU.

What I suspect is happening is that the in-progress count gets left high, e.g.
because of a start() without a paired end(), and that causes KVM to refuse to
install mappings for the affected range of guest memory.  Or possibly that the
problematic host is generating an absolutely massive storm of invalidations and
unintentionally DoS's the guest.

Either way, migrating the VM to a new host and thus a new KVM instance essentially
resets all of that metadata and allows KVM to fault-in pages and establish mappings.

Actually, one thing you could try to unstick a VM would be to do an intra-host
migration, i.e. migrate it to a new KVM instance on the same host.  If that "fixes"
the guest, then the bug is likely an mmu_notifier counting bug and not an
invalidation storm.

But the easiest thing would be to catch a host in the act, i.e. capture traces
with my debug patch from a host with a stuck vCPU.
