Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8044A4E5
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbhKICmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241851AbhKICmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:17 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9787FC061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:32 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id h21-20020a056a001a5500b0049fc7bcb45aso3609388pfv.11
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iSH/9G2uxswFP6gkGEcQmnNa2z9g8VsdxM33bZx7bv0=;
        b=FNjNDlAP3hOxMC/RXn9EWgjxrA+hIShK3UY3VETSZOuZMJeHfitIHtJQZxvYQV+f4U
         Iq/swVyJQEUWRDtuU2WQYypz+xyoRoUfhUzx1kek+cHBteUTCGFdth6d4o6Jm9n+oucZ
         IgoKaTYNOIpCsOLYhKXDyHd84maT9VxoAsHSFqznaArbX9+6iESd9y9zxcDsBrepK7d0
         GFpAwakViIFKPT+Pu2ZrImzM9CtXEOk0XhW/XpnbXOWGZpw3X5sIb0Ftm0Cql2xNDzRI
         dpBpmZhwA0kp9e3zf1oxR/1e2V8fI5wk2Bi+0FNAuf5rWpVta3Oin7i4/v8Ruiz/8oJV
         OV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iSH/9G2uxswFP6gkGEcQmnNa2z9g8VsdxM33bZx7bv0=;
        b=3CnoETJodNXmJ5hiqGTJ77NqwZgFOWBAWwoJ8DC+mCuXHeDHAdKwRHBt1lbMPsdN5P
         ybIyBpTZvCejXQ/i1cprOSHdHtC4swusHm7gxt9ZenctDuTkmftSxWqeX+bRNhN6MpHL
         FxQuuiWrp07u1Fs3QQnkyPKaGlr3wMu7ZZUe4wqD42QeA7RCeQOKTG5hi8OskpeUUUkC
         UGbezX2KSjdOnKdtUfIOLGQF6Vx+LyQJhtdkydje8yj4+i4LgVRz8CDColn8COgc9NXN
         nmV7WX7i1D/PMXs2zdvsQO2TmnJ3QF9k1grIhK5wl/6dZwekqCbjdPeb9l4woLS+q8bb
         pgfQ==
X-Gm-Message-State: AOAM532hH5Q5VWZBKuyCe9yYjzdxFfa6sGJk5CyLr1T102DZOv6IhXfS
        lYCuvx+poE5mmk6JssgRKuAJGxJ/racAyGI88f0EbumZSdgbdWAbd6Kjvvw7VhCfpAakMWNVqXH
        f3V5Cih0vfAgvbxoIa5+Vq6+xm+HwicW5hv7Umyp0c1gp4mb2HvY8ln55epA7loE=
X-Google-Smtp-Source: ABdhPJxTt4UcxOyc1/klJdlWYcGN66uMv0GTJlbqC3+LaRYmHWJSHpNI1PabOWRufiE9dGE3qCyvSL9pxALf0w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:1b2e:: with SMTP id
 q43mr3347483pjq.56.1636425572028; Mon, 08 Nov 2021 18:39:32 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:39:01 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-13-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 12/17] KVM: selftests: aarch64: add tests for LEVEL_INFO in vgic_irq
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add injection tests for the LEVEL_INFO ioctl (level-sensitive specific)
into vgic_irq.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index a20d225367a1..bc1b6fd684fc 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -60,6 +60,7 @@ typedef enum {
 	KVM_INJECT_EDGE_IRQ_LINE = 1,
 	KVM_SET_IRQ_LINE,
 	KVM_SET_IRQ_LINE_HIGH,
+	KVM_SET_LEVEL_INFO_HIGH,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
@@ -98,6 +99,7 @@ static struct kvm_inject_desc inject_edge_fns[] = {
 static struct kvm_inject_desc inject_level_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_SET_IRQ_LINE_HIGH,		false, true,  true },
+	{ KVM_SET_LEVEL_INFO_HIGH,		false, true,  true },
 	{ 0, },
 };
 
@@ -406,6 +408,10 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 		for (i = intid; i < intid + num; i++)
 			kvm_arm_irq_line(vm, i, 1);
 		break;
+	case KVM_SET_LEVEL_INFO_HIGH:
+		for (i = intid; i < intid + num; i++)
+			kvm_irq_set_level_info(gic_fd, i, 1);
+		break;
 	default:
 		break;
 	}
-- 
2.34.0.rc0.344.g81b53c2807-goog

