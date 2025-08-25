Return-Path: <kvm+bounces-55638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 414CFB34653
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:52:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 466B71B20138
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038A62FF648;
	Mon, 25 Aug 2025 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YnDMoCvu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901082FC008
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756137139; cv=none; b=OX9KiHuh9dLndgae8r+NuEzc5IRalQe0o/M7tduIqw4pbgOk0ulD9pKJ1MQ6RRfs/2+zXaq4+fmFPGR8+miWp4w5opPm8zaLutF1pUW7Yqwr4Uqlz7wRZe+La1G1DpoinRlV4BeaTTjT8jYdunRM4WgWW9XNE/S/741CoX7jkco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756137139; c=relaxed/simple;
	bh=KZkhA/kQOmp5Oy93QMxfpEXKqa6Fo2q74cwH7XYOoXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IC/PT/dLZkoOGDAm4cMT+WU7xi8W5JBHl+E8FspuE4KitO3kiCKJsR2zw/YT7UfE9EXQ6mNJpUPQaaaWZibr1n/SteyhZJhTRkdPles3JyBlV+N5w+pTfrEIHJg/8XIUjeKFmO9HirQrIcCaoXjV+lSnPp1sSIWmTD+5/HoL2U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YnDMoCvu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756137136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ed6qfTFHMUqyUn8kqjL4nj7yM5M0u0oh4hNGYHbww5c=;
	b=YnDMoCvuILYchjRL0TVy/32QIWH3sjEw5ouKYqMDnP+Av5398MXllS5RuvkOXCSV9EdbnS
	RHbWbhTfGt4btRa48vxFEejYXjheVGaGrWfQRlTnKqAKIqxiayTP6d0sJ2qS4zBfatLlRQ
	FZTFz46nBHc8fpXVZtblAJIdzymox0A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-UADAU9WrMZepFJBhB0iojQ-1; Mon, 25 Aug 2025 11:52:11 -0400
X-MC-Unique: UADAU9WrMZepFJBhB0iojQ-1
X-Mimecast-MFC-AGG-ID: UADAU9WrMZepFJBhB0iojQ_1756137129
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c79f0a57ddso1103458f8f.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 08:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756137129; x=1756741929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ed6qfTFHMUqyUn8kqjL4nj7yM5M0u0oh4hNGYHbww5c=;
        b=v9kXHvS2xckumNU3IVszQbiZx3eYzqOyWd65OXbX2DaknemyogLpuS6UdcKUN3Sk0/
         ARD7RLkoxrQPBh26HPortLadnXIr7HmNOIzUfZWN9V3bQs543Zja/Y5tknFE5pOYtT8v
         h3wJT1yjK4KbwN2wUF+tQGmvByenpq/ekGcwccWrm4ANizuhVsXeaWFBdFGm/IYKzT7z
         PX5bsiaJLIPgle7OxJi0P4gjURuQylvyzaKv27I9YZqib6PiUX18qeq+MhzOIGxuDcyn
         phIbkHXq/Pua0Mp/Jcc0TQLIV156JHACMJOgb7mVxLncjuuTAA3KoIbw7k5E8e9F/5sZ
         sI/Q==
X-Gm-Message-State: AOJu0YzKnVuUvjku/y7JD6ooofvmPrtE/Y2K1mL2WDa7583YHfUlP6d5
	rrwnIAx6bOMmSC9eDLlhvMvGUwi/Y7ZO2i6RG3IalJylngxu2PJBHpj4RkXc39y1VS09RFWODd6
	ZIBlNWFiF6GVMGtPGi8lHm8yo6jDqn4z0iLJHyU3boiydF7kqOlJcfw==
