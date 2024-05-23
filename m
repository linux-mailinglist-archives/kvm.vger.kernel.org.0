Return-Path: <kvm+bounces-18045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 625FF8CD264
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69CF51C21896
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69081494C6;
	Thu, 23 May 2024 12:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="Tg7XhoIH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DAF148FEA
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716468140; cv=none; b=So21p4f7RHiRYIfnrzfB+HI6i9nWEPp3jLNc9yeS+6Ld4wrrdhncm84OtkHa4eGSzcgTG3Nfq9mKdz9NpM5kEEaw336tlePc81Yio5TQSyJtaz7JujPjaywY6SMnxCssK510qJEW0ONUIdhVSuSO6MT4Se1aE7E807KgVFl5lPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716468140; c=relaxed/simple;
	bh=U4MP831/hb1ixJbb1U8C6JGQJEg4/rE8FZTtu0IhBAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dOWbO7DYhURfiidpks0sbBvFcoFlDoem64q18qFnlB9HeGdCV4zhU45zaUyO1lOlhfZ2DLrdYJJnkixw/DumKLTQRSNfnr9esA+QT6OLT1AG8QmnU6wszM2QMXgIrJtgGaiVer8CcgaY2/YKMelZyAKLrsmKjjqCk0RfPuUX4ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=Tg7XhoIH; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-792ba098eccso458880685a.2
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 05:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1716468137; x=1717072937; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=u0TO7M+YunjW2XWp159sTlTrU8T1iTyPmvxS8aAeSJU=;
        b=Tg7XhoIHACrJ+Yi6K/1FQHszPfIuorJiwDWkr1nLnQIz/vtB+11c3AcQ76pz2q2utN
         KE3WH0vtj4EAOX4XmHh60iUA9uq9JzxB/2hxMFEjN8tnDHw+2vovWrsQsS02seDCjrEh
         tl0HEYOBhEfOw7Poio7Tx9NWMDDUZzysX1L5w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716468137; x=1717072937;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0TO7M+YunjW2XWp159sTlTrU8T1iTyPmvxS8aAeSJU=;
        b=nAiAPLLtP0f2gkZJPRUl6Irpr0RVNdE7SIGhpF3h8sI64qPxLYSjOAyZcbAJsx5gbB
         WgzHF3N8paRSLXLb5p6VxNBLsI+UbbQ3JXERSVM97U+m/5oFfGHnKgyoAwgrTJMMYyj7
         J6Q/k8ICzS+ZWQcuFvhEUdxld/S7W7Bla2TeeBHadLf0nhJ5gL8LGVJH2iMjfuTc9yZa
         YjPb40U1Y8EvLjkEOUhw7g5F4xlFZIyDu063/6/K8aDKfxpxRTRHVDXE+o8fkZC+3Zek
         vl56lfz/oZgf8HUGf4b0EZ9dAwCCVAVtKIfWCBeq4HHOKFx+iWHlbFerGLrwWtNqrprW
         kDiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbVk14EkvE3qD4heB5pEBDRYCcc3PXBNtDMYZOEDmoToz21HaxqiUTMq1XOcx7ZboLe8o5FUHV1dADO3dbtggtkEWH
X-Gm-Message-State: AOJu0Ywz+ANSTCilb7OFBMl13tElcT4GbFdxpW0jt9Azp/KyEOItbCwE
	l6ZnXQOqk4H6HovPuwjYwc+sV7N+e/QKQ0LVuxamK0RLdy0ej/P/7GXRd6hpwr8eOT3ygwtuZwC
	rO6A=
X-Google-Smtp-Source: AGHT+IE6LURKo3NpFLCHpZprZ836WdrwU50TxnOb6beTJvjxmMIz9dBYSTdfVMB8TZZ0LLBTtRAlQg==
X-Received: by 2002:a05:620a:424e:b0:790:fc5a:1ffd with SMTP id af79cd13be357-794994c0aebmr572293385a.66.1716468136824;
        Thu, 23 May 2024 05:42:16 -0700 (PDT)
Received: from [10.125.231.30] ([217.156.233.157])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2fc57asm1488675685a.81.2024.05.23.05.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 05:42:16 -0700 (PDT)
Message-ID: <771bbaa3-0fa5-4b0a-a0a2-6516b4f42867@citrix.com>
Date: Thu, 23 May 2024 13:42:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
To: Alexandre Chartre <alexandre.chartre@oracle.com>, x86@kernel.org,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com,
 "Kaplan, David" <david.kaplan@amd.com>
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/05/2024 1:33 pm, Alexandre Chartre wrote:
> diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
> index 11c9b8efdc4c..7fa04edc87e9 100644
> --- a/arch/x86/entry/entry_64_compat.S
> +++ b/arch/x86/entry/entry_64_compat.S
> @@ -91,7 +91,6 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>  
>  	IBRS_ENTER
>  	UNTRAIN_RET
> -	CLEAR_BRANCH_HISTORY
>  
>  	/*
>  	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
> @@ -116,6 +115,12 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>  	jnz	.Lsysenter_fix_flags
>  .Lsysenter_flags_fixed:
>  
> +	/*
> +	 * CLEAR_BRANCH_HISTORY can call other functions. It should be invoked
> +	 * after making sure TF is cleared because single-step is ignored only
> +	 * for instructions inside the entry_SYSENTER_compat function.
> +	 */
> +	CLEAR_BRANCH_HISTORY

Exactly the same is true of UNTRAIN_RET, although it will only manifest
in i386 builds running on AMD hardware (SYSENTER is #UD on AMD hardware
in Long mode.)

#DB is IST so does handle it's own speculation safety.  It should be
safe to move all the speculation safety logic in the sysenter handler to
after .Lsysenter_flags_fixed:, I think?

~Andrew

