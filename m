Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3C06C0B08
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCTHEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjCTHD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:03:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AAE1ACD7
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:56 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso11341280pjb.3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIWY2LmAYAKCX0X90e1eTyFfSUAt3YEGtck6kHvirNk=;
        b=gS7qrRrqDq9qaoQtkXcKK7pK215yAtZn8WaF9oNZmAozAsFFIthRfko3R60iN1xLvF
         nSxnb2hTRNoDhYtW4OfnEgEaUQEc4hzOUP0/Wa3RSMWDulBoymhgYS228uVW2Bf0mzZV
         urboUDVMhQ7v+hboL3TjcMqnTnxA2TayOf2aOzpxGbT9+zSW8zo8TIAdicRRHcc/Xwy8
         IlXx1LleYUdU3Tu7rzoO2VDhNWoEdFCT1ix+Ab7uk3cH3zAzLaXUVl1PgrtdD4kJxKpg
         4e/CYZZNCaxbR0ilPDzZFFNMPitKEGtnlOkfGxS7ggi77SS2sMSWMq/QWtKasmuVrX+R
         tmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIWY2LmAYAKCX0X90e1eTyFfSUAt3YEGtck6kHvirNk=;
        b=6Ut7KXLXwYIU8+/5TkNC+aKAybxmLWH1O2a51kuXJ1c/NKL3xsPIr5I/+Rh3En28BT
         eB4ICzRkXW6a6fRRCpDgLJTDWthjy7EKHhVhKrbBj9ciwWD8LuaPKs9K1C9Q9Y3Cregc
         3iYteXLekAL4Bc9NWgXPBCcn9/hCvwPI+SgkAhFJmex58Lw9Dd2n8Pb12DwNnaRuTsme
         0hdodirXZPpFFVcrm705jQeMx92IWEY8EhCv/xZW6X1CacH6ZYqXK2uZHLJKh31GEn8D
         aQWitYgLNeHkK9dxrW1jJZmfj5a6aNM0H3wpt46k3R0By4RVrQzLUrEdybycrheaaDLW
         wKtg==
X-Gm-Message-State: AO0yUKUg6H0yxFPJovVZSfTY0yR34kS30v6cVaSz+DFfp4HelT9kfqqH
        9MHLvt2/5aOw6W/QsnNP+hDmZPsUFpI=
X-Google-Smtp-Source: AK7set80VvNHpr7RdDIyXTdK5iNN0SrMj76F2SEmfeacDKttsSBDoOBYBQjHltZXByAun+9uYVs7Uw==
X-Received: by 2002:a05:6a20:cd5d:b0:d5:1863:fe5f with SMTP id hn29-20020a056a20cd5d00b000d51863fe5fmr10506331pzb.2.1679295835154;
        Mon, 20 Mar 2023 00:03:55 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:03:54 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 02/10] powerpc: add local variant of SPR test
Date:   Mon, 20 Mar 2023 17:03:31 +1000
Message-Id: <20230320070339.915172-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds the non-migration variant of the SPR test to the matrix,
which can be simpler to run and debug.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/unittests.cfg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 1e74948..3e41598 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -68,5 +68,9 @@ groups = h_cede_tm
 
 [sprs]
 file = sprs.elf
+groups = sprs
+
+[sprs-migration]
+file = sprs.elf
 extra_params = -append '-w'
 groups = migration
-- 
2.37.2

