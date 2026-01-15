Return-Path: <kvm+bounces-68235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA6ED27FA8
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0742D308B6A8
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F11F3C0083;
	Thu, 15 Jan 2026 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eutkmsbj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R22dN5Sv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BAE3B8BB3
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501590; cv=none; b=EtDEYNANWo/8DybwTezHDejFHQRherWwL5ialQl5shYgWWqlNxmeleN7wreOfEhDot2GLV7olKfbzAB4lZy24tW1paF1yzMA/OZ5Szna1GYGbczPE+27EDj6y5Tt5YgjCR27/MscxCC0XC5RpN5b7mQMuqpeExFR2rKrVGjPP50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501590; c=relaxed/simple;
	bh=0w7qjlkys/t+zaa2dmz/r3JRm0vyMo31Nn/jlIfk5GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M4XQnhlZVRq3msqJdMcnQwstvOE8qjEylS4iMff9Pm9xTkmoDnT39548QJwipcDAP4IeRjU/qTsYO3syrKimkyTpeOOpXPDaFCn8N1gW8LsCKpJ/JXUu2Gk0KQFnpVqhnWC/mBfCwqRa5FkYNyjYoh24CXdY7hDO9HYRz4cT9Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eutkmsbj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R22dN5Sv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768501587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/4PSeZvb7SjbMj4tci2c4EAiTmFPySPC3Po5tN6+TGM=;
	b=EutkmsbjtWpY0u/yxiZ5M5lqj78nauslOnWrE4aaeC01DwwAhWRIkIIrRfIufa3LlAaTKE
	dAO83dY4UFmrWwxpwXbySu2D2ed6cjK5T82uxceGKb7cdAynhs69lQzTQiTfuVUP6xWP3e
	+TaGio/nuoVonnHkTcodOaGD/DlT9PI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-7jve81HJMV2NOGpYFCeUEw-1; Thu, 15 Jan 2026 13:26:26 -0500
X-MC-Unique: 7jve81HJMV2NOGpYFCeUEw-1
X-Mimecast-MFC-AGG-ID: 7jve81HJMV2NOGpYFCeUEw_1768501585
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b872c88d115so178142366b.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768501585; x=1769106385; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/4PSeZvb7SjbMj4tci2c4EAiTmFPySPC3Po5tN6+TGM=;
        b=R22dN5SvefN9ZXHRHXOwBBpPXYMxNzJkZCsVTXXIWihqHW+6IuftSeqAKv9kKoFF0t
         QOHiUWketlrtp2+zmGg9fJJWiXfyh70bZ/f0nSSi+7rAMnO/M0fGI13PURBGqYnoEJ31
         8pfP4DO+EYZ9gs4yGWdz/dBceyKub8LV3TtYuP0+OFbbg4fBFaWNoRSYMZbFe8IxNLgq
         sv9MCYecPHMNR6kljhFffX5Z8Af/FKA+FtBuIKxf4JyW1WNCIeGzEsvFzMDbR1H1R9ic
         iS05pke37u9PlkBcP8+mkMJXVTdy3ekthFFpJ57AScbGzMbj23zzs1vtxm4Pr9b06mrb
         CYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501585; x=1769106385;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4PSeZvb7SjbMj4tci2c4EAiTmFPySPC3Po5tN6+TGM=;
        b=wLSsXPsyncTW8Fzrw84EdElgDp9Tsp5gXENSRCnmLAu7tm3gz6mJH2oRaMXIcFdivZ
         G6tbKxb5ghA5er4QzBRGKHcf+stG4+zCQXJ/iidadKJYUaCz+pDwc30RVYniVpUlzeXy
         ZWJOsSUh/922fQbwWtrlNkVxtCf8cizM+WhWkkRJvFMIA2XMuPdfUQv2gWIRFjQWfDok
         Y8nASXMObuLK6c/sLJp9OjcHQcwF3jQJ4cSvB9ju+BofvKD3DnAZpGJcB0j/+3EJVc7i
         ZA5XvYvf8Jmt3oO+Wi/MeVJOv/dOgHmCIMgz+IDttlwuZ5YrVFo4tOQPvvdqgVTzH4Bf
         Lvtg==
X-Forwarded-Encrypted: i=1; AJvYcCXTITs42BpHwH+NJYvyr/3flXR9ymizYXwSc9BPkXVFg41YbJfLR4P79dEL8Vz7WyiZPSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHZynLtz52zxCrNCBr+6znX0f38DxctJsOeS5lhusc+j4dMxWM
	U+YrlAmusc3WzEr0flMG0E/48pEzvQUSV2GsOg3Yxpy1UI5WbeTuAGlbaYoeNxjy7g1WebwYf38
	ZrOK2Jath4lButhmhrcyucUWayZZMxVatTAaEOYulJD0000eL6frZ7A==
