Return-Path: <kvm+bounces-32862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4EB9E0F89
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80932B21D5D
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 00:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA6F1370;
	Tue,  3 Dec 2024 00:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NLlrZs1H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F299CA2D
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 00:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733184886; cv=none; b=Y9mCrBhVvA1hEnLu5HZyDDo2CV77vRSsH4CuHCZjkKypTMS+y4HP+Ww1gtVB3RyjnaRYA3wkDbAHIWEYlSopCOD7t1xUVrpkzLqprrhphvw9J+/uuFXvQGDsdPogAsgJR8t4L2kEiCv7c9hMqFuYX9dylDeliRJ/7k1Q+9vLlmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733184886; c=relaxed/simple;
	bh=MHJjeZa/reEVzgbcKX2JOJvOOjtlk9wAJDBjubCoJxM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eHEJ3cl0jCawVvfE7YUVRT/Qx011D7el856rSOO1u/bSYzJmwCNUb+BDfgKijWEeSN9df3VELDSPsgssVXjfrXwmBcXpqLmwxaneruVICZLkXBuFFBfWa8Wx+lCk2/qZgLAoFKiMreozIN/TjdBP7BdljHJA3kyczv7RX7eDwSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NLlrZs1H; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2eeeb5b7022so945149a91.0
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 16:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733184884; x=1733789684; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vHmbDNthMFLWB5i9RKAwYv3EBfwAod31XjZ5W9vetUE=;
        b=NLlrZs1HW6ViweR1JJqfw5FupGNZgaoVrAvHzV1H1c4n3cje5koG4vOzQ1F3iYj2ZW
         o+N2n6MJJb2wEeI6qZudy74ui/Yu4gE6kx13n+xPvs+C/d25Jg50JL7q9c0OA4nRB4bF
         GQr5ElBoxvql7zfoyyLpB0BCBZpNqNAeixlSAwG+8AEMB+PaVExrbKHGC5XARDYB8sl7
         ajU4UMf2PJ1Dv/kQsEQn+BhrUwAcHllodCKVYN9mcKE2Uakk763z+dGDrrPGSpZn/yRv
         K5JcBz7mvCVRqxvIgdtcDN0s4KGOTxWD0aLbsy6GXq7WOqxdqQSX3jjxH3xoSNYQWebe
         us/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733184884; x=1733789684;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHmbDNthMFLWB5i9RKAwYv3EBfwAod31XjZ5W9vetUE=;
        b=AolnmCR++0Vn3MwaTGq+Zaas0YjUojdhX8YhJickJ0h41Z7k8rxuy+2iC9N+0DxO1n
         iIbai7jYFTixqqydKVcAUKPQkly+moBc+c6kyxZM0yGwzOYerz+AfMJgghzFnr1V9NuS
         rPcdLFpThhKRrka0ZNnUaNY9DC2MbRPuGHuIdfSaC+20leY7AMThduyE510+Hc1bKvKt
         EI27AnkzcwzKyCEraCi95+r4NkLQTZ0uZW6P6NFg8y1B6b0/1KbOjw4r88pLYeDxJTBw
         0FgKdARxy4PEVtOIotjqiKagE2CqLOiCpZsyN06uEEREbs6J14CIWVt2+5P8hJbxvM6D
         NF1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXVylQT+WEQZg9SRK4xUxdQ3Y9FVZhb49pruWD44Dj5DOgAlBUD7rCYEOn+4rdCh+lWgZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBttusUWnFjIjsuOZcS0YQG+SovxI+8vueuRJ2RnGV47wp0eN
	46tomUZN6QUChrvpxIWnH0QsW1gq291gJk/A4rhIQELi4PNxgcSh24ulYR1BavJL8A0vZreLw9D
	Nhw==
X-Google-Smtp-Source: AGHT+IHnBi8JiasKd6b9FR3Eah0ap7D3VLh2iriUG48oInOKWNVAMYuz8N+zAnjehBKrmxwSwb36IkikFng=
X-Received: from pjf5.prod.google.com ([2002:a17:90b:3f05:b0:2ea:7fd8:9dca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a85:b0:2ee:e961:303d
 with SMTP id 98e67ed59e1d1-2ef01275c7dmr796832a91.35.1733184884307; Mon, 02
 Dec 2024 16:14:44 -0800 (PST)
Date: Mon, 2 Dec 2024 16:14:42 -0800
In-Reply-To: <0a8cda3e-8185-0620-32f7-0696a31f4877@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com> <20241128004344.4072099-6-seanjc@google.com>
 <6f4aabdb-5971-1d07-c581-0cd9471eff88@amd.com> <0a8cda3e-8185-0620-32f7-0696a31f4877@amd.com>
Message-ID: <Z05NcpNLCgnL61jH@google.com>
Subject: Re: [PATCH v4 5/6] KVM: x86: Always complete hypercall via function callback
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Binbin Wu <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 02, 2024, Tom Lendacky wrote:
> On 12/2/24 14:57, Tom Lendacky wrote:
> > On 11/27/24 18:43, Sean Christopherson wrote:
> 
> >> @@ -10071,13 +10072,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> >>  	}
> >>  
> >>  out:
> >> -	return ret;
> >> +	vcpu->run->hypercall.ret = ret;
> >> +	complete_hypercall(vcpu);
> >> +	return 1;
> > 
> > Should this do return complete_hypercall(vcpu) so that you get the
> > return code from kvm_skip_emulated_instruction()?
> 
> Bah, ignore...  already commented on by Xiaoyao.

Reviewers: 2, Sean: 0

:-)

