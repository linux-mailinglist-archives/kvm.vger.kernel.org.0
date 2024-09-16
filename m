Return-Path: <kvm+bounces-26978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3FD97A00B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 783A5283E1D
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3136E15B561;
	Mon, 16 Sep 2024 11:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5bqhJlQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE7315B119;
	Mon, 16 Sep 2024 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726484978; cv=none; b=m9OZFgnXIS6tklPmfn+vcqszrsB4/xfmzdzgjyC8bW5RDwswYXV6r1Vv/MUL6diweGpnQdOnEvSY8z/v5b6kHWkmzqdqL4Rw4QCDkyW2M+I1lvpJOMpmL6L97LFMCF2PPHs3TwmWwEYC5+uAPktLCe3bWFe1MeaS9PmfwExQ9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726484978; c=relaxed/simple;
	bh=ESu+Y3NLrw6nKtLSnksNQ2p6EDkLCi+HsWc7u+Z6WTs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=djCGzwUolaej4h4JoGQm52mo/x/I9NyU/zCHUQrOEz89/5PUAY9GINtXqnwjfO6zV2CVTGIblSy4AQYLXEcrASIuFGhK7QXIB/heAG2JJwchbbN4LE5PcHXPcC3iRCzfwNy6KO7ftjq/0QDDqsq8oX4878vtY6tj3+Qzpu6kcNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5bqhJlQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7718C4CECF;
	Mon, 16 Sep 2024 11:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726484978;
	bh=ESu+Y3NLrw6nKtLSnksNQ2p6EDkLCi+HsWc7u+Z6WTs=;
	h=From:Date:Subject:To:Cc:From;
	b=l5bqhJlQQGDTcvead/WTHbt1AguDOLjEIb1zPTeDP1V2TuiM+cO1ZpHqDNhcB2w2I
	 XRLikS6azFs4aCk+Jfw4bqhRaxmTTTiYgPM8qYwre0pf1UXsvFEmoSzThC+dLtyNtE
	 8NVnV0ptk/lJAqx+cbS+8fIHeakq2IWV3SgEDak1s4J5U6rGjKhovkDcTos9icKzyy
	 uD4aZxg6RhAmnn1zEgeJrlYv9OWHaOM0GDH7OuvfHBAEYoFKjyu/yWcZAgX+OiBLYE
	 +o3xtoux9IPvhlqMGIhn40tDYBXfaY3tGb1eIc3dL+P7WNkMKaioQM5hxQMlQpX7R5
	 iUpgudL+mAo7w==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 16 Sep 2024 04:09:31 -0700
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
Message-Id: <20240916-loongarch-kvm-eiointc-fix-sometimes-uninitialized-v1-1-85142dcb2274@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOoR6GYC/x2NQQrCMBQFr1Ky9kOSilqvIl3E5Ns+bH4kiUUsv
 bvB5cAws6nCGVzUtdtU5hUFSRqYQ6f87GRiQmisrLZHPZgTLSnJ5LKf6blGYiRI9fTAh0qKXBG
 50FsgqHALvhyIzfmu+yHYi+lV674yN/3/vI37/gNDAhrSgwAAAA==
X-Change-ID: 20240916-loongarch-kvm-eiointc-fix-sometimes-uninitialized-e17b039d2813
To: Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>
Cc: Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
 loongarch@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1823; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ESu+Y3NLrw6nKtLSnksNQ2p6EDkLCi+HsWc7u+Z6WTs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkvBD9+zKpiZPCZ9I318oWF/9dznjG8xRNy+UXEmtsXz
 r0WE+3c1VHKwiDGxSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAm4tzDyHCF9b+/u9pko0j5
 3efdSo19y8SrfVMTP8+1WDyzTcnuxCWG/6kz3h9I9F/OYHPYKF7j05o9YUWz73/V/r4wQOpGiMF
 UbX4A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  arch/loongarch/kvm/intc/eiointc.c:512:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
    512 |         default:
        |         ^~~~~~~
  arch/loongarch/kvm/intc/eiointc.c:716:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
    716 |         default:
        |         ^~~~~~~

Set ret to -EINVAL in the default case to resolve the warning, as len
was not a valid value for the functions to handle.

Fixes: f810ef038c66 ("LoongArch: KVM: Add EIOINTC read and write functions")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/loongarch/kvm/intc/eiointc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 414e4ffd69173dc248ba0042bed3bebdc11700e3..e5d23f0da055c97c0e4ba6705f6b71d89846f42a 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -512,6 +512,7 @@ static int kvm_eiointc_write(struct kvm_vcpu *vcpu,
 	default:
 		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
 						__func__, addr, len);
+		ret = -EINVAL;
 	}
 	loongarch_ext_irq_unlock(eiointc, flags);
 	return ret;
@@ -716,6 +717,7 @@ static int kvm_eiointc_read(struct kvm_vcpu *vcpu,
 	default:
 		WARN_ONCE(1, "%s: Abnormal address access:addr 0x%llx,size %d\n",
 						__func__, addr, len);
+		ret = -EINVAL;
 	}
 	loongarch_ext_irq_unlock(eiointc, flags);
 	return ret;

---
base-commit: 357da696640e1db8fc8829a4dd1bb2d0402169b5
change-id: 20240916-loongarch-kvm-eiointc-fix-sometimes-uninitialized-e17b039d2813

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


