Return-Path: <kvm+bounces-14334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D36B88A208C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FDC71F275F3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1995B29437;
	Thu, 11 Apr 2024 20:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b4ta8ONM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F174D28DCA
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 20:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712869161; cv=none; b=IXyWDEUg2/8/avVtL+gSf5H3JbeWgEwOQC6xvhaLNrg5Jl9nXBoszenb5/+4+p8S/0QBXJgw2fFBHNC1FbRd8k5ARkRPt40JsM/nLHzykyPXllVwkqu2Qh9/bg9xNvJsh+Vi6FtbeKrH9ScbnmJmZbZRClQymKvfxvIV2KlweLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712869161; c=relaxed/simple;
	bh=vR99g8mNTRiYJdlpafdj8u7Gjffk6aYOoefBxZEqiMQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tkUHNvKOe6PnWVIfC+VCBe9ak49mxTIPPEXm9rvsVdSv8lo2QZhij3SV3p+rb9wm1XNsuGYqI74mRPEHakqYPoYt8F2RLXHsueZRONloMXuJepnRfHGL+rfMETQAtWSYmCSkSUwJ5xjNDQ8qZ7fh2Y/ai6e1eJks+efplV31Yc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b4ta8ONM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a2dbaacff8so192014a91.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 13:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712869159; x=1713473959; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z/t9yt+wjV0kyHJCD1NRDqQJ2mO0T50Bz6dZJxesy/U=;
        b=b4ta8ONMbtv15xMYjAZyDcWfkUyQqSfUfUWCykhePqLFjJLrglDGUbK1UBWxEsXRfH
         K33GjwCG6FwXaK2dIBTYRspL5gFrkLKDM7CuCypdLBAOIHKiCAMYS+2kqZMFfpzo4NN8
         iczP3levPWRUuT+XrcpUTDl0FBYuDhY+sW5I3KsjL2s6IN9HA117vhXEzA057Rto7N0k
         rNuK6/eECztdMR8273Ovs6DqNgi/wZAv2NYoHHokFdDSIjIgItwm0oKGiHWqrD7LBfgz
         VJAg1JgMpzwI1TJfJKyv5FfcaPl/EYNdI116fJfbXaqxJYsVIANnARGRy3eIkaBgbG2X
         7ZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712869159; x=1713473959;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z/t9yt+wjV0kyHJCD1NRDqQJ2mO0T50Bz6dZJxesy/U=;
        b=IqcT8YNWzwWijEhwDr0McerBsSkFRfg1ULzSBRmlZB3ZGXNDF/hwfx/33GnOUfPRlv
         gx3MBscBLt3H2FU+5rn6pEynHTYKErMeDoYVUqC/Gv1hzeb8sOJ2HX9/1qS9ydyT69RK
         jN+DvKP9ck1M71XrkiFVJ8juemuFpBrQBl2poAPOp7lt4nhz8eO2c5sW/kTTeqjrhqre
         o69R++aMyeFZI/tAsHOl8G3rtxB5DFqyTn0Wfee1fw2lb2T7M2L07Tx7JgQkqpP6TpyL
         20VUFCvYFWSx3QtOHTplWllfA8oo/q+7e+ECNmBo1A+4fgKBUHrLmO3FdhqeIjmr2OHp
         287Q==
X-Gm-Message-State: AOJu0YzKtxsxlUUBRf5vkBnStNj3dhHQMgQysaNbYf6+a58uHf7mCLaS
	UOUCYqevCamQ4oQEQesMP1aJa87R1U+xEkM66dVbilO7406nTAm2itCqDeSbUmIdPzBaKqqvpbQ
	txgjwDZxP29nJCTSYtN7S7CmDDzy/husnOYEct/dls2T2Icj+tvj4ikPKNzBRcXcURJamnJYISF
	uiGSk9DJBpMzym9bQ728vkq9UhTTQ2mvatxwNeXtM=
X-Google-Smtp-Source: AGHT+IHr54fp6UFx/fJ4OhSWwpFKKFZ1tTaYYSu/IECnEVbCPGVtB+Xdp0wIN0vgSRIdQr2WFjLeAfVTw7imtg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90b:1807:b0:29f:f89d:f5b7 with SMTP
 id lw7-20020a17090b180700b0029ff89df5b7mr1867pjb.8.1712869159094; Thu, 11 Apr
 2024 13:59:19 -0700 (PDT)
Date: Thu, 11 Apr 2024 13:58:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240411205911.1684763-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
From: Jim Mattson <jmattson@google.com>
To: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From Intel's documention [1], "CPUID.(EAX=07H,ECX=0):EDX[26]
enumerates support for indirect branch restricted speculation (IBRS)
and the indirect branch predictor barrier (IBPB)." Further, from [2],
"Software that executed before the IBPB command cannot control the
predicted targets of indirect branches (4) executed after the command
on the same logical processor," where footnote 4 reads, "Note that
indirect branches include near call indirect, near jump indirect and
near return instructions. Because it includes near returns, it follows
that **RSB entries created before an IBPB command cannot control the
predicted targets of returns executed after the command on the same
logical processor.**" [emphasis mine]

On the other hand, AMD's "IBPB may not prevent return branch
predictions from being specified by pre-IBPB branch targets" [3].

Since Linux sets the synthetic feature bit, X86_FEATURE_IBPB, on AMD
CPUs that implement the weaker version of IBPB, it is incorrect to
infer from this and X86_FEATURE_IBRS that the CPU supports the
stronger version of IBPB indicated by CPUID.(EAX=07H,ECX=0):EDX[26].

Stop making this inference.

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html
[2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#Footnotes
[3] https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1040.html

Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index bfc0bfcb2bc6..66f2761b2836 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -677,8 +677,6 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
 	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
 
-	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
-		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
 	if (boot_cpu_has(X86_FEATURE_STIBP))
 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
-- 
2.44.0.683.g7961c838ac-goog


