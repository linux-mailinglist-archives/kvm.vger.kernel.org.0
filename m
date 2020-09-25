Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA21279334
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgIYVXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbgIYVXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC01C0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q2so3831452ybo.5
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wImq4f56uZGGumWCDNNBjGMOp7yniJ1YSEUaSsZ8S1E=;
        b=r5uHfrvWmOH5+tkh6TyxkJ0XyDHU070mMWmUfuJGs1LPdRUAInpm/EiOwJtv7y6oY6
         4Rsw5lL+7zOXzQukoLvlZ7rU6+ML16UAubjQHJhM1BpYEzdoa47Av4VgP5dE87ZTmaWc
         fT8LHYkfU1C+xC2kFdtCdZjB+fRZyvh6jd21jy8nJ0SENVmVjdL/z14RShE2XNbfwi7i
         B7EXH5Q9ZLD+V3eS7rCBWTlX5VdUobHri2geXygyBhYe07K4QelI/Gkc5UpywRpMsU6X
         vfOSsLC7dlyRCBt5AjeIdhLrBA2Qpj4CRFS8d8vx3E46U5j3zgBZbjzjSFIUZPa2gAbX
         TAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wImq4f56uZGGumWCDNNBjGMOp7yniJ1YSEUaSsZ8S1E=;
        b=PBub07lD++48aUK8LENZQzU4i+zVsELgHakGaDqUqgCkY5XZicDEtQg+XW6khc0z2Q
         wrVbXZSV9ue1cm/iN+Fij/6y+5EsbIrqsMwigVUIgf4trQj58qwlvqlEZQuYi9zTbL90
         TAnQ0AfXe5UiKVEBC1k6Yhcu/+aemVy6rGjCECQTj88igIplWRJfm6dvioxbBz2ebr0Z
         t2MCBFOJmmYTPX7PLDOVrroMY24+QhLzPdVv6JWxPS+YrvwJzOp+qcFdJPsEOOITZc3q
         PKZCRgCWZJDMYgfStfciIlJkuaN0qcx6Eo49SdkqlVuofGqDC2396jTiym+jdcHi9QD1
         NYgQ==
X-Gm-Message-State: AOAM530m5jcUyjKZG1KOLOjdvxrBDI+3dlB8KMDRjk1i9LFsBJr/LSMm
        AJE2AEgyyYxo8kk4VXAfCLpjg6202uTu
X-Google-Smtp-Source: ABdhPJzs6xEs/BK+jYt2OWKo97X/WaqR/dReS6eqUEm9nKlThkNUe5BuXWKmRDo5eiyVuVUJWfZGsmgZQTsK
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a25:1405:: with SMTP id
 5mr1758714ybu.97.1601068999010; Fri, 25 Sep 2020 14:23:19 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:46 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-7-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 06/22] kvm: mmu: Make address space ID a property of memslots
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save address space ID as a field in each memslot so that functions that
do not use rmaps (which implicitly encode the id) can handle multiple
address spaces correctly.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 05e3c2fb3ef78..a460bc712a81c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -345,6 +345,7 @@ struct kvm_memory_slot {
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
 	u32 flags;
+	int as_id;
 	short id;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cf88233b819a0..f9c80351c9efd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1318,6 +1318,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new.npages = mem->memory_size >> PAGE_SHIFT;
 	new.flags = mem->flags;
 	new.userspace_addr = mem->userspace_addr;
+	new.as_id = as_id;
 
 	if (new.npages > KVM_MEM_MAX_NR_PAGES)
 		return -EINVAL;
-- 
2.28.0.709.gb0816b6eb0-goog

