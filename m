Return-Path: <kvm+bounces-7935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB60848648
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 13:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C51E1F223DB
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 12:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D275DF2C;
	Sat,  3 Feb 2024 12:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="ooj5B2vV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417A5D902
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 12:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706964361; cv=none; b=KxjD7pvUdQlhhJxQnknSLerLYqYx/8w2r6iz9Y8Ix9hHxvfvWiYOQnbg1RhCrjt6bbZlThx8s1/PHKNO78PkioT8zsGA3Rtv+vXecM1YRIhue+dU3ChA6II8hvUCAG3kL3+b0xd+7Yq/Kuulp2RpWTT+hSHmpbC/u8dNlqmjSls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706964361; c=relaxed/simple;
	bh=25rp9n2B2HiuMlBHXHSpXOP3K8wAuEP3Smlh+qkb//g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sw0xjdXGj4aiK6cREsuKV8Mk0TLCwwVD3G00KGoMUBIu59ek5l73NrvFfosjPaTCIo0znnfjlMOIV9Pppi9HTiwiEIVsTi5wtLCxNam/pLqnrtjo6S4oeyr96X/Xef9IazoVdXyE52o5PKHqa6pYvm1Xjhb2v49yqkU4hASEmyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=ooj5B2vV; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5113ab4ef05so1248889e87.0
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 04:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1706964358; x=1707569158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldiXw6iKTj6ew0H41N2nrtPVJNRJtpC6kz2Ut3MX0fc=;
        b=ooj5B2vVwS8VjDDfvJjaQcJ+voaH8hBglnnkc0fD+scGo//g7h2dIkdCqz627thmRL
         2mQAzHeocedDutGfAMDEZvTHG0JmjWinUSlNYeg341ISMTJyRjB/3tcWzrpcsVr8MbY9
         KQSBp0r0pjFTdUIkzpkzOvumZhjb/2UHPf6Q3GpdKIf5cPSYmuuzBOQne8XmDsjInlle
         lO03wrclt8Xmj7d04N9jnWNBR+u8MAYd5iGcbxv0RufLgfYcAl3PeFEkkU89g/HbMfOQ
         cq6vhgMVji5hwz4yY2rADoSwMJnKbOm/r7lHqpFlzjz6xIYRcqMBrV8fUUn3+UuVkIIo
         U/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706964358; x=1707569158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ldiXw6iKTj6ew0H41N2nrtPVJNRJtpC6kz2Ut3MX0fc=;
        b=ZHoPsJfCFwpA7Ps5Lm6Kiqwl5cAkKaj6pEFt+lUY+iNfCeKCHtxpFkZBPosH6Vs82u
         wkz0Rj1EC5GlPzMRUdvQPhRz6x1RxP1qtcJSpra8bD/T4xIltmCsxAd7qAa+e0B3Lgx3
         taXP5o7DyQj+fl6XWGQT7+BdWEprvvdGWNi2d+Xtb4xTprZU6Zg9F+58xv4B1MjMF19h
         5D1vBijrG/m2/NcJPy3Amb8kybdkbPiDPaDINzgGt14zml0wqC2KH8th++EzaXbJIy0C
         NUtcYnjMhrDW2Zxus3eMew7+WhsvXoVw5bsHYXIhuPQHQB/oLSdASswyU+l/AA+m3cdd
         Mamg==
X-Gm-Message-State: AOJu0YwlUWgn0yQYMWgYxqNiwzK8/quD1d8BrapVlb0Tu3sGEWZieAcr
	Ut9G567DYBHFBj5bXdK5hWyjwIb2Cv5NRWlb3PlRbv3H+vZyiUS9mDPnF4k5GZJToCe0wbz2AIB
	x
X-Google-Smtp-Source: AGHT+IEOoWV9xJQtdCPkR/XkACG5CrGdZDfuhbpExBvDp7lGAp/pYEr6qDnuR5QGDUYqkoVclQEkPA==
X-Received: by 2002:a05:6512:2809:b0:511:2ddd:1aa8 with SMTP id cf9-20020a056512280900b005112ddd1aa8mr5946496lfb.36.1706964357320;
        Sat, 03 Feb 2024 04:45:57 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUH+pQqQ/YkFHBB9zml61DUxjA+C/8K9ykGo2G3rXkeZ/275Wz47t1h9CQEX8z8+T8ky9wEU3rZABB31IIoUZEGwVjKxevgRUURCHjN9tv54w1+xvKmK/OM7GV3
Received: from x1.fosdem.net ([2001:67c:1810:f051:d51b:7b6:cc25:3002])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906250b00b00a36c58ba621sm1942015ejb.119.2024.02.03.04.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 04:45:56 -0800 (PST)
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH 1/3] KVM: x86: Fix KVM_GET_MSRS stack info leak
Date: Sat,  3 Feb 2024 13:45:20 +0100
Message-Id: <20240203124522.592778-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240203124522.592778-1-minipli@grsecurity.net>
References: <20240203124522.592778-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 6abe9c1386e5 ("KVM: X86: Move ignore_msrs handling upper the
stack") changed the 'ignore_msrs' handling, including sanitizing return
values to the caller. This was fine until commit 12bc2132b15e ("KVM:
X86: Do the same ignore_msrs check for feature msrs") which allowed
non-existing feature MSRs to be ignored, i.e. to not generate an error
on the ioctl() level. It even tried to preserve the sanitization of the
return value. However, the logic is flawed, as '*data' will be
overwritten again with the uninitialized stack value of msr.data.

Fix this by simplifying the logic and always initializing msr.data,
vanishing the need for an additional error exit path.

Fixes: 12bc2132b15e ("KVM: X86: Do the same ignore_msrs check for feature msrs")
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 363b1c080205..13ec948f3241 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1704,22 +1704,17 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	struct kvm_msr_entry msr;
 	int r;
 
+	/* Unconditionally clear the output for simplicity */
+	msr.data = 0;
 	msr.index = index;
 	r = kvm_get_msr_feature(&msr);
 
-	if (r == KVM_MSR_RET_INVALID) {
-		/* Unconditionally clear the output for simplicity */
-		*data = 0;
-		if (kvm_msr_ignored_check(index, 0, false))
-			r = 0;
-	}
-
-	if (r)
-		return r;
+	if (r == KVM_MSR_RET_INVALID && kvm_msr_ignored_check(index, 0, false))
+		r = 0;
 
 	*data = msr.data;
 
-	return 0;
+	return r;
 }
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
-- 
2.39.2


