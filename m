Return-Path: <kvm+bounces-18350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9B68D41A8
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 01:08:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E6261F22EDA
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 23:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E531CB332;
	Wed, 29 May 2024 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xPacc/f/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02BC16E876
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 23:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717024082; cv=none; b=LBtuvjPIdwtN8z8AqgD9Pce7m0TgoB0LzsrkJHkmtwOsYTVduLxp1V5+msXKyLk7a7yZQUHehHSpAKVvvJK8ngVdLRUfaRlAOQBSxs8M29DzvlxbEeQvMdCZa5nJJTummi0WIjgn+e5QOF9OkZAEf6RoIgidhgiDdM1ad6cc6E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717024082; c=relaxed/simple;
	bh=OpPHbam7unYZXqqkfE/FktxoqKH6VNOldq0Y2i/6B78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uSrm540JrhYNVUmY/WYzDjdQ1IFB/AxUSgMLyX8g1CD8Dk5+/1gMKCIbmSZotQ2grb/ReLw1vYc4wRqQjx+OiDZiCTyfrgNFmThwR14O2VUPdcGBM3V461GmypyZXTfHaZ6DxlYC9z66oo3IPTYHc6Qa2mio/x1oYl3flPWcXK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xPacc/f/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2bf5bb2a414so213083a91.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 16:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717024080; x=1717628880; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6gWPVta/qCJJyLq/hJc6KaVJRsxcvZE7MgWw+KyNFoc=;
        b=xPacc/f//f9tkpdyrHqfVR7xJVl7wbXGJFXSOJnwG1XpYDCwtgNTMgL6/f2696LdW5
         t5hmGhdCImuLtnkz4clIiR9JjrWZoL3PDGv9E+CRS4SaubFQj3A9UvQPggv4mn0nEfAQ
         +vqVmTZM+hyG5XCxb6CiKqLAd8g+9zwDdWjY0GeZjaaiRiZzv9SHSCW+RBMzECP3F8K3
         VHGZ0iKWyaah7PpwZP2xwGU+ZBe+PAAyVzdYIfZwf/PLjelXUlIVI6sJjxFpw2dZW0zg
         yJJGh1gy2atrdAoAjbVjodm6frOpzY67wGFv+Q0dBJOowYbDOcwjIw+veFH+ap+f3Gkc
         v6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717024080; x=1717628880;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gWPVta/qCJJyLq/hJc6KaVJRsxcvZE7MgWw+KyNFoc=;
        b=mhJr2LYAo20UVuupkkYNGJDWjjZ+aQ8vvJRMMcN7i5TaEq7mT81rU/o/nQ9lZuOmfi
         oW7J5oEpKxdzoYfEby+9vGGw8sXXf928Py4GtDeUBZ57vgMl+cfeVlrxWDJsWpbpXv8K
         Fqn3g1UPOEr8otRuyVVnUqUCDJ5VUstRJbMWjffUe7VBDwBf7ku3XsfOGrnfGW608vgy
         yKgRnvt2UnWnoDnLzG99fvYjq9zY/ZJQ9tV8rLKXjAVI0fgdOgd/apisIkrr72b07oS6
         nzlyfLTQxy+w5DLjOkbwLcl9/KpkjLCPzG+fiyH7dLIB9WTIn6r+4VQRKtnmOsx4SjNb
         ROTg==
X-Gm-Message-State: AOJu0YyIsBkFCKXt0bf6/WbDsk1yTqYetO9AAmvSF3iZLkdWIq72oIW9
	J+r0fGS4S2wtoiDpPKUEDPJtl9YurutvFdY+IMNAukKYY50uWRf7P9lXWVGXnx2TjOuMqddzRoW
	AFg==
X-Google-Smtp-Source: AGHT+IGchevfh8WkGOCMlZBu0D1kH8hxThW1k7kjpH5AD9E5N22nag/B1pMMOy5N4Qk+BxA1kDgs6Z0fhg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4b0e:b0:2bf:bcde:d204 with SMTP id
 98e67ed59e1d1-2c1ab9e2544mr1547a91.1.1717024079994; Wed, 29 May 2024 16:07:59
 -0700 (PDT)
Date: Wed, 29 May 2024 16:07:58 -0700
In-Reply-To: <291ecb3e791606c3437fc415343eb4a25e531cc3.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522022827.1690416-1-seanjc@google.com> <20240522022827.1690416-4-seanjc@google.com>
 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com> <Zk7Eu0WS0j6/mmZT@chao-email>
 <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com> <Zk/9xMepBqAXEItK@chao-email>
 <e39b652c-ba0e-4c54-971e-8df9a2a5d0be@intel.com> <ZldDUUf_47T7HsAr@google.com>
 <291ecb3e791606c3437fc415343eb4a25e531cc3.camel@intel.com>
Message-ID: <Zle1TrfeJDeXLtLk@google.com>
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 29, 2024, Kai Huang wrote:
> On Wed, 2024-05-29 at 08:01 -0700, Sean Christopherson wrote:
> > Enabling virtualization should be entirely transparent to userspace,
> > at least from a functional perspective; if changing how KVM enables virtualization
> > breaks userspace then we likely have bigger problems.
> 
> I am not sure how should I interpret this?
> 
> "having a module param" doesn't necessarily mean "entirely transparent to
> userspace", right? :-)

Ah, sorry, that was unclear.  By "transparent to userspace" I meant the
functionality of userspace VMMs wouldn't be affected if we add (or delete) a
module param.  E.g. QEMU should work exactly the same regardless of when KVM
enables virtualization.

> > Performance is secondary for me, the primary motivation is simplifying the overall
> > KVM code base.  Yes, we _could_ use on_each_cpu() and enable virtualization
> > on-demand for TDX, but as above, it's extra complexity without any meaningful
> > benefit, at least AFAICT.
> 
> Either way works for me.
> 
> I just think using a module param to resolve some problem while there can
> be solution completely in the kernel seems overkill :-)

The module param doesn't solve the problem, e.g. we could solve this entirely
in-kernel simply by having KVM unconditionally enable virtualization during
initialization.  The module param is mostly there to continue playing nice with
out-of-tree hypervisors, and to a lesser extent to give us a "break in case of
fire" knob.

