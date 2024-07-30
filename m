Return-Path: <kvm+bounces-22705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8AA0942185
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 22:22:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67D57B20B8C
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 20:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C3C18DF6D;
	Tue, 30 Jul 2024 20:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ehTrVYl7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C896F1662F4
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 20:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722370910; cv=none; b=Dt5jqVyhJjijcX4fd37t8c3FDj/ovUaEIMlCQFyuMWa9kOO7YcQXNkIK+ELWQlDMJ/jMOXYLu/IrpvoGv2D/ff6G/k0dDdhEbrWW/vLD4aDKldw5/zP3v4BvG+ZGiVgC8vTF/LY5y+2vp40kJ9QRhERm4Kwf2CIevr0sSc7yfOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722370910; c=relaxed/simple;
	bh=HxOBAEamRc5o/YLmQaHET0I/Gtrys86BlZ/DJ9hLc6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hMFWR3LoNNgmteh4V8LXxt72gocHRXZdvQlcW8H/vu6F7OTpoxmY5xp2zRa6cRUal57jETEkMchMq59gmXq02ujRAHPu0TTs6mz4JInRTG+/KQSA4f0yB0GG8+WoB7EC6qB5UJueNO/5glDlHL0qdajtr0hA252ftiTDMeOQ8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ehTrVYl7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb7364bac9so213578a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 13:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722370908; x=1722975708; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lo0MEBygX1JypWEaHf/k6xfxdkehMYQ1A9Hdq1FNmkM=;
        b=ehTrVYl7ugsY3JYZO9kauqgaXCi5Yu8YAv+l7pKP0TmcYiOx0XWELMAB7fIpsoD11p
         YMhfj1hr1m9UQ91+UCdXj4PaZXPzMOIeZXLdqI3SxWXrQ511zgMEpkVnTTUVmtcZVJzE
         7ngnSB7TH68MCxRhQpadZVY1l2t/bxixdfXd4n6UiRtFsaHwAKVcPAydTGe0NdjffHGB
         PLPy1PyzzS3ATtrLnCZEixHHRZtZn8h6nWfWB5TUglzgSDVOI9ogDS0SGq90tQ6l1Uat
         77P9xsqtCIhXCKjby9msZnX80QBPk7n/dfYjROGqqJaTj6SQ70N68/dUJO2+9yNFfhEa
         LdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722370908; x=1722975708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lo0MEBygX1JypWEaHf/k6xfxdkehMYQ1A9Hdq1FNmkM=;
        b=HaLbjU9IceD3pkXLT5hIedR+n/lLK3iw1pl2Qwg92jHwMwxCibdiumNZ1c0409WZc6
         25KOFhFZB1m4/XHjnk5wgPOAszOkOdHTjkdnMh3ghh2tsSUPd28/Q55qnRl9uMUJbzR2
         qRcskDKvnYsnAVKtQe/YLVFlmTQV47xvjHoQxmzJapt2DrRz7K6o7JRGviUEX5UAjJrU
         86Cd9wc3nxmD/gcC2p1/8Xt4ZpKma9EZWysXChS4itDsG851u3PWf0XtKMwrX7Cqybp9
         GHI06eJ53EWp+K3qxRgDpKE45qvbp33wAQ/sjqgzOrbqkX6xh/FTUhyh8d7czL+GS94W
         Gn6g==
X-Forwarded-Encrypted: i=1; AJvYcCUzE1baTxr/oxqHzC/OshOZCeGL2MNdum+zqKN31lr0jbvUqiRJE8UBPTuHSE7Q8EiSkwuMgrXOAda4KuMgJusas/ie
X-Gm-Message-State: AOJu0YyAzZTJ6NicnZxvsS7bubSEP7u3gynZMfejVb2jd8SJt4KQRvgk
	ccFcBeNA5Ey3jZegbMW6i4m4eqN0nu7QT0cOBvqaRYuR2ShbCeMv72jCaTyzT8stjSFw6Z9ccFR
	8xA==
X-Google-Smtp-Source: AGHT+IFRxL1KATidTTKhi0tYZI3Y5cQGXURHMsVQzSWYAdVw9bcIrYssZFg0WYN1ZfdRJ6uqRn8d2puX7Kc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ca8b:b0:2cf:93dc:112d with SMTP id
 98e67ed59e1d1-2cfcab4fa5emr42966a91.4.1722370907896; Tue, 30 Jul 2024
 13:21:47 -0700 (PDT)
Date: Tue, 30 Jul 2024 13:21:46 -0700
In-Reply-To: <992c4a07-fb84-42d8-93b3-96fb3a12c8e0@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-85-seanjc@google.com>
 <992c4a07-fb84-42d8-93b3-96fb3a12c8e0@redhat.com>
Message-ID: <ZqlLWl0R1p41CS0O@google.com>
Subject: Re: [PATCH v12 84/84] KVM: Don't grab reference on VM_MIXEDMAP pfns
 that have a "struct page"
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Paolo Bonzini wrote:
> On 7/27/24 01:52, Sean Christopherson wrote:
> > Now that KVM no longer relies on an ugly heuristic to find its struct page
> > references, i.e. now that KVM can't get false positives on VM_MIXEDMAP
> > pfns, remove KVM's hack to elevate the refcount for pfns that happen to
> > have a valid struct page.  In addition to removing a long-standing wart
> > in KVM, this allows KVM to map non-refcounted struct page memory into the
> > guest, e.g. for exposing GPU TTM buffers to KVM guests.
> 
> Feel free to leave it to me for later, but there are more cleanups that
> can be made, given how simple kvm_resolve_pfn() is now:

I'll revisit kvm_resolve_pfn(), Maxim also wasn't a fan of a similar helper that
existed in v11.

> Also, check_user_page_hwpoison() should not be needed anymore, probably
> not since commit 234b239bea39 ("kvm: Faults which trigger IO release the
> mmap_sem", 2014-09-24) removed get_user_pages_fast() from hva_to_pfn_slow().

Ha, I *knew* this sounded familiar.  Past me apparently came to the same
conclusion[*], though I wrongly suspected a memory leak and promptly forgot to
ever send a patch.  I'll tack one on this time around.

[*] https://lore.kernel.org/all/ZGKC9fHoE+kDs0ar@google.com

> The only way that you could get a poisoned page without returning -EHWPOISON,
> is if FOLL_HWPOISON was not passed.  But even without these patches,
> the cases are:
> - npages == 0, then you must have FOLL_NOWAIT and you'd not use
>   check_user_page_hwpoison()
> - npages == 1 or npages == -EHWPOISON, all good
> - npages == -EAGAIN from mmap_read_lock_killable() - should handle that like -EINTR
> - everything else including -EFAULT can go downt the vma_lookup() path, because
> npages < 0 means we went through hva_to_pfn_slow() which uses FOLL_HWPOISON
> 
> This means that you can simply have
> 
> 	if (npages == -EHWPOISON)
> 		return KVM_PFN_ERR_HWPOISON;
> 
> before the mmap_read_lock() line.  You may either sneak this at the beginning
> of the series or leave it for later.
> 
> Paolo
> 

