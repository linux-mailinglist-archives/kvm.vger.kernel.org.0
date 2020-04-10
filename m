Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE8181A4A68
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDJT2Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Apr 2020 15:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgDJT2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 15:28:16 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Fri, 10 Apr 2020 19:28:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: anthonysanwo@googlemail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-206579-28872-RwzgQ3SCzb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #55 from Anthony (anthonysanwo@googlemail.com) ---
Created attachment 288333
  --> https://bugzilla.kernel.org/attachment.cgi?id=288333&action=edit
Windows SVM IOMMU testing

Hi Suravee,

Just wanted to report your latest patch:
KVM: x86: Fixes posted interrupt check for IRQs delivery modes -
https://lore.kernel.org/patchwork/patch/1221065/

Fixes SVM IOMMU with windows - Confirmed looking at proc/interrupts and perf
top etc.

Some oddities I found -

With no cpu-pm there can be a large amount of kvm:kvm_avic_incomplete_ipi
exits. With cpu-pm it reduces significantly to sometimes being zero depending
length of looking at perf stat.

Also with no cpu-pm there is a big performance degradation this can be felt in
general in Windows desktop when UI feels more sluggish. Another example of this
is just trying to start a latencymon report freezes the VM(Not sure if is a
hard unrecoverable freeze but UI is completely frozen). With cpu-pm it is
greatly improved but there is still some inconsistencies and compared to just
SVM AVIC working(using kernel without the patch) the performance is worse.
By performance, I am mainly relating to windows system call performance
monitoring with latencymon but this can also be since in applications(Gaming/UI
in the testing I did). 

For whatever reason my test windows config, however SVM IOMMU doesn't seem to
want to activate even with the same settings as my regular config. This is with
the same kernel and testing back to back. 

I have attached a short perf record session + perf stat and configs which I
hope will aid better. Please let me know if there is anything else I can
provide/test to help with debugging.

Those are the parameters I used to record.

sudo perf kvm --host record -agvsT -z=22 --sample-cpu --max-size 2M
--call-graph fp -e 'kvm:*' -o perf-events.data

sudo perf kvm --host record -agvsT -z=22 --sample-cpu --max-size 2M
--call-graph fp -p `pidof qemu-system-x86_64` -o perf-stack.data

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
