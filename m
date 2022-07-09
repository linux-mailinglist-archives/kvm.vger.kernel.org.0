Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF5A56C69A
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiGIEVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiGIEVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA214E62D;
        Fri,  8 Jul 2022 21:21:20 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e132so520690pgc.5;
        Fri, 08 Jul 2022 21:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmsBiF1bgWBH6D/tGpWmc727qWXK6kbebDM6d8nqWio=;
        b=XisW8uiAvzkDnOmdeVLfqYui4om1zOH9XYk55C8AaArgrrxwTvEK10ZyQ3+n72yG1v
         r7OqxnW5tlqC7d3mVu4RnljDsdNQZJYDP57CFCjhoHPXhdZn9lkikBGJ7XUaY0F503nZ
         F2qauaBXmMcmmWI9sbO9Udx1ceeNW8SO4MVUsJLJ8k4JjR10+uIhKLwwIgtCkVUhsUB8
         5hn2eobGjEnFQyfQ8FkXgCtnLo0AMMfIlbKs4R7uzwgMU5gI7X3uBYCY/OC1CCYBQtpN
         qLBqQBJUnaj15a4+pOOTUAyMefpKOHPWtoaps2v2fTcDu6YrSePewYzpaMwOZdkzdG81
         2ntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmsBiF1bgWBH6D/tGpWmc727qWXK6kbebDM6d8nqWio=;
        b=7ULy77E3VnxqG6mMCOQGBoWdd8N/lyotL+1OIV+zpIbSkBWeveitqKWM/mQgKazeOp
         eqBnj+5M44IaoU5V7xnCuvMBYtxzfg+207KcFPqNwv4ximF8aiO6b+mnxllyttfrMOzv
         A0WKndcc3qtGs31KcNKAasL9lG6t57TrFT6sHvZPksrRTqe3sXnA3hw1SkeATn9zNK8n
         SbwVtosEKjA2Yj/BacKTtvD6VXQxbx++u5pt4l+9R/oqQZdelUL+oCYm73BGt/6Qoa3P
         wnNPXpuISSGNcyglkh6CTCBIEylb6FyDxAlbHzBimv9e3pVNV82o3MFIJhE1WIS1vb/I
         6UHg==
X-Gm-Message-State: AJIora/hkT7MT7n/Wq0uHiQ+LjOafccFhRS6JrLPrwwe/cgujiuqgXI3
        UQNqwJVvgPwLWHfIgjQ7sJs=
X-Google-Smtp-Source: AGRyM1tkyFBwvw19aBJHDt9BeSGGHtV1veLf3x9y8MLe8GzuBWMBDDIr+0nazZ/DXDqPn/pKo9A1pw==
X-Received: by 2002:a63:d94a:0:b0:412:6986:326e with SMTP id e10-20020a63d94a000000b004126986326emr6357310pgj.56.1657340480383;
        Fri, 08 Jul 2022 21:21:20 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id x16-20020aa79a50000000b00528baea5dacsm392817pfj.201.2022.07.08.21.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id A18741039BB; Sat,  9 Jul 2022 11:21:11 +0700 (WIB)
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
        Bagas Sanjaya <bagasdotme@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 10/12] Documentation: x86: Enclose TDX initialization code inside code block
Date:   Sat,  9 Jul 2022 11:20:36 +0700
Message-Id: <20220709042037.21903-11-bagasdotme@gmail.com>
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

kernel test robot reported htmldocs warning on Documentation/x86/tdx.rst:

Documentation/x86/tdx.rst:69: WARNING: Unexpected indentation.
Documentation/x86/tdx.rst:70: WARNING: Block quote ends without a blank line; unexpected unindent.

These warnings above are due to missing code block marker before TDX
initialization code, which confuses Sphinx as normal block quote instead.

Add literal code block marker to fix the warnings.

Link: https://lore.kernel.org/linux-doc/202207042107.YqVvxdJz-lkp@intel.com/
Fixes: f05f595045dfc7 ("Documentation/x86: Add documentation for TDX host support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/x86/tdx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index 6c6b09ca6ba407..4430912a2e4f05 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -62,7 +62,7 @@ use it as 'metadata' for the TDX memory.  It also takes additional CPU
 time to initialize those metadata along with the TDX module itself.  Both
 are not trivial.  Current kernel doesn't choose to always initialize the
 TDX module during kernel boot, but provides a function tdx_init() to
-allow the caller to initialize TDX when it truly wants to use TDX:
+allow the caller to initialize TDX when it truly wants to use TDX::
 
         ret = tdx_init();
         if (ret)
-- 
An old man doll... just what I always wanted! - Clara

