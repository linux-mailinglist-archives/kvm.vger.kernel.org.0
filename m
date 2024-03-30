Return-Path: <kvm+bounces-13215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED10889338A
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 18:43:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EBFA1C20752
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 16:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABD614A0BF;
	Sun, 31 Mar 2024 16:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPSRLNX5"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A61482FC;
	Sun, 31 Mar 2024 16:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903047; cv=fail; b=f4Fy/MLtjZ5E811Kcuu5/1TqHtehbG7k47RHzqT2c7rfw4N1M2P+CtSn80EOdWCqe8tHEvfUYSvMycGFbk8dr89O6OU6ZWlyWODz5CQgMDXmASPyPnhjffeo2uOYEBzvBKbrC6ww4Ms6ggo1WZKwmpHimG3Dg5wficunN8oVu1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903047; c=relaxed/simple;
	bh=0fbsfYNtnfefcsVO14L4iwjzI7Edv8TqDpBGErqiOd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CP8766hyZU5P9lou/v3vLOciDBPIx6j9NoXzyplD+c2EJh+TLU1E7JhtaNgLNd6t2J+DRgpaIWzrUUec+BJ7rYEKfwsd9bmU/Rt4EoFeIMFJWT4mVkCrG4WsXGR6dULMVvK1hiZ/AQSMoYoKuOjfahus08a31L+w1zux9/9NC+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPSRLNX5 reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id B589E2083B;
	Sun, 31 Mar 2024 18:37:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XR5dl4vonYGa; Sun, 31 Mar 2024 18:37:17 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 486B820754;
	Sun, 31 Mar 2024 18:37:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 486B820754
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 09F78800051;
	Sun, 31 Mar 2024 18:28:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:27:59 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:23:54 +0000
X-sender: <linux-crypto+bounces-3138-steffen.klassert=secunet.com@vger.kernel.org>
X-Receiver: <steffen.klassert@secunet.com>
 ORCPT=rfc822;steffen.klassert@secunet.com NOTIFY=NEVER;
 X-ExtendedProps=BQAVABYAAgAAAAUAFAARAPDFCS25BAlDktII2g02frgPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAGIAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACheZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJhdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ049c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngtZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAAwAAgAABQBsAAIAAAUAWAAXAEoAAADwxQktuQQJQ5LSCNoNNn64Q049S2xhc3NlcnQgU3RlZmZlbixPVT1Vc2VycyxPVT1NaWdyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9ye
	TogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAjAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: b.mx.secunet.com
X-ExtendedProps: BQBjAAoAEqRAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgB0AAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZlbi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg==
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 32781
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.80.249; helo=am.mirrors.kernel.org; envelope-from=linux-crypto+bounces-3138-steffen.klassert=secunet.com@vger.kernel.org; receiver=steffen.klassert@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 47F272025D
Authentication-Results: b.mx.secunet.com;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPSRLNX5"
X-Original-To: linux-crypto@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal: i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711835060; cv=none; b=AgnkYl6BU177pCC/42kaXTPOxme34RVEfw+OO09sG84Ecnxxnxd4c4AEr1Yp1t45L9ZOEYGWFjXsmonvBPHldMbAAHkyAWgiqmrztlEpePcYuVg92tp0dQSyD6oSAjZuVbJQeU3nd7xRv92DX0d+7qbFNXb/FcMDtKjRP0+h3I0=
ARC-Message-Signature: i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711835060; c=relaxed/simple;
	bh=RMUAwxfBL6v+GOWep6RijyAhN1Eu1x5xeC0TGBvfsN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1VELV71pSE+pitUxO6PZDLwfBWcKxg+NZBKgmvamMpNZDTWNVWFUNDJILdvT1WUWRcMgnNMdbsW48UzMaEtXGJbeN0Tp4hXRMD1kCBTUYfZ8luyvnqc+VHEPXo0CX9cJUVQcGY2C58L3O8/I+J53S+vh89JdFcw8bXSEaqFfq8=
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPSRLNX5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711835057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=izlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=;
	b=jPSRLNX5ioNiCLGGFgYa15v3rMLzyZj3JtGI5TQBGjZ4f04KM7UUddGP6/ukYlPmaWPi7N
	vzZf0Y1EtVEI+HAzpoUQZSzLmOJV0LsGKdM/VgPmskY3R5zEhJTda9f6E3Z90q/XYPayyK
	oYRnDncI3scGlF57yfr0bQjdbSy+dWA=
X-MC-Unique: cBSYwqMsOFiIfVXKGdkDYQ-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711835054; x=1712439854;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=;
        b=wPEt9/oTyqQBN7x1/VQ0oLwf6LBh2uXTfMpTJ+iG7gaRZoprv2E9WdtU4e+uroNE4b
         wbADETChcmLc6+jrdv469jMc0aR3ggVeUzQLsNr0thyIOEi5R3VvGwp9TDlfIDZ6BSWR
         4Jiju58YLD85ss/678OhI/+74ZiEkbAO5t+fAsg0SRxXoQQspwkdoiYv/8Q70kMfk/1q
         rkK/h6PmP/IUWujmboBQlvLWNaiWxPA0LbIG/MSqc6rGFYHXsTxvWPUuC3MX0E1fYeEl
         HiMv/ZPnlnaxDb0H9zTLppZ1n/m8rQFpwkmzWdmDOmpCdAoggE3mPwiWRShRsnz8lngc
         Q/0A==
X-Forwarded-Encrypted: i=1; AJvYcCWu2bzr3fGgn23SYlM0dL1SFCT002M8R3pEFlngrR4+3AP4yICROqGWZ+yzicvaxuivVyeu6jjnEvu/8YjjqELZFsKXnGLaOPWNgG/K
X-Gm-Message-State: AOJu0YzS9ajh19iDGnUVTwOq1RPcPUPMegzW14HxnLShwQEvms9RRLn6
	jZHSVqvoBxlx1MCCPnzqshth0CSU3obln3Z4DLPIx3Ua2UHNDa+dbILzBPfoS7jWK7fWw9Ixm7A
	VlN+xS/4cfrq91+3G5WOlGCMtFn7P5mXNbLmVZGx85o5jFI8EiWc/rVbhOdoVpg==
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17090624d700b00a4e1aef2d03mr3493110ejb.69.1711835054358;
        Sat, 30 Mar 2024 14:44:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB4hhnolDV2VDW9ProjEjPrZSmimTTGsoO1Kt1nnLoSJpgttSbznq+JYF5W8Ur6uv2Wrybrg==
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17090624d700b00a4e1aef2d03mr3493096ejb.69.1711835053917;
        Sat, 30 Mar 2024 14:44:13 -0700 (PDT)
Message-ID: <8153674b-1b66-4416-a3b8-b6b7867e77f4@redhat.com>
Date: Sat, 30 Mar 2024 22:44:10 +0100
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
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
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

