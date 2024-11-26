Return-Path: <kvm+bounces-32482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDAF9D8F71
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 01:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AB8D288DFD
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 00:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869EA23AD;
	Tue, 26 Nov 2024 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dpa33jkQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA4A64A
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 00:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732579615; cv=none; b=duafyr0X7GOIm7h58TH9S3rK9eMpMIMkReHW+9CTRA2h/GDSVlfkQ2QR7bgx4acfjqJfBkITzdcKJ3Ef9ppJDBF1klbtoXkSlehatFEpP8zfhSoIbFcuhRLKLc339UBpksFp0N5V+Wd5uXXbkp51xt1tKHAZSfjAv+Av0we5KDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732579615; c=relaxed/simple;
	bh=M5Co9uthH1gnhd3RN0apUr1JSaNbeWOyJUNf+j9Ky/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lR1rBowN9FXpMYFoa6PWvqyO4Jt1Hdj0WWpNewXuK8Ei+RctG6zSaMgGRbVAm+FFJtbmDNd1zIccpLOYi0Nf+5bpRmaU8lPHuQaTpNwKyn3lGc2EU2WTUIfg7YecRAKk2XHtGsyhBXAVGwc1h8WwnU8CVeERIkFlfNXAbsgrqDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dpa33jkQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea50590a43so5935565a91.2
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 16:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732579613; x=1733184413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ugon1neLTS7p3z4YTPYc8MJMYZy7L4ypwCsQUtXZKYM=;
        b=dpa33jkQSiyQ8y92Jlvk1+/2D/vgGqntoggfBx4BhtBhFNHNwT6GKy6Ke2MAkdkQMC
         FxMMQq4Xx08U10aQFUVCqemCMh8Ix9/9Vc4JXBBJXfBgARg5CI4gsYf7rqWOiElN+6b0
         NP8DGrE2a3DHjy4GDhfKBoF0mkfo7kPYhW3vlF0SedQetQqTxHRwpxbz4YxvUXTFRWgC
         xockf/ETNHNYAVlpcV980ynL2CH0ICoBOAoI4qMb+lNgsJvsoUEt4Sq21kfi3RZgkDVJ
         LIFJ1XPF3Yj+/8hHD1nvlKPhO9bGaj0UrF8umItBVYdbc2Ei89yN4FzK6MWxFCciSc1x
         ZCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732579613; x=1733184413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugon1neLTS7p3z4YTPYc8MJMYZy7L4ypwCsQUtXZKYM=;
        b=hPSDGiMm8odZWt9PeUKW3sc242CeeE4ndY4xuPO+sOa3qeHuc3nFf2sSNGfOCtuHu2
         Tj4nZ/PcGhUiQibtbYny1qm8IokAE14KwSLOIbv6TCR73OO5NyVpWTnz+CEln1xxC//E
         mqT2Ex1ewjxecZ1L0rq5S0qsGEH9tlthDEnlmRpgxn4KTpFSqViK9D4r9Vv86zElCnIX
         mA5dxOawFhIpB+ALfLFM5U+wDd2ddr+UmWkeAahUIvNX5YN3Ihnl5NWdRYFpbSLR0G2m
         XpRQ6OIDNl1Supcol8r7czGxzrm9ZhT4y52kNrDmXcVo+ESm7v9NjwBjkiYuQcFefMM2
         SEyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOjdSi+QN7mikpXTk/2nbIVmTGz+m4rS+Vv76YHVSXdnOzM92LEZMFYljlOqk5Y33ScQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvYCZYQb+wftgrKlUYofMsDE77GlSJ9rMLYANkyk8zoUs8agYv
	LglBO6eH8c/JLHO7UO6NSgW6D/TuIuaAB07vojZbN4qH+tgW+sIYr7xmtrXlCzTIaq0kjsghfd2
	tNA==
