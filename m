Return-Path: <kvm+bounces-12545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F2B88777F
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 09:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C141282847
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 08:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41242D520;
	Sat, 23 Mar 2024 08:11:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58693FE4;
	Sat, 23 Mar 2024 08:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711181472; cv=none; b=SijNgqMh8mIMOSDOW1I8O0gTOJxDa1sZzhug/3qxy/hB3wodL6CgcgA9Ip/37xaz/Y36Z3Xz3g44bRkONvYIT5T55DrBpXieYk58q2ckOGXbbGY4IA5R47OB/CbEfk+w07Kdd5dx56yVG9LCJnDXUfMT/1bsuXpk2fvHANgg3cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711181472; c=relaxed/simple;
	bh=FQKFKIoMV+BXJdStkMqVeeMG8DIkHc11klM8n2DscHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MRe+J7ZdN1GTqu7sT+cU9rc++b9emh2g4eZHmvvtus/6q3nPgkYTTabh+gXY9n7SaPWxjo53oypI9XlauZJj2djjIWQhrhGLIhnIqQqA0qXoTdFKIstCtHwTc44Tv4ijuGtUMFJGlqEIRj5b5U3rioSy+aV2WevzqfDKc4oauUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from localhost.localdomain (unknown [95.90.237.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id C12CE61E5FE35;
	Sat, 23 Mar 2024 09:09:58 +0100 (CET)
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Colin Ian King <colin.i.king@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: VMX: make vmx_init a late init call to get to init process faster
Date: Sat, 23 Mar 2024 09:05:42 +0100
Message-ID: <20240323080541.10047-2-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@intel.com>

Making vmx_init a late initcall improves QEMU kernel boot times to
get to the init process. Average of 100 boots, QEMU boot average
reduced from 0.776 seconds to 0.622 seconds (~19.8% faster) on
Alder Lake i9-12900 and ~0.5% faster for non-QEMU UEFI boots.

Signed-off-by: Colin Ian King <colin.i.king@intel.com>
[Take patch
https://github.com/clearlinux-pkgs/linux/commit/797db35496031b19ba37b1639ac5fa5db9159a06
and fix spelling of Alder Lake.]
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37a89eda90f..0a9f4b20fbda 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8783,4 +8783,4 @@ static int __init vmx_init(void)
 	kvm_x86_vendor_exit();
 	return r;
 }
-module_init(vmx_init);
+late_initcall(vmx_init);
-- 
2.43.0


