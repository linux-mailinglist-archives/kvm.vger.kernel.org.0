Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F11554A51
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbiFVMuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 08:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiFVMuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 08:50:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B1F10F
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 05:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84980B81EB7
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2802DC341C0
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655902200;
        bh=K+qXRRKpRXjFQF4+dRTdNR4ZmvCuM0LE7eww9arsRcI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=T3va+aKHkeGVvu8kfCChYlmZAaetUPkEo+nprlxCCpuDSsWnX6hlzvbxq/axuA03E
         EcpxlV4v1oNhRfrdgxEtr0hLZEqHHtt8N2fK/pEZArOHATwYy6B7V5KnOy5upi1Poi
         ORWAguCPttof8J56kRiFS8J59uuXIN3L7pFu1eEbQPNJJnNjhJCCLpyhfzOFQ8sVNo
         0ArilxRWnHLvb5FfyJqaJFeefMHs+mYn43FYDoHbalv2III8XWL2xSBmzvRuAFEs4c
         s+q5icyZ/Mp3XmvL4AOHqZnVsyXIBWBsN+2vpzcxdYkXAlq0g1lvvY+eQFOZKXZvwK
         WeCKY8FyAR7gA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 018A5C05FF5; Wed, 22 Jun 2022 12:50:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213781] KVM: x86/svm: The guest (#vcpu>1) can't boot up with
 QEMU "-overcommit cpu-pm=on"
Date:   Wed, 22 Jun 2022 12:49:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: like.xu.linux@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-213781-28872-Xt10WwYFfk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213781-28872@https.bugzilla.kernel.org/>
References: <bug-213781-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213781

Like Xu (like.xu.linux@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.14.0-rc1+                 |5.19.0-rc1+

--- Comment #4 from Like Xu (like.xu.linux@gmail.com) ---
The issue still exits on the AMD after we revert the commit in 31c25585695a.

Just confirmed that it's caused by non-atomic accesses to memslot:
- __do_insn_fetch_bytes() from the prot32 code page #NPF;
- kvm_vm_ioctl_set_memory_region() from user space;

Considering the expected result [selftests::test_zero_memory_regions on x86=
_64]
is that the guest will trigger an internal KVM error due to the initial code
fetch encountering a non-existent memslot and resulting in an emulation
failure.

More similar cases will gradually emerge. I'm not sure if KVM has documenta=
tion
pointing out this restriction on memslot updates (fix one application QEMU =
may
be one-sided), or any need to add something unwise like check
gfn_to_memslot(kvm, gpa_to_gfn(cr2_or_gpa)) in the x86_emulate_instruction(=
).

Any other suggestions ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
