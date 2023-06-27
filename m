Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3064374016C
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 18:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjF0Qjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 12:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjF0Qjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 12:39:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AB5109
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 09:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 810E0611E6
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 16:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9E57C433CC
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687883976;
        bh=+N98BXsUukvfjCL7GNfjkb25OAkQiaRdxxLvL/8Q8KI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WWJzjp14GgXgsGEKFZldTTq9icpu8HINXBT4TbAT9+a9AzPjipO9fE00OOCfBru1F
         DZE+7yyn8h6JK36L7BHaTBvCI86FwLIhRKB2WAehOvK2gJTDm2jbBAbjatmYWV32Xs
         DHe2vXYHDTNMYr9+BVosnharrI8BwzaAkE83diJ8TQ6WpM7+TkkSM4v2DRosJaUnsZ
         kvIBaTYIOCOdEgEWBALUy+J/iDMgcLIj9CK6DyIOS6hMDEqnXjayxbQKbTRMRtTHUA
         I+6q1e83VR8yCmLbxWkeXqsBhKci3hqCL3lpUQilQyA95ZGoYrK6V0tJQUhAL+NfFI
         LsSwxx3xEMufg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id BD285C53BD5; Tue, 27 Jun 2023 16:39:36 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217307] windows guest entering boot loop when nested
 virtualization enabled and hyperv installed
Date:   Tue, 27 Jun 2023 16:39:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: webczat@outlook.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217307-28872-Yzkphi4Dmf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217307-28872@https.bugzilla.kernel.org/>
References: <bug-217307-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D217307

--- Comment #8 from Micha=C5=82 Zegan (webczat@outlook.com) ---
Hello,
the problem is, nothing helps.
Currently I have the following setup changed in reference to my previous co=
nfig
(qemu cmdline below):
- set cpu to Skylake-Client-noTSX-IBRS (note i also tried nehalem or qemu64
randomly and nothing worked, including qemu64 not even booting at all but
unsure why).
- actually removed/commented out all devices except the ones I need like
sound/video/disks.
- Disabled things like smm, secureboot and everything else, just in case.
- Also disabled any and all enlightenments i could find.

The effect is all the same (note I enable vmx feature in cpu settings, if n=
ot
enabled then the system boots without it).

Command line is:

