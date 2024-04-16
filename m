Return-Path: <kvm+bounces-14742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 737888A6674
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEA961F21A81
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EB838627D;
	Tue, 16 Apr 2024 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZTe5AX4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF40A85C79
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 08:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713257366; cv=none; b=obd+w4aj1PVCcu0LP/FOGUVKAqN2qsLswSWIvtXuLs9C9855/FIWnlWfQZUmbAIfydRSTzTV3Lzgi4rPPtCLFSmqCjuSOT9LxrACap4ti04vwTgA/8YF+bCLGMpzMmky2i4UtxkHZdrbGYnfo1JjVfo+ROGmjkgjrAtBrfrwctE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713257366; c=relaxed/simple;
	bh=9xIdHRnzV2O632j4RhG1uswWHNVqgDuU4PlluAj30g8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ba2ewTYzotR5540V65xSeQYxA4hl3Ve3Yxv3F9kmX8fdT0Tyig5mOqzXCw4u2ncO+e9eGooQwp845z3ZfDkOjXWCOm1NA7Cm3xDxFlPYT+GIqmwK0UboyUovsQk8bQbxCW93GheKhVMB5UtZSojTri71IWHx5NSNdbu6KYtkoI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ZTe5AX4x; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-41884e96f9eso5886865e9.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 01:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1713257362; x=1713862162; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvwae8C2beujv4aHEun0iITe/+EHhljfurmTw9uDoMY=;
        b=ZTe5AX4xwmAR8IG3HCcGKiIqwQqB7rbG7WDYiHrMBLtv+a0L8FGslnmtISDyP2uOQI
         oSlg0k+HcvlOxURWAlKkN78vqGHfgM9d+SRJ+LjOeQ2X2XUkvvDTUT91OBm09TB/La21
         0GZuUX/9HsSKkIMsjUtkEgsVw5nGKWlygd/DiZZj7Ba4k1FQ2WyBw3vXlOqyZMmXM5G+
         OlRZDR4kIHJCA53j06nFShBD1adRN/9TBfUCiAE2wEPROUzphpSceRdgWVvC3ldq3Eu0
         IhD0iX8MjHU1oCZpcJIWQ9zY1irel5pyu0ckVMAjdqlX2Hxi84DHbRu2ZUIKr4YBYhxu
         hLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713257362; x=1713862162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvwae8C2beujv4aHEun0iITe/+EHhljfurmTw9uDoMY=;
        b=L4YElHvmoXZ7gg09TXpXZQ6/m2UwWlj1Xid8z8ufzc8vSYnHObJiyxRI5y3saHJgge
         80YzZXiTaLjYQPiTTAt9jlP3nYR71kxqtGpkEeymHSAmsUfjNLxxQBOVcRb9ksAekE77
         jZaL/wY+vgRwJ57EZh59br7qbLX3KxK0AVJ/L9LqCNgMUatXnY/rSpp4ssryTsY3g29Q
         /u8/DI55SmLX8T84hYOXhgqGzU6oRLSMdVBbbAcj3n4BNboU8ROSwaAaanWE32p64ZjE
         lEsugjUPPzKeZxVmKmvvr2ybnzBe4hn5u4GpiJVzTXgpY8XjoPb4u8OWS1JQP76prqTY
         CRlA==
X-Forwarded-Encrypted: i=1; AJvYcCUmZj/glfYHuK4RRtq+mXXyo7c0omm0YBD7KfWDPpvZjsdcxLfHDqRvj30f+eveyLVKcVIIfjPfhMYbukOGZrS3/AXp
X-Gm-Message-State: AOJu0YyZXd1FZ2UsTzhPJvZcAygZrfG/M2fssW7pfvy6tl58J+asn14t
	Kn3toDl0DcWqPy+CsPnqv3YXjspbkl8OEaM1D/wGpGfve3Az60XNs5UOwmhk6O0=
X-Google-Smtp-Source: AGHT+IERQO7yDpvVx0Ze29NzNiatXbTnAhDW6vGus8ihCC8tUM3/GY995t+6Bsj2kugS44iI1F1GAA==
X-Received: by 2002:a05:600c:45d0:b0:416:3317:5951 with SMTP id s16-20020a05600c45d000b0041633175951mr8879758wmo.6.1713257362109;
        Tue, 16 Apr 2024 01:49:22 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id l16-20020a05600c4f1000b00418729383a4sm5208029wmq.46.2024.04.16.01.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 01:49:21 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:49:20 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	x86@kernel.org
Subject: Re: [PATCH v6 07/24] RISC-V: Use the minor version mask while
 computing sbi version
Message-ID: <20240416-1a9f7ea9700c4c6c3e52a1b1@orel>
References: <20240411000752.955910-1-atishp@rivosinc.com>
 <20240411000752.955910-8-atishp@rivosinc.com>
 <20240415-e229bb33ad53ce43e3534f5a@orel>
 <2a63d7da-91b6-496d-9966-e6c0a0aa6c6c@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a63d7da-91b6-496d-9966-e6c0a0aa6c6c@rivosinc.com>

On Tue, Apr 16, 2024 at 01:31:27AM -0700, Atish Patra wrote:
> On 4/15/24 06:06, Andrew Jones wrote:
> > On Wed, Apr 10, 2024 at 05:07:35PM -0700, Atish Patra wrote:
> > > As per the SBI specification, minor version is encoded in the
> > > lower 24 bits only. Make sure that the SBI version is computed
> > > with the appropriate mask.
> > > 
> > > Currently, there is no minor version in use. Thus, it doesn't
> > > change anything functionality but it is good to be compliant with
> > > the specification.
> > > 
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > ---
> > >   arch/riscv/include/asm/sbi.h | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> > > index f31650b10899..935b082d6a6c 100644
> > > --- a/arch/riscv/include/asm/sbi.h
> > > +++ b/arch/riscv/include/asm/sbi.h
> > > @@ -367,8 +367,8 @@ static inline unsigned long sbi_minor_version(void)
> > >   static inline unsigned long sbi_mk_version(unsigned long major,
> > >   					    unsigned long minor)
> > >   {
> > > -	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) <<
> > > -		SBI_SPEC_VERSION_MAJOR_SHIFT) | minor;
> > > +	return ((major & SBI_SPEC_VERSION_MAJOR_MASK) << SBI_SPEC_VERSION_MAJOR_SHIFT
> > > +		| (minor & SBI_SPEC_VERSION_MINOR_MASK));
> > 
> > The previous version had ((major & major_mask) << major_shift) | minor
> > (parentheses around all the major bits before the OR). Now we have
> > parentheses around everything, which aren't necessary, and no longer
> 
> We have to use parentheses around | to avoid compiler warnings
> (-Wparentheses)
> 
> Are you only concerned about the outer parentheses ? I have removed it.
> 
> > have them around all the major bits before the OR. We don't need the
> > parentheses around the major bits, since shift has higher precedence
> > than OR, but I'd probably keep them.
> > 
> 
> Is this what you prefer?
> 
> return ((major & SBI_SPEC_VERSION_MAJOR_MASK) <<
> SBI_SPEC_VERSION_MAJOR_SHIFT) | (minor & SBI_SPEC_VERSION_MINOR_MASK);

Yup

Thanks,
drew

> 
> 
> 
> 
> > Otherwise,
> > 
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > 
> > >   }
> > >   int sbi_err_map_linux_errno(int err);
> > > -- 
> > > 2.34.1
> > > 
> > 
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
> 

