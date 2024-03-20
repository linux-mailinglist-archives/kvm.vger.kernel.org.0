Return-Path: <kvm+bounces-12311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D16488150B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 16:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D9251F23511
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 15:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEDE65472A;
	Wed, 20 Mar 2024 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NToduvWh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061C53E13
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710950211; cv=none; b=RtJu0bweqLakfQ2qJMbVVyTLG1mJtkr8JdDFrEakCrUUUqZdnmN3pQIj/Cuf2GF+zL8v2TwjYSNtHQf7Sr1rRf4+iLxui270ZMUF/w081XdwnSX4PDNtaoDw2Mti4Rmdp/KGroi3YKM4qu7McjNWSXPJBriLarEh9sw13pDDhHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710950211; c=relaxed/simple;
	bh=bOHKtDEhoXhJows+Igj9EdRp+fNi5RwpCozskNd6TaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OvpMVZRM65n3snVtUNs9BSPztZwdsCgeCGmFvYTDWIQI+fQTtJYRmofU98S0+ehvIMbu3bche/FaoN51o73TFWDKimCDy168ivkG/PxoxRXQjJW63YkaZC4J39SWMCSVHW0u4mOIiVBazKj+0TZW+l6ZQJn7OgUE2G1z+uxP3Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NToduvWh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710950208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qrzp2WX9G4fGi7FWFHFjHhR3/T8Nfe24Fjm+GgjHxDE=;
	b=NToduvWhHTC+My6rg8xWINop1aB6z3oYCE/p9zhe+GH9M6/RLVoqGQhDzJmjTFc/7pr6Wo
	ZdZ0cXz9EZMMLK05M20cjEIp7bco41Psg70lV14yc7TKUAIQv81omTPjf0lNiZyslwaqUK
	o5PPYn8OQ7OzK3zrz0ElCcBmg0tgedA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-Cbs2jbXENHK1W9rnR_C_Qg-1; Wed, 20 Mar 2024 11:56:46 -0400
X-MC-Unique: Cbs2jbXENHK1W9rnR_C_Qg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a469d3547c7so4501466b.0
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710950205; x=1711555005;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qrzp2WX9G4fGi7FWFHFjHhR3/T8Nfe24Fjm+GgjHxDE=;
        b=s7N/e6P+OAJI2JtJFLJMLIXNOz7PKNKRzEXTUYOKQ4Pg1YSDCIYk2EHsY7EXG+AyuK
         3D86kFF4vy/aLwjc4fh6WUUVgRqYnslOBRX/DvXAigH+6DLYx8p2m3hQyDo4Y29hqIJ3
         1lKiBY+UtsJ4QoJ2GyObTFShsJ37Mv6zi+/xayKiPuhtAScTnGpZBKst0ITIQN5pjKcT
         Wz0WdKPOEso7yoqpoXxrCw/d6EDHFH3w6/UqtioNOxlzP+ok700b26nFxyWK7Rkcy2KZ
         E0ZqEU0G6KYpIm0onudToH9QSVuqkqoVA4G7LXArre6IdjnKWZQpdp35veqCvVhTyCIk
         mcaw==
X-Gm-Message-State: AOJu0YwNfQWZytJhwYZVUYLikpCqeemuF9gd0fNd0ayxpo/p2xkVYjTS
	FvqP8owPYhqXi9czX32Qj2JbzMPxZlP8GmbpSlX+98bmOZv4hCcJitES/B2/zGUmpEr+9kAx84i
	oCA7TNTyOcP56KxcCigKZ/RuP62+6PaSs7bGWX4lnPZvNSkuICw==
X-Received: by 2002:a17:906:fd3:b0:a46:d786:3672 with SMTP id c19-20020a1709060fd300b00a46d7863672mr79681ejk.13.1710950205101;
        Wed, 20 Mar 2024 08:56:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFL9lb9JU6u29HDH1ruhW2E+dvTvzRu/d44yRA/zPFQeK1CKRp96jbDh+2Z61dbYWZINepF3A==
