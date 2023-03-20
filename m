Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F066C0B11
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjCTHEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCTHE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:04:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A867E1ACC3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:21 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x15so816787pjk.2
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZbjlTasSONwXllC2HqRMaGJgoOY5hFq11Z16oH5Qegc=;
        b=PztoECeU4eSPlpnxP10sTi1Qd2rhNdKcNNHaLInp7h6OhXizPsQQEpje419VcxZmTI
         w4VU+uBzeu+bI3QeEUxWU9H+MumBY/awIPUPJd9OcNyuOLlBMTozF/F89TbKU3czwPRk
         XKrzrOEy+oMdC2YN+WFPfQcieQNQqEcZVHyeGkXN9+jLoNL8RF8uvOVyn771L6kwchag
         MA/qj0vqh6mJDsOwpSoLH0X9rgTzjAbe0TNGcVk7/ZEGf3IpE9KahX4voQdHgrqK+EFY
         0wcL1bH+XAUH4AVkGupXApKPv+JZHxImke1e1PlEGQTALxUVkwaddOohwjlVSbzQWGlb
         KTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZbjlTasSONwXllC2HqRMaGJgoOY5hFq11Z16oH5Qegc=;
        b=js3LLPB70ZkojYf1utCU7DjLITKUstBBIHRa6EahWiLekDCacf7uiwT2gdJjaYQCvp
         SEmbcqUzrc+9nn+zA0GIGO40owpI1tskQN8zHFcPkIgB8ZS7EtL/gnx+3ZmLGsPFyhqV
         c2q5c5742Jz3Gpoju6Bqb+ah/+UoZNu0ZhfOxWsjuX1cXTMNRgIJHYMxTPkjNQaPQrsN
         Gi2OcrZJmW/jS7d5+X7P7UOwrEWFGynzqDIn92YVRgk4IW+amwANt99arekwBd15RgtF
         i1/+g9TFbIFBKerUNSmcfVwFDDdEAndAZHAV6DV7SpGZOK6pW9rD+sU+GFXUs2ruCHK5
         H72g==
X-Gm-Message-State: AO0yUKVQeFSLmNJBqkzukxfMQSmDpZ4R/RyNTgzCYo2JR87N0dZ9Ofdo
        65b4n45u+A9l/Ryj5/n9rlD9UuAxCGo=
X-Google-Smtp-Source: AK7set/jaMzzlJKFuuUyn+HnC/wFMBZiTZaBCZKifCuXO23qeITyMRCnQPFbgUawXRJW4cLObs6ZGg==
X-Received: by 2002:a17:902:db12:b0:1a1:ce99:b0c1 with SMTP id m18-20020a170902db1200b001a1ce99b0c1mr3958461plx.32.1679295860556;
        Mon, 20 Mar 2023 00:04:20 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:04:20 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 10/10] powerpc/sprs: Test hypervisor registers on powernv machine
Date:   Mon, 20 Mar 2023 17:03:39 +1000
Message-Id: <20230320070339.915172-11-npiggin@gmail.com>
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

This enables HV privilege registers to be tested with the powernv
machine.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index dd83dac..a7878ff 100644
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
@@ -462,7 +478,7 @@ static void get_sprs(uint64_t *v)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 		v[i] = mfspr(i);
 	}
@@ -473,8 +489,9 @@ static void set_sprs(uint64_t val)
 	int i;
 
 	for (i = 0; i < 1024; i++) {
-		if (!(sprs[i].access & SPR_OS_WRITE))
+		if (!spr_write_perms(i))
 			continue;
+
 		if (sprs[i].type & SPR_HARNESS)
 			continue;
 		if (!strcmp(sprs[i].name, "MMCR0")) {
@@ -546,7 +563,7 @@ int main(int argc, char **argv)
 	for (i = 0; i < 1024; i++) {
 		bool pass = true;
 
-		if (!(sprs[i].access & SPR_OS_READ))
+		if (!spr_read_perms(i))
 			continue;
 
 		if (sprs[i].width == 32) {
-- 
2.37.2

