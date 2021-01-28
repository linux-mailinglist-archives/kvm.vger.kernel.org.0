Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E0E30721B
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 09:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhA1Iyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 03:54:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232269AbhA1Ip3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 03:45:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611823391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hvtYOjdDfkZyk+lFGoUR0j8cdav/9WreRA8ZjtvAe/E=;
        b=aq11F+aKjJmltl/6mE+VbDfzDj0YYzA+eJOjBDpZMx5gy/9/aLBRg2h+c96/b26AZB8K23
        CAxDRw9WnW33CQbTSBi0M1d1ZeulxCYyxq5kGWtGMnJu7Vg1/tXJCoqgdklB28SWCvcFZ9
        sw7HyTkd0w8ASTOWTkOSXoKoxuPKkeg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-miG_sVzzOTqT_KuwPS3I_g-1; Thu, 28 Jan 2021 03:43:09 -0500
X-MC-Unique: miG_sVzzOTqT_KuwPS3I_g-1
Received: by mail-ed1-f72.google.com with SMTP id a24so2834480eda.14
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 00:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hvtYOjdDfkZyk+lFGoUR0j8cdav/9WreRA8ZjtvAe/E=;
        b=rePh36VyL8vKKKOr615HTuftdl+9J6BJrUqypRllos4fLAUY4fNegNooTeQ8DUfhYT
         1ABXccHU42P0cq8WLlGba84jIo78uoXeDtccbaI9q/P/yBNDOxh/uUrYESMDPSzQVuNh
         RG6hYIdK4NeyjbO4AqJtXYZ3Ph3i0D0W5Kd/KMY5Jq19lg4kIlvJssDodGrzjbHxjeLI
         QmVIxt+xm5v5z/ttN6QsT8PFbCiq5o86JDTejW0rTpmFWr5LtNNkNQXLB5GoS/I0E8/Z
         6n3lkyMtg8N52UNPOq3FkHEDwpNhYTYBHRb+E48P4Scfi3L5mmXs/H4utens8HyTNKlo
         dPyw==
X-Gm-Message-State: AOAM531k1Qz0XAHbiPRhd8DKvqdl3kU7dYZrCCdgEZxWkecGffZjztrv
        zUnbdTKx8k7OpqKR2OJJ52dv9iKHtUR9IAg08ScgzzviBroNNvEZt+zJF1xTBmaMcUbcjZCuMm4
        ZaxkuMopfRvkm
X-Received: by 2002:a17:906:d781:: with SMTP id pj1mr9602419ejb.329.1611823388329;
        Thu, 28 Jan 2021 00:43:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1a78u8FKvTZXcVbcIA+2MiZd1VLUiatKlWwSCjuWctKG+Uxffs2RgHxBspXvhfk93fwJVgg==
X-Received: by 2002:a17:906:d781:: with SMTP id pj1mr9602401ejb.329.1611823388180;
        Thu, 28 Jan 2021 00:43:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qk1sm1931282ejb.86.2021.01.28.00.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 00:43:07 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: fix CPUID entries returned by KVM_GET_CPUID2
 ioctl
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com.com>
References: <20210128024451.1816770-1-michael.roth@amd.com>
 <87a6st31c6.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <304bd6db-4c67-a4bd-3b79-74c0474edefa@redhat.com>
Date:   Thu, 28 Jan 2021 09:43:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87a6st31c6.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 09:36, Vitaly Kuznetsov wrote:
> This is embarrassing but I have a (possible) excuse: copy_to_user's
> argument is 'void *' so no warning was produced. Surprisingly, no test
> caught the breakage. Thanks for debugging and fixing!

So who writes the test:

- the author of the buggy patch

- the maintainer who failed to spot it

- the poor sod who fixed the issue

?

(Just kidding, it will of course be either me or a fourth person :)).

Paolo

