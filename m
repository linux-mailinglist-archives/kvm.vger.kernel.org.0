Return-Path: <kvm+bounces-72241-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKOQAEAromkq0gQAu9opvQ
	(envelope-from <kvm+bounces-72241-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:39:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3031BF087
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5062F30A306E
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B19C83ED126;
	Fri, 27 Feb 2026 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d0WclA5X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B431296BBF
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 23:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772235573; cv=none; b=LUQaENTP2HYzjQjPcgvD2UzPvizPpkHxFe/FDEIhDIcjOD1r+S4b970yxwY28rrtVzUvNQLTfvsgoXPLuqLdoO/M9UEV+0W+tlsILiS0BBLg3gYvK44ol7u8+R3Ish1GUfOdKToIT92llkjKRyr8bj/rOfOR76ecqWbZ6bZRJwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772235573; c=relaxed/simple;
	bh=yhFNscS3e48quN6qC0RgO3oqvBQ6NNePJe9xLSzD7KA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UHk1CaNMY8pKdz9OsDXFOiObNtMqQROHdfpgB6tMc678zrWajWoj4CVo17AQKsw4itgb0gyZwfmkNVY0qbeLEgmI1EbdNFQJ98G97WTtrVgc5gG9suprD784F8RI7T+SHcAqNBSt91DfrprMtOTPfMbNadl60rzjd/kFOdA+T8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d0WclA5X; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-679a47a1febso55619684eaf.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 15:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772235570; x=1772840370; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rjNOk3pwa6q55wmH2B3/b0LkaPg1wV8Htr3bzoAZysM=;
        b=d0WclA5X0vxYMfqcSTNBt/sTGJAHJO3OJhSKhhNMG8bb5zkV+gB9m9qXs6RdGdJIEZ
         4ICWTHmn74maAzbVYEc4zWad3vATYr1XoC9WqlB1adTMLqDUIB0jC4Pi74s5H2QBaLFF
         iSyM4nQajQv0MwPkb4SaRbEkQG4SE6Y9RhzEGKm9EzroSFzYCus4Lv32L6BfNfHrcbQ6
         iFGIni4qBHzhKDM0hWDcIBZ29sC2fv8V6DSTg8PtiEUQfUsGzBmccxdlpqV7LryJDN4S
         fOfh4WpkrAGokICgFX3P/xNd+3NgKluT8Q12LeLfe8QWtZhinl+aPe+4jQAkB12TBBcx
         KQ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772235570; x=1772840370;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjNOk3pwa6q55wmH2B3/b0LkaPg1wV8Htr3bzoAZysM=;
        b=ScLtmuPMTYhbUs9Z52Sxucm3vJ/xM0WJn3T/Crev3oXwVGBwQ2anyhR9bJMhUtjdGH
         g+Y5BIPdz30KSGaSXieoDVnpX2N++bFuJccTnABV+PRpEdGAAgOernUqCdJYOPHagPpC
         SA/OtB7oB3XWZ8VF9CxG5DxmF9/F6tZsEEOHGpeUlPQcgalvdojR5CoAgP9EDtDiAFRX
         Jpx8v+Zn/L/MfozflU35QrBx15Ov48m5CUMxMnffzDYCJL47zexV3UdQuvDD1TXnPkHQ
         pEG/d/SS/+CIKQluIUbe6xb1bRHDRqeO78WqW+obyOBlbOoNRi59HFP8i5XyK+G48iU9
         2TLQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6V3lrwtspiHgKTJYxdpW6rZJwvay6zKqC2joKvesvmpflMfN/6criNfeODNE56+oGyig=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLXkxhTIDCRRsQLzq2h4uPOn/Jtr9sPofKX5ybjYmNwEQfq1x2
	pS3y7+mwgCjHNkCruzlpVkmgr3Q7Cm0bPNThAbizq+kZFXGwG4B4D6CH28o0hpjlG8RdOc5PiD3
	BXIYRZqyclg==
X-Received: from iltq9.prod.google.com ([2002:a05:6e02:969:b0:4d3:ba58:d16])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4cc6:b0:676:aeb2:640
 with SMTP id 006d021491bc7-679fadb7ed5mr2610876eaf.4.1772235570333; Fri, 27
 Feb 2026 15:39:30 -0800 (PST)
Date: Fri, 27 Feb 2026 23:39:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227233928.84530-1-rananta@google.com>
Subject: [PATCH v5 0/8] vfio: selftest: Add SR-IOV UAPI test
From: Raghavendra Rao Ananta <rananta@google.com>
To: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>
Cc: Vipin Sharma <vipinsh@google.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72241-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rananta@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 4B3031BF087
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
 tools/testing/selftests/vfio/lib/sysfs.c      | 141 ++++++++++++
 .../selftests/vfio/lib/vfio_pci_device.c      | 157 ++++++++++----
 .../selftests/vfio/vfio_dma_mapping_test.c    |   6 +-
 .../selftests/vfio/vfio_pci_device_test.c     |  21 +-
 .../selftests/vfio/vfio_pci_sriov_uapi_test.c | 200 ++++++++++++++++++
 11 files changed, 508 insertions(+), 51 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
 create mode 100644 tools/testing/selftests/vfio/lib/sysfs.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_sriov_uapi_test.c


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
--
2.53.0.473.g4a7958ca14-goog


