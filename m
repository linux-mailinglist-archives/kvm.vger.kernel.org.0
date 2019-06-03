Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4340335A7
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 18:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfFCQ5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 12:57:13 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:43044 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbfFCQ4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 12:56:13 -0400
Received: by mail-qk1-f202.google.com with SMTP id v4so985068qkj.10
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2019 09:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i5cRHHCicMsppSSBbFWeJPgqhQ8FMrYjuCKfr4hxLgs=;
        b=sT3L0ZTGkrRVM9BsAKw3Is1YEd5yvotnvZZfNxBe7skB1Imy3yNX3RzPcWZ3L4hBJj
         Ir4PWq35E8DDBUgoDYzLkuASMa2VdGiH7s1U8yAi9EYUyTsOvvYIL5k/dOIxx+s0hJjp
         ivARA7eJCU7WpCZIyl+ggUCauMPneV4kiO9mITdC3bmCRoqBY9+znI9pjppaD8UIqueE
         q8SkWjwj6UsZy3S43cNZjsMLUMGx3YCtYO4jYJeCvlUuA0j/KAAmJ8e05Wl5fyvRzmAY
         H4Wc9GjlHrhbudDD44rVO5eJTf6U73Fu89LC7maXdjap9rfTt5/4PxbL/ZJXa8oMOVpN
         Mbbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i5cRHHCicMsppSSBbFWeJPgqhQ8FMrYjuCKfr4hxLgs=;
        b=MfWcBZ9q+h8kax4axf5zNSrMkWkbkjI62QIBJcu0JTBDawex5lpoGZFtlgeFEsi0c+
         uIERcRzCLT7NezadyH1gSODJOyyEwUkW5VpjnZRk1fEdGArJkzXpovD7chwxe35AT3b/
         jx7UUtoKX8XqkYBKUquuNqeiR1Lw3xXwvLjyuXbEjOiGEA4w5JORDoKM4oOrsriX2tmg
         F2UHwWIylVqUjAatMfutCfbDMyCZyyj8HmB2mL16ZwqXhucGWIH97HQr6QkjI/aoWBzG
         yyoCZ00SiXBKa8sEEjtMrf8ND/Fi0ZyGIV6f6VbnmxjbORBubDC8aHazaDKFxn+eerYN
         oPJg==
X-Gm-Message-State: APjAAAVdw/6Tzxol3kv5X/NVoK9p1IMnu1CASnR6dNaOcEzlIUsrJDIy
        6brtZv9Z6sYGqcvai7WNKK8YOizjMAKtrljO
X-Google-Smtp-Source: APXvYqxlndJ8+4ezg3WqxZgwPuj7croHV+8pOSI6UJilulRqZobP0HRc/RuNHVT76apRYIt7gunvINxeeY21hcHq
X-Received: by 2002:ac8:2817:: with SMTP id 23mr23534732qtq.174.1559580972876;
 Mon, 03 Jun 2019 09:56:12 -0700 (PDT)
Date:   Mon,  3 Jun 2019 18:55:17 +0200
In-Reply-To: <cover.1559580831.git.andreyknvl@google.com>
Message-Id: <c529e1eeea7700beff197c4456da6a882ce2efb7.1559580831.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1559580831.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v16 15/16] vfio/type1, arm64: untag user pointers in vaddr_get_pfn
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
2.22.0.rc1.311.g5d7573a151-goog

