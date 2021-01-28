Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5204F3076AB
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 14:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhA1NDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 08:03:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231250AbhA1NDb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 08:03:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611838925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nBvfO0pJG5CW6SkjjFOYWgtGpflBhkmJYESt+YGWKBo=;
        b=IacHNXZtxMNVrUbPq2tdwlM1TeHRqb1vSrsNpBjmPf6at/tTqr2dixOIjBeY1NhmNRJoV4
        kdSgb2CTuS9qdlzrAnnX/vyWD49aCWDbJpkGzE0RnqGVBYNlAjgxIv11q4z7DjQ1IUCJgW
        bBoDbYSPBjZflRuhtom524TV4PFn6Rs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-b2XtWkdPNqq7BuybmGBG1A-1; Thu, 28 Jan 2021 08:02:02 -0500
X-MC-Unique: b2XtWkdPNqq7BuybmGBG1A-1
Received: by mail-ed1-f70.google.com with SMTP id r4so3132839eds.4
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 05:02:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nBvfO0pJG5CW6SkjjFOYWgtGpflBhkmJYESt+YGWKBo=;
        b=Xa2qe8iXiYBCMOYOd9qkp16CnxzGxW39lDWbii3pk12e2Qx7rELp4tvxR2U38KM4iP
         zEvQ2LpgKIDZ9daBD8GRcZJgMsBuY6LVyn44S4YoaI1FuF/mWcq4nSqhuxKOkkF5iVP8
         CRQtPr2t8OemzqYsqf2LCnGrRLzjllVv1xqFh8reemVjmpuTXMo6bCTyNRHheLp7M5QM
         DM2ucuRRhmpphWqY6rizXqwfj8stt/ehMMZlpNnzcWUViGYVCEZ5+Ay1OwTYJNKRfgon
         9uJrC81txKgcPSMotNKcInJOPgtxu5ixs5bAdfIUHmT9BNBDemyhnrNsAqeSJtBuAkO+
         bqQg==
X-Gm-Message-State: AOAM530c0mCHM9CVoflKWG5zOVNJSjGlU3L8deWwVUFZqhBD8vJ+CnC2
        iVFqoOdXgnwSRDG0TA7kU6zH05r7fxGpahBGRhW2t6kFZs1y9roM1Px+9WVrkP76Cuboih09DSA
        6EEb4S/+HISIA
X-Received: by 2002:a17:906:abd7:: with SMTP id kq23mr9264001ejb.292.1611838921119;
        Thu, 28 Jan 2021 05:02:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/c6AXVewiipZ2hRRD+V6ieXqc3J6x8OeuGPPacTELZqzyy1eAnfDrFD1Ou0XKXJN3PVxTAw==
X-Received: by 2002:a17:906:abd7:: with SMTP id kq23mr9263924ejb.292.1611838920188;
        Thu, 28 Jan 2021 05:02:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id pj11sm2217470ejb.58.2021.01.28.05.01.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 05:01:59 -0800 (PST)
Subject: Re: [PATCH 1/5] KVM: Make the maximum number of user memslots a
 per-VM thing
To:     "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
 <20210127175731.2020089-2-vkuznets@redhat.com>
 <09f96415-b32d-1073-0b4f-9c6e30d23b3a@oracle.com>
 <877dnx30vv.fsf@vitty.brq.redhat.com>
 <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34f76035-8749-e06b-2fb0-f30e295f6425@redhat.com>
Date:   Thu, 28 Jan 2021 14:01:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5b6ac6b4-3cc8-2dc3-cd8c-a4e322379409@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 11:48, Maciej S. Szmigiero wrote:
>>
>> VMMs (especially big ones like QEMU) are complex and e.g. each driver
>> can cause memory regions (-> memslots in KVM) to change. With this
>> feature it becomes possible to set a limit upfront (based on VM
>> configuration) so it'll be more obvious when it's hit.
>>
> 
> I see: it's a kind of a "big switch", so every VMM doesn't have to be
> modified or audited.
> Thanks for the explanation.

Not really, it's the opposite: the VMM needs to opt into a smaller 
number of memslots.

I don't know... I understand it would be defense in depth, however 
between dynamic allocation of memslots arrays and GFP_KERNEL_ACCOUNT, it 
seems to be a bit of a solution in search of a problem.  For now I 
applied patches 1-2-5.

Thanks,

Paolo

