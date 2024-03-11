Return-Path: <kvm+bounces-11582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE968786A1
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06441C211C1
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12E152F82;
	Mon, 11 Mar 2024 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EoelhMRY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634B551C5C
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710179320; cv=none; b=V4NM827jUxR1VZj5sqbvZ2d9jHAtKm0mkwdJNx8i13TRVWIO+YqWCwOFcQKzUsnJHgK42OZje3UTEorLh8qRYtc6mlHUaLY0CXPpMRLMQrZWjzjXXLF12dBUDKhc6MLBCZ8OGHzqwxOB3Uoml3670XqQ6CZjyqYo+PRGPBUGjrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710179320; c=relaxed/simple;
	bh=L1n1/YHrPlqMMkbS0uthBiig9NG84l+9uiSYaBNVKOc=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LxQQn6bHMAyNRp003NktYzeUwKEE2EON39SB+xAOrWNsxKP/Z9ZoSmjw8ZPcNMk+uFs4TFEG8Lrgzlpc5ZkU6ibSLg1lyaBme78jGH/Slku9nOexwQwdDm7lmY4NMw6GibUytCsR/QVwQM+3sImkhFgqAFyUKwKHC/Ro/k14PAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EoelhMRY; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a2386e932so35250607b3.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710179318; x=1710784118; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BiOP5uhojwXrQMEQN8gcT/txErWrlOzb94LiHfJQtiY=;
        b=EoelhMRYkrEiD+m1LcInBYTmHZlQO4BPxOt/N6278aufBsFXoLC+WhfSioi5kv4Rw/
         wFqk2fDsOqNjnRvvgWF2WRfaSyQlQzwfNl47dcE3QcrH3BZtVUEA6cmVpQud3qus8FU+
         wUokXugrpqR7iksENzBX0lhiEHZ6rIGxg2TdchhDAdhE3Rx+I4sObG/XDona8+QXFCW2
         0wWTpEPFDRkka+GS/SXcg4nvEaKuwZGPX8C3OXUqHtK8J0jjanlAy+O5/YD/BS6wdDvt
         14WoZsR07lwFiXUjeX+wCaWAB8gvBepGkmcBPp2ZZnr/hAlZqzRi9cCp9FltzztjmWiB
         ewPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710179318; x=1710784118;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BiOP5uhojwXrQMEQN8gcT/txErWrlOzb94LiHfJQtiY=;
        b=q8iUdhh2WH/sPLigFnIPWcMFmuf0iuIQykPJx68TQttlC+1pUToq7qY1mWt44It3c/
         W4oD26H5//I18GjsuO1/igb/lHRer+1CZWMBp8DHbBQXNFSuwV/8OcJBbktK7DmYETdx
         TKm4RVlu9WZQIhj5qrSM8zcMJbtO/oiRLqbjKs5eTWrJrhtEgf8A3gK+5GSHU8lodTdn
         gIih2X230y6abF3JK163iJLLYh4qm5EcgwYm8ZaHaKk081s1UkUrC+rdGcWRxoWXhjh6
         RlXrrc2RUgJPPmnWTCdwFQWZxXnDrYwrIp1garbW0yT9O879ROgpsI1rI7vIbyoD/dtE
         Dr7A==
X-Gm-Message-State: AOJu0YyfUEGilgKpT1CTa3p2L/4TrmCT9PDuybHhhbt9tml42xmyJ+xp
	V4OS/wE2Xh99frP16lVz86SwIMdL4NugQy/DBqUgQJiigSBha7BkkND/PFKpFpBfp4+VsdFK+gK
	jEMFwLDmTR40N9Jg51yo9+A==
X-Google-Smtp-Source: AGHT+IGFlAS1WdzxYj387xVx8jJoAYV0MEk2zSj5ce9EnqPrBq6hYHzb4A6q6s61+sDLDrkY8tMPGxgQ8QXCcYndpA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:f8e:b0:609:25d1:ea9a with
 SMTP id df14-20020a05690c0f8e00b0060925d1ea9amr2008993ywb.9.1710179318418;
 Mon, 11 Mar 2024 10:48:38 -0700 (PDT)
Date: Mon, 11 Mar 2024 17:48:37 +0000
In-Reply-To: <Ze6PMRMfIK8z0q4F@thinky-boi> (message from Oliver Upton on Sun,
 10 Mar 2024 21:57:21 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntzfv4slqi.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, ricarkol@google.com, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

>> -		asm volatile("wfi\n"
>> -			     "msr daifclr, #2\n"
>> -			     /* handle IRQ */
>> -			     "msr daifset, #2\n"
>> -			     : : : "memory");
>> +		gic_wfi();
>> +		local_irq_enable();
>> +		isb();
>> +		/* handle IRQ */
>> +		local_irq_disable();

> Sorry, this *still* annoys me. Please move the comment above the ISB,
> you're documenting a behavior that is implied by the instruction, not
> anything else.

Fixing this too. I changed this in the third patch but forgot there
was also an instance in the second.

