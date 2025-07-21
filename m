Return-Path: <kvm+bounces-52981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C10B8B0C579
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 271F83B22FF
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 13:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288002D97BD;
	Mon, 21 Jul 2025 13:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ClIATNId"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26E728DEF8;
	Mon, 21 Jul 2025 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753105674; cv=none; b=fiIfsO1iSRvF6JMDb/v0YbIJpMVYeARPd69UIoy7vBmtBsc9TSf/PU/eCi9V7/o9y+uk59HihZ9OHiRX1rZD3RA/GiuGrNP4LpADY0yis65SFSlvx9WevJYRYGaXV+CVJQrEu7p15p2YBdwtOEdIyWZvoscPHq5mi765EU9wXEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753105674; c=relaxed/simple;
	bh=snX18aDYSvAH91XhSukRAOqm6JoWRvWJexQUe37VrDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CqLRLsnzeiSI1aR0m9HVfPwnKi5EFDpykzcPQbm2obrZWHr5Co1m84hqiTtcijKy17jxDomyuUsOEQ11oX/YrQ6nU8uEQ7O6v0J2AzQCABLnrdTiga7DF1hKG895bZPYRhzadt+dHQWu8509NngYQb+O0EiUESwymrlpRWKQOOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ClIATNId; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4561607166aso33396855e9.2;
        Mon, 21 Jul 2025 06:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753105671; x=1753710471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6hMXoajRPcYgGWtmfvlTWE6SJ+TgIseUsXmG90VOgUM=;
        b=ClIATNIdBqMYk3XzPyktVfzYHgoT/6BktdKC6N1lc7SFYAIgUuT3vgy2uchISYNEDh
         PmUAftIujT8tSItUdUw5raQ9uIqhy3GiqR2D7+V5aJoVx3YLUu3iYZ/l1fMziJnG1YqR
         KxgUqWL2ZC2uU+N8J+oMdVPMtZe23ToPdfMf1twQxYqWun1MFzx23Ds0HaqPenV/dkqs
         uo8XA+pcTNWdB21pVVrKlQKN3aZ6C+axArE+ujGOq+37Xh3AJL1kCD/Hmo0zug3ZapcC
         Jio6Bj9jUgZAGvmRgjfSnz3lF1HaIZCnq2ofid/1DLOnHQQOyMUaDoLpTncWfVSS+jQK
         r5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753105671; x=1753710471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6hMXoajRPcYgGWtmfvlTWE6SJ+TgIseUsXmG90VOgUM=;
        b=tS42+zLW4PIBrSJDmuJpqIr15Rm/DekVwUlUCfseVHYhHzImfWZF1DNKBRzRoxo8/9
         9QYlVmpRmtnqV+zwaT1O930aphg27FG49jpgDqrdEdif13IFrqkrUEKKTL2honLeDRRa
         tWP+oVJ5QLHTJM4/UNu/BOQ6nxUPpdqX7ouC+PkoQfoucYvV7RMUHuqHnv4lcarbuiOW
         Q6zifPtwi0gj38XuJGJ2vcSCCE5A/BijzVFuz6ejjrSCldC4T8n/JzYTNIg9W1KgIP34
         Nq1ZLS+eW2sXqybMNh3axUMEwOmUd0QmSnwmbfo+HJOV8qoQdY4kpwunlP+Lglso0MLy
         PD6g==
X-Forwarded-Encrypted: i=1; AJvYcCW3nRJRfUbTGyd1qqBuc0iGCXiMVdu+pnA66nuifnP+bNY5+p9foU3WeOXAf3SL+6y99VlBRAK7hlerBhvB@vger.kernel.org, AJvYcCX8/vmNFtVNQet2jPk6gAVTvsX6MRxnMLU7M1lKHrX6dbhAOL+uXbKqfAHn+NS+1H3vyzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxaOIjF8dJ9xvJn4G9xiyKhp4D4MQjeB45kVMzJSpnGFk1ipqQ
	uheVQnBigXR64MAgVSDAKVyigjno64TNOzNjixbXSKkqdIZDHE2sJ4Al
X-Gm-Gg: ASbGnctoNhIEdKLE53fyaQHMsrSyUwh2qq2G9DHXGI/bfWdJRarH/0dvGjkjeQMg+0q
	/+34POsMv75xXfwrZAF5gNU1oh1P2rRWzn2TQp60MC4Kj8TERYHc9vlZ/SAhRfmZBA1/8F+1oTA
	AnzPjtz08zcWiTQMdybnldZsgeWLkZlNXPBMZZvsO034lbGIMX1NcqN0idZd+vNlHYwQtrv2RXQ
	GxbokegA+YAYb7UMD4KewtfSn+jqL7bEVoF0kWCKp15h+CkFiXDzjOARFM7OgNKlXAaYML8N9Yt
	5+VtKA4oGVCtCR0Wfvd29T1BVuE4lsqHptxlHX+jlubeJvVLDK8FE+Z2agifiALfxkqy1OsoyLn
	xHVXllqytAaezuUb9gtQb
X-Google-Smtp-Source: AGHT+IEcruhLfUpUI0N00j2UKrcehir5UXIERGKzq06ijzswQ7cEXx5HeK+uN6I004IHFYOOWQmneg==
X-Received: by 2002:a05:6000:248a:b0:3a4:eecf:b8cb with SMTP id ffacd0b85a97d-3b60dd95af6mr15750189f8f.28.1753105670724;
        Mon, 21 Jul 2025 06:47:50 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b61ca5c632sm10601732f8f.80.2025.07.21.06.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 06:47:49 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: x86: Remove space before \n newline
Date: Mon, 21 Jul 2025 14:47:17 +0100
Message-ID: <20250721134718.2499856-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space before a newline in a pr_debug_ratelimited
message. Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..e5358277d059 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3142,7 +3142,7 @@ static void enter_lmode(struct kvm_vcpu *vcpu)
 
 	guest_tr_ar = vmcs_read32(GUEST_TR_AR_BYTES);
 	if ((guest_tr_ar & VMX_AR_TYPE_MASK) != VMX_AR_TYPE_BUSY_64_TSS) {
-		pr_debug_ratelimited("%s: tss fixup for long mode. \n",
+		pr_debug_ratelimited("%s: tss fixup for long mode.\n",
 				     __func__);
 		vmcs_write32(GUEST_TR_AR_BYTES,
 			     (guest_tr_ar & ~VMX_AR_TYPE_MASK)
-- 
2.50.0


