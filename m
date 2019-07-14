Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B6267FE8
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 17:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfGNPmI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 14 Jul 2019 11:42:08 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34902 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726783AbfGNPmI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Jul 2019 11:42:08 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 50DF427BA5
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2019 15:42:07 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 44AE027F2B; Sun, 14 Jul 2019 15:42:07 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204175] New: Segmentation: incorrect base calculation in VMX
Date:   Sun, 14 Jul 2019 15:42:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: max@m00nbsd.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-204175-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204175

            Bug ID: 204175
           Summary: Segmentation: incorrect base calculation in VMX
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.*
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: max@m00nbsd.net
        Regression: No

In vmx/nested.c::get_vmx_mem_address(), when the guest runs in long mode, the
base address of the memory operand is computed with a simple:

    *ret = s.base + off;

This is incorrect, the base applies only to FS and GS, not to the others.

Because of that, if the guest uses a VMX instruction based on DS and has a
DS.base that is non-zero, KVM wrongfully adds the base to the resulting
address.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
