Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD372420F8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 11:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437483AbfFLJgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 05:36:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39254 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436605AbfFLJgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 05:36:14 -0400
Received: by mail-pl1-f193.google.com with SMTP id b7so1358835pls.6;
        Wed, 12 Jun 2019 02:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SwGzI5XfH1K4vXAfrjZTodx1XMnoUAT4N0Igdk71XCY=;
        b=NgfU4ZvFIHAUa5XZscShQ8Z4CDQi0RfI7OWOhoKSu845QOerJAzhH+x01UDUvbyPJi
         3kCOGHyPT9KgoEqEf2SDAiiphUbOvUWlx+EW5PsIj3pUsOPZyexqX9kt2lPV0xmrszeo
         eG+EQAD0Rczv7z7k5L+sFF8GvbUDYD/BgruBmHgEdgQTAUyzFOe5lwk4hY+I80MTOsiH
         AMEGMTiMrEwVJ89g0G1CnBvjBsxOCwW+zNxTy0FkV4/6ISJqAghOrN+eULBmTrKYiDeD
         XgDbMOdHNVf2su+s3jYYlVodcq43xMNfIFODRB1RYsh+7sp0UBBfPo4b9tvHLWsMbtK2
         ttvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SwGzI5XfH1K4vXAfrjZTodx1XMnoUAT4N0Igdk71XCY=;
        b=Ln8oLsZ2E+wiZLYGLzyhWm3W1FJOgSWAKl2yJIK846Mu3EQ9Lf73Fs1W2jPaUq6jkg
         DNth/9m6bFXGMogZ7qzqzFBpXkMuXIF5EsRXv/2D6uBaqlrYdMKA/TXTPZqWpBYGZG9Q
         6y29+TuQzqytFzw6mX9gGbX+90C+AOtKXaAW7gJAm3FQAVf22QA9e+GpWP6d78xi+CEh
         JSslnsX62N34Ut3S4Van2rVigNCgKWD9B1Cdt1i+l81vI0j7mN7BqgyDuLGEKzyspfGm
         dbn+ReDaE/lGdDoPF1jJzMMNtFfqogB9bRWRKkU6f+yMm4EOgcqowRx247aO9hy7FHl7
         cpPg==
X-Gm-Message-State: APjAAAWSZOAb+h9n88uWvgy2Se4e9k0ubjdVqD82fh4muaPD/FGijI1v
        xo32f879IKnfBOcSTqR3zLvm34pq
X-Google-Smtp-Source: APXvYqwe4WQfg2VoWySAJ68UC5vy7Xn4AHB9eF6MZhzn51pcH+zW9OtDTV4KI9OyjcYMOdc86dfu+Q==
X-Received: by 2002:a17:902:4906:: with SMTP id u6mr81809848pld.220.1560332173747;
        Wed, 12 Jun 2019 02:36:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 27sm6148936pgl.82.2019.06.12.02.36.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 02:36:13 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3 2/5] KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
Date:   Wed, 12 Jun 2019 17:35:57 +0800
Message-Id: <1560332160-17050-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
References: <1560332160-17050-1-git-send-email-wanpengli@tencent.com>
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
index b63e7b0..f2e3847 100644
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

