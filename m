Return-Path: <kvm+bounces-13211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F3B89337B
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CFFE285BDF
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939C71474C9;
	Sun, 31 Mar 2024 16:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MRx/CD3R"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92509145B00;
	Sun, 31 Mar 2024 16:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711902980; cv=fail; b=hey1UsCwkK4aGcYuh7z6yQCQlYMx7HTeENEbo+2wGJYXyZS8B3TVYIA8pLTkrjWrrzs6fwBnQrBPPgNDJJQ9l2coc9tIvr92y5SyGXI87Lf9Odq7NGXzXB94XkNm3WpoE/gwvjdhZkE/nOHTZUGQrjeoHnXz+dbimes/9wD2xP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711902980; c=relaxed/simple;
	bh=EIe0N6lgclsCpYQlet0Nx534YaNmb6Q4hlnl8S3XcYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h6QE12LIRTam02KHwX20nonl1NmO/8lGkGfpKZIOO8zSsWn8nFRJCnrrNKkgVv7FyvPw4grMP/VNOue4hkV9CSRyVMQgsDlcIehL42LSfWnuMH8klD/9CqfNep+BInxU6eNv3XwthFUqr66LsTk+EuTXIDJ0BnANako5IiTb8MM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MRx/CD3R reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 26DB62083B;
	Sun, 31 Mar 2024 18:36:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zbyHfkoTqxuO; Sun, 31 Mar 2024 18:36:13 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 196B3207E4;
	Sun, 31 Mar 2024 18:36:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 196B3207E4
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 363C7800057;
	Sun, 31 Mar 2024 18:28:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:28:15 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:54 +0000
X-sender: <kvm+bounces-13161-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAJuYHy0vkvxLoOu7fW2WcxcPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQALABcAvgAAALMpUnVJ4+pPsL47FHo+lvtDTj1EQjIsQ049RGF0YWJhc2VzLENOPUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpLENOPUFkbWluaXN0cmF0aXZlIEdyb3VwcyxDTj1zZWN1bmV0LENOPU1pY3Jvc29mdCBFeGNoYW5nZSxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAA4AEQBACf3SYEkDT461FZzDv+B7BQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUAPAACAAAPADYAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0Lk1haWxSZWNpcGllbnQuRGlzcGxheU5hbWUPAA0AAABXZWJlciwgTWFydGluBQAMAAIAAAUAbAACAAAFAFgAFwBGAAAAm5gfLS+S/Eug67t9bZZzF0NOPVdlYmVyIE1hcnRpbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAtaNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBfAAAAo4oAAAUABAAUIAEAAAAYAAAAbWFydGluLndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 18899
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=kvm+bounces-13161-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com B62662025D
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MRx/CD3R"
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711834555; cv=none; b=NFBu/I9xJ8Doue7CNIp8fxaoBS/TEnqDRBkNzN7ZjeqbSDHd62vgt4weIA0gLJo402NwwBtnuXC2bFrXP2I4/dApMGJwe8igKVYkDi6KUYicX5GopfO49tObmdWs7onIMEtgZxxbKnb8b3t5fDpo4NlM8ApuAwi1TfmB6D/g6AA=
ARC-Message-Signature: i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711834555; c=relaxed/simple;
	bh=XGP/bsxmN4UA90jlZmkSiIF6HI+T7qPBdxxu9QCdFjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQJNUPdl911ro1yb7TlzorshCQNK4X5+WQGrQsOmVp3RJepBxyadPMMiiHIPz9P+UgzOAfAN+AYkmsl9NjX3wl4eRfGTRHNqV7T6G3S6lkjmcgDSM1gjv0FjbA1VkegPZVFnirjF/oUmLhi+ksAJCg9tAX49CPkooIRsT2oJ1lA=
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MRx/CD3R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711834552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=;
	b=MRx/CD3RC0fPDEpIr7khRXv6XN2nIUaTA/kw/iz29kNjYIQSnenBvKmEVSkxth6+d8IbT2
	qaEmk1SRpbjldIqAw+NyJQRrh7gGshx7OIX0v7W/gNFZRBn6JGnF9mC20r0JnK28c5q7+N
	JxqQQoX6b7yqgfuWZKp4JdIbT/1hATU=