On 3/29/24 23:58, Michael Roth wrote:
> This patchset is also available at:
>=20
>    https://github.com/amdese/linux/commits/snp-host-v12
>=20
> and is based on top of the following series:
>=20
>    [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
>    https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.c=
om/
>=20
> which in turn is based on:
>=20
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queu=
e
>=20
>=20
> Patch Layout
> ------------
>=20
> 01-04: These patches are minor dependencies for this series and will
>         eventually make their way upstream through other trees. They are
>         included here only temporarily.
>=20
> 05-09: These patches add some basic infrastructure and introduces a new
>         KVM_X86_SNP_VM vm_type to handle differences verses the existing
>         KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
>=20
> 10-12: These implement the KVM API to handle the creation of a
>         cryptographic launch context, encrypt/measure the initial image
>         into guest memory, and finalize it before launching it.
>=20
> 13-20: These implement handling for various guest-generated events such
>         as page state changes, onlining of additional vCPUs, etc.
>=20
> 21-24: These implement the gmem hooks needed to prepare gmem-allocated
>         pages before mapping them into guest private memory ranges as
>         well as cleaning them up prior to returning them to the host for
>         use as normal memory. Because this supplants certain activities
>         like issued WBINVDs during KVM MMU invalidations, there's also
>         a patch to avoid duplicating that work to avoid unecessary
>         overhead.
>=20
> 25:    With all the core support in place, the patch adds a kvm_amd modul=
e
>         parameter to enable SNP support.
>=20
> 26-29: These patches all deal with the servicing of guest requests to han=
dle
>         things like attestation, as well as some related host-management
>         interfaces.
>=20
>=20
> Testing
> -------
>=20
> For testing this via QEMU, use the following tree:
>=20
>    https://github.com/amdese/qemu/commits/snp-v4-wip2
>=20
> A patched OVMF is also needed due to upstream KVM no longer supporting MM=
IO
> ranges that are mapped as private. It is recommended you build the AmdSev=
X64
> variant as it provides the kernel-hashing support present in this series:
>=20
>    https://github.com/amdese/ovmf/commits/apic-mmio-fix1c
>=20
> A basic command-line invocation for SNP would be:
>=20
>   qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>    -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>    -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-=
auth=3D
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX6=
4.fd
>=20
> With kernel-hashing and certificate data supplied:
>=20
>   qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>    -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>    -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-=
auth=3D,certs-path=3D/home/mroth/cert.blob,kernel-hashes=3Don
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX6=
4.fd
>    -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
>    -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
>    -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=
=3DttyS0,115200n8"
>=20
>=20
> Known issues / TODOs
> --------------------
>=20
>   * Base tree in some cases reports "Unpatched return thunk in use. This =
should
>     not happen!" the first time it runs an SVM/SEV/SNP guests. This a rec=
ent
>     regression upstream and unrelated to this series:
>=20
>       https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobw=
fwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/
>=20
>   * 2MB hugepage support has been dropped pending discussion on how we pl=
an
>     to re-enable it in gmem.
>=20
>   * Host kexec should work, but there is a known issue with handling host
>     kdump while SNP guests are running which will be addressed as a follo=
w-up.
>=20
>   * SNP kselftests are currently a WIP and will be included as part of SN=
P
>     upstreaming efforts in the near-term.
>=20
>=20
> SEV-SNP Overview
> ----------------
>=20
> This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
> changes required to add KVM support for SEV-SNP. This series builds upon
> SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
> initialization support, which is now in linux-next.
>=20
> While series provides the basic building blocks to support booting the
> SEV-SNP VMs, it does not cover all the security enhancement introduced by
> the SEV-SNP such as interrupt protection, which will added in the future.
>=20
> With SNP, when pages are marked as guest-owned in the RMP table, they are
> assigned to a specific guest/ASID, as well as a specific GFN with in the
> guest. Any attempts to map it in the RMP table to a different guest/ASID,
> or a different GFN within a guest/ASID, will result in an RMP nested page
> fault.
>=20
> Prior to accessing a guest-owned page, the guest must validate it with a
> special PVALIDATE instruction which will set a special bit in the RMP tab=
le
> for the guest. This is the only way to set the validated bit outside of t=
he
> initial pre-encrypted guest payload/image; any attempts outside the guest=
 to
> modify the RMP entry from that point forward will result in the validated
> bit being cleared, at which point the guest will trigger an exception if =
it
> attempts to access that page so it can be made aware of possible tamperin=
g.
>=20
> One exception to this is the initial guest payload, which is pre-validate=
d
> by the firmware prior to launching. The guest can use Guest Message reque=
sts
> to fetch an attestation report which will include the measurement of the
> initial image so that the guest can verify it was booted with the expecte=
d
> image/environment.
>=20
> After boot, guests can use Page State Change requests to switch pages
> between shared/hypervisor-owned and private/guest-owned to share data for
> things like DMA, virtio buffers, and other GHCB requests.
>=20
> In this implementation of SEV-SNP, private guest memory is managed by a n=
ew
> kernel framework called guest_memfd (gmem). With gmem, a new
> KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
> MMU whether a particular GFN should be backed by shared (normal) memory o=
r
> private (gmem-allocated) memory. To tie into this, Page State Change
> requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
> then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
> private/shared state in the KVM MMU.
>=20
> The gmem / KVM MMU hooks implemented in this series will then update the =
RMP
> table entries for the backing PFNs to set them to guest-owned/private whe=
n
> mapping private pages into the guest via KVM MMU, or use the normal KVM M=
MU
> handling in the case of shared pages where the corresponding RMP table
> entries are left in the default shared/hypervisor-owned state.
>=20
> Feedback/review is very much appreciated!
>=20
> -Mike
>=20
> Changes since v11:
>=20
>   * Rebase series on kvm-coco-queue and re-work to leverage more
>     infrastructure between SNP/TDX series.
>   * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introdu=
ced
>     here (Paolo):
>       https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redh=
at.com/
>   * Drop exposure API fields related to things like VMPL levels, migratio=
n
>     agents, etc., until they are actually supported/used (Sean)
>   * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
>     kvm_gmem_populate() interface instead of copying data directly into
>     gmem-allocated pages (Sean)
>   * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} =
to
>     have simpler semantics that are applicable to management of SNP_LOAD_=
VLEK
>     updates as well, rename interfaces to the now more appropriate
>     SNP_{PAUSE,RESUME}_ATTESTATION
>   * Fix up documentation wording and do print warnings for
>     userspace-triggerable failures (Peter, Sean)
>   * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
>   * Fix a memory leak with VMSA pages (Sean)
>   * Tighten up handling of RMP page faults to better distinguish between =
real
>     and spurious cases (Tom)
>   * Various patch/documentation rewording, cleanups, etc.

