Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADB36569A7
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 12:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiL0LDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 06:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiL0LDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 06:03:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4627664
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672138945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5UYXC2uvxEsQwzXX08EWlwnIuXoHoU3P6WcFp7pQfIc=;
        b=SVRW0ImPtROg+ZVzCYmrr04Dnfldm2XOoAte6ZbgU8PiSX892mimias3Wv0VN3I0759WAr
        3geNmHPmCykY0e3rJrr9m1nwh7AcdprAks7Iu4nSPGrJNHBT62uf7fROlyFhH4+W4l0kfr
        2sJgM2vlDFpM3oxthwPmZJ/AKvVJQqo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-156-QbQic2REMimcbJCM5kqEaw-1; Tue, 27 Dec 2022 06:02:23 -0500
X-MC-Unique: QbQic2REMimcbJCM5kqEaw-1
Received: by mail-ej1-f72.google.com with SMTP id ne1-20020a1709077b8100b007c198bb8c0eso8837019ejc.8
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:02:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5UYXC2uvxEsQwzXX08EWlwnIuXoHoU3P6WcFp7pQfIc=;
        b=e6/fya4VkfUJirrUJsvqE2x4YtyYj6V+hbtHMou1IXNVeMoE+eGwKS77WXdjJXN8fR
         oQyj3DzWMa44wbfkyYYyI4mVtVWjB8xjc8qsge9toNB/VNEIXF9pzezXK0UXZWeJdRPC
         HAH/myGQyImn+ljhidzCTgP8vsm+up1bJn6w/IBBB50/EFZLR91tLASr6m+e0e2uERup
         ZzJnEbvT5hQJs1Uds7LR9QE2kHx92xc1IAMiUi1CfBShWI+F5ExHqMcKvmcUCnA3RfYH
         EkzeRlaud8FsosQrKUPYn69sDYB+p07lmppTcUttyEmSqQzAgI4cf5Efdg01++VXlTLL
         g1tA==
X-Gm-Message-State: AFqh2koE0AD8IfLhZhyFIqR27XcokvmtFpKt75TiYjTYaiZUNHnkH+YV
        aD9d85TsY8B3duHj8HN5UaDRREXnuNDcjNRRECY0zA8chef4Nv4DP2tTFYj7YZsW0ZUGkBWdFfA
        zFdzmjBG5ePs5
X-Received: by 2002:a17:906:8a58:b0:7c1:6981:d062 with SMTP id gx24-20020a1709068a5800b007c16981d062mr18467517ejc.72.1672138942839;
        Tue, 27 Dec 2022 03:02:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvtuVevqtOxAgII/pHaaoiYHEFUS2wlj/SRdv5tiuPKkA6g4NfEq9EEC5erdg4XQB7vxKQ9mA==
X-Received: by 2002:a17:906:8a58:b0:7c1:6981:d062 with SMTP id gx24-20020a1709068a5800b007c16981d062mr18467497ejc.72.1672138942581;
        Tue, 27 Dec 2022 03:02:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm5835398ejt.197.2022.12.27.03.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 03:02:21 -0800 (PST)
Message-ID: <6698dabe-4c11-27c2-8e19-3b3322f0216a@redhat.com>
Date:   Tue, 27 Dec 2022 12:02:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/6] KVM: x86/xen: Fix memory leak in
 kvm_xen_write_hypercall_page()
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>
References: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
 <20221226120320.1125390-1-dwmw2@infradead.org>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221226120320.1125390-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/26/22 13:03, David Woodhouse wrote:
> From: Michal Luczaj <mhal@rbox.co>
> 
> Release page irrespectively of kvm_vcpu_write_guest() return value.
> 
> Suggested-by: Paul Durrant <paul@xen.org>
> Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> Message-Id: <20221220151454.712165-1-mhal@rbox.co>
> Reviewed-by: Paul Durrant <paul@xen.org>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index d7af40240248..d1a98d834d18 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1069,6 +1069,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
>   				  : kvm->arch.xen_hvm_config.blob_size_32;
>   		u8 *page;
> +		int ret;
>   
>   		if (page_num >= blob_size)
>   			return 1;
> @@ -1079,10 +1080,10 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   		if (IS_ERR(page))
>   			return PTR_ERR(page);
>   
> -		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
> -			kfree(page);
> +		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
> +		kfree(page);
> +		if (ret)
>   			return 1;
> -		}
>   	}
>   	return 0;
>   }

Queued, thanks.

Paolo

