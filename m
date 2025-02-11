Return-Path: <kvm+bounces-37913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B35A314E0
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 20:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD1D01885B4A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 19:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9FEE262D23;
	Tue, 11 Feb 2025 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RWO3qkJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51F8250C11
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 19:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739301579; cv=none; b=OnZn59lJILwi3DBOLJ7CupMcLqaAs2bNTvajZKnDzaL8/CU+elmHv50Bzcp8iaYY/F2fiquXVvCywYlMk4+h5zvGqIFE5zGKJwJAWolyEI/+jdvOwhnZorZ2+3YMhn8gjLMzubnaQWqA5V9dm2PZW4bZ7MCIxHA3fqEZacy7rqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739301579; c=relaxed/simple;
	bh=BQVcd0E8qDJAu1XKqZpGV5YtYxLDN/fH/h90PM2zqLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FWtG4Uh2UfcJd+7FYxW0myo3ERksvuxlZGgpguzxB3SNl5pZe8K7TvDKr5sfS+LymKW3A2bLv39QmoyFmXZGXD+uX1BXVgvoQClkRIjCzyeEvEV28dAfVrPNn638AfZgLcnXVksAtsyV+WlZO3BQQZDswUlQDYHzCPJ08vfa+uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RWO3qkJq; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d146357fb2so16435ab.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739301577; x=1739906377; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BQVcd0E8qDJAu1XKqZpGV5YtYxLDN/fH/h90PM2zqLA=;
        b=RWO3qkJqcZKs02dZSpmua4GAx1rEzeTwL4aQemj1cODa5yLsBN+Xc1C7nru8ciO/Qk
         sgSMfHlLNUSXDBWEPGKmQ2hy8HU5Q6xK6Ep0MrFh6ySeqMq6EUCryG3bep/ibwmGF3Bt
         EAZx6irqkbTVwP7dfYa0buYj8wG9Pad8QahQ/DLkaxSlgrTUL4tX7poD57GFvlpdeVi4
         n5a8rtBBTXCs1/NeO9Y6RKO/iFEX3VOifTL3QOIM23YyZs/PzJ2rbEKA6KcGa8CkrDiN
         VDSWbFBm/ukI7uyCaJd2DeUlfKV9eMO7Z+NmGom7Z/qJTOklSqLqQygU6BPWXuiIXuDz
         Xl0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739301577; x=1739906377;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BQVcd0E8qDJAu1XKqZpGV5YtYxLDN/fH/h90PM2zqLA=;
        b=GMbSAc2jmNm4BM3Xk2avFXGbGHF1hwszwJbI/8D7Es7d7fnF4tWKyAUP5xxlaVf0Wh
         csnvPR79/tbUpPnfAqy/UbGxhCjkpPkCiEmD0BnPCYX9vhqFMaV/Q6rIoNPGTnQyotEP
         Kr8ArvPOPPWV1RQlq6ZPcXvc6l42pRI5cOTvsF4k03sVSZ3GEzXvMl9Y0bkuaHaPCVao
         uFxoqwSqhHPHuj0fssGQ0KUQGL3x/3T09B0/pVoF0MeuW3aIs7ncZCz5922ddlx1kVUg
         /VD68D+OM3jGVzsQsYOHSNYqfb5cpZgJtQBdTdGBO1PZHjPLZuyhoXnE9U1vAkjP3/5M
         sJVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIEGYQaJVKUqy9SR70COAWC0HHF5nwBFKwK76ex9eqDM5EHkk6lsccIU61g9jRrLlmXsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGCGfhfRR5fLlZ3poc51bITQvOW5KURREXvwB9J4RCngBVDbDZ
	SfbvM1GIF3VW5nOQyhKfERHx1CJShZZ+l98Xq16JGcofxX8xrFlGWlyV3O1zHf+bK2HdZSg2XXd
	b3U21zi1NgvKiNWecT32vWXeTRr5yRxpJAOp5
X-Gm-Gg: ASbGncvEyCtZVOJ5DKfg5eXw33gFae/+apglVPGv3PacfC7tVH81ez0tizxYH4Rf0g5
	DDSdqEJKk32QJceMsgMTkREURLmXlwt92lgbKAg9FWQrLmftAqVGnAjH/Uo4QxuLuBYiVGi/5
X-Google-Smtp-Source: AGHT+IHZcYXITrrwGicv+DWrhwM/y10QdY1SKlNBDZiGq/499Tf3TOztiUIlbS98GdpyOeZkICE0kLwCQR4n01pCcfs=
X-Received: by 2002:a05:6e02:de9:b0:3d0:62be:12c3 with SMTP id
 e9e14a558f8ab-3d17ce89803mr152295ab.1.1739301576593; Tue, 11 Feb 2025
 11:19:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z35_34GTLUHJTfVQ@google.com> <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com> <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local> <Z4qnzwNYGubresFS@google.com>
 <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local> <Z5JtbZ-UIBJy2aYE@google.com>
 <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local> <Z5KEoepANyswViO_@google.com>
 <20250124125843.GBZ5OOg3rWBd9pY3Bx@fat_crate.local>
In-Reply-To: <20250124125843.GBZ5OOg3rWBd9pY3Bx@fat_crate.local>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 11 Feb 2025 11:19:25 -0800
X-Gm-Features: AWEUYZnCHcmRz4QFrDZ8KpRGdwEuBBU2P5nHjVBGhJsHbEaqxo2hitC1xktH8hg
Message-ID: <CALMp9eQarOhpNkw6WCWOvh_fcHg9846sEo7fAOEoAtKRDA7kSQ@mail.gmail.com>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Borislav,

What is the performance impact of BpSpecReduce on Turin?