I skipped a few patches that deal mostly with AMD ABIs.  Here are the=20
ones that have nontrivial remarks, that are probably be worth a reply=20
before sending v13:

- patch 10: some extra checks on input parameters, and possibly=20
forbidding SEV/SEV-ES ioctls for SEV-SNP guests?

- patch 12: a (hopefully) simple question on boot_vcpu_handled

- patch 18: see Sean's objections at=20
https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/

- patch 22: question on ignoring PSMASH failures and possibly adding a=20
kvm_arch_gmem_invalidate_begin() API.

With respect to the six preparatory patches, I'll merge them in=20
kvm-coco-queue early next week.  However I'll explode the arguments to=20
kvm_gmem_populate(), while also removing "memslot" and merging "src"=20
with "do_memcpy".  I'll post my version very early.

Paolo


X-sender: <kvm+bounces-13162-martin.weber=3Dsecunet.com@vger.kernel.org>
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
X-ExtendedProps: BQBjAAoAEqRAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgB1AAAAo4oAAAUABAAUIAEAAAAYAAAAbWFydGlu=
LndlYmVyQHNlY3VuZXQuY29tBQAGAAIAAQUAKQACAAEPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwA=
BAAAABQADAAcAAAAAAAUABQACAAEFAGQADwADAAAASHVi
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.37
X-EndOfInjectedXHeaders: 32715
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:44:27 +0100
Received: from b.mx.secunet.com (62.96.220.37) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:44:27 +0100
Received: from localhost (localhost [127.0.0.1])
	by b.mx.secunet.com (Postfix) with ESMTP id E924120322
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:44:27 +0100 (CET)
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
	with ESMTP id UnVjOafjPOPL for <martin.weber@secunet.com>;
	Sat, 30 Mar 2024 22:44:26 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dkvm+bounces=
-13162-martin.weber=3Dsecunet.com@vger.kernel.org; receiver=3Dmartin.weber@=
secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com C352E2025D
Authentication-Results: b.mx.secunet.com;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"jPSRLNX5"
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by b.mx.secunet.com (Postfix) with ESMTPS id C352E2025D
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 22:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5468A1F21CEA
	for <martin.weber@secunet.com>; Sat, 30 Mar 2024 21:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3634AEFE;
	Sat, 30 Mar 2024 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"jPSRLNX5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F69482D8
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 21:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.129.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711835060; cv=3Dnone; b=3DAgnkYl6BU177pCC/42kaXTPOxme34RVEfw+OO09sG84=
Ecnxxnxd4c4AEr1Yp1t45L9ZOEYGWFjXsmonvBPHldMbAAHkyAWgiqmrztlEpePcYuVg92tp0dQ=
SyD6oSAjZuVbJQeU3nd7xRv92DX0d+7qbFNXb/FcMDtKjRP0+h3I0=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711835060; c=3Drelaxed/simple;
	bh=3DRMUAwxfBL6v+GOWep6RijyAhN1Eu1x5xeC0TGBvfsN8=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3Dl1VELV71pSE+pitUxO6PZDLwfBWcKxg+NZBKgmvamMp=
NZDTWNVWFUNDJILdvT1WUWRcMgnNMdbsW48UzMaEtXGJbeN0Tp4hXRMD1kCBTUYfZ8luyvnqc+V=
HEPXo0CX9cJUVQcGY2C58L3O8/I+J53S+vh89JdFcw8bXSEaqFfq8=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DjPSRLNX5; arc=3Dnone smtp.client-ip=3D170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711835057;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Dizlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=3D;
	b=3DjPSRLNX5ioNiCLGGFgYa15v3rMLzyZj3JtGI5TQBGjZ4f04KM7UUddGP6/ukYlPmaWPi7N
	vzZf0Y1EtVEI+HAzpoUQZSzLmOJV0LsGKdM/VgPmskY3R5zEhJTda9f6E3Z90q/XYPayyK
	oYRnDncI3scGlF57yfr0bQjdbSy+dWA=3D
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-377-eyReanA0Oci9pe1XY5ST0w-1; Sat, 30 Mar 2024 17:44:15 -0400
X-MC-Unique: eyReanA0Oci9pe1XY5ST0w-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4e4cebd1c0=
so52249266b.0
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 14:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711835054; x=3D1712439854;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Dizlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=3D;
        b=3DwPo0hV7gI77ohVHzuRa2x3ggHAOaO57sbiBTMmyPqHZrNKpQ0wbnqt9C+5885Ly=
vrj
         0Z5E2EeypFBtau8chKJveYjL/ByPJxESpNlHrYagztCO6B+8w4g+0WAE4Qsmua0SBl=
90
         ec3a+bmfHljQ+x+Gw9RTue7vxFykijh4CL13k1FawNDFLYVU2GHXTBxWCnDVin+/fR=
La
         oTnpSWB/wTjLNcgdWWtvY9sp+rVg6hHkpt533cTizLendTizqj0oob6mN4qm2lzc9+=
XZ
         YF6+xdzp2Rl2wcH5yjPPdoUc3JZ0QMTiMAmdGVRPeN7S2j1VpTg7pkMhIZLfkkG5us=
m1
         psAQ=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCWuPKEfpFiMb2kP1lRzLIhqFlEdlHC/mc+Qt0mYN=
DhfLu7CgCmhPLDMMLBAoMhJSwdt5NcPUAD2kNk9+YosPY5D6MkC
X-Gm-Message-State: AOJu0YyBlVPXurOLfhiHoLFnIYzDNnBlgejFQzqmj7BgcVznlkI872o=
L
	/W8o/viNFLoJ3WCVobaYT33e+Az1TA8IpW2jgOETYtj7jbgnqxqUYz6iotJJD3+DSyi/ULv9Pg=
b
	rXyqw2fgHu7ZNtr+2QjLceb/1bf0Mz3kGj3COXOhXCiQ4EAFVuw=3D=3D
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17=
090624d700b00a4e1aef2d03mr3493126ejb.69.1711835054363;
        Sat, 30 Mar 2024 14:44:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB4hhnolDV2VDW9ProjEjPrZSmimTTGsoO1Kt1nnLoSJpgt=
tSbznq+JYF5W8Ur6uv2Wrybrg=3D=3D
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17=
090624d700b00a4e1aef2d03mr3493096ejb.69.1711835053917;
        Sat, 30 Mar 2024 14:44:13 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id d6-20020a1709063ec600b00a474=
