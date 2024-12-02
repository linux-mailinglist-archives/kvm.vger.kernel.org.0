Return-Path: <kvm+bounces-32845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DCF9E0C59
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDB6AB2A805
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A931DE2DE;
	Mon,  2 Dec 2024 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u+QG/vEX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51691DDC39
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733165272; cv=none; b=Gj1C08jPbr0kPeBmsjpvFJE2tUMXLmXw8KbAqFi3i30xl6SkgeaCW5wY2ai5Ewn2WrOHEiWjlpBN40a90IdhlmHvz4m8DwEEchtvcgj6ZjWpQb3qIRtGGAXR64mmZbkUu9Ryd11IwJ2LXBYJ97UHJShpBbqc9VISteMO7e7FbeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733165272; c=relaxed/simple;
	bh=/WDv/GV0NhSrxZ0Vl7TJjeNE20slEbisRuFwg3yb7uM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rf64tPZFimgWM4IhgSb4/VQ3ZqTKNaF7eCLniIU4LGXSBu6Q9ErFrxFXPC4eXs5mzfkDDM1C8fLwNlIh819msiI3WxQQ56RakdEC9QGYGDL/E4FW5mDfwhEakZjscgj5GOMimLX5v+AxwyfSwD9vfqPeKp//kVwS1XDNW9ZZamM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u+QG/vEX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee8ced572eso2298990a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 10:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733165270; x=1733770070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u34wPynLWdSa99IQ6xhu/7M3+TIv2HNu87ct2rQpiWw=;
        b=u+QG/vEXVdcYmU1ZqkBfIft9cg+2lVxs+neqt5vpV7PHtS9+G5SXfE/cpwojVCWYFp
         UebaKy6nWMg8laltRAKN9KMC4spU5A+Z5oOnyFL2aQy7IvA3gZdnmvU/k+8/r8zTifW0
         fVFJnWKvOX9FUqbL89OgD2cgI6P9vrP/Fnk1XkTSYd/VGKrvQNT1ID1jj54ney46cX2u
         NISzS8OXdrgJsaqfiPyBD+T9n3PFN04UtWSwEdfVi4YV2LAi02tkLzL7y7SNzi/p/iQ1
         zrspoUC2Hh8a25sdgZQA0hLLOxE849ZWJbelGQlwteS7pRW9vaU4XCmXaGONvle4uuXn
         2I+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733165270; x=1733770070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u34wPynLWdSa99IQ6xhu/7M3+TIv2HNu87ct2rQpiWw=;
        b=d8itwIhpYSD+SeY+b48n7C3NWcyKVhE8/UVVKTPmO5pN/DPaS4ciGE+BaW9e0BaohG
         GYnlnf/nM9TWCoTfGd5+kaqDYgo7JNdISCf8jAa+wsM4nlPgeQCwrdkwR7WwKG07dDwP
         NGvROJy8E42jrfl7jnhIt/yZ6y7bStmNRwJYpCLyzLzJBI8aEJ+A+NFehiNADPbXLp5M
         cMhkj+sEfhx2ODEzpEeGpUpVPIH/mS8R2aUmwR1EqqU1pHxjFRif1iYp8eFuvpKGYmFR
         zliJ6akmHJ+jmkF0wAwgLQLBCum2tlxvhk/k0tSJBTnqiDgd6NPBjvAhI+sPdYtDQ+b2
         gaMw==
X-Forwarded-Encrypted: i=1; AJvYcCX6DblN3H9V0pW43nSS6LzbAYZtbMyLtHsTiVp6xqbzyt34UyGt6zElrokrMYu5/GLQe50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg67PiKEbe7v9a7LcftyuqsVH9ayd/CCbzIMWW6TGZBmcrrJyh
	Z9YU94SlfEGGC82iXMu0C1BM7TSH2a/pZqVxc9vvRswIrturCjxTSAGmjkapH7Y0cJmBjrOZYT2
	oKQ==
X-Google-Smtp-Source: AGHT+IH1lOkxtOKe5VZ1YQsUZ2R4iUJCkzIbDFJGQzaxTbOPx9DRSSWOWSynHC4tj/4TdwIvmt3yGcRJFdA=
X-Received: from pjbsv8.prod.google.com ([2002:a17:90b:5388:b0:2ea:6aa8:c4ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd2:b0:2ee:c5ea:bd91
 with SMTP id 98e67ed59e1d1-2eec5eabed1mr7923335a91.29.1733165269950; Mon, 02
 Dec 2024 10:47:49 -0800 (PST)
Date: Mon, 2 Dec 2024 10:47:48 -0800
In-Reply-To: <20241128092546.7a5b3f30@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com> <20241128005547.4077116-16-seanjc@google.com>
 <20241128092546.7a5b3f30@p-imbrenda>
Message-ID: <Z04A1Oh0LCKtCN4p@google.com>
Subject: Re: [PATCH v4 15/16] KVM: selftests: Use canonical $(ARCH) paths for
 KVM selftests directories
From: Sean Christopherson <seanjc@google.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 28, 2024, Claudio Imbrenda wrote:
> On Wed, 27 Nov 2024 16:55:46 -0800
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
> > similarity index 94%
> > rename from tools/testing/selftests/kvm/include/x86_64/svm_util.h
> > rename to tools/testing/selftests/kvm/include/x86/svm_util.h
> > index 044f0f872ba9..b74c6dcddcbd 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> > +++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
> > @@ -1,8 +1,5 @@
> >  /* SPDX-License-Identifier: GPL-2.0-only */
> >  /*
> > - * tools/testing/selftests/kvm/include/x86_64/svm_utils.h
> 
> this line clearly has to go ^
> 
> > - * Header for nested SVM testing
> 
> but I think this one can stay? ^

It should go too, the header contains declarations for helpers that having nothing
to do with nested SVM.

On a somewhat related topic, the file should probably be "svm.h", but that's a
future cleanup.

