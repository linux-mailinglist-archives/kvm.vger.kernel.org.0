Return-Path: <kvm+bounces-55283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2760DB2FABA
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 391B3586DE6
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C70B343218;
	Thu, 21 Aug 2025 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZH44rJtL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDDB33EAE7;
	Thu, 21 Aug 2025 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783126; cv=none; b=rWb11KBrHwE/BQ0RXfooFqZ40qnxhXQplqXfCBBbzTtBduqh8aoiX59LLzhIRecB8QpSHGsi0QUCUOVZ2T5pwOWf06Y8JVqMUEGzGebnuWukvVVTjv145vLmY4bi1HDIhOAR3+E5KInE2rNZibHOQ6fhnxZ3+yOM1lgtPdm5lJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783126; c=relaxed/simple;
	bh=UWTsMIFUKKfKqXofgj1KcWxsPN3Qqsk4w0IGNVwekTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1WqRh7UCEuhS63audTToh359vQZaaoBGojgRzDWJsApuOQwMZAojrnwdqj3/1X6JkN3u76MwE0q/744oUQpOadfcUghqUOzrK5+iq5qAxU7uJNx/zsHsneLn7bMlLv+AFOljpndM1onnLgIRgGesdlABp0C+h4drmn4Nx0/7GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZH44rJtL; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783124; x=1787319124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UWTsMIFUKKfKqXofgj1KcWxsPN3Qqsk4w0IGNVwekTA=;
  b=ZH44rJtLg0XeVFi2p+6rh+1EjC4qryUMZsSQscqF7XFOBUIGTcctIRln
   g52bg8oDSqlyapBPMtdBsWQ1WgVJQFnWOX+L76d5RKIY53/ohAtmiLijk
   0n3M8is+2MfctxfZb4swxrNUxaylKE1Ytf8XotgEk8RLbB0DdwxK05JTM
   aOURi4o22NLB6/utpuShGUd98W6MknVKCZH1coNZa9LJxBhqB0AMuDnqu
   yFTXfYYs8aUP5SXeOCq1N62+JUQnvcT0PNg0priSc5PT8hBLKRFtUWcZU
   3d3IIx0Tr1f9JUxeKzHGHSYd7VMlDRdjoixBDmHjm62y5TpUxF+A8nSJv
   g==;
X-CSE-ConnectionGUID: 4x4zJ2ufSFO8IGShOZWl2A==
X-CSE-MsgGUID: vORgF/jrQYW/m89toW0kfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446095"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446095"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:00 -0700
X-CSE-ConnectionGUID: GErc9IwoS5GN23U8c7WejQ==
X-CSE-MsgGUID: 2ixS5ZyGQCidoS2ikKjWUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285399"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:43 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 06/21] KVM: x86: Add fault checks for guest CR4.CET setting
Date: Thu, 21 Aug 2025 06:30:40 -0700
Message-ID: <20250821133132.72322-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Check potential faults for CR4.CET setting per Intel SDM requirements.
CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 799ac76679c9..c363f7df279f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1173,6 +1173,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_call(set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1372,6 +1375,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	kvm_x86_call(set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.47.3


