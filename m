Return-Path: <kvm+bounces-31664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D979C619D
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 20:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08AF0282A59
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49BBB21D219;
	Tue, 12 Nov 2024 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lu9J4MnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0108C21A4CC
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 19:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440043; cv=none; b=ci8uwfztm8LRlkaB/Jp2GihYmkzvVNWL+3c+/czpXXDDzsSb4ObssT9TWIoI6HJG5LMtc2/A0DAa5mS4xYtQAYX0jW+mE2abqx0fjt6PGA7DmpOEuHyhXGVtmdKLV9MRSuRzzqBZEIHLIjdeRq99j7vPduk9jioxXTcSOwkhgr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440043; c=relaxed/simple;
	bh=8Zw9VxaGNKeAshrG2DVz/boJEgYN8+U9vCybtzTq3DY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/6SBNanUif9xcxPEdDoa/jiZ2okJTOnnX2bVJb0IjonDpwAzGGIRfCEn8HH38CqIarwMGyA5AxQWiQMEI0+cCt7hkwnZ3oOHgwtKPqRA70CDhjZau7o0aN5Ydn+7P0793/lMnj3E4MQhdE6HvYx//CQTQ1xBaf7FUrgK474YUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lu9J4MnX; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-37d4ac91d97so5592061f8f.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 11:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731440040; x=1732044840; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y9wb6AkvqlKLFv6CsY4nbWvFqgC5HzXu2/jh/XKH3TM=;
        b=Lu9J4MnX0Tfs5U9qfyePnTDpqzHilgAarFqlHiXG/QnvASy1iPMfKN3jZU1MghoGkH
         UjQRcZQDqVW0u7IRz2kHUUl0SOmwO9cSeHGchdwyFRYT+2MIFVdE/8tsYXe3QCnLPAG5
         TUb8N30iz12uBhr2GAkyCa77BkWvqKxajw1LnlbctHuYFfiIolCmrSFBUzJjaTaIPgfs
         I72oWYz1a90RrqR53Zr5PLXZkqZzF/FNYRWCWmIgpHkiVN+M7A5sYc8+jbbXJXUGsOCs
         jG2bo9qY8wB0iNtyV9iSEhc+atWJJ0cYnlDG3haBIDx6vmV5MlkoSFzXWhv0ppXnB7DV
         Bz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731440040; x=1732044840;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y9wb6AkvqlKLFv6CsY4nbWvFqgC5HzXu2/jh/XKH3TM=;
        b=PKg2lo76HMf24jbpwOCN6cLw4YGW3uVtBLdf5DhQrFBt5kxFOhooVEGB7ozsYnrgCA
         O5kqaX5Y2amT5Hp++HqJQfN3PtjxA+YSFEcV7F1y7Z33V36zhOYxpPKof4+OG2K9q/C3
         5uXiZfBTzHooDVRgrzLohepadFvb2Ql21UIJsvhB85bk6BUHRsli+3aDlo7mZKn/0JlX
         xvEoGcvHf7Nl0PK6vdS+/4jnzyiUOF2sLChrzFvtLgfv1d3ii2qkPqpapZ4mJ1W1Z9sR
         4tvelcazPPyJ8jwsJzEMhxDbT7jEzu3nDuF63s2WtU3bTa8oUVTl1krDkwTFMNbAxbM+
         CdYw==
X-Forwarded-Encrypted: i=1; AJvYcCWRZHNA08pNgjPGcQkg/VcFqK2HHL+bKK4QJwFYFaOPKoP848IvGmLAXmRwK17YkepoVhM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw33Y7/5GtzWY7h4J2JVZQO6JzgBvVai2d8tUYU7JXLkMGhk7Zm
	sfvZR2k0ArNhFyvSqEOnpfpE1+J/HXglekYB2CEx5dh/W587R1XTku+PaHTXUOZHpBa2H5KIEqZ
	tDed66BLAKF3WrsrsOSKNTaQMMrJV2Eu/BgjF
X-Google-Smtp-Source: AGHT+IH2loZRrvGX7OLDNAn4wYJUo+4ZKUEg9FXqo8fn5IA6xVdWeodz/p2eUqUKInKsvo4Oso+ZqW477vo9YTiTm1Q=
X-Received: by 2002:a05:6000:2a8a:b0:381:f443:21d1 with SMTP id
 ffacd0b85a97d-381f443259dmr17589618f8f.54.1731440040288; Tue, 12 Nov 2024
 11:34:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-10-dionnaglaze@google.com> <43be0a16-0a06-d7fb-3925-4337fb38e9e9@amd.com>
In-Reply-To: <43be0a16-0a06-d7fb-3925-4337fb38e9e9@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 12 Nov 2024 11:33:48 -0800
Message-ID: <CAAH4kHasdYwboG+zgR=MaTRBKyNmwpvBQ-ChRY18=EiBBSdFXQ@mail.gmail.com>
Subject: Re: [PATCH v5 09/10] KVM: SVM: Use new ccp GCTX API
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-coco@lists.linux.dev, 
	Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index cea41b8cdabe4..d7cef84750b33 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -89,7 +89,7 @@ static unsigned int nr_asids;
> >  static unsigned long *sev_asid_bitmap;
> >  static unsigned long *sev_reclaim_asid_bitmap;
> >
> > -static int snp_decommission_context(struct kvm *kvm);
> > +static int kvm_decommission_snp_context(struct kvm *kvm);
>
> Why the name change? It seems like it just makes the patch a bit harder
> to follow since there are two things going on.
>

KVM and ccp both seem to like to name their functions starting with
sev_ or snp_, and it's particularly hard to determine provenance.

snp_decommision_context and sev_snp_guest_decommission... which is
from where? It's weird to me.

> Thanks,
> Tom
>


-- 
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

