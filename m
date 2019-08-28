Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2E59FD0D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 10:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfH1I3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 04:29:39 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:39494 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1I3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 04:29:39 -0400
Received: by mail-pf1-f201.google.com with SMTP id n186so1510959pfn.6
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 01:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m26isUzfYfS+tZR7e2mo6xjWcRmXsDiHK/VLJs2n4q4=;
        b=vTrZtWvSHSOXfQNqpOTgwRZteVPk4jzMjJNCA0QBgY8pHQK757xXFgPhJlao4BtxhA
         7V5XpImMMJrHMsPqhCyxNW9ce2F7t1ON5oP9LlbMcBcA/XoGNXH00GllYyL9GB1tSQUi
         70n1y76nfQeVZdTdc5fOd2D1YISsz5ZYPRdu8U0XQD5LCFvL5fQoSIG4AMg2siYfBGmk
         EpjExrVJoMf7PJ5DUZv7eWbFWw4XSiRA3uwTMNr3WHH9+DKovYusmnC+2/fDm+e7RO0J
         qNuNcLh1hhQAaPCf1lrFV6n5J7ujY/+pLl79Nan1il047DKIq1FxWTPMw4bD2UZ5WVaA
         7uYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m26isUzfYfS+tZR7e2mo6xjWcRmXsDiHK/VLJs2n4q4=;
        b=dRP0mU0yKSA4JH7FXufHRyBHy8H12W+nMIP2/xaZKlxIbMETH7C7kq08v1ZY4+8pzJ
         0/2LUea8Y7XqaWammYi4b2CqAe69p4FG41yNFbBeGwFS79+Ud2jmnZjDl31oxsCbXxO+
         wuGW2Vtbr84WPzzk7uAcL+FQkRQXeY69F3w0iAtxAlWd4NUwvQiAlOwaHd5+scCpFJIt
         EVs2yKMh0gTnaZgqmD3Hnib4y3cnoHHcCBMy4RWn/8Q8Pm7WIbLdnnNDu3uoT4r+xd/5
         lzRUzstyesrdmhyn5hQO5yBfMaM15m08mrTSJX/5uM3QaV6RYrppseUk5rXqKw4DNvTD
         dSzA==
X-Gm-Message-State: APjAAAVJfoKMhD5K8AiqQ+SEkHPAgkkcB0a75rHWxGeVyccskpT4D9p/
        r7F289qDDwG2RRi0Amaip2T1p2Z4kFtjjH4zaPttFuLq44Npy5NVnST6WXZgv9LwMsylvEQ+J/q
        163GC8lz366if+lMkKZR1J0NaWLPT0cAlKx7K1IHYuRJePTK+P4uC3H7zgA==
X-Google-Smtp-Source: APXvYqwCQnMr1bdOSCslVxdaQlr8w4xWK0Te2STYsUL7nAN1xaT4pCWNXezZ2HyCYSBW56tkfooXy7cKM3c=
X-Received: by 2002:a63:2a87:: with SMTP id q129mr2470692pgq.101.1566980978058;
 Wed, 28 Aug 2019 01:29:38 -0700 (PDT)
Date:   Wed, 28 Aug 2019 01:29:00 -0700
Message-Id: <20190828082900.88609-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [kvm-unit-tests PATCH] x86: VMX: INVEPT after modifying PA mapping in ept_untwiddle
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ept_untwiddle modifies a PA mapping in the EPT paging structure.
According to the SDM 28.3.3.4, "Software should use the INVEPT
instruction with the "single-context" INVEPT type after making any of
the following changes to an EPT paging-structure entry ... Changing
the physical address in bits 51:12".

Suggested-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 x86/vmx_tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8ad26741277f..94be937da41d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2376,6 +2376,7 @@ static unsigned long ept_twiddle(unsigned long gpa, bool mkhuge, int level,
 static void ept_untwiddle(unsigned long gpa, int level, unsigned long orig_pte)
 {
 	set_ept_pte(pml4, gpa, level, orig_pte);
+	ept_sync(INVEPT_SINGLE, eptp);
 }
 
 static void do_ept_violation(bool leaf, enum ept_access_op op,
-- 
2.23.0.187.g17f5b7556c-goog

