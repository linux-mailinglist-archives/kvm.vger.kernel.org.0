Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2237E3932D9
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhE0Pu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 11:50:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229732AbhE0Puy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 11:50:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622130560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3A/8aMKrYCFcSkywAwP15MCzraIxFgLHfugJjZv14E=;
        b=UwRerj6q21bPPRKFLzhLfJfZWvmiCghNiwSMaoetf3SvcnBbG1UcllDLaryXTNqxZd/cGm
        7owILTSX2eU6uSNyjRSTG/aKR6M9pFB/FUYRkKmeQyojoe8KUz1saNQ/pvGJ3LAxj0C5jz
        rxiHebX3W4IJzlwad3Hx7taE0lDCOPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-gtGEQbHMNFOKxr66SUjHGQ-1; Thu, 27 May 2021 11:49:19 -0400
X-MC-Unique: gtGEQbHMNFOKxr66SUjHGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8044E7B40;
        Thu, 27 May 2021 15:49:17 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D52BE60CDE;
        Thu, 27 May 2021 15:49:14 +0000 (UTC)
Message-ID: <bebc01e5e5cf0c8897c4b29f6139b709902fe527.camel@redhat.com>
Subject: Re: [PATCH v2 0/5] KVM: x86: hyper-v: Conditionally allow SynIC
 with APICv/AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date:   Thu, 27 May 2021 18:49:13 +0300
In-Reply-To: <874keo7ew5.fsf@vitty.brq.redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
         <2409eb8593804eb879ae6fb961a709ca8c20f329.camel@redhat.com>
         <874keo7ew5.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-27 at 10:35 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> > > Changes since v1 (Sean):
> > > - Use common 'enable_apicv' variable for both APICv and AVIC instead of 
> > >  adding a new hook to 'struct kvm_x86_ops'.
> > > - Drop unneded CONFIG_X86_LOCAL_APIC checks from VMX/SVM code along the
> > >  way.
> > > 
> > > Original description:
> > > 
> > > APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> > > SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> > > however, possible to track whether the feature was actually used by the
> > > guest and only inhibit APICv/AVIC when needed.
> > > 
> > > The feature can be tested with QEMU's 'hv-passthrough' debug mode.
> > > 
> > > Note, 'avic' kvm-amd module parameter is '0' by default and thus needs to
> > > be explicitly enabled.
> > > 
> > > Vitaly Kuznetsov (5):
> > >   KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC check for AVIC
> > >   KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC check from
> > >     cpu_has_vmx_posted_intr()
> > >   KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
> > >   KVM: x86: Invert APICv/AVIC enablement check
> > >   KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
> > >     use
> > > 
> > >  arch/x86/include/asm/kvm_host.h |  5 ++++-
> > >  arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
> > >  arch/x86/kvm/svm/avic.c         | 16 +++++-----------
> > >  arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
> > >  arch/x86/kvm/svm/svm.h          |  2 --
> > >  arch/x86/kvm/vmx/capabilities.h |  4 +---
> > >  arch/x86/kvm/vmx/vmx.c          |  2 --
> > >  arch/x86/kvm/x86.c              |  9 ++++++---
> > >  8 files changed, 50 insertions(+), 39 deletions(-)
> > > 
> > 
> > I tested this patch set and this is what I found.
> > 
> > For reference,
> > First of all, indeed to make AVIC work I need to:
> >  
> > 1. Disable SVM - I wonder if I can make this on demand
> > too when the guest actually uses a nested guest or at least
> > enables nesting in IA32_FEATURE_CONTROL.
> > I naturally run most of my VMs with nesting enabled,
> > thus I tend to not have avic enabled due to this.
> > I'll prepare a patch soon for this.
> >  
> > 2. Disable x2apic, naturally x2apic can't be used with avic.
> > In theory we can also disable avic when the guest switches on
> > the x2apic mode, but in practice the guest will likely to pick the x2apic
> > when it can.
> >  
> > 3. (for hyperv) Disable 'hv_vapic', because otherwise hyper-v
> > uses its own PV APIC msrs which AVIC doesn't support.
> > 
> > This HV enlightment turns on in the CPUID both the 
> > HV_APIC_ACCESS_AVAILABLE which isn't that bad 
> > (it only tells that we have the VP assist page),
> > and HV_APIC_ACCESS_RECOMMENDED which hints the guest
> > to use HyperV PV APIC MSRS and use PV EOI field in 
> > the APIC access page, which means that the guest 
> > won't use the real apic at all.
> > 
> > 4. and of course enable SynIC autoeoi deprecation.
> > 
> > Otherwise indeed windows enables autoeoi.
> > 
> > hv-passthrough indeed can't be used to test this
> > as it both enables autoeoi depreciation and *hv-vapic*. 
> > I had to use the patch that you posted
> > in 'About the performance of hyper-v' thread.
> >  
> > In addition to that when I don't use the autoeoi depreciation patch,
> > then the guest indeed enables autoeoi, and this triggers a deadlock.
> >  
> 
> Hm, why don't I see in my testing? I'm pretty sure I'm testing both
> cases...

