Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB0E68003
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfGNQIs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 14 Jul 2019 12:08:48 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35586 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726783AbfGNQIs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Jul 2019 12:08:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id F008727EED
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2019 16:08:46 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id D250127F86; Sun, 14 Jul 2019 16:08:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204177] New: PT: Missing filtering on the MSRs
Date:   Sun, 14 Jul 2019 16:08:46 +0000
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
Message-ID: <bug-204177-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=204177

            Bug ID: 204177
           Summary: PT: Missing filtering on the MSRs
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

In vmx.c::vmx_get_msr(), there is some missing filtering on the PT (RTIT) MSRs.
For example RTIT_CR3_MATCH:

        case MSR_IA32_RTIT_CR3_MATCH:
                if ((pt_mode != PT_MODE_HOST_GUEST) ||
                        (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) ||
                        !intel_pt_validate_cap(vmx->pt_desc.caps,
                                                PT_CAP_cr3_filtering))
                        return 1;
                vmx->pt_desc.guest.cr3_match = data;
                break;

Here, 'cr3_match' is set to the value given by the guest. Later, in
pt_load_msr(), there is a blunt WRMSR:

        wrmsrl(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);

The Intel SDM indicates that

        "IA32_RTIT_CR3_MATCH[4:0] are reserved and must be 0; an attempt to
         set those bits using WRMSR causes a #GP."

Given that KVM does not ensure that the aforementioned bits are zero, it seems
that the guest could #GP the host.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
