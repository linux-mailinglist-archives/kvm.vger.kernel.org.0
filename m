Return-Path: <kvm+bounces-53005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41747B0C7B0
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCBE61AA5AA3
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776862DECB1;
	Mon, 21 Jul 2025 15:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Qk5npGY6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BDD28F95E
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 15:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753112144; cv=none; b=El05ioTScDUbHlnv6Olr8XHtIuxyvbsPyAhzpWuWAKBehQL8ElSyjPkyDOeqBbhrjuI+VqKj4K6gjLK48s4JYyFYPePUhd2JB5ytHiZnurh6C5SOmS0Rjyd87214e9s3qftnrrgNvo8fNDOHfnXORN49Qx9d+K5ILp0mb+O2JEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753112144; c=relaxed/simple;
	bh=9Iz7gkMAHFXR6uNekq+ZozZJoRu2xaFgWGWBCJlun8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=niXG2ZTFB+ku+OpXmvglpn1u94dz5e/FQPQAaFJnBjMX07zHxz+CzCEUno4gTzQnnrXc3dY2YGFIimHeMyFfnnvEGdYzfbhLrVRp7zx1yipnp32FAdER/5vk5phJNhZ4mc9YQoj/fP6T8U7HZsauII61apo5kjpPReGhgYgeJL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Qk5npGY6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so49271865e9.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 08:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753112140; x=1753716940; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0H9/WAmc1ldaaydaa5FydGQck3U4b6Spe4cq3sfvtO0=;
        b=Qk5npGY69p6bcLi4QglRn0mmtf/wh4ru0FxRDakHK7nZErsZTBbF2HL0sL/PjKt2Lc
         /T6pdj6dbHMOUQOuTz7GXG5KYj05cxNxGWwq9bhqDfQhYHVxPjDJhdF4dpkvufOStJiU
         FtnS8qu+Xw5Q6wjrJqp0fN4IVFkje6VeujJna5QeWtEKBWY44G3AvtiXOkjphvzOZGZc
         XVaAHn8Xp6rykD4q9nzBlyidDjr0JmFzoSbaP6WOK/36hPyLq26ZFC9IV+PKqKsWGSVS
         HEmlantW8ns4Ec3YQ+dGCtiUM5ikvtBWo7EMVDQHNPTOSba/k8fp+R3ddu9jhjaKnULm
         2fCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753112140; x=1753716940;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0H9/WAmc1ldaaydaa5FydGQck3U4b6Spe4cq3sfvtO0=;
        b=wy8Hsy/EyILr36vRmURxd/LZzfrGvNJKYyaUakT9s8j3LDSEnfJhqm1Liy+srAR5HL
         Fl91EDlAvsM6IKdYADAN6c/+7IhUg0qq33LlVttKUdpa65pJpxNACXFIljcxFh0qZb3L
         7JToJqELDqWd6p/cyzgzzY20EbQhvDR6qhFmylaiGcvQuunDEPbf7NEaV+L0AADuJQzo
         BZdWTzRxk33U6td6k9YtWQCiYSVutqg4bgHCzFRICGDAvQsMZ4JXZYTQ4JEvvj+vb1o0
         jWWutCNIygWaSUKxbCItHxIFwIrxobUYjLCZj4gKOTI3jBZJc8pFxiIsy04T89u+zmJo
         3ZVw==
X-Forwarded-Encrypted: i=1; AJvYcCVlGYkX4zX0ksDw5ZPMN05KZrNPf48XIazMhZMJU/99zJ6/14UQcBW/EQmbRC0FouiFI+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxoCNRZtDg91OrHVntq1/+hN4cLkZerU9qXhmzDxOD83q70XtZ
	BDjlp0/t5qmXIe/qq2E5pFxuXBVxTLm0rlYSVksesanTmIQl3XE5Fg1WjGpxh84rS30=
X-Gm-Gg: ASbGncusC95otoXIy+u7w/Ztb5jxvpwPOSn3GIBF3DaLT6oOzUPyT/k92xwkU4lWUJm
	h8gD77Wnt6Pq2RKKf2teMaNBR0dZYhN6KwrOvMMKNpdcy+Qexa5EWkO1prVfEHVvkzgJulvL4zD
	Kxnnj4HdsxukGux/Vb2DjozN/HtYJSecu2nln4Gr/C1akz+HLER7W+RQk0544bC/RmBVN3wq8M2
	QF7koZ5Fy0tTloScWPgZCCF3J4L1/Rv1CvCB17ZWUCsxV+cVs2nmNBZRP5SC1xGwYKXYpWz7gd9
	mad9XE4n7sgZ9meY+/alDTkrTjkfYEYKFJPAku/GhvSds+ihKVWGD1/AOK35hcf6l9GfkF4oLdV
	N5eheCt9ETIEIIchzy8rumlXm1JeGm+4XFfyxt+wiHOVKV+eK4FYytT9oyivkNWNiiJL4oUPmPC
	TOotcl0EOS0wUR6sdIqc4kNjMWkqwnJ7koPx1mopw/lCjBEaz1LcJxYm9719P5kWGlmw==
