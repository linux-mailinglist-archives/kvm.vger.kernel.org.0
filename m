Return-Path: <kvm+bounces-37459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 323C4A2A405
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:19:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71D2516744E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE94225A5D;
	Thu,  6 Feb 2025 09:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mk5dm/k8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9B8225A34;
	Thu,  6 Feb 2025 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738833566; cv=none; b=oLGmzhxUxcFNW+RRrwhEQg8WsC1ss+0eX8t2q1zdCcnt7PTEq0fWO7bSkv/0z8lhgI/peG24EvVQhqoFtYy6FsinQD3PKHY+6rnKdcCeeONNNgP2mPpNLlUbhmqIiUnesLIWq4VXuig126vpW8lu3pRZs79wYlN/7+VpnoG5mOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738833566; c=relaxed/simple;
	bh=2wRXntENQ2fBqqr6MsNNMGvS4hq6TPjdeMHkfZSCPqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3TyBec36D0DMxwa7f18kU7GiIFwXu+l1oWwcOQtHQIe61JdKckfIxbX1TC7X0LDQxLeIbLm8r1FvMsIQ2lQR3aLU96GgV9sQnWzCHsi1nKCW0rdyfHRXPUt+D9yxWK+W4yvE+xerzAwIsTLKnAWL8liDA9c0Or4iiPga8QraZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mk5dm/k8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C588AC4CEDD;
	Thu,  6 Feb 2025 09:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738833566;
	bh=2wRXntENQ2fBqqr6MsNNMGvS4hq6TPjdeMHkfZSCPqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mk5dm/k8j5EtrDGcAjEKVL7nttXo1EicE8J9LcSDUoGkYTl8fURxUUTOfk4xixotk
	 fOkQ+YVuHdxV2wSW7xFdUqvE99E0Y3rAS9CaCUtj7IP00jrMo9WqTgawnbMDtUIV6a
	 QKvrRSfw/nlXxiSRmmUfeeSo7PsNJ9w2VSh0O/1gCf3n4UgGyzuMGjyE4HymxyX5z6
	 CaICUE8prVdbFtHSkFEc9VS8SZ3hkq1s/ytgX6ofv0wxmY99y+3RmeX68OE8ngHkbc
	 162CJe1YLJ63sQNACfJ5C99E/6P9GUigy+AqG1VG5JLp/1FDWqPKrPw7R4yrMoaZ8i
	 O6R6RUhH1pUUg==
Date: Thu, 6 Feb 2025 14:42:49 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
Message-ID: <7bzch3zo3r77grfk4lywxdqkjlzfxaqrapdwcl4xgajnhh7nl6@jlr3eetu7lj7>
References: <cover.1738563890.git.naveen@kernel.org>
 <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>
 <6aa6777f-b7da-415d-b123-d49624008304@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6aa6777f-b7da-415d-b123-d49624008304@amd.com>

Hi Vasant,

On Wed, Feb 05, 2025 at 12:18:29PM +0530, Vasant Hegde wrote:
> Hi Naveen,
> 
> 
> On 2/3/2025 12:07 PM, Naveen N Rao (AMD) wrote:

<snip>

> >  void avic_vm_destroy(struct kvm *kvm)
> >  {
> >  	unsigned long flags;
> > @@ -185,7 +202,8 @@ void avic_vm_destroy(struct kvm *kvm)
> >  	if (kvm_svm->avic_logical_id_table_page)
> >  		__free_page(kvm_svm->avic_logical_id_table_page);
> >  	if (kvm_svm->avic_physical_id_table_page)
> > -		__free_page(kvm_svm->avic_physical_id_table_page);
> > +		__free_pages(kvm_svm->avic_physical_id_table_page,
> > +			     avic_get_physical_id_table_order(kvm));
> 
> Move this hunk to previous patch (1/2) ?
> 
> Rest looks good.

Sure, thanks for the review!


- Naveen


