Return-Path: <kvm+bounces-69578-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMTIGhWYe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69578-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:25:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE87B2D0E
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EE7CD307DBC5
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81646346E6A;
	Thu, 29 Jan 2026 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LHzqE9T1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE0C346ACB;
	Thu, 29 Jan 2026 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707308; cv=none; b=PU/ZIKCw19BMFv1CXRMPqpGfT14mPEIoIVBbh1YL56uXKIO1+K3eYbCbKN1ddsMbpDwx0nzbQEQsQH6jv0BMogGohebMpDpkqmai/y1ZQRmM/AhdHiqS6AYHKntiN7yrLAey1YrffCveDbtgNildmVaXeZjO4pxftIjlCLirohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707308; c=relaxed/simple;
	bh=KCsvuJ4268xvvg8O2Y/qGpJlqbGioEqbrDMyCCszPoo=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=kGxGMB1IRu/+jN6Ep/qzhzB1TQfYOAnTbDzHpMmg7yKoYt+BP5yZFX2ayrOZjbMDo724HqwVNGVmja66m2fc3sYBGp3WZWZU70wL9ODq3YlsT0ctInurmasEfYUY+q97nu6X6BIaRxur7o7yeQ/LD1sjc0JNVerNqwP3dHlLTYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LHzqE9T1; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60THL9sn764745
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 29 Jan 2026 09:21:09 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60THL9sn764745
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1769707270;
	bh=tRqvK8QwDvRngEmRElZ+1rKciD8GlRfJYTefwoLXjE0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=LHzqE9T1ZpYBmpxxWjpYQYMxD60ixIka/spIvn6gIPyItlXrgXrxVy2zsTnqLu4J5
	 ieZc1hbjTRwwINbLk2GNyAsNfEsFOCGlt4nDqSeEQ3ObaKBf+KOwMbcOIzv9iU3gmD
	 6Q8HfJHthxWftE8E/nXThcmVqNCHE7di2IdjMgs9Z8vMRoqDoD78CwechPjW8AtUFN
	 6rQ0Az7KSUILOsGdw835CcD/+J5q+WSXqsXYAeWnycPyBPJoWvesjlqeDseYHDONFL
	 o4J1QHacllxkonbIcQ8eu1cBSJ348RNNsupP9sx8bEOxr2sUNkJgFd+qFDcau5WyPh
	 EhGMxgPu6Ea4w==
Date: Thu, 29 Jan 2026 09:21:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, hch@infradead.org,
        sohil.mehta@intel.com
Subject: Re: [PATCH v9 12/22] KVM: VMX: Virtualize FRED event_data
User-Agent: K-9 Mail for Android
In-Reply-To: <60C180BF-AD13-48EF-9BA8-CEACF57965EF@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-13-xin@zytor.com> <aR04V4VVg+p4RsdT@intel.com> <60C180BF-AD13-48EF-9BA8-CEACF57965EF@zytor.com>
Message-ID: <1EA97017-82D2-4C43-B617-D39C68D7BC6F@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69578-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[zytor.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hpa@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:email,zytor.com:dkim,zytor.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: 0BE87B2D0E
X-Rspamd-Action: no action

On January 29, 2026 9:12:02 AM PST, Xin Li <xin@zytor=2Ecom> wrote:
>
>> On Nov 18, 2025, at 7:24=E2=80=AFPM, Chao Gao <chao=2Egao@intel=2Ecom> =
wrote:
>>=20
>>> diff --git a/arch/x86/kvm/vmx/vmx=2Ec b/arch/x86/kvm/vmx/vmx=2Ec
>>> index 4a74c9f64f90=2E=2E0b5d04c863a8 100644
>>> --- a/arch/x86/kvm/vmx/vmx=2Ec
>>> +++ b/arch/x86/kvm/vmx/vmx=2Ec
>>> @@ -1860,6 +1860,9 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
>>>=20
>>> vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
>>>=20
>>> + if (is_fred_enabled(vcpu))
>>> + vmcs_write64(INJECTED_EVENT_DATA, ex->event_data);
>>=20
>> I think event_data should be reset to 0 in kvm_clear_exception_queue()=
=2E
>> Otherwise, ex->event_data may be stale here, i=2Ee=2E, the event_data f=
rom the
>> previous event may be injected along with the next event=2E
>
>It=E2=80=99s no harm to reset it, although it shouldn=E2=80=99t be stale =
when an event that
>uses event data is being injected (otherwise it=E2=80=99s a bug)=2E
>
>
>>=20
>>> +
>>> vmx_clear_hlt(vcpu);
>>> }
>>>=20
>>=20
>>> /*
>>> @@ -950,6 +963,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, =
unsigned int nr,
>>> vcpu->arch=2Eexception=2Eerror_code =3D error_code;
>>> vcpu->arch=2Eexception=2Ehas_payload =3D false;
>>> vcpu->arch=2Eexception=2Epayload =3D 0;
>>> + vcpu->arch=2Eexception=2Eevent_data =3D event_data;
>>=20
>> If userspace saves guest events (via kvm_vcpu_ioctl_x86_get_vcpu_events=
())
>> right after an event is requeued, event_data will be lost (as that uAPI=
 only
>> saves the payload and KVM doesn't convert the event_data back to a payl=
oad
>> there)=2E So this event will be delivered with incorrect event_data if =
the
>> event is restored on another system after migration=2E
>
>Nice catch!
>
>Just to confirm, you are referring to requeueing an original event
>via vmx_complete_interrupts(), right?
>
>Regardless of whether FRED or IDT is in use, the event payload is deliver=
ed
>into the appropriate guest state and then invalidated in
>kvm_deliver_exception_payload():
>
>        1) CR2 for #PF
>
>        2) DR6 for #DB
>
>        3) guest_fpu=2Exfd_err for #NM (in handle_nm_fault_irqoff())
>
>We should be able to recover the FRED event data from there=2E
>
>Alternatively, we could drop the original event and allow the hardware to
>regenerate it upon resuming the guest=2E  However, this breaks #DB delive=
ry,
>as debug exceptions sometimes are triggered post-instruction=2E
>
>
>Sean, does it make sense to recover the FRED event data from guest CPU st=
ate?
>
>
>

I think some bits in DR6 are "sticky", and so unless the guest has explici=
tly cleared DR6 the event data isn't necessarily derivable from DR6=2E Howe=
ver, the FRED event data for #DB is directly based on the data already repo=
rted by VTx (for exactly the same reason =E2=80=93 knowing what the *curren=
tly taken* trap represents=2E)

