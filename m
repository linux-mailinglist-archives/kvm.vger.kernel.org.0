Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F426D466E
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjDCOFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbjDCOFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:05:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAD91F7A5;
        Mon,  3 Apr 2023 07:05:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so30651851pjt.5;
        Mon, 03 Apr 2023 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w5Yc/JgLoDqVPYCHVgZsNyoL+g5Xo1tRksD3zBhoegc=;
        b=AOQuxO8LbxrUXDmCWrjbicNAcNqw4oQt4v2229t9AWsUn5NJzlKFqU93+GGJfCrwT5
         g1LnKe7jVQ87UATb/JO8UvRpI16hDeGorKayVMHcrxlygsd5kZDsdwEDRAHk8HghqY7v
         /7tVM7hBJ83TFS6EpuNn4pHjmbJ6qJIAZ5q52sW/KthBMXcTfvq078d5PvHJMWkhlh5l
         kRxpXHwHHuzfJR/x0xcx2D8DshSdXaztlEsyUi02kEh+9rBRA57YcQbbErM/P0vP2v0Y
         /4Is60f7vNnIdqIxERY3ayNfOGPBvyPNUt8bW/qGVOdrECePMmiOijzeDf8SqN3a8c5i
         q01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5Yc/JgLoDqVPYCHVgZsNyoL+g5Xo1tRksD3zBhoegc=;
        b=67rUmkEMiRm+apZBKXJ1gKtT1Qyr684EhlI8P8Oif3Y8+Zt3/Apye+uXpXBgkuL1KP
         A5q8dqVATgAZxH/Sfiqe5afJxz1wWF6CrvqcT9Cfq+sj509SzkL02e7+hRXdO7MfGa09
         9s7PU6JV1DMdrHtmcZDQqMwhx+kxU89eM2CPbCBLJsFsO6t53Q4OFwpZTmcW4mHpWnWO
         v8cLwhVuJcRkUFPR93IASNtrCDXbM7AE2zt9qLXwAL+1NjCP+8Bi5cIEay4DV7abLHdX
         Vz74nYGpy/RFXxKIVa2NYXvmTS2YCW2eDyhlr5cId49c0SdvMi4fBQZQCkzdO8RtfbEk
         c3Zw==
X-Gm-Message-State: AO0yUKXFlRX04DwuO3Tv+K0zXSjLG0dN7sCJO/UqLRVu1UNKf/L3i087
        PZTKkiTNYtCX5CFopx9EfTMwZ0Vw3Lk=
X-Google-Smtp-Source: AK7set9ovMqt0tc5Q2JFliQdrG5BJa3xdt6EKcQ4O1xwgK+nDHeP92y7tvguZJbUIDaGC6lTMwuORQ==
X-Received: by 2002:a05:6a20:bf18:b0:da:462c:9e15 with SMTP id gc24-20020a056a20bf1800b000da462c9e15mr28915340pzb.48.1680530698315;
        Mon, 03 Apr 2023 07:04:58 -0700 (PDT)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id y8-20020aa78548000000b006288ca3cadfsm6984388pfn.35.2023.04.03.07.04.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:04:57 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
Subject: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
Date:   Mon,  3 Apr 2023 22:05:58 +0800
Message-Id: <20230403140605.540512-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

0 Purpose
---------

Make the entry code handles the super exceptions safely with atomic
stack-switching.

Make the entry code more robust and make TDX and SEV more resistant to
hypervisor manipulation when using IST.


1 What's the problem
--------------------

Thomas Gleixner's complaint about the x86's syscall/exception design:
[RFD] x86: Curing the exception and syscall trainwreck in hardware
https://lore.kernel.org/lkml/875z98jkof.fsf@nanos.tec.linutronix.de/

In the email thread, Linus Torvalds also despised the design with a
lengthy description.

Andrew Cooper's detailed documentation about the syscall gap and the
stack switching problem:
x86 Stack Switching Issues and Improvements
https://docs.google.com/document/d/1hWejnyDkjRRAW-JEsRjA5c9CKLOPc6VKJQsuvODlQEI/edit#
(highly recommended reading if you want to know the detail of the problem)


In short, x86_64 has the issue of syscall gap, so IST has to be used for
super exceptions and exposed to its recursion issues.

Fixing hardware is the only way to remove the syscall gap, while the IST
recursion issues can actually be fixed via software approaches.


2 What are the current approaches to fix the IST recursion issues
-----------------------------------------------------------------

2.1 NMI
-------

Steven Rostedt's NMI stack-switching approach (recommended reading)
The x86 NMI iret problem 
https://lwn.net/Articles/484932/

Nested NMIs lead to CVE-2015-3290 （bad iret to userspace)
https://lwn.net/Articles/654418/

