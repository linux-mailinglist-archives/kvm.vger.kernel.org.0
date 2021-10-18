Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4382B432476
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhJRRRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhJRRRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 13:17:03 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FA9C06161C;
        Mon, 18 Oct 2021 10:14:52 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id n65so3036691ybb.7;
        Mon, 18 Oct 2021 10:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WONSvi72olzI8+Wcr8S4IbIIfzASDpg4WboV6YdaeiM=;
        b=PLwYBODJlIIWG8/TUtWIq71XqpsDD0GUenM0WM4yW9tTKgDqupQKJ1WNDnLNuxs4GY
         ZkS+ZaxKdzesNNB4Py/W8MFmiHleHB0CdKRxrZbwi+YxuwYJeE30aWpqigqVI/NDz8hk
         kSpJbWeNYJ3LPXP9HQk312UmQE/62sg8nlifSyf2hGja5R8tXwmklh0PGi+e2vzr+mYs
         /qUkaWfRV5c1aGDJUtslgTzVv0y2g5gz1kBpA+F0pfuWLWdwAIvDORySM/cd4cfK1a2k
         sPKmfSpP+8R9u2ftjfz/R/uUkOTPxwHnk2gLy3U9kPKZx/5Z14boU7Hhavw9kFVE5SOG
         cu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WONSvi72olzI8+Wcr8S4IbIIfzASDpg4WboV6YdaeiM=;
        b=WIZCzDZJ1Kl/wf2hq0IORU4QXvHJjBSUt6MZoFgdeMOfJ7BWvARz2J62K3Z4x4WBUo
         y/Sba0RGa0Xh/nZ+wU/LevZK3GZnUb+v9Z/mRztMrYF/rNbLo0mIVn2x/8mzaoLcFfr4
         MECMS3IC1yB88L+S6djIBdUh6vTTSAP1wX/OSaaw0HEm2wpe+XGQ4/ipW+RikWuauLMg
         ufvYhkNqIVb98L53kqdig8+FCoAjACzbE/x848+n2i7rdCuHK7LfJSRFYxp0UFKVtMku
         XA7+KarbQCghd0l6eU+e/AKAc7tjgPn/DiWnoK8LCIgGwpAtSsXaok27tq6u9PN/NNvU
         Rfmw==
X-Gm-Message-State: AOAM533JHnnXPM73SAZYbyRB2F3L/ZeqONywKDz62RirTmwRFeTWZaVi
        gL74B4D51wdMzOKPdfF2SXYcVyF9nENwYVVDgoRi4uRHCroNyA==
X-Google-Smtp-Source: ABdhPJwzhX8p4YTD5NEf2LuUbtqWH8Bj8ekAJ7zS61tER1PkR8dhVaGPpC8XsK457nN0nExvJ6VEnqB/sEvMp4s/yTk=
X-Received: by 2002:a25:d290:: with SMTP id j138mr33885450ybg.381.1634577291390;
 Mon, 18 Oct 2021 10:14:51 -0700 (PDT)
MIME-Version: 1.0
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Tue, 19 Oct 2021 01:14:40 +0800
Message-ID: <CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com>
Subject: There is a null-ptr-deref bug in kvm_dirty_ring_get in virt/kvm/dirty_ring.c
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, there is a null-ptr-deref bug in kvm_dirty_ring_get in
virt/kvm/dirty_ring.c and I reproduce it on 5.15.0-rc5+.

###analyze
we can call KVM_XEN_HVM_SET_ATTR ioctl and it would invoke
kvm_xen_hvm_set_attr(), it would call mark_page_dirty_in_slot().
mark_page_dirty_in_slot()
```
void mark_page_dirty_in_slot(struct kvm *kvm,
     struct kvm_memory_slot *memslot,
     gfn_t gfn)
{
if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
unsigned long rel_gfn = gfn - memslot->base_gfn;
u32 slot = (memslot->as_id << 16) | memslot->id;

if (kvm->dirty_ring_size)
kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
    slot, rel_gfn);
else
set_bit_le(rel_gfn, memslot->dirty_bitmap);
}
}
```
mark_page_dirty_in_slot() would call kvm_dirty_ring_get() to get
vcpu->dirty_ring.
kvm_dirty_ring_get()
```
struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
{
struct kvm_vcpu *vcpu = kvm_get_running_vcpu();  //-------> invoke
kvm_get_running_vcpu() to get a vcpu.

WARN_ON_ONCE(vcpu->kvm != kvm); [1]

return &vcpu->dirty_ring;
}
```
but we had not called KVM_CREATE_VCPU ioctl to create a kvm_vcpu so
vcpu is NULL.

[1].vcpu->kvm caused a null pointer dereference.

