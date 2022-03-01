Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02EC4C95FF
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 21:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiCAUSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 15:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbiCAUSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 15:18:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A0823CA51
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 12:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646165878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M1914MzJ/T9hp/vAg8C07YWWHfVVw2QqOeY8vtrYeMI=;
        b=XiVA5QPiwCyirf22OnPCiH+uV4dOQDM78BvEL32zyWPwLCApNDFvsPfAyOrOpNjgGJje5h
        +qAjJVynZT1F7bslV2iq8bnyR/DKW1TYHyoh0r7NOYaqvrsV+ShAlzPg9ZteGVNtlyMe/0
        oeWHupOARr7n/gel8WvldJ2F/HOUZmY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-vhKSBTO6NZ-e87-PQpTsNA-1; Tue, 01 Mar 2022 15:17:57 -0500
X-MC-Unique: vhKSBTO6NZ-e87-PQpTsNA-1
Received: by mail-wm1-f72.google.com with SMTP id l31-20020a05600c1d1f00b00380e3425ba7so1720256wms.9
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 12:17:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M1914MzJ/T9hp/vAg8C07YWWHfVVw2QqOeY8vtrYeMI=;
        b=xAP5RPfv/mH2ABz7eNBuA/joQIsJL3wS2gPEaNXEJHFY0RNTeuGZfPU8oF7UPrlU4z
         u+LcwfuDHnuPhStkoGWnK2+6xdPhEWJg3FnZ8UrimYpceoWIlrGZWf7ES1Eji2M0xq9E
         W9gWGR2OCTPcjiu6gJgGGeiaVOeEgC605jseMcYmagQ84y+fXkrZ8mM8hVmohxSd9vVM
         HbpMdDp/9dGmFNFzGZw+/mzAqbO6HMn4+FB3y/rsdWXNdKzC/9JpojHMvZbipo78mKXF
         inFBCw0hsojIlKgDvGSVdFvrGRlPP6Pr/9jI8amaIauqq8AsJQPo/2bqUtK9IRwcFOOH
         ahpA==
X-Gm-Message-State: AOAM531E68yH+9FnPqxiXgBr/bfBqwpULtwn5KE/fEGEAjoaqbgKWV9u
        6K82Ir626g+RKYtrxEla3cn5MjlVHFbONzQgrcUUwENhMpHcAam02c8aT6hiLWAKxvAd+7iOYp7
        EYzAv7f6PISLK
X-Received: by 2002:a5d:64c8:0:b0:1ef:8e7b:b9 with SMTP id f8-20020a5d64c8000000b001ef8e7b00b9mr12007723wri.182.1646165876376;
        Tue, 01 Mar 2022 12:17:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLCbSzpwlVz70VTYSeQFCuiRW62d5XvnKnwwgwNQZKeyjs7PvmxN7o8nVlDzHjHMbAB+FOcQ==
X-Received: by 2002:a5d:64c8:0:b0:1ef:8e7b:b9 with SMTP id f8-20020a5d64c8000000b001ef8e7b00b9mr12007705wri.182.1646165876141;
        Tue, 01 Mar 2022 12:17:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id h9-20020adff189000000b001ea913352c9sm14590055wro.100.2022.03.01.12.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 12:17:55 -0800 (PST)
Message-ID: <ab4f9fab-1137-72f8-5020-f4041d2b4c06@redhat.com>
Date:   Tue, 1 Mar 2022 21:17:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH AUTOSEL 5.15 06/23] kvm: x86: Disable KVM_HC_CLOCK_PAIRING
 if tsc is in always catchup mode
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Anton Romanov <romanton@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220301201629.18547-1-sashal@kernel.org>
 <20220301201629.18547-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301201629.18547-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/1/22 21:16, Sasha Levin wrote:
> From: Anton Romanov <romanton@google.com>
> 
> [ Upstream commit 3a55f729240a686aa8af00af436306c0cd532522 ]
> 
> If vcpu has tsc_always_catchup set each request updates pvclock data.
> KVM_HC_CLOCK_PAIRING consumers such as ptp_kvm_x86 rely on tsc read on
> host's side and do hypercall inside pvclock_read_retry loop leading to
> infinite loop in such situation.
> 
> v3:
>      Removed warn
>      Changed return code to KVM_EFAULT
> v2:
>      Added warn
> 
> Signed-off-by: Anton Romanov <romanton@google.com>
> Message-Id: <20220216182653.506850-1-romanton@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 33cb065181248..c804122bb6e3a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8657,6 +8657,13 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
>   	if (clock_type != KVM_CLOCK_PAIRING_WALLCLOCK)
>   		return -KVM_EOPNOTSUPP;
>   
> +	/*
> +	 * When tsc is in permanent catchup mode guests won't be able to use
> +	 * pvclock_read_retry loop to get consistent view of pvclock
> +	 */
> +	if (vcpu->arch.tsc_always_catchup)
> +		return -KVM_EOPNOTSUPP;
> +
>   	if (!kvm_get_walltime_and_clockread(&ts, &cycle))
>   		return -KVM_EOPNOTSUPP;
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

