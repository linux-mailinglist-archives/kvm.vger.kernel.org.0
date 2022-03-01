Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660C64C9037
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 17:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiCAQWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 11:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiCAQW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 11:22:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3383E2AE3A
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 08:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646151706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ac9WfGbistjFm7LiKvOxeSDYCD8Gg7LmnqbwLdMfizE=;
        b=YciBP/kMmqJs//YjcgPVvWP1V3yfCDXlvxxJoY/jDI74Zu03GwE61qJiPnxWufrfygRIUG
        sCMC/iW7t0Qw110FZ1X3QTTyG/k6U5I6G92s3s/OrkXkJEiksXJR6HZnS8dptYm/h5N2b6
        jYDp0WQmHRhisIc1XFIBEhm9gn/DyeI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-Y_qf2CuOPyKWgyg5IR0rdw-1; Tue, 01 Mar 2022 11:21:45 -0500
X-MC-Unique: Y_qf2CuOPyKWgyg5IR0rdw-1
Received: by mail-wm1-f71.google.com with SMTP id i20-20020a05600c051400b00380d5eb51a7so1439882wmc.3
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 08:21:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ac9WfGbistjFm7LiKvOxeSDYCD8Gg7LmnqbwLdMfizE=;
        b=YDqIpSia/KT8xnyKNg3+nscNEjT2pGCZ2jav5iUv8ZxNnlHQ0OkEcHqkOtkR1VUe2e
         Lap4ceEhGqlEjtxkvajVhd0zbXcrwB7xBtgil+XnUb0qssMQNhxEZ/8JOmhVlefKpX7I
         V++4RRgj2bq4utU2XiDDyOUC2O49To6aH4seglGInNDNsKfhLkC3rstEG6y1xAYJF2pJ
         I18f4Agdb+MpXBWH0PIttqg2oZedZITSHYhYFtBKZnoS5sHVhuHdnLA6CP6QwgNxgrlQ
         zSQqGuk/GNvUWJzG788bXWX4f3N6EmXkptCZ18KXgY4VG5GNESM5tzpc5MlAcxSP4GO7
         /8/A==
X-Gm-Message-State: AOAM531KPV6Qx7Mdm9sfaIpqR55JQr8Lyfr2D9FAg8I42nyOGzR8X6mh
        uIrOCwl5urAMHVhAvfB5QhFJYN2m80jBNpoXLE55SymaHaOvji09GRDfFov/q9EbsGUbjXb7Cmp
        1+TKFdSoH+6Q2
X-Received: by 2002:a05:6000:cd:b0:1ed:bd9f:69d2 with SMTP id q13-20020a05600000cd00b001edbd9f69d2mr20113281wrx.288.1646151703916;
        Tue, 01 Mar 2022 08:21:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycgS5isqXU9GIuQLrDF3y/TWM3GmZs396UxSScNJGQw1IAMBBON7t0NccxM4wyd8pXTsUTlw==
X-Received: by 2002:a05:6000:cd:b0:1ed:bd9f:69d2 with SMTP id q13-20020a05600000cd00b001edbd9f69d2mr20113254wrx.288.1646151703601;
        Tue, 01 Mar 2022 08:21:43 -0800 (PST)
Received: from redhat.com ([2.53.2.184])
        by smtp.gmail.com with ESMTPSA id m34-20020a05600c3b2200b00380e3225af9sm3294866wms.0.2022.03.01.08.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:21:42 -0800 (PST)
Date:   Tue, 1 Mar 2022 11:21:38 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-hyperv@vger.kernel.org,
        linux-crypto@vger.kernel.org, graf@amazon.com,
        mikelley@microsoft.com, gregkh@linuxfoundation.org,
        adrian@parity.io, lersek@redhat.com, berrange@redhat.com,
        linux@dominikbrodowski.net, jannh@google.com, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz, linux-pm@vger.kernel.org,
        colmmacc@amazon.com, tytso@mit.edu, arnd@arndb.de
Subject: Re: propagating vmgenid outward and upward
Message-ID: <20220301111459-mutt-send-email-mst@kernel.org>
References: <Yh4+9+UpanJWAIyZ@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh4+9+UpanJWAIyZ@zx2c4.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022 at 04:42:47PM +0100, Jason A. Donenfeld wrote:
> Hey folks,
> 
> Having finally wrapped up development of the initial vmgenid driver, I
> thought I'd pull together some thoughts on vmgenid, notification, and
> propagating, from disjointed conversations I've had with a few of you
> over the last several weeks.
> 
> The basic problem is: VMs can be cloned, forked, rewound, or
> snapshotted, and when this happens, a) the RNG needs to reseed itself,
> and b) cryptographic algorithms that are not reuse resistant need to
> reinitialize in one way or another. For 5.18, we're handling (a) via the
> new vmgenid driver, which implements a spec from Microsoft, whereby the
> driver receives ACPI notifications when a 16 byte unique value changes.
> 
> The vmgenid driver basically works, though it is racy, because that ACPI
> notification can arrive after the system is already running again. This
> race is even worse on Windows, where they kick the notification into a
> worker thread, which then publishes it upward elsewhere to another async
> mechanism, and eventually it hits the RNG and various userspace apps.
> On Linux it's not that bad -- we reseed immediately upon receiving the
> notification -- but it still inherits this same "push"-model deficiency,
> which a "pull"-model would not have.
> 
> If we had a "pull" model, rather than just expose a 16-byte unique
> identifier, the vmgenid virtual hardware would _also_ expose a
> word-sized generation counter, which would be incremented every time the
> unique ID changed. Then, every time we would touch the RNG, we'd simply
> do an inexpensive check of this memremap()'d integer, and reinitialize
> with the unique ID if the integer changed. In this way, the race would
> be entirely eliminated. We would then be able to propagate this outwards
> to other drivers, by just exporting an extern symbol, in the manner of
> `jiffies`, and propagate it upwards to userspace, by putting it in the
> vDSO, in the manner of gettimeofday. And like that, there'd be no
> terrible async thing and things would work pretty easily.