Hi!

For me it hangs when windows enables the autoeoi for the first time.

I use 5.13-rc3 kernel with kvm/queue merged, your patches and some my patches
that shouldn't affect things. 
I use qemu commit 3791642c8d60029adf9b00bcb4e34d7d8a1aea4d

I use the following qemu command line:

/home/mlevitsk/Qemu/master/build-master/output/bin/qemu-system-x86_64
-smp 4
-name debug-threads=on
-pidfile /run/vmspawn/win10_ojiejx07/qemu.pid
-accel kvm,kernel-irqchip=on
-nodefaults
-display none
-smp maxcpus=64,sockets=1,cores=32,threads=2
-machine q35,sata=off,usb=off,vmport=off,smbus=off
-rtc base=localtime,clock=host
-global mc146818rtc.lost_tick_policy=discard
-global kvm-pit.lost_tick_policy=discard
-no-hpet
-global ICH9-LPC.disable_s3=1
-global ICH9-LPC.disable_s4=1
-boot menu=on,strict=on,splash-time=1000
-L .bios
-machine pflash0=flash0,pflash1=flash1,smm=off
-blockdev node-name=flash0,driver=file,filename=./.bios/OVMF_CODE_nosmm.fd,read-only=on
-blockdev node-name=flash1,driver=file,filename=./.bios/OVMF_VARS.fd
-device pcie-root-port,slot=0,id=rport.0,bus=pcie.0,addr=0x1c.0x0,multifunction=on
-device pcie-root-port,slot=1,id=rport.1,bus=pcie.0,addr=0x1c.0x1
-device pcie-root-port,slot=2,id=rport.2,bus=pcie.0,addr=0x1c.0x2
-device pcie-root-port,slot=3,id=rport.3,bus=pcie.0,addr=0x1c.0x3
-device pcie-root-port,slot=4,id=rport.4,bus=pcie.0,addr=0x1c.0x4
-device pcie-root-port,slot=5,id=rport.5,bus=pcie.0,addr=0x1c.0x5
-device pcie-root-port,slot=6,id=rport.6,bus=pcie.0,addr=0x1c.0x6
-device pcie-root-port,slot=7,id=rport.7,bus=pcie.0,addr=0x1c.0x7
-device pcie-root-port,slot=8,id=rport.8,bus=pcie.0,addr=0x1d.0x0,multifunction=on
-device pcie-root-port,slot=9,id=rport.9,bus=pcie.0,addr=0x1d.0x1
-device pcie-root-port,slot=10,id=rport.10,bus=pcie.0,addr=0x1d.0x2
-device pcie-root-port,slot=11,id=rport.11,bus=pcie.0,addr=0x1d.0x3
-cpu host,host-cache-info,hv_relaxed,hv_spinlocks=0x1fff,hv_vpindex,hv_runtime,hv_synic,hv-tlbflush,hv-frequencies,hv_stimer,hv-stimer-direct,hv_time,-x2apic,topoext,-svm,invtsc,hv-passthrough,-hv-
vapic
-overcommit mem-lock=on
-m 6G
-device virtio-scsi,id=scsi-ctrl,bus=rport.0,iothread=,num_queues=4
-drive if=none,id=os_image,file=./disk_s1.qcow2,aio=native,discard=unmap,cache=none
-device scsi-hd,drive=os_image,bus=scsi-ctrl.0,bootindex=1,id=auto_id21
-netdev tap,id=tap0,vhost=on,ifname=tap0_windows10,script=no,downscript=no
-device virtio-net-pci,id=net0,mac=02:00:00:A9:4D:A7,netdev=tap0,bus=rport.1,disable-legacy=on
-display gtk,gl=off,zoom-to-fit=on,window-close=off
-device virtio-vga,virgl=off,id=auto_id23
-device qemu-xhci,id=usb0,bus=pcie.0,addr=0x14.0x0,p3=16,p2=16
-device usb-tablet,id=auto_id24
-audiodev pa,id=pulseaudio0,server=/run/user/103992/pulse/native,timer-period=2000,out.mixing-engine=off,out.fixed-settings=off,out.buffer-length=50000
-device ich9-intel-hda,id=sound0,msi=on,bus=pcie.0,addr=0x1f.0x4
-device hda-micro,id=sound0-codec0,bus=sound0.0,cad=0,audiodev=pulseaudio0
-device virtio-serial-pci,id=virtio-serial0,bus=rport.2,disable-legacy=on
-chardev socket,id=chr_qga,path=/run/vmspawn/win10_ojiejx07/guest_agent.socket,server,nowait
-device virtserialport,bus=virtio-serial0.0,nr=1,chardev=chr_qga,name=org.qemu.guest_agent.0,id=auto_id25
-chardev socket,path=/run/vmspawn/win10_ojiejx07/hmp_monitor.socket,id=internal_hmp_monitor_socket_chardev,server=on,wait=off
-mon chardev=internal_hmp_monitor_socket_chardev,mode=readline
-chardev socket,path=/run/vmspawn/win10_ojiejx07/qmp_monitor.socket,id=internal_qmp_monitor_socket_chardev,server=on,wait=off
-mon chardev=internal_qmp_monitor_socket_chardev,mode=control
-chardev socket,path=/run/vmspawn/win10_ojiejx07/serial.socket,id=internal_serial0_chardev,server=on,logfile=/mnt/shared/home/mlevitsk/VM/win10/.logs/serial.log,wait=off
-device isa-serial,chardev=internal_serial0_chardev,index=0,id=auto_id28
-chardev file,path=/mnt/shared/home/mlevitsk/VM/win10/.logs/ovmf.log,id=internal_debugcon0_chardev
-device isa-debugcon,chardev=internal_debugcon0_chardev,iobase=1026,id=auto_id29


