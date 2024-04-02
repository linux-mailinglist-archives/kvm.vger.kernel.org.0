Return-Path: <kvm+bounces-13370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8903789562A
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 16:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CD5E1F23C73
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 14:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C49986264;
	Tue,  2 Apr 2024 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFWDPSAK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B693786134
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712066733; cv=none; b=OiMc/W4y8Umu1oK+gGQyn1yUtLJSxeG05yFqmfokEGh+edjl78gyiGtm44Kk8z/qHOev/EMYZkqgBTheVHD2E4B+MAYk6GvZ01CAd6SfIDgMBmVe7OXGrjbucvV2OMKHIKNRAv9mhv8WV8B2Bofke53issdE7ScGn1CwJZqbV2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712066733; c=relaxed/simple;
	bh=VK5h9//LgdEynnQqdnd0KvOvHtDWdqs7iaya5VEtpts=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TmqHZLKz0zjpJkpGbYfEfPOZzt3Cy3jBScOD/29hcXRj6Iuuexd5cyoeuUGe67eNjGMm5fcNDTZW1ltlzysgBTvnyyiKG9ecxzVR7efOO106l3MAPoCLpZtW4baZwUJ4OnSD5/JGTkC3+evJEHVr0Tpn2Ru89cYNFSGrxXBY4UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFWDPSAK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712066730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ANpAMc1eszGl4nFAW226PDhs3q15NgxFXUklMcpDRo=;
	b=GFWDPSAKh+PsYSG7NM50gWXAzNxSLorQMGqr98UjEx6PG4GtDvFpftspyqQJVYuV86MQkL
	VHHtMJE5CRc9ietJaM3duucYf9Fk9aR+DvysSXYSPxAMAb7PSfZUbSNAXhbDgPcWbT7aAn
	GgXM8ykOzXihRP7WbgyfzLEpNSMyG7o=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-k7wQHDn8OIWcm7cuaavdzQ-1; Tue, 02 Apr 2024 10:05:27 -0400
X-MC-Unique: k7wQHDn8OIWcm7cuaavdzQ-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6e0ee5097feso6504142a34.1
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 07:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712066726; x=1712671526;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ANpAMc1eszGl4nFAW226PDhs3q15NgxFXUklMcpDRo=;
        b=D+0lc+WF4inD2Md1H2FeSLmMdXzUGz1Xnhe/BRQcguWx0aS8E56euN4nRDuGBWbAK1
         2rIf7JQN4pMDiJMF/Nrn+kBijq92vbFwhM22s4jF43ljhfs+Vw2gfY3YGKUT7DIvDC9Z
         WCZYpvXK5E6GXFhSvr+eKIEOba94NCoNLDgKN+7F4+DvETdcSFO1mZ1KS6HDAVFHEpde
         6QUWcghqsicfSwkK+ddj4QCefPpK0McJFfqjtO+5g2Ku1injab3Kpw8Yz/LPWRQRnBRi
         n55UuwDXok79nwl+ojzi26m04ZIuvCJsqHjGwRCO8O+ApTuI8yNs+Z4O4I578mHTeEYu
         e36w==
X-Gm-Message-State: AOJu0Yw8njYKpfHPKZkU9PYrLdHxFRDku+r7DCuWRU7k933BmHudvAJy
	hlKc79rn5xxvcNrVTwNClVU2HVh2eVcqBU2T9Oci4pSs54dJzN+XXsT/1AzOurBxNmrprSe1mci
	b9Ky8jpR9Qvf/cnmmBN7HHcEMCI9cY3zLWXoVdo7aWp9Nz48/pG4BTIgSahSJ1hcK8MBrpJqi7i
	CSYKyVpuouyo7bth2xxKf/dn/X5/z8YYV/Xw==
X-Received: by 2002:a05:6830:1305:b0:6e6:ce61:3ee3 with SMTP id p5-20020a056830130500b006e6ce613ee3mr13673321otq.18.1712066726332;
        Tue, 02 Apr 2024 07:05:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0e3ogVp+zxvLlEV65ZPleONdb8lHys6Pido4t8auh70NKQQ3xCmDKjJbrjHW656l+UKDDdQ==
X-Received: by 2002:a05:6830:1305:b0:6e6:ce61:3ee3 with SMTP id p5-20020a056830130500b006e6ce613ee3mr13673274otq.18.1712066725869;
        Tue, 02 Apr 2024 07:05:25 -0700 (PDT)
Received: from starship.lan ([173.34.154.202])
        by smtp.gmail.com with ESMTPSA id gf15-20020a056214250f00b00691873a7748sm5545187qvb.128.2024.04.02.07.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 07:05:25 -0700 (PDT)
Message-ID: <207d6598c8b74161efc38bd18b476ca8626786b1.camel@redhat.com>
Subject: Re: [PATCH] KVM: selftests: fix max_guest_memory_test with more
 that 256 vCPUs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, linux-kselftest@vger.kernel.org, Shuah
 Khan <shuah@kernel.org>
Date: Tue, 02 Apr 2024 10:05:24 -0400
In-Reply-To: <20240315143507.102629-1-mlevitsk@redhat.com>
References: <20240315143507.102629-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-03-15 at 10:35 -0400, Maxim Levitsky wrote:
> max_guest_memory_test uses ucalls to sync with the host, but
> it also resets the guest RIP back to its initial value in between
> tests stages.
> 
> This makes the guest never reach the code which frees the ucall struct
> and since a fixed pool of 512 ucall structs is used, the test starts
> to fail when more that 256 vCPUs are used.
> 
> Fix that by replacing the manual register reset with a loop in
> the guest code.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  .../testing/selftests/kvm/max_guest_memory_test.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> index 6628dc4dda89f3c..1a6da7389bf1f5b 100644
> --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> @@ -22,10 +22,11 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  {
>  	uint64_t gpa;
>  
> -	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> -		*((volatile uint64_t *)gpa) = gpa;
> -
> -	GUEST_DONE();
> +	for (;;) {
> +		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> +			*((volatile uint64_t *)gpa) = gpa;
> +		GUEST_SYNC(0);
> +	}
>  }
>  
>  struct vcpu_info {
> @@ -55,7 +56,7 @@ static void rendezvous_with_boss(void)
>  static void run_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	vcpu_run(vcpu);
> -	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
> +	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
>  }
>  
>  static void *vcpu_worker(void *data)
> @@ -64,17 +65,13 @@ static void *vcpu_worker(void *data)
>  	struct kvm_vcpu *vcpu = info->vcpu;
>  	struct kvm_vm *vm = vcpu->vm;
>  	struct kvm_sregs sregs;
> -	struct kvm_regs regs;
>  
>  	vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
>  
> -	/* Snapshot regs before the first run. */
> -	vcpu_regs_get(vcpu, &regs);
>  	rendezvous_with_boss();
>  
>  	run_vcpu(vcpu);
>  	rendezvous_with_boss();
> -	vcpu_regs_set(vcpu, &regs);
>  	vcpu_sregs_get(vcpu, &sregs);
>  #ifdef __x86_64__
>  	/* Toggle CR0.WP to trigger a MMU context reset. */

Kind ping on this patch.

Best regards,
	Maxim Levitsky


