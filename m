Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF12939E6DA
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 20:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhFGSuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 14:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhFGSuy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 14:50:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B47996108C;
        Mon,  7 Jun 2021 18:49:01 +0000 (UTC)
Date:   Mon, 7 Jun 2021 14:48:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Ensure liveliness of nested VM-Enter fail
 tracepoint message
Message-ID: <20210607144845.74a893d6@oasis.local.home>
In-Reply-To: <20210607175748.674002-1-seanjc@google.com>
References: <20210607175748.674002-1-seanjc@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Jun 2021 10:57:48 -0700
Sean Christopherson <seanjc@google.com> wrote:

> Use the __string() machinery provided by the tracing subystem to make a
> copy of the string literals consumed by the "nested VM-Enter failed"
> tracepoint.  A complete copy is necessary to ensure that the tracepoint
> can't outlive the data/memory it consumes and deference stale memory.
> 
> Because the tracepoint itself is defined by kvm, if kvm-intel and/or
> kvm-amd are built as modules, the memory holding the string literals
> defined by the vendor modules will be freed when the module is unloaded,
> whereas the tracepoint and its data in the ring buffer will live until
> kvm is unloaded (or "indefinitely" if kvm is built-in).
> 
> This bug has existed since the tracepoint was added, but was recently
> exposed by a new check in tracing to detect exactly this type of bug.
> 
>   fmt: '%s%s
>   ' current_buffer: ' vmx_dirty_log_t-140127  [003] ....  kvm_nested_vmenter_failed: '
>   WARNING: CPU: 3 PID: 140134 at kernel/trace/trace.c:3759 trace_check_vprintf+0x3be/0x3e0
>   CPU: 3 PID: 140134 Comm: less Not tainted 5.13.0-rc1-ce2e73ce600a-req #184
>   Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
>   RIP: 0010:trace_check_vprintf+0x3be/0x3e0
>   Code: <0f> 0b 44 8b 4c 24 1c e9 a9 fe ff ff c6 44 02 ff 00 49 8b 97 b0 20
>   RSP: 0018:ffffa895cc37bcb0 EFLAGS: 00010282
>   RAX: 0000000000000000 RBX: ffffa895cc37bd08 RCX: 0000000000000027
>   RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff9766cfad74f8
>   RBP: ffffffffc0a041d4 R08: ffff9766cfad74f0 R09: ffffa895cc37bad8
>   R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffc0a041d4
>   R13: ffffffffc0f4dba8 R14: 0000000000000000 R15: ffff976409f2c000
>   FS:  00007f92fa200740(0000) GS:ffff9766cfac0000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000559bd11b0000 CR3: 000000019fbaa002 CR4: 00000000001726e0
>   Call Trace:
>    trace_event_printf+0x5e/0x80
>    trace_raw_output_kvm_nested_vmenter_failed+0x3a/0x60 [kvm]
>    print_trace_line+0x1dd/0x4e0
>    s_show+0x45/0x150
>    seq_read_iter+0x2d5/0x4c0
>    seq_read+0x106/0x150
>    vfs_read+0x98/0x180
>    ksys_read+0x5f/0xe0
>    do_syscall_64+0x40/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Fixes: 380e0055bc7e ("KVM: nVMX: trace nested VM-Enter failures detected by H/W")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve
