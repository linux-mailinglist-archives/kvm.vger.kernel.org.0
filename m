Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B551B444C20
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhKDA3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbhKDA2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:28:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23882C061205
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:02 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e6-20020a637446000000b002993ba24bbaso2380443pgn.12
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YU3JQHoEXhNYeqTaFGElIxIrX+lTdkV7tmvn1pNhx20=;
        b=nzIiCi8a3FdUTPNh7ytN/z1OZHuDUfxPkVLwkX7a0tH3K3c1YU/GUrVbVsUKogWulg
         8TV0o+lCCtBLbDlyn4CdD1ZyDyGmDuKpEashuorjvvAytB9Fha6Xh4GdoRmbK2lCIj46
         yaw8bm9yIsgJfAeOZzVP5kZxJzf5HvyCshSjBFStaw+bzKBcK6bPZX6ZcbGAXqRyq2X0
         r24cJ2J/KvfMuDyi9skDCmfAMeR4jILYlAAhpoLRq8XhdUkbVLo1pJ78Onj43zLqECqm
         BUFjMpHQOpmAXdYIVQtZSEVPXFkfrUmNQanymXLbwXrV/MiRmrChRqGkV2fOUirqVkRC
         KbPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YU3JQHoEXhNYeqTaFGElIxIrX+lTdkV7tmvn1pNhx20=;
        b=ycx7ADm6ZWfVTODtpBm+v4NnXdfvM97EA1jG4U++8svMssx7tE64SBwXNxdH/TtkuU
         /W33K6XI+fAFlS58jnY2ElDTCvVL/z5MZzTaxKILXOdRM9X9apZC1cM9JbHOanzO74Kw
         qHyz2NNLYidOoftrC68P3W7GbI6luy1US9TMx5iiGcimVkiRwcUgWW9qIjCTCBS+RuNe
         qur44BwATMRjjb/gY2WfSLrwfehBN+Zp5QpWaBjVyjoAUtq7ZTSQ88ucRjbzSa6VSbh/
         ccqbbvskeTAmelVKqHjFyP3K2J9vFjUb1JYb9+maBiOv1KUB/6JYmqjw4Tupq0r2aYuZ
         oedA==
X-Gm-Message-State: AOAM530JtLx1d5twTxtn0XgLly6TL4VxjnHG9Bzc3FLcWUIPuXkv/Q1+
        8FzTSTzfkYm0tA1cyFUOffLd+/2jYC0=
X-Google-Smtp-Source: ABdhPJweDq2zn2AkOEc4n/Ejh97liBXXjVYy6U4pABPdgYlHkkJl2at3TcV1J/XikSLWHiPxtEuWDooqyFQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP
 id l6-20020a056a0016c6b029032de1909dd0mr48630576pfc.70.1635985561569; Wed, 03
 Nov 2021 17:26:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:03 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 02/30] KVM: Disallow user memslot with size that exceeds
 "unsigned long"
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reject userspace memslots whose size exceeds the storage capacity of an
"unsigned long".  KVM's uAPI takes the size as u64 to support large slots
on 64-bit hosts, but does not account for the size being truncated on
32-bit hosts in various flows.  The access_ok() check on the userspace
virtual address in particular casts the size to "unsigned long" and will
check the wrong number of bytes.

KVM doesn't actually support slots whose size doesn't fit in an "unsigned
long", e.g. KVM's internal kvm_memory_slot.npages is an "unsigned long",
not a "u64", and misc arch specific code follows that behavior.

Fixes: fa3d315a4ce2 ("KVM: Validate userspace_addr of memslot when registered")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 99e69375c4c9..83287730389f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1689,7 +1689,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	id = (u16)mem->slot;
 
 	/* General sanity checks */
-	if (mem->memory_size & (PAGE_SIZE - 1))
+	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
+	    (mem->memory_size != (unsigned long)mem->memory_size))
 		return -EINVAL;
 	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
 		return -EINVAL;
-- 
2.33.1.1089.g2158813163f-goog

