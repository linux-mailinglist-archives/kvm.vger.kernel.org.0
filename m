Return-Path: <kvm+bounces-16729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 564AF8BD036
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CE5C1F261A1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 14:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD10F13D531;
	Mon,  6 May 2024 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hdtuAoz2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABC113D524
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715005377; cv=none; b=tJhvojMYSG3YlrGwCo0alv09TaRgvgGplYknnakXazLgvtHam7GvNWmaoXuQl+krJDuBin6vF4KBdghUl0hdysl/A9u5syWlPz5N1Wp+7SbKRL3mvR7SLMcuzicoeGV+cq9MBD4WWXusPH2oPpBL3gdLjaXgQAwaD/frV9PalPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715005377; c=relaxed/simple;
	bh=zXf0oRwKRa35Uf2fc5HFWAslshC7yIuk6N3qMAfpum0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=omB+++cIppc17QyvaYURJoOV6G6ePDtrqJuc5o5a2H8pzC0x0QcAvAiM6Boh2/NiEDrvLu1w54NNHLRlBHFQCDhPgrx2sKDOOfBYUIovT1I9a8jLFsAYc9REy6K0fKVKFwB/Lr9fjwl+BrTEtMatwXgO27iJ1wQ9pWDm6nkvb9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hdtuAoz2; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-613dbdf5c27so1937553a12.1
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 07:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715005375; x=1715610175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZAxLlaFUQ5Nr5uKqQHOxzk/Ui78RUbkGzJjGGlszQQ=;
        b=hdtuAoz2zKdxmym7GK/KmJSjiXTe5IGtwPk6KqATkZxogB6jev4KZB6SfzJQuIKqug
         FlikVztei0jpJfqJfwuhrWUUEJtFKX9g9aek27/zD5Vr3GyjrvjGxo1o1kwrnE3Te44w
         yehbnsCckNbfKpp4l4g2yRYigeLf1IiT2Qu+1h34uBXPkGFy98/A0n9gG4rmIv3VeU4E
         ai04so6v/2yOxz08nxKHNo951++H5Tzu3j+TqCI5kxW1j9nBgzKHxkRuGFY0nxQdBg2Y
         Egvw/M7n3dJQ7oAZE2cAq+rtHsedhhhZYORmnI+2jH8SEMoNzXt1M/ACTeAAn+aahrWu
         E6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715005375; x=1715610175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZAxLlaFUQ5Nr5uKqQHOxzk/Ui78RUbkGzJjGGlszQQ=;
        b=XDspK58ZIb9+q0jcbO4Katw2REkSFdq6HNFEAA58hZAaRcjAUqWtdeO5dqcd+lB1nX
         0t6KyeZ3pof/ivizWyBPqjR5M3r6zkndxc2C01F0XIZRdcNT2qy58Q6Nj/RTsClcNt0j
         WB8epvVIIaOuDpJfrzQWuWcwWoPPpslptI7wpc+3a6KT8i6koHgcmub/s126CF53z3cc
         tBKyWt+Mb/6QIVtH9tpsHfPsdcnHid6G7L7MuVctWQw8B8V5QUHqJhoFU+yPHjBdiMcn
         +BJDwlzD5FDgNjJrfYbqLWF/c7dHCRbnCAeO+8obKxieSFrwbxBH6iAkVOjXV0r2ZytD
         6q8w==
X-Gm-Message-State: AOJu0Yyzmd0707tT2HOOD8Sm0IsrCBM2DvN41RdYengO5mlH1Efvy0oO
	Ix0b6EVy6Gcngjr6OLn7rcX+OIYwssg4dG1vf/KcEkygVgZcryXYde+DIykfU47qo4zt1y7DM1C
	Ccg==
X-Google-Smtp-Source: AGHT+IH/owV+eNDXQLus+KtdeokiUbI0DgWTjOXkHc3rV0x1HkFFBn8QIgpOzkYZpgxSZWQTwXt+QQrz4Cc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:52a:b0:5dc:aa2a:7790 with SMTP id
 bx42-20020a056a02052a00b005dcaa2a7790mr36794pgb.2.1715005374547; Mon, 06 May
 2024 07:22:54 -0700 (PDT)
Date: Mon, 6 May 2024 07:22:53 -0700
In-Reply-To: <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com> <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
Message-ID: <ZjjnvfSxBtS2psgh@google.com>
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exit_qual;
> +
> +	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
> +		/*
> +		 * Always treat SEPT violations as write faults.  Ignore the
> +		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
> +		 * TD private pages are always RWX in the SEPT tables,
> +		 * i.e. they're always mapped writable.  Just as importantly,
> +		 * treating SEPT violations as write faults is necessary to
> +		 * avoid COW allocations, which will cause TDAUGPAGE failures
> +		 * due to aliasing a single HPA to multiple GPAs.
> +		 */
> +#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE

This does not needd a #define.  It's use in literally one place, one line below.

