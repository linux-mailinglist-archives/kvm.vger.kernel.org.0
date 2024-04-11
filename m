Return-Path: <kvm+bounces-14294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A4DA8A1DD3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 068E828BAF0
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FD65916B;
	Thu, 11 Apr 2024 17:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmUYj1Qj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEC558ACB
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856596; cv=none; b=p9cBpqKLrG7u1f1Ks8axFFQ9FWiCde3OeIAYCPzLwwo2RLVjvrDR/RGXWeminkWU/fzfgGEfG+1mOlbDHTQPvBa5fJ9xZWG2MlfTrxAqHtLoXTQKSZShFSAgoTaGRFM3N9LWPFw5oQQ4K9KgjOCAoPXJKgiECZyEMjU6o7uUuVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856596; c=relaxed/simple;
	bh=88gJtq0OkvcmojJHKuQuZXaNWA06NnTqncW3Fz1vSzo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CaM6OpvP1mw9J+JWdBlmqPEYAZQMgMtGpiUZtzijTqxX++p5gp3WgEFHkfKjgWgM0EwyyeVnQv0WxcSv0H6Y9wN/DXlCqhuUoJQ2LB9FaNOxYrPiEGR2wUZTojc9EtM6oSfvRvSqxqj9HHY8hgoRXdYlqlYFmKqNECniw4ienSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FmUYj1Qj; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d895138d0eso189071fa.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856592; x=1713461392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4uIKw2A4OGs8ru8aalq3pVZ1hGdHCcAPLMgEflbcPUI=;
        b=FmUYj1QjucCZ5JIJ8KTfrA1o+Y1SH0V7MwByhFSrEu3usAe5+ENeGJ0SxatMAk8rhJ
         n7brtynCmbjwVzL+h+lZBTeV14tFkkmsUBCyih6ZHYjtcXdDuVvZugFADQo/T1+jVB9r
         7SdGeUF0H3JTigJMEIalrreBZiKPcyYOhKfmfy7Pp4vD5TGynnnnJ0k1V0yRQ6XVkO3b
         6CaxcUc5hzmhwW6m6bVJh/Da6z401dfJtHeX8i2787USnikIDF7STI3oOizeGjiyLWMP
         OQblunDl7nRCmzOTlO5PoUtXOCMQjkL41a/ecyMhAEoKRFavyAuyb39FAK2z6YhIimMO
         sXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856592; x=1713461392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uIKw2A4OGs8ru8aalq3pVZ1hGdHCcAPLMgEflbcPUI=;
        b=ax8DvRIbNF1LrACBUPz0fx2QxTc/014TGt+Sq7Iusk4rPJtO7unJ3dnS71mmLoAQkn
         ZTj+UrKfXxN5K5tt5F3BxftjNp9LsvYFFT1GVlJU5l4lWMTFZN88vRvug/HmFkMLlnD4
         eG0qj9dS1wNDaPIE5ZiGvfR2JDr5xSme1q193DJKosyJW68Ci54IWCzeo4oZXRqVOX+K
         pL0v/zy59MSVEdnuA7axzKjtnKnhDQjIJZC5ndqmnlxQZh2v4eGJ8Sp9H6YNVH3Bpjxa
         MTjI13EiNT+52JhRP2otfwtTyK4FQr32X1+mfiwup+VsSBaQOLPEjASVCVYKXK58WMZK
         kc6g==
X-Gm-Message-State: AOJu0YxibZ2Sjff1y7pBq6ZKWfHCp81vjuAnGe61hGheMMGnTVP1Dnug
	0W3H38VgA31mWF1SInq1N6ouVSZvSl70lZfGuaypvKFE2q7QF8t8/8GcsZDr
X-Google-Smtp-Source: AGHT+IE6m26yoXKbTD1GCj4eZ6Pommko2CRm7Y4p0rcfuJkdmEDKeUaYYP8qOuI7h4EVZprAEIoB6g==
X-Received: by 2002:ac2:5a03:0:b0:515:a733:2e21 with SMTP id q3-20020ac25a03000000b00515a7332e21mr193195lfn.44.1712856592196;
        Thu, 11 Apr 2024 10:29:52 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:51 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v6 03/11] lib: Define unlikely()/likely() macros in libcflat.h
Date: Thu, 11 Apr 2024 19:29:36 +0200
Message-Id: <20240411172944.23089-4-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411172944.23089-1-vsntk18@gmail.com>
References: <20240411172944.23089-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

So that they can be shared across testcases and lib/.
Linux's x86 instruction decoder refrences them.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 lib/libcflat.h | 3 +++
 x86/kvmclock.c | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 700f4352..283da08a 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -167,4 +167,7 @@ extern void setup_vm(void);
 #define SZ_1G			(1 << 30)
 #define SZ_2G			(1ul << 31)

+#define unlikely(x)	__builtin_expect(!!(x), 0)
+#define likely(x)	__builtin_expect(!!(x), 1)
+
 #endif
diff --git a/x86/kvmclock.c b/x86/kvmclock.c
index f9f21032..487c12af 100644
--- a/x86/kvmclock.c
+++ b/x86/kvmclock.c
@@ -5,10 +5,6 @@
 #include "kvmclock.h"
 #include "asm/barrier.h"

-#define unlikely(x)	__builtin_expect(!!(x), 0)
-#define likely(x)	__builtin_expect(!!(x), 1)
-
-
 struct pvclock_vcpu_time_info __attribute__((aligned(4))) hv_clock[MAX_CPU];
 struct pvclock_wall_clock wall_clock;
 static unsigned char valid_flags = 0;
--
2.34.1


