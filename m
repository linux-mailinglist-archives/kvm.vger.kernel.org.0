Return-Path: <kvm+bounces-13205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C08FD893366
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71B1C2838F8
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55BF1448D3;
	Sun, 31 Mar 2024 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JSkQ4rEh"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5E71EA71;
	Sun, 31 Mar 2024 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902681; cv=fail; b=QXrQHrh8GdgbRyCFs8y45m6SmrQrsK2iZK7jG6mKvLTwmRF4fTIDYcKM20jbl5H1qvPQuGaz490FYm5V2LFcMWnDuLIHxFdfmEg/WHOLs5/xvhlcVyVOE6sXDJ56L3OGCbJ1AGnaXBRskmZ13C01txHZMmWjlFGw04DkTu86038=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902681; c=relaxed/simple;
	bh=HxDZU7e4V+6VclBlhhMt4NnWyFnvASF8fd6WSJDB8Hk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GfFx5A2cT6ivef+O51mYiSKrpQHqLZhXkEYmM/c6z4cOLpwap+DwiOSU6ReH2ZDHZFcOLE5109QfE/ai2QXiWA7qZNB4cwIpTz2jk47hV3EKzg3Zp7j1AXAEma9xOtqlFT27Wc4+yHKapP98PHgKdwsiPq3LpfrixfEXfKodIM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JSkQ4rEh reason="signature verification failed"; arc=none smtp.client-ip=170.10.133.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 7177420842;
	Sun, 31 Mar 2024 18:31:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X24C6NgotWIX; Sun, 31 Mar 2024 18:31:13 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 16A2120826;
	Sun, 31 Mar 2024 18:31:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 16A2120826
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 0B8CC80004A;
	Sun, 31 Mar 2024 18:25:05 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:25:04 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:53 +0000
X-sender: <linux-crypto+bounces-3136-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAuKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBbAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 17821
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3136-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com C95472076B
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834544; cv=none; b=q9NXw4B9yxlbqY3oG52iLzyPSv6XNvuvbXHciJIE1sJiq9ebhLd6Ax88NC//ZNm+CDRygqU45Tmh4uis5R+nhxda0ZygxsPN8+7NonMQANIIENupT1AIS1bj8Fl4YZJ/unkFFyvRjxIMA/+9YFgRwRNezw6sCbcVLK4IaD0y6so=
ARC-Message-Signature: i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834544; c=relaxed/simple;
	bh=A/4nTvH3zcKKDjwq9z7ISuECCM1K8A3A6bBgBipegtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eFNgdjaR4J4Uoz+I3mgxLCqDUhmelqAAHz0lyzdxYao424xVWR2Nhu0tjv7RzRU8+BurJQYRKYCRtuYssoMOcH5fLyOkLqidZ7AIYF220I4hAc3/JVLff8IYWvxugAc9q4yrqtBIOvmWRLQaDqhCFqYWv+xjN9Pyjs5/yvVQ9xA=
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JSkQ4rEh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=;
	b=JSkQ4rEhAmsVeZHuSYL5XgrgNAt13SHnq30WYpbBo6nFSIhiqf0vtKADsEKaBU6OpGVLpQ
	QDX2PzilH9CaTqvHEj9l8ryQdEGf/Tgw6oCc+JpP/bBlFa90eiL40fMPrYKiSpY28VeuVr
	I/R0WttkS5b3uVoyvz/AgBrsOKNpSuI=
X-MC-Unique: ot682GmgNqea56yF7WzxpA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834538; x=1712439338;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=;
        b=wejdjgGddTsGZE/Hu+tUsD9MtZnDTDM9RgNO5EsaqrTwm6B/54/5hpzk5+F709jadB
         jkFBfFdPHXup9JUoNsdqQTI4FKWmqv+EVkdqp0vraYR+OB5ia0GQPCFoO+FJaa5qSpSj
         kqLxnCz4RYr1x66TW86y+XnumXrJ0qOltlZ10RWSedpP6+9/mlY/a5zdC9NDphupWEaY
         p0tsO5tSCICXiPTSIyO2GVxXm3gbvpsbih5xgxE4ojUEyWvp4REgNPZnbgpC1PYYkM7a
         sdAF+9kx8tJnYAo/37eAJh2gS1UbGMfumQwqpkoUDmKIISFtq2S1fwYPQl4NeuEUghyf
         fx1A==
