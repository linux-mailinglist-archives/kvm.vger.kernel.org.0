Return-Path: <kvm+bounces-72583-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APaaHsk4p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72583-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:38:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E931B1F62E7
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:38:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 42732305B5BE
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8A334D4F7;
	Tue,  3 Mar 2026 19:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qEScmOBs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF85739769A
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 19:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566711; cv=none; b=kqO0KRhKMk61dliTEa/GhzUuGwtMTLQkHNeutiqwP82/g4ISHLVduEvLRyoBE0G6XeupzEjtSMJKN6YDK7HA0tU8H5OhHqZP6MH0aATpd0fB1w6TNjcBUjmBkzmhrczG6x1om2XvcGMpAcjXr/6diGu7oNMbtvzyVQ1Wr3OqC8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566711; c=relaxed/simple;
	bh=f27Oclao/xaQfr6PwGRNWGTzXRbSFLqWf6YmYaOs+Ak=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=iQ7mfAyBAPgqTcK5LlQTmRXZ1hO6HP3GkAzbAooVJf2T0V2g/W4YYK013BX0VfU99VElVNra/GUGhzgWN/kV7+G0YcgbVqhFpTFDqHaGnWTjElqWX+xbomF9/7VK9682ZFoMVWRKYqHPQDoB3Y7ApEj0yk1KwKKooTfFGBAMp3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qEScmOBs; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-679dcff168dso52963691eaf.3
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 11:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772566707; x=1773171507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TRfJQCr/6S2DpwzqHkIds7YA3r9Cjso1E29qc+9hpDY=;
        b=qEScmOBs9vWBwsRuU6chUSFXxuK24SS5ZJr/wshbHmatsVFAzbr4A41OCYPrA9aBom
         tWomF/Sb4f8QEzJIjzQg3L+iRgJlAJv0/USpS/K1xSO1vqKsaBS4NFz0WDRPLeiepZZC
         JriY5KwrmVk6Zm56egP0HrEc8zehbEn3IAFop9ZpRPjXmVomHe1FLto0OZg8Y4GEOV5P
         vJdQXt7wRixE0fz7SRRtMp5V3vY0XVVm5wPBCu0Vc4NdDumM31nmKGfZDa/3S6UZd9c+
         qgeuFLA8NPn1j1QvclyguTHfNts8EBwC0wGdWSp6lPXz03IoLMhq+lC5Tz6K1Vm5h5/s
         MMUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566707; x=1773171507;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TRfJQCr/6S2DpwzqHkIds7YA3r9Cjso1E29qc+9hpDY=;
        b=wZUNUXFJscKROJbYfzrCcOeWUca/YRb3Tu2ddrnVvFQnGVWMuiq4KXZbUgbMrBjWRn
         TqA5X4iGgf0ermrLpwc7SVfTvjiywXiES5XuZCmWnKltEHouoxmD/E/dZWz3I8hboZSN
         PeO9JXiQIl4FdWAD/EVtrFnbNreWFDBA+tlR/ptEZBBn50kWGumeGUzDkQmQ4qCb+4pn
         bCe5J5qKPuATKeoKcsuXqvwrS+M6NW0ErnYqdWTTcw/igFBCcDNK6XLOuqkv/2D2ZTOw
         qwETASUtNPGXVhFe1AAjpesqm6Yf4xC/+qC1oFzCLXyGoYx44xKSs3KuBraDc6epTo9G
         7K5g==
X-Forwarded-Encrypted: i=1; AJvYcCXNewssm5nxSbn8+oHKyX/HdCscAiCjSNBhT4BJ5+xqRuco3we7NdjqTIQ5HAJBDo7BWK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxUDinsJWQaC69zT/IS3K9dEIb5JDc9AfulmUPao0Ro7TCW0DZ
	V00MPcru2eTmCDVhljDod10oCv1Qhuyry7vRBiSNMdTyU9doLKCOXe3VWZp3dtFEdL6hV+IArLA
	1/3dkvak8lQ==
X-Received: from jasq9.prod.google.com ([2002:a05:6638:ec9:b0:5c8:f4c9:f657])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4dce:b0:676:96fa:299e
 with SMTP id 006d021491bc7-679fadf3c00mr10363775eaf.27.1772566707359; Tue, 03
 Mar 2026 11:38:27 -0800 (PST)
