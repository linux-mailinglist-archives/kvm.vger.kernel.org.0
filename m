Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8AF719BAC
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 14:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233435AbjFAMMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 08:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbjFAMLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 08:11:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D299E10DA
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 05:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B86FB643F3
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 12:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A82BC4339C
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 12:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685621443;
        bh=LmuXvLvYhebgA+i28TO8aEw8qC1eJJt6l5nl84lPPFQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vPBNtLXy8tmux6xE1H6ZkeT3ZYG9IaP8s35tMUTVKrGzBriXE1m7h2iccTifDjzV0
         pd+sjQjNfklPD6ZNG/8hP6/iplE2QWggoTh+2fZ1IBughx77Xg8jcSPH35THqTEY0U
         1F5jOP2+IV98goz3GleuiVo32a9HVZU7XKDpgRQ+O09IGeSJXMFT6OuZTBhDYeUtYf
         OUiq3rDJhXCdcEAa3Efxi90mytoh7S1POyYdFGkG5I4Mvzm/bTx9xEuooIT6TpB8sO
         s9qH0DpvQk/6lkPYmv7B3feFYbcfgsCcwJL0frCvo9isHZzcSjU2wJTgO7SzF2+tEc
         dT9kNvFF7374Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 0FFD2C43144; Thu,  1 Jun 2023 12:10:43 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217516] FAIL: TSC reference precision test when do hyperv_clock
 test of kvm unit test
Date:   Thu, 01 Jun 2023 12:10:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: zjuysxie@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217516-28872-9KM17gsyL2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217516-28872@https.bugzilla.kernel.org/>
References: <bug-217516-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217516

--- Comment #1 from Ethan Xie (zjuysxie@hotmail.com) ---
qemu version:
# rpm -qa | grep qemu-kvm
qemu-kvm-common-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64
qemu-kvm-block-gluster-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64
qemu-kvm-block-curl-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64
qemu-kvm-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64
qemu-kvm-block-iscsi-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64
qemu-kvm-block-rbd-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64
qemu-kvm-block-ssh-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64
qemu-kvm-core-4.2.0-59.module_el8.5.0+1063+c9b9feff.1.x86_64

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
