Return-Path: <kvm+bounces-39726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0100A49B39
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 15:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94CD03AD4BE
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 14:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D5426E166;
	Fri, 28 Feb 2025 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eh9vXQjt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393F518872D
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 14:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740751455; cv=none; b=D+nL4Vo0SyIQw2HxxJl3AiCTpTPFKBTvFwnVMgUPr41d4MnddEx8b7LFaMUiltVbSae0th1utM7ZRq5X5rnPws/RWU3hWq52KbnGmwChnqs6edPnmVSYo45CPzn227D+1IATELezQIUnHtFzVkh667eACUeos9u8niX7RX7iJJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740751455; c=relaxed/simple;
	bh=4Zkhi/3vKA6AEhdPvUdhJ3xbuKEvtPx76JsO2SWk8Ic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j3GOv53xkVqDoEolmMqp9vNZOYmWtzsJ5iSUizicLt1vEbrMIr8Oeg4leMxWVy7t8Y4qz/JNLuyN9ARe8RxsdvS0plCsEDx3yEK0YF/waFr2Ms206WGOy1MncHDi6MkkANGAjzScjbM+Fa/+f8pnY4PqGJR2lrRTGUk+1m6Y3do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eh9vXQjt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1eadf5a8so4622216a91.3
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 06:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740751453; x=1741356253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j5r7TF3J4CQJcHdUT68P2kvwC87iUS7j4hBRA43VtK0=;
        b=eh9vXQjtQIYtnvCNCnaIzC25LdbnlephFAMQkIz0Z9aJvRuncwvsULZjj56/ErW3CS
         BVtzQEYmz7iOrr/GbosVm0SE1uhqsCSbZir3gMZ5AMGfTGvJpHgMm5fwq5wdr9B+XTEA
         D/aeUz5u0q9LCkvCwqJ8lw0yfVSf2/G64MvApiiw+3WscIhkxFw4buJ2EWYCv/qRcK4b
         Muc4DOAn+cSrqv0lE9NI/KDlvy7L+HePrPEKLf6MmSoBeJbO8CKg0bY9QtatN1Tu+WbQ
         /1z6PZGVWsBvUHXK1FNVuCADEcWtGmQPoh+rsPEaUfF9tBkwUu8kVzvLk9hzzcsaDrg/
         AQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740751453; x=1741356253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5r7TF3J4CQJcHdUT68P2kvwC87iUS7j4hBRA43VtK0=;
        b=TQs7EhJi/SmitLFF8AbWBAUBfQSt04uB5TFGDK0sQIEkRTCQiovzwU7FInoz8ZCBI4
         avWwO/vk+34UQVNhgQDRp1JWxGXz4PhYThkDqHjSnhGxnjgkf0+/juKjBw0IunSPgoW3
         XTCzHCtWf2+3dS2VKwMTyKjpOf+rd4T9R/tRMd+byTG/T3TNcufHW0R2od94oNAUbLVS
         Wv3jAXIcSGoTEO9MQ0Ngsfj6vLv9rFt4ksZeulFdflo5ARzRvmwnmHO0RBXWfPvRFW1m
         m8tsWrvCogcdO+eRtjOs858yya4340cvtTEcOFcOgHzZrbLzQ0SRURLtVM/03IYIegyG
         Nk/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVqhA1c/VbRWsp4V7WGL624tGdHgqSOLV2kFOnHFbOq3LlxUDRPdhGkXXp3Zi86qOB1QRU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8YoFx/nJdnbxwQ4RrOICARpqm57EZ3U2M7DxD+CC0LMTAHNK4
	nG/Pbqim08kmd8vehYBz3e7fNg67bcT8gMuKz+rnjJ8Lq5evtcUxQdSAZE+fyf9HjL9G2WMx9sj
	i+A==
X-Google-Smtp-Source: AGHT+IERc5Pv7+4vnoDGWvifxkMQiAEGd9EDuqaHFnE+42Ho1Qy7JMZwWwtUBI6rQGIzKNL4E69Gflsjx/E=
X-Received: from pjbsn4.prod.google.com ([2002:a17:90b:2e84:b0:2fc:13d6:b4cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c08:b0:2ee:b2fe:eeeb
 with SMTP id 98e67ed59e1d1-2febac04c12mr4780225a91.22.1740751453510; Fri, 28
 Feb 2025 06:04:13 -0800 (PST)
Date: Fri, 28 Feb 2025 06:04:12 -0800
In-Reply-To: <653c3c6e-bdfc-4604-bda0-3b67970a0c62@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227222411.3490595-1-seanjc@google.com> <653c3c6e-bdfc-4604-bda0-3b67970a0c62@amd.com>
Message-ID: <Z8HCXP0hFYs0dUxM@google.com>
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, whanos@sergal.fun
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 28, 2025, Ravi Bangoria wrote:
> On 28-Feb-25 3:54 AM, Sean Christopherson wrote:
> > Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> > DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> > context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> > just supported, but fully enabled).
> > 
> > The bug has gone unnoticed because until recently, the only bits that
> > KVM would leave set were things like BTF, which are guest visible but
> > won't cause functional problems unless guest software is being especially
> > particular about #DBs.
> > 
> > The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> > as the resulting #DBs due to split-lock accesses in guest userspace (lol
> > Steam) get reflected into the guest by KVM.
> > 
> > Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
> > likely the behavior that SVM guests have gotten the vast, vast majority of
> > the time, and given that it's the behavior on Intel, it's (hopefully) a safe
> > option for a fix, e.g. versus trying to add proper BTF virtualization on the
> > fly.
> > 
> > v3:
> >  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
> >  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
> >    it's guaranteed to be '0' in this scenario). [Ravi]
> > 
> > v2:
> >  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
> >  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
> >    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
> >  - Collect a review. [Xiaoyao]
> >  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
> > 
> > v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com
> 
> For the series,
> 
> Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>

Thank you for all your help, much appreciated!

