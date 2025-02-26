Return-Path: <kvm+bounces-39200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED69A45170
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A3DF19C0799
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 00:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434197346F;
	Wed, 26 Feb 2025 00:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ECBLMxwA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2187DA8C
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 00:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740529655; cv=none; b=g3WGxwk8PIBEBiQyapaIm4ySw/aBF1Lhk2V5zAEnB4T8vIKub29VCWjzqdvcGr4yv0NI2TcfXOBGrPcgq0FyU6jdb1b0cEccnPlnatLPLJqohkPEy3xRUXsCUOGGqoV2I1E3dfBqZr6JabpTJxizmH0WLScrMQmaro1s6wRDydQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740529655; c=relaxed/simple;
	bh=YFdIcmETOAJxtDEb1Ht/Nh5ABrjaWCQRix/l3XIAYQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=syA6tc9vzxkRkfYzg/NqVWhsJvCjPiY4l47aZbaxBwR9QPbLYpvil1BUURB0FP1J//7z5iyVWYSweLCM5hR0ysrmmZn6Hi4ylQI7AiAr8YN74vr6yhBf6XGttME5i7DJch6+Uwry9PnoLkZae00vhIKEkKW6TB9K3ACaCGnUMUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ECBLMxwA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc4fc93262so13274081a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 16:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740529653; x=1741134453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HAdIv23vtdyhU1Wievr5YncZEjjI/nIoxYj3wcoEoAc=;
        b=ECBLMxwAsGRdP3VFzeMyGfZGaoY1Qb3UzSP2FRQkvEhGdgROep3X0hVvmxyoTyJC2z
         pW/3EM1QgRY5m3SamvrJNSeV75OeTTvLfYTkqARGd2eRw6jwmgidZIKsw5lWcqY2TFS9
         R2QQNRtcrhhHJPZqJ2ezvxSE1QPbN5yoQWY2K1P3keBz4ACvPkDk15arawiluShBVMaX
         Lyi8npD4Gyykc6lYzAaBsg5hdL/gr5HQP8GYf2+4QaW7QFutLufClTklFxnwaE9m81lY
         /sqDD4LLpqKp+ct0BFq9hWD3TqntV2pPCuYoF/wnFE0h/KI1NPbjfhoGv8vTby+XqJRG
         Ey8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740529653; x=1741134453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HAdIv23vtdyhU1Wievr5YncZEjjI/nIoxYj3wcoEoAc=;
        b=e29TYdilIE8120rkL+cUErFL3LL6x0Nde5/AXBDEpOE5Y6sDqbALkB1unRbbbfVKK+
         /jy6jyDCL4JfwleqnvTSp/qdKXGqxBWEdn731lBjBJHAbwKSSPQlXs/ivQ6siDENA5Vb
         bzt8/3cJ1eyGgEkaBVv0QEWibbkCFTsdbsKHn+KdW11n0p1pHfbByfoqOpRblNi2sEZY
         iZF784Djrq5ruGqbintF4Ifl31oHy7K1yCN9ILz/pp+RcufoZ/1ApmuRddVs9GcAyy6U
         jPtq2kVScaAnkAeJq6zuzrEs3hgcyvvtShvjG8mXf6OTUjnIL3ST/CGJGZvtyJwfnW9O
         5pYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5Am0Co8iV3oY4o16tOdLx9Gc6zdRqEc5yyrPs3ssFCkUl/pQxPNn63xpDmtYoYA5MxhA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCr8lFOerGU97nYyn8qZj3mlTvFkESC8ipgRg+PyYmnrafA0F5
	sk9bMhoZ6MwAVy6WiaMkqdhJjfLBY0ZPTMDpzRBg2/47gsvr0Xc166ZDg1zRbNIs0ZeQYmmNOuC
	6Pg==
X-Google-Smtp-Source: AGHT+IHOUZMQJO44VDHKi6ofhJ07QZ2dZ6izn0Wyr9X1ZaSMCJ5d0/qSAVcldTsRp+dWt1bBYLTGrWWvHEg=
X-Received: from pjbsb8.prod.google.com ([2002:a17:90b:50c8:b0:2d8:8340:8e46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5483:b0:2ee:f076:20f1
 with SMTP id 98e67ed59e1d1-2fe7e218ab9mr2765842a91.0.1740529653271; Tue, 25
 Feb 2025 16:27:33 -0800 (PST)
Date: Tue, 25 Feb 2025 16:27:32 -0800
In-Reply-To: <6475f9c7-304a-4e0b-8000-3dc5c8e718e9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com> <20250224235542.2562848-2-seanjc@google.com>
 <6475f9c7-304a-4e0b-8000-3dc5c8e718e9@redhat.com>
Message-ID: <Z75f9GuA9NfKo37c@google.com>
Subject: Re: [PATCH 1/7] KVM: x86: Free vCPUs before freeing VM state
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>, 
	Jim Mattson <jmattson@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 26, 2025, Paolo Bonzini wrote:
> On 2/25/25 00:55, Sean Christopherson wrote:
> > Free vCPUs before freeing any VM state, as both SVM and VMX may access
> > VM state when "freeing" a vCPU that is currently "in" L2, i.e. that needs
> > to be kicked out of nested guest mode.
> > 
> > Commit 6fcee03df6a1 ("KVM: x86: avoid loading a vCPU after .vm_destroy was
> > called") partially fixed the issue, but for unknown reasons only moved the
> > MMU unloading before VM destruction.  Complete the change, and free all
> > vCPU state prior to destroying VM state, as nVMX accesses even more state
> > than nSVM.
> 
> I applied this to kvm-coco-queue, I will place it in kvm/master too unless
> you shout.

Depends on what "this" is :-)

My plan/hope is to land patches 1 and 2 in 6.14, i.e. in kvm/master, but the
rest are firmly 6.15 IMO.  And based on Yan's feedback, I'm planning on adding a
few more cleanups (though I think they're fully additive, i.e. can go on top).

