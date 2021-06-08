Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A783A39FDB6
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhFHRc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231840AbhFHRc4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 13:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623173463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TF/rgM77L/d/lAEQM9kap4CMSSjJDs34aSUsZ8Lqw00=;
        b=DCFOz/zz67WnbM4TiFLWgmxjsO+R8gkhoYzHHQGLEBl/w7rC7BuEkfJyvkqFghxIHPkh5+
        o29G2k698cCEmykm29PPioOQZHxJSWZulLuwiichcj3ScoMAhDKB55G94rX2n7gW+VsITp
        VXH0ARMw4jbiHmO1qbaN/9mJIPFonLw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-EymG11kVPHCMDYAikOcqtg-1; Tue, 08 Jun 2021 13:31:02 -0400
X-MC-Unique: EymG11kVPHCMDYAikOcqtg-1
Received: by mail-wr1-f71.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso9733688wrh.12
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 10:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TF/rgM77L/d/lAEQM9kap4CMSSjJDs34aSUsZ8Lqw00=;
        b=gmiQvS020K4e7UWLsnbzglDxRx1CVlkFRrZeI4ZuWRxg8iBdcs8+Nqj4aZsfSsN0k9
         ceUer0fphiO6xHkXhXNlsOcxgVSzJ/A1JIgB0hrnQadWFVQFY22nwy+WwK8+oKZp/WWq
         fepuS/ADyqIbcleD1g/qZlY+G0J16zf3iuGeTf0+lyaUvhcAV1oi5dwPn+HM/f2wSk5a
         FuTVjTkDuPsNC2Abyh34d9ZbembieGCQdamzrvRsNBCzVKYJh7LMEj5cPP7m7+JGuDMg
         iP7IXnFumBdb9Z+8tFxLveScPr4fK7N2HtCAhc3jYu5dqzdS5r+6zZTHE0ljWHh+GcN4
         3+ug==
X-Gm-Message-State: AOAM532MMta6oBzZM2+b+UM0UjiscX3aNmuK6r9dYTvCXR4r9VlEMes8
        h55mQEzS9jfIfr0EtWP/61vMNxrKRNZ0P4wgLlQzP9U4i9lJhPB/UJUjtKCTsOeoFaGZ8NyPRnp
        zSUY2qZ8Uptcp
X-Received: by 2002:a5d:47a5:: with SMTP id 5mr11742381wrb.259.1623173460821;
        Tue, 08 Jun 2021 10:31:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+hXpQkKsF/MtCk0rB04qnJ0G728xRvxcrbK0SQ7l7/wkfmJ3psnPl5j+OrSjI7gH0UMjC5A==
X-Received: by 2002:a5d:47a5:: with SMTP id 5mr11742365wrb.259.1623173460657;
        Tue, 08 Jun 2021 10:31:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a4sm18989559wme.45.2021.06.08.10.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 10:31:00 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Ensure liveliness of nested VM-Enter fail
 tracepoint message
To:     Steven Rostedt <rostedt@goodmis.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210607175748.674002-1-seanjc@google.com>
 <20210607144845.74a893d6@oasis.local.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <89ea681f-bbfc-422c-c654-d81b5e83a734@redhat.com>
Date:   Tue, 8 Jun 2021 19:30:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210607144845.74a893d6@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/21 20:48, Steven Rostedt wrote:
> On Mon,  7 Jun 2021 10:57:48 -0700
> Sean Christopherson <seanjc@google.com> wrote:
> 
>> Use the __string() machinery provided by the tracing subystem to make a
>> copy of the string literals consumed by the "nested VM-Enter failed"
>> tracepoint.  A complete copy is necessary to ensure that the tracepoint
>> can't outlive the data/memory it consumes and deference stale memory.
>>
>> Because the tracepoint itself is defined by kvm, if kvm-intel and/or
>> kvm-amd are built as modules, the memory holding the string literals
>> defined by the vendor modules will be freed when the module is unloaded,
>> whereas the tracepoint and its data in the ring buffer will live until
>> kvm is unloaded (or "indefinitely" if kvm is built-in).
>>
>> This bug has existed since the tracepoint was added, but was recently
>> exposed by a new check in tracing to detect exactly this type of bug.
>>
>>    fmt: '%s%s
>>    ' current_buffer: ' vmx_dirty_log_t-140127  [003] ....  kvm_nested_vmenter_failed: '
>>    WARNING: CPU: 3 PID: 140134 at kernel/trace/trace.c:3759 trace_check_vprintf+0x3be/0x3e0
>>    CPU: 3 PID: 140134 Comm: less Not tainted 5.13.0-rc1-ce2e73ce600a-req #184
>>    Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
>>    RIP: 0010:trace_check_vprintf+0x3be/0x3e0
>>    Code: <0f> 0b 44 8b 4c 24 1c e9 a9 fe ff ff c6 44 02 ff 00 49 8b 97 b0 20
>>    RSP: 0018:ffffa895cc37bcb0 EFLAGS: 00010282
>>    RAX: 0000000000000000 RBX: ffffa895cc37bd08 RCX: 0000000000000027
>>    RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff9766cfad74f8
>>    RBP: ffffffffc0a041d4 R08: ffff9766cfad74f0 R09: ffffa895cc37bad8
>>    R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffc0a041d4
>>    R13: ffffffffc0f4dba8 R14: 0000000000000000 R15: ffff976409f2c000
>>    FS:  00007f92fa200740(0000) GS:ffff9766cfac0000(0000) knlGS:0000000000000000
>>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>    CR2: 0000559bd11b0000 CR3: 000000019fbaa002 CR4: 00000000001726e0
>>    Call Trace:
>>     trace_event_printf+0x5e/0x80
>>     trace_raw_output_kvm_nested_vmenter_failed+0x3a/0x60 [kvm]
>>     print_trace_line+0x1dd/0x4e0
>>     s_show+0x45/0x150
>>     seq_read_iter+0x2d5/0x4c0
>>     seq_read+0x106/0x150
>>     vfs_read+0x98/0x180
>>     ksys_read+0x5f/0xe0
>>     do_syscall_64+0x40/0xb0
>>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Fixes: 380e0055bc7e ("KVM: nVMX: trace nested VM-Enter failures detected by H/W")
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> -- Steve
> 

Queued, thanks.

Paolo

