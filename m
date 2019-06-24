Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5202650E5C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfFXOeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:34:37 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:54448 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbfFXOdg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:33:36 -0400
Received: by mail-vk1-f201.google.com with SMTP id w137so6424248vkd.21
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 07:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=28kCgmnVQJn+BZTUIaDgZIVH/xo2y2bOHrwsQUj+YbM=;
        b=ABmMcgz7AotklEeh4aKRTIHhpGJQax1zmT5GPHXjwooqibRCX0X83G+wpDe15X0SRe
         HXe9A2NvGDpBCmPVnJWVtQfrGpLCbLOl8a7QKidgVQZS583p/fioInBWA7fnqQUcPu7U
         DvrTBHAjvD9bvEv4FtgsxMoYukH2FWhUY0cxk16hnaOXVOPeSCjP81uMpB44OL/S9lPI
         aBpKDHVXZkog9XLBmaqt8fwsR9QWzkmPDHX6Y9oJS6A6dF2fyXmif514CVj9w8GAfMxh
         0cWaNfDCDK5rhCagjFyHYvWusLBZwBz8roAGGf8iO/F/Oiq2iyr+j9wwDpgGJziFwszL
         TQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=28kCgmnVQJn+BZTUIaDgZIVH/xo2y2bOHrwsQUj+YbM=;
        b=GbOxRl38gquEVfzQmHrFi1BXJOW+ev1r5C5ezIJgc2ZZLPlSdhaakLcQX5hqe+0rdF
         u/iFM2YFXaEEYAfFOPWLnGOz9p7gYGivitxZ4rAUPY75KkpeTB9U+Q+gy2CsnVCNJuk0
         nK+SdpVkj8CZPXBM1zfVNJOarhhWvH8MX/gwLqw4TUWDRl3PMnHytQmJ5uA+3rV5rGnn
         nujRlap62ZPIPqD/oZoK4eXVGSLFnVRoQbE2G7ZrVjCfhGmI5FkmLlZv3kbLOozoiBDz
         HBMna9f+hz4CNmRHh5n7zW3e4ZUM8SrC0iuVST/A08tCpmuaqc+pCub3EBamapkktWgw
         lHfA==
X-Gm-Message-State: APjAAAUzWHuWB7K6LXt1d6bXLziD8qRTPXVvRixB/2MGgT//eaoUlRxo
        r3iG6e/CjwCpRS03znkpBaLf69NejcPWE0Oz
X-Google-Smtp-Source: APXvYqxFRRLv3BUPtPxjHGRaBJrhiwF+VRuSavZL/k035Tv2azTfOuV+FpSvTW5kRizXDXNW3SNuKikp21TfCtFX
X-Received: by 2002:a1f:9748:: with SMTP id z69mr4561739vkd.25.1561386814933;
 Mon, 24 Jun 2019 07:33:34 -0700 (PDT)
Date:   Mon, 24 Jun 2019 16:32:54 +0200
In-Reply-To: <cover.1561386715.git.andreyknvl@google.com>
Message-Id: <1d036fc5bec4be059ee7f4f42bf7417dc44651dd.1561386715.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1561386715.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v18 09/15] drm/amdgpu: untag user pointers
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

In amdgpu_gem_userptr_ioctl() and amdgpu_amdkfd_gpuvm.c/init_user_pages()
an MMU notifier is set up with a (tagged) userspace pointer. The untagged
address should be used so that MMU notifiers for the untagged address get
correctly matched up with the right BO. This patch untag user pointers in
amdgpu_gem_userptr_ioctl() for the GEM case and in amdgpu_amdkfd_gpuvm_
alloc_memory_of_gpu() for the KFD case. This also makes sure that an
untagged pointer is passed to amdgpu_ttm_tt_get_user_pages(), which uses
it for vma lookups.

Suggested-by: Felix Kuehling <Felix.Kuehling@amd.com>
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
2.22.0.410.gd8fdbe21b5-goog

