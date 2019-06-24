Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860FD50E43
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfFXOdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 10:33:49 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:54891 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbfFXOds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 10:33:48 -0400
Received: by mail-vs1-f74.google.com with SMTP id 184so3921286vsm.21
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 07:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cqAi+OvlHabK4r0DKR/uDYr47zBS8kkFmriW/t8FK6c=;
        b=lXHRsLKGuntJdIfx4IktI470fGbyq/kS83cL/1CQ6KcaqQfI5cgbGIOLx+on2O/XRl
         TyhQq0vCGRVG2NDDFcvggYJ0wxa3AKn2CR+yK/03NNoH4bycNdBR8ox3sdPwTeSrQLuo
         rHeW6O5U9Mg0jIkwq44zjpbQCUdfc3U4ayQ8Dr3awwdf8ADrTM4zsPAD1J2Hva/3oEGx
         iuAfMdkeDB0VVqrLEmMomvjY9gvAQgEF5ueMNKjNbD3E+c53zhezKvbXOoKR1nLLue5p
         C6JfI9UG0Qq2Dtp4qvSg2UI+NSz05kgH40lBS5dNGwoMFiWCdzLiE4V8NQ/k/pPRpCug
         2y1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cqAi+OvlHabK4r0DKR/uDYr47zBS8kkFmriW/t8FK6c=;
        b=ZMr6/KDB+cXB2irMJ2JV7DrhTAk4AXgE2E16oalJYvJUNMqQIsHjHc3CMLKsQrb6LL
         xvVaOKXhVf3AxRHWviCRXKwIzmQu318Udbx0LRY2C4pRWifXYB8syc1eJTAA04m6bXdj
         FW8SaayMW7/upEujSejKtM8ULq1uEfdjKAldMR1rLoFuspyUyS9Uno6qn3ArsdA4ELMa
         NhbCC7XKeoQmy1FE4XPnsWWgM+tgGJ2c4dFNl9FXdwuoPfOYxW5+NODeXAIyRffrj+4e
         xylZ6haNBbVfDtHXas7smqnOgEXBp+71pUngmGA++VkGKBUD9mAGePJ/eo9nborAHg2C
         Dn4w==
X-Gm-Message-State: APjAAAUl+9Mxi1TqzbgQ8/vzjn41vTSTl1KxpTfKNCOjOI2EIQtQ26IB
        /ndzAD+rHGA0DBgZgGoej8ZsWQ0mzpxNGg2E
X-Google-Smtp-Source: APXvYqzY+u8RznlTrOWrBgn25HhvDfTMe7SZyf9e34JUgJZBNd08PatZvu4lGf3zfqdvX7DoXuI91wYnbBpoYfQ0
X-Received: by 2002:ab0:7848:: with SMTP id y8mr60797129uaq.58.1561386827462;
 Mon, 24 Jun 2019 07:33:47 -0700 (PDT)
Date:   Mon, 24 Jun 2019 16:32:58 +0200
In-Reply-To: <cover.1561386715.git.andreyknvl@google.com>
Message-Id: <280ca5496fe82873caac306ca76fb40d702979ff.1561386715.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1561386715.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v18 13/15] tee/shm: untag user pointers in tee_shm_register
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

tee_shm_register()->optee_shm_unregister()->check_mem_type() uses provided
user pointers for vma lookups (via __check_mem_type()), which can only by
done with untagged pointers.

Untag user pointers in this function.

Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/tee/tee_shm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 2da026fd12c9..09ddcd06c715 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -254,6 +254,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 	shm->teedev = teedev;
 	shm->ctx = ctx;
 	shm->id = -1;
+	addr = untagged_addr(addr);
 	start = rounddown(addr, PAGE_SIZE);
 	shm->offset = addr - start;
 	shm->size = length;
-- 
2.22.0.410.gd8fdbe21b5-goog

