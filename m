Return-Path: <kvm+bounces-18618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 809048D7FD7
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 12:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A52671C235A3
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 10:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C5581735;
	Mon,  3 Jun 2024 10:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MTbWDrGW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27205B67D
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717410000; cv=none; b=BYrPCEB7GiTrVktSba3G3E6m3umcQGaOEOqJwj7vnhFZB+oO+lZlbr7P9XL3bjEoVzX6qba8bTvs4RgrihLOcHAaunGAkzrXX8XLmuAhg1yx0Os09qHO4FufsBCGA9QPoTWOxtlkMbiZ40JSnxV0kXE/Cm3FVTulnHBi2pBl4f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717410000; c=relaxed/simple;
	bh=eYs9EwKueVCziSjlomIXFIcKZGn7KpmKrs81zg6GMCA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h+Gv/hoPFMZ6xEMCnDp8tnB/mblOvK2qncO5GS7vD6VpdWBHx9vVweoBVPVBfZOpqxzC7zHp1S595vsqiAI/g2rh0w2616yxNUpXclnqnrKUbnIsli4KwBaMo0xgczik9HbzlsbGWGrsfuMeWXshE+oOEzeWMLhjDHulwU38shc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MTbWDrGW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717409997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rvm9Lt2cgPbjM1KTaqb9AOJc0S3MmgRjZt/lK0v4GsI=;
	b=MTbWDrGW/x6SxKYZ6JTiEAiemh2W/SLfvbq+PAhPKQFAkZvYy+FdVKyPfC0UWJJJY/9F+M
	c4t47SVnLU9yqu/cmTxip6fJF9i7RrJxqL3bhW4fdR8RRUxfDskK5puJnVSZeKU6pg5mPR
	b67/Agg0Ie71qLrDOrBX3T6UGuGRlA4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-zDguC8vNM1yOuH1Bi30JcQ-1; Mon, 03 Jun 2024 06:19:56 -0400
X-MC-Unique: zDguC8vNM1yOuH1Bi30JcQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a68b4937c43so111722366b.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 03:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717409995; x=1718014795;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rvm9Lt2cgPbjM1KTaqb9AOJc0S3MmgRjZt/lK0v4GsI=;
        b=qc1UxpA8Cu8Mlrav0NaNsfF1Mlv5p6L6x7H43ADCvfl5tc/NeKiST3n/XKkGR/D281
         7D4xz2gVRfJEfSBEbK2wWZpaz1354zO2z1mMgU8+5EMiu7zQfNtFFU9ikDND3G13OKlq
         qU9Q70aeEntTkv56KWpWBPFeiJRqp18jPtE3IN8eGEYuk1a+NReswXTmdEksGstAOfyu
         vMvef+0dlGPDWfhjO3KZKXFtxXQMJrWF1QTk5pLVefQWZgc5rLV9UKEHSo1OlYnC6lpE
         4kLvukwLOi34QQpgsD4i1+YEkQ0cNA6syLbMFTMnKiYGy34H3eq8cl8fqubo0r3Stwwb
         FTfQ==
X-Gm-Message-State: AOJu0YyqHxK779gkwAFpqva/oWLbWfK92M7RegnxRaAYhLSSPkRSyoaE
	QXqnOIoY8l8/mnt5PxUyIai+F/m/fLsm2d27r5TDbOemijVvJncKfvP6Pnhzhcl2HWpWcMWf8a8
	rLb2wb+jSiWideIYdgGdnfaN/ufPLyt/SIqg/cxhZFiYBGJUfdaEfawwy9rRLQDS4N9+nNnwTeS
	Yha5BywXpe7d5L0kC6oDLVAB9GMpc/OKyt3Q==
X-Received: by 2002:a17:906:35db:b0:a68:c9fa:f19f with SMTP id a640c23a62f3a-a68c9faf27bmr324999666b.53.1717409995119;
        Mon, 03 Jun 2024 03:19:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGACR4ChCaNSiOkoZcN7C/bqlii5bzUQkPPyZwB3sUm0sTorqo4K6+KKdEGgGDOau8wog1Q6g==
X-Received: by 2002:a17:906:35db:b0:a68:c9fa:f19f with SMTP id a640c23a62f3a-a68c9faf27bmr324997766b.53.1717409994550;
        Mon, 03 Jun 2024 03:19:54 -0700 (PDT)
Received: from avogadro.local ([151.81.115.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6920251929sm68487866b.79.2024.06.03.03.19.54
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 03:19:54 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] svm: make the interrupt_test a bit longer
Date: Mon,  3 Jun 2024 12:19:52 +0200
Message-ID: <20240603101952.621867-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When running under QEMU, a 1-nanosecond periodic timer leaves no room
for the test code to run.  Make the period longer.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 33b25599..416b6aad 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1154,7 +1154,7 @@ static void interrupt_test(struct svm_test *test)
 
 	apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);
 	sti();
-	apic_start_timer(1);
+	apic_start_timer(1000);
 
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
@@ -1167,7 +1167,7 @@ static void interrupt_test(struct svm_test *test)
 	vmmcall();
 
 	timer_fired = false;
-	apic_start_timer(1);
+	apic_start_timer(1000);
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
 
-- 
2.45.1


