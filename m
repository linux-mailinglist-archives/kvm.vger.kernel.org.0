Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4DE706081
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 08:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjEQG5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 02:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjEQG5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 02:57:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052DF19B3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 23:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82B09636C7
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 06:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E23E9C4339C
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 06:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684306618;
        bh=ZAwp3IoWDVntB5NzmY7w2mv0XRrA59tDKfgaCKVkMTA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XSa261i90AJtFufVHNBa+UpKWDma6rQkjLjlOvIpeN4LVCfKk2QnlG8OuZr8N85CN
         szP2NnYORGq7xop41lcHzpp6qkjokazu9VIqDHhkDMVJ0yZcddXpExzqg6sKD7KoLX
         PYXks6gqaBnbY4npRuv9mLWZKFjctolFPUyQj4J3MZnw+Ey3Y/gFgeBPAK3T/Cg/yT
         dhwNcRUAiTLEfqo///TOAzTC3Vkl+2kmo+2PR8SCST7Ji5inkHPxHflQYxgSZQmhEv
         TSJK8H64QQh38o5whSEQL6xDsomNC/730VBLuMRh9kvehFAOOKe++8zPfzc+yhIDFz
         xkE7A/RSoiOyA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CE8DFC43142; Wed, 17 May 2023 06:56:58 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217423] TSC synchronization issue in VM restore
Date:   Wed, 17 May 2023 06:56:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: robert.hoo.linux@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217423-28872-vveEjLlo7j@https.bugzilla.kernel.org/>
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

--- Comment #2 from robert.hoo.linux@gmail.com ---
On 5/9/2023 10:01 PM, bugzilla-daemon@kernel.org wrote:
> Hi
>=20
> We are using lightweight VM with snapshot feature, the VM will be saved w=
ith
> 100ms+, and we found restore such VM will not get correct TSC, which will
> make
> the VM world stop about 100ms+ after restore (the stop time is same as ti=
me
> when VM saved).
>=20
> After Investigation, we found the issue caused by TSC synchronization in
> setting MSR_IA32_TSC. In VM save, VMM (cloud-hypervisor) will record TSC =
of
> each
> VCPU, then restore the TSC of VCPU in VM restore (about 100ms+ in guest
> time).
> But in KVM, setting a TSC within 1 second is identified as TSC
> synchronization,
> and the TSC offset will not be updated in stable TSC environment, this wi=
ll
> cause the lapic set up a hrtimer expires after 100ms+,=20

Can elaborate more on this hrtimer issue/code path?

> the restored VM now will
> in stop state about 100ms+, if no other event to wake guest kernel in NO_=
HZ
> mode.
>=20
> More investigation show, the MSR_IA32_TSC set from guest side has disabled
> TSC
> synchronization in commit 0c899c25d754 (KVM: x86: do not attempt TSC
> synchronization on guest writes), now host side will do TSC synchronizati=
on
> when
> setting MSR_IA32_TSC.
>=20
> I think setting MSR_IA32_TSC within 1 second from host side should not be
> identified as TSC synchronization, like above case, VMM set TSC from host
> side
> always should be updated as user want.

This is heuristics, I think; at the very beginning, it was 5 seconds.
Perhaps nowadays, can we have some deterministic approach to identify a=20
synchronization? e.g. add a new VM ioctl?
>=20
> The MSR_IA32_TSC set code is complicated and with a long history, so I co=
me
> here
> to try to get help about whether my thought is correct. Here is my fix to
> solve
> the issue, any comments are welcomed:
>=20
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ceb7c5e9cf9e..9380a88b9c1f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2722,17 +2722,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *v=
cpu,
> u64 data)
>                           * kvm_clock stable after CPU hotplug
>                           */
>                          synchronizing =3D true;
> -               } else {
> -                       u64 tsc_exp =3D kvm->arch.last_tsc_write +
> -                                               nsec_to_cycles(vcpu,
> elapsed);
> -                       u64 tsc_hz =3D vcpu->arch.virtual_tsc_khz * 1000L=
L;
> -                       /*
> -                        * Special case: TSC write with a small delta (1
> second)
> -                        * of virtual cycle time against real time is
> -                        * interpreted as an attempt to synchronize the C=
PU.
> -                        */
> -                       synchronizing =3D data < tsc_exp + tsc_hz &&
> -                                       data + tsc_hz > tsc_exp;
>                  }
>          }
>=20
This hunk of code is indeed historic and heuristic. But simply removing it=
=20
isn't the way.
Is the interval between your "save VM" and "restore VM" less than 1s?

An alternative, I think, is to bypass this directly write IA32_MSR_TSC way=
=20
to set/sync TSC offsets, but follow new approach introduced in your VMM by

commit 828ca89628bfcb1b8f27535025f69dd00eb55207
Author: Oliver Upton <oliver.upton@linux.dev>
Date:   Thu Sep 16 18:15:38 2021 +0000

     KVM: x86: Expose TSC offset controls to userspace

...

Documentation/virt/kvm/devices/vcpu.rst:

4.1 ATTRIBUTE: KVM_VCPU_TSC_OFFSET

:Parameters: 64-bit unsigned TSC offset

...

Specifies the guest's TSC offset relative to the host's TSC. The guest's
TSC is then derived by the following equation:

   guest_tsc =3D host_tsc + KVM_VCPU_TSC_OFFSET

The following describes a possible algorithm to use for this purpose
...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
