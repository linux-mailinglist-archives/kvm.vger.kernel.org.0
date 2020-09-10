Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5642F26499C
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 18:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIJQWi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Sep 2020 12:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgIJQVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 12:21:43 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209079] CPU 0/KVM: page allocation failure on 5.8 kernel
Date:   Thu, 10 Sep 2020 16:21:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: OBSOLETE
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209079-28872-tyP4xlpo0I@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209079-28872@https.bugzilla.kernel.org/>
References: <bug-209079-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209079

--- Comment #4 from Sean Christopherson (sean.j.christopherson@intel.com) ---
GFP_DMA32 is a flag that forces a memory allocation to use physical memory that
is 32-bit addressable, i.e. below the 4g boundary.  Using GFP_DMA32 is
relatively uncommon, e.g. KVM uses that flag if and only if KVM is using or
shadowing 32-bit PAE paging.  The latter case (shadowing) is what is triggered
if NPT is disabled.

Can you try trying running with "kvm_amd nested=0 avic=1 npt=0" and/or "kvm_amd
nested=0 npt=0" on v5.8.7?  I'd like to at least confirm that whatever was
breaking your setup was fixed between v5.8.0 and v5.8.7, even if we don't
bisect to identify exactly what patch fixed the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
