Return-Path: <kvm+bounces-17475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36D948C6F16
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDAD21F230EF
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4924F5F9;
	Wed, 15 May 2024 23:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tO8Vnxz0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AEB3C48E
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 23:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715815206; cv=none; b=NhQ4UgspMP0COwxz9lAoIikD1J8g5BmhwkmwZwSwxH1OpRPQ1gEs0IhlHQ9qejx+OPKgaw66kftJh9ACzbHCCsC2nQPZh/sJtaUhE1LQDVlnkw/K278luWI1bMdFVehLmpKTv4IsUUciD8ng8acxCLjKsJm/gAbMnvLmLeaMgI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715815206; c=relaxed/simple;
	bh=uq5jbcln+jzH/PLpZe9wXnSOTlm0FyFFVFCwKP91LGM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AP5iHa861vCcdbrFwEK9CnDC8CrgRFeoF8GdN6bFq9y54s7eJvUcX3KpX9v96eJoshPh3VFQWoznAHoV11BM0BihODX2Hi7w0ffIWY6tkekzR0+hRgEbMdyRi0u1GJBejnbelYPsmmHsOPcMghyDtwO4mfJ4odB7ZC+KkjlS01c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tO8Vnxz0; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61beaa137acso122679407b3.1
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 16:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715815204; x=1716420004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6YDxr3hZHHTclQ7zyLq/DlJKdNF735yaym0zXBzZRNw=;
        b=tO8Vnxz0RfBY/mNvbNtPWd4K2gSh2CgO+SRNJGPZr4rR88zouqmbr1b0UGPz999XK5
         d3xC4dMuhLcq02EWdOqAruF8Wmn/U4RJneLIY7tIuEK1rjKJWHFRck622i57C4qwFKTH
         i7xZokKgUN4cl8M+c7Dn9D7TECcH/NUQeiEMw4taLS/zXULc8spiuKW4xzNURG+FQ729
         +ir12zF7ohScN2dCHTKlQqcbb1jj9RgQuV7bTtUZ5E4+ibt33qaN/VHZSv3w6ohp24hU
         iv4SxAdGRgxCYDqQmpWKakN/qwGdi7NJHNIU89YB+mx3wUss7Fcz7Cbh0Mh/TUrkIPV/
         pisQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715815204; x=1716420004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6YDxr3hZHHTclQ7zyLq/DlJKdNF735yaym0zXBzZRNw=;
        b=EHO+OjaRFCm7BpSMtA1ai/JJcIVvgS9DVhkcuHVQjYNXL3ZnHJd7ixr6VXpMYmKT+t
         sryh4nbnS2IBwDPOwDNmb3MLJtEk6KKZqgdHhQCGmcWE+W0k8+VwXpRJdQeAdrfUh7YX
         I68koKfPqXgc4aXLSamMdU39jWPwf316dVyjfLyci5XFuapZOnM0NT+Wn6nAj7u6WNM4
         bSMTOpZiG838iV472hWPwR8gpHT452+zyaWN3zp9lsXzMnwvFmXFYM+sBZLxQ9j4rUDm
         xegqBnWNKNQaUefVQZptECVzh+OJoiRBMkR/ATpVegpP+hh2772IwDlpa/aOJOIN0Rjj
         vb2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtxQ3/A9gxbOp8KLHDFp1wWu9cfDgEmrUPeTgbnMpEI/lpFEhy5zbYulkaYkvMhKNase/oA2HirhfoZUBdNgvdw9FY
X-Gm-Message-State: AOJu0YzPtWFRaahHv8pSPQkZUiWBaRl1WgG/LJByz7fsNUAfwBcyYXkZ
	FfhrRFh0q7AHSzTYcr9bMltK3OrjffE5FDu1dmMUZhuIOl7oYVxpm5b97Q/CoV6HYERiVbb8lvZ
	Zzg==
X-Google-Smtp-Source: AGHT+IGiMIigOSDrrlOBnbxaKLq8/8hmGFpm1Scz2UDZMrMDNsO773Ch249W9pUKNNAsjSgFGmuSjLu7ZmU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6d97:0:b0:627:3c45:4a90 with SMTP id
 00721157ae682-6273c454b1emr4527527b3.4.1715815203978; Wed, 15 May 2024
 16:20:03 -0700 (PDT)
Date: Wed, 15 May 2024 16:20:02 -0700
In-Reply-To: <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-3-rick.p.edgecombe@intel.com> <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
 <ZkUIMKxhhYbrvS8I@google.com> <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
 <ZkUVcjYhgVpVcGAV@google.com> <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
 <ZkU7dl3BDXpwYwza@google.com> <175989e7-2275-4775-9ad8-65c4134184dd@intel.com>
Message-ID: <ZkVDIkgj3lWKymfR@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 16, 2024, Kai Huang wrote:
> > > You had said up the thread, why not opt all non-normal VMs into the new
> > > behavior. It will work great for TDX. But why do SEV and others want this
> > > automatically?
> > 
> > Because I want flexibility in KVM, i.e. I want to take the opportunity to try and
> > break away from KVM's godawful ABI.  It might be a pipe dream, as keying off the
> > VM type obviously has similar risks to giving userspace a memslot flag.  The one
> > sliver of hope is that the VM types really are quite new (though less so for SEV
> > and SEV-ES), whereas a memslot flag would be easily applied to existing VMs.
> 
> Btw, does the "zap-leaf-only" approach always have better performance,
> assuming we have to hold MMU write lock for that?

I highly doubt it, especially given how much the TDP MMU can now do with mmu_lock
held for read.

> Consider a huge memslot being deleted/moved.
> 
> If we can always have a better performance for "zap-leaf-only", then instead
> of letting userspace to opt-in this feature, we perhaps can do the opposite:
> 
> We always do the "zap-leaf-only" in KVM, but add a quirk for the VMs that
> userspace know can have such bug and apply this quirk.

Hmm, a quirk isn't a bad idea.  It suffers the same problems as a memslot flag,
i.e. who knows when it's safe to disable the quirk, but I would hope userspace
would be much, much cautious about disabling a quirk that comes with a massive
disclaimer.

Though I suspect Paolo will shoot this down too ;-)

> But again, I think it's just too overkill for TDX.  We can just set the
> ZAP_LEAF_ONLY flag for the slot when it is created in KVM.

Ya, I'm convinced that adding uAPI is overkill at this point.