X-Received: by 2002:a17:906:fd3:b0:a46:d786:3672 with SMTP id c19-20020a1709060fd300b00a46d7863672mr79667ejk.13.1710950204786;
        Wed, 20 Mar 2024 08:56:44 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id gf9-20020a170906e20900b00a46a27794f6sm5377774ejb.123.2024.03.20.08.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 08:56:42 -0700 (PDT)
Message-ID: <86baf9cb-ba7b-4701-a96d-b34edfe3d1de@redhat.com>
Date: Wed, 20 Mar 2024 16:56:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/49] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for
 memslot
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-10-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
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
In-Reply-To: <20240320083945.991426-10-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:39, Michael Roth wrote:
> +    if (cap_user_memory2 == -1) {
> +        cap_user_memory2 = kvm_check_extension(s, KVM_CAP_USER_MEMORY2);
> +    }
> +
> +    if (!cap_user_memory2 && slot->guest_memfd >= 0) {
> +        error_report("%s, KVM doesn't support KVM_CAP_USER_MEMORY2,"
> +                     " which is required by guest memfd!", __func__);
> +        exit(1);
> +    }

It's easier and more robust (for error reporting purposes) to check both
KVM_CAP_GUEST_MEMFD and KVM_CAP_USER_MEMORY2 at once in the earlier
patches:

-    kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
+    kvm_guest_memfd_supported =
+        kvm_check_extension(s, KVM_CAP_GUEST_MEMFD) &&
+        kvm_check_extension(s, KVM_CAP_USER_MEMORY2);

since KVM cannot really support guest_memfd if it cannot then use it
to create private memory slots.

And then, this one can be changed to also use kvm_guest_memfd_supported:

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e83429b31eb..afcf6f87045 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -284,19 +284,8 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
  {
      KVMState *s = kvm_state;
      struct kvm_userspace_memory_region2 mem;
-    static int cap_user_memory2 = -1;
      int ret;

-    if (cap_user_memory2 == -1) {
-        cap_user_memory2 = kvm_check_extension(s, KVM_CAP_USER_MEMORY2);
-    }
-
-    if (!cap_user_memory2 && slot->guest_memfd >= 0) {
-        error_report("%s, KVM doesn't support KVM_CAP_USER_MEMORY2,"
-                     " which is required by guest memfd!", __func__);
-        exit(1);
-    }
-
      mem.slot = slot->slot | (kml->as_id << 16);
      mem.guest_phys_addr = slot->start_addr;
      mem.userspace_addr = (unsigned long)slot->ram;
@@ -309,7 +298,7 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
           * value. This is needed based on KVM commit 75d61fbc. */
          mem.memory_size = 0;

-        if (cap_user_memory2) {
+        if (kvm_guest_memfd_supported) {
              ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
          } else {
              ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
@@ -319,7 +308,7 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
          }
      }
      mem.memory_size = slot->memory_size;
-    if (cap_user_memory2) {
+    if (kvm_guest_memfd_supported) {
          ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
      } else {
          ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
@@ -331,7 +320,7 @@ err:
                                mem.userspace_addr, mem.guest_memfd,
                                mem.guest_memfd_offset, ret);
      if (ret < 0) {
-        if (cap_user_memory2) {
+        if (kvm_guest_memfd_supported) {
                  error_report("%s: KVM_SET_USER_MEMORY_REGION2 failed, slot=%d,"
                          " start=0x%" PRIx64 ", size=0x%" PRIx64 ","
                          " flags=0x%" PRIx32 ", guest_memfd=%" PRId32 ","
@@ -501,6 +490,7 @@ static int kvm_mem_flags(MemoryRegion *mr)
          flags |= KVM_MEM_READONLY;
      }
      if (memory_region_has_guest_memfd(mr)) {
+        assert(kvm_guest_memfd_supported);
          flags |= KVM_MEM_GUEST_MEMFD;
      }
      return flags;


