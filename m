Return-Path: <kvm+bounces-13213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7032893385
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0836E1C22388
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:43:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F82F149E0E;
	Sun, 31 Mar 2024 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edl35z9B"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBA114534A;
	Sun, 31 Mar 2024 16:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903042; cv=fail; b=mGcRCBetXlBCsEmOpCB2HmF70QfU37VKc003QGPKPsNjUwPJQgMJx+EfGefjCVJWbY8cI8XsNAyv0TPWkf9RVBuusxuaPcd8Uu8t/5Me68B/Kb2G35dAjo+XHf5UWRhwVguuJLKRbKfeuMNuSFYBPjWyhATb1vWAd04kjk78UnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903042; c=relaxed/simple;
	bh=aaSk58JT9whL/HKe5P2WQNdiwUjmDMto5zbQdwdNWSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fylAu6Fd8GmeJXDGBK9/pExa2N3Hag5Mh1TUt/mAIKPGUDzD3u0j42MRLN01/0dxaZlJJZ6bSBvCXFvaGKh3hsQZ65sMuFSXK1vHKeJUmLrG4dwf+nZqulcVwj0sYfvXHXPgyFZiQhhZRVe84Jmyrd+2T2wwe9mxAumewVx78KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edl35z9B reason="signature verification failed"; arc=none smtp.client-ip=170.10.133.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 35BB2207E4;
	Sun, 31 Mar 2024 18:37:17 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xgd0PnRE3BLf; Sun, 31 Mar 2024 18:37:15 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 4503A2067F;
	Sun, 31 Mar 2024 18:37:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 4503A2067F
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id DD60A800059;
	Sun, 31 Mar 2024 18:29:10 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:29:10 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:53 +0000
X-sender: <linux-crypto+bounces-3134-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAuKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBHAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 16774
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3134-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 3F6762025D
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edl35z9B"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal: i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834316; cv=none; b=gJOWbCyvO2wtkvwciM/WUn8K+63Vnj9hz4hIrEViYMB6osXbRvppY2HaPm/gXqzRj+bqDLby+VuHviSU1DcX0wDDatXtgQ7dC1UhM2GQnaOBDSm4tMHJN3assWEr6MqPP3qXh7zw5PTlINp4RmiXDTaU6YdNSDHe2nvc6c23oRs=
ARC-Message-Signature: i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834316; c=relaxed/simple;
	bh=t1KY6wPgvCWcWD2NOTNvE0vD4k8SIvXspJg1UZfO6R0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8MgwMWfkZ70ClUhNdirX7OjjzUN+ChPioz9Xi7p5D0HT7V6vponoVF5u+ai0TsCGc+jh9J7pv/eToum7iPl7wNC7kSnP8BdlYiJ3PzsJkFGzsAYrWr/WNP98b7m5XYqJPQQ7Vx87BfJvxgM52HdXU5HOpJSztf1vF3IgNRn2PE=
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edl35z9B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=;
	b=edl35z9BPmJeVyfZue1DBgASBuJwOLiOFe38iSAg3czBXAE1pMtMh9BlYE5AQtD6STQIS0
	wok+P2jmy3CzbzdFwx1Zv4ThEy1G1K7H9WTPFgpvl6jLovXeYj89p6/1Y9IOqUWPyaSkpR
	QPqnhGKuj4lhUTNKIWo2ftLdwiMmoso=
X-MC-Unique: mSWmyoLTOQiBvVXwGihu9A-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834311; x=1712439111;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=;
        b=Oc2LG+GE+DDKDmSH+fvQsj06iJWMrb80J/8jLSV7MpNls3l9Fn2Ya+WNZ4Clgsq6nT
         ZaqGVm4UoCG9V75XoQw0gVYdq5bM8yaUkz5tzjjA2KuF7HHPzPVzQSeyO8KxZXcuz+Re
         6dG+3Wb597wHCyPuG7Atks0j4TOAnnEVPZYPCNnn0+UqUoSYPImbfyIhBpEGDWiPoDD3
         YdmyB+aq+WXLQPlrEtlejS9eugdUX4maJDIu/4YvNZtXZONZOyQVXtxQ8NyhfjahOcz5
         z4xMl0cek5tErsJuhvxYsIq+fNj1jdv3Y+H2Dnp0ilj9HADAIxUV5+4MLeGjVgHOXqWj
         QLng==
