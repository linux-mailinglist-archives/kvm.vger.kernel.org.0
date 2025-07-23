Return-Path: <kvm+bounces-53293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A0BB0F9C6
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BB891CC1994
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555582264B5;
	Wed, 23 Jul 2025 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="DWKghVmB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04149223716;
	Wed, 23 Jul 2025 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293280; cv=none; b=rAC/a0TWXFNlx75T4eSAKuMK/71gIeo135x2u77ktrxzodeD8L65ktSPJ6/3DXAPB9xO1ngaGzK4JVXanmycLeDP34sOpRA+L7mSsH76xw9G8pRuiT5cmXfMUliP8bNE2IDvFqgHbmEdSwx+olOoADD5Psxn6Wnzz7/L7CMDKp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293280; c=relaxed/simple;
	bh=OtaJdQ6YU5sudx4rdyWNuFiwthEfXyw757uGSlQhjik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPsK/Dq0Todk/0H5+hIqYOw7wwb4TEsjBQMjDM3hQRp8SVNC0LpKllpubery9o4txLgW0JdHr781sKycXS8qhA9aFHQooEjjH/4L76Ozz1+ILWg66GplemYbuHAQfk+VP2ZbputeSY053Uw8h6hXorYi3l6mJ+ipUe2iej9AM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=DWKghVmB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf041284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:58 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf041284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293239;
	bh=PRDEVgITCbLDQ0vEC4YA8ZSuHVrrepoHdheuw6N1oO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWKghVmBzOls6+AmwBbwFdeUqVjq/h+q5/qWoxf5Xoeojf2vJ+wWNNJHIIkhVLR3V
	 l8NIXaZ1DD4zxulVA7lj7zW1dAKJ1tacX/mpECPzjpoDix9zG3cToFWxb+BtpL/MIn
	 wl/FUtCkMjpgK6+2KVdyPYqykAONkd/6pmKG+MGk6Yh4CUQHkDpu/Ly/pNK6QVeehF
	 FZlmE0PfAT5QNfk9jwXfLhbvs0AytUz3Wk0DIUrlfcpjDCz6Vj2cle+SiLTM8x3gwl
	 aqbsx4MP/snmzbjYRDwT1jGzUiUsYqtN/cvOBmhAFhtkhPTYGxiRMRJRR/d9AmJd1T
	 5mIv5AwXh3ozw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 14/23] Documentation: kvm: Fix a section number typo
Date: Wed, 23 Jul 2025 10:53:32 -0700
Message-ID: <20250723175341.1284463-15-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous section is 7.41, thus this should be 7.42.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f8cb0b18b6be..b3a54ac0d653 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8622,7 +8622,7 @@ ENOSYS for the others.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
-7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
+7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
 -------------------------------------
 
 :Architectures: arm64
-- 
2.50.1


