Return-Path: <kvm+bounces-24169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7EF3952095
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 18:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F7C71F26A40
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 16:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F291BB6AC;
	Wed, 14 Aug 2024 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RG+MvqsB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280221BB6B8
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723654725; cv=none; b=eh5ucHKw2/O08Z3SWtz7s2EopKlWhzfTsvKU2GFNWu+KwpTRqHdJYePPZJfwtQZYL/WEt++n6V+pZgrTK/rKMxFcW2d+V3zSA8nkcBYwHi1+lNrF/t5qPPW4W1tg00ZWrnb5WXkXucgBl+J94NHcbRxYvzQNeNFBjnGyCgHZJ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723654725; c=relaxed/simple;
	bh=qKb6MmDl5edg/zdjSmAxa04sa8qoMSwIMd3S3sCkkss=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=oka/Uxd9FbM6WC5pozG3hWich5Pr0nl72/J2Q1nsNuynL0O7ORLa6cSLSCcDfu7I+6ENPkNtdtot/jmpv6NEcw0ywKGdzwQLb5nsPcAGhvpeKrR1Kkh2ZI24l9x5o5OV3On4j5+kkbm759nyl8dBKvBALNIlNohLQb5gZMpZBh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RG+MvqsB; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-81f897b8b56so3758639f.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 09:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723654723; x=1724259523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9KUqfXQBECPDE4w6XMInuqE416mNpFRkyplcuKhfWuM=;
        b=RG+MvqsBz+rmOe9pBlD2yaIR/EOn1uTWTbnce1Q5tHtV8e9hl7scDuxIUoSIkoG5WE
         clAUFEKyPUcfZwKabcywBrDr3LYzHpkOrNSu3qeJI5MLG7bwM1Guo9nNBl3rFcNPYSGE
         PhIhOLu3ra/981oDt24/ADCUZS+023UiGQhTsB8bfF++snVp2gK9MUKuth9RL9OJNv+F
         gzbVDijOjTlv2rzOfwHvxofgCS0u9hKBKVKgljOtsVGjEQ3y/CKmVMfQOO+OglbwGvHD
         HaaZI2oUlKj01f5XRnTg9ufqK5sDLdaJorpcXjQWgrrDGTj2t6cwp3DWnuA1JrzK1IlI
         aRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723654723; x=1724259523;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9KUqfXQBECPDE4w6XMInuqE416mNpFRkyplcuKhfWuM=;
        b=vqWkb1LfLtCZdfb2+aD37pGboFqqAvFrMgL2qM40cKXGOUTTNid5iGNSfm+rKwUU5d
         hKv8ASfjvW9Z1RR5NEpIv0SqhTN6RfG0isx0Jt9xE8wOc9Sj3SlcfE/saE24Xfr0PEGh
         FYhYSjPj2mJykz7e3CsrRl5d8D9qk4y0MfBMO4tirdHysJS4xmjwMGoiI5Lb3FcAE7F0
         1Alyqvqh0QuPSXUcIO9tZ+fwLpdSUPKVpjQb46JNI/4172Q/XZjjivtfwEJ9JK9+pV0i
         zO/BfzBx9ZtjiZF3mF9iLgh3Iusnt3OQD5xx8J8rCYaS/jfY0JTytw5GBFzGU8Lmc4HW
         R68Q==
X-Gm-Message-State: AOJu0YzlDdomi+5MXNCkCbjRicmahR0Xidx7VQogGvbxf+oLAc8AHWRQ
	cqBO7O16pHp4sdt81OdutejjKZA7v3v6VVRHxr6ktyaIljNu0k7hbeLAZJi4Tdla/8lBxefTXv5
	rmPqwYm2snHlYHXZKCdw4hg==
X-Google-Smtp-Source: AGHT+IHoTc1x/EneBtFrNuMxs6qdBoUbugPCZqVeCUBO2FwWXSbjgI5VNwqj5nlFfTDM/3m1liVcDNbw6AStzr55rQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:3421:b0:81a:2abb:48a7 with
 SMTP id ca18e2360f4ac-824e76ac13fmr533739f.1.1723654723227; Wed, 14 Aug 2024
 09:58:43 -0700 (PDT)
Date: Wed, 14 Aug 2024 16:58:42 +0000
In-Reply-To: <ZrwCbsBWf3ZxAH3d@google.com> (message from Sean Christopherson
 on Tue, 13 Aug 2024 18:03:42 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntsev79h31.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 0/6] Extend pmu_counters_test to AMD CPUs
From: Colton Lewis <coltonlewis@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, mizhang@google.com, ljr.kernel@gmail.com, 
	jmattson@google.com, aaronlewis@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Aug 13, 2024, Colton Lewis wrote:
>> Sean Christopherson <seanjc@google.com> writes:

>> > On Tue, Aug 13, 2024, Colton Lewis wrote:
>> > > (I was positive I had sent this already, but I couldn't find it on  
>> the
>> > > mailing list to reply to and ask for reviews.)

>> > You did[*], it's sitting in my todo folder.  Two things.

>> > 1. Err on the side of caution when potentially resending, and tag
>> > everything
>> > RESEND.  Someone seeing a RESEND version without having seen the
>> > original version
>> > is no big deal.  But someone seeing two copies of the same
>> > patches/emails can get
>> > quite confusing.

>> Sorry for jumping the gun. I couldn't find the original patches in my
>> email or on the (wrong) list and panicked.

> Ha, no worries.  FWIW, I highly recommend using lore if you can't  
> (quickly) find
> something in your own mailbox.  If it hit a tracked list, lore will have  
> it.  And
> if you use our corporate mail, the retention policy is 18 months unless  
> you go
> out of your way to tag mails to be kept, i.e. lore is more trustworthy in  
> the
> long run.

> https://lore.kernel.org/all/?q=f:coltonlewis@google.com

I did. I have a bookmark for lore, but I now realize that bookmark was
only searching the kvmarm list and this series isn't going to be there
for obvious reasons. I've fixed that.