X-MC-Unique: 9uxihBKrM-Ok0RCwxwkpcg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711834548; x=1712439348;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=;
        b=ab/z4r8rJuUlX3bvZmLx6GUUx4/fMVhnfXb1f0sG7rBX/vz6KwIoxjOHkzYZzfqFEU
         wBeXV2KyamIzbbsg4pWEbbcAcfyTacu0Fm1zqXkYNGe0rMHp/AtpN4EFMDwe/wG444J+
         99RKddoHeyvtm2a9aDG5J5q2lGsLayKOcViIr6dGzCZRd24zWF6+IOQD/zuR6Xci1uh/
         QQEembmi6VgdCObN9nkl6WbXEIhi8Vf62Jn2Zgv3THjNqNBFhaWejNjOEQBK40VR4G7u
         z4/PUjvIkcZyV0IjAQwCOkBdFxJ3vTzI3RQtmQTbGlbeqvitgz79+ojrbBops8+kTpde
         hAQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVe0DuonStGCvjgjicN+N4be9GWRkUnGqTPwagr1ZSDjapU5BMVYtKNRpvHMcLOaSPe6OXSidLT8VLKaeZSCQwOzMZ2
X-Gm-Message-State: AOJu0YylIF4mXYPvc9nausCsTqcU94tqhjI2emc5HShZbMdHxiPyYqje
	YETJqow21KtczuC+Nu+OZ1M4+6Oap/m6uLsdUdyvcl3aUbStaG4n8dE9/t5Nu4+iBPsK2C83WNR
	eKh+rV27lHJi/ZoWw2AGEKvIYoD7bg9cRC3RIisGqenwoGYy94MELHBuhOw==
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac24256000000b00515a5b11dd0mr3175166lfl.55.1711834548601;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtpVK74hYMJQRsbSNAOxNo0vPDNEDLKCnR39FTY23/i2sK1bKLUmtvrUTSb2GUD2WssCJO3g==
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac24256000000b00515a5b11dd0mr3175156lfl.55.1711834548253;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
Message-ID: <abbe9937-7e0f-4fbd-be0b-488de07dd56c@redhat.com>
Date: Sat, 30 Mar 2024 22:35:44 +0100
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 25/29] KVM: SVM: Add module parameter to enable the
 SEV-SNP
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-26-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-26-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On 3/29/24 23:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>=20
> Add a module parameter than can be used to enable or disable the SEV-SNP
> feature. Now that KVM contains the support for the SNP set the GHCB
> hypervisor feature flag to indicate that SNP is supported.
>=20
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3e8de7cb3c89..658116537f3f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -48,7 +48,8 @@ static bool sev_es_enabled =3D true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  =20
>   /* enable/disable SEV-SNP support */
> -static bool sev_snp_enabled;
> +static bool sev_snp_enabled =3D true;
> +module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>  =20
>   /* enable/disable SEV-ES DebugSwap support */
>   static bool sev_es_debug_swap_enabled =3D true;


X-sender: <linux-kernel+bounces-125897-steffen.klassert=3Dsecunet.com@vger.=
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
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAtaNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBgAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 18849
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:36:33 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:36:32 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 0DD0C2076B
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:36:33 +0100 (CET)
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
	with ESMTP id Llvtz-F6YAUT for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:36:32 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.199.223; helo=3Dny.mirrors.kernel.org; envelope-from=3Dlinux-kern=
el+bounces-125897-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 56C4D20185
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223=
])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 56C4D20185
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BB441C21934
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A3C53E1A;
	Sat, 30 Mar 2024 21:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"FE2gpGrp"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02684E1D5
	for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 21:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834554; cv=3Dnone; b=3Db7FLHTh4s5KJyGT/U4EW3C8rUKvo/8XbW15xZoW/Ldj=
2ZB8F8CXR9RWx0TCo/a98NqmsgnvLyRO7h1Q+ND/K5AkfFYKtNN8lnH9S/HOGTR8dIJ+Y19DfOR=
rgncGvyXDsbD1yRzrgW6lNzkQZGIYg3Wge86P7hO76kHvxfnPeNF4=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834554; c=3Drelaxed/simple;
	bh=3DXGP/bsxmN4UA90jlZmkSiIF6HI+T7qPBdxxu9QCdFjI=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DuZvh3XkJIn35qzaxDGIlHNhGzRYSCjqfwQz9k78Cz5x=
