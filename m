Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EC0178B6C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 08:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgCDHa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 02:30:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28984 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728432AbgCDHa6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Mar 2020 02:30:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583307057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T+pL0qsagmn9LfFxvyydb0rWSBt5iVBDnHKUDsA/QhY=;
        b=OAD6R36+2NOuoFF6CPBAdWEMgd7hr25IMPeSfEFIK9jchF6fLWyVhsisEOPwZl4QYOfft9
        12V5uVpnKMswknz/bV4kSrEmCOaa/cYPZrkIE1bmDtcyHtEp1oG0oMW59jsbM9pj/0UO8U
        QoNW3M07/Nx/l+YhHyNCDdECiGYIChs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-JG7HAJUWOMWPzpeTAeSlNA-1; Wed, 04 Mar 2020 02:30:53 -0500
X-MC-Unique: JG7HAJUWOMWPzpeTAeSlNA-1
Received: by mail-wr1-f70.google.com with SMTP id p11so488710wrn.10
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 23:30:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T+pL0qsagmn9LfFxvyydb0rWSBt5iVBDnHKUDsA/QhY=;
        b=fyHKovP+UcRjLYAAMkdn2plm8F0SWDXgUl9VPz4hNTgsBQjgaM1ukOJkVS1RyIzvaT
         eqc+UrCwKyRtiYkr3Cl9EJcIL0O49BpeQkhaB4gv2ICXZ89D8vY3UYK81YR1c6uJ5dAE
         qziVNNLezyS4rWeTBf2BHzkpiEHFafmF8N4YEozRZf5vaw6Yz7vJOPLkMGS+DXTyaKoY
         EickS9HXMgeeu1Wlx/TTmst+Sk+2iFk1X/n64JLCMcu9oO5Jk3JcHKWDVUIj0aXq8Qhg
         5NBEeIqSdt/9lJnnjJo5LK1cXMJpx/BJf5KaOzzbD9dB1apisihX1MWRkGhcyHEEwPJC
         6ZKw==
X-Gm-Message-State: ANhLgQ3Tif+50/ozRcxbgzeMN+Tj9yJiIebhyHktSeTIQ7BNvULYFew/
        Qj4hcdB7Q52KjrdhLf/TWeTA1UBsevt2TeIwaKrI/qPIXTtRi3l3sifi670/kYoBpWc7OpBag0X
        4NuBswnH9RcF5
X-Received: by 2002:adf:de83:: with SMTP id w3mr2620125wrl.275.1583307051534;
        Tue, 03 Mar 2020 23:30:51 -0800 (PST)
X-Google-Smtp-Source: ADFU+vv7K67V4alYNIqMl5Oc+4PHTR4QkwUs8qWk5xxbODKt72wZPPLJw5c6TJwOAXFw7xm97bFOMw==
X-Received: by 2002:adf:de83:: with SMTP id w3mr2620105wrl.275.1583307051303;
        Tue, 03 Mar 2020 23:30:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id y3sm2982342wmi.14.2020.03.03.23.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 23:30:49 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Avoid explictly fetch instruction in
 x86_decode_insn()
To:     linmiaohe <linmiaohe@huawei.com>, Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <593e16d8-1021-29ef-11d0-a72d762db057@redhat.com>
Date:   Wed, 4 Mar 2020 08:30:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/20 03:37, linmiaohe wrote:
> Hi:
> Peter Xu <peterx@redhat.com> writes:
>> insn_fetch() will always implicitly refill instruction buffer properly when the buffer is empty, so we don't need to explicitly fetch it even if insn_len==0 for x86_decode_insn().
>>
>> Signed-off-by: Peter Xu <peterx@redhat.com>
>> ---
>> arch/x86/kvm/emulate.c | 5 -----
>> 1 file changed, 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c index dd19fb3539e0..04f33c1ca926 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -5175,11 +5175,6 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
>> 	ctxt->opcode_len = 1;
>> 	if (insn_len > 0)
>> 		memcpy(ctxt->fetch.data, insn, insn_len);
>> -	else {
>> -		rc = __do_insn_fetch_bytes(ctxt, 1);
>> -		if (rc != X86EMUL_CONTINUE)
>> -			goto done;
>> -	}
>>
>> 	switch (mode) {
>> 	case X86EMUL_MODE_REAL:

This is a a small (but measurable) optimization; going through
__do_insn_fetch_bytes instead of do_insn_fetch_bytes is a little bit
faster because it lets you mark the branch in do_insn_fetch_bytes as
unlikely, and in general it allows the branch predictor to do a better job.

Paolo

> Looks good, thanks. But it seems we should also take care of the comment in __do_insn_fetch_bytes(), as we do not
> load instruction at the beginning of x86_decode_insn() now, which may be misleading:
> 		/*
>          * One instruction can only straddle two pages,
>          * and one has been loaded at the beginning of
>          * x86_decode_insn.  So, if not enough bytes
>          * still, we must have hit the 15-byte boundary.
>          */
>         if (unlikely(size < op_size))
>                 return emulate_gp(ctxt, 0);
> 

