Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EADF1516A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfEFQb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:31:56 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:36608 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbfEFQby (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:31:54 -0400
Received: by mail-vk1-f202.google.com with SMTP id p137so839629vke.3
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 09:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E5WO9ODhUeb7gchIl3e11LSllsWmM1E2YpuEe+KMyVo=;
        b=ZAV3tC6ygeuQpYDYrKMnamvWU4Ola27jwmOvJT0NrB9zkA9/9VwZpqZILeD/kCkNoz
         2YieZRVMa/AXiEzwBIxCU1l+GEYmKclsxxyQTiWJfi3V4eZQV5Ty6cVbJ946qs6vtwua
         FnVZYy8h8LlcT9zEGoHGJFhxw76fNhlXkwiMMdgNAFJQ0fdrxIy60WNM3Dx5/MSJjbMm
         JoRnUusKGOL9DOHOG1d4lxStTE2KnFUHyp2053KQyza8HaWrD88UcCSEHERhBeycqSfG
         PaS1O1Y2zDlyyujLwl9tuNkVlIoFOsc0GRtgaeegMD911ZalfKNXqOUfZljQAA2/cuom
         1W3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E5WO9ODhUeb7gchIl3e11LSllsWmM1E2YpuEe+KMyVo=;
        b=pLdc2kf6uY225sYH8TWPWQl6uH7Blfixqh8NQKqFMxl995XoiFTmEMTFK7q0D9puJt
         w2WCbCfHvUsJM7V3sA136Fhjaerv9j3sdAYpXGw4ElVKveN4SiVWjQ39+Svjk8UDG9GO
         BYuqd6mXv3fahFhKwzwUDRwyfyvNEuxgmcu6qRv/tMT0Z1HIQSc5+2dq3nzWi09sNXb8
         uwEXqh0A7btZ9XJb6/qTMfLgqwmcE0bd3OhwYQj5j3dkHovSiUHgbeFyFb6k+UKGxW9z
         PAyOUOx2wiut1nwFaZOcjgiAZw7Y2Hym0Hu1gLlkJZ6SxLCBkBcMBHnjY78/PmjwPiD/
         yVVQ==
X-Gm-Message-State: APjAAAXX4NEoMgzbMLqCfThbr48MmRG6GDm6DcMD908UWsrRzdTCHh2o
        ArHkwkrmmAguFdT6Av+J5GMIMfU1ecsQEi8s
X-Google-Smtp-Source: APXvYqw1xOoCnPO8YfwpZ5nRgaPpPr24xspNBV17LLiBFtD2eWt0/j9p08QSESkEcGjJ9SGNKNyhv8KaV3q9K4HX
X-Received: by 2002:a67:efcc:: with SMTP id s12mr4512139vsp.120.1557160313543;
 Mon, 06 May 2019 09:31:53 -0700 (PDT)
Date:   Mon,  6 May 2019 18:31:01 +0200
In-Reply-To: <cover.1557160186.git.andreyknvl@google.com>
Message-Id: <cdf0b98edefa9227db4a3d1fb6e3c7bc5a6a6215.1557160186.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1557160186.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v15 15/17] tee, arm64: untag user pointers in tee_shm_register
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
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
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

tee_shm_register()->optee_shm_unregister()->check_mem_type() uses provided
user pointers for vma lookups (via __check_mem_type()), which can only by
done with untagged pointers.

Untag user pointers in this function.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/tee/tee_shm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 0b9ab1d0dd45..8e7b52ab6c63 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -263,6 +263,7 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 	shm->teedev = teedev;
 	shm->ctx = ctx;
 	shm->id = -1;
+	addr = untagged_addr(addr);
 	start = rounddown(addr, PAGE_SIZE);
 	shm->offset = addr - start;
 	shm->size = length;
-- 
2.21.0.1020.gf2820cf01a-goog

