Return-Path: <kvm+bounces-8145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3023B84BEC7
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CC881C23C90
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D5901B946;
	Tue,  6 Feb 2024 20:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="btVILNSJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCD41B807
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 20:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707251785; cv=none; b=eJblLTfKpETuI7j+NI60a96jnzwYe9BVT9obPVkMPzIgJ0GKqD95lrXdZfhoeATaCJ3UbWliQMQH4B3zoVxFagtNrHdPw4iiO+dLUDmaUq4kwFGuVPBgPLhog4zZ9q/bPxqCloo4GRvbf45T+tpSe/D8oDhaH7mUne9QrSs1b6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707251785; c=relaxed/simple;
	bh=se8P+Bqy2T9rM626GcSkDCI8mK7oGhCqfOiPGu9wZkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=X+80P48EBedkSWxoqufz+CoWuvXL0Au0D3kLPB5WKNV55bI/9VS6SEhP6qrtMfkP+OObMfmMjkrxNKoRQDEhLjlejChAnKVo+6DRIBt+PfMmaKpDjcvjs2aYqJ1Rqy/FxfYA1Lb2SVAX/L41dw2pGUiDWwrD7vBfD51A/BkUoDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=btVILNSJ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5ce632b2adfso6096542a12.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 12:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707251784; x=1707856584; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jzwz3V63szJHlExhCZvPC7c2dtOM+k/FDHvQAaa+NEw=;
        b=btVILNSJbLhDX+8sChHwWXByUoczQaX1QsEtBu3tcptnNHaUHbwI9JyOPuBddk4WP9
         7dsjrsiAMdTYpi86RAUDECKLc+qWFM7B4KIPjVkrHBTdMb6r0+VavfWfGzcpRVL5wVd5
         3MdnDCl0vmhrVvEzRYM484Pjm6zYt/Cf4aXFJIZjR+hxGuiUihCEVA8ZK5mT9nwfYoT1
         SLp1RBhTdQh9ESnG1XTfz9+Pu5gU8leL5pwo44CmUoeBaL1aiu/d32AKNeV/oop2d+gf
         zAIhJDmBGwDQmCXunyguPCnMqJUxqG6x8h0Flb+poN4+A2qPUXDVUpW9GuNWHLR25LPI
         NkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707251784; x=1707856584;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jzwz3V63szJHlExhCZvPC7c2dtOM+k/FDHvQAaa+NEw=;
        b=n76M4JTfafdsH2Y18QAHWGIpoTcGeYSDqzpyX1o9JeptweXJmdknzBuOXIelP+K3Wc
         MxpFZErYHOLIDukoieFZZTvAbcOx+12XZ44hKUUotGji3LaWpzMDBzY30DAXhmIv+Lzs
         nrNhCvoxt8wvYNCKt0oHsRvRY86DlnWLlq+KhhT4kyEkG55+yG4pfkSWjR3y9HycpqwK
         rW4UQKXwB86n1DCBksc/ak2v0pxxyEgekgC3YfX2Ne1PgsptgWZ4Um6AqKu/4YnAIZeY
         WHjTWjm4l434sOxUWOhT1v9ZJj9x1yzbCVzHhgi/CJ+aiqbUpgzfpRbN3FnELIZWO3GZ
         oz2A==
X-Forwarded-Encrypted: i=1; AJvYcCWgyoaIPLFfgz/SRW9taLCD/YlfNkv4XN5hZ3Xz0TrzxQaHaWAwazM/+ShG45ExCGg+OCoGQuQstptWTKKSBpoloXKu
X-Gm-Message-State: AOJu0YxG2KkCVS5MtRdvyc6+knnQ83ag+fKqJG7y9Vdn796SgfFMqQpc
	eIylnafLlQjrt5MpbQiSbOqdwZLAFBofK3rMVkJzphDv4gBjp8XjXSMtK9wkFp3IMEotX7ETQTu
	2bw==
X-Google-Smtp-Source: AGHT+IE+O6nMTqNGYB/t77HMprboX4PQjl7+xgDRrny/aw5DBBLxjaHIIhAZ2fE2KVmSzCD1jBDPxM7Dmrc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:313:b0:5ca:45d0:dc1b with SMTP id
 bn19-20020a056a02031300b005ca45d0dc1bmr1646pgb.9.1707251783750; Tue, 06 Feb
 2024 12:36:23 -0800 (PST)
Date: Tue, 6 Feb 2024 12:36:22 -0800
In-Reply-To: <20240203000917.376631-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com> <20240203000917.376631-11-seanjc@google.com>
Message-ID: <ZcKYRsNUAngWGy2a@google.com>
Subject: Re: [PATCH v8 10/10] KVM: selftests: Add a basic SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 02, 2024, Sean Christopherson wrote:
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(is_kvm_sev_supported());

This also needs

	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));

to handle the case where the platform supports SEV, i.e. /dev/sev exists, but
KVM doesn't support SEV, e.g. if TDP is disabled, if SEV was explicitly disabled
via module param, etc.

