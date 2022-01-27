Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8938149EDDD
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 22:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbiA0V4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 16:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbiA0V4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 16:56:04 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAD6C061747
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 13:56:04 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x11-20020aa7918b000000b004bd70cde509so2231506pfa.9
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 13:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=InFZh5SDs6J4w/UIEvnOJGLsh3lY7VIuXCiGEtfFotg=;
        b=BEeGZ92mNoQ3pLhbJZjKDBFhCModl0jHK4Tcgm3oyp2zH/T40YBDjeY9iN3gpeGW9e
         NVn/5Pb+rOXgxVyBEhZKaX/9oDrY7pLAL6WAvQ3PqJcrB6lhQEpMBUXzIVd7UEIezT8N
         AC5OOAl9cHv2YXQg0bg9/YNfQnUja301O+gFQ5ZACMD3QSprhkm6WIXUtZWUThaIme/n
         lGcrADhOie0F9ldkum8/KglmwghOX9vAWIcwP1BqmSbadMZuJz+hLGM4H+pXZ/XYZR3L
         QhTa1lIBnd3oG1EUZVux8tyGImFmmhXoNVk+17fk309gOB2PrgL9FdC+wNTC1VGPKJyY
         6DkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=InFZh5SDs6J4w/UIEvnOJGLsh3lY7VIuXCiGEtfFotg=;
        b=c/tNwhe4I2hTjd1NBART2NelSzENJdnZWi9Ux5ziJ4AW0i64oQBwV2GX00kPx3J8pk
         PDfSIk6XI3KfNaykEZWgH4bxxtj3JphzrzF1wAHJsDX9Y0fR4oG6NKysLwXZ7cllIi6m
         UTtsowQWacOQ9+4Rcnk4zDcBMDVbzcXZMHJyGo3fsJEIBce3OLOQIc9eCvyYvNjyQ2rd
         IMnF3CqAgvC+j10EEiI0iVb+c09QA4doekPm3c5suJ/AoYot4Fo1PQ3QQcedUnsp2yNT
         u72i192X34Sla+BA9YzSXaxhtWHdi24/DLDr7/MR/F9k721XyTwb3hZrvstxG+SeJ9Mg
         a0dA==
X-Gm-Message-State: AOAM5307WeTGvDI+2igQGdqAUF0zEaQTfgM304cqC11KSlt8KsvoTh3C
        ZDbkSgaeK3FtEwzd9yy/BhU3oQARngNOnjf3VIEH39SwvJfQ7tKkABDAqGj/ORihbu1ER5XzyEw
        MOpfc0FELDcIah85Yszi7ylvxFx2Du9wNRJU8PSbqmJFrg5jrl3xiLoRq2dn5Mr8=
X-Google-Smtp-Source: ABdhPJzHbQ4BgTI9/SKOmZnt+wUKL20Ajh+vra1wum1rsi00juT/Hddt4Xy7SETnPIoFTV0ZRx4lwtwF1/UgFw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:903:408d:: with SMTP id
 z13mr5270350plc.19.1643320563811; Thu, 27 Jan 2022 13:56:03 -0800 (PST)
Date:   Thu, 27 Jan 2022 13:55:48 -0800
In-Reply-To: <20220127215548.2016946-1-jmattson@google.com>
Message-Id: <20220127215548.2016946-3-jmattson@google.com>
Mime-Version: 1.0
References: <20220127215548.2016946-1-jmattson@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [kvm-unit-tests PATCH 3/3] x86: Define wrtsc(tsc) as
 wrmsr(MSR_IA32_TSC, tsc)
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove some inline assembly code duplication and opportunistically
replace the magic constant, "0x10," with "MSR_IA32_TSC."

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 lib/x86/processor.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index fe5add548261..117032a4895c 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -592,9 +592,7 @@ static inline unsigned long long rdtscp(u32 *aux)
 
 static inline void wrtsc(u64 tsc)
 {
-	unsigned a = tsc, d = tsc >> 32;
-
-	asm volatile("wrmsr" : : "a"(a), "d"(d), "c"(0x10));
+	wrmsr(MSR_IA32_TSC, tsc);
 }
 
 static inline void irq_disable(void)
-- 
2.35.0.rc2.247.g8bbb082509-goog

