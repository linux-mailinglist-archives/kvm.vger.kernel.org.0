Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041E72EE76A
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 22:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbhAGVHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 16:07:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbhAGVHA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 16:07:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610053534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dIdzS01a8gJ0BSbSt0S8IGEZ5+kBms8lbRwvPKGFMig=;
        b=YF8A+N6yXBgPHiD4Qd1tQfp2+gLjIg8loHIZaueoZqFg7laaTq5B4oto9KosbTzq2NR2tF
        KCruuskp5V1vA2JZcJX1LcGtRAah/S+DJ6blv8RQ1nbeLuHH9zBbTCpsHeXXXZqU2R9d6n
        AqM64o0Et8HTtQyIxi4jFdJ4JDIesBM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-bham6m8FNsWevgFe_Z1rhA-1; Thu, 07 Jan 2021 16:05:32 -0500
X-MC-Unique: bham6m8FNsWevgFe_Z1rhA-1
Received: by mail-ed1-f69.google.com with SMTP id g14so3785236edt.12
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 13:05:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIdzS01a8gJ0BSbSt0S8IGEZ5+kBms8lbRwvPKGFMig=;
        b=MAOtUC9mM0cvfoZ5xNjjqUwydC+MAq7Bpye05Lezd+bkByD4GVd5PdwZxM7+oWF+Mn
         UPeR2+MjYwQOwmblx9VeTyw7GqsnFBB4rDMqjK904TBqBfypr4PQZpDY4A0E71W3OL+k
         64PlhSoLwn0p10THlHXSInDS9NcB6VqxumbZtHlD/wszh1n/x3aSMgIt7r0vYYaYuj4t
         Bx84Crp9WiKuZ4hZBwDjWR85Gt1xRXUXvFNyqvyJAPTnlTh9a1s0V/yEEDbVIwR4udRw
         uuY3DBzZYGqWfsA9Uj0rE7I1JQWZWjr5U2Z2sc8wJREaFM/xdzPhaN/Fr3tUr5ZZo2Y6
         ogtw==
X-Gm-Message-State: AOAM5310ePwXPyk441FM3Wwwk1hPgqmL3KZfuoeQ3pBKq6Zx9jks8/ZY
        XoBkkUmpAdv7kVKKTTt3ZdN7PV/IJVObBHcI5oumrCGODsegQGy5mHxEte+kNk2IwTzE3Hedk7c
        mMfPzZeKeEinZ
X-Received: by 2002:a05:6402:366:: with SMTP id s6mr2968561edw.44.1610053531392;
        Thu, 07 Jan 2021 13:05:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxD6r7qM/y/nJixYthNZKTD1TNM3xO9CPOLbUoLYL0SZ0n9WyQfrM+H7t/SdIyQf4XnL2cLTw==
X-Received: by 2002:a05:6402:366:: with SMTP id s6mr2968544edw.44.1610053531240;
        Thu, 07 Jan 2021 13:05:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f11sm2840573ejd.40.2021.01.07.13.05.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 13:05:30 -0800 (PST)
Subject: Re: [PATCH v2 2/4] KVM: nSVM: correctly restore nested_run_pending on
 migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
 <20210107093854.882483-3-mlevitsk@redhat.com>
 <98f35e0a-d82b-cac0-b267-00fcba00c185@redhat.com>
 <X/ds0sUw/me4e/g1@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2885afd8-7f1f-f797-ce05-a85550039dc5@redhat.com>
Date:   Thu, 7 Jan 2021 22:05:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/ds0sUw/me4e/g1@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/01/21 21:19, Sean Christopherson wrote:
>> That said, the v1 change had some appeal to it.
> 
> Which v1 change are you referring to?

Moving the to-be-injected event from eventinj to vcpu->arch, and from 
there to vmcb02 on the next vmentry's inject_pending_event.

>> In the VMX case (if properly implemented) it would allow removing the weird
>> nested_run_pending case from prepare_vmcs02_early.  I think it's a valuable
>> invariant that there are no events in the VMCS after each KVM_RUN iteration,
>> and this special case is breaking the invariant.
>
> Hmm, as weird as that code is, I think it's actually the most architecturally
> correct behavior.

I was referring to the "then" branch therein. :)

Paolo

