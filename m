Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380B0104F66
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 10:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKUJjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 04:39:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26401 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726132AbfKUJjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 04:39:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574329152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6HOsR8p3myuOODU/QrYsqHJg/JZdyWcfIaYXi4yDJ5A=;
        b=AaJYWxBCt1fWn1WXkOFOhzqKezikvHvblukEku9FR8rNlJbTTYT9EIAIajiK6NniJRjERI
        LzkZxph9pXdP2hkaPVWnadO2rzQKdTFdXV1Autnw4zhtB9cxEkpkeYXye7S1L84uej/iKF
        bHhTGBaQt1BYyyvO1Co99FfIwynjQbE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-LL44t_FkM62Wh9ho2chgGA-1; Thu, 21 Nov 2019 04:39:11 -0500
Received: by mail-wm1-f71.google.com with SMTP id l23so436774wmh.6
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 01:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tP0N2LZCdFeHGft/Z71mfKHwZBrcm+KfhogbAZB2+0M=;
        b=QaOW6FuAz0mF3h/RWN0+OjHieP8XYX9Mbo1Qcd+r1Kl4fzlM56lx3fj3yKmY7IKtgV
         3PIXlsBg4afwVs6he3m4N4e0RaxEo/iLowat01IlSWDT9+P4qTFYFc6ydDOYVbUVn6ve
         E3hhhOdYwSZuQMDS18FHkr9z/vfCY6c3zaUdTpPT/fk++Bro3TLHffaqAJUF47LkIJu8
         MOBsZl3GC1guRRNaVcx5Zq6hC6rZsTnFmmtUfN+Np7mlT9oXAxUcdIfTS9s9QfOAlZ7S
         4X73c1A204vYOrHtCY0frKwsB903hjS8+UJCKgvgUDQzeEt5rbhCS0zzcoCYxaK9O4fT
         TF6w==
X-Gm-Message-State: APjAAAWz/20Rxf4hgr+BalUX3qeegN6FKsg1K+m2+HxtFTL1HRgjaa+n
        euR18fqoM6+799k/MlLqQitccSGAwYuMKvDx+5h+p0mCJnPJHaMxb+5sl2lLiV4d2JdljDIOl3W
        m5OR8CSEU+ACZ
X-Received: by 2002:a1c:6146:: with SMTP id v67mr8798160wmb.102.1574329149479;
        Thu, 21 Nov 2019 01:39:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqw7onEZx4C0mfi9tTLfuGhs12eVHfzgMG+WwQla6hV6h40ktfDj1V8caZ1Nuiqb5QJZjwlqJQ==
X-Received: by 2002:a1c:6146:: with SMTP id v67mr8798125wmb.102.1574329149062;
        Thu, 21 Nov 2019 01:39:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id r15sm2729389wrc.5.2019.11.21.01.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 01:39:08 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Remove unnecessary TLB flushes on L1<->L2
 switches when L1 use apic-access-page
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191120143307.59906-1-liran.alon@oracle.com>
 <d7d4629a-c605-72bc-9d71-dd97cb6c0ab4@redhat.com>
 <4D796E12-758F-44D6-93B9-0BEFE0E7F712@oracle.com>
 <92baadfa-b458-7a12-25c4-da198b64e8c7@redhat.com>
Message-ID: <e4820ea5-0cb5-0b91-46b2-7acb994a2208@redhat.com>
Date:   Thu, 21 Nov 2019 10:39:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <92baadfa-b458-7a12-25c4-da198b64e8c7@redhat.com>
Content-Language: en-US
X-MC-Unique: LL44t_FkM62Wh9ho2chgGA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 18:49, Paolo Bonzini wrote:
> On 20/11/19 16:25, Liran Alon wrote:
>>>> If L0 use EPT, L0 use different EPTP when running L2 than L1
>>>> (Because guest_mode is part of mmu-role) and therefore SDM section
>>>> 28.3.3.4 doesn't apply. Otherwise, L0 use different VPID when
>>>> running L2 than L1 and therefore SDM section 28.3.3.3 doesn't
>>>> apply.
>>> I don't understand this.  You could still have a stale EPTP entry from =
a
>>> previous L2 vmenter.   If L1 uses neither EPT nor VPID, it expects a TL=
B
>>> flush to occur on every vmentry, but this won't happen if L0 uses EPT.
>> I don=E2=80=99t seem to get your concern.
>> In case L1 don=E2=80=99t use VPID, prepare_vmcs02() will request KVM_REQ=
_TLB_FLUSH.
>> (As it needs to emulate to L1 that on every L1<->L2 switch, the entire p=
hysical TLB is flushed)
>> As explained in commit message.
>=20
> You're right.  I'll rewrite some parts of the commit message, but the
> patch is correct.

