Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C721F7081B8
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 14:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjERMsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 08:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjERMsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 08:48:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A72C9
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 05:48:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B03064F1E
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0D8FC433D2
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684414085;
        bh=FtkbIVZscbM742p7SNQ4pR3KEy7HxwqIyEOYOUdz3gg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rufFCaBKAkXFqNH0vm2VzuNb+hEgvNvHx8ydbhHu9jQuC6a4EcA1+2d3MczIsrzzs
         ei+uCjJilsZaIptcSe+Mu74JwnzHRE9HFUvxQVygDAB8RzMne97purhQNG86Y8YD2r
         UIspRvNWm9o4tt5yrrkAfz9NMDVD61GTpjkGxMvExCxz6OOUusqXyjlm+aHlEuTcf/
         97yc0NRxfLFe0XslAljE/rsq0nGBYixX9BvEuH7NO2UpPposIaOfeBQB3POOvl5uDW
         0MLYJHObp+KgvKGXkVUUUEGUH0+lBBnLaDk+DdQ7U1X1Asz2c+bYzkTpqrkEbfrq5W
         s9+yI/NqqLKvg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C2A83C43141; Thu, 18 May 2023 12:48:05 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217423] TSC synchronization issue in VM restore
Date:   Thu, 18 May 2023 12:48:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zhuangel570@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217423-28872-hZX141cTfZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217423-28872@https.bugzilla.kernel.org/>
References: <bug-217423-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217423

