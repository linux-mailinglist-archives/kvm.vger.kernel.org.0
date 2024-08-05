Return-Path: <kvm+bounces-23190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A36294766E
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 09:57:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36272281844
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 07:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F51814B06E;
	Mon,  5 Aug 2024 07:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBQwR8Dv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4619D149C68;
	Mon,  5 Aug 2024 07:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722844651; cv=none; b=qvigliiJ9beQjhqRpbYq9Qgp4ogpu9AuZjRKLBM9/kGhB172/WfQRVY1QCdw4cxUBai/DEpJ202nYqX+W3okxd41Oa6Mn1RWuUG9LUd4nhsmQBCGhP9iYyQfVD/UVS/4wPckXAnk6qnNEqo/p1H7DUWTTSZev9lcxDwB2LrN3NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722844651; c=relaxed/simple;
	bh=Geket5xHj+rV/lTGgYhI+mobx7QxgrRmSJGYSEDRkpk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Y54TeAirpMelSVU1oSi7HNK07/FqLHF4NUTPp4bVQqznk/EcKOsJIEik67eN55jdGyz6kxvKNFxSzkuiQnhTmHGx6GI43/YjcQroiVBrrH/PnKH+PaesdBpe/cH7hRt8zxGu+/iJQn9RTdZ4k3sbGxULkGODVvkg0UQmmwncCow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBQwR8Dv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59266C32782;
	Mon,  5 Aug 2024 07:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722844650;
	bh=Geket5xHj+rV/lTGgYhI+mobx7QxgrRmSJGYSEDRkpk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UBQwR8Dv5k7JtkeG4laWC2Xs0oOnozRLy+3hVYnDYQn2Ed5eCrDNKiqSjdoXT4acx
	 1hPdTL4JDstUhQJJ7lCM7YYqnV4Qh1m6C+CK460q8siGoQwJJKzkWsjMOX4qcfmelz
	 A6Yt57Xlk92ABmDDhigDShW3vM0pnXKBZJdZWOrnwttmRyqlw3hP4oeUm/b5LanIcX
	 fVlLRwpf9c9nuW6b7SobjiC6lu0VN8iuGUvVZHCooHxsAnFt7ePn4zwuEV1kg+BLX4
	 tQQRPbEFjC/HMt7oQ6FPHcOxgz1D3ofgxyEIT69W/KjqEASCYIB1LwhYcesfg0NZf1
	 asOwN60f4YLIQ==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	David Matlack <dmatlack@google.com>,
	David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 02/84] KVM: arm64: Disallow copying MTE to guest
 memory while KVM is dirty logging
In-Reply-To: <ZqvNekQAjs-SN-se@google.com>
References: <20240726235234.228822-1-seanjc@google.com>
 <20240726235234.228822-3-seanjc@google.com> <yq5aikwku25o.fsf@kernel.org>
 <ZqvNekQAjs-SN-se@google.com>
Date: Mon, 05 Aug 2024 13:27:18 +0530
Message-ID: <yq5a5xsftna9.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 01, 2024, Aneesh Kumar K.V wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > Disallow copying MTE tags to guest memory while KVM is dirty logging, as
>> > writing guest memory without marking the gfn as dirty in the memslot could
>> > result in userspace failing to migrate the updated page.  Ideally (maybe?),
>> > KVM would simply mark the gfn as dirty, but there is no vCPU to work with,
>> > and presumably the only use case for copy MTE tags _to_ the guest is when
>> > restoring state on the target.
>> >
>> > Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
>> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>> > ---
>> >  arch/arm64/kvm/guest.c | 5 +++++
>> >  1 file changed, 5 insertions(+)
>> >
>> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>> > index e1f0ff08836a..962f985977c2 100644
>> > --- a/arch/arm64/kvm/guest.c
>> > +++ b/arch/arm64/kvm/guest.c
>> > @@ -1045,6 +1045,11 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>> >  
>> >  	mutex_lock(&kvm->slots_lock);
>> >  
>> > +	if (write && atomic_read(&kvm->nr_memslots_dirty_logging)) {
>> > +		ret = -EBUSY;
>> > +		goto out;
>> > +	}
>> > +
>> >
>> 
>> is this equivalent to kvm_follow_pfn() with kfp->pin = 1 ?
>
> No, gfn_to_pfn_prot() == FOLL_GET, kfp->pin == FOLL_PIN.  But that's not really
> relevant.
>


What I meant was, should we consider mte_copy_tags_from_user() as one
that update the page contents (even though it is updating tags) and
use kvm_follow_pfn() with kfp->pin = 1 instead?

Is my understanding correct in that, if we want to look up a pfn/page
from gfn with the intent of updating the page contents, we should use
kfp->pin == 1? 

-aneesh