c3c2f9dsm3458900ejj.38.2024.03.30.14.44.11
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:44:13 -0700 (PDT)
Message-ID: <8153674b-1b66-4416-a3b8-b6b7867e77f4@redhat.com>
Date: Sat, 30 Mar 2024 22:44:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
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
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: kvm+bounces-13162-martin.weber=3Dsecunet.com@vger.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:44:27.9699
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 377ee84b-412e-4f5a-3dad-08dc=
5102931d
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.37
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.439|SMR=3D0.351(SMRDE=3D0.036|SMRC=3D0.31=
4(SMRCL=3D0.102|X-SMRCR=3D0.315))|CAT=3D0.087(CATOS=3D0.013
 (CATSM=3D0.013(CATSM-Malware
 Agent=3D0.012))|CATRESL=3D0.042(CATRESLP2R=3D0.018)|CATORES=3D0.028
 (CATRS=3D0.028(CATRS-Index Routing
 Agent=3D0.027))|CATORT=3D0.002(CATRT=3D0.002(CATRT-Journal Agent=3D0.001
 )));2024-03-30T21:44:28.408Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 21685
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.027|SMR=3D0.026(SMRPI=3D0.024(SMRPI-FrontendProxyAgent=3D0.024))
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AARkXAAAPAAADH4sIAAAAAAAEAO1abXPb=
SHIGJUqiKMv27u
 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
 tU49k1I18iek6YLVM6Igbl4BLOoq2NNcGhyNE8rHeBWDH4qizAul9r
 4l1r18xlXWCKN81yOk0YU5jPFv/hmpxiStONVUtlvKOxybwqFjxIpN
 81RL2iPdKyEY1q/AM9a1lDl6b1SF9mDZs1xIpbBatNw37yuC0pbUFo
 da7TCP+kSzIbgBZay7UsZiVb0rCdi42ITU4KK7UMZYFdRwgowlKoqL
 3hfIUSVHRY5jZQY5L7IGuxesckCYtJu2U0vNPklvNWjV0XDFgrXZh1
 v6TKhEvQ72vJV3AoqBA9l3XptS52EBfXbA4G+4K7p1VrQ45xKWl01f
 TreTGwtlozIyN2Q/o73mVDmhTBvE3NBn5tRvtmPfdtGihqH1FHoKsO
 ttsKF1eaaUU9qRl05TCXcMtU5qsCSGs69tGvlk2fyNfEafC45WrJjD
 jLesP5mim9VdMWx9SUSNhj95E3BUKt+jJrWPY73Ret6sCzcSqlRZNb
 D2ZIcpYACbqtU62FSGxJTpEqxfYXlu6a825uxW7dJkCuW2/KATn3ra
 3qmry90liVCrxZa2O5TxR92rphaTirtX681hhuWgkNJnYLjCbhYYW9
 Nl9jiYJ6xobzZBG0dwmEa3WtRJRgWNAr1w12+m9Mv8lNOo7TsulMnM
 62Xbc1OTca83g0GVM36QIDzmjNGphvGYZvr2l6xCcXJ7pGbdtEaadS
 K/8DLAAsreU3AAABC6cEPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZG
 luZz0idXRmLTE2Ij8+DQo8VXJsU2V0Pg0KICA8VmVyc2lvbj4xNS4w
 LjAuMDwvVmVyc2lvbj4NCiAgPFVybHM+DQogICAgPFVybCBTdGFydE
 luZGV4PSI4NiIgVHlwZT0iVXJsIj4NCiAgICAgIDxVcmxTdHJpbmc+
 aHR0cHM6Ly9naXRodWIuY29tL2FtZGVzZS9saW51eC9jb21taXRzL3
 NucC1ob3N0LXYxMjwvVXJsU3RyaW5nPg0KICAgIDwvVXJsPg0KICAg
 IDxVcmwgU3RhcnRJbmRleD0iMjc2IiBUeXBlPSJVcmwiPg0KICAgIC
 AgPFVybFN0cmluZz5odHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0v
 MjAyNDAzMjkyMTI0NDQuMzk1NTU5LTEtbWljaGFlbC5yb3RoQGFtZC
 5jb20vPC9VcmxTdHJpbmc+DQogICAgPC9Vcmw+DQogICAgPFVybCBT
 dGFydEluZGV4PSIzOTIiIFR5cGU9IlVybCI+DQogICAgICA8VXJsU3
 RyaW5nPmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0
 L2t2bS9rdm0uZ2l0L2xvZy8/aD1rdm0tY29jby1xdWV1ZTwvVXJsU3
 RyaW5nPg0KICAgIDwvVXJsPg0KICA8L1VybHM+DQo8L1VybFNldD4B
 Ds8BUmV0cmlldmVyT3BlcmF0b3IsMTAsMDtSZXRyaWV2ZXJPcGVyYX
 RvciwxMSwxO1Bvc3REb2NQYXJzZXJPcGVyYXRvciwxMCwwO1Bvc3RE
 b2NQYXJzZXJPcGVyYXRvciwxMSwwO1Bvc3RXb3JkQnJlYWtlckRpYW
 dub3N0aWNPcGVyYXRvciwxMCwzO1Bvc3RXb3JkQnJlYWtlckRpYWdu
 b3N0aWNPcGVyYXRvciwxMSwwO1RyYW5zcG9ydFdyaXRlclByb2R1Y2 VyLDIwLDE1
