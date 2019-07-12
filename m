Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55DB6646F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 04:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfGLC2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 22:28:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32914 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbfGLC2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 22:28:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so4001240plo.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 19:28:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SQuqtPUHvOhARMEh7aacQAGcSKsUznBxgps/OyxKb0I=;
        b=N+e4o2VPKDp7uQGRUvK32NwGZn2yUJVp8gUHHojnfOxFxycQd7k0O+dAbXTZpjAPnk
         zXqOVGWDaL4fE8aIoKA0FifqFQnURTaQgYVxhMvw/4SzqIHnksGyspFdTcUQxtbo4pk2
         g88rceg7nBt355qBmyEBbmmBc4EYwd2rh5y/Lq8/oOAV8VZLV1AoMj6NIMLqjAMAnYtt
         atS+ULBORZHCzI1zydsvMivFjgylGPNEMuRW0d8a4/+fNqDCE595Kfjc38Dm5GIw7DVI
         y1kJz5UrbMO0BpzfrGn47vFapwn6BtlobAI/6slulG1UDeSyNwFVBuuXk2JO6LymLUX4
         ZTfg==
X-Gm-Message-State: APjAAAXM6UxdmnUmX7DUVcUuhynNxEPE6vx25lQMGH2Mp5+IzqTAA/ya
        Ju34aUBAcip6K/eDSJws4s/8UaRl14VmjQ==
X-Google-Smtp-Source: APXvYqzl9LBPKM9pYxH51GuGOH8IZzPA8PjNbqNwOL8rtS3HhWjvApmHzcSyGXXM7dFgflf/5qTygA==
X-Received: by 2002:a17:902:4501:: with SMTP id m1mr8396879pld.111.1562898522991;
        Thu, 11 Jul 2019 19:28:42 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f15sm7389259pje.17.2019.07.11.19.28.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 19:28:42 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, peterx@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [kvm-unit-tests PATCH v2 2/3] tscdeadline_latency: Limit size
Date:   Fri, 12 Jul 2019 10:28:24 +0800
Message-Id: <20190712022825.1366-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190712022825.1366-1-peterx@redhat.com>
References: <20190712022825.1366-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When size>TABLE_SIZE it can hang as well (say, 10001), because when we
get TABLE_SIZE IRQs we'll stop increasing table_idx, then we'll never
be able to get out of the main loop.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 x86/tscdeadline_latency.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
index 3ad2950..0a3532d 100644
--- a/x86/tscdeadline_latency.c
+++ b/x86/tscdeadline_latency.c
@@ -112,7 +112,11 @@ int main(int argc, char **argv)
     delta = argc <= 1 ? 200000 : atol(argv[1]);
     size = argc <= 2 ? TABLE_SIZE : atol(argv[2]);
     breakmax = argc <= 3 ? 0 : atol(argv[3]);
-    printf("breakmax=%d\n", breakmax);
+
+    if (size >= TABLE_SIZE)
+	    size = TABLE_SIZE;
+    printf("delta=%d, size=%d, breakmax=%d\n", delta, size, breakmax);
+
     test_tsc_deadline_timer();
 
     do {
-- 
2.21.0