And then I get this eventually in dmesg:

[  245.196253] INFO: task qemu-system-x86:3487 blocked for more than 122 seconds.
[  245.196461]       Tainted: G           O      5.13.0-rc2.unstable #28
[  245.196640] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  245.196855] task:qemu-system-x86 state:D stack:    0 pid: 3487 ppid:  3480 flags:0x00000000
[  245.197095] Call Trace:
[  245.197194]  __schedule+0x2d0/0x940
[  245.197307]  schedule+0x4f/0xc0
[  245.197402]  schedule_preempt_disabled+0xe/0x20
[  245.197535]  __mutex_lock.constprop.0+0x2ab/0x480
[  245.197675]  __mutex_lock_slowpath+0x13/0x20
[  245.197802]  mutex_lock+0x34/0x40
[  245.197905]  kvm_vm_ioctl+0x395/0xee0 [kvm]
[  245.198092]  ? _copy_to_user+0x20/0x40
[  245.198213]  ? put_timespec64+0x3d/0x60
[  245.198334]  ? poll_select_finish+0x1b3/0x220
[  245.198465]  __x64_sys_ioctl+0x8e/0xc0
[  245.198577]  do_syscall_64+0x3a/0x80
[  245.198688]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  245.198838] RIP: 0033:0x7f66caec74eb
[  245.198944] RSP: 002b:00007ffd0e8ddc98 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[  245.199157] RAX: ffffffffffffffda RBX: 00000000000a0000 RCX: 00007f66caec74eb
[  245.199354] RDX: 00007ffd0e8dde00 RSI: 000000004010ae42 RDI: 000000000000001e
[  245.199550] RBP: 00007ffd0e8ddd90 R08: 0000000000855628 R09: 0000000000000000
[  245.199745] R10: 00007ffd0e8ef080 R11: 0000000000000206 R12: 00000000004231b0
[  245.199948] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  245.200206] INFO: task CPU 0/KVM:3543 blocked for more than 122 seconds.
[  245.200403]       Tainted: G           O      5.13.0-rc2.unstable #28
[  245.200590] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  245.200812] task:CPU 0/KVM       state:D stack:    0 pid: 3543 ppid:  3480 flags:0x00004000
[  245.201047] Call Trace:
[  245.201122]  __schedule+0x2d0/0x940
[  245.201226]  schedule+0x4f/0xc0
[  245.201318]  schedule_timeout+0xfe/0x140
[  245.201432]  wait_for_completion+0x88/0xe0
[  245.201547]  __synchronize_srcu+0x79/0xa0
[  245.201662]  ? __bpf_trace_rcu_stall_warning+0x20/0x20
[  245.201808]  synchronize_srcu_expedited+0x1e/0x40
[  245.201941]  install_new_memslots+0x5c/0xa0 [kvm]
[  245.202122]  kvm_set_memslot+0x361/0x680 [kvm]
[  245.202292]  kvm_delete_memslot+0x68/0xe0 [kvm]
[  245.202464]  __kvm_set_memory_region+0x517/0x560 [kvm]
[  245.202653]  __x86_set_memory_region+0xe3/0x200 [kvm]
[  245.202848]  avic_update_access_page+0x75/0xa0 [kvm_amd]
[  245.203003]  svm_pre_update_apicv_exec_ctrl+0x12/0x20 [kvm_amd]
[  245.203176]  kvm_request_apicv_update+0xf6/0x160 [kvm]
[  245.203367]  synic_update_vector.cold+0x6d/0xb3 [kvm]
[  245.203565]  kvm_hv_set_msr_common+0x57e/0xc00 [kvm]
[  245.203760]  ? mutex_lock+0x13/0x40
[  245.203861]  kvm_set_msr_common+0x162/0xe60 [kvm]
[  245.204068]  svm_set_msr+0x40b/0x800 [kvm_amd]
[  245.204240]  __kvm_set_msr+0x8f/0x1e0 [kvm]
[  245.204430]  kvm_emulate_wrmsr+0x3a/0x180 [kvm]
[  245.204620]  msr_interception+0x1c/0x40 [kvm_amd]
[  245.204763]  svm_invoke_exit_handler+0x2a/0xe0 [kvm_amd]
[  245.204921]  handle_exit+0xb8/0x220 [kvm_amd]
[  245.205047]  kvm_arch_vcpu_ioctl_run+0xbe7/0x17c0 [kvm]
[  245.205251]  ? kthread_queue_work+0x3d/0x80
[  245.205370]  ? timerqueue_add+0x6e/0xc0
[  245.205482]  ? enqueue_hrtimer+0x39/0x80
[  245.205595]  kvm_vcpu_ioctl+0x247/0x600 [kvm]
[  245.205763]  ? tick_program_event+0x41/0x80
[  245.205887]  __x64_sys_ioctl+0x8e/0xc0
[  245.206002]  do_syscall_64+0x3a/0x80
[  245.206119]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  245.206270] RIP: 0033:0x7f66caec74eb
[  245.206376] RSP: 002b:00007f66b56f7608 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  245.206595] RAX: ffffffffffffffda RBX: 0000000002939360 RCX: 00007f66caec74eb
[  245.206799] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000026
[  245.206998] RBP: 00007f66b56f7700 R08: 0000000000d87130 R09: 000000000000ffff
[  245.207198] R10: 0000000000918ea4 R11: 0000000000000246 R12: 00007ffd0e8dd92e
[  245.207395] R13: 00007ffd0e8dd92f R14: 0000000000000000 R15: 00007f66b56f9640


