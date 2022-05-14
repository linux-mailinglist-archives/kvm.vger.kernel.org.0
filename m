Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B991452736E
	for <lists+kvm@lfdr.de>; Sat, 14 May 2022 20:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbiENSSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 May 2022 14:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiENSS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 May 2022 14:18:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9EAA193
        for <kvm@vger.kernel.org>; Sat, 14 May 2022 11:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DED98610F4
        for <kvm@vger.kernel.org>; Sat, 14 May 2022 18:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40CD4C34117
        for <kvm@vger.kernel.org>; Sat, 14 May 2022 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652552303;
        bh=zKIee9e4UO4tpfszIC2i/QUYg/tqvkLLR60gWByQGY0=;
        h=From:To:Subject:Date:From;
        b=VMvfovMvk99c9mXFeWltNDV8kNqaqdmJalQbwCqu9ROPGInfxPqaceZx7U8G7zPVe
         ki8ShBMSY0NLTZ67ZZwO/9MCXlB/CVoP+t97IkCGOOQ7o3qtEWjQgEzNW25XLQXgYh
         qhzY9x/uCJans/xU1sReMr2uaQ+SpqKYMqhofVEiBjNO6aZhNpW7jmco48UH59Xx6R
         hO98c5UBOho8SGee0unFk8ofsd2A+vUsWYl3t5reDyOEeP1AiG3Y6Fb5mr/h7vvmAs
         pCuDvk+aBleqD39aPEhGgKbyTLYepNtNzIh/aVfbhs4QTRfShUMXr22xBGxkc/KD2E
         afXiTFAZNctZA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 27328CC13B2; Sat, 14 May 2022 18:18:23 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215977] New: kvm BUG: kernel NULL pointer dereference, address:
 000000000000000b
Date:   Sat, 14 May 2022 18:18:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dabo+kernel.org@devconsole.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215977-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D215977

            Bug ID: 215977
           Summary: kvm BUG: kernel NULL pointer dereference, address:
                    000000000000000b
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.17.7
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: dabo+kernel.org@devconsole.de
        Regression: No

Created attachment 300957
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300957&action=3Dedit
journalctl -o cat -k -b -1

Hi,

I encountered a bug in Arch Linux after kernel upgrade from 5.17.1-arch1-1 =
to
5.17.7-arch1-1, when libvirtd starts a kvm accelerated qemu vm. Downgrading=
 to
5.17.1 fixes it.

Please find journal in attachment.

Thank you.

Daniel

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
