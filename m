Return-Path: <kvm+bounces-9032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DFB859D99
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3C581F21E1D
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8373DBA8;
	Mon, 19 Feb 2024 07:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DYQIRXsn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F25374FA;
	Mon, 19 Feb 2024 07:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328877; cv=none; b=gvBifPKWJxOypmVNMmPJREfbo/eHqEgAS6cEsVYoMnr0kDTZb1GgGRjgEealveAwY2MlLWFcJ8Ph1ztzJQOcELk3EQRQAdmsUhNztgCUtXyVBkCRdnSa8aE53Vc5GmjwF8CBXirVipX5yfQR97nWo5qkVDIXd2vkFL29r2msTfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328877; c=relaxed/simple;
	bh=7yQNwaaMLlyKLE8rZMsYP1fpLrQUPVbGPSALYvBYWdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGG4EC3sVDJ3t7ZzQMjtMKmSqFmP09YPhZQNtcmGi26FbWV2RCddKyZQOYHKS8ubzMqVherIkI35BPaXj/ZD0ZEmm8mIa9u5CDuPaZhNXDUVrehySLPjRgkpR3GX4Bjy60dd+v1ObyK6ja61+ZdCa880LJR/wb6J/wvdg0Rwpcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DYQIRXsn; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328875; x=1739864875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7yQNwaaMLlyKLE8rZMsYP1fpLrQUPVbGPSALYvBYWdc=;
  b=DYQIRXsneTby4OmoAO1lGJkaWOvi3kFD16whM1LFRaxhjNCW8LdQNXGh
   I0M/mME0SdnVQUDcs4pv3/PDcVV6osqnpO3e7es13CNUnNPb5rJXGvg89
   X7fAOoqrsfSCAAROfDpdjQabBRMkOdhiL+XS9gK56oYhBD0GQSk3usSxq
   iWgi9ZWZ6Lzujuu3yJtWevTi32w2DF2FU9tVt91+rcEkCy5QmeYzuP5g6
   LLl7BdJfTj6Xti+En7XcOewEeLXpAmLZm+LCCOXzmEUk6UxgUErWItCAG
   gzVsVZyanBKMhnk8gLbr1b1GLIHcn+sytwiLTxyOWUXHp6hoUa9vdXdlX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535136"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535136"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966115"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966115"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 19/27] KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT enabled"
Date: Sun, 18 Feb 2024 23:47:25 -0800
Message-ID: <20240219074733.122080-20-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the governed feature framework to track whether X86_FEATURE_SHSTK
and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
the features can be used iff both KVM and guest CPUID can support them.

TODO: remove this patch once Sean's refactor to "KVM-governed" framework
is upstreamed. See the work here [*].

[*]: https://lore.kernel.org/all/20231110235528.1561679-1-seanjc@google.com/

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/governed_features.h | 2 ++
 arch/x86/kvm/vmx/vmx.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index ad463b1ed4e4..daf0c0a3e29c 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -17,6 +17,8 @@ KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
 KVM_GOVERNED_X86_FEATURE(LAM)
+KVM_GOVERNED_X86_FEATURE(SHSTK)
+KVM_GOVERNED_X86_FEATURE(IBT)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46042bc6e2fa..6cb94754c2a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7764,6 +7764,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.43.0


