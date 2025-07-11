Return-Path: <kvm+bounces-52168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83936B01EA7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 422423AC275
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B162E4246;
	Fri, 11 Jul 2025 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V8NIyHqh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1835F2E03E7
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752242785; cv=none; b=jrwCVLei1jmwn011RABdPHKO/QCbp5Qx6pvKoW/gE57lHpxZurUAH7Ou9hdAUwU4TNtqyUWSj8KAJY3jS+s5I1+Wl1k6dBm/5Z64bVK/Vez56y4gFuQmWOljHbP7S7MRLTLLD3s6X0ank+yeb2AXJy7iJy+bzP84SRT2NOlDlXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752242785; c=relaxed/simple;
	bh=HWvaEhuXDSYgLYWRHKSUTXBSay+No1KBht70inNpu30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mMs55gpDX9BsAB49hn5eRV3U74qSHnO25k9IGvsDCuUS/fknyd/t2Fi9tJSlxMqDeCfIOAkiRHJVwpmpAJZ+edplhLZBTU+6Q0HzDw193gLO11eNpXkvnVRVI1V7Z+Li6C33fKnmvJvpiKDvhgz8461l1KQF6e2dF3dgxZ51Qsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V8NIyHqh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so1993673a91.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 07:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752242783; x=1752847583; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jnCZqhs2jpFslJPdY5U6nIr7Bo2uyg2ScFEtRB8bErs=;
        b=V8NIyHqhkwflo38lGXEpPehkh+MKOwqTpeN3dgsODmh1EClnypxYrWeIyAgRC05yrk
         8QDu2SsrOVH0qOXxoPrN6Qemf2nBduq73J+FbeQOKWXXEpO6tEPpFw88uLROvVYdEpDa
         pS07Czj5b4mAaMuxb3qYuNn4124FxkTz+T++4LxY6t9eKC8jGK7ZBHtTnYJaFR1Yauzv
         0MV9RMyIkyet9YVGz1qrsdISDmlbthMfMX13sjzVodAWZzl0vs3GI1ZCZvO59QXBAqVO
         Fmk8I7lAsFPfeqNmg//GUdPJOUsLErvwpUtOF7zXKe7i/SvmxezscWWv9bt3E8QSSDAp
         YdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752242783; x=1752847583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnCZqhs2jpFslJPdY5U6nIr7Bo2uyg2ScFEtRB8bErs=;
        b=SNBJxIE6MJGWJIM8y2WwNE6XiAyt979z57gx5M0MGFN+k+RX2GGbjyZmd8YNcIn5X7
         YTRraTtwSjzFDmYzQOrR+zlpE0Y0K6K6hNFdm0UR/7QFsX4HO807fqzq9LEdGKQpT8dB
         QX+RUvbQXFL/MYAH5EZeiXM63ZQYY6G+vAOWKFtwwm7CEPimOk0iBo1VD3zYIZ8JXNJp
         jSdIshyRSPxm6lw2q5s8bL1UKWI4Tb9IUs6MFgmapa6Vbq4FMH2Aajl2Aaa9EhiywyZd
         64cqLIGYOtX/zo8HTQTB3UmXiucm2Yha55anDLlKG7GOqNTbbNCXhPhT10sVG/z9kFGZ
         V3zA==
X-Forwarded-Encrypted: i=1; AJvYcCVy1awHtO9Q9CK3aigw4vBHXnHb0DAnln0oA6o0Lm3oFHrQC26LJ70rigAKfRo863F91ug=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHRLwbbEcEQu9L8p6YO6RrAXGhnKyR95gPEzuZX0ps3e/ObVPB
	L/iuRL+6ZcBc/6qTOzdgZ9cvvU0xKZdhlQezYXBSu1XnB72Nk+bROqjdC3CJ00x71kxqjhNQWlA
	DNb3QAQ==
X-Google-Smtp-Source: AGHT+IFP1G+BwI9fgjlF9li/vRzlrSC4JG0EC5WsLxaZfXdd6Ao/Nfb+aDJQsUkaL0KTxYCII+FkDDc445A=
X-Received: from pjee11.prod.google.com ([2002:a17:90b:578b:b0:31c:2fe4:33b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:37cf:b0:31c:15d9:8aa
 with SMTP id 98e67ed59e1d1-31c4cdb64b8mr4842398a91.34.1752242783439; Fri, 11
 Jul 2025 07:06:23 -0700 (PDT)
Date: Fri, 11 Jul 2025 07:06:21 -0700
In-Reply-To: <aHDFoIvB5+33blGp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523095322.88774-1-chao.gao@intel.com> <aHDFoIvB5+33blGp@intel.com>
Message-ID: <aHEaXYmeolKNCqgk@google.com>
Subject: Re: [RFC PATCH 00/20] TD-Preserving updates
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org, 
	paulmck@kernel.org, pbonzini@redhat.com, eddie.dong@intel.com, 
	kirill.shutemov@intel.com, dave.hansen@intel.com, dan.j.williams@intel.com, 
	kai.huang@intel.com, isaku.yamahata@intel.com, elena.reshetova@intel.com, 
	rick.p.edgecombe@intel.com, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 11, 2025, Chao Gao wrote:
> >2. P-SEAMLDR seamcalls (specificially SEAMRET from P-SEAMLDR) clear current
> >   VMCS pointers, which may disrupt KVM. To prevent VMX instructions in IRQ
> >   context from encountering NULL current-VMCS pointers, P-SEAMLDR
> >   seamcalls are called with IRQ disabled. I'm uncertain if NMIs could
> >   cause a problem, but I believe they won't. See more information in patch 3.

NMIs shouldn't be a problem.  KVM does access the current VMCS in NMI context
(to do VMREAD(GUEST_RIP) in response to a perf NMI), but only when KVM knows the
NMI occurred in KVM's run loop.  So in effect, only in KVM_RUN context, which I
gotta image is mutually exclusive with tdx_fw_write().

It'd be nice if we could make the P-SEAMLDR calls completely NMI safe, but
practically speaking, if KVM (or any other hypervisor) is playing with the VMCS
in arbitrary NMI handlers, then we've probably got bigger issues.

