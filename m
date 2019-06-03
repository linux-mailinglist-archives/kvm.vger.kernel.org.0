Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E354E335AC
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 18:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfFCQ5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 12:57:24 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:47346 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729633AbfFCQz5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 12:55:57 -0400
Received: by mail-qt1-f201.google.com with SMTP id c54so8087550qtc.14
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 09:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QTQ4ZZ+1ONHvx3iNcSe/c62gqBzIbuX20WtdiRnopfw=;
        b=Iulw2LDXuMXrguiNT2nc8pImmlAd9SEaHxzy+PIXZoC7Ry1861+IgSJT7msXK0lxjW
         Stlg9JACJI0q7DDqW7dFD1lXLlRa2BWigOxwo5Vw8cFe6qNirKkII0FhPNgtUk9+cp1T
         aHJGoLoDr4Q8979Fk7TFLPwhp9/TzWuYwglUurKj3rFU9GpRJ5xL6D7/jxXgMSu4llum
         hXs/FNVkTTazIDAfHhBMirRaAiVUM4CzdwvnR1yvQzgHmFdNai1A63k4wvi7etXyFGuo
         QDD/dhSJypo/bxB/7BkdNMWk1BD1fsQcPpD2mwu3O8zxH9SkplM6OKzkYqDvbWZfOgAq
         9GzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QTQ4ZZ+1ONHvx3iNcSe/c62gqBzIbuX20WtdiRnopfw=;
        b=EnlGyQ+SjvFcPxGTBEHx3251u6oSb87li4G/0Ufb9J950Yb3qQgpMa3YQzdnuErZJp
         VbQmGrf9Yl65kPbFVGWNW/XuMWKPWm5QA78zMCJjb9USyI+bye12lCvH1ncMU5vEk9m0
         KarcYqGAji+97hixhB/0DE8RsQGKiuZMTxp90ByWUNmXKpVmAA0diqmDiV/uQBHp/h78
         Aex/QxK3fBfV0i8s/cP/FkrpRJU/dlOEVmkQnNn2UbRr/lmdKmhQBXOtOWKNSLZ9ZXJD
         cAStwNLi6kp7i6nYrpfpz/nIiawZocGJ9GBtfsegs+oGS9W/yMDmSL8CGbFuZ63Z7g9A
         nEag==
X-Gm-Message-State: APjAAAUekNZuU6iadk4zqRoY0+qnj3lqbnfELKnqxPNjc4AuxMoGauLP
        szeRABhbD+o6vucr3LbfcYZH+g/l1diw+Oor
X-Google-Smtp-Source: APXvYqynCi8uC9mwY5hf72ttWfEiYBsQ+6wl0nvKi3Uj+AQb+Ufw5GSOsuV9qYkE0ai47XUYEZWA+IZ0Az+FoQAg
X-Received: by 2002:a37:8002:: with SMTP id b2mr23304828qkd.289.1559580956267;
 Mon, 03 Jun 2019 09:55:56 -0700 (PDT)
Date:   Mon,  3 Jun 2019 18:55:12 +0200
In-Reply-To: <cover.1559580831.git.andreyknvl@google.com>
Message-Id: <47d4e95b61013933ffe4f0be8832d03179d94b27.1559580831.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1559580831.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v16 10/16] drm/amdgpu, arm64: untag user pointers
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

In amdgpu_gem_userptr_ioctl() and amdgpu_amdkfd_gpuvm.c/init_user_pages()
an MMU notifier is set up with a (tagged) userspace pointer. The untagged
address should be used so that MMU notifiers for the untagged address get
correctly matched up with the right BO. This patch untag user pointers in
amdgpu_gem_userptr_ioctl() for the GEM case and in amdgpu_amdkfd_gpuvm_
alloc_memory_of_gpu() for the KFD case. This also makes sure that an
untagged pointer is passed to amdgpu_ttm_tt_get_user_pages(), which uses
it for vma lookups.

Suggested-by: Kuehling, Felix <Felix.Kuehling@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c          | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index a6e5184d436c..5d476e9bbc43 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1108,7 +1108,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 		alloc_flags = 0;
 		if (!offset || !*offset)
 			return -EINVAL;
-		user_addr = *offset;
+		user_addr = untagged_addr(*offset);
 	} else if (flags & ALLOC_MEM_FLAGS_DOORBELL) {
 		domain = AMDGPU_GEM_DOMAIN_GTT;
 		alloc_domain = AMDGPU_GEM_DOMAIN_CPU;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index d4fcf5475464..e91df1407618 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -287,6 +287,8 @@ int amdgpu_gem_userptr_ioctl(struct drm_device *dev, void *data,
 	uint32_t handle;
 	int r;
 
+	args->addr = untagged_addr(args->addr);
+
 	if (offset_in_page(args->addr | args->size))
 		return -EINVAL;
 
-- 
2.22.0.rc1.311.g5d7573a151-goog