Linux x86_64 NMI security issues
https://lore.kernel.org/lkml/CALCETrXViSiMG79NtqN79NauDN9B2k9nOQN18496h9pJg+78+g@mail.gmail.com/

If all other super exceptions are omitted, the NMI approach is excellent
except it puts two stacks (the hardware entry stack, 8*12=96 bytes, and
the software handler stack, 4000 bytes) into a single 4K-stack and uses
ASM code too much, which isn't convenient, i.e. it uses X86_EFLAGS_DF to
avoid misleading from syscall gap rather than using
ip_within_syscall_gap().

And the atomic in it is just atomic for NMI, not for all the super
exceptions.

2.2 MCE and DB
--------------

The approach for fixing the kernel mode #DB recursion issue is to totally
disable #DB recursion in kernel mode, which is considered to be the best
and strongest solution.

The approach for fixing the kernel mode MCE recursion issue is to just
ignore it because MCE in kernel mode is considered to be fatal. It is
an acceptable solution.

2.3 #VE
-------

The approach for fixing the kernel mode #VE recursion issue is to just
NOT use IST for #VE although #VE is also considered to be one of the
super exceptions and had raised some worries:
https://lore.kernel.org/lkml/YCEQiDNSHTGBXBcj@hirez.programming.kicks-ass.net/
https://lore.kernel.org/lkml/CALCETrU9XypKbj-TrXLB3CPW6=MZ__5ifLz0ckbB=c=Myegn9Q@mail.gmail.com/
https://lore.kernel.org/lkml/1843debc-05e8-4d10-73e4-7ddce3b3eae2@intel.com/

To remit the worries,  SEPT_VE_DISABLE is forced used currently and
also disables its abilities (accept-on-demand or memory balloon which
is critical to lightweight VMs like Kata Containers):
https://lore.kernel.org/lkml/YCb0%2FDg28uI7TRD%2F@google.com/

2.4 #VC and #HV
---------------

The approach for fixing the kernel mode #VC/#HV recursion issue is even
more complicated and gross.  It dynamically changes the IST pointers in
the TSS; it has a linked list on the stacks to link the stacks; it has
code spilled too many places. It doesn't fix the problem V.S NMI, MCE.
(#VC in the NMI prologue reenable NMI on iret and maybe corrupt the NMI
prologue with nested NMI).
https://lore.kernel.org/lkml/20200715094702.GF10769@hirez.programming.kicks-ass.net/
https://lore.kernel.org/lkml/CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com/

2.5 #DF
-------

The approach for fixing kernel mode #DF recursion issue is to move it
out of the software stack switching scope because #DF is really
destructively fatal and is the last resort for all the other problems.
This approach is always the best way.

2.6 summary for current approaches
----------------------------------

The problem with these approaches is that different super exception uses
different approach and each approach takes care of itself only and the
code is spread overall and into the high-level handler. Above all, they
don't fix the problem; the system can go unexpectedly except in
bare-metal where there is no #VE #VC and #HV and only NMI is the only
recoverable recursive super exception. When there are more than one
recoverable recursive super exceptions, scattered approaches can't work.
Moreover, the current approaches are obstacles to implement supervisor
mode shadow stack.


3 A journey to find a safe stack-switching approach
---------------------------------------------------

3.1 the simplest way, use hardware stack switching only
-------------------------------------------------------

Use only the IST mechanism for super exceptions, but it is not
reentrance-safe:

                  +---------+       +---------+
       +--------> | event A |   +-> | event B |
       |          |hw entry |   |   |hw entry |
       |          +----+----+   |   +----+----+
       |               |      + |        |
       +          +----v----+ | |   +----v----+
handle the event  | prepare | | |   | prepare |
on the IST stack  +----+----+ +-+   +----+----+
        +   +          |      |          |
        |   |     +----v----+ |     +----v----+
        |   +---> |handling | |     |handling |
        |         +---------+ +     |or iret  |
        |                           +----+----+
        |         +---------+            |
        +-------> | event A | <----------------+
                  | reenter |       |reenable  |
                  +----+----+       |or trigger|
                       |            | event A  |
                       v            +----------+
              reenter on the
              same stack top   Event B (might not IST)
                  !oops!       occurs when Event A is
                               preparing or handling


It is unsafe for the handler to stick on the IST stack.

3.2 switch off the IST stack ASAP
---------------------------------

              +---------+       +---------+
              | event A |   +-> | event B |
              |hw entry |   |   |hw entry |
              +----+----+   |   +----+----+
                   |        |        |
              +----v----+   |   +----v----+
              |prepare& |   |   | prepare |
switch to +-> |switch SP|   |   |         |
a special     +----+----+   |   +----+----+
stack              |        |        |
              +----v----+   |   +----v----+
              |handling | +-+   |handling |
              +---------+       |or iret  |
                                +----+----+
              +---------+            |
              | event A | <----------------+
              | reenter |       |reenable  |
              +----+----+       |or trigger|
                   |            | event A  |
                   |            +----------+
                   v
          safe switch SP  Event B (might not IST)
           and handling   occurs when Event A is
                          handling


