Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843A76EE23F
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 14:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbjDYMwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbjDYMwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 08:52:32 -0400
X-Greylist: delayed 72 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Apr 2023 05:52:29 PDT
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A09D307
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 05:52:29 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0d:3786:0:640:7c97:0])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 85E0E6027C;
        Tue, 25 Apr 2023 15:51:13 +0300 (MSK)
Received: from [IPV6:2a02:6b8:0:107:fa75:a4ff:fe7d:8480] (unknown [2a02:6b8:0:107:fa75:a4ff:fe7d:8480])
        by mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id BpFM8l1Mc0U0-KQfsB4hO;
        Tue, 25 Apr 2023 15:51:12 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1682427072; bh=+bGF8KHgmeB1w3xPtY2abqSMo6k78fzmEn6I5kxNxxA=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=N/NY2PgR8In/LJUicayHdMx9kOCOStnjWlttDty1dCbh65hOzpSXiROI04aT7avuP
         +AM5Ww/9NoGruPN767Nzl4X8XM98gjkgTyiaSAQNWoT67EG/EoRZJTuFaewGDCLm0u
         VLIpTneUiIjYwPLRGjZah+lqfQSllHhhnm9fHtSQ=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <2d5b21cb-7b09-f4e8-576f-31d9977aa70c@yandex-team.ru>
Date:   Tue, 25 Apr 2023 15:51:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3 2/7] target/i386: Add new EPYC CPU versions with
 updated cache_info
To:     Babu Moger <babu.moger@amd.com>
Cc:     weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
        paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
        jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
        wei.huang2@amd.com, berrange@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org
References: <20230424163401.23018-1-babu.moger@amd.com>
 <20230424163401.23018-3-babu.moger@amd.com>
Content-Language: en-US
From:   Maksim Davydov <davydov-max@yandex-team.ru>
In-Reply-To: <20230424163401.23018-3-babu.moger@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/24/23 19:33, Babu Moger wrote:
> From: Michael Roth <michael.roth@amd.com>
>
> Introduce new EPYC cpu versions: EPYC-v4 and EPYC-Rome-v3.
> The only difference vs. older models is an updated cache_info with
> the 'complex_indexing' bit unset, since this bit is not currently
> defined for AMD and may cause problems should it be used for
> something else in the future. Setting this bit will also cause
> CPUID validation failures when running SEV-SNP guests.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   target/i386/cpu.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 118 insertions(+)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index e3d9eaa307..c1bc47661d 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1707,6 +1707,56 @@ static const CPUCaches epyc_cache_info = {
>       },
>   };
>   
> +static CPUCaches epyc_v4_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,
> +        .no_invd_sharing = true,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 64 * KiB,
> +        .line_size = 64,
> +        .associativity = 4,
> +        .partitions = 1,
> +        .sets = 256,
> +        .lines_per_tag = 1,
> +        .self_init = 1,
> +        .no_invd_sharing = true,
> +    },
> +    .l2_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 2,
> +        .size = 512 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 1024,
> +        .lines_per_tag = 1,
> +    },
> +    .l3_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 3,
> +        .size = 8 * MiB,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .partitions = 1,
> +        .sets = 8192,
> +        .lines_per_tag = 1,
> +        .self_init = true,
> +        .inclusive = true,
> +        .complex_indexing = false,
> +    },
> +};
> +
>   static const CPUCaches epyc_rome_cache_info = {
>       .l1d_cache = &(CPUCacheInfo) {
>           .type = DATA_CACHE,
> @@ -1757,6 +1807,56 @@ static const CPUCaches epyc_rome_cache_info = {
>       },
>   };
>   
> +static const CPUCaches epyc_rome_v3_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,
> +        .no_invd_sharing = true,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .size = 32 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 64,
> +        .lines_per_tag = 1,
> +        .self_init = 1,
> +        .no_invd_sharing = true,
> +    },
> +    .l2_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 2,
> +        .size = 512 * KiB,
> +        .line_size = 64,
> +        .associativity = 8,
> +        .partitions = 1,
> +        .sets = 1024,
> +        .lines_per_tag = 1,
> +    },
> +    .l3_cache = &(CPUCacheInfo) {
> +        .type = UNIFIED_CACHE,
> +        .level = 3,
> +        .size = 16 * MiB,
> +        .line_size = 64,
> +        .associativity = 16,
> +        .partitions = 1,
> +        .sets = 16384,
> +        .lines_per_tag = 1,
> +        .self_init = true,
> +        .inclusive = true,
> +        .complex_indexing = false,
> +    },
> +};
> +
>   static const CPUCaches epyc_milan_cache_info = {
>       .l1d_cache = &(CPUCacheInfo) {
>           .type = DATA_CACHE,
> @@ -4091,6 +4191,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                       { /* end of list */ }
>                   }
>               },
> +            {
> +                .version = 4,
> +                .props = (PropValue[]) {
> +                    { "model-id",
> +                      "AMD EPYC-v4 Processor" },
> +                    { /* end of list */ }
> +                },
> +                .cache_info = &epyc_v4_cache_info
> +            },
>               { /* end of list */ }
>           }
>       },
> @@ -4210,6 +4319,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                       { /* end of list */ }
>                   }
>               },
> +            {
> +                .version = 3,
> +                .props = (PropValue[]) {
> +                    { "model-id",
> +                      "AMD EPYC-Rome-v3 Processor" },
What do you think about adding more information to the model name to reveal
its key feature? For instance, model-id can be "EPYC-Rome-v3 (NO INDEXING)",
because only cache info was affected. Or alias can be used to achieve
the same effect. It works well in
"EPYC-v2 <-> AMD EPYC Processor (with IBPB) <-> EPYC-IBPB"
> +                    { /* end of list */ }
> +                },
> +                .cache_info = &epyc_rome_v3_cache_info
> +            },
>               { /* end of list */ }
>           }
>       },

-- 
Best regards,
Maksim Davydov

