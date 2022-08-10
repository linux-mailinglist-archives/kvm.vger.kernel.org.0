Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0246658EF91
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiHJPn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiHJPn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:43:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936A65C97B
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FEF7B81D49
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 15:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF696C43470
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660146202;
        bh=9v5gthgXPIUbe+kf/aJ5TU+E8TwcQY7Sa1xtjLLbnko=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ktYoqLuExv2hfTQFdUpbcAAl81KUov+3ETac8YJvjVcMVTfyUDi5zHRFL9Bi0Ktuu
         LeCIyE3c0RrZ9AvsRhtNXgJEfxXEabEIj4MnhclLf3krF0ZXYa5+1hOjVUg5CnArqc
         XwxrWSP2ux19bRi6wB3HwBejnKIm+vbogYtIKk0wYggotv0u6bxsmqIe+iRwMIwQ4C
         LoNsulA22Hb6YNu1nKc0be2XYoRBVPprVuZ1e9VtS+fLxff0T2HLwdOvaAx9c35NnZ
         I4SOM1C9KeZleYw7hMOgLyo3J48nQAsQfJF90dhA1WZzkhTAFqVQtlgiRHfk611pT/
         g9oGyyKfXYyfQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B59D4C433E4; Wed, 10 Aug 2022 15:43:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216349] Kernel panic in a Ubuntu VM running on Proxmox
Date:   Wed, 10 Aug 2022 15:43:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jdpark.au@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216349-28872-yrDvb3ppxQ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216349-28872@https.bugzilla.kernel.org/>
References: <bug-216349-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D216349

--- Comment #3 from John Park (jdpark.au@gmail.com) ---
(In reply to Dr. David Alan Gilbert from comment #2)
> Are you doing live migration? And if so, between which host CPUs?

Thanks for your response. No, I'm not performing any migration. The VM is
static and only running Docker. The host CPU is an Intel N5105. It's not do=
ing
anything too intensive with VM CPU sitting at around 10% and the Host CPU
sitting at around 5% (powersave governor set).

The CPU governer was initially set to 'performance' which I've since change=
d to
'powersave' using the intel_pstate driver but this hasn't improved the
situation.

There's quite a few people on the Proxmox forums (links below) running the =
same
CPU who have also encountered the same issue. Could there be an issue with =
the
kernel and this particular CPU?

https://forum.proxmox.com/threads/vm-freezes-irregularly.111494/
https://forum.proxmox.com/threads/vms-freezing-randomly.113037/
https://forum.proxmox.com/threads/ubuntu-20-04-und-22-04-vms-bleiben-zuf%C3=
%A4llig-h%C3%A4ngen-bsd-vms-nicht.113358/
https://forum.proxmox.com/threads/ubuntu-20-04-04-machine-freezes.112507/
https://forum.proxmox.com/threads/proxmox-vms-crashing-freezing-on-intel-n5=
105-cpu.113177/
https://forum.proxmox.com/threads/pfsense-vm-keeps-freezing-crashing.112439/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
