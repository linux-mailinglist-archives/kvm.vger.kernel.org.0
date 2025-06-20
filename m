Return-Path: <kvm+bounces-50104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D76EDAE1EDD
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:39:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAF7A168BF4
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5182D5431;
	Fri, 20 Jun 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="QrnJ3QdC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975762C3273
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433961; cv=none; b=jqx4tgJ41GZ8q2c5yCkzKKx/+jj0M86Xdz8CjFJXR2+pO3Dkje/Rt5CTB+eiApdstE7DIfrhFw4snuk/QCQyf2X2pUWpTly909IVRSLnKElnlpG2xaYCQv3Tcl20u5qwb0tTiiHWZWlcKsvzoLENLyvggysJCjmobQCQHEQpUxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433961; c=relaxed/simple;
	bh=uT2PyoPJA6QWLp6uQeSHFl+5zcgpLCDgFyJdOEPtb0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0tmAq1N4pMBp5qgGmOonzhYq/lL9j3O14K6ZAEZ9b8OJQsR6UR3FEIl4XbyFW6pDR+V64O+raSx2wLedTK61IUo7t4fjIXYbeSkeVD1MNv4M4gbPUmuS2Rp/j4wfukomkfyZnknHJ6pcpOAxlh6TUWQZ/wUDdPGmPihh5kSjfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=QrnJ3QdC; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so1042471f8f.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750433958; x=1751038758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPBp6CpKf7mNo21Gfe21DBF7oSYJxBVkwjBiKX3BucY=;
        b=QrnJ3QdCVbJJOAiKNA8suk9WykP3O11xKESAXyI3/T6ThpTItU4itcu35YZqqqR8xL
         zy/S268FvPMLSKqeKhQl4pcoBNe0F0OdL6yr4fLsKGZyrAlWa0HxQJsPs497+hJjkcmE
         4e00VhZAZOGg5JmXh/udKTVjgBhOplXnA28HcREvUzcYwEet/hf0vwh+Kis2jzFx/ay3
         2y5LkJWctBhpYbm4Isgat6Q5K/3e22bTNqrQSr6Yauouifyd/e4f9bqyfJhF70QwkwZU
         +uWiWv5PXpduP2W499qbtro3BBHWFwd8cQ9jjBelimV/cYgi5EELKrdQpwbtkecDcoLf
         FuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750433958; x=1751038758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPBp6CpKf7mNo21Gfe21DBF7oSYJxBVkwjBiKX3BucY=;
        b=ddXZd4N9bKdK0w0SQQTpDkVdDUNorgyMUTq+nVvEKTmkHX9VKh5zbKaoZyCxBPHTKr
         tUG8rwwFz7cBJgVP+K5EXxapeCGN1HbWzOleIK+hn1xQq/Kv0EF/z7bKEiI90SVAEmVH
         Q5aARH8EpyP5VtNWFLfjgzXCtpSXEf+0Dxl0oe3svcOSGQUKqDS6Vm8x8ug/h6/6QWmt
         v1jJ0Sp7DNHsD36GQbRoPR+mOQFEbaAlvfiyByfe9pmtBRi0c5AsKUkKoGreTGZi6zsE
         4ntAt7P5BEM6Dqpwr9Ae8dimRMMS/hn7VMWET+VzVoS8U/f/0jGI++o3iQkO5tFzVBtN
         +a9g==
X-Forwarded-Encrypted: i=1; AJvYcCWWayUtgNaWVHe7wbLaX073JPA+we90Fm1n8FInPgUJKobpwDpMVG9iFvD+uDNrbxkfY8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YybgOFoj22UC14fVxHJdfXMc/rLmiFHMFXHkI33ufrCW58g/Ejf
	V6wyG33Y6tUPlGR812mM3lZKA2GlvaMLg67l/y9cydZu1g6yRgt+Eow6yCzQ+K8LfglJ3IYUpNw
	awnMl
X-Gm-Gg: ASbGncttSbMOTuE7RDgTzC1v7nFOH/L0D9lcWYX/IUBQ+9bdk4yia56b116/oNnuu5N
	Y/YGFn4/VF09+HzFHdPF7lJn03nMVH+G7N4OSGCHA25yBPP2olvB2ZhIrstru1NvLNL9Eq8HGeA
	1JSiltHDYoKe0z6dyNPW6O3g9JoOfqKV1QVzUHjYP4nWLO5TINE6PY50LpGyVmGGQwF3yqW/Z3q
	dLczMlZwQ0OykQTdWvn0FtKuED3HcYoMaWUt+9oAfjYSG7lmhvQsEys97GcqsCv5fabOUl/oXpb
	+XKt6X08hNNZKh/j0r+C96+y8/gMQ/NWYKYAyFyK6+tPjbqiey/Ghe+fglhescSm4DbI/BsIbRo
	8EXzu2sTJudxyTdw5m3oyIEkvJxbwif2C78fvue5b9IWjaOBe9ifmmo6EyCaswj30vw==
X-Google-Smtp-Source: AGHT+IFgrur7i5UDOI2b6hg/+JL8EkY4XK1QwHFBm8OJxX8WyEbaqjJw3yD7cadpy2P/YuGbKGCUbA==
X-Received: by 2002:a05:6000:290c:b0:3a4:e665:ca5 with SMTP id ffacd0b85a97d-3a6d12a09b2mr3095978f8f.23.1750433957923;
        Fri, 20 Jun 2025 08:39:17 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d118a1f2sm2323815f8f.83.2025.06.20.08.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 08:39:17 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 2/8] x86/cet: Fix flushing shadow stack mapping
Date: Fri, 20 Jun 2025 17:39:06 +0200
Message-ID: <20250620153912.214600-3-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250620153912.214600-1-minipli@grsecurity.net>
References: <20250620153912.214600-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After toggling the writable bit for the shadow stack pte, its related
TLB entry needs to be flushed to avoid accidental modifications through
the stale TLB entry. The code therefore does an invlpg() for that.
However, it passes the physical address to invlpg() while it should have
been the virtual one.

Fix that.

Fixes: 79e53994616f ("x86: Add test cases for user-mode CET validation")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cet.c b/x86/cet.c
index 42d2b1fc043f..2d704ef8e2a2 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -100,7 +100,7 @@ int main(int ac, char **av)
 	*ptep |= PT_DIRTY_MASK;
 
 	/* Flush the paging cache. */
-	invlpg((void *)shstk_phys);
+	invlpg(shstk_virt);
 
 	/* Enable shadow-stack protection */
 	wrmsr(MSR_IA32_U_CET, ENABLE_SHSTK_BIT);
-- 
2.47.2


