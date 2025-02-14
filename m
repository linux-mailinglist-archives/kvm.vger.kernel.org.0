Return-Path: <kvm+bounces-38105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8A9A35347
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 01:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E0E73AACDE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 00:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DB0BA38;
	Fri, 14 Feb 2025 00:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VUcLJaBr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E94D2753FD
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 00:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739494517; cv=none; b=PYxS9HKn/aqexLXtAXgkN38OZY9tBDETlU86O9ctcZ/+jBxff77IpgVFzRFWZwz/VpDzYDrSlCJ6sRdh5m6IFCLZR/UoN6nGzTzZa6ufN/ypJChsnrxFUX3I8d4aujUiZlpxNxG/cSrkECqzcDT0Nn0yI9l9g4Qp7ktQwnAzdXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739494517; c=relaxed/simple;
	bh=lxFU+hslZonmlrLI705j1CO2zCxhvUZf4doHiGkZBqQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QHjFI5mekjlLfwi/KbnojCQJIrnIyXrpL1NhZwQWjkjNiq4/rL514ojpS3AE/ShZC+ppfZL7mj4H/YBuNIMl9JmJ0zuz1MXMTCyGjx3AcG5vbpBHd04BD8bGQfiLYdJVvmQfmei621UGDdjfrJTroC41Dq1PMyr1S2PdGLARXwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VUcLJaBr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05b36so5054155a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 16:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739494515; x=1740099315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vGzMcm2EJx62xp3i+ETr3ep/fnfxZsEgR2IjUXZxvfM=;
        b=VUcLJaBrPeEPlR2j+x2KeSWaqUPOAp38PSt5mSgGU9YjDy61XC94g12IocqmZEJtDg
         X/3t2eTGhJ4yDr47FFPHQ4pdlOJSIHPHfzQdEUB6AmVQDjuoDHizoj0iGU1PpO7Wmc2b
         K/nJ4LueORt2N+1/Xh0b+Zk05Kcw8cm5ugJxGOuegpCDQcFlvyY7vEw55HMpaFQwhLEQ
         fWRvmMH0tstuAttViao3qNA/2lkVnknvX3zqZPajbLvqgHhmN0foTqyEtK2KP65pyrYP
         hFf3m6O23D2AK1B7WcMOwLjruwcbbcfXdcs9lsCoaKiB+djN0+BO3I6hAdErprgl9miA
         FWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739494515; x=1740099315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGzMcm2EJx62xp3i+ETr3ep/fnfxZsEgR2IjUXZxvfM=;
        b=rrty+bQDboIvJkv/kkRzCD55h5yzDqZFz4HQDAQ1DNjl/bLCc7xrl+V825Jzk/ay1v
         EKql/0ikxErJBSP0eFSGHFsQySmIAkB8rrxD4KA5f3zYCIwS6HknDNbEhMZ4kAxcSm6H
         +77mpxv9ux3lZPdSmPI4EsGyihbRFtz2/vMAaf7BvSjmr2+lBEfIuxISIcpZuuv6poxG
         CXAekcYTC/xTodrXjnzGyy9BeHzpPxFUeladEZc/Zq/xcJ6xw7s3REn35+9xfj/lyrRH
         4EgRRNwdXATnof8pydQEjLr58+m05o/3iziv5lvAp9pRXUIbb/EEiMFd8Sc82moTk21e
         Lkfw==
X-Forwarded-Encrypted: i=1; AJvYcCXR8nay7sNo+duPpQSM5X3DXBIoEVYkkA8cbUjRdaUchFj44TEgXX3+/ImUvn83wgR6xcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrBsiw5lidNkkIula89ifZxsQWnXowR6O+clOcWMKgZI94kupJ
	UaqhVwgfHCp+9iwEfIK4a+a3Pyo5bzQZ8BlA7ldRy4NqJu7MXzki8m6wR7MBaEk9/E4lk5d3EA4
	IlA==
