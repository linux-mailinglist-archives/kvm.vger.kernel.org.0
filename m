Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943EF78CA81
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 19:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbjH2RPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 13:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237825AbjH2RPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 13:15:22 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDC5E70
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 10:14:46 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56f924de34fso3344852a12.2
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 10:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693329265; x=1693934065;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ahI8iyjZw36PW+SGypCxZc2SSBoi3VxST5CAkWkSc2U=;
        b=moYrQvN0h7JrtBn36G5gchH1T6gS6jF0QEEl6puKPt953vVwKNrakqEdQ5lWVNJfti
         /QTpkwDYI2/pyP7OuRSMCOL2Y69+xDhcqsAciceHurJQ7934PTn5+IRBHZvZtIW8vSSh
         M4Tax9dUxv1nxLnaC0Ne542MMEbf2kexJzNuLDNY4pFFgtIljYaa0+3FSeL6uENehqwt
         Wv+3gNbirfymcQt6NaEv2oVGQ/uA9uCMFW9r+UZxrdhha3jD/oGuYbv1roWKc/T4vkfG
         Vjgk2uzKH6vbNYDefjyoCL1iUCwQ8aefQv7FwFZFwioFRKfl4/gyVYYwaQoCu0HtBhPf
         mvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693329265; x=1693934065;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ahI8iyjZw36PW+SGypCxZc2SSBoi3VxST5CAkWkSc2U=;
        b=lfjmDjSuKu2JDs4mifYelOiGdcGTnUvO9LRLYI0+nM+Br64lc1/T4Kah9cZQHUEJoa
         jdWSQGyhV9KBPJB/NZpck02dgex4oAKxAeImxFL5FRT+6oQN4gF5lwWAQL582aqEg8WW
         EwSBNJoO+K64ODim1W2TpMWfb2d0sGmpfV/z+t5jhgW+K2N3W9BbCpX7eN2hY/s73Cpx
         wxARlq+Eg0ZAJV5QrHHvuxue+hajF1+U2SV8H5DUx+gTx8M1PPuowlfm1OuThExdtSIX
         o93ByQrIByKYgWXnbYZntKdBhgDTlIJhE49MibuPCs9T6FUuOH/iik8VZ5e20in5MtOk
         TPLA==
X-Gm-Message-State: AOJu0Yz/J1+Y8OpfTZovwOy46zcEV8s8f1Cx1/4qiiRtebMPdJBQIQXE
        zsFZ2xK55BrqU9t27Z6/oARwjwWpmYU=
X-Google-Smtp-Source: AGHT+IEHnkqOME5kKrmkS3D8dP5ttWBB6E7htY6MUv2/QlyWqsvzX4tHJHFpjcTIFGp4blBZ8BGZe/VoKqA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:77ce:0:b0:565:ea10:201a with SMTP id
 s197-20020a6377ce000000b00565ea10201amr5552004pgc.12.1693329265614; Tue, 29
 Aug 2023 10:14:25 -0700 (PDT)
Date:   Tue, 29 Aug 2023 10:14:23 -0700
In-Reply-To: <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
Mime-Version: 1.0
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de> <ZO2piz5n1MiKR-3-@debian.me>
 <ZO3sA2GuDbEuQoyj@torres.zugschlus.de> <ZO4GeazfcA09SfKw@google.com>
 <ZO4JCfnzRRL1RIZt@torres.zugschlus.de> <ZO4RzCr/Ugwi70bZ@google.com> <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
Message-ID: <ZO4nbzkd4tovKpxx@google.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd related
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Haber <mh+linux-kernel@zugschlus.de>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023, Marc Haber wrote:
> On Tue, Aug 29, 2023 at 08:42:04AM -0700, Sean Christopherson wrote:
> > On Tue, Aug 29, 2023, Marc Haber wrote:
> > > On Tue, Aug 29, 2023 at 07:53:45AM -0700, Sean Christopherson wrote:
> > > > What is different between the bad host(s) and the good host(s)?  E.=
g. kernel, QEMU,
> > >=20
> > > The bad host is an APU ("AMD GX-412TC SOC") with 4 GB of RAM, one of =
the
> > > good hosts is a "Xeon(R) CPU E3-1246 v3" with 32 GB of RAM.
> >=20
> > I don't expect it to help, but can you try booting the bad host with
> > "spec_rstack_overflow=3Doff"?
>=20
> That is destined to go on the kernel command line of the host, not the
> VM, right? I am asking because that host runs a set of VMs that are not
> that easy to reboot without impact on other services, I'd rather not do
> experiments with that.

