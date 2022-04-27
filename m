Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37852512143
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbiD0Q1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243040AbiD0Q0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:26:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7808557999
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffzoPVo40T1QB8nGCSIveEjN49tY8CiNvdur2uf9BJA=;
        b=KQWFmVmsrJvYasYc8HeK2lgAiqLsluRefD9yhizsl4o8ZyvtHdDmc2Q+ZrgjzKzF0mqboI
        meVudgyqeXdma8M3zjE9M0pRy0IH990jKsionWw2/kBuLEzA+Jg6vWxSCgp3wJVwZeAmr6
        8+vo+RgvgzGM7YU2Ntug2j1Brd0r3Y0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-wdAVLq8fM82AIgABYtqELg-1; Wed, 27 Apr 2022 12:19:04 -0400
X-MC-Unique: wdAVLq8fM82AIgABYtqELg-1
Received: by mail-ed1-f72.google.com with SMTP id ec44-20020a0564020d6c00b00425b136662eso1270080edb.12
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ffzoPVo40T1QB8nGCSIveEjN49tY8CiNvdur2uf9BJA=;
        b=CTkZFrT0gZvSdGYaZxI2RVKcyjo3xgPgHHOiACofxmKOsa9fID9sJQeEA6l1nGeqtf
         Pj7HfmeWRAUpYlEuNXoVJaTidRA4v2IENUeaklXqKCnJ3rLrgqffajD3EPpYJdbafDDx
         bq83hvNWAfMsxAwOAxZW66seo0m2cWCmNLzp7TsZ8gETrOrPC3LEA2WwJtoHnDZPdDel
         PZGeeuWVOjWj6j562Je6izAhlnCtWX/CCmbC045kxqH6JgUO8eAYzOkca9PcuWHKXXAk
         GUSuDhrzi+hbdkOFngnae7YED3h7pR3LJzoZHroBcAWX4c2O3i6hP951L9na+IX6+4v4
         Ywiw==
X-Gm-Message-State: AOAM53264RO/k6AxM0hsuVupqAgdJ8g5TolKlS6/ExLsUVccnv2vg798
        ygQeV6k5y8BFwuI8mgx/ybfzR8tzsPAbBS72WtZri9GJ+dD0fd/cytwauNNLwJ7XblH//WiwsK9
        Vnl1FBNQAI/9w
X-Received: by 2002:a17:907:6286:b0:6da:6e24:5e43 with SMTP id nd6-20020a170907628600b006da6e245e43mr27124076ejc.449.1651076343669;
        Wed, 27 Apr 2022 09:19:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzabc0/sYttxf8D1jkbuABMsGvUHBUQ5TkmebPJVuLdNvlX2fgRhAzqQvVk/Pgui8yCvJ73OA==
X-Received: by 2002:a17:907:6286:b0:6da:6e24:5e43 with SMTP id nd6-20020a170907628600b006da6e245e43mr27124052ejc.449.1651076343424;
        Wed, 27 Apr 2022 09:19:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id bg16-20020a170906a05000b006f3c03f5871sm1884081ejb.108.2022.04.27.09.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:02 -0700 (PDT)
Message-ID: <b02f8edc-8d29-46c4-32b4-7317f8eaae2d@redhat.com>
Date:   Wed, 27 Apr 2022 18:18:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.4 1/2] x86/kvm: Preserve BSP
 MSR_KVM_POLL_CONTROL across suspend/resume
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155438.19612-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155438.19612-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 0361bdfddca20c8855ea3bdbbbc9c999912b10ff ]
> 
> MSR_KVM_POLL_CONTROL is cleared on reset, thus reverting guests to
> host-side polling after suspend/resume.  Non-bootstrap CPUs are
> restored correctly by the haltpoll driver because they are hot-unplugged
> during suspend and hot-plugged during resume; however, the BSP
> is not hotpluggable and remains in host-sde polling mode after
> the guest resume.  The makes the guest pay for the cost of vmexits
> every time the guest enters idle.
> 
> Fix it by recording BSP's haltpoll state and resuming it during guest
> resume.
> 
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1650267752-46796-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kernel/kvm.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 408b51aba293..f582dda8dd34 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -59,6 +59,7 @@ static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __align
>   DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
>   static int has_steal_clock = 0;
>   
> +static int has_guest_poll = 0;
>   /*
>    * No need for any "IO delay" on KVM
>    */
> @@ -584,14 +585,26 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
>   
>   static int kvm_suspend(void)
>   {
> +	u64 val = 0;
> +
>   	kvm_guest_cpu_offline(false);
>   
> +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> +	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
> +		rdmsrl(MSR_KVM_POLL_CONTROL, val);
> +	has_guest_poll = !(val & 1);
> +#endif
>   	return 0;
>   }
>   
>   static void kvm_resume(void)
>   {
>   	kvm_cpu_online(raw_smp_processor_id());
> +
> +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> +	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL) && has_guest_poll)
> +		wrmsrl(MSR_KVM_POLL_CONTROL, 0);
> +#endif
>   }
>   
>   static struct syscore_ops kvm_syscore_ops = {

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