###Crash log
root@syzkaller:/home/user# ./kvm_dirty_ring_get
[ 2608.490187][ T6513] BUG: kernel NULL pointer dereference, address:
0000000000000000
[ 2608.491652][ T6513] #PF: supervisor read access in kernel mode
[ 2608.492713][ T6513] #PF: error_code(0x0000) - not-present page
[ 2608.493770][ T6513] PGD 15944067 P4D 15944067 PUD 1589d067 PMD 0
[ 2608.495568][ T6513] Oops: 0000 [#1] PREEMPT SMP
[ 2608.496355][ T6513] CPU: 1 PID: 6513 Comm: kvm_dirty_ring_ Not
tainted 5.15.0-rc5+ #14
[ 2608.497755][ T6513] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[ 2608.499451][ T6513] RIP: 0010:kvm_dirty_ring_get+0x9/0x20
[ 2608.500480][ T6513] Code: 90 e8 5b bb 04 00 83 c0 40 c3 0f 1f 80 00
00 00 00 8b 07 8b 57 04 29 d0 39 47 0c 0f 96 c0 c3 66 90 cc 48 89 fb
e8 17 06 ff ff <48> b
[ 2608.503997][ T6513] RSP: 0018:ffffc90000ab3c08 EFLAGS: 00010286
[ 2608.505054][ T6513] RAX: 0000000000000000 RBX: ffffc90000abd000
RCX: 0000000000000000
[ 2608.506346][ T6513] RDX: 0000000000000001 RSI: ffffffff84fc5baf
RDI: 00000000ffffffff
[ 2608.507705][ T6513] RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000050198
[ 2608.509119][ T6513] R10: 0000000000000001 R11: 0000000000000000
R12: 0000000000000000
[ 2608.510527][ T6513] R13: 0000000020fff000 R14: 0000000000000000
R15: 0000000000000004
[ 2608.512259][ T6513] FS:  0000000001cb0880(0000)
GS:ffff88807ec00000(0000) knlGS:0000000000000000
[ 2608.513848][ T6513] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2608.515061][ T6513] CR2: 0000000000000000 CR3: 000000001583c000
CR4: 00000000000006e0
[ 2608.516506][ T6513] Call Trace:
[ 2608.517110][ T6513]  mark_page_dirty_in_slot.part.0+0x21/0x50
[ 2608.518163][ T6513]  __kvm_write_guest_page+0xa1/0xc0
[ 2608.519078][ T6513]  kvm_write_guest+0x42/0x80
[ 2608.519901][ T6513]  kvm_write_wall_clock+0x7f/0x140
[ 2608.520835][ T6513]  kvm_xen_hvm_set_attr+0x13d/0x190
[ 2608.521775][ T6513]  kvm_arch_vm_ioctl+0xa8b/0xc50
[ 2608.522762][ T6513]  ? tomoyo_path_number_perm+0xee/0x290
[ 2608.523771][ T6513]  kvm_vm_ioctl+0x716/0xe10
[ 2608.524545][ T6513]  __x64_sys_ioctl+0x7b/0xb0
[ 2608.525362][ T6513]  do_syscall_64+0x35/0xb0
[ 2608.530275][ T6513]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 2608.531327][ T6513] RIP: 0033:0x44953d
[ 2608.532096][ T6513] Code: 28 c3 e8 36 29 00 00 66 0f 1f 44 00 00 f3
0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 24 08 0f 05 <48> 8
[ 2608.535565][ T6513] RSP: 002b:00007ffeb22c2238 EFLAGS: 00000202
ORIG_RAX: 0000000000000010
[ 2608.537028][ T6513] RAX: ffffffffffffffda RBX: 0000000000400518
RCX: 000000000044953d
[ 2608.538436][ T6513] RDX: 0000000020001080 RSI: 000000004048aec9
RDI: 0000000000000004
[ 2608.539851][ T6513] RBP: 00007ffeb22c2250 R08: 0000000000000000
R09: 0000000000000000
[ 2608.541273][ T6513] R10: 0000000000000000 R11: 0000000000000202
R12: 0000000000402fb0
[ 2608.542845][ T6513] R13: 0000000000000000 R14: 00000000004c0018
R15: 0000000000000000
[ 2608.544260][ T6513] Modules linked in:
[ 2608.544965][ T6513] CR2: 0000000000000000
[ 2608.547791][ T6513] ---[ end trace 69dbdf44c6028ede ]---
[ 2608.548674][ T6513] RIP: 0010:kvm_dirty_ring_get+0x9/0x20
[ 2608.549513][ T6513] Code: 90 e8 5b bb 04 00 83 c0 40 c3 0f 1f 80 00
00 00 00 8b 07 8b 57 04 29 d0 39 47 0c 0f 96 c0 c3 66 90 cc 48 89 fb
e8 17 06 ff ff <48> b
[ 2608.552808][ T6513] RSP: 0018:ffffc90000ab3c08 EFLAGS: 00010286
[ 2608.553702][ T6513] RAX: 0000000000000000 RBX: ffffc90000abd000
RCX: 0000000000000000
[ 2608.556308][ T6513] RDX: 0000000000000001 RSI: ffffffff84fc5baf
RDI: 00000000ffffffff
[ 2608.557778][ T6513] RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000050198
[ 2608.559314][ T6513] R10: 0000000000000001 R11: 0000000000000000
R12: 0000000000000000
[ 2608.560877][ T6513] R13: 0000000020fff000 R14: 0000000000000000
R15: 0000000000000004
[ 2608.562799][ T6513] FS:  0000000001cb0880(0000)
GS:ffff88803ec00000(0000) knlGS:0000000000000000
[ 2608.564529][ T6513] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2608.565864][ T6513] CR2: 0000000020000001 CR3: 000000001583c000
CR4: 00000000000006f0
[ 2608.567378][ T6513] Kernel panic - not syncing: Fatal exception
[ 2608.568551][ T6513] Kernel Offset: disabled
[ 2608.574584][ T6513] Rebooting in 86400 seconds..

Regards,
 butt3rflyh4ck.

-- 
Active Defense Lab of Venustech
