Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9032551753
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 13:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241677AbiFTLYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 07:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241198AbiFTLYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 07:24:43 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2C315A3C
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 04:24:40 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w20so16713187lfa.11
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 04:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GszSVp79XAdXJU7rWHtCrAkj4julP+0D9zoLxgrCKdY=;
        b=dE40iflDWiIg3dbBtlZNYQHlXUjMq9ZMaPhSGn53RsV74vNnYrQK/pmCzFd2IeviP6
         aDy231iwKufFpKLCJShSq1/VOU9xiXmGMZ92QuAa/gfPDWgVrq81EHxaFmlCfrtW7crz
         jM9NO8ExBks75IXjmP8Ogov7MAw54BvOSxfL9d/GNHio9n5xXkDZtuh6P0kKhHlSwV2e
         Z8tbt5RvlfHCmMjHCXP+iCPgw9ZxTeX301yC6k4oVeAowKHb+TKYtqWlxE3caa3/yu1p
         azI+Bm44AA8oOZ0NkxJ3MuvizhFZIHvz2MxWFeoZTMWb+7gu5SSVRAATJuHrANsb5f3D
         wOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GszSVp79XAdXJU7rWHtCrAkj4julP+0D9zoLxgrCKdY=;
        b=Rqs/jn3mAQhNQI+TxcFEboVLZpa9y1MWTbgG5o4V+fWdlG/rAmwJlHi1wQ0+2hK3Gz
         A0XZjqfKLMspd5zmTb+PV3bHzmZTZ+BavT7hM18BljO5OJ/s2OxrScdi5iXjZoJG8jaX
         jQcLGKjLcTLjvjvjiWQfhuQvVijhPCIkrvePP2NKMuvmtApzsLbOEi+76CItG3LpZRyv
         DLeP81UMY2eRfE4J2kigr6hUzgaq7OZ8DDgYRAtO1for5jFqlCBdjqh56RoqKw0UKpcm
         U6Fa0F9YvQYtkSWP8gRHUsSf9VvIpbJGiPBZRaTR4B0jMoF7OhHdRnHfHDi+MD92Z5G5
         Pgew==
X-Gm-Message-State: AJIora+gI/CB7JiYevUoy13e6p7CGGBT4IhqyQVVUpM8n7uSsP4AJNVa
        ft1mNgy/0adkgdlXBhzXf9cJTqqRgp/GP3L3GuDgyQ==
X-Google-Smtp-Source: AGRyM1upflgaldDlhYWfrHQJ6AHZQSFUvBTmSclg7C+sCslrwxL414z5JvSlGFcjizt1E9RwBOx17FG6iZa1TnSxKpM=
X-Received: by 2002:a05:6512:90f:b0:47f:5a23:c62a with SMTP id
 e15-20020a056512090f00b0047f5a23c62amr7448750lft.598.1655724278169; Mon, 20
 Jun 2022 04:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <69ab985c.7d507.18180a4dcd7.Coremail.pgn@zju.edu.cn>
In-Reply-To: <69ab985c.7d507.18180a4dcd7.Coremail.pgn@zju.edu.cn>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 20 Jun 2022 13:24:26 +0200
Message-ID: <CACT4Y+anXSNgCW3jvsm8wPf0LPxW-kCmXTeno4n-BWntpMaZBA@mail.gmail.com>
Subject: Re: 'WARNING in handle_exception_nmi' bug at arch/x86/kvm/vmx/vmx.c:4959
To:     =?UTF-8?B?5r2Y6auY5a6B?= <pgn@zju.edu.cn>
Cc:     linux-sgx@vger.kernel.org, secalert@redhat.com,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller@googlegroups.com, kangel@zju.edu.cn, 22121145@zju.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jun 2022 at 12:25, =E6=BD=98=E9=AB=98=E5=AE=81 <pgn@zju.edu.cn> =
wrote:
>
> Hello,
>
>     This is Xiao Lei, Gaoning Pan and Yongkang Jia from Zhejiang Universi=
ty. We found a 'WARNING in handle_exception_nmi' bug by syzkaller. This fla=
w allows a malicious user in a local DoS condition. The following program t=
riggers Local DoS at arch/x86/kvm/vmx/vmx.c:4959 in latest release linux-5.=
18.5, this bug can be reproducible stably by the C reproducer:


