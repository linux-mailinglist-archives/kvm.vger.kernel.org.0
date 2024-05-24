Return-Path: <kvm+bounces-18133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D8C48CE6D3
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CF461C2211A
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9CB12C495;
	Fri, 24 May 2024 14:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6ZjcG50"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA5963CB;
	Fri, 24 May 2024 14:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560186; cv=none; b=ecHkV2LxyQ9UOhOM7e8Aw+jTsJ8q9qYvTWQJhzSrDe0HXi3CfONpAEORVnsRvWLcMSCxKJL947tty12CU0eJ6G2zWfcFeMn8ETA1k5GopiykuvvkN8t1/4j1LVJT02esrgTBabddSZGI0Q4/9JlEbMMR5otwIeZnHlPG4ExNoOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560186; c=relaxed/simple;
	bh=fXdrf2he4s1pRtUi0K9sSJo58DOi3PzBtCVyuO9zokQ=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=T/nSfw3jN7EAAlizEcL/1RhjotXVX8o02NgbnfCTJO+sx6Y6S/tFN40iDkSL8eH8/jGQo9c34rIib5x0FK4sCAJsruVLjfdYSRemf8DHzMMaviTObU0eotUWg71lsOY8AWGTjCwD/38UmHLZYeCR9RFegufmoleffl6DVTO2Emk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6ZjcG50; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-354b722fe81so3074786f8f.3;
        Fri, 24 May 2024 07:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716560182; x=1717164982; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9q4CL5GEtuviTHR5EF2NXrLnaRXh41eNJfh/YbEXGwQ=;
        b=m6ZjcG50b+SMtE8ue+EDGphGJNEPqAGP+18wXajL7u5aipueTzOBWNJ5sBUM0xdiDB
         Vw/Zp0SSJWXgt4nJP/pmay7uCp9nAxKvDcXE+tCLE2H0Du+AV2r2BnOX+tDyDPnzM+I4
         f33leUKEVA+BpTr8LChvdyLc8t9UXSQjYJQ4jQ3fKRMin2N0eYFIDmwqJNJdDz35LoVw
         tyJxLeovm62H9hJhrfD1ETU/bApzprNxHbTQBfUZqL+NHhXMMAEx4bbir1WZmboXU1SN
         QFeVHy9W5r+nuS/CC/Vv066OT8Y93T6nCJLDN9DIDiVZ1S0rdUW2CfPlTPHEHfG62xOn
         gJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716560182; x=1717164982;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9q4CL5GEtuviTHR5EF2NXrLnaRXh41eNJfh/YbEXGwQ=;
        b=MhnmRiDVp1NZ6e/6rRPhdN6ZPyUJ2k/eMS8FWGvek4npOgk5Uwk1L0Ae3CvjZkqES8
         5hvrxdgeASxhOJLTH6NY13UMRD4QXKpfukiWvujewsvdMxZ4AdGr/6f1hdHKrhCUXqKt
         oUupWPhEFbljj9ANFX8yZT2Gx2OfpD6E/pQRc76+cDzizOxOw3YzHWOSd35qaDx4TKAk
         W1SYE38gHBRIQvLMHSDhaRDilqBJHxnqvOZVx40tUQdJFkurBSBRknuI/RaBBLXc9159
         ccdaCkQzIIsvF1Yk4txWQ3vhVYu3TOZXgKyqOALNHj78WVQ6QVm+5fnQBM5hUwHwNY6p
         jrxw==
X-Forwarded-Encrypted: i=1; AJvYcCWEDIiFAlmdlXLp21N4L7Em+HFXPJuUbxmzA1jZC0AEpGXQVHGGojAGGSGf7HcqyAKvhqHhVoMCxGdFWj9iie324jofTydw4GVCQleS8pUgj52NktWwr/yuuE290UQ9Tzc9wOBmG9x+dyrdNUP5Jxy7JvZDl6tEp8B33G2+
X-Gm-Message-State: AOJu0YxFS1bY6Bipsp5JrezW0g77hfVUzlcSt8/BVNAl5Jh8vwZwogPt
	benW3m0554GfUvTlostWTZJxaeIZW1Qj2bNZufJ2JaQklQsp7Qsj
X-Google-Smtp-Source: AGHT+IFugCju2Lm4WjZ0ugnhV/HUrfnSCaGftG0on2jA5+IziNDFO2jP4/SGWZdZa/oAG6n9m1xtJw==
X-Received: by 2002:adf:e546:0:b0:354:e0c9:f620 with SMTP id ffacd0b85a97d-35526c38c7bmr1471402f8f.24.1716560182542;
        Fri, 24 May 2024 07:16:22 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35579d7db8csm1707663f8f.8.2024.05.24.07.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:16:22 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <3776d48b-652e-409a-b991-d96d6a9e777e@xen.org>
Date: Fri, 24 May 2024 15:16:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 18/21] KVM: x86: Avoid gratuitous global clock
 reload in kvm_arch_vcpu_load()
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira
 <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, jalliste@amazon.co.uk, sveith@amazon.de,
 zide.chen@intel.com, Dongli Zhang <dongli.zhang@oracle.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240522001817.619072-1-dwmw2@infradead.org>
 <20240522001817.619072-19-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-19-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit d98d07ca7e034 ("KVM: x86: update pvclock area conditionally, on
> cpu migration") turned an unconditional KVM_REQ_CLOCK_UPDATE into a
> conditional one, if either the master clock isn't enabled *or* the vCPU
> was not previously scheduled (vcpu->cpu == -1). The commit message doesn't
> explain the latter condition, which is specifically for the master clock
> case.
> 
> Commit 0061d53daf26f ("KVM: x86: limit difference between kvmclock
> updates") later turned that into a KVM_REQ_GLOBAL_CLOCK_UPDATE to avoid
> skew between vCPUs.
> 
> In master clock mode there is no need for any of that, regardless of
> whether/where this vCPU was previously scheduled.
> 
> Do it only if (!kvm->arch.use_master_clock).
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


