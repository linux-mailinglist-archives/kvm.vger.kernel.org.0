Return-Path: <kvm+bounces-19489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7875E905A78
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 20:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E03C1F22CF3
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 18:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5662183071;
	Wed, 12 Jun 2024 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TJ8VDYVu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA418309D
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718215862; cv=none; b=P3KPHyuWX88141pIZl7HSiWVIFjxOrLrGlSJNt9Cuj1PXu5VT4yxFa610wXcXCZ/C4MRVswv/ZrVPf/cMSFQynCxzY5EnYxzfPsthd24EHy4BC1MDJhkDq4Y/pvXVhz4l0zjM3ZMk3fUSptT/H4n+q9iNgxtutl7oNWcOfvl4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718215862; c=relaxed/simple;
	bh=byfky6BG4g1mjW3Wr/3DNMmcw/qupLWQ0lVzTwpwdZo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cZXhaZrl5vn1sr8JusHkTepuxgqQoYqcvepgNiv7THa/MAhscjjAYnBNn2kKOwDFJV7X5WuOHD6oLcoecG7WhCN95aPeb7x075x/lMZqg41lg82zniD3rZgwPzY7ZHLAkjDy3m4vDAH08u6D1uSeybWBXBgg3F2G69+O/26jWXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TJ8VDYVu; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6300aeb93dcso2993177b3.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 11:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718215860; x=1718820660; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bysuRKx6ASJn7sotbzdgYdmXjsZucWIObzR9RYJqi4M=;
        b=TJ8VDYVu0hwx/RCUpkOjmyYMvNc1yt/sQ18Mm7A2DP1umNdlEPLHYVA8dMxco+PPCv
         PUVhxjfMG5xjrATU6BsdSFri2UNCRSd5A9ljGWRJ3UtIeNO3IQoPEzhkHglXMPdE0qQ/
         k0cy9YMPUG6ssoRVc9AYs9v8n7cQbwSopKc/y72gRbKBBlJx5sSCI55eMb2rn9bSkK4i
         50xlJ/qG1wpeHF75QAVeMCrDB0h4PJ3xQtzSAi9e712GsNmTY4rUd81Ka+3hc0CCg7eC
         6gBCICoqmDuZGCdOPTOTRUFM83L3SolNFqQwrL2kbwyJUWBa91TIv4Jb63XXq9hvKsQS
         FflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718215860; x=1718820660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bysuRKx6ASJn7sotbzdgYdmXjsZucWIObzR9RYJqi4M=;
        b=Ohg5qm7A4YQdu346wwjq7xmkoKgInCW/GTBYjD0sn5te7P39VANQT1e/pCHQknYwe6
         Hsdv5q7nxQpthTBkLow7eA0Obyq5BtGXEeqMOy1rEX2cwofqm6noqKZqbqayHE9f9ng/
         mKF+JGCClU/Wa+1XZpDQ5xXDV4Aee8NaUhAsGBKy1VI4CUtift+8fojJsA2p+ckn99sP
         ObNtBEpoluYduZB1dvVebmNuJv2Lxw8ov/HhhDEjJv19QrFbGkhfkWxcZMHS9Bx6RmdC
         uggV+b28xV154xocAMqaM7TlaEmUem2YAmeT2G1brwob2HtAmFiacg+dSQzVU1iadyYW
         NXHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqDfqLskJLKHH+1HrYXtyzXGDov1Ns5E6gygtEdI+TnzqqrWc8ul2cF4zPyBprcB6s7fpSUT1NUh9dD/BkmgkZIoXT
X-Gm-Message-State: AOJu0YxxZSgZcI/KhrGrlfIUYuRpKz1vwZjw4R6rOqIw1v0xySANVA5T
	UZPj8RC+B8G3aB4Y6oZZzFdwnUxyAjmfJFLs6dWqEnp+g3WRRwwtOKt3VyNWkN/mHa9R7w36+Na
	+og==
X-Google-Smtp-Source: AGHT+IFdlsyNfCopJx9MGc/lpAH0uLI55vrBd5uBQ720M/Quh9qtzfjG5LFD+1WcYsruY1pOCRVfaawqImE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b19b:0:b0:de4:654f:9ad0 with SMTP id
 3f1490d57ef6-dfe66b65b58mr79044276.6.1718215860399; Wed, 12 Jun 2024 11:11:00
 -0700 (PDT)
Date: Wed, 12 Jun 2024 11:10:58 -0700
In-Reply-To: <6bd821a3-9dbe-499c-ae17-afce70076299@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240612104500.425012-1-usama.anjum@collabora.com> <6bd821a3-9dbe-499c-ae17-afce70076299@arm.com>
Message-ID: <ZmnksmC4u5lP5am9@google.com>
Subject: Re: [PATCH 1/2] selftests: kvm: remove print_skip()
From: Sean Christopherson <seanjc@google.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Haibo Xu <haibo1.xu@intel.com>, Anup Patel <anup@brainfault.org>, 
	Andrew Jones <ajones@ventanamicro.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, kernel@collabora.com, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Dev Jain wrote:
> 
> On 6/12/24 16:14, Muhammad Usama Anjum wrote:
> > 
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > index 4f5881d4ef66d..695c45635d257 100644
> > --- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
> > @@ -144,10 +144,9 @@ int main(int argc, char *argv[])
> >   	free((void *)hv_cpuid_entries);
> >   	if (!kvm_cpu_has(X86_FEATURE_VMX) ||
> > -	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
> > -		print_skip("Enlightened VMCS is unsupported");
> > -		goto do_sys;
> > -	}
> > +	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS))
> > +		ksft_exit_skip("Enlightened VMCS is unsupported\n");
> > +
> 
> Isn't it incorrect to delete 'goto do_sys'? ksft_exit_skip() will exit and the
> program will never jump to that label. At other places too you have deleted the 'goto'.

Ya, exiting instead of continuing on will break these tests.

