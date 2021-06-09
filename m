Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62E73A0C34
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 08:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhFIGMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 02:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhFIGMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 02:12:40 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B17C061574;
        Tue,  8 Jun 2021 23:10:46 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so18457274oth.9;
        Tue, 08 Jun 2021 23:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hh/nvBaoFp4g+4qW/m5ZTP8/QZDvTeA+6OvdGD5FDhY=;
        b=vfT4hDQnOTkBFLAOo8bpoI89MerFnRRLclvS5VA86uBlduSqll+l/op3sUQDc/pasU
         pKOxBF+cIpSw5uLIHe6Sdu4r4YYYosup7UnZMxLHzXk7oz++iG+qNecXajDshD2HUlEF
         iWQje5zS/3q3rqeEif+swMcjlk1GWi5em+WkE+L0xWT3YEneKFxrUWFIXTde+xLFmhN/
         9RVI6nURpiId0yE+riJpLnny6cj9LjTLrBfI3iR/gB5Cfxqc0fzqBF9Z+CM758ZBd3Cn
         oirHcub2V+9tWb15iOBo5bhaWFO+8e8Y8JTcxKYDpKLsQEoW9xelMXOe3GJGg/Pdn3U3
         1Vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hh/nvBaoFp4g+4qW/m5ZTP8/QZDvTeA+6OvdGD5FDhY=;
        b=iaW1YPLizRX/MyUGXne16SdCL168h5dL6U5nZI9TE4M6I3KpFczgcOsSsOfB65HwXm
         pkO162qWAX5Llpvg8Etqj+3gUmeRChVauzTgQwfecLxP4BosrpI8HZ+c6EV6eXEJUoBW
         o+C72ie6Gr8pVmeDU5P6o6guUBvs6Km7YRsgkkXXF9WprHqIT5NgWVRsSp9TKpvr/+qd
         5S2IzdSYHJDQFLkxTMvp7K6ibdUoqE4+mA9N3g5VyqBn/WyFWB1gckh+bmOPdF9RmmJe
         bY50/MxhDDGpV2daVPZE0VwrtsLxZrRhW4xRuXVtGz1QQ1hEMO03C9/QRWo+4Vv/+6fp
         5Nzg==
X-Gm-Message-State: AOAM533gpAXu+1wujeVHxpn/vB+ueNsc1VLrPo9Za0w6GLOhMnQQAOFf
        ywnZXnd8M3NToelK37NexbHn500Z0w+SsrPgxT0=
X-Google-Smtp-Source: ABdhPJxvbmBbKs4XWDwEiGUGSmVf+THlYIHcLowwenJhspeAn/E0N5PPTD4JiZeNaGFIdz8xLPLv2/Ct+ABym0ThWmc=
X-Received: by 2002:a9d:2c9:: with SMTP id 67mr3555030otl.56.1623219045797;
 Tue, 08 Jun 2021 23:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210607175748.674002-1-seanjc@google.com>
In-Reply-To: <20210607175748.674002-1-seanjc@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Jun 2021 14:10:34 +0800
Message-ID: <CANRm+CxWovvM187BKtuvS1_WWnSdKc6wFA5swF-sJPJqYSWnUg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Ensure liveliness of nested VM-Enter fail
 tracepoint message
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Jun 2021 at 02:00, Sean Christopherson <seanjc@google.com> wrote:
>
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

I can observe tons of other kvm tracepoints warning like this after
commit 9a6944fee68e25 (tracing: Add a verifier to check string
pointers for trace events), just echo 1 >
/sys/kernel/tracing/events/kvm/enable and boot a linux guest.

    Wanpeng
