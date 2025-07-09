Return-Path: <kvm+bounces-51954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BDAAFEC1C
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A22D21C224EE
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FEB2DBF40;
	Wed,  9 Jul 2025 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XIF7f86V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B6C1EA84
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752071745; cv=none; b=GrRx5o229Cn3a5amgsA5MLLv5N1VPG0mWTcTsZZurCGA1byRJbeOg+5cvw3EaraQGxTkd1j/5KK4eufrVnIX74mQl5c03WbYpsuJw1VLaqA85JXV4Qyq8iAr/3O7IOSRZmIuN1VKLy0XD5/ArHNj05zy1IfDAcMFx4U5XzExv0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752071745; c=relaxed/simple;
	bh=8YdhouPZUQY7P02LpNcD2sAAAo0fpakGafqDHAv2Kc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PB9Z30wl2iTFwfzdrxeUP7omuVyS1zfKa8YjAlY2ekVYycemDaE3dMaAuDu9SIfB+Jus6Kei/uQxK4eH83mbBJgbjI8ciZTcjTo4vKoiGC6pH/niXBFG9bJgCQiAThtQucW7wcZfjIG35VxJTJihYlzrSsN8wUJF6y1uSmPstgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XIF7f86V; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b115fb801bcso6914620a12.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752071743; x=1752676543; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ku2zCzFozPaRS9AkpqL2P6VacMaLZmJzKar7ALrJmU=;
        b=XIF7f86V14osrCebtLebr9kGMH1iXayeAVCvV3iLNXlHYwuwLJbYACFLR3O0jCyMNH
         43kMkZrJ/Lsn7sOBWClrdeOKEXgm8RTNt+II9KZ4q+Xyac5QFoBtu8atXYyZ85BZ9nvm
         rtPhGYpopj9TchxUCuvtPmBRhf+YcY8Cv4XkDf1+SWklnP5E0JRZA60Aef8LoAt3hKMR
         b0aylzwnAcXU21GzXdJlevbJGMtCXNbchXzl5H1pTfx3k0kSR8Qw5+KoCGUN1Vp0qPRN
         UUZ/7Ahh5m5V77/4QwxxesklNhTe20td39VZ7PaP3vV6aZH/ATFv0yZ9r0oP2YI5R9Wp
         hc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752071743; x=1752676543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7ku2zCzFozPaRS9AkpqL2P6VacMaLZmJzKar7ALrJmU=;
        b=hcxWBt0jX8gFJXobVZ1OHeIWHsl0Ln4Dalq9xLA+imqNX3uLoSddzn6xiHTNZY9NIP
         A/nUgkep+tkxuJ8YOzTl4mbxcP1DqLskPGfxNfUcopsX+nHNPdDtB6mybXI5jccruk0E
         DszAgX5QXd49AY0+rS1JcdSyKNYY8nfsTCHu0ELbDkF37l9GBIn0Z1U0lj5XwVEUYuFC
         zgZT7ThoOIhCeX2bOcHctLfmZ106PfskXKiVlBlto4lS3ed7kSAZ4I+Oq2/3YhQP0tTE
         8ltEbNEjgYx0ETC9C5HgtftcwDrKf+tgI1hCjn2HeU0MQCcKfxEsrvTfDAjWn0taNSzc
         Hidg==
X-Forwarded-Encrypted: i=1; AJvYcCVmbdS9NqSdfezu8fOFc/SRZ2RqDoce0G/SoR8j9SDqy0NcUlPkudCifDKwV0emjJRXdzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCJ3yj8LaMCrog93o+eGoVitkywXb5N2FhQMgFY+xGYs96Qp+/
	iwUfO4p1+W62w+XqDEtqxz4XEgVO3xhduVag/zl3PuCCsz2ZHj5e5Vk4qYEgGEu9a64HgWZEB1r
	h2Me7ug==
X-Google-Smtp-Source: AGHT+IE0iW+1i/bebxqmH/aw62RiVT3uR6d207t1zHEY3Yckxx2JH0pCq5Zv8hHrmou0iASKFFw+cYWcpqQ=
X-Received: from pjyd8.prod.google.com ([2002:a17:90a:dfc8:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d06:b0:312:db8f:9a09
 with SMTP id 98e67ed59e1d1-31c2fd00c80mr4781765a91.14.1752071743347; Wed, 09
 Jul 2025 07:35:43 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:35:41 -0700
In-Reply-To: <20250709033242.267892-17-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-17-Neeraj.Upadhyay@amd.com>
Message-ID: <aG5-PV7U2KaZDNGX@google.com>
Subject: Re: [RFC PATCH v8 16/35] x86/apic: Simplify bitwise operations on
 APIC bitmap
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> Use 'regs' as a contiguous linear bitmap for bitwise operations in
> apic_{set|clear|test}_vector(). This makes the code simpler by eliminating

That's very debatable.  I don't find this code to be any simpler.  Quite the
opposite; it adds yet another open coded math exercise, which is so "simple"
that it warrants its own comment to explain what it's doing.

I'm not dead set against this, but I'd strongly prefer to drop this patch.

> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index b7cbe9ba363e..f91d23757375 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -564,19 +564,28 @@ static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
>  	ap->regs64[reg / 8] = val;
>  }
>  
> +static inline unsigned int get_vec_bit(unsigned int vec)
> +{
> +	/*
> +	 * The registers are 32-bit wide and 16-byte aligned.
> +	 * Compensate for the resulting bit number spacing.
> +	 */
> +	return vec + 96 * (vec / 32);
> +}
> +
>  static inline void apic_clear_vector(int vec, void *bitmap)
>  {
> -	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
> +	clear_bit(get_vec_bit(vec), bitmap);
>  }
>  
>  static inline void apic_set_vector(int vec, void *bitmap)
>  {
> -	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
> +	set_bit(get_vec_bit(vec), bitmap);
>  }
>  
>  static inline int apic_test_vector(int vec, void *bitmap)
>  {
> -	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
> +	return test_bit(get_vec_bit(vec), bitmap);
>  }
>  
>  /*
> -- 
> 2.34.1
> 

