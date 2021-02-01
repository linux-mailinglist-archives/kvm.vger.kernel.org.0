Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA8830A569
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 11:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhBAKck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 05:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhBAKci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 05:32:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A22D464DD8
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 10:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612175517;
        bh=bl/uCuqN6Of9M6YmehpOuSSgQ+VCOyFyq6KmP7EEXY8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GtwuA8LVtl9LvZCU2vz6Ct2t0IAw3QTTyqHd04RnPGRXRD27u1vxfinSSRKvVQQI5
         UxksEPAGem4Ud71PvxMIySdokDZmVO9B9MWCuuIgoVFmGC1Yhxv9drFBVd38qfyJrp
         1CkgKtPmVo0IoZ1BoijNfWLWwVYDQ+81iWxV9OnZ53EdGKDLSBdgl/C74/kDtpJOQd
         T2d7ZimPKpG7QsUiuHJstlBZqLgvA26TFFb2KZBSZq1LR1iSeiIfsu/T4LPL2MLFTE
         oPA1gvWBuCr/4/QlTLs1KT4CEOI2UROjl74nU/AFo59rPaWvhtXe0OF6CunwunnGpf
         cqVx0fthgd7gg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 8F58265303; Mon,  1 Feb 2021 10:31:57 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 211467] Regression affecting 32->64 bit SYSENTER on AMD
Date:   Mon, 01 Feb 2021 10:31:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jonny@magicstring.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.isobsolete attachments.created
Message-ID: <bug-211467-28872-D4GyC4pvy9@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211467-28872@https.bugzilla.kernel.org/>
References: <bug-211467-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211467

jonny5532 (jonny@magicstring.co.uk) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
 Attachment #294993|0                           |1
        is obsolete|                            |

--- Comment #3 from jonny5532 (jonny@magicstring.co.uk) ---
Created attachment 295027
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D295027&action=3Dedit
Patch with whitespace fix and SOB

Thanks for confirming, here's the same patch again without the missing newl=
ine
and with my SOB tacked on the bottom. I am indeed not set up for sending
patches so would appreciate it if you could do that bit.

I had a look through emulate.c to see if I could foresee any unintended side
effects - it seems that SYSEXIT already handles the potential transition ba=
ck
from 64->32 bits.=20

I do note that some of the transitions to PROT64 are wrapped in "#ifdef
CONFIG_X86_64 ... #endif", for example in em_syscall. However that looks pr=
etty
dubious in itself - if em_syscall gets run with the guest in long mode, on =
a 32
bit kernel, then it'll just fail to update the EIP but carry on regardless.
Probably an unlikely scenario however (KVM on AMD has only ever worked on 64
bit procs as I understand).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
