Return-Path: <kvm+bounces-55314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E629B2FC4D
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 16:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 889AA170873
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 14:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0CD268688;
	Thu, 21 Aug 2025 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hX8XqX8c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0485623BCFD
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755785800; cv=none; b=Xw7h21OZ4NirxBgftXIOO+MhGqtLcyYsM6nGNd2sC6v7veA1I5kcFzYTGh0HvEr+EAKNHNdcHB637fO/ICXxKmCYXW6n+0Vi16CwBQZrHfnTRYp3v2XyupzBhIxHRIe/l5TRS59KQJHlmkz/ZA/woBKBIljnIjsRppS722aVp18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755785800; c=relaxed/simple;
	bh=6GrnujQLloiv85HLdi3xqRilZz8RU14igxohRDRKuAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HCp27+KEzRWo5147lF2MXxhtVbFUBg/mI6/yqCHbTCiEmJcH1WgR4ffGsLm0sEBNptSQwqw95GYIE95jIglTLtfSIiMkmotw9HlHFx9bOyoHppOG82DmCfq3gU8lNhSrXHGKWhse8kk11F9k31LiEJqnOD5Xn+B2zD8FQl9/7QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hX8XqX8c; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e21dd6so1987060a91.2
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 07:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755785798; x=1756390598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6GrnujQLloiv85HLdi3xqRilZz8RU14igxohRDRKuAo=;
        b=hX8XqX8cjQDXWvg02mW3eUUWhp56Z6MWmhDfkjLy44MiJdKsdUzytwKp91A3e2McYj
         NA+USpdumAlM8HIyNR37BvOIzpyAIvOoN3YXNWRdxEvvxmA800ICfRLP6GyAzukbKsme
         eQaQ1TFT6Vphnvx5FxSf9fXg0Oec4C/r6w3vjO+DY7sw5FjKPWEsQSw2CJBLYFuKGDmY
         HF4vLSwAnPqskKRUux+Wrtw2goQZTyPM2JQ7ng/BDV1BWX0H5efvUcnm747TzFl1jVUq
         Oe/ogn9XyIumXeZEWj5HPQ9kEVu5vb4j5QLg6agfQ4hCFpNrglMlAmzhgJc98r0xYYf+
         DZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755785798; x=1756390598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6GrnujQLloiv85HLdi3xqRilZz8RU14igxohRDRKuAo=;
        b=DP7F8EtkKXU4HiNyUBKCndkk09Y7Fes1TsyrdY6m0hzx4rbiM+1BevhB44NQ3Ld363
         wb6aNIeG7z2UZDcQjdzipW90CDIA3HGe4PZNgbX/2WtrKIh49iy32oS7SA1Y/UQDLH4X
         EaLuc9StMe4U+cC4EuroA/lQoeKdWSY72b4iXNhQng2KJ4oCnxyIgegNb4FgpIB3bN6N
         3G6qll/lTdalwUPmU1/6YEaidxtj58IyWQaVqvX6VqpFxd56VKMcESV7yG2PhozzG6f4
         HLLNb/EOR34NGQ1yVhoPREBx9NYhYRfiKP0vXp/Es75tFuJ4LUqwXzRUMoifmE1e7Q6c
         An2A==
X-Forwarded-Encrypted: i=1; AJvYcCWryTEsWrXpx6W15dBDN+F8ascgCiWOsFFKtXDJ3QL06TyPvcANaYLqI4wxnbz4Lg8g2xo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz960hJc7qfTzNAn5Be+BoJwkiKBAVZHT8yw6yP2BLT1OpvSc9e
	HkZlrmxRB7PRdom2V3nDifzvsYRqihJAkDR/If7lK68k2ZHS5kMJfBhtP/jxerEJ1u0iawXiRvS
	mG+7T4A==
X-Google-Smtp-Source: AGHT+IFwgalIbtRABlLOHlpKify6KGBP/os4lTVekK7e7XeW4den+TP+VDgQAETfScMeohffbl/PKvnkxB0=
X-Received: from pjs15.prod.google.com ([2002:a17:90a:c0f:b0:325:2de:8b77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2248:b0:31f:22f:a221
 with SMTP id 98e67ed59e1d1-324ed1c0298mr3587232a91.29.1755785798238; Thu, 21
 Aug 2025 07:16:38 -0700 (PDT)
Date: Thu, 21 Aug 2025 07:16:36 -0700
In-Reply-To: <20250821042915.3712925-2-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com> <20250821042915.3712925-2-sagis@google.com>
Message-ID: <aKcqRFWuGZQQ3v3y@google.com>
Subject: Re: [PATCH v9 01/19] KVM: selftests: Include overflow.h instead of
 redefining is_signed_type()
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 20, 2025, Sagi Shahar wrote:
> Redefinition of is_signed_type() causes compilation warning for tests
> which use kselftest_harness. Replace the definition with linux/overflow.h

Heh, tried that:

https://lore.kernel.org/all/18f2ea68-0f7c-465e-917e-e079335995c1@sirena.org.uk

There's now a fix in kvm-x86/fixes and thus kvm-x86/next, so if you base something
off kvm-x86/next, the warnings should be gone.

