Return-Path: <kvm+bounces-18946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 346A08FD61A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 20:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A59B91F2349B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357AB13AA3F;
	Wed,  5 Jun 2024 18:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yi7qOD43"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC205228
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 18:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717613827; cv=none; b=t9urw5LSYEpTSG/jTvsxLxqS7DnnQCeV5yar7bjyXnMUrjC1qnCwE1q0kbS2oiE0rLFvsB0HKugIj9H16z8IlrJUNNDdLpYh+qFN6434D1PpbrkO1MgdM6BCI5r3GHS/wjBg0ltlCiWFRY+qMYnL7xmfPCOYEugR/zhH5lnV/us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717613827; c=relaxed/simple;
	bh=5zIIt4AbDwIqDg6azuqj6I2To+6q2KO4TXJiL/Owjfs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MrAUoW4zFQlgKNFrhGheYhtBQ2Bxsg2HD7wDnjTKEIRf7rWnagrhuYmdIRnv/CP6q+VghCtBKiUX3gFLQz8S1uHPfu+IIP1hShppKIOKfQMH1N0WHnxgbsx5rKI1di6tMG0+Nd+soWHpZurtEP30ZMxGFrV7Y+Oeb9vxU6Zt3Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yi7qOD43; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so106478a12.3
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 11:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717613825; x=1718218625; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Fm4EAowOR0P7Rb4PgjTwhoVaVYlufFtSZqjfn+LkrU=;
        b=yi7qOD43BmdUsK7ZgChfw3++d8uPzCGEoIBa4ih9VqmG37iGxlwyOMMQvkjF4twrDq
         NDoI8t+HhIsvN2/5GBOzDo5IiURwYwmpspUth7SoQG5Nwww5ZkItUQLBTamhE7MwUjku
         E/5tx+uwHk+k8fqBXsUXgRmerpj8e6khdRi8S3oTtLF/Am8wCYg1/kgnfoiCq96cIiMu
         Z6D/U93rgGh2p+E3zR/QswvSOapwkujHqQ/0FhE2t9pbGfqwcg0wsVh/owsUlBqdSg7m
         0GZxmqPahA/rZ1+UXWUSuAvOJhDq0ysFIGWakC5fioTaTEn2eicFBdHnyTRpCLukNYyB
         SXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717613825; x=1718218625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Fm4EAowOR0P7Rb4PgjTwhoVaVYlufFtSZqjfn+LkrU=;
        b=kifF4OPq8xumYd4860Ov6oBreAsOMKJlZlGxIw+mDeglCjwYepkgeNMEn690PXuDCC
         F9T+Y1tYGjgCMXpsNPk4Nu1nz1tCLaci+rA4zOc80BJlL1B9+c6+5ce8n0ea0+GqQ2BL
         V2i9lBygmLlosrh0vv3lBudF0d4Hzw3Me+ek0QF8Xk0Jrrm5BMa/zPBeYQefUQHgUjFm
         nMUaptSc/EfiAcDZ/reNIVtGVEejhaieLZvs21JTu2zXFit9sVGFGFTcOxe66NsD1Iws
         KbwBCmp5h3zikbfLVmIfBQSLqv5a7TuwXX4752frLq7n5MEJKH4WGM04bdYrQmphPndd
         /IRQ==
X-Gm-Message-State: AOJu0YwfprwPoMYkd5ydlrk1JRnQa0KugK4JMwxoE6L6joWBfLWgw8aM
	3aR/kXw6HmmprwQMAphWztqbeROCbJTYl33WSU75sz31jn5br26WfwSo0IFTseW26RmurL+FbDq
	Ukg==
X-Google-Smtp-Source: AGHT+IEYy2BJzai/JnxtkoVdyjHFX00gy762SPLZuwZjOk2ur8Pwwe/4l39n5XGr0737THlm1Ca+j4WJN2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2442:b0:1f3:453:2c89 with SMTP id
 d9443c01a7336-1f6a5a5e522mr2228595ad.9.1717613825133; Wed, 05 Jun 2024
 11:57:05 -0700 (PDT)
Date: Wed, 5 Jun 2024 11:57:03 -0700
In-Reply-To: <20240122085354.9510-5-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240122085354.9510-1-binbin.wu@linux.intel.com> <20240122085354.9510-5-binbin.wu@linux.intel.com>
Message-ID: <ZmC0_4ZN---IZEdk@google.com>
Subject: Re: [kvm-unit-tests PATCH v6 4/4] x86: Add test case for INVVPID with LAM
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 22, 2024, Binbin Wu wrote:
> +	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)

Checking for feature support seems superfluous, e.g. LA57 should never be set if
it's unsupported.  Then you can do

	lam_mask = is_la57_enabled() ? LAM57_MASK : LAM48_MASK;

> +		lam_mask = LAM57_MASK;
> +
> +	vaddr = alloc_vpage();
> +	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
> +	/*
> +	 * Since the stack memory address in KUT doesn't follow kernel address
> +	 * space partition rule, reuse the memory address for descriptor and
> +	 * the target address in the descriptor of invvpid.
> +	 */
> +	operand = (struct invvpid_operand *)vaddr;

Why bother backing the virtual address?  MOV needs a valid translation, but
INVVPID does not (ditto for INVLPG and INVPCID, though it might be simpler and
easier to just use the allocated address for those).

> +	operand->vpid = 0xffff;
> +	operand->gla = (u64)vaddr;
> +	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
> +								 lam_mask);
> +	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
> +	report(!fault, "INVVPID (LAM on): tagged operand");

