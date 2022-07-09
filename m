Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8300256C68F
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiGIEVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGIEVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:18 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E8B4E62C;
        Fri,  8 Jul 2022 21:21:17 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p16so397659plo.0;
        Fri, 08 Jul 2022 21:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ycgZMvq2EVogDaqogTrk1vbctpDqtsq51oWL+KX1fwE=;
        b=IUDAVGaP5i3wsy3MP7idxdjv/VjJdS+DB+cAE3/YgLZLVDuWvQB9rVuxzkECFqDnUs
         RKd8CYxxe2w3QYWEaaoyivVcPG29K32MEkFPDK9ivuexTkUrQqm6IY9gq4wcCW199PIS
         WQ2GI28IgKCEhda632Rr1HUJJOioldYc17bWyhoKqfMfajnHBczDGV/vk8wZjRkMoHA9
         HboWCIZ1UYh/OhQqsjXMnt4rJ0MbWEzzPeF30lwAvWAU9549IigCdM10XeYWlaqKCL6G
         8Y4iDGHxfkyayiuDvhbZaUt8O9vPgy4f/UDazRQCO3clor3TQ2PTTwsP+aPbJNjmTI1M
         4yPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ycgZMvq2EVogDaqogTrk1vbctpDqtsq51oWL+KX1fwE=;
        b=yPcoPsDqxo9AKwk8fJR0CcCoGZtcmYMF+G5iWa23CzqLCEQOkhjH6xENrPK/xNAHMi
         XW6Qgp9BlnuDtEMVS/vdxGLlHyipI+Y5ktJHgnnq+vlvbsSH2Uc0nu0Q1g+WFWS22KI/
         Dt+5KDvAAciUTtqJfKk8grP1PZZfa+mX5dmHK5n9SDosWe/2p0HG+YgPKOL+qEPqbtzF
         lC7wfy+Jw9m3I1EQ3snC+UKdoxOtLNfTGaLkCNw72qE7eRyUtr/+EFmY3LlGY32wY29B
         VbBxgmHibQ2CxYccbAy3ymKHB/cfYVEeoAjZHC1DIoZcqQGdOnP+osdC2uUk7j+Gj2oc
         vfRg==
X-Gm-Message-State: AJIora8lbgfuMSySafkOsZmth8T8CZDAkYyjOxRVnRFGIh0sRJOwU/tq
        D0Ufas0hAxmZMBiq8tA/Coo=
X-Google-Smtp-Source: AGRyM1u3R/Bf4/mPqH1iFvrcy+Oj5Qvhdsg7oo64sXJHUcB+TfJl++7Ezz2mL+4sZEqgogHTXga2Ag==
X-Received: by 2002:a17:902:eccf:b0:16b:f555:d42e with SMTP id a15-20020a170902eccf00b0016bf555d42emr6858192plh.75.1657340476542;
        Fri, 08 Jul 2022 21:21:16 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902f35100b0016bf803341asm332158ple.146.2022.07.08.21.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E3A411039B1; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
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
Subject: [PATCH 05/12] Documentation: kvm: tdx: title typofix
Date:   Sat,  9 Jul 2022 11:20:31 +0700
Message-Id: <20220709042037.21903-6-bagasdotme@gmail.com>
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

The page title contains misspelled "Dodmain" instead of "Domain" and
missing space before abbreviation parentheses. Fix both mistakes.

Fixes: 9e54fa1ac03df3 ("Documentation/virtual/kvm: Document on Trust Domain Extensions(TDX)")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/intel-tdx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/intel-tdx.rst b/Documentation/virt/kvm/intel-tdx.rst
index 1e3ad0ca2925bf..5288631c80122d 100644
--- a/Documentation/virt/kvm/intel-tdx.rst
+++ b/Documentation/virt/kvm/intel-tdx.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 ===================================
-Intel Trust Dodmain Extensions(TDX)
+Intel Trust Domain Extensions (TDX)
 ===================================
 
 Overview
-- 
An old man doll... just what I always wanted! - Clara