Date: Tue,  3 Mar 2026 19:38:14 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260303193822.2526335-1-rananta@google.com>
Subject: [PATCH v6 0/8] vfio: selftest: Add SR-IOV UAPI test
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E931B1F62E7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72583-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

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
# Starting 45 tests from 15 test cases.
#  RUN           vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match ...
Created 1 VF (0000:1a:00.0) under the PF: 0000:16:00.1
#            OK  vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
ok 1 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.init_token_match
#  RUN           vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close ...
Created 1 VF (0000:1a:00.0) under the PF: 0000:16:00.1
#            OK  vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
ok 2 vfio_pci_sriov_uapi_test.vfio_type1_iommu_same_uuid.pf_early_close
[...]
#  RUN           vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token ...
Created 1 VF (0000:1a:00.0) under the PF: 0000:16:00.1
#            OK  vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
ok 45 vfio_pci_sriov_uapi_test.iommufd_null_uuid.override_token
# PASSED: 45 / 45 tests passed.
# Totals: pass:45 fail:0 xfail:0 xpass:0 skip:0 error:0

Thank you.
Raghavendra

v6:
- Terminate the output buffers of readlink() with '\0' in sysfs.c.

v5:
- Rebase to v7.0-rc1 (Alex).

v4: Suggestions by David and Alex
- Assert that the value computed in sysfs_val_get() in an int. Rename the
  function to sysfs_val_get_int() to better reflect what the function is doing. (Alex)
- Add the missing Signed-off-by tag in patch-7 (David).

v3: Suggestions by David Matlack (thanks!)
- Introduce a patch to add -Wall and -Werror to the vfio Makefile.
- Use snprintf_assert() where they were missed.
- Rename the functions as suggested in the sysfs lib and the test file.
- Alloc the output char * buffer in the functions sysfs_driver_get() and
  sysfs_sriov_vf_bdf_get() instead of relying on the caller to pass one.
  The caller is now responsible for freeing these buffers.
- Remove unnecessary initializations of local variables in sysfs and the
  vfio_pci_device libraries.
- Move the inclusion of -luuid to the top level Makefile.
- Introduce vfio_pci_device_{alloc|free}() and let the test and the functions in
  vfio_pci_device.c use this.
- Return -errno for the ioctl failure in __vfio_device_bind_iommufd() instead of
  directly calling ioctl_assert().
- Since the vfio-pci driver sets the 'driver_override' to the driver of PF,
  instead of clearing sriov_drivers_autoprobe and binding the VF explicitly to
  the 'vfio-pci' driver, only assert that it's already bound.
- By extension to the above point, remove the unnecessary functions from the sysfs
  lib.

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

v5: https://lore.kernel.org/all/20260227233928.84530-1-rananta@google.com/
v4: https://lore.kernel.org/all/20260224182532.3914470-1-rananta@google.com/
v3: https://lore.kernel.org/all/20260204010057.1079647-1-rananta@google.com/
v2: https://lore.kernel.org/all/20251210181417.3677674-1-rananta@google.com/
v1: https://lore.kernel.org/all/20251104003536.3601931-1-rananta@google.com/

Raghavendra Rao Ananta (8):
  vfio: selftests: Add -Wall and -Werror to the Makefile
  vfio: selftests: Introduce snprintf_assert()
  vfio: selftests: Introduce a sysfs lib
  vfio: selftests: Extend container/iommufd setup for passing vf_token
  vfio: selftests: Expose more vfio_pci_device functions
  vfio: selftests: Add helper to set/override a vf_token
  vfio: selftests: Add helpers to alloc/free vfio_pci_device
  vfio: selftests: Add tests to validate SR-IOV UAPI

 tools/testing/selftests/vfio/Makefile         |   4 +
 .../selftests/vfio/lib/include/libvfio.h      |   1 +
 .../vfio/lib/include/libvfio/assert.h         |   5 +
 .../vfio/lib/include/libvfio/sysfs.h          |  12 ++
 .../lib/include/libvfio/vfio_pci_device.h     |  11 +
 tools/testing/selftests/vfio/lib/libvfio.mk   |   1 +
 tools/testing/selftests/vfio/lib/sysfs.c      | 144 +++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      | 157 ++++++++++----
 .../selftests/vfio/vfio_dma_mapping_test.c    |   6 +-
 .../selftests/vfio/vfio_pci_device_test.c     |  21 +-
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 200 ++++++++++++++++++
 11 files changed, 511 insertions(+), 51 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
--
2.53.0.473.g4a7958ca14-goog


