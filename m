Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D9F536FB7
	for <lists+kvm@lfdr.de>; Sun, 29 May 2022 06:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiE2EsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 May 2022 00:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiE2EsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 May 2022 00:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB37B590B3
        for <kvm@vger.kernel.org>; Sat, 28 May 2022 21:48:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2781F60DBB
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 04:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7BF92C3411D
        for <kvm@vger.kernel.org>; Sun, 29 May 2022 04:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653799693;
        bh=e/5YqpuBMe5NLk6haQT5183V1/0M+ZMtFBNrGEvyV48=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TmhOJp3xHBy/Z6+jeMbNoj/GXrLBBqoWajg+6Nz/S/H43LGteOviQO4ZTAC7mECdp
         +QbEhyyU3x9hQrHrffsTjypCxQMN1/CzMXXDYRoZ/5xeo1MfoLaf/xLSJ0AaqAT0dn
         F/lO7aQGOuzGWMNWJ6QNFVROIQCcl+bdotKl27xaFuHKK5UzE4l2Sjy/PJ1UsePj+U
         HIKDbRN+A0FzVMCJHaFuUfbHgwfc1wzmEH1eoKWBttpJwZSK1mu2qN8fYI7HNAQLX5
         VuAta7Oi86/2W6j6ZNqK/t7eenb5OWRc7SECNWkl6h9movOBm/kh/ZVZIaJ40cSF6v
         rdVksup/ltHjA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 6609BCC13AD; Sun, 29 May 2022 04:48:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216045] KVM x2APIC virtualization causes EOI to be ignored
Date:   Sun, 29 May 2022 04:48:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216045-28872-VvH7MyoVHg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216045-28872@https.bugzilla.kernel.org/>
References: <bug-216045-28872@https.bugzilla.kernel.org/>
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

--- Comment #1 from Eric Li (ercli@ucdavis.edu) ---
Explanation of guest behavior

1. BIOS boots XMHF
2. XMHF starts GRUB as a nested guest
3. GRUB by default boots Debian (5 seconds timeout)
4. Debian executes 0xffffffff81062179 (can set a hardware breakpoint using
GDB). At this instruction is a WRMSR to 0x80b (IA32_X2APIC_EOI)
5. The WRMSR instruction above will VMEXIT to hypervisor mode (XMHF). The
VMEXIT entry point is 0x10206411 (xmhf_parteventhub_arch_x86vmx_entry)
6. At 0x10206434, the hypervisor calls 0x10207eb9
xmhf_parteventhub_arch_x86vmx_intercept_handler()
7. At 0x10208390, the hypervisor calls 0x10206d9f _vmx_handle_intercept_wrm=
sr()
8. At 0x102070c6, the hypervisor performs WRMSR to 0x80b. The intention is =
to
forward EOI from the guest (Debian) to KVM. Before WRMSR, "info lapic" in Q=
EMU
gives

...
ISR      48
IRR      48

9. After WRMSR, RIP lands at 0x102070c8. "info lapic" in QEMU gives

...
ISR      48
IRR      48

However, I am expecting it to give

...
ISR      (none)
IRR      48

10. After a lot of instructions, the nested Debian guest halts. "info lapic=
" is

...
ISR      236
IRR      48 236 253

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
