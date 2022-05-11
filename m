Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA625234C1
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244216AbiEKNzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 09:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbiEKNzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 09:55:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D0B2CE1B
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 06:55:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15873B823B9
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 13:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B845DC34116
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652277314;
        bh=qAZq5CGp+pA8lnAOjDIQgd3tu5ql8c8uQaAC4TKMNi8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FzdkSrbjsF5eWPoKYU5amhLUy+GjRXl9Vher0iJ+Cowu2gYKEpLppGC93IL/YWTak
         c/e+BS8a5+0biYWXOZZ4m13UWHRFV4tir/KEbqBSuRr3cczwu0EUqen+fUb1FLAYPe
         wTeBNnF6JhwM2CxVn4rleye2o01zyi14o7scsIm7GAagaphptS1W0Jv4WJtLqsTuhW
         tnwC4lNHHSf/CPxw94Ur2Fv/tyS2kUicXi5Li3l9Vrif24BnVqM7GBfGzMGZpNlvKC
         MOOUovgJmoOAAEZKCKRoQii5OfzmWehheFlDfeqo5FvqoEcW8TOug0GjoX1B/4PaRP
         dx1//+XxpJckw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9F0C8CC13B1; Wed, 11 May 2022 13:55:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] nVMX: KVM(L0) does not perform a platform reboot when
 guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Wed, 11 May 2022 13:55:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215964-28872-43bkufWhqw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215964-28872@https.bugzilla.kernel.org/>
References: <bug-215964-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215964

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
Hmm, QEMU is clearing clearing "guest mode" to get the vCPU back into L1 at
RESET, and IIRC QEMU will do KVM_SET_NESTED_STATE as part of its RESET
emulation.

My question about the 0xcf9 write still stands.  Does the OUT get sent to Q=
EMU
and then something goes awry during RESET emulation?  Or is the OUT forward=
ed
to L1 as a nested VM-Exit?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
