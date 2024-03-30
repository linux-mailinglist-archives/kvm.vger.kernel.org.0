Return-Path: <kvm+bounces-13149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40CB8892CC6
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 20:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2ED31F2315C
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 19:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C062433BD;
	Sat, 30 Mar 2024 19:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ivsqoLEa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F34200D9
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 19:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711826947; cv=none; b=HCaAkcuXhg85w6aYrX6QEBc7q5TUwwqV1G0599JNTWkLvud34ThrQ0dXaCp7rmgMz+kxUV9WRZZN6Q3vH3+2GWy/s+Gmo4+1VrVcVlaehhU5QE6NyFtDMGhh/smR1AicDqUrmD+wd1WiAlk4vjYh2eVrpjCalbA+WuazdQdtWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711826947; c=relaxed/simple;
	bh=svQzHCHWAzJY7vKIICdKjhh9jaM85RqqfFZ0r/q+89k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hgt4Dz0rO6bdhmJwYkAfevpeybjTmBp5fWfxMjNX2GQBTQHaP7JNJFeiK3dsYMTF4itVbGaAubrkB3qOiVNbFTv3EFPHymWSkXJqp1xSIhIC2SSMgFeER/OO1oKkG/WGsbGxepxCVvJv09vLMb03NK16GSpJwI4YzLVa9YXol8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ivsqoLEa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711826943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PZaO6UZD4eKxQJPlCVYZh4cOEQwmdgnhpSX42zJ6FmI=;
	b=ivsqoLEamLPgk6KAo9ddhIt44KqzLU/9vpxtUeakcGIqE1GcFZ8axZfW2A0Klq5OH9w6vj
	LwzE/JblotE10CS3ue2uLRtpyhcl3sMi1avSZVDbMbMz/hqGp8d4K7ZTluGudz+t6w85LB
	ybJ5LPbge4jDuM2Ty1Ojb8vOdT+5IYw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-ZM6BURtWPPCISLubWhcXHw-1; Sat, 30 Mar 2024 15:29:01 -0400
X-MC-Unique: ZM6BURtWPPCISLubWhcXHw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-515d45b24f3so964967e87.0
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 12:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711826940; x=1712431740;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZaO6UZD4eKxQJPlCVYZh4cOEQwmdgnhpSX42zJ6FmI=;
        b=XZPkVS/OLu6NsQHRd6KvEDnE18SS46/24MSwso3jQ/O6ufwHO75qXDrwZdZGUymT2r
         6iOTT6MlFHA4/vSBKvmprKsarHleFggUtdFvrV8r38HMD2ofzm6uS0kvMm9WaigTVUPM
         3VaFCP0zJh5ZsmPQlcdNKUbDaPCxrDaiMbo3dmLGtQgouX/tXtg8dJrellzi85Vz2JYf
         FxrAltL+Yapk7KR/kWefU1Rc8fheHgpjRA7p89HnxS+KzuBmTNsAyGN3278r4aKcyZ3B
         +Ep9TO284bK8wzWtS+dRjryPumRsr0pzkfKVGyDUzavGuTv7JokbMydZVxU5w1p4iW90
         U6gQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe51tZ0x/kqbYarofbRU3MSQMSdHRntM27yFM48UtsIkzCixTl/sJoSuIT1f1m7KXVqmaXqw2zcID+Ci1O5nCpx4p0
X-Gm-Message-State: AOJu0YztiefeoY9PsXpXNZjnOaSOMn36TLn17MbefS9lZpo+Mv+uM+A9
	+7Kdw5EL1P3brq86tcEgmIN6g0DMWJNzRUmsqyOMxNdbYGAJ9J+C6eRYDA4PRkaMGzZPsFdmX5t
	FaSTGN6PjFJn/3UsBzmJrjH0PeTdRn/fXBqDgfWJPIkRD9UdbzA==
X-Received: by 2002:ac2:4e95:0:b0:513:d5bb:3017 with SMTP id o21-20020ac24e95000000b00513d5bb3017mr3570673lfr.36.1711826939901;
        Sat, 30 Mar 2024 12:28:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETWcn309M29ldNyARl5R+qPDZ0V3Erl1H0snBe9+7BpyUQrrJ8JzUkquCV4HqdUnWN7bubKg==
X-Received: by 2002:ac2:4e95:0:b0:513:d5bb:3017 with SMTP id o21-20020ac24e95000000b00513d5bb3017mr3570651lfr.36.1711826939419;
        Sat, 30 Mar 2024 12:28:59 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id q27-20020a170906389b00b00a4e2dc1283asm2570523ejd.50.2024.03.30.12.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 12:28:58 -0700 (PDT)
Message-ID: <3ea21d49-85d8-4631-b94e-6b2fd38a31a8@redhat.com>
Date: Sat, 30 Mar 2024 20:28:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 05/29] KVM: x86: Define RMP page fault error bits for
 #NPF
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
 <20240329225835.400662-6-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-6-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled globally, the hardware places restrictions on
> all memory accesses based on the RMP entry, whether the hypervisor or a
> VM, performs the accesses. When hardware encounters an RMP access
> violation during a guest access, it will cause a #VMEXIT(NPF) with a
> number of additional bits set to indicate the reasons for the #NPF.
> Define those here.
> 
> See APM2 section 16.36.10 for more details.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> [mdr: add some additional details to commit message]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

One nit below.


> ---
>   arch/x86/include/asm/kvm_host.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 90dc0ae9311a..a3f8eba8d8b6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -262,9 +262,12 @@ enum x86_intercept_stage;
>   #define PFERR_FETCH_BIT 4
>   #define PFERR_PK_BIT 5
>   #define PFERR_SGX_BIT 15
> +#define PFERR_GUEST_RMP_BIT 31
>   #define PFERR_GUEST_FINAL_BIT 32
>   #define PFERR_GUEST_PAGE_BIT 33
>   #define PFERR_GUEST_ENC_BIT 34
> +#define PFERR_GUEST_SIZEM_BIT 35
> +#define PFERR_GUEST_VMPL_BIT 36
>   #define PFERR_IMPLICIT_ACCESS_BIT 48
>   
>   #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
> @@ -277,7 +280,10 @@ enum x86_intercept_stage;
>   #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
>   #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
>   #define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
> +#define PFERR_GUEST_RMP_MASK	BIT_ULL(PFERR_GUEST_RMP_BIT)
> +#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(PFERR_GUEST_SIZEM_BIT)
>   #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
> +#define PFERR_GUEST_VMPL_MASK	BIT_ULL(PFERR_GUEST_VMPL_BIT)

Should be kept in either bit order or perhaps alphabetical order 
(probably bit is better).

Paolo

>   #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>   				 PFERR_WRITE_MASK |		\


