Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1BD4D2B3D
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 10:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiCIJDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 04:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiCIJC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 04:02:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8127216AA5E
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 01:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646816517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BgihzrLoyH/kzw4agGF/2fpwe3C4H7hKVoUZxMMuCSc=;
        b=frlL4TwvOvf8XI3U3cL7Vz82dbPGYKkcbfTlomcMPhpQJTmKqsMUjdiPd/7eEjF9IvmkXg
        kHI6dqsgXwqYjkHpl+vXoMiZALRWgqnh/PMymu3Zz9EZTAtdcSfSi5oes9Mmr4PirIcPwh
        +QW9qO0zle7YE2RRa2Ws3entuVQ5CaU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-_N5iidE9MwqENNnwVnLB8Q-1; Wed, 09 Mar 2022 04:01:56 -0500
X-MC-Unique: _N5iidE9MwqENNnwVnLB8Q-1
Received: by mail-wr1-f71.google.com with SMTP id q14-20020adfea0e000000b002036c16c6daso525953wrm.8
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 01:01:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BgihzrLoyH/kzw4agGF/2fpwe3C4H7hKVoUZxMMuCSc=;
        b=Zy+7eJi2uwwFYZPIjTJsX3/bqn6z883dQkdEbea4F8dfTu5TuUq5X4/kQ3EnY4tvGI
         gF2A7htSKwhgav6IQ4Qbm9TEo7Jz2aFOseUu/bj0KI07OuN2k18IJxWdEiv3TFZbhoB+
         T9cRa2bJK2iMk+TC3WLqQZWxi8IxQlP2ErX/Yo3nBiBwozI4AjJaFQEiYHMehteDFfnM
         nlCmxzLo6KW1230+i+Xv/LjHjZ2hXfmj26oYIoa0VnUh8hIk6lSvTEZLrXxd2S3ydiJo
         NvLxWCiv9TQEA89thXq0eWMKDk3tyeUVBBEByeSmJY5SNbJHMtBFnyvrfUrvFiYXLXFw
         mVag==
X-Gm-Message-State: AOAM530v+R2SkjDeigyGnCtqQnVxBdgu2noNwTKBGVxox+9GvXTSSVlE
        VvBeOE8hfqnC03I0yhZdN79v2nPvQIKQsx1Jf/PWTdkyKnZ7iNaySTxGHcVv8E5E6NcajKpAzGS
        biKqAywSS7e6F
X-Received: by 2002:a05:600c:4284:b0:389:c472:e05e with SMTP id v4-20020a05600c428400b00389c472e05emr2417558wmc.19.1646816514296;
        Wed, 09 Mar 2022 01:01:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyAXoU+4WoIZYbFO+NXA9MK58DX0yxqbTORMzXVOGXqqWnQvtw1moTN4UdJ53YnAHPs7z7S4w==
X-Received: by 2002:a05:600c:4284:b0:389:c472:e05e with SMTP id v4-20020a05600c428400b00389c472e05emr2417528wmc.19.1646816514034;
        Wed, 09 Mar 2022 01:01:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ay24-20020a05600c1e1800b00389a420e1ecsm1098507wmb.37.2022.03.09.01.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:01:53 -0800 (PST)
Message-ID: <2bd92846-381b-f083-754a-89dfcdccc90c@redhat.com>
Date:   Wed, 9 Mar 2022 10:01:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: SVM: fix panic on out-of-bounds guest IRQ
Content-Language: en-US
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn,
        Yi Liu <liu.yi24@zte.com.cn>
