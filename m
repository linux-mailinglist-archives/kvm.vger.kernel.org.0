Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB58AE03C
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfIIVTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 17:19:32 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:37541 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfIIVTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 17:19:32 -0400
Received: by mail-vs1-f67.google.com with SMTP id q9so9815226vsl.4
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 14:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=oOiZ1EdVlfm+qg42MPgETyKI/X2VoNKNgczezd9rkcY=;
        b=niqtfSAi4arCrS43bsKpbw7tLD4wRv1qkEhYdKmemq8kaz/qi3M0z/WH4sS5yr5qlb
         hq+Q5liUDXHloON2TX16CetwqArBsS1gPt4ANSnrHWh9pRa79/zzGFCQnHxCrte/lnrP
         MGfJXFEyiEyxERsBb3JzH9YG8aIzvMHam3IbHPaiHnFPIR35n15HO7P5h/zADVNvmAQU
         VYwKHOYWdNokZB6aslV5h6ZiOsv2HCrJZ5Zt+i25l2XkRAzE7Prg+b4TR78RQ3x6WZyg
         LYyGnc3+9nLJ5Ia8xIomEElBFMMaNxp9UGnGt0h1KVQyUSZZO1P6kYfkW80Y09TC0Gde
         5/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oOiZ1EdVlfm+qg42MPgETyKI/X2VoNKNgczezd9rkcY=;
        b=C0FAAv7dqOKEEG37qi0Wrsn5QWhEtR4S/Fy+dKid2Sped+CKUJWJZNkqoWLhUhARSZ
         4vqmjK+JFi3gnk96EJ5RCTBXgZ9LJcfpqJtQfJ8RHSCuab+pEoaMUXSYNJjDqRNxmOh5
         gGyU+7ZFuTqGOrqb1bq6Rr1+v6rTwjes0aT7aVMLYZeknxcQkdNA4zwnmCY1qL5AqSXU
         wrpLZT5A30Bndu43Q0fGy9yjIAW3bDzv4gxux8jAiYo2J1cdPfPRfTEruuV1IP9muZNw
         3XEqfaw9ezsh18GIwov9BJnBIYEVszEHunVeuaUHOBkFZY//sFYPVDaYMrpNmvfbNk0O
         rs0w==
X-Gm-Message-State: APjAAAWyMEjrAF4DKFlSnZq2R6durPLv73awX/5XW7a880Dapoz7Bk4U
        dfhWj7xbMmE7RsbA056pOhZh7UbzXbOjTFdh6zXHiwP0XZx6
X-Google-Smtp-Source: APXvYqxmn3H2PufT8xzGrLjXW+wOFnhjqfBkdc1pRFw6G3cGmMrNzX+HltgJK46bNz5zdG04R4LiJoevXx8xmEm5AK0=
X-Received: by 2002:a67:2f4b:: with SMTP id v72mr9593621vsv.212.1568063970819;
 Mon, 09 Sep 2019 14:19:30 -0700 (PDT)
MIME-Version: 1.0
From:   Bill Wendling <morbo@google.com>
Date:   Mon, 9 Sep 2019 14:19:20 -0700
Message-ID: <CAGG=3QWteHe8zCdXQVQv+42pMO2k4XvAbj_A=ptRUi9E2AwT2w@mail.gmail.com>
Subject: [kvm-unit-tests PATCH] x86: remove memory constraint from "mov" instruction
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "mov" instruction to get the error code shouldn't move into a memory
location. Don't allow the compiler to make this decision. Instead
specify that only a register is appropriate here.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/x86/desc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 5f37cef..451f504 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -263,7 +263,7 @@ unsigned exception_error_code(void)
 {
     unsigned short error_code;

-    asm("mov %%gs:6, %0" : "=rm"(error_code));
+    asm("mov %%gs:6, %0" : "=r"(error_code));
     return error_code;
 }