I got confused because of "Otherwise, L0 use different VPID when running
L2 than L1 and therefore SDM section 28.3.3.3 doesn't apply".  In fact
SDM section 28.3.3.3 never applies to nested virtualization because:

* if L1 doesn't use VPID, the architecture requires a TLB flush on
vmentry/vmexit anyway

* if L1 uses VPID, it already has to do an INVVPID.  L0 only needs to
take care of combined mappings, which can be done with INVEPT but also
by using a different EP4TA for L1 and L2, as is the case after 1313cc2bd8f6=
.

Here is the rewritten commit message:

----
According to Intel SDM section 28.3.3.3/28.3.3.4 Guidelines for Use
of the INVVPID/INVEPT Instruction, the hypervisor needs to execute
INVVPID/INVEPT X in case CPU executes VMEntry with VPID/EPTP X and
either: "Virtualize APIC accesses" VM-execution control was changed
from 0 to 1, OR the value of apic_access_page was changed.

In the nested case, the burden falls on L1, unless L0 enables EPT in
vmcs02 but L1 enables neither EPT nor VPID in vmcs12.  For this reason
prepare_vmcs02() and load_vmcs12_host_state() have special code to
request a TLB flush in case L1 does not use EPT but it uses
"virtualize APIC accesses".

This special case however is not necessary. On a nested vmentry the
physical TLB will already be flushed except if all the following apply:

* L0 uses VPID

* L1 uses VPID

* L0 can guarantee TLB entries populated while running L1 are tagged
differently than TLB entries populated while running L2.

If the first condition is false, the processor will flush the TLB
on vmentry to L2.  If the second or third condition are false,
prepare_vmcs02() will request KVM_REQ_TLB_FLUSH.  However, even
if both are true, no extra TLB flush is needed to handle the APIC
access page:

* if L1 doesn't use VPID, the second condition doesn't hold and the
TLB will be flushed anyway.

* if L1 uses VPID, it has to flush the TLB itself with INVVPID and
section 28.3.3.3 doesn't apply to L0.

* even INVEPT is not needed because, if L0 uses EPT, it uses different
EPTP when running L2 than L1 (because guest_mode is part of mmu-role).
In this case SDM section 28.3.3.4 doesn't apply.

Therefore, there is no need to specifically flush TLB in case L1 does
not use EPT but it uses "Virtualize APIC accesses".

Similarly, examining nested_vmx_vmexit()->load_vmcs12_host_state(),
one could note that L0 won't flush TLB only in cases where SDM sections
28.3.3.3 and 28.3.3.4 don't apply.  In particular, if L0 uses different
VPIDs for L1 and L2 (i.e. vmx->vpid !=3D vmx->nested.vpid02), section
28.3.3.3 doesn't apply.

Thus, remove this flush from prepare_vmcs02() and nested_vmx_vmexit().

Side-note: This patch can be viewed as removing parts of commit
fb6c81984313 ("kvm: vmx: Flush TLB when the APIC-access address changes=E2=
=80=9D)
that is not relevant anymore since commit
1313cc2bd8f6 ("kvm: mmu: Add guest_mode to kvm_mmu_page_role=E2=80=9D).
i.e. The first commit assumes that if L0 use EPT and L1 doesn=E2=80=99t use=
 EPT,
then L0 will use same EPTP for both L0 and L1. Which indeed required
L0 to execute INVEPT before entering L2 guest. This assumption is
not true anymore since when guest_mode was added to mmu-role.
----

Paolo

