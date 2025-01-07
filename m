Return-Path: <kvm+bounces-34685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4E1A044DE
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 494CD3A6F54
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F911F37A2;
	Tue,  7 Jan 2025 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AI/zBWu5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87361E25EB
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736264278; cv=none; b=ewoad7IGbzoXX6OXL17V9+VEGRBSK6ZguOMltsssp4ruPrqClS6qnVnjZ4dMALXVDc8EbWu4UTTuKkU23hT4VLoMkWaub7iaklg6/TB2TALhLufKlxX6bt9RfCueAysoWfqIn62Dg2O1jOzosOEToxHwS7yj8YmfCK3RHaAQv00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736264278; c=relaxed/simple;
	bh=LJeOLSx3TO9m513NwbnkeDQ6maYTT/dIQ73DSi02NXg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gHYHJdIOqhLZbL8cmhnD5AhQ3JVqFFeB7zAk0T//YYrpOCGCfDhghAft1/yUeh0fUJyJmxn+xgx9vk7elxx5g6FQfmtsSVbqtF3r4xBLt5paPCCG9mUSCBNhrM+n6i/T7D1Btr2KO4B82OArBEQ2ZtKNqChbB1JMch52uOAWou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AI/zBWu5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso22256435a91.2
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 07:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736264276; x=1736869076; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5em+kVXHMZ6KEpaSnxRKl0QMtZenxzWVITT8lA9geoY=;
        b=AI/zBWu5ICAup7ojDt0frJIQahgPwQm37FYQpu9uaeR86TuD2V8kxNIHbLnyzTGG65
         TJrTIlCijI5nG4YnaL42I0IVcDlfUH6xqv+OfzJ8gW7Otit8xgZlcTCj2evPAMi/ZaaC
         cralCe8SGFSd0v6AOxc6xHnwLDTs0Z5S3PyJWn68/lD/F/HnLGeWaOyNxqEqxvDjJb0+
         9xsMRouuW6J6OGGSK2u1lp5AB28o+f/CZ8ekCwBXukEmSbmVwRPls77KEcvW3+j3Os1I
         Ine+7rfQ8HZZM0743G1sRY0WKOs68AXM50yq8UkOciqUvU5rOqUdEPcEAG4FOBG6sHHh
         nwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736264276; x=1736869076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5em+kVXHMZ6KEpaSnxRKl0QMtZenxzWVITT8lA9geoY=;
        b=Qky00VCa49evYbdzP9SzHWtIM0LA1z6JI0tklTiFEk3hPhxzIj6P8O1pAS7UnH5KD7
         Et4rJOCKpC6curs5zN+1ZjUN4HAiCm6tA7nYwomSXGt+LhqoJhE4RP74+Bm7fW74jnsr
         Re//6vHMjbGD04v8CKvC2Iyw5HlZN1Ff67xSIIdGp6PcN+l5Va9uhkeVo3gr321i2hGp
         Bwo924sHTM5cLIc1Q1CwHvhcg/GTYK9lEJBYN4lDVZBzRl5sxNRxoAa5ckHoCY5XXPkZ
         9jfSEVrBY6yW6c6QHhpY1lODqt1+fuVABAoMuoseSxlVLyu7iR9EgLrxUshVlMwj06VK
         T8AA==
X-Forwarded-Encrypted: i=1; AJvYcCWDrHufoyfcXpwYpCzKlHzLj040teuuHIXxNOCURC1pCmeE4eJ9GdzkCz4i31uxjXXrxWA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg2MYHyFCyrzGwsFzmAXPYP9EF6v1LvSSDmBlzrOhWIQC2nM+W
	IVOwUGW1F5CWF7QBKi3dgsC3L7m6awHQh/cGqr10BWyRQgaxv8/QmIliZ0CPKP27bfc7aGThcYS
	xhA==
X-Google-Smtp-Source: AGHT+IEcGzEx9UodPbhCllVaZK25i6Tbo5ua2Txu4ITHVS9wRNaOSsK0fxtQwdKmWGWPr4qSPnk37CtX2j4=
X-Received: from pfaw12.prod.google.com ([2002:a05:6a00:ab8c:b0:728:e1a0:2e73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:670b:b0:1e0:d32f:24e2
 with SMTP id adf61e73a8af0-1e5e081edf3mr103640840637.38.1736264275581; Tue,
 07 Jan 2025 07:37:55 -0800 (PST)
Date: Tue, 7 Jan 2025 07:37:54 -0800
In-Reply-To: <20250107042202.2554063-4-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-4-suleiman@google.com>
Message-ID: <Z31KUrNvDxqyEBsn@google.com>
Subject: Re: [PATCH v3 3/3] KVM: x86: Document host suspend being included in
 steal time.
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> Steal time now includes the time that the host was suspended.
> 
> Change-Id: Ie1236bc787e0d3bc9aff0d35e6b82b7e5cc8fd91

gerrit.

> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  Documentation/virt/kvm/x86/msr.rst | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
> index 3aecf2a70e7b43..81c17c2200ca2f 100644
> --- a/Documentation/virt/kvm/x86/msr.rst
> +++ b/Documentation/virt/kvm/x86/msr.rst
> @@ -294,8 +294,10 @@ data:
>  
>  	steal:
>  		the amount of time in which this vCPU did not run, in
> -		nanoseconds. Time during which the vcpu is idle, will not be
> -		reported as steal time.
> +		nanoseconds. This includes the time during which the host is
> +		suspended. However, the case where the host suspends during a
> +		VM migration might not be correctly accounted. Time during
> +		which the vcpu is idle, will not be reported as steal time.

This belongs in the previous patch.  All in all, IMO this can all be one single
patch, as I don't see any reason to put crud into common KVM.

>  
>  	preempted:
>  		indicate the vCPU who owns this struct is running or
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

