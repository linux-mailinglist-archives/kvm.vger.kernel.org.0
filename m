Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601BD4712DA
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 09:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhLKIWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 03:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhLKIWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 03:22:19 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA52AC061751;
        Sat, 11 Dec 2021 00:22:18 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id e3so37399536edu.4;
        Sat, 11 Dec 2021 00:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5kEcZxkBXlWefk5sypVc8zvnb+Y3Uf9P6j2F6q18Als=;
        b=CEdX4vSeEr3TaiJyStU4U2YGWcRgKqOCkzz2AN2/kPKLEoO0H8z12D1Mjt3zS9RQxr
         xKT87Jl3Z1Ve0e8QqOESz96xWOf3ZG9CNj10KZ7EoRUJ581VzK3f9Fyb3O17tPO6EUc6
         BXGIm9vmSWAr12CPQhY5r64TJ5NwysvMwY8KPX9QviGllStB8hqqIugzD29KGxkbCxof
         3gfoBN83GTd3ZKVRCY88AXqykJrRmvps3Zy3ok1RrU8trk7HKiMmZ9sw9QLkRLDIkX23
         TKKHU31dEQyFkJcThANukdsCEU+jfzgRIcRYfpkouEjY/VreUhyyCIAyC/G/prOGpKSv
         AJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5kEcZxkBXlWefk5sypVc8zvnb+Y3Uf9P6j2F6q18Als=;
        b=7/t8/8mGilx9eSsSpv11tsr3iejSf3mIVwPhgyGIOXmVeuGtwUUGSqdMUsvUTBCrRE
         H0WZizmABUoyq3pG7H/nUNoRRJwwJtvjVoXe5lLHjYEwVItgZTywpSniq70XBIBm+fhF
         h6aZXLXLbIwT/ec4QBmH6qlfGlXAoNWMXpbw99KAlAi3/04ImGScp0i+mqF6sn49djUM
         mpX7M8EafNfeUEmsnW1x89wgS9bvTUu066NKxUhneHKXy02AN/A4Q7zkWuQf5p1e9WVl
         7wGWq2FoPWqcKriyuMnFV1DVdEr4H2AYa+7Npdez9Vjt7mji72yDNwFB7qD06AYJH926
         s5AA==
X-Gm-Message-State: AOAM53065eu05XY4p84Cc7+E7yJ4ortGStUfwJSOoB7KWFWs0jzZNDVD
        qZcWrKUYRrSyjXk2b8cMlzHPUzzuAqAGEA==
X-Google-Smtp-Source: ABdhPJyUXSSeb2vgponB2mBfQznJjlZCp+iEDtjqo3JMKjhZZY+B/C/QwBu5mWnU4Sbeg0ykknjb5g==
X-Received: by 2002:a17:907:2da2:: with SMTP id gt34mr27760282ejc.372.1639210937454;
        Sat, 11 Dec 2021 00:22:17 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id eg8sm2649455edb.75.2021.12.11.00.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 00:22:16 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <56281d07-de85-69be-8855-71e7219e0227@redhat.com>
Date:   Sat, 11 Dec 2021 09:22:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com> <Ya/5MOYef4L4UUAb@google.com>
 <11219bdb-669c-cf6f-2a70-f4e5f909a2ad@redhat.com>
 <YbPBjdAz1GQGr8DT@google.com>
 <42701fedbe10acf164ec56818b941061be6ffd4e.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <42701fedbe10acf164ec56818b941061be6ffd4e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/21 07:56, Maxim Levitsky wrote:
>> This apparently wasn't validated against a simple use case, let
>> alone against things like migration with nested VMs, multliple L2s,
>> etc...
> 
> I did validate the *SREGS2* against all the cases I could (like
> migration, EPT/NPT disabled/etc. I even started testing SMM to see
> how it affects PDPTRs, and patched seabios to use PAE paging. I still
> could have missed something.

Don't worry, I think Sean was talking about patch 16 and specifically
digging at me (who deserved it completely).

Paolo
