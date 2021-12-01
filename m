Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15B2464538
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 04:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346357AbhLADFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 22:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346350AbhLADFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 22:05:48 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF15DC061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 19:02:28 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id b68so22778363pfg.11
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 19:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2m0lqCRByV7QOKjWy5hukU3vAIBzQsmd4tDT5LUKLO8=;
        b=i25euUF1q0pJCiV+e/eplDPdimnyV8tDZO8BDKRyvgZTI112UYyud18aSSKFU3iNGF
         zeaRABD5Qj7ccKAJ6lmuLsiYS1p9w1IDZlgUoJ57LaIOn6Zv5RZ3B+y8QD2Dv8RCxiPJ
         k+vnQINPryBNSpndYVPdLBfpWASEqfcAfkrbX19Y1bXCrWFfNpRweC7L1VutOfJxb3cO
         Ire+u/D1IIlsZOuhTcGcavCIGBIVOUpuZW1nesxaJTreOrWFzncQCrxggsMfhCvB2oX9
         Jm58xBR0KWZb1Co8o/cHalbJg9I8tbSPF8oAzdjQth0ybSrF5CcYZEeXLcgnQdIDXLEZ
         wXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2m0lqCRByV7QOKjWy5hukU3vAIBzQsmd4tDT5LUKLO8=;
        b=diRLpcsANBWGKguTLmBdw3Qsi/S68y6ZSRAav7Er0KKOJEM1vvXQkbOttubLyix92Z
         tKYqnHsDNxHQ2d9UWEALUAQa5s6WgOdLnNRIXI+4DCWV0fcEvIpX6Bb1c2hfufxjsw0J
         JG79GcoXOsTT2+JOoX2MyorZO4eAy4QFCLYmrsMvYwwhHfxJb9vQA+uQ/IdJI3ZFaXy3
         awG7dUIZQsHw4vN2sbH26vkdYwvEad6WZYTrYpC/SNjrSE+Ya0S91JzxLXUwd+sVWvhJ
         /Td7lIJZV/1Vm1swz5YvbWIw59b8Gtn5nwHFUsMrvR6YtePW80Kka3jcnylH2JbmJfw4
         gWzw==
X-Gm-Message-State: AOAM533V1FITQD7GuIm8jZPezFfOjTYIETWP8DZqSkyvfNrDRRGlG7sM
        61qNyk+TtJwXGEON2sZhWvo95Q==
X-Google-Smtp-Source: ABdhPJyyozRFSjhFpMK1g9HKTg7Kvl2dqg6zGlaazmTmiVVt7jrqS25sTOqH8s60j+SqadUmSj/MHA==
X-Received: by 2002:a65:51c1:: with SMTP id i1mr2619532pgq.600.1638327748409;
        Tue, 30 Nov 2021 19:02:28 -0800 (PST)
Received: from always-x1.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id 12sm1085248pjn.16.2021.11.30.19.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 19:02:28 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 2/2] KVM: x86: Use x86_get_cpufreq_khz to get frequency for kvmclock
Date:   Wed,  1 Dec 2021 11:00:09 +0800
Message-Id: <20211201030009.89740-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

# Ignore previous [PATCH v2 2/2] KVM: x86: use x86_get_freq to get freq for kvmclock, and remove this line

If the host side supports APERF&MPERF feature, the guest side may get
mismatched frequency.

KVM uses x86_get_cpufreq_khz() to get the same frequency for guest side.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 arch/x86/kvm/x86.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a403d92833f..125ed3c8b21a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8305,10 +8305,8 @@ static void tsc_khz_changed(void *data)
 
 	if (data)
 		khz = freq->new;
-	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		khz = cpufreq_quick_get(raw_smp_processor_id());
 	if (!khz)
-		khz = tsc_khz;
+		khz = x86_get_cpufreq_khz(raw_smp_processor_id());
 	__this_cpu_write(cpu_tsc_khz, khz);
 }
 
-- 
2.25.1

