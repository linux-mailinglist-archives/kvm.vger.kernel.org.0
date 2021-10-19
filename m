Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D541432F69
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 09:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhJSHbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 03:31:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhJSHbc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 03:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634628559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqVn5RwvdpeL/byQOIlSug5o1mDvU+SpBxf9v6lVTbw=;
        b=fi0IVwkpTMkg1dc+JnTWH79jimmTKSpSBzK/wz3hl0IyWprDcZ8NaQBKbWFiie/GfcrXot
        hhu3yWc8KAyAz4mbRyNWGVqxqmacl67mxMs7rg0JVVXC5oU6jm0ZaAwmGgi8qiV7PYPoHH
        jGYG+tARlR2vM6mAczB5cbSZJQlUQqs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-cKVnJ5a_NcSucRlFKutZ-g-1; Tue, 19 Oct 2021 03:29:18 -0400
X-MC-Unique: cKVnJ5a_NcSucRlFKutZ-g-1
Received: by mail-ed1-f69.google.com with SMTP id e14-20020a056402088e00b003db6ebb9526so16664603edy.22
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 00:29:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yqVn5RwvdpeL/byQOIlSug5o1mDvU+SpBxf9v6lVTbw=;
        b=U7rsyb3xpqdMYMqIHE86kcVtwzD3Ww9jXnupnItE4Q5J/8ITmi4LuWjXORwsgYhdwx
         pchCDkxZ9oAxK25t50qz5Z5uR3CqjJyYCN/YYEL7DqwdUlwQos30cq+rzJh2OBdaLHLs
         +9uRZWcpnfIdEK1nHiJFRpuNkEEdGnAemSzl9dgAWmzrrTHmBuHFK0V808xZW5yyNoBb
         jhn93bFThpZHuTD7Cdt/pkNmBx3171nV58O+fKeW6vnd5xceTL/zomnFEJtKdWhNtCD8
         Cywso21C9zY35FmY2K4Pl65jRHCI6Abu+54cuqtzYstw8eWgTSMExGNHHvUiWdm5KdZx
         RkvQ==
X-Gm-Message-State: AOAM533x+byTfcY6FKZhJj9zCtD4SVrpBk/gT6eJwmh534AlQSNEW2vL
        ZdCFcjcRKhcBQjDglaEN2OLL36capBwh+0tyHzXKYUXu6foTy0tlFzKtTTLzeJOEiXNYdBmhrL9
        AUqWyjfij/eXY
X-Received: by 2002:a17:907:971e:: with SMTP id jg30mr36114062ejc.169.1634628557122;
        Tue, 19 Oct 2021 00:29:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNTjle6x1nbzF/SoF4SS95DKSy0DVA4VZCiNUpt/jVZ3v4C1arh0eLJse/qEuUVyGV+2jI1g==
X-Received: by 2002:a17:907:971e:: with SMTP id jg30mr36114047ejc.169.1634628556918;
        Tue, 19 Oct 2021 00:29:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id i10sm11036825edl.15.2021.10.19.00.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 00:29:16 -0700 (PDT)
Message-ID: <876df534-a280-dc26-6a70-a1464bacad5f@redhat.com>
Date:   Tue, 19 Oct 2021 09:29:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: Clear pv eoi pending bit only when it is set
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Cc:     seanjc@google.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org
References: <1634609144-28952-1-git-send-email-lirongqing@baidu.com>
 <87y26pwk96.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87y26pwk96.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 09:23, Vitaly Kuznetsov wrote:
>>   
>> -static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
>> +static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu, bool pending)
> Nitpick (and probably a matter of personal taste): pv_eoi_clr_pending()
> has only one user and the change doesn't make its interface much nicer,
> I'd suggest we just inline in instead. (we can probably do the same to
> pv_eoi_get_pending()/pv_eoi_set_pending() too).

Alternatively, merge pv_eoi_get_pending and pv_eoi_clr_pending into a 
single function pv_eoi_test_and_clear_pending, which returns the value 
of the pending bit.

So the caller can do essentially:

-	pending = pv_eoi_get_pending(vcpu);
-	pv_eoi_clr_pending(vcpu);
-	if (pending)
+	if (pv_eoi_test_and_clear_pending(vcpu))
                 return;


Paolo

