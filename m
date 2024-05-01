Return-Path: <kvm+bounces-16370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 349C38B8FE8
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DBF1B20EAE
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183E2161328;
	Wed,  1 May 2024 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rfbhiel2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD9616087B
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 18:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714589683; cv=none; b=FFyIFfCCxiksWHuhVFcVSEuU2u8QIBkXGNri9RdAIwJVKz8FkGLVtArk/u3VjdMjt7TSjMSo8ugF/4ScEa2bboY3Mm3qlsMGHJnbKQGkO9APfATgC+wKW+CQYOgr4OZymEd7UzO39rCb5RLVIsxOIVuyKn6FviqzNURr0HKQZVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714589683; c=relaxed/simple;
	bh=ZDFyiXcFQpYmQqUMFVEe9FegPdW34mLyaWMr9aBCBF4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Om0bIlMWcC7HNa/T+aZqqGZftzA7BQ+qR3cl3rA+o6Ofmnm/oVjUuBKTnfyepSvXHjZLaBaU64knCvTmhBDjSj3FxTzj8CbN8QZ2+E/W9ytAGEGk02izKXGkf69glg5o6uiZ7GYibWcOFQGVI8gieqCtBs68tU2g2rN5oAf9G5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rfbhiel2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b35b8a9feaso468688a91.3
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 11:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714589681; x=1715194481; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7WCk4sjm/hGbZuv1UBg6truPSxtFEYVHoQRMNBTBqho=;
        b=Rfbhiel2rJKy23lQlRVin50n81HUSBV3ZFmnpqRyt/db2N4NpMBjc7ErfvOvU2jSil
         PycsNaw9FS3MS9JmMqYHesOx8L+/alQuAPaqnknrB0a8QAVXNruTycAHtQjomZsOiV96
         qVneOV9dTDdzdLoLLA5fkv+ciXXmXJRkqPEGEijut85x40eruV1zz9GUG+oOr/Fxt/Tu
         LMBAQefduIF9SMwDyIcNaGvwY+QAq+irqzbJY2RQCZOYst2dDb9kw2Ys/1FIZTmxtYfH
         XteEVba/lOoNT9kXWVIB/4J+HHey7AEjiK400kVZBuYC/rswnTO9RXyk/+IsvNaBWhtz
         ycnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714589681; x=1715194481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7WCk4sjm/hGbZuv1UBg6truPSxtFEYVHoQRMNBTBqho=;
        b=wfXRk8sCQ26h4CiB/PLhfvBDuRl9awPA9oFNQ/m/G8Cts+kv77QV4KvfKZtx4YhvoD
         N2zXIoqbBTmy8SJdyW9HX7ODOBKikeZaQ/tJArLJKDLyAu4YnGtIcfbDBR9hlwzXzEiu
         0KBx6Ir9Te46vxaO9sef2M3ixgXbPVC3z5z8eldLiEwO1CGxTkBVk2rz2Ffs8bqDHQze
         m8p1YuNDy/5j+14wwSSAukRaj2bCK/fSR4opph3ETCTLg5v1VUlF53cmag//cU/wW+0m
         p3vp48QTKNLiiOni/Uj14jsc7TArOacDYq98DYN2HURy23ZtMesKQDinUssAekenTeZN
         aeDw==
X-Forwarded-Encrypted: i=1; AJvYcCV3ZO0OPp436DnprnN+c9hDdn1ehXtrGiJpOcj3Tf9QaD7rtapUI6gAcvNPClYYcCiCOhzHJ1xSoxrJZ36BEwJMWovE
X-Gm-Message-State: AOJu0YyTfap2bKjwKJh05i5/9UCgyeQR22Z0ChiButG5J+9pFUPBgAHT
	arlryngGZMc2fuplgs9Z/10ejMmAKU2GjikmzHUmSqtIWuHq16PneqcxI+EfjeivhKKdh331QUE
	xSg==
X-Google-Smtp-Source: AGHT+IEaEMkzuIRvQdXiBfaDkh9C3i4lsdhVtSwmc/4q4ol6mkUrYSdgzDL/fKpff9VrOEqYhmXsnGuyTYg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:360e:b0:2b3:90eb:7b46 with SMTP id
 ml14-20020a17090b360e00b002b390eb7b46mr692pjb.7.1714589681215; Wed, 01 May
 2024 11:54:41 -0700 (PDT)
Date: Wed, 1 May 2024 11:54:39 -0700
In-Reply-To: <20240219074733.122080-10-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-10-weijiang.yang@intel.com>
Message-ID: <ZjKP7_vydkig2FQ4@google.com>
Subject: Re: [PATCH v10 09/27] KVM: x86: Rename kvm_{g,s}et_msr()* to menifest
 emulation operations
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

s/menifest/manifest, though I find the shortlog confusing irrespective of the
typo.  I think this would be more grammatically correct:

  KVM: x86: Rename kvm_{g,s}et_msr()* to manifest their emulation operations

but I still find that unnecessarily "fancy".  What about this instead?

  KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest accesses

It's not perfect, e.g. it might be read as saying they emulate guest RDMSR and
WRMSR, but for a shortlog I think that's fine.

