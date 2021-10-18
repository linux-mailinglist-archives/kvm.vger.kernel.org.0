Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B88E14326EF
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhJRS5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 14:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbhJRS5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 14:57:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9D3C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:55:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id om14so12847264pjb.5
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rTz4/jSlZyWfMiUVRUtwP9A0tGQp4FA6poWnsUXfMHA=;
        b=CEhc+C5496SCcB7LYMGxZjGtaERzZ4R2ccnZHKvtXOyopB5S+0HHTYdOo+tWIIg2iT
         NN1xps6KFuH5RyJbGEsIJfYD2HW3tPYgd6UbvQNZwFIgV9vfAP8GwQYAbQg/2wV6qCzk
         XWOO105ohb0X6U0o8aLOKMmbzYwx8ftO9RNh/xI2N+q0LCr5MPw0KSDBAz9aDIBfr0Fl
         8qmBWSo0o0KFCvChhU6hUTA4dyQ9+xuxqWzXDcGt0z5vYxkETtSjfGqbwH79DOAo8FhJ
         vc9/kYMLFJ+s3XM+kW/7KvcB99e9vw8CB8QYEqtBvE2aTBmv0RlYzYhvXZTNgXTvOfW8
         rvLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rTz4/jSlZyWfMiUVRUtwP9A0tGQp4FA6poWnsUXfMHA=;
        b=wfO+r6WKLy0JoB5BwI5c9yvUyF0LjWTgf4ndayo+a9CvVJNXxZmql+i3ELZwXhKflS
         yM7ppVtjGMMSUGJAMll1ha1mOXFOBdgK1eckCnb9F5bEBqMHYao73P0RQt2fs0deUWMx
         00lRPOFSttOwiOMgNy8i4YA0Nka80McF5pjRCWYpZ5PCxKS252/povRhg86/DrkVQWQr
         VWGa+uc2Mzf7rIrY+PV9Y1Q5hMsw9xjdblYXzdD25aCrDFqjqX+1km5sCrGXHGz6xB6u
         V1NtpiEkSAPV1WoC2zlfqYLu+qD1GLj/0/4RpVrOvz0MXvs9LeK1uDqguXNoGFiKbuAw
         Ur2Q==
X-Gm-Message-State: AOAM530OzQVPdQzPdmXFw150spC9P2gH3ySofezv+MHxqxfgRxyevFoK
        6mmBxMjgayDWghjBIp7F6BpbheBoWS1vew==
X-Google-Smtp-Source: ABdhPJwJQJu627dlVrOH5wynQWLhuXR+WqwkeeMR7RP5+UOted17dBdV92yQ+rWtCJjxbvlXaC1ZbQ==
X-Received: by 2002:a17:90a:f0d6:: with SMTP id fa22mr759328pjb.53.1634583330198;
        Mon, 18 Oct 2021 11:55:30 -0700 (PDT)
Received: from ?IPv6:2601:646:8200:baf:7db8:b64e:3a03:8df? ([2601:646:8200:baf:7db8:b64e:3a03:8df])
        by smtp.gmail.com with ESMTPSA id b130sm14468948pfb.9.2021.10.18.11.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:55:29 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: mmu: Make NX huge page recovery period
 configurable
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, bgardon@google.com,
        dmatlack@google.com
References: <20211016005052.3820023-1-junaids@google.com>
 <f513e90b-8eed-53ef-6c80-e588f1260e18@redhat.com>
From:   Junaid Shahid <junaids@google.com>
Message-ID: <0a192000-23bf-2021-1714-96fc7104ad95@google.com>
Date:   Mon, 18 Oct 2021 11:55:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f513e90b-8eed-53ef-6c80-e588f1260e18@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/16/21 12:00 AM, Paolo Bonzini wrote:
> On 16/10/21 02:50, Junaid Shahid wrote:
>> Currently, the NX huge page recovery thread wakes up every minute and
>> zaps 1/nx_huge_pages_recovery_ratio of the total number of split NX
>> huge pages at a time. This is intended to ensure that only a
>> relatively small number of pages get zapped at a time. But for very
>> large VMs (or more specifically, VMs with a large number of
>> executable pages), a period of 1 minute could still result in this
>> number being too high (unless the ratio is changed significantly,
>> but that can result in split pages lingering on for too long).
>>
>> This change makes the period configurable instead of fixing it at
>> 1 minute (though that is still kept as the default). Users of
>> large VMs can then adjust both the ratio and the period together to
>> reduce the number of pages zapped at one time while still
>> maintaining the same overall duration for cycling through the
>> entire list (e.g. the period could be set to 1 second and the ratio
>> to 3600 to maintain the overall cycling period of 1 hour).
> 
> The patch itself looks good, but perhaps the default (corresponding to a period of 0) could be 3600000 / ratio, so that it's enough to adjust the ratio?
> 
> Paolo
> 

Sure, that sounds good. I'll send an updated version.

Thanks,
Junaid
