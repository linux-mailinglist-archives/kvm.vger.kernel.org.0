Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8854F1E753
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 06:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfEOEME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 00:12:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39237 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbfEOEMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 00:12:03 -0400
Received: by mail-pf1-f196.google.com with SMTP id z26so642541pfg.6;
        Tue, 14 May 2019 21:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TmNr7NWRvuB1H22Y/bVjw8p/e3VenEqeZUhq8ds/kPA=;
        b=YdacPIkmRSlzvydmLfdim/JPX2BB7BBYeZ9MzBAcO7KITTKTyE16YNG2UUemGo81Mp
         KhiZ0fr6da+k1VFJDlZbMRO++X+vbtWXAf5/Ii6V/nAsGyNQiiwVc0fYqV8xqRRgAYdP
         LH0YFhYe4BRZHq71BQgy08e6cmAp5augm+QIsBDCOTou+fPQ82eBcvmUnaz9bOoe4WXv
         IDAo2msCyrAROIudRoowmXOuBcI23b7jqrIDkl6icYjyWn1NkawDc4LqVIsZsskV/GvF
         p4Qq1Yb5yCKCFAU45ISqoxTWHGk36/zzw+a4I2UICV7QNyGMznfPQxVbwHnFK+4a6qyL
         zt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TmNr7NWRvuB1H22Y/bVjw8p/e3VenEqeZUhq8ds/kPA=;
        b=JhlwSx5UHGEfj43wgKt15QcRh5rwE2XLOwxS6a60++CpQFiz2FoyS2OGhGMUcev+QW
         tAl6l8SbPV8g+FEL5CI1bzpHvfwtapZBJ8akR6MKnZaLv33keaCkk375+ipXDTwVlw7+
         MhgntNy8PS0tuKkZbxUS/Kr+KLAVdaY/jTHFfXnq3OLgFvzn4xk7kDUDIhfaLW/02Qkt
         SECIirCjEaybk2foGeJHesurQk3HEsEUvqi4mX52UgvTWb6tKzIza3kvsybv8HZEYz6c
         RmRJstbYSmGoj46xAaJ2nkBO7+cWWqeo/DvenVKw5sQuwHzDkONRrTFRMzG4yDvXU+3z
         3jJA==
X-Gm-Message-State: APjAAAVapV8ERYt0ESQQyR7OrIjmNHzCOqQqvT5r0MA02RgSGoJEUnxV
        v9XaHhCkfC4j8nhTrSIMK069JMu0
X-Google-Smtp-Source: APXvYqy3Ywx1h5Ok3xrAAusgAnoyQs6hquQVqMcdmyQ0uIfULMecOYX1DBv4lXQoAT8MO1rpFrZqrg==
X-Received: by 2002:a63:6dca:: with SMTP id i193mr40442990pgc.353.1557893523064;
        Tue, 14 May 2019 21:12:03 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z187sm886788pfb.132.2019.05.14.21.12.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 14 May 2019 21:12:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 2/4] KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
Date:   Wed, 15 May 2019 12:11:52 +0800
Message-Id: <1557893514-5815-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
References: <1557893514-5815-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After commit c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of
timer advancement), '-1' enables adaptive tuning starting from default
advancment of 1000ns. However, we should expose an int instead of an overflow
uint module parameter.

Before patch:

/sys/module/kvm/parameters/lapic_timer_advance_ns:4294967295

After patch:

/sys/module/kvm/parameters/lapic_timer_advance_ns:-1

Fixes: c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of timer advancement)
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d75bb97..1d89cb9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -143,7 +143,7 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
  * tuning, i.e. allows priveleged userspace to set an exact advancement time.
  */
 static int __read_mostly lapic_timer_advance_ns = -1;
-module_param(lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
+module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
-- 
2.7.4

