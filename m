Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEEE72B95D
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 09:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbjFLH5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 03:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbjFLH5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 03:57:04 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890FC3ABA
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 00:56:17 -0700 (PDT)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by gandalf.ozlabs.org (Postfix) with ESMTP id 4QfkX33rXfz4xGj;
        Mon, 12 Jun 2023 17:56:03 +1000 (AEST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4QfkWw50Qjz4xFn;
        Mon, 12 Jun 2023 17:55:56 +1000 (AEST)
Message-ID: <14168a66-38ba-82e6-08d2-830f6216b4e1@kaod.org>
Date:   Mon, 12 Jun 2023 09:55:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v20 09/21] machine: adding s390 topology to query-cpu-fast
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-10-pmorel@linux.ibm.com>
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230425161456.21031-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Pierre,

On 4/25/23 18:14, Pierre Morel wrote:
> S390x provides two more topology attributes, entitlement and dedication.
> 
> Let's add these CPU attributes to the QAPI command query-cpu-fast.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>   qapi/machine.json          | 9 ++++++++-
>   hw/core/machine-qmp-cmds.c | 2 ++
>   2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 1cdd83f3fd..c6a12044e0 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -55,10 +55,17 @@
>   # Additional information about a virtual S390 CPU
>   #
>   # @cpu-state: the virtual CPU's state
> +# @dedicated: the virtual CPU's dedication (since 8.1)
> +# @entitlement: the virtual CPU's entitlement (since 8.1)
>   #
>   # Since: 2.12
>   ##
> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
> +{ 'struct': 'CpuInfoS390',
> +  'data': { 'cpu-state': 'CpuS390State',
> +            'dedicated': 'bool',
> +            'entitlement': 'CpuS390Entitlement'
> +  }
> +}
>   
>   ##
>   # @CpuInfoFast:
> diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
> index b98ff15089..3f35ed83a6 100644
> --- a/hw/core/machine-qmp-cmds.c
> +++ b/hw/core/machine-qmp-cmds.c
> @@ -35,6 +35,8 @@ static void cpustate_to_cpuinfo_s390(CpuInfoS390 *info, const CPUState *cpu)
>       CPUS390XState *env = &s390_cpu->env;
>   
>       info->cpu_state = env->cpu_state;
> +    info->dedicated = env->dedicated;
> +    info->entitlement = env->entitlement;

When you resend, please protect these assignments with :

  #if !defined(CONFIG_USER_ONLY)

Thanks,

C.

>   #else
>       abort();
>   #endif