X-MS-Exchange-Forest-IndexAgent: 1 6690
X-MS-Exchange-Forest-EmailMessageHash: 6E70D1AD
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> This patchset is also available at:
>=20
>    https://github.com/amdese/linux/commits/snp-host-v12
>=20
> and is based on top of the following series:
>=20
>    [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
>    https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.c=
om/
>=20
> which in turn is based on:
>=20
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queu=
e
>=20
>=20
> Patch Layout
> ------------
>=20
> 01-04: These patches are minor dependencies for this series and will
>         eventually make their way upstream through other trees. They are
>         included here only temporarily.
>=20
> 05-09: These patches add some basic infrastructure and introduces a new
>         KVM_X86_SNP_VM vm_type to handle differences verses the existing
>         KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
>=20
> 10-12: These implement the KVM API to handle the creation of a
>         cryptographic launch context, encrypt/measure the initial image
>         into guest memory, and finalize it before launching it.
>=20
> 13-20: These implement handling for various guest-generated events such
>         as page state changes, onlining of additional vCPUs, etc.
>=20
> 21-24: These implement the gmem hooks needed to prepare gmem-allocated
>         pages before mapping them into guest private memory ranges as
>         well as cleaning them up prior to returning them to the host for
>         use as normal memory. Because this supplants certain activities
>         like issued WBINVDs during KVM MMU invalidations, there's also
>         a patch to avoid duplicating that work to avoid unecessary
>         overhead.
>=20
> 25:    With all the core support in place, the patch adds a kvm_amd modul=
e
>         parameter to enable SNP support.
>=20
> 26-29: These patches all deal with the servicing of guest requests to han=
dle
>         things like attestation, as well as some related host-management
>         interfaces.
>=20
>=20
> Testing
> -------
>=20
> For testing this via QEMU, use the following tree:
>=20
>    https://github.com/amdese/qemu/commits/snp-v4-wip2
>=20
> A patched OVMF is also needed due to upstream KVM no longer supporting MM=
IO
> ranges that are mapped as private. It is recommended you build the AmdSev=
X64
> variant as it provides the kernel-hashing support present in this series:
>=20
>    https://github.com/amdese/ovmf/commits/apic-mmio-fix1c
>=20
> A basic command-line invocation for SNP would be:
>=20
>   qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>    -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>    -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-=
auth=3D
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX6=
4.fd
>=20
> With kernel-hashing and certificate data supplied:
>=20
>   qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>    -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>    -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-=
auth=3D,certs-path=3D/home/mroth/cert.blob,kernel-hashes=3Don
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX6=
4.fd
>    -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
>    -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
>    -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=
=3DttyS0,115200n8"
>=20
>=20
> Known issues / TODOs
> --------------------
>=20
>   * Base tree in some cases reports "Unpatched return thunk in use. This =
should
>     not happen!" the first time it runs an SVM/SEV/SNP guests. This a rec=
ent
>     regression upstream and unrelated to this series:
>=20
>       https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobw=
fwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/
>=20
>   * 2MB hugepage support has been dropped pending discussion on how we pl=
an
>     to re-enable it in gmem.
>=20
>   * Host kexec should work, but there is a known issue with handling host
>     kdump while SNP guests are running which will be addressed as a follo=
w-up.
>=20
>   * SNP kselftests are currently a WIP and will be included as part of SN=
P
>     upstreaming efforts in the near-term.
>=20
>=20
> SEV-SNP Overview
> ----------------
>=20
> This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
> changes required to add KVM support for SEV-SNP. This series builds upon
> SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
> initialization support, which is now in linux-next.
>=20
> While series provides the basic building blocks to support booting the
> SEV-SNP VMs, it does not cover all the security enhancement introduced by
> the SEV-SNP such as interrupt protection, which will added in the future.
>=20
> With SNP, when pages are marked as guest-owned in the RMP table, they are
> assigned to a specific guest/ASID, as well as a specific GFN with in the
> guest. Any attempts to map it in the RMP table to a different guest/ASID,
> or a different GFN within a guest/ASID, will result in an RMP nested page
> fault.
>=20
> Prior to accessing a guest-owned page, the guest must validate it with a
> special PVALIDATE instruction which will set a special bit in the RMP tab=
le
> for the guest. This is the only way to set the validated bit outside of t=
he
> initial pre-encrypted guest payload/image; any attempts outside the guest=
 to
> modify the RMP entry from that point forward will result in the validated
> bit being cleared, at which point the guest will trigger an exception if =
it
> attempts to access that page so it can be made aware of possible tamperin=
g.
>=20
> One exception to this is the initial guest payload, which is pre-validate=
d
> by the firmware prior to launching. The guest can use Guest Message reque=
sts
> to fetch an attestation report which will include the measurement of the
> initial image so that the guest can verify it was booted with the expecte=
d
> image/environment.
>=20
> After boot, guests can use Page State Change requests to switch pages
> between shared/hypervisor-owned and private/guest-owned to share data for
> things like DMA, virtio buffers, and other GHCB requests.
>=20
> In this implementation of SEV-SNP, private guest memory is managed by a n=
ew
> kernel framework called guest_memfd (gmem). With gmem, a new
> KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
> MMU whether a particular GFN should be backed by shared (normal) memory o=
r
> private (gmem-allocated) memory. To tie into this, Page State Change
> requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
> then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
> private/shared state in the KVM MMU.
>=20
> The gmem / KVM MMU hooks implemented in this series will then update the =
RMP
> table entries for the backing PFNs to set them to guest-owned/private whe=
n
> mapping private pages into the guest via KVM MMU, or use the normal KVM M=
MU
> handling in the case of shared pages where the corresponding RMP table
> entries are left in the default shared/hypervisor-owned state.
>=20
> Feedback/review is very much appreciated!
>=20
> -Mike
>=20
> Changes since v11:
>=20
>   * Rebase series on kvm-coco-queue and re-work to leverage more
>     infrastructure between SNP/TDX series.
>   * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introdu=
ced
>     here (Paolo):
>       https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redh=
at.com/
>   * Drop exposure API fields related to things like VMPL levels, migratio=
n
>     agents, etc., until they are actually supported/used (Sean)
>   * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
>     kvm_gmem_populate() interface instead of copying data directly into
>     gmem-allocated pages (Sean)
>   * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} =
to
>     have simpler semantics that are applicable to management of SNP_LOAD_=
VLEK
>     updates as well, rename interfaces to the now more appropriate
>     SNP_{PAUSE,RESUME}_ATTESTATION
>   * Fix up documentation wording and do print warnings for
>     userspace-triggerable failures (Peter, Sean)
>   * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
>   * Fix a memory leak with VMSA pages (Sean)
>   * Tighten up handling of RMP page faults to better distinguish between =
real
>     and spurious cases (Tom)
>   * Various patch/documentation rewording, cleanups, etc.

I skipped a few patches that deal mostly with AMD ABIs.  Here are the=20
ones that have nontrivial remarks, that are probably be worth a reply=20
before sending v13:

- patch 10: some extra checks on input parameters, and possibly=20
forbidding SEV/SEV-ES ioctls for SEV-SNP guests?

- patch 12: a (hopefully) simple question on boot_vcpu_handled

- patch 18: see Sean's objections at=20
https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/

- patch 22: question on ignoring PSMASH failures and possibly adding a=20
kvm_arch_gmem_invalidate_begin() API.

With respect to the six preparatory patches, I'll merge them in=20
kvm-coco-queue early next week.  However I'll explode the arguments to=20
kvm_gmem_populate(), while also removing "memslot" and merging "src"=20
with "do_memcpy".  I'll post my version very early.

Paolo


X-sender: <linux-kernel+bounces-125899-steffen.klassert=3Dsecunet.com@vger.=
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
X-ExtendedProps: BQBjAAoAEqRAQuxQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAGIACgB2AAAAo4oAAAUABAAUIAEAAAAcAAAAc3RlZmZl=
bi5rbGFzc2VydEBzZWN1bmV0LmNvbQUABgACAAEFACkAAgABDwAJAAAAQ0lBdWRpdGVkAgABBQA=
CAAcAAQAAAAUAAwAHAAAAAAAFAAUAAgABBQBkAA8AAwAAAEh1Yg=3D=3D
X-Source: SMTP:Default MBX-DRESDEN-01
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 32603
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-dresden-01.secunet.de (10.53.40.199) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 22:44:44 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.37 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 22:44:44 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id AFFC220883
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:44:44 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.151
X-Spam-Level:
X-Spam-Status: No, score=3D-5.151 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.1, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d3H_IRq6YVrj for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 22:44:40 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125899-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com 4042420820
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 4042420820
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 22:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9897282B90
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 21:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F554AEF8;
	Sat, 30 Mar 2024 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@redhat.com he=