Ah, yeah, in that case don't bother.

> The issue can be triggered and worked around by changing the VM only, I
> didn't touch the host other than some virsh incantations.
>=20
> >=20
> > > system configuration is from the same ansible playbook, but of
> > > course there are differences.
> >=20
> > Can you capture the QEMU command lines for the good and bad hosts?
> > KVM doesn't get directly involved in serial port emulation; if the
> > blamed commit in 6.5 is triggering unexpected behavior then QEMU is a
> > better starting point than KVM.
>=20
> the qmu command line of the test VM on the APU host is
>=20
> [14/4946]mh@prom:~ $ pstree -apl | grep [l]asso
>   |-qemu-system-x86,251092 -name guest=3Dlasso,debug-threads=3Don -S -obj=
ect secret,id=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qemu/domain=
-20-lasso/master-key.aes -machine pc-i440fx-2.1,accel=3Dkvm,usb=3Doff,dump-=
guest-core=3Doff -cpu Opteron_G3,monitor=3Doff,x2apic=3Don,hypervisor=3Don =
-m 768 -realtime mlock=3Doff -smp 1,sockets=3D1,cores=3D1,threads=3D1 -uuid=
 15338d79-b877-48da-b72f-f706bd05dadf -no-user-config -nodefaults -chardev =
socket,id=3Dcharmonitor,fd=3D30,server,nowait -mon chardev=3Dcharmonitor,id=
=3Dmonitor,mode=3Dcontrol -rtc base=3Dutc,driftfix=3Dslew -global kvm-pit.l=
ost_tick_policy=3Ddelay -no-hpet -no-shutdown -global PIIX4_PM.disable_s3=
=3D1 -global PIIX4_PM.disable_s4=3D1 -boot strict=3Don -device ich9-usb-ehc=
i1,id=3Dusb,bus=3Dpci.0,addr=3D0x5.0x7 -device ich9-usb-uhci1,masterbus=3Du=
sb.0,firstport=3D0,bus=3Dpci.0,multifunction=3Don,addr=3D0x5 -device ich9-u=
sb-uhci2,masterbus=3Dusb.0,firstport=3D2,bus=3Dpci.0,addr=3D0x5.0x1 -device=
 ich9-usb-uhci3,masterbus=3Dusb.0,firstport=3D4,bus=3Dpci.0,addr=3D0x5.0x2 =
-device virtio-serial-pci,id=3Dvirtio-serial0,bus=3Dpci.0,addr=3D0x6 -drive=
 file=3D/dev/prom/lasso,format=3Draw,if=3Dnone,id=3Ddrive-virtio-disk0,cach=
