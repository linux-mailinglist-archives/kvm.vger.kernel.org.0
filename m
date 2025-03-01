Return-Path: <kvm+bounces-39779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68948A4A6D3
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE2017A9326
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FBC8F5B;
	Sat,  1 Mar 2025 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ULRYrN+h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFBA36B
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 00:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740787392; cv=none; b=Hd9AYQiPXJbHa6mvXilkU45nnF52hWJRA1+iNGRLkGZjZtjc2Mhp7CsTEw04+gexeVpPxxUPRRaGuTOu4Sr39tfzMUcAeawRRN7RrpeEdjobVtxbBj7AAide4KEtjFWpWKUvmUNWYWT/ScT8Fys1xGR7IQL0jU63JIwQZ/oLJWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740787392; c=relaxed/simple;
	bh=xNrgVKborPQ4Jg+P6ehVIspOwfeUc+beftNnuNY4vCY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=abmBkruq5EtHyxlh3LsBeB+ibdln7WJEeckGSvj2CGcp7FeqHicqwmCO2XxkQOpNAZuI0yWdEGI+aLwHAarJjWrmgORjZmMOLdRY8W4IsNLm/AlMnWyKwEhV69pzQacE+hDu6qE2UCEPAtQ2ReQsVHWBQ4kazXWpqwDyxPeXmyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ULRYrN+h; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2feda472a6eso173752a91.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 16:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740787390; x=1741392190; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dAmSC5T02PcTsxNjNKU5koqfrVaWqSMeJo5eAXs8QN0=;
        b=ULRYrN+h2mO04qGaF7WFvAXM5Fu+GTXkNCufB50qv/Yf2fW91pASI9GTt4PTuX+XD6
         7mDC8iIhtKtUwkMZOzDDioTWccv1WEg6ZLibhOG/bbdWTWCutN1pY4vb4lyph7cBJkVH
         KraRATg4mRR38pGKJNUXcyuEabm4OE5ZSjezbTmlnqQJ9z0XnDIND44P6gqan/EFCVzK
         QRacMWqMu+Z/I7c6JrSwsIpkMlH0wFScu71irqWlf3QFnL9JzP1eREi0C8gefxeI+Y9D
         ibRQW9oAl1nKR8wrq9NinaOcxWp73nrw0S/yrvMtm+KJD0S1VU71iniY1tKfubgRZ0Lk
         Z2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740787390; x=1741392190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dAmSC5T02PcTsxNjNKU5koqfrVaWqSMeJo5eAXs8QN0=;
        b=Y/e63KBo+Kr33eAG0uHv/XyxthDD16K+1izNWNVVBLk/0OQYeg4keI+j7QZd+wfMCQ
         4ObX8wypa+eEhgQTdER5FS5MG3KSji8Lf0q2CwbA4godPg9FNRwSMfFsPpLrEe4QWQUl
         eSvRlSNovOeMOtKUwNfQcJvIkx56wa8f2v+Iseyl2LeecczYIqG+GLwlq0u/XCgzzyVJ
         2XxFKh5zuqTnnp9WYdlRXOScn8Qt1L2DlfCcFe99coNLl7+zkG9+4kC84kxr/vvrtDqR
         gX4PWvtZBFPJD01PsN0/zonyh9R+iLHUa1e3zSHc7Z3OuI6SRCLdvm2DLdfdXlVtuM0S
         8STA==
X-Forwarded-Encrypted: i=1; AJvYcCUfVydJp2gc49VBOj6KU8Lsy0eEXKSs2uCBeLE9rWptAQm6yD0X1mFg0iCJUvLzzr6R5qM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIkOe0Raq9dWgxU7tCGsAzvPpjsWnT3E/LYQL9a/qj2Fy8n8eq
	aUSA/WPh8UdH960N4qUZAz4rZq1TrJNPtAxGrzNxzFKJZm6lAIGmSqOR37HfyhDDbyE7kFaVMJS
	ysw==
X-Google-Smtp-Source: AGHT+IHGZPMd9GM7Z250yBBG/+OcfufCLuaBQlCFX7fV9dGD0utgxxLHuDNtXqSliyjHipvuZKUjNQWW0Sg=
X-Received: from pjbsi12.prod.google.com ([2002:a17:90b:528c:b0:2fc:1e77:d6b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d40e:b0:2ee:c9b6:c26a
 with SMTP id 98e67ed59e1d1-2febab50df6mr9170769a91.11.1740787390036; Fri, 28
 Feb 2025 16:03:10 -0800 (PST)
Date: Fri, 28 Feb 2025 16:03:08 -0800
In-Reply-To: <20250205182402.2147495-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev> <20250205182402.2147495-2-yosry.ahmed@linux.dev>
Message-ID: <Z8JOvMx6iLexT3pK@google.com>
Subject: Re: [RFC PATCH 01/13] KVM: nSVM: Track the ASID per-VMCB
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

+Jim, for his input on VPIDs.

On Wed, Feb 05, 2025, Yosry Ahmed wrote:
> The ASID is currently tracked per-vCPU, because the same ASID is used by
> L1 and L2. That ASID is flushed on every transition between L1 and L2.
> 
> Track the ASID separately for each VMCB (similar to the
> asid_generation), giving L2 a separate ASID. This is in preparation for
> doing fine-grained TLB flushes on nested transitions instead of
> unconditional full flushes.

After having some time to think about this, rather than track ASIDs per VMCB, I
think we should converge on a single approach for nVMX (VPID) and nSVM (ASID).

Per **VM**, one VPID/ASID for L1, and one VPID/ASID for L2.

For SVM, the dynamic ASID crud is a holdover from KVM's support for CPUs that
don't support FLUSHBYASID, i.e. needed to purge the entire TLB in order to flush
guest mappings.  FLUSHBYASID was added in 2010, and AFAIK has been supported by
all AMD CPUs since.

KVM already mostly keeps the same ASID, except for when a vCPU is migrated, in
which case KVM assigns a new ASID.  I suspect that following VMX's lead and
simply doing a TLB flush in this situation would be an improvement for modern
CPUs, as it would flush the entries that need to be flushed, and not pollute the
TLBs with stale, unused entries.

Using a static per-VM ASID would also allow using broadcast invalidations[*],
would simplify the SVM code base, and I think/hope would allow us to move much
of the TLB flushing logic, e.g. for task migration, to common code.

For VPIDs, maybe it's because it's Friday afternoon, but for the life of me I
can't think of any reason why KVM needs to assign VPIDs per vCPU.  Especially
since KVM is ridiculously conservative and flushes _all_ EPT/VPID contexts when
running a different vCPU on a pCPU (which I suspect we can trim down?).

Am I forgetting something?

[*] https://lore.kernel.org/all/Z8HdBg3wj8M7a4ts@google.com

