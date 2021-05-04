Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7855337284C
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 11:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhEDJvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 05:51:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhEDJvU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 05:51:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620121825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLLNqsS9L3JlqB+77pJZObONKY2VG8iKD+gJcR3gPl0=;
        b=YCEOMXFZxZuPzLtV/h32fzuJLZfIDW5LGTkS7ez4eXNN6AHbostg9WBOjx0qSFNY3A8ytk
        n1OM0O77/MY0pw2m1zW/4YzjPDA44s3T9cA58QTJbt0CBNhYKyqEw/5o1Lachn8VDQg6PG
        n2jU/414Pu40PsNn9fgCia0CB35dJEY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-8JiQ36kNOGCy-TtEbnTXlw-1; Tue, 04 May 2021 05:50:23 -0400
X-MC-Unique: 8JiQ36kNOGCy-TtEbnTXlw-1
Received: by mail-ed1-f70.google.com with SMTP id f8-20020a0564020688b029038840895df2so6126561edy.17
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 02:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TLLNqsS9L3JlqB+77pJZObONKY2VG8iKD+gJcR3gPl0=;
        b=BGbHnS8Y8wMijJR3t2ozjuLEupE4klUio76rD6+j3H3k87rK/BOxPRYBG7tSfnJyzK
         IdafkfbS2ofVzrwYwHWTWx8wMOK/2OAOPNOS2AAKfWQufSxmBkzak3X5reSOtYlIAdP0
         DTHS5VxpIvo1Fq8LtEPZDGaDGAPlRsam0aRrOOrlf/pTIv7Y1uow8/hmWZ985tzC3Nnl
         8H7ax54gN++pkjmtfROTZtSVnOekQcb2WJur4rRtVz5ROUmJrXtxo+TTnm4xrRBN8Hvv
         DepsxxQeoD4sFGI7frqbSgV2mZzWq6DJ1/7DlJqGrdXZA4qkpDSAfGE62I62JQavqD6n
         Krxg==
X-Gm-Message-State: AOAM530jhon7afpIb/CeevXPHIAYwW+tRv5P934bw/3YboaVflHbQDP4
        3z6rE0kuZVv14prwrzFGkGWPrvJHFWSE/athUXXd1EzX4XFJRwgZKnSk0fSiCqVqoFJ6w2O4WuG
        EMZocVoQqa/zh
X-Received: by 2002:a17:906:c9d0:: with SMTP id hk16mr21511734ejb.512.1620121822623;
        Tue, 04 May 2021 02:50:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCJyldKGwnVeDHhwh86DCOqVryoCavSu5rceiCbCiFV+ZSms3HzvvVKa6Wa6wLmzON+hplHw==
X-Received: by 2002:a17:906:c9d0:: with SMTP id hk16mr21511719ejb.512.1620121822436;
        Tue, 04 May 2021 02:50:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v26sm1149040ejk.66.2021.05.04.02.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 02:50:21 -0700 (PDT)
Subject: Re: [PATCH v4] KVM: x86: Fix KVM_GET_CPUID2 ioctl to return cpuid
 entries count
To:     Alexander Graf <graf@amazon.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Sean Christopherson <seanjc@google.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20210428172729.3551-1-valeriy.vdovin@virtuozzo.com>
 <YIoFFl72VSeuhCRt@google.com>
 <0d68dbc3-8462-7763-fbad-f3b895fcf6e6@redhat.com>
 <be7eedf7-03a2-f998-079d-b18101b8b187@openvz.org>
 <63e54361-0018-ad3b-fb2b-e5dba6a0f221@redhat.com>
 <048b3f3a-379d-cff3-20b6-fc74dd12a98f@openvz.org>
 <514b5373-c07b-ad34-5fba-f8850faf6d68@redhat.com>
 <b4434730-9cd1-1d41-d012-f7beff7e351b@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2c097165-bb13-4b9f-64f9-3c6d88a648b4@redhat.com>
Date:   Tue, 4 May 2021 11:50:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <b4434730-9cd1-1d41-d012-f7beff7e351b@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 11:26, Alexander Graf wrote:
> 
> 
> On 04.05.21 10:21, Paolo Bonzini wrote:
>>
>> On 04/05/21 10:15, Denis V. Lunev wrote:
>>> As far as I understand only some testing within kernel now.
>>> Though we have plans to expose it for QAPI as the series
>>> in QEMU
>>>    [PATCH 1/2] qapi: fix error handling for x-vz-query-cpu-model-cpuid
>>>    [PATCH 2/2] qapi: blacklisted x-vz-query-cpu-model-cpuid in tests
>>> is not coming in a good way.
>>> The idea was to avoid manual code rework in QEMU and
>>> expose collected model at least for debug.
>>
>> KVM_GET_CPUID2 as a VM ioctl cannot expose the whole truth about CPUID
>> either, since it doesn't handle the TSX_CTRL_CPUID_CLEAR bit.  Given
>> that QEMU doesn't need KVM_GET_CPUID2; it only needs to save whatever it
>> passed to KVM_SET_CPUID2.
> 
> What if we instead deflect CPUID into user space so it can emulate it in 
> whatever way it likes? Is the performance difference going to be 
> relevant? Are people still using cpuid as barrier these days?

There's enough weirdness in CPUID (e.g. the magic redirection of unknown 
leaves to the highest Intel leaf) to make it relatively hard to 
implement correctly.  So I think it should remain in the kernel.

Paolo

