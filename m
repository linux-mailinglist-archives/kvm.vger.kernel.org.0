Return-Path: <kvm+bounces-34639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 319A4A03125
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23DF9160DCF
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1691DFDB8;
	Mon,  6 Jan 2025 20:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j0UDrOtG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4F51DE3A6
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736194094; cv=none; b=BK5SsrNWd0f0awz+sy+CZVRD4irbbUpFTCKIgZGRalIt1+whE5AAJ59ApJqRQ1xcHv2uowjDUG/DKP+ULPkKu8Uxph4XZwzTbzH4bOsb+n+g5sFpXNL2g3M734c0Jz/jGvj1Qh3odYYEoiu4pYg2BIE+NYgWbfmnx8yD7XPxU8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736194094; c=relaxed/simple;
	bh=OA/+3tJhYR96YRIWHxSUeUB5CngnxBYfW58gDOzHXb0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g5eOdgw/zgv6cXYZlZPlAslMxDWfDVFB1fiZSnad7205nY7s2R8ckM9NTcYxFenypEWZUrPnR6rpNxqkRwIINeFiep8kTZJ3TICWpWe/5wZfFA0leEpBtnT+CpWAB4MUMngfinIlNF5T7dbX61HZ2FL0zM0IR7KBM2t590r1WCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j0UDrOtG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so34009865a91.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736194092; x=1736798892; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TLbgTd+h2JiSDQGecQW9CCBpocirSI2s8BD8y8xDL5c=;
        b=j0UDrOtG/766mhrUxiF0hz25adcLdoYze9gX4m0a4rihQjwBJg0cVUviS3syfiMyLY
         /yYBLeJfwfgtgE3Ov3uFM01R2B+tbctJIntBnSqJsfHK/RG/thf7RRRGdnjoaVdafqc2
         1BAaZzD6LYhbxNVD8gqMHwVEEfhyO5ow6di6GU6M9kxrwnkthzwkpeZpRnAFGHiJFJAp
         qB1LoYkQOyJ9LqO9eiLQxWYr6SugOUhZf/pkERyw6TWsDSIQd/DJ4WPql17WdE4XCLPU
         nu31uJYpZ3y+OtGlfs6XwD25TZFJcLvRtFhmLwv3x+WQzU3lIuh/Hotrf3fpa2kaPFUI
         SPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736194092; x=1736798892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TLbgTd+h2JiSDQGecQW9CCBpocirSI2s8BD8y8xDL5c=;
        b=SK6t+ZfH3PAOkEKzsyVM6OC7jiJ7p2j7HEEJATwj7QIITfE47d2bcuz7og369m3w6C
         7S8mGJzBhfLeg9/IY0/hVN3i3Dqn7NclKnyo/8SCY1wTC4r0HCDfPIRZKr2rqboBSGUR
         sumlxKIhYkZKbdrV+SLP9Gc8rgOwv0XEBYqu4UUJKcAffIeOp6NZg6b+qkc+WPy1zBze
         jYVp8rLdhy6ksZUckArsD701a3ri9slknNSZp+BD7gBK/rzE8NXGXmk7oFNHqCG7H5fI
         qnsQVvseB5IAIMTZXqJDA5NndKlsbIuHYmuKckcglvlqqQHn6rdKq6QdpPVWLuwMXxhD
         x4rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUshuK8FduTlxqW4ayjqD8h52reebpm9oH0CSql2SqP3iWS4HoRg6CR3Zx8hZx7rrZzNhI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjcxl0cfEb8myGZcBKCqfYK9W9V1kasdaRJGt/V9s7VY7iuYaw
	m+uukn8qLNmoRM1WLfJhnub+Vc5ufBBMQJWrFGo6o8Umrag1bMgwKmP1wcIGLKM6M0OPHasCl8n
	H/Q==
X-Google-Smtp-Source: AGHT+IGbFVQs/Sd9sklpYuIoetXApWNhnudivPMR7uaqWcOQX8Ycdhn149dl8PIqozQ+o7bgS/vzPp82PmE=
X-Received: from pjur12.prod.google.com ([2002:a17:90a:d40c:b0:2f2:e8f5:d7e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:50c3:b0:2f2:a664:df20
 with SMTP id 98e67ed59e1d1-2f452def241mr89315531a91.7.1736194092136; Mon, 06
 Jan 2025 12:08:12 -0800 (PST)
Date: Mon, 6 Jan 2025 12:08:10 -0800
In-Reply-To: <af89758d-d029-419e-bcb5-713b2460163d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com> <af89758d-d029-419e-bcb5-713b2460163d@intel.com>
Message-ID: <Z3w4Ku4Jq0CrtXne@google.com>
Subject: Re: [PATCH 00/16] KVM: TDX: TDX interrupts
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, tony.lindgren@linux.intel.com, 
	isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 06, 2025, Xiaoyao Li wrote:
> On 12/9/2024 9:07 AM, Binbin Wu wrote:
> > Hi,
> > 
> > This patch series introduces the support of interrupt handling for TDX
> > guests, including virtual interrupt injection and VM-Exits caused by
> > vectored events.
> > 
> 
> (I'm not sure if it is the correct place to raise the discussion on
> KVM_SET_LAPIC and KVM_SET_LAPIC for TDX. But it seems the most related
> series)
> 
> Should KVM reject KVM_GET_LAPIC and KVM_SET_LAPIC for TDX?

Yes, IIRC that was what Paolo suggested in one of the many PUCK calls.  Until
KVM supports intra-host migration for TDX guests, getting and setting APIC state
is nonsensical.

