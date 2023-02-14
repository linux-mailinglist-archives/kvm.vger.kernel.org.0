Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B403C695D7A
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjBNItp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNItn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:49:43 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4979317CDF;
        Tue, 14 Feb 2023 00:49:42 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id b5so16345228plz.5;
        Tue, 14 Feb 2023 00:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zLTX+3sdKbK2e53JHj/d2kK8+1oHfP8YLHN7YuBU+5U=;
        b=QDYVPk4YVjz7RAoZTzUru4gcliZdjiSORTv0S71L+4oxdukZ3G3KwTOVN+EVBMMb+j
         GEGRuaZG/DR1L/ZxGAQxXYtMhWQddDe4ItMR0uUSESONsKzEJ+j/T3lLLUSAHcLxJBT2
         v9AhrBb2O5tsol7yjkAma2QAkS43oo+ifLuaRyVb4C0+H7k106tHr1TVxXzQQhsWuvGZ
         b33B5gE5yGy6ICHsNiIEJ2tsVhw5ls4KBaOfwxHVhSSVtT7ymrikoOAbrPh8R3Yc/NKL
         bN3solXR6APMiCyvxxhg+BUiHnbFHKaqVjkUQfPYeG2tku0G1dQBvAjHdb9V0Ej62VrG
         liXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zLTX+3sdKbK2e53JHj/d2kK8+1oHfP8YLHN7YuBU+5U=;
        b=xhPq+jsp9KOZEPuC0FT1fk77FMTnvX14wHXf0pSJxy24REAz+qbo4dKaZtQNn6k4BC
         UEvjmfag5cp5DejtRJ0rFvfW48Zav0eWgMR/Fz2jSMpDbf0i6HVC3J02WTU44rbKgkGA
         PCrlhaHlmK+qRtIA3nJZQ1aFd8KqBIcQBjLf7CbgsFoMHo8Bi57OCzWM0v9OtUa2YDEG
         dWI0oYxBzgM0qYYc3FpWiFph2DmYWDVkPpT45ePLHdSWbglaUEK3ZAansWqZ592xp6aq
         CdTFjoegnGoEzZeELzXysfYF0shaP+qGYDAwIwpXtdysD7lVuzwvg/LjV8Bmiu+jzLSm
         260A==
X-Gm-Message-State: AO0yUKVxwir9+jTFntQcm6UC+1tOl3hKZ7ftTAjKgk9irpH3MPCn3eCb
        /R3+Qg7FoqJKvRI50Sh34Si0ir7zrVQ0WYcyGys=
X-Google-Smtp-Source: AK7set/f8SbKS4c+Sh+rqHZvy4rL5jhVkbzHfQZvcI4ajGuPX18DTN/H96Ibc39vG8Mwd7L64lOo/w==
X-Received: by 2002:a17:90b:3904:b0:233:ee50:d26d with SMTP id ob4-20020a17090b390400b00233ee50d26dmr1692314pjb.4.1676364581858;
        Tue, 14 Feb 2023 00:49:41 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o9-20020a17090a3d4900b00233b1da232csm6549475pjf.41.2023.02.14.00.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 00:49:41 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: selftests: Add a helper to read kvm boolean module parameters
Date:   Tue, 14 Feb 2023 16:49:19 +0800
Message-Id: <20230214084920.59787-2-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214084920.59787-1-likexu@tencent.com>
References: <20230214084920.59787-1-likexu@tencent.com>
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
index 403ea0ee77ac..fae0c76c344a 100644
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
2.39.1

