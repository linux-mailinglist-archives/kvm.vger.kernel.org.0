Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61BB56C6AE
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiGIEV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiGIEVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:19 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798284E63A;
        Fri,  8 Jul 2022 21:21:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x184so635339pfx.2;
        Fri, 08 Jul 2022 21:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kqgIf//8Dsl2ovKoNOr5TejvwiroTvJl6z8lZ1nXLAM=;
        b=Usw0VXUMjNukfejaUnXIB/Vzmd2l1UiAb2WfP4Q7LdDheS5mNfYmk6pTkv8u6Klc/7
         0Ooi9So+aPuDD9nC3tHcZXKB5ONHBfKFZk/7a+CFpsVl2pQo8NbtYC5Br5kmi8718iUK
         70vvL6czsqWCMJUkTbpmJxu3GMnZOhFadG1NkBb22fz3+VJIOLeRT3AT1TltyItI7ywT
         9OIOJEkfZ7IRzyg+3SXtV5wwPLfHM9b61jkesevh5qyLDlcvfEeyVpXCE/8wB0V+T5E3
         jq1tLgwfEffn07CUDmMg2Cp3fOYjvFqkYOjciuACHOHczbAli9cv2Q5xj75KyUAKRPOQ
         3VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kqgIf//8Dsl2ovKoNOr5TejvwiroTvJl6z8lZ1nXLAM=;
        b=dfiA02IfVdkMgX5JXoRAvQop4KkbACWqvV87XqGBqSNKdGuQyoEqtXyNEUegsRyw9j
         Klqu4czR0uQqEi6pxRZ7XUu8ILreCbBkBjARDhMFU66Rd/QDD5Ak1AmcEk8Fdj4xBD7a
         AiV0it1BhXAfqvv9O+H6tfpV/cYPhFao7RONdMoz4JUAD2d2dZNNHQzcjarItUie8mGT
         9DfOvFY6O2UU3Z3y7G/hC9fgJMOGyb9TUNLfkmVgbB3nEB91g/UhzeQEw69YmAzOFFUi
         zY7BBi60cKP0HM5GxiTlxonbHvDIVMKXVQxkbmQ9rR38m4tEdI0pbfPQ/aX4XnSy8Ub9
         /nSA==
X-Gm-Message-State: AJIora9KYhPOCuHPEr4N1eV1GbxPyUnBKAcKJBPDV9aUWtEE3rfHgEjE
        0I6wNMVMIV/GTwGK6+CLFNQ=
X-Google-Smtp-Source: AGRyM1uaifn+sBYgGLh8V7LYIVrg6zY7zfcgJlqWMsGptHsp8J2gb+VBTHjpdj48qGOH+OiPgJv7AQ==
X-Received: by 2002:a63:8641:0:b0:413:8c07:4ebf with SMTP id x62-20020a638641000000b004138c074ebfmr6136013pgd.604.1657340476917;
        Fri, 08 Jul 2022 21:21:16 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id m6-20020a1709026bc600b0016c325141d2sm287884plt.15.2022.07.08.21.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C22FD103874; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
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
Subject: [PATCH 04/12] Documentation: kvm: tdx: Use bullet list for public kvm trees
Date:   Sat,  9 Jul 2022 11:20:30 +0700
Message-Id: <20220709042037.21903-5-bagasdotme@gmail.com>
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

The 8th external reference (public trees), doesn't have bullet list for
listing, so the reference is rendered as continous paragraph instead.

Use bullet list for the reference.

Fixes: 9e54fa1ac03df3 ("Documentation/virtual/kvm: Document on Trust Domain Extensions(TDX)")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/intel-tdx.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx.rst b/Documentation/virt/kvm/intel-tdx.rst
index 7371e152021621..1e3ad0ca2925bf 100644
--- a/Documentation/virt/kvm/intel-tdx.rst
+++ b/Documentation/virt/kvm/intel-tdx.rst
@@ -417,8 +417,10 @@ References
 .. [7] Intel TDX Virtual Firmware Design Guide
    https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.
 .. [8] intel public github
-   kvm TDX branch: https://github.com/intel/tdx/tree/kvm
-   TDX guest branch: https://github.com/intel/tdx/tree/guest
+
+   * kvm TDX branch: https://github.com/intel/tdx/tree/kvm
+   * TDX guest branch: https://github.com/intel/tdx/tree/guest
+
 .. [9] tdvf
     https://github.com/tianocore/edk2-staging/tree/TDVF
 .. [10] KVM forum 2020: Intel Virtualization Technology Extensions to
-- 
An old man doll... just what I always wanted! - Clara