> 
> > The reason is that kvm_request_apicv_update must not be called with
> > srcu lock held vcpu->kvm->srcu (there is a warning about that
> > in kvm_request_apicv_update), but guest msr writes which come
> > from vcpu thread do hold it.
> >  
> > The other place where we disable AVIC on demand is svm_toggle_avic_for_irq_window.
> > And that code has a hack to drop this lock and take 
> > it back around the call to kvm_request_apicv_update.
> > This hack is safe as this code is called only from the vcpu thread.
> >  
> > Also for reference the reason for the fact that we need to
> > disable AVIC on the interrupt window request, or more correctly
> > why we still need to request interrupt windows with AVIC,
> > is that the local apic can act sadly as a pass-through device 
> > for legacy PIC, when one of its LINTn pins is configured in ExtINT mode.
> > In this mode when such pin is raised, the local apic asks the PIC for
> > the interrupt vector and then delivers it to the APIC
> > without touching the IRR/ISR.
> > 
> > The later means that if guest's interrupts are disabled,
> > such interrupt can't be queued via IRR to VAPIC
> > but instead the regular interrupt window has to be requested, 
> > but on AMD, the only way to request interrupt window
> > is to queue a VIRQ, and intercept its delivery,
> > a feature that is disabled when AVIC is active.
> >  
> > Finally for SynIC this srcu lock drop hack can be extended to this gross hack:
> > It seems to work though:
> > 
> > 
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index bedd9b6cc26a..925b76e7b45e 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -85,7 +85,7 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
> >  }
> >  
> >  static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> > -				int vector)
> > +				int vector, bool host)
> >  {
> >  	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
> >  	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> > @@ -109,6 +109,9 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> >  
> >  	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
> >  
> > +	if (!host)
> > +		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> > +
> >  	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICV */
> >  	if (!auto_eoi_old && auto_eoi_new) {
> >  		printk("Synic: inhibiting avic %d %d\n", auto_eoi_old, auto_eoi_new);
> > @@ -121,6 +124,10 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> >  			kvm_request_apicv_update(vcpu->kvm, true,
> >  						 APICV_INHIBIT_REASON_HYPERV);
> >  	}
> > +
> > +	if (!host)
> > +		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> > +
> >  }
> >  
> >  static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
> > @@ -149,9 +156,9 @@ static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
> >  
> >  	atomic64_set(&synic->sint[sint], data);
> >  
> > -	synic_update_vector(synic, old_vector);
> > +	synic_update_vector(synic, old_vector, host);
> >  
> > -	synic_update_vector(synic, vector);
> > +	synic_update_vector(synic, vector, host);
> >  
> >  	/* Load SynIC vectors into EOI exit bitmap */
> >  	kvm_make_request(KVM_REQ_SCAN_IOAPIC, hv_synic_to_vcpu(synic));
> > 
> > 
> > Assuming that we don't want this gross hack,  
> 
> Is it dangerous or just ugly?

