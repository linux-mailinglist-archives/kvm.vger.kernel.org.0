Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13BF258FF6
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 16:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgIALy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 07:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIALxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:53:50 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F381C061244;
        Tue,  1 Sep 2020 04:53:50 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so423060plt.3;
        Tue, 01 Sep 2020 04:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=deukqrTnR0cMzsDKDaqxmBI2QdBNNOMXdjj1IqkXDBo=;
        b=XGknnUl5Ax4ZlofOqiThlZt8dgwF/9fDJdmA9cH5irula3kLI7CPRZdtZKjoWcQvDn
         6B04V4QhFIMLMKg+Mhd8b086sl9AYx3mAjclN+TgDMQ319a+bG4Y//xrZ/QFSp6FwN1g
         0lO8uOwRIXqEUW1RzJNAIdBx8rj4eO8oOR4/GGJc1uusHoco4LjMvs4Lqe9ia/CEUqNX
         1ZwV0v1yg34L7gtWDlMPlZf3muPjnnssrC/R5Z6knCMEzWj+6mrPtfrQVSwZofUoNI3X
         6Nb51M0GQZmfzS89waYtM2Ee4I8ImR2PxPSgF1+3LvQlDDB2z2NYs2t7R/RzGLy1A5cz
         n0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=deukqrTnR0cMzsDKDaqxmBI2QdBNNOMXdjj1IqkXDBo=;
        b=uRgLdV3zy/Pe9lAaLZkpssfjnQaDfv3lfwfWQ0yy+HjoiyaYh+PgGfUwxRHI7x2Lvd
         hfzaFFCoI0I6u0GZaWuKlKIWGPECPV2tdKF/4zTDBZdjyb1rZKr3KpjRlp1qSs93wCYK
         vpWbllGo/5Rwq7ohwe1V3KX+EvI7vCgCKSN+oiiIplYAhrmsw3IC8FEKNpYESOJtSyZY
         bdjqgNYjXVqkz36s1mK8dIwT9Ubh0w8vztLaANgVV91lvtdYUFmcEc/gzXw9Ri9DbFsd
         mxydgBoJOCU/H/ImIaVuXhKswoEUbA57I8GKse9TPEjrU/jo9BhsHG7fPiHKxMzJau6R
         ifFw==
X-Gm-Message-State: AOAM533bQZGfWWR0JzSs6n+NyI3rYXCAdwTJz/T6wx2OvnTqvR2/dMQd
        CCRFFiTaPJ17x2mQIT2uIA4=
X-Google-Smtp-Source: ABdhPJwNjXvlt61ssgWgPZnZKqp427rrJB0T8ROpLi2YxiDjwxc1bBuVnFWLhkztKoKUIcxnj0fhnA==
X-Received: by 2002:a17:902:b111:: with SMTP id q17mr1066230plr.202.1598961229988;
        Tue, 01 Sep 2020 04:53:49 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.gmail.com with ESMTPSA id fs24sm1365344pjb.8.2020.09.01.04.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:53:49 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC V2 1/9] Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT support
Date:   Tue,  1 Sep 2020 19:54:43 +0800
Message-Id: <d7684439e1aa1c213c3a29219afda55b9b70b662.1598868204.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1598868203.git.yulei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Add parameter global_root_hpa for saving direct build global EPT root point,
and add per-vcpu flag direct_build_tdp to indicate using global EPT root
point.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/include/asm/kvm_host.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ab3af7275d8..485b1239ad39 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -788,6 +788,9 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	/* vcpu use pre-constructed EPT */
+	bool direct_build_tdp;
 };
 
 struct kvm_lpage_info {
@@ -963,6 +966,8 @@ struct kvm_arch {
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
+	/* global root hpa for pre-constructed EPT */
+	hpa_t  global_root_hpa;
 };
 
 struct kvm_vm_stat {
-- 
2.17.1

