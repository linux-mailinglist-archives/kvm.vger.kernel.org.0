Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CFA1AD4CF
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 05:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgDQDVu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Apr 2020 23:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgDQDVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 23:21:50 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207315] New: Out of bounds access in search_memslots() in
 include/linux/kvm_host.h
Date:   Fri, 17 Apr 2020 03:21:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sunhaoyl@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-207315-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207315

            Bug ID: 207315
           Summary: Out of bounds access in search_memslots() in
                    include/linux/kvm_host.h
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.7-rc1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: sunhaoyl@outlook.com
        Regression: No

Created attachment 288543
  --> https://bugzilla.kernel.org/attachment.cgi?id=288543&action=edit
kernel config

Description of problem:
Possible out of bounds access exists in search_memslots() in
include/linux/kvm_host.h.
In search_memslots(struct kvm_memslots *slots, gfn_t gfn),  a binary search is
used  for slot searching,  as following code shows:

        while (start < end) {
                slot = start + (end - start) / 2;

                if (gfn >= memslots[slot].base_gfn)
                        end = slot;
                else
                        start = slot + 1;
        }

        if (gfn >= memslots[start].base_gfn &&
            gfn < memslots[start].base_gfn + memslots[start].npages) {
                atomic_set(&slots->lru_slot, start);
                return &memslots[start];
        }

However, *start* may equal to *slots->used_slots*  when *gfn* is smaller than
every *base_gfn*, which causes out of bound access in if-condition. 


Version-Release number of selected component (if applicable):
linux-v5.7-rc1

How reproducible:
Easy.

Steps to Reproduce:
1.  Compile kernel with config in the attachment.
2.  Compile and run following code

#include <stdint.h>
#include <unistd.h>
#include <linux/kvm.h>
#include <asm/kvm.h>
#include <sys/ioctl.h>
#include <fcntl.h>

int main(int argc, char **agrv){

        struct kvm_userspace_memory_region kvm_userspace_memory_region_0 = {
                .slot = 4098152658,
                .flags = 1653871800,
                .guest_phys_addr = 9228163640593578308,
                .memory_size = 13154652985641659684,
                .userspace_addr = 2934507574655831761
        };
        char *s_0 = "/dev/kvm";
        struct kvm_vapic_addr kvm_vapic_addr_1 = {
                .vapic_addr=4096
        };

        int32_t r0 = open(s_0,0,0);
        int32_t r1 = ioctl(r0,44545,0);
        ioctl(r1,44640);
        ioctl(r1,1075883590,&kvm_userspace_memory_region_0);
        int32_t r2 = ioctl(r1,44609,0);
        ioctl(r2,44672,0);
        ioctl(r2,1074310803,&kvm_vapic_addr_1);
        return 0;
}


Actual results:
Kernel panic as following:

[ 46.550820][ T6635] BUG: KASAN: slab-out-of-bounds in
__kvm_gfn_to_hva_cache_init+0x30b/0x710
[ 46.551811][ T6635] Read of size 8 at addr ffff8880268e1468 by task
executor/6635
[ 46.552658][ T6635] 
[ 46.552922][ T6635] CPU: 0 PID: 6635 Comm: executor Not tainted 5.6.0+ #65
[ 46.553690][ T6635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[ 46.555034][ T6635] Call Trace:
[ 46.555410][ T6635] dump_stack+0x1e9/0x30e
[ 46.555890][ T6635] print_address_description+0x74/0x5c0
[ 46.556525][ T6635] ? printk+0x62/0x83
[ 46.556978][ T6635] ? vprintk_emit+0x32e/0x3b0
[ 46.557493][ T6635] __kasan_report+0x103/0x1a0
[ 46.558008][ T6635] ? __kvm_gfn_to_hva_cache_init+0x30b/0x710
[ 46.558662][ T6635] ? __kvm_gfn_to_hva_cache_init+0x30b/0x710
[ 46.559321][ T6635] kasan_report+0x4d/0x80
[ 46.559799][ T6635] ? __kvm_gfn_to_hva_cache_init+0x30b/0x710
[ 46.560460][ T6635] ? kvm_lapic_set_vapic_addr+0x7d/0x130
[ 46.561095][ T6635] ? kvm_arch_vcpu_ioctl+0x15e7/0x3eb0
[ 46.561724][ T6635] ? kvm_vcpu_ioctl+0xff/0xa80
[ 46.562259][ T6635] ? kvm_vcpu_ioctl+0x550/0xa80
[ 46.562796][ T6635] ? kvm_vm_ioctl_get_dirty_log+0x650/0x650
[ 46.563442][ T6635] ? __se_sys_ioctl+0xf9/0x160
[ 46.563967][ T6635] ? do_syscall_64+0xf3/0x1b0
[ 46.564483][ T6635] ? entry_SYSCALL_64_after_hwframe+0x49/0xb3
[ 46.565150][ T6635] 
/* ... */

Expected results:
normal exit

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
