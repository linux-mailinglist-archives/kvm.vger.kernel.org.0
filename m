Return-Path: <kvm+bounces-43215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4468A879E9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 10:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDB4C171457
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 08:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D618325A338;
	Mon, 14 Apr 2025 08:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kS96/vwx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA15259C84;
	Mon, 14 Apr 2025 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744618300; cv=none; b=DxAKT4rzInMRpYkd9lgm4epzOXnWrq0MzH3YooXy84zSTtNqSv9bosUiiG4givzRnhExbqj7845E71Hgt8jYy/rheVcBTsTQ4XZVRQoKZp54vd5fF2wUaKmKkrn1ZIOrtZbenfyUvs26d2wyiGSmxNL8klQITDA11ZP/zenqiKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744618300; c=relaxed/simple;
	bh=M0Px4sQq0Ua88FTGip8MlAZaR44q/swxW1mcn7Kadw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENopIlI6TCQdiatfiGXgghdMheFHde9qjVEQVN7Galz7zO5jIPmyJ13vdnmU3xXO7wWyckc87BjSHhEUKfv97GmoIjndxYmZj9EH0QxvH/5FGhtloOi7Ab8a6hShlTNGwj/kW2hrnJDQCz0UEKIJDydefzNmiwvUEUNSTvboY0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kS96/vwx; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e686d39ba2so7335047a12.2;
        Mon, 14 Apr 2025 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744618296; x=1745223096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQLehcjcbISmim2iPvDB9cValC6G9pjc/biEGN2jZVA=;
        b=kS96/vwxcVevwCv35sjKfGua8bCo4JrSXScINfk/xRBabcsKkg62CGlk28taiEbc1L
         jdyoByJSCpwAvzs1J+1Z2lp5M7ciHFyKxRPZDKg4/EsJ9kfs5Zuk52MrPh1wMctlQusm
         9NTFNVyzLUGieANuY2QV0bUOYxfcovkFhdgsqC2v4COOy+W/g4NuwNmKDB+UJyRD/7RT
         wpBvsO7/IhGOMx9Bxl4jZCehWhcscQduPtnA0iqQ2RM+26sWqFDIOJjkN29BdxP11/4C
         Ffi9mizkJQOsVyshvl6jrvnMSu1N9jFCP/0aT2qbky5YAZHe7lwZrH2UHkTe/WL1iOzW
         ZCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744618296; x=1745223096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQLehcjcbISmim2iPvDB9cValC6G9pjc/biEGN2jZVA=;
        b=OA9OWp+jSTxRHUJ1o+7WDoO01KjjmI+ysYGnQG9S4YKqpFtO5oBqC4xz5yvQzDkfgf
         3EN7tgmXdVHDza2Enw4+eq3yj8HCsQxRNFSANiMbxd1d5xIu3UxN3u3W5p1FTjbcAUHH
         rDYhVi/cQroc3lbyuvF50KXa2VjGrfSgIgqfTy9DFrVMR3XZE8d69/cHHyi5yGXtl48d
         HYyLEgIl2eX6jmkk48YJq6h92svVF0YOCG6pa0C1C1Ic/BCJP6g+Zcsb7y9ePzOTg/jY
         Fp7coztzjJMJsOskeeacZEc6ujXJgziwQixdjH4XeTTomXgonMmA9Md+B4K2XRxf6XX8
         VeAg==
X-Forwarded-Encrypted: i=1; AJvYcCWyg2eAg+Y7tvJjv9JDhldNX/WQY6ulpACB6xDaPAe3n1Krq7/d5p/pP6Qt/3Hd8VWGx0/fn5KOE8PC03Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvVY3RTAhHtn5Ar/zQryzJI4MH/8H3oUMLjqtBlhBw7MTzRFTM
	q5yzCOgyXvk8lvec37oddycrD6twNNwnWtKKxZZCFTjlSEjSLG1i0vad4FZ6
X-Gm-Gg: ASbGncvbNkuDvG0j17BBVcOxt855PMgryrI+VmA4ns7Q99walHp3f9024Ce+OugHNOI
	cKmvKCgge8LEl5hjLS/Jrx5APipxc8IQPO/JO9K/HaW7xTcElqBZw1VLZWnLkGGIZFidISJLUlO
	vS/dNDPreDt1Hp9sBQ2FD6IRGANRTQJFNCH596OaieB0LwoYLCrLiquC956sP5DaAtalBHcpGLX
	VYLpuW5i4E5sjFlVc49cMuoJiYQB/kTuFw0iQy0WsAekI5ahJdGYqGSmQB+8Xb/30oK44P85Jzo
	texLqdVilPiOUTk5TvTaEUUKU0JwFtD7
X-Google-Smtp-Source: AGHT+IEt0SfgVcxAhqTlfRSXKOZHjazMKmKgeZnwLG/vZgN0qwUdwA1UDhLWRkFlgHXABhWiZx1p9Q==
X-Received: by 2002:a05:6402:2812:b0:5e5:cb92:e770 with SMTP id 4fb4d7f45d1cf-5f36f77ffdamr9859194a12.1.1744618295711;
        Mon, 14 Apr 2025 01:11:35 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36ee55212sm4435244a12.9.2025.04.14.01.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 01:11:35 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: kvm@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/2] KVM: VMX: Use LEAVE in vmx_do_interrupt_irqoff()
Date: Mon, 14 Apr 2025 10:10:51 +0200
Message-ID: <20250414081131.97374-2-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250414081131.97374-1-ubizjak@gmail.com>
References: <20250414081131.97374-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Micro-optimize vmx_do_interrupt_irqoff() by substituting
MOV %RBP,%RSP; POP %RBP instruction sequence with equivalent
LEAVE instruction. GCC compiler does this by default for
a generic tuning and for all modern processors:

DEF_TUNE (X86_TUNE_USE_LEAVE, "use_leave",
	  m_386 | m_CORE_ALL | m_K6_GEODE | m_AMD_MULTIPLE | m_ZHAOXIN
	  | m_TREMONT | m_CORE_HYBRID | m_CORE_ATOM | m_GENERIC)

The new code also saves a couple of bytes, from:

  27:	48 89 ec             	mov    %rbp,%rsp
  2a:	5d                   	pop    %rbp

to:

  27:	c9                   	leave

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kvm/vmx/vmenter.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index f6986dee6f8c..0a6cf5bff2aa 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -59,8 +59,7 @@
 	 * without the explicit restore, thinks the stack is getting walloped.
 	 * Using an unwind hint is problematic due to x86-64's dynamic alignment.
 	 */
-	mov %_ASM_BP, %_ASM_SP
-	pop %_ASM_BP
+	leave
 	RET
 .endm
 
-- 
2.49.0


