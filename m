Return-Path: <kvm+bounces-47748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6270AC476D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 897877A4C60
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 05:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335441B4F0A;
	Tue, 27 May 2025 05:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="wjRfKXCn"
X-Original-To: kvm@vger.kernel.org
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2434323A6
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 05:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748322916; cv=none; b=E3Vem7qviIHbf+nCMvbkAK4w5BTNhI49T0DU5jlB6lbCdv3Hnf+z+2X66PoFGqG0kZVxccWTnLO2k8cElTqR0e0dIrR6N24N3AkM7f3K9shX8qeOFiuTEt5cPM8NvyZ1JmEHOZseuT3Dufl0X00xEkXsjyf+p/XJVUfGv6qDTi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748322916; c=relaxed/simple;
	bh=iIhYXxZiXzP1nOmODNSrHuhwjAVawSq7mltuOEeOpLI=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=OwtcdsGC7k9lMzQ7O4J7hn7Yil/YB5ms+sQjkb7E3PEOE9W6ChEAe2uAexLGqGaym6YjPjVVdhGczNviBqE/oKesUmYIpFktbH8EVwoVNZTdRGexzHd4WMlnPILRRDnLbnN9VCuCEu9FGMOM+w3N++hlMrwUn8NNHObwEAzvJRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=wjRfKXCn; arc=none smtp.client-ip=203.205.221.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1748322603; bh=HEP8M2++02Q2nGa/KrIRO1wnBG+GhLuBDildhfq5FJ8=;
	h=From:To:Cc:Subject:Date;
	b=wjRfKXCngjRXqp+ywIRjx8z2qtAAItBDjYKH8BQiNrImtxJyzi0uaj7Ij93rfnNIb
	 qBUb/E8zDaOBI52T2cctxolgRQNCg0Cmo3+E1TS7Yf6fMMi5DC+Cmfx4lR/GMwc6IV
	 Df09posjfeQkCFxPUN5feu9Czj6KWeqS24jPZeHQ=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.228.63])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id B5D2FA08; Tue, 27 May 2025 11:45:29 +0800
X-QQ-mid: xmsmtpt1748317529tcvff8lxm
Message-ID: <tencent_27A451976AF76E66DF1379C3604976A3A505@qq.com>
X-QQ-XMAILINFO: M3vv73qU6a4uejIKGc9BXxeApuz7c/+QvRfcumYJyl+UYV7/OWQkZ+N1K7rnJE
	 IMb3bxs0SYYtEEtlJVuZZtCuMOHB2fY4tbMAB6brpaysGwS1n178ja3qMOB6/dYbAntTIQxhyApR
	 DfdZfWF/hb7UgL2kqhLuW4oeBdUgsR9/wgrLIxHukiBYDrvvLFgxFitIN5aTm84XySybcwnaEoOC
	 r5N4szUYp9vhGrTbINdh94ZGYt2eaRGAEmeDAUcUiyqu6GH+605vnnjxNrvd5k4Wo2Of/yPxX5IH
	 YQao9JY2yQHM5XwqOxmwHiie7xuNqzY1aX2NK/za05icVhfjRtMIk/sRNHZZydJMH4qZjIu74FKo
	 MhxNbDeP80E0k2MJJVDY3EjXsLTfKDKyUEAJtTR7B5YgjW0GSbLcdqsfuebU8Z7B3GKMr9st1QSY
	 25RcUP7leAT9M5/WOlV7/1T/CvQMbJULCwiS2som+ccSNcCrVZopKhEn6buHML8JPZHGdB/YA6CB
	 9D8ss5s7YiSEwTLx/9Zvi9dVNqTHzvuDg3Wv/SQgQmfUK6GVqmxV0J9kFNl0s12xfnQG+8D0nyZN
	 eOA6azqfbCpRCtksOhqHaKMT7YggejLBR9Gf4gfgGo8WQ59A3sD3wwbxS70ZCucUpCLfGUdFgtSj
	 NAipMmThc2+ya6JXEFSd/40sGtfwhjS4kvfUIBK1CbRfx8T019dS9OEO3pRUQ7kmzhA2J805fV4Q
	 t0CT1nLYXTn+JiHazHx1f8wMWC9l5cpFi7AzNyEp1XJoMPAEoCBYSjPqfUvp3aS6G0AASXyTRdGK
	 +ac+MGSc9ZgUX0STx4UAuy1XxrBCLz8LoEt2HzwcJ9WMVZqwhbLpqh3mX4l2OGoAP/MvNNqd/n4W
	 rLyqI/v16tafQPnHyTDRoAlZ60+oLSlX6NQE+cr2nU9hj4YY3UOvAt7iJVam8r+Q==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: seanjc@google.com
Cc: pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	binbin.wu@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH next] KVM: VMX: add noinstr for is_td_vcpu and is_td
Date: Tue, 27 May 2025 11:45:16 +0800
X-OQ-MSGID: <20250527034515.1569758-2-eadavis@qq.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

is_td() and is_td_vcpu() run in no instrumentation, so they are need
noinstr.

[1]
vmlinux.o: error: objtool: vmx_handle_nmi+0x47:
        call to is_td_vcpu.isra.0() leaves .noinstr.text section

Fixes: 7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 arch/x86/kvm/vmx/common.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 8f46a06e2c44..70e0879c58f6 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -59,20 +59,20 @@ struct vcpu_vt {
 
 #ifdef CONFIG_KVM_INTEL_TDX
 
-static __always_inline bool is_td(struct kvm *kvm)
+static noinstr __always_inline bool is_td(struct kvm *kvm)
 {
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
-static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
+static noinstr __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
 {
 	return is_td(vcpu->kvm);
 }
 
 #else
 
-static inline bool is_td(struct kvm *kvm) { return false; }
-static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+static noinstr bool is_td(struct kvm *kvm) { return false; }
+static noinstr bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
 
 #endif
 
-- 
2.43.0


