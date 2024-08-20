Return-Path: <kvm+bounces-24569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F26957CC0
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 07:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8887C284B7E
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 05:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F8B1459F6;
	Tue, 20 Aug 2024 05:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hIxa1VWY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B63E1862;
	Tue, 20 Aug 2024 05:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724131957; cv=none; b=IBis/cjSm5PdJHTPZEe0AOYHWh/pGsv1zko+GwH4lttXt6E7/AIRXzoSk6JUseuOtn9unD8HmHUV0juRFNS2N2y80SZKz0FVO3aMpGkJILLtFM4JCErkr7A4PKPP9YHDV8uk6Kw3R2FBJNUKAi7DoPd5khcH52dZ4dx9BDbLSjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724131957; c=relaxed/simple;
	bh=fzafTY+hMgu+Mmsh1SAc4j1kBbrC7lh0Ogb3zZdXivc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e9v9ZrGutDv+Weuwi6kaeQjWuA701EiV/pZTPNV0/MT6KxtTG04we7GlnZI7xfAtQ9+pGvfAd64Nnp5QJMi37A7StpSN/CDzzhdIIaK8mPVajfC4Hm6mWwvyMCGiQvZ6bXe6AZnRkhB53n1QIoxoQNOdrQMR+KU8cqBdadPSzUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hIxa1VWY; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-49294bbd279so1847775137.0;
        Mon, 19 Aug 2024 22:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724131955; x=1724736755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i6QfqVruNv0KeYjR1T2Xi8sKHkpHxg8Q0ePcqumb5I0=;
        b=hIxa1VWYHH0mgxTWHzxLCVhDir30qLsZ/yQQ0NnpDCzbXTJ66sDpruAgp/zxqX/D4s
         kCZsz2a/eqomc6cbXYkLV1tCLMhBW9LNDJY+ko3KOUfsVj1Mt1Jr66qhC/wsoZd/e9dk
         1IJUhG+an3ijLCBmrfYRQw9FHN2H9YuMNigpNWvKMfrg46q/9hyjKk3/UMbACV3sEV+z
         TExEEHyC9xOjjIPeDJ3GiZsz53WEhp20MO2B+s8qnni/ds8EyYK54wneBkOiXCK6qTpl
         G9HEoa5c1RJ3Ua9bTQd7xRMTMtnxezXIAXzDNvwCXJm1GLIpa1aMZQnOY3daqtWpPvx+
         s7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724131955; x=1724736755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i6QfqVruNv0KeYjR1T2Xi8sKHkpHxg8Q0ePcqumb5I0=;
        b=C5KllHDkwBjsM1PrqjivsZnmZP2+R8NcyNjO3j4k2gQzlKvaDXZ+BoAwsZT4r1asrw
         oE+/uxG4EUGeWeL5lMAyJSVPZkYXRyDf3Rh16QP37jIZvXjYAxpcH7AnoIOK5qkZzVs1
         cvd2fvNV2Ut23jizs6Z2jLifdh8j6kTL06RjrbAg34t+40IBCjTGlJ9ugq0NGwpIFa+q
         0xYWvp4vdvSkt5cIQHCO08qF16ZNMmLvEHiTb56mzEgy0sv3TW2rWHWLXORxBTWh/GtH
         zS3PPV6SYqgu+5k1Ij271bdSm6FEA8xvV06iFsiMG9DFau+ezLL+FwWOz3Z7fPq3C9BT
         Ewew==
X-Forwarded-Encrypted: i=1; AJvYcCVt7cy6vzU5ZwhJ+nuVNlxaQjLOo9caREMxBRmOKeVYUl1Z2qRLLOIIm/HZj1j5oIfnYI3rITKjqCf6IwVoq6TINcEeaTvT1GnjaOCjBMnoNY6fIRajp8/x4upMLuaef8ff
X-Gm-Message-State: AOJu0YxLsa1lBUJh47LGnNhRHheI52VrO7VyGEtdmSxG+CvZcbI90ezo
	/+pL6irvWHdS6ag+NqCtUSuYYuN7NFNRjkPAM+Gh68zZd9OiMDeXp8YvPuHkqro=
X-Google-Smtp-Source: AGHT+IFJDEiZQFdQnB6vuxIC34BX3BZcDCcfpLYE+XFHrNvR7Th7DV+B5/CHTpV28VWGDBTQx21Scw==
X-Received: by 2002:a05:6102:3ece:b0:493:b9f8:82f2 with SMTP id ada2fe7eead31-497799e4d64mr15948858137.25.1724131954628;
        Mon, 19 Aug 2024 22:32:34 -0700 (PDT)
Received: from localhost (57-135-107-183.static4.bluestreamfiber.net. [57.135.107.183])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-842fb9c6015sm1431092241.26.2024.08.19.22.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 22:32:34 -0700 (PDT)
From: David Hunter <david.hunter.linux@gmail.com>
To: stable@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	javier.carrasco.cruz@gmail.com,
	shuah@kernel.org,
	David Hunter <david.hunter.linux@gmail.com>,
	Peter Shier <pshier@google.com>,
	Jim Mattson <jmattson@google.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Li RongQing <lirongqing@baidu.com>
Subject: [PATCH 6.1.y] KVM: x86: fire timer when it is migrated and expired, and in oneshot mode
Date: Tue, 20 Aug 2024 01:32:29 -0400
Message-ID: <20240820053229.2858-1-david.hunter.linux@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li RongQing <lirongqing@baidu.com>

[ Upstream Commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2]

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

(cherry picked from commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2)
The code was able to compile without errors or warnings. 
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


