Return-Path: <kvm+bounces-39748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E021A49FE0
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28B00176706
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC65F280A5C;
	Fri, 28 Feb 2025 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gXUAJKWi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CBB280A40
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740762470; cv=none; b=XAtXasJQLnmKrEiL5+UwD7gZuVO9o54XqMysH3570PhyXobqeUhFSSyolETs9hf8zJeBRRAXLou8N6tTX9PYM/frOBhl+7x1qn/FNFwazAMBAjeLxRQWqkSNRABQuTMtU8aM6HOS4PFFmgYljduwuAyBM5IuhkXBaUBcUbgHKtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740762470; c=relaxed/simple;
	bh=0NfHbYhPhFL4xmc58hlP/iPcW1AfrhEYdXl85tc/9AQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LIlv/ntums791wjd3ibj/1RQk2EOYJV9g8I3vpd6SHK+Lh8pupjcgewkUxzAki7kZvvD83eiGGbKdKM2bd8ADzLZ0F7fvYiVcin03Wx5Cu2nCuGGphJScaS4uAWP7yMJHAeVzbgGbP/U7Voc7v+8ur0HMoc1/cVClFMAcwFKw3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gXUAJKWi; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fec1f46678so2788583a91.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 09:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740762468; x=1741367268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn9Wd0e1ZZG+jNEhSiMJWTR2pHzJGatUZGEsCpUKJdE=;
        b=gXUAJKWiDUUOyknuLFQi/mUOp1yDUksas1mWHZ6527yXBg8Pt3El2lSuyYVVp2QSkd
         G7jeB1E3vKGFOCpbMFfEq8R5cvs1Re1OozmGCRXO7qKv/o0TnI2YNrF1bWo4/+V7Kkeh
         TT/2nGiMPW7tSSYAGw3fBR3+EoovOSNkeYxuqrLAKMFFGrinXO9LKIeTNqZ4vh8lKmiU
         5y8jN4M9l6b96nNmBfl2Ovps9dv/46f/UFiXZufV2s7f2V4Khp4JtzWO3Q82Q8LVEChj
         +FcjD7Wwucz0wxGbPj/ylgk0CpQk6ZM9OT2MdAoFO0leoRhOmhRcW82tLjHI+HMFEvMI
         /bzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740762468; x=1741367268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn9Wd0e1ZZG+jNEhSiMJWTR2pHzJGatUZGEsCpUKJdE=;
        b=osg2crdot6v1sxuJmT0LHS/iEEc+Hg1SAh7P1wn7uMcNIW644o3Kh5bKMg+tQeVocV
         7/Tp6Fv/sx7d9hrbfJLE98cO2Um0bw1e2bq7cU40SVf7ngd1YjcExo94yEXMdtzpCIic
         q7DcRodtdJfivqG4M1vJkdVSuHYvodd4Bfol0rA2o2ojotNKRwwaYN4y7NRoWQ0mQs16
         L0GrF7xWF+qRugwkBrzrFgUT7xar8U8ZlNaLutJSNsoeoe3O/GixxQQnr42NDOvRtX5g
         /tX/DcIYH7RfdPkGIXHi+gChP/wTYMjT3yddX/X9g6ldhEY1K6n09gb/17M36VH+06SB
         wQfw==
X-Forwarded-Encrypted: i=1; AJvYcCVXbatgEwpCSPF5ExcjXhP1Egt77JWLWdWi4xK0W/O9pIlugO1Thf1cr87W+5ZTI2fd5cE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQMebcJCmH+RDILWaH9VSwfyFAEevGTK1lQpxgVmsXxAtKDqcP
	lQ12T25yloLbavIb+YFRj83XlfqvnSwpQLn6/eKmPrY5TqYWFGa5fa1tdsQz8Sy6cqKReL8gmOa
	OJg==
X-Google-Smtp-Source: AGHT+IHCzzNosE8PrfJpy25JhjQdhCx8jziKT/hMLk27lARvaQgMu3AliD8Y8mk7rBFMgRqebNAAm68vYfQ=
X-Received: from pjbeu14.prod.google.com ([2002:a17:90a:f94e:b0:2fc:2b96:2d4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d47:b0:2f4:432d:250d
 with SMTP id 98e67ed59e1d1-2febab75deemr6114083a91.21.1740762467886; Fri, 28
 Feb 2025 09:07:47 -0800 (PST)
Date: Fri, 28 Feb 2025 09:06:34 -0800
In-Reply-To: <20250124150539.69975-1-fgriffo@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124150539.69975-1-fgriffo@amazon.co.uk>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174049620083.2628640.12510480368568809515.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Update Xen TSC leaves during CPUID emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Fred Griffoul <fgriffo@amazon.co.uk>
Cc: griffoul@gmail.com, vkuznets@redhat.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 24 Jan 2025 15:05:39 +0000, Fred Griffoul wrote:
> The Xen emulation in KVM modifies certain CPUID leaves to expose
> TSC information to the guest.
> 
> Previously, these CPUID leaves were updated whenever guest time changed,
> but this conflicts with KVM_SET_CPUID/KVM_SET_CPUID2 ioctls which reject
> changes to CPUID entries on running vCPUs.
> 
> [...]

Applied to kvm-x86 xen, thanks!

[1/1] KVM: x86: Update Xen TSC leaves during CPUID emulation
      https://github.com/kvm-x86/linux/commit/a2b00f85d783

--
https://github.com/kvm-x86/linux/tree/next

