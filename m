Return-Path: <kvm+bounces-19383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C716B904880
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 712221F237AA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EB98820;
	Wed, 12 Jun 2024 01:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CUnoC5Py"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCF94C90
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718156535; cv=none; b=rLXU96OiHtGuxiHomEVr5bHQ4WcuUgAQhW4smDMnbiuP7fvlcsgjWHtpPKUdaMLVY5IJZ6IrtcDwWSbXny2lgnQE6dJ1rtLvm1HzhBjEigOxKfWhxRm3mY2iXqE+Ajn7fRl3EHeMA8N8zs/5515r/WAmuDYMzffmneO+JP4zqvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718156535; c=relaxed/simple;
	bh=xZ7SLDZDURI3AX35VLIjN64dL8veo1J6qAgedm8anvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lYAPIohnzlLvJNIqb7bHEVq1YF7clkfj+CDPRsXIVtp8Abd2NJkZhjs0ZIYUs5bxep4b1Gl19WxAlMmj7wU7o5DviZUHdu0Hi8Zh1Fn2f2+E84ZoJKqG8PVJhEHnFRDE2bcCGgyyV/sbplK+d2JNZjw6/uOuqoUKFnN6LQ0VaZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CUnoC5Py; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-68197de746fso6061068a12.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718156533; x=1718761333; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b2bEF7pu3oPrudxp2KioWHyLS9XD0CdHx5hvKW6tPyc=;
        b=CUnoC5PyBVDM56OyBhQ1ln1HnW8WcVgGFQAxd3KIk+PlfftX0g9M51R7UzRufltzit
         XEh/L5oF6qXS10uZjnxmhJ3Z1wbkTP4QC2wCCpFhHmSMHGjMaY1l8lnTZfn0WbDtAy0L
         cQWYPSc4mufBxh7O/J7js7b0dLRDPQ6pnYBh7Dvuhb24PCSXxEMraSGxEAMyL7Ldwsc/
         rLqKxqOesqsSJq3+GtdUnF9hRiq0yfccZHAOaCR3p3FXr2WWoALBx5kz54PJxuGZtTPv
         y0k6UogXnYe98JhuWkVVf4MHpOK+yWeoDGf1YL80UtNlxtizXI8ODaddmQ2+QmCmqUq5
         0rRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718156533; x=1718761333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b2bEF7pu3oPrudxp2KioWHyLS9XD0CdHx5hvKW6tPyc=;
        b=owwtL0FprNfVWVeukCspDupltUOVMJ2ublkSufDLkj+D7xKfdjQOkQxIK6frRnHVln
         gEzkKtgkvBWtfnwWtZ7gc5VN+UtiVHhiZ8dN+RZupawYT3QG1KVX7mxgmqOURVdrTdz5
         9NgeiRV29ZmpXCnd/4PtZQlOAWMvpoRhqoQq2TH2oLIL5JUPK2CHGzSauD1Ac5RSHs56
         P6K8X+BQyzXXhESSW9rSpNEbYTZ9KQj3bS5MbkJtrnZrH9umTWf6ZFMlTi/J/PPUXNdt
         hqV+4ppfzlD+03CWPBfvsIMOZuLBGPd1lNczTotvRcpZbym68ZaOeXV7E95FQYy7F7KR
         W2dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWempLvgu/QjAsfPBLB6IZtAzhOJHTkmDayLnQqBSEI4Bq4MsJp+L9zAnUVMeE49oL0tj8vYcoxc//w6Yl0tlhRsOeo
X-Gm-Message-State: AOJu0YzI5f7vV1MIDc51TgHVB0RmB411FKaTA1v6YNy4YC5vT3fN8SIy
	Q8Wu9ZTtEir3FDfqmCODZ5MhSrIReLfzzFfkfqxyZ1OKfWmh/AajjF3YgBdVK1l6YXjaaCC8xKf
	NwQ==
X-Google-Smtp-Source: AGHT+IGrMo3Tfw6/ctuyzLHcS7QrH+t2EMuBXOBamTEujfHIJiD3vMOeJHFhc8mmJ5+J4GStgILYEvM0NjQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4c4f:0:b0:673:9f86:3f2f with SMTP id
 41be03b00d2f7-6fae6d65861mr937a12.9.1718156532733; Tue, 11 Jun 2024 18:42:12
 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:42:11 -0700
In-Reply-To: <59381f4f-94de-4933-9dbd-f0fbdc5d5e4a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240429060643.211-1-ravi.bangoria@amd.com> <20240429060643.211-4-ravi.bangoria@amd.com>
 <Zl5jqwWO4FyawPHG@google.com> <e1c29dd4-2eb9-44fe-abf2-f5ca0e84e2a6@amd.com>
 <ZmB_hl7coZ_8KA8Q@google.com> <59381f4f-94de-4933-9dbd-f0fbdc5d5e4a@amd.com>
Message-ID: <Zmj88z40oVlqKh7r@google.com>
Subject: Re: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org, 
	james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com, 
	j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com, 
	michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 05, 2024, Ravi Bangoria wrote:
> On 6/5/2024 8:38 PM, Sean Christopherson wrote:
> > Some of the problems on Intel were due to the awful FMS-based feature detection,
> > but those weren't the only hiccups.  E.g. IIRC, we never sorted out what should
> > happen if both the host and guest want bus-lock #DBs.
> 
> I've to check about vcpu->guest_debug part, but keeping that aside, host and
> guest can use Bus Lock Detect in parallel because, DEBUG_CTL MSR and DR6
> register are save/restored in VMCB, hardware cause a VMEXIT_EXCEPTION_1 for
> guest #DB(when intercepted) and hardware raises #DB on host when it's for the
> host.

I'm talking about the case where the host wants to do something in response to
bus locks that occurred in the guest.  E.g. if the host is taking punitive action,
say by stalling the vCPU, then the guest kernel could bypass that behavior by
enabling bus lock detect itself.

Maybe it's moot point in practice, since it sounds like Bus Lock Threshold will
be available at the same time.

Ugh, and if we wanted to let the host handle guest-induced #DBs, we'd need code
to keep Bus Lock Detect enabled in the guest since it resides in DEBUG_CTL.  Bah.

So I guess if the vcpu->guest_debug part is fairly straightforward, it probably
makes to virtualize Bus Lock Detect because the only reason not to virtualize it
would actually require more work/code in KVM.

I'd still love to see Bus Lock Threshold support sooner than later though :-)

