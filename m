Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D39216F8AE
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgBZHoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:44:54 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48905 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgBZHoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:44:54 -0500
Received: by mail-pg1-f202.google.com with SMTP id h14so1288318pgd.15
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 23:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6pHSqsqhtQpsZBK8Kdeyx8XvutwVtDm2Afb6gQYh6DM=;
        b=Mo7o+9Y/ti+/X/PgbqFLsbuMoAos1ylIUguffoKM/q1+tZMkkLiS3bKoF1Xt71eQMO
         SwH73Tf5agOP65C8J1jNOrAFkhHypCfXDmdtYlFy1SmGljB2ueHbz+GTszrV+ifKTkvm
         WcQAniJR0v19zRpV2RgFwQOZRqUonvbBc5l2lVK8+Zj7JeYSE8H4zos8gZWMattSJ7fK
         SGCF7Vg24sDbLa5RTqjLOJF4+PnKSpFR4GKiHJv+clh60Gl1qJjdCLwb5MipvQTYM3NZ
         VtakBEUOoGrQkTI98Ope7F59FyS9nhrfw1d2+jPL17TER4LUQedF786FMWAzSr7MWk27
         Yg7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6pHSqsqhtQpsZBK8Kdeyx8XvutwVtDm2Afb6gQYh6DM=;
        b=pO1oCBQGZcdVC1lDf4aY2gaa8CnfqD56DopfNLwWd6/t3wT6rfpdmYUFQf/somqBWd
         00zOf6/O6DCxF5gA33c8nnSWxCnCvd4mzXVvIASfrb6AcnIn8oS9vt8dlc4jCUBLjSV4
         cPSsE9H/qWdKj/NK50J2TTtDfj6ThORJZbk4WywZcosyRLtXZGwFC7Su7ilhpD6qoUYq
         Tln8LDkuNqL3b1xrI9K9JafrocUc/pSNCFaAmKUSiVSiSkfVWQ4x6xdw5DEm1ySmIa0i
         m/Dc35KMAQDA88lrNeBKwPHjFnOkgQ8pfNhQMqwgy2Rn1J0vAhqwdqEMvQnE0dMPkz/4
         cXuQ==
X-Gm-Message-State: APjAAAVMJ5RFt6FNZBCs1IXCsxnioim2EY4jjaala1mi1R4O7U3puRrE
        uahij6XaARoZ8e2JI1DI+4H/sJIJdyejOEDwGAqpaW6qanjeerBlK301/itOPGYKq6yzM0AnECA
        U8kxRzBI403lUp1EDkP5466r1AkwS8CUCS3hEk0t5vUBYzZzUF/M0+Q==
X-Google-Smtp-Source: APXvYqwaNVMvUNxZClWOF2TGyEiGmrzZMxTbrVTH2vXi7Z4vUDkf+R75cl/YWQFkXRVTZnDSna6Sg7oraQ==
X-Received: by 2002:a63:6d01:: with SMTP id i1mr2528728pgc.55.1582703091894;
 Tue, 25 Feb 2020 23:44:51 -0800 (PST)
Date:   Tue, 25 Feb 2020 23:44:21 -0800
In-Reply-To: <20200226074427.169684-1-morbo@google.com>
Message-Id: <20200226074427.169684-2-morbo@google.com>
Mime-Version: 1.0
References: <20200226074427.169684-1-morbo@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [kvm-unit-tests PATCH 1/7] x86: emulator: use "SSE2" for the target
From:   morbo@google.com
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

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

