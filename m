Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04F84DA96E
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 05:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353553AbiCPEy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 00:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242162AbiCPEy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 00:54:27 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084AD6399
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 21:53:14 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id f11-20020a056602070b00b00645d08010fcso642456iox.15
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 21:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=K14DZH14W1w3Fib+HTcSKKVS8x/nXI0p88zYgtmQW+0=;
        b=jGbKOmklfkwDfsqs9g+OAPJYaLJ8qGWRH4dR+7c2DsvfPGKFh5+8l7h8sh3DVYbOhA
         99d/g6QCXNUsBadJ3kjcMFkpgEXJNnPIrQ08C4wWU6cceBy3nFFRMmxOuznCRMvLBfrx
         L1hdrngyJgYABFezjfaeZmIVPh7w4187SJF/LyZjyXmKVq51lnnv9ErvrCvKYrOMfa8R
         xLEbPTGgr6WVMlSdOna8PWd/jT1cAz/x9NbG4HBvMptcnz6xFTebiMAEUbIkZBcRBYNG
         XHI8C0G03UX4rasyg60WVDONc8oMYkT5begmkxAW0MGIS4NlN7PNWJwqprUZWWwgfp9u
         B3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=K14DZH14W1w3Fib+HTcSKKVS8x/nXI0p88zYgtmQW+0=;
        b=sHscUkKqYkqgRYP+9rVRireQX6A6PjqUMq91u5zXTa1A5Yjsou27ru6Vzf1QDYk2Fa
         lEJRTAJfMTBHWWzXXN6JzpaI+AKf891IfX1lrdc6yf+ZSZndanffGC0ynx/YTmJd7ujA
         mB8Azj6Zbi5JKVPKdUDTlpxR4ANPRmQAB2hj/DhLDD6jpB6JjbCO385fKrHNeg85rXsp
         D5LSZi2JqSrz/hAHx89aZ4MwFoqPOaq1ONBtesCSkHq6TXGudQjPrkktHncPdde1CeSp
         7Q2kbuaiWL9XFdieqdiReNO8H19o1NY4tbLNAg74gIBqavz0auNzKOGgDfVHqZs6YWuN
         4uDw==
X-Gm-Message-State: AOAM532N44dPilfiE7LC3LQMAWN6KIGMNGn5KMNcS5X1LPNPEqS6/H5e
        Ml20znCuG2J7OA/xAmLf73gC4u2JQ/FeX5f0qGgpr8PFpzKXEjhyEDZaQfAw4Pq3KthMEmgG2D1
        2fiRvnqSYyhXcZL8Wdvxe/Qkd2WN1XvB5Oeg1wIx16H2tFr0SvsP07Mo6rw==
X-Google-Smtp-Source: ABdhPJzUpXcPo1CW5aMWeaY4HypQJwIoVFwfwdpz5CjdIbFfnKLT0Sq6kMqHMyO7kbls4RXVvlj3kQoPvgE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:3006:b0:317:9daf:4425 with SMTP id
 r6-20020a056638300600b003179daf4425mr26057944jak.14.1647406393341; Tue, 15
 Mar 2022 21:53:13 -0700 (PDT)
Date:   Wed, 16 Mar 2022 04:53:08 +0000
Message-Id: <20220316045308.2313184-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH] Documentation: KVM: Describe guest TSC scaling in migration algorithm
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oupton@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
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

The VMM has control of both the guest's TSC scale and offset. Extend the
described migration algorithm in the KVM_VCPU_TSC_OFFSET documentation
to cover TSC scaling.

Reported-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Oliver Upton <oupton@google.com>
---

Applies to kvm/queue (references KVM_{GET,SET}_TSC_KHZ on a VM fd).

Parent commit: 2ca1ba339ed8 ("KVM: x86: Test case for TSC scaling and offset sync")

 Documentation/virt/kvm/devices/vcpu.rst | 26 ++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60a29972d3f1..85199e9b7f8d 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -180,13 +180,18 @@ Returns:
 	 ======= ======================================
 
 Specifies the guest's TSC offset relative to the host's TSC. The guest's
-TSC is then derived by the following equation:
+TSC is then derived by the following equation where tsc_scale is the
+ratio between the VM and host TSC frequencies:
 
-  guest_tsc = host_tsc + KVM_VCPU_TSC_OFFSET
+  guest_tsc = (host_tsc * tsc_scale) + KVM_VCPU_TSC_OFFSET
 
-This attribute is useful to adjust the guest's TSC on live migration,
-so that the TSC counts the time during which the VM was paused. The
-following describes a possible algorithm to use for this purpose.
+The VM's TSC frequency is configured with the KVM_{GET,SET}_TSC_KHZ
+vCPU or VM ioctls.
+
+The KVM_VCPU_TSC_OFFSET attribute is useful to adjust the guest's TSC
+on live migration, so that the TSC counts the time during which the VM
+was paused. The following describes a possible algorithm to use for this
+purpose.
 
 From the source VMM process:
 
@@ -202,7 +207,10 @@ From the source VMM process:
 
 From the destination VMM process:
 
-4. Invoke the KVM_SET_CLOCK ioctl, providing the source nanoseconds from
+4. Invoke the KVM_SET_TSC_KHZ ioctl to set the guest TSC frequency to
+   the value recorded in step 3 (freq).
+
+5. Invoke the KVM_SET_CLOCK ioctl, providing the source nanoseconds from
    kvmclock (guest_src) and CLOCK_REALTIME (host_src) in their respective
    fields.  Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
    structure.
@@ -214,10 +222,10 @@ From the destination VMM process:
    between the source pausing the VMs and the destination executing
    steps 4-7.
 
-5. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_dest) and
+6. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (tsc_dest) and
    kvmclock nanoseconds (guest_dest).
 
-6. Adjust the guest TSC offsets for every vCPU to account for (1) time
+7. Adjust the guest TSC offsets for every vCPU to account for (1) time
    elapsed since recording state and (2) difference in TSCs between the
    source and destination machine:
 
@@ -229,5 +237,5 @@ From the destination VMM process:
    a time of 0 in kvmclock.  The above formula ensures that it is the
    same on the destination as it was on the source).
 
-7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
+8. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
    respective value derived in the previous step.
-- 
2.35.1.723.g4982287a31-goog

