Return-Path: <kvm+bounces-39487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE84A471C6
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70D0C16040A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE8A13E02A;
	Thu, 27 Feb 2025 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WcP/g6h/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7D2270037
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740621265; cv=none; b=prwACMhX+mqU5+I92qdLkq91BdnJVewn+CE+Os3HRCm24n2rdVeEftJ79qqPRpaTYp6Yqy4GFwtbLao1BHj2GEmwR7ZEJOj2gUNdV8gmUeO6cNb+Jcx4/QJsuklNfUhrvflsCsyRjruL8gARkwYAd32Vej+VmiRZEgPPJgd9ga4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740621265; c=relaxed/simple;
	bh=BUX4aPOvtEa1+6oCrTSXTpfOjw/MuX+wsTkMmn6zUAg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nHM6MnXrOudnNopLvN1QWFrU+GbRXAMsBt/+o7AZFgrPeIVze2ybbt4CzxWyz3Xj7PzTpGOw85ExOkWfVl0KkcSXclHqdKSOlWMZ+rquYzrUemNsuWYDvpOScJqDDBR7leKElgnDBgZuCC/Se3VZ3s8Hk7BfnbT2D2zzP95G5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WcP/g6h/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740621260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ou+95ZKQM5HeiQtErwcnpxUHmSwBFhNR4ZItLSh1obw=;
	b=WcP/g6h/9y2S2Zy/T0o9q4cXKbfGtAVVaUwig/1Ja6OZjMxw3KBG+J7VX+OX/UIqBIehQS
	qYmGBL8pjhp6yaYlZSxe2eKHYxGrA9nzcYxO8eWtUQL9G38DgzWTZ7A6f3dq3rdvx+bM6u
	ZH/TyT0VmOpRkMeUWCVy5Kh/IYTwynI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-4QvfEgddNtegMhi0m6yijA-1; Wed, 26 Feb 2025 20:54:19 -0500
X-MC-Unique: 4QvfEgddNtegMhi0m6yijA-1
X-Mimecast-MFC-AGG-ID: 4QvfEgddNtegMhi0m6yijA_1740621258
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6e677b8a17fso8395236d6.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:54:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740621258; x=1741226058;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ou+95ZKQM5HeiQtErwcnpxUHmSwBFhNR4ZItLSh1obw=;
        b=jj5++4JCNcKZkQJAYdbcdPo8Em+2aHpcK9W7AxELku3hjApGr8mlxudNwbS+zU0jKs
         fNUuPRosKoWTRqidpirFPq7p21h8dPk4G9Pt5dGo5F4ND3+K0F1Jj9a+3GoHCa1st56h
         yqODosoOMLRdcflvnt5rliSxJ+0pkCuaTj5mHEm1bwWt/xDhH0YBVhnRpHHf4Z1BCent
         2g1t+5B4myo3hjjWDmmDb6G+d/nFd1lRl5rjVW6Ky3LjDeDg+Hd2KawZnY4RqrxKgvqb
         rclbYBG6WSkpjBrDkT7/G5AQFQyjNCCJPWZIVLkHzRQZgw4FIh2tVwOaYrvuNznmkL1T
         NZVw==
X-Forwarded-Encrypted: i=1; AJvYcCXV8IoFMpfyQQCzzvl/FyIvEFd/+gFVne8grf/AigsX28D8xi+/NlLZFADLClM7tqy6Tog=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy4qpCNhUcR/4jG/KT9sYhcalfUyYPkv7oUEzMVbnejYcGdP1n
	N5cEd4sWfZvi09TJsT+hoCFGeEdJ8pAQuRPKAIvzke17rgokZvC6KqnTSpAcAX7M2w+8pSbgcy5
	kbddBtoOrmeBRGrfx45tBtIkiKxFTY2Dh+Avk8EZZo1BxEzIPJQ==
X-Gm-Gg: ASbGnctZxXukC+chNaW4ekvIltnpERJQGzPU2MVIr6Ft7vZFdDFfJ2jMI71DpFS1VV6
	L9kk9gRbFFLIhoIpnp3M9eEGaMk/HWvnlU7hfhXrCQLq52yZbEHzB2eDOlaexYXx1mU5F5sqfEA
	vbeSSpHDTc+4OCTPZDeNTd8bzgCJkN3e1S/kInX30yqulkvgbOfyhXIa/duebUQXsHPBklW4/Hz
	Bl0eKJ9n/Bi+V3l7w8EPJEZrzLYjvsDfR3VhVELA0i8+7DpFuTGLitiIme73i89FE6mrf1HY6gd
	kSqDYr7ihZ57EXk=
