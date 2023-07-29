Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061E8768028
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 16:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjG2Oym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jul 2023 10:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjG2Oyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jul 2023 10:54:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2851835B3
        for <kvm@vger.kernel.org>; Sat, 29 Jul 2023 07:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690642424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nq//HWsZ0YlNk9f1keqXb51bZ7c40xck1LtIyJE5/ZQ=;
        b=EIJviEFdoQbxWCskump2U0qJhagZtaiSBxIyAFyZ9VVmIGTWDsPi+t6Gw/NFusgHVYiSQC
        d2t+OCJQnWHT8JQe4puQadpuZhFI2YPfOiQQYZz6gPQlnKIY9HcVI7cg6PIgzgnSuzC9+q
        dvmBVttyFAROlw1tqrvfpbunHkZe1G4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-rzh2FiWOOXmxZPErPT462Q-1; Sat, 29 Jul 2023 10:53:42 -0400
X-MC-Unique: rzh2FiWOOXmxZPErPT462Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-52291e49dbcso2002311a12.2
        for <kvm@vger.kernel.org>; Sat, 29 Jul 2023 07:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690642421; x=1691247221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nq//HWsZ0YlNk9f1keqXb51bZ7c40xck1LtIyJE5/ZQ=;
        b=kCuWb0dO+GmugLjkBVdmEBMeYNQKUgkh2JFVhZ4+Bt5QQfbsgHSXOE46+YcIsGvdEC
         VILNn/y64pBEKxQ49w0kUCQ2AKtWxPrysfS9cRDt2XfXst6hriECRmLKZVaMmr1jlxRS
         jxFqrGHNELqyjq7rlSIbq2uvBO2zpFIcq9w6akDSxvvuFWYPgiW2ixU9aDmDPM6P6Cb4
         jjVG1Mht3OXtHosYxzSQXux+vIGH/28O85ufzEqgwMQADvxZppJ+oO1sZqrrPshBgyEK
         +7azEtr9eNJM3ul1qk4h4AzuP85fgiS/KiGuGLJH6/hb69Jy+o+z6Y0LVqkXP0jYbMX3
         kn7w==
X-Gm-Message-State: ABy/qLZZBDu5Z0L4Fei/Y2pcMBjfZ1b65UtCSPp3sRmTCtwNtceAhlSs
        ++9dC0RFY2ZWtWmsBfT+vMRmGaXm8RoDkAoHUjRyz7uZF6k2rm2v6Tod3fzaZLyAwwOO9cpStje
        xN2c7PWsUWWYy
X-Received: by 2002:aa7:c143:0:b0:522:27f1:3c06 with SMTP id r3-20020aa7c143000000b0052227f13c06mr3987607edp.21.1690642421581;
        Sat, 29 Jul 2023 07:53:41 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHcLjwyLS0eEAF2f90zM6l73C9+BegNJtS2/XMqpaqk6VNw0aCeVqXlcfx3eu66X64IzYJ67A==
X-Received: by 2002:aa7:c143:0:b0:522:27f1:3c06 with SMTP id r3-20020aa7c143000000b0052227f13c06mr3987596edp.21.1690642421264;
        Sat, 29 Jul 2023 07:53:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r13-20020aa7d58d000000b005227b065a78sm3015413edq.70.2023.07.29.07.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jul 2023 07:53:40 -0700 (PDT)
Message-ID: <fe59c490-da64-10ae-7f94-88d842e9f839@redhat.com>
Date:   Sat, 29 Jul 2023 16:53:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] KVM: x86/tsc: Use calculated tsc_offset before
 matching the fist vcpu's tsc
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230724073516.45394-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230724073516.45394-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/24/23 09:35, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Avoid using kvm->arch.cur_tsc_offset until tsc sync is actually needed.
> 
> When the vcpu is created for the first time, its tsc is 0, and KVM
> calculates its tsc_offset according to kvm_compute_l1_tsc_offset().
> The userspace will then set the first non-zero tsc expected value for the
> first guest vcpu, at this time there is no need to play the tsc synchronize
> mechanism, the KVM should continue to write tsc_offset based on previously
> used kvm_compute_l1_tsc_offset().
> 
> If the tsc synchronization mechanism is incorrectly applied at this point,
> KVM will use the rewritten offset of the kvm->arch.cur_tsc_offset (on
> tsc_stable machines) to write tsc_offset, which is not in line with the
> expected tsc of the user space.
> 
> Based on the current code, the vcpu's tsc_offset is not configured as
> expected, resulting in significant guest service response latency, which
> is observed in our production environment.
> 
> Applying the tsc synchronization logic after the vcpu's tsc_generation
> and KVM's cur_tsc_generation have completed their first match and started
> keeping tracked helps to fix this issue, which also does not break any
> existing guest tsc test cases.
> 
> Reported-by: Yong He <alexyonghe@tencent.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217423
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> V1 -> V2 Changelog:
> - Test the 'kvm_vcpu_has_run(vcpu)' proposal; (Sean)
> - Test the kvm->arch.user_changed_tsc proposal; (Oliver)
> V1: https://lore.kernel.org/kvm/20230629164838.66847-1-likexu@tencent.com/
> 
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a6b9bea62fb8..4724dacea2df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2721,7 +2721,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>   			 * kvm_clock stable after CPU hotplug
>   			 */
>   			synchronizing = true;
> -		} else {
> +		} else if (kvm->arch.nr_vcpus_matched_tsc) {
>   			u64 tsc_exp = kvm->arch.last_tsc_write +
>   						nsec_to_cycles(vcpu, elapsed);
>   			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
> 

I am not sure, when will kvm->arch.nr_vcpus_matched_tsc ever be nonzero 
again once a new generation starts?  If this patch ever causes 
synchronizing to be false, matched will also be false when calling 
__kvm_synchronize_tsc.

What was wrong with Oliver's proposed patch?

Paolo

