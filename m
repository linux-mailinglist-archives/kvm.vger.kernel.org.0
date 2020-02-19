Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B437164E83
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 20:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgBSTKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 14:10:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20623 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726643AbgBSTKX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Feb 2020 14:10:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582139422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Iu+zDafgQ7GdYGR/n8pxbgWtAD7a9J36y82BGwKTfA0=;
        b=FvwBCaumwf7eAvvx3m+aVGLR6Fwi6xADelRb+eqtDmycLOpfbsnQ9n26I/M6b1Y+1DQ+mZ
        1ruoblj/A9Zndj//MteOyjdYqs1zNA98B4lXaW136IwQHbEvYF0b6CqHwMr7bEXdvdMnu+
        zRVifVtVRc1w2P2+A9bHt8wJ11JN/G8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-A1nFdjYNPZyoVheteIKDAg-1; Wed, 19 Feb 2020 14:10:20 -0500
X-MC-Unique: A1nFdjYNPZyoVheteIKDAg-1
Received: by mail-qk1-f200.google.com with SMTP id q135so934182qke.22
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 11:10:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iu+zDafgQ7GdYGR/n8pxbgWtAD7a9J36y82BGwKTfA0=;
        b=JEdeSw5xmF9nEWNrsPqJPJP5vxxVLPVajLa1UBruXOIcLprJk1X4WwV46yPFHJ/KTL
         W4oOnz19hFnc+gIAVqVCi9L4CrjfJk+nv8djgVXbv/7ayV89Pls9kYPDjDnBXLN6NxWk
         bxSHbQBzAbFg7VA/xWt/YCjRpSS9L/A0eUJJ1E8CtBLM60uQZB1RB2jHtcAcuzZ74XKX
         n8I4FOMshjSVFmZDpFCOvToR5YpvEsZeFKHDrt7stYkOWPrLK4bT9kLi58lUnRxwb645
         gB6DLTl2Oew79ET+sHslpHLZo6uM68zD4QRejSdD7q2D6XBMRa57mdDHAEKUGA9TUNA9
         d0TQ==
X-Gm-Message-State: APjAAAVir8BPhLi5QrirA6/QqSZlbRRirx7Cv+nOKcGdfl4UHb81ojIu
        7g2VDBk2FVltrhkR5x0mxMjkfRKj82I1YwsVkr9gV3dxEokbwAC5zKSGTKSOQ8NsLU9/6xFi69r
        sKOX5OXfg5yA0
X-Received: by 2002:aed:29e2:: with SMTP id o89mr23723356qtd.353.1582139419974;
        Wed, 19 Feb 2020 11:10:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyR4tvaG55rn+oIGW+9DmQY+Q5rgmtUB62N9SOWO2kSCX8x9uyUbBuaGecyF0GgmgJCEJ7bJQ==
X-Received: by 2002:aed:29e2:: with SMTP id o89mr23723317qtd.353.1582139419685;
        Wed, 19 Feb 2020 11:10:19 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id m95sm453246qte.41.2020.02.19.11.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 11:10:19 -0800 (PST)
Date:   Wed, 19 Feb 2020 14:10:17 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v6 01/22] KVM: x86: Allocate new rmap and large page
 tracking when moving memslot
Message-ID: <20200219191017.GA37550@xz-x1>
References: <20200218210736.16432-1-sean.j.christopherson@intel.com>
 <20200218210736.16432-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200218210736.16432-2-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 01:07:15PM -0800, Sean Christopherson wrote:
> Reallocate a rmap array and recalcuate large page compatibility when
> moving an existing memslot to correctly handle the alignment properties
> of the new memslot.  The number of rmap entries required at each level
> is dependent on the alignment of the memslot's base gfn with respect to
> that level, e.g. moving a large-page aligned memslot so that it becomes
> unaligned will increase the number of rmap entries needed at the now
> unaligned level.
> 
> Not updating the rmap array is the most obvious bug, as KVM accesses
> garbage data beyond the end of the rmap.  KVM interprets the bad data as
> pointers, leading to non-canonical #GPs, unexpected #PFs, etc...
> 
>   general protection fault: 0000 [#1] SMP
>   CPU: 0 PID: 1909 Comm: move_memory_reg Not tainted 5.4.0-rc7+ #139
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:rmap_get_first+0x37/0x50 [kvm]
>   Code: <48> 8b 3b 48 85 ff 74 ec e8 6c f4 ff ff 85 c0 74 e3 48 89 d8 5b c3
>   RSP: 0018:ffffc9000021bbc8 EFLAGS: 00010246
>   RAX: ffff00617461642e RBX: ffff00617461642e RCX: 0000000000000012
>   RDX: ffff88827400f568 RSI: ffffc9000021bbe0 RDI: ffff88827400f570
>   RBP: 0010000000000000 R08: ffffc9000021bd00 R09: ffffc9000021bda8
>   R10: ffffc9000021bc48 R11: 0000000000000000 R12: 0030000000000000
>   R13: 0000000000000000 R14: ffff88827427d700 R15: ffffc9000021bce8
>   FS:  00007f7eda014700(0000) GS:ffff888277a00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f7ed9216ff8 CR3: 0000000274391003 CR4: 0000000000162eb0
>   Call Trace:
>    kvm_mmu_slot_set_dirty+0xa1/0x150 [kvm]
>    __kvm_set_memory_region.part.64+0x559/0x960 [kvm]
>    kvm_set_memory_region+0x45/0x60 [kvm]
>    kvm_vm_ioctl+0x30f/0x920 [kvm]
>    do_vfs_ioctl+0xa1/0x620
>    ksys_ioctl+0x66/0x70
>    __x64_sys_ioctl+0x16/0x20
>    do_syscall_64+0x4c/0x170
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   RIP: 0033:0x7f7ed9911f47
>   Code: <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
>   RSP: 002b:00007ffc00937498 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>   RAX: ffffffffffffffda RBX: 0000000001ab0010 RCX: 00007f7ed9911f47
>   RDX: 0000000001ab1350 RSI: 000000004020ae46 RDI: 0000000000000004
>   RBP: 000000000000000a R08: 0000000000000000 R09: 00007f7ed9214700
>   R10: 00007f7ed92149d0 R11: 0000000000000246 R12: 00000000bffff000
>   R13: 0000000000000003 R14: 00007f7ed9215000 R15: 0000000000000000
>   Modules linked in: kvm_intel kvm irqbypass
>   ---[ end trace 0c5f570b3358ca89 ]---
> 
> The disallow_lpage tracking is more subtle.  Failure to update results
> in KVM creating large pages when it shouldn't, either due to stale data
> or again due to indexing beyond the end of the metadata arrays, which
> can lead to memory corruption and/or leaking data to guest/userspace.
> 
> Note, the arrays for the old memslot are freed by the unconditional call
> to kvm_free_memslot() in __kvm_set_memory_region().
> 
> Fixes: 05da45583de9b ("KVM: MMU: large page support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

