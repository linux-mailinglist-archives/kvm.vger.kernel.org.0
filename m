Return-Path: <kvm+bounces-23407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 827B0949608
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:00:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 978141C2274D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BD547F6B;
	Tue,  6 Aug 2024 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="oZbcNhfl"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27A44C81;
	Tue,  6 Aug 2024 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722963594; cv=none; b=gWiKM35V7cKEuw6jS3Nmal/Ex9WOXckbXkpphWDnbTGvy7z+55/yB3N2r1pHguhsYgP1m5qzZHBNMbXLGnMBA9QQ07T+sjRLK97CU4EzLQouOfCtTto3SXrJcKyyM7bdzBSahf+zaFu0wt+ncUEX2HEzRul0MZxux0dgkSVaW9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722963594; c=relaxed/simple;
	bh=QIgo1oTbTGrJcGzsnRXNARSORVNQ40wyWmyE3akTlK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nl0xG2ZvXIN1GLl6YVQ1hycer3Nz6XkiB85in0YaprSwSIhLQjgBmwrVo8qofP97QGldjDOAd/Mno8SDhwVFv8LnYXQK8jhI5j47PX5xoQ2j/xsQVKSevfJbd17uJ1t/bgTLuxaM6mpBz+FC6E3qKbZWsqqJrgI6KqGm1MElYsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=oZbcNhfl; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1sbNX9-00Dlqt-94; Tue, 06 Aug 2024 18:59:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=+WAintw+rCDDHjJQ1WEuvYYp6tga3Qlo68DUf+AZz2E=; b=oZbcNhflrl3QMwFZMy95J0xYPz
	ucXj5lNuUqxESPkkgplHqS98DaTmDRc7TgyWSH02QuvSq+fU2LLD8FFBGMOzYX+DbPQDhsHs2B48A
	gIR2EMAbGdm2iOnDpzJxMS0Vji3pnAqBKFAqCklHzfhYCpiwBi+x5qJTXVgGcZVA140aqOw3D7zLx
	AwN/O/SDP+L2bISoqMVAg8Ijy24COGql6NH+dsMgW1ra91TvQGRw4RD+F32qivJXDTfi5bNoWONRx
	Y+rCd2OOjNBMWnhBncwoOBAUeimaM4DggwFRFlRnXICshmxL17thIOBXEUOF3jIzZ3sPT9QbM0n4N
	St27Be4Q==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1sbNX8-0005ZD-QP; Tue, 06 Aug 2024 18:59:38 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1sbNWy-0021rb-T9; Tue, 06 Aug 2024 18:59:28 +0200
Message-ID: <b0c3552b-1efd-4c48-8d86-91ee16e7222a@rbox.co>
Date: Tue, 6 Aug 2024 18:59:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
To: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>
References: <20240730155646.1687-1-will@kernel.org>
 <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co> <Zql3vMnR86mMvX2w@google.com>
 <20240731133118.GA2946@willie-the-truck>
 <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co> <Zqpj8M3xhPwSVYHY@google.com>
 <20240801124131.GA4730@willie-the-truck>
 <07987fc3-5c47-4e77-956c-dae4bdf4bc2b@rbox.co> <ZrFYsSPaDWUHOl0N@google.com>
From: Michal Luczaj <mhal@rbox.co>
Content-Language: pl-PL, en-GB
In-Reply-To: <ZrFYsSPaDWUHOl0N@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/6/24 00:56, Sean Christopherson wrote:
> [...]
> +	/*
> +	 * xa_store() should never fail, see xa_reserve() above.  Leak the vCPU
> +	 * if the impossible happens, as userspace already has access to the
> +	 * vCPU, i.e. freeing the vCPU before userspace puts its file reference
> +	 * would trigger a use-after-free.
> +	 */
>  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> -		r = -EINVAL;
> -		goto kvm_put_xa_release;
> +		mutex_unlock(&vcpu->mutex);
> +		return -EINVAL;
>  	}
>  
>  	/*
> @@ -4302,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  	 */
>  	smp_wmb();
>  	atomic_inc(&kvm->online_vcpus);
> +	mutex_unlock(&vcpu->mutex);
>  
>  	mutex_unlock(&kvm->lock);
>  	kvm_arch_vcpu_postcreate(vcpu);
> @@ -4309,6 +4318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  	return r;
>  
>  kvm_put_xa_release:
> +	mutex_unlock(&vcpu->mutex);
>  	kvm_put_kvm_no_destroy(kvm);
>  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);

Since we're handling the impossible, isn't the BUG_ON part missing
mutex_unlock(&kvm->lock)?


