Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7ED42481
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438566AbfFLLoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:44:24 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:48124 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438552AbfFLLoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 07:44:21 -0400
Received: by mail-qk1-f202.google.com with SMTP id l185so13504462qkd.14
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 04:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dC40GuuRrFkQnjrApJXQmFxRiKKrkesKJBcqRTZL8Hw=;
        b=l++ZaaCoh/Va878Z1RknZZDdHUxfk157JnrRAUHz0jkL8fnv4FiiLmIp7Mk+/+dj5Z
         udFWoFOVhW7criNi8EMt8LBSnQaHvMhhUZ7BDvFNW7/H/rP4O9cpUiWmbFdx7WqJb0YL
         NYshnqAqHIeJqfZE1jL/Or9LTpuDIXYOfI1A2lvZRf82GFgwU4vOl8q53aA7Al9b8vAL
         /40xfjd6Br1Z56pIH7ZQuk9+yAf8Fr4GxAKL+l48BRvqpFH3utDdPvwMyQ57y2D4Zbcd
         AbEKWCBEQKFZuNPc6Vhcbi8LrlZtqOM5E/akcRiPUbRsuxCCoPgb7uahyTdqK4vvCrOk
         BhgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dC40GuuRrFkQnjrApJXQmFxRiKKrkesKJBcqRTZL8Hw=;
        b=r+CE3ofN60rcIF0BVq7XoViM7rmzvpmfmi7oXECTkDsLUN+SKVa1BuK5LUcqSWyHnW
         LraYe0joejVhDa70Slynaoz7t+SrMKtc7AuQRAIXvUBdJCz6JIckJvgZkIO38WdpyS3h
         38ljTCGXHb8M8khsxBD2tC8ArFRSTdMonywwmW1JbW9uXDChXjRgC5FcxRWaBmPMFIe2
         NKCuRIJ6qEg5z68Nc9PhL1132Qhtsv18c2sr5FDKCF7Q4o+rglqktiZaat3ZmEYciYEL
         BpCtVnWfAXMZ7YEoSZfe1BwfBUa7n4HCVlMSllRMoaBKePxRJN4aTB5Mg5PxLL4rJiL3
         +LCQ==
X-Gm-Message-State: APjAAAXiRvzmCd0o/OOuWTA9S+pV/PikoXJ+R0njHKpb8tuxynpk57ME
        j5CcTZt/dwmUpdz0FTKgn6DOAqOmv+WrRGSL
X-Google-Smtp-Source: APXvYqwZjeFH8QvU8JlQ9TXNVd73FVhiQa5kjrzjuBPKvVuXz62UTyjAI0ty22a00jJqk9SVHlzrZWd7SRmSPg0y
X-Received: by 2002:ac8:30c4:: with SMTP id w4mr67672128qta.314.1560339860763;
 Wed, 12 Jun 2019 04:44:20 -0700 (PDT)
Date:   Wed, 12 Jun 2019 13:43:31 +0200
In-Reply-To: <cover.1560339705.git.andreyknvl@google.com>
Message-Id: <e86d8cd6bd0ade9cce6304594bcaf0c8e7f788b0.1560339705.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1560339705.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH v17 14/15] vfio/type1, arm64: untag user pointers in vaddr_get_pfn
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

This patch is a part of a series that extends arm64 kernel ABI to allow to
pass tagged user pointers (with the top byte set to something else other
than 0x00) as syscall arguments.

vaddr_get_pfn() uses provided user pointers for vma lookups, which can
only by done with untagged pointers.

Untag user pointers in this function.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3ddc375e7063..528e39a1c2dd 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -384,6 +384,8 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 
 	down_read(&mm->mmap_sem);
 
+	vaddr = untagged_addr(vaddr);
+
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