X-Google-Smtp-Source: AGHT+IG/1MWVAemebTitOKmZq/g9dMUwTU7pG/CAEZvm3VcvBKvsMMZ7l7bsH2e1kdbTGrcpAq+yvw==
X-Received: by 2002:a05:600c:5298:b0:456:15c7:ce90 with SMTP id 5b1f17b1804b1-4562e38a72fmr206995605e9.12.1753112139617;
        Mon, 21 Jul 2025 08:35:39 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e7f2e8csm163861165e9.5.2025.07.21.08.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 08:35:39 -0700 (PDT)
Message-ID: <9c49bd5f-bf40-4a02-9e91-e499134116c6@grsecurity.net>
Date: Mon, 21 Jul 2025 17:35:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/23] Enable CET Virtualization
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com,
 weijiang.yang@intel.com, xin@zytor.com, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20250704085027.182163-1-chao.gao@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 xsDNBF4u6F8BDAC1kCIyATzlCiDBMrbHoxLywJSUJT9pTbH9MIQIUW8K1m2Ney7a0MTKWQXp
 64/YTQNzekOmta1eZFQ3jqv+iSzfPR/xrDrOKSPrw710nVLC8WL993DrCfG9tm4z3faBPHjp
 zfXBIOuVxObXqhFGvH12vUAAgbPvCp9wwynS1QD6RNUNjnnAxh3SNMxLJbMofyyq5bWK/FVX
 897HLrg9bs12d9b48DkzAQYxcRUNfL9VZlKq1fRbMY9jAhXTV6lcgKxGEJAVqXqOxN8DgZdU
 aj7sMH8GKf3zqYLDvndTDgqqmQe/RF/hAYO+pg7yY1UXpXRlVWcWP7swp8OnfwcJ+PiuNc7E
 gyK2QEY3z5luqFfyQ7308bsawvQcFjiwg+0aPgWawJ422WG8bILV5ylC8y6xqYUeSKv/KTM1
 4zq2vq3Wow63Cd/qyWo6S4IVaEdfdGKVkUFn6FihJD/GxnDJkYJThwBYJpFAqJLj7FtDEiFz
 LXAkv0VBedKwHeBaOAVH6QEAEQEAAc0nTWF0aGlhcyBLcmF1c2UgPG1pbmlwbGlAZ3JzZWN1
 cml0eS5uZXQ+wsERBBMBCgA7AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEd7J359B9
 wKgGsB94J4hPxYYBGYYFAmBbH/cCGQEACgkQJ4hPxYYBGYaX/gv/WYhaehD88XjpEO+yC6x7
 bNWQbk7ea+m82fU2x/x6A9L4DN/BXIxqlONzk3ehvW3wt1hcHeF43q1M/z6IthtxSRi059RO
 SarzX3xfXC1pc5YMgCozgE0VRkxH4KXcijLyFFjanXe0HzlnmpIJB6zTT2jgI70q0FvbRpgc
 rs3VKSFb+yud17KSSN/ir1W2LZPK6er6actK03L92A+jaw+F8fJ9kJZfhWDbXNtEE0+94bMa
 cdDWTaZfy6XJviO3ymVe3vBnSDakVE0HwLyIKvfAEok+YzuSYm1Nbd2T0UxgSUZHYlrUUH0y
 tVxjEFyA+iJRSdm0rbAvzpwau5FOgxRQDa9GXH6ie6/ke2EuZc3STNS6EBciJm1qJ7xb2DTf
 SNyOiWdvop+eQZoznJJte931pxkRaGwV+JXDM10jGTfyV7KT9751xdn6b6QjQANTgNnGP3qs
 TO5oU3KukRHgDcivzp6CWb0X/WtKy0Y/54bTJvI0e5KsAz/0iwH19IB0vpYLzsDNBF4u6F8B
 DADwcu4TPgD5aRHLuyGtNUdhP9fqhXxUBA7MMeQIY1kLYshkleBpuOpgTO/ikkQiFdg13yIv
 q69q/feicsjaveIEe7hUI9lbWcB9HKgVXW3SCLXBMjhCGCNLsWQsw26gRxDy62UXRCTCT3iR
 qHP82dxPdNwXuOFG7IzoGBMm3vZbBeKn0pYYWz2MbTeyRHn+ZubNHqM0cv5gh0FWsQxrg1ss
 pnhcd+qgoynfuWAhrPD2YtNB7s1Vyfk3OzmL7DkSDI4+SzS56cnl9Q4mmnsVh9eyae74pv5w
 kJXy3grazD1lLp+Fq60Iilc09FtWKOg/2JlGD6ZreSnECLrawMPTnHQZEIBHx/VLsoyCFMmO
 5P6gU0a9sQWG3F2MLwjnQ5yDPS4IRvLB0aCu+zRfx6mz1zYbcVToVxQqWsz2HTqlP2ZE5cdy
 BGrQZUkKkNH7oQYXAQyZh42WJo6UFesaRAPc3KCOCFAsDXz19cc9l6uvHnSo/OAazf/RKtTE
 0xGB6mQN34UAEQEAAcLA9gQYAQoAIAIbDBYhBHeyd+fQfcCoBrAfeCeIT8WGARmGBQJeORkW
 AAoJECeIT8WGARmGXtgL/jM4NXaPxaIptPG6XnVWxhAocjk4GyoUx14nhqxHmFi84DmHUpMz
 8P0AEACQ8eJb3MwfkGIiauoBLGMX2NroXcBQTi8gwT/4u4Gsmtv6P27Isn0hrY7hu7AfgvnK
 owfBV796EQo4i26ZgfSPng6w7hzCR+6V2ypdzdW8xXZlvA1D+gLHr1VGFA/ZCXvVcN1lQvIo
 S9yXo17bgy+/Xxi2YZGXf9AZ9C+g/EvPgmKrUPuKi7ATNqloBaN7S2UBJH6nhv618bsPgPqR
 SV11brVF8s5yMiG67WsogYl/gC2XCj5qDVjQhs1uGgSc9LLVdiKHaTMuft5gSR9hS5sMb/cL
 zz3lozuC5nsm1nIbY62mR25Kikx7N6uL7TAZQWazURzVRe1xq2MqcF+18JTDdjzn53PEbg7L
 VeNDGqQ5lJk+rATW2VAy8zasP2/aqCPmSjlCogC6vgCot9mj+lmMkRUxspxCHDEms13K41tH
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04.07.25 10:49, Chao Gao wrote:
> The FPU support for CET virtualization has already been merged into the tip
> tree. This v11 adds Intel CET virtualization in KVM and is based on
> tip/master plus Sean's MSR cleanups. For your convenience, it is also
> available at
> 
>   https://github.com/gaochaointel/linux-dev cet-v11
> 
> Changes in v11 (Most changes are suggested by Sean. Thanks!):
> 1. Rebased onto the latest tip tree + Sean's MSR cleanups
> 2. Made patch 1's shortlog informative and accurate
> 3. Slotted in two cleanup patches from Sean (patch 3/4)
> 4. Used KVM_GET/SET_ONE_REG ioctl for userspace to read/write SSP.
>    still assigned a KVM-defined MSR index for SSP but the index isn't
>    part of uAPI now.
> 5. Used KVM_MSR_RET_UNSUPPORTED to reject accesses to unsupported CET MSRs
> 6. Synthesized triple-fault when reading/writing SSP failed during
>    entering into SMM or exiting from SMM
> 7. Removed an inappropriate "quirk" in v10 that advertised IBT to userspace
>    when the hardware supports it but the host does not enable it.
> 8. Disabled IBT/SHSTK explicitly for SVM to avoid them being enabled on
>    AMD CPU accidentally before AMD CET series lands. Because IBT/SHSTK are
>    advertised in KVM x86 common code but only Intel support is added by
>    this series.
> 9. Re-ordered "Don't emulate branch instructions" (patch 18) before
>    advertising CET support to userspace.
> 10.Added consistency checks for CR4.CET and other CET MSRs during VM-entry
>    (patches 22-23)
> 
> [...]

I tested this with your work-in-progress QEMU support branch from [1]
and it worked well on my Alder Lake NUC (i7-1260P).

The host kernel has IBT and user shadow stacks enabled, so does the
guest kernel. KUT CET tests[2] ran fine on the host as well as in the
guest, i.e. nested works too.

Therefore,

Tested-by: Mathias Krause <minipli@grsecurity.net>

[1] https://github.com/gaochaointel/qemu-dev#qemu-cet
[2]
https://lore.kernel.org/kvm/20250626073459.12990-1-minipli@grsecurity.net/

Thanks,
Mathias

