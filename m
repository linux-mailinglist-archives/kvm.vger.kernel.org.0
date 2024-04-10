Return-Path: <kvm+bounces-14089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E36BF89ED9C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 835FF1F228E1
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77C313D61C;
	Wed, 10 Apr 2024 08:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rIx5NfK5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6937A13D529
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737762; cv=none; b=aksLBhs803wMqrFhRK07vV7h9bEtd2OY1Arfjra/dIRwYyJoWqNEXrrZ1rX1l9+lu2hVGXdgZY3gzKj3I6HjxLfhbu0IQctziLoEfrEQdvQMhAaUSktldMEuqS9ZxDjuwvKPbtV0G0Xfqz8H+q7FsWYPeAY41f8ZRjyPZVN/WuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737762; c=relaxed/simple;
	bh=1xy8JEBzmCvsE0c+vyvVtF1ncyFT2iUpIVYsycSUaUc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CnVDlmf9SbRV0o5n3F7yU1Q6h6OxOptTrOCQMcnX9mdwfy9flQbajKgFVy/k9i9hRmeUHnYT3REseHa/aMRXUMkXCB4p/HTtMLe+9QEkpQjqygsVwcR/x5rxYI2xF4GEVygEfnFa8Wpd6eI9+4jeaHy6vUlEr5o0Zn8lFYT1uvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rIx5NfK5; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-56e37503115so4608340a12.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737759; x=1713342559; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jh/NV6yW6K+2G6i6rK3aentqLTJHJAzofXzqiefolM=;
        b=rIx5NfK5fG9LF+7iVfia4KKbZkGkwrMXBBs2FC1nfdSZolZghvyizLzRD8Inlrq1cz
         s2MpLX0cNKwKwMeyr/BdqHNK9KnXRCv1z2cgF93IFU7ZtZQP4tEmjaq4ZUkDdCBW3KsH
         +VGE2X7/jT604DeCa3iwUkcAgj6r5LNAE74yAGJnWGrr/liooyrQKvrE7C8rkPp+Mvt6
         jkide+dzewojjTPUdTMpLX+enKh/eZv18+MBTgS79Mw601KtMr5CEmXzQOt32uZGbzdS
         414crS3E5xv3dmWf2DbOJFBcTEn0PEWDSdqmkw/VeVl3Fax7mR6KW59MLgV7HwR4g9rf
         TkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737759; x=1713342559;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jh/NV6yW6K+2G6i6rK3aentqLTJHJAzofXzqiefolM=;
        b=ku23I/yE/QThNgdrLYBhSu+sNN2qNQWYURZxxvIznycBnYmM3xVRB/k8y8lNM6wcRn
         8mSedUrpsUcQYLrk+eoJ+oc0bwCWifs8EWes/NWAab7d5fxCk/K/xs4ddA2RZb0gGL3T
         qEYSB5bcHQsDCmFndUlF8K7xZFAy1fECkgM7zyQQycmvtHfTq9qreFVETo6eVCmgDsUk
         SyMS7lP2vQq4Syr/hCHRniHtBwbkeH7eptF5s3zS6F8sJleHoIAT+j81NxclcurfZM0I
         FNkXb4F61l/DYi5p7TOFvgNmKly6DBd53mi+MTrsk0mhiSRhUs2s1PLIbhm8Cw14Jahv
         SoUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUi/luD819P6nLBkzTT1bIVNSUmaed9EY/kVtROaVJmue1/SBRWQiXOWY5CfqCBgYTeg/6iijBd5j9T7olAn5AwBnZd
X-Gm-Message-State: AOJu0Yz73Md1k7e94XEB6KIxh7X8OHXS5LAYrJOWxoViaAhLQnM0zAbW
	JhGIHamWEu2vcs4+3nK9n/NsjLGV5pdm+yzkMfNSS/fkHs42nc78M6lItfonJw==
X-Google-Smtp-Source: AGHT+IHhEhDmwBmoCNwZPINWnUcQxwKkJgql9hzsRwxXum2LL0s2QGfma9Zc+wwW++uYiLm7gJA5pQ==
X-Received: by 2002:a50:871b:0:b0:56e:219a:b49c with SMTP id i27-20020a50871b000000b0056e219ab49cmr1074195edb.32.1712737758727;
        Wed, 10 Apr 2024 01:29:18 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id ef5-20020a05640228c500b0056e74af55e0sm1558489edb.83.2024.04.10.01.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:29:18 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:29:14 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 07/12] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
Message-ID: <7f4fsc647ve5c4tn5wxosdrss2iqd7fsgmdx3rha4dvruwyi75@kc5yyoyaw7iv>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..9db04a286398 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -301,7 +301,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -326,7 +326,6 @@ void __noreturn hyp_panic(void)
 	u64 par = read_sysreg_par();
 
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
 
 asmlinkage void kvm_unexpected_el2_exception(void)
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

