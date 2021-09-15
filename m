Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9071140CED1
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 23:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhIOV3m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 17:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbhIOV3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 17:29:38 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABEEC0613D9
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:28:18 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id n24so5319893ion.10
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 14:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WQkUPnYzyIj6imY2siHAssmMkcSFNpsLGyNs+c8n/bw=;
        b=JnjBCXkfoljTWoBOUnDg5Vh8CuSHnEFvjPkYN63ahVDLJ75Z55KcQrMVr1Upl7MOOk
         cpNiNqEZ6l0Ju6k2PLrOYQFjiNSlNki3UjEzt14EaCivli7ZnnGyar9KGDqVb3OxLyQ3
         LAtbPUVkd08fC23fX077KsNd7hLN52tZZFoIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WQkUPnYzyIj6imY2siHAssmMkcSFNpsLGyNs+c8n/bw=;
        b=5rbvWAw262yfYQNTAx/QpSy+qyr372UQrePigI1FtQ+VaBfD0N/nr/TDsP/RPnhfDE
         UK0Dc7XMqyQYlBWZGQPNnPfsL3ko9aQzpuPl+KhFhnSFNCDLUZQ+oYPar0BwB1XbhL1D
         i/F99PI81hVpg2V4N7ZyDOPAymO+xEKVG57KWnPj4hzmyqrSWfvW5Ntk6GO34NYDS7XE
         6lddotNvf5iwl1ZJ2/JcJV7OcM/LkCEqH6SN1aSKuafNH8DAiElShGIW3A4JnUhsgycR
         2BRH24ARMOdxa7kRSjczvxPEcsTnG2IOy2S8BRCDLF5F+TTU2xbbD22Gm99h+Ps2xP+j
         a4Pg==
X-Gm-Message-State: AOAM532f/A183sqdRnjUsYTvDmEKPee1yfg1ILhXQzcYt1MxBlkG4xYX
        CODGPIUHQ6VkuTVLWhfx7rOrVA==
X-Google-Smtp-Source: ABdhPJzjtcPBMtUHKJAWFKiFoS6ecKsz+u8ONbHYrQElJFVMLe6T1I0LuiCyK11t4QYYrKuwNRxzaQ==
X-Received: by 2002:a05:6638:2109:: with SMTP id n9mr1748840jaj.17.1631741297845;
        Wed, 15 Sep 2021 14:28:17 -0700 (PDT)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f2sm622884ioz.14.2021.09.15.14.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 14:28:16 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     pbonzini@redhat.com, shuah@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] selftests: kvm: fix get_run_delay() ignoring fscanf() return warn
Date:   Wed, 15 Sep 2021 15:28:09 -0600
Message-Id: <b93a1779df180a61e765bb67be7a83600585901c.1631737524.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1631737524.git.skhan@linuxfoundation.org>
References: <cover.1631737524.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix get_run_delay() to check fscanf() return value to get rid of the
following warning. When fscanf() fails return MIN_RUN_DELAY_NS from
get_run_delay(). Move MIN_RUN_DELAY_NS from steal_time.c to test_util.h
so get_run_delay() and steal_time.c can use it.

lib/test_util.c: In function ‘get_run_delay’:
lib/test_util.c:316:2: warning: ignoring return value of ‘fscanf’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
  316 |  fscanf(fp, "%ld %ld ", &val[0], &val[1]);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/test_util.c     | 4 +++-
 tools/testing/selftests/kvm/steal_time.c        | 1 -
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index c7409b9b4e5b..451fed5ce8e7 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -95,6 +95,8 @@ struct vm_mem_backing_src_alias {
 	uint32_t flag;
 };
 
+#define MIN_RUN_DELAY_NS	200000UL
+
 bool thp_configured(void);
 size_t get_trans_hugepagesz(void);
 size_t get_def_hugetlb_pagesz(void);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index f80dd38a38b2..a9107bfae402 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -313,7 +313,9 @@ long get_run_delay(void)
 
 	sprintf(path, "/proc/%ld/schedstat", syscall(SYS_gettid));
 	fp = fopen(path, "r");
-	fscanf(fp, "%ld %ld ", &val[0], &val[1]);
+	/* Return MIN_RUN_DELAY_NS upon failure just to be safe */
+	if (fscanf(fp, "%ld %ld ", &val[0], &val[1]) < 2)
+		val[1] = MIN_RUN_DELAY_NS;
 	fclose(fp);
 
 	return val[1];
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 51fe95a5c36a..2172d65b85e4 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -19,7 +19,6 @@
 
 #define NR_VCPUS		4
 #define ST_GPA_BASE		(1 << 30)
-#define MIN_RUN_DELAY_NS	200000UL
 
 static void *st_gva[NR_VCPUS];
 static uint64_t guest_stolen_time[NR_VCPUS];
-- 
2.30.2

