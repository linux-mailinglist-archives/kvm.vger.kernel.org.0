Return-Path: <kvm+bounces-7206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5923683E35F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 21:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE93AB24DE6
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 20:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BCF52374F;
	Fri, 26 Jan 2024 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="08ShMefS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1DC224C6
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 20:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706300915; cv=none; b=qc1twbTagZIdD/EA/umNKStALOuGdIH1RJlTRGM+h30uyvEIb7rvZrMZicZf3aDHdN7nO0e53SjPSGV/bF+sf980R3m4RTXxj1RfSndwyJIHaPkFUUPy/Re037bdIivOKqoXTBgTCxswbdmipXd1ATRuVjxdbiHQKnn3FGVMUxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706300915; c=relaxed/simple;
	bh=MX1cl8lmGmpn8sljYyeenca6Mtxd43PcXSi1NGAVEWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rm5ddDh3UhW53fuSJg5cm0sThcXCVE5Y1KHJbAMqMrCTvsG9TXfN/1LClX0quAKA+CrZMXPC5GJu2apTL8WYHcqvBfglUqUr3aKzzRcGpi+TLimogr2XUPdDjd1AowwfEHUfnERK7FiX1ZktuEqLCdA0Hn1n2bPr6BlgyeYIxAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=08ShMefS; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cec090b2bdso730985a12.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 12:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706300913; x=1706905713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KbQ+Dwhg/HevKgCb1ijIHEGKfQzi7W5glVtqWEkhfqI=;
        b=08ShMefSLdxC/ARJQwgiMa+S+0aZex2v0Z2VBtJz2u4xIzNCYJq5KQVEP8ybwehpBp
         PEtCK0rn57jC9b6zuvKx2wQCdIHRwoVGZv/Gd4eJhNOS0xAGpXVq8fM3bSyJtF8UOQfD
         JJT8CpRGuS6PhcZBh73ZAjWzbRZTJfn1Z+S9ipqXXkF8Vq5IbwSyWQFlLA0Cj9WuwtTv
         wz48QUZg86HgL1Har/y5CLwl5KSq3VzoJwjEC/HSWfGGluNhJPOIKi8hiOZ2ovCfTFxr
         tBZcO2pBnU/cmJxk5g0DgLDLXLcDAIOfTKtMLvv6zeTXopA/j3Q3P5YKFp2+kX0kON92
         HzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706300913; x=1706905713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KbQ+Dwhg/HevKgCb1ijIHEGKfQzi7W5glVtqWEkhfqI=;
        b=jIQxhKK+1zXoXQ6lidZCdr4Rb4K+oA1qtxphiym6DccGsqIWImzgIIeUfEw9ICY+zL
         cmvmU21grUiWluAPGZ7CdZYEqv2LHtMqu3sIG1mmQgFHylfIw/62zz1U8sfHBGuLiS2N
         Rzqz9ruW17w9OLJb1B17IA1pv47IdSdy66P1CQjFzYe/xLlqzOeTzJ92bImnQ4Xhi3GS
         3785bYQeXq5GIXfy+9B3l3g9EcerXDIZBZphVrOJDbZ08aqspOG8hdAoy1UrsU24Dpuw
         xthlrSFY+KAESMIao7AnGcMzr4Bc74rwRhtMMp3Yp8zx1QRfXb9NWrjh9JLmPSHBXA4m
         Fh4Q==
X-Gm-Message-State: AOJu0YwhYnct92RG2WfcL99/CqI4JR82e9m8ck/d/FDXGAa43k18KYSO
	/h9N4cYOOpBLeRUcmw17cql3LcXX5rjeL+9S/rewO7y5flytHizNmIuCILxQSEhSzW2GVhuRXFK
	sYw==
X-Google-Smtp-Source: AGHT+IFuxqVUto7K9qlkno1FvOpuribEDZLPtNAujSDb8v9/ilztKOioPYJlW0aBaN6d/Nq82pMdRpk7AJQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:64c4:0:b0:5ce:474:352b with SMTP id
 t4-20020a6564c4000000b005ce0474352bmr1894pgv.5.1706300913464; Fri, 26 Jan
 2024 12:28:33 -0800 (PST)
Date: Fri, 26 Jan 2024 12:28:31 -0800
In-Reply-To: <20240125015420.1960090-5-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240125015420.1960090-1-maobibo@loongson.cn> <20240125015420.1960090-5-maobibo@loongson.cn>
Message-ID: <ZbQV75Q-N_cJLhj6@google.com>
Subject: Re: [PATCH v6 4/4] KVM: selftests: Add test cases for LoongArch
From: Sean Christopherson <seanjc@google.com>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 25, 2024, Bibo Mao wrote:
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index 075b80dbe237..7b09e59296be 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -333,7 +333,7 @@ static void test_invalid_memory_region_flags(void)
>  	struct kvm_vm *vm;
>  	int r, i;
>  
> -#if defined __aarch64__ || defined __x86_64__
> +#if defined __aarch64__ || defined __x86_64__ || __loongarch__

I assume that last one wants to be "defined __loongarch__"

>  	supported_flags |= KVM_MEM_READONLY;
>  #endif
>  
> -- 
> 2.39.3
> 

