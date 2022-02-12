Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A653D4B3433
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 11:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbiBLK0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 05:26:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiBLK0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 05:26:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4839E22B15
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 02:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF31F60B6A
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 10:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48F47C340F3
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 10:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644661600;
        bh=Yzw/3OcmCre/osNVpgR2DClOgBp6fL3E6yvY/Lq0qXI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aBJUtsb2cgIcHS5iHPtWbPZCZ55u9mOV18/UkMdH88aFxroulKV+tN7ajQ7SnBW82
         Yn225eD+aJHIGbSbUgvu8EeEsQBM1KhK5yzsTPoP2MdWqfcFNdZilyxhm/LpsMyjdg
         AhKXCD8DbXThEj2UGFqz8fIHCrKF7oyqRC/8h6HlC6Mxhdta23UdIPiftpaq3dTQq8
         zEkZrMEpvWOdpcuYbneM/ltohskt6jOIdCR4Kn08C+5NfTu3YwYFj1x3i/FYejh5u7
         yLyEcDIrKraJySgx6U9QI282yb17r+y0FML2G5Y6Yg+GSkXqZO78tl3npxsZdf9CHB
         6W5YtB7JNI+xQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 37ACAC05FD2; Sat, 12 Feb 2022 10:26:40 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Sat, 12 Feb 2022 10:26:39 +0000
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
Message-ID: <bug-199727-28872-5PPusjrYyW@https.bugzilla.kernel.org/>
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

--- Comment #9 from Roland Kletzing (devzero@web.de) ---
https://qemu-devel.nongnu.narkive.com/I59Sm5TH/lock-contention-in-qemu
<snip>
I find the timeslice of vCPU thread in QEMU/KVM is unstable when there
are lots of read requests (for example, read 4KB each time (8GB in
total) from one file) from Guest OS. I also find that this phenomenon
may be caused by lock contention in QEMU layer. I find this problem
under following workload.
<snip>
Yes, there is a way to reduce jitter caused by the QEMU global mutex:

qemu -object iothread,id=3Diothread0 \
-drive if=3Dnone,id=3Ddrive0,file=3Dtest.img,format=3Draw,cache=3Dnone \
-device virtio-blk-pci,iothread=3Diothread0,drive=3Ddrive0

Now the ioeventfd and thread pool completions will be processed in
iothread0 instead of the QEMU main loop thread. This thread does not
take the QEMU global mutex so vcpu execution is not hindered.

This feature is called virtio-blk dataplane.
<snip>


i tried "virtio scsi single" with "aio=3Dthreads" and "iothread=3D1" in pro=
xmox,
and after that, even with totally heavy read/write io inside 2 VMs (located=
 on
the same spinning hdd on top of zfs lz4 + zstd dataset and qcow) and severe
write starvation (some ioping  >>30s), even while live migrating both vm di=
sks
in parallel to another zfs dataset on the same hdd, i get absolutely NO jit=
ter
in ping anymore. ping to both VMs is constantly at <0.2ms=20

from the kvm pid:
-object iothread,id=3Diothread-virtioscsi0=20=20
-device
virtio-scsi-pci,id=3Dvirtioscsi0,bus=3Dpci.3,addr=3D0x1,iothread=3Diothread=
-virtioscsi0=20
-drive
file=3D/hddpool/vms-files-lz4/images/116/vm-116-disk-3.qcow2,if=3Dnone,id=
=3Ddrive-scsi0,cache=3Dwriteback,aio=3Dthreads,format=3Dqcow2,detect-zeroes=
=3Don=20
-device
scsi-hd,bus=3Dvirtioscsi0.0,channel=3D0,scsi-id=3D0,lun=3D0,drive=3Ddrive-s=
csi0,id=3Dscsi0,bootindex=3D100

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
