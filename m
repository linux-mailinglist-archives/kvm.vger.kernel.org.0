Return-Path: <kvm+bounces-19896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6AFA90DEA5
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70EA22825BA
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3CC178393;
	Tue, 18 Jun 2024 21:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s5HoV1R3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844E115EFAF
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 21:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718747039; cv=none; b=lBMgU96dt4v2pKsAb869bS9Bn4iga/nTdBlcjUr/tGo2Bg5n5T8Dfhk1fIaF/LXrSv1+6kbKlHRfvlcnJKiaPvRt/jW7YMgokuihfWZe/tOoqhKm0MaxyBQAyNTPngAkqHCeq7WgPLmrU1pidPygViQ1PVvvWbnGJYl27nKNg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718747039; c=relaxed/simple;
	bh=DLUk1H1l4ZeqIjMc1pYUzfOJVR3vak2kdq+12go0bhQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IkpwhlicYXaMBk4/UpKnfhjF/Higb/Qn75/qL836HxMzuqt7Sl97p+sTbAwIvyWsvu/6q2IJhXdr5m4IvbGYBsk8LnRusMdmSDxkKvSI5CUNPQsvmwmrn1E748wuKwyu9WGd+59N6A5JoeYbrPih8xV7OL0KhrNH4JelYJTB8c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s5HoV1R3; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dff4a650404so4424135276.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 14:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718747037; x=1719351837; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xDoltJVQ7zR6NCEuSMFubyNCVkbnipGqI79mQtN+sq4=;
        b=s5HoV1R3BIfXbeKIgz/fe9vyQNFG5eI+wVdeKsVneXyaq+U9/Z1gAMhZMf/nTrXb0a
         duUyquAVKMfJBd8T7Mdhr3Eeak2qeHo0/vYSpQGkH69GvWT6cRQ8m27/UQHZAMwNb3LS
         iMh8OeUhmwmm9zNBVGQMyGKeFFn57zlSFA2zjx/hyj1NU04I1ihpQn5y+d0j0FPuTc7O
         URQZGypnNUxUOxiEicdZkQapz19OeaDFaPOV3XiU+xyYN3npWzRIkeISP5bm/FJSui+1
         bgjCD8G8ANJBXz7PtyIE3XX0piwa9CL/jhn1PMPW5TMFgzTB/SEd7KeM71/3RKF/cagZ
         Kf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718747037; x=1719351837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDoltJVQ7zR6NCEuSMFubyNCVkbnipGqI79mQtN+sq4=;
        b=Wx/s3E7SytY/GkiB3JtHr2Xo76JHfPPUBfvqKFG5WpJqGYAe3zm2LBP10ssw+P1Hut
         1G6jPJytJep3Jh7FTlZ3ZxjQ95wON4OQvIIhMXPd/iXmv/qJ/ij2ptN/Ng6dqSRo12TD
         DiakvY36dh82tVDG5KRCI/FMkx4zESa/WOk5ukZ6MoZoK1fYBmekv/4M6voI9VUEzxF/
         JjFj/Roez0Pdmvhu8x6sxN2vz1mT43A1I+AwN/eVCjlYrSB1JWpkYRep54cf7PFY6FM1
         UAoUl/ea5O+ewjwMbgxienTAk7d/HF1nfJUN3ROhv6nSfVKN9Y85Dpv6j37UepE1uMW0
         jTuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVUVrV1i84WX+TyXrX7Ueij68TOfePjUI+t0bBUpgIGshKVDdYOFJbak/EM9q4t13bD5L/H/DI11RxT9aIT1PLHvDa
X-Gm-Message-State: AOJu0YyH+VB7xJ9K45rPsq40OyjEvk0EfBC/Yqju1hts6a56KKUEWhB4
	D2JQaz5Ma/EFnoC1sTF3ZIRJIn9ltT7ORfXmU4ayaFmOkEY6rEAzivbjVqIMsX9pFWkmZrMx3Jn
	vMA==
X-Google-Smtp-Source: AGHT+IGbprsDdgHYY1PfaO8dbpnyRSi4ZlsM6r4nYlbWbmwkVMmNuHK1CDeg8OXRFAAI5wAMi0F3mFM3pa4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:51:0:b0:dff:36ec:fdbe with SMTP id
 3f1490d57ef6-e02be23cdebmr62359276.12.1718747037555; Tue, 18 Jun 2024
 14:43:57 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:43:55 -0700
In-Reply-To: <20240614202859.3597745-2-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240614202859.3597745-1-minipli@grsecurity.net> <20240614202859.3597745-2-minipli@grsecurity.net>
Message-ID: <ZnH_m_83ip2rdpbC@google.com>
Subject: Re: [PATCH v3 1/5] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 14, 2024, Mathias Krause wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 14841acb8b95..b04e87f6568f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4200,12 +4200,20 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  /*
>   * Creates some virtual cpus.  Good luck creating more than one.
>   */
> -static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
> +static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>  {
>  	int r;
>  	struct kvm_vcpu *vcpu;
>  	struct page *page;
>  
> +	/*
> +	 * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
> +	 * too-large values instead of silently truncating.
> +	 *
> +	 * Also ensure we're not breaking this assumption by accidentally
> +	 * pushing KVM_MAX_VCPU_IDS above INT_MAX.

I tweaked this slightly because it's not just accidental changes we need to
guard against, and to "hint" that vcpu_id really should be an "unsigned int".

	/*
	 * KVM tracks vCPU IDs as 'int', be kind to userspace and reject
	 * too-large values instead of silently truncating.
	 *
	 * Ensure KVM_MAX_VCPU_IDS isn't pushed above INT_MAX without first
	 * changing the storage type (at the very least, IDs should be tracked
	 * as unsigned ints).
	 */

> +	 */
> +	BUILD_BUG_ON(KVM_MAX_VCPU_IDS > INT_MAX);
>  	if (id >= KVM_MAX_VCPU_IDS)
>  		return -EINVAL;
>  
> -- 
> 2.30.2
> 

