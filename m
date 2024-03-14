Return-Path: <kvm+bounces-11829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 837C187C43D
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B43161C210A0
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452B476056;
	Thu, 14 Mar 2024 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LOmi4FF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369D7317E
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447897; cv=none; b=bUCYcRqCMMfw4Ma8OZkDF66s/4tP1Tc4XS/7jXjGfxUJF5GFbxCaxfykBlJ7li+/+WqzZDJJnGhPDrLtD1/eiucNmYII+xJitRizoeVOBGAztwmwQoGfQUm4XAt+55UvpPejoz7Dw5q56vGjLR0HEOvRkD38iQ1vCd3dG96R1Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447897; c=relaxed/simple;
	bh=6/Yu0QDPKynolND3gmbYFuiviBU1OTdPkmZfwvNmj30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYH0z3l2Ce1ObMJX4dXYnAYRtjvKrmUHIkKs+Ycgh6tgK3CZlmmum8O2m3OeyHvy64c41dBwL/4DVEQnALk5VmSKw30J4uGJSUDWenm4g3NCvHTgCETXW1E7H2hK+1z/WGCWbw1QUt+W6lrJAXPM2QJ9WxmsnHADm2TIzegkd8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LOmi4FF0; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d485886545so5425901fa.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447894; x=1711052694; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xuCZTiMpeaXF4P5JXeYvn/6B04UPpdx+BA/DKeRB3B0=;
        b=LOmi4FF0sbhZNtmfvZo6/4fZ8u9zWqEUQBUdD9kXOTG/Mqh8jCGF+eJL290oFKVlbh
         6OBQg1sq36Ye2eyWGZPxyxRfyts3bdocrmOJPwuB/EKj/R5Sclp6nzfSdkAQO6i9HhtC
         LQ1M13aHrfvy4eIZowIVS9oI3bBXOjtERKAjDoCp+8EYIOjUQV2mcLaOQyRL/ScAX+cD
         UPqG1TyZoC57nm/VIJlzKAOEnYiUVrC+L+KB2VuP6ja8preWdoE2e5OS9EPbeTFytsCt
         UwG/8fdyYImAr+Y+4Ae00TDn+swd3loJo+3YLYliN5+/qysQOeSK7FXv1ViUmorjn6Xt
         0tIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447894; x=1711052694;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xuCZTiMpeaXF4P5JXeYvn/6B04UPpdx+BA/DKeRB3B0=;
        b=KnIS/zjQVwkg5K1G079aSvlbwau6x46p6D3N6F5l/tgwa5Qxcc8qXj1+bEXXALfGXt
         MmlASJWaPzVy7UlZNiBIPIQVVFdtUIyXbRO5W7VSPLJI8XQ2IaX852ofwAMb+Me5fPH8
         BgWZi8nS8gLYPgJL6BAuA5iarDHwHz6G5enu9Ut8v2uxnc+GXckuGzQyTK6BaL2KvG8p
         ia04a7DhPAUvwjDr8/aFBEEPxxT2skDeU7QYpTJAiku/9ETWF+ZIinu1iIS5lmmtraaY
         GFAGQuatZDCN5V+9bwT05XrUC9x3JDNj110GICKIKEwQhoY1WjCoEjxCLsHt33F+cN/0
         QPbg==
X-Forwarded-Encrypted: i=1; AJvYcCUIhWHCiWSc5YBswNt0hg2FZhTEzR6yGi63C/H+buii0CsFo46bGXv6yXxGGAe9kO82HMVltMIwlyBRc1r+8gfnoCvD
X-Gm-Message-State: AOJu0YwMvvWrQ2qeJ+Mvf+rP34zwbYbY4idh3T0qyxb0hMCORsBxtAnj
	YyXFNTiQzAiLhLJT91025wy81T5Fk4yGx189hFX1QUrRIAMdF01zSiBJ8kO15g==
X-Google-Smtp-Source: AGHT+IGdzgal9d7jECsheAve01ljHpLhiGK1mtn9v3Osy56JhBtqA4ZSO+j/CgBHoCEF6ku+b5RVYA==
X-Received: by 2002:ac2:4ed1:0:b0:513:caa7:3773 with SMTP id p17-20020ac24ed1000000b00513caa73773mr867447lfr.63.1710447893822;
        Thu, 14 Mar 2024 13:24:53 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id jy5-20020a170907762500b00a4675490095sm746999ejc.42.2024.03.14.13.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:24:53 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:24:49 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	David Brazdil <dbrazdil@google.com>
Subject: [PATCH 06/10] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
Message-ID: <e017fb72f9aef1de10cb958bfeda87496d3ee9e0.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with KCFI, to allow type ID resolution
across compilation units (between the call-site check and the callee's
prefixed u32) at link time. They are therefore not needed in the final
(runtime) relocation table.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
index 6bc88a756cb7..7b046d97b301 100644
--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -50,6 +50,9 @@
 #ifndef R_AARCH64_ABS64
 #define R_AARCH64_ABS64			257
 #endif
+#ifndef R_AARCH64_ABS32
+#define R_AARCH64_ABS32			258
+#endif
 #ifndef R_AARCH64_PREL64
 #define R_AARCH64_PREL64		260
 #endif
@@ -383,6 +386,9 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
 		case R_AARCH64_ABS64:
 			emit_rela_abs64(rela, sh_orig_name);
 			break;
+		/* Allow 32-bit absolute relocation, for KCFI type hashes. */
+		case R_AARCH64_ABS32:
+			break;
 		/* Allow position-relative data relocations. */
 		case R_AARCH64_PREL64:
 		case R_AARCH64_PREL32:

-- 
Pierre

