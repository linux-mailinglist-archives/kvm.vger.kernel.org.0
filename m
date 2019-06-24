Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5049350E4C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfFXOds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:33:48 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:57014 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbfFXOdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:33:45 -0400
Received: by mail-vk1-f202.google.com with SMTP id a4so6416543vki.23
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 07:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v2NimiCS5k+CASkvLG6PtbLfdsWbdfRiVRoN94NNZxk=;
        b=R52F0Fd2shfIFR4q0bGdXx41jOC2qnPJSQkzVjeQeg54HgHR1/LLyouZcbT5pvU9ph
         IHRux4iRMn4iYjvIDENfWOq45LSEDCPbYqCOQOQrImK8uyieit/JhMM59l/PH48sLiy7
         OI6R5A3fMrdUIOLYn31VebhgCxKDAeunCFpurDmVgRp0CrVsEJYad0EcCQYYY+TsPx7Q
         wTuXqrZzi+DWvrwVhM13ZxkTrFcZ7WmDz7dFzgsP/AanzslvHIEdFMM6FuW5iowuC8jA
         iMOcgKpuXLtNG/lXst1VUVtGfDLMhPKtSnYwCtLyaY9LkXb2nkdEdjD68Dx6hEKz0c54
         IyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v2NimiCS5k+CASkvLG6PtbLfdsWbdfRiVRoN94NNZxk=;
        b=WqyYIaSzZE74XHn3CChoWvSDnnUs3odyYdxBQBBIkJFnWxrKI4Njm9itRs4AtrT7TM
         QqlIA0gp+3fNNqluPeY3MggVY989NbbWLM3Ofdx2uufU/bmZUp+z+Qh87WrGif1J8GIt
         laoN7V0csu+6qdDOYqDbNZZpxFpUdAPdRQw+FmkUrP2MoerpbUfl3lOXEdTh7e9FCLRa
         TIgRPHXRZsD4FkO3Pmab0uLBxNZi6oUBr8dMKnvJbxxLQ3mCkVU8AAne12pGppw2W+C7
         oRAjtBWycemRMzMbJZJ8CD+xgwIyHba7WySNgJNb8Gyh4uHq8NDokYyU97/0olXWjpuS
         cIQg==
X-Gm-Message-State: APjAAAU+YZZuBYhzknYbUCs6ZOZ2+I7O4TQdWbvFmwMQHTRbEoAzSD1z
        ltZnjbNF012wh7Q741qXrfCWd0be4WEUxGDz
X-Google-Smtp-Source: APXvYqzc7XeUiJjoodFNDUni2Tg0W5zegM0Bn90vNeBUMt6R6CtCKJP3h/iCRJwisxZh4IB/OpGm7X901/iCtFh1
X-Received: by 2002:a1f:ccc4:: with SMTP id c187mr4785454vkg.56.1561386824379;
 Mon, 24 Jun 2019 07:33:44 -0700 (PDT)
Date:   Mon, 24 Jun 2019 16:32:57 +0200
In-Reply-To: <cover.1561386715.git.andreyknvl@google.com>
Message-Id: <f28f0374a8ed0985d045ce1959855c1e35dc138a.1561386715.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1561386715.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v18 12/15] media/v4l2-core: untag user pointers in videobuf_dma_contig_user_get
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
        Andrey Konovalov <andreyknvl@google.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a part of a series that extends kernel ABI to allow to pass
tagged user pointers (with the top byte set to something else other than
0x00) as syscall arguments.

videobuf_dma_contig_user_get() uses provided user pointers for vma
lookups, which can only by done with untagged pointers.

Untag the pointers in this function.

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/media/v4l2-core/videobuf-dma-contig.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
index 0491122b03c4..ec554eff29b9 100644
--- a/drivers/media/v4l2-core/videobuf-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
@@ -157,6 +157,7 @@ static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
 static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 					struct videobuf_buffer *vb)
 {
+	unsigned long untagged_baddr = untagged_addr(vb->baddr);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long prev_pfn, this_pfn;
@@ -164,22 +165,22 @@ static int videobuf_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
 	unsigned int offset;
 	int ret;
 
-	offset = vb->baddr & ~PAGE_MASK;
+	offset = untagged_baddr & ~PAGE_MASK;
 	mem->size = PAGE_ALIGN(vb->size + offset);
 	ret = -EINVAL;
 
 	down_read(&mm->mmap_sem);
 
-	vma = find_vma(mm, vb->baddr);
+	vma = find_vma(mm, untagged_baddr);
 	if (!vma)
 		goto out_up;
 
-	if ((vb->baddr + mem->size) > vma->vm_end)
+	if ((untagged_baddr + mem->size) > vma->vm_end)
 		goto out_up;
 
 	pages_done = 0;
 	prev_pfn = 0; /* kill warning */
-	user_address = vb->baddr;
+	user_address = untagged_baddr;
 
 	while (pages_done < (mem->size >> PAGE_SHIFT)) {
 		ret = follow_pfn(vma, user_address, &this_pfn);
-- 
2.22.0.410.gd8fdbe21b5-goog

