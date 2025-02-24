Return-Path: <kvm+bounces-39021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BB55A429A7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 682561887F5C
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E23A26562C;
	Mon, 24 Feb 2025 17:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O6ImVaTv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B469262809
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417944; cv=none; b=ERl7SKUs1yju/GLSvgDBr0j65o7Sl45dgY0/OD5OVFom/Fh3ZlNFZp6Ub9eBzynBzCEcTmeCuH3L4fYK/TkfM0vV6wCoIGNNh22d+8OnkGyVzcFvsQQe8jGcSI6wtGFsMHAS6qJTi8vt42Hyg6ZCWeywd1qPGJRhnrH72Y3ifNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417944; c=relaxed/simple;
	bh=PofSd+Is4SBmsv2FUszTRpxBnvCquAoafQ7MS+Vrz2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ttw7d9DMbIqQfST3GlW38/tZZbB7XwZN1AKojz47SPO7QuHnhzryrzTpMXzFovxBKYr5+GkbLbZoNpthjl0WQXYbFv/Mcluic0t8z4ietePrB3j589xKmO3cdSIQUevMjJ/6/n7E++CCappLTThuGQGgsVU6x1+Yqh19LVLOgKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O6ImVaTv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc45101191so8988708a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417941; x=1741022741; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FKXGuirbevoDb4DVB8lVtI4tToxsiEk/EpygfhBFyqs=;
        b=O6ImVaTvdK8qyLmO0opiY8uDqp4YP2w2x2wEoIW+Z9Ac4SEW5BSBs8OqbNq56J1hE3
         3FYhHjLzW8gfdfW++WqbEuibIhm8LMQttlG8f6xzksAOHti/TUInlF/X7DmWEmfQ7EAw
         MKe+HwBiI37HwLBFVEO2eOu4904I3k0A5HMzmACW1vhlAR55O/CJgKq5YqDqpK1HFsTJ
         bJ+p3+/gufQ50lADlQ0emRqXpIFxrzJNtrh8Gzq4f99CAvGOnhulHZqQT9EWWGEASiwQ
         NT1YS9E92/5D7tNzft0PpCgpELtsLbpqVtFoiqtwkDSPtpSAZl2Zm2MohECy/CgQf6DH
         t88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417941; x=1741022741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FKXGuirbevoDb4DVB8lVtI4tToxsiEk/EpygfhBFyqs=;
        b=jS3AsBWc5ZBtJhBFle7gLpx/IUVIl+hM+4IQoW+8eVfeHmchyMJVbW00erp+3zXy+T
         LR1cLSt2xsrYaS56BFTxtsFxaIkZjAvdE7b9eRUDHDDGwZYE18R9SPCWmGM1DNpw1gpA
         4SnU2EIBzJT8pTafKLwtJ80jjhepm9ysxFiv5yQcDVXWy75kdoLUtmZwjos08SxzK9lh
         XCu/mYMAN1Jpagjtroueng9P6Un5b2dufSt9e1qauF5UwLgetQaBwNiyJ/8gzVgLsUv3
         GC2eShrlZABW0wG48hLpxxwPXtTGUJzgcqRMC/AhOKxU8WF6XiNPJqHWIvhrJUl6tgHQ
         qvRw==
X-Gm-Message-State: AOJu0YypBb04StMCyoRh/0Fvv8LSqXkQQFk0fljN3GWGV3rNnxdsM8qu
	vLBejJQ4fUhVY+/AM0cECpyxnKmiN7E2vVj2a/2YIfiGDCn4yIP2Eq5qZTDTFUQIx+v3t+uwGRq
	t3w==
X-Google-Smtp-Source: AGHT+IHLwZY4N9Odi8BEuoUQVs/Tg8+z28Q8co19p5Z288Ii6zT5l2dxf2z5VVU2/FeAkLyxK+ARNY0SKcI=
X-Received: from pjbnc7.prod.google.com ([2002:a17:90b:37c7:b0:2fa:284f:adae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc4:b0:2ef:33a4:ae6e
 with SMTP id 98e67ed59e1d1-2fce78a31bemr26597810a91.12.1740417941503; Mon, 24
 Feb 2025 09:25:41 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:03 -0800
In-Reply-To: <20250214160639.981517-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250214160639.981517-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041741564.2350357.16011772813519077142.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] nVMX: Clear A/D enable bit in EPTP after
 negative testcase on non-A/D host
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 14 Feb 2025 08:06:39 -0800, Sean Christopherson wrote:
> Clear the Access/Dirty enable flag in EPTP after the negative testcase
> that verifies enabling A/D bits results in failed VM-Entry if A/D bits
> aren't supported.  Leaving the A/D bit set causes the subsequent tests to
> fail on A/D-disabled hosts.
> 
> 

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/1] nVMX: Clear A/D enable bit in EPTP after negative testcase on non-A/D host
      https://github.com/kvm-x86/kvm-unit-tests/commit/afbea997744e

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

