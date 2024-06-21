Return-Path: <kvm+bounces-20303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FF5912D3A
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 20:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42A4F1C22CBE
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 18:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A438917B4E5;
	Fri, 21 Jun 2024 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cvbs2Gzz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709C61684AA
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718994758; cv=none; b=JTMfB7gm5zCcTFCeH1IZB8zgNjcmvV0qZ0ccVzYt9y7riD7cuaHUcAWN5BTxScth7WNgajGFUzmdzlwRpbRyb/ayJK5ashlTcImIR2yW0QWwsftI42mieZgd5va8bkDA0ch50TOce5qt/3SzxKadLnj8BGh4gVqmTjJxwZ3eEXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718994758; c=relaxed/simple;
	bh=0H34soARn+l9ua3hOFI0BtyYnn5z/+diQyMIqihfAwY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ofUcvnX3ZW6l0K8y2cm2xTEObw8KyuF6cPFwtEZRX7yLAr7WOiom/2qCq3eQFEqHpm5g1StG2t5Ko9WG4NsY5W4Sy8iOBpKDY7rGFfCKG3RNTFWSPyWgz5xad2jTRt59w2oQ7zj68Ck/NHf6zDmJLoeixKQPtdUZzXz4d8DZcMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cvbs2Gzz; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62f46f56353so37688927b3.3
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 11:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718994756; x=1719599556; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wjq+poPO8VKzj2zS+5inMc+koR44iKdQ85yHH57Hmm4=;
        b=cvbs2Gzz+uUCkXQJddyah/FnohdJxL3JJG2tmjixdVONRsfod4QQvpNV9vf8/68R/A
         GuwkVc5W/vWM4aC383r4NTBBapf0+91nGWUWFo/Kx99zUq17lSm95Dzskt2DYW80F3a2
         CTeO+nsmkAEEH3rj/U1Meu24tw39QNh7ADjGVYkn1L4q8UzpcywSV9XM9a4PiLfMTDPc
         Jy3w2YkNr7NlKk8lOxPa+KFFzwhNCJ69Bw6Xh3ZsScaftie+5MOrzIdalUTQ3BveDQKg
         T9GYGnz1ZQmYjKm2ReGayBb2YyWzVZ0lvThABurWwFALGhAzv/st4oZ5b33Xi/Rp2e97
         ysqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718994756; x=1719599556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wjq+poPO8VKzj2zS+5inMc+koR44iKdQ85yHH57Hmm4=;
        b=bx9Bnslbf+4t91jlCHfbwSRYbMXTk0+RH8LIoke0B2ZuMx/BxXAi0DJnEprEC355NP
         AynSanAzV8BaerjhdYM0O/m9U2dRWpsVS7abkglI0TXherka1dEg15e9xc3NAkmZjrEr
         yIy6+L/tpC9uvOegOULTmE7znrkbFIPJHCIRUqkk9bm/5Yl4ElMAAvKtT1Yy/lLNHpHB
         Gy64Jc9wf2dOJyd7sIXVsDCRm8BxhUWtU7ztCCTcNoj32+AMWfgBUs2YqkCKZqJo1PJF
         TmrnmBfLR8WDNqmoMOJaqF6JfWlzjps0xDeX+2RmBsgSqwxLqFVMZx/fIM0hvpXN9zBq
         vs8A==
X-Forwarded-Encrypted: i=1; AJvYcCXSLUNgRaHPBa/c3zFxNE43PbtdPaLM6PG61XeU2DuIvD9zilDrkbCArQLiX5h7EQIypt4q0VtHzX8Rj3MLrP8KydI+
X-Gm-Message-State: AOJu0YxP18e+GLl27kSllQhReIyJhYqyICWzDItV3j5m3Tkk2qo5T6y4
	3ksuCZvoJ4a5P+4NMhCNbHwCHZs5HBFJh0Ri59FUFwi443JcV1u65zcnPO1vY32xNS3boBQ+S9n
	1rg==
X-Google-Smtp-Source: AGHT+IGEjW89Y/O/38ZL3Tnu7qb0RJLIju4LabxToEhzi7MadqEX4RhJshNX3Tuav4hl19hd3OuuQC4QDCc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:25c7:b0:62c:de05:5a78 with SMTP id
 00721157ae682-63a8f524cebmr11574467b3.6.1718994756418; Fri, 21 Jun 2024
 11:32:36 -0700 (PDT)
Date: Fri, 21 Jun 2024 11:32:34 -0700
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com>
Message-ID: <ZnXHQid_N1w4kLoC@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 29, 2024, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> that is backed by struct pages that aren't currently being refcounted
> (e.g. tail pages of non-compound higher order allocations) into the
> guest.
> 
> Our use case is virtio-gpu blob resources [1], which directly map host
> graphics buffers into the guest as "vram" for the virtio-gpu device.
> This feature currently does not work on systems using the amdgpu driver,
> as that driver allocates non-compound higher order pages via
> ttm_pool_alloc_page().
> 
> First, this series replaces the gfn_to_pfn_memslot() API with a more
> extensible kvm_follow_pfn() API. The updated API rearranges
> gfn_to_pfn_memslot()'s args into a struct and where possible packs the
> bool arguments into a FOLL_ flags argument. The refactoring changes do
> not change any behavior.
> 
> From there, this series extends the kvm_follow_pfn() API so that
> non-refconuted pages can be safely handled. This invloves adding an
> input parameter to indicate whether the caller can safely use
> non-refcounted pfns and an output parameter to tell the caller whether
> or not the returned page is refcounted. This change includes a breaking
> change, by disallowing non-refcounted pfn mappings by default, as such
> mappings are unsafe. To allow such systems to continue to function, an
> opt-in module parameter is added to allow the unsafe behavior.
> 
> This series only adds support for non-refcounted pages to x86. Other
> MMUs can likely be updated without too much difficulty, but it is not
> needed at this point. Updating other parts of KVM (e.g. pfncache) is not
> straightforward [2].

FYI, on the off chance that someone else is eyeballing this, I am working on
revamping this series.  It's still a ways out, but I'm optimistic that we'll be
able to address the concerns raised by Christoph and Christian, and maybe even
get KVM out of the weeds straightaway (PPC looks thorny :-/).

