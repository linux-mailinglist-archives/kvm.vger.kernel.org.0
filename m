Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286BE64B53E
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbiLMMgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbiLMMgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:36:14 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E18513E9B
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:11 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso1075596wmb.0
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAS00uDwTnX0iz6OiEnof4qv+85R5FD/5UPI6Ha2V80=;
        b=lQmDA90DbXEwC7qP5vPds/7EEfMXj/0zvOwqP7kxXmDGx6j9d3G5fJXLl9eVN3Voby
         7N9XLDnv8YW2mE0ZUfC80tjWsajTp1tMWPNqsm2bfIm9lKyRnWmA9PHbpELvM/WJ0nDD
         SaDduq0n3B5HUjsRgR+3CyFagqZYjN05fZ5T7VPL7tdRQ0BujZ6hJYF/EoyT+nzBd/sy
         H55ydNcpEOcoDROHV+kPvDP0fguBIb9JZKbAMePgLuxyHHQuK25RhVlJ192zx2oE/P23
         mTVu+xEKOhWXgNY5Y4wcrdeL1R+mTMHhV2Oau8MdxRaN78GpBLJIMu4DiIOMQgHi84Py
         +R+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAS00uDwTnX0iz6OiEnof4qv+85R5FD/5UPI6Ha2V80=;
        b=tTuVCT6pCk7GOY937o822tey7TWtLFR8RrZgsew/6cVOMeJDGztuyyDxFYoOMn6eLF
         UpdbVOEb5AkM27crXF7Z00qnMwAKcKA1sBLo4cky+PFlW3bnGuhLNfu8iXvwfdYTsO8p
         kVR2v7ZL/DcOZwXc7/FhbwE9x25Ffl3ZySs05SCCOJe4SWEWK5aXO3H+D6t5GgS+ZDfK
         IIFiwgI7rUv8QAKfHUSdDy/4u3ubN5NqP2zxhHcxkpHmekKe3nb3nSZnfBkgUMK9ztEG
         dhiHsctlYJs5dhNIGOBID0Na7OaQBD6wTVgg+fd8zsj1YUdoBT2hsgwzQueKq5LBc0Qc
         693Q==
X-Gm-Message-State: ANoB5pnaKqA7HJ6TCnXqEbBeyIxzB/DmPB3hvFWLrLfAM7lOIzys37Dn
        Zi+7d229FALTP0yeh+0SNg048aOhtG6JGKNJ3Mk=
X-Google-Smtp-Source: AA0mqf6Q7a99lz4o6i2mZR6Xev5Bo/BCPIkxBFwblJpymEZdQWi+7bcEYuWQEdQoM9waol9RshSezg==
X-Received: by 2002:a05:600c:22ca:b0:3d1:ee97:980 with SMTP id 10-20020a05600c22ca00b003d1ee970980mr19035459wmg.7.1670934970165;
        Tue, 13 Dec 2022 04:36:10 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id q13-20020a7bce8d000000b003cf71b1f66csm12090266wmj.0.2022.12.13.04.36.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Dec 2022 04:36:09 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-8.0 3/4] hw/ppc/spapr: Reduce "vof.h" inclusion
Date:   Tue, 13 Dec 2022 13:35:49 +0100
Message-Id: <20221213123550.39302-4-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221213123550.39302-1-philmd@linaro.org>
References: <20221213123550.39302-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently objects including "hw/ppc/spapr.h" are forced to be
target specific due to the inclusion of "vof.h" in "spapr.h".

"spapr.h" only uses a Vof pointer, so doesn't require the structure
declaration. The only place where Vof structure is accessed is in
spapr.c, so include "vof.h" there, and forward declare the structure
in "spapr.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr.c         | 1 +
 include/hw/ppc/spapr.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 66b414d2e9..f38a851ee3 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -62,6 +62,7 @@
 #include "hw/ppc/fdt.h"
 #include "hw/ppc/spapr.h"
 #include "hw/ppc/spapr_vio.h"
+#include "hw/ppc/vof.h"
 #include "hw/qdev-properties.h"
 #include "hw/pci-host/spapr.h"
 #include "hw/pci/msi.h"
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 04a95669ab..5c8aabd444 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -12,7 +12,6 @@
 #include "hw/ppc/spapr_xive.h"  /* For SpaprXive */
 #include "hw/ppc/xics.h"        /* For ICSState */
 #include "hw/ppc/spapr_tpm_proxy.h"
-#include "hw/ppc/vof.h"
 
 struct SpaprVioBus;
 struct SpaprPhbState;
@@ -22,6 +21,8 @@ typedef struct SpaprEventLogEntry SpaprEventLogEntry;
 typedef struct SpaprEventSource SpaprEventSource;
 typedef struct SpaprPendingHpt SpaprPendingHpt;
 
+typedef struct Vof Vof;
+
 #define HPTE64_V_HPTE_DIRTY     0x0000000000000040ULL
 #define SPAPR_ENTRY_POINT       0x100
 
-- 
2.38.1