X-Gm-Gg: AY/fxX5OzKxeUj8xnyzqd3tjngnmlhyvGdVNg3Zr3a+KEikkSqr8u1lQ5sQksFKmwNM
	68pR+4HToZfWQmcApNI/82PwSbwajP5RSsjXXaVQqhPihmatG+SvV5WeUt1kVbS64ne9Kbtsb8b
	jGxZgCMAGGQ53IsvQQNf6VpYUb6u6p/SzFX26h89jFdlkgRCCGsHDor28GIzKnaFDq7vZUSbsAs
	sm5lcuE7mvseUVImjXWbPztvqf8780KPZNwDcbFCvXAMT66l8HUZfUHTwBY+lFNMiuYzMMtlQ6u
	OI75XWRU8DjdPihAivzNnj6d6BFsAkG5QhAR/Z5/4yuM0WnNbGukD+DZjAX3DRtC9MjOMQpw3X7
	I0jzlT4qmvIiD23NjFVTIbQ5T7LgBfOA96F22Epyk1MyJNBvW+BIflEj3QrLSPcbNgsaG/7Bp3T
	OJ5TYL2EJXnlM=
X-Received: by 2002:a17:907:846:b0:b87:6f2:a486 with SMTP id a640c23a62f3a-b8792f79ecdmr47545166b.31.1768501585161;
        Thu, 15 Jan 2026 10:26:25 -0800 (PST)
X-Received: by 2002:a17:907:846:b0:b87:6f2:a486 with SMTP id a640c23a62f3a-b8792f79ecdmr47542466b.31.1768501584718;
        Thu, 15 Jan 2026 10:26:24 -0800 (PST)
Received: from [192.168.1.84] ([93.56.161.93])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-b87959f6e53sm7681666b.47.2026.01.15.10.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 10:26:24 -0800 (PST)
Message-ID: <fcd329da-b24a-484b-85df-c3e1c2616a53@redhat.com>
Date: Thu, 15 Jan 2026 19:26:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
To: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, "Bae, Chang Seok" <chang.seok.bae@intel.com>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
 <cd6721c7-0963-4f4f-89d9-6634b8b559ae@intel.com>
 <8ee84cb9-ef6d-43ac-b9d0-9c22e7d1ecd8@redhat.com>
 <f130ac18-708a-4074-b031-9599006786d3@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <f130ac18-708a-4074-b031-9599006786d3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 19:19, Dave Hansen wrote:
> Is there anything preventing the kernel_fpu_begin() interrupt from
> happening a little later, say:
> 
> 	XFD[18]=0
> 	...
> 	XFD[18]=1
> 	# Interrupt (that does XSAVE)
> 	XRSTOR (no #NM)
> 	
> In that case, the XSAVE in kernel_fpu_begin() "operates as if XINUSE[i]
> = 0" and would set XFEATURES[18]=0; it would save the component as being
> in its init state. The later XRSTOR would obviously restore state 18 to
> its init state.

Yes, absolutely, and the fact that the race window is so small is why 
this issue stayed undetected for years.  In fact, consider that XFD 
becomes a pass-through MSR after the first write, at which point there's 
on race window at all---XFD[18] will be 1 if that's the guest value and 
the state will be destroyed.

I only mentioned SMIs as a way for this to happen on bare metal, i.e. 
without KVM involvement at all (though for dual-monitor treatment 
virtualization _is_ involved).

> That's a long-winded way of saying I think I agree with the patch. It
> destroys the state a bit more aggressively but it doesn't do anything _new_.

Thanks. :)

> What would folks think about making the SDM language stronger, or at
> least explicitly adding the language that setting XFD[i]=1 can lead to
> XINUSE[i] going from 1=>0. Kinda like the language that's already in
> "XRSTOR and the Init and Modified Optimizations", but specific to XFD:
> 
> 	If XFD[i] = 1 and XINUSE[i] = 1, state component i may be
> 	tracked as init; XINUSE[i] may be set to 0.
> 
> That would make it consistent with the KVM behavior. It might also give
> the CPU folks some additional wiggle room for new behavior.
Yes, absolutely.  I think any other hypervisor may want to do the same, 
to avoid save/restores of tile data to when guest XFD[18]=1 (and to 
avoid unnecessary clearing of XFD, just for the sake of storing tile 
data that is most likely unused).

Paolo