--- Comment #3 from zhuangel (zhuangel570@gmail.com) ---
(In reply to robert.hoo.linux from comment #2)
> On 5/9/2023 10:01 PM, bugzilla-daemon@kernel.org wrote:
> > Hi
> >=20
> > We are using lightweight VM with snapshot feature, the VM will be saved
> with
> > 100ms+, and we found restore such VM will not get correct TSC, which wi=
ll
> > make
> > the VM world stop about 100ms+ after restore (the stop time is same as =
time
> > when VM saved).
> >=20
> > After Investigation, we found the issue caused by TSC synchronization in
> > setting MSR_IA32_TSC. In VM save, VMM (cloud-hypervisor) will record TS=
C of
> > each
> > VCPU, then restore the TSC of VCPU in VM restore (about 100ms+ in guest
> > time).
> > But in KVM, setting a TSC within 1 second is identified as TSC
> > synchronization,
> > and the TSC offset will not be updated in stable TSC environment, this =
will
> > cause the lapic set up a hrtimer expires after 100ms+,=20
>=20
> Can elaborate more on this hrtimer issue/code path?

Below are the steps in detail, I traced them via bpftrace, to simplify the
analysis, the preemption timer on host is disabled, guest is running with
TSC timer deadline mode.

TSC changes before save VM:
1 create VM/VCPU, guest TSC start from 0 (VCPU initial value)
  host_tsc0 =3D 0 + offset0
2 pause VM after guest start finished (about 200ms)
  host_tsc1 =3D guest_tsc1 + offset0
  guest_tsc1_deadline =3D guest_tsc1 + expire1
3 save VM state
  save guest_tsc1 by reading MSR_IA32_TSC
  save guest_tsc1_deadline by reading MSR_IA32_TSC_DEADLINE

TSC changes in restore VM (to simplify the analysis, step 4
and step 5 ignore the host TSC changes in restore process):
4 create VM/VCPU, guest TSC start from 0 (VCPU initial value)
  host_tsc3 =3D 0 + offset1
5 restore VM state
  set MSR_IA32_TSC by guest_tsc1
  set MSR_IA32_TSC_DEADLINE by guest_tsc1_deadline
6 start VM
  VCPU_RUN

In step 5 setting MSR_IA32_TSC, because the guest_tsc1 is within 1 second,
KVM will take this update as TSC synchronize, then skip update offset1.
This means the guest TSC is still at 0 (initialize value).

In step 5 setting MSR_IA32_TSC_DEADLINE, VMM just want setup hrtimer after
expire1, but KVM will get the current guest TSC is 0, and then calculate
the expire time as (guest_tsc1_deadline - 0), then the hrtimer introduce
guest_tsc1 latency (the guest kernel stopped if it will only kick by loapic
timer).

>=20
> > the restored VM now will
> > in stop state about 100ms+, if no other event to wake guest kernel in N=
O_HZ
> > mode.
> >=20
> > More investigation show, the MSR_IA32_TSC set from guest side has disab=
led
> > TSC
> > synchronization in commit 0c899c25d754 (KVM: x86: do not attempt TSC
> > synchronization on guest writes), now host side will do TSC synchroniza=
tion
> > when
> > setting MSR_IA32_TSC.
> >=20
> > I think setting MSR_IA32_TSC within 1 second from host side should not =
be
> > identified as TSC synchronization, like above case, VMM set TSC from ho=
st
> > side
> > always should be updated as user want.
>=20
> This is heuristics, I think; at the very beginning, it was 5 seconds.
> Perhaps nowadays, can we have some deterministic approach to identify a=20
> synchronization? e.g. add a new VM ioctl?

The 5 seconds was original introduced in commit f38e098ff3a3 ("KVM: x86:
TSC reset compensation"), when setting TSC into same value in 5 second. And
in 46543ba45fc49 ("KVM: x86: Robust TSC compensation"), remove the same val=
ue
check.

From changes in these 2 commits, I think the TSC synchronize first introduc=
ed
to handle synchronize from guest side (kernel boot), then changed to migrat=
ion
setting from host side.

In commit 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization
on guest writes"), Paolo has split the guest TSC write from this complicated
synchronization.

Now just migration scenarios left, in migration the TSC restore should be s=
et
before VCPU start to run, one hack is to skip checking whether the VCPU sta=
rts
running, such as check last_vmentry_cpu is -1.

> >=20
> > The MSR_IA32_TSC set code is complicated and with a long history, so I =
come
> > here
> > to try to get help about whether my thought is correct. Here is my fix =
to
> > solve
> > the issue, any comments are welcomed:
> >=20
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ceb7c5e9cf9e..9380a88b9c1f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2722,17 +2722,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu
> *vcpu,
> > u64 data)
> >                           * kvm_clock stable after CPU hotplug
> >                           */
> >                          synchronizing =3D true;
> > -               } else {
> > -                       u64 tsc_exp =3D kvm->arch.last_tsc_write +
> > -                                               nsec_to_cycles(vcpu,
> > elapsed);
> > -                       u64 tsc_hz =3D vcpu->arch.virtual_tsc_khz * 100=
0LL;
> > -                       /*
> > -                        * Special case: TSC write with a small delta (1
> > second)
> > -                        * of virtual cycle time against real time is
> > -                        * interpreted as an attempt to synchronize the
> CPU.
> > -                        */
> > -                       synchronizing =3D data < tsc_exp + tsc_hz &&
> > -                                       data + tsc_hz > tsc_exp;
> >                  }
> >          }
> >=20
> This hunk of code is indeed historic and heuristic. But simply removing i=
t=20
> isn't the way.
> Is the interval between your "save VM" and "restore VM" less than 1s?
>=20
> An alternative, I think, is to bypass this directly write IA32_MSR_TSC wa=
y=20
> to set/sync TSC offsets, but follow new approach introduced in your VMM by
>=20
> commit 828ca89628bfcb1b8f27535025f69dd00eb55207
> Author: Oliver Upton <oliver.upton@linux.dev>
> Date:   Thu Sep 16 18:15:38 2021 +0000
>=20
>      KVM: x86: Expose TSC offset controls to userspace
>=20
> ...
>=20
> Documentation/virt/kvm/devices/vcpu.rst:
>=20
> 4.1 ATTRIBUTE: KVM_VCPU_TSC_OFFSET
>=20
> :Parameters: 64-bit unsigned TSC offset
>=20
> ...
>=20
> Specifies the guest's TSC offset relative to the host's TSC. The guest's
> TSC is then derived by the following equation:
>=20
>    guest_tsc =3D host_tsc + KVM_VCPU_TSC_OFFSET
>=20
> The following describes a possible algorithm to use for this purpose
> ...

"TSC counts the time during which the VM was paused.", This new feature wor=
ks
for live migration. But if we save/restore VM with snapshot, the TSC should=
 be
paused either?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
