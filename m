Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B4F6B03A9
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 11:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCHKEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 05:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjCHKEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 05:04:45 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B7531E15
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 02:04:43 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id ec29so32596135edb.6
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 02:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1678269882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lk9hO6GYjlCyqcLurlB1UfNe+BCiVXIYGhrwW9z2MsI=;
        b=NUNs4mxWIsBGRfVjdOfJcLmtEJl8HDimKqG+z+txyP5YU6Ux0GduUSKENCZXAY4mLw
         QVNSFMw/XlqJOcVZyUzRBwfwkI2eARmGPda3rHnewAqIWA6gBAkyiKQEZn85E6oyC1rT
         fwkyGBu0qu4dieEGvb1yy3Fzlh48Lh9+pe+68L66/k7EIK2pWMv2rdSqo3Od8cS4xwMm
         sCv3WK/l3Eaxi0bgRmO3XJFoWUi0N7Tg/WZwTHim/iNkfw/Lwd8pUbQ9SIdmLAGN0d08
         bwGP0a2yi7i3t0tjSPkmzBkvTcb9APz6MTTVmmhiFMTq9t0T0O/tSoEghAiwBvvK8jNK
         1DNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678269882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lk9hO6GYjlCyqcLurlB1UfNe+BCiVXIYGhrwW9z2MsI=;
        b=KFM+Q/mlB8HBEHPORx8E3mwVhT89OrGaCSt/RVjUf6mjdupt4tEJMM9NKjAWaV7olW
         qj5SpIlFhC+iAza3DHibE4W6APE9J7Fy2QqL+GqzXeClvXRcWtCU1u3Up6+P67deyXqW
         jGJId1Mhafu4NS3IJr+he27PkzwDncARr8Y5GD7OxnY4VL0HSdfVHIvQ/8jbSy8mHg27
         jtlyAejCJj5v+AJWFn9UvJdLuSlC+ofS42oSj0nCjqhbPhYjatUCXM+DsbfOcFC9EZQ6
         FEdW4+xSHlx3+UEUe6gsSqqIwnBWDKOB2SqOpYN0bQUVrGFPbxXThVyaUqObLZrp85kX
         K73Q==
X-Gm-Message-State: AO0yUKXqbZLksNGYbgICNC9h4KAkBowovIMcnPF3C+S2zoyfeCYeBwkT
        uCrBeZvNvvQ8lj0dbqmn5cMXEw5A8X9ekIG/exGCW3S8oBsBj79lZg0dlQ==
X-Google-Smtp-Source: AK7set+kdEqXCECoY7VWoWxVhnJ2j4s0W2hG3ilYor1v6P9mwBAkOhNoVGK1QuebqOrZyiI2oLcKrWZ1oa34+Q/UvxI=
X-Received: by 2002:a17:906:618:b0:8a6:91d9:c7ac with SMTP id
 s24-20020a170906061800b008a691d9c7acmr8937153ejb.5.1678269881870; Wed, 08 Mar
 2023 02:04:41 -0800 (PST)
MIME-Version: 1.0
References: <20230308084306.1908706-1-junyan.lin@spacemit.com>
In-Reply-To: <20230308084306.1908706-1-junyan.lin@spacemit.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 8 Mar 2023 15:34:29 +0530
Message-ID: <CAAhSdy2X+=QMhFjP5qReZBqSQckmbWvcjCdQ+9tF28pYqtq_MQ@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix sometimes VCPU not woken up when Sstc enabled
To:     Junyan Lin <junyan.lin@spacemit.com>
Cc:     atishp@atishpatra.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 8, 2023 at 2:14=E2=80=AFPM Junyan Lin <junyan.lin@spacemit.com>=
 wrote:
>
> When Sstc is enabled, kvm_riscv_vcpu_timer_blocking() starts a hrtimer
> to kick the sleeping VCPU when its next_cycles arrives. The hrtimer
> would be started only if delta_ns is not 0. But sometimes when code runs
> here, current_cycles has already become greater than the VCPU
> next_cycles, and delta_ns is set to 0. At this time, the hrtimer won't
> be started and the sleeping VCPU will never be woken up (unless kicked
> elsewhere).
>
> To fix this issue, we can start the hrtimer as usual when delta_ns is 0.
> It seems no harm is done if a hrtimer is started with relative expiry 0,
> and it can trigger kvm_riscv_vcpu_vstimer_expired() ASAP to kick the
> VCPU.
>
> Signed-off-by: Junyan Lin

