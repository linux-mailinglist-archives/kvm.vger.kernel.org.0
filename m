Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD8B1B5FBF
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgDWPni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:43:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59675 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729282AbgDWPni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587656616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yaSfDwhy0WkP2x8l/xKsfypjnmxH9a+M8bRe06h89X0=;
        b=EC2rkmig9ikuTPUj/5SB5MusuT0efqVfBj3OOSkzoJ7aaJaCk3+IrK6WiRpIhYqNA0Zjw8
        ShKkWp3I1fhonlrLVslKtINkFl9Lk6qvJGb7saUqnV95dseH6lUBlsLzICjD9goEOBLarC
        emF3FUI57J88as4NtJc9UvYDQBEFOrQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-PZc8ULhfMvyai2oTH7VfBA-1; Thu, 23 Apr 2020 11:43:34 -0400
X-MC-Unique: PZc8ULhfMvyai2oTH7VfBA-1
Received: by mail-wm1-f69.google.com with SMTP id 72so4087370wmb.1
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 08:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yaSfDwhy0WkP2x8l/xKsfypjnmxH9a+M8bRe06h89X0=;
        b=CvDLpZjmru143+1VvTkVQuTkRE3biKboS9zpvhgPDMO4wQVrF96m0MQbQcwTzkBWu1
         vRTCsRHcwmLXq0ulZjq1IB6SYtavNNlCBA6iy2S1kSzNQIbCIVK7fj/TLfvOasqb5KeU
         Qa7KYFn7NJUfcXerfNCIkV60u8pUXe/bzlY0R8pcH6sl7zgRuaszDFLquZkTL/Ay3+zH
         IcB+zhl6aywRN5/bivOUUavxg+PlpUEmAeEH45JJphbJRXI9TChrZqNWHboVfi7oIB4S
         p9z/oKBQylvUPfKTgNbXKDpKaJbvdzHQAR70seK37dVfHo01QCgHw9j57PoIUeof3ii6
         A9Dg==
X-Gm-Message-State: AGi0PuYfu1g7FGx1n6iYKMscK/FDalkz4mSAEFsTuTxCT1lbNuRGztSm
        cXENaLfNFZi0GxZnnuwLMHeSXcr3bZ8/MsX6VbGnizCxgQh1jR+2ozDcO4eko7l5fm+ctZQHOg5
        ShjJCjQRIUZ9Z
X-Received: by 2002:adf:e5c8:: with SMTP id a8mr6090864wrn.56.1587656613727;
        Thu, 23 Apr 2020 08:43:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypLi2aeT+iCRoZnl2LY6pfEQsNNFK9xdNRsShgC3cQDvBg7qhvEgLDszJu8Ia3sgKnMcdHdlxA==
X-Received: by 2002:adf:e5c8:: with SMTP id a8mr6090832wrn.56.1587656613448;
        Thu, 23 Apr 2020 08:43:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f43b:97b2:4c89:7446? ([2001:b07:6468:f312:f43b:97b2:4c89:7446])
        by smtp.gmail.com with ESMTPSA id 17sm4119170wmo.2.2020.04.23.08.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 08:43:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com, wei.huang2@amd.com
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
 <20200423144209.GA17824@linux.intel.com>
 <ae2d4f5d-cb96-f63a-7742-a7f46ad0d1a8@redhat.com>
 <20200423153531.GC17824@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <793bf6ba-a21a-02cc-c80a-05a7af37b5b6@redhat.com>
Date:   Thu, 23 Apr 2020 17:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200423153531.GC17824@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 17:35, Sean Christopherson wrote:
> On Thu, Apr 23, 2020 at 05:10:45PM +0200, Paolo Bonzini wrote:
>> On 23/04/20 16:42, Sean Christopherson wrote:
>>> On Tue, Apr 14, 2020 at 04:11:07PM -0400, Cathy Avery wrote:
>>>> With NMI intercept moved to check_nested_events there is a race
>>>> condition where vcpu->arch.nmi_pending is set late causing
>>> How is nmi_pending set late?  The KVM_{G,S}ET_VCPU_EVENTS paths can't set
>>> it because the current KVM_RUN thread holds the mutex, and the only other
>>> call to process_nmi() is in the request path of vcpu_enter_guest, which has
>>> already executed.
>>>
>> I think the actual cause is priority inversion between NMI and
>> interrupts, because NMI is added last in patch 1.
> Ah, that makes more sense.  I stared/glared at this exact code for a long
> while and came to the conclusion that the "late" behavior was exclusive to
> interrupts, would have been a shame if all that glaring was for naught.
> 

Ah no, it's a bug in Cathy's patch and it's a weird one.

The problem is that on AMD you exit guest mode with the NMI latched and
GIF=0.  So check_nested_events should enable the NMI window in addition
to causing a vmexit.

So why does it work?  Because on AMD we don't have (yet)
nested_run_pending, so we just check if we already have a vmexit
scheduled and if so return -EBUSY.  The second call causes
inject_pending_event to return -EBUSY and thus go through KVM_REQ_EVENT
again, which enables the NMI window.

Paolo

