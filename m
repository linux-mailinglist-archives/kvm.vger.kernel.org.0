Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C054A3A065F
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhFHVtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbhFHVtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:49:51 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631ABC061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:47:58 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id g12-20020a056e021a2cb02901dfc46878d8so16255659ile.4
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4A17gJzJ1kAenjV8HCdX+pKLR+NA8dR0yX/rB5Wyus4=;
        b=sZ03P3gmdWaLshxczUdD9Od3bFJUln8rI4ImTn8BDyJzHtddp3THf5COkhfLMdj55E
         n9sjgUCKQgP4l6XRXdCHfCyOxu9hvHY16sqhT5/R6MnHcwV+HuxNq1NlyJj3uadUFc4n
         H7r4IxlGZHiAuvHOQ1gg1tFGgdhyKWQakRbEG+U2ckcGSCRIM5nYO7UbFtMxfpZwvKAE
         +fjddPP9+5BdMz7lTndnpx7znrI/Msz/7n33UV3eAkPwFaiEb5kqY7CxJfGm7Mkw6Xqm
         aKbHQ34Eby8DGH6OlizugwpfJIrMiZjv4GfocR3ndPv29968ap/g4kMYOR2TTuB1RcY2
         SR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4A17gJzJ1kAenjV8HCdX+pKLR+NA8dR0yX/rB5Wyus4=;
        b=KiO41peRyuNimke/cMf8O8OMUja9smA6/qUDSFtk+6gqqyJPMK7ceowOCSBuDB+C69
         MFEDBhguDwpZ4W5xcr30nzZ7bxvYA8Ha5aqp2xoxbldOmb6HA5y792OhF6ZEUMQ9Aebw
         Z79n8Oa2iaKAZwHkVxLSFLDcAG3Ni+YVP31tDitwO6qhXTQhB7BJxA7SK+PpheQGBVbA
         uTR0cLs7wHyFEt1IK2gHbOZo1QuJ/o0t5sHtDB8PWknKD66YRYeQGmLAWdn7PijFdNpp
         1UA2GD9/yFSK06YgDnxFYax3o6pyZuGB6DLCjBs/IEMwUu5MJqbK6XRb0j0tKMLH6u23
         fLkA==
X-Gm-Message-State: AOAM531lWaMvl8hYoeCscm2uqD6tpf4q8ziNr+4r8Z3Yy5z0ys/QuKM8
        jwXc40M63D+at27JID+E6APOXvH/ro1jez1MwOboObLKc+QbkWm21faFsUniq6NT2ygl8DD2Tv/
        pBvRylwupUYS5kbzTjL4+Z1gqRlWavsvNuuhp4paP/Y+Hd6ImcxaXlob22Q==
X-Google-Smtp-Source: ABdhPJxnS6SA33thGYVUqbqETQx/fbnXtTuCiMbrOX/ip3kv7XfbzDxbKzCuHLNRXwCPmcgEWAfR4WhvG1c=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:9842:: with SMTP id p2mr20519082ios.132.1623188877580;
 Tue, 08 Jun 2021 14:47:57 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:33 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-2-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 01/10] KVM: Introduce KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Correctly migrating a guest's view of the system counter is challenging.
To date, KVM has utilized value-based interfaces (e.g. guest value for
IA32_TSC msr on x86, CNTVCT_EL0 on arm64) for migrating guest counter
state. Restoring counters by value is problematic, especially for
operators who intend to have the guest's counters account for elapsed
time during live migration. Reason being, the guest counters _still_
increment even after calculating an appropriate value to restore a
guest's counter on the target machine.

Furthermore, maintaining the phase relationship between vCPU counters is
impossible with a value-based approach. The only hope for maintaining
the phase relationship of counters is to restore them by offset.

Introduce a new pair of vcpu ioctls, KVM_GET_SYSTEM_COUNTER_STATE and
KVM_SET_SYSTEM_COUNTER_STATE, that aim to do just that. Each
implementing architecture will define its own counter state structure,
allowing for flexibility with ISAs that may have multiple counters
(like arm64).

Reviewed-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/uapi/linux/kvm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..562650c14e39 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SGX_ATTRIBUTE 196
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
 #define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_SYSTEM_COUNTER_STATE 199
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1645,6 +1646,10 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
 
+/* Available with KVM_CAP_SYSTEM_COUNTER_STATE */
+#define KVM_GET_SYSTEM_COUNTER_STATE	_IOWR(KVMIO, 0xcc, struct kvm_system_counter_state)
+#define KVM_SET_SYSTEM_COUNTER_STATE	_IOW(KVMIO, 0xcd, struct kvm_system_counter_state)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
-- 
2.32.0.rc1.229.g3e70b5a671-goog

