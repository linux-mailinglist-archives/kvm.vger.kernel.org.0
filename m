Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEFC35D2F8
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343685AbhDLWVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343666AbhDLWVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:21:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2C0C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:20:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v6so14111079ybk.9
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CWYLK1Nq956lXK6/CZyqJrTCFyW3FBgUwDisoyLnoZE=;
        b=JAJOXTeFhWLgvXICg+LDvObGR5FL/FNB/jnOfdao44BEDtwrf2fTtD5Z/B54TyJuvX
         f1m6IQUxQ2aKUsN94lnQWCqu0sUeG96gXdlcegV5bn/XXC3dw3nDZfING2MtRD75cZ3w
         qYyHV/nZZ03WqXdRKUz6oVzcUTiXUdZck/6yTI+lOjFyA00EjBqJqZSY4p5I8IxXTRnU
         45PFjbzpcYriIeK1vtUmjM0IR6Rl2fGlxE4tJGMzBCLeyTQZldelPq1wlsGTwXtlLl8w
         Yc6sEDtkNLqS+krwgsLIh3nByT9Vv94t8B64o/uyFxDIA2+o2QRMV1rHA/NbJH8WY/7E
         MlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CWYLK1Nq956lXK6/CZyqJrTCFyW3FBgUwDisoyLnoZE=;
        b=LL67C6brFJVCh6AxVHkPF60t/qYE+VC7vKQmoIq7/yjsbTAVMr6CnDgn8lD1Qw2+Ce
         340OnpNSSmDXLLLfZrAYp9QPV+i4VoArvzJcW0iabmBXPioXxE8R0WzfS4Un1+qws4oS
         Z6+R1PI0d/YZOUb/47//iTkZYm0zuvwqDlZNbHImgUBuunu535pxCnCYMvJ3NDqXCpA1
         clMTtJV7u8iwrLbIhYQBuDJL4Allevt7qQJ+rmbTedWua0CktLBC9q9G0a5PAUVihDv+
         lsk0WvZExFfOIVQ7vnOSZUBhibG0dq3JHYTawcyRwFocg8hhGCVi3peEJadZytRHgZwc
         SIrA==
X-Gm-Message-State: AOAM533xQAU3W5o7UhxpAwS4YoyKQN9RV8r+YFvT/Vbbkzi8A9/DafVr
        6QI2V7w1ewC31h36/2rPNJW4GuGQY4g=
X-Google-Smtp-Source: ABdhPJwIxmb+XLWgx2RW89d77jd3AkTM4I4lGPEqIzhsdt9VwOq9Ll4tWQyfrDSEqTTpMdlUCP0VUNzutpU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a25:cc3:: with SMTP id 186mr40287194ybm.178.1618266056256;
 Mon, 12 Apr 2021 15:20:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 12 Apr 2021 15:20:48 -0700
In-Reply-To: <20210412222050.876100-1-seanjc@google.com>
Message-Id: <20210412222050.876100-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210412222050.876100-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH 1/3] KVM: Destroy I/O bus devices on unregister failure
 _after_ sync'ing SRCU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Hao Sun <sunhao.th@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If allocating a new instance of an I/O bus fails when unregistering a
device, wait to destroy the device until after all readers are guaranteed
to see the new null bus.  Destroying devices before the bus is nullified
could lead to use-after-free since readers expect the devices on their
reference of the bus to remain valid.

Fixes: f65886606c2d ("KVM: fix memory leak in kvm_io_bus_unregister_dev()")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 383df23514b9..d6e2b570e430 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4511,7 +4511,13 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		new_bus->dev_count--;
 		memcpy(new_bus->range + i, bus->range + i + 1,
 				flex_array_size(new_bus, range, new_bus->dev_count - i));
-	} else {
+	}
+
+	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
+	synchronize_srcu_expedited(&kvm->srcu);
+
+	/* Destroy the old bus _after_ installing the (null) bus. */
+	if (!new_bus) {
 		pr_err("kvm: failed to shrink bus, removing it completely\n");
 		for (j = 0; j < bus->dev_count; j++) {
 			if (j == i)
@@ -4520,8 +4526,6 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 		}
 	}
 
-	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
 	kfree(bus);
 	return;
 }
-- 
2.31.1.295.g9ea45b61b8-goog

