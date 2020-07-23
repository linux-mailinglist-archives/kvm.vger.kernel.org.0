Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7043A22B5CA
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 20:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgGWSgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 14:36:06 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726666AbgGWSgE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 14:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595529361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjMEMo7D/ooHPdAOuZ5F7N2yj6cdYx6amr6g21w93l4=;
        b=ZZsr1bPnelz/J5ivl39tvB+4efudt4y64H2QeM1eKhkVRKSPfaKKC5I7HoQ42q8JmdcVNP
        XjfI0nZIuiLjsQqm6OrDZdof1FfCcDQa4S8nhYmH0QSn6OIo22S7tTWY0uSOWuEg6FoFBy
        C79Uiob16rEmTsAqzQJljaA4Sdvloy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-BZ3USn77Ohi5QhFdIZo0QA-1; Thu, 23 Jul 2020 14:35:56 -0400
X-MC-Unique: BZ3USn77Ohi5QhFdIZo0QA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94D67800688;
        Thu, 23 Jul 2020 18:35:53 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62EA15C221;
        Thu, 23 Jul 2020 18:35:50 +0000 (UTC)
Date:   Thu, 23 Jul 2020 12:35:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Wayne Boyer <wayne.boyer@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Weijiang Yang <weijiang.yang@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add capability to zap only sptes for the
 affected memslot
Message-ID: <20200723123544.6268b465@w520.home>
In-Reply-To: <20200723155711.GD21891@linux.intel.com>
References: <20200703025047.13987-1-sean.j.christopherson@intel.com>
        <51637a13-f23b-8b76-c93a-76346b4cc982@redhat.com>
        <20200709211253.GW24919@linux.intel.com>
        <49c7907a-3ab4-b5db-ccb4-190b990c8be3@redhat.com>
        <20200710042922.GA24919@linux.intel.com>
        <20200713122226.28188f93@x1.home>
        <20200713190649.GE29725@linux.intel.com>
        <20200721030319.GD20375@linux.intel.com>
        <20200721100036.464d4440@w520.home>
        <20200723155711.GD21891@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jul 2020 08:57:11 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> On Tue, Jul 21, 2020 at 10:00:36AM -0600, Alex Williamson wrote:
> > On Mon, 20 Jul 2020 20:03:19 -0700
> > Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >  =20
> > > +Weijiang
> > >=20
> > > On Mon, Jul 13, 2020 at 12:06:50PM -0700, Sean Christopherson wrote: =
=20
> > > > The only ideas I have going forward are to:
> > > >=20
> > > >   a) Reproduce the bug outside of your environment and find a resou=
rce that
> > > >      can go through the painful bisection.   =20
> > >=20
> > > We're trying to reproduce the original issue in the hopes of biesecti=
ng, but
> > > have not yet discovered the secret sauce.  A few questions:
> > >=20
> > >   - Are there any known hardware requirements, e.g. specific flavor o=
f GPU? =20
> >=20
> > I'm using an old GeForce GT635, I don't think there's anything special
> > about this card. =20
>=20
> Would you be able to provide your QEMU command line?  Or at least any
> potentially relevant bits?  Still no luck reproducing this on our end.

XML:

<domain type=3D'kvm'>
  <name>GeForce</name>
  <uuid>2b417d4b-f25b-4522-a5be-e105f032f99c</uuid>
  <memory unit=3D'KiB'>4194304</memory>
  <currentMemory unit=3D'KiB'>4194304</currentMemory>
  <memoryBacking>
    <hugepages/>
  </memoryBacking>
  <vcpu placement=3D'static'>4</vcpu>
  <cputune>
    <vcpupin vcpu=3D'0' cpuset=3D'3'/>
    <vcpupin vcpu=3D'1' cpuset=3D'7'/>
    <vcpupin vcpu=3D'2' cpuset=3D'2'/>
    <vcpupin vcpu=3D'3' cpuset=3D'6'/>
    <emulatorpin cpuset=3D'0,4'/>
  </cputune>
  <os>
    <type arch=3D'x86_64' machine=3D'pc-i440fx-5.0'>hvm</type>
    <loader readonly=3D'yes' type=3D'pflash'>/usr/share/edk2/ovmf/OVMF_CODE=
