Return-Path: <kvm+bounces-57615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 967EEB584FE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 20:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B929F7A8D2D
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9875327E049;
	Mon, 15 Sep 2025 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="YBG5rw33"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FB522D4C8
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757962470; cv=none; b=tU52Z5iKSO7uP3NpZdIdkvJd+GXnZOmBfdiP2rrGivZ9cF2TeXcKIHFNvTIiUn725bVfselTbLKVu7oY+RmdsEGG+a2WSjwD50Uqw/HSx9cAT0wDYXZxyVfnCPobj+A19v+mmsgCkC9UiznPCHLCzJ3lnesnP0LGu4lpTzb19AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757962470; c=relaxed/simple;
	bh=u6gEci3U7ToUTxMXpzqQi213NPpY1v+lR5ozOoaPzqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTdVVvhln7Rnm2OZ98W4bRfWA+QoKuWkPijn8j2kYhqGZPefDodnZAuOTfGa/wX8isigU4r86J8dKKvLRQT7kwhu3l8kPIunn69TSDAGPDajaPIRIAJ8yMT76pL19/LPg8zWZoZRYVobX8KgQx352w7HKE3vx94vRk6F+bcIoUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=YBG5rw33; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-887745ee814so154113439f.3
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 11:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1757962467; x=1758567267; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nHjtmkFYaDUtD28akM0L8ajAhLyVsgYa1W7tKXHErm0=;
        b=YBG5rw33P7E6UxHZcSvygsQEsUVVisKGE0WA/3ClGijmYTzxykCv+Y6vvDy3ucWAwX
         752jUwROUY7ET0FhuTnCkQpyfSsIkWq8Rhj8bqT/qpeqtLuSeSDJ3+oQYZ482q5ynW4L
         mowuBpOsvey9xHQ5r5/BasBgo3OV9qR52kGSdpZUPjr6g792pbhnQX1qp6UbAicld2VV
         Bd4FHZ58jCig0OgrAjwiJK/QzWXu7uaGrPQc1um8LQxwbjLlqth6428asayfj3fW5ynC
         GWo504MrsobqvLpc4Klt6uUQryDhIL+wZ/1iJMx9KM8aUYdkRJY4TcY2gzBtOlCTh4zy
         xxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757962467; x=1758567267;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nHjtmkFYaDUtD28akM0L8ajAhLyVsgYa1W7tKXHErm0=;
        b=jWcUUXMvn27LO/ESdhkAfEGPpe2IwrcDOf1PswnbF1/4I7hnBZYfny8xPsSYaTSBga
         IxeEifCPRaPeTaS3V6stD4ItL17ypyIIhIJqhOypyIDpJaW8ZhtntlQQjpiI0XQu3vZJ
         Sh4L50c6CgSpZ6NmSf+UFRV/NV9JfSJ3eqGLNaWTPqAK0y7K61jcvBwsR9VjUoF8VX/I
         iP15QsUnsNhfgbWxyAhrzatK4V8eRLq4OWLqwo48VsJfJAWqO9qBMS9LOOhPJnR0kDWP
         ZBCL6sY/fsCurm32YWZXE9CzMtAeyy/W1QZMg2XtkVvCDdDM4bp/ZU9XvQqvxRKFNKkg
         A2wA==
X-Forwarded-Encrypted: i=1; AJvYcCWWUa7LDdErGsrJ3f6ddrHm7twnR94lSCjIFM5SsCC5ILCuxqOU3oOhCZOa5mt7TEKZB8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKFYN9wh6Hr0LBwhxX+DIhlpf1W/p+/FiwICp7ryWxJX4OBwUv
	/WBVjY0i4IykEnuQlrTfXHzDH7KUGt4I3+48r066pdgKhtHOzvO2v39QigCi4lpvmmU=
