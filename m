Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E76F9E8
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 15:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfD3NZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 09:25:47 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:40288 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbfD3NZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 09:25:46 -0400
Received: by mail-qt1-f202.google.com with SMTP id g28so13049120qtk.7
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 06:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XhTfun6kQ0RRzRGxeYV1Lxl9M9fvGqRUvmzO5QW1/Iw=;
        b=wJdQ1UGK5yN+4uNr4h/B5QAZg4CL5PwyVx/Pw0wXlRL/1oGZsU8xxjXpZhWnko4SRI
         fd58gicIFCILzVPy4t7gpYBYkZYkBR3FmblDk49rQtqjc+3RWgZP2PESfhPKYuSabBw/
         B0hXw+/teu1vbGfMkq/9KC8ilccnVzEvxDboYdIBbHp/DJQFCI0D5tDe+o/VISE54DyV
         St7L+ZfiWURBvKb49SaxC44tIWiHtqDmkV/TM32oplri8v6dnEdHN+6rXyhwe32Swezt
         x0OHZZDCsWZFgoiC74TFCi6OtAop9i/h8/+cUKSH3r+foqub7XosNX+XNvDEf+4uDkZz
         /4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XhTfun6kQ0RRzRGxeYV1Lxl9M9fvGqRUvmzO5QW1/Iw=;
        b=EGTre8O7cPXcW07j7rWP1Hv/UTB50x2ZEZY3UVkY34fOcj4QNl00fPHFmQ21sOrZMm
         T11mz9YK2P0npfVPEmDS3wBoJIYyDtRTdJE9s0hc76P79f73RrNK3aoxlKoX2SLDC2iR
         MXbQ+e2FufnGyyosVXzLk4kmkLVek4joZ0Sv5TYB4d6H0D9i603AZ5QYlbGBYDypZyRx
         V85R5EOWTFEzsNWaZ92lRfQqt78Ch+W92uq466pKwrh/PcAGe1V/CpdMpBT7J0hiHqA7
         RCBfdb6zbRpQ/4ziGGme3bxL2U3waUayYPXj079HunfreZMecRkg2SyzrV1GxEwup5BI
         zcTQ==
X-Gm-Message-State: APjAAAXpq1BJTM7Twc44X69xXB68ixhh6wl6+eLukC2mQ782jkYKAL90
        6G5xHxsjiDzId9tj1tW1d/oHsoCWkMhdVxrF
X-Google-Smtp-Source: APXvYqznoxmsWRf0TRsMetoUzYzE4dAnT0nzUuom4UB8P1UAcmj3+/tm6hiTUWLYkHc/SM6nPM/1vvtkZ4BWAaOU
X-Received: by 2002:a37:b683:: with SMTP id g125mr147309qkf.249.1556630745179;
 Tue, 30 Apr 2019 06:25:45 -0700 (PDT)
Date:   Tue, 30 Apr 2019 15:25:05 +0200
In-Reply-To: <cover.1556630205.git.andreyknvl@google.com>
Message-Id: <f7a89f69f95e471f161e4000d0e13f57364bc90d.1556630205.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1556630205.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH v14 09/17] fs, arm64: untag user pointers in copy_mount_options
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

In copy_mount_options a user address is being subtracted from TASK_SIZE.
If the address is lower than TASK_SIZE, the size is calculated to not
allow the exact_copy_from_user() call to cross TASK_SIZE boundary.
However if the address is tagged, then the size will be calculated
incorrectly.

Untag the address before subtracting.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c9cab307fa77..c27e5713bf04 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2825,7 +2825,7 @@ void *copy_mount_options(const void __user * data)
 	 * the remainder of the page.
 	 */
 	/* copy_from_user cannot cross TASK_SIZE ! */
-	size = TASK_SIZE - (unsigned long)data;
+	size = TASK_SIZE - (unsigned long)untagged_addr(data);
 	if (size > PAGE_SIZE)
 		size = PAGE_SIZE;
 
-- 
2.21.0.593.g511ec345e18-goog

