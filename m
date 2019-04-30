Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A43CFA2C
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 15:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfD3N1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 09:27:30 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:47576 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbfD3NZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 09:25:42 -0400
Received: by mail-vk1-f202.google.com with SMTP id x77so1449127vke.14
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 06:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4c/fu3qC3Skvw+ZZk7UHJQzalE9hfnOxHloiMgOUfYw=;
        b=wBxzW9uz5sqQEs2k0kS4yhvkUsLQPUol5yYuscC/EhJQq88IJKN51oJN9Ma9N+F87j
         0yaXqLxOKrSBWEzg6TAlDuogkZNA4XMbprAL12kWJ8MdNH7JIvTO8ZRXCqw/W9rKaVTK
         0th2TjbWtiytISvyVjLE74X1hS0zo7K7eSu+m53APk0oWFg+5hHivN//aHp583NOkYkp
         q/Xzdqo7lpDQuozd8M9soPmozGOH2C019sBJyK9gvXzEw1QU7pl845OD9URqwv3Lf0aM
         RmLDFBkc4rSunB/Q4UnHBTaxv0r2wOX1jQXVnW4MBVL+0daNYML4EK5a4hKos8NfLzsy
         dlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4c/fu3qC3Skvw+ZZk7UHJQzalE9hfnOxHloiMgOUfYw=;
        b=DZvbRxU7TD6E4Hc9g/vsHjt2v/GOtEdjcMGh7fcVRw+w9+cn/qhn1zakhm2Qr1acVm
         LkKd7sx6h9609LT57kqLW7Za6TQMAQOSxEr3FsOkepD25nH8vlo4TaAdObd7OQ6YVJc5
         Pd1U6EwOqDClYuHpPAKwwTazbbr83huJwvWZnZqNSbuDasgNYgEJZbX0CSKMcGGUdSeX
         R6hLA816DjEvadJrnUMzXTS7LTlCBpIfekTmFRKc26pm24/v2wrJTGOxnCLkfe6ntOaw
         8DSkZpTHTO5f4RgWsvwXT4FvBURNfqbweB3E/vAQg7kO9RPKs2f0qYjv9QFiRSRGwC88
         HvEw==
X-Gm-Message-State: APjAAAW03FWI+jV2LpQcIhFA2XGictebKhrvJrSCwP/BWEKFOXIwKFiH
        6U/rgwq1UrmmXUI37ND9rfH/YW4AFOErDlTl
X-Google-Smtp-Source: APXvYqx4TL4lB6fuuHN3vQZgSBJDs10/R98gvbNQDm51wxIVMnZyNgUuaizbdtdyYw1MeWbTLc+s/luHbNJTgZgZ
X-Received: by 2002:a67:8155:: with SMTP id c82mr6290812vsd.200.1556630742131;
 Tue, 30 Apr 2019 06:25:42 -0700 (PDT)
Date:   Tue, 30 Apr 2019 15:25:04 +0200
In-Reply-To: <cover.1556630205.git.andreyknvl@google.com>
Message-Id: <8e20df035de677029b3f970744ba2d35e2df1db3.1556630205.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1556630205.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH v14 08/17] mm, arm64: untag user pointers in get_vaddr_frames
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

get_vaddr_frames uses provided user pointers for vma lookups, which can
only by done with untagged pointers. Instead of locating and changing
all callers of this function, perform untagging in it.

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
2.21.0.593.g511ec345e18-goog

