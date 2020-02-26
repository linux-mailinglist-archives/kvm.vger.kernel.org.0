Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F9F16FB2C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 10:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgBZJpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 04:45:08 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:42900 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgBZJpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 04:45:08 -0500
Received: by mail-pg1-f202.google.com with SMTP id m29so1510840pgd.9
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 01:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UtzL/mOBJbhx1wqaitkgRIuidwcFWAMCohGe1UdpshI=;
        b=X+ZddKFSVjmYx//5ODHFJwhJaxEg/vQNbaS0/9McIw/EgtcDrqzxwwnc5udMNOc8y5
         8iJseZCMYXXYmgBIQIc6cxijuLCEdmjFbmMBj9C+2c1jSfWQBo83OejI0BRgKVirwFI1
         GGPaiBXuKFtxL+LdTbn0HgPMChuJeK+LMRxx6B5zf2EUkFh2QnNYOEsYk99hq4Qx+CwU
         vbjWnRy3I55DFOsctA9xennNTgNeir678PmfJZ0AC/NqD1Zvc0kDfI442NeWlmS2nmML
         B8Y5UnXCTlMWD2pSIhSA+vWzwJcO2oGnyA9PJNk+Ze6Rk6vDvWnVXB1BvIzBcdBW4dTG
         9bBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UtzL/mOBJbhx1wqaitkgRIuidwcFWAMCohGe1UdpshI=;
        b=rsqi4XVWyaC7GgxoB33t1+TrcO4rz+pMNRfwrCFt375DNpB+KlBQCD+Altk+iFNkPU
         vMM/3UCaiRuv6iqyICeLp+QE1C8eUcU2gksnk9BUKOcmUizMf53BWMhyeMo+mZ4cRiC/
         ndDY6Xr/aC0FCvmHH7GAki/5ubvKGjiGeDvW2NO46UwOZX8CUiXYhLYGcYpNvoqrpZHy
         kuEz8q0PVaeqGdLpdEQWmWoLzKPbAA0xzDm5eccrFm0NI+N87WNbvKAVAImi2KyS1hCi
         PKegp+yKSpx4uo7qNKXwiNcnxzVPPpZUmuU7esLj7dIwAW4F3VuWoka00D7j5IF8dSfA
         d3cw==
X-Gm-Message-State: APjAAAXH1tX/Ya+gdmR8q6q97tIkvXUcqFgExbaEWOR1nkzpJMi66nKE
        Sa9CS81uT0FUKA2g/tJdPSqhugLugJK6Oyk4g0+9gIhPfSNwRTewZCqjsq69pYObbQUDdZBkz7Z
        ZbL7234t3WO0NQFebM0aLt5l0pw/sxau1v3N+42gg/i1bhb0HfAJX1w==
X-Google-Smtp-Source: APXvYqzSgz7MffRoXeBj95R2xBrN3ltqOstk0iZ2kZBeQ4hlG3i5Srri1DhEqHld3wABCaPm2XYghOiYPg==
X-Received: by 2002:a65:5c46:: with SMTP id v6mr3204635pgr.333.1582710305549;
 Wed, 26 Feb 2020 01:45:05 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:44:30 -0800
In-Reply-To: <20200226094433.210968-1-morbo@google.com>
Message-Id: <20200226094433.210968-12-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com> <20200226094433.210968-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH v2 6/7] x86: emulator: use "SSE2" for the target
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     oupton@google.com, pbonzini@redhat.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The movdqu and movapd instructions are SSE2 instructions. Clang
interprets the __attribute__((target("sse"))) as allowing SSE only
instructions. Using SSE2 instructions cause an error.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 x86/emulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 8fe03b8..2990550 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -658,7 +658,7 @@ static bool sseeq(sse_union *v1, sse_union *v2)
     return ok;
 }
 
-static __attribute__((target("sse"))) void test_sse(sse_union *mem)
+static __attribute__((target("sse2"))) void test_sse(sse_union *mem)
 {
     sse_union v;
 
-- 
2.25.0.265.gbab2e86ba0-goog

