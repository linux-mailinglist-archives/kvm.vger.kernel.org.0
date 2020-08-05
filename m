Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CF223D383
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgHEVQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgHEVQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:16:19 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C408C061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:16:19 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p127so31679393pfb.18
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/bAS5D2FJOOziY1CDNb4uJHD5HOqYsb4+TMybYazvIg=;
        b=mv7UhRfKMQ2m1bjS3VLO0pKWVJPBF1rZJcqBWuEt+nmztm+VoCHSgVNYKuCLEWeV6F
         m6xuk5m2QFpCEDQS0RI8KXjl7xR5ICXO0CWDXQkih27I9i5kBdqFfwgRAivXqQIlUFvp
         GZWzMWD2UZy4DgRL4dyFdubPY2xMJrQfQATo+8QN8B3eoJbNcaZJNwa3R3mNUma9QdNd
         NlLjC5pnw707L542z2Db06ki54GShdLxHWWI76emdm0AxImXKT/34BDGSqLoh47G64Hy
         2GqUw8qPvoadNrGHzA7V7JI9J3lN61w4Sj87RD3vfEf3t6sRyrTqv0p6yxIrRPcre6Ro
         O3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/bAS5D2FJOOziY1CDNb4uJHD5HOqYsb4+TMybYazvIg=;
        b=GOBRHKE4iMZ4qrhm0rCsod2HJKr9Yn9s4gMUu/j832JoIE9E3omURD9IwfMo+v2MW4
         x7X0YbxbsiFVmS5K9k5Y1fwhJjiIP0dPcGRbx+gSvdE93UOcuWEDkoZD+f5aaug2Wtzk
         MuG3nXqLws643rXlbh7+lHsO0rLkirKBL5Ci7d7ZwSJC9fibGBw9jwslf+nOx3NjR7Ha
         7vP5xg7MhNymIqgE4Bs6OtlH5I/1iLt+T8UL5XNwz1XEoxwKKHKIr1wB2+AGAEi9vbgj
         ofV3FzYryCljYDJNwlRf94Y2D1v3cj7JmxF0EOYnJJ+XhJXsVqoaqLhoQ+KSj/atCo4E
         sOqg==
X-Gm-Message-State: AOAM531kwDkdYXF4N6YN2ArrbFvI+nr1JS8XE6PX0rmihMHjA6FtDH/o
        rHsI196TbCB+nkFsGD2JhATE0iY/EUi3nK6s6V3DgY96STegnmIb0mYi6Ugc5CJ6tjDfuT8d8BX
        EpjV4F+ajTnN1aXaDxLMFtcglXoyO1n8FbC+TQOw2ag/+sycaU9p3rJTVpw==
X-Google-Smtp-Source: ABdhPJxRdshxmWa9rVRClkJUkuRDg0Sf/x8iLN46SOtdAilVOsmCNVdNipD+3WESPZx0zBLI0lVAEorO6Vg=
X-Received: by 2002:a17:90a:f30d:: with SMTP id ca13mr5432094pjb.225.1596662177723;
 Wed, 05 Aug 2020 14:16:17 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:16:05 +0000
In-Reply-To: <20200805211607.2048862-1-oupton@google.com>
Message-Id: <20200805211607.2048862-3-oupton@google.com>
Mime-Version: 1.0
References: <20200805211607.2048862-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH 2/4] kvm: x86: set wall_clock in kvm_write_wall_clock()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small change to avoid meaningless duplication in the subsequent patch.
No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: I77ab9cdad239790766b7a49d5cbae5e57a3005ea
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d18582aefa9f..53d3a5ffde9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1790,6 +1790,8 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	struct pvclock_wall_clock wc;
 	u64 wall_nsec;
 
+	kvm->arch.wall_clock = wall_clock;
+
 	if (!wall_clock)
 		return;
 
@@ -2997,7 +2999,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 	case MSR_KVM_WALL_CLOCK:
-		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
-- 
2.28.0.236.gb10cc79966-goog

