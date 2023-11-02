Return-Path: <kvm+bounces-451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5BB7DFABC
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 20:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7996AB21349
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAAA21363;
	Thu,  2 Nov 2023 19:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2ortX52v"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D850200D4
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 19:15:23 +0000 (UTC)
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A634136
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 12:15:19 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b2f2b9a176so825754b6e.0
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 12:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698952518; x=1699557318; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zQjgybZFTlPKj/UiWrViWEzaYunnF8hFWA7g6W/61+Q=;
        b=2ortX52vhDNAVQ9jhgxCiK39xtE9lFce7sH7s2rAtLd/HZeRI69KXgzFN5VU3ey2tm
         zpmXdZyzs5b1oRwe/U1jhAEFZh6ZxAXqky558ePgPm+cZtSAc4/AdTU+iMjCIw6iRYx8
         nyx+CWz0zkWRrLR0Hq6qJf64QV8sT/WxRVbvn0Vd/irBBFi8rysm53ckJqUcAfTJYeLa
         x23BmiCrYD5uq492QVUCFKw+2ya7AGsvCagflU8wQ+d7NfMi9EoR8eykeccFa4uF+Wu5
         Su8hgXxUaVVfe16uMVw1WNK/Y5AG1Sxz66AaCCx8mWAUqu6ypjdBusYDCshqk8WFOaTO
         OlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698952518; x=1699557318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zQjgybZFTlPKj/UiWrViWEzaYunnF8hFWA7g6W/61+Q=;
        b=vrYRYVL5ivha/alSPsuDm5ZqxpBTL+MZaI7RxA9UvzebHqglt6N/A8OL2L/qq7C4jS
         SYsM9XyzF4wuRcVMgo0petHUd67KQdDcfYObcFYILwCSmAmthtSTB0khCKAb/5svqAfC
         xNGYIgSnuup+enhRRJSONZ77lVEWEVYGptRAtLoPhQX7mNERg7ayhjVRZw7b5GF8iuOK
         +IzpG5c9j/972fUCVVIHfJYFWBKzHqfO4HEsKW1fDngvWDDHyJ4fvGa28Za980BgC00D
         A70SkUl3ZF6kU6mWRh0BOcDI0c994bpMiDLbwo5r9IRYYL8fOeTJKdmlOJAm5JWjGRDw
         oleQ==
X-Gm-Message-State: AOJu0YwBmJalMIWrbbXGwj0QXmMBHTq9qSHeiXFAzojhPVAzYyOfBzAB
	nMZTBsr2W2d2hSTmU9xAp3so5QnWpDQeYLfieRH6NQ==
X-Google-Smtp-Source: AGHT+IGdp46tnQ41glidviv3jlI3EmK1KPcYKTU7WJay+sA87MaG0B2sVQ3c1NQw2onVdre5QSNu/aGCQozfSBDS8iE=
X-Received: by 2002:a05:6808:f15:b0:3a3:b39d:a8bf with SMTP id
 m21-20020a0568080f1500b003a3b39da8bfmr23023527oiw.45.1698952518287; Thu, 02
 Nov 2023 12:15:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
In-Reply-To: <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 2 Nov 2023 12:14:42 -0700
Message-ID: <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

I'm going to squash this into patch 9: the fact that it's separated is
a holdover from when the memslot flag check lived in arch-specific
code.

Proposed commit message for the squashed commit

> KVM: Add KVM_CAP_EXIT_ON_MISSING which forbids page faults in stage-2 fault handlers

> Faulting in pages via the stage-2 fault handlers can be undesirable in
> the context of userfaultfd-based postcopy: contention for userfaultfd's
> internal wait queues can cause significant slowness when delivering
> faults to userspace. A performant alternative is to allow the stage-2
> fault handlers to, where they would currently page-fault on the
> userspace mappings, exit from KVM_RUN and deliver relevant information
> to userspace via KVM_CAP_MEMORY_FAULT_INFO. This approach avoids
> contention-related issues.

> Add, and mostly implement, a capability through which userspace can
> indicate to KVM (through the new KVM_MEM_EXIT_ON_MISSING memslot flag)
> that it should not fault in pages from the stage-2 fault handlers.

> The basic implementation strategy is to check the memslot flag from
> within __gfn_to_pfn_memslot() and override the "atomic" parameter
> accordingly. Some callers (such as kvm_vcpu_map()) must be able to opt
> out of this behavior, and do so by passing the new can_exit_on_missing
> parameter as false.

> No functional change intended: nothing sets KVM_MEM_EXIT_ON_MISSING.

One comment/question though- as I have the (sqaushed) patches/new
commit message written, I think it could mislead readers into thinking
that callers that pass can_exit_on_missing=false to
__gfn_to_pfn_memslot() *must* do so. But at least some of these cases,
such as the ones in the powerpc mmu, I think we're just punting on.

I see a few options here

1. Make all callers pass can_exit_on_missing=false, and leave the
=true update to the x86/arm64 specific "enable/annotate
KVM_EXIT_ON_MISSING" commits [my preference]

2. Make the powerpc callers pass can_exit_on_missing=true as well,
even though we're not adding KVM_CAP_EXIT_ON_MISSING for them

3. Add a disclaimer in the commit message that some cases where
can_exit_on_missing=false could become =true in the future

4. Things are fine as-is and I'm making a mountain out of a molehill

Any thoughts?

