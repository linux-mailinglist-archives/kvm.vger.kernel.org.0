Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C155045B8FD
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 12:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbhKXLV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 06:21:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240887AbhKXLV4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Nov 2021 06:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637752726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EXLSeLEr0J3vq9Ir5gCLpfItHKa5rtYcPMMzJxUxGIM=;
        b=duQlzeviRalGqutZ67DQhZVN0mZWOVfeRmGoS8alF7FvL9U1ZNpAQ3MUFjxKN0iTA/9ouT
        BfD3lHwTLC9MElgzXYmMZ19m0NypLBdRUSxC/cEEcZvinC+cOZ4K0OovT6W4r3trvFOKkC
        o44JXrORnr9iBxg0/BO6VSOeK8/oT28=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-Lax9vaEuPkuIlZhKqYaqoA-1; Wed, 24 Nov 2021 06:18:45 -0500
X-MC-Unique: Lax9vaEuPkuIlZhKqYaqoA-1
Received: by mail-wm1-f72.google.com with SMTP id a85-20020a1c7f58000000b0033ddc0eacc8so947294wmd.9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 03:18:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EXLSeLEr0J3vq9Ir5gCLpfItHKa5rtYcPMMzJxUxGIM=;
        b=guXDSg7yYoSp32+J0sCzcIrZK87seWArixJyB75iUUCff6Cce29odftfUPfuZYFJLM
         mrgPng7Xa2QnfEVQduhPhZsV6tpnXokZTAR+3VHNb7TBZ5Yhg2c66G201fONSSukmzOe
         B88d3S5DXOa2vR3AfRWFH2TS8wh41c7oFbX0uhBermxAQCfp3sT826otuj+6HgW2EEaz
         mWKSjF42zXnj9yg3zAlb+QVaZRhu7f+4szzoymelW1b1JbZjvWsKY1dwsWpyDryqGLOQ
         YQ//E8OxGSTyDLgsfM0Z2CNjo3KapgmcBFguRE8JAwWoTfIgVi8QklCcp8DIS2HZ/pQ3
         PWSQ==
X-Gm-Message-State: AOAM532CVEIaYVC6oVSqdtKd37EWDzjDgFoM8f7CKlKkz0d51mRn6pYB
        qf564tu850vWZ/VEPakuNGS5IU7nlGqFg+mIoSMTYLKc4LjmcOd9n8N6ncUrsi5Bxu9FHyeq/LF
        3MoDYssA1TiWp
X-Received: by 2002:a05:6000:1568:: with SMTP id 8mr17888293wrz.76.1637752724294;
        Wed, 24 Nov 2021 03:18:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUFsykw0HGFhTqQnLN7D+ri7et5Vk/6y++jdKzN6SIrBYF+ephUxl+Qt7w4lsYUvICVs6Pkw==
X-Received: by 2002:a05:6000:1568:: with SMTP id 8mr17888258wrz.76.1637752724065;
        Wed, 24 Nov 2021 03:18:44 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t8sm5115342wmq.32.2021.11.24.03.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 03:18:43 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     pbonzini@redhat.com, David Woodhouse <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot <syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [syzbot] kernel BUG in kvm_read_guest_offset_cached
In-Reply-To: <000000000000f854ec05d167f227@google.com>
References: <000000000000f854ec05d167f227@google.com>
Date:   Wed, 24 Nov 2021 12:18:42 +0100
Message-ID: <871r35n6nh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot <syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    4c388a8e740d Merge tag 'zstd-for-linus-5.16-rc1' of git://..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=171ff6eeb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
> dashboard link: https://syzkaller.appspot.com/bug?extid=7b7db8bb4db6fd5e157b
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.

No worries, I think I do.

>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7b7db8bb4db6fd5e157b@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kvm/../../../virt/kvm/kvm_main.c:2955!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 27639 Comm: syz-executor.0 Not tainted 5.16.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:kvm_read_guest_offset_cached+0x3aa/0x440 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2955
> Code: 00 48 c7 c2 c0 08 a2 89 be 0b 03 00 00 48 c7 c7 60 0d a2 89 c6 05 71 f9 73 0c 01 e8 62 19 f8 07 e9 d6 fc ff ff e8 36 1b 6f 00 <0f> 0b e8 2f 1b 6f 00 48 8b 74 24 10 4c 89 ef 4c 89 e1 48 8b 54 24
> RSP: 0018:ffffc9000589fa18 EFLAGS: 00010216
> RAX: 0000000000003b75 RBX: ffff8880722ba798 RCX: ffffc90002b94000
> RDX: 0000000000040000 RSI: ffffffff81087cda RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000004 R09: ffffc900049dbf53
> R10: ffffffff81087a0f R11: 0000000000000002 R12: 0000000000000004
> R13: ffffc900049d1000 R14: 0000000000000000 R15: ffff8880886c0000
> FS:  00007fd7a562f700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000200 CR3: 0000000038e62000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000c0fe
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  handle_vmptrld arch/x86/kvm/vmx/nested.c:5304 [inline]

The code is:

		struct gfn_to_hva_cache *ghc = &vmx->nested.vmcs12_cache;
		struct vmcs_hdr hdr;

		if (ghc->gpa != vmptr &&
		    kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, vmptr, VMCS12_SIZE)) {
	            ...
		}

		if (kvm_read_guest_offset_cached(vcpu->kvm, ghc, &hdr,
						 offsetof(struct vmcs12, hdr),
						 sizeof(hdr))) {
                ....

It seems that 'nested.vmcs12_cache' is zero-initalized and 'ghc->gpa !=
vmptr' check will pass if VMPTRLD is called with '0' argument.

The following hack to 'state_test.c' can be used to crash host's kernel:

diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 32854c1462ad..29b468f1a083 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -81,6 +81,9 @@ static void vmx_l1_guest_code(struct vmx_pages *vmx_pages)
        GUEST_ASSERT(vmx_pages->vmcs_gpa);
        GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
        GUEST_SYNC(3);
+
+       vmptrld(0);
+
        GUEST_ASSERT(load_vmcs(vmx_pages));
        GUEST_ASSERT(vmptrstz() == vmx_pages->vmcs_gpa);
 

This seems to be a regression introduced by

commit cee66664dcd6241a943380ef9dcd2f8a0a7dc47d
Author: David Woodhouse <dwmw@amazon.co.uk>
Date:   Mon Nov 15 16:50:26 2021 +0000

    KVM: nVMX: Use a gfn_to_hva_cache for vmptrld

Luckily, it's in 5.16-rc2 only.

I think the solution is to assign 'ghc->gpa' to '-1' upon
initialization. I can send a patch if my conclusions seem to be right.

-- 
Vitaly

