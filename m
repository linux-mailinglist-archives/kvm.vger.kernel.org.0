Return-Path: <kvm+bounces-70125-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMofOriagmkzWwMAu9opvQ
	(envelope-from <kvm+bounces-70125-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:02:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9369EE0397
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 02:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C63F730655E7
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 01:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849E723BCFD;
	Wed,  4 Feb 2026 01:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="byHsBxUW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1145F7DA66
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 01:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770166865; cv=none; b=NA9+djAKp0LStUJ7hJvPs/KtuAytQU52sPgb0Y3jIJx9H/IinxUFaFVznbnAohStHUhr44/WhMn9o+K4QhDCP3t2kaMCxR9fqHF5r40SejeyvGMNoAoQDyf7rcDASCAFjXVU8Yq3d811F4kC3i45YWrKmbNlm40AuCUM5g6AjGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770166865; c=relaxed/simple;
	bh=47731ao1xYrn2HNhPmWB7PL6DmFAizKQc+s91udQdQY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HFp3NsM7HpahJxRvS/2Tsnupt5EyIScC+AwCNIt8Ko9b22nbUr2tvcncXLt1ZuYfeszg/SuE9/wUXiwBS2PHEDgetS0ob1cRQ/NHgrr19ziw4s/1u2aui2q9C0HcwnscG4nhjiIRrSmIPxj9m3Gu6C69Kr1qImyMjkk0kW8u+30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=byHsBxUW; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-662f839d680so16179877eaf.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 17:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770166863; x=1770771663; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bknv3NTjuVi2ZJRP2bJVyu5xC4LgrDEhPL5v5QRmy+s=;
        b=byHsBxUWlKXtZI3QlDAuO7CAn/t4GKJrYdzOjYbQK8G7BABBKhA27S6bDtYELjppW3
         PMtksQuEjq4AEM/rtiGifkNY6JQEwfTzokw2n8N0eM7btw19Pg1hTC3yYVKDjiIx+v8J
         x5LopVoGQlatEZhf7AcQsbWV5Ji6mWDSPlhn7Zb6KVOqB37YcRGD5HU2EShP+0xT33ZX
         huAQgMzpe5tOXS7ljfMnPn+FY8tAeeRx5lgv/kkcKVm3ev2JQv+MBn850YLJUA4orNrP
         xTiSm2cT48LrUaIYskdGYXUVafZLV3VPm9VhDGXHchZj18ayqws2+49U6/sKGI61krmH
         xfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770166863; x=1770771663;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bknv3NTjuVi2ZJRP2bJVyu5xC4LgrDEhPL5v5QRmy+s=;
        b=hy6ME5DdH0vlBJ4zGvVIswjcoPOHcyjO2GOpndzWZ1KYamOX3OLjsXn7XY72yoFbe8
         f9Ulu5162pkSizDExXOaJXCzsBT5gQxbfJ5hKWzShFg7p7eixoUCfgdCfubCbX/MxwK/
         O7bRiFW61/YxbJJZsXUJ2PGWrFqzSMuS3nr7ANufuYNeMRW407UZMWAGKesgaGzmRb2R
         PsjvlAygWT3/LElPIA4y2ntbZ72AaErdyuo6Qh9Q33/V+WbBU1YHZeaoSoNh8VfKqR8M
         FIa/9HnaJCFb8TnajXgIMTE1dsdwa8sUdeVmV/s/AB2icZpQZFG94WSPEb8kYyFgT0TG
         xOng==
X-Forwarded-Encrypted: i=1; AJvYcCVjSLNtebMkPH3u/MfyCfMsDF083rS5ydotfGshDSCL2q4f/2RYSfQohZefCYFF0YYwnR0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcdD4LwjBSAEwEygxZzCZ+fSRCOYAqf5uxEQLnI/F5JkLYQUCR
	zafmHBn88ovVkoDq+pXWJndoxRxA9FrjsFxz1gwo22kXIcS/Ix3Yj+5PXOM2ONL4xPTNHZ/t7X2
	f+2tNnWLN3g==
X-Received: from ionq20.prod.google.com ([2002:a5d:8514:0:b0:954:3aea:1293])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1f02:b0:663:c8a:f14d
 with SMTP id 006d021491bc7-66a2113d4d0mr625712eaf.29.1770166862944; Tue, 03
 Feb 2026 17:01:02 -0800 (PST)
Date: Wed,  4 Feb 2026 01:00:49 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260204010057.1079647-1-rananta@google.com>
Subject: [PATCH v3 0/8] vfio: selftest: Add SR-IOV UAPI test
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>
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
	TAGGED_FROM(0.00)[bounces-70125-lists,kvm=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9369EE0397
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
 tools/testing/selftests/vfio/lib/sysfs.c      | 136 ++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      | 156 ++++++++++----
 .../selftests/vfio/vfio_dma_mapping_test.c    |   6 +-
 .../selftests/vfio/vfio_pci_device_test.c     |  21 +-
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 200 ++++++++++++++++++
 11 files changed, 502 insertions(+), 51 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c


base-commit: d721f52e31553a848e0e9947ca15a49c5674aef3
--
2.53.0.rc2.204.g2597b5adb4-goog