e=3Dnone,aio=3Dnative -device virtio-blk-pci,scsi=3Doff,bus=3Dpci.0,addr=3D=
0x7,drive=3Ddrive-virtio-disk0,id=3Dvirtio-disk0,bootindex=3D1,write-cache=
=3Don -drive file=3D/dev/prom/lasso-swap0,format=3Draw,if=3Dnone,id=3Ddrive=
-virtio-disk1,cache=3Dnone,aio=3Dnative -device virtio-blk-pci,scsi=3Doff,b=
us=3Dpci.0,addr=3D0x9,drive=3Ddrive-virtio-disk1,id=3Dvirtio-disk1,write-ca=
che=3Don -drive if=3Dnone,id=3Ddrive-ide0-0-0,readonly=3Don -device ide-cd,=
bus=3Dide.0,unit=3D0,drive=3Ddrive-ide0-0-0,id=3Dide0-0-0 -netdev tap,fd=3D=
33,id=3Dhostnet0,vhost=3Don,vhostfd=3D34 -device virtio-net-pci,netdev=3Dho=
stnet0,id=3Dnet0,mac=3D52:54:00:9e:9a:15,bus=3Dpci.0,addr=3D0x3 -chardev pt=
y,id=3Dcharserial0 -device isa-serial,chardev=3Dcharserial0,id=3Dserial0 -c=
hardev spicevmc,id=3Dcharchannel0,name=3Dvdagent -device virtserialport,bus=
=3Dvirtio-serial0.0,nr=3D1,chardev=3Dcharchannel0,id=3Dchannel0,name=3Dcom.=
redhat.spice.0 -device usb-tablet,id=3Dinput0,bus=3Dusb.0,port=3D1 -spice p=
ort=3D5902,addr=3D127.0.0.1,disable-ticketing,seamless-migration=3Don -devi=
ce qxl-vga,id=3Dvideo0,ram_size=3D67108864,vram_size=3D67108864,vram64_size=
_mb=3D0,vgamem_mb=3D16,max_outputs=3D1,bus=3Dpci.0,addr=3D0x2 -device intel=
-hda,id=3Dsound0,bus=3Dpci.0,addr=3D0x4 -device hda-duplex,id=3Dsound0-code=
c0,bus=3Dsound0.0,cad=3D0 -chardev spicevmc,id=3Dcharredir0,name=3Dusbredir=
 -device usb-redir,chardev=3Dcharredir0,id=3Dredir0,bus=3Dusb.0,port=3D2 -c=
