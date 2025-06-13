Return-Path: <kvm+bounces-49541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A2C8AD985E
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D8A17A2F4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3031B28DB4F;
	Fri, 13 Jun 2025 22:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c23Z/mIa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055621F3B9E
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749854894; cv=none; b=gYh37QljUHlioDIP+48tOztL75GTnzPLCAHxBGKaVnQ2CeVYA2O682wGxKYaJpGBWFUC5jv9hLv2iyoGIKBXuoaj5AnPbUy3aE3WIHIFdN+y291hG+8IGtUdaSc8QrAElxetOFkhbyZfRR7tKlOtHsWSxJ5XzQjL2nnCblTzNMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749854894; c=relaxed/simple;
	bh=b2f4UfTd6Ie3E6DBleQTiYYTSPeearnB2GRwzHGTHi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DcYEDz9gKPXbWMrhXB/bjU7tnHv4oxkmCg1UP/UbdGoP4caU3e6p4AtRRO7oGq1DPECl9HknRiLzKACgh+5UCPWvPLVZ/+YnSaA8r+WLbMVCpX+O/kpcNA2rG+/+109jbM1SvDF769S+3iAkdPmglQIOXtm6HISUBjngoAknfQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c23Z/mIa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311f4f2e6baso2458118a91.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749854892; x=1750459692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I0pEZjx6fVkzLwzb7Tf4p6SavBE34NRSvbWnq2Fu6u8=;
        b=c23Z/mIaayvg18QQApHw304Ncj9U+M8HJVWS/Cla7tXwnQb0Zvb/wGOMBugWEutvPY
         xIRKW2Oo3DQOPpakxO1O25HD/254WXVxzCYKU1xW3gJyIod069zuYbzIreAxWjQJ+jCz
         VqvrMGIojF9N/+JDawuTNbbeXVRaOLYP4Bn/uVuB63ANyne7zHdsCmlHzbdl9FC9MiIA
         V/oJceOawz0Ml6kosu7zS1bT6xpZZ+00GNLvUDbs648waQwsZrN8hMh3U+/mDZ2IFVUq
         JEURE1OZIoxl1QdRjvOZOr3YPn8oXYt8pMKt4h63GRqFw2I36+boMleD3zurbDstoy2U
         E+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749854892; x=1750459692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I0pEZjx6fVkzLwzb7Tf4p6SavBE34NRSvbWnq2Fu6u8=;
        b=bZY1FM84FAbaYJxLQicayzRcGCmP5JfPJjR5m5U1aOmPaxoQFdmJyqfAke/gFprwXa
         jbXMM3+Vh5nlmLUNMzkxTzUCkJQTcSksg9cNyTYvNri253QmwSXcGjh+YHMMPAfkJgG7
         o7ORIu3fwSA0J4PHCtOmszYW9wHnr66sK23JMHPB/dUGR8xtnsmKVJ6j7vY7U7MwtlUQ
         eB5D//duCUxvnKA4UqABtfNxxYm4UU+iw+Qumdt7K4DORtVPdL3eBeKxbNbXi/Urbk+n
         W5zH2VhxT1E9Y4JVmyFXxEZ9URy7+6tAOIB1Gg6olduClIBIlvc9GfmCKmChEyYct9Wr
         aMIA==
X-Gm-Message-State: AOJu0Yxj0h+IaDZZ4xZOaKjZH2K+MAPGifSBw5H0/95+aHeHHu0Q5nTp
	LH4MLA95qcSmdiMNiVFPnMJ/q+TqHzkHHYz2WlNDG0FWajb+Qkb16gvNZByXZdauqWbyWLqKn/e
	+e+BUGA==
X-Google-Smtp-Source: AGHT+IFmVbuER09bqe0w/t1NnKGFZRyDNJUVfxGfFpjqY6vikPqb0P4dso4PSiLkCEX/Cq6o353w4bjW7uU=
X-Received: from pjbdy14.prod.google.com ([2002:a17:90b:6ce:b0:313:274d:3007])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7c6:b0:312:b4a:6342
 with SMTP id 98e67ed59e1d1-313f1dd5483mr2147790a91.33.1749854892347; Fri, 13
 Jun 2025 15:48:12 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:48:10 -0700
In-Reply-To: <aEySD5XoxKbkcuEZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com>
Message-ID: <aEyqqj77hIAZy8FL@google.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Sean Christopherson wrote:
> On Wed, Jun 11, 2025, Fuad Tabba wrote:

...

> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> 
> And to my point about "shared", this is also very confusing, because there are
> zero checks in here about shared vs. private.

Heh, and amusingly (to me at least), I was the one that suggested this name[*]:

 : >  static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 :
 : This should be something like kvm_gmem_fault_shared() make it abundantly clear
 : what's being done.  Because it too me a few looks to realize this is faulting
 : memory into host userspace, not into the guest.

Though I don't think my two statements are contradictory.  A bare kvm_gmem_fault()
is confusing because it's ambigous.  kvm_gmem_fault_shared() is confusing because
"shared" is (IMO) bad terminology.

E.g. to me, this is much more obvious:

  static vm_fault_t kvm_gmem_fault_user(struct vm_fault *vmf)

or even

  static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)

if we're worried about "user" getting confused with supervisor vs. user in the
guest.

[*] https://lore.kernel.org/all/Z-3UGmcCwJtaP-yF@google.com

