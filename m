Return-Path: <kvm+bounces-40508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C53FA57FAF
	for <lists+kvm@lfdr.de>; Sun,  9 Mar 2025 00:10:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 807803AC12E
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 23:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F294A20E31F;
	Sat,  8 Mar 2025 23:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Epf58pQc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8231B17C77
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 23:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741475413; cv=none; b=bt8VTsyLYz34peE3uyoCRaz6iBi66dGhUSfRPk2DsldVrOnjwSd/uHbnga+y1J/cKQZOq6XZyx2d4xsFZz+ysgMfUIzx2mYAxWi0Ce0A11ll8cPOeTO8tQ5xVCGn2527HyJ01h/yQotGG7uUxsuyQID8juRxx9PtvzvxaNvammU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741475413; c=relaxed/simple;
	bh=nxEtO0Km1yvcxVktFwoYFYWQbtl8UBAwyhOz2wf19rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=geXDn5SjVyQxAprZRTBa+I6Y3Ceo5DS4gTlQC5ddXqaMfAt0LYC0mdnlHOqnNd5bz8GR3z9EaB5JmU9qPt7F+hduBipmy8GrS6NyHFSy+FB+pJ1b7imRezX/J5yhwE6yJSghjviPfS0bJDSdasfYTOqMTX5GO1N2X0zCQ/B2ESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Epf58pQc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43bd03ed604so26020515e9.2
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 15:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741475409; x=1742080209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfxwOIZGSthGrPYmV9+XOb1nB6O0gzLqIcndrzluicE=;
        b=Epf58pQc4/NM4mZEAsQRTo8sc9ZwmzsW4zBRKv+aytBreRBTCdAigA1a9834leRr61
         3Dpy/1Hj0cq9kgMHPLp1bm8rrkstUjRCBJcjbverwDUFGgbQKZ5ZxUZF53P6hyFlO8M1
         DBNvZ/HgJ+BpCQxybtcepE3eJ5NxqCx6YdkvJc5yKudwYMIF8pbBeV5AyddFhzrVab5s
         Lei9z5FQYBXNbUNOOpeNlJHA2mNyX62Dg34LdhD64M+XSKfZULofhjUbhPPSaOIHOSRT
         lDuvoh87wcF2wYGpQtqDwvSQ4lUKA6hWZ9YtOrrH5VOYx21T2FYGZgWv/ztDf0Sxg1Jd
         uwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741475409; x=1742080209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lfxwOIZGSthGrPYmV9+XOb1nB6O0gzLqIcndrzluicE=;
        b=a5Lb2iGqWMGq4tuBs8gf44DqX7ah1to11bbgkI1/nk69dA79158aqExDAX0o3Nc5p5
         ozy28x2PKZ161+DQU0QApKTJ3378tkNQBblQggaLjglvcc6MEehHYguNrjZ1H02V3gOP
         94BiZ7fkAIdmM9nuIATpOfvQ4Js5pn49JKDAW49eV/rzXe9oYbTIISkYL4YY1lgbOvMJ
         I9Ek4UG6nqeVj9OchRfmaslsYM9KDOgUtAO9qF5B/HLHRpRaMP7PRbYqtGwP6fJH+OMu
         RG7CFzbv7GqrNAEEagMGyFT4Gzcsl3mFGGD5B7HT4CXdujrTRID6RrbAxs91PWM5P8o/
         ybRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLoOIcZ1S8wNLwV27Ujm3GtCX6EIGn3Wmwzj5KPeuDUglhdD89g3a0G0EEFVDymbO89A0=@vger.kernel.org
X-Gm-Message-State: AOJu0YznStW3f6u3yMfCmNoELa0gMOshzbtGhCeXf9OsOz+EquzFf+aU
	bJL0IY/T2+MUF0pCwMo4IXNxRh7nKSE+lyrV/YDc9TS613AYlp1UBGWeA8dmvUU=
X-Gm-Gg: ASbGnctvHoj/i+BFD/9aSjdHToyAIZVhBBFmxk2BKKulJmJ5QCqa3hHeAmLjoc7M5f2
	zOWdkd3QLMkd7FVHr0gXjbXDe5MIIA8Kr2KQvGttHMfGygKcssCN+xUVI9w5JOResuOIKDYo3gR
	KCnC1FKZGLwcjBcT8jLyczRRlTjtpLW9mVURcryPkZHqOy08rso79mXDVhSxeXRQRtmGkpE8oLc
	L9iFmXdrAFL3SV52Nd86S0UGpFlNNoa5LI+6y1mHAep3ct3Nxm6PoKoDpUQiAx6O9ZqFN96WVXT
	FT4kU0ry80ho8o66D5fNAMjgb7Jqjux+AGa3xskvXhmREzjUMLV9gZdYlKLktcsuEuDKwaXJ8Ov
	4KaG/JF5/9Zd7d0MtHUM=
X-Google-Smtp-Source: AGHT+IEqYFt3ONWw2rS9Wwh6tBBRqOLce/1aiPLRA7IaFr0DAlK7OI2TQrPavd/72gpTyJnokKbccA==
X-Received: by 2002:a05:6000:1a8f:b0:390:f552:d295 with SMTP id ffacd0b85a97d-39132dd8711mr5569888f8f.53.1741475408786;
        Sat, 08 Mar 2025 15:10:08 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e3250sm10154532f8f.61.2025.03.08.15.10.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 08 Mar 2025 15:10:07 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	qemu-s390x@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 08/21] system/kvm: Expose kvm_irqchip_[add,remove]_change_notifier()
Date: Sun,  9 Mar 2025 00:09:04 +0100
Message-ID: <20250308230917.18907-9-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250308230917.18907-1-philmd@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
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

Move their declaration with common prototypes, otherwise
the next commit would trigger:

  hw/vfio/pci.c: In function ‘vfio_realize’:
  hw/vfio/pci.c:3178:9: error: implicit declaration of function ‘kvm_irqchip_add_change_notifier’
   3178 |         kvm_irqchip_add_change_notifier(&vdev->irqchip_change_notifier);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |         kvm_irqchip_add_irqfd_notifier
  hw/vfio/pci.c:3236:9: error: implicit declaration of function ‘kvm_irqchip_remove_change_notifier’
   3236 |         kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |         kvm_irqchip_remove_irqfd_notifier

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/kvm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.47.1


