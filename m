Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFB178C95A
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbjH2QJo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 29 Aug 2023 12:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjH2QJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 12:09:17 -0400
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B20A1A6;
        Tue, 29 Aug 2023 09:09:14 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qb1HC-002bdr-1L;
        Tue, 29 Aug 2023 18:09:10 +0200
Date:   Tue, 29 Aug 2023 18:09:10 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <ZO4YJlhHYjM7MsK4@torres.zugschlus.de>
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de>
 <ZO2piz5n1MiKR-3-@debian.me>
 <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
 <ZO4GeazfcA09SfKw@google.com>
 <ZO4JCfnzRRL1RIZt@torres.zugschlus.de>
 <ZO4RzCr/Ugwi70bZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <ZO4RzCr/Ugwi70bZ@google.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023 at 08:42:04AM -0700, Sean Christopherson wrote:
> On Tue, Aug 29, 2023, Marc Haber wrote:
> > On Tue, Aug 29, 2023 at 07:53:45AM -0700, Sean Christopherson wrote:
> > > What is different between the bad host(s) and the good host(s)?  E.g. kernel, QEMU,
> > 
> > The bad host is an APU ("AMD GX-412TC SOC") with 4 GB of RAM, one of the
> > good hosts is a "Xeon(R) CPU E3-1246 v3" with 32 GB of RAM.
> 
> I don't expect it to help, but can you try booting the bad host with
> "spec_rstack_overflow=off"?

That is destined to go on the kernel command line of the host, not the
VM, right? I am asking because that host runs a set of VMs that are not
that easy to reboot without impact on other services, I'd rather not do
experiments with that.

The issue can be triggered and worked around by changing the VM only, I
didn't touch the host other than some virsh incantations.

> 
> > system configuration is from the same ansible playbook, but of
> > course there are differences.
> 
> Can you capture the QEMU command lines for the good and bad hosts?
> KVM doesn't get directly involved in serial port emulation; if the
> blamed commit in 6.5 is triggering unexpected behavior then QEMU is a
> better starting point than KVM.

the qmu command line of the test VM on the APU host is

[14/4946]mh@prom:~ $ pstree -apl | grep [l]asso
  |-qemu-system-x86,251092 -name guest=lasso,debug-threads=on -S -object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-20-lasso/master-key.aes -machine pc-i440fx-2.1,accel=kvm,usb=off,dump-guest-core=off -cpu Opteron_G3,monitor=off,x2apic=on,hypervisor=on -m 768 -realtime mlock=off -smp 1,sockets=1,cores=1,threads=1 -uuid 15338d79-b877-48da-b72f-f706bd05dadf -no-user-config -nodefaults -chardev socket,id=charmonitor,fd=30,server,nowait -mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew -global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 -boot strict=on -device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x5.0x7 -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x5 -device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x5.0x1 -device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x5.0x2 -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 -drive file=/dev/prom/lasso,format=raw,if=none,id=drive-virtio-disk0,cache=none,aio=native -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x7,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1,write-cache=on -drive file=/dev/prom/lasso-swap0,format=raw,if=none,id=drive-virtio-disk1,cache=none,aio=native -device virtio-blk-pci,scsi=off,bus=pci.0,addr=0x9,drive=drive-virtio-disk1,id=virtio-disk1,write-cache=on -drive if=none,id=drive-ide0-0-0,readonly=on -device ide-cd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0 -netdev tap,fd=33,id=hostnet0,vhost=on,vhostfd=34 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:9e:9a:15,bus=pci.0,addr=0x3 -chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 -chardev spicevmc,id=charchannel0,name=vdagent -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=com.redhat.spice.0 -device usb-tablet,id=input0,bus=usb.0,port=1 -spice port=5902,addr=127.0.0.1,disable-ticketing,seamless-migration=on -device qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vgamem_mb=16,max_outputs=1,bus=pci.0,addr=0x2 -device intel-hda,id=sound0,bus=pci.0,addr=0x4 -device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 -chardev spicevmc,id=charredir0,name=usbredir -device usb-redir,chardev=charredir0,id=redir0,bus=usb.0,port=2 -chardev spicevmc,id=charredir1,name=usbredir -device usb-redir,chardev=charredir1,id=redir1,bus=usb.0,port=3 -chardev spicevmc,id=charredir2,name=usbredir -device usb-redir,chardev=charredir2,id=redir2,bus=usb.0,port=4 -chardev spicevmc,id=charredir3,name=usbredir -device usb-redir,chardev=charredir3,id=redir3,bus=usb.0,port=5 -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x8 -object rng-random,id=objrng0,filename=/dev/urandom -device virtio-rng-pci,rng=objrng0,id=rng0,bus=pci.0,addr=0xa -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny -msg timestamp=on
[15/4947]mh@prom:~ $

a refrence qemu command line of a test VM on the Xeon host is

[1/4992]mh@gancho:~ $ pstree -apl | grep '[w]hip'
  |-qemu-system-x86,1478 -enable-kvm -name guest=whip,debug-threads=on -S -object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-9-whip/master-key.aes -machine pc-i440fx-2.1,accel=kvm,usb=off,dump-guest-core=off -cpu Nehalem -m 512 -realtime mlock=off -smp 2,sockets=2,cores=1,threads=1 -uuid 3dd1f71d-3b84-44e2-808f-a5c67694f25c -no-user-config -nodefaults -chardev socket,id=charmonitor,fd=34,server,nowait -mon chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew -global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1 -boot strict=on -device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x5.0x7 -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x5 -device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x5.0x1 -device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x5.0x2 -device virtio-scsi-pci,id=scsi0,bus=pci.0,addr=0x7 -device virtio-serial-pci,id=virtio-serial0,bus=pci.0,addr=0x6 -drive file=/dev/gancho/whip,format=raw,if=none,id=drive-scsi0-0-0-0,cache=none,aio=native -device scsi-hd,bus=scsi0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0-0-0-0,id=scsi0-0-0-0,bootindex=1,write-cache=on -netdev tap,fd=36,id=hostnet0,vhost=on,vhostfd=37 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:5e:b4:42,bus=pci.0,addr=0x3 -chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0 -chardev socket,id=charchannel0,fd=38,server,nowait -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_agent.0 -chardev spicevmc,id=charchannel1,name=vdagent -device virtserialport,bus=virtio-serial0.0,nr=2,chardev=charchannel1,id=channel1,name=com.redhat.spice.0 -device usb-tablet,id=input0,bus=usb.0,port=1 -spice port=5908,addr=127.0.0.1,disable-ticketing,seamless-migration=on -device qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vgamem_mb=16,max_outputs=1,bus=pci.0,addr=0x2 -device intel-hda,id=sound0,bus=pci.0,addr=0x4 -device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 -chardev spicevmc,id=charredir0,name=usbredir -device usb-redir,chardev=charredir0,id=redir0,bus=usb.0,port=2 -chardev spicevmc,id=charredir1,name=usbredir -device usb-redir,chardev=charredir1,id=redir1,bus=usb.0,port=3 -device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x8 -object rng-random,id=objrng0,filename=/dev/urandom -device virtio-rng-pci,rng=objrng0,id=rng0,bus=pci.0,addr=0x9 -sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny -msg timestamp=on
[2/4993]mh@gancho:~ $

Both come from virt-manager, so if the XML helps more, I'll happy to
post that as well.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
