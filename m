Return-Path: <kvm+bounces-36243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A72F4A191BB
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 13:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C5651887A2D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 12:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BD2212FA5;
	Wed, 22 Jan 2025 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISwwl5rx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EA5212D74
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 12:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737550246; cv=none; b=MQn9ZG3Xgqc2JImVvYh54P/bI8rvrNodMNlwG/VOqlKSLDV0NgpI/Uw47J3k40NsQflh3u5KevUxZVowuqZ5kymbxb+4uiCIr1yRQgm7+kbbOIyY/YszOeOC9W1TI00BWNg+tuOzCt2MZjBpz+BcVLesVSWh7TyMP63EWoEJhjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737550246; c=relaxed/simple;
	bh=kSgah4fHqDx87RyFN/0CmW9Tco9YIqQ0GRt/q8UwP5w=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=twhlQ0gHb/zpsOqACnjiooVgQVABLxHO8CylC33MprFuM0H2usDQyHsjPOYlUEqzGis+pfRzRUGjBCY6Ic8X7XN+om3DzDK9SJS1MbkLKROPb4YVz2Y2yjrUqspZOt4RekmLmp7NiT2aaqEHpLExo1bGqJ2RPlsyZfEiFKHeeyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISwwl5rx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737550243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LW27o9ibDrBuIqSxNuJafjZNrk+ONiMKEpl5KHoyPA8=;
	b=ISwwl5rxL66xH6r+igC4rvInF0KTUE95xayCtnmRrZzlqASn1lJeB16Yo0BGG6j+cdCDgr
	ES9kQHZvLVd2YQLS6E52S71AJkmHQxV4h2W5gH8vducYWyzASLxUp06pkU1qISKxW1tz6j
	FtH0RG1+/nfqExwbiKlDx9qUNNz3Aog=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-14Y17toAPvOlOW6UfJ2XUA-1; Wed, 22 Jan 2025 07:50:41 -0500
X-MC-Unique: 14Y17toAPvOlOW6UfJ2XUA-1
X-Mimecast-MFC-AGG-ID: 14Y17toAPvOlOW6UfJ2XUA
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ab45150a216so312666766b.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 04:50:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737550240; x=1738155040;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LW27o9ibDrBuIqSxNuJafjZNrk+ONiMKEpl5KHoyPA8=;
        b=rLTjWJFRTF3tuaB2EuVuJiLv7tedKpFxDdDfUr9Wj3nGia6VLBgRbAaLt815t5kcil
         c8wEOXATpVqyZFAYtUa4H0bNPExJitykYwVuvLXF1ArsfrG2/VjTR0OlV+SJhyyQ+ZMK
         7Ddjd3rl+lhz/m0eYtGv2r7o4QC7tMbRDBjB3aAZoq0ows0hCFBmIWdzlo0+Vzh0ojyw
         kHtcblY3Km65uK84H3ekLvzLYsNw4kdN1Q9kqb2W9QXghj9s2aHdcJ169tEtAfp6CEMc
         9PxZqb2QsRhxzxdpIyP4nhI2WvmytQK9JSF4gN4L4PAlXupOIQSWjNE4X3jfJkl5EanH
         R6yg==
X-Forwarded-Encrypted: i=1; AJvYcCUTr3rm7um1TpGNzT20LmWSKWY/WAP+cYP09WLcyM8WzuwqWmbpq0WIzN2PkiXBoBPTk8E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJhp5g3AxKoyCLRO8HU8hlpH0etBkFbWjmujiPmyUoR1ZKDPUw
	cVgSNvBUi1s9OzNSB6qQxZ8RyJMM3m+zBrOctnRLaK1Xmn4MDvtGksuS7E+yY2qLMKSysSlH/er
	oy5I7sq/UfurFOXNCTs/DRIYWR9yl/W1mJIDiEhW2clUrgWNXOw==
X-Gm-Gg: ASbGnctATkJd3h92KOHjSHnp1tnc7aC1g7zhe+eRk4KPJ6z7webEo9im3lbXB4dd8Xu
	w/VeaKk2xRC3Wz8WCMF7vGb+dhv3uMHswfjdDK1ERPJ+SnpviyhBwAjcxus514Lwi5WpXzawJAD
	sTAI+1hrNAmIquyzjK1IZ/yv/+toqBgPzna5Gi3xEZJ5fPQHqMKEUwisoYQ6lMXWv4KzkPOhpPK
	tFmMiEsHx3Jj9M55/9cJCn9427peHWzlRPicPayZb8xTtt+mNs8yKdjeyjDdm0lQaFTjQlPf6E=
