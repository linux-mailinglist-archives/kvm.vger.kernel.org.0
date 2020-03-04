Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9A61797B3
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 19:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388189AbgCDSUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 13:20:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388117AbgCDSUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Mar 2020 13:20:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583346006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sc0Xcmlskdb745JmJFxuE7AmsaR9eAsu+qMPQfvgRAA=;
        b=eDkIqyvjUnm9dj3Lgoxc/HLfoyUR55xFutBY1nqTxiVrgkQ+3fKHlh5aKxJgtZzw3c45ub
        FvTdmkHXd6kMbT5wgxUy8gBbUh2NL8WTpfPZKtnjb2NxL/YwMeolu3u51PVJDq+3uNCqEx
        u4HzOeJe7c2o/XZlFChTY17v8rfxo54=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-RWTBqAa0Ojam-1IK3EB7Wg-1; Wed, 04 Mar 2020 13:20:02 -0500
X-MC-Unique: RWTBqAa0Ojam-1IK3EB7Wg-1
Received: by mail-wr1-f72.google.com with SMTP id q18so1190604wrw.5
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 10:20:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sc0Xcmlskdb745JmJFxuE7AmsaR9eAsu+qMPQfvgRAA=;
        b=q+aOOYj85KmzvBDCX+IrgGPapS59GIOchIiBvZx3OqUhCOippxrBSyeYxnAhxajv+i
         ueUkrfWLrAOhdWy6fwaV3ZKN4qegau9VJR929zGDIRjo29lRAfXTufHKGAIJT0NiI+oZ
         htG6GwxvdqSMrGltKhhR0fAP07AzblM3LBg5xGP9wJ+EIKxM8vSQcVg8/gM0JCSgcqpL
         3rr3lthK2NfouOKQ/6ewH3D9qWQPyvD0F0Y0KH8QkSDeFPRGpiGJtcPglxCkFfWCkYd5
         kwGwfIk3f5W/KlQjfdfUjef0UvXY7220AdduD9dFW9a/hLH0VTkfrnJXXVN1Y9UbduRY
         GWXA==
X-Gm-Message-State: ANhLgQ2t+D2LmYsdZ+aocZdxvrut4EjvutfctDXDYwm6meQZRIaBP8+l
        Ca+aAi8UOtc6C0FcMpgrYczGnoteipNULiTis7OIIf9iuxSUnQ6wfrjpvs6hPpkj4vshCEQjnJV
        jpCF1fzds4xIl
X-Received: by 2002:a5d:4043:: with SMTP id w3mr5385370wrp.139.1583346001107;
        Wed, 04 Mar 2020 10:20:01 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvMvPx30AeZ0XZ0GMLVOfVyfATjiiWEyIm29aWaWBtqZT4tOSR60u07P5jBLCYTmV38Q30pcw==
X-Received: by 2002:a5d:4043:: with SMTP id w3mr5385363wrp.139.1583346000909;
        Wed, 04 Mar 2020 10:20:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id k66sm2769279wmf.0.2020.03.04.10.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 10:20:00 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Avoid explictly fetch instruction in
 x86_decode_insn()
To:     Peter Xu <peterx@redhat.com>, linmiaohe <linmiaohe@huawei.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <05ca4e7e070844dd92e4f673a1bc15d9@huawei.com>
 <20200304153253.GB7146@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad023c34-9a08-7d61-22de-911c4e8760ba@redhat.com>
Date:   Wed, 4 Mar 2020 19:19:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304153253.GB7146@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/20 16:32, Peter Xu wrote:
>> Looks good, thanks. But it seems we should also take care of the comment in __do_insn_fetch_bytes(), as we do not
>> load instruction at the beginning of x86_decode_insn() now, which may be misleading:
>> 		/*
>>          * One instruction can only straddle two pages,
>>          * and one has been loaded at the beginning of
>>          * x86_decode_insn.  So, if not enough bytes
>>          * still, we must have hit the 15-byte boundary.
>>          */
>>         if (unlikely(size < op_size))
>>                 return emulate_gp(ctxt, 0);
> Right, thanks for spotting that (even if the patch to be dropped :).
> 
> I guess not only the comment, but the check might even fail if we
> apply the patch. Because when the fetch is the 1st attempt and
> unluckily that acrosses one page boundary (because we'll only fetch
> until either 15 bytes or the page boundary), so that single fetch
> could be smaller than op_size provided.

Right, priming the decode cache with one byte from the current page
cannot fail, and then we know that the next call must be at the
beginning of the next page.

Paolo

