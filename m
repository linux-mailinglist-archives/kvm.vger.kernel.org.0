Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212146CA472
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjC0Mqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbjC0MqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:46:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6F449EB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id r7-20020a17090b050700b002404be7920aso7659849pjz.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsaua7blaj4slx6G/pjAPsZzllQw2eT67bEuq+/vhBQ=;
        b=g8nZvqhQ81DeWCAYCmHwXEWwlZ8oG143q7tCezhLiol6BeuJT0o04oteNXda+H/6h4
         lXDEXnGBxGTV/FnWlDzBiF2Cdb3lkGpiBy4aM2C+wJiVWmtlglKRa6GAKpVNJUnztRSX
         PEMTz9T+0GHD++ivGp6hWcC5Uwe2DKuR9GVo8fkfwCOyB2x2NA1f5SlmUY9n+xpOKwa+
         +p4GpButq2nsLe/U48JpdOOyaYBUF6lAZBiT+MjQbNicyH+8aA3KnyJSVUxDyelVeaG8
         9PaZ78ft0jQly+8ZjpItSYEkqWTBRih9fer58PdU5fbDxu4zht9N114I3JNDqxMi6hgH
         6qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zsaua7blaj4slx6G/pjAPsZzllQw2eT67bEuq+/vhBQ=;
        b=zOV2EUL3MGLK2G9YWtQ0NczSj/v62H7o5AWLhJQLXARNd1VwGsH8I9oOcyXAUQ/4LS
         RkD23BZYJEAJtbk8iPnSIxOw3tDJAiL13dgypzgFL5AxCvJ4R6bVhrP1g1t+Q8mHSkg5
         rpBnuuKbdqBzeNmbXi+IGbyPVHOF6QLpdKIhccxAKOVYbrGrG5Rnw62ImBHQTlgGygx6
         OzYxHJolcLK5g3KjQdPRywBjjWlTNEo8zBqmo+9G7VyDIKo7M5pNOoJAfDBVo3cKc0TQ
         ZQP9wRnmpFp+NkCTtrME1pp+ycMMFABjIS829wM61Pz0yvGxsvy1IZu2ir4x+6ky3nLX
         +L6w==
X-Gm-Message-State: AAQBX9dWf/V/EIvjIMK7ppXYaDN2VonHxO40pzUNq3MBgB5i1oaSsiSr
        HrxGv9YCXtVIxh9PnWQ74MyvkX+Gh+4=
X-Google-Smtp-Source: AKy350ZqqCNhdHy5dN7TneKop3XAUuoIVIYVPdueQWnxdb6dRGyf+T+HmPK9JaTmoSlKRtvf+OA9fw==
X-Received: by 2002:a17:902:cf47:b0:1a1:a830:cef8 with SMTP id e7-20020a170902cf4700b001a1a830cef8mr10258979plg.27.1679921174465;
        Mon, 27 Mar 2023 05:46:14 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:46:13 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 13/13] powerpc/sprs: Test hypervisor registers on powernv machine
Date:   Mon, 27 Mar 2023 22:45:20 +1000
Message-Id: <20230327124520.2707537-14-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables HV privilege registers to be tested with the powernv
machine.

Acked-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index d566420..07a4e75 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -199,16 +199,16 @@ static const struct spr sprs_power_common[1024] = {
 [190] = {"HFSCR",	64,	HV_RW, },
 [256] = {"VRSAVE",	32,	RW, },
 [259] = {"SPRG3",	64,	RO, },
-[284] = {"TBL",		32,	HV_WO, },
-[285] = {"TBU",		32,	HV_WO, },
-[286] = {"TBU40",	64,	HV_WO, },
+[284] = {"TBL",		32,	HV_WO, }, /* Things can go a bit wonky with */
+[285] = {"TBU",		32,	HV_WO, }, /* Timebase changing. Should save */
+[286] = {"TBU40",	64,	HV_WO, }, /* and restore it. */
 [304] = {"HSPRG0",	64,	HV_RW, },
 [305] = {"HSPRG1",	64,	HV_RW, },
 [306] = {"HDSISR",	32,	HV_RW,		SPR_INT, },
 [307] = {"HDAR",	64,	HV_RW,		SPR_INT, },
 [308] = {"SPURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
 [309] = {"PURR",	64,	HV_RW | OS_RO,	SPR_ASYNC, },
-[313] = {"HRMOR",	64,	HV_RW, },
+[313] = {"HRMOR",	64,	HV_RW,		SPR_HARNESS, }, /* Harness can't cope with HRMOR changing */
 [314] = {"HSRR0",	64,	HV_RW,		SPR_INT, },
 [315] = {"HSRR1",	64,	HV_RW,		SPR_INT, },
 [318] = {"LPCR",	64,	HV_RW, },
@@ -306,7 +306,7 @@ static const struct spr sprs_power9_10[1024] = {
 [921] = {"TSCR",	32,	HV_RW, },
 [922] = {"TTR",		64,	HV_RW, },
 [1006]= {"TRACE",	64,	WO, },
-[1008]= {"HID",		64,	HV_RW, },
+[1008]= {"HID",		64,	HV_RW,		SPR_HARNESS, }, /* At least HILE would be unhelpful to change */
 };
 
 /* This covers POWER8 and POWER9 PMUs */
@@ -350,6 +350,22 @@ static const struct spr sprs_power10_pmu[1024] = {
 
 static struct spr sprs[1024];
 
+static bool spr_read_perms(int spr)
+{
+	if (machine_is_powernv())
+		return !!(sprs[spr].access & SPR_HV_READ);
+	else
+		return !!(sprs[spr].access & SPR_OS_READ);
+}
+
+static bool spr_write_perms(int spr)
+{
+	if (machine_is_powernv())
+		return !!(sprs[spr].access & SPR_HV_WRITE);
+	else
+		return !!(sprs[spr].access & SPR_OS_WRITE);
+}
+
 static void setup_sprs(void)
 {
 	uint32_t pvr = mfspr(287);	/* Processor Version Register */
@@ -466,7 +482,7 @@ static void get_sprs(uint64_t *v)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 		v[i] = __mfspr(i);
 	}
@@ -477,8 +493,9 @@ static void set_sprs(uint64_t val)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_WRITE))
+		if (!spr_write_perms(i))
 			continue;
+
 		if (sprs[i].type & SPR_HARNESS)
 			continue;
 		if (!strcmp(sprs[i].name, "MMCR0")) {
@@ -550,7 +567,7 @@ int main(int argc, char **argv)
 	for (i = 0; i < 1024; i++) {
 		bool pass = true;
 
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 
 		if (sprs[i].width == 32) {
-- 
2.37.2

