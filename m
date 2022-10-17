Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3216012AB
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 17:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiJQPXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 11:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiJQPXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 11:23:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5675246C
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 08:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45DC0CE14A0
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 15:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5EDD6C43140
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666020183;
        bh=eYYa1zWasMiHZj5Aos7HYCHz45oSf7ehMD2J2KRjZ/w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=F0CamNv324yJxIM7mTFc87KuGS4CcAhmR9Uqq8KeREwyyNCl7+LfK8n7mz8cB5gV3
         ufDPVkcdJSb2jcYQ4Cxa4ZU4CcXw84ImxGpVUHazlWeJMLK/O5843fbk3cTJyt7G8k
         MvXHUxVDAAuEgd9WYFOmfmAtMWjwlBlAs1HXyx5OxWR3OnNGSl5MM+Tz16xUhB4csZ
         /rd3N8YVJvFYBTB8p6CgiNT9uE8Ah51uG9afJoGz1J7Vd/xezYZAwaqD1NJQcxO4vo
         +7JhQaa6fyssCegGIyHyx/e9E4FS8f8xM1kGXl2RHQc9rL5RHSXV/aK7dPj8503e53
         QsHbNhG7av+vw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4B491C433EA; Mon, 17 Oct 2022 15:23:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216598] Assertion Failure in kvm selftest mmio_warning_test
Date:   Mon, 17 Oct 2022 15:23:02 +0000
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
Message-ID: <bug-216598-28872-Tv2brh0Uo4@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216598-28872@https.bugzilla.kernel.org/>
References: <bug-216598-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216598

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
On Mon, Oct 17, 2022, bugzilla-daemon@kernel.org wrote:
> Created attachment 303018
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D303018&action=3Dedit
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   x86_64/mmio_warning_test.c:118: warnings_before =3D=3D warnings_after
>   pid=3D4383 tid=3D4383 errno=3D0 - Success
>      1  0x0000000000402463: main at mmio_warning_test.c:117
>      2  0x00007f5bc5c23492: ?? ??:0
>      3  0x00000000004024dd: _start at ??:?
>   Warnings found in kernel.  Run 'dmesg' to inspect them.

Known bug.  Fix is posted[*], will make sure it gets into 6.1 and I suppose
backported to stable.

[*] https://lore.kernel.org/all/20220930230008.1636044-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
