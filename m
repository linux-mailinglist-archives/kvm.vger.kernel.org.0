Return-Path: <kvm+bounces-19897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5200490DEA9
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78BCF1C2132F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3A6178378;
	Tue, 18 Jun 2024 21:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zxdzwrbl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A519216DC19
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 21:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718747172; cv=none; b=TnOSuH5KqISRN03usH2JtamYcFj95QYQlQQ/V9kDkFpPREqUN3CP2O6fFA6w9U/AELlMEzgRgWAVah/CgoGqlHrEQZECjTYbvk94isGPF4v9+5Mj8EGRIXF/4gKghj/W5so9zlkpoqRjIv3CxtDGZB2y6rZPNBFGVhjCMFOwTGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718747172; c=relaxed/simple;
	bh=AvNrF8DODCk953bLRKAikN4GelqcLbbbV8JPr5mz4Yg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=b/mQzWV1aMVz2BhqwDElEOOF8ZHO3qUK3HZRtiMCmT3yAu0i/ZOXcIOtya2Btoth+jTJbZNywn4HkVDkPgLt3h77K7nJbDMDNFjaAS3lHECwrm1wWpW92+vZ7ofpIkit645AmwZEN5t6ALV2zudflZCQd0tPLjfSnrdUhmO/4hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zxdzwrbl; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6e67742bee6so3494565a12.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718747170; x=1719351970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TIQ3kfXDxnvR9vG4GruL5d0nx4Vqm1FEFplJ13qNH0E=;
        b=ZxdzwrblSrSF42CAEXLA1jx8+vbX2lFLs+4R2u6TLlvOAlRZZBSAjxHFOVsCscCaA5
         Am6TXHRzsNawU6wlVAVtoKr+s6xGsYM1big6yVeLjsgk1oEh9gCcVISZindABB2P+SzD
         VGDzL8nQOmGwbEA3q/wCAqGfepOLxCNbiFZz7fUsOTwpao5Db+EqtG06XgCCpEbjpSaa
         G5B4TnDIEMf8VIvpFspaOwr1FUZgT4IPLkcwSadtFfW1/Vr1bU4lnCeBXr9kXOqBI5lE
         +HKQbsnoE/AEwpc4zAknuAlC/7o3tW6wrM2rjWMtxbT0rTqDd8UGNBByDnqpd4jZXnzy
         Bpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718747170; x=1719351970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TIQ3kfXDxnvR9vG4GruL5d0nx4Vqm1FEFplJ13qNH0E=;
        b=o0tLp8/znq1MTSklypFv0jAEGaHGK/ORpyBJb93E4yQz10dQAJP+GL3y3XlE96+5fW
         5qCkLmYHZTgrY6TZYBIFpQYRCyqPy8Piux5RCkcja3qwedS+e9pSDKVJ4yPoxHF0bwtZ
         iwNmE/8oLR2t2H+nCPECrk6ZqZETCLSqC/YaVxsRJu0kb4AhX4m0JGEXcR1uRj/KVOjf
         Gv/EU9yTbP65iXPKc9egakEgsGrPM+j9GhWXUpA3Dz3pUIHJ0Ezi3sKKaa3dBrL6tXpv
         zoVxiKmJdAQsC2jucFKI4N6sI3GzEMK4EbxU2YgPWFySD0jYkQdS4sNe8RM0oPCuAW7I
         Xf2w==
X-Forwarded-Encrypted: i=1; AJvYcCXneKaFz44+UPfWilXyH8VryzpTB+9AUFt0Fj/+i8Nv/uClQQNWhDDzHBNgP1+YPVdI4Lv/aXL5gxE1NTUvL3f6LFON
X-Gm-Message-State: AOJu0YwiwcVnGypHPCq/k0S7S/dLJ36HejUi03iygZh3611J3QdIP20/
	YNAX9dJZK7ASPUUCss58qWhshgyJJ9nEBBoxLxYPC25EeCfpbbdux8CKwZWAyDhNINeLSsDlvdg
	Chg==
