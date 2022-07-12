Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE52C57194A
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 13:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiGLL73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 07:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbiGLL67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 07:58:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47605F1D
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657627113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tN6vFUpo/wAbFsq44AFOSDmkPA0arGUmJ053wonWD+c=;
        b=ZHNKlbCF8sl+rcAvyLk9ZnouqkmvX8UfJ0a/G1dYz5xHbODZGI+GhmBsBM1m0VJcA5VVlK
        pFr+Wb0yrcsvhJ63YNRoAfcaLF9gp0gcTNquvEJXi+dlXP1I+5mMcBU+15DCyaduDSRAoy
        XaIdLDsyPTEtrI5yD6UUDKqNoKBQFEw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-JFwCSRrTMkKCJp2g7uTp7A-1; Tue, 12 Jul 2022 07:58:32 -0400
X-MC-Unique: JFwCSRrTMkKCJp2g7uTp7A-1
Received: by mail-qk1-f200.google.com with SMTP id bm2-20020a05620a198200b006a5dac37fa2so7622764qkb.16
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 04:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tN6vFUpo/wAbFsq44AFOSDmkPA0arGUmJ053wonWD+c=;
        b=c+Bs16TcVMfWrbDqN5P6DNJp2ff0xLCXCfkiDlhdsUPyzMH3WlJfgvHGbTzLAmTOXN
         ePDdywZpJerF44+9CRMgB/H2nHmI1mC8wlLwnBbUYH1Djb7MdXTCm0HoorRA0LKcVFGd
         GRFD7nITLMoMZe8vNSJp8RFZkoDilRV0y9Agh8+uBaoBvgocYgXIYbZkDlU21SZ0t407
         o3ybZMudBfwyBudUYbe95k+ehFfK5rUp8KR8wYRwWjWfbm2GRzh6PlLibTz1Gypam41u
         mcPkE8Y6hylXefr5jIWeCa7yg+UVvA2QL77mqoku6HN/SJYnLeL6eWk7FkdUUn1B1s0F
         ZGBA==
X-Gm-Message-State: AJIora9Ark5Vz0w9Q9DoZt42dxIkZQblNgVwhF5Sa0rKttXp6aetLTuo
        yCb9DlPe/mq4LBCem7rTg5oSuuRa4nIuLLzJs3L7CZIXmYRV39XfEcQlNW883qRz8YBGIQMHLws
        QUTFuGavhbTRl
X-Received: by 2002:a37:8d3:0:b0:6b5:8adf:208a with SMTP id 202-20020a3708d3000000b006b58adf208amr5902027qki.215.1657627111818;
        Tue, 12 Jul 2022 04:58:31 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1veJb+pDI8XvNUrlheSB9UNvRqZZJS0lkNPKf9/bHp/iY23Zpjl5fYcNzGAM12JOh1bJyJp4g==
X-Received: by 2002:a37:8d3:0:b0:6b5:8adf:208a with SMTP id 202-20020a3708d3000000b006b58adf208amr5902015qki.215.1657627111625;
        Tue, 12 Jul 2022 04:58:31 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id u19-20020a05620a0c5300b006b5ab88e544sm421901qki.124.2022.07.12.04.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:58:31 -0700 (PDT)
Message-ID: <085a6f661672da1e507422ea4404e144abbd5562.camel@redhat.com>
Subject: Re: [PATCH v3 19/25] KVM: VMX: Adjust CR3/INVPLG interception for
 EPT=y at runtime, not setup
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jul 2022 14:58:27 +0300
In-Reply-To: <20220708144223.610080-20-vkuznets@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
         <20220708144223.610080-20-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Clear the CR3 and INVLPG interception controls at runtime based on
> whether or not EPT is being _used_, as opposed to clearing the bits at
> setup if EPT is _supported_ in hardware, and then restoring them when EPT
> is not used.  Not mucking with the base config will allow using the base
> config as the starting point for emulating the VMX capability MSRs.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9771c771c8f5..eca6875d6732 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2501,13 +2501,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>         rdmsr_safe(MSR_IA32_VMX_EPT_VPID_CAP,
>                 &vmx_cap->ept, &vmx_cap->vpid);
>  
> -       if (_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) {
> -               /* CR3 accesses and invlpg don't need to cause VM Exits when EPT
> -                  enabled */
> -               _cpu_based_exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
> -                                            CPU_BASED_CR3_STORE_EXITING |
> -                                            CPU_BASED_INVLPG_EXITING);
> -       } else if (vmx_cap->ept) {
> +       if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
> +           vmx_cap->ept) {
>                 pr_warn_once("EPT CAP should not exist if not support "
>                                 "1-setting enable EPT VM-execution control\n");
>  
> @@ -4264,10 +4259,11 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>                 exec_control |= CPU_BASED_CR8_STORE_EXITING |
>                                 CPU_BASED_CR8_LOAD_EXITING;
>  #endif
> -       if (!enable_ept)
> -               exec_control |= CPU_BASED_CR3_STORE_EXITING |
> -                               CPU_BASED_CR3_LOAD_EXITING  |
> -                               CPU_BASED_INVLPG_EXITING;
> +       /* No need to intercept CR3 access or INVPLG when using EPT. */
> +       if (enable_ept)
> +               exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
> +                                 CPU_BASED_CR3_STORE_EXITING |
> +                                 CPU_BASED_INVLPG_EXITING);
>         if (kvm_mwait_in_guest(vmx->vcpu.kvm))
>                 exec_control &= ~(CPU_BASED_MWAIT_EXITING |
>                                 CPU_BASED_MONITOR_EXITING);


Makes sense, although the 'runtime' word a bit misleading, as we don't allow to change
'enable_ept' after kvm_intel is loaded I think.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

