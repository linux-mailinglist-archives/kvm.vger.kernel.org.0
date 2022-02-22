Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE7D4BF3CE
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 09:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiBVIjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 03:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiBVIjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 03:39:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C394D9A9A6
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 00:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645519124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Tu9QL7WsIDCY+RdsCeRWYUzvZbj9M0i130tiIYSbeY=;
        b=Gr8ecsToY5J8Fk0pSagP63ppaWHJr/RqO9agWOJdVeAiPAVZCy1HVcgmI5EKdFhHDEfDu5
        xNgG2+wd8z+62G6+Y/++BPRNXcLGB9W2RZVraWblqv1gg/eEqrZJBGf46WQ7ACEKfXASId
        NXArYXsX+RjunRZrN4fME+xnlVfkcHc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-f8mjMNt6MGK9uMt9k6I1qw-1; Tue, 22 Feb 2022 03:38:43 -0500
X-MC-Unique: f8mjMNt6MGK9uMt9k6I1qw-1
Received: by mail-wr1-f70.google.com with SMTP id j27-20020adfb31b000000b001ea8356972bso890579wrd.1
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 00:38:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6Tu9QL7WsIDCY+RdsCeRWYUzvZbj9M0i130tiIYSbeY=;
        b=LbhW/utIPYsrs0VF1CtUhwsrHjRN5yHeErcDEoS7T8rFLThF9Bk4u8snTROZXjW6kp
         G3KKgkFLuMRRSZKnTEjNorOqKZFu4Uon2UZ6GCdWCa/u2eHlNY8UeoW6bTa5Y2hqH8m8
         Sj+N2l/2vRoTIkCkA9XzwEAzlX0D1gziuuyX+sYJn2D1GcPq4Z6ZmlLE9e92HLfuGba2
         AwkJT3lwi1Y57IOrGdAc0FQH/KEamB9gNKV+MH2wM4yoIe8eSMawL9ixHxOR6cH5PPef
         9dzZGfJsJ/fl2xusCmJarX1R05ffuUCTqERMG/94df9mI7buHELLbFMPStPfg+Av3pCi
         sM3g==
X-Gm-Message-State: AOAM5314n6SekZNmcEvigYWg0K04ilioPhHUZHYrjYvoL1qJ6uxyoKgV
        pazjxX3VAqQ7GlCb6i6idWMmLrlgZKMSKFztzUZLKgN6qlrKjwCGY9ICzu4i85SDLtMG5LbPQVS
        +x68YsrygFCGR
X-Received: by 2002:a5d:55cd:0:b0:1e3:30ee:858 with SMTP id i13-20020a5d55cd000000b001e330ee0858mr18458340wrw.344.1645519121337;
        Tue, 22 Feb 2022 00:38:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/mAZMdOCZ/IMsBJhsAEB0jkNUK7UB2S6eckGyYvOxdQbYedfTRllJRw+vuCBCiIytz3kuLA==
X-Received: by 2002:a5d:55cd:0:b0:1e3:30ee:858 with SMTP id i13-20020a5d55cd000000b001e330ee0858mr18458314wrw.344.1645519121089;
        Tue, 22 Feb 2022 00:38:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u7sm41296850wrm.15.2022.02.22.00.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 00:38:40 -0800 (PST)
Message-ID: <6b5b8f01-6676-e7e4-d6d6-55c69f99a86d@redhat.com>
Date:   Tue, 22 Feb 2022 09:38:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RESEND PATCH] KVM: x86/mmu: make apf token non-zero to fix bug
Content-Language: en-US
To:     Liang Zhang <zhangliang5@huawei.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangzhigang17@huawei.com
References: <20220222031239.1076682-1-zhangliang5@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222031239.1076682-1-zhangliang5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 04:12, Liang Zhang wrote:
> In current async pagefault logic, when a page is ready, KVM relies on
> kvm_arch_can_dequeue_async_page_present() to determine whether to deliver
> a READY event to the Guest. This function test token value of struct
> kvm_vcpu_pv_apf_data, which must be reset to zero by Guest kernel when a
> READY event is finished by Guest. If value is zero meaning that a READY
> event is done, so the KVM can deliver another.
> But the kvm_arch_setup_async_pf() may produce a valid token with zero
> value, which is confused with previous mention and may lead the loss of
> this READY event.
> 
> This bug may cause task blocked forever in Guest:
>   INFO: task stress:7532 blocked for more than 1254 seconds.
>         Not tainted 5.10.0 #16
>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>   task:stress          state:D stack:    0 pid: 7532 ppid:  1409
>   flags:0x00000080
>   Call Trace:
>    __schedule+0x1e7/0x650
>    schedule+0x46/0xb0
>    kvm_async_pf_task_wait_schedule+0xad/0xe0
>    ? exit_to_user_mode_prepare+0x60/0x70
>    __kvm_handle_async_pf+0x4f/0xb0
>    ? asm_exc_page_fault+0x8/0x30
>    exc_page_fault+0x6f/0x110
>    ? asm_exc_page_fault+0x8/0x30
>    asm_exc_page_fault+0x1e/0x30
>   RIP: 0033:0x402d00
>   RSP: 002b:00007ffd31912500 EFLAGS: 00010206
>   RAX: 0000000000071000 RBX: ffffffffffffffff RCX: 00000000021a32b0
>   RDX: 000000000007d011 RSI: 000000000007d000 RDI: 00000000021262b0
>   RBP: 00000000021262b0 R08: 0000000000000003 R09: 0000000000000086
>   R10: 00000000000000eb R11: 00007fefbdf2baa0 R12: 0000000000000000
>   R13: 0000000000000002 R14: 000000000007d000 R15: 0000000000001000
> 
> Signed-off-by: Liang Zhang <zhangliang5@huawei.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 593093b52395..8e24f73bf60b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3889,12 +3889,23 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
>   	walk_shadow_page_lockless_end(vcpu);
>   }
>   
> +static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
> +{
> +	/* make sure the token value is not 0 */
> +	u32 id = vcpu->arch.apf.id;
> +
> +	if (id << 12 == 0)
> +		vcpu->arch.apf.id = 1;
> +
> +	return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
> +}
> +
>   static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   				    gfn_t gfn)
>   {
>   	struct kvm_arch_async_pf arch;
>   
> -	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
> +	arch.token = alloc_apf_token(vcpu);
>   	arch.gfn = gfn;
>   	arch.direct_map = vcpu->arch.mmu->direct_map;
>   	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);

Queued, thanks.

Paolo