X-Received: by 2002:ad4:5bcf:0:b0:6cb:d1ae:27a6 with SMTP id 6a1803df08f44-6e6b010e18bmr279715416d6.24.1740621258372;
        Wed, 26 Feb 2025 17:54:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBqZ/D95K1s9QpCXseRrPcX1BdgmuGX/rQVnBiRdXhBp6GsljdcZd9Jzp4AScOPLQ7SlfGGQ==
X-Received: by 2002:ad4:5bcf:0:b0:6cb:d1ae:27a6 with SMTP id 6a1803df08f44-6e6b010e18bmr279715256d6.24.1740621258073;
        Wed, 26 Feb 2025 17:54:18 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47472409b32sm4405971cf.61.2025.02.26.17.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 17:54:17 -0800 (PST)
Message-ID: <8d4ef8fdf192bba60c7c31f22925270d62c87c54.camel@redhat.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  David Matlack <dmatlack@google.com>, David Rientjes
 <rientjes@google.com>, Marc Zyngier <maz@kernel.org>,  Oliver Upton
 <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao
 <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2025 20:54:16 -0500
In-Reply-To: <Z7-3K-CXnoqHhmgC@google.com>
References: <20250204004038.1680123-1-jthoughton@google.com>
	 <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
	 <Z7UwI-9zqnhpmg30@google.com>
	 <07788b85473e24627131ffe1a8d1d01856dd9cb5.camel@redhat.com>
	 <Z75lcJOEFfBMATAf@google.com>
	 <4c605b4e395a3538d9a2790918b78f4834912d72.camel@redhat.com>
	 <Z7-3K-CXnoqHhmgC@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-26 at 16:51 -0800, Sean Christopherson wrote:
> On Wed, Feb 26, 2025, Maxim Levitsky wrote:
> > On Tue, 2025-02-25 at 16:50 -0800, Sean Christopherson wrote:
> > > On Tue, Feb 25, 2025, Maxim Levitsky wrote:
> > > What if we make the assertion user controllable?  I.e. let the user opt-out (or
> > > off-by-default and opt-in) via command line?  We did something similar for the
> > > rseq test, because the test would run far fewer iterations than expected if the
> > > vCPU task was migrated to CPU(s) in deep sleep states.
> > > 
> > > 	TEST_ASSERT(skip_sanity_check || i > (NR_TASK_MIGRATIONS / 2),
> > > 		    "Only performed %d KVM_RUNs, task stalled too much?\n\n"
> > > 		    "  Try disabling deep sleep states to reduce CPU wakeup latency,\n"
> > > 		    "  e.g. via cpuidle.off=1 or setting /dev/cpu_dma_latency to '0',\n"
> > > 		    "  or run with -u to disable this sanity check.", i);
> > > 
> > > This is quite similar, because as you say, it's impractical for the test to account
> > > for every possible environmental quirk.
> > 
> > No objections in principle, especially if sanity check is skipped by default, 
> > although this does sort of defeats the purpose of the check. 
> > I guess that the check might still be used for developers.
> 
> A middle ground would be to enable the check by default if NUMA balancing is off.
> We can always revisit the default setting if it turns out there are other problematic
> "features".

That works for me.
I can send a patch for this then.

> 
> > > > > Aha!  I wonder if in the failing case, the vCPU gets migrated to a pCPU on a
> > > > > different node, and that causes NUMA balancing to go crazy and zap pretty much
> > > > > all of guest memory.  If that's what's happening, then a better solution for the
> > > > > NUMA balancing issue would be to affine the vCPU to a single NUMA node (or hard
> > > > > pin it to a single pCPU?).
> > > > 
> > > > Nope. I pinned main thread to  CPU 0 and VM thread to  CPU 1 and the problem
> > > > persists.  On 6.13, the only way to make the test consistently work is to
> > > > disable NUMA balancing.
> > > 
> > > Well that's odd.  While I'm quite curious as to what's happening,
> 
> Gah, chatting about this offline jogged my memory.  NUMA balancing doesn't zap
> (mark PROT_NONE/PROT_NUMA) PTEs for paging the kernel thinks are being accessed
> remotely, it zaps PTEs to see if they're are being accessed remotely.  So yeah,
> whenever NUMA balancing kicks in, the guest will see a large amount of its memory
> get re-faulted.
> 
> Which is why it's such a terribly feature to pair with KVM, at least as-is.  NUMA
> balancing is predicated on inducing and resolving the #PF being relatively cheap,
> but that doesn't hold true for secondary MMUs due to the coarse nature of mmu_notifiers.
> 

I also think so, not to mention that VM exits aren't that cheap either, and the general
direction is to avoid them as much as possible, and here this feature pretty much
yanks the memory out of the guest every two seconds or so, causing lots of VM exits.

Best regards,
	Maxim Levitsky


