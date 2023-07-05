Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111627487A0
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 17:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbjGEPP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 11:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbjGEPPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 11:15:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19AE1724
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 08:15:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E0D8615DA
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 888AEC433CC
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688570152;
        bh=LvvKF7tFobiiR7KW81nxNt93oq0HbEhxYZQHw/eLdNQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JNUuD9jG/sLOFmhBBz4jeK01l1Ypk0WkvCJfVZYb2NB2rpTUdoBD3Z1d2GZyJ32Nq
         kU2Snuw9hqUZnfnlShNkmgpd5BPUiqV6Ps/7DG5/4Jj0to5dHZBnJuF7QRGBoz1S8G
         3K0uNHAlILqECkmE2BuHWjU3P5ou/0qxqv16P7NwI3Cu3YKzhSXwsLRP4S8OJFbSs3
         XRxY7HW7axR7WACSbj2wZloan38W4LQe4uh8I6tRLU0zllTi8zEbXOGm1g7Y+Ln2vu
         3Ix6lvjm4BHf5xZk0sDnYh/5c2EeROk7Y9ksvheNDom9DxfKZZDsjlUBHoViX4Y2R1
         lDRavckIPKrww==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7B5A5C4332E; Wed,  5 Jul 2023 15:15:52 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Wed, 05 Jul 2023 15:15:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: 780553323@qq.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-ehBGn7CgGi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #14 from Prob1d (780553323@qq.com) ---
  <cpu mode=3D"host-passthrough" check=3D"none" migratable=3D"on">
    <topology sockets=3D"1" dies=3D"1" cores=3D"4" threads=3D"1"/>
    <feature policy=3D"require" name=3D"sgxlc"/>
    <feature policy=3D"require" name=3D"intel-pt"/>
    <feature policy=3D"require" name=3D"ibrs-all"/>
    <feature policy=3D"require" name=3D"dtes64"/>
    <feature policy=3D"require" name=3D"monitor"/>
    <feature policy=3D"require" name=3D"ds_cpl"/>
    <feature policy=3D"require" name=3D"vmx"/>
    <feature policy=3D"require" name=3D"smx"/>
    <feature policy=3D"require" name=3D"est"/>
    <feature policy=3D"require" name=3D"tm2"/>
    <feature policy=3D"require" name=3D"xtpr"/>
    <feature policy=3D"require" name=3D"pdcm"/>
    <feature policy=3D"require" name=3D"ssbd"/>
    <feature policy=3D"require" name=3D"ibpb"/>
    <feature policy=3D"require" name=3D"stibp"/>
    <feature policy=3D"require" name=3D"tsc_adjust"/>
    <feature policy=3D"disable" name=3D"sgx"/>
    <feature policy=3D"require" name=3D"avx2"/>
    <feature policy=3D"require" name=3D"clflushopt"/>
    <feature policy=3D"require" name=3D"xsaves"/>
    <feature policy=3D"require" name=3D"md-clear"/>
  </cpu>
That is my cpu config. Maybe there are something that also needs.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
