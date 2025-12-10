Return-Path: <kvm+bounces-65671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0F0BCB3BBF
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 19:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B7F043074749
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 18:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80EF32862D;
	Wed, 10 Dec 2025 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hh+o5Lwv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C4532692A
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390463; cv=none; b=H0ymoBtGu5TevUHo6ZAuSgJVCZ5YjAZ6POeZw5iF8YQPHKFbDyP9L8ebA1BGG7hhz4qGnAl3dhKd3h48PJXd46oijhYIFhYA39DrPGUp1i0bT9q61JEsCAXMUx0cVGpjHEAielcwSC0quRTAt+yf34rZMoNgBPUiI+HUruq6zbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390463; c=relaxed/simple;
	bh=Gwtk7/V1IbgkADTY4UZ3AYMrnSlS5Y2RNs6HXegXqUk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kSrWAjaAyo/cj/euHcrqhvodqrJnzV7aMOVQL04WgeYS7kDGWdhcuGJGpQwegecHYnUfpZBV7S/bqX09IDxAxDaT3yqOLj8r3/5+YXxURvV0n1WcC3ODPicugFVHEFnYFPdIeJQZDqHswuINynFhHrFKtpbaAFAY6OABNOhYt5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hh+o5Lwv; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c72ccd60f5so359544a34.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 10:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765390461; x=1765995261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gJPs3sxzYCDJFdqc+QHt5C/KgqWsA0f2Jj2OdmWtv1o=;
        b=Hh+o5LwvtZWyx3kp/DjgS3a7/t8HWdXgdWIDfiiK+gu71UtgadbmzdNeldX6fOvyNz
         XjUWorL2kyv3Sbx0tX4uPmJXHh9sz2uMDdqsWzRqdssZ47Miflb9msIPTt+VdHsSHUQJ
         NWywPmqkxPsCvWjAjvwxK0wN5fK8isbWJ0OMoLOdrBCGPfTAUw79EXu9PD5T1csRcKg/
         xK6/ICMqa1ROBhMuij2lY/i9f+Dfl4Y6A+BwgnywPBhNaw/10iZVQnWOmNYo0ktex1A8
         YaUqien7Uf6r1dvhpHq27crDb5mcMs1l8NtB3YjP37AyRLI9A8tKSQEiu70qnE9N8mlh
         D69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390461; x=1765995261;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJPs3sxzYCDJFdqc+QHt5C/KgqWsA0f2Jj2OdmWtv1o=;
        b=dS8c54OQuvfL7VMyn6uvp5LnM/wKhlGvtBrPFdal3cUoDCpJMebkxu7RR+TQ+jf8hQ
         9jcxxtAxd13scenDKD5hcbQHRS8SqkcsFtghm7j1J3xbxwojwj8jRpyhUZB/awlijhvr
         jBiuemaD0AVMRw9jbFSzYYwdnIMaWY+2In6VwjuSjKesK/HM+d84YVi+2gW7Ds65zE43
         UxsAoYqU19njHsXsVBvuhHZgzsFKe/FIbhPWXfGKWREFuVM0lUYryHaUdjy+Gx8AOVFf
         3+AUIq0qo4TR9BIWoEHGh1ZPtZd85BIzfHXWE54lHBuS9lDeIb3FrPUnU6EV3w9ERwbm
         AYkg==
X-Forwarded-Encrypted: i=1; AJvYcCXorstNWGs+o2GOU6mubgzG4UIZRgoz1v5NfXhQF0KB7MZVjKOP/ymtU1izcWlRLCdotDg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQt+iKAuGjUWdL+uwZbhBGl2DC3YtsBEl3fPXKCIg8W26e9xUO
	pc/9VxmZVAYw88pPwShabyzINMjaeACdOgzsvQAOkrEb4WeNOozdullst6TkKTL0dfXBmawUTLN
	1zTf+x5CYNA==
