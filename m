Return-Path: <kvm+bounces-48673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7246AD088E
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 21:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9F353B30E3
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 19:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC7F20F077;
	Fri,  6 Jun 2025 19:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XT+vTros"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884DF6A8D2
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 19:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749237441; cv=none; b=drf+DrhfZJVaw4lqz51Sb3KOA95VgkSP3mwmsC/ICzh2zhkxwLfgisxOWQePAIDy0TJSqGIQA0Ksl9oSyOzQmkQCHrPqwAKifJYUksgr1ByhQ+jCwMoBc+QUZujQ7ue9Zpl2EznyZ8oZaUprnS4Kol4SS91ZMjr2dX1+HNmhMq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749237441; c=relaxed/simple;
	bh=8/5I89rSig0E8WTLOcQ9dlmnlj1e18AB7yCe4+1P8I4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s9Zq4mxDgTuN3WB9y17/BkT9pC3jZ/Xz5jM8T4G9piODZ1zk/e7r54l1y/Fq1v9EPLArPRlrOb2IIo2efW9jzXLZ2qU4jBKtr7uDA+ERdUmg1XpeeiDxN+tCSOxXDUlb2EDdO/6DkPEPYn3M5ayC5rnbWk5+tIppDmOgTUEdVqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XT+vTros; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7398d70abbfso3819343b3a.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 12:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749237439; x=1749842239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=03M2l8uu7QPriOa9Y3qizZN45yubliiwCghn8obW280=;
        b=XT+vTrosMHVhIQXE6hCwR0EqRp+5UDltBYJHNp5wXb29CbDmUso2DryIpzHpzx3j+n
         6k04OkeS94o1s+0TteXaWB4PvUrMaM9JVKu269b7P9X1BT9e13De4B4RnYHrbvcHSSlm
         51MrbCOZ6Bp67vsoHNN8sYte5rwIkrOr74mwEmcqkdPTnRFGZA8Hkjl7xQ+sJpr3xNc+
         kBBo8YWDVmltbZ1AH8101MMQwtyp+UEp05lnNshthU8n5UKo/7TF1G5pf+UuZAP7qhh7
         t3Pp7ZRE0Np41pplwpfQbc0ZrdEZqXk4TcGCJkjMOgHLtSSCxAH7IX+3KhNskp8PU+rd
         fgmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749237439; x=1749842239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=03M2l8uu7QPriOa9Y3qizZN45yubliiwCghn8obW280=;
        b=pxh2GIQIf3Doyu0Dv6EQIdv1SlUtGT9SS3vtOSeOE/Fgey2THhE7D5bwyeXXg0EF+x
         X+6cZ87snXmigHesq7xXH8yXUqvY0+iiNmNr0URhl1zeaIz22ZmGFr6fm4IHXZ1b2G/4
         1/Vnc1j18VFvG7J23U0sg0KPEkSAdEkBTzQT2Jp5A34DPFC6aJerqQ3GZz6wSzYXO+9Q
         lHLokE0PtrgIIpYEYggzEQGcnJaPOw0GC1mt6T0IFGcc6WL2k/b8klPEQZZ1SueJGzB5
         4slU199Ppe8THFHXu/q2TXkPHS7rZYzva7SgCF+Yq4c7u02N+LhBMqAfOFqlCCrC8H/7
         Ahkg==
X-Forwarded-Encrypted: i=1; AJvYcCU4AvNK+J35Xb48A9FCTpjGwqyznT9u0vmZLU+7r+znsGDa8h60T66qpXyuVPQqopzfcGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnBd2Gr3RwF5gzm3jAxCqO966wBaWstTL7Aa4s4EpU3fs9Efbt
	UT6cArRFNhQUaYbCwSiQh7PW8u1KmkaXIdKcaFUVuPnVO8ig5jCbJsRnJaWQS5heZhVAcVE2CW+
	DrPuC0A==
X-Google-Smtp-Source: AGHT+IGnzJpQPPI2T40fvXyrBrNAEGci091ibTyB6lnhV/NjMJQ/KUj6MExXtocXmJ1DATt6S61Ld0KTGDw=
X-Received: from pgbcs2.prod.google.com ([2002:a05:6a02:4182:b0:b2c:4bbc:1ed5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9208:b0:21a:3d97:e93a
 with SMTP id adf61e73a8af0-21ee2621861mr5318236637.42.1749237438729; Fri, 06
 Jun 2025 12:17:18 -0700 (PDT)
Date: Fri, 6 Jun 2025 12:17:17 -0700
In-Reply-To: <20250425075756.14545-2-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250425075756.14545-1-adrian.hunter@intel.com> <20250425075756.14545-2-adrian.hunter@intel.com>
Message-ID: <aEM-vQZd2LMrerjG@google.com>
Subject: Re: [PATCH V3 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: pbonzini@redhat.com, mlevitsk@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 25, 2025, Adrian Hunter wrote:
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..5161f6f891d7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -500,14 +500,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  	 */
>  	mutex_lock(&tdx_lock);
>  
> -	/*
> -	 * Releasing HKID is in vm_destroy().
> -	 * After the above flushing vps, there should be no more vCPU
> -	 * associations, as all vCPU fds have been released at this stage.
> -	 */
>  	err = tdh_mng_vpflushdone(&kvm_tdx->td);
> -	if (err == TDX_FLUSHVP_NOT_DONE)
> -		goto out;

This belongs in a separate patch, with a changelog explaining what's up.  Because
my original "suggestion"[1] was simply a question :-)

+	/* Uh, what's going on here? */
 	if (err == TDX_FLUSHVP_NOT_DONE)

You did all the hard work of tracking down the history, and as above, this
definitely warrants its own changelog.

[1] https://lkml.kernel.org/r/Z-V0qyTn2bXdrPF7%40google.com
[2] https://lore.kernel.org/all/d7e220ab-3000-408b-9dd6-0e7ee06d79ec@intel.com

>  	if (KVM_BUG_ON(err, kvm)) {
>  		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
>  		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
> @@ -515,6 +508,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  		goto out;
>  	}
>  
> +	write_lock(&kvm->mmu_lock);
>  	for_each_online_cpu(i) {
>  		if (packages_allocated &&
>  		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> @@ -539,7 +533,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
>  	} else {
>  		tdx_hkid_free(kvm_tdx);
>  	}
> -
> +	write_unlock(&kvm->mmu_lock);
>  out:
>  	mutex_unlock(&tdx_lock);
>  	cpus_read_unlock();
> @@ -1789,13 +1783,13 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>  	struct page *page = pfn_to_page(pfn);
>  	int ret;
>  
> -	/*
> -	 * HKID is released after all private pages have been removed, and set
> -	 * before any might be populated. Warn if zapping is attempted when
> -	 * there can't be anything populated in the private EPT.
> -	 */
> -	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
> -		return -EINVAL;
> +	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
> +		WARN_ON_ONCE(!kvm->vm_dead);

Should this be a KVM_BUG_ON?  I.e. to kill the VM?  That'd set vm_dead, which is
kinda neat, i.e. that it'd achieve what the warning is warning about :-)

> +		ret = tdx_reclaim_page(page);
> +		if (!ret)
> +			tdx_unpin(kvm, page);
> +		return ret;
> +	}
>  
>  	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
>  	if (ret <= 0)

