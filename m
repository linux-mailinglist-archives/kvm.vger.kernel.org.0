Return-Path: <kvm+bounces-18831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E970E8FC00F
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7885E1F2264C
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B352515218B;
	Tue,  4 Jun 2024 23:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GxAcxGNE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A637C14D71C
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544406; cv=none; b=JiC0a7r0KN204bXiysU6CR/5DaldEEPSo9fRJTq8CLfeMsGkqWaXuOfL35Wmgc8V33vMbM3Xb6PXzftwXHAc43Uf4IvLfgKAkwNvsfg7Kv3QxiC5g3wxM+RCsmrsREvAImz8ybyA8CKyb8jTkmuUTvmqAiRbwCaZIW3jTflBcHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544406; c=relaxed/simple;
	bh=K20674vbTA6e4Mc8a4eEWVOJb8WC1M5eduSCbUsHEfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=n379EHAX1JzWyH+ejyrIhq1/aDqmAvja/Sxnu2sSOj6WV4vjisV8SqLXwh8BVy44e0FuTuEma5ANQB51XkmqePT3/iuBoS8oIejm9q6kAGi74T+mJGDiM0UbGbdbk2+VQSir3NNWJWKbNNfbUygS03+HTYUZ4M6AvrnoPBEK5mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GxAcxGNE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c1bb32d87eso5183909a91.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544405; x=1718149205; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lfqZkxWiUFXs+Smpv5BhGJvVqEtSydrq8RLVlLN70tw=;
        b=GxAcxGNEIuml64fSSEdlRcqocLFy9+zX2F1KYitJ5JB89tfDk2H0WiHajHBdk5raIV
         xBLAdYV5XurNWaw/Wp7yqiHeZHYwuEFK58n2KQAQKUa4tq9yISdK+4k2ax9XY85yekou
         9lFbMYWKbNGBxEZWOze7MMd3UwEEcEdH3Y8/kSWSoME//M6RelDVvQcDqHqS4mVjTjDV
         2pjpJHtKc0iL6Tn00Bzgk3WcISBOMxhL83rr70eNgKto2VSDRT2Xbxkd47bGH1mPrNcl
         P64YH0kS0nZOmxaimWqqubO/ueABrFFIL473ddUmQ4DuaQ7PkMF+vW0KdtDd06h1a300
         Zung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544405; x=1718149205;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfqZkxWiUFXs+Smpv5BhGJvVqEtSydrq8RLVlLN70tw=;
        b=chKbPGY/WQes9gOKqa6bG/TU+jSuYMhkXMka5164s5qodadPzqqgqe6BkG315kVra3
         udgFNgXwjhPWCy8etHtTnb0KR1o8PEFW8KUdybl5Cnm0Yd8FjhptHe3CoiVteR7116c+
         sufuQ+CSCjqpKkma0xzuX1005VrdstZLga4t/XKVuZ30OixkNpQ61eGKGMp7cmuNXL/f
         krrmwSUGuO6/aIejVjtQuTfhmTP3v2FTPLtnp/p4ZYyZKyug7p/nmoYjGxRa7417Ri4g
         CXyyiM0a5pfxeUexhX5a6lMu7GvgfIy02wO1XmriJB2HLtaKrofXIF5AQCfh39cqGmLY
         H1Tw==
X-Forwarded-Encrypted: i=1; AJvYcCWuNLxmop2Jo/bL3/xSbUzj2uc85C0XkYFNGh8LKMCyEIVZZu6erReIjvMT0AjdO7Jt4OsnQvpWYH01uecAL09cLPf2
X-Gm-Message-State: AOJu0Yw776kDzcim2C8bFDAeQf0mjqfYvJWNmudRbZgMeP0O+cyBrmmc
	97jj0iq/TSw9NXrSZ33vWyv4unWJcFzLQ4725iEDzDQPN2tE+emxnqFnIiZTguAjbmf9tbsiGXO
	O4g==
X-Google-Smtp-Source: AGHT+IFxtxEqjmVp8/kH2Qth4/863K555VQ5O4vmSNtNdXp/quRdJ22+vGKICOD8/uHgcqggI9XTX3xlIMU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:784:b0:2c2:4109:6a5f with SMTP id
 98e67ed59e1d1-2c27db65874mr6079a91.6.1717544404810; Tue, 04 Jun 2024 16:40:04
 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:55 -0700
In-Reply-To: <20240520120858.13117-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520120858.13117-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754376695.2781015.3069627762821218444.b4-ty@google.com>
Subject: Re: [PATCH v3 0/3] KVM: SVM: refine snp_safe_alloc_page() implementation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	thomas.lendacky@amd.com, yosryahmed@google.com, pgonda@google.com, 
	Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 20 May 2024 20:08:55 +0800, Li RongQing wrote:
> This series include three changes for snp_safe_alloc_page:
> 1. remove useless input parameter
> 2. not account memory allocation for per-CPU svm_data
> 3. Consider NUMA affinity when allocating per-CPU save_area
> 
> Diff V3: rebase
> Diff V2: remove useless input parameter and not account per-CPU svm_data
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/3] KVM: SVM: remove useless input parameter in snp_safe_alloc_page
      https://github.com/kvm-x86/linux/commit/f51af3468688
[2/3] KVM: SVM: not account memory allocation for per-CPU svm_data
      https://github.com/kvm-x86/linux/commit/9f44286d77ac
[3/3] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
      https://github.com/kvm-x86/linux/commit/99a49093ce92

--
https://github.com/kvm-x86/linux/tree/next

