Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2579A41B697
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 20:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242289AbhI1Stv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 14:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242237AbhI1Stt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 14:49:49 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC185C06161C
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:09 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id v10-20020ad4554a000000b0038250b18b6dso56828463qvy.12
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 11:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O4Pf1pw7IvGHNe4ix1iHuqBRwQM1rzQrtDbARj3VD7U=;
        b=mMMdCpyyOz9jvXo89g2rQ6b6Nh948to1i5C3FcPkKL21khzd0SJnqxQR4pkyDMx9wa
         s0O07AEGyGZovHoZMQWntxZ96N3sLH8ged8VBIMRL3FOXckb8dsewQN2qvTmew6Mg8p0
         Oolh9VInTIJlL5VZaT2EXghb9fy5iK+ewpnw//GSA/9/OPPM46+sSBbZ8QpqsfcCDI0L
         hnzvrBsCQu6n04TqU7WBQFmmglwGBFckLdXNTpAVz4Yjxd4GOGyU9lwF+ghdGzg0WUiz
         iB4cEZyX1mFt8GkSsJB84Cquma2SBzV8D+IDLTJmPek45HdWNKnpiemLZlZf80Badjv/
         6dBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O4Pf1pw7IvGHNe4ix1iHuqBRwQM1rzQrtDbARj3VD7U=;
        b=5NHPdyjwTFJQ8PRLC+oaEmPssAcgrTUcUavkHMSQ3RAqvYjXHlZZVKQQHXYHzf7Ndb
         J9qg3P/YpdF5gdh9eZiu4LZEiagzTGTCzoqYOyp1fvZqUupwNmfEYVgsKO9ztxzU8gqB
         w3GVZyxtrxS5x51LnEXvffy1X9c3cI50c5WxXXbpGP7IaYinzyyF1WnSThboaklECoe0
         EseD23vPQRgGgezS3aoKZZTLBIaMKxAMiuE9MExXxBsgTVXmrbeDPFOcvgibw4HZyZDP
         ekM2goHhmpq4k0sB4nnPvVVbnilKHvvjRoPwrzDaM9w+HJs1pJghDdemWd1zUCVVqJSK
         EBmw==
X-Gm-Message-State: AOAM533JmO+KnDMwOb0WAtFvzunKxxMCj0rUL/EkIV9UmoVUMND2ACFo
        9DCsLIHkctJYoqdjxKTimgTD7GL0aO8xepKzwQirA+UcjZJh3YLnO9L0WtSKWe7xuMlAsprFExY
        SmUi8EKzOAJ/5IgB7gLEOx5/Xs1Poss4oAo9Riw/m1X3AgN7bbJZQJylDW0bQNwE=
X-Google-Smtp-Source: ABdhPJx5jNcltOLTjTdhqpjP1Bl4mvZcRKZjKlWdl3zBsvmwrNHy7AtNptUT7fjtgYO1crNJzy1+li0z/78wjg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:ad4:4a02:: with SMTP id
 m2mr164765qvz.8.1632854888735; Tue, 28 Sep 2021 11:48:08 -0700 (PDT)
Date:   Tue, 28 Sep 2021 11:47:55 -0700
In-Reply-To: <20210928184803.2496885-1-ricarkol@google.com>
Message-Id: <20210928184803.2496885-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210928184803.2496885-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 01/10] kvm: arm64: vgic: Introduce vgic_check_iorange
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the new vgic_check_iorange helper that checks that an iorange is
sane: the start address and size have valid alignments, the range is
within the addressable PA range, start+size doesn't overflow, and the
start wasn't already defined.

No functional change.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h            |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 7740995de982..f714aded67b2 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -29,6 +29,28 @@ int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 	return 0;
 }
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size)
+{
+	int ret;
+
+	ret = vgic_check_ioaddr(kvm, ioaddr, addr, alignment);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED(size, alignment))
+		return -EINVAL;
+
+	if (addr + size < addr)
+		return -EINVAL;
+
+	if (addr + size > kvm_phys_size(kvm))
+		return -E2BIG;
+
+	return 0;
+}
+
 static int vgic_check_type(struct kvm *kvm, int type_needed)
 {
 	if (kvm->arch.vgic.vgic_model != type_needed)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 14a9218641f5..c4df4dcef31f 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -175,6 +175,10 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
 int vgic_check_ioaddr(struct kvm *kvm, phys_addr_t *ioaddr,
 		      phys_addr_t addr, phys_addr_t alignment);
 
+int vgic_check_iorange(struct kvm *kvm, phys_addr_t *ioaddr,
+		       phys_addr_t addr, phys_addr_t alignment,
+		       phys_addr_t size);
+
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
-- 
2.33.0.685.g46640cef36-goog