X-Received: by 2002:a05:6402:3c7:b0:5d9:f402:16a0 with SMTP id 4fb4d7f45d1cf-5db7d354846mr16219160a12.22.1737550240476;
        Wed, 22 Jan 2025 04:50:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPMz3/AtozZmjLKI6yWqVcx0nJ4GrqAFAJngMHJCEFh39np3XO8C0taSnbHvvtXz/dvZ7PWA==
X-Received: by 2002:a05:6402:3c7:b0:5d9:f402:16a0 with SMTP id 4fb4d7f45d1cf-5db7d354846mr16219138a12.22.1737550240066;
        Wed, 22 Jan 2025 04:50:40 -0800 (PST)
Received: from [192.168.10.47] ([176.206.124.70])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5dbe6de509esm1917155a12.70.2025.01.22.04.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 04:50:39 -0800 (PST)
Message-ID: <41399770-2b1c-4051-9e9a-1acb702f2439@redhat.com>
Date: Wed, 22 Jan 2025 13:50:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/7] KVM: TDX: Add a place holder to handle TDX VM exit
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org, binbin.wu@linux.intel.com
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-2-binbin.wu@linux.intel.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 xsEhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAc0j
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT7CwU0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSTOwE0EVEJx7gEIAMeHcVzuv2bp9HlWDp6+RkZe+vtl
 KwAHplb/WH59j2wyG8V6i33+6MlSSJMOFnYUCCL77bucx9uImI5nX24PIlqT+zasVEEVGSRF
 m8dgkcJDB7Tps0IkNrUi4yof3B3shR+vMY3i3Ip0e41zKx0CvlAhMOo6otaHmcxr35sWq1Jk
 tLkbn3wG+fPQCVudJJECvVQ//UAthSSEklA50QtD2sBkmQ14ZryEyTHQ+E42K3j2IUmOLriF
 dNr9NvE1QGmGyIcbw2NIVEBOK/GWxkS5+dmxM2iD4Jdaf2nSn3jlHjEXoPwpMs0KZsgdU0pP
 JQzMUMwmB1wM8JxovFlPYrhNT9MAEQEAAcLBMwQYAQIACQUCVEJx7gIbDAAKCRB+FRAMzTZp
 sadRDqCctLmYICZu4GSnie4lKXl+HqlLanpVMOoFNnWs9oRP47MbE2wv8OaYh5pNR9VVgyhD
 OG0AU7oidG36OeUlrFDTfnPYYSF/mPCxHttosyt8O5kabxnIPv2URuAxDByz+iVbL+RjKaGM
 GDph56ZTswlx75nZVtIukqzLAQ5fa8OALSGum0cFi4ptZUOhDNz1onz61klD6z3MODi0sBZN
 Aj6guB2L/+2ZwElZEeRBERRd/uommlYuToAXfNRdUwrwl9gRMiA0WSyTb190zneRRDfpSK5d
 usXnM/O+kr3Dm+Ui+UioPf6wgbn3T0o6I5BhVhs4h4hWmIW7iNhPjX1iybXfmb1gAFfjtHfL
 xRUr64svXpyfJMScIQtBAm0ihWPltXkyITA92ngCmPdHa6M1hMh4RDX+Jf1fiWubzp1voAg0
 JBrdmNZSQDz0iKmSrx8xkoXYfA3bgtFN8WJH2xgFL28XnqY4M6dLhJwV3z08tPSRqYFm4NMP
 dRsn0/7oymhneL8RthIvjDDQ5ktUjMe8LtHr70OZE/TT88qvEdhiIVUogHdo4qBrk41+gGQh
 b906Dudw5YhTJFU3nC6bbF2nrLlB4C/XSiH76ZvqzV0Z/cAMBo5NF/w=
In-Reply-To: <20241201035358.2193078-2-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On Sun, Dec 1, 2024 at 4:52 AM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Introduce the wiring for handling TDX VM exits by implementing the
> callbacks .get_exit_info(), and .handle_exit().

Linux 6.14 adds get_entry_info. For lack of a better place, I added it
in this patch when rebasing kvm-coco-queue:

static void vt_get_entry_info(struct kvm_vcpu *vcpu, u32 *intr_info, u32 *error_code)
{
	*intr_info = 0;
	*error_code = 0;

	if (is_td_vcpu(vcpu))
		return;

	vmx_get_entry_info(vcpu, intr_info, error_code);
}

Thanks,

Paolo


