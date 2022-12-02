Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD36640DBA
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiLBSpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbiLBSpV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:45:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0836312
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670006593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xcEA7o1BcfKrY2K2tVnrEXaf0YA37GTfmmfJSVGitL0=;
        b=dMUCKLX+LiNpqCAsM9b7ZSRQWOFG7yrhx1QXD/h48X8nWV8dc78vI7Vdvc/lrKQfMbQZU6
        O8csRVqDDvIGl91tUOPjhzhh/RbXMyzFtohjBV3+rk1bmKiZeWaiLlVzLZIDfnkSrjNjpM
        0q9JgONcsRPiIa+nMaxOvg9MvrlQz9Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-399-RF6_niA3P4Sk_fkFwglOpw-1; Fri, 02 Dec 2022 13:43:06 -0500
X-MC-Unique: RF6_niA3P4Sk_fkFwglOpw-1
Received: by mail-wm1-f69.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso2901473wmh.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:43:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcEA7o1BcfKrY2K2tVnrEXaf0YA37GTfmmfJSVGitL0=;
        b=AkdOGEmKfdGENPzAi55QJ6fiabPhC/sl7oeK8ovbqDSfpl56MyjbZtNFYrjYIsiqBy
         d6nvumVdZmmizp8LWPGi6Tll+a7ywGICTAElB8cdtFTNoSlJJ+3pj0/fuNyapPYA/IX9
         3vzn9V8gPh/o5SmFxrzia7F3bzArVSNY2ekkbBGkxLZo2CZllKQlHlK9xQrVxccpKLdZ
         DWDCCaLCr34Q1uCBXlu11FjMquI0ywtWgjbrbTewcVlcJlY7ftexLMAfpUXKmaKVuxQr
         zzvBHlHhLTllQLaT//i6NsWpCkckGEYuNwmDXhfvYQ/dTBvRai1d27YHm6aIl884quuw
         8dGw==
X-Gm-Message-State: ANoB5pnQZZT4rf+oNcJAF6yJJe6nrx7NFxrBvzTa7nv1l6JSTCcCr0w2
        jaFAsCZK2pwCkcUAju5A0kNqCa9VoxWqBq6MPl/6B5l7jI0ZXEKZ1lpZuOHvaZ0byHu/OGdijBS
        DiOaN9MCwNPFn
X-Received: by 2002:adf:f64e:0:b0:242:4006:b55c with SMTP id x14-20020adff64e000000b002424006b55cmr4008170wrp.532.1670006585751;
        Fri, 02 Dec 2022 10:43:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5WhXiKGTxZ6Btc40SYbZT6jTQG58ViDLAnwokq+LLgoJFeyTpExfGp4/9yXEqLSK2FGVbYeA==
X-Received: by 2002:adf:f64e:0:b0:242:4006:b55c with SMTP id x14-20020adff64e000000b002424006b55cmr4008160wrp.532.1670006585549;
        Fri, 02 Dec 2022 10:43:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n36-20020a05600c502400b003cf6c2f9513sm9601785wmr.2.2022.12.02.10.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:43:05 -0800 (PST)
Message-ID: <847ff9d1-c160-f243-65cf-92bbe14abf33@redhat.com>
Date:   Fri, 2 Dec 2022 19:43:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: x86: Optimize your code to avoid unnecessary calls
Content-Language: en-US
To:     liujing <liujing@cmss.chinamobile.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221201014237.5764-1-liujing@cmss.chinamobile.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221201014237.5764-1-liujing@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

thanks for your contribution!  We can improve the code even further 
though.  You are still calling kvm_pic_update_irq() after 
kvm_set_ioapic(), and that is also unnecessary.

On 12/1/22 02:42, liujing wrote:
> @@ -6047,11 +6042,10 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
>   		kvm_set_ioapic(kvm, &chip->chip.ioapic);
>   		break;
>   	default:
> -		r = -EINVAL;
> -		break;
> +		return -EINVAL;
>   	}
>   	kvm_pic_update_irq(pic);
> -	return r;

Please make instead a new function:

void
kvm_set_pic(struct kvm *kvm, int n, struct kvm_pic_state *state)
{
	struct kvm_pic *s = kvm->arch.vpic;

	pic_lock(s);
	memcpy(...)
	pic_update_irq(s);
	pic_unlock(s);
}

that lets you replace kvm_pic_update_irq() altogether.

Thanks!

Paolo

