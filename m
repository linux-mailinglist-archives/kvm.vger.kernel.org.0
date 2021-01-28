Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22702307E77
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhA1St2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbhA1SqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 13:46:03 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A33BC061793
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:45:23 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id p21so8961075lfu.11
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+pbMkZm7NigUA8MDQfToYpV4bo7Pj4kIa3i69Hik+9g=;
        b=aStsaTkGQtmd53qvSTdCKXUSGqnrcwud0LUZyFv8opnKBS56BlvSbDOBb5+zqkFYlh
         Rva74RyIXoYc7zrbyNXSmIUOIxlBnRQjqoUIvBwAGt7zGxcQw0P7+43ur89zjIrM8hiz
         nfMmny46X/50PJEIlHu0lVF680aP1JeayXwzJ8YlHRSzOCLoVanUTgexg5UjYwTvrFtJ
         OQ+8kezrc3PDXz3jA3wsq7Z+49aZUBRPkZfF6yVnHsirwUudJLylzZDXkwyUA5YewFEc
         Mx71xllwmq6+vFLI0bMGz/p3IRciTyl20+yMkEyp/tC+cIyTv97na60p+iFsi6gQtmDi
         gWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+pbMkZm7NigUA8MDQfToYpV4bo7Pj4kIa3i69Hik+9g=;
        b=RXDxKHGYIaujaOF/u7u4xYpE9z3V4LFG06+sFTXSaVLF3yk5nbaUQFXvjsPm63XSxa
         L5AqKxZZKlxhnchszX6qdG8u2aRReLYE6O1lac83XumfdDi5/l4K+udLo5HYI0e36Av9
         WLxDX6edRWWawaAPebQOQ/1fQePgdGrfUGUnm77ng2RgoJ2ba21O7ButB8zQwn8H7Acd
         xbM8KykKNzsK5oRkz48Jq3EpWRNTippgPKkhhWcyCp/k6qEeB42GYtXMtMnqZvjQVBNR
         EbuHegzsaWp1knwCf7khoVah3Z33BioppLx64AqWhht6Qk7buHHokufPsKLhPDV48bOq
         yjgw==
X-Gm-Message-State: AOAM532D5kUn5fIySON+NZzUfUveX7vONoiCtfx6j8RWASNwjSV+tuI0
        mojjk7eQBAPuWJmOhsPjPXPRISmk03ubIw==
X-Google-Smtp-Source: ABdhPJygFJo+zUkc16gywE7BeCr1FFcqBuLAgUixB5Hf/649/txu6fknLDev77aBPrVFdW8ThvV+Iw==
X-Received: by 2002:a19:d07:: with SMTP id 7mr194761lfn.215.1611859521277;
        Thu, 28 Jan 2021 10:45:21 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id k8sm1750508lfg.41.2021.01.28.10.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:45:20 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v2 4/4] KVM: enforce NR_IOBUS_DEVS limit if kmemcg is disabled
Date:   Thu, 28 Jan 2021 21:32:23 +0300
Message-Id: <c5426ed44a9ab9fe2a0d4a6a4dee30b3be30b0e3.1611850291.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1611850290.git.eafanasova@gmail.com>
References: <cover.1611850290.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ioregionfd relies on kmemcg in order to limit the amount of kernel memory
that userspace can consume. Enforce NR_IOBUS_DEVS hardcoded limit in case
kmemcg is disabled.

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
 virt/kvm/kvm_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 096504a6cc62..74bedb7272e6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4352,9 +4352,12 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	if (!bus)
 		return -ENOMEM;
 
-	/* exclude ioeventfd which is limited by maximum fd */
-	if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
-		return -ENOSPC;
+	/* enforce hard limit if kmemcg is disabled and
+	 * exclude ioeventfd which is limited by maximum fd
+	 */
+	if (!memcg_kmem_enabled())
+		if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
+			return -ENOSPC;
 
 	new_bus = kmalloc(struct_size(bus, range, bus->dev_count + 1),
 			  GFP_KERNEL_ACCOUNT);
-- 
2.25.1

