Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E7E536F7C
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 06:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiE2E1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 00:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiE2E1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 00:27:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B3BB0D39
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 21:27:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E5A4B80936
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 04:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC4D3C385B8
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 04:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653798418;
        bh=oJiVJbI0ZYgTwtEB9FGM0Do+6uqGYS5hSbhhRVTBTPw=;
        h=From:To:Subject:Date:From;
        b=ZUErf28fGclvYyszcudWxRo14gZ9DYhST02U7u4idYZqImnsG5dIN/YrCn0/jRvbc
         kg+ggIuwAfg79mV765iRVF1xpPTkRLOkYVjj/YoOdcxMX7QsgG9ZGUIiDkIZjMvP0D
         MPQKGWna+8CJX3RTQlIwpGnEaUT4/Bl9kilQOVnJAqy3pJVJ12pJtmxDhmXyTbD4nG
         XCnAgx4dFeGVu2iCaJYuJgZdT1sMTbvMVTuN7/PFN4l2eqtvp6txYCsSkkiN1Q4R6K
         TB0zygQQ8i4+CefKqp+fkigpEoDpoTOJiYH6VOJtjR4kOv14mzJ8PDSYVRmGZhT1zT
         7Uaz9LrJFXUdQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C5F7EC05FD2; Sun, 29 May 2022 04:26:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216045] New: KVM x2APIC virtualization causes EOI to be ignored
Date:   Sun, 29 May 2022 04:26:58 +0000
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
Message-ID: <bug-216045-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216045

            Bug ID: 216045
           Summary: KVM x2APIC virtualization causes EOI to be ignored
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.17.9
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: ercli@ucdavis.edu
        Regression: No

Created attachment 301071
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D301071&action=3Dedit
Guest hypervisor to reproduce this bug (xz compressed)

CPU model: 11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
Host kernel version: 5.17.9
Host kernel arch: x86_64
Guest: a micro-hypervisor (called XMHF), which runs Linux (64-bit Debian,
5.10.0-9-amd64)
QEMU command line: qemu-system-x86_64 -m 512M -smp 2 -cpu Haswell,vmx=3Dyes
-enable-kvm -serial stdio -drive media=3Ddisk,file=3Dc.img,index=3D1 -drive
media=3Ddisk,file=3Ddebian11x64.qcow2,index=3D2
The problem goes away if using -machine kernel_irqchip=3Doff
This problem cannot be tested with -accel tcg , because the guest requires
nested virtualization

Files used to reproduce this bug:

debian11x64.qcow2 (3.3G) is uploaded at
https://drive.google.com/uc?id=3D1LtUwnzH8pDvjoBhJhxk5wIz9_UTlGaBA . It sho=
uld be
equivalent to a freshly installed Debian 5.10.0-9-amd64 on QEMU. Its kaslr =
is
disabled for debugging convenience.

c.img (8M) is uploaded at
https://drive.google.com/uc?id=3D1g3c9KMAoh_Yvb9bzSuOBMG5L-2VX6twU . It is =
also
compressed as c.img.xz and uploaded with this bug. It is built from
https://github.com/lxylxy123456/uberxmhf/tree/ab7968ed8017f4397808186252663=
6f75c80a3b7
.

Actual behavior:

After running the QEMU command above, the hypervisor (XMHF) will boot and t=
hen
chain load Debian as a guest OS. Debian starts to boot and stuck. In QEMU's
monitor, if I enter "info lapic", I see

...
ISR      253
IRR      48 236 253

Expected behavior:

When running the QEMU command above, the hypervisor should boot Debian, and
Debian should boot successfully. The VGA screen should show "debian login:".

The expected behavior can be achieved in a few ways:
1. Remove "-drive media=3Ddisk,file=3Dc.img,index=3D1" from QEMU command li=
ne. This
will boot Debian directly (instead of booting XMHF and then boot Debian)
2. Add "-machine kernel_irqchip=3Doff" to the QEMU command line
3. Apply the following patch to KVM and re-compile. This patch will let KVM
think that x2APIC virtualization is not available.

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilitie=
s.h
index 3f430e218..29b412ae4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -157,8 +157,7 @@ static inline bool cpu_has_vmx_rdtscp(void)

 static inline bool cpu_has_vmx_virtualize_x2apic_mode(void)
 {
-       return vmcs_config.cpu_based_2nd_exec_ctrl &
-               SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
+       return 0;
 }

 static inline bool cpu_has_vmx_vpid(void)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
