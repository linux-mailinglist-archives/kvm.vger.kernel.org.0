Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E2673BA5C
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjFWOlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFWOlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:41:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F9172A
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 07:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E998C61A70
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 14:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53758C433C8
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687531263;
        bh=bWsX08q9i36rLQWqo4ZcZZtA9WKTy/nef0pxnkPuY4s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YFaHP3qbNnwDudo0O6GSg7aEF8l4u2+SRcw/p59Y94wa2UZnqwaKKTboDgtp9UZ7A
         twnxOvz1qmEh3FtozJejSibdWBv3XKNGrh3rushJJwl/bQPH+efj3kGCAI8a1pVEfb
         1z/lqdNy3+qVXrmeXV9UljlwUBFsJh28uBJkpOPob2zbu6HEB2T9cCnpRipwZ0rHC0
         LQ8yPyd9mCL841rm7ceaxlSzJRM99YEw3N7Cfn+RF93pmdLcbGKxXVUpnDAPmFL1YY
         Q+vYe8fMDib7OMPcpcHAKc0GVcb3QHuz/QicLmyZ28m50On5p/kls7YDXQ+a3Vk2g8
         ZUDT7B4ZseXfA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 32A56C53BD2; Fri, 23 Jun 2023 14:41:03 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217423] TSC synchronization issue in VM restore
Date:   Fri, 23 Jun 2023 14:41:02 +0000
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
Message-ID: <bug-217423-28872-SViA10PlQq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217423-28872@https.bugzilla.kernel.org/>
References: <bug-217423-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217423

--- Comment #4 from robert.hoo.linux@gmail.com ---
On 5/18/2023 8:48 PM, bugzilla-daemon@kernel.org wrote:
[...]
(Sorry for late response)
>> Can elaborate more on this hrtimer issue/code path?
>=20
> Below are the steps in detail, I traced them via bpftrace, to simplify the
> analysis, the preemption timer on host is disabled, guest is running with
> TSC timer deadline mode.
>=20
> TSC changes before save VM:
> 1 create VM/VCPU, guest TSC start from 0 (VCPU initial value)
>    host_tsc0 =3D 0 + offset0
> 2 pause VM after guest start finished (about 200ms)
>    host_tsc1 =3D guest_tsc1 + offset0
>    guest_tsc1_deadline =3D guest_tsc1 + expire1
> 3 save VM state
>    save guest_tsc1 by reading MSR_IA32_TSC
>    save guest_tsc1_deadline by reading MSR_IA32_TSC_DEADLINE
>=20
> TSC changes in restore VM (to simplify the analysis, step 4
> and step 5 ignore the host TSC changes in restore process):
> 4 create VM/VCPU, guest TSC start from 0 (VCPU initial value)
>    host_tsc3 =3D 0 + offset1
> 5 restore VM state
>    set MSR_IA32_TSC by guest_tsc1
>    set MSR_IA32_TSC_DEADLINE by guest_tsc1_deadline
> 6 start VM
>    VCPU_RUN
>=20
> In step 5 setting MSR_IA32_TSC, because the guest_tsc1 is within 1 second,
> KVM will take this update as TSC synchronize, then skip update offset1.
> This means the guest TSC is still at 0 (initialize value).

IIUC, here no matter synchronizing =3D true or false, offset will always be=
=20
updated, i.e. __kvm_synchronize_tsc() will be called. But the offset value =
will=20
differ.

I guess your environment is tsc_stable, then offset =3D kvm->arch.cur_tsc_o=
ffset,=20
which is 0. That is to say, the elapsed time isn't counted in by the heuris=
tics=20
method in current code, that's the culprit.

static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
{
        ...
        offset =3D kvm_compute_l1_tsc_offset(vcpu, data);
        ...

        /*
         * For a reliable TSC, we can match TSC offsets, and for an unstable
         * TSC, we add elapsed time in this computation.  We could let the
         * compensation code attempt to catch up if we fall behind, but
         * it's better to try to match offsets from the beginning.
          */
        if (synchronizing &&
            vcpu->arch.virtual_tsc_khz =3D=3D kvm->arch.last_tsc_khz) {
                if (!kvm_check_tsc_unstable()) {
                        offset =3D kvm->arch.cur_tsc_offset;
                } else {
                        u64 delta =3D nsec_to_cycles(vcpu, elapsed);
                        data +=3D delta;
                        offset =3D kvm_compute_l1_tsc_offset(vcpu, data);
                }
                matched =3D true;
        }

        __kvm_synchronize_tsc(vcpu, offset, data, ns, matched);
        raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
}


>> An alternative, I think, is to bypass this directly write IA32_MSR_TSC w=
ay
>> to set/sync TSC offsets, but follow new approach introduced in your VMM =
by
>>
>> commit 828ca89628bfcb1b8f27535025f69dd00eb55207
>> Author: Oliver Upton <oliver.upton@linux.dev>
>> Date:   Thu Sep 16 18:15:38 2021 +0000
>>
>>       KVM: x86: Expose TSC offset controls to userspace
>>
>> ...
>>
>> Documentation/virt/kvm/devices/vcpu.rst:
>>
>> 4.1 ATTRIBUTE: KVM_VCPU_TSC_OFFSET
>>
>> :Parameters: 64-bit unsigned TSC offset
>>
>> ...
>>
>> Specifies the guest's TSC offset relative to the host's TSC. The guest's
>> TSC is then derived by the following equation:
>>
>>     guest_tsc =3D host_tsc + KVM_VCPU_TSC_OFFSET
>>
>> The following describes a possible algorithm to use for this purpose
>> ...
>=20
> "TSC counts the time during which the VM was paused.", This new feature w=
orks
> for live migration. But if we save/restore VM with snapshot, the TSC shou=
ld
> be
> paused either?
>=20
Not sure what's host's TSC situation when host is, say, suspended/hibernate=
d.
VM=20
Save/Restore can refer to that.
But, the key point of this new approach is to use OFFSET rather than direct=
 TSC=20
value, this is like x86 TSC_ADJUST was introduced, and is preferred.
Via this new interface,
"... Ensure that the KVM_CLOCK_REALTIME flag is set in the provided structu=
re.
KVM will advance the VM's kvmclock to account for elapsed time since record=
ing=20
the clock values.", therefore I think it can solve your problem, rather tha=
n=20
modify the ancient and heuristics code at high risk.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