X-Forwarded-Encrypted: i=1; AJvYcCXOeMlo9rfHJCVICvAHrL9p6fFtUQraOFmSMkcRTFOfC7yVzk23LCRmAHxxnoCd+MO3SbI16b2ZcCS22BFgNtewdJFvOcIiYC63zBBz
X-Gm-Message-State: AOJu0YwAqeDoV6DB+hWen3FF67uv7QnIbasMxe8ZlxJRMixqkgsrizfd
	Mw3ccXv8aAxXC9IM+HkPFAdTjRmkSWzkUEek1P5a2XcxvW7lpcAFpDEpcaMm+m9AASrAS4NC0c4
	tW175QvIzbYXtg5EmN74x1KmCfkb8+ORJ0LtKesnsPxtGgsNUfFUaYomWyqNwkA==
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a170907969300b00a4e17c59944mr4619562ejc.61.1711834311182;
        Sat, 30 Mar 2024 14:31:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4ZTkjUa1qAw9ZLrLn5Cmk/KIYm4xouooLm1o+DG2vC/bIdk1gQWLiRdSLYKS8JVSoO2kgWw==
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a170907969300b00a4e17c59944mr4619522ejc.61.1711834310761;
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Message-ID: <f1e5aef5-989c-4f07-82af-9ed54cc192be@redhat.com>
Date: Sat, 30 Mar 2024 22:31:47 +0100
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 22/29] KVM: SEV: Implement gmem hook for invalidating
 private pages
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
 <20240329225835.400662-23-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-23-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On 3/29/24 23:58, Michael Roth wrote:
> +		/*
> +		 * If an unaligned PFN corresponds to a 2M region assigned as a
> +		 * large page in he RMP table, PSMASH the region into individual
> +		 * 4K RMP entries before attempting to convert a 4K sub-page.
> +		 */
> +		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
> +			rc =3D snp_rmptable_psmash(pfn);
> +			if (rc)
> +				pr_err_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx e=
rror %d\n",
> +						   pfn, rc);
> +		}

Ignoring the PSMASH failure is pretty scary...  At this point=20
.free_folio cannot fail, should the psmash part of this patch be done in=20
kvm_gmem_invalidate_begin() before kvm_mmu_unmap_gfn_range()?

Also, can you get PSMASH_FAIL_INUSE and if so what's the best way to=20
address it?  Should fallocate() return -EBUSY?

Thanks,

Paolo


X-sender: <kvm+bounces-13158-martin.weber=3Dsecunet.com@vger.kernel.org>
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
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAtaNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBJAAAAo4oAAAUABAAUIAEAAAAYAAAAbWFydGlu=
LndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwA=
BAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 16579
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:32:11 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:32:11 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id ABA5820826
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:32:11 +0100 (CET)
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
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FoJ_3Rwf84rm for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 22:32:08 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dkvm+bounce=
s-13158-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber=
@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F30CB2076B
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F30CB2076B
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B7241C20F9A
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 21:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5518E4C629;
	Sat, 30 Mar 2024 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"hu+tg7qO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBBB4AEDA
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.129.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834316; cv=3Dnone; b=3DsU96opc8Q4+vBAfWVNHlZNG/6KJ9xERcoxqnFNAnT2N=
Ir9o/5bLqm2p97E5chSL4FNgEsliAbX7YgkUDqGiJ6cm41/128EZ28k1AvaRLb/qwEAIw7Mf6lW=
H1smIoL2MRxAMOap7LUee99TXnDkZo4Q4zIToinh5Wu1OGOC7HAlc=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834316; c=3Drelaxed/simple;
	bh=3Dt1KY6wPgvCWcWD2NOTNvE0vD4k8SIvXspJg1UZfO6R0=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DI8MgwMWfkZ70ClUhNdirX7OjjzUN+ChPioz9Xi7p5D0=
