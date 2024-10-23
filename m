Return-Path: <kvm+bounces-29498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A0A9AC969
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53C8C284B8D
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A23A1AB6CB;
	Wed, 23 Oct 2024 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JXhoctH1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA4A1A265D
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729684147; cv=none; b=ja4OlTeKZXTPvvAuOdKprlzr9ZyQMB7TfouAO41CPudQqfZHYxXA5mC5EBF2XkgFgzbG6+QhGGWGyHP/5btXequxKYh1rimP7sCntHcxrKb5jUOdyCP2HKTuBqT3zYhhpl0N+UMymH2mg9it7Qq+UPka1bZVmpdFsi4O+PIDafA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729684147; c=relaxed/simple;
	bh=lnAzdNlv19301PTpnzxOvvebhNg12dbxkYaRPa9fsdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLtEDYW4oOUIsTYyXZKUFLDAlhSWQHLZz5cvYVmKM9+sLWEAB+0pvoMxZXHT8QXvyl5KCoqHxk+6FFiPhJg9tcQXCY26S93F9LdT6typSIKVkgo27ml/kBHKasBvc5rHQRqknJH+PRJzsi2Mrv4B0A9Q77xR6OlCvj+t5pP6+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JXhoctH1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729684144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m6kz830Q6Q2sHJKEQ2L50K5dgcFaGgSdbSQzFqvDar4=;
	b=JXhoctH19SfZ/lZWxxoMklpk/hx1u/tASsnfFmK5pGunv+sRXXTV/3KpMr37yK7bbpw1mM
	ccekHxUrFu80plK9iAGZi8B5aieXfU/8P4J/ebasD7NQIi4ARN0R+hVnUNdgP1tHQfKjnP
	dYZiBxdUWSx1gTLoLix9lQHiwaeAEkI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-sXayAPixPjmEBSDv6zI6tg-1; Wed, 23 Oct 2024 07:49:03 -0400
X-MC-Unique: sXayAPixPjmEBSDv6zI6tg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d45f1e935so3231673f8f.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:49:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729684142; x=1730288942;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m6kz830Q6Q2sHJKEQ2L50K5dgcFaGgSdbSQzFqvDar4=;
        b=XmljDvJuOqLRYxyW+AuT5udRQLP8JQ27DoGoIJggzGCv6bBN967WFx+cxkDqXL7Ml/
         4M9+HymIj+O4qHgDTr1TSZK9xgdKy9PN6NDYmDX3rpLjXQZi2ASQE7Ebw2u/SZerJdzf
         8YiOb1uMza3kqBn5uFjTGk+QD9loAjubgK0oRbqFRAwGw89LJOQZg3WgN9UpwsC1lRXl
         UVTY+gqe5DDd2mTROJEATRk+I7Q0rNcX67mSFzhLUjMecUCtwpD6kV5hOYGtiCrHN+rO
         w/egcAlGUUfD5HT700Qx0akD9bu/wNWiVSJIDKKsiYlPJI+LZadQT77F4KFji3ltFnMV
         ysZw==
X-Forwarded-Encrypted: i=1; AJvYcCVSCmRAMCI1PFaSWSjrtk5fAYftsILMZOa7iRIWdoXgQDMJPa5u4BXAS+BYfUjnrLtVuew=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1D1D/IxGfygWvc+FFxqrH6HWgd/EYYnafbcldkCgYxzkKAZWT
	xPAedHCcAOXghEXSyFavY+OhVpti0DD/po2m+yS4aVvaSo8GgnagidtsWAxPuiq3vYSOQW4saT6
	/icrbYhi4ieTn/nfaNMkKpgJB/pc5WOpl1vXWfx1BLFID6B6ITA==
X-Received: by 2002:a05:6000:1210:b0:374:b6f4:d8d1 with SMTP id ffacd0b85a97d-37efcf0b548mr1498843f8f.13.1729684142120;
        Wed, 23 Oct 2024 04:49:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUT0sp4eH6mOtuL30exiy5cULAfI4w3qDURGhrvTYuy9yPDH5DOXGd77VMq0qcLF48M0XZRA==
X-Received: by 2002:a05:6000:1210:b0:374:b6f4:d8d1 with SMTP id ffacd0b85a97d-37efcf0b548mr1498817f8f.13.1729684141659;
        Wed, 23 Oct 2024 04:49:01 -0700 (PDT)
Received: from [192.168.10.3] ([151.95.144.54])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43186bde267sm14009505e9.13.2024.10.23.04.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 04:49:01 -0700 (PDT)
Message-ID: <8db215c5-4393-4db1-883c-431fed9dfd59@redhat.com>
Date: Wed, 23 Oct 2024 13:48:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] Extend SEV-SNP SVSM support with a kvm_vcpu per
 VMPL
To: Sean Christopherson <seanjc@google.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: roy.hopkins@suse.com, ashish.kalra@amd.com, bp@alien8.de,
 dave.hansen@linux.intel.com, jroedel@suse.de, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 michael.roth@amd.com, mingo@redhat.com, tglx@linutronix.de,
 thomas.lendacky@amd.com, x86@kernel.org
References: <cover.1726506534.git.roy.hopkins@suse.com>
 <6028e1a0fad729f28451782754417b0be3aea7ed.camel@HansenPartnership.com>
 <ZxawyGnWfo378f3S@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZxawyGnWfo378f3S@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 21:51, Sean Christopherson wrote:
> On Fri, Oct 18, 2024, James Bottomley wrote:
>>> I've prepared this series as an extension to the RFC patch series:
>>> 'SEV-SNP support for running an SVSM' posted by Tom Lendacky [1].
>>> This extends the support for transitioning a vCPU between VM
>>> Privilege Levels (VMPLs) by storing the vCPU state for each VMPL in
>>> its own `struct kvm_vcpu`. This additionally allows for separate
>>> APICs for each VMPL.
>>
>> I couldn't attend KVM forum, but I understand based on feedback at a
>> session there, Paolo took the lead to provide an architecture document
>> for this feature, is that correct?
> 
> Yep.
> 
>> Just asking because I haven't noticed anything about this on the list.
> 
> Heh, there's quite a queue of blocked readers (and writers!) at this point ;-)

Well, at least one person had a writer's block instead.

I had it almost ready but then noticed a few hiccups in the design we 
came up with, and have been seating on it for a while.  I'm sending it 
now, finishing the commit messages.

Paolo


