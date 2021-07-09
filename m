Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002DD3C21C7
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 11:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhGIJvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 05:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231864AbhGIJvs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Jul 2021 05:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625824144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+D6hL7BjwsO7nJv1l4mm1Wl5x0ozJbYKdRinib4pKM=;
        b=idAc4YW2fCUsrinFCESnRbLydoF78/s6YDn/flGNX1rPnenBMyPCB+am3ua86q6heUeN3t
        26Z53mzidp66sr1qVHv4CFRH1c9MRgmXb9KSyMUwvD/uY8kPv08eGXagVbkGftHM7+OpRi
        Tmac08Jd9nfC4pG238SgfDnFp36lDUs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-l3hU7si5MsKuAPvnuFwHhw-1; Fri, 09 Jul 2021 05:49:04 -0400
X-MC-Unique: l3hU7si5MsKuAPvnuFwHhw-1
Received: by mail-ed1-f72.google.com with SMTP id p19-20020aa7c4d30000b0290394bdda6d9cso4904308edr.21
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 02:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r+D6hL7BjwsO7nJv1l4mm1Wl5x0ozJbYKdRinib4pKM=;
        b=VtXLT2Hco3R5nHqCFYcq8/6IEl+B3ZOLIiJGTU6EXLPmD5o/z/0GFoFrs2L4qrLVnW
         Fs8XaY7WcokWxbYQJw4plpgTvxi+pqPwlay7l4Oh0u/zIDty6PE7UhNFLkZtOUF+dM/w
         SxnYVlYYiepLHguf8aG4YffWizyLdh4gX/ZRCE9V+B0ilmJRD3lXWX+ZEOET3Jh3batw
         Ldg+P6W4nHEkq03x5bWjFEDbiQOo9GhMiy9bFGyiHaqZRkHs4cnzhgDpX/W0lz0QrBg2
         6b4QggvBN9Xa+puD2M5QpLq0H/bS73oEQ46YzdTE7OuR61qcnwImkWn7OJXVwwi6RBAr
         wtJw==
X-Gm-Message-State: AOAM531XBgcf7Qm7ES5IRGYcfcFw2iNgJYG7zNkPxifpwqyiVqiQeePW
        PnCmoZwR65vqfJQhQvXT2sxrLSKpOTGiFR1hmiGdxYT97C891RBh/RtmaJUn315PqXMoeZN/bzT
        AybobzAjm7ylrFyryDAE8xpQH9kCYVhghtAoXW1NwKtLEsfFsXgjYvtnhbJowVcAF
X-Received: by 2002:a17:906:2dc9:: with SMTP id h9mr15124226eji.345.1625824142501;
        Fri, 09 Jul 2021 02:49:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMcoC8cVvcnlK0RHTXW2IGSwfoURzhJYFm4mvBzybLVkAzWqqjCuLOjxrWtnFKgsIJ95FmAg==
X-Received: by 2002:a17:906:2dc9:: with SMTP id h9mr15124188eji.345.1625824142287;
        Fri, 09 Jul 2021 02:49:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm2111880ejk.97.2021.07.09.02.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 02:49:01 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Also reload the debug registers before
 kvm_x86->run() when the host is using them
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210628172632.81029-1-jiangshanlai@gmail.com>
 <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com>
 <c79d0167-7034-ebe2-97b7-58354d81323d@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <397a448e-ffa7-3bea-af86-e92fbb273a07@redhat.com>
Date:   Fri, 9 Jul 2021 11:49:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c79d0167-7034-ebe2-97b7-58354d81323d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/21 05:09, Lai Jiangshan wrote:
> I just noticed that emulation.c fails to emulate with DBn.
> Is there any problem around it?

Just what you said, it's not easy and the needs are limited.  I 
implemented kvm_vcpu_check_breakpoint because I was interested in using 
hardware breakpoints from gdb, even with unrestricted_guest=0 and 
invalid guest state, but that's it.

Paolo

> For code breakpoint, if the instruction didn't cause vm-exit,
> (for example, the 2nd instruction when kvm emulates instructions
> back to back) emulation.c fails to emulate with DBn.
> 
> For code breakpoint, if the instruction just caused vm-exit.
> It is difficult to analyze this case due to the complex priorities
> between vectored events and fault-like vm-exit.
> Anyway, if it is an instruction that vm-exit has priority over #DB,
> emulation.c fails to emulate with DBn.
> 
> For data breakpoint, a #DB must be delivered to guest or to VMM (when
> guest-debug) after the instruction. But emulation.c doesn't do so.
> 
> And the existence of both of effective DBn (guest debug) and guest DBn
> complicates the problem when we try to emulate them.

