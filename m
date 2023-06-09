Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C347297AC
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 13:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbjFILA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 07:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239302AbjFILAm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 07:00:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06D51FF3
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 04:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686308400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hp1V+H0c0blZeFGezmZ2Jagy9PHvvFYZ0tk77cJraXU=;
        b=UObiRaNbsPSw3qqCEAL2FjZqUDYLc3zZ32RFxC5Ymg1SG6+RBaMkBydaki8ct5aitg+Uwg
        MgK3xkABPecUvqPZY+gsUKrrUMIzD+cYEW21kYPvsqetnJ4cUYsu2zwZIjcFUygXDQC+UR
        u7+vseowmv/mtiS0GZnxDjMBabe4ZME=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-FlVgMelROUKfekMbGp0Dlg-1; Fri, 09 Jun 2023 06:59:59 -0400
X-MC-Unique: FlVgMelROUKfekMbGp0Dlg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-75ec91f26c8so39660785a.1
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 03:59:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686308399; x=1688900399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hp1V+H0c0blZeFGezmZ2Jagy9PHvvFYZ0tk77cJraXU=;
        b=BT3jO8MWX71C+v2mz5KS7XjmubrO+58pzCg29bNfDjM8NQu9HiMZy51eB4H54rFzY0
         AGyIbdjn96SYzNBlaDjBhLQw7CQCqL2pl9ypAR0FxP9uSVXBp6V7l1gix7afFVRrjudA
         6K1juRsUWxrdn1aU3O2A6gCYbN3NAil//RU7doalVagIPgY2htzdpDTyc3X3hUaVeBXv
         IqHH5GrjSgmZ6er336I8BgfIn+sc9OBTlSfpJN/0po9nAz6E03foeGf+CMZJqsoqR6l6
         PsztWkajYdqG6CWFdqZxZuN9/C1RP09y1Z8YJ6jMhdPpnStGG7wUwew9RT3bzREXkdoL
         ToFA==
X-Gm-Message-State: AC+VfDy7TEEIytETizgggJOV9oXPQZEqNVFwO8r7XwYWB1B/+Qn814ed
        6GsWpyHezwY4ssUGMgUTwVLkdg0iZkdlTdeR2/kJstv3xrrkVWiumPDr73Mfiv2RPkk4ItTWeFR
        W+NPPaPRT0wHj
X-Received: by 2002:a05:620a:8908:b0:75e:bd15:d95a with SMTP id ql8-20020a05620a890800b0075ebd15d95amr826645qkn.6.1686308399086;
        Fri, 09 Jun 2023 03:59:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5pX2BgRt1yhMGjAkkAV6A3kyJooZuyypF9hAb1zGeqztu2HxgfV33qrZip60badBxrIS0f0w==
X-Received: by 2002:a05:620a:8908:b0:75e:bd15:d95a with SMTP id ql8-20020a05620a890800b0075ebd15d95amr826625qkn.6.1686308398848;
        Fri, 09 Jun 2023 03:59:58 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s1-20020a05620a16a100b0075b35e72a21sm951485qkj.86.2023.06.09.03.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 03:59:58 -0700 (PDT)
Message-ID: <10695b6a-65d5-2df3-e89e-8cc2cd75b8ac@redhat.com>
Date:   Fri, 9 Jun 2023 18:59:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH kvmtool 12/21] Add helpers to pause the VM from vCPU
 thread
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
 <20230526221712.317287-13-oliver.upton@linux.dev>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230526221712.317287-13-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

I have a play with this series, the guest always hang when hotplug two 
more cpus, it seems the kvm_cpu_continue_vm forget to continue the 
current cpu.

On 5/27/23 06:17, Oliver Upton wrote:
> Pausing the VM from a vCPU thread is perilous with the current helpers,
> as it waits indefinitely for a signal that never comes when invoked from
> a vCPU thread. Instead, add a helper for pausing the VM from a vCPU,
> working around the issue by explicitly marking the caller as paused
> before proceeding.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   include/kvm/kvm-cpu.h |  3 +++
>   kvm-cpu.c             | 15 +++++++++++++++
>   2 files changed, 18 insertions(+)
> 
> diff --git a/include/kvm/kvm-cpu.h b/include/kvm/kvm-cpu.h
> index 0f16f8d6e872..9a4901bf94ca 100644
> --- a/include/kvm/kvm-cpu.h
> +++ b/include/kvm/kvm-cpu.h
> @@ -29,4 +29,7 @@ void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu);
>   void kvm_cpu__arch_nmi(struct kvm_cpu *cpu);
>   void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task);
>   
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu);
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu);
> +
>   #endif /* KVM__KVM_CPU_H */
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index 7dec08894cd3..9eb857b859c3 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -141,6 +141,21 @@ void kvm_cpu__run_on_all_cpus(struct kvm *kvm, struct kvm_cpu_task *task)
>   	mutex_unlock(&task_lock);
>   }
>   
> +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
> +{
> +	/*
> +	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
> +	 * signal exit.
> +	 */
> +	vcpu->paused = true;
> +	kvm__pause(vcpu->kvm);
> +}
> +
> +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
> +{
Here should add:
	vcpu->paused = false;
> +	kvm__continue(vcpu->kvm);
> +}
> +
>   int kvm_cpu__start(struct kvm_cpu *cpu)
>   {
>   	sigset_t sigset;

-- 
Shaoqin

