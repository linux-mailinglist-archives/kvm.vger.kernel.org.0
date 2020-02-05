Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A3D153324
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgBEOhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:37:24 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41286 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726502AbgBEOhY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:37:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580913442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jWlvFwUdUv+RENWF5c/fy1loseX2NrAzZ8YGZViIh9Q=;
        b=RI5vEzj05qZnkO2l4eqCqofgo3acbjKUDhjkyBTPAA+uW2y/xtYdsp7m6HRlrAL/RiaVuM
        OIPC78r57yAjXLz1UNj21hsr5CVewDtwgrzapkHrrUI0t35mGDJjPugz+aK9md9tuiAX2X
        +fzOvNH4LlZecviyAog68vszI7gkp1Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-nyehGvLPOMGTjCrTDlWY8w-1; Wed, 05 Feb 2020 09:37:20 -0500
X-MC-Unique: nyehGvLPOMGTjCrTDlWY8w-1
Received: by mail-wr1-f69.google.com with SMTP id 50so1293740wrc.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:37:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jWlvFwUdUv+RENWF5c/fy1loseX2NrAzZ8YGZViIh9Q=;
        b=mRtlPIimkQdi7g7Qx1USg/CLsFvI8nvlK0EjObDmOsmO9t8XAMOKdMpiZ2L3T4ZAkW
         rMo26HTISeZ6yr30PAAvcCV/8dw7ntsVESzU5CES3Xqs8jRYWqdJgVRXc7EqCqssrbxX
         hRNOf1Xnz4z5tmdnIAgy0Wq16NJKZeetNSq8l4FWRYOYJBdWFOTVQ4+qTxfZrCxagBwW
         /sa/CqcC2fa0QWisC+Z2kLDJKeTC8MFfCxfkmhA/h6EgOn+2vNI2Zhyb5ubX5G3wJ1Xj
         HdTHP/w5vzEmi7Uyjehz4lEpU0OZJBf8Po/gMfJ432nCsR9Nsx2KYiEBCJKQkv2bZgrA
         MIBg==
X-Gm-Message-State: APjAAAWYWkP6DEvmvbdppTFnpUl62gAe0fZT57uA6WRRDC6KrrqtJqDR
        mNwB1STbf4s9l6k0Qv8UhL/TNtmqU1ZhXP6goH6AK3HYGnEh5mgvTDYSFfhVf7VytB9t50oFG3W
        OCBjT9ngJe/ZA
X-Received: by 2002:a5d:6144:: with SMTP id y4mr28122021wrt.367.1580913439820;
        Wed, 05 Feb 2020 06:37:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDnnQbP+VZROCaAZ6agojL2psHiA+jWmvjshHhDZUxQyLaSpAQAtfLUiTomj0vKySe4pbwqg==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr28122006wrt.367.1580913439652;
        Wed, 05 Feb 2020 06:37:19 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g128sm8208807wme.47.2020.02.05.06.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:37:19 -0800 (PST)
Subject: Re: [PATCH 2/3] kvm: mmu: Separate generating and setting mmio ptes
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ben Gardon <bgardon@google.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200203230911.39755-1-bgardon@google.com>
 <20200203230911.39755-2-bgardon@google.com>
 <87sgjpkve2.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a920cd0-530b-f380-a81a-da7cc6969f3e@redhat.com>
Date:   Wed, 5 Feb 2020 15:37:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87sgjpkve2.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/20 14:37, Vitaly Kuznetsov wrote:
>> +static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
>> +			   unsigned int access)
>> +{
>> +	u64 mask = make_mmio_spte(vcpu, gfn, access);
>> +	unsigned int gen = get_mmio_spte_generation(mask);
>> +
>> +	access = mask & ACC_ALL;
>> +
>>  	trace_mark_mmio_spte(sptep, gfn, access, gen);
> 'access' and 'gen' are only being used for tracing, would it rather make
> sense to rename&move it to the newly introduced make_mmio_spte()? Or do
> we actually need tracing for both?

You would have the same issue with sptep.

> Also, I dislike re-purposing function parameters.

Yes, "trace_mark_mmio_spte(sptep, gfn, mask & ACC_ALL, gen);" is
slightly better.

Paolo