4mG0aLHBAolrCiB7Ze9uRoohtZPKvgup+SgEcbrEsrmbsyZ80+rn4kDeCRHbiIvapx4UliYLo6P=
wJvOaTOtzrbKuROkk6/cjzopwOfYjQBGYlOabniJ2QgL1qeXhasBk=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DFE2gpGrp; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834551;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DR/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=3D;
	b=3DFE2gpGrpWlnRIpXbWfocTT4UIYFVk24/FqG5zZimf7CIdtAnU/kIbb074rzBV4VNQquOeb
	eTN3MbKMOVPS2ppvxfoagxAufdAKFn0UfYxkHQz7N30hayElSK0pLcXCFJKreU8cT+hWW4
	70pBRDiWqHLwO0MhAJS60JlSC8hhBTE=3D
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-66-mkNfF_eMO-6IX7-uTbmq-g-1; Sat, 30 Mar 2024 17:35:50 -0400
X-MC-Unique: mkNfF_eMO-6IX7-uTbmq-g-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-515c1948e73=
so2306242e87.3
        for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 14:35:49 -0700=
 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834548; x=3D1712439348;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DR/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=3D;
        b=3DXibPL1YT7C7WAHy76R2BNffFmAKXq7tS4GkdU7jlYD5NyTyafk9PfACl7Hn3jFg=
Rov
         Eu/Gt2HDNLI1zhBxauFdOJw7qdJ+IhtQgAHjQCWEP4FfItR4A0ph6qTBh0bsFO8nQC=
Lh
         boJk/wP5IrediBxEvZ0p1MP7BPe6STjykG10jomz1zS84ULjUkvmbBB9W8ArJOkYm2=
dS
         wepwoevgsr34g16XRpAOviKeYv1JLIMYPU9o4eCgg4n5L/jaI4to02XXlNF4HT1OGQ=
05
         HNsIgkbEuVI+EyqHiRqeWEmmIy86zclP6cdw6skT9jNOEGwogsGgay2cb6hTap+qh0=
aO
         Lkug=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCUpZGruGvtSL/GRzzb/T9l9NEdlyPXCEPSxQp58g=
fVW2yTXYs3Fm0An24hPuTNlnIRLdQSrQRaCzpAWGinXnitsZhYQjW/v+HJXwwK6
X-Gm-Message-State: AOJu0YxhKpBvOwa3o7UuzohVTOgan1vevOaRV+MzsvuUCnNUnrNpe/u=
C
	D+q4iEuOd+EUyRD/EL7daw1o5qU2e2uGqU0A8JAf1JdH8jH52FlXFRnaLRT8uxrZd+Ksr2BjQa=
X
	NmIKeRvlwGdfC2KaqNeLkTxAV6qmMXN9Ht8GHDfyLF4uXW/q6WkeV5IFucCL/qA=3D=3D
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac242=
56000000b00515a5b11dd0mr3175194lfl.55.1711834548712;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtpVK74hYMJQRsbSNAOxNo0vPDNEDLKCnR39FTY23/i2sK1=
bKLUmtvrUTSb2GUD2WssCJO3g=3D=3D
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac242=
56000000b00515a5b11dd0mr3175156lfl.55.1711834548253;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id os26-20020a170906af7a00b00a4=
65b72a1f3sm3494452ejb.85.2024.03.30.14.35.45
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:35:47 -0700 (PDT)
Message-ID: <abbe9937-7e0f-4fbd-be0b-488de07dd56c@redhat.com>
Date: Sat, 30 Mar 2024 22:35:44 +0100
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 25/29] KVM: SVM: Add module parameter to enable the
 SEV-SNP
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-26-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-26-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-kernel+bounces-125897-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:36:32.9947
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: c85bfe61-624d-4800-c8ac-08dc=
51017801
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.419|SMR=3D0.341(SMRDE=3D0.035|SMRC=3D0.30=
5(SMRCL=3D0.102|X-SMRCR=3D0.306))|CAT=3D0.077(CATOS=3D0.011
 (CATSM=3D0.011(CATSM-Malware
 Agent=3D0.010))|CATRESL=3D0.041(CATRESLP2R=3D0.037)|CATORES=3D0.023
 (CATRS=3D0.023(CATRS-Index Routing Agent=3D0.022)));2024-03-30T21:36:33.46=
4Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 13311
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.050|SMR=3D0.008(SMRPI=3D0.005(SMRPI-FrontendProxyAgent=3D0.005))=
|SMS=3D0.042
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAVUDAAAPAAADH4sIAAAAAAAEAJVS33Pa=
RhDew0IgCHbqpA
 9920c7AmQbbBPH9Thu03YmE9cTZvLKHLoTugZ0jE7gJNM/u39A9ySZ
 UoIz7SAdu6vv+/bH7V/13xPsBScvg5M+nvQuTgdtfKfCmMspvtdZjP
 epzuRFq3GFv6R6doE3qfpDmhiHKpnEeDku3K6x7jWfiW6oZ1cEt4zX
 QiDHmRaLqcQ5T/lMZjLFLOYJhvSOJS6MFJhplAkfE0inKJTJzSyWOH
 zzoTO8vbNakeTZIpVdvNX3ViHDtx/eYaiTjKvE5GizmM91mmGk04J9
 e4dGZrn9628/3ViZ+PNcpktlCFIqYjTlE1uCSoQKeSYLdUtW5kFTim
 7Z01BNEik6Ooo648//fRybvNcmVkR7y6cpx0uee92P1ltjtRrv5VLJ
 e+JZzh3XU403OvmiEoWX83FhXadSUMUrzhV2Oh37h8jTMA4+Dc6Cj8
 tZYOwrl90Q/8Qe+n6JOcZI0bjpypOJFG08oUEYmWZKJ+bAP2wTQMip
 tP5B57CcglBRRGkmKkMePJJl/MgHy6dZy0/YkwMhz8NxLxy87HbPTg
 fHx2envfOoF+Hx0dFZv18282gO+933/W+mur7GTn/QPkefzoF1TcYz
 RfVpPaX9WI6kGRXrJ/BHzNKFfFVMpljcUb64o4SWVxwU8PYGrZ1rtf
 Go3+8fvipHhBi8KNc6eNjpcp9Xm/oiyDvcLMgk8wfpvBT/G4D1kv1H
 KiZ4e5P3v2p+M8Sf5XgxGd7z+UbxuG2cwoJHhtBfl2l/ABXYYQxqxQ
 MVcitspwpQhVoN6g5Uq9BwwCXbRhh8bw13B5wdaNLJoOJCzbOYKrlE
 J4NOCtJJLIu0yoQnQY/cAlnP7RKw9jhQb0CzSE0KBFspe/Cdy6AFtd
 x1tpVUXwdQDQSgyHNrlIA6gyZ49LVqm/LIfQaeaynPikSrhzHqDhhr
 2hMq9LXGvMJusL3CqMO+k6crAP+iQ2VbkObpPoHdJ6zlAriwuw3jbQ
 kyGhRdVVFS5R8bqlS8BTPYzadUs3fRpK73865t44wS2YGsYTyHuQ6A
 A/tuftEPd0RT3VsJ7pWR1lcRStHYSJHT1zFbUrjlPTZq8HSl+UMeJB
 E7YVL+GzbhDKYKBwAAAQq1Azw/eG1sIHZlcnNpb249IjEuMCIgZW5j
 b2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWlsU2V0Pg0KICA8VmVyc2lvbj
 4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPEVtYWlscz4NCiAgICA8RW1h
 aWwgU3RhcnRJbmRleD0iNjIiPg0KICAgICAgPEVtYWlsU3RyaW5nPm
 JyaWplc2guc2luZ2hAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAg
 PC9FbWFpbD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMzg4Ij4NCi
 AgICAgIDxFbWFpbFN0cmluZz5hc2hpc2gua2FscmFAYW1kLmNvbTwv
 RW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgICA8RW1haWwgU3
 RhcnRJbmRleD0iNDQxIiBQb3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAg
 ICAgIDxFbWFpbFN0cmluZz5wYm9uemluaUByZWRoYXQuY29tPC9FbW
 FpbFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICA8L0VtYWlscz4NCjwv
 RW1haWxTZXQ+AQyWCjw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbm
 c9InV0Zi0xNiI/Pg0KPENvbnRhY3RTZXQ+DQogIDxWZXJzaW9uPjE1
 LjAuMC4wPC9WZXJzaW9uPg0KICA8Q29udGFjdHM+DQogICAgPENvbn
 RhY3QgU3RhcnRJbmRleD0iMzE4Ij4NCiAgICAgIDxQZXJzb24gU3Rh
 cnRJbmRleD0iMzE4Ij4NCiAgICAgICAgPFBlcnNvblN0cmluZz5Ccm
 lqZXNoIFNpbmdoPC9QZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNv
 bj4NCiAgICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydE
 luZGV4PSIzMzMiPg0KICAgICAgICAgIDxFbWFpbFN0cmluZz5icmlq
 ZXNoLnNpbmdoQGFtZC5jb208L0VtYWlsU3RyaW5nPg0KICAgICAgIC
 A8L0VtYWlsPg0KICAgICAgPC9FbWFpbHM+DQogICAgICA8Q29udGFj
 dFN0cmluZz5CcmlqZXNoIFNpbmdoICZsdDticmlqZXNoLnNpbmdoQG
 FtZC5jb208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0K
 ICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjM3NCI+DQogICAgICA8UG
 Vyc29uIFN0YXJ0SW5kZXg9IjM3NCI+DQogICAgICAgIDxQZXJzb25T
 dHJpbmc+QXNoaXNoIEthbHJhPC9QZXJzb25TdHJpbmc+DQogICAgIC
 A8L1BlcnNvbj4NCiAgICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFp
 bCBTdGFydEluZGV4PSIzODgiPg0KICAgICAgICAgIDxFbWFpbFN0cm
 luZz5hc2hpc2gua2FscmFAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQog
 ICAgICAgIDwvRW1haWw+DQogICAgICA8L0VtYWlscz4NCiAgICAgID
 xDb250YWN0U3RyaW5nPkFzaGlzaCBLYWxyYSAmbHQ7YXNoaXNoLmth
 bHJhQGFtZC5jb208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YW
 N0Pg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjQyNiIgUG9zaXRp
 b249IlNpZ25hdHVyZSI+DQogICAgICA8UGVyc29uIFN0YXJ0SW5kZX
 g9IjQyNiIgUG9zaXRpb249IlNpZ25hdHVyZSI+DQogICAgICAgIDxQ
 ZXJzb25TdHJpbmc+UGFvbG8gQm9uemluaTwvUGVyc29uU3RyaW5nPg
 0KICAgICAgPC9QZXJzb24+DQogICAgICA8RW1haWxzPg0KICAgICAg
 ICA8RW1haWwgU3RhcnRJbmRleD0iNDQxIiBQb3NpdGlvbj0iU2lnbm
 F0dXJlIj4NCiAgICAgICAgICA8RW1haWxTdHJpbmc+cGJvbnppbmlA
 cmVkaGF0LmNvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1haW
 w+DQogICAgICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW5n
 PlBhb2xvIEJvbnppbmkgJmx0O3Bib256aW5pQHJlZGhhdC5jb208L0
 NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0KICA8L0NvbnRh
 Y3RzPg0KPC9Db250YWN0U2V0PgEOzwFSZXRyaWV2ZXJPcGVyYXRvci
 wxMCwxO1JldHJpZXZlck9wZXJhdG9yLDExLDE7UG9zdERvY1BhcnNl
 ck9wZXJhdG9yLDEwLDA7UG9zdERvY1BhcnNlck9wZXJhdG9yLDExLD
 A7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEwLDA7
 UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDExLDA7VH
 JhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMTM=3D
