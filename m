Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8919D6D2DDF
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 05:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjDADQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 23:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbjDADQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 23:16:40 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073EE1DF87;
        Fri, 31 Mar 2023 20:16:39 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id ce4so2970646pfb.1;
        Fri, 31 Mar 2023 20:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680318997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=79ylBJyUuKCfX3ZxdsB4JMPHnnU1cgFoSf6oewBvv5w=;
        b=CITX2gGMskHEG30ZV9Yj3YnOYVFONDGOgdxe9zRM4KIrfzfNF///FH4sySwtZLWFbU
         UF8sDnXSO2eSi8qzI1LfDkfmOr97MpbauQXI4vu3yWNXGzo+kOJKoIvxWA4AOsPZnWsq
         N5TSgJPcA9RWISqLPTtiPER8GkQwURt3YuJsU5AO8goHQSyb8TFE+ZEh2BZjKT4h3xXK
         VdYvlB6nYxVORw7M0hIPzK/1tl36LzJw/FI8Ui1DfW25VM8z5zkgHSpI8INy18VCE7qt
         5Ikd9d/umeoOiIx3egjRpa3ByrcM233DXuidm7sr6SDXsG34rkqXpWVLgW1GX7C4k7Ns
         q2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680318997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79ylBJyUuKCfX3ZxdsB4JMPHnnU1cgFoSf6oewBvv5w=;
        b=CAGXIBrjwQY5c0UmWnDiOlmpWi+kJ8UsOyuophIKYVrQhvHcWQZ10B8pjxXUgOAP75
         XrBhTGTQ5LtsD6vvFwpRgrEvv99borMWRM7LAJ4kpbM7wyalc5QzXCHKD2v3Er1lI+wW
         UUsSkJUtY2XHmH+XToUylMFtxlbfEaeZwybJFAO12M76VWTYQizWbJypZ7rSgkEM8IGP
         os8OHResr0kcprEAoqUHR2qzk8JGsEMDDFCqLJPN+o6nzmttWD+VPwx2SbXH0TkW/gkx
         6Z4R21NF3uxfWTuHmgBfq75lufK5E3/5idjTOl2ewTfl+8B3TcpGRDXuwFuumMw/5ZAL
         KH+Q==
X-Gm-Message-State: AAQBX9f4htaBKqyHwctPnEnIgM2crrdhO7fa1+KEpcCryB9hLnVjkhqX
        SZQoRDIaf2Uki4+dg9uEWGs=
X-Google-Smtp-Source: AKy350bGIqAs1SBqSZR0gpCSzc6Nc3BIpAhebt7KaGMdoRUh6/Pz7XXFbO2a23KrtG/+AMuaYGQ0Cw==
X-Received: by 2002:a62:84c4:0:b0:628:134b:6b1c with SMTP id k187-20020a6284c4000000b00628134b6b1cmr32103216pfd.2.1680318997346;
        Fri, 31 Mar 2023 20:16:37 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id s7-20020a62e707000000b0062dad805b76sm2576403pfh.143.2023.03.31.20.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 20:16:37 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 260711067F1; Sat,  1 Apr 2023 10:16:34 +0700 (WIB)
Date:   Sat, 1 Apr 2023 10:16:33 +0700
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
Subject: Re: [RFC PATCH v2 2/6] kvm: arm64: Add support for get_cur_cpufreq
 service
Message-ID: <ZCeiEbrZHyYVZYuh@debian.me>
References: <20230331014356.1033759-1-davidai@google.com>
 <20230331014356.1033759-3-davidai@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230331014356.1033759-3-davidai@google.com>
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

On Thu, Mar 30, 2023 at 06:43:46PM -0700, David Dai wrote:
> +get_cur_cpufreq support for arm/arm64
> +=============================

Oops, I have to also fix this heading too:

---- >8 ----
diff --git a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
index 76f112efb99f92..21c2b2fe0c8acf 100644
--- a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
+++ b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 get_cur_cpufreq support for arm/arm64
-=============================
+=====================================
 
 Get_cur_cpufreq support is used to get current frequency(in KHz) of the
 current CPU that the vCPU thread is running on.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
