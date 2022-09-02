Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8655AB8EF
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiIBTpy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIBTpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7461520BEB
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:45:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FFE860DF0
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 19:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65550C433B5
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662147951;
        bh=Vt+QriF83MpjCDYqtGrRkemhyCmqLBhedr1iheC8iSw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GXD29kb9Ez5r1Wu5F1Pd8GuFzvBqIyhb8ZlLS26jFcveCnxDZbq9R2AODeUMvYZhI
         WKrVUtZoCTzt8hFcNbT3dRX0Mu1tBHNYcPdl/VFiDs3qye0p2ZIBHghjKNoIhuK8kF
         lA2KUZwP02CyVUIs/6K4BSIPzAINHx73dcsHmihB0pu714wZGCd1HmkUv24oUoD8Bl
         0P89hH7IHdLu9J+Gwy7a+ALvGke6RYMdii9uJqWN9KaeuIBRfYcyqg8S7E1c89PeG5
         F43hu418K+umKaboLJjiRpiAxTwBWrPOpYZQ2dQ+EM9dP/qJsxxNuq5eTfAJ7q5lLu
         mr30CbMd3wYYg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 52177C433E9; Fri,  2 Sep 2022 19:45:51 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216033] KVM VMX nested virtualization: VMXON does not check
 guest CR0 against IA32_VMX_CR0_FIXED0
Date:   Fri, 02 Sep 2022 19:45:51 +0000
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
Message-ID: <bug-216033-28872-qeghcQUm21@https.bugzilla.kernel.org/>
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

--- Comment #4 from Eric Li (ercli@ucdavis.edu) ---
>       if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
>           !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
>               kvm_queue_exception(vcpu, UD_VECTOR);
>               return 1;
>       }

Thanks for the reply. I think there is still a typo. Do you mean the follow=
ing?

        if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
            !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
                kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
                return 1;
        }

Or maybe:

        if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
            !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
                kvm_inject_gp(vcpu, 0);
                return 1;
        }

I am not familiar with KVM code so not sure which one should be used. Thanks
again!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
