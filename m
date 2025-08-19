Return-Path: <kvm+bounces-55052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B1CB2CFB5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B24F118985EF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1D826D4C0;
	Tue, 19 Aug 2025 23:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fF1dFcLJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C306D257829
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645196; cv=none; b=RUSS07Qz/nAlgOXn1hq8oThH7+okeLlIrmOvaq144JqksTXHANySH4hWrGDa0YMNOVgncwTPtMCUfrv1JrB8I1+3B8WJ0PnMsV/vqkS9TMApGahCGWR0wirtByuG2Nsa6FepN+MKKGbej1tJfkS0J9Un+cLhRTwiGKiMHqLtJz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645196; c=relaxed/simple;
	bh=DbAZcsaZshw2pNAUw1kCvwfgjZLncgG2hcDz/z62HlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ug+l7IupPPTZI5iZ+yFfwRP9SLMwzs+GXR01jxC5zfK5+/TR4IVjnKZjSjVZIe1l/SCgQ2pFWDaPmie9p/vf5zVITWH8HzPtN53Ju9MMv02xdl3ALWyNrE+ZpbCcaFfkD9wI3ZxIXt2oIUYqYuM4oIUv6WV4e7w5lQUlPLx3B+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fF1dFcLJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e017eeso5717121a91.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645194; x=1756249994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6cpBgZnCZWHCkwWtr/lyfImXHFPj8pcEoGwl3xBymtc=;
        b=fF1dFcLJ2NsBd2DLDPJCeTWq7hUGgPhxqXStdaIvBaexqJRbtc5q47UE5x9/HQkVaj
         c4wPdFElFumAUm97FB4ADk2vWAVYZFhjP5WgcQFfISwAvM35yvRFznhtpP/768ZItF1l
         Th+SKtDmwaVSgi1Ym/vheagejEFnKdwuN/b7xSdKyzPY/Q7L8cLaP9dvpjhge6zcQnXb
         b5urmrOfQyJSC+v1Xu1s7LiUU9vx0q/zhVEirt7/Qiyon2npTfcUfA+n4GwrvoqUhMRZ
         ZFNDfEVRiIxGJbt6OXTvw74k12DMl4hPz1Y8ZHf4T+SrZXWyab4mpToWcgEOoWrpNLuo
         P6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645194; x=1756249994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6cpBgZnCZWHCkwWtr/lyfImXHFPj8pcEoGwl3xBymtc=;
        b=g29BlIc0xNjeSznuD5rTbFalDH6t73XdAJHOdycWudcQ4xg7bALqH/LfO+48SSkJOo
         C8lTvW++tVAYqKDH+o69gH/3Tw5AR1Qa5smwjLvyzHwk+ah8gKN5B/LqeRxfTS9HiJgM
         u//iZ+FtKeDkCSuxVo2hPCnmvntk3fCYH29BIxwhXU3gGtvoVRt5N3hrC93l2H6qsZAU
         55Vw4a3zIXO10i0p41gf2nOegerrsmNaFF6WcRHZJuOm45CVYYNhxcwbz3RTiL7yDQLk
         JNQR9ADFvKe/HDv3G1NChDKPtEZURaHM7CQv4zh8Oq2VpNw6dafGeU7XoVcqXuD5qKBY
         V0WA==
X-Forwarded-Encrypted: i=1; AJvYcCV02tu8LD2NPuQ7a3bpgYoO++i+UAeiJdfDdCBsB8I5RoNSzEYnTo/G7rTluGTTisKNNUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwukVbffXVXobeNBVTdfKNnoZBmcPiWt1/sW4Js9dmG+kv3gSh
	FGWu0fiq18d+t/VX9iXgd9K+K5f/d7+Xky8woW4+rWCmf50F6MQkFyr7PVZicEpp/x6w9KHMXev
	dNK6aUw==
X-Google-Smtp-Source: AGHT+IHXZS13Wm/enoQeQIFj+zvIoKXED9dxG+t7ZlOZFWM4Dh09uHpf+AoKBfn4QU8WpzxBIqjlq+kDnZ0=
X-Received: from pjz14.prod.google.com ([2002:a17:90b:56ce:b0:314:29b4:453])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5788:b0:31c:c661:e4e
 with SMTP id 98e67ed59e1d1-324e146de63mr1072066a91.33.1755645194177; Tue, 19
 Aug 2025 16:13:14 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:11:51 -0700
In-Reply-To: <20250811203041.61622-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250811203041.61622-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175555262137.2808532.3246238140019941167.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: fixes for SEV
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yury Norov <yury.norov@gmail.com>
Cc: Zheyun Shen <szy0127@sjtu.edu.cn>
Content-Type: text/plain; charset="utf-8"

On Mon, 11 Aug 2025 16:30:38 -0400, Yury Norov wrote:
> From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> 
> A couple fixes for recently merged sev_writeback_caches() and
> pre_sev_run() changes.
> 
> Yury Norov (NVIDIA) (2):
>   KVM: SVM: don't check have_run_cpus in sev_writeback_caches()
>   KVM: SVM: drop useless cpumask_test_cpu() in pre_sev_run()
> 
> [...]

Applied patch 1 to kvm-x86 fixes, with the reworded changelog to call out that
it's a performance fix.  Thanks!

[1/2] KVM: SVM: don't check have_run_cpus in sev_writeback_caches()
      https://github.com/kvm-x86/linux/commit/923fcb3dbc02

--
https://github.com/kvm-x86/linux/tree/next

