Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FC511A671
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 10:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfLKJFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 04:05:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726988AbfLKJFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 04:05:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576055133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PenXlg+BC3zbnqNl3XULuIWWyu7R9w15XW00KbpnuWU=;
        b=UoeO61fdvoqPK+NfieeiO8B2OsRV+JH5SoBKeBXg6eF/pkYTxCmGgLPCnAqAoYeiwXbwIV
        n+pmx1Tl68JUG2MR2DH19a3qfjaEKkisEfPhRhEvZ50eNtuCdnTWPmJkQetCOvmRkX2rNR
        d51C5sl3eL9sNz/6w6PIP5UsmaJ6knA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-X476Z32bMbm1fOTqBofzPw-1; Wed, 11 Dec 2019 04:05:32 -0500
Received: by mail-wm1-f69.google.com with SMTP id o205so2132968wmo.5
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 01:05:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PenXlg+BC3zbnqNl3XULuIWWyu7R9w15XW00KbpnuWU=;
        b=XNUGAggHKwyTaed6vMRq8YjFbcYKUfjcRrLMQGtFt/YGpZaKuRU+rX3P98XBqo+Xk4
         O28N75E6hm/2mF4BKyIeKHIo1aBH/Jha8x9m2DkY4/sQjUfmYYAo2HGpoWVZA0nxF7y5
         UMegUdieb1fOn+Tf5QZVoJlnyCC8T+pXZFF4qWoFOzn3HAOETrosuWp5EdZykBcyXXnW
         2sUvLM+7HFlaGcnIMurNhedvcFX/PWiBBZTNLaAUUubKpTursrfxiOy+HMxmDKP60ouI
         vU4+B4t0+9LkgIreL4gXMH3zMZK/2BSxgTnvESw0vyzPGnlMlb9HzgzXkUFmMs7rYbgQ
         f/0A==
X-Gm-Message-State: APjAAAVyMqWw2E7SRCaEf/F/QA7nSMUmmHJhRyHq9wv4ExOyEpsVCPqx
        7nTHP4Uauz8dMS+f1ImdE1mxrF8EYQArq/u2PQAWMULpYhCT50vuNKwEEYY6hluRs4/GvPUY4++
        P8DtOkHIxx+Hn
X-Received: by 2002:a1c:9e58:: with SMTP id h85mr2336505wme.77.1576055130959;
        Wed, 11 Dec 2019 01:05:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqzJswQMpAiJ3AaINMEQKXGXjrGFZxuu0EXkQGiD96eH1Lvt/2POIUge3oCgHe+0Q+Koq339fA==
X-Received: by 2002:a1c:9e58:: with SMTP id h85mr2336471wme.77.1576055130639;
        Wed, 11 Dec 2019 01:05:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id u18sm1479960wrt.26.2019.12.11.01.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 01:05:29 -0800 (PST)
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
To:     "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <1355422f-ab62-9dc3-2b48-71a6e221786b@redhat.com>
 <a3e83e6b-4bfa-3a6b-4b43-5dd451e03254@redhat.com>
 <20191210081958-mutt-send-email-mst@kernel.org>
 <8843d1c8-1c87-e789-9930-77e052bf72f9@redhat.com>
 <20191210160211.GE3352@xz-x1> <20191210164908-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1597a424-9f62-824b-5308-c9622127d658@redhat.com>
Date:   Wed, 11 Dec 2019 10:05:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191210164908-mutt-send-email-mst@kernel.org>
Content-Language: en-US
X-MC-Unique: X476Z32bMbm1fOTqBofzPw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/19 22:53, Michael S. Tsirkin wrote:
> On Tue, Dec 10, 2019 at 11:02:11AM -0500, Peter Xu wrote:
>> On Tue, Dec 10, 2019 at 02:31:54PM +0100, Paolo Bonzini wrote:
>>> On 10/12/19 14:25, Michael S. Tsirkin wrote:
>>>>> There is no new infrastructure to track the dirty pages---it's just a
>>>>> different way to pass them to userspace.
>>>> Did you guys consider using one of the virtio ring formats?
>>>> Maybe reusing vhost code?
>>>
>>> There are no used/available entries here, it's unidirectional
>>> (kernel->user).
>>
>> Agreed.  Vring could be an overkill IMHO (the whole dirty_ring.c is
>> 100+ LOC only).
> 
> I guess you don't do polling/ event suppression and other tricks that
> virtio came up with for speed then?

There are no interrupts either, so no need for event suppression.  You
have vmexits when the ring gets full (and that needs to be synchronous),
but apart from that the migration thread will poll the rings once when
it needs to send more pages.

Paolo

