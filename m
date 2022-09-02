Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559CA5AB9B5
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 22:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiIBU5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 16:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIBU5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 16:57:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867F0FE056
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 13:57:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 218D960B43
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 20:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F7DAC433D7
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662152238;
        bh=yLIw5QalzeWi+BBqeMXnmhId5t3khSyh5MCdZr9So/Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=I7I9KL7FBjGUS4YrZWMh2G+txPhKS+e1lsh9sSwmmm1tMb0fKtITfxG1f5TjqZ3oy
         7etIx+njKLRQqEG5vRWR6cPM0WLo4nANRivkOnMY9fgbmWqqY3220jasof1KxDFz0Z
         Q6fdfmvdfNo2dvl/OeEqXoCrYwEBIxaknuNPBsU54KDYk9jYadzPn++UPsWiYdwLgh
         fdih+yrDwRcVq4056qdcId4fRS0qIQQMt2FzhUOowqNzFZWjIosfAuPjWp4T+oukbM
         IieHRpTvUunMU20kEuiG++5+9jl4aDiXOeDrUHg+WUTOhUHXXyd9yABJ1n2/iNV0nU
         vflIQOfcauM3Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 68DA5C04231; Fri,  2 Sep 2022 20:57:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216033] KVM VMX nested virtualization: VMXON does not check
 guest CR0 against IA32_VMX_CR0_FIXED0
Date:   Fri, 02 Sep 2022 20:57:18 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216033-28872-eFjeS2nk5C@https.bugzilla.kernel.org/>
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

--- Comment #5 from Sean Christopherson (seanjc@google.com) ---
On Fri, Sep 02, 2022, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216033
>=20
> --- Comment #4 from Eric Li (ercli@ucdavis.edu) ---
> >       if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
> >           !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
> >               kvm_queue_exception(vcpu, UD_VECTOR);
> >               return 1;
> >       }
>=20
> Thanks for the reply. I think there is still a typo. Do you mean the
> following?

Yes, yes I did.

>         if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
>             !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
>                 kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>                 return 1;
>         }
>=20
> Or maybe:
>=20
>         if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
>             !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
>                 kvm_inject_gp(vcpu, 0);
>                 return 1;
>         }
>=20
> I am not familiar with KVM code

Heh, for all the good that being familiar with KVM is doing me.

> so not sure which one should be used. Thanks again!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