.fd</loader>
    <nvram template=3D'/usr/share/edk2/ovmf/OVMF_VARS.fd'>/var/lib/libvirt/=
qemu/nvram/GeForce_VARS.fd</nvram>
    <bootmenu enable=3D'yes'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
    <hyperv>
      <relaxed state=3D'on'/>
      <vapic state=3D'on'/>
      <spinlocks state=3D'on' retries=3D'8191'/>
      <vendor_id state=3D'on' value=3D'KeenlyKVM'/>
    </hyperv>
    <kvm>
      <hidden state=3D'on'/>
    </kvm>
    <vmport state=3D'off'/>
  </features>
  <cpu mode=3D'custom' match=3D'exact' check=3D'none'>
    <model fallback=3D'allow'>IvyBridge-IBRS</model>
    <topology sockets=3D'1' dies=3D'1' cores=3D'4' threads=3D'1'/>
  </cpu>
  <clock offset=3D'localtime'>
    <timer name=3D'rtc' tickpolicy=3D'catchup'/>
    <timer name=3D'pit' tickpolicy=3D'delay'/>
    <timer name=3D'hpet' present=3D'no'/>
    <timer name=3D'hypervclock' present=3D'yes'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>
  <devices>
    <emulator>/usr/local/bin/qemu-system-x86_64</emulator>
    <disk type=3D'file' device=3D'disk'>
      <driver name=3D'qemu' type=3D'qcow2' cache=3D'none'/>
      <source file=3D'/mnt/ssd/GeForce.qcow2'/>
      <target dev=3D'sda' bus=3D'scsi'/>
      <boot order=3D'2'/>
      <address type=3D'drive' controller=3D'0' bus=3D'0' target=3D'0' unit=
=3D'0'/>
    </disk>
    <controller type=3D'scsi' index=3D'0' model=3D'virtio-scsi'>
      <driver queues=3D'4'/>
      <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x05' fu=
nction=3D'0x0'/>
    </controller>
    <controller type=3D'pci' index=3D'0' model=3D'pci-root'/>
    <controller type=3D'usb' index=3D'0' model=3D'nec-xhci'>
      <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x08' fu=
nction=3D'0x0'/>
    </controller>
    <interface type=3D'direct'>
      <mac address=3D'52:54:00:60:ef:ac'/>
      <source dev=3D'enp4s0' mode=3D'bridge'/>
      <model type=3D'virtio'/>
      <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x03' fu=
nction=3D'0x0'/>
    </interface>
    <input type=3D'mouse' bus=3D'ps2'/>
    <input type=3D'keyboard' bus=3D'ps2'/>
    <hostdev mode=3D'subsystem' type=3D'pci' managed=3D'yes'>
      <source>
        <address domain=3D'0x0000' bus=3D'0x01' slot=3D'0x00' function=3D'0=
x0'/>
      </source>
      <rom bar=3D'on'/>
      <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x04' fu=
nction=3D'0x0'/>
    </hostdev>
    <hostdev mode=3D'subsystem' type=3D'pci' managed=3D'yes'>
      <source>
        <address domain=3D'0x0000' bus=3D'0x01' slot=3D'0x00' function=3D'0=
x1'/>
      </source>
      <rom bar=3D'off'/>
      <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x06' fu=
nction=3D'0x0'/>
    </hostdev>
    <memballoon model=3D'none'/>
  </devices>
</domain>

=46rom libvirt log:

