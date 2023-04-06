Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57E66D8E3C
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 06:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbjDFEJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 00:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbjDFEJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 00:09:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039B810C1
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 21:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD5360301
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 04:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0887DC4339B
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 04:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680754143;
        bh=nP9PpQie04Dom0UG8H3bDpc3Jheta6/A+9PxCKulSPI=;
        h=From:To:Subject:Date:From;
        b=JxYz2Rn80tO/MCQeUtCVbWjfWCRU3CUNCyb1auHleOSXMQ+DjWnRKSQ7xoEBjovpc
         OgOefJjmorsI1pbZDRWxrg9qCzGnLO790SgKMJY2Oz1Acncffpmq9NnmnLhL2PkyBn
         3kIQt07uLLl95v3xw4YlFSysV7keJS745HNEkgluUbhK6+4SucVOx5Llhw7l8xG8At
         kfSEMLFHfpZEhuK/oOMIVhHxGpETzUZI3oZn8Oy4yJA1aDDTInIWQB18sTBFFCIFV8
         o891DXfTdiOEE7DHlax1/ZPrlkPV3Vk6VRQO6yNsZfWd1dAKPOdkrcYIywcbJCgrH1
         UvE3FdzScUJYw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id E9C21C43142; Thu,  6 Apr 2023 04:09:02 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217304] New: KVM does not handle NMI blocking correctly in
 nested virtualization
Date:   Thu, 06 Apr 2023 04:09:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiaoyi13691419520@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-217304-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217304

            Bug ID: 217304
           Summary: KVM does not handle NMI blocking correctly in nested
                    virtualization
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: lixiaoyi13691419520@gmail.com
        Regression: No

Created attachment 304088
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D304088&action=3Dedit
LHV image to reproduce this bug (c.img), compressed with xz

CPU model: 11th Gen Intel(R) Core(TM) i7-1165G7 @ 2.80GHz
Host kernel version: 6.2.8-200.fc37.x86_64
Host kernel arch: x86_64
Guest: a micro-hypervisor (called LHV, 32-bits), which runs a 32-bit guest
(called "nested guest").
QEMU command line: qemu-system-x86_64 -m 192M -smp 2 -cpu Haswell,vmx=3Dyes
-enable-kvm -serial stdio -drive media=3Ddisk,file=3Dc.img,index=3D1
This bug still exists if using -machine kernel_irqchip=3Doff
This problem cannot be tested with -accel tcg , because the guest requires
nested virtualization

To reproduce this bug:

1. Download c.img.xz (attached with this bug), decompress to get c.img. Rel=
ated
source code of this LHV image is in
https://github.com/lxylxy123456/uberxmhf/blob/a12638ef90dac430dd18d62cd29aa=
967826fecc9/xmhf/src/xmhf-core/xmhf-runtime/xmhf-startup/lhv-guest.c#L871
.

2. Run the QEMU command line above

3. See the following output in serial port (should be within 10 seconds):

Detecting environment
    QEMU / KVM detected
End detecting environment
Experiment: 13
  Enter host, exp=3D13, state=3D0
    hlt_wait() begin, source =3D  EXIT_NMI_H   (5)
      Inject NMI
      Interrupt recorded:       EXIT_NMI_H   (5)
    hlt_wait() end
    hlt_wait() begin, source =3D  EXIT_TIMER_H (6)
      Inject interrupt
      Interrupt recorded:       EXIT_TIMER_H (6)
    hlt_wait() end
  Leave host
  Enter host, exp=3D13, state=3D1
    hlt_wait() begin, source =3D  EXIT_NMI_H   (5)
      Inject NMI
      Strange wakeup from HLT
      Inject interrupt
      Interrupt recorded:       EXIT_TIMER_H (6)
(empty line)
source:      EXIT_NMI_H   (5)
exit_source: EXIT_TIMER_H (6)
TEST_ASSERT '0 && (exit_source =3D=3D source)' failed, line 365, file lhv-g=
uest.c
qemu: terminating on signal 2

The expected output is (reproducible on real Intel CPUs with >=3D 2 CPUs):

Detecting environment
End detecting environment
Experiment: 13
  Enter host, exp=3D13, state=3D0
    hlt_wait() begin, source =3D  EXIT_NMI_H   (5)
      Inject NMI
      Interrupt recorded:       EXIT_NMI_H   (5)
    hlt_wait() end
    hlt_wait() begin, source =3D  EXIT_TIMER_H (6)
      Inject interrupt
      Interrupt recorded:       EXIT_TIMER_H (6)
    hlt_wait() end
  Leave host
  Enter host, exp=3D13, state=3D1
    hlt_wait() begin, source =3D  EXIT_NMI_H   (5)
      Inject NMI
      Interrupt recorded:       EXIT_NMI_H   (5)
    hlt_wait() end
    iret_wait() begin, source =3D EXIT_MEASURE (1)
    iret_wait() end
    hlt_wait() begin, source =3D  EXIT_TIMER_H (6)
      Inject interrupt
      Interrupt recorded:       EXIT_TIMER_H (6)
    hlt_wait() end
  Leave host
Experiment: 1
... (endless)

Explanation:

Assume KVM runs in L0, LHV runs in L1, the nested guest runs in L2.

The code in LHV performs an experiment (called "Experiment 13" in serial
output) on CPU 0 to test the behavior of NMI blocking. The experiment steps
are:
1. Prepare state such that the CPU is currently in L1 (LHV), and NMI is blo=
cked
2. Modify VMCS12 to make sure that L2 has virtual NMIs enabled (NMI exiting=
 =3D
1, Virtual NMIs =3D 1), and L2 does not block NMI (Blocking by NMI =3D 0)
3. VM entry to L2
4. L2 performs VMCALL, get VM exit to L1
5. L1 checks whether NMI is blocked.

The expected behavior is that NMI should be blocked, which is reproduced on
real hardware. According to Intel SDM, NMIs should be unblocked after VM en=
try
to L2 (step 3). After VM exit to L1 (step 4), NMI blocking does not change,=
 so
NMIs are still unblocked. This behavior is reproducible on real hardware.

However, when running on KVM, the experiment shows that at step 5, NMIs are
blocked in L1. Thus, I think NMI blocking is not implemented correctly in K=
VM's
nested virtualization.

I am happy to explain how the experiment code works in detail. c.img also
reveals other NMI-related bugs in KVM. I am also happy to explain the other
bugs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
