Return-Path: <kvm+bounces-18286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8E168D3615
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E07A31C23B57
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D25C2181321;
	Wed, 29 May 2024 12:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1dtoPQOG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B618C38F96
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984878; cv=none; b=OAtJUj+praEx1fHH9KN4DUP/ZSEPjmgj1wQMxqIeCznbteKRpTlUNhc4H8pG6OoIrSFynwL9HNo4I54p7DMkhCMIM69J/UA7ZSeaNhLTU6hQG3H/DtylV/PxFQtYR7rK6aVVshyqIN6h2EJ8p+EXw3AlXLAKQokQZyCLKbgKIwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984878; c=relaxed/simple;
	bh=n/Rt+Z7/h3tKGyTZQjuwoohj1Dyd6vhk6ULQqnGfhKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VFgu0Wt077YEG3pIEqHb+zWiIdPPyy+nDVDfWW8Ajx2PzHCDY3uLJx5D8ziB00EzvZyYxM+c5xuxErf+gxFCV0ouh7NtQYRZ7Kkvoo8OLhJyjKx8gadjpVDw8Pbh38diAcIB/aeHFY7IA6jaW6PFjjmSDb5lhALjg0otjB+byWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1dtoPQOG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a083e617aso36991057b3.2
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984876; x=1717589676; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j4Rf2lfhPQdW0ulVQ+ZkbOO+HrzrcUNTk97aD9mbPlw=;
        b=1dtoPQOGx0us4ztHO19Zc/WhMDdk2YIzWcWJNNjTU6a+GOYfkU6rngTd5TvbFC4joe
         PvM8pJl8wIn2Y/LPxSNOkGzcFktirJs+7k/i/mzAy/5x+MR51WPw0I3Dq897NcwxBCcP
         EDrifxhqKtqFGsidk/aLYazYoAxENQQF1tRFTuIjeAs7HThOtYwC/25vtm1vms+V6311
         zn4rIL0WL2Jn0DIXuNp67oHu3NY74I5cGgvSxtkOR1+WKklrsYS8sOI5wasO6+G2ahBF
         HBK0gUgAhMcyRwXENKhUWCvMqookGlvGy9T5nwailwe+36AiekQkBAFD2hfG7nyOFlo6
         e9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984876; x=1717589676;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j4Rf2lfhPQdW0ulVQ+ZkbOO+HrzrcUNTk97aD9mbPlw=;
        b=XxMflCtv4ydK8FICa8SlT3UtgXVyTQ75op5zQrWdOCTCCoSa/r+y8Age6AWBMAiwbO
         rxWFP0oS95D62Tigy3TjO7FGiM3F2K7sl+FRSlDwEqkz+5FIK18W0oVz9mzWXUEOVbxf
         rsLMXeb+/0dKTyvakWDu9mKg+Ws0csb6zLhSsNNs2JGcTU6cC7N+msFF/lGtQzVF12BB
         lE2dVIC6hfnofpQIcWJRH0q4VD5nD6aMxNOqAlPWXJlOpc9oTX5biQKARB4npVpdJHWu
         nhuLCkrYnvG/2QdJnWoq+xXIfNFGY6IMhRtdi7B9mryxUlT0tag54kMJLG2JkvYuASix
         pMRA==
X-Forwarded-Encrypted: i=1; AJvYcCUOctBksDY6ucApl8wG8JQ6dHbMiWZEmDfafW0wLF2Fw+mloHOWMAGwQSpPJZKCWZj9d4i8/3wi9resnSjp0PjKJd03
X-Gm-Message-State: AOJu0Yyiphxnq3rDPc1o7GmrdGIDA0khYVlD4sIX+XhLpfo8lVvPm0oh
	giz9g7cRgEeImhQgqTtEWoiJUyEsIZNYyCg3HYfvrVyWgmPK5ce144v0HuSbRh3O+oQVJd31Ug=
	=
X-Google-Smtp-Source: AGHT+IEkdZ2CPDm5cYVOhM4+XL1fH8AlLKI24Mx4NO3l+ssr5tA1I25II+Qs22X8PnruQU2dGz49CMMUxw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:f0f:b0:de5:4ed6:d3f3 with SMTP id
 3f1490d57ef6-df7721df7cbmr3593228276.6.1716984875835; Wed, 29 May 2024
 05:14:35 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:09 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-4-ptosi@google.com>
Subject: [PATCH v4 03/13] KVM: arm64: nVHE: Simplify __guest_exit_panic path
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In invalid_host_el2_vect (i.e. EL2{t,h} handlers in nVHE guest context),
remove the duplicate vCPU context check that __guest_exit_panic also
performs, allowing an unconditional branch to it.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index 135cfb294ee5..71fb311b4c0e 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -197,18 +197,13 @@ SYM_FUNC_END(__host_hvc)
 	sub	x0, sp, x0			// x0'' =3D sp' - x0' =3D (sp + x0) - sp =3D x0
 	sub	sp, sp, x0			// sp'' =3D sp' - x0 =3D (sp + x0) - x0 =3D sp
=20
-	/* If a guest is loaded, panic out of it. */
-	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
-	cbnz	x0, __guest_exit_panic
-	add	sp, sp, #16
-
 	/*
 	 * The panic may not be clean if the exception is taken before the host
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	hyp_panic
+	stp	x0, x1, [sp, #-16]!
+	b	__guest_exit_panic
=20
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
--=20
2.45.1.288.g0e0cd299f1-goog


