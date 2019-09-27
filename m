Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7301BC0974
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfI0QS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:18:58 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:50811 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfI0QS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:18:58 -0400
Received: by mail-qt1-f202.google.com with SMTP id d24so5354893qtn.17
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5ZuP6sW4dc0DGUSf3S28WoHPVkPfdDixP8+uQWXCCWg=;
        b=DJzZh8XTngCnOX722VLXiZpGVBQ+CixPkF3c9/7dJYq5WCrSS7SJBrDrW9qrnjlgPh
         79EROoulIkMBCFHpni/DcJSvW1txDB6NNZEjsZ2aDbOPBsCBqbpNosN/j5dYGV2OC5dc
         DYTiPNMc7yb70LTzXzB4/2BB3nAgZRIKkE7m0p5vAAGzzT1XgRjHfkAHq4IIy3gPa27x
         1z3su1JRBwN/dBQkMb++y9MhmxylaKtLkhY2vpEFS73bhq9gpO/lJadL6+VzKK1RjmZL
         QWDuqG4db7jwrFXPG1T2mj9KeM0OR38D6CIcbqixc2IWBfXviTBPET16AGVF1WNnT/6B
         v1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5ZuP6sW4dc0DGUSf3S28WoHPVkPfdDixP8+uQWXCCWg=;
        b=XpchbQr5a17rlMBU69tbL71nA0P7HokX79+9vHVJ03cI0/tarJwKPbgyQAn6LhDXhY
         Bh0l9gJRAc76suJi6lggSuKcqN/tp3aNh8VeNIhJ11J02ldCmfLrepCmweY1C2kj50V6
         Dv+OSArXDGMDcYBZd2UoNzYUeRtEj/kkHBankvqBgF44ZNX9rqG0FD7pF/9p58WPMAhL
         H18JjKkGEvOEOf3TPnJy8/GS8j9J7BrU/o38IpvN80OoHyZBfu9aa33/6v5d98IdQ1DK
         cTAYk6hjGhm/j/SdX7I79evRe3FO0/uzy+RDh3T7qgq+hGmNAORNtbQouS6ve/lEVDHR
         PTrw==
X-Gm-Message-State: APjAAAWkP0fNu6hTJApxd5bf5oU6CCZQQ6F4vZrri9lr44451BCO3Pmj
        qXY9wRGYg4BBk5VLithMblf2AoBKr4ubEcQwtGEDCusGekMnDlJ3LwnJqTl27ZWis3Jj11vysND
        Oylqa3F6Q35U55Eo2rwxFJ593LJsqoBt1sfnbNmuWxvL9scHmv5obXu/tEykS
X-Google-Smtp-Source: APXvYqyYcBDWAtVNPkG6ko9XIDhB6+oAP2NJ/q9ndUoK8ODyWHTX/wYJkzR7aE2qb7y3gz37yWHYRiNkOefW
X-Received: by 2002:ac8:329d:: with SMTP id z29mr11063636qta.112.1569601137543;
 Fri, 27 Sep 2019 09:18:57 -0700 (PDT)
Date:   Fri, 27 Sep 2019 09:18:36 -0700
In-Reply-To: <20190927161836.57978-1-bgardon@google.com>
Message-Id: <20190927161836.57978-9-bgardon@google.com>
Mime-Version: 1.0
References: <20190927161836.57978-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH 8/9] KVM: selftests: Support large VMs in demand paging test
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move memslot 0 past 4 GiB to support the large page tables required to
map several TiB of memory.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index eb1f7e4b83de3..a733bb3c91fd4 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -24,6 +24,12 @@
 #include "kvm_util.h"
 #include "processor.h"
 
+/*
+ * Put slot 0 past the first 4G of guest physical address to avoid collision
+ * with KVM-internal memslots.
+ */
+#define SLOT_0_GPA (4UL << 30)
+
 /* The memory slot index demand page */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -171,7 +177,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
 	pages += (2 * pages) / PTES_PER_PT;
 	pages += ((2 * vcpus * vcpu_wss) >> PAGE_SHIFT_4K) / PTES_PER_PT;
 
-	vm = vm_create(mode, pages, O_RDWR);
+	vm = _vm_create(mode, SLOT_0_GPA, pages, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
-- 
2.23.0.444.g18eeb5a265-goog

