Return-Path: <kvm+bounces-71459-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Ki6KiAWnGkq/gMAu9opvQ
	(envelope-from <kvm+bounces-71459-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 09:56:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB21173568
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 09:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B786730263D1
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1167734DCDF;
	Mon, 23 Feb 2026 08:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvQWh2Uy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WqJTvPst"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7B534D907
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 08:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771836954; cv=none; b=NUN4HclgqVTKPrFtGJLc87Q3hC5QEW63OW+9uW8hMpLCs9TUKU9mtWJlPjctAsVZ9j5mfwSQgRCyRLN++JHSfViyl6xRvhuw/q/KqXFSS1APDSNq2xBkdo51WnaA9XEe2pDmcDsbMTLD5CbWsplL2+1ZoWWSqWqvUkpB2+Jya0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771836954; c=relaxed/simple;
	bh=KYFlfC8sXrxlylue5TpXssTcOuehH7BERDSDVQq92dw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fx22c/f0dEuXiH9pTQJQIac68XlIc8XmRsGyUacTs9At94z6reZM7oyK3fn+gmdxS8Y7PsNdzDIK7AJvuJmLsqCbEM8SiDQLxMPf5by4cxIG0KM575EP8y/KIpyqYqTUHvqdEsR7I8L7juqagQsB/7pnYY5GHxCPnF47cawybvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SvQWh2Uy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WqJTvPst; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771836952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HlfPtuoIVP7zNl5EzRr0slKeeyrKnAzFG3uyLdGjiYo=;
	b=SvQWh2UywOtaOIy6cITrTLU3BgR/hH+taokJGWPvzJiSx29F+WLHpjFzv8WNDVKcczf8Bd
	7oTh59r3QmTzG5GQlCHAL7bG9KGh1eoih5Wo6CP/MIw1Z5eIKgNsopB5mijfSY0WVFOGre
	hJg6lTDrmLkFjndygkwDOTLCOA8rzbE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-GgTTJniqOj2sOsfpjTvpaw-1; Mon, 23 Feb 2026 03:55:50 -0500
X-MC-Unique: GgTTJniqOj2sOsfpjTvpaw-1
X-Mimecast-MFC-AGG-ID: GgTTJniqOj2sOsfpjTvpaw_1771836949
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4836cc0b38eso42120475e9.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 00:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771836949; x=1772441749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HlfPtuoIVP7zNl5EzRr0slKeeyrKnAzFG3uyLdGjiYo=;
        b=WqJTvPstOAsmsURzTxsrFNVrNCNCpBQBE5tOnt+IiRfJt2MuadzlrQPYFsg5ZpurSB
         9dr/AWY3OsptDDVj0o9VLmxBpZwNHO43S7xP1BSK1nr5Kt65CVg4Df3CCbQN1/+iR5RY
         2eYkgsmSGT9tfYjarHB/SM4G+sZgPxNT6DzJ0GBi7BZX6KZ3NHoaMPgM+3MCHRuCY0c2
         83GPd1+Bbp+7JhwKrcT44CB4ZUyjf6yd1OdGSJLzBm38NI/2GrRdGYMNZx9icswf3K2G
         WlmGQA4x7dKPyOocR41Nb/wLf8VrNLkHFG42/KgQtt/2MQtvRK1e9EjDdv5x/y6Z0W/X
         vkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771836949; x=1772441749;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HlfPtuoIVP7zNl5EzRr0slKeeyrKnAzFG3uyLdGjiYo=;
        b=VC124i2dI4JzNnJ7wbhweDLNtU3TSbzorF84fGilm4SMDBW0xKgVrjdHqMm2Oww3JU
         70GRnqu4k7WiWTM6QffcadChf8bcBFfNXRUvulmyu/nJq/e6Zav4w6M/r1hkRrreM2Mz
         JB55U+nYryMLy5IjHuAxFw9cchIZU+DkfrNZayRilP346221tP3G5vvYJabSN4xI1VN6
         N9yiaogzR++2BH92IoTiHM1PSG1zWxtei9MM2tHjJ/e04VWIUU3yRHUEPzlWUREub2HM
         QasBme32KpVnqn+mr4J7p+yaMprsTCxvIV+haLVjRRi3XLR4yiFanfJ+OcSqLryV94Hf
         Xa/Q==
X-Gm-Message-State: AOJu0YzmhYIJ8kITeZPbkcszvBoSnSSH8n/Nxwdc5w7sJQJmUqrBtjDz
	Pn45YiQkNowErR1235MYd5hqpSDByDJheEStuBRw01VJoa7Mx58YykFxPncsCn7jkHqjW0LeWT8
	EG8ICnIf7WNaY6JhOpQQa0ppE3w/v4WGNYY8MSulMcF5V4LbBkJEptg==
X-Gm-Gg: AZuq6aJ8BYZB9G+Ux4lC/ejfjGUBJr39ciZC0I8Tv2R02lvYdLY36mQa2xyzV0mfZbW
	mdmQ6Fgy8jMLZqFnyxeyncuCq93C16WIMZi6kbv2miCZP4wrWxNFeOCuC5tfjE/bzRy77htUVdX
	myG/xhSqyH7+a/BaxPbEQYgekaMgRbNKBlXVBH1HGnUSH34L65G5YwNfsNm1iWTXz/gPc+IiBk6
	SqDrXuli9r12BpVrm8oDR5Uod7FczOlSirTxJPg6I6SXtHr4oG7XEHmUXi361h8BX2a358RkOIZ
	gHfvem1a4lTBN5FUkr7CKsQ6XKe8Y7oBhezZNIlPJ4WFodyBZ1K4OwreyPFJzMjngGai/PQszGJ
	sLf31v7o8MoRZ4ZzGxw==
X-Received: by 2002:a05:600c:5394:b0:483:6a8d:b2fc with SMTP id 5b1f17b1804b1-483a95b7162mr109762335e9.8.1771836948631;
        Mon, 23 Feb 2026 00:55:48 -0800 (PST)
X-Received: by 2002:a05:600c:5394:b0:483:6a8d:b2fc with SMTP id 5b1f17b1804b1-483a95b7162mr109762035e9.8.1771836948063;
        Mon, 23 Feb 2026 00:55:48 -0800 (PST)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a4424106sm193187565e9.0.2026.02.23.00.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 00:55:47 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Manuel Andreas
 <manuel.andreas@tum.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/hyper-v: Validate entire GVA range for
 non-canonical addresses during PV TLB flush
In-Reply-To: <aZiYgTNHfM5Y_Mo7@google.com>
References: <00a7a31b-573b-4d92-91f8-7d7e2f88ea48@tum.de>
 <aZiYgTNHfM5Y_Mo7@google.com>
Date: Mon, 23 Feb 2026 09:55:46 +0100
Message-ID: <87pl5vu9d9.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71459-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vkuznets@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6CB21173568
X-Rspamd-Action: no action

Sean Christopherson <seanjc@google.com> writes:

> +Vitaly and Paolo
>
> Please use scripts/get_maintainer.pl, otherwise your emails might not rea=
ch the
> right eyeballs.
>
> On Thu, Feb 19, 2026, Manuel Andreas wrote:
>> In KVM guests with Hyper-V hypercalls enabled, the hypercalls
>> HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_=
EX
>> allow a guest to request invalidation of portions of a virtual TLB.
>> For this, the hypercall parameter includes a list of GVAs that are suppo=
sed
>> to be invalidated.
>>=20
>> Currently, only the base GVA is checked to be canonical. In reality,
>> this check needs to be performed for the entire range of GVAs.
>> This still enables guests running on Intel hardware to trigger a
>> WARN_ONCE in the host (see prior commit below).
>>=20
>> This patch simply moves the check for non-canonical addresses to be
>> performed for every single GVA of the supplied range. This should also
>> be more in line with the Hyper-V specification, since, although
>> unlikely, a range starting with an invalid GVA may still contain
>> GVAs that are valid.
>>=20
>> Fixes: fa787ac07b3c ("KVM: x86/hyper-v: Skip non-canonical addresses dur=
ing PV TLB flush")
>> Signed-off-by: Manuel Andreas <manuel.andreas@tum.de>
>> ---
>>  arch/x86/kvm/hyperv.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index de92292eb1f5..f4f6accf1a33 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1981,16 +1981,17 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>>  		if (entries[i] =3D=3D KVM_HV_TLB_FLUSHALL_ENTRY)
>>  			goto out_flush_all;
>>=20=20
>> -		if (is_noncanonical_invlpg_address(entries[i], vcpu))
>> -			continue;
>> -
>>  		/*
>>  		 * Lower 12 bits of 'address' encode the number of additional
>>  		 * pages to flush.
>>  		 */
>>  		gva =3D entries[i] & PAGE_MASK;
>> -		for (j =3D 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
>> +		for (j =3D 0; j < (entries[i] & ~PAGE_MASK) + 1; j++) {
>> +			if (is_noncanonical_invlpg_address(gva + j * PAGE_SIZE, vcpu))
>> +				continue;
>> +
>>  			kvm_x86_call(flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
>> +		}
>
> Vitaly, can we treat the entire request as garbage and throw it away if a=
ny part
> isn't valid?  Or do you think we should go with the more conservative app=
roach
> as above?

I don't remember if I have ever seen real Windows trying to flush
anything non-canonical at all but my gut feeling tells me we should
rather play safe and use Manuel's 'conservative' approach. Also, this
should be consistent with TLFS which says:

"Invalid GVAs (those that specify addresses beyond the end of the
partition=E2=80=99s GVA space) are ignored."

i.e. it doesn't say 'Invalid GVA RANGES are ignored'.

>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index de92292eb1f5..f568f3d4f6e5 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1967,8 +1967,8 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>         struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>         struct kvm_vcpu_hv *hv_vcpu =3D to_hv_vcpu(vcpu);
>         u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
> +       gva_t gva, extra_pages;
>         int i, j, count;
> -       gva_t gva;
>=20=20
>         if (!tdp_enabled || !hv_vcpu)
>                 return -EINVAL;
> @@ -1978,18 +1978,22 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>         count =3D kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB=
_FLUSH_FIFO_SIZE);
>=20=20
>         for (i =3D 0; i < count; i++) {
> +
>                 if (entries[i] =3D=3D KVM_HV_TLB_FLUSHALL_ENTRY)
>                         goto out_flush_all;
>=20=20
> -               if (is_noncanonical_invlpg_address(entries[i], vcpu))
> -                       continue;
> -
>                 /*
>                  * Lower 12 bits of 'address' encode the number of additi=
onal
>                  * pages to flush.
>                  */
>                 gva =3D entries[i] & PAGE_MASK;
> -               for (j =3D 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
> +               extra_pages =3D (entries[i] & ~PAGE_MASK);
> +
> +               if (is_noncanonical_invlpg_address(gva, vcpu) ||
> +                   is_noncanonical_invlpg_address(gva + extra_pages * PA=
GE_SIZE))
> +                       continue;
> +
> +               for (j =3D 0; j < extra_pages + 1; j++)
>                         kvm_x86_call(flush_tlb_gva)(vcpu, gva + j * PAGE_=
SIZE);
>=20=20
>                 ++vcpu->stat.tlb_flush;
>

--=20
Vitaly


