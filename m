Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7F3307BAF
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhA1RCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:02:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232741AbhA1RB2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:01:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611853201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UH9HnxwYQlcxwQzC5ROXxf5EX99BRvbyCUr9+YZW4as=;
        b=gvnefLh4bupiJTosBGXR08lE4iV+TiLRc11zMh4WTgg2KzeuQMnt0wj+0zbLMiXL0tcwF1
        95oDnALnwoDyont3OUu4al2j1O2M957t0PqWEVdihG4rWR3WSL+cSZUVuelizV+7T/QsgV
        lGzoQ5/p+CEy+T8scUrd8py955HJRxg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-MP2_X1xoOImB6kKkfSYcsA-1; Thu, 28 Jan 2021 11:59:59 -0500
X-MC-Unique: MP2_X1xoOImB6kKkfSYcsA-1
Received: by mail-ed1-f69.google.com with SMTP id u26so2563199edv.18
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 08:59:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UH9HnxwYQlcxwQzC5ROXxf5EX99BRvbyCUr9+YZW4as=;
        b=f2w3hpfngs0o4Z+O5TgTBVZpb8EdwnCCXgZl00NxcbMS6WR2NYNrluHo0xeUMwg7/5
         0zQTdONDt0PDe7IJUk/guYCUCSmvlKMz//6+qvoha9ZN8yRMFt8HqKbZRWov0tyzw4rF
         PHFXM7mgZUBTF4uopDVJtTx2yAdJwKJt48QsNTqLqJ7XJJukJnkBJJpgseRobfzj4rsw
         QcrZ2drJW2fYGe8ua2vFrW0Gifz5AapgXW3c1a4YlD4dBAukB447yhIu1NEhmRUHxekz
         nqg8pRw7yvd4CyLAVZdcnd9QDVqasj+UilANIw55dNCrMyU1LQ/7LjhaIfFvI1cXm6PA
         yXHA==
X-Gm-Message-State: AOAM532Dmm1NmFKy88DcjZuz8SzmpjZuFOqGodde03ZzwWCUP8LNuqdA
        jr5znK3lBhzoxaHFrC6j0/jXAv119drDyikBbNfAy16jvv0jGqaOut2dSnViA9dmjwbasPfXXE2
        SobJPkuR5omwN
X-Received: by 2002:a50:da8b:: with SMTP id q11mr523671edj.352.1611853197914;
        Thu, 28 Jan 2021 08:59:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCYYO4KxHvkD1ek7VplCvdhayWK50wgiLkiCy7nAAszHbgwT/+0cTT4+tdbopcJmj3Hq5WZg==
X-Received: by 2002:a50:da8b:: with SMTP id q11mr523655edj.352.1611853197771;
        Thu, 28 Jan 2021 08:59:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id fi12sm2576705ejb.49.2021.01.28.08.59.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 08:59:56 -0800 (PST)
Subject: Re: [PATCH v2 14/14] KVM: SVM: Skip SEV cache flush if no ASIDs have
 been used
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-15-seanjc@google.com>
 <55a63dfb-94a4-6ba2-31d1-c9b6830ff791@redhat.com>
 <YBLmareW9CB0Kcta@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47871650-ed98-4258-69c0-75d8a1a7f4e5@redhat.com>
Date:   Thu, 28 Jan 2021 17:59:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBLmareW9CB0Kcta@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 17:29, Sean Christopherson wrote:
> On Thu, Jan 28, 2021, Paolo Bonzini wrote:
>> I can't find 00/14 in my inbox, so: queued 1-3 and 6-14, thanks.
> 
> If it's not too late, v3 has a few tweaks that would be nice to have, as well as
> a new patch to remove the CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT dependency.
> 
> https://lkml.kernel.org/r/20210122202144.2756381-1-seanjc@google.com

Yes, will do (I had done all of them myself except the comment in 
sev_hardware_teardown() but it's better to match what was sent to LKML).

Paolo