It seems to work.
But this approach is still not working, when:

              +---------+       +---------+ Event B (also IST)
              | event A |   +-> | event B | occurs when Event A is
              |hw entry |   |   |hw entry | switching stack, but
              +----+----+   |   +----+----+ has not finished yet
                   |        |        |
              +----v----+   |   +----v----+
              |prepare& |   |   |prepare& |
Switch to +-> |switching|---+   |switch SP|
a special                       +----+----+
stack                                |
              +---------+       +----V----+
              | event A | <---+ |handling |
              | reenter |     | |or iret  |
              +----+----+     | +----+----+
                   |          |      |
                   v          +------------+
          Reenter on the        |reenable  |
          same stack top        |or trigger|
              !oops!            | event A  |
                                +----------+

In this example, if event A (IST) is interrupted by event B while is
preparing or switching, the stack is still corrupted.

So it needs to be an atomical switching-off.

Currently, NMI and #VC are using this approach.

NMI uses the hardware-entry IST stack, 8*12=96 bytes, and the software
handler stack, 4000 bytes, connected in a 4K page.  NMI setups both
stacks and do the high-level handler in the 4000-byte stack in an
atomical way.

But this "atomical way" is only atomic in the view of NMI itself,
not in the view of all super exceptions. If event B (#MC, #VC)
occurs when event A (NMI) is preparing (NMI's prologue), the NMI
is reenabled on B's return, and if a nested NMI is delivered,
the stack is still corrupted.

#VC switches off the IST stack totally with more hacks, but not
really fix the problem.

So it needs to be a really atomical switching-off.  "really atomical"
means it is atomic in the view of all super exceptions.
(#DF is not counted, which is more super than other super exceptions)

3.3 atomically switch off the IST stack
---------------------------------------

We need a really atomic way to switch the stacks.

This new atomic way is named atomic-IST-entry which is applied for
all IST events except #DF. For convenience, aIST means the events that
use atomic-IST-entry approach, or all IST events except #DF.

+-------------------------------+    +-------------------------------+
|                   +---------+ |    | +---------+                   |
| atomic-IST-entry  | event A | |    | | event B |  atomic-IST-entry |
|                   |hw entry | |    | |hw entry |                   |
|                   +----+----+ |    | +----+----+                   |
|                        |      |    |      |                        |
|  atomic switch    +----v----+ |    | +----v----+    Also help      |
|  to a special +-> |  switch | |    | |  switch | <-+complete A's   |
|  stack            |  stack  | +----> |  stack  |    atomic entry   |
|                   +---------+ |    | +---------+                   |
+-------------------------------+    +---------+---------------------+
                                               |
                +---------+  +---------+  +----v----+
                |handle A <--+B return <--+handle B |
                +---------+  +---------+  +---------+

atomic-IST-entry consists of the hardware entry procedure which delivers
the event on the TSS-configured IST stack and a software stack switching
procedure which switches the stack from the TSS-configured IST stack to
a special stack.

If it just interrupts an incompleted atomic-IST-entry, it helps complete
what the interrupted atomic-IST-entry should have done and adjusts its
return point so that when it returns, it will return to the point as
though the interrupted aIST has fully completed its atomic-IST-entry.

Note, doing "what the interrupted atomic-IST-entry should have done" may
do it recursively if the interrupted aIST had also interrupted yet
another aIST.  Since the maximum number of nested aIST is limited, the
recursive procedure would be implemented as a loop rather than a
recursive function call.

This approach ensures any atomic-IST-entry's completion no matter
whether it completes by itself or is completed by a nested aIST, so it
is atomicall.

4 atomic-IST-entry: how to implement it
---------------------------------------

4.1 Types of atomic-IST-entry
-----------------------------

outmost atomic-IST-entry
	The atomic-IST-entry that interrupts any non-atomic-IST-entry
	context is the outmost atomic-IST-entry.

interrupted atomic-IST-entry
	The atomic-IST-entry interrupted by an IST event before
	committing is an interrupted atomic-IST-entry. All
	atomic-IST-entries except for the ongoing one are interrupted
	atomic-IST-entries.

nested atomic-IST-entry
	The atomic-IST-entry that interrupts other atomic-IST-entry is
	a nested atomic-IST-entry. All atomic-IST-entries except for
	the outmost are nested atomic-IST-entries.

ongoing atomic-IST-entry
	The atomic-IST-entry running on the CPU before committing is
	an ongoing atomic-IST-entry. If it is interrupted by an IST event
	before committing, it will become an interrupted atomic-IST-entry
	and the new event will be the new ongoing atomic-IST-entry.


4.2 atomic and proxy
--------------------

Atomic is the most fundamental strategy and attribute for the stack
switching procedure for aIST entries. The software maintains it like
atomically hardware-entry as if the architecture would deliver the aIST
event on a target stack atomically.

To make an interrupted atomic-IST-entry atomic in software, the nested
atomic-IST-entry works as a proxy of the interrupted atomic-IST-entry
and does all its work. The interrupted atomic-IST-entry may also be a
nested atomic-IST-entry, so the ongoing nested atomic-IST-entry should
do all of the work of all interrupted atomic-IST-entries.

4.3 abortable, replicable and idempotent
----------------------------------------

When an atomic-IST-entry is interrupted, it will never be resumed to the
point where it was interrupted since all of its work had been done on
return.  So any point in the atomic-IST-entry must be abortable.  All of
its work has to be completed with the same result by the ongoing nested
atomic-IST-entry, so any work in an atomic-IST-entry must be replicable
and idempotent.

4.4 two views of the atomic-IST-entry: logical and reality
----------------------------------------------------------

logical view  +------>  atomic by aborting and replicating

+-------------+  +   +---------------+            +---------------+
|  event A    |  |   |   event A     | interrupt  |   event B     |
|  hw entry   |  |   |   hw entry    |   +------> |   hw entry    |
+------+------+  |   +------+--------+ + |        +------+--------+
       |         |          |          | |               |
+------v------+  |   +------v--------+ | |        +------v--------+
|save pt_regs |  |   | save pt_regs  | | |        | save pt_regs  |
+------+------+  |   +------+--------+ | |        +------+--------+
       |         |          |          +-+               |
       |         |   +------v--------+ |          +------v--------+
       |         |   |for all entries| |          |for all entries|
+------v------+  |   |   replicate   | |          |   replicate   |
|copy pt_regs |  |   | copy pt_regs  | |          | copy pt_regs  |
+------+------+  |   +------+--------+ |          +------+--------+
       |         |          |          |                 |
+------v------+  |   +------v--------+ +          +------v--------+
|   switch    |  |   | commit switch |            | commit switch |
+-------------+  |   +---------------+  abort to  +---------------+
                 +   the interrupted    -------->  the nested
                     atomic-IST-entry  <--------   atomic-IST-entry
                                        replicate  (when ongoing)


4.5 copy-on-write and commit design pattern
-------------------------------------------

Generally, abortable, replicable, and idempotent programs are often
implemented via copy-on-write and commit design pattern.  Copy-on-write
is usually applied for memory or persistent storage where the write
operations are performed on the copied version of the data and the
original version is kept read-only.

With regard to interrupts and exceptions, the "copy-on-write" for
registers is a little different: the registers are copied/saved to the
memory and kept read-only and the later write operation are performed on
the bare registers because when the interrupt or the exception returns,
the saved version is considered original and restored on return.

In the entry code, the procedure has to use the basic registers to run
the procedure itself,  doing "copy-on-write" for the basic registers
sounds like something of a catch-22 or a chicken-and-egg problem.

Luckily, there are two inherent features that can be used to bootstrap
the procedure and overcome the problem. Firstly, the hardware-entry has
saved the exception head onto the IST stack, which is also a
copy-on-write for the %rflags, %rsp, and %rip registers.  Secondly,
there are scratchable areas to write without needing to save them first.
Scratchable areas are crucial for copy-on-write to do the copy. The IST
stack itself is the scratchable area to save everything and run the
procedure.  The unused part of the target stack is also a scratchable
area to copy the context before committing switching stacks.


4.6 save-touch-replicate-copy-commit assembly line
--------------------------------------------------

Combining the copy-on-write and commit design pattern with the logical
procedure that an atomic-IST-entry is supposed to do (push pt_regs,
copy pt_regs, and switch stacks), the save-touch-replicate-copy-commit
assembly line comes into the world:

save:
To ensure proper handling of registers and data, it is crucial to save
everything before making any changes. This includes multiple save-stages
and must be saved on memory.

save-stage-1: hardware-entry (COW for %rflags, %rsp, %rip):
hardware atomic and saves %rflags, %rsp, %rip, allowing them to be
safely touched afterward.

save-stage-2: push general registers (COW for the general registers):
save all general registers at once since they must be touched during
the atomic-IST-entry procedure. It is recommended to save all general
registers at one go before making any changes to them, otherwise,
it may result in the need for additional save-stages.

save-stage-3: save other things (COW for other things):
If the procedure also touches anything aside from general registers or
scratchable areas, it is necessary to use this stage. This stage is
separate as saving these additional items often involves touching
general registers.  It is not recommended to use it as touching extra
things complicates the atomic-IST-entry.  It is important to note that
if atomic-IST-entry needs to change to kernel GSBASE or kernel CR3 or
SPEC_CTRL, this stage is required.
 

The save operation needs to be designed with the ability to be aborted
and replicated:
  o The save-stages are obviously inherent abortable;
  o Aborted save-stages can be replicated easily as the data has not
    yet been touched and can be replicated and stored in another
    location within nested contexts;
  o Complete save-stages don't need to be replicated directly and the
    complete saved version must be locatable;  the ability in nested
    contexts to identify, locate and access the complete saved data can
    be considered a form of replication;

touch:
Write to the registers or the other data. It can be easily maintained
abortable, replicable, and idempotent with the help of the save-stages.

replicate:
Replicate all the work (save-touch-copy-commit) of the interrupted
atomic-IST-entry.  The replicate operation focuses only on the final
result. The supposed final resulted context of the interrupted
atomic-IST-entry needs to be copied to the target stack, so the
replicate operation directly operates on the copying target which is
still in a scratchable area before commtting to avoid dirtying any
saved area.

Replicating the commit operation does not necessarily mean directly
committing it.  Rather, it involves ensuring that when a nested
atomic-IST-entry returns to the interrupted atomic-IST-entry, it
returns to the commit point by replicating all the work as if the
interrupted aIST had just successfully committed before being
interrupted.

The replicate operation is obviously inherent abortable and replicable.

copy:
(COW for the saved context and prepare the target pt_regs on the target
stack for switching):
Copy all the supposed saved contexts onto the target stack at the
deterministic-located location.  In the implementation, the copy
operation is squashed with the replicate operation since the replicate
operation is designed to directly operate on the copying target.

The copy operation must be abortable and replicable, i.e. the source
must be locatable or replicable and the destination must be locatable
and touchable.

commit:
Commit the copied result and switch to the target stack.  Since
replicating the commit operation does not necessarily mean directly
committing it, the commit operation is actually doing overall-commit: 
  when the ongoing atomic-IST-entry succeeds to commit, all the
  interrupted atomic-IST-entries are also committed right away.

4.7 identify and locate
-----------------------

The atomic-IST-entry code has to identify the types (outmost or nested)
of the atomic-IST-entries, from itself to the outmost atomic-IST-entry.

For each interrupted atomic-IST-entry, the event vector, the saved
context (mainly pt_regs) on the TSS stack, the commit_ip has to be
identified/located, and the information which save-stage it had
completed.

The identifying methods can be implemented based on RSP, RIP, and SSP.
In theory, it is not required to use all of the methods, but using
multiple methods can increase robustness in case the entry code goes
wrong, the hardware goes wrong, or any non-entry code goes wrong
(i.e. buggy code sets RSP to one of the IST stacks). If different
methods give different results, forcedly triggering #DF is the last
resort.

Note, RSP can only be examined when the interrupted context is ring0 and
not in syscall gap.
Note, if there are multiple vectors that share the same IST stack, or
there are multiple instructions in the commit stage, the RIP-based
method must be used.

The current code uses RSP based method only. It is very easy to add the
RIP-based method later.

To easily deterministic-locate the location for copying, only one target
stack is used, and the stack is named IST main stack and shared for all
aIST events.  The atomic-IST-entry copies the pt_regs to the IST main
stack and commit-switches to it. (When you re-read the above paragraphs,
you can replace "the target stack" with "the IST main stack".)  There
might be multiple events on the IST main stack, so the stack is larger.

To make identifying and locating code work correctly, there are
requirements for the code outside the atomic-IST-entry:
  o No SP/IP mess:  Should not set the SP/IP to the IST stacks or IST
    event entry code, and only the code of atomic-IST-entry is running
    on the TSS-configured IST stacks (except #DF's IST stack).
  o leave IST stacks completely: No usable data left when switching off
    the IST stacks.


4.8 Hardware Requirement: not nested in atomic-IST-entry
--------------------------------------------------------

Any aIST event can NOT be nested by itself in atomic-IST-entry. No iret
instruction in atomic-IST-entry to re-enable NMI; No write the specific
MSR to re-enable #MC; No debug allowed in the atomic-IST-entry to
re-trigger #DB; No TDCALL or anything to re-enable #VE, #VC, and #HV.
If any aIST is nested inside a not yet committed atomic-IST-entry, the
hardware should morph it into a double fault or there is a bug in the
hardware.

The identifying code will resort to double fault if this requirement
is not met.


4.9 Copy the supposed saved context
-----------------------------------

With identifying and locating code, we have two types of copies:
copy_outmost() and copy_nested() for the outmost and nested
atomic-IST-entries respectively. And they are implemented in a way that
the code to replicate them is themself. i.e.
	replicate(copy_outmost) = copy_outmost
	replicate(copy_nested)  = copy_nested

copy_outmost:
Do the work as the outmost atomic-IST-entry to copy the supposed pt_regs
of the interrupted context to the IST main stack.  (If the ongoing
atomic-IST-entry is the outmost one, the work is literally doing copy as
the outmost, if not, the work is replicating the outmost.)

The hardware-entry of the outmost atomic-IST-entry has already saved the
exception head of the  pt_regs. If the outmost atomic-IST-entry was
unfortunately interrupted before fully saving all the general registers,
the general registers are untouched and must be saved by one of the
consequent nested atomic-IST-entries. The identifying code can just
examine all the nested atomic-IST-entries to find which one has saved
the general registers.

copy_nested:
Do the work as a nested atomic-IST-entry to copy the supposed pt_regs
of the interrupted context to the IST main stack.

The hardware-entry of the nested atomic-IST-entry has already saved
the exception head of the pt_regs of the interrupted context (inside
the interrupted atomic-IST-entry).  To maintain the atomic attribute
of the atomic-IST-entry, the copy_nested() (of the ongoing nested
atomic-IST-entry) has to replicate all that the interrupted
atomic-IST-entries should have been done till the commit point and
copy the supposed saved context (pt_regs).

To avoid touching any saved pt_regs, the replicating is actually
directly applied on the target pt_regs.

4.10 Full view
--------------

non-atomic-IST-entry context (start point)
+
|     outmost                nested                  nested
|  +-----------+           +-----------+           +-----------+
+> |  event A  | interrupt |  event B  | interrupt |  event C  |
   |  hw entry |     +---> |  hw entry |     +---> |  hw entry |
   +-----+-----+   + |     +-----+-----+   + |     +-----+-----+
         |         | |           |         | |           |
   +-----v-------+ | |     +-----v-------+ | |     +-----v-------+
   |save pt_regs | | |     |save pt_regs | | |     |save pt_regs |
   +-----+-------+ | |     +-----+-------+ | |     +-----+-------+
         |         +-+           |         +-+           |
   +-----v-------+ |       +-----v-------+ |       +-----v-------+
   | identify    | | +-----+ identify    | | +-----+ identify    |
   |             | | |     +-------------+ | |     +-------------+
   |copy_outmost | | |                     | |
   +-----+-------+ | |     +-------------+ | |     +-------------+
         |         | | +-> |copy_nested  | | | +-> |copy_nested  |
   +-----v-------+ + | |   +-----+-------+ | | |   +-----+-------+
   |commit switch|   | |         |         | | |         |
   +-------------+   | |   +-----v-------+ + | |   +-----v-------+
                     | |   |commit switch|   | |   |commit switch|
   +-------------+ <-+ |   +-------------+   | |   +-----+-------+
   |copy_outmost |     |                     | |         |
   +-------------+ +---+ +-------------------+ |         V
                         |                     |  succeed to commit
   +-------------+ <-----+ +-------------+     |    (end point)
   |copy_outmost |         |copy_nested  |     |
   +-------------+ +-----> +-------------+ +---+


Full view with data movement:


(start point)     EventA's  EventB's  EventC's      IST main
+----------+      ISTstack  ISTstack  ISTstack      stack
|          |
|non atomic| <----------------------------------+  +------+
|IST entry | <--------------------------------+ |  |      |
| context  | <---+ +------+                   | |  |      |
|          | <-+ | |ss    | copy outmost      | |  |ss    |context
+---+------+   | +-+rsp   |  exc head         | +--+rsp   |inter-
    |          |   |rflags| ============#     |    |rflags|rupted
    |          +-+ |cs    |             #     +--+ |cs    |by A
+---v---+        +-+rip   |             #copy_   +-+rip   |
|       |hw entry  |ecode |             #outmost   |ecode |
|Event A| ======>  |gp    | <--------+  #======>   |gp    |
|       |ASM push  |regs  |          |  #          |regs  |
|       |(aborted) +------+          |  #          +------+ <+
|       |   ^      |      | +------+ |  #          +------+  |
+---+---+   |      |      | |ss    | |  # copy_    |ss    |  |
    |       |               |rsp   +-+  # nested   |rsp   +--+
    |       +------------+  |rflags| == # ======>  |rflags|
+---v---+                |  |cs    |    #          |cs    | +----+
|       |      hw entry  +--+rip   |copy#outmost   |rip   +-+    v
|Event B|       ======>     |ecode |  gp#regs      |ecode |Event A's
|       |      ASM push     |gp    |====#          |gp    |commit ip
| rep   | <--+ (pushed)     |regs  |               |regs  |
| copy  |    |              +------+ <--------+    +------+ <+
+---+---+    |              |      | +------+ |    +------+  |
    |        |              |      | |ss    | |    |ss    |  |
    |        |                       |rsp   +-+    |rsp   +--+
+---v---+    +--------------------+  |rflags|      |rflags|
|       |                         |  |cs    |copy_ |cs    | +----+
|Event C|        hw entry         +--+rip   |nested|rip   +-+    v
|       |         ======>            |ecode |====> |ecode |Event B's
| rep   |        ASM push            |gp    |      |gp    |commit ip
| copy  |        (pushed)            |regs  |      |regs  |
+---+---+                            +------+  +-> +------+
    |                                |      |  |   |      |
    |                                |      |  |   |      |
    |succeed to                                |   |      |
    |  commit           rsp +------------------+
    +-----------------> rip = Event C's commit ip  final context
                                  (end point)      after commit



4.11 minimal procedure environment
----------------------------------

To avoid complicating atomic-IST-entry too much, the atomic-IST-entry
accesses only the general purpose registers and the stacks which is also
the minimal required environment for a C-function to run.

So the atomic-IST-entry can be possibly running with user GSBASE (so
don't use PERCPU), with KPTI's user CR3 (so don't access outside the CPU
ENTRY AREA), without IBRS bit. Be careful!

It is possible to make the atomic-IST-entry switches GSBASE, CR3, and
SPEC_CTRL, but it will need the save-stage-3, more code to switch GSBASE,
CR3, and SPEC_CTRL, and more code to replicate switching GSBASE, CR3, and
SPEC_CTRL.

4.12 C-function entry code
--------------------------

As seen above, the work of atomic-IST-entry is hard to implement in ASM
code, so the major part of the atomic-IST-entry is implemented in C code
as a C-function. The ASM code does the save-stages and then calls the
C-function.

The C-function has a RET instruction before IBRS_ENTER. I (Lai Jiangshan)
am still searching for why IBRS_ENTER "Must be called before the first
RET instruction" (comments in entry_64.S). No clue so far and needs help.
The only way to fix it is to use save-stage-3 and to make the
atomic-IST-entry switches GSBASE, CR3, and SPEC_CTL. (Not hugely
cumbersome, but I don't like it)


5 Supervisor Shadow stack
-------------------------

The current approach to handling the IST stack (including NMI_executing
and #VC's stack switching) presents a challenge for implementing the
supervisor shadow stack. However, this obstacle is removed by the
introduction of this atomic-IST-entry.

The implementation of the supervisor shadow stack can be accomplished
using a similar software-based atomicall approach. First, a shadow stack
(the IST main shadow stack) must be created and associated with the IST
main stack for each CPU besides shadow stacks for TSS-configured IST
stacks.  Next, the locating code within the atomic-IST-entry can
determine where to write on the IST main shadow stack when identifying
the interrupted context.

The atomic-IST-entry can then write(WRSS) values corresponding to the
copied pt_regs to the IST main shadow stack and save the resulting SSP
on the IST main stack in the extended portion below or above the pt_regs
as if the hardware delivers the event on the IST main stack and the IST
main shadow stack. The commit stage is extended to multiple instructions
that commit both stacks which switches the RSP first and then the shadow
stack (obtained the resulting SSP from the extended portion below or
above the copied pt_regs).

If the multiple-instruction commit stage is interrupted, it is
considered an interrupted atomic-IST-entry, and the RIP-based
identifying and locating code need to travel inside the outer
interrupted atomic-IST-entry. It can also be considered
non-atomic-IST-entry context and affects the identifying and locating
code differently and a special replicating code is needed for this
special non-atomic-IST-entry context which makes it not preferred.

Finally, the code must clear all aIST's shadow stack's busy bits before
entering the handling code to ensure that the shadow stacks are ready
for the next hardware-entry and atomic-IST-entry.

By implementing these steps, the supervisor shadow stack can be
successfully used along with the IST stacks.


6 FRED
------

FRED stands for Flexible Return and Event Delivery, and it is Intel's
attempt to address the problem of switching stacks for super exceptions
among other things such as improving overall performance and response
time and ensuring that event delivery establishes the full supervisor
context and that event return establishes the full user context.

https://cdrdv2-public.intel.com/678938/346446-flexible-return-and-event-delivery.pdf
https://lore.kernel.org/lkml/20230307023946.14516-1-xin3.li@intel.com/

The FRED approach to address the problem of switching stacks for super
exceptions is to introduce the concept of a stack level. The current
stack level (CSL) is a value in the range 0–3 that the processor tracks
when CPL = 0. FRED event delivery determines the stack level associated
with the event being delivered and, if it is greater than the CSL (or if
CPL had been 3), loads the stack pointer (RSP) from a new FRED RSP MSR
associated with the event’s stack level. (If supervisor shadow stacks
are enabled, the stack level applies also to the shadow-stack pointer,
SSP, which would be loaded from a FRED SSP MSR.)  The FRED return
instruction ERETS restores the old stack level. 

Comparing the software atomic-IST-entry and FRED:
  o atomic-IST-entry is focused solely on stack switching for IST events,
    while FRED offers a variety of features. 
  o While, obviously, atomic-IST-entry may not improve overall
    performance and response time like FRED, it also does not worsen it.
    In the fast path where the outmost atomic-IST-entry succeeds to
    commit, the atomic-IST-entry's major work is not much different from
    a normal interrupt.
  o FRED attempts to restore the full supervisor context when entering
    from ring3, while atomic-IST-entry doesn't even handle the supervisor
    GSBASE.  It should be noted that neither atomic-IST-entry nor FRED
    handles CR3 for KPTI or RCU or other context-tracking bits.  GSBASE
    is not more crucial than CR3 and less crucial than stacks which is
    the minimal basic environment for everything else.
  o While FRED may only be available on future platforms,
    atomic-IST-entry is available on all  existing x86_64 platforms,
    including non-Intel platforms.

In total, atomic-IST-entry can only do atomic stack switching for IST,
while FRED provides more abilities. If you have FRED, just use it.  If
you don't, just don't fret too much either.


7 summary
---------

There are multiple gaps in event delivery:
1) stack gap type 1 (syscall gap): RSP is not kernel RSP (on syscall
   event)
2) stack gap type 2 (reentrance safe gap): the stack is in danger of
   corruption by nested super events.
3) GSBASE gap: GSBASE is not kernel GSBASE
4) CR3 gap: CR3 is not kernel CR3
5) IBRS gap: SPEC_CTRL_IBRS bit is not set for kernel
6) RCU gap: RCU is not enabled for kernel
7) MSR gap: some other MSR is switched to the corresponding kernel MSR
   value
