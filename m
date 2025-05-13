Return-Path: <kvm+bounces-46375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD85AB5BE7
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59B1A1B47EE4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 17:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EFA21171F;
	Tue, 13 May 2025 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="acH8k/2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD8628FA80
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747158851; cv=none; b=Dx4t+s74wWwSJQ0kruXIkFHz/Zll6soSSI2SWZLP/qQB97Tj8E8JCV8+4Ct3JJTHRCexJ5ltTl+fNbPSAm5Je4o6B0xOs+/h1KNx2kFf0j9UUvyuOMobYdWkJP3StJFVIaiBjkE8T9w0JcqZsYM0w+FLwS7tWwtEy42MYGFJauM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747158851; c=relaxed/simple;
	bh=ZETV0SyLB51ABOS7GCLSTe/c/Lkm4H/VBnpprfCzoQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mxm1hXFrEg7A0nnfednp/q7OkW5I9paT1JVnRDMHX2oKKo83iIsKHXqOYYOj37phc5ODacUIXTSFoG1+rE+TE0T4BpC3sVjNaN2Pxx2IIGBS8FDkGZi+HRbWqBwLpA8pbN3ltFPF8krb/qMZ1nhl/EXDGUfxAiMUzQjlqnN4MKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=acH8k/2y; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af59547f55bso3253542a12.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747158849; x=1747763649; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1ScAKPK9lKlY9UgspugLQpSKdL/YPUt4UHrgfW8UlU=;
        b=acH8k/2yIcyjz1Sa059qHVw9qnQFUxllHvkDqapLBEOE3oo7FcVxe2nZrPWWf1XsrX
         zS3BlX0T5FFqqT00iktnn8cHB/BExnlbl7HKTk2k25gRxZvoihIL6gzWC6jomF2Qi4OQ
         WpHVlAU93merFMOXUxCasis/OjdGNInTmc9p8iyyNchBxEwPlu6A1KfJrTJqVe+yz2vR
         ztBIvHAiKq8UuAVJEEdOU6h90H1cevVv0u1/UIE3/qt7MM25RQRBaYWWZdthQE5ozGNH
         sxo8J6jVMgre9UhdKjUI/v5b6kMkSl96XtvbLHsKMmSQ2JTV4OHg6mHXgARFhFeAS9VS
         beUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747158849; x=1747763649;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F1ScAKPK9lKlY9UgspugLQpSKdL/YPUt4UHrgfW8UlU=;
        b=A9Osah+fng3wraFVCPqcC0g9swgH6oVejBLA04biHaNdPpGw5tj73L3wt38SuqXR4A
         joz2X3bsTwBnR5qCZEi37s8nDuwhNnGUawRQYTUbTOIc8pC/R1F8VCBFlfe3KVrSw8Xt
         SJdnnXUyK6BmUTHRma2dhDpmdje1XC2/+lAzviWoVr3K7Ma1hplJq4ZXeB5AySC5Mh8R
         QZEJvYytLzvUFoVrsdYTXOCaSui2bt/IpPw5ilSE9i5Eakc3vkf1o1J+LqG3rJJ7Xd/M
         iaeh5ltkXfRuDRyxlnVgmf5ezJzpHV1PT4ptupXGr2AkJGYgSDrgEXQDPfi6RnTWvh1q
         cadQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvuRe8lO45pzanO2QizsFycFkTTK0NNqoVG8Hi0rN8OUjv/Lo/Eidu7PNA19ZMGhIrmiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIs58wl7nRZ4x6DG75UxP571Fo+YAcbLxcLMESdgTIt+0fwn5s
	mOio9XKvgh+gdl/8I7LQ12spY4Twseeklrd3sNYAckZY2MBLu1YWKfvlz5q3fEqFM8lI6m7fI5w
	zfg==
X-Google-Smtp-Source: AGHT+IHiDZAiOpBEFOJgxUpXok2oMelxQphuEuzlOnuu5yK+a04Vf0oTH+lvsg7fpahPLTxAOdtcgKu4Bpw=
X-Received: from pjk3.prod.google.com ([2002:a17:90b:5583:b0:2fa:1481:81f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:268b:b0:2fe:a336:fe63
 with SMTP id 98e67ed59e1d1-30e2e62a8f7mr733965a91.24.1747158848982; Tue, 13
 May 2025 10:54:08 -0700 (PDT)
Date: Tue, 13 May 2025 10:54:07 -0700
In-Reply-To: <9F6D5641-E2DC-47EF-BAFC-E0FF20D1FC08@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-16-jon@nutanix.com>
 <aCJoNvABQugU2rdZ@google.com> <9F6D5641-E2DC-47EF-BAFC-E0FF20D1FC08@nutanix.com>
Message-ID: <aCOHP3B2sRVut3By@google.com>
Subject: Re: [RFC PATCH 15/18] KVM: x86/mmu: Extend make_spte to understand MBEC
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sergey Dyasli <sergey.dyasli@nutanix.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2025, Jon Kohler wrote:
> > I would straight up WARN, because it should be impossible to reach this=
 code with
> > ACC_USER_EXEC_MASK set.  In fact, this entire blob of code should be #i=
fdef'd
> > out for PTTYPE_EPT.  AFAICT, the only reason it doesn't break nEPT is b=
ecause
> > its impossible to have a WRITE EPT violation without READ (a.k.a. USER)=
 being
> > set.
>=20
> Would you like me to send a separate patch out for that to clean up as
> I go? Or make such ifdef=E2=80=99ery as part of this series?

I'll send a patch.  It's not at all urgent, not a hard dependency for MBEC,=
 the
comment(s) needs to be rewritten, I want to do an audit of paging_tmpl.h to=
 see
if there is more code that'd be worth #idef'ing out for nEPT.

