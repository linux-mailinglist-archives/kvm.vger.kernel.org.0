Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2227A71E60
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 20:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391359AbfGWR7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 13:59:44 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:45390 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391358AbfGWR7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 13:59:39 -0400
Received: by mail-yw1-f74.google.com with SMTP id b63so32701289ywc.12
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2019 10:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JHpRt1iV1Yui2063ArtK5NZw3fPfTbQsXHZ/X8tSe2c=;
        b=a1WmmrmprQZ/rcrg4bnGXYSWuW8VRJo8q/rb7ZTLQKZa1K7I67ixfos045Wbs17Hsc
         4ubobzNkIuAipJMS7ZPZPbwqhOEcQBYGSdXPH8NmRc6nBI3x8EfWx1KUwQ8GdoHMrOVu
         pQBBRoSlOoWQvrJK6Ndgh0M+u5SrtS+Z7XLFtzHXYzmOZcoQreZcqxEy8gyvJGE0ittV
         1ErCh2wjdbyE4mfBH/bts1VkhHwv8KlRuO+94TszgBwo8vjAMA7AFwRnm9ELenbWUlad
         Ar6m6acLtYRugfggNK1CttVM0dqBedFHVAahPgUmqPuarVGgg9aYEhjvXatkNn9RUbXS
         DjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JHpRt1iV1Yui2063ArtK5NZw3fPfTbQsXHZ/X8tSe2c=;
        b=iOeGvzCL3hhowl8Edr+dUIDIfNhYJ2/5bDlhlMLNTkIXonaO3y3gPuR0vRSP8mhSL9
         RHjLohyshaF75HoYUcChdWP4aANm9xKR4vBonBX1k9Njz33HJSS9qQ2OfTIHNEkuhdom
         ZmXHiCeGh2/ic+fRsp6kTe4sVoYIcf0uPHVBJOGYVdjFS9z19s4DOJz3sq5gwIFiSjeT
         LLX0glQ3yW8jU5RXp5SA2ioC5LqKGy3KCyOMnnyYjgoY2Hln8vqbrXVS6JHxMm6ZtpoJ
         gOUqmq+hEMfmGYb1d9kl5/MeLjb5jf3UlTDri7ftEf3wYq6il/zcRApOAWVaaatGRMfE
         /Lgg==
X-Gm-Message-State: APjAAAXRwrN6LXpJ5qVhKcxN+00ydM2gWCMs8MAKNiToEXGopJKJTgLJ
        0xUB0DqetSnsh75rdSZCd3SEDxq6gr1W+KSm
X-Google-Smtp-Source: APXvYqzQ4z/ZiuFK+6sqRZERC5QgYRRFA4U1Dnbp9V3f1PKQeQRLZSu3TG/nr3g90hvkMvcrT8eNvmOVLDqS9X26
X-Received: by 2002:a0d:d616:: with SMTP id y22mr43437325ywd.365.1563904778592;
 Tue, 23 Jul 2019 10:59:38 -0700 (PDT)
Date:   Tue, 23 Jul 2019 19:58:47 +0200
In-Reply-To: <cover.1563904656.git.andreyknvl@google.com>
Message-Id: <c856babeb67195b35603b8d5ba386a2819cec5ff.1563904656.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1563904656.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH v19 10/15] drm/radeon: untag user pointers in radeon_gem_userptr_ioctl
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
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a part of a series that extends kernel ABI to allow to pass
tagged user pointers (with the top byte set to something else other than
0x00) as syscall arguments.

In radeon_gem_userptr_ioctl() an MMU notifier is set up with a (tagged)
userspace pointer. The untagged address should be used so that MMU
notifiers for the untagged address get correctly matched up with the right
BO. This funcation also calls radeon_ttm_tt_pin_userptr(), which uses
provided user pointers for vma lookups, which can only by done with
untagged pointers.

This patch untags user pointers in radeon_gem_userptr_ioctl().

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Suggested-by: Felix Kuehling <Felix.Kuehling@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/gpu/drm/radeon/radeon_gem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index d8bc5d2dfd61..89353098b627 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -296,6 +296,8 @@ int radeon_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	uint32_t handle;
 	int r;
 
+	args->addr = untagged_addr(args->addr);
+
 	if (offset_in_page(args->addr | args->size))
 		return -EINVAL;
 
-- 
2.22.0.709.g102302147b-goog

