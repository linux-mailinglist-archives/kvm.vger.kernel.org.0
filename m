Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C1F47A1D1
	for <lists+kvm@lfdr.de>; Sun, 19 Dec 2021 19:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhLSSlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 13:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbhLSSlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Dec 2021 13:41:12 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCCFC061574;
        Sun, 19 Dec 2021 10:41:12 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b13so1036689edd.8;
        Sun, 19 Dec 2021 10:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1FNf5UrcYVxutkZBZuhd7yu7j8GGoDvHt1ZSWYN6ub8=;
        b=S8EpS08QJqcal4tHd0hc0RyOF4G9ieSYyRCzUQa3U04LzI0tIPjqO8/QaWh4XkNK1b
         rOGUxZQ/7dxS8GwsPWKc1kl5h81miGpuZKZTffuTH5c6sxqwdxK6zNWsRWjrBWaHkdQp
         /I0r/hxZLQmeCkkzpf40ZRY/9X+ew8YwHdO4jW/uPwQZ/kpTHdlJpTEy/Gy9aun77e54
         2L05QRVSloIXRzvvk/rlb26p2PtbcCi57BSs+9UqO+qH5O7Te9EJ/wpSoFDT15UbHNvO
         YoMeNljH42Pj37EuvocPPsQzpDJ3RUA3P5WnO/erWezUVE3KKIV5uD/uNf75VDa14EXN
         0/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1FNf5UrcYVxutkZBZuhd7yu7j8GGoDvHt1ZSWYN6ub8=;
        b=fPS49lIfPpi66R1/3ZWRaaMKJHTloflXMhUIddsMPGZItkSGImKC36ACHpVJoVZNC2
         Ph04QuQPhr/uePCvXbwzoee8LEe4sUjobjRTzf0eAL+G4zkwXuj3lI4Fq7SGQu1t29z9
         x1fexM0K5jnRPCVWM9wPd3K9zL0xnapmeZWZCWOlZZye+5YrnoMOyP7w9fh0PM5nss4/
         EMYtGdDt6nPJH7OXQEAtcPlC1hmaUSbDvEJsox6KApBSLQ3XgEVTPbWIIUyl8bs1nVDz
         KRwjJemfb0JDeNfLc/gCc/q95PFHccAJRIwH8ubOJRbuBTw9P58I9trjpAaIe2JKveYW
         A7Yg==
X-Gm-Message-State: AOAM5326Vhz8q9O/cV8y4gA73ujdqLEmbEs4OpFCBSeRr42vzTjHRuxX
        m/PiZ67FaWw5EVd1i/IdjRwlECZ21fs=
X-Google-Smtp-Source: ABdhPJwJej9sc9JaUkMxRJnyTjaUV+2E81x8DMq008oSE7tyQJCcB3WX2KdHGflw14jJQws8/NCICA==
X-Received: by 2002:a17:906:9402:: with SMTP id q2mr10315106ejx.106.1639939270981;
        Sun, 19 Dec 2021 10:41:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id sd39sm1352297ejc.14.2021.12.19.10.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 10:41:10 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8b294ccb-28c2-57fb-3e1e-6ec8c55e410c@redhat.com>
Date:   Sun, 19 Dec 2021 19:41:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/7] KVM: x86: Retry page fault if MMU reload is pending
 and root has no sp
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-2-seanjc@google.com>
 <c94b3aec-981e-8557-ba29-0094b075b8e4@redhat.com>
 <YbN58FS67bEBOZZu@google.com>
 <8ab8833f-2a89-71ff-98da-2cfbb251736f@redhat.com>
 <YbOLRLEdfpl51QLS@google.com> <Ybo5nOu7/bVPhzCK@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ybo5nOu7/bVPhzCK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 19:53, Sean Christopherson wrote:
>>
>>> 2) a case that has been handled in the inefficient way forever.
>> I don't care about inefficiency, I'm worried about correctness.  It's extremely
>> unlikely this fixes a true bug in the legacy MMU, but there's also no real
>> downside to adding the check.
>>
>> Anyways, either way is fine.
> Ping, in case this dropped off your radar.  Regardless of how we fix this goof,
> it needs to get fixed in 5.16.

Something has happened to my home directory in the middle of tests 
running for this rc, and I can't really do anything about it until 
someone sees my ticket. :/  This is the Linux maintainer version of a 
dog eating my homework, I suppose.

Since there was another report of this, I'll just queue up this version 
and send it out.

Paolo
