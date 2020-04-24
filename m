Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0338F1B72C7
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgDXLMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgDXLMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:12:01 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A495C09B045;
        Fri, 24 Apr 2020 04:12:01 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f8so3624779plt.2;
        Fri, 24 Apr 2020 04:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6VYOsM5gqxnJ8Fj9mA3NrZhEPwkpUDOyTXJ2jtRSCA0=;
        b=YXams7v7NDuTYc/eBxH/rxi0az35iPhbKbyXQhKDwAtoc7j2coRHLlwXkJ6MrXQGna
         bsSCoO+z1HUJoi9X9G3yoRRmVZigbVw3Eoe8MPOHMyMTmJSfGpl3goKPGdqv3Stlf/zI
         SjrOtFl6Hl286uFwWQNhCsil0COzaPQO0qL10rqUOaBCPs1YWWkzhJQBqGmPqrG+Ougs
         knPzEY64s0hiEwzQHQcEivbY+yXJ6TxfwUa6se+mRIgIxNqU9JOtZThyv+19DaZW6Htn
         L+ClsTThUHyiqeY99YVOjbwvZ8o2m1uM+mSJ3V0Xk7paF8hZgYKnlfKb99AdXgkv+mh7
         kGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=6VYOsM5gqxnJ8Fj9mA3NrZhEPwkpUDOyTXJ2jtRSCA0=;
        b=N2nemZKpn5HMgqkNn3KyhXB4vPHT8cvT4NEXsukN4lwEXbY8QxId/BmTMQlks04eYu
         CipkE75yyNnN6MNZjSgwQiMzaXsYFhcBR1kt6A5KpG3YcmIxVs7In0ls81L6O3h/8eNs
         YsQ/fk5FvAnuU2jgpgxKbx5JjIiK2iEuATJkOZuaxzwBb7pKw3m4qBBdR3cLuKXvgIcR
         0ntLT3Hj+FCcSB6+K+SuJ/AuaeWSOACYRo5xcy8FGs7oG+0IduQ0Ofw8J6YNh9+ebusT
         i4XJ7Bfi+BIETwPxndhZz3lgfKyN++Q+UP87GW43XDxt2GAVSuLLlg5OHej9wnbCM+Ag
         tFlg==
X-Gm-Message-State: AGi0PuZYOE4TQ7FFE+ZSRrtJGOmP6IGZLxfbDgiDqKqo6ukcXQmLYhjb
        sLK50bmLu83qTYdU3ErN1FULVCKcva4=
X-Google-Smtp-Source: APiQypI+PDjfKg9J6nX/4fRibS+YLTKqyumKQ+lrfF9fNYgFHKALrTV6i3WfsRtvqRrlzWyxfi/Pmg==
X-Received: by 2002:a17:90a:718c:: with SMTP id i12mr5693232pjk.142.1587726721033;
        Fri, 24 Apr 2020 04:12:01 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.11.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:12:00 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 08/14] KVM: MIPS: Let indexed cacheops cause guest exit on Loongson-3
Date:   Fri, 24 Apr 2020 19:15:27 +0800
Message-Id: <1587726933-31757-9-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3's indexed cache operations need a node-id in the address,
but in KVM guest the node-id may be incorrect. So, let indexed cache
operations cause guest exit on Loongson-3.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/kvm/vz.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index f9fbbc16..ab320f0 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2853,8 +2853,12 @@ static int kvm_vz_hardware_enable(void)
 	write_c0_guestctl0(MIPS_GCTL0_CP0 |
 			   (MIPS_GCTL0_AT_GUEST << MIPS_GCTL0_AT_SHIFT) |
 			   MIPS_GCTL0_CG | MIPS_GCTL0_CF);
-	if (cpu_has_guestctl0ext)
-		set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+	if (cpu_has_guestctl0ext) {
+		if (current_cpu_type() != CPU_LOONGSON64)
+			set_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+		else
+			clear_c0_guestctl0ext(MIPS_GCTL0EXT_CGI);
+	}
 
 	if (cpu_has_guestid) {
 		write_c0_guestctl1(0);
-- 
2.7.0