X-Google-Smtp-Source: AGHT+IE+ru0espGFuS9wOdmMbFbdZv75qYL5SavI9BTUhtxXWisV6HlT8PRog/sZ2FbZ3VLCGnYpMd1Rd88=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a8:b0:6e6:831f:c3f0 with SMTP id
 41be03b00d2f7-710b9e10287mr1950a12.11.1718747169797; Tue, 18 Jun 2024
 14:46:09 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:46:08 -0700
In-Reply-To: <20240614202859.3597745-5-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240614202859.3597745-1-minipli@grsecurity.net> <20240614202859.3597745-5-minipli@grsecurity.net>
Message-ID: <ZnIAIGJpErWhfHns@google.com>
Subject: Re: [PATCH v3 4/5] KVM: selftests: Test max vCPU IDs corner cases
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 14, 2024, Mathias Krause wrote:
> The KVM_CREATE_VCPU ioctl ABI had an implicit integer truncation bug,
> allowing 2^32 aliases for a vCPU ID by setting the upper 32 bits of a 64
> bit ioctl() argument.
> 
> It also allowed excluding a once set boot CPU ID.
> 
> Verify this no longer works and gets rejected with an error.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
> v3:
> - test BOOT_CPU_ID interaction too
> 
>  .../kvm/x86_64/max_vcpuid_cap_test.c          | 22 +++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
> index 3cc4b86832fe..c2da915201be 100644
> --- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
> @@ -26,19 +26,37 @@ int main(int argc, char *argv[])
>  	TEST_ASSERT(ret < 0,
>  		    "Setting KVM_CAP_MAX_VCPU_ID beyond KVM cap should fail");
>  
> +	/* Test BOOT_CPU_ID interaction (MAX_VCPU_ID cannot be lower) */
> +	if (kvm_has_cap(KVM_CAP_SET_BOOT_CPU_ID)) {
> +		vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)MAX_VCPU_ID);
> +
> +		/* Try setting KVM_CAP_MAX_VCPU_ID below BOOT_CPU_ID */
> +		ret = __vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID - 1);
> +		TEST_ASSERT(ret < 0,
> +			    "Setting KVM_CAP_MAX_VCPU_ID below BOOT_CPU_ID should fail");
> +	}
> +
>  	/* Set KVM_CAP_MAX_VCPU_ID */
>  	vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID);
>  
> -
>  	/* Try to set KVM_CAP_MAX_VCPU_ID again */
>  	ret = __vm_enable_cap(vm, KVM_CAP_MAX_VCPU_ID, MAX_VCPU_ID + 1);
>  	TEST_ASSERT(ret < 0,
>  		    "Setting KVM_CAP_MAX_VCPU_ID multiple times should fail");
>  
> -	/* Create vCPU with id beyond KVM_CAP_MAX_VCPU_ID cap*/
> +	/* Create vCPU with id beyond KVM_CAP_MAX_VCPU_ID cap */
>  	ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)MAX_VCPU_ID);
>  	TEST_ASSERT(ret < 0, "Creating vCPU with ID > MAX_VCPU_ID should fail");
>  
> +	/* Create vCPU with id beyond UINT_MAX */

I changed this comment to

	/* Create vCPU with bits 63:32 != 0, but an otherwise valid id */

mostly because it's specifically testing the bad truncation of the upper bits,
but also because I initially misinterpreted the intent and confused it with the
INT_MAX BUILD_BUG_ON().

> +	ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)(1L << 32));
> +	TEST_ASSERT(ret < 0, "Creating vCPU with ID > UINT_MAX should fail");
> +
> +	/* Create vCPU with id within bounds */
> +	ret = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)0);
> +	TEST_ASSERT(ret >= 0, "Creating vCPU with ID 0 should succeed");
> +
> +	close(ret);
>  	kvm_vm_free(vm);
>  	return 0;
>  }
> -- 
> 2.30.2
> 

