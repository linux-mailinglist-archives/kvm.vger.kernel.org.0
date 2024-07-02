Return-Path: <kvm+bounces-20822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29F891F0CA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 10:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0F741C21E64
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 08:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C82714B978;
	Tue,  2 Jul 2024 08:07:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from chinatelecom.cn (smtpnm6-03.21cn.com [182.42.153.190])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14969146D57;
	Tue,  2 Jul 2024 08:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=182.42.153.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719907632; cv=none; b=oSVCo6IND2ZLlvJsBC2AMNdCHvBimoDZAgv0uzMGZMdI6Oyjn3Uq58vhEiYoRZ9nicz5XGzwVkX2oQuRvLKAJaxFTHzAPr6HZNw/xN6ItDo4CBtfcKj59NdL1Qmnvh2+IZAzZkldkDwfbpa059TxZkJ4GyyOOYICqR1Ry0ErsHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719907632; c=relaxed/simple;
	bh=92dFSfRbS5RmLRskRjZ2zcudhCzrBgOuK58ydCAwa10=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=deeUoiPLvmsv/me0QmnBtFXOBgfsfvvtYXD3QO4h+lpeCA3HrhOw0kNRWujaSifA4Zt2kr9OgVTBW4tlbpmN414b9Syr2GslRvNrawJ9pjOayW6+ytLAMqXagGfBs0sX+0pzDY0hay694zefMAB2msrOh+J3JalXoxMAXd122hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn; spf=pass smtp.mailfrom=chinatelecom.cn; arc=none smtp.client-ip=182.42.153.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chinatelecom.cn
HMM_SOURCE_IP:192.168.137.232:0.732275872
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-36.111.64.84 (unknown [192.168.137.232])
	by chinatelecom.cn (HERMES) with SMTP id 4E61FE3B26;
	Tue,  2 Jul 2024 15:56:25 +0800 (CST)
X-189-SAVE-TO-SEND: +liuq131@chinatelecom.cn
Received: from  ([36.111.64.84])
	by gateway-ssl-dep-67bdc54df-b7md5 with ESMTP id 303878b1da4b4347b4843b31d3a4b404 for seanjc@google.com;
	Tue, 02 Jul 2024 15:56:36 CST
X-Transaction-ID: 303878b1da4b4347b4843b31d3a4b404
X-Real-From: liuq131@chinatelecom.cn
X-Receive-IP: 36.111.64.84
X-MEDUSA-Status: 0
Sender: liuq131@chinatelecom.cn
From: Qiang Liu <liuq131@chinatelecom.cn>
To: seanjc@google.com
Cc: pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuq131@chinatelecom.cn>
Subject: [PATCH] KVM: VMX: Modify the BUILD_BUG_ON_MSG of the 32-bit field in the vmcs_check16 function
Date: Tue,  2 Jul 2024 06:46:09 +0000
Message-Id: <20240702064609.52487-1-liuq131@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to the SDM, the meaning of field bit 0 is:
Access type (0 = full; 1 = high); must be full for 16-bit, 32-bit,
and natural-width fields. So there is no 32-bit high field here,
it should be a 32-bit field instead.

Signed-off-by: Qiang Liu <liuq131@chinatelecom.cn>
---
 arch/x86/kvm/vmx/vmx_ops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 8060e5fc6dbd..93e020dc88f6 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -47,7 +47,7 @@ static __always_inline void vmcs_check16(unsigned long field)
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2001,
 			 "16-bit accessor invalid for 64-bit high field");
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x4000,
-			 "16-bit accessor invalid for 32-bit high field");
+			 "16-bit accessor invalid for 32-bit field");
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x6000,
 			 "16-bit accessor invalid for natural width field");
 }
-- 
2.27.0


