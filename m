Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AEC2F063A
	for <lists+kvm@lfdr.de>; Sun, 10 Jan 2021 10:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbhAJJtY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 10 Jan 2021 04:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbhAJJtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jan 2021 04:49:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5040322D01
        for <kvm@vger.kernel.org>; Sun, 10 Jan 2021 09:48:43 +0000 (UTC)
Received: by pdx-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 436BB86729; Sun, 10 Jan 2021 09:48:43 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 211109] Hard kernel freeze due to large cpu allocation.
Date:   Sun, 10 Jan 2021 09:48:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vytautas.mickus.exc@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-211109-28872-DHuAR2aOOr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-211109-28872@https.bugzilla.kernel.org/>
References: <bug-211109-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=211109

--- Comment #1 from Vytautas Mickus (vytautas.mickus.exc@gmail.com) ---
VM configuration xml:
```
<domain type='kvm' id='1'>
  <name>minikube</name>
  <uuid>b2dc4e44-53b6-433f-850c-a638294a1cf5</uuid>
  <memory unit='KiB'>6144000</memory>
  <currentMemory unit='KiB'>6144000</currentMemory>
  <vcpu placement='static'>31</vcpu>
  <resource>
    <partition>/machine</partition>
  </resource>
  <os>
    <type arch='x86_64' machine='pc-i440fx-5.1'>hvm</type>
    <boot dev='cdrom'/>
    <boot dev='hd'/>
    <bootmenu enable='no'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>
  <cpu mode='host-passthrough' check='none' migratable='on'/>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='/home/vytautas/.minikube/machines/minikube/boot2docker.iso'
index='2'/>
      <backingStore/>
      <target dev='hdc' bus='scsi'/>
      <readonly/>
      <alias name='scsi0-0-2'/>
      <address type='drive' controller='0' bus='0' target='0' unit='2'/>
    </disk>
    <disk type='file' device='disk'>
      <driver name='qemu' type='raw' io='threads'/>
      <source
file='/home/vytautas/.minikube/machines/minikube/minikube.rawdisk' index='1'/>
      <backingStore/>
      <target dev='hda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05'
function='0x0'/>
    </disk>
    <controller type='usb' index='0' model='piix3-uhci'>
      <alias name='usb'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01'
function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pci-root'>
      <alias name='pci.0'/>
    </controller>
    <controller type='scsi' index='0' model='lsilogic'>
      <alias name='scsi0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04'
function='0x0'/>
    </controller>
    <interface type='network'>
      <mac address='e0:58:91:b9:3c:cd'/>
      <source network='default' portid='cd0c40d3-2faf-479e-990d-1a5956405a2e'
bridge='virbr0'/>
      <target dev='vnet0'/>
      <model type='virtio'/>
      <alias name='net0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
function='0x0'/>
    </interface>
    <interface type='network'>
      <mac address='8c:a0:a6:01:80:c5'/>
      <source network='minikube-net'
portid='23d86a93-40be-42c0-85e6-be14a3991f14' bridge='virbr1'/>
      <target dev='vnet1'/>
      <model type='virtio'/>
      <alias name='net1'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
function='0x0'/>
    </interface>
    <serial type='pty'>
      <source path='/dev/pts/3'/>
      <target type='isa-serial' port='0'>
        <model name='isa-serial'/>
      </target>
      <alias name='serial0'/>
    </serial>
    <console type='pty' tty='/dev/pts/3'>
      <source path='/dev/pts/3'/>
      <target type='serial' port='0'/>
      <alias name='serial0'/>
    </console>
    <input type='mouse' bus='ps2'>
      <alias name='input0'/>
    </input>
    <input type='keyboard' bus='ps2'>
      <alias name='input1'/>
    </input>
    <memballoon model='virtio'>
      <alias name='balloon0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06'
function='0x0'/>
    </memballoon>
    <rng model='virtio'>
      <backend model='random'>/dev/random</backend>
      <alias name='rng0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07'
function='0x0'/>
    </rng>
  </devices>
  <seclabel type='dynamic' model='dac' relabel='yes'>
    <label>+65534:+992</label>
    <imagelabel>+65534:+992</imagelabel>
  </seclabel>
</domain>
```

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
