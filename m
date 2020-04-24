Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3C21B7B9E
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 18:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgDXQa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 12:30:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727031AbgDXQa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 12:30:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587745825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEnOw8ZF0dGRt/O1mfiDTUYS411MyNzBKC0AjVmnO9I=;
        b=gh8LifSRUpyNxbVe9d9e6xrG76UDWnCDjAnx9zejtiJlMj8FNtvvbwMaEWJ8RGZZCrEVe9
        Q1fV+SXnAY2dp4+cG9wbgx7vlY286U5TDqaYtK+cP7yEGW6tbgLlJCGdcQ7d/11AdOO89c
        42APHITlKv9Pusrba7ve1125Hdpmpv4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-U1q-tBSCNdCaM1uamqej5Q-1; Fri, 24 Apr 2020 12:30:23 -0400
X-MC-Unique: U1q-tBSCNdCaM1uamqej5Q-1
Received: by mail-wr1-f69.google.com with SMTP id r11so5033192wrx.21
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 09:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lEnOw8ZF0dGRt/O1mfiDTUYS411MyNzBKC0AjVmnO9I=;
        b=B0NOF1zJCbrk/7KSMRmooMQs2XX9d8r6WGo2u206W03LC0Irv79XdfAIF1IdjX9Ch0
         aS6T/qIJWMAbQa72bjev1QyPE+jOinKTm5CFle/26HJn6AvRTCVV0aWBc+LRHXQ4FIdk
         /t6P+245tnhh+iQZ3l8Wgq7h4U6jfl9KjcdUKShXM8aLjDg1QedZ6Fp1zWNTnVhxlg6n
         ar8ZHZcezOGdzNeB2yTw/sH85qahaTrkWBvboRHEebI8Jg+/C1pstQ4mM6zYqF4bGE1b
         03JdAFImQCUDBxXBRg0n3AOuJwJHr7CWK87ScXMatenFoTJ4sw3OUjbwiQhc7xNa3c2y
         06Hw==
X-Gm-Message-State: AGi0PuZ9JgpuC+NTIYqBoUVLFEOkuRtfrI8X4ZoVBdpOuRfmzfYytibE
        Yr40BNmhuiHr+A3HXGdZcMxgMYZps5oP2I/V7n/GqcGaWvggH03Y+fM2i8ZobnLt6aZ4Nj93Sy0
        OXhd0ih30ruvn
X-Received: by 2002:a1c:384:: with SMTP id 126mr11132861wmd.58.1587745821302;
        Fri, 24 Apr 2020 09:30:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypI5NdM9wUQZ0z948a+KAa0g9t1ym4JE3AZg1fAUjiERTIDRj8cTkPnrs2IYfdntnT5DXIT3Mg==
X-Received: by 2002:a1c:384:: with SMTP id 126mr11132840wmd.58.1587745821093;
        Fri, 24 Apr 2020 09:30:21 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id k14sm9205034wrp.53.2020.04.24.09.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 09:30:20 -0700 (PDT)
Subject: Re: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Li RongQing <lirongqing@baidu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
 <20200424144625.GB30013@linux.intel.com>
 <CALMp9eQtSrZMRQtxa_Z5WmjayWzJYhSrpNkQbqK5b7Ufxg-cMA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ce51d5f9-aa7b-233b-883d-802d9b00e090@redhat.com>
Date:   Fri, 24 Apr 2020 18:30:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQtSrZMRQtxa_Z5WmjayWzJYhSrpNkQbqK5b7Ufxg-cMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 18:25, Jim Mattson wrote:
>> Assuming we're going forward with this, at an absolute minimum the RDMSRs
>> need to be wrapped with checks on host _and_ guest support for the emulated
>> behavior.  Given the significant overhead, this might even be something
>> that should require an extra opt-in from userspace to enable.
> 
> I would like to see performance data before enabling this unconditionally.

I wouldn't want this to be enabled unconditionally anyway, because you
need to take into account live migration to and from processors that do
not have APERF/MPERF support.

Paolo

