Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C8D5AB86A
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiIBSjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 14:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIBSjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 14:39:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C8F10F0AB
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 11:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D999862281
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 18:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FD25C433D6
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662143955;
        bh=32bT2p3J0EE6RW+UilhXK4/NQQF1IEjl8/l3QZgrieI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hqFxunLIrMcvOLK57hlOAYBej46ueUkLWXQ2GrKpO9bbkQTeGndc+yErnI0sohwFZ
         JsfwVGJkoqiZvhi/wCEtKVR2rHTfm0Py3izQxOU3zHltCufhB2pJwKELaLxnXnsBsj
         40xDSdckniJCt4XA/7Ik5Vyjj76VIwDBd2fVlt4I7QuwGRfOwMN9UQLQtXkfhvCRQ8
         2g/4mHIvU/TWWdlZvkCuQadGkW2iLPwNFckonRRl/V+0MVzAiGHpR5KZdl5iCRC5gy
         m7FoLJcF4FlqykKOhZhYvlDF//FoicLV9NWTbxVmtB0izaAeXbojrnlR7cBCnLAPBv
         nnbyimeRkIUfQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2594FC433E6; Fri,  2 Sep 2022 18:39:15 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216033] KVM VMX nested virtualization: VMXON does not check
 guest CR0 against IA32_VMX_CR0_FIXED0
Date:   Fri, 02 Sep 2022 18:39:14 +0000
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
Message-ID: <bug-216033-28872-5Jrf2lrP4A@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216033-28872@https.bugzilla.kernel.org/>
References: <bug-216033-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216033

--- Comment #2 from Eric Li (ercli@ucdavis.edu) ---
@Sean Christopherson Thanks for submitting the fix to this bug in
https://lore.kernel.org/lkml/20220607213604.3346000-4-seanjc@google.com/ .
However, I recently tested this fix and the behavior is not as expected.

According to Intel's SDM, VMXON may generate 2 types of exceptions:

    IF (register operand) or (CR0.PE =3D 0) or (CR4.VMXE =3D 0) or ...
        THEN #UD;
    ELSIF not in VMX operation
        THEN
            IF (CPL > 0) or (in A20M mode) or
            (the values of CR0 and CR4 are not supported in VMX operation .=
..
                THEN #GP(0);

For example, when CR4 value is incorrect, different exceptions may be gener=
ated
depending on which bit is incorrect. If CR4.VMXE =3D 0, #UD should be gener=
ated.
Otherwise, #GP(0) should be generated. However, after the fix, #UD is always
generated.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
