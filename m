Return-Path: <kvm+bounces-42071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 187A3A71F93
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20B18177B25
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71522255E32;
	Wed, 26 Mar 2025 19:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZGczyL1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5731917F9
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018537; cv=none; b=c4VMu5d8hF9WJ1quN+hVrdo0w0qknIrke0DvU0W54bNp3XKS4411UO4/c7Fw3b7PQdQC3zmxykbY6PWHMBpyGhpbxixsSF7M0fOaX5N3AlROe4+5NHNBz/Z0qrYGxflf1t8z3WF31cTwCCRIiTzrQ4ZLpMJ8wRo6KyGA3agJnDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018537; c=relaxed/simple;
	bh=3dz7TALKYsubRBUYr/bSgmmrsdzj1opX4UARJMrIvow=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=teUwNPbKq5AnWUfaYVfticNx5aBO66wq4rd7w2pu+9FkEd1WAFTohNRO0OYbWRVWFYsglgUcbd6Z7WvbrGel4egjfM1pa8AatyNSyoQDM35Ew2g7cjMDFJohuXxDTFqHqj+fKySiFR7pif5P6xoBC6tuM+o7uHyGmzemSV+hGC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OZGczyL1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224347aef79so6184265ad.2
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 12:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743018535; x=1743623335; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mr/ftcHWfkXSh0K4oLo0YgEeRzBHbBXHE5/0Xa1PdAE=;
        b=OZGczyL18dlZWw2Yt1POXdYn+L+xGIHwbydMQHpjY1bn4EIuQryB3nm2dO7kR51w4d
         h8hIMffuIW8/Uz0FQwjISfKAjKRfCMa3Vyvrekb8P6Op2t400LtDT4/PLBqAJ0YibmBk
         RwkxGbUC7JtUJckzqmobCRP+0lBlv3jdLExu5m2R9Q4ejQmVOVivLXvhWqmlR9MxywiE
         ttb38ZLaPZrT4ZhPYYsK+cTKXYgSVJXXnqnph7BrUkBzRxAMNongYxAY0KwzThCCGoIG
         rrnzweeB9ADo2S98tXW8kIF8Us5cCKgQGHYTh6amepEeJiQT2EyszoZmIwr+QxnJ8lGa
         z11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743018535; x=1743623335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mr/ftcHWfkXSh0K4oLo0YgEeRzBHbBXHE5/0Xa1PdAE=;
        b=iBUpEUjqlLlx7iASUKUXNdwgUZwsUVrwaTnugYKE14gn6UYjRT3aaGVrvDTKAHXdAT
         gRERGxe8WGpGtlkEYca0lRsAN1oZYbHHS4U2tyuphk8K/yBTaOArgsDQfyrI2Pq2OyiP
         PlymWwsFpCeUWpljIf4CVCF6DKSWJSuqH7sO//YObdPoCxnAFQ7upi6bz720IKufXzSt
         KGKAkD0CRT7kI3smDdp6zyQcmd1g5M/+wzuEL7fLV0mCWzUIFtK5NSo8r7kU1h8dzNPn
         l18+vahnphAQoW5phbcUsdl/4rmgRurNMlBNLOxAHpTKNaPpqEilUDrRmumk31lQIpxN
         IowA==
X-Forwarded-Encrypted: i=1; AJvYcCUbDUVpKSHoT6oxaKBKkSxXcmfj+WGDGEHcSiN2pBZ9TDvPZyK/f0HNBBJdbCDMIqDytcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNzjgmGxeLazofLI9Mdn06SMwdEgRq/qEhlRO3joj88aB7vd8q
	wjSddsgHMr04pSxatAnJnPCJEjk3P6dXtpkgdfEVn49AIt7V6odZA2KMHfLk/jcMXOax80y5wzE
	/3w==
X-Google-Smtp-Source: AGHT+IHVbE7MyotFOK0/MO8xvhQBRUILzC5BoDATUc8bzSwlPsvPrDtsqOB2AH9g+FdXyS0xyy5A+Jx8Uww=
X-Received: from pfbch4.prod.google.com ([2002:a05:6a00:2884:b0:736:3d80:706e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e2a:b0:736:3c2b:c38e
 with SMTP id d2e1a72fcca58-73961037e5amr990961b3a.13.1743018535394; Wed, 26
 Mar 2025 12:48:55 -0700 (PDT)
Date: Wed, 26 Mar 2025 12:48:53 -0700
In-Reply-To: <Z9NMxr0Ri7VUlJzM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev> <Z9NMxr0Ri7VUlJzM@google.com>
Message-ID: <Z-RaJVo1MKuI90G0@google.com>
Subject: Re: [PATCH 0/3] Unify IBRS virtualization
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	David Kaplan <David.Kaplan@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Yosry Ahmed wrote:
> On Fri, Feb 21, 2025 at 04:33:49PM +0000, Yosry Ahmed wrote:
> > To properly virtualize IBRS on Intel, an IBPB is executed on emulated
> > VM-exits to provide separate predictor modes for L1 and L2.
> > 
> > Similar handling is theoretically needed for AMD, unless IbrsSameMode is
> > enumerated by the CPU (which should be the case for most/all CPUs
> > anyway). For correctness and clarity, this series generalizes the
> > handling to apply for both Intel and AMD as needed.
> > 
> > I am not sure if this series would land through the kvm-x86 tree or the
> > tip/x86 tree.
> 
> Sean, any thoughts about this (or general feedback about this series)?

No feedback, I just you and Jim to get mitigation stuff right far more than I
trust myself :-)

I'm planning on grabbing this for 6.16.