References: <20220309113025.44469-1-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220309113025.44469-1-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 12:30, Yi Wang wrote:
> As guest_irq is coming from KVM_IRQFD API call, it may trigger
> crash in svm_update_pi_irte() due to out-of-bounds:
> 
> crash> bt
> PID: 22218  TASK: ffff951a6ad74980  CPU: 73  COMMAND: "vcpu8"
>   #0 [ffffb1ba6707fa40] machine_kexec at ffffffff8565b397
>   #1 [ffffb1ba6707fa90] __crash_kexec at ffffffff85788a6d
>   #2 [ffffb1ba6707fb58] crash_kexec at ffffffff8578995d
>   #3 [ffffb1ba6707fb70] oops_end at ffffffff85623c0d
>   #4 [ffffb1ba6707fb90] no_context at ffffffff856692c9
>   #5 [ffffb1ba6707fbf8] exc_page_fault at ffffffff85f95b51
>   #6 [ffffb1ba6707fc50] asm_exc_page_fault at ffffffff86000ace
>      [exception RIP: svm_update_pi_irte+227]
>      RIP: ffffffffc0761b53  RSP: ffffb1ba6707fd08  RFLAGS: 00010086
>      RAX: ffffb1ba6707fd78  RBX: ffffb1ba66d91000  RCX: 0000000000000001
>      RDX: 00003c803f63f1c0  RSI: 000000000000019a  RDI: ffffb1ba66db2ab8
>      RBP: 000000000000019a   R8: 0000000000000040   R9: ffff94ca41b82200
>      R10: ffffffffffffffcf  R11: 0000000000000001  R12: 0000000000000001
>      R13: 0000000000000001  R14: ffffffffffffffcf  R15: 000000000000005f
>      ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>   #7 [ffffb1ba6707fdb8] kvm_irq_routing_update at ffffffffc09f19a1 [kvm]
>   #8 [ffffb1ba6707fde0] kvm_set_irq_routing at ffffffffc09f2133 [kvm]
>   #9 [ffffb1ba6707fe18] kvm_vm_ioctl at ffffffffc09ef544 [kvm]
> #10 [ffffb1ba6707ff10] __x64_sys_ioctl at ffffffff85935474
> #11 [ffffb1ba6707ff40] do_syscall_64 at ffffffff85f921d3
> #12 [ffffb1ba6707ff50] entry_SYSCALL_64_after_hwframe at ffffffff8600007c
>      RIP: 00007f143c36488b  RSP: 00007f143a4e04b8  RFLAGS: 00000246
>      RAX: ffffffffffffffda  RBX: 00007f05780041d0  RCX: 00007f143c36488b
>      RDX: 00007f05780041d0  RSI: 000000004008ae6a  RDI: 0000000000000020
>      RBP: 00000000000004e8   R8: 0000000000000008   R9: 00007f05780041e0
>      R10: 00007f0578004560  R11: 0000000000000246  R12: 00000000000004e0
>      R13: 000000000000001a  R14: 00007f1424001c60  R15: 00007f0578003bc0
>      ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b
> 
> Vmx have been fix this in commit 3a8b0677fc61 (KVM: VMX: Do not BUG() on
> out-of-bounds guest IRQ), so we can just copy source from that to fix
> this.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> Signed-off-by: Yi Liu <liu.yi24@zte.com.cn>

Hi, the Signed-off-by chain is wrong.  Did Yi Liu write the patch (and 
you are just sending it)?

Paolo

> ---
>   arch/x86/kvm/svm/avic.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index fb3e20791338..f59b93d8e95a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -783,7 +783,7 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   {
>   	struct kvm_kernel_irq_routing_entry *e;
>   	struct kvm_irq_routing_table *irq_rt;
> -	int idx, ret = -EINVAL;
> +	int idx, ret = 0;
>   
>   	if (!kvm_arch_has_assigned_device(kvm) ||
>   	    !irq_remapping_cap(IRQ_POSTING_CAP))
> @@ -794,7 +794,13 @@ int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>   
>   	idx = srcu_read_lock(&kvm->irq_srcu);
>   	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
> -	WARN_ON(guest_irq >= irq_rt->nr_rt_entries);
> +
> +	if (guest_irq >= irq_rt->nr_rt_entries ||
> +		hlist_empty(&irq_rt->map[guest_irq])) {
> +		pr_warn_once("no route for guest_irq %u/%u (broken user space?)\n",
> +			     guest_irq, irq_rt->nr_rt_entries);
> +		goto out;
> +	}
>   
>   	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
>   		struct vcpu_data vcpu_info;