Similar patch is already queued for Linux-6.3 RC fixes.

Refer,
https://patchwork.ozlabs.org/project/kvm-riscv/patch/20230210142711.1177212=
-1-rkanwal@rivosinc.com/

Regards,
Anup

> ---
>
> I used QEMU (v7.2.0, with Sstc support, running on a x86_64 Ubuntu PC)
> to run RISC-V KVM (with the application kvmtool). Sometimes when I
> operate the VM console, the following VM kernel messages occured:
>
> [ 193.615374] rcu: INFO: rcu_sched self-detected stall on CPU
> [ 193.817218] rcu: 0-...!: (1 ticks this GP) idle=3D1f4c/0/0x1 softirq=3D=
391/391 fqs=3D0
> [ 194.081286] (t=3D26093 jiffies g=3D-367 q=3D1 ncpus=3D1)
> [ 194.259913] rcu: rcu_sched kthread timer wakeup didn't happen for 26092=
 jiffies! g-367 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
> [ 194.469957] rcu: Possible timer handling issue on cpu=3D0 timer-softirq=
=3D531
> [ 194.604240] rcu: rcu_sched kthread starved for 26093 jiffies! g-367 f0x=
0 RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D0
> [ 194.804629] rcu: Unless rcu_sched kthread gets sufficient CPU time, OOM=
 is now expected behavior.