HT7V6vponoVF5u+ai0TsCGc+jh9J7pv/eToum7iPl7wNC7kSnP8BdlYiJ3PzsJkFGzsAYrWr/WN=
P98b7m5XYqJPQQ7Vx87BfJvxgM52HdXU5HOpJSztf1vF3IgNRn2PE=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3Dhu+tg7qO; arc=3Dnone smtp.client-ip=3D170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834314;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3D2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=3D;
	b=3Dhu+tg7qOLER5yPfsR3AgmPc7bLp6V8ATXtv1Zy2kOfDYvOmyO1uFeEbMW3nLwdw3msibIz
	KDQnkqa58ANIRIPvcR2CTinXE+vKPKB56c4HmkWVeECAjOo7FNhi20GuLgIRIz69HCPU98
	a0RFkh9bWf++ervOXti9R6M2WshEI7o=3D
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-503-6TNAOuxjON-zT5vuK6vI4g-1; Sat, 30 Mar 2024 17:31:52 -0400
X-MC-Unique: 6TNAOuxjON-zT5vuK6vI4g-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a4747f29e19=
so79026766b.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834311; x=3D1712439111;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3D2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=3D;
        b=3DY5OCy4FiAavvhWzm1jt2rXOysXq1yK/K8Vt3yQo5VOx7dYpYv+frBWikQsiacHG=
a8z
         bSDQucFqoatbYu5kN27IMmptWehus4BEI3oxEuHugC8tGkVMESNfMqIZ3qqqmdepJ1=
1R
         WbmQBB1NH1OiT9gIecPJEhNzeIHoL2+YO/lFGTED976woyGTcwmlLJcUrNbBi2RGF6=
J5
         qiufRNEK+lTiVL+VYhSMM4NcIDeTMRUYw3c+pjJ4F8JiyTGSDav2TaYRgnnL3GyjwW=
XH
         0F15pDiPXcOhNDWNXXgFvV2Gyhm7NbrFLlDWuWQ47pQs295f0bWuZDXVUfIWcpItmh=
aV
         zAzg=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCVzbOiX7dTzeAsOI8Ee+C/gEzZaljrIZmMl53dXE=
O/4msw9BEToOX5GM0v8OVv0Zvr2kMKKqU49VBl7MEzlH61dgbg1
X-Gm-Message-State: AOJu0YzVA0bN0VHEQAH5Rrptu02KsPfLYx3l3DwPXB3Qg2RycT4Scfl=
p
	4UJ9/Dk3HxUOC8ksS8oBGieYeI52smcaYSNJPA3P3KJ+Ork1yu+RTzsEqbU2SY4cyz5pme6Fk1=
I
	7y60BaTfJpqizLBHTMjAW2CGM/W14RgzC8TL/kFZeLjVzCcu+hg=3D=3D
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a1=
70907969300b00a4e17c59944mr4619565ejc.61.1711834311183;
        Sat, 30 Mar 2024 14:31:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4ZTkjUa1qAw9ZLrLn5Cmk/KIYm4xouooLm1o+DG2vC/bId=