X-MS-Exchange-Forest-IndexAgent: 1 2822
X-MS-Exchange-Forest-EmailMessageHash: 605501D6
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>=20
> Add a module parameter than can be used to enable or disable the SEV-SNP
> feature. Now that KVM contains the support for the SNP set the GHCB
> hypervisor feature flag to indicate that SNP is supported.
>=20
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3e8de7cb3c89..658116537f3f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -48,7 +48,8 @@ static bool sev_es_enabled =3D true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  =20
>   /* enable/disable SEV-SNP support */
> -static bool sev_snp_enabled;
> +static bool sev_snp_enabled =3D true;
> +module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>  =20
>   /* enable/disable SEV-ES DebugSwap support */
>   static bool sev_es_debug_swap_enabled =3D true;


X-sender: <linux-crypto+bounces-3137-steffen.klassert=3Dsecunet.com@vger.ke=
rnel.org>
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
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAtaNAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgBhAAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 18895
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:36:37 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:36:37 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 7795A2076B
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:36:37 +0100 (CET)
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
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G6SLbWf-sN4u for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:36:35 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dlinux-crypt=
o+bounces-3137-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=3Ds=
teffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 2659620185
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 2659620185
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8BD91F20F1A
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3294AEFE;
	Sat, 30 Mar 2024 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"edzURYOC"
X-Original-To: linux-crypto@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADED553E01
	for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 21:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711834558; cv=3Dnone; b=3DmK2jizNfxG9VHmSSZBvZOv6QjGjIeAngFOyDRTkyJ3L=
eaz1Va1dAbod4TVAy8YdKzqURe3upvRp/RMesFhGI5gXIpfKCSSNo8snDxEt7kzgOUTicq56K3g=
HtQPq1mV38G3+g1BzJI/gEiXZTKWbXP7+8PzqIcxtUd8yhroN1bog=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711834558; c=3Drelaxed/simple;
	bh=3DXGP/bsxmN4UA90jlZmkSiIF6HI+T7qPBdxxu9QCdFjI=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DZsHILqnU7JxzV7lD0u1g/5u8/S9mtmJ4pDD8qQlRIiI=