> [ 194.990219] rcu: RCU grace-period kthread stack dump:
> [ 195.090119] task:rcu_sched state:I stack:0 pid:14 ppid:2 flags:0x000000=
00
> [ 195.224749] Call Trace:
> [ 195.262612] [] schedule+0x5a/0xe6
> [ 195.369865] [] schedule_timeout+0x96/0x184
> [ 195.467307] [] rcu_gp_fqs_loop+0x2f8/0x3c6
> [ 195.571945] [] rcu_gp_kthread+0x132/0x15a
> [ 195.713804] [] kthread+0xea/0x100
> [ 195.797756] [] ret_from_exception+0x0/0xc
> [ 195.889635] rcu: Stack dump where RCU GP kthread last ran:
> [ 196.010148] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.0 #27
> [ 196.109710] Hardware name: linux,dummy-virt (DT)
> [ 196.220722] epc : arch_cpu_idle+0x22/0x28
> [ 196.301151] ra : default_idle_call+0x3c/0xfc
> [ 196.370436] epc : ffffffff80003ffa ra : ffffffff808e85c8 sp : ffffffff8=
0c4beb0
> [ 196.470957] gp : ffffffff80e252e0 tp : ffffffff80c57e40 t0 : ff6000001f=
5ea600
> [ 196.591430] t1 : 0000000000000000 t2 : ffffffff809aab10 s0 : ffffffff80=
c4bec0
> [ 196.754133] s1 : 0000000000000000 a0 : 0000000000000000 a1 : 0000000000=
000000
> [ 196.893724] a2 : ffffffff809a1368 a3 : ff6000001f5e7368 a4 : 0000000000=
001f44
> [ 196.999888] a5 : ff6000001f5e7368 a6 : 4000000000000000 a7 : 0000000000=
000000
> [ 197.096473] s2 : ffffffff80e28248 s3 : ffffffff80e283f8 s4 : ffffffff80=
e2521c
> [ 197.200699] s5 : 0000000000000000 s6 : ffffffff809a23d8 s7 : ffffffff80=
e724f0
> [ 197.316841] s8 : 0000000000000000 s9 : 0000000000000000 s10: 0000000000=
000000
> [ 197.426412] s11: 0000000000000000 t3 : 000000000000005d t4 : 0000000000=
000000
> [ 197.591666] t5 : 00000000a9a15ab4 t6 : 0000000000000000
> [ 197.689520] status: 0000000200000120 badaddr: 0000000000000000 cause: 8=
000000000000005
> [ 197.830312] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.0 #27
> [ 197.940338] Hardware name: linux,dummy-virt (DT)
> [ 198.028434] epc : arch_cpu_idle+0x22/0x28
> [ 198.122230] ra : default_idle_call+0x3c/0xfc
> [ 198.206204] epc : ffffffff80003ffa ra : ffffffff808e85c8 sp : ffffffff8=
0c4beb0
> [ 198.358393] gp : ffffffff80e252e0 tp : ffffffff80c57e40 t0 : ff6000001f=
5ea600
> [ 198.485282] t1 : 0000000000000000 t2 : ffffffff809aab10 s0 : ffffffff80=
c4bec0
> [ 198.573230] s1 : 0000000000000000 a0 : 0000000000000000 a1 : 0000000000=
000000
> [ 198.712281] a2 : ffffffff809a1368 a3 : ff6000001f5e7368 a4 : 0000000000=
001f44
> [ 198.845871] a5 : ff6000001f5e7368 a6 : 4000000000000000 a7 : 0000000000=
000000
> [ 198.991388] s2 : ffffffff80e28248 s3 : ffffffff80e283f8 s4 : ffffffff80=
e2521c
> [ 199.139266] s5 : 0000000000000000 s6 : ffffffff809a23d8 s7 : ffffffff80=
e724f0
> [ 199.277888] s8 : 0000000000000000 s9 : 0000000000000000 s10: 0000000000=
000000
> [ 199.414241] s11: 0000000000000000 t3 : 000000000000005d t4 : 0000000000=
000000
> [ 199.553449] t5 : 00000000a9a15ab4 t6 : 0000000000000000
> [ 199.613065] status: 0000000200000120 badaddr: 0000000000000000 cause: 8=
000000000000005
>
> It seems that VCPU stalled for a long time. I found it is because
> sometimes the delta_ns in kvm_riscv_vcpu_timer_blocking() is 0, and the
> hrtimer won't be started to wake the VCPU up again later. The VCPU keeps
> sleeping until I operate the VM console, and kvmtool calls ioctl() to
> inject a interrupt and finally calls kvm_vcpu_kick() to wake it up.
>
> If we configure QEMU to have only one physical CPU, this issue is easier
> to reproduce. It looks as expected. The less CPU resources the VCPU
> thread has, the more likely the circumstance 'delta_ns =3D=3D 0' is to
> happen.
>
> I tried starting the hrtimer as usual when delta_ns is 0, it did solve
> this problem. I looked into the implementation of hrtimer, there seems
> no harm if we start it with relative expiry 0 (but I'm not entirely
> sure).
>
> Some details of my environment:
>
> - QEMU: v7.2.0
> - Linux kernel: v6.2
> - OpenSBI: commit-id 506928a1be9952abc52f05c0c661338aa1d66f6d (higher
> than v1.1)
> - kvmtool: commit-id 717a3ab0a195626360f40e9d3b4d6d8e072e83ba
>
> Running QEMU:
> ```
> qemu-system-riscv64 \
> -cpu rv64 \
> -machine virt \
> -smp 1 \
> -m 1024M \
> -nographic \
> -bios MY_OPENSBI_FIRMWARE \
> -kernel MY_KERNEL.Image \
> -initrd MY_INITRD \
> -append "root=3D/dev/ram rw console=3DttyS0,115200n8 earlycon=3Dsbi"
> ```
>
> Running VM with kvmtool on QEMU:
> ```
> lkvm run \
> --mem 512 \
> --console serial \
> --kernel MY_KERNEL.Image \
> --params "console=3DttyS0,115200n8 earlycon=3Duart8250,mmio,0x3f8"
> ```
>
> arch/riscv/kvm/vcpu_timer.c | 6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index ad34519c8a13..3ac2ff6a65da 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -147,10 +147,8 @@ static void kvm_riscv_vcpu_timer_blocking(struct kvm=
_vcpu *vcpu)
> return;
>
> delta_ns =3D kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
> - if (delta_ns) {
> - hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> - t->next_set =3D true;
> - }
> + hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
> + t->next_set =3D true;
> }
>
> static void kvm_riscv_vcpu_timer_unblocking(struct kvm_vcpu *vcpu)
> --
> 2.34.1
>
>
> This message and any attachment are confidential and may be privileged or=
 otherwise protected from disclosure. If you are not an intended recipient =
