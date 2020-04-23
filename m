Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A4A1B5F78
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgDWPg7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:36:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28123 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgDWPg7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 11:36:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587656217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E23T/oKddWGo20e8Sy98c42LsNfH3cMjAg49nwFeKKI=;
        b=Dry+sH7tFeLuKlHFFaPz7PpwcbD6hPT+KuoRNn5HRHGC/Uhzl4gPizNHGp9jw4swsWywcu
        eHZH8lJp8jw9oaoEnx3WzJfgLA4bv0ifpss0dqUMNU+vwwl4WQaYQA00urbBzpMb/Wf9kn
        p3ZJdBc928Zt9PQhP8vDoELAkgNtC44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-uhXV4b82MrCICvxSQoHEFw-1; Thu, 23 Apr 2020 11:36:55 -0400
X-MC-Unique: uhXV4b82MrCICvxSQoHEFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1608D872FE1;
        Thu, 23 Apr 2020 15:36:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-29.rdu2.redhat.com [10.10.116.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54DD610016DA;
        Thu, 23 Apr 2020 15:36:52 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
 <20200423144209.GA17824@linux.intel.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <467c5c66-8890-02ba-2e9a-c28365d9f2c6@redhat.com>
Date:   Thu, 23 Apr 2020 11:36:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200423144209.GA17824@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/23/20 10:42 AM, Sean Christopherson wrote:
> On Tue, Apr 14, 2020 at 04:11:07PM -0400, Cathy Avery wrote:
>> With NMI intercept moved to check_nested_events there is a race
>> condition where vcpu->arch.nmi_pending is set late causing
> How is nmi_pending set late?  The KVM_{G,S}ET_VCPU_EVENTS paths can't s=
et
> it because the current KVM_RUN thread holds the mutex, and the only oth=
er
> call to process_nmi() is in the request path of vcpu_enter_guest, which=
 has
> already executed.

You will have to forgive me as I am new to KVM and any help would be=20
most appreciated.=C2=A0 This is what I noticed when an NMI intercept is=20
processed when it was implemented in check_nested_events.

When check_nested_events is called from inject_pending_event ...=20
check_nested_events needs to have already been called (kvm_vcpu_running=20
with vcpu->arch.nmi_pending =3D 1)=C2=A0 to set up the NMI intercept and =
set=20
svm->nested.exit_required. Otherwise we do not exit from the second=20
checked_nested_events call ( code below ) with a return of -EBUSY which=20
allows us to immediately vmexit.

 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Call check_nested_eve=
nts() even if we reinjected a previous=20
event
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * in order for caller t=
o determine if it should require=20
immediate-exit
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * from L2 to L1 due to =
pending L1 events which require exit
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * from L2 to L1.
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */

 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (is_guest_mode(vcpu) && kv=
m_x86_ops.check_nested_events) {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 r =3D kvm_x86_ops.check_nested_events(vcpu);
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (r !=3D 0)
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 r;
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }

Unfortunately when=C2=A0 kvm_vcpu_running is called vcpu->arch.nmi_pendin=
g is=20
not yet set.

Here is the trace snippet ( with some debug ) without the second call to=20
check_nested_events.

Thanks,

Cathy

qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168269: kvm_entry: vcpu =
0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168271: kvm_exit:=
 reason EXIT_MSR=20
rip 0x405371 info 1 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168272: kvm_neste=
d_vmexit: rip=20
405371 reason EXIT_MSR info1 1 info2 0 int_info 0 int_info_err 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168273: kvm_apic:=
 apic_write=20
APIC_ICR2 =3D 0x0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168274: kvm_apic:=
 apic_write=20
APIC_ICR =3D 0x44400
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168275: kvm_apic_=
ipi: dst 0 vec 0=20
(NMI|physical|assert|edge|self)
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168277: kvm_apic_=
accept_irq: apicid=20
0 vec 0 (NMI|edge)
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168278: kvm_msr: =
msr_write 830 =3D 0x44400
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168279: bprint:=20
svm_check_nested_events:=C2=A0 svm_check_nested_events reinj =3D 0, exit_=
req =3D 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168279: bprint:=20
svm_check_nested_events:=C2=A0 svm_check_nested_events nmi pending =3D 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168279: bputs: vc=
pu_enter_guest:=C2=A0=20
inject_pending_event 1
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168279: bprint:=20
svm_check_nested_events: svm_check_nested_events reinj =3D 0, exit_req =3D=
 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168279: bprint:=20
svm_check_nested_events: svm_check_nested_events nmi pending =3D 1
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168280: bprint: s=
vm_nmi_allowed:=20
svm_nmi_allowed ret 1
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168280: bputs: sv=
m_inject_nmi:=20
svm_inject_nmi
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168280: bprint: v=
cpu_enter_guest:=C2=A0=20
nmi_pending 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168281: kvm_entry=
: vcpu 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168282: kvm_exit:=
 reason EXIT_NMI=20
rip 0x405373 info 1 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168284: kvm_neste=
d_vmexit_inject:=20
reason EXIT_NMI info1 1 info2 0 int_info 0 int_info_err 0
 =C2=A0qemu-system-x86-2029=C2=A0 [040]=C2=A0=C2=A0 232.168285: kvm_entry=
: vcpu 0


>> the execution of check_nested_events to not setup correctly
>> for nested.exit_required. A second call to check_nested_events
>> allows the injectable nmi to be detected in time in order to
>> require immediate exit from L2 to L1.
>>
>> Signed-off-by: Cathy Avery <cavery@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 027dfd278a97..ecfafcd93536 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -7734,10 +7734,17 @@ static int inject_pending_event(struct kvm_vcp=
u *vcpu)
>>   		vcpu->arch.smi_pending =3D false;
>>   		++vcpu->arch.smi_count;
>>   		enter_smm(vcpu);
>> -	} else if (vcpu->arch.nmi_pending && kvm_x86_ops.nmi_allowed(vcpu)) =
{
>> -		--vcpu->arch.nmi_pending;
>> -		vcpu->arch.nmi_injected =3D true;
>> -		kvm_x86_ops.set_nmi(vcpu);
>> +	} else if (vcpu->arch.nmi_pending) {
>> +		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
>> +			r =3D kvm_x86_ops.check_nested_events(vcpu);
>> +			if (r !=3D 0)
>> +				return r;
>> +		}
>> +		if (kvm_x86_ops.nmi_allowed(vcpu)) {
>> +			--vcpu->arch.nmi_pending;
>> +			vcpu->arch.nmi_injected =3D true;
>> +			kvm_x86_ops.set_nmi(vcpu);
>> +		}
>>   	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
>>   		/*
>>   		 * Because interrupts can be injected asynchronously, we are
>> --=20
>> 2.20.1
>>