k1gQWLiRdSLYKS8JVSoO2kgWw=3D=3D
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a1=
70907969300b00a4e17c59944mr4619522ejc.61.1711834310761;
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id h19-20020a1709060f5300b00a4e=
30ff4cbcsm2438004ejj.194.2024.03.30.14.31.48
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Message-ID: <f1e5aef5-989c-4f07-82af-9ed54cc192be@redhat.com>
Date: Sat, 30 Mar 2024 22:31:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 22/29] KVM: SEV: Implement gmem hook for invalidati=
ng
 private pages
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
 <20240329225835.400662-23-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-23-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: kvm+bounces-13158-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:32:11.6326
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 722ff65a-3efc-43b9-14f4-08dc=
5100dc39
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.427|SMR=3D0.349(SMRDE=3D0.035|SMRC=3D0.31=
4(SMRCL=3D0.100|X-SMRCR=3D0.314))|CAT=3D0.076(CATOS=3D0.011
 (CATSM=3D0.011(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.044(CATRESLP2R=3D0.041)|CATORES=3D0.017
 (CATRS=3D0.017(CATRS-Index Routing
 Agent=3D0.016))|CATORT=3D0.001(CATRT=3D0.001(CATRT-Journal Agent=3D0.001
 )));2024-03-30T21:32:12.089Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 12886
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.030|SMR=3D0.023(SMRPI=3D0.020(SMRPI-FrontendProxyAgent=3D0.020))=
|SMS=3D0.006
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAToDAAAPAAADH4sIAAAAAAAEAIVTUYvb=
RhAe25Ltk08PTa
 Gl9CHTwKV26tjFuUJ6pQlX8LVH7lITN4FAQaytlbxE2hW7K19M6A/v
 W2dXNgTi0EWI0ezMN983M/q396fEJ9PZz9PZOc6eXPz0dIy3Yr1hvM
 BXym7wTivLL+LoGf6AH5/po099+AivM2QSa8kKkUue4uLqJa6V1txU
 SqYGrUKGs1vUPBdKIjOmiWMG2VHAgumcY8XoJSRuOL66XaBlq4KPcb
 G8vVz+gZa8ezwhqYCQqdiKtGbFUcTzFx6DS6sFN7jimdIcmbW8rKyQ
 ueO4VnLLtSWuFG3q1WNHYHIMbvqpU2Q4/K42PJmVSV2lzHJ8+BB1WS
 UF31Jfn+Hi9+Rm/mZ+k5y/GOGHI7D7o9f4KxpZJZTsNSeVKZnZDKtM
 jn75fJ5joNejzwccTqUTrnWiiWMhSmF5OnywnL+5wCsmChoLtWLf5E
 PLdkjt8mP98f1ZUbxHyifHWfq3fDD+/4LHOGRyTEqP6fknjuLoOpdK
 +7nQnPdsMqJX09SEIQnc2h2aNdO7yWSCeGkp0l0o2oY4mmSa8yRTha
 CxMimV9dljNBtVF6lHbbpKW0YjV9k+ndn1hrYDUyXd7sXRu22Z5CUv
 EyG3tN9usMmK9k4OR4ctciFlWSe1LFmV5Jmk1sqcD0fPnZLLwqixI4
 E7VWPO7V5OcnV5fZNcv3y9nNPfk7rxGYV3G2a/N57fihuLd2xH84gj
 lqb0OxkU9jnishGRsaJQayJEVKgftZb4eP7b6+VbX/evDZPvzNiZC6
 YK5Yw4AmhDp9WCXvNAmz7brU4IEEKvB/0AwhCmzgmdE4g6EAzg1KX4
 yC70+nDiP78KoUvBTSSFUTrdkkFv8kdwv/ETJnkiGNAn2Q0O5fchCG
 DchpDsGAIPHpF94qD67RYMgFh12w7HxXwJAZX2JchD8WcUc8+XGEDc
 gZCuGoaeTJfeHQ/bcKO6LXjacYS/JZyGJ/FpUkKIyPDa+0ELImd0vZ
 Dux6IOMd3GIBpE7BsnhPQOQq+UPF/70g2HEE6DAxmH04IvPFRz23Sv
 KUFO7wk8KyfnBE670CduXQL/D6xoQUG0BQAAAQKhAzw/eG1sIHZlcn
 Npb249IjEuMCIgZW5jb2Rpbmc9InV0Zi0xNiI/Pg0KPFRhc2tTZXQ+
 DQogIDxWZXJzaW9uPjE1LjAuMC4wPC9WZXJzaW9uPg0KICA8VGFza3
 M+DQogICAgPFRhc2sgU3RhcnRJbmRleD0iODc1Ij4NCiAgICAgIDxU
 YXNrU3RyaW5nPkFsc28sIGNhbiB5b3UgZ2V0IFBTTUFTSF9GQUlMX0
 lOVVNFIGFuZCBpZiBzbyB3aGF0J3MgdGhlIGJlc3Qgd2F5IHRvPC9U
 YXNrU3RyaW5nPg0KICAgICAgPEFzc2lnbmVlcz4NCiAgICAgICAgPE
 VtYWlsVXNlciBJZD0ibWljaGFlbC5yb3RoQGFtZC5jb20iPk1pY2hh
 ZWwgUm90aDwvRW1haWxVc2VyPg0KICAgICAgICA8RW1haWxVc2VyIE
 lkPSJrdm1Admdlci5rZXJuZWwub3JnIiAvPg0KICAgICAgPC9Bc3Np
 Z25lZXM+DQogICAgPC9UYXNrPg0KICA8L1Rhc2tzPg0KPC9UYXNrU2
 V0PgEOzgFSZXRyaWV2ZXJPcGVyYXRvciwxMCwxO1JldHJpZXZlck9w
 ZXJhdG9yLDExLDE7UG9zdERvY1BhcnNlck9wZXJhdG9yLDEwLDA7UG
 9zdERvY1BhcnNlck9wZXJhdG9yLDExLDA7UG9zdFdvcmRCcmVha2Vy
 RGlhZ25vc3RpY09wZXJhdG9yLDEwLDA7UG9zdFdvcmRCcmVha2VyRG
 lhZ25vc3RpY09wZXJhdG9yLDExLDA7VHJhbnNwb3J0V3JpdGVyUHJv ZHVjZXIsMjAsOQ=3D=
=3D
X-MS-Exchange-Forest-IndexAgent: 1 1468
X-MS-Exchange-Forest-EmailMessageHash: 6630D56E
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> +		/*
> +		 * If an unaligned PFN corresponds to a 2M region assigned as a
> +		 * large page in he RMP table, PSMASH the region into individual
> +		 * 4K RMP entries before attempting to convert a 4K sub-page.
> +		 */
> +		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
> +			rc =3D snp_rmptable_psmash(pfn);
> +			if (rc)
> +				pr_err_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx e=
rror %d\n",
> +						   pfn, rc);
> +		}

