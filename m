Return-Path: <kvm+bounces-20851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0303F9240C8
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 16:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACDE7285DAE
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 14:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD3F1BA86E;
	Tue,  2 Jul 2024 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJLsGSZw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F17D1BA098;
	Tue,  2 Jul 2024 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719930377; cv=none; b=jyCEpK+6CAao9gkRgLK8by84dzkvJfTCvKtFq19BAGUMUvtOyHudeh4ikLoG8sfLzeDA0v5TvSSrOMGg2WU8O8Lsf9Ja0RmmJKkLo/Y/WMOJ0ybwGtkm3r9gyBdF9v9Ojz7gmDtB01cjOF+1BWBwCKjES3IEVv8rz/iPBTMBOZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719930377; c=relaxed/simple;
	bh=bUymbfat9/kKGL16cSlsngxtShh0v8QfDzVYq4FBt7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b2Bqa7DPzqEoTrCyw1epkA15GPjX4ltqoBD6W7kyrb24RwkXiRb3f811xQMxIoa8Da9kc/LLHsB0EVyA47vRXgIdSwIYkF3eOwHF8rp/TwYQu5eFUOt1jYBk2HK8KdgLWBPEbThvSvZdjqOFISAaAI7E69fQ5M0A15jrIQPSHZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJLsGSZw; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ee794ebffbso7893651fa.1;
        Tue, 02 Jul 2024 07:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719930373; x=1720535173; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pw30YIDggayqbF1wkD4nfxJujJesCWLfn+Ka0ECvf+4=;
        b=mJLsGSZwSYh2Akhz0B0wvjAYtSJ699lStTtmLVJtJYcnaja7z+jy55Q6S1hpraYrw2
         4YvWEN2i7Fy3EkvB/Q44oRJB303QXOc5wvpX2ceyKdANrUkNmWsuio23rxCpYl0U8tKH
         tQ7eehvcmx4V9cWLmv76auSBIKPPHXW3jmrWWnwNySF+NsfPs2+90baaOhB3N9fIQAqr
         SJho3jc8s/RVjmqZOtqdut1HO00jTU/fMHzoD0DmFnA5UcpyBRjLBafhpQPcbPI2WeSI
         ioZLW5LRAWTpMcPgTtZwDRwkEfR989+uvGkik9AscpKCIeorqhh5WyfuZxN7H5RbTWv4
         QcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719930373; x=1720535173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pw30YIDggayqbF1wkD4nfxJujJesCWLfn+Ka0ECvf+4=;
        b=KfYaD20fiDLHRvZWCIOcVXHr64vUslWjECowiZW0hmVM0iysb/CZGVQoLDJ8RFNSbb
         I5rBXbTwBymF3qJgNm4Fb31z2RvJXBYwLnRSCmf3m6CSc3Exr1jBOwHE5b7dSr5spthM
         Ipn2M2svSq0C+zV1I/d/GCp+r3cR75j97aZA+1Pn6jnEfs9xnl1vT4gl6hAG5w6m/Z+z
         +NacIsXTW0PMn56C6+EeZsHjBcZgaC4BMACYeh7aTnAH7puUSZXPLkaSCTY4j4b7dCsh
         3lXgvT6Q60t9Erl3cN0cs8ygPV3V/nzKzJzssAiE1Zqy10ixxzPspz1S4C86OmuxJkwv
         Et+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXL+JqmuTmYUpX2WdWnnkgwWR0NKdV02iH5mIgugo2AfwjxfBDE/qJu0160fakSKdepiHFQA5k6hGGyXvQpxr6bguOQ0LKuHVjS27aBJufcqdgRlSxyap+d4AB/
X-Gm-Message-State: AOJu0YyI+sUkMOXNSAae3Tof/m47jbIRz7Pk3aNlrumdewyTaHGWx3NR
	ZD+jlpIBhp61QDDYuvb2CTH8yyiCH1LlvOPIxRDDbhX4R04syTVNgVDhnmS8palb8SRzF3UXw+P
	21gUq0H9ptm/OGtbBUbEZ4wok0C0=
