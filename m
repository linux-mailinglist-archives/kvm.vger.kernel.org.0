Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6254808E
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfFQLZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:25:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45294 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbfFQLY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:24:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id s21so5632461pga.12;
        Mon, 17 Jun 2019 04:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7cFKfAqTFnDsz7H72uAzwV5NxIhwkVRp3XlBceBAKto=;
        b=YbDW0LZkdWRsiM5Dr8udglnjGpETpGUzBFWSSfyJ59v7HU/GEPeH0CobuO0xSB1VyD
         zR7JmtWKDokWLP22mbpbUn9u3t3pFgpNREkIwj6DxEi39AriqjXGAGbG8Zes8ijQ8EBl
         /dbaHH9HIwfbISNeCxPlHq/S3IIL+5rMpe9whyshI4LXS6bQ/3jV3qjoKUCol83OTeGd
         L6xgAxizABgQKKuXz8kUT9ccb/DkVGgTL4FOZm9W30aPD5UT17adu7aqObVn1+mO/vVs
         J3xW5YgDXdJJ9M0vT4V+LuIS9o+0eLtkkYicEIuBP/a1tymfV6YNWrmDL+dpTCNZKiw/
         uoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7cFKfAqTFnDsz7H72uAzwV5NxIhwkVRp3XlBceBAKto=;
        b=LP5KMnKkHg+Ru1IjAbDDhgHJwHgmye98gwV1YcSq9JARNkVMaDoZYd+REeqKPqqDs3
         uuMzCV/k3b0pO+e0gxFlSStAPDQZ7lcuVT1GiQNXDRm/rHTLztHmUOFheVvfCgbRCx66
         mw0dx54M8X7BPqd854jzLWUghQ89qTLwlAs+/zGmkdti6gzvsMaFHxMh1ffzKPasQfq2
         K6mqpoDjYaCRb4kjvRXNCXdY2Ow8JbyKJlUseRVDTHLBRn4i0Ml0h8RGp8+Jq4TwcmPV
         2yOXswMfev7a6/q/KxcUczgZMC1kwA2d31ap358rBweZYbmezvghYZ8ulYQPZJXj44XH
         kfPg==
X-Gm-Message-State: APjAAAWn/WQGFwo1nsqZII5cq6ahz+ii0C47UJ1jYyFHMNwzfkj1y7Ne
        SM9hd1HLoDH+UolgadY9m7PDvEqD
X-Google-Smtp-Source: APXvYqwl5bbo9MEHOh50krxogQRZosns6nLyCuUCMSMmbQwjIxy+aFB3ZviJ5JiqUpPchl4sEDnlVw==
X-Received: by 2002:a65:5344:: with SMTP id w4mr48331723pgr.8.1560770698865;
        Mon, 17 Jun 2019 04:24:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d4sm12535751pfc.149.2019.06.17.04.24.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 04:24:58 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 3/5] KVM: LAPIC: Ignore timer migration when lapic timer is injected by pi
Date:   Mon, 17 Jun 2019 19:24:45 +0800
Message-Id: <1560770687-23227-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

When lapic timer is injected by posted-interrupt, the emulated timer is
offload to the housekeeping cpu. The timer interrupt will be delivered
properly, no need to migrate timer.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9ceeee5..665b1bb 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2520,7 +2520,8 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
 	struct hrtimer *timer;
 
-	if (!lapic_in_kernel(vcpu))
+	if (!lapic_in_kernel(vcpu) ||
+		posted_interrupt_inject_timer(vcpu))
 		return;
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
-- 
2.7.4

