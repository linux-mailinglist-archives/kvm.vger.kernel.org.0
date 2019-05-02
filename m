Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1627C12648
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 04:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfECCLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 22:11:05 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43843 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfECCLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 22:11:05 -0400
Received: by mail-pl1-f195.google.com with SMTP id n8so1919753plp.10
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 19:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=E5SKlBJ2qV7SbzwBBmwpThWQhwyq+IZObtNpXJkJU/Q=;
        b=SqdZHuxmJy8IUdeEAfut9nLSC2WZsy1Arxj0fsj6J6W9FQWHFBvvTFDY1p/gJd8YRd
         y88ACInx3ugHAo/DI+YIXYvRsdliipUqQbEexRe0e2nAWqy0EDkVmRPH3jmPlfjyWP05
         RrGowzzZK3R8eF8znExGb/OV5q/ZmJP5YeOCGCMDo1Gk4D2XjZqqBzuuUAs/P8qkFnwT
         QTjd7zGdwor4/VeHgFsnsTAnUcassn3G4XVeGOn2RmH636oByKFvTgojQA9rq3xvr0Jh
         mSWOJYVn4E1XoeSteq5b/IEa+0xfDR6L+A0Zz+UE5+CNHImuSK0aSCpodmrG/PJnbSxi
         gkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E5SKlBJ2qV7SbzwBBmwpThWQhwyq+IZObtNpXJkJU/Q=;
        b=Mc79gBBEkAf9mpobynhP+oMFFfaZSA1Bhf0CEUmm2zIskTb7d8h0Y85c7lXOZ8kSJn
         SxbXZyXK/ZytGYzVe2Ck3SJ/xOzkvsu76HNuHVe1wDSpgzI3XMfK4LvX7bmEOmUEvdgW
         gyKXUBIkwsIYNGAg3V6TOI9lXOEV0dBRpWJWrrT7y0dVtO//Wues6JvJW/AYClk6Sp2p
         CwhlZ7FETyfeKCcNBCn6Yj77Spaap/QVvsd2UD4enCEKb4M8sVy9XelSciygtmqn+zZ7
         0bbwmpIHAk2vfBZQU+fGTvEB3ZzaimkjDFDqXbkU3RWU98t/4fOkpvhYtSZEW9PxCHNN
         JveQ==
X-Gm-Message-State: APjAAAUsOd8yx2fE02+9NuJowaEJ8URiVs7TwtbxmKfae4BjlLIA8ahC
        T/86FLdab23Kn9kG44gFvWw=
X-Google-Smtp-Source: APXvYqxepdIyuxj20ZbA5U7Z/7mskneeO8xB7+36ytCpr9SEkRqaz/OyDX79r1+IqeWjPOXFYz8FgA==
X-Received: by 2002:a17:902:5995:: with SMTP id p21mr7301272pli.216.1556849464359;
        Thu, 02 May 2019 19:11:04 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id o3sm601287pgk.84.2019.05.02.19.11.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 19:11:03 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: eventinj: Do a real io_delay()
Date:   Thu,  2 May 2019 11:49:13 -0700
Message-Id: <20190502184913.10138-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

There is no guarantee that a self-IPI would be delivered immediately.
io_delay() is called after self-IPI is generated but does nothing.
Instead, change io_delay() to wait for 10000 cycles, which should be
enough on any system whatsoever.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/eventinj.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/eventinj.c b/x86/eventinj.c
index 8064eb9..250537b 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -18,6 +18,11 @@ void do_pf_tss(void);
 
 static inline void io_delay(void)
 {
+	u64 start = rdtsc();
+
+	do {
+		pause();
+	} while (rdtsc() - start < 10000);
 }
 
 static void apic_self_ipi(u8 v)
-- 
2.17.1

