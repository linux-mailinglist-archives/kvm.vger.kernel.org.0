Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6FF4D2C48
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 10:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiCIJkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 04:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiCIJkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 04:40:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F28ADA865
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 01:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646818742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ceu+mVtn0m1mLuj4Eu7l+tJ5zr0qjvpQJmEqW6dih8k=;
        b=SDsKMlP4uposIjgd2PlUpwlro//rYTCiCUDj+66n53YSB8o6bVCtPtWXagpErPHG1nWkjA
        PLZa8Ht8tzL3kwQIzjSGPNPN4074jwpCvjZ16ky3nZ6bIWk1TiQMwAjOHI7hMHrAwMtUzn
        HSbg4elpvUzuezLKNV8DXCwCRcvLsd8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-wCp2jZiSNHWUsiFi0D16kA-1; Wed, 09 Mar 2022 04:39:01 -0500
X-MC-Unique: wCp2jZiSNHWUsiFi0D16kA-1
Received: by mail-wm1-f70.google.com with SMTP id 7-20020a1c1907000000b003471d9bbe8dso1668943wmz.0
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 01:39:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ceu+mVtn0m1mLuj4Eu7l+tJ5zr0qjvpQJmEqW6dih8k=;
        b=NVULTmUMPGybIbSY1h2qDMY0eE5jKXt4MG+NjdHwfnAQmY6JGDLGLTi3Y/oBiM/jzG
         GHBbq+1AZYek0+nvPAHI25ZIeH/9SN5XA15gE40L2m93ICavF9ixMrtulgvK6rTD2RFT
         q+70IpP+kDaPW6uKdpL1OFEd/YIXQZuc7CoEIzpOQNrNuL9R4fYRceXJLL+HhgGyToAv
         UD/LCR1eFH9QqoG+NET/fkoso260kYRlCyaRK2kOon1m+VKnsmntp1oDgMslJMgTQvmm
         XWQv/2J25euF0sw2sgsQy+CZizeKybzX4hbdiTJGZUdsvd0GVKQAiWdkaPRo4OGdNL+p
         Rtqw==
X-Gm-Message-State: AOAM532YSdN/kTFpnuxuZWLLpUA9NoiFeekzlfIWzFrnnMUa/jvg+Ev9
        fWJ+yZtPlVC1SfZuTjJcFtV9s9JQre0WcT/SYSge1mvnI9LRdSKvC9ZLy6bnyXc2+lsYn1Mzzo+
        rVyQxMu95+kO+
X-Received: by 2002:a7b:c8d7:0:b0:389:c84c:55be with SMTP id f23-20020a7bc8d7000000b00389c84c55bemr5034845wml.135.1646818739534;
        Wed, 09 Mar 2022 01:38:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjmIBhFizyFKH0ag29FksH/acvu4AmMAUJO1dRmhGlZ81wKvnpyRG8euUUgNj09BIOyGG1XA==
X-Received: by 2002:a7b:c8d7:0:b0:389:c84c:55be with SMTP id f23-20020a7bc8d7000000b00389c84c55bemr5034830wml.135.1646818739288;
        Wed, 09 Mar 2022 01:38:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v20-20020a7bcb54000000b0037fa63db8aasm4850666wmj.5.2022.03.09.01.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:38:58 -0800 (PST)
Message-ID: <c54cc8ba-a5a7-b73b-4bb4-12f766fef558@redhat.com>
Date:   Wed, 9 Mar 2022 10:38:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: fix sending PV IPI
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, x86@kernel.org,
        kvm@vger.kernel.org, wanpengli@tencent.com
References: <1646814944-51801-1-git-send-email-lirongqing@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1646814944-51801-1-git-send-email-lirongqing@baidu.com>
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

On 3/9/22 09:35, Li RongQing wrote:
> if apic_id is less than min, and (max - apic_id) is greater than
> KVM_IPI_CLUSTER_SIZE, then third check condition is satisfied,
> 
> but it should enter last branch, send IPI directly
> 
> Fixes: aaffcfd1e82 ("KVM: X86: Implement PV IPIs in linux guest")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

So an example is

    apic_id on first iteration = 1
    apic_id on second iteration = KVM_IPI_CLUSTER_SIZE
    apic_id on third iteration = 0

Thanks, this looks good.

Paolo

> ---
>   arch/x86/kernel/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 959f919..8915c93 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -517,7 +517,7 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>   		} else if (apic_id < min && max - apic_id < KVM_IPI_CLUSTER_SIZE) {
>   			ipi_bitmap <<= min - apic_id;
>   			min = apic_id;
> -		} else if (apic_id < min + KVM_IPI_CLUSTER_SIZE) {
> +		} else if (apic_id > min && apic_id < min + KVM_IPI_CLUSTER_SIZE) {
>   			max = apic_id < max ? max : apic_id;
>   		} else {
>   			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,

