Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A542335AD
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfFCQ5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 12:57:23 -0400
Received: from mail-ot1-f74.google.com ([209.85.210.74]:38899 "EHLO
        mail-ot1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbfFCQ4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 12:56:00 -0400
Received: by mail-ot1-f74.google.com with SMTP id x23so9224176otp.5
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 09:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J9pRn7M3NANi3nsm6t0U9rkGUXnmKvJ1SqswIr7oBNs=;
        b=uyCC5R6PocJkucx1jg/Ao87LrvuuxuIBF6MJgtDNhRfSLGfd93TT+616KNBdU1kmQ0
         AgUDtRxuemeCNPWARnIzmKXOHJHBg+nlDVnGcRWa1zFo9sO/boLQmVSMKTOceUEyeuWg
         mQemhEJH0YpA4zNTW5udZ12GKI5bnl80kC7VZlC60TPzrs4d4KpnJ4TkMFczujBnqjPI
         s1PIMD6Bv9mJiTZ+Ezsulw1mODRNfzAxvwpKccvPVlqp//q9tEM3ODpqGbBulPCkTHr1
         l2f+hVLNHUHhV92giHpjab5jQ7AF27XvPV9Duk2JrwjNtkOIOBAX18N6EpfDx4AK8S9m
         dKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J9pRn7M3NANi3nsm6t0U9rkGUXnmKvJ1SqswIr7oBNs=;
        b=l/jFCyxsAu1vcy4PDqdwfx36hMAn6z7bXx22lXUznnCYOlKIHKrLp7cL/iZSGKefB1
         cRn44fvRBTwD0m0yYTEvfMZlerc2ku3Fk9PUKDJYKpz0vaCUDLw2hSMT5ysCoVcFRQO0
         2gYlY7o9qe2AZMDQKJSCMjhef+RL/qyQOtiI8W0jxyvJr+qOVB/YfmpTpiGkQPn0OwXo
         Eion5D4LbvE47vDwlAdlSOEKnnVvo5QWfpZzXbsTg8L/u5c8gtQRgq28NhYhCrU5TiMr
         OzEEpFEHZ8gT1bX8Pfi71D5JhMqw501mLAGI4J8xTyG0QUTWuZE6ONxUpXTAC3DiHoFO
         QPgQ==
X-Gm-Message-State: APjAAAVzBJjsjTgkROqqCvZk7vtPNXBSn//KwKzeyBOSrHDsg3IDmpEb
        WfD/59YZRsQk5rptSe0DOU1r6rNY/QpS0S/U
X-Google-Smtp-Source: APXvYqxkxhXEjx8ehUwO+4U+/PSwW95cfpd51BrO1CGROW1JbuARWLoPLbgzmMBGokFlEw6Kw7ByzaocLX6whXWc
X-Received: by 2002:aca:4341:: with SMTP id q62mr1665112oia.140.1559580959661;
 Mon, 03 Jun 2019 09:55:59 -0700 (PDT)
Date:   Mon,  3 Jun 2019 18:55:13 +0200
In-Reply-To: <cover.1559580831.git.andreyknvl@google.com>
Message-Id: <f293884fad5f741b9202a9db6006f4bfdaedc2bd.1559580831.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1559580831.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v16 11/16] drm/radeon, arm64: untag user pointers in radeon_gem_userptr_ioctl
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Christian Koenig <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Khalid Aziz <khalid.aziz@oracle.com>, enh <enh@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>, Kuehling@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a part of a series that extends arm64 kernel ABI to allow to
pass tagged user pointers (with the top byte set to something else other
than 0x00) as syscall arguments.

In radeon_gem_userptr_ioctl() an MMU notifier is set up with a (tagged)
userspace pointer. The untagged address should be used so that MMU
notifiers for the untagged address get correctly matched up with the right
BO. This funcation also calls radeon_ttm_tt_pin_userptr(), which uses
provided user pointers for vma lookups, which can only by done with
untagged pointers.

This patch untags user pointers in radeon_gem_userptr_ioctl().

Suggested-by: Kuehling, Felix <Felix.Kuehling@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index 44617dec8183..90eb78fb5eb2 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -291,6 +291,8 @@ int radeon_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	uint32_t handle;
 	int r;
 
+	args->addr = untagged_addr(args->addr);
+
 	if (offset_in_page(args->addr | args->size))
 		return -EINVAL;
 
-- 
2.22.0.rc1.311.g5d7573a151-goog

