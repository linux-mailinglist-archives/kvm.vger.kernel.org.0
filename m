Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A7735D2FC
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 00:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343710AbhDLWVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 18:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343692AbhDLWVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 18:21:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C0CC061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:21:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d1so14056429ybj.15
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 15:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ESswuqujHLR9RwIvnBx5XZH5Vn+MJ5i3MkDtDukO9o0=;
        b=D1tTFUeCdmwluFUVTzpGwF3ju7lYDhrtdS9PuO6ZgTVDdac6bd3h6POmsudUhkQ09r
         eX+aoQ0wza9Jf/Pn0Qb/hFavoSCKVNrq4aaMzxcLGdzslfWx7cTII/CCjZTQEbztPi8o
         qPG9pePkOtNftszj1a3Jb1eTu++jck2aBPxIK0Yi8q5Zj9VXSKOd9ICfJSQ/1BOvycRW
         OFPRE7Mrwf0PrU5bTE3FjsCPN7UpcZmtvnzRraAgf+vjEanLqGBDlMdlPsTouuJ8T4Bc
         qngB/tersKAYsRm6t35MX9LJ21hhzAGHqjLVM5pFzdUA9sO8J5bOF8QFYg54izbwh1Wf
         9l8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ESswuqujHLR9RwIvnBx5XZH5Vn+MJ5i3MkDtDukO9o0=;
        b=N4W5BeuCkX/MKSeHlcYyJHU9e+VPrIPxw/SREcWOtMP0VBRkC1XyeYxILsD+ccPNVy
         D1E68vhudvIidXp710x4/mjMYvS3wLgpi8n+E+qkq7gnA6CgCjkrVVu6cg9ntUeXGzhd
         nxJvOhCI5i7gZfHFqxmk1bQ3XrR6PYYtNWZnPHmPtBDl6DyFDA20bhgEFUDtQ4BOi3T7
         cM1n6PCTWeqKPXFCjtEh7LE64kop6LXnUX9bZmaZlHTGsfPX9Ai8Mx91bRQ8fayH1YfW
         F+Q2WjcYKlyXWUEk0AIe+3FpfLJMQzv+m3lrZ9agAG/K+hEokX8iITLHNtMNz1urgyLu
         1KiA==
X-Gm-Message-State: AOAM533Fva4+xyNxrAazu3vKECRvPVPAiLPmsKSFNIUoJyhM/zN07XWa
        /IW43IBV7LgsLe4qONRRR8ALVT67s/A=
X-Google-Smtp-Source: ABdhPJy/vKp9lF3Y26AoMcKefOoc3C9FcpTbnn6rqDLQhJGEO8gZT+3DXRr2wOaM7WtseZ7zIBoiBj9XETU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f031:9c1c:56c7:c3bf])
 (user=seanjc job=sendgmr) by 2002:a25:4154:: with SMTP id o81mr12685872yba.69.1618266060926;
 Mon, 12 Apr 2021 15:21:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 12 Apr 2021 15:20:50 -0700
In-Reply-To: <20210412222050.876100-1-seanjc@google.com>
Message-Id: <20210412222050.876100-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210412222050.876100-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH 3/3] KVM: Add proper lockdep assertion in I/O bus unregister
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Hao Sun <sunhao.th@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert a comment above kvm_io_bus_unregister_dev() into an actual
lockdep assertion, and opportunistically add curly braces to a multi-line
for-loop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ab1fa6f92c82..ccc2ef1dbdda 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4485,21 +4485,23 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	return 0;
 }
 
-/* Caller must hold slots_lock. */
 int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			      struct kvm_io_device *dev)
 {
 	int i, j;
 	struct kvm_io_bus *new_bus, *bus;
 
+	lockdep_assert_held(&kvm->slots_lock);
+
 	bus = kvm_get_bus(kvm, bus_idx);
 	if (!bus)
 		return 0;
 
-	for (i = 0; i < bus->dev_count; i++)
+	for (i = 0; i < bus->dev_count; i++) {
 		if (bus->range[i].dev == dev) {
 			break;
 		}
+	}
 
 	if (i == bus->dev_count)
 		return 0;
-- 
2.31.1.295.g9ea45b61b8-goog

