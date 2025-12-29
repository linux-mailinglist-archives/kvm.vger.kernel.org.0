Return-Path: <kvm+bounces-66778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FD0CE733E
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 16:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A8363012DE5
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 15:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2951F32B9A8;
	Mon, 29 Dec 2025 15:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iTXCUM0S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36DD2165EA
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767021885; cv=none; b=g2Sc6j+0tzfAbCdDRyCtWEM3rSASA/TbmlHZ9CWjJ3AP/ko2JAQvgsxiFWFXcmd1FVaiJuUDZz+vi6D7IkW5t7RHKoTLszw6ozBbBLJO8P6V5gTctEFj2T91HQTZQwXGzbKkoaIcaYKhm+6H1rqWj+GnLrZKt3Ysz0kga3wYTjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767021885; c=relaxed/simple;
	bh=NN8T3287x7Ols1SXOdTD/e2049uwV6Gj932H5nZUdZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q9v2CfHa7roMwfV7rlra1oTc1/tb9BH82XUJFbAoQiEBk4+bCycV3sbEaf8IxiXkU8IBi+q+GZtQN0xgS30W71TH1cCA7gHzjFZQ7gB5aM4FLz0U1TIxivKg5OR7EREE1vbhbEEJerUtnZ2kEx/l3du1ro0zzUntG+LmnYCNKqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iTXCUM0S; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7f046e16d50so15329463b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 07:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767021883; x=1767626683; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IPdy/u4ar4zg+FvL/tA84pDfFm5/wiGlEDxZ5SeN1nQ=;
        b=iTXCUM0SC9c3cD7+83LI9YBZBsLYPDvE5eIx8ftopShbVj5FYZiT1B2Rrepow65+J5
         e/dkJ9BHmFPuEkwiL2rNTy918CUYqHB+izIOw9wJNCUSLNoACtwXOUalKPPXu8rd0Gvk
         wmEuqxL2VY9CRnRucGZTVrc7SrMuiPk8NV/r4iWSiqqmTFcZNnyC//+GKOnJIgbVPZbj
         cXdfkcQYZ8yzhbinC+yzoP2NHrSZCW42fSSV96qttu+YpOxB8dmAnPUYN1FZ5LhI1YoK
         sGGIBXiz8X34ZHt947cfJy9WAh6Nxqazdm5hgU3xNfpIZiPudZykheBsbp2/G29Tc7lg
         fJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767021883; x=1767626683;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPdy/u4ar4zg+FvL/tA84pDfFm5/wiGlEDxZ5SeN1nQ=;
        b=agkjrs+Z1PuOxJCJDzE3peuN+HGQtcEBun8S7AcfaIExnwhbWzNPAwq30w8TFQhGv1
         Ju6dpwjoiPxzBsdxnD7OrEWN2Z0vc8VjrxMdap0c+zgPrO/HPE69AAQGiNXfhM1kj6V0
         aqwNDLLi9vLVh0mVBtmDRdjII0aoE3TEFh4SvaqvnGOSJgtZNP+ei8Db2tQRl8Dh3wxx
         s/ZMq1xDxCSOdYa7RyiqC4EGu3wZgNNXJUuju2yZk9w7OsHGUQO3QGugYDyD3lmPqqoH
         U6MnsShhZ0LPISVXz9ww/eQJbuA44dzt0F2oCGjkxR1paMfaOoWiC3ROLlyP1LusRJJN
         lPCg==
X-Forwarded-Encrypted: i=1; AJvYcCU1KWxp96PYTHGaBSsLPVNxz01R/Xs1Q2Kj7zRML7KbOfROc6o9egYEBSkc4dZgHyc1/i8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5y3jiYwdD0kT5yO6jwCE6GcWWYzjF5na9zEP0PoIUMliH/424
	C7NkH5sCfjO2h8IEiVC0eIhU9fM/10AYicaF1c4UP7r1jrwwOQYhh1jljd8BaIrQz8XHtdXgeUj
	jLC36Xw==
X-Google-Smtp-Source: AGHT+IFgS7WihSzpyIuhrJFpLQJCGyE0BCoxx8nYlJDyjilVPlDY1U8ZPShs2HwghBqKbLanUNIlqfzMI1o=
X-Received: from pfbff2.prod.google.com ([2002:a05:6a00:2f42:b0:793:b157:af42])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:44c6:b0:7e8:4433:8fb9
 with SMTP id d2e1a72fcca58-7ff66d5f992mr22928778b3a.65.1767021883283; Mon, 29
 Dec 2025 07:24:43 -0800 (PST)
Date: Mon, 29 Dec 2025 07:24:41 -0800
In-Reply-To: <yq7u5tot4mr67pxiu7frq62ndk2mpzwjir5264alva3jhcd6z5@mgaew5c3vms7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-7-yosry.ahmed@linux.dev> <aUsXw9m4g-Pn7LtO@google.com>
 <yq7u5tot4mr67pxiu7frq62ndk2mpzwjir5264alva3jhcd6z5@mgaew5c3vms7>
Message-ID: <aVKdOU8scPANWb1h@google.com>
Subject: Re: [PATCH v3 06/16] KVM: selftests: Introduce struct kvm_mmu
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 23, 2025, Yosry Ahmed wrote:
> On Tue, Dec 23, 2025 at 02:29:23PM -0800, Sean Christopherson wrote:
> > On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> > > diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> > > index 972bb1c4ab4c..d8808fa33faa 100644
> > > --- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> > > +++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
> > > @@ -10,6 +10,8 @@
> > >  
> > >  extern bool is_forced_emulation_enabled;
> > >  
> > > +struct kvm_mmu;
> > > +
> > >  struct kvm_vm_arch {
> > >  	vm_vaddr_t gdt;
> > >  	vm_vaddr_t tss;
> > > @@ -19,6 +21,8 @@ struct kvm_vm_arch {
> > >  	uint64_t s_bit;
> > >  	int sev_fd;
> > >  	bool is_pt_protected;
> > > +
> > > +	struct kvm_mmu *mmu;
> > 
> > No, put kvm_mmu in common code and create kvm_vm.mmu.  This makes the "mmu" object
> > a weird copy of state that's already in kvm_vm (pgd, pgd_created, and pgtable_levels),
> > and more importantly makes it _way_ to easy to botch the x86 MMU code (speaking
> > from first hand experience), e.g. due to grabbing vm->pgtable_levels instead of
> > the mmu's version.  I don't see an easy way to _completely_ guard against goofs
> > like that, but it's easy-ish to audit code the code for instance of "vm->mmu.",
> > and adding a common kvm_mmu avoids the weird duplicate code.
> 
> Do you mean move pgd, pgd_created, and pgtable_levels into kvm_mmu?

Yep, exactly.

> If yes, that makes sense to me and is obviously an improvement over what it's
> in this patch.
> 
> I didn't immediately make the connection, but in hindsight it's obvious
> that having some of the state in kvm_vm_arch and some in kvm_vm is
> fragile.

