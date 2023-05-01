Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA226F33A5
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 18:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjEAQvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjEAQvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 12:51:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5610C1719
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 09:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9727161D8F
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 16:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0318C433D2
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682959891;
        bh=nNwqwEPEiT06O1oPTIGKi6iYYycY44DhJ8Nggj9C/TA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Lp1CfSYUBpaswh53au3mTbrYbgWXfvprH6RxTO7bRJD6BzVvrmXD3TEMPDggA0Jz6
         ZnjtBojA4YZ94sDzzLzRDxbVcD4CtYfUTyiseDWhn2WA8HIeWFzhERRZj6XnO5MjyS
         E4UoAAutQ6X8W9TNRwhObvgbCKTEoacdQkjccFmAofXHDQnHI5oe32GfH2O5ov/TYo
         dI/SqXEH13cmc0dnd3i5rqysRu5hYyfpQE4ILwLoXWt4JkGQyEsH0j0FZJSBjBGwrW
         F/Ux5GJa++cHj0/fUKaKN5X2/KVpc9VFKoOrpUwiU3j7WSbnqyJvZ0x+TZdnxWJvK1
         HZgahNhQR9BUA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CF211C43142; Mon,  1 May 2023 16:51:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217379] Latency issues in irq_bypass_register_consumer
Date:   Mon, 01 May 2023 16:51:30 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217379-28872-YDqpbtJUh7@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217379-28872@https.bugzilla.kernel.org/>
References: <bug-217379-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217379

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Fri, Apr 28, 2023, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217379
>=20
>             Bug ID: 217379
>            Summary: Latency issues in irq_bypass_register_consumer
>            Product: Virtualization
>            Version: unspecified
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: zhuangel570@gmail.com
>         Regression: No
>=20
> We found some latency issue in high-density and high-concurrency scenario=
s,
> we are using cloud hypervisor as vmm for lightweight VM, using VIRTIO net=
 and
> block for VM. In our test, we got about 50ms to 100ms+ latency in creatin=
g VM
> and register irqfd, after trace with funclatency (a tool of bcc-tools,
> https://github.com/iovisor/bcc), we found the latency introduced by follo=
wing
> functions:
>=20
> - irq_bypass_register_consumer introduce more than 60ms per VM.
>   This function was called when registering irqfd, the function will regi=
ster
>   irqfd as consumer to irqbypass, wait for connecting from irqbypass
>   producers,
>   like VFIO or VDPA. In our test, one irqfd register will get about 4ms
>   latency, and 5 devices with total 16 irqfd will introduce more than 60ms
>   latency.
>=20
> Here is a simple case, which can emulate the latency issue (the real late=
ncy
> is lager). The case create 800 VM as background do nothing, then repeated=
ly
> create 20 VM then destroy them after 400ms, every VM will do simple thing,
> create in kernel irq chip, and register 15 riqfd (emulate 5 devices and e=
very
> device has 3 irqfd), just trace the "irq_bypass_register_consumer" latenc=
y,
> you
> will reproduce such kind latency issue. Here is a trace log on Xeon(R)
> Platinum
> 8255C server (96C, 2 sockets) with linux 6.2.20.
>=20
> Reproduce Case
>
> https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/kvm_irqfd_=
fork.c
> Reproduce log
> https://github.com/zhuangel/misc/blob/main/test/kvm_irqfd_fork/test.log
>=20
> To fix these latencies, I didn't have a graceful method, just simple ideas
> is give user a chance to avoid these latencies, like new flag to disable
> irqbypass for each irqfd.
>=20
> Any suggestion to fix the issue if welcomed.

Looking at the code, it's not surprising that irq_bypass_register_consumer()
can
exhibit high latencies.  The producers and consumers are stored in simple
linked
lists, and a single mutex is held while traversing the lists *and* connecti=
ng
a consumer to a producer (and vice versa).

There are two obvious optimizations that can be done to reduce latency in
irq_bypass_register_consumer():

   - Use a different data type to track the producers and consumers so that
lookups
     don't require a linear walk.  AIUI, the "tokens" used to match produce=
rs
and
     consumers are just kernel pointers, so I _think_ XArray would perform
reasonably
     well.

   - Connect producers and consumers outside of a global mutex.

Unfortunately, because .add_producer() and .add_consumer() can fail, and
because
connections can be established by adding a consumer _or_ a producer, getting
the
locking right without a global mutex is quite difficult.  It's certainly do=
able
to move the (dis)connect logic out of a global lock, but it's going to requ=
ire
a
dedicated effort, i.e. not something that can be sketched out in a few minu=
tes
(I played around with the code for the better part of an hour trying to do =
just
that and kept running into edge case race conditions).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
