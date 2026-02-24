Return-Path: <kvm+bounces-71644-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yB2aGyrtnWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71644-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:25:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 107F018B569
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ACC8B3004636
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26F433AD9C;
	Tue, 24 Feb 2026 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gi1b/Iap"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896112874E6
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957539; cv=none; b=hVBzwMNsvLQwxq11YUt1uZnJ7SqFabseEPnkcpQxzaLYI5AKUk5V9X42q5DAj1eLSZNVIZAIKKvZGtJ9vMOnhrEVgG1wYIcqB+TXSnn89vq3tHgXzS+5tecgrYdVJ7tWppRiJFLIUMPT0+6oCFEpJhm680MIZfUCKf0/dmxyca8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957539; c=relaxed/simple;
	bh=uuqe1GZHlkUKstTlH2UG6Od3U3SW4paxzIEGbvrLeak=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LSxpwyEqAwymmt5b7fLyHZSZPU4ooUvfnGPdh7vP8pLf7RwgPtnQTM3KCoN2OTieVJoViSFz5oO5OWjrq4ffRRfVBbcyLrxD2eO9JF5zuEjTc22JPPLKiYq+RWR2xZF3NKhrtcICElwce4F10l2jnXLmcuQhuJJ4m3xtopYgbuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gi1b/Iap; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d18cbba769so56923934a34.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957536; x=1772562336; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FSfrPHwZe7tcTRvqF7oCxkJB0Uyq1ow3w008PpM/4ww=;
        b=gi1b/IapIc7W/ucjMlFBn8Mx4IwsL7PKlKceEei1cqzzHkgUefSyJHaC0ki3+sI8Rs
         KhA7fPJ9FiKl0Jqf2sSPi9SbIFtua1wA1AJc2an+wFeDp2Cj6stu0F8Zpq57bQhwBgi/
         LxhpRVYHgUMeKeoACmvU8Hnt+GKRCPEoKxaa3yJro48bTnE6ONFrFg2XhgaBlufDc0AQ
         Kps/Bdswjgnxh1c8HId4Yr0idhKGh8u9iWOpDpQOFczOwi7OiceorDg/+F9LlsbGxhus
         JqwJyMAxDNc2J8VfY0cEftnRgXRv88AbSewZtUz63NDgfAx4I8ABsN97XjNnsA/C34xg
         w8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957536; x=1772562336;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FSfrPHwZe7tcTRvqF7oCxkJB0Uyq1ow3w008PpM/4ww=;
        b=exlkyPTc13Px46uWVA8PrvL/MyKLm36Gm+4wzMugA/TXRoL0Gxbe3Sm91syHcWUWj8
         k2yY7lfNMgJ6U41QHejX+MJxVgPR/zFer1XPRp9wXUl9GE26/G8ernWpIGNEL7YThEaN
         PM4E8B4vCifHiwl9HGcUbyzl2tcgWU3YmAd2SiTrEEkU8jv9vb71yz8FS1t7T9+WvHyr
         fEu0l1BSV2suRFdWRwfHKsDM0p2U6Y31P2HldLdRU7dN3aWeA6ooVTiTajeBDt3I2ELm
         MEIY5duI4DdQBi4V/tV5VpfJbapWiwx1tz02kqX5B52OWMtDwidO9vVh/UH1o5VDO56Y
         TSjw==
X-Forwarded-Encrypted: i=1; AJvYcCV6qPqQODwte4LUBPmoFhJERvaI/V2xdg+7BZFapt5/dM9A7mG43W+Si8IuPy8kJYqRTKQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu415W8rSWER7KwEVM3fTV8wvY1fMFSx9CfyHUmYlwzmT+VqWo
	yA/E3p0MXqBwMAbgwnIF63THAD07NuSeZ01zhC9AmJ7JDGsulCTLeg3+WpJAgJUUOPf9AZjxr/y
	D8e5h3D34Zw==
X-Received: from illo6.prod.google.com ([2002:a05:6e02:1146:b0:43c:22f4:457c])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:626:b0:679:e750:6c10
 with SMTP id 006d021491bc7-679e7506da8mr232713eaf.24.1771957536129; Tue, 24
 Feb 2026 10:25:36 -0800 (PST)
Date: Tue, 24 Feb 2026 18:25:24 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224182532.3914470-1-rananta@google.com>
Subject: [PATCH v4 0/8] vfio: selftest: Add SR-IOV UAPI test
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71644-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 107F018B569
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
 tools/testing/selftests/vfio/lib/sysfs.c      | 141 ++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      | 156 ++++++++++----
 .../selftests/vfio/vfio_dma_mapping_test.c    |   6 +-
 .../selftests/vfio/vfio_pci_device_test.c     |  21 +-
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 200 ++++++++++++++++++
 11 files changed, 507 insertions(+), 51 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c


base-commit: d721f52e31553a848e0e9947ca15a49c5674aef3
--
2.53.0.414.gf7e9f6c205-goog


