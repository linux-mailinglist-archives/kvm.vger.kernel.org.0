Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EED052421E
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 03:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbiELBgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 21:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiELBgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 21:36:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697CA19C02
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 18:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4C361E87
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 01:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56BEDC34113
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 01:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652319368;
        bh=0fLlCdXB01xmHVEWg8MwyC1wNuk339wpCbrh+x7YiVE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=V9Ap46zjKUnJ1QsoJ8rz6r/i3qBsddtGzzdLuvuwfAwIhsxF/oT8ddKuUxLYrwt8s
         jJIxhIweWGf6atxTxaUnpGXdiaz7pBzGa9Ia20piKWoMyYiqzvv4v1Qe+A29mLMKYY
         ew/1lR7aM1+Xa+elivZ04s5xEcxNIJNUD8IzzsLLxPiju2cgJXrRA2ZhgvCs/4oo50
         2M6Yk4WMT3nRYHcTvfHrrGGWDr4ZBmQufs2T1+pxPfgd/1I5RzPZqKYJZSZjRVv7Cj
         4Yr1u2butaMH4HyCQU/QfmsDfe/FYBQH8JxOQQTQeUoZnCrr9yWkocEK/IaceUR2jE
         6cC+lZsHfvQJQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 30A11C05FD0; Thu, 12 May 2022 01:36:08 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215964] nVMX: KVM(L0) does not perform a platform reboot when
 guest(L2) trigger a reboot event through IO-Port-0xCF9
Date:   Thu, 12 May 2022 01:36:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: yadong.qi@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215964-28872-iMikjjTS8E@https.bugzilla.kernel.org/>
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

--- Comment #4 from Yadong Qi (yadong.qi@intel.com) ---
I think the OUT of 0xCF9 is forwarded to QEMU , because there is no any
0xCF9-OUT VMExit in L1 been traced.

Besides, the first VMExit in L1 after the OUT is a RDMSR-VMExit which is
totally unexpected, and the guest(L2) RIP is 0xFFF0. So I guess L0(QEMU/KVM)
has reset part of the vCPU, but the not cleared the nVMX state, so when L0
resume guest, it still treat L1 as alive and emulate unexpected VMExit to L=
1.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
