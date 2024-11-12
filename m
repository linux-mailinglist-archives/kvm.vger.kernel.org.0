Return-Path: <kvm+bounces-31643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 091299C5E42
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:06:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C10DC28196A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6954213142;
	Tue, 12 Nov 2024 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqR2b69D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A762076D2;
	Tue, 12 Nov 2024 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731430929; cv=none; b=I3YZEBxDv7oW/iWJN9UDKvjgMudgp70ZL6jdpfPH4dxfy7/BIuXToLkUuPwcrOSS347N7SKpYaN8wHT9cIZEM5c1p5Gowo8ckJGQpkJbPrbr2Eicxkp0Nrze76MB+oU3tiYAbArhKliCSBf62e0YgAsjkGSEbz8G2VsUpqX04Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731430929; c=relaxed/simple;
	bh=M7ma40ELUhNvpjlyWrEKeeikRjFdp5fR7WH70jTeKyk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=NxFgz03G1tkQT4dti1EHPtovam7dI6ul3OAtIl1V5cSuQdY6c6KKFBOo6tmbPuj8a9lKd4GqVuaOOUKIrJWxAMab9oDawkVepSgUvFhl6f8hNAP/UPpbWnnXiEyjHEw8NFdCOvkMyA0O1svqydF7G2VyjAexhNtB61Ej/MBuiSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqR2b69D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FF8C4CECD;
	Tue, 12 Nov 2024 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731430928;
	bh=M7ma40ELUhNvpjlyWrEKeeikRjFdp5fR7WH70jTeKyk=;
	h=From:Date:Subject:To:Cc:From;
	b=SqR2b69DC6UN/itpJEpDivAQ0WvaMssRwPhcspNX/mBkej8BPF1Rw5mvH/VmvJnwr
	 j+KBHXnB+P72BUU6kRisTvThNZzKNzsAZu2I8OCTS3ccQNp6RkjSGElf05GWaapgeq
	 GygTNfQq4WFPFD6HbZjFMM9L4k5NQWAg1/dt7wEPZ7rSBwYG9vhqmtlGPIDIqUUfDz
	 eeqo1aGJPX5InyoQIJ1OGBznqxkgIaih249umw8VFgNpHn5vOG1JG/kv90KfPl7/e/
	 C0IDVpeKNFSzaj+tFoySzfF3F65anDOQd9IrpLBAN9rXoCoD6W3AYFQ3D0MP1hzdPq
	 xhGAifx0T49Yw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 12 Nov 2024 10:02:04 -0700
Subject: [PATCH] LoongArch: KVM: Ensure ret is always initialized in
 kvm_eiointc_{read,write}()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241112-loongarch-kvm-eiointc-fix-sometimes-uninitialized-v1-1-7d881f728d67@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAuKM2cC/x2NwQrCMBAFf6Xs2QUT60F/RTzEZNs+bDaSxCIt/
 fcGjwPDzEZFMqTQvdsoy4KCpA3MqSM/OR2FERqTPdveGGN5TklHl/3E7yWyIEGr5wE/LilKRZT
 CX4Wiws1YJbAJt+HaX8LLBkut+8nS9P/z8dz3Ayn4i+SDAAAA
X-Change-ID: 20241112-loongarch-kvm-eiointc-fix-sometimes-uninitialized-1d9f543db2d2
To: Huacai Chen <chenhuacai@kernel.org>, 
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>, Xianglai Li <lixianglai@loongson.cn>, 
 kvm@vger.kernel.org, loongarch@lists.linux.dev, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2092; i=nathan@kernel.org;
 h=from:subject:message-id; bh=M7ma40ELUhNvpjlyWrEKeeikRjFdp5fR7WH70jTeKyk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOnGXfwfr9Tscn6wWXnZO4P13Smcx9d9U1hz6dpJIR7d6
 O+uszd0d5SyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJMLAxMrRt2i9n3hHp2hvo
 XGSinp6h8jmfeePJI7Jf+7KVrDn03zP8U2hUcJ74foXf4vOxe091zapQWOHgkC9zdz1nvpK9eP8
 CLgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  arch/loongarch/kvm/intc/eiointc.c:323:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
    323 |         default:
        |         ^~~~~~~
  arch/loongarch/kvm/intc/eiointc.c:697:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
    697 |         default:
        |         ^~~~~~~

Set ret to -EINVAL in the default case to resolve the warning, as len
was not a valid value for the functions to handle.

Fixes: e24e9e0c1da4 ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
It appears that my previous version of this change did not get
incorporated in the new revision. I did not mark this as a v2 since it
has been some time.

https://lore.kernel.org/r/20240916-loongarch-kvm-eiointc-fix-sometimes-uninitialized-v1-1-85142dcb2274@kernel.org
---
 arch/loongarch/kvm/intc/eiointc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 0084839f41506eb3b99c2c38f9721f3c0101e384..6af3ecbe29caaaef1582b1fbb941c01638e721cf 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -323,6 +323,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 	default:
 		WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
 						__func__, addr, len);
+		ret = -EINVAL;
 	}
 	spin_unlock_irqrestore(&eiointc->lock, flags);
 
@@ -697,6 +698,7 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 	default:
 		WARN_ONCE(1, "%s: Abnormal address access: addr 0x%llx, size %d\n",
 						__func__, addr, len);
+		ret = -EINVAL;
 	}
 	spin_unlock_irqrestore(&eiointc->lock, flags);
 

---
base-commit: f7cc7a98fb7124abc269ebf162fcb3a8893b660a
change-id: 20241112-loongarch-kvm-eiointc-fix-sometimes-uninitialized-1d9f543db2d2

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


