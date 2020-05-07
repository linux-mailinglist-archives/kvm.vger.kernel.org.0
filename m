Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBAA1C9E54
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 00:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgEGWVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 18:21:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53243 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726776AbgEGWVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 18:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588890068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZoTGnbCXcMKyRQ9mPxmL7dzgnwDNH85/mAMTGS95ms=;
        b=HA3o5kIQyIQjF+uw+fizTpkT0ceaFuinyNahPnSlRv3bvQMtLtk7I3kwN6WiEoRsFKdFsN
        vfo/dpLpJ+W01w1nhzRMmDnhQOLMiJD840NTpRy7cz5MN7Tpe35qbvwa5UnNEpksxq5Xjk
        tG3ss+FCt8+NlwpH+tAdTqlkHQvHkV4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-_tlYO-PPMJ6BgMe03y9H_Q-1; Thu, 07 May 2020 18:21:06 -0400
X-MC-Unique: _tlYO-PPMJ6BgMe03y9H_Q-1
Received: by mail-wr1-f72.google.com with SMTP id e5so4223814wrs.23
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 15:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AZoTGnbCXcMKyRQ9mPxmL7dzgnwDNH85/mAMTGS95ms=;
        b=YRxDTa+sjBm0sDN6RzXXV03lNpPmpV7Z2KAzFdsu4rtjBPNthU5tYJ2GzkksWvz6a8
         rDzfpJNxBjFFtI0I3NYUvaN0ghmXwxz770M4b9wa14z9usAZXQhFbr4w0Jpb7wP7xY3l
         0fa5AEiZDAJRX0IQ7gAszVVvLzi21y9LZo2AqTm2XANdhcqvQdp0SbT408OrFJsn7Aj3
         Bu6+y9VIICU0pqJFSHX7vOqImjI2rqd1rIorFRcjuy2rDbTL9W+vklQCK5bB0/w71hs7
         A+3TBtXJ/RxaTluQ8+ONTKC3GDtL3e8TJjjvWFpirphltQoY+98eHiRXcj3uiUhh/gqb
         yWew==
X-Gm-Message-State: AGi0Pubn6B1gCkoUNir3KB2RrN4LzwLQlIOS0Ovqqgmj/nbkdktw6Zwf
        /rMl+wlxwYue/iNillNiY2qgNglTLXhVj6mWyiWaE/jWNiSI6xITtHs/wnYE6rxJCkZ59QAHIEU
        zWKoRNqe4p2Cj
X-Received: by 2002:a5d:510f:: with SMTP id s15mr19666487wrt.103.1588890064409;
        Thu, 07 May 2020 15:21:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypLUV4HMfiKwgurDoaoGbriEeAIIhW/Gxxjg07T2LtNMBH9vWdh9mS5ffncMlq2akBCU6Erg8g==
X-Received: by 2002:a5d:510f:: with SMTP id s15mr19666469wrt.103.1588890064128;
        Thu, 07 May 2020 15:21:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id z132sm7704638wmc.29.2020.05.07.15.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 15:21:03 -0700 (PDT)
Subject: Re: [PATCH v2 7/9] KVM: SVM: keep DR6 synchronized with
 vcpu->arch.dr6
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-8-pbonzini@redhat.com> <20200507182220.GI228260@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d6e61be1-f1e0-59a5-f5a0-538c739d0805@redhat.com>
Date:   Fri, 8 May 2020 00:21:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507182220.GI228260@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 20:22, Peter Xu wrote:
>> -	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
>> +	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
> The rest looks very sane to me, but here I failed to figure out how arch.dr6
> finally applied to save.dr6.  I saw it is applied in svm_vcpu_run() in the next
> patch, but if that's the case then iiuc this commit may break bisection. Thanks,

You're right, this needs a call to kvm_update_dr6 (which would go away
on the next patch).

Paolo

