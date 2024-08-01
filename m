Return-Path: <kvm+bounces-22975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F1AD945269
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 19:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4D5D1C231A6
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8837D1B9B52;
	Thu,  1 Aug 2024 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1gTXcblx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A49A1B8EA6
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 17:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722535074; cv=none; b=oMuerImR20VDB7HB8zAhHw12fkq22HkRZiV0fsOj0exWlkyaVmlGb+ulXl6p9wqRjl3Kw45S6MOcM+UftIQr7EepcCqQ+aqVnBBH5rqBceZIr8H7mIxmPaas+IVqfc7fO8fa2RvRg3MDbSCuWC4FvDbn5HWa35VPANTBdh2e4Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722535074; c=relaxed/simple;
	bh=RRnVrODlIXwb4KTZdh1i8JoY9YJHVgr4QPTd7lqZ8sc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m7c8pKcg4WEETC/vgaEEzS5JpgU7u2Is9b4QCuePmLcug7LCpPp8O0SfAMy2L+y79tprfmmkGk+jhIrEPyo0PjIdTdo0bgPPIhqFsUoX5Vb5KKwjBv3hgTZ3ea6zJfL0fmsoc5lBsOUrz420/JaUlZKR229WuD1xMKMu/YHYICo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1gTXcblx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb63abe6f7so8782878a91.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 10:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722535073; x=1723139873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YZsjMORWNMLw4A5ZHbitxpDYHrl9my8e/hfGilOpgU0=;
        b=1gTXcblxCkia0kBomrawj1uNO4++9SAjhMjPZ2MuZ8GZuSBaQ93kNnJraAVl2Sw+mO
         kHXERg66AoBKsUYykay5a5tnFOjvW1Ljdnxuxl8BjuIcHumul+uy2YMDZu60vJr6H06E
         d5544MKImHtVM401dgS1KqaPOObb/Ya2ma9/DDTrse2dkX0s1+mCwxODr1A8CdsnNp2Y
         YGeUNz5RpXqygfIwAZheyhepX1NWYP5Yp+l933VJylJiMoVcMZYvjM0woRqTMbM60NyT
         W0fxYTuP8L1JSJbbF4HhbadTzedDKV+HLyEQeBhL8SOGBxn4Hh+rKaZ7zDceEb3oJK4z
         HdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722535073; x=1723139873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZsjMORWNMLw4A5ZHbitxpDYHrl9my8e/hfGilOpgU0=;
        b=H8kUitYqZNlBaZvaN1kvAmf1GI0kQPaLo2JocNjKjQ7kyUjbxGnsbIJUm6qBHnZbIG
         l36cx4mCIrb7mRTtnHHzMHjooMUPbYMtHz/y9FQLl3x0gd+sc/7Dm/YjIXcVPitWVU7g
         P4AarQqLOql6Eo/+lZxHMBacv2ca5zBeCPqCoOjiR6/tC0nLnWpDl7tNbBf9YuYo9K5b
         UixSoLPviNmfSyfwQ/ufluBvCMUhCAJ5UO00vUBUuO1rnbWHNtHJ7Qnii9P8cQ1qgRAR
         J670GLr2sL8qV3fN5WhUSVNvyuomwCwfWvoJg+7FmVaYPkoFzabu1W6WTAzLJCWK37FR
         kAIA==
X-Forwarded-Encrypted: i=1; AJvYcCUnQ11M+MDBjffnNlSXMXgVx54BLQB2WHrR7QmpuNbhuUj1+vaF3Ipi/VKQxDkRZ+KXKlPRsVZE82tJ5VlLJ07zwWiM
X-Gm-Message-State: AOJu0YxBOwDUtbxlsKDJYM/qh5O2qu3x5iKO0UvIcXxU6YjDHoza1TLu
	zhrd8TwtYihWmDQebEzFFzFOLzwKiYK1urzsm2HyTegJz7CE/pptgGpoeYDeYyfevsdd8mSFIji
	45w==
X-Google-Smtp-Source: AGHT+IFR+iUgu+QKJU7dkP2vun0rHsyzYS+V01y7jiTTuZQWqm44psgY1ZYc8q2GM5amzUuj4CJmeyx9mEs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:314a:b0:2cf:6730:9342 with SMTP id
 98e67ed59e1d1-2cff93d3415mr54282a91.1.1722535072537; Thu, 01 Aug 2024
 10:57:52 -0700 (PDT)
Date: Thu, 1 Aug 2024 10:57:51 -0700
In-Reply-To: <20240801173955.1975034-1-ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-3-michael.roth@amd.com> <20240801173955.1975034-1-ackerleytng@google.com>
Message-ID: <ZqvMnz8203fJYr5L@google.com>
Subject: Re: [PATCH] Fixes: f32fb32820b1 ("KVM: x86: Add hook for determining
 max NPT mapping level")
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: michael.roth@amd.com, ak@linux.intel.com, alpergun@google.com, 
	ardb@kernel.org, ashish.kalra@amd.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, dovmurik@linux.ibm.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, vannapurve@google.com, 
	erdemaktas@google.com, jroedel@suse.de, kirill@shutemov.name, 
	kvm@vger.kernel.org, liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, luto@kernel.org, mingo@redhat.com, 
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com, pbonzini@redhat.com, 
	peterz@infradead.org, pgonda@google.com, rientjes@google.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, slp@redhat.com, 
	srinivas.pandruvada@linux.intel.com, tglx@linutronix.de, 
	thomas.lendacky@amd.com, tobin@ibm.com, tony.luck@intel.com, vbabka@suse.cz, 
	vkuznets@redhat.com, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 01, 2024, Ackerley Tng wrote:
> The `if (req_max_level)` test was meant ignore req_max_level if
> PG_LEVEL_NONE was returned. Hence, this function should return
> max_level instead of the ignored req_max_level.
> 

Fixes: ?

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Change-Id: I403898aacc379ed98ba5caa41c9f1c52f277adc2

Bad gerrit, bad!

