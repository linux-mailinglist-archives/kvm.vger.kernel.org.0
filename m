Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983343A1A9F
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 18:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbhFIQO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 12:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhFIQO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 12:14:57 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D0EC06175F
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 09:12:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k15so18738453pfp.6
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 09:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B80WuFTp3m8SwecqT3IfJ//IoK5UJC0lbvLHibfCmx8=;
        b=FWVZCG644MLckCLl4nD1KJzI72GQEbRGPhQm6FEHnfs/bflCedBZIU/WTxM6oDPOkt
         98dy/fmo83KtIU4f4k6lfCKV73LxZP4D3hl/mx3tEcyZEMl3jyXhvUJkO+Lmfk94UwoB
         Ue8HOtSn0aj86hr91DQOz8gVsETP2ZR7af+/2Dw6Mm5Ga993W8n5WamXKxTRKNtjmttd
         UOUD/hJM0CrF1ETOrP9ld+91UwFgLsk3Ooqn7i6werfSXPKazJOmHooOiZIFXIsCJtKv
         YTc5QJuoa2w4474990DrcXsbBrQtWyEdf7cv2U2gjrWUuXvDPitimB9E4KZkONlXRh8N
         pICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B80WuFTp3m8SwecqT3IfJ//IoK5UJC0lbvLHibfCmx8=;
        b=uicYxPEOJcGMo9R6/QKKYFDPPpYfizlCBvO+/CbWoaDFU+kmeyifXJewYKwhQdqNUN
         tl/N2nHmgFixbxKBQF5dd5Hd0VH8SU5H+20LZl3q0aTqEf02Tif/tdhNRi5FMhFUhrqI
         fiXcUm9YQLzjqIMeP9tuh+RbT/V+FY9DPqhTdpdNcD7kwu0LJ8I2+Ya3zimBtdVzmqq0
         s3qtuwxYWvALsaeyZl6+088GgAhkzofPwgSNGru24MfQoHFRWywGUN3RkLr/nKbMG/H1
         bqrY9IRRuuq6oHgSPSpWQ9DSUyTngdwFHpEULtaXszprrZr6l1MwWQFC+Pq5fP4YqDl3
         fF5Q==
X-Gm-Message-State: AOAM53143o4D9ZbCnz14lWr4poWPD2/EPmlfrMZJ/2Qd9N+XHS6Pn0gE
        DSKJ37mBE9Rq7FsGnfxruYn/1Q==
X-Google-Smtp-Source: ABdhPJxvlWFsnIlVWfNlW143h1l1tU2YoUyMXelmM/SalweFWK2m0qPlPzphjNaD0OiHDM8Sb/hzZg==
X-Received: by 2002:a62:2581:0:b029:2ea:228e:5a37 with SMTP id l123-20020a6225810000b02902ea228e5a37mr524454pfl.63.1623255167466;
        Wed, 09 Jun 2021 09:12:47 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
        by smtp.gmail.com with ESMTPSA id z22sm92340pfa.157.2021.06.09.09.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:12:46 -0700 (PDT)
Date:   Wed, 9 Jun 2021 09:12:40 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] KVM: x86: Ensure liveliness of nested VM-Enter fail
 tracepoint message
Message-ID: <YMDoeDTrAMmfl6+k@google.com>
References: <20210607175748.674002-1-seanjc@google.com>
 <CANRm+CxWovvM187BKtuvS1_WWnSdKc6wFA5swF-sJPJqYSWnUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CxWovvM187BKtuvS1_WWnSdKc6wFA5swF-sJPJqYSWnUg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021, Wanpeng Li wrote:
> On Tue, 8 Jun 2021 at 02:00, Sean Christopherson <seanjc@google.com> wrote:
> >
> > Use the __string() machinery provided by the tracing subystem to make a
> > copy of the string literals consumed by the "nested VM-Enter failed"
> > tracepoint.  A complete copy is necessary to ensure that the tracepoint
> > can't outlive the data/memory it consumes and deference stale memory.
> >
> > Because the tracepoint itself is defined by kvm, if kvm-intel and/or
> > kvm-amd are built as modules, the memory holding the string literals
> > defined by the vendor modules will be freed when the module is unloaded,
> > whereas the tracepoint and its data in the ring buffer will live until
> > kvm is unloaded (or "indefinitely" if kvm is built-in).
> >
> > This bug has existed since the tracepoint was added, but was recently
> > exposed by a new check in tracing to detect exactly this type of bug.
> >
> >   fmt: '%s%s
> >   ' current_buffer: ' vmx_dirty_log_t-140127  [003] ....  kvm_nested_vmenter_failed: '
> >   WARNING: CPU: 3 PID: 140134 at kernel/trace/trace.c:3759 trace_check_vprintf+0x3be/0x3e0
> >   CPU: 3 PID: 140134 Comm: less Not tainted 5.13.0-rc1-ce2e73ce600a-req #184
> >   Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
> >   RIP: 0010:trace_check_vprintf+0x3be/0x3e0
> >   Code: <0f> 0b 44 8b 4c 24 1c e9 a9 fe ff ff c6 44 02 ff 00 49 8b 97 b0 20
> >   RSP: 0018:ffffa895cc37bcb0 EFLAGS: 00010282
> >   RAX: 0000000000000000 RBX: ffffa895cc37bd08 RCX: 0000000000000027
> >   RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff9766cfad74f8
> >   RBP: ffffffffc0a041d4 R08: ffff9766cfad74f0 R09: ffffa895cc37bad8
> >   R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffc0a041d4
> >   R13: ffffffffc0f4dba8 R14: 0000000000000000 R15: ffff976409f2c000
> >   FS:  00007f92fa200740(0000) GS:ffff9766cfac0000(0000) knlGS:0000000000000000
> >   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 0000559bd11b0000 CR3: 000000019fbaa002 CR4: 00000000001726e0
> >   Call Trace:
> >    trace_event_printf+0x5e/0x80
> >    trace_raw_output_kvm_nested_vmenter_failed+0x3a/0x60 [kvm]
> >    print_trace_line+0x1dd/0x4e0
> >    s_show+0x45/0x150
> >    seq_read_iter+0x2d5/0x4c0
> >    seq_read+0x106/0x150
> >    vfs_read+0x98/0x180
> >    ksys_read+0x5f/0xe0
> >    do_syscall_64+0x40/0xb0
> >    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> I can observe tons of other kvm tracepoints warning like this after
> commit 9a6944fee68e25 (tracing: Add a verifier to check string
> pointers for trace events), just echo 1 >
> /sys/kernel/tracing/events/kvm/enable and boot a linux guest.

Can you provide your .config?  With all of events/kvm and events/kvmmmu enabled
I don't get any warnings running a Linux guest, a nested Linux guest, and
kvm-unit-tests.

Do you see the behavior with other tracepoints?  E.g. enabling all events on my
systems yields warnings for a USB module, but everything else is clean.
