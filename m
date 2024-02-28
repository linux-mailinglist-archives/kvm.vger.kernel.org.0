Return-Path: <kvm+bounces-10257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E0E86B122
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 15:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7FC01C26270
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 14:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7981534E2;
	Wed, 28 Feb 2024 14:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eDaAdfcV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3D914F995
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709128904; cv=none; b=CKvUcQglHIWdhOPSI8ha7aWL8NPwK/3Z48ob3Y7KGIfOD9jjq+8y4rdJ2EHzYyOWh7lgaKTCjuonUnLL4U88gjl3b9Us4v9t9T1L84vA0GNzKVlgxzC26dDKV4570UwGg9RZdlwMR44h0Y1rz824OwQOFjKED2fZC+AvfSVpt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709128904; c=relaxed/simple;
	bh=xc76ZCeLWL3oTqKplyTXLIkjTzvs1c7E0/u3Cpm9N0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCA4gtg8ytkL8pLg1Ye7csBSqGQtoshBFDKXAHcPhpX3/MaaBiNVFlI2Wo+oRFA4VDcHqtfnycB+FN3IvvCbDxOf5fCfHwyiEc2Vx9mnE0jRR6Ezu7BwZyFhCM1hgf7VbsNkh6rowY2tkfpJbZcQyOEC5cHf7XiY4dLWloAHySE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eDaAdfcV; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a3e8c1e4aa7so585113666b.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 06:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709128901; x=1709733701; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EnEXRx8bnyUyfsm70CiXRdEbU0pNvdct3xMdEGSpg+U=;
        b=eDaAdfcVHNv+BKBnGd3pHrx2lO0YrKjEU84qLI+pxiDfrVSz/mK/NcTeUP/YFi+C2b
         v4KYa3z7wD1Wf83130KiOosVJ4vE7zJbMmtTaulruOGeMOwRxP3xJP1X42EFLF2ZZ2W1
         pvmUIvPpEk7R2Gdb2lpigk7OapXpoDYEF9KGnwYd+eI7iPVVhG7nKB98/y7+X8wdhhja
         9PweQBhgLdNC/ZEiSS1mFD1LncsUR8XJwWpb3cZtEVM00S9zyHQANuCqufvQOqiRRWlg
         Yrjqxv+DaUzRYUeHkXIDEkW+QyRqinzfhy06SnlFjWtpGSw7+vEBxe98jTUGb8g2cb03
         bG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709128901; x=1709733701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EnEXRx8bnyUyfsm70CiXRdEbU0pNvdct3xMdEGSpg+U=;
        b=CWNjk5MomdJXqflMZyipVXmiohewf7smJwtAyMb9liBBxVLJdJfiWhzTjYbc6RKuHl
         hJAQhsKp2nCAzLvy8HT8qLvkv0URccz0lPM5sTA6xAMk92F0NEL9iu2oVMCxY6avI/Ka
         TC1V/eFKW8VEwm4Y+spFjz7bBAp8zEm/w334DdxX0ShXF1I2c+B98GRzwojLISrEfbjo
         aaE2g4Y5WJJ+0a7t7BmHqSusN9ogj1KTrNtlEvg1n39pSRXKl+s6E1kos1pTYGJ+kp1w
         9DqJdEHW84St/L0sy82uRm5pdU03W6vWVobS1eF3p1k8s0S0Me31LUysP+hq/aypjMfJ
         eIEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKUi+mH+sytO8xtJ/P1D82yMuA5QXc76bbwXrtMFbU/grjc8yeRV9jU/IsIyclnM+e1QGAz3/2EOD7jRTH8QE/ziR3
X-Gm-Message-State: AOJu0Yx/6E9A23kXBcimFrrCq7GyJYZmjG6a9EIuaUQbZ3WcPwz/7FYG
	Nps3lDBPYFy2SAm8ZApBy2PncbAWG5Ugp44md/Zkw/0YIW96U2A1IM0kjgQ5vA==
X-Google-Smtp-Source: AGHT+IG+mMPw3nLKhBZME1EV6xBhg5as1F5Nh7tAbzSsU+HTsNt7AekMp+h4F9soXsgzhwe+C3070Q==
X-Received: by 2002:a17:906:af0f:b0:a3f:384a:73ab with SMTP id lx15-20020a170906af0f00b00a3f384a73abmr8640197ejb.71.1709128900636;
        Wed, 28 Feb 2024 06:01:40 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id cx9-20020a170907168900b00a43e8562566sm910600ejd.203.2024.02.28.06.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 06:01:39 -0800 (PST)
Date: Wed, 28 Feb 2024 14:01:36 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
Message-ID: <Zd88wFzxgGEWrhSb@google.com>
References: <20240222161047.402609-1-tabba@google.com>
 <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
 <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com>
 <a09996d9-17be-4017-9297-2004f0bc8ed3@redhat.com>
 <CA+EHjTxBOs3M7DNeUfq9EfpZ8wSw5Uh6SOr_fG_9V=xjTH2S_Q@mail.gmail.com>
 <0951868c-911d-4879-bc79-14b5d3959462@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0951868c-911d-4879-bc79-14b5d3959462@redhat.com>

On Wednesday 28 Feb 2024 at 11:12:18 (+0100), David Hildenbrand wrote:
> > > So you don't need any guest_memfd games to protect from that -- and one
> > > doesn't have to travel back in time to have memory that isn't
> > > swappable/migratable and only comes in one page size.
> > > 
> > > [I'm not up-to-date which obscure corner-cases CCA requirement the s390x
> > > implementation cannot fulfill -- like replacing pages in page tables and
> > > such; I suspect pKVM also cannot cover all these corner-cases]
> > 
> > Thanks for this. I'll do some more reading on how things work with s390x.
> > 
> > Right, and of course, one key difference of course is that pKVM
> > doesn't encrypt anything, and only relies on stage-2 protection to
> > protect the guest.
> 
> I don't remember what exactly s390x does, but I recall that it might only
> encrypt the memory content as it transitions a page from secure to
> non-secure.
> 
> Something like that could also be implemented using pKVM (unless I am
> missing something), but it might not be that trivial, of course :)

One of the complicated aspects of having the host migrate pages like so
is for the hypervisor to make sure the content of the page has not been
tempered with when the new page is re-mapped in the guest. That means
having additional tracking in the hypervisor of pages that have been
encrypted and returned to the host, indexed by IPA, with something like
a 'checksum' of some sort, which is non-trivial to do securely from a
cryptographic PoV.

A simpler and secure way to do this is (I think) is to do
hypervisor-assisted migration. IOW, pKVM exposes a new migrate_page(ipa,
old_pa, new_pa) hypercall which Linux can call to migrate a page.
pKVM unmaps the new page from the host stage-2, unmap the old page from
guest stage-2, does the copy, wipes the old page, maps the pages in the
respective page-tables, and off we go. That way the content is never
visible to Linux and that avoids the problems I highlighted above by
construction. The downside is that it doesn't work for swapping, but
that is quite hard to do in general...

