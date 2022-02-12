Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A574B31C7
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 01:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354349AbiBLANv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 19:13:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiBLANu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 19:13:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BCCD41
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 16:13:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1140661B76
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 00:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B82FC340F3
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 00:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644624826;
        bh=NxoOSaL/buRf39IPk7pivD5SRhjq+Qugu4td5l+HpzE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KfGub7iRk7cFROmhhATliFFpC/xK+PGuf2eaC3gIBVxKhgSp76g1/lxY9gCpN5ZGe
         k3SwjsV5zqjyFg4G6LbGNAGWMezHLLb5txoVYxIOVRGTKW2mA8/Zw+M3fPjfxMz6kX
         5FoqBdTX8foZBG1TjW0jRp8kwCkBX5jYs2MSHRd4t1IMY+Q31FojVveN7EU0Q0koVZ
         BV5m1eveOehh3OkT37HW68wsR7wOzq9VYZfGgPlAbgfaX6qGkb1JXVB7K3NLKLeyT/
         LLgSVMRlh9PQyLG/F8r8TdlXi07YEtxGO3R6LKC5aNNiAO8AkfLJUI2V6Cmp2zt+xw
         iIEdNubm1z1bQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 62AF8CC13A6; Sat, 12 Feb 2022 00:13:46 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Sat, 12 Feb 2022 00:13:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-3VQE9GCTuy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #8 from Roland Kletzing (devzero@web.de) ---
yes.

i found the following interesting information. i think this explains a LOT.

https://docs.openeuler.org/en/docs/20.03_LTS/docs/Virtualization/best-pract=
ices.html#i-o-thread-configuration

I/O Thread Configuration
Overview

By default, QEMU main threads handle backend VM read and write operations on
the KVM. This causes the following issues:

    VM I/O requests are processed by a QEMU main thread. Therefore, the
single-thread CPU usage becomes the bottleneck of VM I/O performance.
    The QEMU global lock (qemu_global_mutex) is used when VM I/O requests a=
re
processed by the QEMU main thread. If the I/O processing takes a long time,=
 the
QEMU main thread will occupy the global lock for a long time. As a result, =
the
VM vCPU cannot be scheduled properly, affecting the overall VM performance =
and
user experience.

You can configure the I/O thread attribute for the virtio-blk disk or
virtio-scsi controller. At the QEMU backend, an I/O thread is used to proce=
ss
read and write requests of a virtual disk. The mapping relationship between=
 the
I/O thread and the virtio-blk disk or virtio-scsi controller can be a
one-to-one relationship to minimize the impact on the QEMU main thread, enh=
ance
the overall I/O performance of the VM, and improve user experience.
Configu

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
