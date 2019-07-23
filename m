Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4D671E3B
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 19:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391310AbfGWR72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 13:59:28 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:54277 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391293AbfGWR71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 13:59:27 -0400
Received: by mail-vk1-f202.google.com with SMTP id l7so43948vkm.21
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2019 10:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/huzVrn6iDinNK3gESNF6fMWuVj1J0a8E8YliY+JUMI=;
        b=Y7zAf+EqSsPzgFlPRtHiU2eaf3uvF3mBfxNqtK2dkyuo3VTBYXjjpviaGnsQe0yYUQ
         RZjdFooS3ZC7uUt58aVI/4cdpsAs60vswb3AsNKQ+PFZtVBvzHw5kY0TqkqeCmyj7riF
         mtQh5FnaNVG9iaAtW+G98/NdplTTfZ9IkSgAzb8usp7NHgKVNq41drkIZNhCHbFrZwbP
         oh8Z0GVIBTZb34XQapQJ/Cc8NMSc6thxgEsgQUYNQcR1lgRqwCY4KcosdJFpWo+DlmgQ
         eRBAMO05IGodFWFysR4D+7FGT50746wIbh4QySN2wsOGOenRi1KIej0OqRFaxZbG5kzF
         UnOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/huzVrn6iDinNK3gESNF6fMWuVj1J0a8E8YliY+JUMI=;
        b=mpBeEfQ/L0/uZj5DgSe6IyC5zh7r9sMfuNmyWj4kGinm33aou7CFBaxfZkqNO/yFQJ
         35Zp/hlqiAGHJnN0fr2YSlPlpcS0dmXKSxrD3e/9M/KOVuaYa4y+Fp6Q8y05tSwqh4ty
         XHopP0CQP2M2v+cwhyWPie6tNit7pN8U4bXtsk48/p/Z3cdJOQrjeG1jnbOxZUtoeyAH
         6npTwjA0HuMWfCLr0NOAoUyTjmMLEJIXN2bn/E97YqLXI72zuJ2pORopxkoxG37MpFYA
         aTEuy179RTTRHVe7jVLxfhavlAZNTLudc2g3y8DgEMxluarja6ZgVz8ZHABSm5E4QDVO
         2B5Q==
X-Gm-Message-State: APjAAAXegfPgalG6SSeWCaXhdyhIq32mNgPN60kDfpZ06GmeX8VBH+8T
        Yc3oryvtY0OarLUYd6GhHn+83p8mE1DZD9kc
X-Google-Smtp-Source: APXvYqza4RkKEiX9RSMJ4O0WeYRSe7jZPKwJC2E9aqA1oTke3kgtphbjO4en0GBzP/IdlZCHDhS+pYVnwN9x8xEl
X-Received: by 2002:ab0:1c2:: with SMTP id 60mr34283049ual.78.1563904765450;
 Tue, 23 Jul 2019 10:59:25 -0700 (PDT)
Date:   Tue, 23 Jul 2019 19:58:43 +0200
In-Reply-To: <cover.1563904656.git.andreyknvl@google.com>
Message-Id: <28f05e49c92b2a69c4703323d6c12208f3d881fe.1563904656.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1563904656.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
Subject: [PATCH v19 06/15] mm: untag user pointers in get_vaddr_frames
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

get_vaddr_frames uses provided user pointers for vma lookups, which can
only by done with untagged pointers. Instead of locating and changing
all callers of this function, perform untagging in it.

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 mm/frame_vector.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index c64dca6e27c2..c431ca81dad5 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -46,6 +46,8 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	if (WARN_ON_ONCE(nr_frames > vec->nr_allocated))
 		nr_frames = vec->nr_allocated;
 
+	start = untagged_addr(start);
+
 	down_read(&mm->mmap_sem);
 	locked = 1;
 	vma = find_vma_intersection(mm, start, start + 1);
-- 
2.22.0.709.g102302147b-goog