hardev spicevmc,id=3Dcharredir1,name=3Dusbredir -device usb-redir,chardev=
=3Dcharredir1,id=3Dredir1,bus=3Dusb.0,port=3D3 -chardev spicevmc,id=3Dcharr=
edir2,name=3Dusbredir -device usb-redir,chardev=3Dcharredir2,id=3Dredir2,bu=
s=3Dusb.0,port=3D4 -chardev spicevmc,id=3Dcharredir3,name=3Dusbredir -devic=
e usb-redir,chardev=3Dcharredir3,id=3Dredir3,bus=3Dusb.0,port=3D5 -device v=
irtio-balloon-pci,id=3Dballoon0,bus=3Dpci.0,addr=3D0x8 -object rng-random,i=
d=3Dobjrng0,filename=3D/dev/urandom -device virtio-rng-pci,rng=3Dobjrng0,id=
=3Drng0,bus=3Dpci.0,addr=3D0xa -sandbox on,obsolete=3Ddeny,elevateprivilege=
s=3Ddeny,spawn=3Ddeny,resourcecontrol=3Ddeny -msg timestamp=3Don
> [15/4947]mh@prom:~ $
>=20
> a refrence qemu command line of a test VM on the Xeon host is
>=20
> [1/4992]mh@gancho:~ $ pstree -apl | grep '[w]hip'
>   |-qemu-system-x86,1478 -enable-kvm -name guest=3Dwhip,debug-threads=3Do=
n -S -object secret,id=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qe=
mu/domain-9-whip/master-key.aes -machine pc-i440fx-2.1,accel=3Dkvm,usb=3Dof=
f,dump-guest-core=3Doff -cpu Nehalem -m 512 -realtime mlock=3Doff -smp 2,so=
ckets=3D2,cores=3D1,threads=3D1 -uuid 3dd1f71d-3b84-44e2-808f-a5c67694f25c =
-no-user-config -nodefaults -chardev socket,id=3Dcharmonitor,fd=3D34,server=
,nowait -mon chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol -rtc base=3D=
utc,driftfix=3Dslew -global kvm-pit.lost_tick_policy=3Ddelay -no-hpet -no-s=
hutdown -global PIIX4_PM.disable_s3=3D1 -global PIIX4_PM.disable_s4=3D1 -bo=
ot strict=3Don -device ich9-usb-ehci1,id=3Dusb,bus=3Dpci.0,addr=3D0x5.0x7 -=
device ich9-usb-uhci1,masterbus=3Dusb.0,firstport=3D0,bus=3Dpci.0,multifunc=
tion=3Don,addr=3D0x5 -device ich9-usb-uhci2,masterbus=3Dusb.0,firstport=3D2=
,bus=3Dpci.0,addr=3D0x5.0x1 -device ich9-usb-uhci3,masterbus=3Dusb.0,firstp=
ort=3D4,bus=3Dpci.0,addr=3D0x5.0x2 -device virtio-scsi-pci,id=3Dscsi0,bus=
=3Dpci.0,addr=3D0x7 -device virtio-serial-pci,id=3Dvirtio-serial0,bus=3Dpci=
.0,addr=3D0x6 -drive file=3D/dev/gancho/whip,format=3Draw,if=3Dnone,id=3Ddr=
ive-scsi0-0-0-0,cache=3Dnone,aio=3Dnative -device scsi-hd,bus=3Dscsi0.0,cha=
nnel=3D0,scsi-id=3D0,lun=3D0,drive=3Ddrive-scsi0-0-0-0,id=3Dscsi0-0-0-0,boo=
tindex=3D1,write-cache=3Don -netdev tap,fd=3D36,id=3Dhostnet0,vhost=3Don,vh=
ostfd=3D37 -device virtio-net-pci,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:0=
0:5e:b4:42,bus=3Dpci.0,addr=3D0x3 -chardev pty,id=3Dcharserial0 -device isa=
-serial,chardev=3Dcharserial0,id=3Dserial0 -chardev socket,id=3Dcharchannel=
0,fd=3D38,server,nowait -device virtserialport,bus=3Dvirtio-serial0.0,nr=3D=
1,chardev=3Dcharchannel0,id=3Dchannel0,name=3Dorg.qemu.guest_agent.0 -chard=
ev spicevmc,id=3Dcharchannel1,name=3Dvdagent -device virtserialport,bus=3Dv=
irtio-serial0.0,nr=3D2,chardev=3Dcharchannel1,id=3Dchannel1,name=3Dcom.redh=
at.spice.0 -device usb-tablet,id=3Dinput0,bus=3Dusb.0,port=3D1 -spice port=
=3D5908,addr=3D127.0.0.1,disable-ticketing,seamless-migration=3Don -device =
qxl-vga,id=3Dvideo0,ram_size=3D67108864,vram_size=3D67108864,vram64_size_mb=
=3D0,vgamem_mb=3D16,max_outputs=3D1,bus=3Dpci.0,addr=3D0x2 -device intel-hd=
a,id=3Dsound0,bus=3Dpci.0,addr=3D0x4 -device hda-duplex,id=3Dsound0-codec0,=
bus=3Dsound0.0,cad=3D0 -chardev spicevmc,id=3Dcharredir0,name=3Dusbredir -d=
evice usb-redir,chardev=3Dcharredir0,id=3Dredir0,bus=3Dusb.0,port=3D2 -char=
dev spicevmc,id=3Dcharredir1,name=3Dusbredir -device usb-redir,chardev=3Dch=
arredir1,id=3Dredir1,bus=3Dusb.0,port=3D3 -device virtio-balloon-pci,id=3Db=
alloon0,bus=3Dpci.0,addr=3D0x8 -object rng-random,id=3Dobjrng0,filename=3D/=
dev/urandom -device virtio-rng-pci,rng=3Dobjrng0,id=3Drng0,bus=3Dpci.0,addr=
=3D0x9 -sandbox on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,re=
sourcecontrol=3Ddeny -msg timestamp=3Don
> [2/4993]mh@gancho:~ $
>=20
> Both come from virt-manager, so if the XML helps more, I'll happy to
> post that as well.

Those command lines are quite different, e.g. the Intel one has two serial =
ports
versus one for the AMD VM.  Unless Tony jumps in with an idea, I would try =
massaging
either the good or bad VM's QEMU invocation, e.g. see if you can get the AM=
D VM
to "pass" by pulling in stuff from the Intel VM, or get the Intel VM to fai=
l by
making its command line look more like the AMD VM.