X-Forwarded-Encrypted: i=1; AJvYcCXdBtuKct43gLSLyMQAVXzfxoWgOBDb/fM9mxwcONxrza64wnzBts75AGUoW9V3D6EXXJLPmMjo6nsivWJmrc6E/pHLIe4pFlI3xx/V
X-Gm-Message-State: AOJu0YwyaICuWjqzycfD5woZyeziRfjCZ0z8TRhHB7WhZGjtDiMzo0xG
	qXgtBgWmph6CIcG5QK/ZiQtMALoRMKu/D0kYmmC+FS/eL98T0ood8SF+cQnshx1lbs9sCMTkApG
	2Iq5W0UGOC1GNyZ7lHuLYNkmnbzrWxQ95W4gs8RHhvNRae541/C7goVzKduW+fw==
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d18000000b00513b06298c4mr3643239lfj.11.1711834538170;
        Sat, 30 Mar 2024 14:35:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5PGmEGHf24nUfF7B7vuwJRBVN0rKW1MZiU9RQdC6MVZb3TnEUgyIIaZghldmm9GaQfOSwZw==
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d18000000b00513b06298c4mr3643226lfj.11.1711834537752;
        Sat, 30 Mar 2024 14:35:37 -0700 (PDT)
Message-ID: <00800f4b-5403-4416-b984-12b207362a19@redhat.com>
Date: Sat, 30 Mar 2024 22:35:33 +0100
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 24/29] KVM: SEV: Avoid WBINVD for HVA-based MMU
 notifications for SNP
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-25-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-25-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On 3/29/24 23:58, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>=20
> With SNP/guest_memfd, private/encrypted memory should not be mappable,
> and MMU notifications for HVA-mapped memory will only be relevant to
> unencrypted guest memory. Therefore, the rationale behind issuing a
> wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
> for SNP guests and can be ignored.
>=20
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: Add some clarifications in commit]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 31f6f4786503..3e8de7cb3c89 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2975,7 +2975,14 @@ static void sev_flush_encrypted_page(struct kvm_vc=
pu *vcpu, void *va)
>  =20
>   void sev_guest_memory_reclaimed(struct kvm *kvm)
>   {
> -	if (!sev_guest(kvm))
> +	/*
> +	 * With SNP+gmem, private/encrypted memory should be
> +	 * unreachable via the hva-based mmu notifiers. Additionally,
> +	 * for shared->private translations, H/W coherency will ensure
> +	 * first guest access to the page would clear out any existing
> +	 * dirty copies of that cacheline.
> +	 */
> +	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>   		return;
>  =20
>   	wbinvd_on_all_cpus();


X-sender: <kvm+bounces-13160-martin.weber=3Dsecunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=3Drfc822;martin.weber@secunet.=
com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7f=
W2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNS=
ZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAU=
AEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWU=
RJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAA=
LMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0=
cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3Vwcyx=
DTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cm=
F0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ie=
C1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxS=
ZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFg=
AFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYX=
Rpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc=
3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5U=
cmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQA=
jAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAuKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBdAAAAo4oAAAUABAAUIAEAAAAYAAAAbWFydGlu=
LndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwA=
BAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 17817
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:36:05 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:36:05 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id C1C7D20322
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:36:05 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.851
X-Spam-Level:
X-Spam-Status: No, score=3D-2.851 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.1, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G3vJTeK-xASN for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 22:36:03 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dkvm+bounce=
s-13160-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber=
@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 572412025D
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"AaC50WIk"
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 572412025D
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F0571C216C7
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 21:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70FB5103E;
	Sat, 30 Mar 2024 21:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"AaC50WIk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D084A99C
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834544; cv=3Dnone; b=3DllVqaoaCimh+5hmI9zmsnC/iwyzb2E5Hu7QNGoMonpz=
PGejc///CLaxbkq8Cweg+S1JiGYBT3GW4IXKhqhtyeU45YUqJD3NDZBzyxFgxcr6x2bJ/zqwbjY=
WUDHB6m51Ve9hV/UuT0jat8CyrbAV3/nk8SjFStB8Gtdb3yUASx7Y=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834544; c=3Drelaxed/simple;
	bh=3DA/4nTvH3zcKKDjwq9z7ISuECCM1K8A3A6bBgBipegtg=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DeFNgdjaR4J4Uoz+I3mgxLCqDUhmelqAAHz0lyzdxYao=
424xVWR2Nhu0tjv7RzRU8+BurJQYRKYCRtuYssoMOcH5fLyOkLqidZ7AIYF220I4hAc3/JVLff8=
IYWvxugAc9q4yrqtBIOvmWRLQaDqhCFqYWv+xjN9Pyjs5/yvVQ9xA=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DAaC50WIk; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834542;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Dk6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=3D;
	b=3DAaC50WIksL9NXcrY24Vf8866p2pD2dqoSt2KH3Q9m5G0W+ckANKXwFV174bh285mSHdYYp
	Am7Pp2OVACSpmiGTiarIdJ3LjY7U4pMD4dIoEJj3ZGOB4HEAf14Rvx311TLCJXwVJkY5J+
	xI1Knv3RO0diA68TV+qXMsxlED6tSMU=3D
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-422-DH0MhiZ-NpO52d4IzgoGyw-1; Sat, 30 Mar 2024 17:35:39 -0400
X-MC-Unique: DH0MhiZ-NpO52d4IzgoGyw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-50e91f9d422=
so2894479e87.2
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834538; x=3D1712439338;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Dk6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=3D;
        b=3DRCf5TMeMQhuiEsqquu6GXQ6GB3m+0/iFcCRbdF6FHT1Iubn/tjzv9lJOylHmfYv=
5Rd
         0IDLo6EJAZe/Wj/3XMS1gcLnaViQijGQJp80IzzKosq6bJfMwoJ05jO2hHjP2LesRk=
CL
         ls6tLS8SmE7uOn5J/O8eraI2NB5d2E7aFk5FjrSgdc4szOq6yKDiEsUZh7LD8AZt3x=
3V
         FjPHhGFDXaTfQRvJNBteXbSAO2dwmd9M+EVjU5OP479DDtLt7PAvHOQhrnFbM2mI+x=
Q1
         GpaNnNlrtdfoevCxQxcG3X81fpRXiK2IjIEOGdqn+4ljVqkGltjlAiV1zSYWssY4ZX=
sf
         Yajg=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCVsvUr1yfJMqn5TiPVxUHnKx54OrM1lq42sSt5QV=
6/IUdSjUCRDAopDDLunjYXvT4rMttWkkf9EOqxfV0NgTL6zg5Gv
X-Gm-Message-State: AOJu0Yw78dI/Q4jTJmUdgdVwmJo61d5Dc0X6+N42kKg2Ei0tQZSPKJK=
n
	85HBFAanKtI/SqjFIhGrwICQQxDWmQLuhNwCXKkLmnck6SXZv02QHXiI7Juury1kcXbmHeR23i=
X
	H7r5aoSL0elu+EUpX1DdU0z9z4Uju3Ci5pQXkOOY1Vc6cKsnqGw=3D=3D
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d=
18000000b00513b06298c4mr3643259lfj.11.1711834538175;
        Sat, 30 Mar 2024 14:35:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5PGmEGHf24nUfF7B7vuwJRBVN0rKW1MZiU9RQdC6MVZb3T=
nEUgyIIaZghldmm9GaQfOSwZw=3D=3D
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d=
18000000b00513b06298c4mr3643226lfj.11.1711834537752;
        Sat, 30 Mar 2024 14:35:37 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id w4-20020a1709062f8400b00a4e0=
7f8b6bfsm3445434eji.59.2024.03.30.14.35.34
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:35:37 -0700 (PDT)
Message-ID: <00800f4b-5403-4416-b984-12b207362a19@redhat.com>
Date: Sat, 30 Mar 2024 22:35:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 24/29] KVM: SEV: Avoid WBINVD for HVA-based MMU
 notifications for SNP
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org=
,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com=
,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-25-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-25-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: kvm+bounces-13160-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:36:05.7650
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 24f51bbd-dcf0-4e6f-b4c7-08dc=
510167c6
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.419|SMR=3D0.345(SMRDE=3D0.035|SMRC=3D0.31=
0(SMRCL=3D0.100|X-SMRCR=3D0.309))|CAT=3D0.072(CATOS=3D0.012
 (CATSM=3D0.012(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.042(CATRESLP2R=3D0.039)|CATORES=3D0.016
 (CATRS=3D0.015(CATRS-Index Routing Agent=3D0.014)));2024-03-30T21:36:06.21=
4Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 13679
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.029|SMR=3D0.022(SMRPI=3D0.020(SMRPI-FrontendProxyAgent=3D0.020))=
|SMS=3D0.008
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAYEEAAAPAAADH4sIAAAAAAAEAI1UW2/b=
NhQ+si35EjvBmh
 Yb+jCcvjmJL7nHSYMg3cNQYMhWtNv6MAwGLVEWUYkyRNmJt/yG/eYd
 koovg7ONoGWS5zvfuZJ/NX+SeNI/vuwfn+LxydXZoIN3wo8Yj/Fjmk
 d4n6U5v2o1bvD7LE2u8J2KhIrwBxZnDK+Z2fW+6N0tS4KenyY3BNb4
 z4LUP/34oT+ecpUPE56EQQcnmZixnPe59LP5JOcBkiDN5qiidBoHKN
 McRxwTNpmwUcw7monJAO/uftEyEQqf5SKVCsM0w/e/vutq6JLmXsQx
 pjKea5aMx3zGZI55qnmmcmnVOFUo9fDniGecCHkH84j0jAkWcyKJBF
 kXSk2FHCPTNPcjIWfBMJVDFsdDfzJV7T0UEhWfDRexEu0w437MRMID
 kq+ER/7Gc02kI6AEWV+UCdNnUjsuxpKcCXpFKj/RngfdNAy7o/n/rQ
 H+lgQZgYMAVZpwJF+ylfSRwwRMRP77BgtrLXCd2F2PWiFasdBqfOQz
 we9JT+t8YGmc4nep/ENIgdeTkV3dUhwRyxc6N9jtdvUfIsv8qP8wOO
 9/mSV9pX981vPxES/xoBgF8ghDQdUgN+SYUxcNyH3FMxNJ+2CvQ4CA
 aq337e5ekbVAhCEZGwtKef8ZW6NnBFqfCs8f8OQoPA9PLwbnZ4cnvd
 4JHwT8wh+d+INLPDo8PD89LUJ61oaWUyT/aur2FrvHlxdnnQs8MP9H
 p/pM5VQsH2epCEx3hfFURcNFEw8nbMzbKs+mfo7EOZxRM+K+/nas0v
 6MPWUDlzTPNOmSCPfps2e1/jTxoR4ixPabBUFbYwzowEj7+8s17i+u
 /8GYDP33vR/xNe2pzDijctMTgDPBzK2MZqw7YkqrJtPiMeCZ6ukWF/
 bCxvPOGo2+YSpi1ILdm8IDzDMmVWxvQQff9z/TPdDXX/rF68Glmmbr
 7oQio9fCvhnM97lS9KQYp3QJ8N6E4MecZZhOCSLnyB+EyunNWOMJRJ
 bPyd5EcIVpSAwspzvvRzwWkvdWsf3lZkPe8fHRlFLJyT+rsT4ynk8z
 +XbRBHpsesDe6rvZagCUoOw4ULUTSrQtOWUXwIVqFWoVcF1oVMDzoE
 onngMv9cIrQ6UMWySlhevAFngWX4cGIWnSOVHVoGWQlRZs64UDDahY
 AOnSNJh6CbwtaLraCjFsEdLyEKEDLhl9AVVC0nnFLhx4TXaNV3VoWn
 Mu1K0tu7UOVGGH1FuFP5VNUZCWa5jdbdghFQ+2VlVMEryqVqnZeMtQ
 q+mQyW3tQxXqtN2FurG7+4QppuNUHADH+Up/oUTSqlO364azYxc1eF
 Ex5ixgTR1Kmw6pKF4TtptOywPwYHsTpr7h0Knpyjqecalk1yXdA56t
 CCX2GxNUXRfd1RE5UNPJ8ewsQdPCVvLfMIGToVclI6obURm+rRSJ9V
 YbowQ7VOvCpSWYKr7VhNemfDXCN01QNJ882XV1j3neshNce2KpavBq
 ISVRHd6sO1Mr65pWysX2aw9ervXV3xVfMWkZCQAAAQrBAzw/eG1sIH
 ZlcnNpb249IjEuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWls
 U2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPE
 VtYWlscz4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iNjEiPg0KICAg
 ICAgPEVtYWlsU3RyaW5nPmFzaGlzaC5rYWxyYUBhbWQuY29tPC9FbW
 FpbFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICAgIDxFbWFpbCBTdGFy
 dEluZGV4PSI1NDciIFBvc2l0aW9uPSJPdGhlciI+DQogICAgICA8RW
 1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3Ry
 aW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW5kZX
 g9IjYwMCIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0
 cmluZz5wYm9uemluaUByZWRoYXQuY29tPC9FbWFpbFN0cmluZz4NCi
 AgICA8L0VtYWlsPg0KICA8L0VtYWlscz4NCjwvRW1haWxTZXQ+AQ7O
 AVJldHJpZXZlck9wZXJhdG9yLDEwLDE7UmV0cmlldmVyT3BlcmF0b3
 IsMTEsMTtQb3N0RG9jUGFyc2VyT3BlcmF0b3IsMTAsMDtQb3N0RG9j
 UGFyc2VyT3BlcmF0b3IsMTEsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm
 9zdGljT3BlcmF0b3IsMTAsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9z
 dGljT3BlcmF0b3IsMTEsMDtUcmFuc3BvcnRXcml0ZXJQcm9kdWNlci wyMCw3
X-MS-Exchange-Forest-IndexAgent: 1 1827
X-MS-Exchange-Forest-EmailMessageHash: A196860A
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>=20
> With SNP/guest_memfd, private/encrypted memory should not be mappable,
> and MMU notifications for HVA-mapped memory will only be relevant to
> unencrypted guest memory. Therefore, the rationale behind issuing a
> wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
> for SNP guests and can be ignored.
>=20
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: Add some clarifications in commit]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 31f6f4786503..3e8de7cb3c89 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2975,7 +2975,14 @@ static void sev_flush_encrypted_page(struct kvm_vc=
pu *vcpu, void *va)
>  =20
>   void sev_guest_memory_reclaimed(struct kvm *kvm)
>   {
> -	if (!sev_guest(kvm))
> +	/*
> +	 * With SNP+gmem, private/encrypted memory should be
> +	 * unreachable via the hva-based mmu notifiers. Additionally,
> +	 * for shared->private translations, H/W coherency will ensure
> +	 * first guest access to the page would clear out any existing
> +	 * dirty copies of that cacheline.
> +	 */
> +	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>   		return;
>  =20
>   	wbinvd_on_all_cpus();


X-sender: <linux-kernel+bounces-125896-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com NOTIFY=3DNEVER; X-ExtendedProps=3DBQAVABYAAgAAAAUAFAARAPDFCS25B=
AlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURh=
dGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQB=
HAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3=
VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4Y=
wUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5n=
ZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl=
2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ0=
49Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAH=
QAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5z=
cG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAw=
AAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbi=
xPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQ=
XV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1p=
Y3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmV=
yc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAtaNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBeAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 17913
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:36:14 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:36:14 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id B4B9520322
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:36:14 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.851
X-Spam-Level:
X-Spam-Status: No, score=3D-2.851 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.1, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dunavailable autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bX0hQhQjf4l0 for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:36:13 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125896-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 3DC7E2025D
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"JSkQ4rEh"
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 3DC7E2025D
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5FFC1F21DFE
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6933F52F70;
	Sat, 30 Mar 2024 21:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"JSkQ4rEh"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047A91DFC6
	for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 21:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834543; cv=3Dnone; b=3Dccog+mZGdcIjlotH1ju2gIP+H8Ihe03fxFUhE4rASqb=
EAUuXyGOV6OARBR2a/ue+ukMJZEXif0R/51/PisvRQr7KCPTmLGbVNim/5k+zbSTPVubege281L=
cw+fLzTw94RUeNV05FDMdKG9gJ1STLM78HBWz+k2BA+oTgfxL+gr4=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834543; c=3Drelaxed/simple;
	bh=3DA/4nTvH3zcKKDjwq9z7ISuECCM1K8A3A6bBgBipegtg=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3Dlhwggt1Q7u+PTm50rqr0jpiDnPgBOKmFdevuB0Q9wuP=
RK6pZlQjVmloy5qWWkfRebugKpr0MjH47ARrNBeWtvHItAi3pRPhVqijUjO808hQs7BY8FUd10N=
3j46QWLytQN4PXyGDaKzEluE33+JFzMmHh5S+lX3RvXHgXm81iPL8=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DJSkQ4rEh; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834541;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Dk6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=3D;
	b=3DJSkQ4rEhAmsVeZHuSYL5XgrgNAt13SHnq30WYpbBo6nFSIhiqf0vtKADsEKaBU6OpGVLpQ
	QDX2PzilH9CaTqvHEj9l8ryQdEGf/Tgw6oCc+JpP/bBlFa90eiL40fMPrYKiSpY28VeuVr
	I/R0WttkS5b3uVoyvz/AgBrsOKNpSuI=3D
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-464-TulHzr_5OgWLCaLKMpfrXA-1; Sat, 30 Mar 2024 17:35:39 -0400
X-MC-Unique: TulHzr_5OgWLCaLKMpfrXA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-515bbb9a73a=
so2292533e87.0
        for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 14:35:39 -0700=
 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834538; x=3D1712439338;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Dk6nhJ/n2fVMLTJ5orSzZrSN05UZkFdn1WgbErq3l2Pk=3D;
        b=3DGcPMMfkXq56SYLgMLVaoTFznA0YsHR7ZwCQhB1WbbcUB8I4+plNHYpzcbLzX812=
0s/
         juvL1k7m7nQJsH3N/8VmXi7m7PYGgyfc7VTDz0kAaDSInp0iELAxaUVR96e6XRBLge=
cz
         PwSqKfWTvSHaqUtv7ucJs88ESWF1/DuqfQxIg+fIL67zkZApg16yV0i5Bu6qgN8DxG=
GN
         A/vQUDCGbEwhedqbftl8w96+N7+oWk//sl9MuPUj++jQDFPdx92ae71gLPleWQUdD1=
Gd
         als/rv8D7OO/yZqscoZrJkTHSKzw7OgNuSyGHXdeTlU5gKeZGGGWThlyeOC/Jv+eyI=
N9
         gbOw=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCUGbr2aAbIhSFLUwf7Rao2KTehNv26xGMI4cS8oD=
+mFauDsHLHhTXa5YQVcm2Iro4N8olHuxY5IjrBYPnYK5PjVTEu3Ed109f+BWbod
X-Gm-Message-State: AOJu0YzBxnxGLehy+JxKH/2lQLAaIRi40ZZbcTQkkw9JFwSEQKZ1yB0=
2
	c8jJDyMRPwzPX7S78f/cVwIp8r/+JtXelF3Rh/kIaauyKpCWs0P7lslRUKn0LfPRhXNwYbYOvk=
r
	nmLxuXFk8otl8o8GKde2ds3nwKplUHqDWqrOW4TJArdl7Xy7mNp46ieTitGfjpg=3D=3D
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d=
18000000b00513b06298c4mr3643244lfj.11.1711834538172;
        Sat, 30 Mar 2024 14:35:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5PGmEGHf24nUfF7B7vuwJRBVN0rKW1MZiU9RQdC6MVZb3T=
nEUgyIIaZghldmm9GaQfOSwZw=3D=3D
X-Received: by 2002:a19:2d18:0:b0:513:b062:98c4 with SMTP id k24-20020a192d=
18000000b00513b06298c4mr3643226lfj.11.1711834537752;
        Sat, 30 Mar 2024 14:35:37 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id w4-20020a1709062f8400b00a4e0=
7f8b6bfsm3445434eji.59.2024.03.30.14.35.34
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:35:37 -0700 (PDT)
Message-ID: <00800f4b-5403-4416-b984-12b207362a19@redhat.com>
Date: Sat, 30 Mar 2024 22:35:33 +0100
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 24/29] KVM: SEV: Avoid WBINVD for HVA-based MMU
 notifications for SNP
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org=
,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com=
,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-25-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-25-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-kernel+bounces-125896-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:36:14.6826
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 4110a7a6-c5e7-483a-949d-08dc=
51016d17
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.411|SMR=3D0.340(SMRDE=3D0.035|SMRC=3D0.30=
5(SMRCL=3D0.101|X-SMRCR=3D0.305))|CAT=3D0.070(CATOS=3D0.011
 (CATSM=3D0.011(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.040(CATRESLP2R=3D0.036)|CATORES=3D0.015
 (CATRS=3D0.015(CATRS-Index Routing Agent=3D0.014)));2024-03-30T21:36:15.15=
7Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 13777
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.064|SMR=3D0.023(SMRPI=3D0.020(SMRPI-FrontendProxyAgent=3D0.020))=
|SMS=3D0.040
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAYEEAAAPAAADH4sIAAAAAAAEAI1UW2/b=
NhQ+si35EjvBmh
 Yb+jCcvjmJL7nHSYMg3cNQYMhWtNv6MAwGLVEWUYkyRNmJt/yG/eYd
 koovg7ONoGWS5zvfuZJ/NX+SeNI/vuwfn+LxydXZoIN3wo8Yj/Fjmk
 d4n6U5v2o1bvD7LE2u8J2KhIrwBxZnDK+Z2fW+6N0tS4KenyY3BNb4
 z4LUP/34oT+ecpUPE56EQQcnmZixnPe59LP5JOcBkiDN5qiidBoHKN
 McRxwTNpmwUcw7monJAO/uftEyEQqf5SKVCsM0w/e/vutq6JLmXsQx
 pjKea5aMx3zGZI55qnmmcmnVOFUo9fDniGecCHkH84j0jAkWcyKJBF
 kXSk2FHCPTNPcjIWfBMJVDFsdDfzJV7T0UEhWfDRexEu0w437MRMID
 kq+ER/7Gc02kI6AEWV+UCdNnUjsuxpKcCXpFKj/RngfdNAy7o/n/rQ
 H+lgQZgYMAVZpwJF+ylfSRwwRMRP77BgtrLXCd2F2PWiFasdBqfOQz
 we9JT+t8YGmc4nep/ENIgdeTkV3dUhwRyxc6N9jtdvUfIsv8qP8wOO
 9/mSV9pX981vPxES/xoBgF8ghDQdUgN+SYUxcNyH3FMxNJ+2CvQ4CA
 aq337e5ekbVAhCEZGwtKef8ZW6NnBFqfCs8f8OQoPA9PLwbnZ4cnvd
 4JHwT8wh+d+INLPDo8PD89LUJ61oaWUyT/aur2FrvHlxdnnQs8MP9H
 p/pM5VQsH2epCEx3hfFURcNFEw8nbMzbKs+mfo7EOZxRM+K+/nas0v
 6MPWUDlzTPNOmSCPfps2e1/jTxoR4ixPabBUFbYwzowEj7+8s17i+u
 /8GYDP33vR/xNe2pzDijctMTgDPBzK2MZqw7YkqrJtPiMeCZ6ukWF/
 bCxvPOGo2+YSpi1ILdm8IDzDMmVWxvQQff9z/TPdDXX/rF68Glmmbr
 7oQio9fCvhnM97lS9KQYp3QJ8N6E4MecZZhOCSLnyB+EyunNWOMJRJ
 bPyd5EcIVpSAwspzvvRzwWkvdWsf3lZkPe8fHRlFLJyT+rsT4ynk8z
 +XbRBHpsesDe6rvZagCUoOw4ULUTSrQtOWUXwIVqFWoVcF1oVMDzoE
 onngMv9cIrQ6UMWySlhevAFngWX4cGIWnSOVHVoGWQlRZs64UDDahY
 AOnSNJh6CbwtaLraCjFsEdLyEKEDLhl9AVVC0nnFLhx4TXaNV3VoWn
 Mu1K0tu7UOVGGH1FuFP5VNUZCWa5jdbdghFQ+2VlVMEryqVqnZeMtQ
 q+mQyW3tQxXqtN2FurG7+4QppuNUHADH+Up/oUTSqlO364azYxc1eF
 Ex5ixgTR1Kmw6pKF4TtptOywPwYHsTpr7h0Knpyjqecalk1yXdA56t
 CCX2GxNUXRfd1RE5UNPJ8ewsQdPCVvLfMIGToVclI6obURm+rRSJ9V
 YbowQ7VOvCpSWYKr7VhNemfDXCN01QNJ882XV1j3neshNce2KpavBq
 ISVRHd6sO1Mr65pWysX2aw9ervXV3xVfMWkZCQAAAQrBAzw/eG1sIH
 ZlcnNpb249IjEuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWls
 U2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPE
 VtYWlscz4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iNjEiPg0KICAg
 ICAgPEVtYWlsU3RyaW5nPmFzaGlzaC5rYWxyYUBhbWQuY29tPC9FbW
 FpbFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICAgIDxFbWFpbCBTdGFy
 dEluZGV4PSI1NDciIFBvc2l0aW9uPSJPdGhlciI+DQogICAgICA8RW
 1haWxTdHJpbmc+bWljaGFlbC5yb3RoQGFtZC5jb208L0VtYWlsU3Ry
 aW5nPg0KICAgIDwvRW1haWw+DQogICAgPEVtYWlsIFN0YXJ0SW5kZX
 g9IjYwMCIgUG9zaXRpb249Ik90aGVyIj4NCiAgICAgIDxFbWFpbFN0
 cmluZz5wYm9uemluaUByZWRoYXQuY29tPC9FbWFpbFN0cmluZz4NCi
 AgICA8L0VtYWlsPg0KICA8L0VtYWlscz4NCjwvRW1haWxTZXQ+AQ7O
 AVJldHJpZXZlck9wZXJhdG9yLDEwLDA7UmV0cmlldmVyT3BlcmF0b3
 IsMTEsMTtQb3N0RG9jUGFyc2VyT3BlcmF0b3IsMTAsMDtQb3N0RG9j
 UGFyc2VyT3BlcmF0b3IsMTEsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm
 9zdGljT3BlcmF0b3IsMTAsMDtQb3N0V29yZEJyZWFrZXJEaWFnbm9z
 dGljT3BlcmF0b3IsMTEsMDtUcmFuc3BvcnRXcml0ZXJQcm9kdWNlci wyMCw3
X-MS-Exchange-Forest-IndexAgent: 1 1827
X-MS-Exchange-Forest-EmailMessageHash: A196860A
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>=20
> With SNP/guest_memfd, private/encrypted memory should not be mappable,
> and MMU notifications for HVA-mapped memory will only be relevant to
> unencrypted guest memory. Therefore, the rationale behind issuing a
> wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
> for SNP guests and can be ignored.
>=20
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: Add some clarifications in commit]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 31f6f4786503..3e8de7cb3c89 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2975,7 +2975,14 @@ static void sev_flush_encrypted_page(struct kvm_vc=
pu *vcpu, void *va)
>  =20
>   void sev_guest_memory_reclaimed(struct kvm *kvm)
>   {
> -	if (!sev_guest(kvm))
> +	/*
> +	 * With SNP+gmem, private/encrypted memory should be
> +	 * unreachable via the hva-based mmu notifiers. Additionally,
> +	 * for shared->private translations, H/W coherency will ensure
> +	 * first guest access to the page would clear out any existing
> +	 * dirty copies of that cacheline.
> +	 */
> +	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>   		return;
>  =20
>   	wbinvd_on_all_cpus();



