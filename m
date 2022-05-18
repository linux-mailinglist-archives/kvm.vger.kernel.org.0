Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A227652C1E5
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiERR7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241277AbiERR7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:59:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F58E8CB31
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2fef32314f7so25129487b3.18
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wW/lYQK8VggoySTpe050tppXxqMna8Q7adRf7tVfVhg=;
        b=m7dz77VdABiVhTzfZaIE0LeeSvBl6t9Qe9hFsM9WYPe2IsqVOFN0CjpDqYmVm1IzVX
         lelo5I7GsEpdephGyPib6OfJPar543AGL0CyQXWm2mTzukn96l0CaUGRcaEOct9no4gO
         A5XScGLwYy9u48ePPFPh9hkTcjAZhnjw3riCuKtzo/lwuxduEUHbGS8vcrjl+dnb4m/L
         oQ9v7L4h//c5pAgL60dEsnNWnY/WfTj7W882amwZSRc96CGohagTca7JD1NDTSWfJdbr
         CdudJwHuEyUAeeTt6e34RcIMt4Y+q28oZCqtghHRxw8q7PFELQWtHBN7BZazYF49ApTU
         Mr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wW/lYQK8VggoySTpe050tppXxqMna8Q7adRf7tVfVhg=;
        b=6jA+O6WrGL0mU0EIUSXGq1v+TtalRszEdunORotD6K+DMXYwRvImEjPnUqQEhVAGbI
         HXhcdkoR3Gd0tLDXLyayeQHUM2k2EJHp0MIYn7mVwfTL30pT6kZzIiaLBqQjoS/2jYYa
         YcOJdtoGAIQXV45XoFxOrUe1z2NqYHeGGuLVGpk4Vq+vTdBw28WhZ+BLczsyTjSnr36m
         y7dt5ekgXonxz0rVJhB7GyRiU48m6GE+fHyEub3hX19TG4XSk1trjZeb8JEjaFypvRNF
         HG/FB3WgD7ZYQ/CHrqtp0He8CIrxUYBzA3bLh8kKMiJ7eOmTUU9hVYfp2Ya+j7PMnfw8
         9ZPQ==
X-Gm-Message-State: AOAM532g5MXzu4xPbXkR1jooPoq1Yv7nhayGD3NO8UlB0hhB0lMU8WtQ
        BzEs1h1/eZDvlG2hY0pVhaqRijCXFVpdHJGAMi+Kp9UYTakcMzm88xtSnv6CtRtpFfZD2IpHCrD
        Lp4pDJAPwNUq4by+yULHRffJYCY3LOKdBOuM/A0GyqV50nB6m0ro4+TyVLQ==
X-Google-Smtp-Source: ABdhPJw5H1xUyMPhKN/sPf1QXyNfjUugFkOmTeSYbv+d8ETvnoloSmWGNmYxD/mOirbcPIE+KlziYPCyXNk=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:e20d:0:b0:64a:6397:1fad with SMTP id
 h13-20020a25e20d000000b0064a63971fadmr780425ybe.496.1652896757121; Wed, 18
 May 2022 10:59:17 -0700 (PDT)
Date:   Wed, 18 May 2022 17:58:11 +0000
In-Reply-To: <20220518175811.2758661-1-oupton@google.com>
Message-Id: <20220518175811.2758661-6-oupton@google.com>
Mime-Version: 1.0
References: <20220518175811.2758661-1-oupton@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v2 5/5] KVM: Hoist debugfs_dentry init to kvm_create_vm_debugfs()
 (again)
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since KVM now sanely handles debugfs init/destroy w.r.t. the VM, it is
safe to hoist kvm_create_vm_debugfs() back into kvm_create_vm(). The
author of this commit remains bitter for having been burned by the old
wreck in commit a44a4cc1c969 ("KVM: Don't create VM debugfs files
outside of the VM directory").

Signed-off-by: Oliver Upton <oupton@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aaa7213b34dd..558de6a252de 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -979,6 +979,12 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
 				      kvm_vcpu_stats_header.num_desc;
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created.
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (!debugfs_initialized())
 		return 0;
 
@@ -1100,12 +1106,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
-	/*
-	 * Force subsequent debugfs file creations to fail if the VM directory
-	 * is not created (by kvm_create_vm_debugfs()).
-	 */
-	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
-
 	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
 			"kvm-%d", task_pid_nr(current));
 
-- 
2.36.1.124.g0e6072fb45-goog

