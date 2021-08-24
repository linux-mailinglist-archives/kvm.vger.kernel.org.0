Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CF63F5D5A
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhHXLxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236614AbhHXLxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:53:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 493B061246
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629805967;
        bh=A6DZ6tlFEhpGh4vmU1kNSMWwzVJEgQKEx71NLcJAMAk=;
        h=From:To:Subject:Date:From;
        b=bu2Od9lxp6Y0O+c30sCemACg577dhKBJ/HSH+pqWe6Cg7/j6fjDapgryvdz1S9CVF
         0FQjz9giqfsWFLPeasxSguINqt6/DH6yUTPCD4M24ZZrr5BGf2yBXtupgJDbNMg5QF
         eHhA33YCgHSIc1VqWyx9zPA7B+B/ct/pu4IrupqEzWmbrXMG8hhneDtl/za/snouJa
         xKanPvBiodsbMQ33Bf3zXLNG2oZli5A2gvqWkoPCKoTLVuqSuQdGO3mks3c0Em0v7h
         PSM7yCPnBHkRKa8AZX6+knPlwVhxryY6hQXaqOjR9qJWu74CrghAXjDcNmuPanuhKM
         4xhC9chp7RgYg==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 424C860FF2; Tue, 24 Aug 2021 11:52:47 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 214165] New: Missing clflush before RECEIVE_UPDATE_DATA
Date:   Tue, 24 Aug 2021 11:52:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: masa.koz@seera-networks.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-214165-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214165

            Bug ID: 214165
           Summary: Missing clflush before RECEIVE_UPDATE_DATA
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.13.12
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: masa.koz@seera-networks.com
        Regression: No

Created attachment 298457
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D298457&action=3Dedit
Add the missing sev_clflush_pages()

In sev_receive_update_data(), sev_clflush_pages() is not called b/w
sev_pin_memory() and RECEIVE_UPDATE_DATA. Because of this missing, we will
often see the pre-written contents in the memory updated by
RECEIVE_UPDATE_DATA. I guess that we should call sev_clflush_pages() as
LAUNCH_UPDATE_DATA.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
