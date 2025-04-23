Return-Path: <kvm+bounces-43935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D78FEA98B55
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80FE517F195
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B5F1A4E70;
	Wed, 23 Apr 2025 13:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nT0JZxbk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16DA61FFE
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 13:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745415435; cv=none; b=EVzTteY5exM4pkUBElWx28fUrqgqMr2Wz26Mb5SqCbYD+t/HbsAtq4LFcx1aO/PucGtXGNASx3fgbp3LRrh8wgYLkGUEpGd2qF/2qHcavMSEM1zQdm3RAlP2DTVKnCmsTmZ/g5daIA3wuKPWbG6UjCQ1xGwlVJ9wtb7tZTWzURo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745415435; c=relaxed/simple;
	bh=dXr0vdvJSE4CQmBa2fTuILJV/L6G5HpSxSHQ49PKVqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PXpLq4EDHWqhEvcevBKFVRuTvClHoAcav68EWGHLWbcMb4f0t/qc6qXBl748FD4Lhuu08ZyHwmNPengRBJQPyq9I6yMjSOnZxl5JOBSZI7SHCRszKVIwY/ofAfLphETfZgxcg2FwdxkAzSESYE+KZhQjCOaKQJeauy4cwALIIcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nT0JZxbk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3055f2e1486so9192645a91.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 06:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745415433; x=1746020233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QTV99TNe8c9V+BGz9HYw0E5RTZLdGwFx/9m2XgmuzHE=;
        b=nT0JZxbkLOWuAaq4nDpqtJy0UU3fVSwyW/pnNNBGYtoYR/+veEUbsw1SW7uJkXUY9+
         O8RFZ5mI3iZ/bhFeyS6mpQMMAXezkdZIzt5lXK/oKDFsuDimPPcn2I6rOaU8XnWilwy4
         Qflh7jQ/97QLXGCjRrnvUz0MJpppmkyoylDcvcx1GHi73/C77pzsSBWavAJzDCuOl8Vu
         Bx69HB/Nd+cusCL5TPzdZ2tLrS0aQKRNqjrAQAhL7fNktV8FmsgyGiJ37d7CE0puVmjy
         sSKyhx/48E0CSccNslHjG8NDhKl65lvTaigTuvvrWJaiU24iVs3SZBs7noSsvJEIf+mE
         70Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745415433; x=1746020233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QTV99TNe8c9V+BGz9HYw0E5RTZLdGwFx/9m2XgmuzHE=;
        b=pwm+YDA3AdAq/8oA5aTZH6sTIv+mPPZYJSTrhwysaxPzUOmF0XmLJu4TsIpeyczV3g
         WZgmJmoz9oJ+dJmW60q6HbiqzY8151nJi1sT1kmklZZqQxTf+dtMcLkdN9BrAYk8/Nna
         hOXwwJhhhE2/lKUlH7be9RKHx+hb2MmTCCYJGPuiIHbNL08eCxkr5VazLqpsBRQelmzd
         dY5j616/F6rS+xIzQMglXlOlBd2kTNnaX3JfT1C+kY0cZnlslNPX6GHA6BuC/8ROPdLw
         jz1owcUEiUQeNEw1B5ZQrX4aBQHtAbgppWv6UvXG4MNHlv4ZZSVN1gEkoaU520+pNakP
         qqNA==
X-Forwarded-Encrypted: i=1; AJvYcCWfQnpvzkXaeKil3hI/FVHk5eQoZxiiEg1mtIJ6hVKWzV0h+COELrRcRR2Tlh6qn6ZHHcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD0JHIEmpLN+pnTg6XyISfNSIkro34tMuJR2M4wYh79l7HCpuZ
	Kq25hnels4bFZr/kz/FOH2ZV4QZbEyYwrPL0e8HEmH606HUD/N2l2FimJCh/LUDc3o/FPKFCtMt
	mxA==
X-Google-Smtp-Source: AGHT+IEWS42km52dkYFlmcKZWmN1wttg5SPG3JN+o4kIB9LzXEDLrbHh1gdrPp7a64YZSw75FwPTF5N3xvo=
X-Received: from pjur12.prod.google.com ([2002:a17:90a:d40c:b0:308:867e:1ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2650:b0:2ee:9b2c:3253
 with SMTP id 98e67ed59e1d1-3087bbc9333mr25668631a91.30.1745415432973; Wed, 23
 Apr 2025 06:37:12 -0700 (PDT)
Date: Wed, 23 Apr 2025 06:37:11 -0700
In-Reply-To: <7527f09c-7163-4276-b9a4-edac6c8217ae@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422082216.1954310-1-xin@zytor.com> <20250422082216.1954310-11-xin@zytor.com>
 <aAexLqjhKncFyw2V@google.com> <7527f09c-7163-4276-b9a4-edac6c8217ae@zytor.com>
Message-ID: <aAjtBxzvRgNt4Uzr@google.com>
Subject: Re: [RFC PATCH v2 10/34] x86/msr: Convert __rdmsr() uses to
 native_rdmsrq() uses
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-pm@vger.kernel.org, 
	linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org, 
	jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org, 
	namhyung@kernel.org, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, wei.liu@kernel.org, ajay.kaher@broadcom.com, 
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com, 
	pbonzini@redhat.com, vkuznets@redhat.com, luto@kernel.org, 
	boris.ostrovsky@oracle.com, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 23, 2025, Xin Li wrote:
> On 4/22/2025 8:09 AM, Sean Christopherson wrote:
> > I strongly prefer that we find a way to not require such verbose APIs, especially
> > if KVM ends up using native variants throughout.  Xen PV is supposed to be the
> > odd one out, yet native code is what suffers.  Blech.
> 
> Will try to figure out how to name the APIs.
> 
> One reason I chose verbose names is that short names are in use and
> renaming needs to touch a lot of files (and not fun at all).

Yeah, I've looked at modifying rdmsrl() to "return" a value more than once, and
ran away screaming every time.

But since you're already doing a pile of renames, IMO this is the perfect time to
do an aggressive cleanup.

