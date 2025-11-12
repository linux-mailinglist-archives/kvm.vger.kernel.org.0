Return-Path: <kvm+bounces-62917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F45C53DED
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:14:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 61FBF34391E
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4082A34B191;
	Wed, 12 Nov 2025 18:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F3X58444";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YLhX5lcM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B222347FCA
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971254; cv=none; b=GbYOYIg2fLe9W2stcNkE7/j38Pwhp3Oh76JyKpvNKNu5BVNr9HzojQ3myLVDC3HUuBF0K7pwxLp97rwh265tYmEppJpaF4PcIVYOHVcALCBsaSqg48YeLf0bUFIRNVZwe4lRVOI9h7BYDviHHLFMVfiyxecMSFdMRLt9puWSH4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971254; c=relaxed/simple;
	bh=5Yb3X6PZiKols/sQXmoknfK/pTPbA3jLRfEhVBUsSgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm69TNFzgYV9cQ3AQCjWknm0CStC9RLrag3vdSp3Oqm884Pfq2LSS5dii9JxwCRZOpqV07de6g6s7Car1pi8BWdSkNtcF/quZREcaEOClEoMwpLzg1WigrRJy03NrWPwC+sMBocdPJHhzYZHxekCr/BIm3mE/bRNfuSV3gyPeoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F3X58444; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YLhX5lcM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762971250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
	b=F3X58444+vydgcbylzWQlATIdR1va4Vs7emMsR19yAD7gABg7RCCbT8wxEt9NL6s3VZp2+
	tFs0ITEN6WFOHGuNfg++325jMCHumDKJG2JpD+C68d4xbyps3jD+HQP7QQ1EPd8YW7nF5y
	R52s6Q4+k9+ygNE6/XTbr2zf/+NL060=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-Tvp2SVJsNPeOJ-M3k7Wb3w-1; Wed, 12 Nov 2025 13:14:09 -0500
X-MC-Unique: Tvp2SVJsNPeOJ-M3k7Wb3w-1
X-Mimecast-MFC-AGG-ID: Tvp2SVJsNPeOJ-M3k7Wb3w_1762971248
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47778daa4d2so9676375e9.2
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 10:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762971248; x=1763576048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
        b=YLhX5lcMXJWAYwN8dyyFYtuQ9ANrl+pg2fd834s/7xb2+7WJRqJELDlB8jwsD+FcKX
         j5prfbC5J4IKplfa5TChjmUpq7jtbQSOtyxg6Cm/Q/2DGgea3OdX0bMEUrsNJUm/lu9E
         g/V4VLqkPSV34f/1YgzVFSOT+Pj7nB03GrTfVPtAP1COpQkqwykzYFdV6hq/I3EMUtQb
         0ARNWiS2q/P+SzQ+BuYFb8PflOGTnvmeK16JNEzmbYa416awqzXxDdcgf4l/yCjf7ERj
         /ss2rjrSO0lakWv9uD8iJ99cUWnHr9uc081bHhEVUh3P2PX+IDSt6j28vO74uerfGBxT
         +2xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762971248; x=1763576048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U7+Ad1DQku/KL3b7bCdX4+uTWQCvm0tEszy834Ayws4=;
        b=jELWvW33LNqy0a89CRQfsAtj0/oHliINXcv82q1RE2CAxHEJWoy/p3tmTwyDbVB0Gw
         EwirTVnXOkpaflWQfHzGWBaB3wVzUeOfDE3eMWYeOVCEFhRvDadjoJvZ8A6Uzol4Vl/p
         eRxPnvEbEvj8Yp758n3JyBdDLzU/56MI5bugaJy9kgFz87kMoS9jZIJnvS4aEsIYbnEV
         eM+N73SOI52p4I4/E3+fkKIixqkCJ0PvOjhIcJaURpHsbMzlmFIXO5ZAZm5sekLl2fQb
         8c4e+3lNXnj1z+J6R6XwbYES1YomJT3a2Mh/8w+K3Df6ALYHvwVgJaJuL2zAG0pAJaPd
         KBJA==
X-Forwarded-Encrypted: i=1; AJvYcCUz7XHGW84b/C3RhDvvUr1syZTVpSIK64vKBF447fj/v5PMdSixe7BC9iRoQon3dep4xQk=@vger.kernel.org
X-Gm-Message-State: AOJu0YytthLwd2+OI2qbNzWnWZR0aKcrWG6Tdtm3gu2mcywhJlaMUKKM
	j2ufcte3K0aizoujKr7H+22f/FS/wF7xmeeNHHAnRDd0PpwlT+DRUULNT3YjZiW8mMejRvEm48v
	YWLWqcYSb6ht5IlvqDaR2kpS7OJjfiLRGQad4kmZ4tEeoTUY7KiL9BFYxhFYWUA==
X-Gm-Gg: ASbGncsUpqLXLhOxgrmzpMjbHZdDzp6vfvT5fZkKj6+A7WfY9OeCSohAgehR4tj4Wvx
	ap8h6JmDfHieqNQ+Dq+VwL+jkpI2Sw0FDyY8m82eCehWf5Hurz43m0VZhr5L+jhrGarIeTNbeI5
	mykSSfQysDbCpAVmR0EbGOYjtrat7ARQALo5MeRHOqZK7ta+VfxEpNAAczj9+kh9B0tmG64vVHz
	u3G1sYFrcMS7oPACCKbDTJ/BITYzuLkjLNk1Bru0yIMUh2kF3rJzZQ6B/j7H3rsEt1y3WCrclLw
	Xetsj5Hlb6HXP3SOF+/2bsalo5K0aH8zV6esKbRbKuUdIgl4bxyBTLuNj1GdRtMAfriqg3IaTDd
	pcnCGu9p5HSMggncAhdOi6IwYvjfoklBEuxak2tIPYTNi5kuVI16m467+SoaZrA==
X-Received: by 2002:a05:600c:1d0f:b0:471:16e5:6d7a with SMTP id 5b1f17b1804b1-4778706ea91mr33694095e9.13.1762971247847;
        Wed, 12 Nov 2025 10:14:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExx7YrdQI+IydYpEMMuMdDOGxLo8j/rSItSIu9aQs64pFfJY+BoQHkmXgSTSSwlx02YpTuFw==
X-Received: by 2002:a05:600c:1d0f:b0:471:16e5:6d7a with SMTP id 5b1f17b1804b1-4778706ea91mr33693785e9.13.1762971247394;
        Wed, 12 Nov 2025 10:14:07 -0800 (PST)
Received: from rh.fritz.box (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e51e49sm46851355e9.7.2025.11.12.10.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:14:06 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v3 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Wed, 12 Nov 2025 19:13:56 +0100
Message-ID: <20251112181357.38999-2-sebott@redhat.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112181357.38999-1-sebott@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index 54ae5da7ce..9fba3e886d 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.42.0