X-Google-Smtp-Source: AGHT+IGlwyUD7FgXcpFkZUJ5txKIx1y1yxyaFuk4mRU29WjJ0cD7wtdhamLHdykOw9gJBsDV9Lhw/n5+KG8Elz6hQqo=
X-Received: by 2002:a2e:3018:0:b0:2ec:5f85:61c0 with SMTP id
 38308e7fff4ca-2ee5e707c21mr70672801fa.48.1719930372912; Tue, 02 Jul 2024
 07:26:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CABgObfasyA7U5Fg5r0gGoFAw73nwGJnWBYmG8vqf0hC2E8SPFw@mail.gmail.com>
 <sejux5gvpakaopre6mk3fyudi2f56hiuxuevfzay3oohg773kd@5odm3x3fryuq>
 <CABgObfb-KrmJzr4YBtuN3+_HLm3S1hmjO7uEy0+AxSDeWE3uWg@mail.gmail.com>
 <l5oxnxkg7owmwuadknttnnl2an37wt3u5kgfjb5563f7llbgwj@bvwfv5d7wrq4>
 <3b6a1f23-bf0e-416d-8880-4556b87b5137@amazon.com> <hyrgztjkjmftnpra2o2skonfs6bwf2sqrncwtec3e4ckupe5ea@76whtcp3zapf>
 <CAFfO_h5_uAwdNJB=fjrxb_pPiwRDQxaZn=OvR3yrYd+c18tUdQ@mail.gmail.com>
 <xw2rhgn2s677t6cufp2ndpvvgpdlovej44o6ieo7nz2p6msvnw@zza7jzylpw76>
 <CAFfO_h4WnSkinX1faduAD68h=nQCWhPgpYKTPV+xfSqyfMmxEA@mail.gmail.com>
 <CAFfO_h55DdTPWEjeR-ARnWZ0tMWNdJZnUauXsxm5eL+TzhAFLA@mail.gmail.com> <nojtsdora7chbhnblvygozoa4qui3ghivndvg5ixbsgebos4hg@e2jldxpf7sum>
In-Reply-To: <nojtsdora7chbhnblvygozoa4qui3ghivndvg5ixbsgebos4hg@e2jldxpf7sum>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Tue, 2 Jul 2024 20:26:02 +0600
Message-ID: <CAFfO_h4Ke-zfO+UAcCFxfwQOZsSKbOw2M-gErBE3wOnXj_eZKQ@mail.gmail.com>
Subject: Re: How to implement message forwarding from one CID to another in
 vhost driver
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Graf <agraf@csgraf.de>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, stefanha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Stefano,
Thanks a lot for all the details. I guess my next step is to try to
implement the forwarding logic in vhost-device-vsock and take it from
there.

Regards,
Dorjoy

