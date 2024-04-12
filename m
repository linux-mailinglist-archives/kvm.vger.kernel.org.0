Return-Path: <kvm+bounces-14415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB1E8A297E
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 178541C225BE
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E3440860;
	Fri, 12 Apr 2024 08:41:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBBF38FA3;
	Fri, 12 Apr 2024 08:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911280; cv=none; b=fp6k4XQ+0uMchqzaz0ENFqHWHOXncarEezEtODWA74sQBOMLzVJykKJm+EMBQsU9Vb+DdDsED+nhp/xyzdlGzteU3kBqaGyZMxLgpKknNoefXHnXTVu/Xq/1pXyfx//lW4bniDldpT5FwGJoIv8j3J/iMfXWJV7sk5WUVSqg36M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911280; c=relaxed/simple;
	bh=43sKYtsFLRVOrVPBcqhE8/RN5WZfWsuNH3OGHSxjLcU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YGQOaBEmfiMlZo8NT+H2LivO4RJW+XdC7xnSRTGr1D3LlLGb9JCn9t0I6oXMi9KgaHnsVr2zbZg7IBFzGg3eOEQJ0fKTyR5XfRdLqilc81Ao6f9xTYoktdpqacHNeXbhKRZysmesrws59491qgG13Kq5v8la4diMoc5rw/jgYFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7890339;
	Fri, 12 Apr 2024 01:41:47 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EDFC3F6C4;
	Fri, 12 Apr 2024 01:41:16 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [v2] Support for Arm CCA VMs on Linux
Date: Fri, 12 Apr 2024 09:40:56 +0100
Message-Id: <20240412084056.1733704-1-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are happy to announce the second version of the Arm Confidential
Compute Architecture (CCA) support for the Linux stack. The intention is
to seek early feedback in the following areas:
 * KVM integration of the Arm CCA;
 * KVM UABI for managing the Realms, seeking to generalise the
   operations where possible with other Confidential Compute solutions;
 * Linux Guest support for Realms.

See the previous RFC[1] for a more detailed overview of Arm's CCA
solution, or visible the Arm CCA Landing page[2].

This series is based on the final RMM v1.0 (EAC5) specification[3].

Quick-start guide
=================

The easiest way of getting started with the stack is by using
Shrinkwrap[4]. Currently Shrinkwrap has a configuration for the initial
v1.0-EAC5 release[5], so the following overlay needs to be applied to
the standard 'cca-3world.yaml' file. Note that the 'rmm' component needs
updating to 'main' because there are fixes that are needed and are not
yet in a tagged release. The following will create an overlay file and
build a working environment:

cat<<EOT >cca-v2.yaml
build:
  linux:
    repo:
      revision: cca-full/v2
  kvmtool:
    repo:
      kvmtool:
        revision: cca/v2
  rmm:
    repo:
      revision: main
  kvm-unit-tests:
    repo:
      revision: cca/v2
EOT

shrinkwrap build cca-3world.yaml --overlay buildroot.yaml --btvar GUEST_ROOTFS='${artifact:BUILDROOT}' --overlay cca-v2.yaml

You will then want to modify the 'guest-disk.img' to include the files
necessary for the realm guest (see the documentation in cca-3world.yaml
for details of other options):

  cd ~/.shrinkwrap/package/cca-3world
  /sbin/e2fsck -fp rootfs.ext2 
  /sbin/resize2fs rootfs.ext2 256M
  mkdir mnt
  sudo mount rootfs.ext2 mnt/
  sudo mkdir mnt/cca
  sudo cp guest-disk.img KVMTOOL_EFI.fd lkvm Image mnt/cca/
  sudo umount mnt 
  rmdir mnt/

Finally you can run the FVP with the host:

  shrinkwrap run cca-3world.yaml --rtvar ROOTFS=$HOME/.shrinkwrap/package/cca-3world/rootfs.ext2

And once the host kernel has booted, login (user name 'root') and start
a realm guest:

  cd /cca
  ./lkvm run --realm --restricted_mem -c 2 -m 256 -k Image -p earlycon

Be patient and you should end up in a realm guest with the host's
filesystem mounted via p9.

It's also possible to use EFI within the realm guest, again see
cca-3world.yaml within Shrinkwrap for more details.

An branch of kvm-unit-tests including realm-specific tests is provided
here:
  https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca/-/tree/cca/v2

[1] Previous RFC
    https://lore.kernel.org/r/20230127112248.136810-1-suzuki.poulose%40arm.com
[2] Arm CCA Landing page (See Key Resources section for various documentation)
    https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
[3] RMM v1.0-EAC5 specification
    https://developer.arm.com/documentation/den0137/1-0eac5/
[4] Shrinkwrap
    https://git.gitlab.arm.com/tooling/shrinkwrap
[5] Linux support for Arm CCA RMM v1.0-EAC5
    https://lore.kernel.org/r/fb259449-026e-4083-a02b-f8a4ebea1f87%40arm.com

