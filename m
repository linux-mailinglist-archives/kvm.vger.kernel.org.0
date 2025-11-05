Return-Path: <kvm+bounces-62105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61377C37873
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 20:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4402818C7AD6
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 19:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B0A342170;
	Wed,  5 Nov 2025 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HAKZpPRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7EE33EAF8
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762371871; cv=none; b=cUjv0T8Jpi6l5utgAGVRsRuoqBFXD4vXEuUYW6b7e3jjPVpXON/gtPx03+VSrcjnt/JmMoDmqwSrbVzTbXVaMoIEyPLDRm4nHFpDCLl5OjxW4leH11G4TlKY1ldVt9eu6GvND0lYXBBBmT1Sh3ZlCHrMvoMZE61l1n9QghQdxhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762371871; c=relaxed/simple;
	bh=F1PLsq9xm+III7HBdcj18czd5KsIWEZ81RMxhvzVsNg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c0zTmy7QX/5RltjNd4uHwkaMHxx7kSeeB8fY9roqlTlF94VR9Aa3E9NYGmj45VCiHHeIJ9H5dg+k4TscWXtlBknPkRhSqy3Ua3ajj+ZCKaAoZd7vOsgs+slm+7k41v376aLX4ETGAkGPw1vbSc8NudqzntSq0ZpjrVdA1R0h2Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HAKZpPRO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b646768eso248744a91.1
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 11:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762371869; x=1762976669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K8ZK0MiZ1hzn7iH0lOR2KZ5CJE/Z492UpE0NsitI4ac=;
        b=HAKZpPROeyWEmoNXYbZCWAf/QHh47RVnABxelKbu8ysPRNzzl7e7qGLAzW7PvS6n5K
         7eB3jqr9d+P1H4BV37W/lh2s3kPha1D7Jw8REzCfe+h/9Ugg9CL6sxOE2joLKlwiX5uy
         XQQr8oCzvnWf0P58S3yGP9dCyd+SiQTvz/g67TyAuvgNub0meEUM6CJocvYxTHPmYySF
         7eyya8TlVN6nWjFNP7bdLx9FodfmquHascYSE0DkgLHfas+1VRh3TK6UzbFRbGDH394R
         +lpMUllEBKR1/uSUGJ/cqCkP2gdLv9KRUVYMtd6i4Y88bB77h0fwMcHnf5aptZxUM/8G
         iNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762371869; x=1762976669;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K8ZK0MiZ1hzn7iH0lOR2KZ5CJE/Z492UpE0NsitI4ac=;
        b=TSO+tXsr8zB7ne2hGGMRHAAuQJkYjlhLleEuTINqeLPouxu/WclHPQjf/MtdlbuUjF
         5TEzYLdwTKRcHCtZXTRkRQp9V9jnFgN6gy+EefaM9oZSuP+fjIafMQFdUnxgaAWIppDg
         TK1/CUVit7vNjaTW7WI2lIxxYE0Y9/zK+BFhtsNZRK2QF7FWKK6JQrn/6VBZ5ilYatPp
         63YK9HWFiSlm+VtvNdHRtqxO8VQPIrK1w8fe18ZY8lUKmEfnM/xn6s267SD9hSsgjDIW
         tz+aDQalSo7LsHddHM6JS2M2nKy0rTCOszFOyjzbxoCbGgm+LYTvRSIBO61dfzFHBwa0
         +VEg==
X-Forwarded-Encrypted: i=1; AJvYcCUw13+LcUN3aPSULronz+1nsVbVf+d7YJab+8uT6yxTUIGFSNPZMDu+3iRtOqOortB0qqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/a6GMhhgQtCT6ubdAODFwnEF2ovpScFU4ilQX+oIagbZ+Lx3Y
	D0J+qNbj4JbF9/pVikFN6SjSZnLBPa/kdADqSQQTUu/txtfN3GtkNKQ++kht0cjs7Q3cr6HNjfZ
	jmMqRHA==
X-Google-Smtp-Source: AGHT+IGUe19WzjgS7NVl1on3cCWT7NzacMbeJ7zc1z1lSJo6Mtsb4w1JefM4Y086HcyZXcE3ju6dHq1EPBY=
X-Received: from pjbca19.prod.google.com ([2002:a17:90a:f313:b0:340:66e4:4269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc3:b0:340:f05a:3ebd
 with SMTP id 98e67ed59e1d1-341a6dd9a30mr4900591a91.28.1762371868572; Wed, 05
 Nov 2025 11:44:28 -0800 (PST)
Date: Wed, 5 Nov 2025 11:44:27 -0800
In-Reply-To: <20251024192918.3191141-3-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251024192918.3191141-1-yosry.ahmed@linux.dev> <20251024192918.3191141-3-yosry.ahmed@linux.dev>
Message-ID: <aQupG93pUl-IYx8G@google.com>
Subject: Re: [PATCH 2/3] KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly
 for LMSW emulation
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel, 
	Matteo Rizzo <matteorizzo@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025, Yosry Ahmed wrote:
> When emulating L2 instructions, svm_check_intercept() checks whether a
> write to CR0 should trigger a synthesized #VMEXIT with
> SVM_EXIT_CR0_SEL_WRITE. For MOV-to-CR0, SVM_EXIT_CR0_SEL_WRITE is only
> triggered if any bit other than CR0.MP and CR0.TS is updated. However,
> according to the APM (24593=E2=80=94Rev.  3.42=E2=80=94March 2024, Table =
15-7):
>=20
>   The LMSW instruction treats the selective CR0-write
>   intercept as a non-selective intercept (i.e., it intercepts
>   regardless of the value being written).
>=20
> Skip checking the changed bits for x86_intercept_lmsw and always inject
> SVM_EXIT_CR0_SEL_WRITE.
>=20
> Fixes: cfec82cb7d31 ("KVM: SVM: Add intercept check for emulated cr acces=
ses")
> Cc: stable@vger.kernel

Bad email (mostly in case you're using a macro for this; the next patch has=
 the
same typo).

