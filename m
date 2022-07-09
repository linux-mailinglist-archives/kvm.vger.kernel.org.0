Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9368656C6A4
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 06:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiGIEVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 00:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGIEVU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 00:21:20 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3B54B0E2;
        Fri,  8 Jul 2022 21:21:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s21so633511pjq.4;
        Fri, 08 Jul 2022 21:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uc2nzWj3GO3b5HUllJokkKuyzfzRetWmte+HK193uOQ=;
        b=i06nVhPonWm+JM9xl/dd/0p/O5J7aTiWCZAbG9qdk8Li8lvxFrCx92Anh26b5LPe80
         jkcNLI9u/rAQ4gBNl+TaTNBkggsC0z6ud/chHCv3q8QkUL/qOnUA5RstffkdMKuA5qnd
         78Xs7mzIQZnXa89Xh7C8m5mmOHpbkbLi2lPD31on7XgR2Bd2EZky6cW1K6tg4Yu5FEr1
         hgiOwfCZ64IfEaDHmbIcGvly9Ka6SYdzRJb+d2hXJ8cTL1qLlcrlouZ9x98JpUoqBBmS
         2YMbA8POsl/sAoLssd2snQhovnMpIC4l2k41Of+qmumGpcCxJHB1J1xn476mqdWg+499
         HGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uc2nzWj3GO3b5HUllJokkKuyzfzRetWmte+HK193uOQ=;
        b=kGc99Vkir/oDBeKBnZT86M8lD4jKPGzZZQeitQIq0YCijnUgTWsIX9qwWWFSBtvVE/
         jWd74GSzX7w7cJX2ewPAKCgWAt2yGa/iLGMrLOLLvbJM1uHanZn1x7OTuos7jzUuWwQK
         VKAsxSd1cKjTmafgm8diNNU8uttRebxZiAk9ZCr9fpCFb4REsegiLqnirvO8UJlVOekx
         A85YS2h2Dw24KlIN9JGIvQcM4S2i+eBFJYuDgjvnf26hv2bi9lh4Rj4gLhc/72po1ult
         PV+I0IkBqocP/QxhKjru+3kmiTN/XGwkFW3zV2+e1M95AzgqfsHbqpeouHiunK9JGpre
         BJYw==
X-Gm-Message-State: AJIora+Pv0AkLA+oWMtEWjwDZkLEGjmJwmjcjKehCg9qwbxrw3iar4LI
        kBGhlf4PUbrP4TYMq5ubCdA=
X-Google-Smtp-Source: AGRyM1vQ5WjnidPWh3oz/3gYL8JM5bSyUewuloXko384/8Ex/0+LkeDTe7iXU+VyBzr5v8+QUYhvCQ==
X-Received: by 2002:a17:902:e946:b0:16b:d4e1:a405 with SMTP id b6-20020a170902e94600b0016bd4e1a405mr7015887pll.16.1657340479553;
        Fri, 08 Jul 2022 21:21:19 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id n5-20020a622705000000b005254c71df0esm408394pfn.86.2022.07.08.21.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 21:21:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 59A35103943; Sat,  9 Jul 2022 11:21:10 +0700 (WIB)
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
Subject: [PATCH 03/12] Documentation: kvm: tdx: Add footnote markers
Date:   Sat,  9 Jul 2022 11:20:29 +0700
Message-Id: <20220709042037.21903-4-bagasdotme@gmail.com>
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

Sphinx reported unreferenced footnotes warnings:

Documentation/virt/kvm/intel-tdx.rst:353: WARNING: Footnote [1] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:355: WARNING: Footnote [2] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:357: WARNING: Footnote [3] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:359: WARNING: Footnote [4] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:361: WARNING: Footnote [5] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:363: WARNING: Footnote [6] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:365: WARNING: Footnote [7] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:367: WARNING: Footnote [8] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:370: WARNING: Footnote [9] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:372: WARNING: Footnote [10] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:375: WARNING: Footnote [11] is not referenced.
Documentation/virt/kvm/intel-tdx.rst:380: WARNING: Footnote [12] is not referenced.

Add missing reference markers to fix the warnings. While at it, reword
"Overview" section paragraph.

Fixes: 9e54fa1ac03df3 ("Documentation/virtual/kvm: Document on Trust Domain Extensions(TDX)")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/virt/kvm/intel-tdx.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/intel-tdx.rst b/Documentation/virt/kvm/intel-tdx.rst
index 7a7c17da3a045f..7371e152021621 100644
--- a/Documentation/virt/kvm/intel-tdx.rst
+++ b/Documentation/virt/kvm/intel-tdx.rst
@@ -8,9 +8,11 @@ Overview
 ========
 TDX stands for Trust Domain Extensions which isolates VMs from
 the virtual-machine manager (VMM)/hypervisor and any other software on
-the platform. [1]
-For details, the specifications, [2], [3], [4], [5], [6], [7], are
-available.
+the platform. For details, see the specifications [1]_, whitepaper [2]_,
+architectural extensions specification [3]_, module documentation [4]_,
+loader interface specification [5]_, guest-hypervisor communication
+interface [6]_, virtual firmware design guide [7]_, and other resources
+([8]_, [9]_, [10]_, [11]_, and [12]_).
 
 
 API description
-- 
An old man doll... just what I always wanted! - Clara

