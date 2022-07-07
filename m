Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E047569845
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 04:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiGGCiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 22:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbiGGCit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 22:38:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372752CE3A
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 19:38:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEDE9B81FAE
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 02:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EAAEC341E5
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 02:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657161525;
        bh=UpmITv01uWNNXw/eAYaBwXCLwNSDAaT40djLruIAT0o=;
        h=From:To:Subject:Date:From;
        b=NxpM7peekPp8PAiQxSacgUQt8zr/R8lxnrJju4J70jAO6lw3sdsEZqKw3y5LHpmYS
         cWcejZg20iQs8bwLk1oCcNUndt/BkYv24WJBbipyulfshkbl1OMppC4dRpWJ6ktQ4Z
         KLLCJAZ+iLZ1eEyxeRWndJSH1KxJkFT5BOj16YDRiTM+TBFpreoleKonj2lRHOIUhr
         tR9L1QGiL6yM4S3eVAc0MvKQC4l6Tg/wJ2EsKiOJFtosP56Fq49KXwJ34jYT2j9qWR
         HqKiuChOGxZtdbA9PuntUOZ/mBIMi3AnZssYvv8qqSlL1m9JfZu/4OOUpjbCP2kTNK
         YF0c5foEbwhZA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5B5D7CC13B7; Thu,  7 Jul 2022 02:38:45 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216212] New: KVM does not handle nested guest enable PAE paging
 correctly when CR3 is not mapped in EPT
Date:   Thu, 07 Jul 2022 02:38:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ercli@ucdavis.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-216212-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216212

            Bug ID: 216212
           Summary: KVM does not handle nested guest enable PAE paging
                    correctly when CR3 is not mapped in EPT
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.18.9
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ercli@ucdavis.edu
        Regression: No

Created attachment 301352
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301352&action=3Dedit
LHV image used to reproduce this bug (lhv-231a25f7f.img)

CPU model: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
Host kernel version: 5.18.9
Host kernel arch: x86_64
Guest: a micro-hypervisor (called LHV, 32-bits), which runs a 32-bit guest
(called "nested guest").
QEMU command line: qemu-system-x86_64 -m 256M -smp 1 -cpu Haswell,vmx=3Dyes
-enable-kvm -serial stdio -drive media=3Ddisk,file=3Dlhv-231a25f7f.img,inde=
x=3D1
This bug still exists if using -machine kernel_irqchip=3Doff
This problem cannot be tested with -accel tcg , because the guest requires
nested virtualization

How to reproduce:

1. Download lhv-231a25f7f.img (attached with this bug). Source code of this=
 LHV
image is in
https://github.com/lxylxy123456/uberxmhf/tree/231a25f7f49589618be0faac77a39=
bc593a62758
.

2. Run the QEMU command line above

3. See "BAD" printed in the VGA screen at row 20 column 0-2. The last line =
of
serial output is:

Fatal: Halting! Condition '0 && "Guest received #UD (incorrect behavior)"'
failed, line 26, file lhv-guest.c

Expected behavior (reproducible on real hardware and Bochs):

See "GOOD" printed in the VGA screen at row 21 column 0-3. The last line of
serial output should be:

Fatal: Halting! Condition '0 && "hypervisor receives CR3 EPT (correct
behavior)"' failed, line 375, file lhv-vmx.c


Explanation:

In KVM terms, KVM is L0, LHV is L1, nested guest is L2.

LHV runs the nested guest with:

* EPT enabled.
* Unrestricted guest enabled.
* CR0 guest/host mask (VMCS encoding 0x6000) does NOT set CR0_PG bit.
* Most of EPT is identity mapping, but the page pointed to by nested guest's
CR3 is not present in EPT.
* The nested guest uses PAE paging.
* Let the nested guest enable paging by setting CR0.PG.

When the nested guest enables paging, LHV should receive an EPT violation
(correct behavior), because enabling paging requires reading CR3. However, =
in
KVM, the nested guest receives an #GP exception, as if the MOV CR0 instruct=
ion
fails.


Likely stack trace and cause of this bug (Linux source code version is 5.18=
.9):

Stack trace:

handle_cr
    kvm_set_cr0
        load_pdptrs
            kvm_translate_gpa
    kvm_complete_insn_gp
        kvm_inject_gp

What happened:

* When nested guest sets CR0.PG, handle_cr() in KVM is called.
* handle_cr() calls handle_set_cr0().
* is_guest_mode(vcpu) is true, so kvm_set_cr0() is called.
* kvm_set_cr0() calls load_pdptrs().
* load_pdptrs() calls kvm_translate_gpa().
* Since LHV does not set the page for CR3 in EPT, kvm_translate_gpa() fails.
* load_pdptrs() returns 0.
* kvm_set_cr0() returns 1.
* handle_set_cr0() returns 1.
* handle_cr() receives an error, so it injects #GP to the nested guest.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
