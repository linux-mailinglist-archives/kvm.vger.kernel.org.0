Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC2D39BEB2
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhFDR3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:15 -0400
Received: from mail-pj1-f73.google.com ([209.85.216.73]:53067 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFDR3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:15 -0400
Received: by mail-pj1-f73.google.com with SMTP id pf14-20020a17090b1d8eb029015c31e36747so5620041pjb.2
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p5DAeovxZ7wrgmDRjP+sOlFBRY+PyiE6SmRmHOZJBYY=;
        b=RVGm+2FC7bIETqrHZ4snFv9hATJXMrwKRNf2M7TawTlRXmjDbeV4QBbrJAD7etmVtT
         VPH4vuH92+JaMz65UJ/fErWbFwk2dV5z2R5aG+QIJ+lLEFCtV4X/TDRpFJ6SyGteMAt/
         zrRvjqN4zITmypX0IpPqO3ILSlGoK7dxXWcJlHpV8a8Y3VBfzuycl7HUkDLcEs40KBmR
         VuW18U+N85pUK3FgXkz6QwIunLIxmTcjMYXCjMNQG1zv0lxjtMRF/PSHKI64mVCUl5Fs
         6TT8VcTM7u6OMOBXcsQ6w1xJO49D7pW4UVZaUEZoJWtN0swd5+NgLyusau7SZIv0WNIC
         7ZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p5DAeovxZ7wrgmDRjP+sOlFBRY+PyiE6SmRmHOZJBYY=;
        b=DJrj2S2uuOjnX0aEtPgjPDz6sCm6dvGJUnOS5FO3FMT7kEcXikazZi2hyCSOu8/oGs
         NMJ8mr2Mv2uCFfm9iWku+TbtEN/uH7ZI4vN7x3wjO9soiBskyy5NEcucatyd2oXVtvE+
         v9BO3AO/Qf/oR7fW/7BZ72jcKyTlIIXe1JanhpMQdxQTpX3n6t9kPnDUxPwkbdmCebkC
         KJMxRjIQqUhGjJcDEJiABNVCt9+BcHDZRParP82ZsCq1nQqJkwrbcEPQvLE3AkoT7ZJD
         5nzDYvDzt0Rw4vSwc1Oyi3BzGz5oYBJuqHiqy7NOZXzSLIzp0haaYWHiowM1ceWHwSDn
         UZ5g==
X-Gm-Message-State: AOAM530+DLKXAYt+EqYgh8dw0T6cxMUOunSsIVq+ZfgZeh5LelutADby
        Ivj43RQxYg0aQ+bntudy2jLZ5bb0cc6RNA2GYY2j5XGbUUP7v71WWQOUWwfRPhAIj1Udb4/xa7M
        Sv+bKO3eyfzAFcHeP/GZFjCNfm5VyEl5lkmNGtKCvpR7C3FjSsGJceuzutcTenms=
X-Google-Smtp-Source: ABdhPJzhKqG5tmYLa5uJHQ8cmrddNJFo0oukfoU8R5YBbZKpbh7rDh/bc0d7qYZFc5wgbyw/F+s1N5JIhvW4gg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a63:b955:: with SMTP id
 v21mr6140950pgo.230.1622827588623; Fri, 04 Jun 2021 10:26:28 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:00 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-2-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 01/12] KVM: x86: Remove guest mode check from kvm_check_nested_events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A survey of the callsites reveals that they all ensure the vCPU is in
guest mode before calling kvm_check_nested_events. Remove this dead
code so that the only negative value this function returns (at the
moment) is -EBUSY.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b594275d49b5..882457e92679 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8535,9 +8535,6 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 
 int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 {
-	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
-		return -EIO;
-
 	if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
 		kvm_x86_ops.nested_ops->triple_fault(vcpu);
 		return 1;
-- 
2.32.0.rc1.229.g3e70b5a671-goog