On Tue, Jul 2, 2024 at 6:05=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> On Sun, Jun 30, 2024 at 04:54:18PM GMT, Dorjoy Chowdhury wrote:
> >Hey Stefano,
> >Apart from my questions in my previous email, I have some others as well=
.
> >
> >If the vhost-device-vsock modification to forward packets to
> >VMADDR_CID_LOCAL is implemented, does the VMADDR_FLAG_TO_HOST need to
> >be set by any application in the guest? I understand that the flag is
> >set automatically in the listen path by the driver (ref:
> >https://patchwork.ozlabs.org/project/netdev/patch/20201204170235.84387-4=
-andraprs@amazon.com/#2594117
> >), but from the comments in the referenced patch, I am guessing the
> >applications in the guest that will "connect" (as opposed to listen)
> >will need to set the flag in the application code? So does the
> >VMADDR_FLAG_TO_HOST flag need to be set by the applications in the
> >guest that will "connect" or should it work without it? I am asking
> >because the nitro-enclave VMs have an "init" which tries to connect to
> >CID 3 to send a "hello" on boot to let the parent VM know that it
> >booted expecting a "hello" reply but the init doesn't seem to set the
> >flag https://github.com/aws/aws-nitro-enclaves-sdk-bootstrap/blob/main/i=
nit/init.c#L356C1-L361C7
>
> Looking at af_vsock.c code, it looks like that if we don't have any
> H2G transports (e.g. vhost-vsock) loaded in the VM (this is loaded for
> nested VMs, so I guess for nitro-enclave VM this should not be the
> case), the packets are forwarded to the host in any case.
>
> See
> https://elixir.bootlin.com/linux/latest/source/net/vmw_vsock/af_vsock.c#L=
469
>
> >.
> >
> >I was following
> >https://github.com/rust-vmm/vhost-device/tree/main/vhost-device-vsock#si=
bling-vm-communication
> >to test if sibling communication works and it seems like I didn't need
> >to modify the "socat" to set the "VMADDR_FLAG_TO_HOST". I am wondering
> >why it works without any modification. Here is what I do:
> >
> >shell1: ./vhost-device-vsock --vm
> >guest-cid=3D3,uds-path=3D/tmp/vm3.vsock,socket=3D/tmp/vhost3.socket --vm
> >guest-cid=3D4,uds-path=3D/tmp/vm4.vsock,socket=3D/tmp/vhost4.socket
> >
> >shell2: ./qemu-system-x86_64 -machine q35,memory-backend=3Dmem0
> >-enable-kvm -m 8G -nic user,model=3Dvirtio -drive
> >file=3D/home/dorjoy/Forks/test_vm/fedora2.qcow2,media=3Ddisk,if=3Dvirtio
> >--display sdl -object memory-backend-memfd,id=3Dmem0,size=3D8G -chardev
> >socket,id=3Dchar0,reconnect=3D0,path=3D/tmp/vhost3.socket -device
> >vhost-user-vsock-pci,chardev=3Dchar0
> >    inside this guest I run: socat - VSOCK-LISTEN:9000
> >
> >shell3: ./qemu-system-x86_64 -machine q35,memory-backend=3Dmem0
> >-enable-kvm -m 8G -nic user,model=3Dvirtio -drive
> >file=3D/home/dorjoy/Forks/test_vm/fedora40.qcow2,media=3Ddisk,if=3Dvirti=
o
> >--display sdl -object memory-backend-memfd,id=3Dmem0,size=3D8G -chardev
> >socket,id=3Dchar0,reconnect=3D0,path=3D/tmp/vhost4.socket -device
> >vhost-user-vsock-pci,chardev=3Dchar0
> >    inside this guest I run: socat - VSOCK-CONNECT:3:9000
> >
> >Then when I type something in the socat terminal of one VM and hit
> >'enter', they pop up in the socat terminal of the other VM. From the
> >documentation of the vhost-device-vsock, I thought I would need to
> >patch socat to set the "VMADDR_FLAG_TO_HOST" but I did not do anything
> >with socat. I simply did "sudo dnf install socat" in both VMs. I also
> >looked into the socat source code and I didn't see any reference to
> >"VMADDR_FLAG_TO_HOST". I am running "Fedora 40" on both VMs. Do you
> >know why it works without the flag?
>
> Yep, so the driver will forward them if the H2G transport is not loaded,
> like in your case. So if you set VMADDR_FLAG_TO_HOST you are sure that
> it is always forwarded to the host, if you don't set it, it is forwarded
> only if you don't have a nested VM using vhost-vsock. In that case we
> don't know how to differentiate the case of communication with a nested
> guest or a sibling guest, for this reason we added the flag.
>
> If the host uses vhost-vsock, that packets are discarded, but for
> vhost-device-vsock, we are handling them.
>
> Hope this clarify.
>
> Stefano
>
> >
> >On Wed, Jun 26, 2024 at 11:43=E2=80=AFPM Dorjoy Chowdhury
> ><dorjoychy111@gmail.com> wrote:
> >>
> >> Hey Stefano,
> >> Thanks a lot for all the details. I will look into them and reach out
> >> if I need further input. Thanks! I have tried to summarize my
> >> understanding below. Let me know if that sounds correct.
> >>
> >> On Wed, Jun 26, 2024 at 2:37=E2=80=AFPM Stefano Garzarella <sgarzare@r=
edhat.com> wrote:
> >> >
> >> > Hi Dorjoy,
> >> >
> >> > On Tue, Jun 25, 2024 at 11:44:30PM GMT, Dorjoy Chowdhury wrote:
> >> > >Hey Stefano,
> >> >
> >> > [...]
> >> >
> >> > >> >
> >> > >> >So the immediate plan would be to:
> >> > >> >
> >> > >> >  1) Build a new vhost-vsock-forward object model that connects =
to
> >> > >> >vhost as CID 3 and then forwards every packet from CID 1 to the
> >> > >> >Enclave-CID and every packet that arrives on to CID 3 to CID 2.
> >> > >>
> >> > >> This though requires writing completely from scratch the virtio-v=
sock
> >> > >> emulation in QEMU. If you have time that would be great, otherwis=
e if
> >> > >> you want to do a PoC, my advice is to start with vhost-user-vsock=
 which
