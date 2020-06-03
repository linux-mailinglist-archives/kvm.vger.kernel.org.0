Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1751ED9AE
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 01:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgFCX4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 19:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgFCX4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 19:56:40 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43335C08C5C0
        for <kvm@vger.kernel.org>; Wed,  3 Jun 2020 16:56:39 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 16so3069736qka.15
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 16:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w71DdQoWum2Kp6HNHDyrfluiKwehR5flNSkldp7Yl4Q=;
        b=smSuSqbmLTccA6vOZlnRM/vE0/sge5FA19Nc5PVOZ+kQkwmQ37IiTqru4rLIB3E/yI
         vqcNwdYxFep2OdAiOgE0121ZfmmHXwfmDld8s5m6PfwWAYwpB7UqFJ/wiJYc1xn9ezXS
         +bbDIwDHVmIQCOnRvGX89q+bmGKpnSgk2YvG/xpY+q7fWNdeRMlytoGUhHuzqv+RWF1u
         k2lzWYj+RLO4QVFRESrUcE43WJr/6xdLUfvC3BH+/fnxz/Rl69VlT4HR4CBseen44wxo
         JHkBUlAhHP31vjwQ/8xWXYtE1GjlFjNp4kbwQBKom4z6Fm+EFMY5NaNpRnzztmYwdpUz
         u17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w71DdQoWum2Kp6HNHDyrfluiKwehR5flNSkldp7Yl4Q=;
        b=kXn7t4on7+w4THgVjMWV+nqlSbHTsHAoXEK8Cj7P1w6hlwy6mwPfQsvNcnpkEYghDy
         mz/ArsYLV2xCY2lzDhhhmDCND1qM1vnhqhqd1+Y+7lKg0wuBAeMr4osuMXiqUXNnvBSr
         vGuQll1v9n+wDRjZTYFdjHZbatpxSTLEzBHC5WfhfcNV3XK18yoakNeibqnU93IdzpBn
         n0yPgHKGyDVPtBHeVFybDKuGvDNoj6noItoj2lJ6nHYNDc02sVT6n0NNHkwCyPaUhOJl
         Vlj9H5FsnkjdA7Kw/Z0eFGZWBPZSxDr/euGxuZcDIjnqDFF7rG5qNLWuvFShxGWGOtR2
         esIw==
X-Gm-Message-State: AOAM532bgRcplEqxRP65dE7wtb2n8DmZGm9h8dGphiThxmKGmtrOzOIE
        KXMgZtKr7LQcNkmZrfmnk+SczsDXY7t0RW9jcW1KXzw/925ExI0m6qG/EdBcbLqIZs7Tol+z7Lp
        re4RhGpFnbYfuZGBr9D+YZClzNBvpw71ynn8N4QwPbXWWIKF68yV94xZls+8/0g4=
X-Google-Smtp-Source: ABdhPJxPcmxK3XHmCKL9nTYT4vJYNFxER2QLv1pIoAATcju0Hv2rQ3KTC6n3u9ivCYADrvoi1fsUsRqy4hXH8Q==
X-Received: by 2002:ad4:472f:: with SMTP id l15mr2342045qvz.52.1591228598212;
 Wed, 03 Jun 2020 16:56:38 -0700 (PDT)
Date:   Wed,  3 Jun 2020 16:56:20 -0700
In-Reply-To: <20200603235623.245638-1-jmattson@google.com>
Message-Id: <20200603235623.245638-4-jmattson@google.com>
Mime-Version: 1.0
References: <20200603235623.245638-1-jmattson@google.com>
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v4 3/6] kvm: vmx: Add last_cpu to struct vcpu_vmx
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