8) kernel context gap: some other context is not switched to the kernel
   context 

Gaps 3-8 are robustly solved by the noinstrument facility with careful
interrupted context tracking (paranoid_entry and .Lerror_bad_iret are
among the examples) and build-time objtools checking.  They are not as
essential and tough as stack gaps (maybe except for the IBRS gap).

Gap1(stack gap type 1, syscall gap) could have been addressed by
hardware, ensuring a proper kernel RSP on syscall event, as demonstrated
by FRED. The gap is short and contained by the entry/noinstrument
acility, only presenting issues in the face of super events, which can
be solved by IST. However, IST causes the issue of Gap 2.

Gap2(stack gap type 2, reentrance safe gap) must be addressed on any
system that wants to switch stacks on super events. FRED's solution
involves using kernel stack levels.  On a system without kernel stack
levels,  gap2 can be robustly solved now by this new atomic-IST-entry
and noinstrument facility. Actually, atomic-IST-entry can be considered
a special form of kernel stack levels. The #DF stack is the highest
stack level, IST main stack for other super events is a less highest
stack level, and all the other events are assigned with the lowest
stack level.

If gap5(IBRS gap) is problematic within atomic-IST-entry, which uses
a RET instruction, save-stage-3, and corresponding touching (writing
the MSR) and replicating code should be added into atomic-IST-entry.