Ignoring the PSMASH failure is pretty scary...  At this point=20
.free_folio cannot fail, should the psmash part of this patch be done in=20
kvm_gmem_invalidate_begin() before kvm_mmu_unmap_gfn_range()?

Also, can you get PSMASH_FAIL_INUSE and if so what's the best way to=20
address it?  Should fallocate() return -EBUSY?

Thanks,

Paolo


X-sender: <linux-kernel+bounces-125893-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAuKNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBKAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 16804
Received: from cas-essen-01.secunet.de (10.53.40.201) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:32:18 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:32:18 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id 02EAF202BE
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:32:19 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.451
X-Spam-Level:
X-Spam-Status: No, score=3D-2.451 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIM_INVALID=3D0.1, DKIM_SIGNED=3D0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dfail (1024-bit key) reason=3D"fail (body has been altered)"
	header.d=3Dredhat.com
Received: from b.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VM6my3QVLpwD for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:32:18 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-kern=
el+bounces-125893-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 489042025D
Authentication-Results: b.mx.secunet.com;
	dkim=3Dfail reason=3D"signature verification failed" (1024-bit key) header=
.d=3Dredhat.com header.i=3D@redhat.com header.b=3D"hu+tg7qO"
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id 489042025D
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44DFE1C2197B
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F474F5FD;
	Sat, 30 Mar 2024 21:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dfail reason=3D"signature verification failed" (1024-bit key) header=
