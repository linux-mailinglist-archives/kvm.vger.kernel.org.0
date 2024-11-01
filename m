Return-Path: <kvm+bounces-30272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8249B88D4
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 02:46:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3C71B22176
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 01:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D365B13A258;
	Fri,  1 Nov 2024 01:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hL5dc67r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159585628
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 01:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730425497; cv=none; b=Qepf2qQzEdbdOt0GWIheK475xAxbL5XEMJDJpCY8d6o91nK0GHcdeQvebDm1DX4/mhgEdzlQhK3YdyUYoHBP8Z8908dFsjL+LMKQbPPr3V01j2mr9JZZ9VIoVOYNVfttjriZvcd5Q3pp/hcF/TiAa4Q13YCnM6RwCRN1OW9Yd9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730425497; c=relaxed/simple;
	bh=g2yXyh/XuQDbdRvLq+7Ht6ad5jWCH8+9YqK2Ecn3XOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SMalT8sxzNLN+WwrQ+7EXITS1LQrnmCv2IMd8mO9rE6nuPLltPu3HCSPgFIC0AvPq8etkwFOuhh31kOoObi/sojDUDReAkpwdlamxLCqB8/zX7y83/+9j1LhoME1IIqm8u4/1KUTdLOZWWbf2DprlzlnHH/rx9Xew9mUOz2QJRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hL5dc67r; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20ca4877690so39635ad.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 18:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730425491; x=1731030291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3XP5Wkv+RNW2+r7bEHxQsIWfnBYd0uQeyY2higphAI=;
        b=hL5dc67rtTtM3eA56qsiD2AU8EThdGWnIaQXzeNT6jMvfQ9zp7z5Pzx06DWj8UJ3OW
         AwEWEFRBCmkE7YHHYS7OvjoraJXAiYb6PmJHSc9ZyIs2mR0VFGshp/GLdTOAHJXQRSqf
         OK9NZkThOJ2UAPRdro4wRydw+ssdp5ctQBmV/s4rGbFwJhcU2z0KUFv+gbfDXwHSsBL2
         pi5CPxDEXoWGIQW7FE2oCAPTJeKdtXbuJeH+OHIPo0COhVXE96YQc51i4yPFDfvZ5Xar
         CPYjb6uQq+OH1DZDmEOc56oy9bVoEEdOBSc8lTKpl3uXmhImlsh5mKbEqGHKck8tf68h
         Okww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730425491; x=1731030291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3XP5Wkv+RNW2+r7bEHxQsIWfnBYd0uQeyY2higphAI=;
        b=uR3Sw54Dt/zVZRHepobQhPAMPDz4xJNx+lAgK8xoP1Yr8bbXIDxNHU2ZnT1fdojNRC
         g3NCuSRvZChBI8OU64dCqGIkqJbd6zzoRhpGEnAqEQqQYtj89xX7PQ0ggofstiZaohbu
         bVBKaikU2o4zsBelgQZrR76THVA4heBEiFlulOo/UrGJumDaa6Fxn8+RmRK6x9zZ/fM2
         Q2ogokWDsvadMP+ZeTt0430m8R3vwiVoZeqgUxaoSRfU3r2JImcwPuHZ85JOLv1/EUWe
         AqYC79Ol5KKHeYk3ZZOtWKjeoUCRIA5cAuQKA/sKrnAJzcxjcGUmh4oMKaeJtmYU4XI3
         Z35A==
X-Forwarded-Encrypted: i=1; AJvYcCW0d14G8Sq1kzo7B/zgdOcncmqXX5YaY0j09ysO3/bzFN2SvIKwVJnnCeSl3h+UrUvGIBI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzB3rjguXjuNFJL2gApGvfJr8f/9OYVwUufxznu3w30p3q0NSUg
	MzsOSXQKFT4OEh5vl/sgQkBzya0ow3rRzrQIjnvsjm/kIMlBt/YLphK/ik1B6w==
X-Gm-Gg: ASbGncv36MLWzPsRyQLfyvXx9yXL2nmyj6K7ZF+xPQSgOEmeWhoJUl/J+NweE+W8Fz5
	fWgMdFctD9LtVsYv5YdvjamDv1nE8wxBFniFC7vdlC17iyATXbTc+5PvwGKd4llrCcsKkYak5ml
	xO0Ry2S9IfokXTxyxgCW2O/jdhrgf6YbhTH0eFeU/G0DeEVtLLnedRME8ueKx/U3bS/fBhGRbQY
	lZvGIp6NQnZrbEQZ+RRGtMZ4ry6HkWuiQwLnY47ejRJASDVIc0sfinJIY+xXIObfUQCNUj3vlfR
	IWaKHfxeyUROl7POc06UDoE=
X-Google-Smtp-Source: AGHT+IE5Sl0gNcxBorXKwK80EliT1yn0U0hB4LI9lWcpW0YggnBB9NdstYuNqAFfcfuSQro9x8ORag==
X-Received: by 2002:a17:902:ce91:b0:207:14ca:f0c1 with SMTP id d9443c01a7336-2110427ce3cmr4195975ad.16.1730425490601;
        Thu, 31 Oct 2024 18:44:50 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55d0:1ce2:4bd3:4446:5b60? ([2600:1700:38d4:55d0:1ce2:4bd3:4446:5b60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1e5839sm1799727b3a.68.2024.10.31.18.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 18:44:49 -0700 (PDT)
Message-ID: <d0a38982-b811-4429-8b89-81e5da3aaf72@google.com>
Date: Thu, 31 Oct 2024 18:44:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/26] mm: asi: Make some utility functions noinstr
 compatible
To: Thomas Gleixner <tglx@linutronix.de>,
 Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Alexandre Chartre <alexandre.chartre@oracle.com>,
 Liran Alon <liran.alon@oracle.com>,
 Jan Setje-Eilers <jan.setjeeilers@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>,
 Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
 Khalid Aziz <khalid.aziz@oracle.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>,
 Reiji Watanabe <reijiw@google.com>, Ofir Weisse <oweisse@google.com>,
 Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>,
 KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>,
 Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>,
 x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
 <20240712-asi-rfc-24-v1-1-144b319a40d8@google.com>
 <20241025113455.GMZxuCX2Tzu8ulwN3o@fat_crate.local>
 <CA+i-1C3SZ4FEPJyvbrDfE-0nQtB_8L_H_i67dQb5yQ2t8KJF9Q@mail.gmail.com>
 <ab8ef5ef-f51c-4940-9094-28fbaa926d37@google.com> <878qu6205g.ffs@tglx>
Content-Language: en-US
From: Junaid Shahid <junaids@google.com>
In-Reply-To: <878qu6205g.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 12:12 PM, Thomas Gleixner wrote:
> 
> I doubt that it works as you want it to work.
> 
> +	inline notrace __attribute((__section__(".noinstr.text")))	\
> 
> So this explicitely puts the inline into the .noinstr.text section,
> which means when it is used in .text the compiler will generate an out-of
> line function in the .noinstr.text section and insert a call into the
> usage site. That's independent of the size of the inline.
> 

Oh, that's interesting. IIRC I had seen regular (.text) inline functions get 
inlined into .noinstr.text callers. I assume the difference is that here the 
section is marked explicitly rather than being implicit?

In any case, I guess we could just mark these functions as plain noinstr. 
(Unless there happens to be some other way to indicate to the compiler to place 
any non-inlined copy of the function in .noinstr.text but still allow inlining 
into .text if it makes sense optimization-wise.)

Thanks,
Junaid






