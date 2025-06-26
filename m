Return-Path: <kvm+bounces-50850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E01EAEA2EC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC8F55619AE
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 15:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070452ECD18;
	Thu, 26 Jun 2025 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TCUlvzF5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043E2E610B
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750952700; cv=none; b=Kh19VpueCMATqVeP3ly2WgeU1zYBeiVMO2t7UMu0OBP1URcecC5XH+Qm9jJ/AMsWYweacPO4M9CTulygauqVSlyp2SqOHSl77XMVdKF7eQXvnB4lS4l1+y89usH93EfzuteildN88rIZiE4in0aCQ1vgltjJNQJWDDe1wOMmYg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750952700; c=relaxed/simple;
	bh=UPzg+1cFWaa5IEQs97XqQsfv0UsC67UYlsGsjUZbIk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fd92xAmiaI/SauALbNmBF/rjxA8ZQQzoVPrTXIE17N+EayhgrXRPMuBC07zhU8qZT8gcSp+MHOekYT4pVlq9fXw8+wo0sQGLEDJt/JYherlA4Lk6Y8L9rJ3MZtQQ72TR7UgzkquLFtJGLNPBPBzYPoDw1R5mZJlCZqx7W48pGNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TCUlvzF5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748cf01de06so2418750b3a.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 08:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750952698; x=1751557498; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dJ4boTNcjSB3GkKZvOY11od0wh/pgsj65dFh/E1J50o=;
        b=TCUlvzF5YaH7CclCZhhRKMICnHzLRiK6jfTS2LZmtunIDabaUg+ScxVzxmI0aPCNdn
         zCcBD2W7m0uSWqGxWsnqJ8gZxlokUUmR/Rn+3jiHxAVNmoXCihkhei4KQX9eEYzbkVMa
         UXZJZ4dEw8IisHwWSm1ZlFEZPg4aqfmqw1jHXmXN0NXZS6zFAKz8GOrYMxt6mDZT4+ac
         sRh1ZD6Vle3ubcR1Fh7HdcrIm9v0o+ycU0dSi/cDGKuyvmImbLujQbo7YZE/jrAHmKZI
         r/XZzYiBxiXvoGk7bWH6x63ZOu+Rn2wAJborsQ5b0yPdNUB0q5MPu4K7462++FjibDf7
         XV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750952698; x=1751557498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dJ4boTNcjSB3GkKZvOY11od0wh/pgsj65dFh/E1J50o=;
        b=U81qVY0m253jz7bcpjfGcV0LiXpl/NYRf+iDGpsDvb8YvBj8iSxEujm1VKncMZLCly
         nvwHHPwZfObR+jK7dkM8lPNIAmUXgLfLzsj3DxDLqaEKzdceZUkvrl/2Ibg3ylVta+KA
         WB2r+lSO50W+/eG7bH2KS9F0DYfyky0ykih8lugNZuAEWL6oIcwJuFGhBt8zD5lTWD8w
         Zc65lMhXYve+G/i2/gpcGvMHLlmx4Hl4yap1nMwu6g+ROhkht3YTya+zcubgN7pk29Mx
         /0JI4x49JTjhcS81KZuPYUNMeQLnBH8M9h9cTAKLV0yVcEafuuJs3URx5WJbFaSF8enO
         JIVA==
X-Forwarded-Encrypted: i=1; AJvYcCVXzMTIwgdENuAGoZhEr99OCgD5Rf25KQUceqV0UlcF6RpPkRPmkEn7/UteGGyVu6ja3nI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlz+ViALHio3BX2VqnxOjgv8aCD0I1Mf/bjVEKPqOLd+mixAvD
	PbhYKE280LV1oZnNV0IhrmxGnQ4+oaWx2N/Pyvl2jb85PmXxNlq8hygoGcAVe307XVZ7USKnEfA
	9cc4r7g==
X-Google-Smtp-Source: AGHT+IHv9FW8lQLGwlaBHFwpp23GrtZ0oFp1gQDu2z4AW0WZkFqQPeNOaoDhABPtQe6lbaeqNZ0KNtiyS1M=
X-Received: from pfbde3.prod.google.com ([2002:a05:6a00:4683:b0:748:e276:8454])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b54:b0:748:eb38:8830
 with SMTP id d2e1a72fcca58-74ad45900cdmr10200651b3a.13.1750952698238; Thu, 26
 Jun 2025 08:44:58 -0700 (PDT)
Date: Thu, 26 Jun 2025 08:44:56 -0700
In-Reply-To: <aF1ntuyr8gHleCwA@char.us.oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
 <aF1S2EIJWN47zLDG@google.com> <aF1ntuyr8gHleCwA@char.us.oracle.com>
Message-ID: <aF1q-O_1FnNDLzWK@google.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on AMD
From: Sean Christopherson <seanjc@google.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com, 
	x86@kernel.org, boris.ostrovsky@oracle.com, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 26, 2025, Konrad Rzeszutek Wilk wrote:
> On Thu, Jun 26, 2025 at 07:02:00AM -0700, Sean Christopherson wrote:
> > And it's not like KVM is forcing userspace to enumerate support for
> > ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate support.  So
> > while I completely agree KVM's behavior is odd and annoying for userspace to deal
> > with, this is probably something that should be addressed in userspace.
> 
> If you do -cpu host we tack this on all the time.

Yes, I know.

> Or you saying we should have QEMU disable this for AMD CPUs all the time?

Maybe not _all_ the time.  But yes, I'm suggesting that QEMU clear ARCH_CAPABILITIES
when running on AMD.

> Which in effect is the same thing as doing this patch.. but just moving
> it to QEMU, kvm-tool, Google Cloud user-space thingie, AWS cloud thingie.

I don't think kvm-tool supports Windows, and I highly doubt any cloud provider
is doing the equivalent of QEMU's `-cpu host`.  I.e. I suspect QEMU is the only
VMM that's actually affected by this.

> That is a lot more complexity than doing it in the kernel.

I have a hard time believing it'd be more complex.  More code, probably.  But
this isn't all that complex.

