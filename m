Return-Path: <kvm+bounces-37234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEF1A27312
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:43:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D517A18826B2
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 13:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ECA62185AB;
	Tue,  4 Feb 2025 13:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7puT0M0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7220A211707;
	Tue,  4 Feb 2025 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674954; cv=none; b=mK7Q4uHWV5ijNJKkxValNCb7qAL96tBqL8OpAyi8CDRfZ4oG0TSJ2A4THxMtMNQdQszNKB59ELh9eUh6oX/SWfaUO6MCAwV0ZXpbui5VLSBulZM5U/T6RGtwwhY7FH1VVh7I285R2h5UtHmvB+lQO6cB+bZDBv1hjS0qcprlCvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674954; c=relaxed/simple;
	bh=rCU20zhTZYBtL5tWyNNN1J3mcF8NyqKlWs5Hr42UOLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HyMzHCMyVElV37VL38pEAXEyn1iBFEzXKTSGmQHSG0A9EMMCyFphvSu1ASbXLSwqAgvpGDECM5DAf4inBUZV7ZJkmCnzZOM1djb8hSEnlqK8nuRvY44BsPvNM2gRndXgK6PnArJaLXVFcsbUlypcyPd3iGj0yI1bs/JWfM+XOVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7puT0M0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D570C4CEE2;
	Tue,  4 Feb 2025 13:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674953;
	bh=rCU20zhTZYBtL5tWyNNN1J3mcF8NyqKlWs5Hr42UOLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i7puT0M04jlql3dhnNEkrPYjVBCd6+CTazmpRggmUMecEVVZ6nPoq2zvadjtMtBH8
	 AP3PZVM+dhEKgMvxhTB/9HeFCfThHK/oY0GiPU5xOoE0JrCm8b/Tdy047BELkdW/RO
	 GF8w7XFKhaSVprpO73urPMd7GxwvObpKQIf5IytSjsoZrPoqIajQuv5u5ofz9eoGsl
	 lR81ENWzAQ0+fn9rMi7qGqlMBWzBsmYhqiAjC8xXvSjGaUMQKckzBTfpzcVWLyN+T9
	 RDWizsYtnK+lXEO1XSoWgE1aq2MsMs+CZW5oh5uOoLe+adVUFKuNdtrBPMpHcYtsUt
	 TiJjV3YUxp1IA==
Date: Tue, 4 Feb 2025 18:40:59 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: Remove use of apicv_update_lock when
 toggling guest debug state
Message-ID: <jhzyfv3t35zo43dhxjjuhgq2iz4gghr32ftsva3aeln5to5qns@iaunfm3qvqfd>
References: <cover.1738595289.git.naveen@kernel.org>
 <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
 <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>

On Mon, Feb 03, 2025 at 09:00:05PM -0500, Maxim Levitsky wrote:
> On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> > apicv_update_lock is not required when querying the state of guest
> > debug in all the vcpus. Remove usage of the same, and switch to
> > kvm_set_or_clear_apicv_inhibit() helper to simplify the code.
> 
> It might be worth to mention that the reason why the lock is not needed,
> is because kvm_vcpu_ioctl from which this function is called takes 'vcpu->mutex'
> and thus concurrent execution of this function is not really possible.
> 
> Besides this:
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Sure, thanks for the review!


- Naveen


