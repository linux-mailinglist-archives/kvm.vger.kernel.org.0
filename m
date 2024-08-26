Return-Path: <kvm+bounces-25105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AA7F95FC87
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 00:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A61A1C20BAC
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1321819D06A;
	Mon, 26 Aug 2024 22:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKsYxG9H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C725C129E93;
	Mon, 26 Aug 2024 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724710442; cv=none; b=bEwix7q7k0DGa4MsNJIUvK/OvaIqKjlOffLdb/ipIXaZ0OD+acSQ/cwzfcTxM5L9w2IYQ1LyLOEbqc5941TgmsoRzaUpR7crKxVildMhPRYY6PnBnirxHLoEuxEZ9Bm84RT2NMCY+bkDSpeol2kcK/tk395uOapc1U9AGX5Dkgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724710442; c=relaxed/simple;
	bh=Tw0FvpJeVTngT3MzbWoaiZUL246yALTdADNOAPtFOP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVjOd4Qj/qhekCQCq3ddTuwcc0EgyFmSH/cDYsifjm3JpT2hTvnnivr+VtsZzYn/kG3frRWo7+XsS7hCP3IPJUHE/IzeUuCHpKisM75+L9cukJS2phpjqQyKc5094HENT/gv7JdUpFHJSriHCbcHYshJIBxVJZRtzHL98KX/AZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKsYxG9H; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-498cfbc0b05so1701064137.1;
        Mon, 26 Aug 2024 15:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724710439; x=1725315239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oa9FJlzpzEnTWXFf9+QlmwJ5wNhi6ZIyOsCW5VlVcQA=;
        b=HKsYxG9HEPE0RAnqP/uQeGKRpx7EdPPpXzhTUjJ8LkDJ0W77FjrrtP4/qQl2bGxBLC
         GUpDGVCnMP4JxquCl+XGkW+b4DnfzAQa1Juz+w10Q/1d/rfcWR9TV701RxHmN725GqdS
         3HqTmuCnvdIQZJNG3r6xvHAl1wcb3yE3Em9qKe1HcYFEdy7vBzzk1AxV493XGsEXL/MH
         nm/qDxe073aPYFnKQZliOd5HrpuBJmkHn3ewFvm45+qsS2xEW0LRpcwKOsK/+OeVflET
         YjBweFkxsKiJXOw/Zhoczq3H7JQbFzd1/QtnAvd7pxcmEZWgyO3mk+BuhOiTBx+mdvEw
         9uyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724710439; x=1725315239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oa9FJlzpzEnTWXFf9+QlmwJ5wNhi6ZIyOsCW5VlVcQA=;
        b=cc1MuxoXuLZilsSXPkH2Fp7WAuDS2fWzGtdKFIcnmoNocwJZCx6kQqXrRbEqenx7oa
         qpFrb+LiUHztnsM3oT7wkieURatOR+Zw5tAmg8/FOFv+TDcgr3mpErKdXFnIixMN8WK/
         7mZ18w8NQ5hrOmKHBSSx1DH4oaaGLjFXcU9sOtXqww+8BWFr/BA2oJDeKOHW0Hyvdybs
         /uxVd+rQdumgIV4aLkyUdfn1bBm0ZebceFUDaGJ5qHCv6sO8roaXq8OrGsiSr7xhr6Jx
         /2iGp5D3Mbg6ICLZz4kZbfV+74gmlQDomUkLtn/HqC0NFwYknakKFL9FPssmz2cnBGzr
         vW1g==
X-Forwarded-Encrypted: i=1; AJvYcCVn8afaxS7qekPq0nT+X24fa9xOdnErmwz3Hchd4gjH1enCY70fp1Mk7klmhx6HchH/hnQOQshP@vger.kernel.org, AJvYcCXeMqMtVBKDAqYnnkdjzR6LGvWGYv6Nq2yxzqs8J+mFD2EIz/zeU/iGSdP43IwOyg+1Yek=@vger.kernel.org, AJvYcCXqA4TiLVD8esLjoh3vumdS3BcbMCEk1dcoNKRfvdc3fgGkQ08QAZMJY93zhaAyhIMrwJpgTalnKBgwi2nv@vger.kernel.org
X-Gm-Message-State: AOJu0YzvXRto1yYcCUKDaeMYBVZwsbacC4QIYq4FV/hS+bMFVPQfSLeF
	2GuTnzVn1rcoNU79UV2+euqk4Kgm2UdtiduVzT6ARXTuZNsB6PxS
X-Google-Smtp-Source: AGHT+IHRivxmUJjWFXCXdqLJ6mTW1JWGSc+v7TGL/GmPmcwd8ggh0Nkc8m0JxdSTqTbYcI1ZhbAdWQ==
X-Received: by 2002:a05:6102:50a6:b0:494:2c2:e2c6 with SMTP id ada2fe7eead31-498f4b3636bmr15112941137.7.1724710439549;
        Mon, 26 Aug 2024 15:13:59 -0700 (PDT)
Received: from localhost (57-135-107-183.static4.bluestreamfiber.net. [57.135.107.183])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-498e479a7bcsm1416446137.4.2024.08.26.15.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 15:13:59 -0700 (PDT)
From: David Hunter <david.hunter.linux@gmail.com>
To: seanjc@google.com
Cc: dave.hansen@linux.intel.com,
	david.hunter.linux@gmail.com,
	hpa@zytor.com,
	javier.carrasco.cruz@gmail.com,
	jmattson@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lirongqing@baidu.com,
	pbonzini@redhat.com,
	pshier@google.com,
	shuah@kernel.org,
	stable@vger.kernel.org,
	x86@kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 6.1.y 1/2 V2] KVM: x86: fire timer when it is migrated and expired, and in oneshot mode
Date: Mon, 26 Aug 2024 18:13:35 -0400
Message-ID: <20240826221336.14023-2-david.hunter.linux@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240826221336.14023-1-david.hunter.linux@gmail.com>
References: <ZsSiQkQVSz0DarYC@google.com>
 <20240826221336.14023-1-david.hunter.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[Upstream Commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2
From: Li RongQing <lirongqing@baidu.com>

when the vCPU was migrated, if its timer is expired, KVM _should_ fire
the timer ASAP, zeroing the deadline here will cause the timer to
immediately fire on the destination

Cc: Sean Christopherson <seanjc@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://lore.kernel.org/r/20230106040625.8404-1-lirongqing@baidu.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

Cherry-picked from commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2]
Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
---
 arch/x86/kvm/lapic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c90fef0258c5..3cd590ace95a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1843,8 +1843,12 @@ static bool set_target_expiration(struct kvm_lapic *apic, u32 count_reg)
 		if (unlikely(count_reg != APIC_TMICT)) {
 			deadline = tmict_to_ns(apic,
 				     kvm_lapic_get_reg(apic, count_reg));
-			if (unlikely(deadline <= 0))
-				deadline = apic->lapic_timer.period;
+			if (unlikely(deadline <= 0)) {
+				if (apic_lvtt_period(apic))
+					deadline = apic->lapic_timer.period;
+				else
+					deadline = 0;
+			}
 			else if (unlikely(deadline > apic->lapic_timer.period)) {
 				pr_info_ratelimited(
 				    "kvm: vcpu %i: requested lapic timer restore with "
-- 
2.43.0


