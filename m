Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185E51469FA
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAWNy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:54:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35897 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbgAWNy5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 08:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579787696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQ3Ow20PKV371NO5YgbOYBtfdI39/lSB5zP8TflCC5o=;
        b=a1VKldHNf7pTB6ZrBqiR0LLA9MgE5Vo7K1sa1fJEwuMc71Ikj/oGMGzxRhpyxTh34+oh1j
        54eESsSQgPD79YMCYB4lmVR2gGJJpum911uE4GhffzUSnt2LWr4m7KxWNzF4tmVkUBwDFd
        WjRKjspi1haJ5WnYtTlJAEi2gMDd06U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-H7KxbcA0OzGSBrV4q_BrrQ-1; Thu, 23 Jan 2020 08:54:52 -0500
X-MC-Unique: H7KxbcA0OzGSBrV4q_BrrQ-1
Received: by mail-wm1-f71.google.com with SMTP id s25so623917wmj.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 05:54:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RQ3Ow20PKV371NO5YgbOYBtfdI39/lSB5zP8TflCC5o=;
        b=ag4FIG3BigOfSNBNeLOY0DL2snaIkUD6RGv1n+uOljCNXws+dZ5aEDgvpS6S5rIdl5
         KPu6I2qxr2ubDyNDrXRXlD1PyHOf3g741RMb1FjwVdc18YS3Z4L0leJCIr2iwh/wybFJ
         jM7k6KqoXfGPX6bJvhI0LRMgsiYm84gXvKaZFEAYHayD+/26o3YF2bU9jnFdWdQ3J4u9
         qQsDcKlYfXQGNNeTPgZz24YKi3sCEzYiQHWn8BtlfpDtVe/ipBMY8LGSYCHfGpBP2KhK
         0fzMHXYoAMvtxWfJLVBYHk7z+glmMhtOlgEmlHzO/sanU+7bPnypWwb7fakiCT9QPy3r
         7DGg==
X-Gm-Message-State: APjAAAVziVlMaVpV8mFg8JLliq6CSP3zS/9fS/RHhWA+e3Eea0Iuf9iG
        djf8Qusux89nQexa7ntUKCMKnOwilANAVnn3zsymovhgh9GPFmVzuQU3fpToeSwZr3mClRu9jJv
        Qjsq7OLEGXUxb
X-Received: by 2002:a05:600c:224a:: with SMTP id a10mr4402301wmm.143.1579787691645;
        Thu, 23 Jan 2020 05:54:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKDd2Y0rsZeFLVbKo5pHH20OQcIqSfL1QyTrAtoWCMveHeMEIT2dWY+aPKw92HxHMLD6QraQ==
X-Received: by 2002:a05:600c:224a:: with SMTP id a10mr4402279wmm.143.1579787691407;
        Thu, 23 Jan 2020 05:54:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id k8sm3102469wrl.3.2020.01.23.05.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 05:54:50 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86: use raw clock values consistently
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     mtosatti@redhat.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
 <1579702953-24184-3-git-send-email-pbonzini@redhat.com>
 <87r1zqqode.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ed5b7a36-b9a0-5436-c704-58c65966b7c2@redhat.com>
Date:   Thu, 23 Jan 2020 14:54:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87r1zqqode.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 14:43, Vitaly Kuznetsov wrote:
>> +
>> +static s64 get_kvmclock_base_ns(void)
>> +{
>> +	/* Count up from boot time, but with the frequency of the raw clock.  */
>> +	return ktime_to_ns(ktime_add(ktime_get_raw(), pvclock_gtod_data.offs_boot));
>> +}
>> +#else
>> +static s64 get_kvmclock_base_ns(void)
>> +{
>> +	/* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
>> +	return ktime_get_boottime_ns();
>> +}
>>  #endif
> But we could've still used the RAW+offs_boot version, right? And this is
> just to basically preserve the existing behavior on !x86.

Yes, there's no reason to restrict the pvclock_gtod notifier to x86_64.
 But this is stable material so I kept it easy.

>>
>> -	getboottime64(&boot);
>> +	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
> 
> There are not that many hosts with more than 50 years uptime and likely
> none running Linux with live kernel patching support so I bet noone will
> ever see this overflowing, however, as wall_nsec is u64 and we're
> dealing with kvmclock here I'd suggest to add a WARN_ON().

You're off by a factor of 10, 2^64 nanoseconds are about 584 years
(584*365*10^9*86400). :)

Paolo

