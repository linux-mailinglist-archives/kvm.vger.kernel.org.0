Return-Path: <kvm+bounces-29519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA4FD9ACD63
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 16:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A474280E20
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89AF1B6556;
	Wed, 23 Oct 2024 14:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="QUtgjPP4";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="QUtgjPP4"
X-Original-To: kvm@vger.kernel.org
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E5421830E;
	Wed, 23 Oct 2024 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729694007; cv=none; b=MtDy4H+YgpuRHwQW1wbaCGYKmImkD3qjnpczxE6TmnlZjO4BoQKz1fCiyfYLzFTWroyirs7+5qTl0txYvtbEXdDK3O03qAHaq+BewKhnSPZIWAEk0B89GaXyFWAY4AKCA++6kRgHZJfGgezgFyZQRhpAa96v6tbsf8CRv7NuxCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729694007; c=relaxed/simple;
	bh=S7Z+vVe4R+0sfq538t4ASPMCuufGmEe03z1ZjfijqSY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WkFAFwqA69ENlVy8pVUYtrh3xXC/KmU3/xVIaIaBslv/cFmCJDEuiTeVNYKOEaMrRna1zqSQueGawHdr/cgGwAaxZ7ytCkZ2qQW7bsCxKCEbpf5D4SyVGajCLh/G0WgQvJnm8pl9YiXD9qwe4ZHVUA0ug0zUu1eZ1qQQCaZ63S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=QUtgjPP4; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=QUtgjPP4; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729694004;
	bh=S7Z+vVe4R+0sfq538t4ASPMCuufGmEe03z1ZjfijqSY=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=QUtgjPP4gL/mKqPoyU7dcPQcu+19EbdaM/Me7wwl14P7Uy8i4mLXeUNL1O5zghzWC
	 7QSoqF/k0xoZHO/hFunv1Mf/s3rVYcw079SdrrnLz3cqwjxaAtJJ6gaTg2HFxCZzou
	 n/7CEm7Ox5hD2XpevQFv0XDA4jD+EFD2dYPyfL8U=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 4D90612874E5;
	Wed, 23 Oct 2024 10:33:24 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id zbiu8HbL15g3; Wed, 23 Oct 2024 10:33:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729694004;
	bh=S7Z+vVe4R+0sfq538t4ASPMCuufGmEe03z1ZjfijqSY=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=QUtgjPP4gL/mKqPoyU7dcPQcu+19EbdaM/Me7wwl14P7Uy8i4mLXeUNL1O5zghzWC
	 7QSoqF/k0xoZHO/hFunv1Mf/s3rVYcw079SdrrnLz3cqwjxaAtJJ6gaTg2HFxCZzou
	 n/7CEm7Ox5hD2XpevQFv0XDA4jD+EFD2dYPyfL8U=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id EF36F1287459;
	Wed, 23 Oct 2024 10:33:22 -0400 (EDT)
Message-ID: <526445c102e47fbc1179a76a85661c89581c29e5.camel@HansenPartnership.com>
Subject: Re: [RFC PATCH 0/5] Extend SEV-SNP SVSM support with a kvm_vcpu per
 VMPL
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Cc: roy.hopkins@suse.com, ashish.kalra@amd.com, bp@alien8.de, 
 dave.hansen@linux.intel.com, jroedel@suse.de, kvm@vger.kernel.org, 
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 michael.roth@amd.com,  mingo@redhat.com, tglx@linutronix.de,
 thomas.lendacky@amd.com, x86@kernel.org
Date: Wed, 23 Oct 2024 10:33:21 -0400
In-Reply-To: <8db215c5-4393-4db1-883c-431fed9dfd59@redhat.com>
References: <cover.1726506534.git.roy.hopkins@suse.com>
	 <6028e1a0fad729f28451782754417b0be3aea7ed.camel@HansenPartnership.com>
	 <ZxawyGnWfo378f3S@google.com>
	 <8db215c5-4393-4db1-883c-431fed9dfd59@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2024-10-23 at 13:48 +0200, Paolo Bonzini wrote:
> On 10/21/24 21:51, Sean Christopherson wrote:
> > On Fri, Oct 18, 2024, James Bottomley wrote:
> > > > I've prepared this series as an extension to the RFC patch
> > > > series: 'SEV-SNP support for running an SVSM' posted by Tom
> > > > Lendacky [1]. This extends the support for transitioning a vCPU
> > > > between VM Privilege Levels (VMPLs) by storing the vCPU state
> > > > for each VMPL in its own `struct kvm_vcpu`. This additionally
> > > > allows for separate APICs for each VMPL.
> > > 
> > > I couldn't attend KVM forum, but I understand based on feedback
> > > at a session there, Paolo took the lead to provide an
> > > architecture document for this feature, is that correct?
> > 
> > Yep.
> > 
> > > Just asking because I haven't noticed anything about this on the
> > > list.
> > 
> > Heh, there's quite a queue of blocked readers (and writers!) at
> > this point ;-)
> 
> Well, at least one person had a writer's block instead.
> 
> I had it almost ready but then noticed a few hiccups in the design we
> came up with, and have been seating on it for a while.  I'm sending
> it now, finishing the commit messages.

Thanks for doing that.  For those on linux-coco who don't follow the
KVM list, the document is here:

https://lore.kernel.org/kvm/20241023124507.280382-6-pbonzini@redhat.com/

Regards,

James



