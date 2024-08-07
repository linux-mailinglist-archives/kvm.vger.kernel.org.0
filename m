Return-Path: <kvm+bounces-23579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A442A94B282
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 23:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B8451F23227
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 21:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CEA1552F5;
	Wed,  7 Aug 2024 21:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1h9QXAV1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EB214EC47
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 21:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723067919; cv=none; b=ibVDIH6siW2NDDRwYB9RFoFtgpQ9JIblxWkUxq/fWvlUYLbY3xJUy7+kEcYiPVUDH3zVX1hxvk8JXjFmZvmN3kBNtZvS/smlLKSYSd/GkSbqVqDO2pnnYM6tsUX8RwbqUHzfnLTXH8BIvB3s0EwGqcjYS7TWFzVmoGDNCAwW044=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723067919; c=relaxed/simple;
	bh=c08WaZBC8OmswkebMYegQBqCu6JB2zC4KsS+DBX2LfE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EMQggiramdnS9ALxm6Ii22Rwo/bg6e/fJcwNFqVeGJdc9zRWP98MFrZgtmq/dJ4D5buiQRdj0tIiNe5N5KxGVe7WVR+0TBu5+FeVaJ/H6eaQE0kuHqTig4etycvT4NN2QZKhKQ28uaUekJC48c4Nul1jWDH5weOEYhHUrkj8uts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1h9QXAV1; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso236442a12.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 14:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723067917; x=1723672717; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Geo7mE7Px+nMYERQfpI51YnWlkJ5yKR6d+PPNKtIfZQ=;
        b=1h9QXAV1Irw1QSzpeqV+TQWks+Rhmd9eCuMy5Gqs+dcyUZ4AdC4qiR5Tz/G+iriDCo
         0n5VMiVYP6DcuPSolS5eQwJwrCs6mrA6tgt3DnIYj8IcMqyYSiHhT2ceZ60LQ5seFCFJ
         0Qi3868ODZ8oR+IAFMeY1ACsgFydz0B5qXTLkCJZ5YLJzdsBkK8nTJ5kOmB9SeDgdTS7
         5MI06yNZ53EO/y8XzBIswEk70DiMw9bq+yovnVf2Ty+X2+C7XcSObZgL/WJ1uLC3LRp5
         aw3FgjMm3vE3V7pk6lgek+dfLStFHLnSkWxkifq7iOkCDWGncdBAmIcAvW4ngsSvgMFL
         qwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723067917; x=1723672717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Geo7mE7Px+nMYERQfpI51YnWlkJ5yKR6d+PPNKtIfZQ=;
        b=Va3zXeH5MMXCn6kL1veAQQbBun8EJlmdp/hUXgvM2A3FV+j4F92tFKmEmHdgDiEIpJ
         BHNOM32uzFvZ7O3ep1ylG+FD93RBdnWBH5hoXHwamcbnLmpGRB4zSma4CMREeXsCQLW0
         cPAIdE0ZMUT9pSe7qFhlb9yqGUwKxuwjvsYfdjNqnzElxyaUd9pXwfI6cgKorKwJpkfD
         liViMzvv1soIGRZxsRYdnhDkSjZriACO2cfhpHvnlLdaTBt2RRpDsn4Z7ahxNhdb2dv2
         UTP2kf8hP8BgtdHBTRB+DJ27vKXUsmMDjWb0t9fPttclGkWcABCl1M1oYggYid8kwC8R
         dQEg==
X-Forwarded-Encrypted: i=1; AJvYcCWKhSG3+aJo+nsiMhyZxc0aE8C09/wrkLUtgePVjw+QDeKLHp33KZYB81xyLZlJCRdPTVY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4qIGgOhtPpIknpu/kGiHuiVmQKqFnIDLoJykFLBFBbqSJkRTI
	hEyn8VW+O1h/UOCQ1gPmnIE2Ily135ACEECyvCV6eMjr97bh10ZXQI79hiDdsMh0/7PGBeXNoCJ
	hJg==
X-Google-Smtp-Source: AGHT+IGT4yfaQtCszwo3v/BQf+VsEDoi91mBnnPGweFALLFNPlxrCzIoFqDGdSNEdxfNC5erws8GJco3fog=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:935a:0:b0:702:4fb6:8724 with SMTP id
 41be03b00d2f7-7c11124f056mr7890a12.1.1723067917038; Wed, 07 Aug 2024 14:58:37
 -0700 (PDT)
Date: Wed, 7 Aug 2024 14:58:35 -0700
In-Reply-To: <b0c3552b-1efd-4c48-8d86-91ee16e7222a@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240730155646.1687-1-will@kernel.org> <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co>
 <Zql3vMnR86mMvX2w@google.com> <20240731133118.GA2946@willie-the-truck>
 <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co> <Zqpj8M3xhPwSVYHY@google.com>
 <20240801124131.GA4730@willie-the-truck> <07987fc3-5c47-4e77-956c-dae4bdf4bc2b@rbox.co>
 <ZrFYsSPaDWUHOl0N@google.com> <b0c3552b-1efd-4c48-8d86-91ee16e7222a@rbox.co>
Message-ID: <ZrPuC59gatPJ4UzQ@google.com>
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
From: Sean Christopherson <seanjc@google.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Will Deacon <will@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 06, 2024, Michal Luczaj wrote:
> On 8/6/24 00:56, Sean Christopherson wrote:
> > [...]
> > +	/*
> > +	 * xa_store() should never fail, see xa_reserve() above.  Leak the vCPU
> > +	 * if the impossible happens, as userspace already has access to the
> > +	 * vCPU, i.e. freeing the vCPU before userspace puts its file reference
> > +	 * would trigger a use-after-free.
> > +	 */
> >  	if (KVM_BUG_ON(xa_store(&kvm->vcpu_array, vcpu->vcpu_idx, vcpu, 0), kvm)) {
> > -		r = -EINVAL;
> > -		goto kvm_put_xa_release;
> > +		mutex_unlock(&vcpu->mutex);
> > +		return -EINVAL;
> >  	}
> >  
> >  	/*
> > @@ -4302,6 +4310,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >  	 */
> >  	smp_wmb();
> >  	atomic_inc(&kvm->online_vcpus);
> > +	mutex_unlock(&vcpu->mutex);
> >  
> >  	mutex_unlock(&kvm->lock);
> >  	kvm_arch_vcpu_postcreate(vcpu);
> > @@ -4309,6 +4318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> >  	return r;
> >  
> >  kvm_put_xa_release:
> > +	mutex_unlock(&vcpu->mutex);
> >  	kvm_put_kvm_no_destroy(kvm);
> >  	xa_release(&kvm->vcpu_array, vcpu->vcpu_idx);
> 
> Since we're handling the impossible, isn't the BUG_ON part missing
> mutex_unlock(&kvm->lock)?

Doh, yes.

