Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1A6B71CC
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 09:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjCMI5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 04:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjCMI4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 04:56:54 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A762423C61;
        Mon, 13 Mar 2023 01:53:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a2so12126636plm.4;
        Mon, 13 Mar 2023 01:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678697617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVtL4Mahv24U8m6dcDI6vCl9MV+/3t8GA9cjgeYPo88=;
        b=IFuE/RKpWgbpue1yFOcu0pv1jDxtZQJW8Y7Vw9ouBUxFVmsGM5WCrXXMLtEvn4JfxL
         cDrO81S7cmqF2X9NZ9Sgbcyot0PwpVbLzpl9yMNKRLeJ7gYUOezlObWsSAscDv2LYmRI
         mqAzYYW3t9l4fwfpoiOLGwUOSDAMqQxLnofP5ioEyGYykDhigZsZR9vtvEpkrCydO+iG
         n8HkJMgJH+Da70QTQnQEybxXOf0A0SdXgNxsO6+iTff+abMnS/kU6nfZsjMVeFV2eMpA
         jHaAP/iuqzj42xZFvguwof0o4vhu7Ij9+reFqiCqsguQelV/M8Yt3fBBpNegivvCl0dR
         w5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678697617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVtL4Mahv24U8m6dcDI6vCl9MV+/3t8GA9cjgeYPo88=;
        b=KwTuMe2RBFECRReQgttcjZ1xd7esJq2CdWWpzVpLWLTKDmQxcLnlCCyuLZzaZxObeL
         FiQISmtdcwT/YUhLW6qf8dbXA7y6cKYDo0hf1w6FJ4VTfgMbsJGgE0s/a+kkiHhpB/Xh
         qSSdhXXGIFovcL5UICQrT7QM8Z0RUV1gJoQ3LHvLiKCpUv7qDY6Ugi2+HM8d1zf+I1Gw
         L0S3lwx3Y/E/MjLaeN4Rba/g9sbGeFnf/x7MyvwUZ2vIQR7UBi1RFEdGYY4h03J4GuVn
         gmsGj4tM1IACuK49bEfbieHFLOZuURIUC45OV8gSbnTeb/aT+hiJXCllwzH4chsGF+7j
         I6mw==
X-Gm-Message-State: AO0yUKWB5k0x3ISqmvXzUos9K0NBPvoAaQ+TRdEC7Tnw/PCvfyCsOvaJ
        4kohtsoX0jkwR2Ltqidjocg=
X-Google-Smtp-Source: AK7set9ZdyeFtt2FTsc+OO9lLDZYcp9kQhe6SEC1tRaUC1+2g85groVXsQlxUdp0MIzAmbHfMbnuDA==
X-Received: by 2002:a17:902:d483:b0:19a:9055:6658 with SMTP id c3-20020a170902d48300b0019a90556658mr9887872plg.18.1678697617067;
        Mon, 13 Mar 2023 01:53:37 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902d48600b0019ee045a2b3sm4155059plg.308.2023.03.13.01.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 01:53:36 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: selftests: Add a helper to read kvm boolean module parameters
Date:   Mon, 13 Mar 2023 16:53:10 +0800
Message-Id: <20230313085311.25327-2-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313085311.25327-1-likexu@tencent.com>
References: <20230313085311.25327-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

Add a helper function for reading kvm boolean module parameters values.
No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c          | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index fbc2a79369b8..a089c356f354 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -213,6 +213,7 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
 int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 
+bool get_kvm_param_bool(const char *param);
 bool get_kvm_intel_param_bool(const char *param);
 bool get_kvm_amd_param_bool(const char *param);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56d5ea949cbb..fa6d69f73199 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -80,6 +80,11 @@ static bool get_module_param_bool(const char *module_name, const char *param)
 	TEST_FAIL("Unrecognized value '%c' for boolean module param", value);
 }
 
+bool get_kvm_param_bool(const char *param)
+{
+	return get_module_param_bool("kvm", param);
+}
+
 bool get_kvm_intel_param_bool(const char *param)
 {
 	return get_module_param_bool("kvm_intel", param);
-- 
2.39.2

