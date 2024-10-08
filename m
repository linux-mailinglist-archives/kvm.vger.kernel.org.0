Return-Path: <kvm+bounces-28126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48B2C9945B9
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 12:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B68C1C23E94
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0D51CC14B;
	Tue,  8 Oct 2024 10:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dzgAW8E5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77821C3034;
	Tue,  8 Oct 2024 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728384330; cv=none; b=Zk0xxx160R7MLwCLfc15wqSOGNBv6I0eICeHZHq5B98nLGRp1JgvdDykheLkkO3W2JR4HI997Y7UPixoE9KLNaeqfm1Z0vfPV8/hrQciZ3HHM73/UYLa13rpGfucfCcM3tBXTNbEvvJ7upF5h1B+RKOs3zfojDvkx/hbqdLPfoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728384330; c=relaxed/simple;
	bh=HtBrFFSxd0haUGWgmJghsc4vdQL505ySfYgVnrPrT2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CkM4fGeaYa8DPSFHZuqLyK6FXzbrsGT/Iv9lWio+bAB7RoiXFIp3lryDrIRwxy14BjNqvtc9zPzchVLBG3mTP6uwnoeDOrpXNLX9Vp6iTdox/mKdlk4r8dW2RALq8AhghmO7/HoQXjieLuxwB1mXvVYtq1n8PpOaGlsfNiz65pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dzgAW8E5; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728384328; x=1759920328;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HtBrFFSxd0haUGWgmJghsc4vdQL505ySfYgVnrPrT2M=;
  b=dzgAW8E5GkUKp/s+EC0BDiUHrG9r+gx1Q9BeuCAbpjghktBgIA86qUoU
   pN3NJDrDW0IJ0oGQgfTth80C/T3M/2nlECD8qxCWLeKwwl/Ym0ybGnTQb
   RP6VGH8N/mNMwAYu6LZQBXGa8plEgwMH6xrEDGaqP1kePYWrAxnIbMGli
   uYgQGZl4bP1u6+BAHcrAlOwdFGYfCZefiOE77KA4de2DwrozVBVEGm1vY
   KigL00p0I9eXT2wZfyOgXdWMnqyJuNLr9IbzYSXumGle2YdTI+NoqPyJ0
   ip3z5hquCOxjVv0vccfloTrj/tYPUuTDxTO5b40dcyIzkqEdudlDYMBcY
   g==;
X-CSE-ConnectionGUID: re+YBq3QRsSKp4tcv1tPMA==
X-CSE-MsgGUID: H5k0ClzGQVyi/VLTRbQfjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45033831"
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="45033831"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 03:45:28 -0700
X-CSE-ConnectionGUID: G2IcUylJS0SOwEbR0j4Fxg==
X-CSE-MsgGUID: T+7H0ziWSHqXVoOFHmMejw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="76166902"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.88])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 03:45:27 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 0/2] Fixup two comments
Date: Tue,  8 Oct 2024 23:45:12 +1300
Message-ID: <cover.1728383775.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Spotted two nit issues in two comments of the apicv code (if I got it
right) which probably are worth fixing.

Kai Huang (2):
  KVM: x86: Fix a comment inside kvm_vcpu_update_apicv()
  KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()

 arch/x86/kvm/x86.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.46.0


