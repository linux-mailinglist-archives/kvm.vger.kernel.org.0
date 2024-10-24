Return-Path: <kvm+bounces-29611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 284739AE18B
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 11:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 576CA1C21BFA
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C9E1B6D1A;
	Thu, 24 Oct 2024 09:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="sSGMn5AY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742223D97A;
	Thu, 24 Oct 2024 09:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729763677; cv=none; b=iBcPv0S+5M+ETukuxxeWjrNHn3kKhJ4wjv1K2JFY7XR5KdxK6EK0F+z/WI46IFHL6CNrMDHJxRfM+M79vhbAv/lk8MALyKNJ/6FeXFGtHXGP5t4Da63eCQRpVOOtL3fHl7f1UGGWk9cOa97sBIKjfaTa947AKjirENlcgCP4OuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729763677; c=relaxed/simple;
	bh=x2UavDE92BDv5s+BCjcYORa//OWbbb8+5xxnuc/JyAg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SaUKB6NYJ/N7KFbWRVKaBl1ZPH1UjF/16thuJ6WmtDSSRvCtiL0ac8c8TNTPv4Z0Vq/5YmoASLU8NyB8Dbx6aPbmr+Vr096eavzF+75na2kLXe8g50MBYOlTafbqHKKXM8GJUkcluf7od64ZoVXAZF3MTnd1emD3gqY91eT8kyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=sSGMn5AY; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729763676; x=1761299676;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uSRSILRaUqOQk+d0fn6fIQaBj6XiKKtO7Jq3IIN/vcw=;
  b=sSGMn5AYHdKl++45dw7YZEWbehh5av5OP+2a3KYpuUPl/MsYzaZwQyuQ
   Jpl5P0GpXCHO93LSm3cwhy0KGcNgnXU/WZqf6ProzYaZVQ0KhIA+BSlya
   2vNy3QDbJ9abZW5RtfVdFyoaCB/IBXjPqNr0mVPF9Zuh/aTqy8D1t4NBl
   0=;
X-IronPort-AV: E=Sophos;i="6.11,228,1725321600"; 
   d="scan'208";a="346285138"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 09:54:33 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.38.20:62460]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.134:2525] with esmtp (Farcaster)
 id 701ab77b-f7dc-4389-9913-914fa0c58c0b; Thu, 24 Oct 2024 09:54:32 +0000 (UTC)
X-Farcaster-Flow-ID: 701ab77b-f7dc-4389-9913-914fa0c58c0b
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:54:32 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 24 Oct 2024 09:54:32 +0000
Received: from email-imr-corp-prod-pdx-all-2c-d1311ce8.us-west-2.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Thu, 24 Oct 2024 09:54:32 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-d1311ce8.us-west-2.amazon.com (Postfix) with ESMTPS id 3591C40637;
	Thu, 24 Oct 2024 09:54:30 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <brijesh.singh@amd.com>, <michael.roth@amd.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [RFC PATCH 0/4] KVM: ioctl for populating guest_memfd
Date: Thu, 24 Oct 2024 09:54:25 +0000
Message-ID: <20241024095429.54052-1-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Firecracker currently allows to populate guest memory from a separate
process via UserfaultFD [1].  This helps keep the VMM codebase and
functionality concise and generic, while offloading the logic of
obtaining guest memory to another process.  UserfaultFD is currently not
supported for guest_memfd, because it binds to a VMA, while guest_memfd
does not need to (or cannot) be necessarily mapped to userspace,
especially for private memory.  [2] proposes an alternative to
UserfaultFD for intercepting stage-2 faults, while this series
conceptually compliments it with the ability to populate guest memory
backed by guest_memfd for `KVM_X86_SW_PROTECTED_VM` VMs.

Patches 1-3 add a new ioctl, `KVM_GUEST_MEMFD_POPULATE`, that uses a
vendor-agnostic implementation of `post_populate` callback.

Patch 4 allows to call the ioctl from a separate (non-VMM) process.  It
has been prohibited by [3], but I have not been able to locate the exact
justification for the requirement.

Questions:
 - Does exposing a generic population interface via ioctl look
   sensible in this form?
 - Is there a path where "only VMM can call KVM API" requirement is
   relaxed? If not, what is the recommended efficient alternative for
   populating guest memory from outside the VMM?

[1]: https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/handling-page-faults-on-snapshot-resume.md
[2]: https://lore.kernel.org/kvm/CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com/T/
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6d4e4c4fca5be806b888d606894d914847e82d78

Nikita

Nikita Kalyazin (4):
  KVM: guest_memfd: add generic post_populate callback
  KVM: add KVM_GUEST_MEMFD_POPULATE ioctl for guest_memfd
  KVM: allow KVM_GUEST_MEMFD_POPULATE in another mm
  KVM: document KVM_GUEST_MEMFD_POPULATE ioctl

 Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
 include/linux/kvm_host.h       |  3 +++
 include/uapi/linux/kvm.h       |  9 +++++++++
 virt/kvm/guest_memfd.c         | 28 ++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c            | 19 ++++++++++++++++++-
 5 files changed, 81 insertions(+), 1 deletion(-)


base-commit: c8d430db8eec7d4fd13a6bea27b7086a54eda6da
-- 
2.40.1