ader.b=3D"RQ3bReTm"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mime=
cast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0196741AAB
	for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 21:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dnone smtp.client-ip=
=3D170.10.133.124
ARC-Seal: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711835061; cv=3Dnone; b=3DlbgVQwY2hwuNsOlMDigRvxkA1+zvqQCgc0jmBa7F5Gw=
lmoF+5ZfqtTM7UZPubhO30WzKs+w5YwHnoajZoHtislPX59kqvDW9OXUxEuLMp4DPz1foUbt/fY=
ygmOmqyEr2rFpQtPBdfH5sVrWVwQW6Z6Soh8xejKYWqRKlAajX8Ng=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711835061; c=3Drelaxed/simple;
	bh=3DRMUAwxfBL6v+GOWep6RijyAhN1Eu1x5xeC0TGBvfsN8=3D;
	h=3DMessage-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=3DYholoel+uw1wdi51cPhvnLHBY/ACRRuj+C4lbhxLrtZ=
XAtTMk52MG11exdBOiU7lME64P02oZiOUdLSMw9z/KBx5gtSAkxs3epprUaBauFA9+yaokpHO/s=
m9TDeoGo8d+Vj+yRZntwzAaF+rnHPxY5I6J9F9Bdr+QH+epuoAVd0=3D
ARC-Authentication-Results: i=3D1; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dnone dis=3Dnone) header.from=3Dredhat.com; spf=3Dpass smtp.mailfrom=3Dr=
edhat.com; dkim=3Dpass (1024-bit key) header.d=3Dredhat.com header.i=3D@red=
hat.com header.b=3DRQ3bReTm; arc=3Dnone smtp.client-ip=3D170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dnone di=
s=3Dnone) header.from=3Dredhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dpass smtp.mailfrom=
=3Dredhat.com
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dredhat.com;
	s=3Dmimecast20190719; t=3D1711835058;
	h=3Dfrom:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3Dizlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=3D;
	b=3DRQ3bReTmFnqbkB5/ETXTvDsuBtJOCnnd5KHXs2iqSd5GZHYQWGfhQ1ELnoqKUOWFmd0BL2
	4M2+nCELxfLcjsAwgxZkxTF071/mXkkjBy3Z+/DOX0F/D4JljG4iwOLOVjGMKo7hZWSsOv
	uc7AyXoJje4HqGzRY3dzm3G1Iqf+9u0=3D
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=3DTLSv1.3, cipher=3DTLS_AES_256_GCM_SHA384) id
 us-mta-216-w_wd_SvkMyiWGlMvldmNcg-1; Sat, 30 Mar 2024 17:44:15 -0400
X-MC-Unique: w_wd_SvkMyiWGlMvldmNcg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a4e4cebd1c0=
so52249966b.0
        for <linux-kernel@vger.kernel.org>; Sat, 30 Mar 2024 14:44:15 -0700=
 (PDT)
X-Google-DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed;
        d=3D1e100.net; s=3D20230601; t=3D1711835054; x=3D1712439854;
        h=3Dcontent-transfer-encoding:in-reply-to:autocrypt:content-languag=
e
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Dizlk5zYEPtQtitZfD1Xa4239xlrb4zQaz31TSnSFbO8=3D;
        b=3Dtw1oTF+ijs3x0tAH6oNJMsuK5LaE3SO7iMnmI8LG6bfO0Is8iTT7hVGTmSSB16Z=
T0s
         tS/L/TZULM4aJT/XZ+gDOVmsGZ2+6Gp2bb0xWgGSqgMdvnUxhgwPSclhECTvzqDOdL=
jE
         c6eUcKzxWurPVHfutxwA8mu/HCAZPZy0Pod0XdsG5FWeMdU/6Piru0YpoP/JJDCgUJ=
R6
         WJneuzSAXHX4Gy3QxqT1LEvjGbK3kq9glK295zTD2XuEhakzSUK6hmHLn7hgRq52FC=
b5
         0MhshZ4SoVZZwxcTQJ1Nv5rAIS79npCZloEvIe04D5+4THBF1fkrgcsj0LN1tYvFsa=
R8
         4hMw=3D=3D
X-Forwarded-Encrypted: i=3D1; AJvYcCUfdH3f7hEI7zy7tcmoDtJ01IIIpJxJHSqdbxTo6=
UKchjEVG2jDrJHBRIpci1IVsLNBnkR+puf16upPnm1AfqPF+iLVzyw902NX9ET3
X-Gm-Message-State: AOJu0YxPhMMMc/64kjBtL0m+pWPK3ugap47XIAvg1EZ9Y3YtAFa9FbZ=
Y
	7TcWmSW5WDbPDWziX3kSlRrb4MJczwhsPvnw5V4vtTu8/uB+s70XhFl3EHtva6lWrsKRJ8HVXb=
T
	E58k1E6P0zdxoLvTFA2PjmG/kWC5JXK+BSbGgrayHE4hK6KMHsqprIn/+JiWaIA=3D=3D
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17=
090624d700b00a4e1aef2d03mr3493118ejb.69.1711835054361;
        Sat, 30 Mar 2024 14:44:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB4hhnolDV2VDW9ProjEjPrZSmimTTGsoO1Kt1nnLoSJpgt=
tSbznq+JYF5W8Ur6uv2Wrybrg=3D=3D
X-Received: by 2002:a17:906:24d7:b0:a4e:1aef:2d03 with SMTP id f23-20020a17=
090624d700b00a4e1aef2d03mr3493096ejb.69.1711835053917;
        Sat, 30 Mar 2024 14:44:13 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id d6-20020a1709063ec600b00a474=
c3c2f9dsm3458900ejj.38.2024.03.30.14.44.11
        (version=3DTLS1_3 cipher=3DTLS_AES_128_GCM_SHA256 bits=3D128/128);
        Sat, 30 Mar 2024 14:44:13 -0700 (PDT)
Message-ID: <8153674b-1b66-4416-a3b8-b6b7867e77f4@redhat.com>
Date: Sat, 30 Mar 2024 22:44:10 +0100
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/29] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
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
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=3Dpbonzini@redhat.com; keydata=3D
 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3D
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
Content-Type: text/plain; charset=3DUTF-8; format=3Dflowed
Content-Transfer-Encoding: 7bit
Return-Path: linux-kernel+bounces-125899-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 30 Mar 2024 21:44:44.7330
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 4d3e4e5f-576f-48a8-1693-08dc=
51029d1b
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-dr=
esden-01.secunet.de:TOTAL-HUB=3D0.433|SMR=3D0.348(SMRDE=3D0.053|SMRC=3D0.29=
4(SMRCL=3D0.102|X-SMRCR=3D0.294))|CAT=3D0.083(CATOS=3D0.013
 (CATSM=3D0.012(CATSM-Malware
 Agent=3D0.012))|CATRESL=3D0.040(CATRESLP2R=3D0.018)|CATORES=3D0.028
 (CATRS=3D0.028(CATRS-Index Routing Agent=3D0.027)));2024-03-30T21:44:45.14=
3Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-dresden-01.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 21633
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.009|SMR=3D0.008(SMRPI=3D0.006(SMRPI-FrontendProxyAgent=3D0.006))
X-MS-Exchange-Organization-AVStamp-Enterprise: 1.0
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Organization-RulesExecuted: mbx-dresden-01
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AARkXAAAPAAADH4sIAAAAAAAEAO1abXPb=
SHIGJUqiKMv27u
 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
 tU49k1I18iek6YLVM6Igbl4BLOoq2NNcGhyNE8rHeBWDH4qizAul9r
 4l1r18xlXWCKN81yOk0YU5jPFv/hmpxiStONVUtlvKOxybwqFjxIpN
 81RL2iPdKyEY1q/AM9a1lDl6b1SF9mDZs1xIpbBatNw37yuC0pbUFo
 da7TCP+kSzIbgBZay7UsZiVb0rCdi42ITU4KK7UMZYFdRwgowlKoqL
 3hfIUSVHRY5jZQY5L7IGuxesckCYtJu2U0vNPklvNWjV0XDFgrXZh1
 v6TKhEvQ72vJV3AoqBA9l3XptS52EBfXbA4G+4K7p1VrQ45xKWl01f
 TreTGwtlozIyN2Q/o73mVDmhTBvE3NBn5tRvtmPfdtGihqH1FHoKsO
 ttsKF1eaaUU9qRl05TCXcMtU5qsCSGs69tGvlk2fyNfEafC45WrJjD
 jLesP5mim9VdMWx9SUSNhj95E3BUKt+jJrWPY73Ret6sCzcSqlRZNb
 D2ZIcpYACbqtU62FSGxJTpEqxfYXlu6a825uxW7dJkCuW2/KATn3ra
 3qmry90liVCrxZa2O5TxR92rphaTirtX681hhuWgkNJnYLjCbhYYW9
 Nl9jiYJ6xobzZBG0dwmEa3WtRJRgWNAr1w12+m9Mv8lNOo7TsulMnM
 62Xbc1OTca83g0GVM36QIDzmjNGphvGYZvr2l6xCcXJ7pGbdtEaadS
 K/8DLAAsreU3AAABC6cEPD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZG
 luZz0idXRmLTE2Ij8+DQo8VXJsU2V0Pg0KICA8VmVyc2lvbj4xNS4w
 LjAuMDwvVmVyc2lvbj4NCiAgPFVybHM+DQogICAgPFVybCBTdGFydE
 luZGV4PSI4NiIgVHlwZT0iVXJsIj4NCiAgICAgIDxVcmxTdHJpbmc+
 aHR0cHM6Ly9naXRodWIuY29tL2FtZGVzZS9saW51eC9jb21taXRzL3
 NucC1ob3N0LXYxMjwvVXJsU3RyaW5nPg0KICAgIDwvVXJsPg0KICAg
 IDxVcmwgU3RhcnRJbmRleD0iMjc2IiBUeXBlPSJVcmwiPg0KICAgIC
 AgPFVybFN0cmluZz5odHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0v
 MjAyNDAzMjkyMTI0NDQuMzk1NTU5LTEtbWljaGFlbC5yb3RoQGFtZC
 5jb20vPC9VcmxTdHJpbmc+DQogICAgPC9Vcmw+DQogICAgPFVybCBT
 dGFydEluZGV4PSIzOTIiIFR5cGU9IlVybCI+DQogICAgICA8VXJsU3
 RyaW5nPmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0
 L2t2bS9rdm0uZ2l0L2xvZy8/aD1rdm0tY29jby1xdWV1ZTwvVXJsU3
 RyaW5nPg0KICAgIDwvVXJsPg0KICA8L1VybHM+DQo8L1VybFNldD4B
 Ds8BUmV0cmlldmVyT3BlcmF0b3IsMTAsMDtSZXRyaWV2ZXJPcGVyYX
 RvciwxMSwxO1Bvc3REb2NQYXJzZXJPcGVyYXRvciwxMCwwO1Bvc3RE
 b2NQYXJzZXJPcGVyYXRvciwxMSwwO1Bvc3RXb3JkQnJlYWtlckRpYW
 dub3N0aWNPcGVyYXRvciwxMCwzO1Bvc3RXb3JkQnJlYWtlckRpYWdu
 b3N0aWNPcGVyYXRvciwxMSwwO1RyYW5zcG9ydFdyaXRlclByb2R1Y2 VyLDIwLDE1
X-MS-Exchange-Forest-IndexAgent: 1 6690
X-MS-Exchange-Forest-EmailMessageHash: 6E70D1AD
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent

On 3/29/24 23:58, Michael Roth wrote:
> This patchset is also available at:
>=20
>    https://github.com/amdese/linux/commits/snp-host-v12
>=20
> and is based on top of the following series:
>=20
>    [PATCH gmem 0/6] gmem fix-ups and interfaces for populating gmem pages
>    https://lore.kernel.org/kvm/20240329212444.395559-1-michael.roth@amd.c=
om/
>=20
> which in turn is based on:
>=20
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=3Dkvm-coco-queu=
e
>=20
>=20
> Patch Layout
> ------------
>=20
> 01-04: These patches are minor dependencies for this series and will
>         eventually make their way upstream through other trees. They are
>         included here only temporarily.
>=20
> 05-09: These patches add some basic infrastructure and introduces a new
>         KVM_X86_SNP_VM vm_type to handle differences verses the existing
>         KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
>=20
> 10-12: These implement the KVM API to handle the creation of a
>         cryptographic launch context, encrypt/measure the initial image
>         into guest memory, and finalize it before launching it.
>=20
> 13-20: These implement handling for various guest-generated events such
>         as page state changes, onlining of additional vCPUs, etc.
>=20
> 21-24: These implement the gmem hooks needed to prepare gmem-allocated
>         pages before mapping them into guest private memory ranges as
>         well as cleaning them up prior to returning them to the host for
>         use as normal memory. Because this supplants certain activities
>         like issued WBINVDs during KVM MMU invalidations, there's also
>         a patch to avoid duplicating that work to avoid unecessary
>         overhead.
>=20
> 25:    With all the core support in place, the patch adds a kvm_amd modul=
e
>         parameter to enable SNP support.
>=20
> 26-29: These patches all deal with the servicing of guest requests to han=
dle
>         things like attestation, as well as some related host-management
>         interfaces.
>=20
>=20
> Testing
> -------
>=20
> For testing this via QEMU, use the following tree:
>=20
>    https://github.com/amdese/qemu/commits/snp-v4-wip2
>=20
> A patched OVMF is also needed due to upstream KVM no longer supporting MM=
IO
> ranges that are mapped as private. It is recommended you build the AmdSev=
X64
> variant as it provides the kernel-hashing support present in this series:
>=20
>    https://github.com/amdese/ovmf/commits/apic-mmio-fix1c
>=20
> A basic command-line invocation for SNP would be:
>=20
>   qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>    -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>    -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-=
auth=3D
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX6=
4.fd
>=20
> With kernel-hashing and certificate data supplied:
>=20
>   qemu-system-x86_64 -smp 32,maxcpus=3D255 -cpu EPYC-Milan-v2
>    -machine q35,confidential-guest-support=3Dsev0,memory-backend=3Dram1
>    -object memory-backend-memfd,id=3Dram1,size=3D4G,share=3Dtrue,reserve=
=3Dfalse
>    -object sev-snp-guest,id=3Dsev0,cbitpos=3D51,reduced-phys-bits=3D1,id-=
auth=3D,certs-path=3D/home/mroth/cert.blob,kernel-hashes=3Don
>    -bios /home/mroth/ovmf/OVMF_CODE-upstream-20240228-apicfix-1c-AmdSevX6=
4.fd
>    -kernel /boot/vmlinuz-6.8.0-snp-host-v12-wip40+
>    -initrd /boot/initrd.img-6.8.0-snp-host-v12-wip40+
>    -append "root=3DUUID=3Dd72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=
=3DttyS0,115200n8"
>=20
>=20
> Known issues / TODOs
> --------------------
>=20
>   * Base tree in some cases reports "Unpatched return thunk in use. This =
should
>     not happen!" the first time it runs an SVM/SEV/SNP guests. This a rec=
ent
>     regression upstream and unrelated to this series:
>=20
>       https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobw=
fwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/
>=20
>   * 2MB hugepage support has been dropped pending discussion on how we pl=
an
>     to re-enable it in gmem.
>=20
>   * Host kexec should work, but there is a known issue with handling host
>     kdump while SNP guests are running which will be addressed as a follo=
w-up.
>=20
>   * SNP kselftests are currently a WIP and will be included as part of SN=
P
>     upstreaming efforts in the near-term.
>=20
>=20
> SEV-SNP Overview
> ----------------
>=20
> This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
> changes required to add KVM support for SEV-SNP. This series builds upon
> SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
> initialization support, which is now in linux-next.
>=20
> While series provides the basic building blocks to support booting the
> SEV-SNP VMs, it does not cover all the security enhancement introduced by
> the SEV-SNP such as interrupt protection, which will added in the future.
>=20
> With SNP, when pages are marked as guest-owned in the RMP table, they are
> assigned to a specific guest/ASID, as well as a specific GFN with in the
> guest. Any attempts to map it in the RMP table to a different guest/ASID,
> or a different GFN within a guest/ASID, will result in an RMP nested page
> fault.
>=20
> Prior to accessing a guest-owned page, the guest must validate it with a
> special PVALIDATE instruction which will set a special bit in the RMP tab=
le
> for the guest. This is the only way to set the validated bit outside of t=
he
> initial pre-encrypted guest payload/image; any attempts outside the guest=
 to
> modify the RMP entry from that point forward will result in the validated
> bit being cleared, at which point the guest will trigger an exception if =
it
> attempts to access that page so it can be made aware of possible tamperin=
g.
>=20
> One exception to this is the initial guest payload, which is pre-validate=
d
> by the firmware prior to launching. The guest can use Guest Message reque=
sts
> to fetch an attestation report which will include the measurement of the
> initial image so that the guest can verify it was booted with the expecte=
d
> image/environment.
>=20
> After boot, guests can use Page State Change requests to switch pages
> between shared/hypervisor-owned and private/guest-owned to share data for
> things like DMA, virtio buffers, and other GHCB requests.
>=20
> In this implementation of SEV-SNP, private guest memory is managed by a n=
ew
> kernel framework called guest_memfd (gmem). With gmem, a new
> KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
> MMU whether a particular GFN should be backed by shared (normal) memory o=
r
> private (gmem-allocated) memory. To tie into this, Page State Change
> requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
> then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
> private/shared state in the KVM MMU.
>=20
> The gmem / KVM MMU hooks implemented in this series will then update the =
RMP
> table entries for the backing PFNs to set them to guest-owned/private whe=
n
> mapping private pages into the guest via KVM MMU, or use the normal KVM M=
MU
> handling in the case of shared pages where the corresponding RMP table
> entries are left in the default shared/hypervisor-owned state.
>=20
> Feedback/review is very much appreciated!
>=20
> -Mike
>=20
> Changes since v11:
>=20
>   * Rebase series on kvm-coco-queue and re-work to leverage more
>     infrastructure between SNP/TDX series.
>   * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introdu=
ced
>     here (Paolo):
>       https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redh=
at.com/
>   * Drop exposure API fields related to things like VMPL levels, migratio=
n
>     agents, etc., until they are actually supported/used (Sean)
>   * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
>     kvm_gmem_populate() interface instead of copying data directly into
>     gmem-allocated pages (Sean)
>   * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} =
to
>     have simpler semantics that are applicable to management of SNP_LOAD_=
VLEK
>     updates as well, rename interfaces to the now more appropriate
>     SNP_{PAUSE,RESUME}_ATTESTATION
>   * Fix up documentation wording and do print warnings for
>     userspace-triggerable failures (Peter, Sean)
>   * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
>   * Fix a memory leak with VMSA pages (Sean)
>   * Tighten up handling of RMP page faults to better distinguish between =
real
>     and spurious cases (Tom)
>   * Various patch/documentation rewording, cleanups, etc.

I skipped a few patches that deal mostly with AMD ABIs.  Here are the=20
ones that have nontrivial remarks, that are probably be worth a reply=20
before sending v13:

- patch 10: some extra checks on input parameters, and possibly=20
forbidding SEV/SEV-ES ioctls for SEV-SNP guests?

- patch 12: a (hopefully) simple question on boot_vcpu_handled

- patch 18: see Sean's objections at=20
https://lore.kernel.org/lkml/ZeCqnq7dLcJI41O9@google.com/

- patch 22: question on ignoring PSMASH failures and possibly adding a=20
kvm_arch_gmem_invalidate_begin() API.

With respect to the six preparatory patches, I'll merge them in=20
kvm-coco-queue early next week.  However I'll explode the arguments to=20
kvm_gmem_populate(), while also removing "memslot" and merging "src"=20
with "do_memcpy".  I'll post my version very early.

Paolo




