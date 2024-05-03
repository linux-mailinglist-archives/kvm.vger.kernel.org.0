Return-Path: <kvm+bounces-16548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C558BB62A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB6571C22416
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D821311B9;
	Fri,  3 May 2024 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2oROz7I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432CC131191
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 21:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772232; cv=none; b=IdamHgtRkgy6OBjj2vsXsYk8pMkz5Y46mcG0wGeOch8nShGEcTbwoYoxkGyXiQnj/uJGsFkYl7v96iK2mtLTh+9fT0RCeQBSuKuU5sSdA9qCxf1FlwAQuL58w8y/AldIm6UdgODqgwEIQng+he8xh9GMgGAx78iwViWxyibwMRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772232; c=relaxed/simple;
	bh=T78GnKXhmF90EUMcoihJXbtnP3USZWPjBsko2Q+gE0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BhBFRLi2P8X8SAvxEGY9ZJb4bqSqDDaCS7RI7UVKYLZ7wjSTuBLujPwUSRf0PMmHuRH1HtZ0+EemwothUcZiU+xATvrwz847Nrtlm+8ViFPvp6E0WE1ZcBm8bwposJzECNLsZ99XJJTOXSYDGYZ2rwlgC5ktx7Olb5c6wXGPX6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2oROz7I; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-613dbdf5c27so116122a12.1
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 14:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714772230; x=1715377030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pRR7KPd/cLlG8WnQvndczDv6yBxPP3pjh1dorGD2J1c=;
        b=A2oROz7I7ccpF8L/yzqrHr6oyYtnT2BmZL7PsXAbOZ7bNjfCdWLfSIt65r0tC5l5EN
         g1A6ZkgznrVOeWgPVGy+74b7yHtwE9G3ksvHpoePG1lU9Cb5nE9WgRXDNSM1I94tY2Xr
         T1wnJPQzgJdm5WugjhuAD8LBgxF+rzkz1sk8gE1Un7dHuLje3W8RCLtfqw0i7ArimW5x
         o8Nsq5h9fBNv4FZoRT5HWp0vMmXTvQQVsbvjaqVl1SNrs5kpwXVC3ZUORdn624rUpK9B
         W1rOkyydBBkF2KWez2C7QJeMmZ9rYUX/PdMbDnUzw8f+Ell0X6Y4xHjJL69z7fkgDt2/
         yDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772230; x=1715377030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pRR7KPd/cLlG8WnQvndczDv6yBxPP3pjh1dorGD2J1c=;
        b=Pxv8gBstBbWCwat1JERdx93NC9ZGws9giEpGgSx4epyUWaal4c2x6vvT1UtbzeWQDw
         goYP0IoNrRiLu1Hf8N6x0/xtMn5hX0vt3UVySg1EYF/QnXlTL4bEseFLsftXZh0TwEhS
         pNCkkTxWWH9ZuFGBkPTkkzHuS7sQ1+OoYd7SZQ+3y4ndpPLmMlnNCUOllCgsm+m/d/b9
         qH9Dk8/lFTAIneJcvweXV9rHjJAkrY9OkJl5o56S3XdcF4J5LSjzCidKsz+BCoJw+S+C
         Gj2k/dgOVeEugWQPaDyEYKqsFhdtfR3LeMHUOaJQE52ADjK+kcEMrh8JVdxjoYA8unpd
         aTqg==
X-Gm-Message-State: AOJu0YwEOnVNqh1DTSVvzwsOEuusSLNZiXS8VaHpfKexwIN6ktMswkCD
	ANWJP1CnJ5r0NngLpjiGX/yjr56j1mR1DYA5lSVR7fxFlBaFgXvkYc+JPodcPzvrfJmZvz22zqE
	Ocg==
X-Google-Smtp-Source: AGHT+IGEgo4+diPoiyuTt2VZgasus5eMXUGK6JnD9ACDfLFd+or60o4UK1xIIX86iYt1vb7LAQ+9d2Drm40=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c2:b0:1eb:ac97:6c35 with SMTP id
 u2-20020a17090341c200b001ebac976c35mr165223ple.9.1714772230517; Fri, 03 May
 2024 14:37:10 -0700 (PDT)
Date: Fri,  3 May 2024 14:32:26 -0700
In-Reply-To: <20240430162133.337541-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430162133.337541-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <171469160805.1008906.10298105633797388106.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Require KVM_CAP_USER_MEMORY2 for tests
 that create memslots
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Apr 2024 09:21:33 -0700, Sean Christopherson wrote:
> Explicitly require KVM_CAP_USER_MEMORY2 for selftests that create memslots,
> i.e. skip selftests that need memslots instead of letting them fail on
> KVM_SET_USER_MEMORY_REGION2.  While it's ok to take a dependency on new
> kernel features, selftests should skip gracefully instead of failing hard
> when run on older kernels.
> 
> 
> [...]

Applied somewhat quickly to kvm-x86 selftests, but feel free to provide feedback.
It's the last commit in "selftests", and I don't have any more selftests patches
in the queue for 6.10, so making changes if someone has a better idea should be
quite easy.

[1/1] KVM: selftests: Require KVM_CAP_USER_MEMORY2 for tests that create memslots
      https://github.com/kvm-x86/linux/commit/8a53e1302133

--
https://github.com/kvm-x86/linux/tree/next

