Return-Path: <kvm+bounces-57093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FDAB4A937
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A50D4362EED
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A173164B8;
	Tue,  9 Sep 2025 10:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1GmjjfUw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B90E313E37
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 10:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757412021; cv=none; b=oSLmiNIW5Z0uxyDFA4WJMf2S/1yAHqwhaGKSnla+y2Y/5BmgpySckbhnXcJBkP5CEzVFlI2rGADZPFrzveFbD6KYkjcSsgTsa2LfmNPoX7Z2CYVPX2T0EWJ+ZTlKtPbsDYX3KyfZVuwEdDgZzPZBKavCiuOSbAEOBJpHC2mLh2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757412021; c=relaxed/simple;
	bh=TC0/DAtjo962c3w2zSDYnWaaPOAlIjdtxO5AuA4+e2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z90Dr398Kt2BxVzWYAGgjsrGKzjGW0tie5PCsQrvgiPa2X0rqa1q5ZoJBQKL3TxZxmVvjtcR8DeE9M4KqjCPTbczF3Mbgyz7nGAZcBjdSNLD0+VKtbid+KT6Y2b0W3sGrmLRzaYNd8e7igiOOEzJlBb8jkR1IGBl3p1un8WHkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1GmjjfUw; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45cb6d8f42bso52074895e9.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 03:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757412017; x=1758016817; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4CHS3L1HTq4zc8VOJcXLjTfuiOI6XTDNN7808wd2BIw=;
        b=1GmjjfUwiiUwu3JdR8EZJP5otoGKdB03MG6c4El4E8aHUNetf6oIhlZWG/1hz7Gp1/
         72P0bflVoELsFQCB7Xb6fiPhN4xC8jMqYOPsOHEc3UW2ShY6RFU41Pn9Dj6BhN3YSMKM
         btDTwxSNZDI1QV53Au+v8mxrlyffgblqOZiWiKrLkkDnONsMSQmTUmdrcAgORdNPhNRB
         fZlKn7YlIEn5F88kVxe81fQTcI+uCuwVByZzmY6raeAsQuUU9OHPChAowMZLVWtPO4Zx
         6Ho4NAOcfv8PW5uKfuGUEyGSlv38UIhUKUPfgJyfoyOpLRQ61kaiJjL/m0SPMPFq7PLg
         KHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757412017; x=1758016817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4CHS3L1HTq4zc8VOJcXLjTfuiOI6XTDNN7808wd2BIw=;
        b=q0xhIuAuvhKIV02IPPKSco0ysZ+9HqmCXDOWtHIi4p2AleFNyI9+u0/8q4y2RgP7td
         gVomOEaYzwLKqSQ2w0vuq+XBv0S3unHWh1cJ97pAwHPMuohwktIezp7L6iwcyQP9bS0k
         HA/wKmlSzRADpsJwlDMnObfS+gqWrm3KVU+NjHH1zfq6YPpQPi8fgOo4nOTStLK+75LX
         TkHz3bLBNZFfj06u9Cl+r1Al5Pbrj3xCdVJU2YnRpxJ/Ot/0LBdET3ImBfJUR8jAkreM
         9jvK8OIUr4r7IpwYrCFUOGb77JtkC2g95iA/axghGJn5IuuWyGfvJ33NkACyEe+nZWK8
         WyLw==
X-Forwarded-Encrypted: i=1; AJvYcCWStg+x2YgoXSxtDSDw3n5E9SvPcIw24MKOC6z2MclIHN45S6G91PbO0UVuvw8mnFlsxMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkmFHbdM527FQEocqsDYE7sTy+gHqkzzPTx9KPLS6lqeu0eG2A
	PNwIVN9+yocc4n5WdxCwu4F7PEU5IbDblw96Gl7NWNwX3kPD64ATXPEVg3wy1kngyEt1aoK87Er
	vRA==
X-Google-Smtp-Source: AGHT+IFFKS9LSCg4pqICkObMpdq7WwENyXMbo01qMECVjQhfTtItSGy3G3y/UQTpd1+00goRvADrbyzv2A==
X-Received: from wmbei14.prod.google.com ([2002:a05:600c:3f0e:b0:45d:e45e:96aa])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:548a:b0:458:bfb1:1fb6
 with SMTP id 5b1f17b1804b1-45ddde6a471mr83472825e9.2.1757412017523; Tue, 09
 Sep 2025 03:00:17 -0700 (PDT)
Date: Tue,  9 Sep 2025 10:00:07 +0000
In-Reply-To: <20250909100007.3136249-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909100007.3136249-1-keirf@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909100007.3136249-5-keirf@google.com>
Subject: [PATCH v4 4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>, 
	Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"

Device MMIO registration may happen quite frequently during VM boot,
and the SRCU synchronization each time has a measurable effect
on VM startup time. In our experiments it can account for around 25%
of a VM's startup time.

Replace the synchronization with a deferred free of the old kvm_io_bus
structure.

Tested-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Keir Fraser <keirf@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7d6111cf254..103be35caf0d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -206,6 +206,7 @@ struct kvm_io_range {
 struct kvm_io_bus {
 	int dev_count;
 	int ioeventfd_count;
+	struct rcu_head rcu;
 	struct kvm_io_range range[];
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 870ad8ea93a7..bcef324ccbf2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1320,6 +1320,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
 	}
 	cleanup_srcu_struct(&kvm->irq_srcu);
+	srcu_barrier(&kvm->srcu);
 	cleanup_srcu_struct(&kvm->srcu);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	xa_destroy(&kvm->mem_attr_array);
@@ -5952,6 +5953,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 }
 EXPORT_SYMBOL_GPL(kvm_io_bus_read);
 
+static void __free_bus(struct rcu_head *rcu)
+{
+	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
+
+	kfree(bus);
+}
+
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
 {
@@ -5990,8 +5998,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	memcpy(new_bus->range + i + 1, bus->range + i,
 		(bus->dev_count - i) * sizeof(struct kvm_io_range));
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
-	kfree(bus);
+	call_srcu(&kvm->srcu, &bus->rcu, __free_bus);
 
 	return 0;
 }
-- 
2.51.0.384.g4c02a37b29-goog


