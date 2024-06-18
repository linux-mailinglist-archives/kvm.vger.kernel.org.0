Return-Path: <kvm+bounces-19898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC0E90DEAD
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DED23B20EC0
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B04178378;
	Tue, 18 Jun 2024 21:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yMt4kBOg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE62C482DA
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 21:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718747417; cv=none; b=NmEo3gr7PBlN5/NHrgoEN4T7HV/88gHgByPHtVXW3/vW2qxd+77bhJO7XbLoj5j5u/u3s+0DeJAXJpbndWfqtNrskGz+yQcFw0TuOs6SIvqZ3xGYZ20dbDCAX3pr5cBiowR1BmR3HYl095KSP/1pcOlzGaXz1rV7f3QproureUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718747417; c=relaxed/simple;
	bh=XFuS1zWm/p7yqOU8+Xma2TY9qvjk8OvFirs8ldHM+aE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lnRNOx8Ge71hEr6sR3Y0hVTVMV2MpLSTC4ySr7Z1OPQUWqgziIUXlMVrYIKd3TVvGSp0B9wkuOiWxFyaayp5rVdsm+SA1NAOMRWJ4wyLfkLgGZMD21RIT6EdAYdUg5pk2WyoDVjQZLspz7bPxpa5+nRDLoznzhCtAAg6QZZxhS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yMt4kBOg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c7ad681313so642156a91.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718747415; x=1719352215; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zAmXhDPd4IVK5pKc/W0EmNV4bYPK0uZn5zZjNdwsfts=;
        b=yMt4kBOghLcXttKx3aMgJEBD07aTRaWSOqIWF+7p/ZT6fziP3Rc/TTh5qoTltTieAk
         3VXSMyCZwfe6D3fXvxvC4gAlu1iEtS3CvbJAeqSKq4rYaoDui9Z/shB0vb4Vdv4RbiRe
         azb5INq1NNKk8fvfBso0ADtcZu55HJe44Z6Gu0jO4HlDyNsLr6HeesilYpcrRiVCyLy+
         OdJEWJqH4lhB5wgIXqPvyqOH2OeLeXMwDIrhogg1LHl8cwWYzKRm0dtI8c50L/+A+ir0
         eK9jqv1qlvYhwK7oZOCu0447/rLBN5aroCwG97nwS2OO9cwQS5Ox8tXiNlosPS6OP9tz
         dVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718747415; x=1719352215;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAmXhDPd4IVK5pKc/W0EmNV4bYPK0uZn5zZjNdwsfts=;
        b=sRa1Wvvf34ZlAOI8DBupVNgRk1cpU3uJkhmVht/Sn6QjOEwNepc18ZtVNcEOrcPjBR
         SsqZubXqUC47kXXHYwdDkOKr60GprjKX3ggjP3knygw5GrpLTdFLfW9yKf5JPE7xLK6H
         Hva6kbvbwwtGhoK6eBHGP53UmU0VbAGNbv3yoD1cli9nFzepSbZhqauk8Pb0PBcNi68s
         /gkLIn05nK4XBYIn2PVVdlemMKmEnGKTRYqOcbj57Hjd2TD86ufFa8pp3M0npZsZ2NU6
         AZt9vbSJ//9VyBJPjqRaTABnbyHIcuXOA87ui9xQQRxP5WD8ydC8IRvZWMqiwt5HChkH
         Tlkw==
X-Forwarded-Encrypted: i=1; AJvYcCUn4Uq8gEWS3kqNtRanYJkJAxtg2TEeCyHEvpK5+4oXXgQt18T7Zcxk3QNKa471hJV7hb/kSR4t2LTT3FjGWv08o4Xx
X-Gm-Message-State: AOJu0Yx8ALfyA0fr4KD0eq+tF7TzcvCO79pDmMuy0wKm/iUVx6SqCVsi
	GwGDNSF3CpvnwdkyW6VTlPO9pM6WQlf5NdpePYDR0kLk1h22OJiy2BwW8DY6disiYjG29K6S/Ia
	9wg==
X-Google-Smtp-Source: AGHT+IGeTOxZc19hXeoHUWepMz1pFVC9euAM0twDShnZkTxVaac/wM3TwvV/+HgiY/4kbSbwLODorQx+ovs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b0a:b0:2c3:2975:541 with SMTP id
 98e67ed59e1d1-2c7b57fad55mr2590a91.1.1718747414711; Tue, 18 Jun 2024 14:50:14
 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:50:13 -0700
In-Reply-To: <20240614202859.3597745-6-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240614202859.3597745-1-minipli@grsecurity.net> <20240614202859.3597745-6-minipli@grsecurity.net>
Message-ID: <ZnIBFWqPmiEKQiTO@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: Test vCPU boot IDs above 2^32
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 14, 2024, Mathias Krause wrote:
> The KVM_SET_BOOT_CPU_ID ioctl missed to reject invalid vCPU IDs. Verify
> this no longer works and gets rejected with an appropriate error code.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> index d691d86e5bc3..50a0c3f61baf 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> @@ -33,6 +33,13 @@ static void guest_not_bsp_vcpu(void *arg)
>  	GUEST_DONE();
>  }
>  
> +static void test_set_invalid_bsp(struct kvm_vm *vm)
> +{
> +	int r = __vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(1L << 32));
> +

I also added a test to verify KVM_CAP_MAX_VCPU_ID+1 also fails, because why not.

	unsigned long max_vcpu_id = vm_check_cap(vm, KVM_CAP_MAX_VCPU_ID);
	int r;

	if (max_vcpu_id) {
		r = __vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(max_vcpu_id + 1));
		TEST_ASSERT(r == -1 && errno == EINVAL, "BSP with ID > MAX should fail");
	}

	r = __vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(1L << 32));
	TEST_ASSERT(r == -1 && errno == EINVAL, "BSP with ID[63:32]!=0 should fail");

> +	TEST_ASSERT(r == -1 && errno == EINVAL, "invalid KVM_SET_BOOT_CPU_ID set");
> +}
> +
>  static void test_set_bsp_busy(struct kvm_vcpu *vcpu, const char *msg)
>  {
>  	int r = __vm_ioctl(vcpu->vm, KVM_SET_BOOT_CPU_ID,
> @@ -75,11 +82,15 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
>  static struct kvm_vm *create_vm(uint32_t nr_vcpus, uint32_t bsp_vcpu_id,
>  				struct kvm_vcpu *vcpus[])
>  {
> +	static int invalid_bsp_tested;
>  	struct kvm_vm *vm;
>  	uint32_t i;
>  
>  	vm = vm_create(nr_vcpus);
>  
> +	if (!invalid_bsp_tested++)

I dropped this and just had every VM run the negative test.  There's zero chance
anyone will ever notice an extra failed ioctl() or three, whereas it took me a
second to realize this is just a somewhat lazy way of writing a one-off negative
test.

> +		test_set_invalid_bsp(vm);
> +
>  	vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(unsigned long)bsp_vcpu_id);
>  
>  	for (i = 0; i < nr_vcpus; i++)
> -- 
> 2.30.2
> 

