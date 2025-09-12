Return-Path: <kvm+bounces-57437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84705B55921
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 00:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77407B6270F
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 22:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388D727B4F7;
	Fri, 12 Sep 2025 22:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DoKgUEQ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6726257820
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 22:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757715938; cv=none; b=kQzHZIISy+u6G3vbLIFFJDF4kbE90MVSfsyvy7sM0cRJ3cqBdyfaI6QTpPgcIXhQuYYIaXgyAWeAo3XKLA/+UNqIVJDAlwTvxrvR1OvFO/SinWiB9FtZSztG3uSLk5zJLRUKVcn4cg7H/IN4BJD0gEVEiOgo8C4hKeLK27bAZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757715938; c=relaxed/simple;
	bh=wGdCLlt9iZzPASFuHOAN3X/Ln6C99xyX7V0TA22N7bg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JmuavscrQJqssJpS289cynGMVSC+kF/A9gg3bBwPxltfTHSEq8W6qvSB54lShCmT2bSlLplnOkqO9UDJ6ulQIAlPS6RCv05QbvkpyOlAkTau5ZyboEyoFS4H7psrqxt57N8hm+wvkPQGDVys4LaMesf/uiTVGUMuo0Iq3BHkqOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DoKgUEQ3; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24b4aa90c20so25030795ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 15:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757715936; x=1758320736; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=299M/Z6pTRXV1Q5qkwkETIH636XUDaeorq+fJeIX7vw=;
        b=DoKgUEQ3zdaWzuyTklELmf6SmdZnLypWko9BLNQxnDR15Dw8r8FaZg6eYw2YLxhT6l
         vpTTlznjwweZqiq2JtPUx+RzNEzP9WobENzj/mr0f/1+rea7FHQHicJ5Yx7YBrCLI4F+
         7P0plfhWAM8/u8tz3YAELP0xU2mkX0I9IWTx+Ohms3z4EzH9Olo7BkXVmj1pDs/KHzsl
         sBa4uHYbRgEhOhYGxNbAldyxFDHDR9tVQvurIV1RKG4rRkADNQUO5smnEyW6UX0FkIQL
         Q4k3SgjCTMgJ7Enr8cSsbSumWmFQQE8aTOjhsJL7Ptj0B6EkBpe0pJX9t7TwPeYIc1Ac
         E50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757715936; x=1758320736;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=299M/Z6pTRXV1Q5qkwkETIH636XUDaeorq+fJeIX7vw=;
        b=n0Wn4N94qLfcsIj+Z3dL4U1AhQ00o8U6xxCjtTJk1wLtGAkVWdkISahkwBNCKFwn7Z
         X5gbQc6UFdxU2y3nz4MZlSozwEjsqTOBQTqBRkg2W6JdWDyEyuXlQaRlECG68z0RBKEs
         pM8Nt2LoBQS2nM1ZlQgOpouIFP84/OD76uRIWybXXK8LyyOJtS/vNm2wpA9sXyRzpbl1
         3+GRtNWsiVCmoqKKmd7ZdBhPO5V2XYkCBiR0kkORLNMO2RlFAFsPQ08KSMPVsQEmOrYb
         u9DoHKPI8lJobyBMFYPxrxIhEiwrnMphmowwlnlSrN2spAiJUkDuJ6MQD22pzYKDZvwm
         Fniw==
X-Forwarded-Encrypted: i=1; AJvYcCUghivQ56mIVUZlAl82JwnnkWQN1HJmuUocaQUjCqFHSmeuBo73R7izP9QeRqJiP95avjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIe9y6GuLUpn+5riScCgErotebitZFYZPAXL4uhHiavqRpT50e
	rUZu47tNZOFNuKewKE5MyOyKlHGtlxKwDPAvRSmsSH3A2qx0mH41Z96RloqfU2J+ciyEtmoE7Fi
	/CH+xDNBzCCEMTg==
X-Google-Smtp-Source: AGHT+IHSTWCWMYGOA9WCRjuMhPoRpacqXhjAwRv9u7vbP6xlrFPR1i1SZvNGqHPv/kcEsrmBFPIvlucVaSo+9A==
X-Received: from plbp14.prod.google.com ([2002:a17:903:174e:b0:24b:14e1:af2a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c30:b0:24d:7314:fe64 with SMTP id d9443c01a7336-25d27828f01mr55569785ad.57.1757715936261;
 Fri, 12 Sep 2025 15:25:36 -0700 (PDT)
Date: Fri, 12 Sep 2025 22:25:22 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912222525.2515416-1-dmatlack@google.com>
Subject: [PATCH 0/2] KVM: selftests: Link with VFIO selftests lib and test
 device interrupts
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/kvm/selftests/vfio_pci_irq_test/v1

I'm sending this series out a little early. VFIO selftests has landed in
vfio/next[1] and is slated for 6.18, but has not yet been merged by
Linus. But I wanted to start the discussion of linking the VFIO
selftests library into KVM selftests so we can test VFIO-KVM
interactions.

To demostrate testing VFIO+KVM interactions, patch 2 contains a test to
exercise delivering VFIO device interrupts to vCPUs. This test is
heavily based on Sean's vfio_irq_test.c [2].

Running selftests with VFIO devices is slightly different than typical
KVM selftests since it requires a PCI device bound to vfio-pci. The VFIO
selftests have a helper script for setting up a device:

  $ ./run.sh -s -d 0000:6a:01.0
  + echo "vfio-pci" > /sys/bus/pci/devices/0000:6a:01.0/driver_override
  + echo "0000:6a:01.0" > /sys/bus/pci/drivers/vfio-pci/bind

  Dropping into /bin/bash with VFIO_SELFTESTS_BDF=0000:6a:01.0

The test can then be run and it will detect the $VFIO_SELFTESTS_BDF
environment variable.

  $ tools/testing/selftests/kvm/vfio_pci_irq_test
  $ tools/testing/selftests/kvm/vfio_pci_irq_test -v64 -d -x

You can also pass the BDF directly to the test on the command-line (i.e.
using run.sh and the environment variable is not a required).

  $ tools/testing/selftests/kvm/vfio_pci_irq_test 0000:6a:01.0
  $ tools/testing/selftests/kvm/vfio_pci_irq_test -v64 -d -x 0000:6a:01.0

In order to test with real MSIs generated by the device (-d option), the
device must also have a supported driver in
tools/testing/selftests/vfio/lib/drivers/. At the moment we only have
drivers for Intel CBDMA and Intel DSA devices, so I haven't been able to
test with -d on AMD yet.

Currently this test only supports x86_64, but it should be portable to
at least ARM in the future, so I optimistically placed it in the
top-level KVM selftests directory.

[1] https://github.com/awilliam/linux-vfio/tree/next
[2] https://lore.kernel.org/kvm/20250404193923.1413163-68-seanjc@google.com/

Cc: Sean Christopherson <seanjc@google.com>

David Matlack (2):
  KVM: selftests: Build and link sefltests/vfio/lib into KVM selftests
  KVM: selftests: Add a test for vfio-pci device IRQ delivery to vCPUs

 tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
 .../testing/selftests/kvm/vfio_pci_irq_test.c | 507 ++++++++++++++++++
 2 files changed, 512 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/vfio_pci_irq_test.c


base-commit: 093458c58f830d0a713fab0de037df5f0ce24fef
prerequisite-patch-id: 72dce9cd586ac36ea378354735d9fabe2f3c445e
prerequisite-patch-id: a8c7ccfd91ce3208f328e8af7b25c83bff8d464d
-- 
2.51.0.384.g4c02a37b29-goog