X-Google-Smtp-Source: AGHT+IG5ngeMiNOMVZUFHXMBuyybKCp3WjbtkfdfiVwv29ZoD5+1hFfkQhTBVR4sfR9gbDecEXlqXPEFSd8=
X-Received: from pji8.prod.google.com ([2002:a17:90b:3fc8:b0:2fa:1b0c:4150])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540c:b0:2f9:c56b:6ec8
 with SMTP id 98e67ed59e1d1-2fbf5be6b9amr15999928a91.10.1739494515423; Thu, 13
 Feb 2025 16:55:15 -0800 (PST)
Date: Thu, 13 Feb 2025 16:55:13 -0800
In-Reply-To: <6829cf75-5bf3-4a89-afbe-cfd489b2b24b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250207233410.130813-1-kim.phillips@amd.com> <20250207233410.130813-3-kim.phillips@amd.com>
 <4eb24414-4483-3291-894a-f5a58465a80d@amd.com> <Z6vFSTkGkOCy03jN@google.com> <6829cf75-5bf3-4a89-afbe-cfd489b2b24b@amd.com>
Message-ID: <Z66UcY8otZosvnxY@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field
From: Sean Christopherson <seanjc@google.com>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	"Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Kishon Vijay Abraham I <kvijayab@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 13, 2025, Kim Phillips wrote:
> On 2/11/25 3:46 PM, Sean Christopherson wrote:
> > On Mon, Feb 10, 2025, Tom Lendacky wrote:
> > > On 2/7/25 17:34, Kim Phillips wrote:
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index a2a794c32050..a9e16792cac0 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -894,9 +894,19 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
> > > >   	return 0;
> > > >   }
> > > > +static u64 allowed_sev_features(struct kvm_sev_info *sev)
> > > > +{
> > > > +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES) &&
> > > 
> > > Not sure if the cpu_feature_enabled() check is necessary, as init should
> > > have failed if SVM_SEV_FEAT_ALLOWED_SEV_FEATURES wasn't set in
> > > sev_supported_vmsa_features.
> > 
> > Two things missing from this series:
> > 
> >   1: KVM enforcement.  No way is KVM going to rely on userspace to opt-in to
> >      preventing the guest from enabling features.
> >   2: Backwards compatilibity if KVM unconditionally enforces ALLOWED_SEV_FEATURES.
> >      Although maybe there's nothing to do here?  I vaguely recall all of the gated
> >      features being unsupported, or something...
> 
> This contradicts your review comment from the previous version of the series [1].

First off, my comment was anything but decisive.  I don't see how anyone can read
this and come away thinking "this is exactly what Sean wants".

  This may need additional uAPI so that userspace can opt-in.  Dunno.  I hope guests
  aren't abusing features, but IIUC, flipping this on has the potential to break
  existing VMs, correct?

Second, there's a clear question there that went unanswered.  Respond to questions
and elaborate as needed until we're all on the same page.  Don't just send patches.

Third, letting userspace opt-in to something doesn't necessarily mean giving
userspace full control.  Which is the entire reason I asked the question about
whether or not this can break userspace.  E.g. we can likely get away with only
making select features opt-in, and enforcing everything else by default.

I don't think RESTRICTED_INJECTION or ALTERNATE_INJECTION can work without KVM
cooperation, so enforcing those shouldn't break anything.

It's still not clear to me that we don't have a bug with DEBUG_SWAP.  AIUI,
DEBUG_SWAP is allowed by default.  I.e. if ALLOWED_FEATURES is unsupported, then
the guest can use DEBUG_SWAP via SVM_VMGEXIT_AP_CREATE without KVM's knowledge.

So _maybe_ we have to let userspace opt-in to enforcing DEBUG_SWAP, but I suspect
we can get away with fully enabling ALLOWED_FEATURES without userspace's blessing.

> If KVM enforces ALLOWED_SEV_FEATURES, it can break existing VMs, thus
> the explicit userspace allowed-sev-features=on opt-in [2].
> 
> Thanks,
> 
> Kim
> 
> [1] https://lore.kernel.org/kvm/ZsfKYHFkWA-Rh23C@google.com/
> [2] https://lore.kernel.org/kvm/20250207233327.130770-1-kim.phillips@amd.com/

