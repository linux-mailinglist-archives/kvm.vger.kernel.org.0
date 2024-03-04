Return-Path: <kvm+bounces-10809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E039387049F
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:58:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E8ED1C20FED
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 14:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FAF45BF6;
	Mon,  4 Mar 2024 14:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LbfOXwVh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE7ABE4C
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709564302; cv=none; b=G2PDIjNJm9IvXFKOTeAUbcNsNpaViVypukGrXyvFQeGcU5OueXSHX8nTIep7877Ncp8/cOhuTceWY4xw90g3dS1Pf1SeRTc9Ma69rMyQt0sL3vaeVhuRRlpAkZU15W0LRmjqhTw4Z0hFz1Gfv6tKfVh68Es+H2j5gEtK+GS57OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709564302; c=relaxed/simple;
	bh=Gx/fanVcTAbOBQHjB+gJ/LpDk0tcUzbeGoIrwaa5Fow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFx5aD0a5/M+fZk3CaeKVM/IGV+OB/pdz8qkzF26/nglnuzEej5yegbQzROdnALwldBBqDlq9tvGd0/QoJOm6DilQahOZUV6tyUqjGNx7U3jXfj2CPVfgD5bBtuDUYKKsEqBw2INE/VeQuMGBS3xuLrzl/rzoQAmWQFdksE+2z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LbfOXwVh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709564299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nRj+ZQOUd9c6zEEw65NfXBu2gLm5lh8Gkkiq+U+6YUM=;
	b=LbfOXwVhNX4DVJYsgPFyg64b6nyEJI1ZW5nZIN4+Kf3Any9RHdgGj7dQqcpiERLbcRsdr4
	FntnEq9K6ChEwXocP0hMXiz+YuDKtgoAFc8gUj1f+c5pjfjiMkBe9XREUFb0fSuAOZp0Y2
	7ah0ChFziB78/sIImchV8Ni/M+Z0yo8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-yNZwggd_Mb6qpGudFh1kVQ-1; Mon,
 04 Mar 2024 09:58:16 -0500
X-MC-Unique: yNZwggd_Mb6qpGudFh1kVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E126B3816449;
	Mon,  4 Mar 2024 14:58:15 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE58C111D640;
	Mon,  4 Mar 2024 14:58:15 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 8BA3518009DB; Mon,  4 Mar 2024 15:58:14 +0100 (CET)
Date: Mon, 4 Mar 2024 15:58:14 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/1] kvm: add support for guest physical bits
Message-ID: <z4di6tev2kdeddclskhl5xhrlpseykgukfwit6ickrh57zscyv@bkjtbyj3enjx>
References: <20240301101713.356759-1-kraxel@redhat.com>
 <20240301101713.356759-2-kraxel@redhat.com>
 <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ab64c0f-7387-4738-b78c-cf798528d5f4@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Mon, Mar 04, 2024 at 09:54:40AM +0800, Xiaoyao Li wrote:
> On 3/1/2024 6:17 PM, Gerd Hoffmann wrote:
> > query kvm for supported guest physical address bits using
> > KVM_CAP_VM_GPA_BITS.  Expose the value to the guest via cpuid
> > (leaf 0x80000008, eax, bits 16-23).
> > 
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> > ---
> >   target/i386/cpu.h     | 1 +
> >   target/i386/cpu.c     | 1 +
> >   target/i386/kvm/kvm.c | 8 ++++++++
> >   3 files changed, 10 insertions(+)
> > 
> > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > index 952174bb6f52..d427218827f6 100644
> > --- a/target/i386/cpu.h
> > +++ b/target/i386/cpu.h
> > @@ -2026,6 +2026,7 @@ struct ArchCPU {
> >       /* Number of physical address bits supported */
> >       uint32_t phys_bits;
> > +    uint32_t guest_phys_bits;
> >       /* in order to simplify APIC support, we leave this pointer to the
> >          user */
> > diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> > index 2666ef380891..1a6cfc75951e 100644
> > --- a/target/i386/cpu.c
> > +++ b/target/i386/cpu.c
> > @@ -6570,6 +6570,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >           if (env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_LM) {
> >               /* 64 bit processor */
> >                *eax |= (cpu_x86_virtual_addr_width(env) << 8);
> > +             *eax |= (cpu->guest_phys_bits << 16);
> 
> I think you misunderstand this field.
> 
> If you expose this field to guest, it's the information for nested guest.
> i.e., the guest itself runs as a hypervisor will know its nested guest can
> have guest_phys_bits for physical addr.

I think those limits (l1 + l2 guest phys-bits) are identical, no?

The problem this tries to solve is that making the guest phys-bits
smaller than the host phys-bits is problematic (which why we have
allow_smaller_maxphyaddr), but nevertheless there are cases where
the usable guest physical address space is smaller than the host
physical address space.  One case is intel processors with phys-bits
larger than 48 and 4-level EPT.  Another case is amd processors with
phys-bits larger than 48 and the l0 hypervisor using 4-level paging.

The guest needs to know that limit, specifically the guest firmware
so it knows where it can map PCI bars.

take care,
  Gerd


