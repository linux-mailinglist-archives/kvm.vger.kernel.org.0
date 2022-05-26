Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD4E5351EB
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbiEZQSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 12:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiEZQSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 12:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D313F6CA8B
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BE65B8211F
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 16:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5139CC34118
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 16:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653581916;
        bh=wbX8aCqdWvpGTgXiy4puhdam9EDep5SY3t/d6xba79k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hK5QPP0yWQbDFCxXa+LfBi6Cx3a1YqYc8x5YDAK+WH7qDaluxvZSxsg1SPG9/SsjI
         8UqNmg4fDFb5XNDaWW5sxXqfnJv7jKeg6/lPc7d/e6aQBU/uvcwB2bwLgij3cPoqst
         17oUxilexq0jtWjvBrN6xJkm/hS1BHZjIsoZ+oFZQIDpt4RTHvuo9r/XzAK/MVMCHY
         POo8j+Un/Md6nYEeBqATCF0QbBuoCXan/fTqelaGsu+xLybvgio1fUKXrMgJNr5lnX
         sP17Q3FarwUrDSYY7+JZSTiTC8RFvnH6qSTqZraQIPIuwJegIJvjSQhg35sjD8twSp
         0Qp3y78V6rZlg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 395A9C05FD2; Thu, 26 May 2022 16:18:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216033] KVM VMX nested virtualization: VMXON does not check
 guest CR0 against IA32_VMX_CR0_FIXED0
Date:   Thu, 26 May 2022 16:18:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-216033-28872-DeJ3APpi6P@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216033-28872@https.bugzilla.kernel.org/>
References: <bug-216033-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216033

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
Ugh, KVM is comically wrong.  It _deliberately_ avoids checking CR0/CR4 wit=
h a
comment saying that "most faulting conditions have already been checked by
hardware", but the SDM pseudocode makes it very clear that only the (CR0.PE=
 =3D
0) or (CR4.VMXE =3D 0) or (RFLAGS.VM =3D 1) or (IA32_EFER.LMA =3D 1 and CS.=
L =3D 0)
checks are performed before the VM-Exit occurs.

        /*
         * The Intel VMX Instruction Reference lists a bunch of bits that a=
re
         * prerequisite to running VMXON, most notably cr4.VMXE must be set=
 to
         * 1 (see vmx_is_valid_cr4() for when we allow the guest to set thi=
s).
         * Otherwise, we should fail with #UD.  But most faulting conditions
         * have already been checked by hardware, prior to the VM-exit for
         * VMXON.  We do test guest cr4.VMXE because processor CR4 always h=
as
         * that bit set to 1 in non-root mode.
         */
        if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
                kvm_queue_exception(vcpu, UD_VECTOR);
                return 1;
        }

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
