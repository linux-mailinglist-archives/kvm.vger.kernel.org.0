Return-Path: <kvm+bounces-32820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 025859E01CF
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 13:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E07E51690E8
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD53220C494;
	Mon,  2 Dec 2024 12:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqwL1oN+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D78204087;
	Mon,  2 Dec 2024 12:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733141065; cv=none; b=SCRWlqSjZqTIJbFymmxEYZmUBZGaMwxdVr+gW8Ju7IcRtejPWzL+EosLavQgYNFKFRswFeN4dWRTB+Bi9qLQrtadNJ1VyVh2iokurYBg+4Yv83+UMx6gQz0T+ejd1qo4X7EPOGg29Fho3K0V72MmYLacRaybSe5sOre24sLhbyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733141065; c=relaxed/simple;
	bh=iG+FWqfHcVRBreJM9nURrF5EK7KuHNIEuynzkO4KzW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8Vff4vCN3Kre90/K5AKTdZi7lM/8mJzOotVnb+shrFb9KjY8bJ34RnWYSBHtwALA4rM2fIMOXnDvmt6GmklqncYEFnD1xjVi6kQh6yGJ5m5GfKGL/mvdoaUcz5Vzr0jQKrzkOXoL9TMw1aGjkwjkWjLCV7WHlH4zIN6yqmHW/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqwL1oN+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97E8C4CED1;
	Mon,  2 Dec 2024 12:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733141065;
	bh=iG+FWqfHcVRBreJM9nURrF5EK7KuHNIEuynzkO4KzW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqwL1oN+WwLYc0Dzmegjn47dyKTIs8ssi0Ib6fI0zcNYcutByMV/OBU/Vj88/VxRE
	 AtIpPNRRaAh01VK1eJHT+PsDSYaKTcaB0Db0uE/SUmcP25hPRhrekgsug1GOAGcHaC
	 rPd2Ec/+1Aghb7UgOjVfCI+YXdl+/VS7lAR9qZhgV9xSwkqzN+xJKWvdPu9sUf54Ji
	 3qYbkxlEEJIbqZVmVxKOpHHpztVVg2l8Td/G91D28jw2MlKX0sp4AIJ8Y+2Va3gG1d
	 v7I/ZSIx6p2gSIhzLwjNLpU+sZnJatKPy3uXrGR1XPMUi9JSt0KHWzuvyk7fcs/IaP
	 qW/gSoenXOMQA==
From: Borislav Petkov <bp@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	X86 ML <x86@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH v2 2/4] KVM: x86: Advertise SRSO_USER_KERNEL_NO to userspace
Date: Mon,  2 Dec 2024 13:04:14 +0100
Message-ID: <20241202120416.6054-3-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241202120416.6054-1-bp@kernel.org>
References: <20241202120416.6054-1-bp@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

SRSO_USER_KERNEL_NO denotes whether the CPU is affected by SRSO across
user/kernel boundaries. Advertise it to guest userspace.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 097bdc022d0f..7cf5fa77e399 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -800,7 +800,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
-		F(WRMSR_XX_BASE_NS)
+		F(WRMSR_XX_BASE_NS) | F(SRSO_USER_KERNEL_NO)
 	);
 
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
-- 
2.43.0


