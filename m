Return-Path: <kvm+bounces-66522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D16FBCD7304
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 22:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B6F663001190
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 21:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC95732572F;
	Mon, 22 Dec 2025 21:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtG6sKD7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KbKTBFup"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0AD3081B8
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 21:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766438673; cv=none; b=SWtKhPOpCCTTj6ie5PgC25eyE0Myuen3dsAH1DlB4VdKhof0v2BbSbvghiCx83E6vvRMBvKmkIY+N7/Q01OKbZ+yVJ7Atjb6mDOU0z8u2yBhK2Yvg4vVDu9x+m1O3POHKOHcoPvoe1kLE2L2/fVQ2byN4HTed8TojKnh8oxAoHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766438673; c=relaxed/simple;
	bh=6G/rureTs/LIq0vCbBX7RFmJGZEJeM/iqvCu5gGIK38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cmxB24nwpJw69QUW2TIrGiBOKTbXi4/lqk/XpvtqQzAOY1LB3VC605gVBLogb5glcBNiUxTvNruGk51W/tUNA2Hni0ZtMirfOuVsWrS8B3ovI1dKL9tiQaVRN1JUBL79UK9hkNQX88rDG78Vne72287MeZEBYLWOaOjOhSw21PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtG6sKD7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KbKTBFup; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766438671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NTwD9UMpmb1CpesXI2JDuqyrvxD7xQACIpug7Oxl9n4=;
	b=WtG6sKD75NbMsrBDNR6wjYe01Zc9iw5YhkJEEGFP3gXSwPAwg1Sni22z6+3BVGJy5g2FQ1
	Omj5bB9EfseYg3l538z1kHLj599K7mCvwWQF9uvfmv4ftAuMs7MIQQHziR08NEipr9ZaZM
	l9E1Kv/EiOdGbBGfNxOZ9zStpP+xo+A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-YWolK2srMTuRivz3EmRvFw-1; Mon, 22 Dec 2025 16:24:30 -0500
X-MC-Unique: YWolK2srMTuRivz3EmRvFw-1
X-Mimecast-MFC-AGG-ID: YWolK2srMTuRivz3EmRvFw_1766438669
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477cabba65dso25182655e9.2
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 13:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766438668; x=1767043468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NTwD9UMpmb1CpesXI2JDuqyrvxD7xQACIpug7Oxl9n4=;
        b=KbKTBFupoEcCETUhLAzRLnoulKQbGfTxX93FmoQ9zRJYCiI21WzCnkyTSTwGwR3CYl
         6TnnCN7/PDd2vKvs/+of8vDv+cGrpQnA/CMqVPLg62YlY+sJeYGXspBvn3Pn3LdOon91
         3YeX1w3Jj8TXduPZnpayAcYSC3zmWS4D9KL5Xb/o43yOkYT7luUIysMvIls6NUn3aAJW
         O3g2rD8NluZfD1ibenWle6NxIsOBK2RWZADEspFEkopUgQVCHXT02qjQGBuIDH6DUblu
         I+hA/HHmTyqsjTJHaHlNYzt31faYPigebHWtgTAtqqUwgY+5pcfUWKWmyxoodI7RtzYr
         36Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766438668; x=1767043468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTwD9UMpmb1CpesXI2JDuqyrvxD7xQACIpug7Oxl9n4=;
        b=MeU4zqKUSbtnyy9TG9vVxtWnq82SyCQ7C//jlIPws02Ege++T/314AHpWExuKqndSt
         PR76uPxlznhPTkzhtastTV8ONqlZYzyBzMYAWDSixnAF+Nndn4kVo/HWH2FMMyAE363f
         1GMG8mVl5EsQ1XG8pOitQ2zxVw1cQ2fbeGqBn+gmRExQWYja7PnG13A+/IkbpBRaT8tz
         S9E1vCNaMxpnYKYIWDanyZeVvEJPJC4rY+mYrQWsF5Sc2UCO5nbUMt750nrF0wTr8v/z
         a6Ik0c+AZdPX0w0ZOKusF8+HOhOEbu2++a8+1w0mt5IdKd57LfILCcOzv7RiZ24FD2bp
         kPsA==
X-Forwarded-Encrypted: i=1; AJvYcCUlNB5CXS+WSzimxv/t9rQvtInAOh4uZUWHTM7t1ucbf5kgUjGbC1dPj7ehIStEPofZF1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ/O8O8e0+oeoXNnkS+nQApJgevsQexTXndnUh62cEb7iQxYHm
	qpGrH4Y4ke+SFf9aiwJ0Vy3rzxFB4wKysSCLeQW5naZMukrbead99DXVRPfob6xpBP35FrpAIlm
	B4jUM/quCZaFO8tkvPkQFiwul2zsP9zaS4IC17LZfWzgKvN1dWhwbuyEHcgav2A==
X-Gm-Gg: AY/fxX7RITsShqwE2BzP2+5sJfJoEpABcrtblb8gWLBC+3BJwa6RCtT1nBH8Ex4UDUe
	cMqn9Rm4xLYuCyFym5/Eeu0zShe9+9fGHM7FmC+81+C3HaV6g//ezLFofhNTW4azMie0d2XUdgz
	DkFdH7JQbHPZg7Y3l2QOgEcMoK3rjU/QBnswBmSr30MyJwc7/ShJgxa0uR52aQx3/aR0B01ckAx
	VtpiCCriZL9iB0U+nLqdo1B2ZfOo8fb2PcNvnU/Sczzf+rgJA2u5IaEzz7rDa4IDXc4iIXq1Ruy
	1DleeJBeF6CfN+kp12XGAtCyk2IVGZeUB7zQisU2ub7jigBRYFAUGpOj8QTSMSYPI5pSsVDs8y3
	q3CcaRkriHn83GBVkRk/+yxGC7S985uj8bxB8eyCnJQAkxPt2cff17OclvlPToRzubehSD8jKjC
	5otx1+xYyu6ncwC1c=
X-Received: by 2002:a05:600c:3489:b0:479:2a09:9262 with SMTP id 5b1f17b1804b1-47d1953dabamr129873515e9.9.1766438668043;
        Mon, 22 Dec 2025 13:24:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSvoVw1UeQgqipe3BnueWIKEomrH/EsAPO1d+tieW2DQB9Osd2BqZ+h7A/qPKJsr17yTIOng==
X-Received: by 2002:a05:600c:3489:b0:479:2a09:9262 with SMTP id 5b1f17b1804b1-47d1953dabamr129873395e9.9.1766438667630;
        Mon, 22 Dec 2025 13:24:27 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be2724fe8sm311947015e9.1.2025.12.22.13.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 13:24:27 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] x86, fpu: check for consistency after loading fpregs
Date: Mon, 22 Dec 2025 22:24:26 +0100
Message-ID: <20251222212426.834058-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fpregs_assert_state_consistent() does nothing if TIF_NEED_FPU_LOAD is set.
But in that case the FPU *will* be loaded very soon; move the checks
after the load, thus ensuring that they are performed.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/fpu/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index c802321acb5d..28d1d25f62d4 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -860,10 +860,10 @@ void fpregs_lock_and_load(void)
 
 	fpregs_lock();
 
-	fpregs_assert_state_consistent();
-
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		fpregs_restore_userregs();
+
+	fpregs_assert_state_consistent();
 }
 
 void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
-- 
2.52.0