I am not sure what the difference is though. So we have a 16 byte unique
value and you would prefer a dword counter. How is the former not a
superset of the later?  I'm not sure how safe it is to expose it to
userspace specifically, but rest of text talks about exposing it to a
kernel driver so maybe not an issue? So what makes interrupt driven
required, and why not just remap and read existing vmgenid in the pull
manner?  What did I miss?


> But that's not what we have, because Microsoft didn't collaborate with
> anybody on this, and now it's implemented in several hypervisors. Given
> that I'm already spending considerable time working on the RNG, entirely
> without funding, somehow I'm not super motivated to lead a
> cross-industry political effort to change Microsoft's vmgenid spec.
> Maybe somebody else has an appetite for this, but either way, those
> changes would be several years off at best.
> 
> So given we have a "push"-model mechanism, there are two problems to
> tackle, perhaps in the same way, perhaps in a different way:
> 
> A) Outwards propagation toward other kernel drivers: in this case, I
>    have in mind WireGuard, naturally, which very much needs to clear its
>    existing sessions when VMs are forked.
> 
> B) Upwards propagation to userspace: in this case, we handle the
>    concerns of the Amazon engineers on this thread who broached this
>    topic a few years ago, in which s2n, their TLS library, wants to
>    reinitialize its userspace RNG (a silly thing, but I digress) and
>    probably clear session keys too, for the same good reason as
>    WireGuard.
> 
> For (A), at least wearing my WireGuard-maintainer hat, there is an easy
> way and there is a "race-free" way. I use scare quotes there because
> we're still in a "push"-model, which means it's still racy no matter
> what.
> 
> The faux "race-free" way involves having `extern u32 rng_vm_generation;`
> or similar in random.h, and then everything that generates a session key
> would snapshot this value, and every time a session key is used, a
> comparison would be made. This works, but given that we're going to be
> racy no matter what, I think I'd prefer avoiding the extra code in the
> hot path and extra per-session storage. It seems like that'd involve a
> lot of fiddly engineering for no real world benefit.
> 
> The easy way, and the way that I think I prefer, would be to just have a
> sync notifier_block for this, just like we have with
> register_pm_notifier(). From my perspective, it'd be simplest to just
> piggy back on the already existing PM notifier with an extra event,
> PM_POST_VMFORK, which would join the existing set of 7, following
> PM_POST_RESTORE. I think that'd be coherent. However, if the PM people
> don't want to play ball, we could always come up with our own
> notifier_block. But I don't see the need. Plus, WireGuard *already*
> uses the PM notifier for clearing keys, so code-wise for my use case,
> that'd amount adding another case for PM_POST_VMFORK, in addition to the
> currently existing PM_HIBERNATION_PREPARE and PM_SUSPEND_PREPARE cases,
> which all would be treated the same way. Ezpz. So if that sounds like an
> interesting thing to the PM people, I think I'd like to propose a patch
> for that, possibly even for 5.18, given that it'd be very straight-
> forward.
> 
> For (B), it's a little bit trickier. But I think our options follow the
> same rubric. We can expose a generation counter in the vDSO, with
> semantics akin to the extern integer I described above. Or we could
> expose that counter in a file that userspace could poll() on and receive
> notifications that way. Or perhaps a third way. I'm all ears here.
> Alex's team from Amazon last year proposed something similar to the vDSO
> idea, except using mmap on a sysfs file, though from what I can tell,
> that wound up being kind of complicated. Due to the fact that we're
> _already_ racy, I think I'm most inclined at this point toward the
> poll() approach for the same reasons as I prefer a notifier_block. But
> on userspace I could be convinced otherwise, and I'd be interested in
> totally different ideas here too.
> 
> Another thing I should note is that, while I'm not currently leaning
> toward it, the vDSO approach also ties into interesting discussions
> about userspace RNGs (generally a silly idea), and their need for things
> like fork detection and also learning when the kernel RNG was last
> reseeded. So cracking open the vDSO book might invite all sorts of other
> interesting questions and discussions, which may be productive or may be
> a humongous distraction. (Also, again, I'm not super enthusiastic about
> userspace RNGs.)
> 
> Also, there is an interesting question to decide with regards to
> userspace, which is whether the vmgenid driver should expose its unique
> ID to userspace, as Alex requested on an earlier thread. I am actually
> sort of opposed to this. That unique ID may or may not be secret and
> entropic; if it isn't, the crypto is designed to not be impacted
> negatively, but if it is, we should keep it secret. So, rather, I think
> the correct flow is that userspace simply calls getrandom() upon
> learning that the VM forked, which is guaranteed to have been
> reinitialized already by add_vmfork_randomness(), and that will
> guarantee a value that is unique to the VM, without having to actually
> expose that value.
> 
> So, anyway, this is more or less where my thinking on this matter is.
> Would be happy to hear some fresh ideas here too.
> 
> Regards,
> Jason

