Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDD86295BD
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 11:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbiKOKZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 05:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiKOKZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 05:25:47 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E079EB4AF
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 02:25:46 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id 46-20020a9d0631000000b00666823da25fso8300222otn.0
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 02:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2t/5Fwa+kcrVYytVyoGhwhA0LJjVEpVh4ghi2At6TpQ=;
        b=CEem9Gsy++2rAsQ/k1o5liFOA2uPpAASYqhA6AnuHXBHfXB4od6axyNPZtCv6GEK53
         5ykhhjViwhhCa62lVWXsEvwATbyPa/8qHDk7ndWMqu/hopblMmBOBNK94HetZnzbdqR2
         vuDFPvgX4MSsDRkycRv/VfG+ZJFx8q6ppWO/TYWasr3cFfxjWEgiVIzipQ7EaTg2lSru
         X0P5dR5HnaBMEV+K3U9/shsubjx3F28hkyHoSOgDZ1ogfigVwM4VIANbkdOxbIiwRMG0
         5IB0isoBbrvsZZsT4ToVtecXCu5+TSmm6j/5iVMQwQaamAcAKLa6sBSzeZZOq0Y/NxQy
         tRaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2t/5Fwa+kcrVYytVyoGhwhA0LJjVEpVh4ghi2At6TpQ=;
        b=M6pZJJigxCIsYgPh5pgQDor1lVSU7FCkDBrdMQ//chixyCL56fGBw316akFjclln/Q
         8ZUhK0dwT2U2r5KM8ruV70XSEwOvRD06m0zB+kH/PGbA+tw+FXCaqW7ceaw7aSWKC0g3
         Ahw0lapa99jc3roFjpVorNqFOjYrYSkRDLpsTu63/pUcXYTMOhQwldOX/ihPeQtkCD9D
         u97/P1Xpsg5OtWaTjU9vKRD4YdFL7U6EPwd95L/x7fxPaVpHyaEov0CF0cLC+/7v0fnh
         RsT0F262HJtQAEpv/4Ipedhnj9Ku3vulFfXvh8TPxWLKwe6U8iAhhr7E6HPri/ypPkJp
         3klg==
X-Gm-Message-State: ANoB5pm2H61syRZyuJ2YCX25kjlx9OOPFGWW+q6BKshtkR6QGDSOQ1qL
        jgBbfzyHC26wU3dlMy8IEWtGyZFUcJCLeIBMr56Ctg==
X-Google-Smtp-Source: AA0mqf5VuYJHPM+V6ecnOYF/+hnmZj0D7vizVbqN/Zav7eTQIgtl+v3njMF45IQfXgvQoS+y1N/AHOPDG2c8OcZCMKk=
X-Received: by 2002:a9d:32f:0:b0:66c:7982:2d45 with SMTP id
 44-20020a9d032f000000b0066c79822d45mr8358758otv.123.1668507946033; Tue, 15
 Nov 2022 02:25:46 -0800 (PST)
MIME-Version: 1.0
References: <200906190927.34831.borntraeger@de.ibm.com> <20221112161942.3197544-1-dvyukov@google.com>
 <20221114080345-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221114080345-mutt-send-email-mst@kernel.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 15 Nov 2022 11:25:35 +0100
Message-ID: <CACT4Y+bsjzCvYvVWoHM2GNC1CuR4xDoqjD5WSPkv=oWq+WAt4A@mail.gmail.com>
Subject: Re: [PATCH/RFC] virtio_test: A module for testing virtio via userspace
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     borntraeger@de.ibm.com, virtualization@lists.linux-foundation.org,
        syzkaller <syzkaller@googlegroups.com>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, 14 Nov 2022 at 14:06, Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Sat, Nov 12, 2022 at 05:19:42PM +0100, Dmitry Vyukov wrote:
> > I am looking for a test module that allows
> > to create a transient virtio device that can be used to activate a virtio
> > driver are communicate with it as if from the host.
> > Does such thing exist already?
> > Or how are virtio transports/drivers tested/fuzzed nowadays?
> >
> > Thanks
>
> Just coding it up in qemu is probably easiest.  This is how we test
> most things.

This works for some testing scenarios, but has important downsides:
 - fixed number of global virtio devices, so tests are not
hermetic/parallel and proper fuzzing is impossible
 - tests running inside of the kernel can't control the device
behavior, so lots of scenarios are untestable/unfuzzable
 - not suitable for most CI/fuzzing systems that run in clouds (nested
virt is very slow)
 - require special setup per test suite (not scalable for CI/fuzzing
systems that test all of kernel)

A better and flexible approach to stub devices is to implement them
inside of the kernel and allow creation of new transient instances
(e.g. /dev/net/tun). Such stubs allow proper fuzzing, allow
self-contained tests, allow the test to control stub behavior and are
compatible with all machines (cloud, physical hw).

Is my understanding of how such in-kernel stub device can be
implemented correct?
A stub driver could create struct virtio_device and call
register_virtio_device() directly skipping all of the bus/probing
code.
The virtio_device implementation will be parallel to virtio_mmio/pci
and implement its own virtio_config_ops and notify/kick callback.
This will allow us to test all of the virtio device drivers (console,
balloon, virtio sound/gpu, etc), but not the virtio_mmio/pci nor the
real probing code.

Is there a reasonable way to also test virtio_mmio/pci/probing from
within the kernel?
