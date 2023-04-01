Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54E06D2DD4
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 05:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbjDADMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 23:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjDADMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 23:12:21 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF931EFC5;
        Fri, 31 Mar 2023 20:12:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso9699113pjc.1;
        Fri, 31 Mar 2023 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680318739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GMsqA2/S4acnYNFGSszhcxD2t1ID/uK62fRiA76JiBA=;
        b=izzE5BwTcnLtWXiLFvb1b1GiNKSO8qGbitdSPuU2w3doJeL1SXvD/0YcRCbyPbSHd0
         LJwJSLBiDslPaI69lmy9Y/1xjuqTF2IXhiJ8wNO0q2bY7aTUTx/B/sgRoZFeuoGkJ6wA
         rNdMRDFWVWTizj4ktebC7jnALxztJWSYdPqf2/gQSMTizk+5ibKtsgavvHVVIoewpNJT
         fsfUbERSIZUx5xKiNwnld9prEvcpmyju0cY2+8iMbiB9tuZCpC6ZGmadcu0dWe3w5hyx
         2hhXx2L3psFIFJb0tN83ePDQsMHg7eNPqt3ZzfYzibSAlBikvflC3XtoU4IgYDVIoPzb
         1dJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680318739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMsqA2/S4acnYNFGSszhcxD2t1ID/uK62fRiA76JiBA=;
        b=zzJGlT7OCM77PM6xs/akAoJnkr9IueWeucLQMgCH/0Lpfh+Y3gL1AL2fgsMq8/9pnk
         BO719qwVTUSV03ay7JOqjRzs/56Mw1mEa89UAagEQwfkVS6l7CuGdzie75dPW3PwXx91
         rZU1mcmrJjhKvmxi1LWT/8nZAS63xLNAHnbJIUYNH1ctuKfiAj3oq0u0vfJCc0Xz87x2
         AkTWQkJKbIuu/a+2+m05k2a4hzMfrLDgk+v+sIFzsKZ26yUcZLsiF8TMKfukGXse6LC7
         /6R0axlrRp3AmbpSENJiL8OJzJ9/qCIRjW1UwmbqDgcoKqAyOyvWK1EWIzr/dy027vjx
         Ktzg==
X-Gm-Message-State: AAQBX9dFFNP/2CNuhvlYgMBGurHZdv0K+Jkndx2MXA0E9TfFvMr7ZtPx
        Jtpt+0XEZg3jF4ELB1bWjmM=
X-Google-Smtp-Source: AKy350bPTa+6wCaLlfIe0t8Z/dZpxNsv/Fw1CdcxoSM2Sy7O3EUGDsMbmYmRcGqE3Vk4WsBjOQymQA==
X-Received: by 2002:a17:902:fa43:b0:1a1:a8db:495d with SMTP id lb3-20020a170902fa4300b001a1a8db495dmr22990145plb.4.1680318739546;
        Fri, 31 Mar 2023 20:12:19 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b0019f789cddccsm2292207pll.19.2023.03.31.20.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 20:12:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 31AA4101622; Sat,  1 Apr 2023 10:12:15 +0700 (WIB)
Date:   Sat, 1 Apr 2023 10:12:15 +0700
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
Message-ID: <ZCehD15QJyDapG3u@debian.me>
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
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 62de0768d6aa..b0ff0ad700bf 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8380,6 +8380,14 @@ structure.
>  When getting the Modified Change Topology Report value, the attr->addr
>  must point to a byte where the value will be stored or retrieved from.
>  
> +8.40 KVM_CAP_GET_CUR_CPUFREQ
> +------------------------
> +
> +:Architectures: arm64
> +
> +This capability indicates that KVM supports getting the
> +frequency of the current CPU that the vCPU thread is running on.
> +
>  9. Known KVM API problems
>  =========================
>  
> diff --git a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
> new file mode 100644
> index 000000000000..06e0ed5b3868
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
> @@ -0,0 +1,21 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +get_cur_cpufreq support for arm/arm64
> +=============================
> +
> +Get_cur_cpufreq support is used to get current frequency(in KHz) of the
> +current CPU that the vCPU thread is running on.
> +
> +* ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID: 0x86000040
> +
> +This hypercall uses the SMC32/HVC32 calling convention:
> +
> +ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID
> +    ==============    ========    =====================================
> +    Function ID:      (uint32)    0x86000040
> +    Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
> +                      (uint32)    Frequency in KHz of current CPU that the
> +                                  vCPU thread is running on.
> +    Endianness:                   Must be the same endianness
> +                                  as the host.
> +    ==============    ========    =====================================

Sphinx reports htmldocs warnings:
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8384: WARNING: Title underline too short.

8.40 KVM_CAP_GET_CUR_CPUFREQ
------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8384: WARNING: Title underline too short.

8.40 KVM_CAP_GET_CUR_CPUFREQ
------------------------
/home/bagas/repo/linux-kernel/Documentation/virt/kvm/api.rst:8404: WARNING: Title underline too short.

I have applied the fixup:

---- >8 ----
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8f905456e2b4a1..baf8a4c43b5839 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8381,7 +8381,7 @@ When getting the Modified Change Topology Report value, the attr->addr
 must point to a byte where the value will be stored or retrieved from.
 
 8.40 KVM_CAP_GET_CUR_CPUFREQ
-------------------------
+----------------------------
 
 :Architectures: arm64
 
diff --git a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
index 06e0ed5b3868d7..76f112efb99f92 100644
--- a/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
+++ b/Documentation/virt/kvm/arm/get_cur_cpufreq.rst
@@ -11,11 +11,12 @@ current CPU that the vCPU thread is running on.
 This hypercall uses the SMC32/HVC32 calling convention:
 
 ARM_SMCCC_VENDOR_HYP_KVM_GET_CUR_CPUFREQ_FUNC_ID
-    ==============    ========    =====================================
+
+    ==============    ========    ========================================
     Function ID:      (uint32)    0x86000040
     Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
                       (uint32)    Frequency in KHz of current CPU that the
                                   vCPU thread is running on.
     Endianness:                   Must be the same endianness
                                   as the host.
-    ==============    ========    =====================================
+    ==============    ========    ========================================

Thanks.

-- 
An old man doll... just what I always wanted! - Clara
