Return-Path: <kvm+bounces-7503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5312842DB3
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 21:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67F02B24572
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C82671B52;
	Tue, 30 Jan 2024 20:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RwAlFmCQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2652871B45
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 20:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646389; cv=none; b=IlcMAggHgogZE4MJmb0orRDa1qE8RIKC4mtFJeMQ/wO8+Otr9nO6rMQhLsqzZnMC4d7JDp3z1sGTQETSyidNEw1jGE5pI73/QBr6xcMeRc81QXS/DgpRwORPa9qW7Cnpo+YJG+tGkQMrXAsorjcm1NrhPu4j2KBeSWC6tqUEnes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646389; c=relaxed/simple;
	bh=61Oppu3AVzP+KtyffiFkREZRsy7hKLsaEdGCtMFJ2Tg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q/W5uofhLiDfTig0b661I7PxAvY24Vxa/2l9KcC+dBgv2srRNiMldI4IfjBqVJN0W95c2qBfCElNjDkfY+WPi9GaOUk/3AmuI7ABGOEBz/EK0T+gV+c8im1WlOzfblBUpAi1v6gAzn5RKQVamPoMn8Sm3ENodHV6W5KungWBars=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RwAlFmCQ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5f0fd486b9aso63434557b3.2
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 12:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706646387; x=1707251187; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h5pgpMcGME2v9VvnIy7lBJB+U5dgrFCMGRIIdlijbWk=;
        b=RwAlFmCQ55HDCydgjF8LQzYAD7PQJgRLaTcZcCSq/Isv5SP46B1eZuIsgVwVh6V/K6
         RT4rsr+x9jFGcgyhmIb3A/OyS4tIXFlLOZtli/Bp8y0LhzRbTlcVlbcKHjIdvgI0Es/g
         Q/arkx7zDyfk9HAbqjgG3ia+5h9uvm0aBbtvB/iz8wKCKenMCqT5AlKlpmK44HWTrBoA
         4iRuTFtQGbIJdozelUpwZb77CipUKyTEsR9HN5wKwag40ph9GA0BnW0zJqfUtefGTd04
         7nCJcJm5cz9nnXzK24M/ecus9Owetg8ROkBTuoys1AcJdJtgL3wJ5bnL86DFrlG1pmfK
         QHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706646387; x=1707251187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h5pgpMcGME2v9VvnIy7lBJB+U5dgrFCMGRIIdlijbWk=;
        b=AEUTup5+AFJu4U5JSf8dAkfsm10josJV67EiZzYTBUqOA3FZEpazSIkZ/eDFmSJBSI
         b5r0S1V82CXs3egkx1FrMp23VSBcMywmnBQhtna/jL2/aCjJSR2Mnf+vksE/nnVbUBWa
         EU+C+Ihn4F6xxQMRBtx+M3pQXSmBbR9NugCUHNQbSISHgwVZSe6Ud55Ix3P8uFN071Zw
         Wysx/S34yqrxW8Gel+ZnaZyTYkOpNraNsYExs+yoctmqQdB/Mf/jsP/Ct0FbUNIVtor3
         XbMagdvC0M12JyJUJ61zeHs48WsCRMoxv/xuYGhK2ujiRKDhJ5shRwQSWFWTsLgeOqzW
         W1MA==
X-Gm-Message-State: AOJu0Yxy8Ts+CPjr/ZQVb2qF+0EgaUSh1jD8fyOp07YyxuNBokND/Jjh
	CMU+qlEIWXNK0tW0h8j+QP5NbFEwcE45Co4N0NfAZpLGFPPeA2aGCsbcmyuz9jo+5UlBmOKzfnt
	/QQ==
X-Google-Smtp-Source: AGHT+IHckChIdOpRwfbWV8GrXqEqx1z1rCFc0PlXBsdw7+n8o4dfOUWIS0du0dp6kzjap7P3rhIB7Jyts0A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b8b:b0:dc2:3db1:da48 with SMTP id
 ei11-20020a0569021b8b00b00dc23db1da48mr590192ybb.13.1706646387146; Tue, 30
 Jan 2024 12:26:27 -0800 (PST)
Date: Tue, 30 Jan 2024 12:26:25 -0800
In-Reply-To: <20231206170241.82801-12-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231206170241.82801-7-ajones@ventanamicro.com> <20231206170241.82801-12-ajones@ventanamicro.com>
Message-ID: <ZblbcUloeMqc-lR0@google.com>
Subject: Re: [PATCH 5/5] KVM: selftests: x86_64: Remove redundant newlines
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 06, 2023, Andrew Jones wrote:
> @@ -162,7 +162,7 @@ static void check_clocksource(void)
>  		goto out;
>  	}
>  
> -	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
> +	TEST_ASSERT(!strncmp(clk_name, "tsc", st.st_size),

This newline is functionally necessary.  It's in the strncmp() (*#$@ sysfs appends
newlines to everything), not the TEST_ASSERT message.  I'll give you a pass and
fixup when applying since I'm guessing you don't have x86 hardware ;-)

I double checked the other arch patches and didn't see anything sneaky like this.