> >> > >> is already there.
> >> > >>
> >> > >
> >> > >Can you give me some more details about how I can implement the
> >> > >daemon?
> >> >
> >> > We already have a demon written in Rust, so I don't recommend you
> >> > rewrite one from scratch, just start with that. You can find the dae=
mon
> >> > and instructions on how to use it with QEMU here [1].
> >> >
> >> > >I would appreciate some pointers to code too.
> >> >
> >> > I sent the pointer to it in my first reply [2].
> >> >
> >> > >
> >> > >Right now, the "nitro-enclave" machine type (wip) in QEMU
> >> > >automatically spawns a VHOST_VSOCK device with the CID equal to the
> >> > >"guest-cid" machine option. I think this is equivalent to using the
> >> > >"-device vhost-vsock-device,guest-cid=3DN" option explicitly. Does =
that
> >> > >need any change? I guess instead of "vhost-vsock-device", the
> >> > >vhost-vsock device needs to be equivalent to "-device
> >> > >vhost-user-vsock-device,guest-cid=3DN"?
> >> >
> >> > Nope, the vhost-user-vsock device requires just a `chardev` option.
> >> > The chardev points to the Unix socket used by QEMU to talk with the
> >> > daemon. The daemon has a parameter to set the CID. See [1] for the
> >> > examples.
> >> >
> >> > >
> >> > >The applications inside the nitro-enclave VM will still connect and
> >> > >talk to CID 3. So on the daemon side, do we need to spawn a device
> >> > >that has CID 3 and then forward everything this device receives to =
CID
> >> > >1 (VMADDR_CID_LOCAL) same port and everything it receives from CID =
1
> >> > >to the "guest-cid"?
> >> >
> >> > Yep, I think this is right.
> >> > Note: to use VMADDR_CID_LOCAL, the host needs to load `vsock_loopbac=
k`
> >> > kernel module.
> >> >
> >> > Before modifying the code, if you want to do some testing, perhaps y=
ou
> >> > can use socat (which supports both UNIX-* and VSOCK-*). The daemon f=
or
> >> > now exposes two unix sockets, one is used to communicate with QEMU v=
ia
> >> > the vhost-user protocol, and the other is to be used by the applicat=
ion
> >> > to communicate with vsock sockets in the guest using the hybrid prot=
ocol
> >> > defined by firecracker. So you could initiate a socat between the la=
tter
> >> > and VMADDR_CID_LOCAL, the only problem I see is that you have to sen=
d
> >> > the first string provided by the hybrid protocol (CONNECT 1234), but=
 for