Lai Jiangshan (7):
  x86/entry: Move PUSH_AND_CLEAR_REGS out of paranoid_entry
  x86/entry: Add IST main stack
  x86/entry: Implement atomic-IST-entry
  x86/entry: Use atomic-IST-entry for NMI
  x86/entry: Use atomic-IST-entry for MCE and DB
  x86/entry: Use atomic-IST-entry for VC
  x86/entry: Test atomic-IST-entry via KVM

 Documentation/x86/kernel-stacks.rst   |   2 +
 arch/x86/entry/Makefile               |   3 +
 arch/x86/entry/entry_64.S             | 615 +++++++-------------------
 arch/x86/entry/ist_entry.c            | 299 +++++++++++++
 arch/x86/include/asm/cpu_entry_area.h |   8 +-
 arch/x86/include/asm/idtentry.h       |  15 +-
 arch/x86/include/asm/sev.h            |  14 -
 arch/x86/include/asm/traps.h          |   1 -
 arch/x86/kernel/asm-offsets_64.c      |   7 +
 arch/x86/kernel/callthunks.c          |   2 +
 arch/x86/kernel/dumpstack_64.c        |   6 +-
 arch/x86/kernel/nmi.c                 |   8 -
 arch/x86/kernel/sev.c                 | 108 -----
 arch/x86/kernel/traps.c               |  43 --
 arch/x86/kvm/vmx/vmx.c                | 441 +++++++++++++++++-
 arch/x86/kvm/x86.c                    |  10 +-
 arch/x86/mm/cpu_entry_area.c          |   2 +-
 tools/objtool/check.c                 |   7 +-
 18 files changed, 937 insertions(+), 654 deletions(-)
 create mode 100644 arch/x86/entry/ist_entry.c


base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
2.19.1.6.gb485710b