LC_ALL=3DC \
PATH=3D/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin \
HOME=3D/var/lib/libvirt/qemu/domain-1-GeForce \
XDG_DATA_HOME=3D/var/lib/libvirt/qemu/domain-1-GeForce/.local/share \
XDG_CACHE_HOME=3D/var/lib/libvirt/qemu/domain-1-GeForce/.cache \
XDG_CONFIG_HOME=3D/var/lib/libvirt/qemu/domain-1-GeForce/.config \
QEMU_AUDIO_DRV=3Dnone \
/usr/local/bin/qemu-system-x86_64 \
-name guest=3DGeForce,debug-threads=3Don \
-S \
-object secret,id=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qemu/do=
main-1-GeForce/master-key.aes \
-blockdev '{"driver":"file","filename":"/usr/share/edk2/ovmf/OVMF_CODE.fd",=
"node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unma=
p"}' \
-blockdev '{"node-name":"libvirt-pflash0-format","read-only":true,"driver":=
"raw","file":"libvirt-pflash0-storage"}' \
-blockdev '{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/GeForce=
_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"disc=
ard":"unmap"}' \
-blockdev '{"node-name":"libvirt-pflash1-format","read-only":false,"driver"=
:"raw","file":"libvirt-pflash1-storage"}' \
-machine pc-i440fx-5.0,accel=3Dkvm,usb=3Doff,vmport=3Doff,dump-guest-core=
=3Doff,pflash0=3Dlibvirt-pflash0-format,pflash1=3Dlibvirt-pflash1-format \
-cpu IvyBridge-IBRS,hv-time,hv-relaxed,hv-vapic,hv-spinlocks=3D0x1fff,hv-ve=
ndor-id=3DKeenlyKVM,kvm=3Doff \
-m 4096 \
-mem-prealloc \
-mem-path /dev/hugepages/libvirt/qemu/1-GeForce \
-overcommit mem-lock=3Doff \
-smp 4,sockets=3D1,dies=3D1,cores=3D4,threads=3D1 \
-uuid 2b417d4b-f25b-4522-a5be-e105f032f99c \
-display none \
-no-user-config \
-nodefaults \
-chardev socket,id=3Dcharmonitor,fd=3D36,server,nowait \
-mon chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol \
-rtc base=3Dlocaltime,driftfix=3Dslew \
-global kvm-pit.lost_tick_policy=3Ddelay \
-no-hpet \
-no-shutdown \
-boot menu=3Don,strict=3Don \
-device nec-usb-xhci,id=3Dusb,bus=3Dpci.0,addr=3D0x8 \
-device virtio-scsi-pci,id=3Dscsi0,num_queues=3D4,bus=3Dpci.0,addr=3D0x5 \
-blockdev '{"driver":"file","filename":"/mnt/ssd/GeForce-2019-08-02.img","n=
ode-name":"libvirt-2-storage","cache":{"direct":true,"no-flush":false},"aut=
o-read-only":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-2-format","read-only":true,"cache":{"direc=
t":true,"no-flush":false},"driver":"raw","file":"libvirt-2-storage"}' \
-blockdev '{"driver":"file","filename":"/mnt/ssd/Geforce.qcow2","node-name"=
:"libvirt-1-storage","cache":{"direct":true,"no-flush":false},"auto-read-on=
ly":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-1-format","read-only":false,"cache":{"dire=
ct":true,"no-flush":false},"driver":"qcow2","file":"libvirt-1-storage","bac=
king":"libvirt-2-format"}' \
-device scsi-hd,bus=3Dscsi0.0,channel=3D0,scsi-id=3D0,lun=3D0,device_id=3Dd=
rive-scsi0-0-0-0,drive=3Dlibvirt-1-format,id=3Dscsi0-0-0-0,bootindex=3D2,wr=
ite-cache=3Don \
-netdev tap,fd=3D38,id=3Dhostnet0,vhost=3Don,vhostfd=3D40 \
-device virtio-net-pci,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:60:ef:ac,=
bus=3Dpci.0,addr=3D0x3 \
-device vfio-pci,host=3D0000:01:00.0,id=3Dhostdev0,bus=3Dpci.0,addr=3D0x4,r=
ombar=3D1 \
-device vfio-pci,host=3D0000:01:00.1,id=3Dhostdev1,bus=3Dpci.0,addr=3D0x6,r=
ombar=3D0 \
-sandbox on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcec=
ontrol=3Ddeny \
-msg timestamp=3Don

