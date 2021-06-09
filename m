Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A85E3A1CCA
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFISc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:32:56 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:46798 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFIScz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:32:55 -0400
Received: by mail-pj1-f41.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1969108pjb.5
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NBi9Yheet34AiIDQ7k7SUS/JsehvOX+YErFL/OZ7J+k=;
        b=hToWiCMMei76RiTHdPHLHlOpOFr/1+9dHlkSDf9/RXEiE+AZNxptKt2rwwMlqKBoeA
         aDcM5hfxKajOicidqQNvTzMNZ2E+AxdMN96QlXX7K/E/V85vCLckLGeBMKDVwFcplESK
         5Y8wyb2PkVFDlJjSBfqai2Ad+rnENmxE6SnfGjGcrWpX2VrdbO2R9IzBSB0zNywzAXK5
         KPx6SKAwqGuZoosD32RQLJS1Mn75NKoNtHEfQ4kEfFtbuNh3SXc6XUTiGcO/kmdLF7yv
         kUURxZsDnM7sa7TVI9TFP8r3AD5Q52YV/v07d4fKDkG0KqhvVNw44nQTXXzDk/TakYYn
         UJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBi9Yheet34AiIDQ7k7SUS/JsehvOX+YErFL/OZ7J+k=;
        b=kJqvzjH8/nNu37x4RzxSQ9V5D02n7yMi7XuL0+gOUr6MWKgIJHKqXUp3g0yh9lVZ+v
         HBZt0AKh4CClRy625jX8cuF3W0YAQBbIslAgPEb3EdXc8Ti8/KPe5aNjQspQhAOF/US2
         qa7vGvkf2uHvmSByIogF7W3vgN1Y889UFB0tnjM3GC9vnVsswiWVb6X6P9OFgAwR5Jp3
         fSm1REedsqefjqtbyCq+fXzPkOuNO4Sd2kI0EyRoDJheaXsr+EcgfDhBzsGPaWTJ5KBt
         wYLbUuJTVi4Dm0pRubkI3in1PNTTgGKFECFsr/mK2qx3VZOA9q28P5/YvAmeJXRS63xx
         uNPw==
X-Gm-Message-State: AOAM530ssUU3TF0hCatr/Mlh+PZsFRMQ4scNgWo0hJizS1J+jmecDhiP
        gvcT6258xhfQCullRU3bHA67ikjD0sp92w==
X-Google-Smtp-Source: ABdhPJwtcQzQFuZQw+W58l7wcV/uDWBE/zKPUgGfii66vDYiyFnrU383KPHXeLrdy1SSANOl47yBpw==
X-Received: by 2002:a17:90b:4d92:: with SMTP id oj18mr888505pjb.89.1623263400350;
        Wed, 09 Jun 2021 11:30:00 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:29:59 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 3/8] x86/smptest: handle non-consecutive APIC IDs
Date:   Wed,  9 Jun 2021 18:29:40 +0000
Message-Id: <20210609182945.36849-4-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

When APIC IDs are not allocated consecutively, smptest fails. Fix it by
using id_map, which maps CPU numbers to their apic-IDs.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/smptest.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/smptest.c b/x86/smptest.c
index 2989aa0..cbb4e60 100644
--- a/x86/smptest.c
+++ b/x86/smptest.c
@@ -1,4 +1,5 @@
 #include "libcflat.h"
+#include "apic.h"
 #include "smp.h"
 
 unsigned nipis;
@@ -8,7 +9,7 @@ static void ipi_test(void *data)
     int n = (long)data;
 
     printf("ipi called, cpu %d\n", n);
-    if (n != smp_id())
+    if (id_map[n] != smp_id())
 	printf("but wrong cpu %d\n", smp_id());
     else
         nipis++;
-- 
2.25.1

