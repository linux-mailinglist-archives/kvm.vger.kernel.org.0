Return-Path: <kvm+bounces-48351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6811ACD079
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 02:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DDFE3A6823
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 00:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F233810F9;
	Wed,  4 Jun 2025 00:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JHU0Vu85"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B28AD2C
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 00:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748995697; cv=none; b=iopJKQmaaExdEepyoyRbc5vRNX5Nc6aw8Gq0F9dzvZR/7V6AKhTROF3PzOy/vdmNdhkzxVYSwkQEaYbqstUYnpi/Ma3tEJenGllnwZmG2/nPaE8sL3mbhTspKfqA+gBm3QqsxGjUNHWwl15VwklNTgx5Hgdv5JtQ2qFg8BNbpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748995697; c=relaxed/simple;
	bh=2AmORUWBIwnqHLto7sTqvBbF1Jn0kKlNu+8Y8i1P1RU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=A6+OT+omcB9QzdJmI+vaTwJL3M4TTiFUOz1kWiYuIqxVyVMizZNW8unuEM/10BheCxZmSBonwSpjimqVI4vuO7A12n2tT07K9XL9R6JcGRzUCFRvUuDrZN7mW8tHSlvbczBIN+o0e+Enw6pJ61XKDA2eC67iW0DnCg2Er2Dgpgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JHU0Vu85; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23505adcac8so47503855ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 17:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748995695; x=1749600495; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kaeoER0E+Rf40LjcbAZVkgeKGezEOsbwzrO7qjm0l7Q=;
        b=JHU0Vu85UadfqMVA7OGtAxJIKHxsIAMKWobO1yL38gKB7nzK0N2WoX31p7OzoaHY3S
         +BcoalLFQxV4fLawG8KWZXDTfW3RtyWC9RGruiX8FoWhgG0dKjo2RWGu3yr/lNpiVagA
         7ioH6CY76T4fXvzwEYOkLpcEHLA5eJHcipEX7pkT4mwl5VN19H+843nxJMcNfW8qfqZf
         8nXyb9CF/6ya655E6stbtnFtfyNv0gvWWq+JsM3o2kzzKwYDw/ZciRNrKH0cmZ9RS+Jb
         Qfhb1Ib6Id0yKX57f2shVWraDKS6t63Wj4iIE4mePh1+U1jCGD2bWcQGNWRWPTO3uPdc
         ESnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748995695; x=1749600495;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kaeoER0E+Rf40LjcbAZVkgeKGezEOsbwzrO7qjm0l7Q=;
        b=C3otN/m+ufSoZoRlv6F675VvKv/imyTK0dxpYCcjVK8qZRpZQ3dG4o2UV+Ipj1jwn0
         7lTVhVy0IXm6sa1z+30y69OWYNQsMQ/UELWhZx7+10Uc1Ys7874fTOD2iyDK2VRDOnIU
         IjmZhKHIuh+l81mMaxpwP1ayhKzjmtMtks4JOm6gwk0vMPXgjQRN4e2q1Qt+NVAyboHE
         BX5dW10VDKhvBJaljg1C7KQD9j2FNu1Xz4JNRg204b0IIeC66ye5smAXo3k6625P5J4e
         i8qeSabBgkxtZJRlPuSpJDfCjwDiEbmqWbSrsEnQhv/Kz+BHTVbPtclWitqc7FcAY+UN
         o8+Q==
X-Gm-Message-State: AOJu0YyhuECBh/G40j9hK914VE88NVac2tvZH+kc/D1/AjrMHhBFUN+C
	k082v2msCs+fFagxcGddSFIbdzRVqxi42ZFwr5XP+pzGOe7kq7kkpjp5o97bWJKjtH8YZA7gFTY
	BzmqZIA==
X-Google-Smtp-Source: AGHT+IGn6eUxYQhaWvEJ+Of6L6XyYHrDZC556J6wglNoqorUrtD5QsMPRSdVBaeDisaxBAyB/fghiZLKjFk=
X-Received: from plbbe7.prod.google.com ([2002:a17:902:aa07:b0:234:2261:8333])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2351:b0:234:bca7:2926
 with SMTP id d9443c01a7336-235e11f24famr9169205ad.27.1748995695033; Tue, 03
 Jun 2025 17:08:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Jun 2025 17:08:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250604000812.199087-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: Delete split IRQ chip variants of apic
 and ioapic tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Naveen N Rao <naveen@kernel.org>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove the dedicated {io,}apic-split testcases and instead rely on users
to run KVM-Unit-Tests with ACCEL="kvm,kernel_irqchip=split" to provide the
desired coverage.

While providing more coverage by "default" is nice, the flip side of doing
so is that makes it annoying for an end user to do more, and gives the
false impression that the configurations in unittests.cfg are the only
configurations worth testing.

E.g. with kernel_irqchip=split, svm_npt fails on x2AVIC hardware due to
test bugs, hyperv_connections fails due to what is effectively a QEMU bug
that also got hoisted into KVM], and vmx_apic_passthrough_tpr_threshold_test
fails (with some KVM versions) due to a KVM bug that happened to be masked
by another KVM bug with the in-kernel PIT emulation.

Link: https://lore.kernel.org/all/Z8ZBzEJ7--VWKdWd@google.com
Link: https://lore.kernel.org/all/202502271500.28201544-lkp@intel.com
Link: https://lore.kernel.org/all/20250304211223.124321-1-seanjc@google.com
Cc: Naveen N Rao <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 6e69c50b..4f06a59f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -7,19 +7,6 @@
 # arch = i386|x86_64
 ##############################################################################
 
-[apic-split]
-file = apic.flat
-smp = 2
-extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
-arch = x86_64
-groups = apic
-
-[ioapic-split]
-file = ioapic.flat
-extra_params = -cpu qemu64 -machine kernel_irqchip=split
-arch = x86_64
-groups = apic
-
 [x2apic]
 file = apic.flat
 smp = 2

base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1204.g71687c7c1d-goog


