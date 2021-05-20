Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8BE38B9F3
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhETXFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbhETXFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:16 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B775C061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:54 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q69-20020a17090a1b4bb029015d3adc1867so5604750pjq.1
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0wnPxFKJXC46QgurgGHA4bPpgEK+w7m9Db4mfJ3t1U4=;
        b=czYm0NO48HwGfZe9uAslmUeU4TD4wSespBbvjx5QE0twujoMwW/WmqH4vNPLmaPjy4
         raAb5h3/XAaDef0lgujKIqisbSi/guRBrwOwIQ3Dhf0eZtKXWbYBLMEEKUbqAPMWad4d
         rgrdfG5uDwY0LjaykYzo5A2sa/C803OhG7d8jMDZaO+yVwwDemoIKbrZB1mJwic9noFP
         mSgohQgDygCU/eFcDTNr8QVIb9zSE1JkLFs82fFo5saLbDrJ3uXbeTQY3tpGuuASgpsG
         aJxvWDOu8LtzpKRrV8Q134EPd5wktvJuqEJVVvhKXp6eEYEDMsApoSwTMmMl0ACMS73n
         SakQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0wnPxFKJXC46QgurgGHA4bPpgEK+w7m9Db4mfJ3t1U4=;
        b=KOpcrCit6JprJUmtdd06cm4OzUUrmbRIpjCSlIp1c/3+M9XxjR2cJ34tLgrVJqtD8F
         RyNk/Hnm5DhNwn9o1KdZ/rBvVCg/ZEAJefgdPqf/PN/Ot7ib8Y4E0PQSuaqjh1r/zVqw
         3ZSSKjDJWmyMtq3ciOFtv24ezU4iwVJ0TyQaOCtuEtbHOARNPYsDGw1atPPW7SRSK9EY
         ox1vO4EXTqeR5Uf9TM4d9wkdil2Qdw9YrEuIPFpP1qqHUoehVVtb33aIp1PXLEASHTzF
         OEeF0bUdqMWIkg6MxVYIaEfyHnFqWqVZ+mkdn7ipti5msFzEJ0eCxlkjTnYQ9tS4qoSM
         ZnTg==
X-Gm-Message-State: AOAM533QlN55zHLPGElLfDswozMULJtpN8x5PBGkALJspKvdR4YnUDlx
        CwYntbdzSdwELkX6pgxzm8T++7iTZPP2dgfi9cm+GC+2o1bjhDLYsiTXYdBpi8qLj2zL8gGCCMV
        Txw8o4SYZXKib4Hann3nQ4DWc4nC9c55YeOJCG9BOjrJDrc5oFfMRF9Hsa8YpC1E=
X-Google-Smtp-Source: ABdhPJwogPEeX0EIXIvC+Rv3y6zKg/JPTqgJABWCbjZJt12EiwCUrRACL5l9ljGidGQAf2FTqPNS/eitntt+RA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:e309:b029:f1:9342:2036 with SMTP
 id q9-20020a170902e309b02900f193422036mr8481442plc.53.1621551833624; Thu, 20
 May 2021 16:03:53 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:28 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-2-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 01/12] KVM: x86: Remove guest mode check from kvm_check_nested_events
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
index bbc4e04e67ad..d517460db413 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8532,9 +8532,6 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 
 int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 {
-	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
-		return -EIO;
-
 	if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu)) {
 		kvm_x86_ops.nested_ops->triple_fault(vcpu);
 		return 1;
-- 
2.31.1.818.g46aad6cb9e-goog