Q59As4x/pd2/KIU1fOubJj7jw6QUoJUrcgoFDuhx2TNyUrYeK0iLbQrUaX4VMx7ydR+evg+OL+d=
bopuaG6//RUXyWtVc2BlSOMnb3Iqu+Khs5YkBpuJsqxpN+WmVTHA4=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DedzURYOC; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711834553;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DR/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=3D;
	b=3DedzURYOCFJVuOxIxSh1ksZBAL0UGPu7VXOXMLyCPfPp4rTQGswX93HzJ8EvG0r0mMucCZM
	ywkHDRqKu3NE8vtnD7XOVdsc2SJQ02jMcMI8zXw6svXcoxmS16bWN+AwMfPA0Tm/bcGNHq
	RxZL7PismjkuX8GtGL4nItNQLxvHbgQ=3D
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-8-RmynicKXOH-0H-BwJSYPHw-1; Sat, 30 Mar 2024 17:35:51 -0400
X-MC-Unique: RmynicKXOH-0H-BwJSYPHw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50e91f9d422=
so2894541e87.2
        for <linux-crypto@vger.kernel.org>; Sat, 30 Mar 2024 14:35:50 -0700=
 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711834548; x=3D1712439348;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DR/YdumI8jd8jDImfb7MEXm8pAf+7owyDUrM2XftNAOY=3D;
        b=3DIouwQLJ2RZGq+nmfEfo2RoHQX8cOVnn6y7J3PyJLuEmVh8Dy5fnLbAY7NFPF57x=
1ed
         HSUJIOD5mdSSeL5gRGbOvmE1PAouwFQ4nGY6LEZlBOO+JcufJoDzy1AEqravyBInAc=
Mu
         eF+LonSu5Gb6ioQUuOkQMjC8aDJV2aqNCGqL+yP3DNHYfMFoi4Spyb3dh50cQdThSS=
UA
         A5EDGUObV9jPKuI4w+yffjkngoG69cmkCfZoGml18yDZZXWXPImjbxRgHoktckgFbV=
pu
         3goZ69ifnHkyEZNChhUWeb56GAn80/AmvyFnkWv+s0g4iyyJXY/r6E3/nJxnm9o/Hg=
xI
         d8HQ=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCXgbdPKNpSp6x0pqfKIPH7UxydRGmQAsyq2wfAsN=
OF9Sefd/uzcOpJliopU2eHTtHwULlcYs4mO0/ifhDB5/hQy4wtXIscLoEyvQ0Oa
X-Gm-Message-State: AOJu0YyPJSuW7MwDC/9Sg96ZOYuImIvc8NWkUzDXWgN7EzYwBPBDOyC=
2
	ZDX3rSI3E78xHxq10hIUUkvGMmJESO6eh8H2p1z79F4S76qBQJmRs1570VAfl2zF7VJAho57Qf=
n
	pnPpJ8V8V/9hkKNHH6p4O+le41idF1bYyEU6w8xJ4yrrB+Ib1ne5gmif7zZFp4w=3D=3D
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac242=
56000000b00515a5b11dd0mr3175179lfl.55.1711834548603;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtpVK74hYMJQRsbSNAOxNo0vPDNEDLKCnR39FTY23/i2sK1=
bKLUmtvrUTSb2GUD2WssCJO3g=3D=3D
X-Received: by 2002:ac2:4256:0:b0:515:a5b1:1dd0 with SMTP id m22-20020ac242=
56000000b00515a5b11dd0mr3175156lfl.55.1711834548253;
        Sat, 30 Mar 2024 14:35:48 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id os26-20020a170906af7a00b00a4=
65b72a1f3sm3494452ejb.85.2024.03.30.14.35.45
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:35:47 -0700 (PDT)
Message-ID: <abbe9937-7e0f-4fbd-be0b-488de07dd56c@redhat.com>
Date: Sat, 30 Mar 2024 22:35:44 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 25/29] KVM: SVM: Add module parameter to enable the
 SEV-SNP
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-26-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-26-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-crypto+bounces-3137-steffen.klassert=3Dsecunet.com@vger.=
kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:36:37.4225
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: acec573f-931a-46c9-6803-08dc=
51017aa5
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.423|SMR=3D0.345(SMRDE=3D0.035|SMRC=3D0.31=
0(SMRCL=3D0.102|X-SMRCR=3D0.309))|CAT=3D0.077(CATOS=3D0.012
 (CATSM=3D0.012(CATSM-Malware
 Agent=3D0.011))|CATRESL=3D0.039(CATRESLP2R=3D0.036)|CATORES=3D0.024
 (CATRS=3D0.024(CATRS-Index Routing Agent=3D0.023)));2024-03-30T21:36:37.91=
1Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 13357
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.065|SMR=3D0.024(SMRPI=3D0.021(SMRPI-FrontendProxyAgent=3D0.021))=
|SMS=3D0.041
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAVUDAAAPAAADH4sIAAAAAAAEAJVS33Pa=
RhDew0IgCHbqpA
 9920c7AmQbbBPH9Thu03YmE9cTZvLKHLoTugZ0jE7gJNM/u39A9ySZ
 UoIz7SAdu6vv+/bH7V/13xPsBScvg5M+nvQuTgdtfKfCmMspvtdZjP
 epzuRFq3GFv6R6doE3qfpDmhiHKpnEeDku3K6x7jWfiW6oZ1cEt4zX
 QiDHmRaLqcQ5T/lMZjLFLOYJhvSOJS6MFJhplAkfE0inKJTJzSyWOH
 zzoTO8vbNakeTZIpVdvNX3ViHDtx/eYaiTjKvE5GizmM91mmGk04J9
 e4dGZrn9628/3ViZ+PNcpktlCFIqYjTlE1uCSoQKeSYLdUtW5kFTim
 7Z01BNEik6Ooo648//fRybvNcmVkR7y6cpx0uee92P1ltjtRrv5VLJ
 e+JZzh3XU403OvmiEoWX83FhXadSUMUrzhV2Oh37h8jTMA4+Dc6Cj8
 tZYOwrl90Q/8Qe+n6JOcZI0bjpypOJFG08oUEYmWZKJ+bAP2wTQMip
 tP5B57CcglBRRGkmKkMePJJl/MgHy6dZy0/YkwMhz8NxLxy87HbPTg
 fHx2envfOoF+Hx0dFZv18282gO+933/W+mur7GTn/QPkefzoF1TcYz
 RfVpPaX9WI6kGRXrJ/BHzNKFfFVMpljcUb64o4SWVxwU8PYGrZ1rtf
 Go3+8fvipHhBi8KNc6eNjpcp9Xm/oiyDvcLMgk8wfpvBT/G4D1kv1H
 KiZ4e5P3v2p+M8Sf5XgxGd7z+UbxuG2cwoJHhtBfl2l/ABXYYQxqxQ
 MVcitspwpQhVoN6g5Uq9BwwCXbRhh8bw13B5wdaNLJoOJCzbOYKrlE
 J4NOCtJJLIu0yoQnQY/cAlnP7RKw9jhQb0CzSE0KBFspe/Cdy6AFtd
 x1tpVUXwdQDQSgyHNrlIA6gyZ49LVqm/LIfQaeaynPikSrhzHqDhhr
 2hMq9LXGvMJusL3CqMO+k6crAP+iQ2VbkObpPoHdJ6zlAriwuw3jbQ
 kyGhRdVVFS5R8bqlS8BTPYzadUs3fRpK73865t44wS2YGsYTyHuQ6A
 A/tuftEPd0RT3VsJ7pWR1lcRStHYSJHT1zFbUrjlPTZq8HSl+UMeJB
 E7YVL+GzbhDKYKBwAAAQq1Azw/eG1sIHZlcnNpb249IjEuMCIgZW5j
 b2Rpbmc9InV0Zi0xNiI/Pg0KPEVtYWlsU2V0Pg0KICA8VmVyc2lvbj
 4xNS4wLjAuMDwvVmVyc2lvbj4NCiAgPEVtYWlscz4NCiAgICA8RW1h
 aWwgU3RhcnRJbmRleD0iNjIiPg0KICAgICAgPEVtYWlsU3RyaW5nPm
 JyaWplc2guc2luZ2hAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAg
 PC9FbWFpbD4NCiAgICA8RW1haWwgU3RhcnRJbmRleD0iMzg4Ij4NCi
 AgICAgIDxFbWFpbFN0cmluZz5hc2hpc2gua2FscmFAYW1kLmNvbTwv
 RW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgICA8RW1haWwgU3
 RhcnRJbmRleD0iNDQxIiBQb3NpdGlvbj0iU2lnbmF0dXJlIj4NCiAg
 ICAgIDxFbWFpbFN0cmluZz5wYm9uemluaUByZWRoYXQuY29tPC9FbW
 FpbFN0cmluZz4NCiAgICA8L0VtYWlsPg0KICA8L0VtYWlscz4NCjwv
 RW1haWxTZXQ+AQyWCjw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbm
 c9InV0Zi0xNiI/Pg0KPENvbnRhY3RTZXQ+DQogIDxWZXJzaW9uPjE1
 LjAuMC4wPC9WZXJzaW9uPg0KICA8Q29udGFjdHM+DQogICAgPENvbn
 RhY3QgU3RhcnRJbmRleD0iMzE4Ij4NCiAgICAgIDxQZXJzb24gU3Rh
 cnRJbmRleD0iMzE4Ij4NCiAgICAgICAgPFBlcnNvblN0cmluZz5Ccm
 lqZXNoIFNpbmdoPC9QZXJzb25TdHJpbmc+DQogICAgICA8L1BlcnNv
 bj4NCiAgICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFpbCBTdGFydE
 luZGV4PSIzMzMiPg0KICAgICAgICAgIDxFbWFpbFN0cmluZz5icmlq
 ZXNoLnNpbmdoQGFtZC5jb208L0VtYWlsU3RyaW5nPg0KICAgICAgIC
 A8L0VtYWlsPg0KICAgICAgPC9FbWFpbHM+DQogICAgICA8Q29udGFj
 dFN0cmluZz5CcmlqZXNoIFNpbmdoICZsdDticmlqZXNoLnNpbmdoQG
 FtZC5jb208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0K
 ICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjM3NCI+DQogICAgICA8UG
 Vyc29uIFN0YXJ0SW5kZXg9IjM3NCI+DQogICAgICAgIDxQZXJzb25T
 dHJpbmc+QXNoaXNoIEthbHJhPC9QZXJzb25TdHJpbmc+DQogICAgIC
 A8L1BlcnNvbj4NCiAgICAgIDxFbWFpbHM+DQogICAgICAgIDxFbWFp
 bCBTdGFydEluZGV4PSIzODgiPg0KICAgICAgICAgIDxFbWFpbFN0cm
 luZz5hc2hpc2gua2FscmFAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQog
 ICAgICAgIDwvRW1haWw+DQogICAgICA8L0VtYWlscz4NCiAgICAgID
 xDb250YWN0U3RyaW5nPkFzaGlzaCBLYWxyYSAmbHQ7YXNoaXNoLmth
 bHJhQGFtZC5jb208L0NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YW
 N0Pg0KICAgIDxDb250YWN0IFN0YXJ0SW5kZXg9IjQyNiIgUG9zaXRp
 b249IlNpZ25hdHVyZSI+DQogICAgICA8UGVyc29uIFN0YXJ0SW5kZX
 g9IjQyNiIgUG9zaXRpb249IlNpZ25hdHVyZSI+DQogICAgICAgIDxQ
 ZXJzb25TdHJpbmc+UGFvbG8gQm9uemluaTwvUGVyc29uU3RyaW5nPg
 0KICAgICAgPC9QZXJzb24+DQogICAgICA8RW1haWxzPg0KICAgICAg
 ICA8RW1haWwgU3RhcnRJbmRleD0iNDQxIiBQb3NpdGlvbj0iU2lnbm
 F0dXJlIj4NCiAgICAgICAgICA8RW1haWxTdHJpbmc+cGJvbnppbmlA
 cmVkaGF0LmNvbTwvRW1haWxTdHJpbmc+DQogICAgICAgIDwvRW1haW
 w+DQogICAgICA8L0VtYWlscz4NCiAgICAgIDxDb250YWN0U3RyaW5n
 PlBhb2xvIEJvbnppbmkgJmx0O3Bib256aW5pQHJlZGhhdC5jb208L0
 NvbnRhY3RTdHJpbmc+DQogICAgPC9Db250YWN0Pg0KICA8L0NvbnRh
 Y3RzPg0KPC9Db250YWN0U2V0PgEOzwFSZXRyaWV2ZXJPcGVyYXRvci
 wxMCwwO1JldHJpZXZlck9wZXJhdG9yLDExLDE7UG9zdERvY1BhcnNl
 ck9wZXJhdG9yLDEwLDA7UG9zdERvY1BhcnNlck9wZXJhdG9yLDExLD
 A7UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEwLDA7
 UG9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDExLDA7VH
 JhbnNwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMTI=3D
X-MS-Exchange-Forest-IndexAgent: 1 2822
X-MS-Exchange-Forest-EmailMessageHash: 605501D6
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
>=20
> Add a module parameter than can be used to enable or disable the SEV-SNP
> feature. Now that KVM contains the support for the SNP set the GHCB
> hypervisor feature flag to indicate that SNP is supported.
>=20
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>   arch/x86/kvm/svm/sev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3e8de7cb3c89..658116537f3f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -48,7 +48,8 @@ static bool sev_es_enabled =3D true;
>   module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  =20
>   /* enable/disable SEV-SNP support */
> -static bool sev_snp_enabled;
> +static bool sev_snp_enabled =3D true;
> +module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
>  =20
>   /* enable/disable SEV-ES DebugSwap support */
>   static bool sev_es_debug_swap_enabled =3D true;



