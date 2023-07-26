Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05430763DB0
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 19:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjGZRby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 13:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjGZRbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 13:31:53 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397CC1BE2
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:31:52 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1bb982d2572so162475ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 10:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690392711; x=1690997511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TxQ1fFHD95LkzxtPBa5j940Wq0wInCYH6nMpzr1ER8I=;
        b=CaxonWw4g1fyEFYRFlFBzSUFQNGzPGlQ9Pfj94MwjPATdYLJHAm8q93bklVSaycR9u
         pZ4HSUsW9Nfm+wh9B3gRurOeFzNxWR4+OZ0LnsvYulT9IFLpZWw+qIsx6eJFHoU8Zq1/
         Ls+hO2efPaqWLWu7/Tv7bp+t7gRCV5Nty/2ZFPb2c3duQj/H3V0WD+8NpNarDP7L51kK
         6LfhkWNBY38ghW8NFk3POdcAZbkzYnJIRedU+U8DKG6nnmMjmmeUdpxvcGJGqdcrYqCm
         pO3rlFRZp6esJ4kxOnE1x8uRA2niL5kzgf7pzbxV1NeKqR0coIKhqqyHYxBWt05Tiisn
         lC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690392711; x=1690997511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TxQ1fFHD95LkzxtPBa5j940Wq0wInCYH6nMpzr1ER8I=;
        b=Wh3peFuH07BJqAkIKXVNJg98kkARirxnR5rCqrsCFolhAkz6LKagGHZx3eDglc9/jT
         1rmpLjPQUJGq1rxgviEDX8/awy3hM6SUj3T0X8WfCAJI1rN1VCHy3pthWedgJu/gSzKT
         sWoLVnjqjI3iC0sv+JqydaImblxLMIZfr3I9HwM/lwx2F6f8S9yzXiNuf7RjoXyRqkua
         chwXdiPJIOg1UPZEn/m1UZDBGxsD80Fs+ugBxY2ION/jk/mDfxJ+YixlYN57xfUBPt9G
         7LjMpbqdY2kO1ctahniDqj8VApNmYwq/+WATJv2GXI2eX9n/0oaEJCqjPmBdNMbKNBLK
         mfqg==
X-Gm-Message-State: ABy/qLZlD8RgqhskUZaU22M3Ofw1NdIpHB3XCLU62hJUI44Qrq1OhMUW
        2Oq8KdL7WdIwHlhf1CqPWt1sSgrfhWc=
X-Google-Smtp-Source: APBJJlEpUUpgD2zKc++qKq17h4d+Z5CPA+Pya742xj9/bzbd9YFWKsG176C0v493nsHzMT/rKN5w/vo8a1g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:284:b0:1b5:2496:8c0d with SMTP id
 j4-20020a170903028400b001b524968c0dmr10425plr.3.1690392711691; Wed, 26 Jul
 2023 10:31:51 -0700 (PDT)
Date:   Wed, 26 Jul 2023 10:31:50 -0700
In-Reply-To: <65262e67-7885-971a-896d-ad9c0a760907@polito.it>
Mime-Version: 1.0
References: <65262e67-7885-971a-896d-ad9c0a760907@polito.it>
Message-ID: <ZMFYhkSPE6Zbp8Ea@google.com>
Subject: Re: Pre-populate TDP table to avoid page faults at VM boot
From:   Sean Christopherson <seanjc@google.com>
To:     Federico Parola <federico.parola@polito.it>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 26, 2023, Federico Parola wrote:
> Hi everyone,
> is it possible to pre-populate the TDP table (EPT in my case) when
> configuring the VM environment, so that there won't be a page fault / VM
> exit every time the guest tries to access a RAM page for the first time?

No, not yet.

> At the moment I see a lot of page faults when the VM boots, is it possible
> to prevent them to reduce boot time?

You can't currently prevent the page faults, but you can _significantly_ reduce
them by backing guest memory with hugepages.  E.g. using 2MiB instead of 4KiB
pages reduces the number of faults by 512x, and 1GiB (HugeTLB only) instead of
2MiB by another 512x.

But the word yet...

KVM needs to add internal APIs to allow userspace to tell to KVM map a particular
GPA in order to support upcoming flavors of confidential VMs[1].  I could have
sworn that I requested that that API be exposed to userspace via a common ioctl(),
e.g. so that userspace can prefault all of guest memory if userspace is so inclined.
Ah, I only made that comment in passing[2].

I'll follow-up in the TDX series to "officially" float the idea of exposing the
helper as an ioctl().

[1] https://lkml.kernel.org/r/6a4c029af70d41b63bcee3d6a1f0c2377f6eb4bd.1690322424.git.isaku.yamahata%40intel.com
[2] https://lore.kernel.org/all/ZGuh1J6AOw5v2R1W@google.com
