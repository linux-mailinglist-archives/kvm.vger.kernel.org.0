Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952E62423CB
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 03:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgHLBer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 21:34:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57510 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726507AbgHLBeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597196083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jNPw/VwlKs0T+9yxLNnVrJ8hQQDWec0GVRS6+g3AueA=;
        b=Fn3ZEmaPX5NR5i99kG+vyH5KahrVTWSF7WbZ9bs4y95qv3eVgF2h0APWHj8P1xy0rfY3LB
        luwkex5aQUL3/Fy+Th1GKU2rV31NlTHQA+XwZicw8RR6qP6uUhx5XEuIvjY6JVMK/MfbxX
        cU22ZoClhQD0B451KR6XKkx2zRN1AGY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-E3ZsdgZzOgG_hdKgZbGnNA-1; Tue, 11 Aug 2020 21:34:39 -0400
X-MC-Unique: E3ZsdgZzOgG_hdKgZbGnNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DD3310059A2;
        Wed, 12 Aug 2020 01:34:38 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E42F260E1C;
        Wed, 12 Aug 2020 01:34:37 +0000 (UTC)
Date:   Tue, 11 Aug 2020 19:34:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH] kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes
Message-ID: <20200811193437.286ba711@x1.home>
In-Reply-To: <20200707223630.336700-1-jmattson@google.com>
References: <20200707223630.336700-1-jmattson@google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jul 2020 15:36:30 -0700
Jim Mattson <jmattson@google.com> wrote:

> According to the SDM, when PAE paging would be in use following a
> MOV-to-CR0 that modifies any of CR0.CD, CR0.NW, or CR0.PG, then the
> PDPTEs are loaded from the address in CR3. Previously, kvm only loaded
> the PDPTEs when PAE paging would be in use following a MOV-to-CR0 that
> modified CR0.PG.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---

I can't even boot the simplest edk2 VM with this commit:

qemu-system-x86-core-5.0.0-2.fc32.x86_64
edk2-ovmf-20200201stable-1.fc32.noarch

<domain type="kvm">
  <name>vm1</name>
  <uuid>5ef9bfbe-46d9-4760-97a9-1290d2751908</uuid>
  <memory unit="KiB">1048576</memory>
  <currentMemory unit="KiB">1048576</currentMemory>
  <vcpu placement="static">1</vcpu>
  <os>
    <type arch="x86_64" machine="pc-i440fx-5.0">hvm</type>
    <loader readonly="yes"
type="pflash">/usr/share/edk2/ovmf/OVMF_CODE.fd</loader>
<nvram>/var/lib/libvirt/qemu/nvram/vm1_VARS.fd</nvram> <boot
dev="network"/> </os>
  <features>
    <acpi/>
    <apic/>
    <vmport state="off"/>
  </features>
  <cpu mode="host-model" check="partial"/>
  <clock offset="utc">
    <timer name="rtc" tickpolicy="catchup"/>
    <timer name="pit" tickpolicy="delay"/>
    <timer name="hpet" present="no"/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <pm>
    <suspend-to-mem enabled="no"/>
    <suspend-to-disk enabled="no"/>
  </pm>
  <devices>
    <emulator>/usr/bin/qemu-kvm</emulator>
    <controller type="usb" index="0" model="ich9-ehci1">
      <address type="pci" domain="0x0000" bus="0x00" slot="0x05"
function="0x7"/> </controller>
    <controller type="usb" index="0" model="ich9-uhci1">
      <master startport="0"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x05"
function="0x0" multifunction="on"/> </controller>
    <controller type="usb" index="0" model="ich9-uhci2">
      <master startport="2"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x05"
function="0x1"/> </controller>
    <controller type="usb" index="0" model="ich9-uhci3">
      <master startport="4"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x05"
function="0x2"/> </controller>
    <controller type="pci" index="0" model="pci-root"/>
    <interface type="direct">
      <mac address="52:54:00:62:fe:f4"/>
      <source dev="enp4s0" mode="bridge"/>
      <model type="e1000"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x03"
