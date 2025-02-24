Return-Path: <kvm+bounces-38971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F37B3A415F5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 08:09:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A840A3B06F7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 07:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5568F23FC52;
	Mon, 24 Feb 2025 07:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e+SPhtiE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B909020B20A;
	Mon, 24 Feb 2025 07:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740380924; cv=none; b=lcBoUoIQ6M1rdse9LXrZ7xPGld0RaqIueXQIsFWB6ZT241YbSTrh11UJFEngUSPgNZNOHsR4nS/QsyefhTTRPaz83gWDHHqLofeUqgNXdBoqo3SZiCaqhSkvldxVP1ONsNgijExzQlsaLcdmokSrZcfEPzszDbfu1Khf9wl4Lyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740380924; c=relaxed/simple;
	bh=R6HSVBn9Y8ToVb2vuMlEkF1uRe5BDzQkqHH1ig9bbZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gWqRXHWfC4m0YflWYgio2KtJ+rjLmiUE0cn+i+GZm49ImiRt3fqRbK3iDhy7WZRG0BUqaQOp/xRKWlKQ6i8pJmcQNAuGcYJw15jEjcCQosoC96JBXPNWxURMAkJDfdHC/217Skr+BJBskexLCiiGPVPFDhQeY/JMkxofpm5h5/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e+SPhtiE; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740380923; x=1771916923;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=R6HSVBn9Y8ToVb2vuMlEkF1uRe5BDzQkqHH1ig9bbZI=;
  b=e+SPhtiESzq13nQZKOX+ijVWhGQ07X6XpK3QiEh5R7Kc4fk4AI7Fb+E4
   QV9Pr8sG7UCvaL8i3KGipj9j0RNaNZv2KBLI77R6SCZX/O7aSwNgmbGhE
   0fWUKErEh3gnMaeGJdb5Hrx7Kkmz5RfLQ8EFFA6tnzk+uV4NsnFN/aJzx
   jbGnZfRYAC1Vebd9S0+lcUHIVoGjdcTPVXYSr/EaZp/JjE/5yHGSMBax5
   23OvqXUs1JGkwxyk/yF5GeK1GYcaT0ILqlVD6ts89ZjqndWefZL8jOcXd
   z3hz47kk6Z1z1SdNja1TZM0MYolCnmKOO8jpZ+ebhDLZDRr7M3l9jROpT
   w==;
X-CSE-ConnectionGUID: 2IDI5BvKTj6qz2vzHp8myA==
X-CSE-MsgGUID: QOU+KXLBSb6ygIpTqVOZGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="41138956"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="41138956"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:08:43 -0800
X-CSE-ConnectionGUID: bAiP6BC7SVmWzN2IMUHO/Q==
X-CSE-MsgGUID: 2qg8Ct02QKCKlpFhLhKk0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="121243058"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:08:40 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kevin.tian@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/3] KVM: x86: Introduce quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
Date: Mon, 24 Feb 2025 15:07:15 +0800
Message-ID: <20250224070716.31360-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series introduces a quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT as
suggested by Paolo and Sean [1].

The purpose of introducing this quirk is to allow KVM to honor guest PAT on
Intel platforms with self-snoop feature. This support was previously
reverted by commit 9d70f3fec144 ("Revert "KVM: VMX: Always honor guest PAT
on CPUs that support self-snoop"") due to a reported broken of an old bochs
driver which incorrectly set memory type to UC but did not expect that UC
would be very slow on certain Intel platforms.

Sean previously suggested to bottom out if the UC slowness issue is working
as intended so that we can enable the quirk only when the VMs are affected
by the old unmodifiable guests [2]. After consulting with CPU architects,
it's told that this behavior is expected on ICX/SPR Xeon platforms due to
the snooping implementation.

So, implement the quirk such that KVM enables it by default on all Intel
non-TDX platforms while having the quirk explicitly reference the old
unmodifiable guests that rely on KVM to force memory type to WB. Newer
userspace can disable the quirk by default and only leave it enabled if an
old unmodifiable guest is an concern.

The quirk is platform-specific valid, available only on Intel non-TDX
platforms. It is absent on Intel TDX and AMD platforms, where KVM always
honors guest PAT.

Patch 1 does the preparation of making quirks platform-specific valid.
Patch 2 makes the quirk to be present on Intel and absent on AMD.
Patch 3 makes the quirk to be absent on Intel TDX and self-snoop a hard
        dependency to enable TDX [3].
        As a new platform, TDX is always running on CPUs with self-snoop
        feature. It has no worry to break old yet unmodifiable guests.
        Simply have KVM always honor guest PAT on TDX enabled platforms.
        Attaching/detaching non-coherent DMA devices would not lead to
        mirrored EPTs being zapped for TDs then. A previous attempt for
        this purpose is at [4].


This series is based on kvm-coco-queue. It was supposed to be included in
TDX's "the rest" section. We post it separately to start review earlier.

Patches 1 and 2 are changes to the generic code, which can also be applied
to kvm/queue. A proposal is to have them go into kvm/queue and we rebase on
that.

Patch 3 can be included in TDX's "the rest" section in the end.

Thanks
Yan

[1] https://lore.kernel.org/kvm/CABgObfa=t1dGR5cEhbUqVWTD03vZR4QrzEUgHxq+3JJ7YsA9pA@mail.gmail.com
[2] https://lore.kernel.org/kvm/Zt8cgUASZCN6gP8H@google.com
[3] https://lore.kernel.org/kvm/ZuBSNS33_ck-w6-9@google.com
[4] https://lore.kernel.org/kvm/20241115084600.12174-1-yan.y.zhao@intel.com


Yan Zhao (3):
  KVM: x86: Introduce supported_quirks for platform-specific valid
    quirks
  KVM: x86: Introduce Intel specific quirk
    KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
  KVM: TDX: Always honor guest PAT on TDX enabled platforms

 Documentation/virt/kvm/api.rst  | 30 +++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++-----
 arch/x86/kvm/vmx/main.c         |  1 +
 arch/x86/kvm/vmx/tdx.c          |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 39 +++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              |  7 +++---
 arch/x86/kvm/x86.h              | 12 +++++-----
 10 files changed, 91 insertions(+), 22 deletions(-)

-- 
2.43.2