X-Gm-Gg: ASbGncsaZ1pSxQH8jj+u5Bd1M2dmvDXMDxckApteOssqoSdYTVF9X14ZSdNGaL5ff1c
	QuOAmlVzlbX5pDc/PXYeD0Eo85a52czAqGDPtN9lLEsA9d7AdtUbsqxvRECIdatg5wAy8D2xjOp
	aS+YOW9+9bGvI8GTb86M5ID/88c55aTKvrOs7c8CGuR5i+s0Gi2dqxsR7EOrY78xqctCy2qTTGJ
	2iu/rTWYgOFuIFxjYdP58LcMjnrT+C3gwxh05eE6DFvK/HCDdIAnvOOSTA/+CcnLxH/myXJXRQn
	J1xZo2ux9C37CsYxMVfjrEMQKYQXclz3pMhL9MgaLatkouNkEJvlRkJwA9DDagL6zvX0dl36u6T
	xhP9OTMZblF6EvFgPMTgLwA2HjvyRF14fByfZvUekdFwEnA==
X-Google-Smtp-Source: AGHT+IEjr6zGZqacHdWkL3Z8t38AIWoiSVtR9aH1dtfZivjd618GfxmSmMqQ2RxU5i5TL42raRKcFA==
X-Received: by 2002:a05:6e02:1a07:b0:408:c77b:a7ea with SMTP id e9e14a558f8ab-420a417433emr128421475ab.22.1757962467026;
        Mon, 15 Sep 2025 11:54:27 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4240059d880sm24827505ab.20.2025.09.15.11.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 11:54:26 -0700 (PDT)
Date: Mon, 15 Sep 2025 13:54:25 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Jinyu Tang <tjytimi@163.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Conor Dooley <conor.dooley@microchip.com>, 
	Yong-Xuan Wang <yongxuan.wang@sifive.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Nutty Liu <nutty.liu@hotmail.com>, Tianshun Sun <stsmail163@163.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Subject: Re: [PATCH] KVM: riscv: Power on secondary vCPUs from migration
Message-ID: <20250915-23f31d3577fe91c7d9944b1f@orel>
References: <20250915122334.1351865-1-tjytimi@163.com>
 <DCTFU1UCDSZZ.3J6L3T6TYTELM@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DCTFU1UCDSZZ.3J6L3T6TYTELM@ventanamicro.com>

On Mon, Sep 15, 2025 at 04:19:21PM +0200, Radim Krčmář wrote:
> 2025-09-15T20:23:34+08:00, Jinyu Tang <tjytimi@163.com>:
> > The current logic keeps all secondary VCPUs powered off on their
> > first run in kvm_arch_vcpu_postcreate(), relying on the boot VCPU 
> > to wake them up by sbi call. This is correct for a fresh VM start,
> > where VCPUs begin execution at the bootaddress (0x80000000).
> >
> > However, this behavior is not suitable for VCPUs that are being
> > restored from a state (e.g., during migration resume or snapshot
> > load). These VCPUs have a saved program counter (sepc). Forcing
> > them to wait for a wake-up from the boot VCPU, which may not
> > happen or may happen incorrectly, leaves them in a stuck state
> > when using Qemu to migration if smp is larger than one.
> >
> > So check a cold start and a warm resumption by the value of the 
> > guest's sepc register. If the VCPU is running for the first time 
> > *and* its sepc is not the hardware boot address, it indicates a 
> > resumed vCPU that must be powered on immediately to continue 
> > execution from its saved context.
> >
> > Signed-off-by: Jinyu Tang <tjytimi@163.com>
> > Tested-by: Tianshun Sun <stsmail163@163.com>
> > ---
> 
> I don't like this approach.  Userspace controls the state of the VM, and
> KVM shouldn't randomly change the state that userspace wants.
> 
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > @@ -867,8 +867,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >  	struct kvm_cpu_trap trap;
> >  	struct kvm_run *run = vcpu->run;
> >  
> > -	if (!vcpu->arch.ran_atleast_once)
> > +	if (!vcpu->arch.ran_atleast_once) {
> >  		kvm_riscv_vcpu_setup_config(vcpu);
> > +		/*
> > +		 * For VCPUs that are resuming (e.g., from migration)
> > +		 * and not starting from the boot address, explicitly
> > +		 * power them on.
> > +		 */
> > +		if (vcpu->arch.guest_context.sepc != 0x80000000)
> 
> Offlined VCPUs are not guaranteed to have sepc == 0x80000000, so this
> patch would incorrectly wake them up.
> (Depending on vcpu->arch.ran_atleast_once is flaky at best as well.)
> 
> Please try to fix userspace instead,

Yes, and maybe it's already fixed
https://lore.kernel.org/all/20250915070811.3422578-1-xb@ultrarisc.com/

Thanks,
drew

