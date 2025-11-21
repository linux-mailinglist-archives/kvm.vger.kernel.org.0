Return-Path: <kvm+bounces-64186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C89BC7B38E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:08:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A0CF54EFBC9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA2C30FC3D;
	Fri, 21 Nov 2025 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D3TgW8I6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B793354AEC
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748249; cv=none; b=YyrJVwOdkvd0UVox+BMQjCi9jOinebE8WCT96PTz9gn8LponZCqt1KJJ3Kscelye5sQ0aw+QVzG2lfQWdugTwx69L8IsxfpXzNSbzBo3bAoTSlwf/klqKntl3jHld/CPUsoqM4cr2HeHFDfM/RB9Jj2kr+6ZyV8otdgMEsjUldA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748249; c=relaxed/simple;
	bh=MEJQO4pcHI/6M2OZJqJN6Gd8hIYZnXCggtCKrHQfhpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nfNw9JFlfVuI+N8f7hmpVsjMvCd9x8/XG/U59v0hntMNo4IIAnisiESpm8CYSJWgAChB//Z1/eP9SA121CH+aZrRoR7jT07NI0yW7oEK0/EJzdrubEdG9ESjEXlrj0IDUdAISsKuCWdyZ6Do39fW2pYzLqzAI9kSyjTGhQnC3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D3TgW8I6; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b735e278fa1so464784866b.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763748246; x=1764353046; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fIzxMAUt1tjU6yiKbhOBCNnWrLtrJZ5me+CdVlWDUCo=;
        b=D3TgW8I6qoS6kAxQdiXvyBHVfLQ+fIPKY5aAkZcCcXetqABcX4OUwKHaowLP9podM+
         A4rh+uZPbB/SBfsswEti1kwiLC/DDhGgsygGYOH20PuuYmvwNlWJmj9RZ2a5thD4n9BX
         Lt0W+vPy0UE6hxJNU/KaVJmA68QEupzYODhjIX8I7Z0TljRk0n7yGJeYBbCdC3LzSIdS
         TI6AsA86TRb7GLSiMHZOn6bqH+V9Ysj4XgaggAb6bPGNWXTmy5SMRPG8ircUkZHFKnaL
         45gx04cdMkJybjaoogCti97VEKB1LJU5T3hIzTM+443OYvUpOMazWJphpoccXau41E5x
         KlMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748246; x=1764353046;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIzxMAUt1tjU6yiKbhOBCNnWrLtrJZ5me+CdVlWDUCo=;
        b=WDFAZ41T1d0tFW3wwZS7RXcWrHtGLIEbMPlmN5UK7+qU5vIc861q0t2VlYXMpAUcFM
         JEpJ6rD9wpPG7XmD6vWa4ggh/fGh8Wb9ZN7ckMTKjEYJl2dauxKRdDHs4GkQnqWvBIVB
         iICe8CLTtyw39s/yDcbnv59NmdUG9HXcaq5Arbm28pA30mFCyux8sZTx1vrCTTTxFYp9
         Y0PsfDs2r7the6UTTE4I7sRv8YYa2+QgUvOvrdNHZqLuWh0hRjFX87/nLhUxHJk+YgEx
         LZJefLCDFMXwFo7A2mH1NmgyhB7rH//821wp0qnuEr2SqUTM+0dOBHKny2QjxbO/RzHZ
         tivA==
X-Forwarded-Encrypted: i=1; AJvYcCVnkjBql5utpg+ADSmbf0WzFEUOPsEPRXcih9JBJvYBS9j+TpvKK5yU5F8ukjN5kE9TQYU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbOWGYpWMxO9k6AjOaAhdL3qUJiqhu9XhXQHF5AVjqZpqTc8aO
	1Zgl4rZnMG8Cwl8RTtI9hcY3FmSxcrRFNOLQwbu3o1aeEdxtBP2Za0qrZZJbQWoB7RM=
X-Gm-Gg: ASbGncuGrPL+bc64H7vfZKBGQbfNHQh8qjhaETPPafpW6J6eehWRiL+7cut1T5tvXoZ
	LoLHapyXz23jBGmCKzlQ52MhU+svvM7Vch4QIsWV2SEsVjq1BmvJAQzXQ5UW+n/oTvBTjEzVdHo
	O3Kqnkf3W5OlJkvtwI8axr2Zn9QQ6sSrK3Abz99x+qu80RKcESm+cNkh3EOagxAYF3wsfEUrhsc
	qGwWbEXAWhlYtIwSHFwosKGiYHXx2UwrmOb89kQyN2zqqmDh8QGQW5Qpr8AFFznKfwipSLjBUbE
	1N2SCOeNbMRdmMvn0p08Biay90sARLe0T9OKLVaF6eCm1/3jnsF+gjp7Xxo4qtPIrf1Mz3/BwQA
	tKVqWo6lB1YBUIfW64E9wZsT0JF8lCUCH11nxj4YRd4SuovueR4HgFKFgcjKo7Mbu8dJO2wYDtD
	mOGODNiWQCjgk6qfen0n9Xeee1DZnUYcU6tLkU
X-Google-Smtp-Source: AGHT+IFcfaWFWi2Rf8Lqiip9ctm/vAeWchesaKom/ajf75mzmQnR3wt435G7zkyYEAmFYMiRplv3GA==
X-Received: by 2002:a17:907:969e:b0:b73:9a71:13bb with SMTP id a640c23a62f3a-b76716d9fcdmr327373066b.32.1763748245761;
        Fri, 21 Nov 2025 10:04:05 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd5e0sm548601366b.1.2025.11.21.10.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 10:04:05 -0800 (PST)
Message-ID: <17aef174-3165-41e6-a3f2-d652a56bba63@suse.com>
Date: Fri, 21 Nov 2025 20:04:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/11] x86/vmscape: Override conflicting attack-vector
 controls with =force
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-10-1adad4e69ddc@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-10-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:20, Pawan Gupta wrote:
> vmscape=force option currently defaults to AUTO mitigation. This is not
> correct because attack-vector controls override a mitigation when in AUTO
> mode. This prevents a user from being able to force VMSCAPE mitigation when
> it conflicts with attack-vector controls.
> 
> Kernel should deploy a forced mitigation irrespective of attack vectors.
> Instead of AUTO, use VMSCAPE_MITIGATION_ON that wins over attack-vector
> controls.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

