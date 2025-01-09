Return-Path: <kvm+bounces-34936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 982CCA0806E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A56F77A28AC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14751B040E;
	Thu,  9 Jan 2025 19:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xz/Ymd9w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659D719C556
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736449647; cv=none; b=uGAtH8IruD36HspKNg0tZI+PGaTVokOnlk/eYYKw61GAWSYSxbBCsMLz+TjFrnUoH0qq8YCQho6ycPbUY9fm8JFsBB92alRZWoLIn3jXOWm4N/mpB4AfFER1Fa7oObiKXtooLYNA4ZmKBN8AaraRGYVpKnyEB+agfGbjaP5cur0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736449647; c=relaxed/simple;
	bh=MKdvbtlSNREUD9tQ3WDTw2X1xsQst3yft3V5eJgw5mU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=deFA1wSpi10qoLKEZAIA/T6wA7+L6LLkmco0lgAckMFFOfINHxQ4khB0i8hy6Op6iOLbbcIUGV+kswbQkZOuvCEnXVFyK1oH+JlaQYcdxc9pfmUKy0qtUCKOJ5z3Qy+kMOqePINKMMO/B7LAicrKkdDpp9j9sOo6iMjbfCbk9BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xz/Ymd9w; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso3618934a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736449646; x=1737054446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YAFl8oxMn+4OWiBfmOCqt1n9SmilznMI/rM3XM++rFU=;
        b=Xz/Ymd9w7oz/iVGVBv0L3QhSebymabxGGREZOkbHXntPNr6m4gTLCZruDT9qkNpk+6
         MT/dFkx9LAvhENGBCvny+nreAJupCYBKGx/YaeKKsIS30zMd0L6EfMuayeHfG22MRARv
         cAD5O9tzPpJHtoXfCxrFbP31O6lGr5CvjZb0ENB8JT53P/FlJRyrIQhh0e+QLdzFgkF+
         qJpSlJgZFvbsCb1uePJQUH1HHsaol0HYUXx2QLNyYb1sx4Kyt+By3nMz06+3EF+1CzpG
         pcbUeYn18FkHDC+mytrGtDJn8xp/cwLQ6nh5oT6XEB8L7jxSUYFF3QVXenmbYZCMJ9ad
         FZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736449646; x=1737054446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YAFl8oxMn+4OWiBfmOCqt1n9SmilznMI/rM3XM++rFU=;
        b=is9+vTj3W+uoTcR5d2Vzq5bvQ6kYIBrFuaGaVqx0W+FYZVoPfs/D7BkUt+aEhepYpc
         SjcoK53zMYGQiEBoFZp1YCpeCkDBRRvYOOMDQXuLwm6nMY57UC/y7a81F0lSbBwba4kz
         nobBNcJWnpFqYKspwyX2cpaYo/iaEwyc4ESlawlCqGl+sTCyfaI4Oj1EQSxR23MqeWWO
         quhGU2PmvUxyFwVDHYRKs2yViwlW575xZ7gQ8As/uKFbcNN0Y5waCBOa7Ew9OzYlGiIj
         9LAWP9nwzltv5sOCz1k4mplWJPsT9eWbFoXN8yJgq5yTZ/R9WwG4Wi47omQJej/iZuEy
         fT2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSMqIEFNXEojNwiY6rAUqj5p9cVbUxEKf0mmQr05mKH1/d/RTKYawG746MsJswYNQp2Gk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1I2zuQGd/jsPB3FKm3ULW7ZNt0Mg/9o9VWMPz9RHYkvXh3EI5
	22Jj8/wEwizfE/0XAuqfBp2MgFoisji9LXO+DLW8YFXsEEWPYnvRUYUXfgSP1mNCv7LbSIg6URL
	tAA==
X-Google-Smtp-Source: AGHT+IGfqHfrrOW1TXoHzJjl1gNv82mqMiJA/BmNQ6TyvR9A3FEwcV69xv4bF8nQUa/IsMCkbReXjlWsoDg=
X-Received: from pjb12.prod.google.com ([2002:a17:90b:2f0c:b0:2ea:5469:76c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f91:b0:2ee:d797:40a4
 with SMTP id 98e67ed59e1d1-2f548f09ef9mr12271408a91.8.1736449645722; Thu, 09
 Jan 2025 11:07:25 -0800 (PST)
Date: Thu, 9 Jan 2025 11:07:24 -0800
In-Reply-To: <20250109133817.314401-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250109133817.314401-1-pbonzini@redhat.com> <20250109133817.314401-6-pbonzini@redhat.com>
Message-ID: <Z4AebPhhcQfGVmNO@google.com>
Subject: Re: [PATCH 5/5] KVM: e500: perform hugepage check after looking up
 the PFN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, oliver.upton@linux.dev, 
	Will Deacon <will@kernel.org>, Anup Patel <apatel@ventanamicro.com>, 
	Andrew Jones <ajones@ventanamicro.com>, linuxppc-dev@lists.ozlabs.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, Paolo Bonzini wrote:
> @@ -483,7 +383,7 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
>  	 * can't run hence pfn won't change.
>  	 */
>  	local_irq_save(flags);
> -	ptep = find_linux_pte(pgdir, hva, NULL, NULL);
> +	ptep = find_linux_pte(pgdir, hva, NULL, &psize);
>  	if (ptep) {
>  		pte_t pte = READ_ONCE(*ptep);

LOL, this code is such a mess.  If no ptep is found, IRQs are left disabled.  The
bug has existed since commit 691e95fd7396 ("powerpc/mm/thp: Make page table walk
safe against thp split/collapse"), i.e. we didn't accidentally delete a
local_irq_restore() at some point.

@@ -468,14 +469,23 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 
 
        pgdir = vcpu_e500->vcpu.arch.pgdir;
+       /*
+        * We are just looking at the wimg bits, so we don't
+        * care much about the trans splitting bit.
+        * We are holding kvm->mmu_lock so a notifier invalidate
+        * can't run hence pfn won't change.
+        */
+       local_irq_save(flags);
        ptep = find_linux_pte_or_hugepte(pgdir, hva, NULL);
        if (ptep) {
                pte_t pte = READ_ONCE(*ptep);
 
-               if (pte_present(pte))
+               if (pte_present(pte)) {
                        wimg = (pte_val(pte) >> PTE_WIMGE_SHIFT) &
                                MAS2_WIMGE_MASK;
-               else {
+                       local_irq_restore(flags);
+               } else {
+                       local_irq_restore(flags);
                        pr_err_ratelimited("%s: pte not present: gfn %lx,pfn %lx\n",
                                           __func__, (long)gfn, pfn);
                        ret = -EINVAL;