X-Gm-Gg: ASbGncuku0pl9eEvEjyEzlYV+IWljf63jJriUgC9vptrxq3YSzs3a0tlOOxwja5Cb80
	50zOCtaJw/paSimNUHmPqOsopaINBu8jPKD8yM8GzNcsQcDvOpzsUcHyb19sloaG3zaG7c8+3fW
	P6DL+DeYhp551Whlmd9+djNxgczh5RZq5EPKkWSJQWTKh+8yzDBySpeGY13igOmGciDef00iyTW
	jnnXFHICbSNBAUW8xTXVWCWyMsU8pzOD2W0yAp28odXyacnbuaYEg6nZU6cHzhhfLMwPNqrF28A
	x/D3ARhf4Uyv/lJjfUKYJ7bJ4audbP/QUmmfXD9NWKcXDTezsHMDqn0g3YNgB4R4+JOWtM75oyN
	dZ6n/YS5UKGNJ+xjposq6InkkXAc=
X-Received: by 2002:a05:6000:2404:b0:3b8:d30c:885f with SMTP id ffacd0b85a97d-3c5dcefe32fmr10599037f8f.53.1756137128980;
        Mon, 25 Aug 2025 08:52:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXEz5g23IvWuo/ydVi6QeOhq8AK8ymIKqhjfE0JE8EYTvGus+zqYsHwn1w6Z++sXaw7/PNcA==
X-Received: by 2002:a05:6000:2404:b0:3b8:d30c:885f with SMTP id ffacd0b85a97d-3c5dcefe32fmr10599010f8f.53.1756137128539;
        Mon, 25 Aug 2025 08:52:08 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70f237fefsm12155436f8f.30.2025.08.25.08.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 08:52:08 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH] KVM: selftests: fix irqfd_test on arm64
Date: Mon, 25 Aug 2025 17:52:03 +0200
Message-ID: <20250825155203.71989-1-sebott@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irqfd_test on arm triggers the following assertion:
==== Test Assertion Failure ====
  include/kvm_util.h:527: !ret
  pid=3643 tid=3643 errno=11 - Resource temporarily unavailable
     1  0x00000000004026d7: kvm_irqfd at kvm_util.h:527
     2  0x0000000000402083: main at irqfd_test.c:100
     3  0x0000ffffa5aab587: ?? ??:0
     4  0x0000ffffa5aab65f: ?? ??:0
     5  0x000000000040236f: _start at ??:?
  KVM_IRQFD failed, rc: -1 errno: 11 (Resource temporarily unavailable)

Fix this by setting up a vgic for the vm.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 tools/testing/selftests/kvm/irqfd_test.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/irqfd_test.c b/tools/testing/selftests/kvm/irqfd_test.c
index 7c301b4c7005..f7b8766e9d42 100644
--- a/tools/testing/selftests/kvm/irqfd_test.c
+++ b/tools/testing/selftests/kvm/irqfd_test.c
@@ -8,7 +8,11 @@
 #include <stdint.h>
 #include <sys/sysinfo.h>
 
+#include "processor.h"
 #include "kvm_util.h"
+#ifdef __aarch64__
+#include "vgic.h"
+#endif
 
 static struct kvm_vm *vm1;
 static struct kvm_vm *vm2;
@@ -86,14 +90,30 @@ static void juggle_eventfd_primary(struct kvm_vm *vm, int eventfd)
 	kvm_irqfd(vm, GSI_BASE_PRIMARY + 1, eventfd, KVM_IRQFD_FLAG_DEASSIGN);
 }
 
+static struct kvm_vm *test_vm_create(void)
+{
+#ifdef __aarch64__
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+
+	vm = vm_create_with_one_vcpu(&vcpu, NULL);
+	gic_fd = vgic_v3_setup(vm, 1, 64);
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");
+
+	return vm;
+#endif
+	return vm_create(1);
+}
+
 int main(int argc, char *argv[])
 {
 	pthread_t racing_thread;
 	int r, i;
 
 	/* Create "full" VMs, as KVM_IRQFD requires an in-kernel IRQ chip. */
-	vm1 = vm_create(1);
-	vm2 = vm_create(1);
+	vm1 = test_vm_create();
+	vm2 = test_vm_create();
 
 	WRITE_ONCE(__eventfd, kvm_new_eventfd());
 
-- 
2.51.0