.d=3Dredhat.com header.i=3D@redhat.com header.b=3D"hu+tg7qO"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111914AEEB
	for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 21:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834316; cv=3Dnone; b=3DG3p9CFPbVp0VXEUyZo5IiFi5SvOwdcKSSeI0rtbFQNk=
oB+H4Lu3KvEkRdXm9U30awfGzsTln2UtOiaS40ZDVpyEXthZtvIDMB+1gw/P5sETJQCN6G9gVT2=
Nt7JOv7869fDeFJemWtQr8L1Pf3q6kBOWt9icCpBDng32iJK5XDWQ=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834316; c=3Drelaxed/simple;
	bh=3Dt1KY6wPgvCWcWD2NOTNvE0vD4k8SIvXspJg1UZfO6R0=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DI8MgwMWfkZ70ClUhNdirX7OjjzUN+ChPioz9Xi7p5D0=
HT7V6vponoVF5u+ai0TsCGc+jh9J7pv/eToum7iPl7wNC7kSnP8BdlYiJ3PzsJkFGzsAYrWr/WN=
P98b7m5XYqJPQQ7Vx87BfJvxgM52HdXU5HOpJSztf1vF3IgNRn2PE=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3Dhu+tg7qO; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834314;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3D2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=3D;
	b=3Dhu+tg7qOLER5yPfsR3AgmPc7bLp6V8ATXtv1Zy2kOfDYvOmyO1uFeEbMW3nLwdw3msibIz
	KDQnkqa58ANIRIPvcR2CTinXE+vKPKB56c4HmkWVeECAjOo7FNhi20GuLgIRIz69HCPU98
	a0RFkh9bWf++ervOXti9R6M2WshEI7o=3D
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-204-NA3hJCigMBWwPeo_eVOzUA-1; Sat, 30 Mar 2024 17:31:52 -0400
X-MC-Unique: NA3hJCigMBWwPeo_eVOzUA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a4d8e5d6722=
so203217466b.0
        for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 14:31:52 -0700=
 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834311; x=3D1712439111;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3D2Lxl+j+xR8FWVtx6+a/UxVWMhMmDhnJi8YYlIddCdSo=3D;
        b=3DtHRjme0u2zj3uWrus62Z6fRXMGH2qcZQPiMn9WKvqlO1NiYDdogCuP24Vy99Nec=
d/C
         g7gBmGq2QAVJDMAwSqoHCU3gLGe7ErZXpCUQPgAv3eL0aXOIlO/dxiPyRO3YLo4HeY=
EP
         H1FY58vY5LggCO8xmfdOPCr3w+PRtbtRMn3CAjn20MpCIeSfydKl4Mflurgia7Fuyp=
gF
         Gtdz/0d8opx72ytMR22gQ/voi/nNIkdU3yFGduLXO6yOJ0xnPTAbVb41ylRhHEepbR=
Qo
         PFBIiUvdXD/WcfVUOX7h/qq6CVSru+0Pk15A06/14uQ0K59YJ2UbnVRoYhpBIY9QeK=
+1
         SiLw=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCVQFM5SCn27EibMN2Wrv/PPQb6bxkdMKDXxlUF7N=
WOJWiCq0MZoYAMtUVnw0diUUXiZ8zAfRL0OSkb6jhELvBT+1cEMJfSwcveqkGCh
X-Gm-Message-State: AOJu0YxbkEJnkO5uWcml1P7bc0JhQpH4d+lReMqe6814CJGKbWpYXoK=
T
	E2rrzFYk7S3qY5ZpWLM2NKASLks2oF5TQfAZw5HMgQraxMeeRbqVYr0meWBvF+2OP4qsYyW7AK=
