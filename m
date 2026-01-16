Return-Path: <kvm+bounces-68282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F73DD29660
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 01:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D558C303D16A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0762F5474;
	Fri, 16 Jan 2026 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PeoYJwlJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96536253F05
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 00:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768522877; cv=none; b=CpfTB3MlONpgvSFA6PF/8H4H8tW6m1g3jscqELw0pBJwkPzDGqEnCEEfiJI/J5DueI+6MUusum6qgKjfGt7MSwz8praygKcbJkUNx4QiGeOhu2yp+JcrW880R9NR4hBF5JUQOPhyM/Loi3g32o8YRcwiXzk8BD4C4lMW/aKAe00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768522877; c=relaxed/simple;
	bh=t4vsBeuu0m/0sbK6tArmtIoE1Hem9tL9dmkzDdMchEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RAq2BWuFrBzhsGforAMCXrBYdBLBifbiRDCaznfAYXdwtBC9ai4YZzM5WCarCddVuLildh4hXI6bg5pCCVlmOs9UQl9SnDlY5mh8OqL580xlmNDBGLSCFAQlgYKaAzh/k/lBTO++Wtd2ASbgyNMfMR+ChH0o/tq8sGNip7YKxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PeoYJwlJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c387d3eb6so903317a91.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768522876; x=1769127676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cZIgcvFFF0bBT+nPZ8VSIoYP9P3jFPcW3NBuTLRkaDI=;
        b=PeoYJwlJpNM01A3zvHDiN4jdPIjZ44TUunJ7YaKae1tUL9SVTs7QyLokMRtHPNIf2Z
         y32xn1oA0QzS1rnU7TF+6qo7VyVl27EzGBHHVV4dfmOiTEMg1JJ/QPWgdF6KPHsANZYm
         G5gS3Fce+gM3+l819d+AlK4soxzOIP+X+VqwyhGmJ66E9AKX3IGJIrm9TZ3Ig0ygXBNz
         namyM2nwwSqIRd0Yxsi7mFyENzMSrXYDwFIIA7W/Y/FXVXPuqlbwmXEy7rv9Y7Qdkn5z
         OBU+4FysTHl1bdhyk/xnj6aM4EVfWw827GaN05Y+lHeK5tjWq1C5+RIdtYfAXhkqUxN3
         9UJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768522876; x=1769127676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cZIgcvFFF0bBT+nPZ8VSIoYP9P3jFPcW3NBuTLRkaDI=;
        b=krZrnh+Bg+e9ctMVg+69hR0XX896U9aGOekrIukymCqkzTWNpzm8pkJV7dfhjOdvJl
         WRYVLolkb6WNQCopRdx8NICcBAW1Ai/bDkArW2UBA31R5SAMr4/bpa2A0tI+P9sThYAy
         K8wskZxgnkKe31HoVsBGerpw+zFOGFOeaqPHO23sVUuEnHAKtF6ICwhhFoXMWsap2mJz
         1pixINtcHQ/WB0NSPr+apk40Hm4Ce5Y+P8KCU7FH2fEx8tnUkSFL5X/uLs8jy/a//TDs
         bktxhCJqUJLuJnTCX6w3C7B80T/jQHroC5eFaaj5+YOpHdJHvxLYER+3m8jnKo64bmY3
         GBBw==
X-Forwarded-Encrypted: i=1; AJvYcCXE7QyyNrB9a8+TkiF0tl/74e8pdCJ9kBU0pCA96xldli7BP4CRfTPy00pXkZnlM9Dn3L4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1GXHYcjpU0VX0SV46X6bE0nGKwOqs6ljAMUKlPr5is/yNmBo9
	3WeRc0NyQgm98cLFyMoZcViNymZpiwECWwzgmDdiTceSG2CFsTCoEMzFJ10mb44eF7NtpkSnA70
	Sl0tMQw==
X-Received: from pjyu16.prod.google.com ([2002:a17:90a:e010:b0:340:6b70:821e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fc8:b0:340:4abf:391d
 with SMTP id 98e67ed59e1d1-35272ef5bcdmr995754a91.16.1768522875863; Thu, 15
 Jan 2026 16:21:15 -0800 (PST)
Date: Thu, 15 Jan 2026 16:21:14 -0800
In-Reply-To: <20260106102222.25160-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102222.25160-1-yan.y.zhao@intel.com>
Message-ID: <aWmEegVP_A613WIr@google.com>
Subject: Re: [PATCH v3 14/24] KVM: Change the return type of gfn_handler_t()
 from bool to int
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Yan Zhao wrote:
> Modify the return type of gfn_handler_t() from bool to int. A negative
> return value indicates failure, while a return value of 1 signifies success
> with a flush required, and 0 denotes success without a flush required.
> 
> This adjustment prepares for a later change that will enable
> kvm_pre_set_memory_attributes() to fail.

No, just don't support S-EPT hugepages with per-VM memory attributes.  This type
of complexity isn't worth carrying for a feature we want to deprecate.