FWIW a similarly-looking issue was reported by syzbot:
https://syzkaller.appspot.com/bug?id=3D1b411bfb1739c497a8f0c7f1aa501202726c=
d01a
https://lore.kernel.org/all/0000000000000a5eae05d8947adb@google.com/

Sean said it may be an issue in L0 kernel rather than in the tested kernel:
https://lore.kernel.org/all/Yqd5upAHNOxD0wrQ@google.com/

What kernel did you use for the host machine?





> ------------[ cut here ]------------
> WARNING: CPU: 14 PID: 9277 at arch/x86/kvm/vmx/vmx.c:4959 handle_exceptio=
n_nmi+0x11a7/0x14d0 arch/x86/kvm/vmx/vmx.c:4959
> Modules linked in:
> CPU: 14 PID: 9277 Comm: syz-executor.7 Not tainted 5.18.5 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubunt=
u1.1 04/01/2014
> RIP: 0010:handle_exception_nmi+0x11a7/0x14d0 arch/x86/kvm/vmx/vmx.c:4959
> Code: ff e8 1d b7 3c 00 be 0c 44 00 00 48 c7 c7 00 c9 23 8a c6 05 9f 71 5=
e 04 01 e8 5b 02 8d 02 0f 0b e9 64 f8 ff ff e8 f9 b6 3c 00 <0f> 0b e9 ae f4=
 ff ff e8 ed b6 3c 00 e8 28 97 a0 02 e9 5f fd ff ff
> RSP: 0018:ffff888038dc7b48 EFLAGS: 00010286
> RAX: 0000000000002617 RBX: 0000000000000000 RCX: ffffffff811dcf27
> RDX: 0000000000040000 RSI: ffffc90003dd1000 RDI: ffff888039595c0c
> RBP: ffff888039594000 R08: 0000000000000001 R09: ffff8880395941a7
> R10: ffffed10072b2834 R11: 0000000000000001 R12: fffffffffffffff8
> R13: 000000008000030e R14: ffff88803895c000 R15: ffff888039594068
> FS:  00007ff56edf7700(0000) GS:ffff888067d00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000003aec8006 CR4: 0000000000772ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6239 [inline]
>  vmx_handle_exit+0x5e7/0x1aa0 arch/x86/kvm/vmx/vmx.c:6256
>  vcpu_enter_guest arch/x86/kvm/x86.c:10283 [inline]
>  vcpu_run arch/x86/kvm/x86.c:10365 [inline]
>  kvm_arch_vcpu_ioctl_run+0x2a2e/0x5ca0 arch/x86/kvm/x86.c:10566
>  kvm_vcpu_ioctl+0x4d2/0xc60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:394=
3
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x16d/0x1d0 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x45e8c9
> Code: 4d af fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 0f 83 1b af fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ff56edf6c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000000077bf60 RCX: 000000000045e8c9
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 000000000077bf60 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffc491be6af R14: 00007ff56edf79c0 R15: 0000000000000000
>  </TASK>
> ---[ end trace 0000000000000000 ]---
>
> Syzkaller reproducer:
> # {Threaded:false Repeat:false RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: =
Leak:false NetInjection:false NetDevices:false NetReset:false Cgroups:false=
 BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false Vhc=
iInjection:false Wifi:false IEEE802154:false Sysctl:true UseTmpDir:false Ha=
ndleSegv:false Repro:false Trace:false LegacyOptions:{Collide:false Fault:f=
alse FaultCall:0 FaultNth:0}}
> r0 =3D openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
> r1 =3D ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
> r2 =3D ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0)
> syz_kvm_setup_cpu$x86(r1, r2, &(0x7f0000fe8000/0x18000)=3Dnil, &(0x7f0000=
0000c0)=3D[@textreal=3D{0x8, 0x0}], 0x1, 0x17, &(0x7f0000000100)=3D[@cr4=3D=
{0x1, 0x200915}], 0x1)
> ioctl$KVM_RUN(r2, 0xae80, 0x0)
>
>
> C repro and config are attached.
>
>
> Best regrads.
>
> Xiao Lei from Zhejiang University.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller/69ab985c.7d507.18180a4dcd7.Coremail.pgn%40zju.edu.cn.
