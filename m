Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3694911A2
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 23:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243582AbiAQWMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 17:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbiAQWMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 17:12:21 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA783C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:20 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id e3so60209856lfc.9
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vWLVs+l7+STOOWtF13ZAtvkyq3IkQp2HTgX1z6kBB5E=;
        b=di5kK9L/kexo7RbJDKjstQjuat1cRFPimC4HpYOEHSFG2+4NfckedOSDrXj2Ha4cCy
         HZsf3Hmb2vNoRcWCp0UOLKmlqu/vEJQuF9ia5I1A3QIMc8UI1vl14KKc0KjL4cElc13q
         KAGwaf8CsikW+F//0ckS7mXdkx3s4vd/v7eAfCiS+ZlNxfiAOOYrHfM29axm9pZu11TB
         1obBIlIi/F7BX9lVmncjm+amwvBc77qvHV36q9F/32X23s7w3u+joxbCeJ5q8Tl/8G8i
         jijVbH+o6OxSC+YN/hbR0XpMQdluuwY9AhteWOgyz3W9NzuCYqzFjT54bQJ4Dm2rl5cX
         jy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vWLVs+l7+STOOWtF13ZAtvkyq3IkQp2HTgX1z6kBB5E=;
        b=jhjI71B8rh0wKPccLATC5va0ojgJPOqI9YJTL6fjrWMTbRLYyRURq72VASCvcjtfa9
         aA73vJKstkVCaplqy6tvUjbQBq1orkrKVHHWY5rOIyncLwwzbYWo8jacRiC94D3IUWxZ
         cxZba+0wAi538GqgZH5ZGrR4YG6P9OpKPMnACgRv0XVy16QudWFlb+nqFDQL93ZoP9zA
         F7o7Moe9IHroZ7iUDGph/fgI5q7z1e0TZ9kRd6NUqYkI2i/pwN40qB+hUptwzeKcWAWE
         +Ai2+atZ/VcJMY05XRfV59eaQzaoEs1FkdKxaSbNmdLSgE9S7BqqpVBE0z/yLh8GlQcm
         eKOw==
X-Gm-Message-State: AOAM530W+yM5NTAuoYjGgELeKdyX7mbvdLSJPAJpvgsxEaWD7wpKhtQt
        tcS2oGRQiKymjlBp/N1TmzaaFTHRtUz5Og==
X-Google-Smtp-Source: ABdhPJyf9OYzYOrbZQA2NBj7TKRJGo1BOyC51WraCMrJcKo0HWWwT1PUwNI2v80G2+4x1TOPWIdS0g==
X-Received: by 2002:a2e:9018:: with SMTP id h24mr16992262ljg.468.1642457538922;
        Mon, 17 Jan 2022 14:12:18 -0800 (PST)
Received: from localhost.localdomain (88-115-234-133.elisa-laajakaista.fi. [88.115.234.133])
        by smtp.gmail.com with ESMTPSA id c32sm1458094ljr.107.2022.01.17.14.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:12:18 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 0/5] kvmtool: Fix few found bugs
Date:   Tue, 18 Jan 2022 00:11:58 +0200
Message-Id: <cover.1642457047.git.martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In December, we hosted a CTF where one of the challenges was exploiting
any "0day" bug in kvmtool [1]. Eight teams managed to find a bug and
exploit it in less than 36 hours. Write-ups for exploits are available
by HXP [2] and kalmarunionen [3]. 

Now, I'm aware that kvmtool is mostly used for KVM testing and KVM bring-up
in simulation environments. But since it does get mentioned in some security-
related projects [4, 5] and has a sandboxing feature, maybe it makes sense
to fix these bugs.

Could you please check if these patches make sense?
I have not verified that these patches do not break something for these virtio
drivers.

Kind regards,
Martin

[1]: https://2021.ctf.link/internal/challenge/dd0e8826-c970-4fde-8eeb-41a9d8a86b67/
[2]: https://hxp.io/blog/87/hxp-CTF-2021-indie_vmm-writeup/
[3]: https://www.kalmarunionen.dk/writeups/2021/hxp-2021/lkvm/
[4]: https://blog.quarkslab.com/no-tears-no-fears.html
[5]: https://fly.io/blog/sandboxing-and-workload-isolation/

Martin Radev (5):
  virtio: Sanitize config accesses
  virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
  virtio/net: Warn if virtio_net is implicitly enabled
  Makefile: Mark stack as not executable
  mmio: Sanitize addr and len

 Makefile                |  7 +++++--
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  3 ++-
 mmio.c                  |  4 ++++
 virtio/9p.c             | 21 ++++++++++++++++----
 virtio/balloon.c        |  8 +++++++-
 virtio/blk.c            |  8 +++++++-
 virtio/console.c        |  8 +++++++-
 virtio/mmio.c           | 44 ++++++++++++++++++++++++++++++++++-------
 virtio/net.c            | 11 ++++++++++-
 virtio/pci.c            | 40 +++++++++++++++++++++++++++++++++----
 virtio/rng.c            |  8 +++++++-
 virtio/scsi.c           |  8 +++++++-
 virtio/vsock.c          |  8 +++++++-
 14 files changed, 154 insertions(+), 25 deletions(-)

-- 
2.25.1

