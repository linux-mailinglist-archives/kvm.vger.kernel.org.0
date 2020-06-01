Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A981EB1AA
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 00:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgFAWYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 18:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgFAWYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 18:24:42 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AFCC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 15:24:41 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id s20so1550787qvw.12
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 15:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w71DdQoWum2Kp6HNHDyrfluiKwehR5flNSkldp7Yl4Q=;
        b=syFUZnRWEfAhTOeiMM2UmOa94rJraaS8S2V/4s+f3ryC8Szgv7pkdwhUTawue8wKd9
         fnVvScoBeennLI0tfOSk+e66+zsAPTZlebqPo9vuJhW63dr6UJuJ6WBUMGqlFLZANZH6
         fmB8DmSRYZ+Zjb7OjVWgESS6IGdn3ze6AfNgYkCuHL+pn0TcRBCzSmUsVOabTX7YuA0a
         T52QpNWIgS/QQs57bkDQQEJD2bkrq6/eXFFL5LTgga0orvPu/b63zPFF8C1QnE4lcgoO
         S4YXBSUL/AHkbIa9kL1Y/AnnAwzB+OuLjNdNf2sw6OC2S+4bo+RrWb3VXWcdPkjFSF3q
         pHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w71DdQoWum2Kp6HNHDyrfluiKwehR5flNSkldp7Yl4Q=;
        b=lbbh1z8UHVh13orSunPQQeo18lsehypN+K4qDCwd/AeAJsmn+vUI2L/TjFCDOO6h8n
         GBDuNR+exSJHvu7uft5xR3XbV2R7Md8WkgviCEMwHz8u8S0xn8TNqEvbTzZ4edUouvlC
         SwBY6hmYHxv0NtOxIIQdJENBhHGTJ0B+Ot9Ikl+AYwn1VAwUy33BZmC5EG80vv++rY5H
         rmrM0cuiUCnptZv68Rj14rShX+UfHc5hmyQzwBOpDn0XXYcX3dsGVHKeWQKvyESvBEFw
         Lp8Q4mZ3TvMsPH1yZ7d5p5aDnRcw0qIw/+PNHzEaQdE/hNjxib8pwhnzFSRJydv/z3L6
         KS8A==
X-Gm-Message-State: AOAM532Rs2HuyYkrKB0z8kyJmnVGoaC/Tw0juwratTrmgzLMMRoL+NuP
        GDQUIBl0Vcr2/EOkGFaOKNwmjby57EYE9J4MlRG+1ItVn96M15qlwLjdmDtgnttvEHuHaTSeS/B
        faO1bGhCr1FpNo7GHQo1cgq2HtWtsSEPV5Izab8VBWncmAES2PTtSKFJki8Qa8q8=
X-Google-Smtp-Source: ABdhPJzMQUW3JKYyhnldZa4MUjZO9LfwTQGgeRWfBFwulRuDoxg/UZ03Bbm0B350ww9DDFBfwlJgcrv+V4m++Q==
X-Received: by 2002:a05:6214:6a1:: with SMTP id s1mr22730957qvz.46.1591050280897;
 Mon, 01 Jun 2020 15:24:40 -0700 (PDT)
Date:   Mon,  1 Jun 2020 15:24:15 -0700
In-Reply-To: <20200601222416.71303-1-jmattson@google.com>
Message-Id: <20200601222416.71303-4-jmattson@google.com>
Mime-Version: 1.0
References: <20200601222416.71303-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we already do in svm, record the last logical processor on which a
vCPU has run, so that it can be communicated to userspace for
potential hardware errors.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 arch/x86/kvm/vmx/vmx.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 170cc76a581f..42856970d3b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6730,6 +6730,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.cr2 != read_cr2())
 		write_cr2(vcpu->arch.cr2);
 
+	vmx->last_cpu = vcpu->cpu;
 	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
 				   vmx->loaded_vmcs->launched);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 672c28f17e49..8a1e833cf4fb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -302,6 +302,9 @@ struct vcpu_vmx {
 	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
+
+	/* which host CPU was used for running this vcpu */
+	unsigned int last_cpu;
 };
 
 enum ept_pointers_status {
-- 
2.27.0.rc2.251.g90737beb825-goog

