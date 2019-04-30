Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359C7F9EB
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 15:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfD3NZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 09:25:53 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:43221 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728480AbfD3NZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 09:25:52 -0400
Received: by mail-ot1-f73.google.com with SMTP id q23so7375946otk.10
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 06:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+qKylFjMLP53K9qAejYeg4zQoAltlSq0MdIVnvcZCpk=;
        b=btEcp2nedxD/RSSqWCBp6Rk8cMJhftnRu9ZW20tW9H57Xw0aRxokGUkdPaQcz9rkFo
         41vHcxVyWnumGF2h8AA/tvaQ1eb1WCyLG8jJc1HuBhG3r5Wd1fM3SW30CuGnpg1TRhOv
         wnQvFrUnasvGEjcZv5QbKz23EvdFctZuk2lHQH4EeEAFL4Kx+vSjlXZtQRydk7j1idAx
         /UUAwj84w5Pi95UWsOVe8tS152xj2ZfcEWPp7jNQzN52h4BmJiS1Ku9e/jk70X0Z2EPY
         SDSyNof0IogZBTJr94e5UKMwPIftjzOfnH+SY8xUjb5s8afDb//mLKaZWdWGUI38Snzl
         JsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+qKylFjMLP53K9qAejYeg4zQoAltlSq0MdIVnvcZCpk=;
        b=nWSR5IfxLGqjQrQvmEl2Tm5bmKBBIEy1wdrNecT9XVfnkdWEnjaHfnQEUwQe0y4wwu
         fRLC8ums4Mq93Sh6slxBPEnQQbN7eQwlrt1EoW04wauUfTOW7o6t7aRWtzgRP6OE4lC2
         phOLDh+Rc8uqbgxZbUpe+AhDlOf3oHJowFw864LVleQ+t08/RIUsXdTA4x0aNVLQW8KJ
         OkEOdXdunNIrYfZrmlJXqufzyN+lzApsVbsh+pePRN9msKYqWohYoOwJUFDYnORS6Poz
         rgDbf6yHNBfrLsiDD89V1bLWmAXCsUc/X1LTFMTtSrkwDOGclAxsTcjohAuYDFs69hH0
         BzwA==
X-Gm-Message-State: APjAAAW/j8Npj43E3dj6HnGN/GBtcLHXjAjvPZaFclSisIXefb1c/ndI
        S5TVC98JcF+OOlDiOPYXNBpqS1SV7J3YYB7o
X-Google-Smtp-Source: APXvYqz7KleMfXSb2xWhqBUaqWJTSwZR2ghM1vwfjJsnESBwGEPHMng/yx10KRFE5q5G6LCNFaFlFnciq2Xk09j0
X-Received: by 2002:aca:4e83:: with SMTP id c125mr2833389oib.13.1556630751340;
 Tue, 30 Apr 2019 06:25:51 -0700 (PDT)
Date:   Tue, 30 Apr 2019 15:25:07 +0200
In-Reply-To: <cover.1556630205.git.andreyknvl@google.com>
Message-Id: <2e827b5c484be14044933049fec180cd6acb054b.1556630205.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1556630205.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH v14 11/17] drm/amdgpu, arm64: untag user pointers
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
        Yishai Hadas <yishaih@mellanox.com>, Kuehling@google.com,
        Felix <Felix.Kuehling@amd.com>, Deucher@google.com,
        Alexander <Alexander.Deucher@amd.com>, Koenig@google.com,
        Christian <Christian.Koenig@amd.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Chintan Pandya <cpandya@codeaurora.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a part of a series that extends arm64 kernel ABI to allow to
pass tagged user pointers (with the top byte set to something else other
than 0x00) as syscall arguments.

amdgpu_ttm_tt_get_user_pages() uses provided user pointers for vma
lookups, which can only by done with untagged pointers. This patch
untag user pointers when they are being set in
amdgpu_ttm_tt_set_userptr().

In amdgpu_gem_userptr_ioctl() and amdgpu_amdkfd_gpuvm.c/init_user_pages()
an MMU notifier is set up with a (tagged) userspace pointer. The untagged
address should be used so that MMU notifiers for the untagged address get
correctly matched up with the right BO. This patch untag user pointers in
amdgpu_gem_userptr_ioctl() for the GEM case and in
amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu() for the KFD case.

Suggested-by: Kuehling, Felix <Felix.Kuehling@amd.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c          | 2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c          | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 1921dec3df7a..20cac44ed449 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1121,7 +1121,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 		alloc_flags = 0;
 		if (!offset || !*offset)
 			return -EINVAL;
-		user_addr = *offset;
+		user_addr = untagged_addr(*offset);
 	} else if (flags & ALLOC_MEM_FLAGS_DOORBELL) {
 		domain = AMDGPU_GEM_DOMAIN_GTT;
 		alloc_domain = AMDGPU_GEM_DOMAIN_CPU;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index d21dd2f369da..985cb82b2aa6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -286,6 +286,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	uint32_t handle;
 	int r;
 
+	args->addr = untagged_addr(args->addr);
+
 	if (offset_in_page(args->addr | args->size))
 		return -EINVAL;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 73e71e61dc99..1d30e97ac2c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1248,7 +1248,7 @@ int amdgpu_ttm_tt_set_userptr(struct ttm_tt *ttm, uint64_t addr,
 	if (gtt == NULL)
 		return -EINVAL;
 
-	gtt->userptr = addr;
+	gtt->userptr = untagged_addr(addr);
 	gtt->userflags = flags;
 
 	if (gtt->usertask)
-- 
2.21.0.593.g511ec345e18-goog