X-Google-Smtp-Source: AGHT+IG9PKWc+g14McheU5BkRkSI/aTn5PquV13KcWCYV3a7A5r9c+gWMln98TaoHNW0Ap5dQ27lIcklU4M=
X-Received: from pjbta12.prod.google.com ([2002:a17:90b:4ecc:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d81:b0:2ea:aa69:1077
 with SMTP id 98e67ed59e1d1-2eb0e02b69cmr18708951a91.6.1732579613575; Mon, 25
 Nov 2024 16:06:53 -0800 (PST)
Date: Mon, 25 Nov 2024 16:06:52 -0800
In-Reply-To: <b7d21cce-720f-4db3-bbb4-0be17e33cd09@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241118130403.23184-1-kalyazin@amazon.com> <ZzyRcQmxA3SiEHXT@google.com>
 <b6d32f47-9594-41b1-8024-a92cad07004e@amazon.com> <Zz-gmpMvNm_292BC@google.com>
 <b7d21cce-720f-4db3-bbb4-0be17e33cd09@amazon.com>
Message-ID: <Z0URHBoqSgSr_X5-@google.com>
Subject: Re: [PATCH] KVM: x86: async_pf: check earlier if can deliver async pf
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, peterx@redhat.com, 
	oleg@redhat.com, vkuznets@redhat.com, gshan@redhat.com, graf@amazon.de, 
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com, nsaenz@amazon.es, 
	xmarcalx@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 25, 2024, Nikita Kalyazin wrote:
> On 21/11/2024 21:05, Sean Christopherson wrote:
> > On Thu, Nov 21, 2024, Nikita Kalyazin wrote:
> > > On 19/11/2024 13:24, Sean Christopherson wrote:
> > > > None of this justifies breaking host-side, non-paravirt async page faults.  If a
> > > > vCPU hits a missing page, KVM can schedule out the vCPU and let something else
> > > > run on the pCPU, or enter idle and let the SMT sibling get more cycles, or maybe
> > > > even enter a low enough sleep state to let other cores turbo a wee bit.
> > > > 
> > > > I have no objection to disabling host async page faults, e.g. it's probably a net
> > > > negative for 1:1 vCPU:pCPU pinned setups, but such disabling needs an opt-in from
> > > > userspace.
> > > 
> > > That's a good point, I didn't think about it.  The async work would still
> > > need to execute somewhere in that case (or sleep in GUP until the page is
> > > available).
> > 
> > The "async work" is often an I/O operation, e.g. to pull in the page from disk,
> > or over the network from the source.  The *CPU* doesn't need to actively do
> > anything for those operations.  The I/O is initiated, so the CPU can do something
> > else, or go idle if there's no other work to be done.
> > 
> > > If processing the fault synchronously, the vCPU thread can also sleep in the
> > > same way freeing the pCPU for something else,
> > 
> > If and only if the vCPU can handle a PV async #PF.  E.g. if the guest kernel flat
> > out doesn't support PV async #PF, or the fault happened while the guest was in an
> > incompatible mode, etc.
> > 
> > If KVM doesn't do async #PFs of any kind, the vCPU will spin on the fault until
> > the I/O completes and the page is ready.
> 
> I ran a little experiment to see that by backing guest memory by a file on
> FUSE and delaying response to one of the read operations to emulate a delay
> in fault processing.

...

> In both cases the fault handling code is blocked and the pCPU is free for
> other tasks.  I can't see the vCPU spinning on the IO to get completed if
> the async task isn't created.  I tried that with and without async PF
> enabled by the guest (MSR_KVM_ASYNC_PF_EN).
> 
> What am I missing?

Ah, I was wrong about the vCPU spinning.

The goal is specifically to schedule() from KVM context, i.e. from kvm_vcpu_block(),
so that if a virtual interrupt arrives for the guest, KVM can wake the vCPU and
deliver the IRQ, e.g. to reduce latency for interrupt delivery, and possible even
to let the guest schedule in a different task if the IRQ is the guest's tick.

Letting mm/ or fs/ do schedule() means the only wake event even for the vCPU task
is the completion of the I/O (or whatever the fault is waiting on).