It *should* work, but as it is always with locking,
if something changes, the assumption that MSR write
is called with SRCU held only on guest initiated writes
might be not true anymore.

Honestly I don't like the workaround that drops the lock in
svm_toggle_avic_for_irq_window either for the same reason.

> 
> > I wonder if we can avoid full blown memslot 
> > update when we disable avic, but rather have some 
> > smaller hack like only manually patching its
> > NPT mapping to have RW permissions instead 
> > of reserved bits which we use for MMIO. 
> > 
> > The AVIC spec says that NPT is only used to check that
> > guest has RW permission to the page, 
> > while the HVA in the NPT entry itself is ignored.
> 
> Assuming kvm_request_apicv_update() is called very rarely, I'd rather
> kicked all vCPUs out (similar to KVM_REQ_MCLOCK_INPROGRESS) and
> schedule_work() to make memslot update happen ourside of sRCU lock.

Adding Suravee Suthikulpanit to CC.


I tested it again and indeed I only see a burst of kvm_request_apicv_update
which ends when Windows enables IO apic
(this is a result of svm_toggle_avic_for_irq_window)


The AVIC disable due to SynIC autoeoi also happens I think
once per VCPU (I didn't verify this) and that is it.

So yes I do vote to make APICV update done in safer manner
as you suggest.


BTW I forgot about another reason that disables AVIC
The 'kvm-pit.lost_tick_policy=discard' has to be set,
since otherwise the in-kernel PIT reinject code relies
on EOI interception and thus disables AVIC as well.


Best regards,
	Maxim Levitsky

> 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > 
> > 
> > 




