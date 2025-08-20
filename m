Return-Path: <kvm+bounces-55114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 426E3B2D969
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D79FA066AA
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56CB2DA769;
	Wed, 20 Aug 2025 09:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SYeUUoBV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F416D2222C7
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 09:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755683498; cv=none; b=ZVno4AkhvqgtMF7KuDkrn7WVc336alw7oWREeQNNu2qDSMvpYyvSiUEB9jQKuVP3uSUlhZqJPfsyjiBq9gg80MOBhJje8YYorGqssB7TXjnZKpN1p0eNKAxkeRwhfK//nzMLtBnyLOVltkUxRqKkmS/JyzHlzPNYPCmBoG/iCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755683498; c=relaxed/simple;
	bh=Pczc+gYj2vSfnt+nJjCrzTSNjuYqaJwvRbHf2boWqUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FTkO/3ZEDpylOx5xDCaMuoWxyNBPfIdha965r8rynPhB8Jm/LzNKt6IGyUODZBGgb9cbwJyoji4la421ygV0ggyZXZfhJ6ZgXWTjxH55LHT7zPijZUMARqDAn/qtVAG78Qg2nrAhPmJUCCErIwt3EQ2vknte9LFoxw+vd2k0rTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SYeUUoBV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755683494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0GUB+HIgF7/xxsP4RdzJyerhYdUR6F5sktWPi0WlPx0=;
	b=SYeUUoBVpd/nPRHPxtE1BSKJBS6PfFTb3sgBChabqQd+a0XrJcWBLd2sKapE7uaztkd9gA
	ErcjayUWQUnM8KMB6AGKePPj+1oscZOL2mp/BLhb+vJAFxtk1HJEGB8WDmqHNYS5mz/Djo
	FMH18dpeVWe4V7BCRjuB6AhSw1KEh9o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-pD3RbyjSNt6_Ifl-Gulq2w-1; Wed, 20 Aug 2025 05:51:32 -0400
X-MC-Unique: pD3RbyjSNt6_Ifl-Gulq2w-1
X-Mimecast-MFC-AGG-ID: pD3RbyjSNt6_Ifl-Gulq2w_1755683491
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0511b3so30843415e9.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 02:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755683491; x=1756288291;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0GUB+HIgF7/xxsP4RdzJyerhYdUR6F5sktWPi0WlPx0=;
        b=FCD3VYroe4/Pm09WDt5Aj8n7umN1m6mbuIEtCwK2OdX6hQD3JxWJIX6ABpoeCHXuUt
         5cjx5RqP1uMQeHnY/9aRuH2J7Cv54l952VwYfGWv3pKO+WpUZU/j4WM2nRKPlkE0Yplj
         nM5ymMomwgdsd1f/3WmXgZ8LpgFGAquG0Cf/WwV4du0fRugjcmm52lO+8h4+HF53o9J2
         IOTn4SwoK3kfRidyrSjmQSFSIlSYZOV/boDd+EpawKnYkTgxx8rvx2avjBI+JMjLMkkm
         AVMD0ENN/YKP7Sprej47hVPqjQD1PHlZJz5y2Sfj7Lc/ND9N/0Py2QgS9MFDuDgCUHuV
         zj/g==
X-Gm-Message-State: AOJu0YwRxUsh7mmeXdmXnxs9wLJO4Atn28tCvwEQqudncyqfww0H6N1l
	j9ABfX7R8dJIcomt1F0GY5AK6kgMGow7NLy6Ew54MspNVa3ZcWwqnbF92btHHH9u0GrXjKUxrn9
	8eA8Ty7tS26W+Z9w3KnCQ177x46yU/xrJekcsH0PJkIZg25RlPpPg2g==
X-Gm-Gg: ASbGncvWjB3J4OC3wTYGrHAoq2V6UZt0ltO49jb9hfYfcl0ZBrkZaCOCmlps1yy+z2y
	JCLBcQVLvmNWFt4v5hPXFd6DFLF91GzxLl2Se8QVqH4MQ7/wOt68PWpbbsUHt7RoLWqbAWxcJJS
	eN9ZaF3zc1Rf04zwj56WatxyEj5mVUnBOza1768vKkRzYc5QagPMVlwqm36uGjdc7D1PxM9zvo0
	uUjvMIvoLWyhix9mlCGUhEDP+VQtQLib5+iRleHT/GovoDuWvNA8j1bQsCW6/qAlzsli21G6KmV
	iPsfBoZn+AamO4iDOy5gDUuwq5USf4picyMILZTy
X-Received: by 2002:a05:600c:3103:b0:456:191b:9e8d with SMTP id 5b1f17b1804b1-45b479b6bb2mr17355475e9.11.1755683491313;
        Wed, 20 Aug 2025 02:51:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEP35Pfv65wKLEW3We9sqvyhHuLNAdDhQHLEWsbXzluyvJY58fsrtfETHG1PbZwAJkL0mprZA==
