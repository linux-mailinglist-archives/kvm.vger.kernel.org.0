Return-Path: <kvm+bounces-40375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FDBFA57002
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:04:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BCDE165CEA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 18:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85E1E23F29C;
	Fri,  7 Mar 2025 18:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SA579To0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03AF21C16A
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 18:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370667; cv=none; b=NjktzLhPJ724RaSzg+w5mUA6Z8PGUvBYwqcpnr06Wi7ZY7C70xmmT63I7q9cS3nyAFjysYzAroy7+qYF2IaLBUl576KteX5nR+fJWjMBc0NMVlVMIHCXZV+1pJpiYq/4STgNdECiZvZPhzbtePiZkKeL1gr66e1oOxVoGa/3+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370667; c=relaxed/simple;
	bh=9BvSfDYQ/noI7SgRbVbxumf1WP3NKSSn7+9fuUNEDpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k3vb2PfqpVUYkYjD2es1Lhbh21XnzQEcJCr+yX7cudsiRfAWF2UoGKXMKbu+8RQzrgeYP+dAakka/L8NDmDcM9QCRVIDMLjKm1Sh098ozsER/kC7GL8IkbKBamvWSYf14RMsqU2J1OefLfFvT35cwMIFSyO1r2Pm4BfEUPP8GoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SA579To0; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43bc31227ecso12605775e9.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 10:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741370664; x=1741975464; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zein7nNBqGkN3Vk6l0GAK1eJKKbYG2EwAlAfLaPQUy0=;
        b=SA579To0E8MGz1lr39fWJGWEnmq+ldLw9zeKadYKW1oWPAYlIGdxwunFcoWhyfaeqV
         NCVyL4/rpIC9TZj++xkLlMtazdry+tDuGvnfx5JqqrkAr/oL6IQDurYPV3ZgXMNTKdgN
         y06/nqojBd7JOBaEj7cavhf9419/Uph68g0bulKGtHaNE4OYUWDZEtS9WcHOZqJ7nKVa
         vHu5mecFGTRqPJi59UkIWC7+Acvfec8PEcWQBtOi181NfpE7s6LhPbo7rF73HR3mV3Xl
         kHLHtpk02k9at7kYHDKwLAJ7KTgiXlyOFIm8AqXaXxctDTtqNEYIFyMwSboOjcblvnHE
         Mo7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370664; x=1741975464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zein7nNBqGkN3Vk6l0GAK1eJKKbYG2EwAlAfLaPQUy0=;
        b=WEvktLHxr/syaMMZE7Eqi7ECCZ2VCWpwjx9q08SI4FG/lZ83WwotKoU1dRAccFgne3
         lLDaMaXc3vtPwlq+OwTDHTu7XUB9gSI+FpLWj0xdJtRf3wY8xHF8oQbltWqLBSyUtaZl
         LrIvKXtVhPxdfu7aDlgyA/wqHWK3MLdooT0HR94+lz7u/ZRF0qcxsRsAYt5yyUuznYbJ
         57PJ+6O71/npyTVC6iFVxSGxwpH/JentXCdG5OrzUv1Kvu/V9taqVWJUaen9dVq8LVNX
         SvxnkWIdo/P2hwuxBNvU3qylsg9MK0XZJglOJS5ka+UPHeqMX9EUuN19Z0Qg56rYCxSA
         Bifg==
X-Forwarded-Encrypted: i=1; AJvYcCXjkMyzCvmkITQpIkxSAbCBSwAPB3h4g/KX+CKaFbw+UIEi74swFH3Rfx1Sc1cLLpOSvWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW8yi8St5tk1TO92RDdYBec2ikJBXI+E/D+nWRYr4YMVY20m4Z
	kRXKvWWwhFI0yIiu74umQJERwkT9YNpW/kSf1WMnkiNsmmOqo0LLA4l671/rwrU=
X-Gm-Gg: ASbGncvliTXMY51J5TqNPnIhHZZO/bWo9g7Bz1qG0kMRSN8O2MQGzW0FTQCKxcw5E9u
	ENGPVc5ZrkVLeo0jKr+3mXN8hxnhwCC4jqmsripZ5nsU5ZJvknU1i1TevAD+zW1T/EJPZ4s9FzX
	keXOkuGnGkUZUjgTG0ZryJI76lvWGm7UdoHdCR3TViXrP9HBJeoSlAN2W8TuZ35n6UCRJG8xnbb
	tV9Mnr3HxiS8anwBep6HO0eq1apFfb0UKH/6d8X51EWeCV8uWxNdoHpCw0SVgBqgjWQLx65AtSq
	9o5RThtg0NxdO17RfE6C6lScMgxmQ9Uq+ECtmX59kAEm08yBfb5cnv/LPZhpf06MnokIMlJGAfS
	eQmGsdU7+7lq34EvnIc0=
X-Google-Smtp-Source: AGHT+IFDgIDG9piVmZplAJ+ruu2TBupqlEASPykHccRCOMyucVuMcasUmrzNVAlMlKSwIHkSMaQ5UA==
X-Received: by 2002:a05:600c:6d8e:b0:43b:cc3c:60ca with SMTP id 5b1f17b1804b1-43c5a631736mr27612245e9.21.1741370663562;
        Fri, 07 Mar 2025 10:04:23 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd8da097sm60151705e9.17.2025.03.07.10.04.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 07 Mar 2025 10:04:23 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-ppc@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-s390x@nongnu.org,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 08/14] system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
Date: Fri,  7 Mar 2025 19:03:31 +0100
Message-ID: <20250307180337.14811-9-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250307180337.14811-1-philmd@linaro.org>
References: <20250307180337.14811-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently kvm_irqchip_add_irqfd_notifier() and
kvm_irqchip_remove_irqfd_notifier() are only declared on
target specific code. There is not particular reason to,
as their prototypes don't use anything target related.

Move their declaration with common prototypes, and
implement their stub.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/kvm.h   |  8 ++++----
 accel/stubs/kvm-stub.c | 12 ++++++++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index ab17c09a551..75673fb794e 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -412,10 +412,6 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg);
 
 void kvm_irqchip_add_irq_route(KVMState *s, int gsi, int irqchip, int pin);
 
-void kvm_irqchip_add_change_notifier(Notifier *n);
-void kvm_irqchip_remove_change_notifier(Notifier *n);
-void kvm_irqchip_change_notify(void);
-
 struct kvm_guest_debug;
 struct kvm_debug_exit_arch;
 
@@ -517,6 +513,10 @@ void kvm_irqchip_release_virq(KVMState *s, int virq);
 void kvm_add_routing_entry(KVMState *s,
                            struct kvm_irq_routing_entry *entry);
 
+void kvm_irqchip_add_change_notifier(Notifier *n);
+void kvm_irqchip_remove_change_notifier(Notifier *n);
+void kvm_irqchip_change_notify(void);
+
 int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
                                        EventNotifier *rn, int virq);
 int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index ecfd7636f5f..a305b33d84d 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -83,6 +83,18 @@ void kvm_irqchip_change_notify(void)
 {
 }
 
+int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                   EventNotifier *rn, qemu_irq irq)
+{
+    return -ENOSYS;
+}
+
+int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                      qemu_irq irq)
+{
+    return -ENOSYS;
+}
+
 int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
                                        EventNotifier *rn, int virq)
 {
-- 
2.47.1


