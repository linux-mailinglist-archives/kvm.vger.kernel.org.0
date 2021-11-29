Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA86460E70
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 06:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbhK2F2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 00:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbhK2F0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 00:26:33 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B0FC061757
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 21:23:16 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s137so14906217pgs.5
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 21:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=irOV3j4vbeWhkKZZS8pKM9srtDflYt0SC5pb7+oBXfQ=;
        b=4GqTtW3WY+Ee8ZRFk170sEeEWF1gtrRF56VQXH8J+fw3Zd3rsVtc9TGD0aS6YD28as
         AepDPAoDQX8tyHyw5MjiXsafUJEa6M05XEKpQFDdoKmaePQ/bSQ7SHeA4aXLDoVYxzZv
         nP1wAA8AtIaRBZh8Pnyfsr+heaFCI/PjMaDwO+vv3YkHFGStPwZoSsbePgZnfPG8kvE9
         SAO5FLILf3rzzE0jk4KoFXCwR8JhSED72n1N2fzEIwtSgA+hiwHWQwBRmj9JtaKn2UNn
         3F0sanXUp2tFcuPbrTRqmZWjwSRuEvaraGiS4V+WvhzJ44ql+/PdTfpj0RKf/T0U/Cmf
         X2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=irOV3j4vbeWhkKZZS8pKM9srtDflYt0SC5pb7+oBXfQ=;
        b=Y7I75bmZmPw/bTtY8Adw1W9PQ3/dcZ1jqxZZ1KkntV2PO2N9jGps0Tr66TYIVLbxDz
         S6rWTBM75qT6Xyt253zLI4CQEQ4+GcE5gZBy644I/j6W8wMl0Ekdj0kbW4EOh5lfJFcl
         Z1bUTRxlIZvEifg9SzPPKlOwY2bT1cKV+N5OMyW2i/v8asG6+sRinKXHfeQ16A99aF/3
         tprgRyWfDqvomw4rWuMh2zrNSpj+iknBRDw/BhkzH19jPDf0n8C6PLtWHbc5RG3B4efS
         4wBC82hevd7abON/3B5qnXnw6ftvOLE0uKYNQcGnBp9H2QihX6ylbG7JP5EHuSHjhYAx
         oYeg==
X-Gm-Message-State: AOAM533zX3UAj0uuR+nZus1quVeb/bFusUimTu6t+sIB3dNbF9E1fz5T
        vVurl/I5VlpNXblbgHW0ZV5uAw==
X-Google-Smtp-Source: ABdhPJxePdfuYnlLDjMX4vLzgyXbCdXtJGS7KgAb3hJIcFC8nVNnAWJscBp7u8ib4vGGuSoISszFtw==
X-Received: by 2002:a63:e20c:: with SMTP id q12mr20573139pgh.558.1638163395900;
        Sun, 28 Nov 2021 21:23:15 -0800 (PST)
Received: from sushi.bytedance.net ([61.120.150.74])
        by smtp.gmail.com with ESMTPSA id t13sm14753683pfl.214.2021.11.28.21.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 21:23:15 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 2/2] KVM: x86: use x86_get_freq to get freq for kvmclock
Date:   Mon, 29 Nov 2021 13:20:38 +0800
Message-Id: <20211129052038.43758-2-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211129052038.43758-1-pizhenwei@bytedance.com>
References: <20211129052038.43758-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the host side supports APERF&MPERF feature, the guest side may get
mismatched freq.

KVM uses x86_get_freq to get the same freq for guest side.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 arch/x86/kvm/x86.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a403d92833f..0c2a2188700f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8305,10 +8305,8 @@ static void tsc_khz_changed(void *data)
 
 	if (data)
 		khz = freq->new;
-	else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		khz = cpufreq_quick_get(raw_smp_processor_id());
 	if (!khz)
-		khz = tsc_khz;
+		khz = x86_get_freq(raw_smp_processor_id());
 	__this_cpu_write(cpu_tsc_khz, khz);
 }
 
-- 
2.25.1

