Return-Path: <kvm+bounces-51029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD393AEC165
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 22:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 517177B704B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 20:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E7E2ECD1F;
	Fri, 27 Jun 2025 20:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GPPSekE1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321D225785
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751057156; cv=none; b=bcFLC0jXexlnGj7K0W6yDPHh1cxnzaEDqPA5PICWmX7HX+Px4P+3pMam6GZSFBDJsRW5MIsIUfQuKxVCej6gW/IGsaf/mGcHmGFU6XopnatTfKUbe1Nytk+g042pncwGCD84uoRfcWupxogyc3v76q1eRv6Qqvs0TqSzwkyW6WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751057156; c=relaxed/simple;
	bh=31Dp+CMBRMQ8uN0vaou9SdCDYjiC6hdV62l5ML46Uno=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QwwhyS/bo/qqiCmd56W5cmTPt3Kq33T/PCf7zWI2S9NbGQc43r4CNcwxOJ4xXTZfJ9A0Y+MCymJNgcEKEb3j2vChr5wV9imy6/BSUi3789VjHPasZFjRQr/Z0O0SGvllh1csjGqmPt0mQEauduiakQrlBhk7gUEJNCSVePt2bVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GPPSekE1; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3df2d0b7c7eso3026395ab.2
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 13:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751057153; x=1751661953; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UQtNA0hS1YdwM8TLVBpaF+KBYsznLZdF9AooNXo/LEo=;
        b=GPPSekE1vDPGi2XJnCTME4l2gNLn7mqvF+JNHh9jVDAvjMs/kO158C4pOpMOfwj3tp
         nXVZ9nYNEfMkCajpywJLld7Nmf4/YWaq7cmtW5NJBF3QQAgOiXZ7XGr1ZkqDKjuNNVr6
         bfIchAca0ucovoWjV1CiA2zMhCX1NbtQKZOWMfUitX3tM0hZCW18E6tRDjQgyUEm/y9q
         ZXvmGwmW0ptfgmcN/SQ53FgH9ooQgUcNeBjgAsE6e2WTQwXYe9f4WTxOakQnWTT7jkzG
         byx6hzUh1hzKomegznDcDeeWWrQdJ7g7i19rrxZR/DDwC9mRInlxXjyluqTdaqHdG0il
         LIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751057153; x=1751661953;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQtNA0hS1YdwM8TLVBpaF+KBYsznLZdF9AooNXo/LEo=;
        b=f+9F5t8pWiRG13WL0cCB/7gUTwd/AuDRG7FIsqw0/bc/8qUmi0Xv8LpdKgIhp0m5Hf
         5hyfFkG2QBtii0PhXrJn87BF4KlxpWKjMjhEgLUtcpPzZEL/2wpH90HadggCP/khVKk4
         Hm7tKNbLTEhkjssUHyT9tbCQScRZnngmfEZGyCmWL9VUB0gP9XTzsxl3xe8mUTpO75fB
         o45cz+C6DOL9qJuacmWq2RjfXBNPglZ6DX8gP0eYP27X4FKZzi1Z7BlmAJW28IJOm3XS
         HoZ8yFHJCn2haB0J9Pt0tUbFvUXSUrhFHcsAqWHKrZSnFbIo7ejn0pf1PMByHUOeL+4I
         /9Hw==
X-Gm-Message-State: AOJu0YwD+ukyO1i9hQ3ZdJPnhCQEBZG5cWczPbFLICpEF4wPvxavTF9x
	Y2Z2Ltq0J2JF68KIE8+h+NM2Bs3YkTEffEJK2fCnN8RaTQpANWICV3mN7R/qy+YVXKunpP6SK4f
	I3EiEboJcYR40AW0NRSoB0Mev0Q==
X-Google-Smtp-Source: AGHT+IG8ubvH3kPztAj1ao94LgGUW1XY/gBYCn7CffcpcGKKkMXZJW+TsDn1nh7iOVmLnOgs9jfVsOn7IAe78nE95w==
X-Received: from ilbec16.prod.google.com ([2002:a05:6e02:4710:b0:3dd:77db:e2f7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:12e8:b0:3df:154d:aa60 with SMTP id e9e14a558f8ab-3df4acf7b61mr59890785ab.22.1751057152711;
 Fri, 27 Jun 2025 13:45:52 -0700 (PDT)
Date: Fri, 27 Jun 2025 20:45:51 +0000
In-Reply-To: <86sejlb9ba.wl-maz@kernel.org> (message from Marc Zyngier on Fri,
 27 Jun 2025 14:31:05 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntcyao9am8.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 03/22] KVM: arm64: Define PMI{CNTR,FILTR}_EL0 as undef_access
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	oliver.upton@linux.dev, mizhang@google.com, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	shuah@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Marc. Thanks for the review.

Marc Zyngier <maz@kernel.org> writes:

> On Thu, 26 Jun 2025 21:04:39 +0100,
> Colton Lewis <coltonlewis@google.com> wrote:

>> Because KVM isn't fully prepared to support these yet even though the
>> host PMUv3 driver does, define them as undef_access for now.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/arm64/kvm/sys_regs.c | 3 +++
>>   1 file changed, 3 insertions(+)

>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 76c2f0da821f..99fdbe174202 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -3092,6 +3092,9 @@ static const struct sys_reg_desc sys_reg_descs[] =  
>> {
>>   	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility =  
>> sme_visibility  },
>>   	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility =  
>> fp8_visibility },

>> +	{ SYS_DESC(SYS_PMICNTR_EL0), undef_access },

> $ jq -r --arg FEAT "FEAT_PMUv3_ICNTR" -f ./dumpfeat.jq Features.json
> (FEAT_PMUv3_ICNTR --> v8Ap8)
> (FEAT_PMUv3_ICNTR --> FEAT_PMUv3p9)
> ((FEAT_PMUv3_ICNTR && FEAT_AA64EL2) --> FEAT_FGT2)

> If you have FEAT_PMUv3_ICNTR, then you have FEAT_FGT2. If you have
> FEAT_FGT2, then we already trap and UNDEF PMICNTR_EL0 without any
> further handling since 4bc0fe0898406 ("KVM: arm64: Add sanitisation
> for FEAT_FGT2 registers").

>> +	{ SYS_DESC(SYS_PMICFILTR_EL0), undef_access },

> Same thing.
>> +
>>   	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
>>   	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
>>   	{ PMU_SYS_REG(PMCNTENSET_EL0),

> So none of this is actually required.

Thanks for the context. I'll take this patch out.

