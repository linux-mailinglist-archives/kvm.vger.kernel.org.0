Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3427556C6A3
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiGIEVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGIEVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87A14E62D;
        Fri,  8 Jul 2022 21:21:22 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso387478pjk.3;
        Fri, 08 Jul 2022 21:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uXohxGFGaSlqXK87Mr0YBkysDoOymE++YQPhkvmJrvQ=;
        b=HE8j8luJq5h1OVBEDnt2bDyyG7gQ2TMvxhS4BO3wfbCbmR8FkSpOcnyR0mY/yrOxRD
         IWaLMdksPZHL559pF7ATCp2BCzEJh32ZvazfJGvu0ZA+axdFXRjiTEbo6cnXIym0PO4L
         zL1mZoXem+M0MOzMHAn1jIsn7IkMA3mp36smXIpERaBOFNlsixXj7lRz243aQb665ruU
         xC5Omi6ECS/i186oFtOZ5VURfQHw9t8JMIlKeN9DFF2/k7tGKo9LSwwjUmHw0gB7ikFy
         PtXaDBSLpjT9EeCOUhGKn7PV4IV3dBh34xk48Ss65fPGXmwHc3Yi8INqPclj/CH+JBMs
         MUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uXohxGFGaSlqXK87Mr0YBkysDoOymE++YQPhkvmJrvQ=;
        b=25+OP/6SO3WHQQecfcY5l9FWeici74cp3G8valuKB9O/iqb1S4nlJRaDc6CxpHDxnB
         FShYkZD5bIQ2geSUsPGA7QLynlXDI+FQniSQnwOD3cv4zDjb/ikxodhIMDGxa0M14Gob
         WQBTd8bywjpj6fS/DLkI2f8iiHSi84Aky5LFMcLTBFaCOtp8Sj2ytVxYOjG0sLRaEyqC
         olDv8mCH2GLhMAqKhsoOk695S51MuTX3LzxFdLkm42L80UuQ0O7VnUUeTl/usE12yWie
         Ox/rVYG9o6zELEkCUWHfmb5glLpyAtqq+1cKzmd++wOBKhn5n4lD5AGDKgU/NEwxzEfI
         WLbA==
X-Gm-Message-State: AJIora+upEKSBwkhJFt/SAayXZvRRCaQJEZyolrztxc6svYuIDwSSBGe
        SLQt7cR79IcRU3IQx2anf7dG3hzMOps=
X-Google-Smtp-Source: AGRyM1vmqFdcqlLmm7x18MzA2ZZ+0RAazzVXsdxgZZQh9Dp3fyiu6FXsGc6jJS3l7w9g3lqpVqcWxw==
X-Received: by 2002:a17:90a:e7cd:b0:1f0:c82:c88f with SMTP id kb13-20020a17090ae7cd00b001f00c82c88fmr1181858pjb.100.1657340482346;
        Fri, 08 Jul 2022 21:21:22 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902d88a00b0016a268563ecsm353896plz.23.2022.07.08.21.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:21 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id EB5BD1039D6; Sat,  9 Jul 2022 11:21:11 +0700 (WIB)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 09/12] Documentation: kvm: tdx-tdp-mmu: Add blank line padding to lists in concurrent sections
Date:   Sat,  9 Jul 2022 11:20:35 +0700
Message-Id: <20220709042037.21903-10-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220709042037.21903-1-bagasdotme@gmail.com>
References: <20220709042037.21903-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The last warnings on tdx-tdp-mmu.rst are caused by missing blank line
padding at lists on "concurrent" sections. Add the padding.

Fixes: 7af4efe3263854 ("KVM: x86: design documentation on TDX support of x86 KVM TDP MMU")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/tdx-tdp-mmu.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/tdx-tdp-mmu.rst b/Documentation/virt/kvm/tdx-tdp-mmu.rst
index c403e14fb223aa..f2170c154e18c3 100644
--- a/Documentation/virt/kvm/tdx-tdp-mmu.rst
+++ b/Documentation/virt/kvm/tdx-tdp-mmu.rst
@@ -418,8 +418,10 @@ Concurrent zapping
 2. freeze the EPT entry (atomically set the value to REMOVED_SPTE)
    If other vcpu froze the entry, restart page fault.
 3. TLB shootdown
+
    * send IPI to remote vcpus
    * TLB flush (local and remote)
+
    For each entry update, TLB shootdown is needed because of the
    concurrency.
 4. atomically set the EPT entry to the final value
@@ -429,6 +431,7 @@ Concurrent populating
 ---------------------
 In the case of populating the non-present EPT entry, atomically update the EPT
 entry.
+
 1. read lock
 2. atomically update the EPT entry
    If other vcpu frozen the entry or updated the entry, restart page fault.
@@ -436,6 +439,7 @@ entry.
 
 In the case of updating the present EPT entry (e.g. page migration), the
 operation is split into two.  Zapping the entry and populating the entry.
+
 1. read lock
 2. zap the EPT entry.  follow the concurrent zapping case.
 3. populate the non-present EPT entry.
@@ -451,7 +455,6 @@ In this case, the TLB shootdown is batched into one.
 3. TLB shootdown
 4. write unlock
 
-
 For Secure EPT, TDX SEAMCALLs are needed in addition to updating the mirrored
 EPT entry.
 
@@ -462,9 +465,11 @@ Add a hook for TDX SEAMCALLs at the step of the TLB shootdown.
 1. read lock
 2. freeze the EPT entry(set the value to REMOVED_SPTE)
 3. TLB shootdown via a hook
+
    * TLB.MEM.RANGE.BLOCK()
    * TLB.MEM.TRACK()
    * send IPI to remote vcpus
+
 4. set the EPT entry to the final value
 5. read unlock
 
@@ -477,7 +482,9 @@ condition.  A hook can be added.
 1. read lock
 2. freeze the EPT entry
 3. hook
+
    * TDH_MEM_SEPT_ADD() for non-leaf or TDH_MEM_PAGE_AUG() for leaf.
+
 4. set the EPT entry to the final value
 5. read unlock
 
-- 
An old man doll... just what I always wanted! - Clara