X-Google-Smtp-Source: AGHT+IFnk3aW3f+FPOvxHQLOPw+dndUuJC5iBNWTkzUAdTVvuwF8AuDQUDNG6dQkKTcWgdDwENf5daJzC0W1
X-Received: from ilbbt5.prod.google.com ([2002:a05:6e02:2485:b0:42e:7be2:3ade])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1846:b0:659:9a49:9044
 with SMTP id 006d021491bc7-65b2abf4186mr1680543eaf.15.1765390460842; Wed, 10
 Dec 2025 10:14:20 -0800 (PST)
Date: Wed, 10 Dec 2025 18:14:11 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251210181417.3677674-1-rananta@google.com>
Subject: [PATCH v2 0/6] vfio: selftest: Add SR-IOV UAPI test
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

This series adds a vfio selftest, vfio_pci_sriov_uapi_test.c, to get some
coverage on SR-IOV UAPI handling. Specifically, it includes the
following cases that iterates over all the iommu modes:
 - Setting correct/incorrect/NULL tokens during device init.
 - Close the PF device immediately after setting the token.
 - Change/override the PF's token after device init.

The test takes care of creating/setting up the VF device, and hence, it
can be executed like any other test, simply by passing the PF's BDF to
run.sh. For example,

$ ./scripts/setup.sh 0000:16:00.1
$ ./scripts/run.sh ./vfio_pci_sriov_uapi_test

TAP version 13
1..45
Starting 45 tests from 15 test cases.
  RUN  vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
    OK vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
ok 1 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
  RUN vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
   OK vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
ok 2 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
  RUN vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.override_token
   OK vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.override_token
[...]
  RUN vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token ...
   OK vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
ok 45 vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
PASSED: 45 / 45 tests passed.

Thank you.
Raghavendra

v2: Suggestions by David Matlack (thank you)
 - Introduce snprintf_assert() to check against content trucation.
 - Introduce a new sysfs library to handle all the common vfio/pci sysfs
   operations.
 - Rename vfio_pci_container_get_device_fd() to
   vfio_pci_group_get_device_fd().
 - Use a fixed size 'arg' array instead of dynamic allocation in
   __vfio_pci_group_get_device_fd().
 - Exclude vfio_pci_device_init() to accept the 'vf_token' arg.
 - Move the vfio_pci_sriov_uapi_test.c global variable to the FIXTURE()
   struct or as TEST_F() local variables.
 - test_vfio_pci_container_setup() returns 'int' to indicate status.
 - Skip the test if nr_vfs != 0.
 - Explicitly set "sriov_drivers_autoprobe" for the PF.
 - Make sure to bind the VF device to the "vfio-pci" driver.
 - Cleanup the things done by FIXTURE_SETUP() in FIXTURE_TEARDOWN().

v1: https://lore.kernel.org/all/20251104003536.3601931-1-rananta@google.com/

Raghavendra Rao Ananta (6):
  vfio: selftests: Introduce snprintf_assert()
  vfio: selftests: Introduce a sysfs lib
  vfio: selftests: Extend container/iommufd setup for passing vf_token
  vfio: selftests: Export more vfio_pci functions
  vfio: selftests: Add helper to set/override a vf_token
  vfio: selftests: Add tests to validate SR-IOV UAPI

 tools/testing/selftests/vfio/Makefile         |   1 +
 .../selftests/vfio/lib/include/libvfio.h      |   1 +
 .../vfio/lib/include/libvfio/assert.h         |   5 +
 .../vfio/lib/include/libvfio/sysfs.h          |  16 ++
 .../lib/include/libvfio/vfio_pci_device.h     |   9 +
 tools/testing/selftests/vfio/lib/libvfio.mk   |   5 +-
 tools/testing/selftests/vfio/lib/sysfs.c      | 151 ++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      | 135 ++++++++---
 .../selftests/vfio/vfio_dma_mapping_test.c    |   6 +-
 .../selftests/vfio/vfio_pci_device_test.c     |  21 +-
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 215 ++++++++++++++++++
 11 files changed, 515 insertions(+), 50 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c


base-commit: d721f52e31553a848e0e9947ca15a49c5674aef3
--
2.52.0.239.gd5f0c6e74e-goog


