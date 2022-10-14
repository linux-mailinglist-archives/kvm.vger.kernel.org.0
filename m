Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302005FEC5E
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 12:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJNKLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 06:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiJNKL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 06:11:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE91514EC7D
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665742274;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=8FGCSnmWS9YSeKOVf31i5PwnQR2o9ASrKbCvKXlkXbo=;
        b=ak5lus/UbEJ1lkIvtwNNrin9+LgNVEhRIHs/6/9voF+ObPSmMZLlE+aGtHsBmSTZln/oGb
        3NPrak2+cKD39rehe42bx/B+JzPunla7R49Mgw3ktmeCKQc6UWPlZXGWV4Uhz000iyK6Ll
        BKB9lmXNKPNxqu2igxfnUuB4dA+GuI4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-139-BWy53kmoPk2KSpYPNvuCTg-1; Fri, 14 Oct 2022 06:11:13 -0400
X-MC-Unique: BWy53kmoPk2KSpYPNvuCTg-1
Received: by mail-wm1-f71.google.com with SMTP id 133-20020a1c028b000000b003c5e6b44ebaso4433601wmc.9
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 03:11:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FGCSnmWS9YSeKOVf31i5PwnQR2o9ASrKbCvKXlkXbo=;
        b=j+ErbAOedNPJmmcYirpbcHm/NCSkYpXmeIMH1IxmbGCscH5xwf5M75A1sWW2fVbAwz
         5F6T5YD4AYp7Y6tZDODhaOerGGunrikvwlIAfvikhvB/Muw2wXwhfSBw4CrLu54anrV3
         5oTvyml3H6kd5zU82NJ1HPSglqR81J0my+xge2wQ7FX/ZEInTPzCv85K5jU8Mzrr5e6P
         jeDniTGJoLC2qbZg3lPNc/33DJoyWgaXVXW4B1JmjMndGfHu9zRBejJVnrBndK+wp4nl
         qy/i3gifcyYecNJ4Zd+eVslINbciZ/J+N/MdVycy+r1c50lfNVGV5vV5GvueWxX2uKrp
         LYQw==
X-Gm-Message-State: ACrzQf0t1oUHOwTf7r4mQE2itZiqkPlOKT7IK9vw0udwvX+Fh+AvuVko
        DS5ib5dBIsQ+5h/z77b3oCOLIANFSpJpNpAgvx2e3+/CzL8OATX3CPsw6nN75miKugN1ugBsfyg
        c3KdnNIqMloOlQ20p6BzKR1MHzLe9W8Q297h6fIw6UOHoeLflx4q+ILtf14W8PY+u
X-Received: by 2002:a05:600c:3543:b0:3b4:ba45:9945 with SMTP id i3-20020a05600c354300b003b4ba459945mr9577719wmq.58.1665742271765;
        Fri, 14 Oct 2022 03:11:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6A2Bin5AZhSEMXDLhNhYgDun/z4RfB6byLpdAGZq7yTCkkZL3M2MiC2ssF7e8YTATSpoq2dQ==
X-Received: by 2002:a05:600c:3543:b0:3b4:ba45:9945 with SMTP id i3-20020a05600c354300b003b4ba459945mr9577700wmq.58.1665742271495;
        Fri, 14 Oct 2022 03:11:11 -0700 (PDT)
Received: from localhost (static-28-206-230-77.ipcom.comunitel.net. [77.230.206.28])
        by smtp.gmail.com with ESMTPSA id m187-20020a1ca3c4000000b003b476cabf1csm1734772wme.26.2022.10.14.03.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 03:11:11 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM Call for 2022-10-18
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 14 Oct 2022 12:11:10 +0200
Message-ID: <871qran29t.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

For next week, we have a topic:

- VFIO and migration

We are going to discuss what to do with vfio devices that support
migration.  See my RFC on the list, so far we are discussing:

- we need a way to know the size of the vfio device state
  (In the cases we are discussing, they require that the guest is
  stopped, so I am redoing how we calculate pending state).

- We need an estimate/exact sizes.
  Estimate can be the one calculated last time.  This is supposed to be
  fast, and needs to work with the guest running.
  Exact size is just that, we have stopped the guest, and we want to
  know how big is the state for this device, to know if we can complete
  migration ore we will continue in iterative stage.

- We need to send the state asynchronously.
  VFIO devices are very fast at doing whatever they are designed to do.
  But copying its state to memory is not one of the things that they do
  fast.  So I am working in an asynchronous way to copy that state in
  parallel.  The particular setup that caused this problem was using 4
  network vfio cards in the guest.  Current code will:

  for i in network cards:
     copy the state from card i into memory
     send the state from memory from card i to destination

  what we want is something like:

  for i in network cards:
     start asyrchronous copy the state from card i into memory

  for i in network cards:
     wait for copy the state from card i into memory to finish
     send the state from memory from card i to destination

So the cards can tranfer its state to memory in parallel.


At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

   https://calendar.google.com/calendar/u/0?cid=ZWdlZDdja2kwNWxtdTF0bmd2a2wzdGhpZHNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

