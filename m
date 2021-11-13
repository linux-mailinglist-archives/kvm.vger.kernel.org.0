Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C091944F078
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhKMBZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbhKMBZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:25:43 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3DAC061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:52 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id l10-20020a17090a4d4a00b001a6f817f57eso5273096pjh.3
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ba+wxobSaiFgmTcgNPo/VsfplrPQ2ANaflUkZ8U4a0Y=;
        b=B2RXTSE+PsDQxq7oyt7onb151ClNd8WGtfxbuo8u0TZgh9aOnDTWAnvdB/5/Dy0rzQ
         W0SVhNnv9T96lHG4/HucXMgaCt2V6L/wjk9GMjXIyF1SLKA3QiUJ1+NyrPEjPNeQCF8L
         L7kGJS/2VpOghFFwbmHpzBKTMy1rH586KW5wzi0d6hgzl5ZT2hHP62qfgOs/PBN1QLR3
         I283eK87ObcpukWe/Tw04Po+bpk1cxT80eJ/Vb3iF3jFtt6VLa1UmfuvwFNryAuWFGf+
         NbsBedNB+i2THjX+c+6HFo+oIyw/Fidj1xiS3ksdMJJhZhV4oinNo3UnIYCJtHJGTh+W
         j+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ba+wxobSaiFgmTcgNPo/VsfplrPQ2ANaflUkZ8U4a0Y=;
        b=hNENoeDUos+FCy5z1+1ZBkgDs64vmr97EvjaE3RW7LD5alWmMQoAt5AoBx6bqQyPdw
         whh/hHFGMxDOKX1pgJ83G6ZqM+5ICQGH/+ok8GgT5ydzuIFcyReP9UarOF/YZmb52NVO
         8rzwdiQiMQrXhJZodae+H7FFcu04uRXMrWE7/6JLcoRnClGqBzbskIUvkpGBc+20rSMD
         K9JglRGN8cPmsoo3b7uyClcky4rUxHsCFORJ7sja/lRBDAJzhUeOenKDrfEdYHFnEEmJ
         gVhIgS01AqaYvCzoYkj7pdRBqVxYu9tdBm43yvFm5HJ1TD2HZhPVzDQvykyPwHl4mylh
         QT+Q==
X-Gm-Message-State: AOAM530wzb0XCfi0HqhADk9ymIF4YmZe01pYI3uS8MRCI7GUKifKC0eO
        P5JPPd4JASG+ftfnDUkwIp0GOd0YAdJn
X-Google-Smtp-Source: ABdhPJxd9EBwwuIBPspUU4u87Oi0TkCWLlVKjb1nJ8VxwRhr5W5IAS2T2mLzZod60TuVuSRdfolwZ6rvNCJY
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90a:3905:: with SMTP id
 y5mr141689pjb.0.1636766571415; Fri, 12 Nov 2021 17:22:51 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:26 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-4-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 03/11] KVM: Introduce kvm_vm_has_run_once
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upcoming patches need a way to detect if the VM, as
a whole, has started. Hence, unionize kvm_vcpu_has_run_once()
of all the vcpus of the VM and build kvm_vm_has_run_once()
to achieve the functionality.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b373929c71eb..102e00c0e21c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1854,4 +1854,6 @@ static inline bool kvm_vcpu_has_run_once(struct kvm_vcpu *vcpu)
 	return vcpu->has_run_once;
 }
 
+bool kvm_vm_has_run_once(struct kvm *kvm);
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ec8a8e959b2..3d8d96e8f61d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4339,6 +4339,23 @@ static int kvm_vm_ioctl_get_stats_fd(struct kvm *kvm)
 	return fd;
 }
 
+bool kvm_vm_has_run_once(struct kvm *kvm)
+{
+	int i, ret = false;
+	struct kvm_vcpu *vcpu;
+
+	mutex_lock(&kvm->lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		ret = kvm_vcpu_has_run_once(vcpu);
+		if (ret)
+			break;
+	}
+
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 static long kvm_vm_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
-- 
2.34.0.rc1.387.gb447b232ab-goog