function="0x0"/> </interface>
    <input type="mouse" bus="ps2"/>
    <input type="keyboard" bus="ps2"/>
    <graphics type="vnc" port="-1" autoport="yes">
      <listen type="address"/>
    </graphics>
    <video>
      <model type="vga" vram="16384" heads="1" primary="yes"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x02"
function="0x0"/> </video>
    <memballoon model="virtio">
      <address type="pci" domain="0x0000" bus="0x00" slot="0x07"
function="0x0"/> </memballoon>
  </devices>
</domain>


/usr/bin/qemu-kvm \
-name guest=vm1,debug-threads=on \
-S \
-object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-3-vm1/master-key.aes \
-blockdev '{"driver":"file","filename":"/usr/share/edk2/ovmf/OVMF_CODE.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}' \
-blockdev '{"driver":"file","filename":"/var/lib/libvirt/qemu/nvram/vm1_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}' \
-blockdev '{"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}' \
-machine pc-i440fx-5.0,accel=kvm,usb=off,vmport=off,dump-guest-core=off,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format \
-cpu IvyBridge-IBRS,ss=on,vmx=on,pdcm=on,pcid=on,hypervisor=on,arat=on,tsc-adjust=on,umip=on,md-clear=on,stibp=on,arch-capabilities=on,ssbd=on,xsaveopt=on,ibpb=on,amd-ssbd=on,skip-l1dfl-vmentry=on,pschange-mc-no=on \
-m 1024 \
-overcommit mem-lock=off \
-smp 1,sockets=1,cores=1,threads=1 \
-uuid 5ef9bfbe-46d9-4760-97a9-1290d2751908 \
-no-user-config \
-nodefaults \
-chardev socket,id=charmonitor,fd=36,server,nowait \
-mon chardev=charmonitor,id=monitor,mode=control \
-rtc base=utc,driftfix=slew \
-global kvm-pit.lost_tick_policy=delay \
-no-hpet \
-no-shutdown \
-global PIIX4_PM.disable_s3=1 \
-global PIIX4_PM.disable_s4=1 \
-boot strict=on \
-device ich9-usb-ehci1,id=usb,bus=pci.0,addr=0x5.0x7 \
-device ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pci.0,multifunction=on,addr=0x5 \
-device ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pci.0,addr=0x5.0x1 \
-device ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pci.0,addr=0x5.0x2 \
-netdev tap,fd=38,id=hostnet0 \
-device e1000,netdev=hostnet0,id=net0,mac=52:54:00:62:fe:f4,bus=pci.0,addr=0x3,bootindex=1 \
-vnc 127.0.0.1:0 \
-device VGA,id=video0,vgamem_mb=16,bus=pci.0,addr=0x2 \
-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x7 \
-sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny \
-msg timestamp=on

The graphics display is never initialized.  Found via bisect, reverting 
d42e3fae6fae against 00e4db51259a resolve the issue.  Thanks,

Alex

>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..5a91c975487d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -775,6 +775,7 @@ EXPORT_SYMBOL_GPL(pdptrs_changed);
>  int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  {
>  	unsigned long old_cr0 = kvm_read_cr0(vcpu);
> +	unsigned long pdptr_bits = X86_CR0_CD | X86_CR0_NW | X86_CR0_PG;
>  	unsigned long update_bits = X86_CR0_PG | X86_CR0_WP;
>  
>  	cr0 |= X86_CR0_ET;
> @@ -792,9 +793,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
>  		return 1;
>  
> -	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
> +	if (cr0 & X86_CR0_PG) {
>  #ifdef CONFIG_X86_64
> -		if ((vcpu->arch.efer & EFER_LME)) {
> +		if (!is_paging(vcpu) && (vcpu->arch.efer & EFER_LME)) {
>  			int cs_db, cs_l;
>  
>  			if (!is_pae(vcpu))
> @@ -804,8 +805,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  				return 1;
>  		} else
>  #endif
> -		if (is_pae(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
> -						 kvm_read_cr3(vcpu)))
> +		if (is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
> +		    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
>  			return 1;
>  	}
>  

