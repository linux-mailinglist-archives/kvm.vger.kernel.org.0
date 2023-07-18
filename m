Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E055757AB6
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 13:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjGRLme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 07:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjGRLmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 07:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9655198E
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 04:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689680473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6mYqRmobTSmlaJDxzrk7H0sz66Ug53ixgvatsoEizE0=;
        b=UHvAzZcqo4AqxpTwwtSuu5xbMBQ3L4helNJ1F5zloYwDjGEqcahlHwy0VNv2E9yeLHFdMQ
        z5qotULip/yWy9HJbDqzopxcIJsmHNPk9WRE82hJa6s/aGkQtvh1L0CD93IyIJlVh7w3rg
        fMi0xvgoidQFzU9Rn4iVJ6D/XMtB86M=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-6vws4KHJNL2odPZ4QV-yEg-1; Tue, 18 Jul 2023 07:41:12 -0400
X-MC-Unique: 6vws4KHJNL2odPZ4QV-yEg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a34d3e5ebso316136966b.3
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 04:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689680471; x=1692272471;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6mYqRmobTSmlaJDxzrk7H0sz66Ug53ixgvatsoEizE0=;
        b=fes8XxjWeWMqrqp3ryu0cXSrdeIwTApbkiw02h4LlJxhSV2CCEpaZyNxI4FMMhnm2w
         gEFlg6j/Ey3ii71xLPnEm1geamVV3LAY41VLuxDmvMHX2IhubZJQSy8KSqgg7aqSMAPu
         ipIY7vHqHZr8HvaflHwaC8xX0GOkOqnADQzYzBqpo6+Da5zxnT1mJSp9Mju+218+YCcG
         6Q4yOkz4cwAoywzJcFOniIYOVd9MTkhh3CVLZGlARybCPrP9QSfR6uunJAOW13y5pGBW
         uhgTNTbsJu8V2CThmYC67e87xhug6qkRwmB2Yr/NZ2oIvrJVaGCUtB/54fYHjssQZPFT
         bf2w==
X-Gm-Message-State: ABy/qLYCEGrjCdY2zEZV7TZ/9UBPz9ISamCzjtgxcxpDrxh5aIdruZ1e
        TUDrfnFq5VtaHD0UPI4TJfGRQeO2OXHLpn5+2P2IOum5gwz37AenknAUh7sGgsvyHrmsvWRcw9e
        KMyJIG0meBo+3JSeLnKlG
X-Received: by 2002:a17:907:1dd3:b0:978:90cc:bf73 with SMTP id og19-20020a1709071dd300b0097890ccbf73mr11470057ejc.48.1689680471333;
        Tue, 18 Jul 2023 04:41:11 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEFnorFN48cFP8/ErR9y/dfNcwwMKE9ug0uTRlgEY4VxsbZO6jdC8B+PpsJ1lhsYgio3ROSbg==
X-Received: by 2002:a17:907:1dd3:b0:978:90cc:bf73 with SMTP id og19-20020a1709071dd300b0097890ccbf73mr11470029ejc.48.1689680470983;
        Tue, 18 Jul 2023 04:41:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id k2-20020a170906128200b0098e2eaec394sm904339ejb.101.2023.07.18.04.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 04:41:10 -0700 (PDT)
Message-ID: <bda79e85-c0bf-8d59-2750-d922a59bb859@redhat.com>
Date:   Tue, 18 Jul 2023 13:41:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
References: <20230718091310.119672-1-mlevitsk@redhat.com>
 <20230718091310.119672-2-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: VMX: __kvm_apic_update_irr must update the
 IRR atomically
In-Reply-To: <20230718091310.119672-2-mlevitsk@redhat.com>
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

On 7/18/23 11:13, Maxim Levitsky wrote:
> +		irr_val = READ_ONCE(*((u32 *)(regs + APIC_IRR + i * 0x10)));

Let's separate out the complicated arithmetic, as it recurs below too:

	u32 *p_irr = (u32 *)(regs + APIC_IRR + i * 0x10);

> +			while (!try_cmpxchg(((u32 *)(regs + APIC_IRR + i * 0x10)),
> +			       &irr_val, irr_val | pir_val));
> +
>   			prev_irr_val = irr_val;
> -			irr_val |= xchg(&pir[i], 0);
> -			*((u32 *)(regs + APIC_IRR + i * 0x10)) = irr_val;
> -			if (prev_irr_val != irr_val) {
> -				max_updated_irr =
> -					__fls(irr_val ^ prev_irr_val) + vec;
> -			}
> +			irr_val |= pir_val;
> +
> +			if (prev_irr_val != irr_val)
> +				max_updated_irr = __fls(irr_val ^ prev_irr_val) + vec;

We can write this a bit more cleanly too, and avoid unnecessary
try_cmpxchg too:

prev_irr_val = irr_val;
do
	irr_val = prev_irr_val | pir_val;
while (prev_irr_val != irr_val &&
        !try_cmpxchg(p_irr, &prev_irr_val, irr_val));

if (prev_irr_val != irr_val)
	max_updated_irr = __fls(irr_val ^ prev_irr_val) + vec;

If this looks okay to you, I'll queue the patches for -rc3 and also Cc 
them for inclusion in stable kernels.

Paolo