X-Received: by 2002:a05:600c:3103:b0:456:191b:9e8d with SMTP id 5b1f17b1804b1-45b479b6bb2mr17355125e9.11.1755683490825;
        Wed, 20 Aug 2025 02:51:30 -0700 (PDT)
Received: from [192.168.1.84] ([93.56.169.94])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3c3e673ab01sm576512f8f.18.2025.08.20.02.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 02:51:30 -0700 (PDT)
Message-ID: <78253405-bff8-476c-a505-3737a499151b@redhat.com>
Date: Wed, 20 Aug 2025 11:51:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "Hansen, Dave" <dave.hansen@intel.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "kas@kernel.org" <kas@kernel.org>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
 <farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Williams, Dan J"
 <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
References: <cover.1755126788.git.kai.huang@intel.com>
 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
 <aJ3qhtzwHIRPrLK7@google.com>
 <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
 <aJ4kWcuyNIpCnaXE@google.com>
 <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
 <aJ5vz33PCCqtScJa@google.com>
 <f5101cfa773a5dd89dd40ff9023024f4782b8123.camel@intel.com>
 <acbcfc16-6ccc-4aa8-8975-b33caf36b65f@redhat.com>
 <a418f9758b5817c70f7345c59111b9e78c0deede.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
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
In-Reply-To: <a418f9758b5817c70f7345c59111b9e78c0deede.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/25 23:53, Huang, Kai wrote:
> On Tue, 2025-08-19 at 12:31 +0200, Paolo Bonzini wrote:
>> 2) ... but anyway, KVM is the wrong place to do the test.  If anything,
>> since we need a v7 to change the unnecessary stub, you could move that
>> stub under #ifndef CONFIG_KEXEC_CORE and rename the function to
>> tdx_cpu_flush_cache_for_kexec().
> 
> Agreed on renaming to tdx_cpu_flush_cache_for_kexec().
> 
> But with the "for_kexec()" part in the function name, it already implies
> it is related to kexec, and I kinda think there's no need to test
> IS_ENABLED(CONFIG_KEXEC_CORE) anymore.
> 
> One of the main purpose of this series is to unblock TDX_HOST and KEXEC in
> the Kconfig, since otherwise I've been told distros will simply choose to
> disable TDX_HOST in the Kconfig.  So in reality, I suppose they will be on
> together probably in like 95% cases, if not 100%.
> 
> If we want to test CONFIG_KEXEC_CORE in tdx_cpu_flush_cache_for_kexec(),
> then it would be a little bit weird that why we don't test it in other
> places, e.g., when setting up the boolean.  Testing it in all places would
> make the code unnecessarily long and harder to read.

No I don't mean testing it there, but just making
tdx_cpu_flush_cache_for_kexec() a stub when CONFIG_KEXEC_CORE is
undefined:

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index e9a213582f03..913199b1954b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -217,7 +217,6 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
  u64 tdh_phymem_cache_wb(bool resume);
  u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
  u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
-void tdx_cpu_flush_cache(void);
  #else
  static inline void tdx_init(void) { }
  static inline int tdx_cpu_enable(void) { return -ENODEV; }
@@ -225,8 +224,13 @@ static inline int tdx_enable(void)  { return -ENODEV; }
  static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
  static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
  static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
-static inline void tdx_cpu_flush_cache(void) { }
  #endif	/* CONFIG_INTEL_TDX_HOST */
  
+#ifdef CONFIG_KEXEC_CORE
+void tdx_cpu_flush_cache_for_kexec(void);
+#else
+static inline void tdx_cpu_flush_cache_for_kexec(void) { }
+#endif
+
  #endif /* !__ASSEMBLER__ */
  #endif /* _ASM_X86_TDX_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 93477233baae..376d49ef4472 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -453,7 +453,7 @@ void tdx_disable_virtualization_cpu(void)
  	 * remote CPUs to stop them.  Doing WBINVD in stop_this_cpu()
  	 * could potentially increase the possibility of the "race".
  	 */
-	tdx_cpu_flush_cache();
+	tdx_cpu_flush_cache_for_kexec();
  }
  
  #define TDX_SEAMCALL_RETRIES 10000
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c26e2e07ff6b..cd2a36dbbfc5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1871,7 +1871,7 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
  }
  EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
  
-void tdx_cpu_flush_cache(void)
+void tdx_cpu_flush_cache_for_kexec(void)
  {
  	lockdep_assert_preemption_disabled();
  
@@ -1881,4 +1881,4 @@ void tdx_cpu_flush_cache(void)
  	wbinvd();
  	this_cpu_write(cache_state_incoherent, false);
  }
-EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache);
+EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache_for_kexec);


Personally, I'm totally okay with v6.  But the above change seems
to me like the best way to obey Sean's objection, better than
adding the test in KVM.

Paolo