/usr/bin/qemu-system-x86_64 \
-name guest=3Dwin11,debug-threads=3Don \
-S \
-object
'{"qom-type":"secret","id":"masterKey0","format":"raw","file":"/var/lib/lib=
virt/qemu/domain-22-win11/master-key.aes"}'
\
-blockdev
'{"driver":"file","filename":"/usr/share/edk2/ovmf/OVMF_CODE.fd","node-name=
":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}'
\
-blockdev
'{"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","fil=
e":"libvirt-pflash0-storage"}'
\
-blockdev
'{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/win11_VARS.fd","n=
ode-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"=
}'
\
-blockdev
'{"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","fi=
le":"libvirt-pflash1-storage"}'
\
-machine
pc-q35-7.0,usb=3Doff,smm=3Doff,kernel_irqchip=3Don,dump-guest-core=3Doff,me=
mory-backend=3Dpc.ram,pflash0=3Dlibvirt-pflash0-format,pflash1=3Dlibvirt-pf=
lash1-format
\
-accel kvm \
-cpu
Skylake-Client-noTSX-IBRS,mpx=3Doff,vmx=3Don,kvm-pv-unhalt=3Doff,kvm-pv-ipi=
=3Doff,pmu=3Doff
\
-m 8192 \
-object
'{"qom-type":"memory-backend-memfd","id":"pc.ram","share":true,"x-use-canon=
ical-path-for-ramblock-id":false,"size":8589934592}'
\
-overcommit mem-lock=3Doff \
-smp 8,sockets=3D1,dies=3D1,cores=3D8,threads=3D1 \
-uuid 589e17db-9ea9-49ac-8a66-c75bbc39ddd3 \
-no-user-config \
-nodefaults \
-chardev socket,id=3Dcharmonitor,fd=3D29,server=3Don,wait=3Doff \
-mon chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol \
-rtc base=3Dlocaltime,clock=3Dvm,driftfix=3Dslew \
-no-shutdown \
-global ICH9-LPC.disable_s3=3D1 \
-global ICH9-LPC.disable_s4=3D1 \
-boot strict=3Don \
-device
'{"driver":"pcie-root-port","port":16,"chassis":1,"id":"pci.1","bus":"pcie.=
0","multifunction":true,"addr":"0x2"}'
\
-device
'{"driver":"pcie-root-port","port":17,"chassis":2,"id":"pci.2","bus":"pcie.=
0","addr":"0x2.0x1"}'
\
-device
'{"driver":"pcie-root-port","port":18,"chassis":3,"id":"pci.3","bus":"pcie.=
0","addr":"0x2.0x2"}'
\
-device
'{"driver":"pcie-root-port","port":19,"chassis":4,"id":"pci.4","bus":"pcie.=
0","addr":"0x2.0x3"}'
\
-device
'{"driver":"pcie-root-port","port":20,"chassis":5,"id":"pci.5","bus":"pcie.=
0","addr":"0x2.0x4"}'
\
-device
'{"driver":"pcie-root-port","port":21,"chassis":6,"id":"pci.6","bus":"pcie.=
0","addr":"0x2.0x5"}'
\
-device
'{"driver":"pcie-root-port","port":22,"chassis":7,"id":"pci.7","bus":"pcie.=
0","addr":"0x2.0x6"}'
\
-device '{"driver":"pcie-pci-bridge","id":"pci.8","bus":"pci.1","addr":"0x0=
"}'
\
-device
'{"driver":"pcie-root-port","port":23,"chassis":9,"id":"pci.9","bus":"pcie.=
0","addr":"0x2.0x7"}'
\
-device
'{"driver":"pcie-root-port","port":24,"chassis":10,"id":"pci.10","bus":"pci=
e.0","multifunction":true,"addr":"0x3"}'
\
-device
'{"driver":"pcie-root-port","port":25,"chassis":11,"id":"pci.11","bus":"pci=
e.0","addr":"0x3.0x1"}'
\
-device '{"driver":"qemu-xhci","id":"usb","bus":"pci.2","addr":"0x0"}' \
-device
'{"driver":"virtio-scsi-pci","iommu_platform":true,"packed":true,"id":"scsi=
0","num_queues":8,"bus":"pci.4","addr":"0x0"}'
\
-blockdev
'{"driver":"host_device","filename":"/dev/pool/win11","node-name":"libvirt-=
2-storage","auto-read-only":true,"discard":"unmap"}'
\
-blockdev
'{"node-name":"libvirt-2-format","read-only":false,"driver":"raw","file":"l=
ibvirt-2-storage"}'
\
-device
'{"driver":"scsi-hd","bus":"scsi0.0","channel":0,"scsi-id":0,"lun":0,"devic=
e_id":"drive-scsi0-0-0-0","drive":"libvirt-2-format","id":"scsi0-0-0-0","bo=
otindex":1}'
\
-blockdev
'{"driver":"file","filename":"/var/lib/libvirt/cdroms/virtio-win-0.1.225.is=
o","node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"}'
\
-blockdev
'{"node-name":"libvirt-1-format","read-only":true,"driver":"raw","file":"li=
bvirt-1-storage"}'
\
-device
'{"driver":"ide-cd","bus":"ide.1","drive":"libvirt-1-format","id":"sata0-0-=
1"}'
\
-object
'{"qom-type":"input-linux","id":"input0","evdev":"/dev/input/by-id/usb-MOSA=
RT_Semi._2.4G_INPUT_DEVICE-event-kbd","repeat":true,"grab_all":true,"grab-t=
oggle":"ctrl-ctrl"}'
\
-object
'{"qom-type":"input-linux","id":"input1","evdev":"/dev/input/by-path/platfo=
rm-i8042-serio-0-event-kbd","repeat":true,"grab_all":true,"grab-toggle":"ct=
rl-ctrl"}'
\
-object
'{"qom-type":"input-linux","id":"input2","evdev":"/dev/input/by-path/pci-00=
00:00:15.0-platform-i2c_designware.0-event-mouse"}'
\
-object
'{"qom-type":"input-linux","id":"input3","evdev":"/dev/input/by-path/platfo=
rm-i8042-serio-1-event-mouse"}'
\
-audiodev '{"id":"audio1","driver":"spice"}' \
-spice port=3D0,disable-ticketing=3Don,seamless-migration=3Don \
-device
'{"driver":"qxl-vga","id":"video0","max_outputs":1,"ram_size":67108864,"vra=
m_size":67108864,"vram64_size_mb":0,"vgamem_mb":16,"bus":"pcie.0","addr":"0=
x1"}'
\
-device
'{"driver":"ich9-intel-hda","id":"sound0","bus":"pcie.0","addr":"0x1b"}' \
-device
'{"driver":"hda-duplex","id":"sound0-codec0","bus":"sound0.0","cad":0,"audi=
odev":"audio1"}'
\
-device
'{"driver":"virtio-balloon-pci","id":"balloon0","bus":"pci.3","addr":"0x0"}=
' \
-device '{"driver":"vmcoreinfo"}' \
-sandbox
on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcecontrol=3D=
deny \
-msg timestamp=3Don

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
