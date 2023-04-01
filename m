Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC166D2DE6
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 05:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjDADWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 23:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbjDADWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 23:22:08 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD36E1A2;
        Fri, 31 Mar 2023 20:22:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so25466242pjz.1;
        Fri, 31 Mar 2023 20:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680319327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cr5tBYy38ZZC28ZSszUi1K8vp86NGKalcc5lCrnyDOk=;
        b=Aq5zoNHoBZWN6EFETU/CMM0feLdgHGCSqNclgQmWBifRyVilDdbU9ETOmOHRt7jpOp
         O2cq+76kq8X8T/9qXOMfQYuGTvz0PcqPSBAfI4lcPkqahI8xFYHM5D2xhmwxKgRXcqqW
         IZZIKKxs3n1mcM49yZojPokiY2bbJ04G+GPc19RVhXQR6GkBseKQjCydZM68LDglrtCG
         /JxD3mhhllqj++aT+GN5RofKg/qK3crM3hiyCkL7xl3lu+E9fZO8FLMqBxjQNsRMtIMU
         hurlJWu8Lso4YHDW+Da7UiYrysjuMkNlReuIYd067eyOgtld5iXC9yCPwAr0Ygh0YT0L
         mYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680319327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cr5tBYy38ZZC28ZSszUi1K8vp86NGKalcc5lCrnyDOk=;
        b=3vJUfncbl/TX/e+bznc2zWpTXgnOHjKJRPOTjapCy0HM8MFXWFBA5YP+SFGyWYap4w
         PzinElxjRF+mCnxaruHlYASyIahnxzVMdxWB/xogLwbrna+mxnG2tg339qn264zY307O
         ibiTSq3/1U7WYgXx7Ei9WWm/vZ5WV/yR86K/UEN8FaBEZNGlX7g4omLMSY2Oh61o/mEE
         mho/EsosG33m0ETnrr1F/h8saSF3GOvN/pAP/N9HffFJqIlGlfCcyAcuSCaEPSGGj7Xm
         73aF2PxWNj2l/oSwk3UAHR9b/5IErwWJSlOdosHPe1pumi9GAda7EAdop1DXmRWOsQ++
         j/kg==
X-Gm-Message-State: AAQBX9dL0o+cB2DDJ+oIdPhK8MslIwevTtzTAAWAs8h8dc1Vd9GOhziy
        u3AzAJgTEbhhwj0a+QHgtv0=
X-Google-Smtp-Source: AKy350YGFMuDhx0aSeePnUv3R6G4bO3noCPXvwRe1lziEoVTbG6Z/ygQOSd4JNEdETFa5URzlDbirg==
X-Received: by 2002:a17:903:2343:b0:1a1:abcc:e44e with SMTP id c3-20020a170903234300b001a1abcce44emr35392488plh.9.1680319326990;
        Fri, 31 Mar 2023 20:22:06 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id d19-20020a170902b71300b0019ac23cb6edsm2257266pls.181.2023.03.31.20.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 20:22:06 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 447A1102ED5; Sat,  1 Apr 2023 10:22:04 +0700 (WIB)
Date:   Sat, 1 Apr 2023 10:22:04 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     David Dai <davidai@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v2 3/6] kvm: arm64: Add support for util_hint service
Message-ID: <ZCejXGfh6Hx2NCLi@debian.me>
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-4-davidai@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331014356.1033759-4-davidai@google.com>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 06:43:47PM -0700, David Dai wrote:
> +ARM_SMCCC_HYP_KVM_UTIL_HINT_FUNC_ID
> +    ==============    =========   ============================
> +    Function ID:      (uint32)    0x86000041
> +    Arguments:        (uint32)    util value(0-1024) where 1024 represents
> +                                  the highest performance point normalized
> +                                  across all CPUs
> +    Return values:    (int32)     NOT_SUPPORTED(-1) on error.
> +    Endianness:                   Must be the same endianness
> +                                  as the host.
> +    ==============    ========    ============================

Sphinx reports htmldocs warning:
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/arm/util_hint.rst:21: WARNING: Malformed table.
Column span alignment problem in table line 8.

==============    =========   ============================
Function ID:      (uint32)    0x86000041
Arguments:        (uint32)    util value(0-1024) where 1024 represents
                              the highest performance point normalized
                              across all CPUs
Return values:    (int32)     NOT_SUPPORTED(-1) on error.
Endianness:                   Must be the same endianness
                              as the host.
==============    ========    ============================

I have to fix the table:

---- >8 ----
diff --git a/Documentation/virt/kvm/arm/util_hint.rst b/Documentation/virt/kvm/arm/util_hint.rst
index 262d142d62d91e..99e5bf99446d90 100644
--- a/Documentation/virt/kvm/arm/util_hint.rst
+++ b/Documentation/virt/kvm/arm/util_hint.rst
@@ -11,7 +11,8 @@ to the host.
 This hypercall using the SMC32/HVC32 calling convention:
 
 ARM_SMCCC_HYP_KVM_UTIL_HINT_FUNC_ID
-    ==============    =========   ============================
+
+    ==============    =========   ========================================
     Function ID:      (uint32)    0x86000041
     Arguments:        (uint32)    util value(0-1024) where 1024 represents
                                   the highest performance point normalized
@@ -19,4 +20,4 @@ ARM_SMCCC_HYP_KVM_UTIL_HINT_FUNC_ID
     Return values:    (int32)     NOT_SUPPORTED(-1) on error.
     Endianness:                   Must be the same endianness
                                   as the host.
-    ==============    ========    ============================
+    ==============    =========   ========================================

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
