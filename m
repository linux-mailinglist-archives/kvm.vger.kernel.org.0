Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD3D39299C
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhE0IdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 04:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235336AbhE0IdY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 04:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622104311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jJfbDlOdCHEBuP0/2VSWt2Xp4aAvYX7fFfLqYRlsGu4=;
        b=DlXOCHotNnmPKc7koT7ij/BjUwk1U2WvkFp+p34UFOQT94H72SHfhno/SvpKJPoI8/uQ7B
        p3hxQMTnDWG2aBQDU+uBmpyiQJEP1bb8okmbbDt1U0tsUAp2py4oBxXDLCzr9WEMUAP0ig
        OmOtRcPl+vQvaGjUgID5JBfTPegoH20=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-rqmPXCPROH-VJcFesIzF_w-1; Thu, 27 May 2021 04:31:47 -0400
X-MC-Unique: rqmPXCPROH-VJcFesIzF_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A25501F4;
        Thu, 27 May 2021 08:31:46 +0000 (UTC)
Received: from work-vm (ovpn-114-249.ams2.redhat.com [10.36.114.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F5326EF42;
        Thu, 27 May 2021 08:31:41 +0000 (UTC)
Date:   Thu, 27 May 2021 09:31:39 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Claudio Fontana <cfontana@suse.de>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Windows fails to boot after rebase to QEMU master
Message-ID: <YK9Y64U0wjU5K753@work-vm>
References: <20210521091451.GA6016@u366d62d47e3651.ant.amazon.com>
 <20210524055322-mutt-send-email-mst@kernel.org>
 <YK6hunkEnft6VJHz@work-vm>
 <d71fee00-0c21-c5e8-dbc6-00b7ace11c5a@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d71fee00-0c21-c5e8-dbc6-00b7ace11c5a@suse.de>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Claudio Fontana (cfontana@suse.de) wrote:
> On 5/26/21 9:30 PM, Dr. David Alan Gilbert wrote:
> > * Michael S. Tsirkin (mst@redhat.com) wrote:
> >> On Fri, May 21, 2021 at 11:17:19AM +0200, Siddharth Chandrasekaran wrote:
> >>> After a rebase to QEMU master, I am having trouble booting windows VMs.
> >>> Git bisect indicates commit f5cc5a5c1686 ("i386: split cpu accelerators
> >>> from cpu.c, using AccelCPUClass") to have introduced the issue. I spent
> >>> some time looking at into it yesterday without much luck.
> >>>
> >>> Steps to reproduce:
> >>>
> >>>     $ ./configure --enable-kvm --disable-xen --target-list=x86_64-softmmu --enable-debug
> >>>     $ make -j `nproc`
> >>>     $ ./build/x86_64-softmmu/qemu-system-x86_64 \
> >>>         -cpu host,hv_synic,hv_vpindex,hv_time,hv_runtime,hv_stimer,hv_crash \
> >>>         -enable-kvm \
> >>>         -name test,debug-threads=on \
> >>>         -smp 1,threads=1,cores=1,sockets=1 \
> >>>         -m 4G \
> >>>         -net nic -net user \
> >>>         -boot d,menu=on \
> >>>         -usbdevice tablet \
> >>>         -vnc :3 \
> >>>         -machine q35,smm=on \
> >>>         -drive if=pflash,format=raw,readonly=on,unit=0,file="../OVMF_CODE.secboot.fd" \
> >>>         -drive if=pflash,format=raw,unit=1,file="../OVMF_VARS.secboot.fd" \
> >>>         -global ICH9-LPC.disable_s3=1 \
> >>>         -global driver=cfi.pflash01,property=secure,value=on \
> >>>         -cdrom "../Windows_Server_2016_14393.ISO" \
> >>>         -drive file="../win_server_2016.qcow2",format=qcow2,if=none,id=rootfs_drive \
> >>>         -device ahci,id=ahci \
> >>>         -device ide-hd,drive=rootfs_drive,bus=ahci.0
> >>>
> >>> If the issue is not obvious, I'd like some pointers on how to go about
> >>> fixing this issue.
> >>>
> >>> ~ Sid.
> >>>
> >>
> >> At a guess this commit inadvertently changed something in the CPU ID.
> >> I'd start by using a linux guest to dump cpuid before and after the
> >> change.
> > 
> > I've not had a chance to do that yet, however I did just end up with a
> > bisect of a linux guest failure bisecting to the same patch:
> > 
> > [dgilbert@dgilbert-t580 qemu]$ git bisect bad
> > f5cc5a5c168674f84bf061cdb307c2d25fba5448 is the first bad commit
> > commit f5cc5a5c168674f84bf061cdb307c2d25fba5448
> > Author: Claudio Fontana <cfontana@suse.de>
> > Date:   Mon Mar 22 14:27:40 2021 +0100
> > 
> >     i386: split cpu accelerators from cpu.c, using AccelCPUClass
> >     
> >     i386 is the first user of AccelCPUClass, allowing to split
> >     cpu.c into:
> >     
> >     cpu.c            cpuid and common x86 cpu functionality
> >     host-cpu.c       host x86 cpu functions and "host" cpu type
> >     kvm/kvm-cpu.c    KVM x86 AccelCPUClass
> >     hvf/hvf-cpu.c    HVF x86 AccelCPUClass
> >     tcg/tcg-cpu.c    TCG x86 AccelCPUClass
> >     
> > 
> 
> Paolo, it seems to me that something went wrong in the merge of this commit.
> 
> The last version of the series I sent had this comment in the commit message,
> as part of a very long series of rebases after review.
> 
> [claudio]: Rebased on commit b8184135 ("target/i386: allow modifying TCG phys-addr-bits")
> 
> 
> While I do not see this comment in the commit posted here. So I suspect that an older version of the series was included?

That comment is there in the one merged:
    [claudio]:
    Rebased on commit b8184135 ("target/i386: allow modifying TCG phys-addr-bits")

and I don't see any difference in this commit or the 2 previous ones in
the upstream compared with your i386_cleanup_9 branch.

Dave


> The series is also available as:
> 
> https://github.com/hw-claudio/qemu.git "i386_cleanup_9"
> 
> Thanks,
> 
> Claudio
> 
> 
> 
> 
> > The guest crash is:
> > [   85.008985][ T1524] BUG: unable to handle page fault for address: ffffffff810d9c42
> > [   85.012868][ T1524] #PF: supervisor write access in kernel mode
> > [   85.012962][ T1524] #PF: error_code(0x0003) - permissions violation
> > [   85.013043][ T1524] PGD 2224067 P4D 2224067 PUD 2225063 PMD 10001e1 
> > [   85.013180][ T1524] Oops: 0003 [#1] SMP NOPTI
> > [   85.013295][ T1524] CPU: 2 PID: 1524 Comm: blogbench Not tainted 5.11.0-rc7 #100
> > [   85.013395][ T1524] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> > [   85.013546][ T1524] RIP: 0010:kvm_kick_cpu+0x22/0x30
> > [   85.013630][ T1524] Code: 0f 1f 84 00 00 00 00 00 55 48 63 ff 48 c7 c0 78 11 01 00 48 8b 14 fd c0 36 11 82 48 89 e5 53 31 db 0f b7 0c 02 b8 05 00 00 00 <0f> 01 d9 5b 5d c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 89 fb
> > [   85.013852][ T1524] RSP: 0018:ffffc90000747c08 EFLAGS: 00010046
> > [   85.013951][ T1524] RAX: 0000000000000005 RBX: 0000000000000000 RCX: 0000000000000000
> > [   85.014058][ T1524] RDX: ffff88807c600000 RSI: 0000000000000100 RDI: 0000000000000000
> > [   85.014153][ T1524] RBP: ffffc90000747c10 R08: ffff88807c72a800 R09: ffff88807ffd6000
> > [   85.014248][ T1524] R10: 0000000000000001 R11: 0000000000000046 R12: ffff88807c72a800
> > [   85.014343][ T1524] R13: 0000000000000000 R14: ffff888005409940 R15: ffff88807c72a818
> > [   85.014437][ T1524] FS:  00007fa2f750a700(0000) GS:ffff88807c700000(0000) knlGS:0000000000000000
> > [   85.014559][ T1524] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   85.014644][ T1524] CR2: ffffffff810d9c42 CR3: 0000000009016003 CR4: 0000000000370ea0
> > [   85.014741][ T1524] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   85.014842][ T1524] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [   85.014945][ T1524] Call Trace:
> > [   85.014998][ T1524]  __pv_queued_spin_unlock_slowpath+0xa0/0xd0
> > [   85.015103][ T1524]  __raw_callee_save___pv_queued_spin_unlock_slowpath+0x15/0x24
> > [   85.015206][ T1524]  .slowpath+0x9/0x15
> > [   85.015261][ T1524]  do_raw_spin_unlock+0x48/0xc0
> > [   85.015333][ T1524]  _raw_spin_unlock_irq+0x1d/0x30
> > [   85.015404][ T1524]  finish_task_switch+0xcc/0x2c0
> > [   85.015478][ T1524]  __schedule+0x283/0x9a0
> > [   85.015534][ T1524]  schedule+0x50/0xc0
> > [   85.015588][ T1524]  request_wait_answer+0x126/0x240
> > [   85.015667][ T1524]  ? finish_wait+0x90/0x90
> > [   85.015740][ T1524]  fuse_simple_request+0x17c/0x2e0
> > 
> > the backtrace moves about a bit, but it always ends up as
> > a page fault in kvm_kick_cpu.
> > 
> > My qemu commandline being:
> > ./x86_64-softmmu/qemu-system-x86_64 -M pc,memory-backend=mem,accel=kvm -cpu host  -m 2G,maxmem=16G,slots=16 -smp 4 -object memory-backend-memfd,id=mem,size=2G,share=on -chardev socket,id=char0,path=/tmp/vhostqemu -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs -kernel /home/dgilbert/virtio-fs/kernel-builds/monolithic-dax-20210209a -initrd /home/dgilbert/virtio-fs/test-initramfs.img -chardev stdio,mux=on,id=mon -mon chardev=mon,mode=readline  -device virtio-serial-pci,disable-modern=on -device virtconsole,chardev=mon -object rng-random,id=objrng0,filename=/dev/urandom -device virtio-rng-pci,rng=objrng0,id=rng0,disable-legacy=on -vga none -append "console=hvc0  debug loglevel=9 systemd.journald.forward_to_console" -display none  -overcommit mem-lock=off -netdev user,id=usernet -device virtio-net-pci,netdev=usernet -name debug-threads=on
> > 
> > 
> >>
> >>>
> >>>
> >>> Amazon Development Center Germany GmbH
> >>> Krausenstr. 38
> >>> 10117 Berlin
> >>> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> >>> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> >>> Sitz: Berlin
> >>> Ust-ID: DE 289 237 879
> >>>
> >>>
> >>
> >>
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