of this message, please delete it and any attachment from your system and n=
otify the sender immediately by reply e-mail. Unintended recipients should =
not use, copy, disclose or take any action based on this message or any inf=
ormation contained in this message. Emails cannot be guaranteed to be secur=
e or error free as they can be intercepted, amended, lost or destroyed, and=
 you should take full responsibility for security checking.
> =E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E4=BB=BB=E4=BD=95=E9=99=84=
=E4=BB=B6=E5=85=B7=E6=9C=89=E4=BF=9D=E5=AF=86=E6=80=A7=E8=B4=A8=EF=BC=8C=E5=
=B9=B6=E5=8F=AF=E8=83=BD=E5=8F=97=E5=85=B6=E4=BB=96=E4=BF=9D=E6=8A=A4=E6=88=
=96=E4=B8=8D=E5=85=81=E8=AE=B8=E8=A2=AB=E6=8A=AB=E9=9C=B2=E7=BB=99=E7=AC=AC=
=E4=B8=89=E6=96=B9=E3=80=82=E5=A6=82=E9=98=81=E4=B8=8B=E8=AF=AF=E6=94=B6=E5=
=88=B0=E6=9C=AC=E9=82=AE=E4=BB=B6=EF=BC=8C=E6=95=AC=E8=AF=B7=E7=AB=8B=E5=8D=
=B3=E4=BB=A5=E5=9B=9E=E5=A4=8D=E7=94=B5=E5=AD=90=E9=82=AE=E4=BB=B6=E7=9A=84=
=E6=96=B9=E5=BC=8F=E9=80=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=8C=E5=
=B9=B6=E5=B0=86=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E4=BB=BB=E4=BD=
=95=E9=99=84=E4=BB=B6=E4=BB=8E=E9=98=81=E4=B8=8B=E7=B3=BB=E7=BB=9F=E4=B8=AD=
=E4=BA=88=E4=BB=A5=E5=88=A0=E9=99=A4=E3=80=82=E5=A6=82=E9=98=81=E4=B8=8B=E5=
=B9=B6=E9=9D=9E=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=86=99=E6=98=8E=E4=B9=8B=E6=94=
=B6=E4=BB=B6=E4=BA=BA=EF=BC=8C=E6=95=AC=E8=AF=B7=E5=88=87=E5=8B=BF=E4=BD=BF=
=E7=94=A8=E3=80=81=E5=A4=8D=E5=88=B6=E3=80=81=E6=8A=AB=E9=9C=B2=E6=9C=AC=E9=
=82=AE=E4=BB=B6=E6=88=96=E5=85=B6=E4=BB=BB=E4=BD=95=E5=86=85=E5=AE=B9=EF=BC=
=8C=E4=BA=A6=E8=AF=B7=E5=88=87=E5=8B=BF=E4=BE=9D=E6=9C=AC=E9=82=AE=E4=BB=B6=
=E6=88=96=E5=85=B6=E4=BB=BB=E4=BD=95=E5=86=85=E5=AE=B9=E8=80=8C=E9=87=87=E5=
=8F=96=E4=BB=BB=E4=BD=95=E8=A1=8C=E5=8A=A8=E3=80=82=E7=94=B5=E5=AD=90=E9=82=
=AE=E4=BB=B6=E6=97=A0=E6=B3=95=E4=BF=9D=E8=AF=81=E6=98=AF=E4=B8=80=E7=A7=8D=
=E5=AE=89=E5=85=A8=E5=92=8C=E4=B8=8D=E4=BC=9A=E5=87=BA=E7=8E=B0=E4=BB=BB=E4=
=BD=95=E5=B7=AE=E9=94=99=E7=9A=84=E9=80=9A=E4=BF=A1=E6=96=B9=E5=BC=8F=EF=BC=
=8C=E5=8F=AF=E8=83=BD=E4=BC=9A=E8=A2=AB=E6=8B=A6=E6=88=AA=E3=80=81=E4=BF=AE=
=E6=94=B9=E3=80=81=E4=B8=A2=E5=A4=B1=E6=88=96=E6=8D=9F=E5=9D=8F=EF=BC=8C=E6=
=94=B6=E4=BB=B6=E4=BA=BA=E9=9C=80=E8=87=AA=E8=A1=8C=E8=B4=9F=E8=B4=A3=E5=81=
=9A=E5=A5=BD=E5=AE=89=E5=85=A8=E6=A3=80=E6=9F=A5=E3=80=82
