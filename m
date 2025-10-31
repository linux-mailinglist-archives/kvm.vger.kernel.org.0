Return-Path: <kvm+bounces-61706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 53E99C26448
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C1E534E3F36
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BA0302770;
	Fri, 31 Oct 2025 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BiAMWdgC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C122FF16C
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 17:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930102; cv=none; b=fqmdsmLcrjmwp9ti53QRgU6PM87RdCRoS8JBu0KyDy42ggtoz2fhfh+55DGsXH39F88nTvx0giAxoaetDZMA6/crcskpDKaYlOlSYH2/pl/42sLNMwk/t7IBuGEkLUse9fZ95IYngPMC8LbStJMtzmq9boPLoCYamznTrArcP5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930102; c=relaxed/simple;
	bh=ExP714MhRpE/X2S1bgAsGplYXRnkY86iAwV9dqwqkTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qEaCDDRlGsPV/sMbsqb1qMDlp9krVyLClsI3JsJBZIAo8Vgn76EZh++t+hYJZXZOEaBNU7eRKZ4qRWHl4gQ/wwqz1ZgvLyRZqNXQXPAp8lBN9/8GhOlXV8/iwSRsU08/LyA3gKCG1XgQbQOQ/1Tt9/wn3ay5k5YWFAeNl32gL+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BiAMWdgC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-336b646768eso2647169a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761930100; x=1762534900; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/MRbBtlEvav5GDT1r+/BrezlWRnmNwGU9mv00LO9a4=;
        b=BiAMWdgCEG5fj3u5rMQhLIVleLkQkzAxYX+RZLhfzMKRNdvcTpeYAQ6MpoULfgNaa4
         44G4BZe5EorU7NjtoUazEBB49XFI2uvz9U/mDb35IuEs8dlYQMBE3UJjjVWINxJCx576
         YVXakuP2qFvigki1O7TLrE2jWEPDqKc54g6kpTH9U9MXb8E6kPt2IrdXn6m7ScWPRom3
         yCjdWocfF7xLL+ins9cf3hUnS31/s75ejUSoCGQBYt5+NiuuBtIPAR9U3nwKijwa19Gv
         Aw3x4di78OPaWZjOIXUX975yLD62DvtPlaBuRG8ZtAqdIT33uoTy7nnyenxDhYSgj9LP
         PNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930100; x=1762534900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2/MRbBtlEvav5GDT1r+/BrezlWRnmNwGU9mv00LO9a4=;
        b=rcLJNt5PEKXzSLNJjhe+B5+54w8qVDt6Ht/tax+LABmQQThxw1Jhm2wLrudp8dDUU0
         SfzykfHLq3zOUInPVF+GKsxHtC9TXNpXdkTvD2e6SnnjkJVW7wZqi8b3ZU5WZPXkPhnM
         +zSvKDQCd3OxEMWpYj2ygzY99rqkz1iyzsOmwOxYCkpmhKyDTWAS2nqMj+5SVIhZUkM4
         MijLbiFJ9AR2F8cG6hhYKIAcozeAROiVlrESUyspJG6uKuxKXvHKIj+BSQ+eptVViJat
         3nNSSj8rQLP8TYxmveUHZaXGaop4pSz+N8BMBDza8R2AkEK/jRP5L5MWvVDzGPnpJF0G
         ILxg==
X-Forwarded-Encrypted: i=1; AJvYcCWNAuMjoBcUGfmE4S3aRwemypD1cGus63Qpjeb3mLqyLmOMZyPVaAVluN9WYcuMY/Dz2L4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr7fxqEypT+GuLUuMUnOVQbUNzFnoKKK/ohThT2UCejw9ZE6fQ
	AdbmV1V97rG8uuY8T5mSro3+xFdHrbonrHf+2nnXQzBAvsaTZ4lGXr5uPIdyVuBtsgp+hgLQ0m0
	9uaNqcA==
X-Google-Smtp-Source: AGHT+IH748GsxTeI/Q04BSQ33R6BefPTyOvqnz4pgeN1lbp9XyK8W64dvo9aC285XLDySIC0ETt+QAl6jJ0=
X-Received: from pjbgo19.prod.google.com ([2002:a17:90b:3d3:b0:33d:4297:184e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1812:b0:340:299e:dbc
 with SMTP id 98e67ed59e1d1-34082fd608emr6573642a91.16.1761930100216; Fri, 31
 Oct 2025 10:01:40 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:01:38 -0700
In-Reply-To: <bophxumzbp2yuovzhvt62jeb5e6vwc2mirvcl6uyztse5mqvjt@xmbhgmqnpn5d>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030185004.3372256-1-seanjc@google.com> <bophxumzbp2yuovzhvt62jeb5e6vwc2mirvcl6uyztse5mqvjt@xmbhgmqnpn5d>
Message-ID: <aQTrcgT9MMY_69wh@google.com>
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 31, 2025, Yao Yuan wrote:
> On Thu, Oct 30, 2025 at 11:50:03AM +0800, Sean Christopherson wrote:
> I like the dedup, and this brings above for tdx which not
> before. Just one small thing: Will it be better if keep the
> "vmx"/"svm" hint as before and plus the "tdx" hint yet ?

It'd be nice to have, but I honestly don't think it's worth going out of our
way to capture that information.  If someone can't disambiguate "kvm" to mean
"vmx/tdx" vs. "svm" based on the host, they've got bigger problems.

And as for "vmx" vs. "tdx", I really hope that's not meaningful information for
users, e.g. the printks are ratelimited, and users should really be gleaning
information from the VMM instance, not from dmesg.