> >> > a PoC it should be ok.
> >> >
> >> > I just tried the following and it works without touching any code:
> >> >
> >> > shell1$ ./target/debug/vhost-device-vsock \
> >> >      --vm guest-cid=3D3,socket=3D/tmp/vhost3.socket,uds-path=3D/tmp/=
vm3.vsock
> >> >
> >> > shell2$ sudo modprobe vsock_loopback
> >> > shell2$ socat VSOCK-LISTEN:1234 UNIX-CONNECT:/tmp/vm3.vsock
> >> >
> >> > shell3$ qemu-system-x86_64 -smp 2 -M q35,accel=3Dkvm,memory-backend=
=3Dmem \
> >> >      -drive file=3Dfedora40.qcow2,format=3Dqcow2,if=3Dvirtio\
> >> >      -chardev socket,id=3Dchar0,path=3D/tmp/vhost3.socket \
> >> >      -device vhost-user-vsock-pci,chardev=3Dchar0 \
> >> >      -object memory-backend-memfd,id=3Dmem,size=3D512M \
> >> >      -nographic
> >> >
> >> >      guest$ nc --vsock -l 1234
> >> >
> >> > shell4$ nc --vsock 1 1234
> >> > CONNECT 1234
> >> >
> >> >      Note: the `CONNECT 1234` is required by the hybrid vsock protoc=
ol
> >> >      defined by firecracker, so if we extend the vhost-device-vsock
> >> >      daemon to forward packet to VMADDR_CID_LOCAL, that would not be
> >> >      needed (including running socat).
> >> >
> >>
> >> Understood. Just trying to think out loud what the final UX will be
> >> from the user perspective to successfully run a nitro VM before I try
> >> to modify vhost-device-vsock to support forwarding to
> >> VMADDR_CID_LOCAL.
> >> I guess because the "vhost-user-vsock" device needs to be spawned
> >> implicitly (without any explicit option) inside nitro-enclave in QEMU,
> >> we now need to provide the "chardev" as a machine option, so the
> >> nitro-enclave command would look something like below:
> >> "./qemu-system-x86_64 -M nitro-enclave,chardev=3Dchar0 -kernel
> >> /path/to/eif -chardev socket,id=3Dchar0,path=3D/tmp/vhost5.socket -m 4=
G
> >> --enable-kvm -cpu host"
> >> and then set the chardev id to the vhost-user-vsock device in the code
> >> from the machine option.
> >>
> >> The modified "vhost-device-vsock" would need to be run with the new
> >> option that will forward everything to VMADDR_CID_LOCAL (below by the
> >> "-z" I mean the new option)
> >> "./target/debug/vhost-device-vsock -z --vm
> >> guest-cid=3D5,socket=3D/tmp/vhost5.socket,uds-path=3D/tmp/vm5.vsock"
> >> this means the guest-cid of the nitro VM is CID 5, right?
> >>
> >> And the applications in the host would need to use VMADDR_CID_LOCAL
> >> for communication instead of "guest-cid" (5) (assuming vsock_loopback
> >> is modprobed). Let's say there are 2 applications inside the nitro VM
> >> that connect to CID 3 on port 9000 and 9001. And the applications on
> >> the host listen on 9000 and 9001 using VMADDR_CID_LOCAL. So, after the
> >> commands above (qemu VM and vhost-device-vsock) are run, the
> >> communication between the applications in the host and the
> >> applications in the nitro VM on port 9000 and 9001 should just work,
> >> right, without needing to run any extra socat commands or such? or
> >> will the user still need to run some socat commands for all the
> >> relevant ports (e.g.,9000 and 9001)?
> >>
> >> I am just wondering what kind of changes are needed in
> >> vhost-device-vsock for forwarding packets to VMADDR_CID_LOCAL? Will
> >> that be something like this: the codepath that handles
> >> "/tmp/vm5.vsock", upon receiving a "connect" (from inside the nitro
> >> VM) for any port to "/tmp/vm5.vsock", vhost-device-vsock will just
> >> connect to the same port using AF_VSOCK using the socket system calls
> >> and messages received on that port in "/tmp/vm5.vsock" will be "send"
> >> to the AF_VSOCK socket? or am I not thinking right and the
> >> implementation would be something different entirely (change the CID
> >> from 3 to 2 (or 1?) on the packets before they are handled then socat
> >> will be needed probably)? Will this work if the applications in the
> >> host want to connect to applications inside the nitro VM (as opposed
> >> to applications inside the nitro VM connecting to CID 3)?
> >>
> >> Thanks and Regards,
> >> Dorjoy
> >
>

