Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB3273D69B
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 05:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjFZDud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 23:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjFZDub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 23:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D82189
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 20:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA4DD60C79
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 03:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1111CC433CB
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 03:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687751430;
        bh=xwmNti7w0UAqVHQeXHRIrqXGcJ4ZS6r+htz86m1Sy+A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uk7tSzS6aY3ZX1jbKTBfC7GguZ0hq7JFqizJ+A5DEuOY+jRUiy91ZpiX+1N4HHvYX
         MAPwWh1ioIWnA/F+K9kRehE+UWL7kw7HRFYYXwRDQ0iYtcvZhFfHu86m688V+MHuD8
         vfaB8bQ9C51Hei5FVTfRzV/Lu3q1zH3LNCvRAEDgrd3I9DmP1DoGDZOw/1WABiW79u
         ft+PBXns1wtH1DjAhKwTLYGZpwwbjLMC6vkz1YyO7Y1oxU4K+Er9n9f21DNaNi6mKo
         3V5Pep6JfXs7ksJkb6Ls2/JjiRnxcpeHaqmLiDzabNdxayKvGhYc/878zKboRpkK6P
         lm5YoQVbG/O6w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id EB3F5C53BD3; Mon, 26 Jun 2023 03:50:29 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217558] In KVM guest with VF of X710 NIC passthrough, the mac
 address of VF is inconsistent with it in host
Date:   Mon, 26 Jun 2023 03:50:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217558-28872-7yzOKLooBM@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217558-28872@https.bugzilla.kernel.org/>
References: <bug-217558-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217558

--- Comment #8 from Chen, Fan (farrah.chen@intel.com) ---
Hi Patryk

We reproduced this issue with the latest kernel commit
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
a92b7d26 kernel version: 6.4.0_rc7

When you reproduce, did you create multiple VFs and passthrough all of them=
 to
KVM guest? I found that if we only passthrough one VF to guest, the mac is =
the
same as it in host, but when passthrough 2 or more VFs, sometimes only the
first VF use the same mac as it in host, other VFs' mac are random; sometim=
es
all the VFs' mac are random.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