4
	n4LSkeN6RE4jNgiwOvZU6Qd27cSBsWIWNR7MH4p7GDTSZ0HBv2Djy1HJIxnWSxA=3D=3D
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a1=
70907969300b00a4e17c59944mr4619535ejc.61.1711834311163;
        Sat, 30 Mar 2024 14:31:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4ZTkjUa1qAw9ZLrLn5Cmk/KIYm4xouooLm1o+DG2vC/bId=
k1gQWLiRdSLYKS8JVSoO2kgWw=3D=3D
X-Received: by 2002:a17:907:9693:b0:a4e:17c5:9944 with SMTP id hd19-20020a1=
70907969300b00a4e17c59944mr4619522ejc.61.1711834310761;
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id h19-20020a1709060f5300b00a4e=
30ff4cbcsm2438004ejj.194.2024.03.30.14.31.48
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:31:50 -0700 (PDT)
Message-ID: <f1e5aef5-989c-4f07-82af-9ed54cc192be@redhat.com>
Date: Sat, 30 Mar 2024 22:31:47 +0100
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 22/29] KVM: SEV: Implement gmem hook for invalidati=
ng
 private pages
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
 <20240329225835.400662-23-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-23-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-kernel+bounces-125893-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:32:18.9908
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: c1a4f654-0254-416d-b384-08dc=
5100e09b
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.201
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-01.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.415|SMR=3D0.343(SMRDE=3D0.035|SMRC=3D0.30=
7(SMRCL=3D0.101|X-SMRCR=3D0.308))|CAT=3D0.071(CATOS=3D0.011
 (CATSM=3D0.011(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.040(CATRESLP2R=3D0.038)|CATORES=3D0.017
 (CATRS=3D0.017(CATRS-Index Routing Agent=3D0.016)));2024-03-30T21:32:19.39=
7Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-01.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 13185
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-01.secunet.de:TO=
TAL-FE=3D0.021|SMR=3D0.022(SMRPI=3D0.020(SMRPI-FrontendProxyAgent=3D0.020))
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AATkDAAAPAAADH4sIAAAAAAAEAIVTUYvb=
RhAe25Lsk08Pba
 Gl9KHTwKV26pyLc4X0ShOu4GuP3KUmbgKFglhbK3mJtCt2V76Y0v/d
 x86ubAjEoYsQo9mZb75vZvRv/3eJT6azH6ezC5w9ufzh6QTvxHrDeI
 mvlN3gvVaWXybxM/wO3z/TRx/68BHe5MgkNpKVopA8w8X1S1wrrbmp
 lcwMWoUMZ3eoeSGURGZMG8cMsqOAJdMFx5rRS0jccHx1t0DLViWf4G
 J5d7X8DS1593hCUgEhM7EVWcPKo4gXLzwGl1YLbnDFc6U5Mmt5VVsh
 C8dxreSWa0tcKdo0q8eOwPkxuOmHTpHj6JvG8HRWpU2dMcvx4UPUVZ
 2WfEt9fYaLX9Pb+Zv5bXrxYox/H4HdH73Gn9HIOqVkrzmtTcXMZlTn
 cvzTx/McA70efzzgcGqdcq1TTRxLUQnLs9GD5fzNJV4zUdJYqBX7Jh
 9atkNqlx/r9+/OyvIdUj45zrK/5IPJ/xc8xiGXE1J6TM8/SZzEN4VU
 2s+F5rxnkxO9hqYmDEng1u7QrJnenZ+fI15ZinQXirYhiXPNeZqrUt
 BUmZTK+uQJmo1qysyDtk2lJaOJq3yfzex6Q8uBmZJu9ZL47bZKi4pX
 qZBbWm8313RFaydH48MSuZCqatJGVqxOi1xSZ2XBR+PnTshVadTEkc
 CdarDgdq8mvb66uU1vXr5ezunnydz0jML7DbPfGs9vxY3Fe7ajcSQx
 yzL6mwwK+xxx2YrIWVmqNREiKtSORkt8PP/l9fJPX/ePDZNvzcSZC6
 ZK5YwkBuhCr9OBfvtAlz67nV4IEEK/D4MAwhCmzgm9E4h7EAzh1KX4
 yAj6Azjxn5+HEFFwG0lhlE63ZNCb/DF83foJkzwxDOmT7BaH8gcQBD
 DpQkh2AoEHj8k+cVCDbgeGQKyirsNxMZ9BQKV9CfJQ/BnFfOpLDCHp
 QUhXLUNPJqJ3z8O23KhuB572HOGvCKflSXzalBBiMrz2ftCB2BmRFx
 K9L+oQE7UG0SBiXzohpHcYeqXk+cKXbjmEcBocyDicDnziodrbtntt
 CXJ6T+BZOTkncBrBgLhFBP4fK2bKarMFAAABAqEDPD94bWwgdmVyc2
 lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTE2Ij8+DQo8VGFza1NldD4N
 CiAgPFZlcnNpb24+MTUuMC4wLjA8L1ZlcnNpb24+DQogIDxUYXNrcz
 4NCiAgICA8VGFzayBTdGFydEluZGV4PSI4NzQiPg0KICAgICAgPFRh
 c2tTdHJpbmc+QWxzbywgY2FuIHlvdSBnZXQgUFNNQVNIX0ZBSUxfSU
 5VU0UgYW5kIGlmIHNvIHdoYXQncyB0aGUgYmVzdCB3YXkgdG88L1Rh
 c2tTdHJpbmc+DQogICAgICA8QXNzaWduZWVzPg0KICAgICAgICA8RW
 1haWxVc2VyIElkPSJtaWNoYWVsLnJvdGhAYW1kLmNvbSI+TWljaGFl
 bCBSb3RoPC9FbWFpbFVzZXI+DQogICAgICAgIDxFbWFpbFVzZXIgSW
 Q9Imt2bUB2Z2VyLmtlcm5lbC5vcmciIC8+DQogICAgICA8L0Fzc2ln
 bmVlcz4NCiAgICA8L1Rhc2s+DQogIDwvVGFza3M+DQo8L1Rhc2tTZX
 Q+AQ7OAVJldHJpZXZlck9wZXJhdG9yLDEwLDA7UmV0cmlldmVyT3Bl
 cmF0b3IsMTEsMTtQb3N0RG9jUGFyc2VyT3BlcmF0b3IsMTAsMDtQb3
 N0RG9jUGFyc2VyT3BlcmF0b3IsMTEsMDtQb3N0V29yZEJyZWFrZXJE
 aWFnbm9zdGljT3BlcmF0b3IsMTAsMDtQb3N0V29yZEJyZWFrZXJEaW
 Fnbm9zdGljT3BlcmF0b3IsMTEsMDtUcmFuc3BvcnRXcml0ZXJQcm9k dWNlciwyMCw5
X-MS-Exchange-Forest-IndexAgent: 1 1467
X-MS-Exchange-Forest-EmailMessageHash: BFA14E5E
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> +		/*
> +		 * If an unaligned PFN corresponds to a 2M region assigned as a
> +		 * large page in he RMP table, PSMASH the region into individual
> +		 * 4K RMP entries before attempting to convert a 4K sub-page.
> +		 */
> +		if (!use_2m_update && rmp_level > PG_LEVEL_4K) {
> +			rc =3D snp_rmptable_psmash(pfn);
> +			if (rc)
> +				pr_err_ratelimited("SEV: Failed to PSMASH RMP entry for PFN 0x%llx e=
rror %d\n",
> +						   pfn, rc);
> +		}

Ignoring the PSMASH failure is pretty scary...  At this point=20
free_folio cannot fail, should the psmash part of this patch be done in=20
kvm_gmem_invalidate_begin() before kvm_mmu_unmap_gfn_range()?

Also, can you get PSMASH_FAIL_INUSE and if so what's the best way to=20
address it?  Should fallocate() return -EBUSY?

Thanks,

Paolo



