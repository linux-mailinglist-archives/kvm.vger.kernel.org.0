Return-Path: <kvm+bounces-25711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C13969528
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6420280D5C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996381DAC6B;
	Tue,  3 Sep 2024 07:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="inAxloYD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48451D54F2
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 07:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725347995; cv=none; b=b5crsgb6v/in+2LFyvBvGdrrzKXdZUQkdfE0koFYiq+o/n1+zShu0wsX+Jhcwkurbfgv92e7xQ95SzEn1UAfJseoAPHZYcnTf/GULsabIXW8L4ymN5qGBKdf+J8wrwNeO8LhT/rOOqRscgdCxMwweNdnoDtv/OSvfWQw7hsLGOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725347995; c=relaxed/simple;
	bh=hX20aXfXmOXgjflS88ieE5vPYkjvB9CjCF7KxLiWXZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hQ9KK1VaOsob43zuuiyUpQzL774DMy5lkFzffoLfWSu9v+XpNfnE7qtfPdJdDho0GDyB34KiOyUsKlc3SRyyu3HhOFTLyRWcdHdRf06r1+8ZtDaENpUP/5lL+24MCIZvJ7Tm94lugWBvN8nV01bh01quKor1snQC4wSWAeId2jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=inAxloYD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725347992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YOrLfsvwEiISGQ8ZVlVc7TwmstdfG5ZkvLyeiD+k0Nw=;
	b=inAxloYD69QopmOXlfY6AlVLmhAO8KKIOElBPuSgibocWg97qke+OEam5KLYk0vaZbPWgl
	tPLkpa58mEnt3C5CuKYw+687uS/YQuOFGUi3x+EgWjMyvJEJ31bt59J41Lab0kQ2e82nto
	/sb4nz26gXavlk4+lu0IDKAK6BPcUpI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-t6qIYjTFPciP4WFORnrYhA-1; Tue, 03 Sep 2024 03:19:51 -0400
X-MC-Unique: t6qIYjTFPciP4WFORnrYhA-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-71431f47164so5329463b3a.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 00:19:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725347990; x=1725952790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YOrLfsvwEiISGQ8ZVlVc7TwmstdfG5ZkvLyeiD+k0Nw=;
        b=Hj6sId4Ee8DZxTAdnz7/DCjJwvbcu0Kht69gNxLG2z4x7z6Uq3aU/R87yAY4KSHaRK
         U/x328ObRc324n4mJwF6pZTEoJMxunwQ/wRrB6KmvoA/9D1Foy1fC6/w3dTb0goJpbZc
         WwNdNGkPnS3z5Ei19oQimrfFE5GkK/PEHX59M/STUc8DTD7iurLlU/J9xaKkqKcCmmfb
         1l7xMhAtATSvDRM659G/gJLg+tjBINmsHOIetsXp4WQBro5GMarHOpYL0CQmC2QO3vPO
         ucnpYEHjcIVUkFPqM3WQioLWBDyB3vew6IoliLSvANQIcwPv89fcUuHt7yWUN9Q3gMYa
         wq6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqD6sc+hhXKwBpZ40qVTTCHpr/6Qe82SwPSfVx/dBeq31Xo4X3lyaGtkQGU69/8ueYuLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxexw3qWwBaLlgH8eST1hA5G7Qpm7/dIR4cypFrECkv9CHR06+
	mKHx3t1Y3WC/hke4lXOfT0oYIWPLI0odRwIu87vdyyAXZ2rCg2ov1mC1qyr3DWBG0D4ufsdJl+M
	MIiYAdIlygdJq0NvZ5czy6RFG8pSUOISD86MAoo6PelNQkzOumg==
X-Received: by 2002:a05:6a20:d528:b0:1cc:df9e:bc3a with SMTP id adf61e73a8af0-1cecdf31af7mr10436593637.31.1725347990260;
        Tue, 03 Sep 2024 00:19:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCtdTBTFQyE7fvIl3BTOHoJBqKRt6B/bdPcHyK151s5Dto+GOmrjnCdQmjQ+SgSc4wKXHDQQ==
X-Received: by 2002:a05:6a20:d528:b0:1cc:df9e:bc3a with SMTP id adf61e73a8af0-1cecdf31af7mr10436584637.31.1725347989886;
        Tue, 03 Sep 2024 00:19:49 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-715e55b9cfbsm8083651b3a.93.2024.09.03.00.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 00:19:49 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH] kvm/i386: fix a check that ensures we are running on host intel CPU
Date: Tue,  3 Sep 2024 12:49:42 +0530
Message-ID: <20240903071942.32058-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

is_host_cpu_intel() returns TRUE if the host cpu in Intel based. RAPL needs
Intel host cpus. If the host CPU is not Intel baseed, we should report error.
Fix the check accordingly.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11c7619bfd..503e8d956e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2898,7 +2898,7 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
      * 1. Host cpu must be Intel cpu
      * 2. RAPL must be enabled on the Host
      */
-    if (is_host_cpu_intel()) {
+    if (!is_host_cpu_intel()) {
         error_report("The RAPL feature can only be enabled on hosts\
                       with Intel CPU models");
         ret = 1;
-- 
2.42.0


