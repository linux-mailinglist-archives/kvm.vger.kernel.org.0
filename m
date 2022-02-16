Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8394B86D3
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 12:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiBPLiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 06:38:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBPLiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 06:38:15 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6284766AFD
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:38:02 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso3852293pjs.1
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XVqbnjLYjeH1rc7fjv6cX2lZtkgpQ8GkwHWH0GF7qrk=;
        b=rOIF8zbR8HK9HJpDFP7k4gIjN/EnQq3RavPFLIWmtwnMnD3/0knaLBymq+wL7i1291
         WfkuAM2Np8vsBN6nszZC24SceImGwz6fd8wmx2Bjt6TBQ8XzfeakMnTsdUbFwqMfh13m
         GLbsISNcnZjenqBNlGXK87833AepzExvffTz+0xypytG4oOdVQF097lJ1FyyExM48mOQ
         z6GHYcmwc0IY/CXaAzkDkkKdZ7xyKA/IRcGpojx4og8rdmabHTczuo2zRjZEwzSfSy5r
         8Mq9r7qmI1xJIH23s2unqRKwlzjdRb48i0Oth45I37N4RaKdLZnqbmCAK85WSrgsbqch
         /5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XVqbnjLYjeH1rc7fjv6cX2lZtkgpQ8GkwHWH0GF7qrk=;
        b=R32BBFBMIlernBirppBWBk92+Glm16ADLHDFl0i+V7bmCdxfUSULVy2f7D0WPJ0Mrm
         Q8pDKG2C67QSVGP99ZQpYwApDKIX0C+jNQWPQ9MAOfZG49FLI0AN7ETQ3s2/LGkIdE49
         /BSJGzer7VfKyKUq+AFtfjQs5XnOOxdsmzG9hK5Xc6nmdx/t7t7WDH9RtcP6dn8GefWN
         SK0JLch06vYvxAlFPH1pUPz5AeYvyeo4WOlZrRAhL1LpjUbijSreS1d58cTcUrEZ+mlj
         Qihn4s9zqO9xKbo6dbfINdRozvulZ9Lhog7Wyg/z6FStrtDpR1NCZtuh1zPpqcEl9cNO
         qpIQ==
X-Gm-Message-State: AOAM533y1be6qvdxIw1/K0avTOixEddxYwdbkysJDUIurj4KlCP0X/ts
        5zfhgu5eLhlzrYJXy1AhyQb8sQ==
X-Google-Smtp-Source: ABdhPJweicWY1RRMSLzaOq+LFnlPrYlBuTWGm3p7RYY8VojheTr5PTFgTvBGSc934LYJoaQHDzxOsw==
X-Received: by 2002:a17:90a:a78c:b0:1b8:b769:62d0 with SMTP id f12-20020a17090aa78c00b001b8b76962d0mr1207077pjq.227.1645011481947;
        Wed, 16 Feb 2022 03:38:01 -0800 (PST)
Received: from FVFYT0MHHV2J.tiktokcdn.com ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id z21sm5248228pgv.21.2022.02.16.03.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 03:38:01 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com,
        alexandru.elisei@arm.com
Cc:     kvm@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH kvmtool v2 2/2] x86: Set the correct APIC ID
Date:   Wed, 16 Feb 2022 19:37:35 +0800
Message-Id: <20220216113735.52240-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220216113735.52240-1-songmuchun@bytedance.com>
References: <20220216113735.52240-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kvmtool boots a kernel, the dmesg will print the following message:

  [Firmware Bug]: CPU1: APIC id mismatch. Firmware: 1 APIC: 30

Fix this by setting up correct initial_apicid to cpu_id.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
v2:
- Rework subject and commit log.

 x86/cpuid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/x86/cpuid.c b/x86/cpuid.c
index c3b67d9..aa213d5 100644
--- a/x86/cpuid.c
+++ b/x86/cpuid.c
@@ -8,7 +8,7 @@
 
 #define	MAX_KVM_CPUID_ENTRIES		100
 
-static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
+static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid, int cpu_id)
 {
 	unsigned int signature[3];
 	unsigned int i;
@@ -28,6 +28,8 @@ static void filter_cpuid(struct kvm_cpuid2 *kvm_cpuid)
 			entry->edx = signature[2];
 			break;
 		case 1:
+			entry->ebx &= ~(0xff << 24);
+			entry->ebx |= cpu_id << 24;
 			/* Set X86_FEATURE_HYPERVISOR */
 			if (entry->index == 0)
 				entry->ecx |= (1 << 31);
@@ -80,7 +82,7 @@ void kvm_cpu__setup_cpuid(struct kvm_cpu *vcpu)
 	if (ioctl(vcpu->kvm->sys_fd, KVM_GET_SUPPORTED_CPUID, kvm_cpuid) < 0)
 		die_perror("KVM_GET_SUPPORTED_CPUID failed");
 
-	filter_cpuid(kvm_cpuid);
+	filter_cpuid(kvm_cpuid, vcpu->cpu_id);
 
 	if (ioctl(vcpu->vcpu_fd, KVM_SET_CPUID2, kvm_cpuid) < 0)
 		die_perror("KVM_SET_CPUID2 failed");
-- 
2.11.0

