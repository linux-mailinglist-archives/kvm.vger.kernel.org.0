Return-Path: <kvm+bounces-37966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BBAA327F4
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 15:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42361648EC
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 14:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349A120E6F3;
	Wed, 12 Feb 2025 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WF1fgspW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CF720E6F9
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 14:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739369088; cv=none; b=CHZdzTaHYAJpq4wjXfoOst8q8U4iIetlOetscx90ccnBfi9RA+/qnlYrT6/2DohjwhGTFKirnbUBUUS4OEBW2QnfD0+bcnkTIQn1oK+wpH4sAotKYC4Dp9Vnw+6h/KyUaMJU01lg4iLgSojDJZT5NOtRUX5Tw7Tcgb0oOMp1xx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739369088; c=relaxed/simple;
	bh=1xcQIacpc8dhmBgvyBRXjuSUlGaUQmUJ7GDeS/cN3tY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J93e74liS4jM2/mZmE4FUvp9UiSRuv9f2wueOKjzpcpsS3XbhxPqssfMwhWcmUusvzjKQs/HmsEhXHThlVxs8N4MpZX1ERQin1YhXyze3fOpL3QqcV5g1Vv0lOeUXNjOqoKeHiavgBD5MIV7m9bgn61VquwxRzIu1Nrg19M86xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WF1fgspW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa57c42965so8637179a91.1
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 06:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739369086; x=1739973886; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fBPn4+roevj+TUDjbscDOGumF8HQGlMx0VxpqyCPs6U=;
        b=WF1fgspWLmJT8SYAc7e/Kf2UwV8KxxZJl34q2Do+kZF9Q0isr+MFzvXL9ZSeVZSvQm
         wwZKSfgJnQDTC71/HPeDBwVxooz8JuLq929nlU0I/M9etv2PpxWOQWHpGOeEOPkbveer
         uVziigKxkInOA6AIHYdFGEdi0GpfivZ/81qvqLEWtpo8CSSMZYuqwhqYwNNZHoiq0MID
         3QYBNEp4nynhXw06MJ8J/vDVcLnMN0k/llBY9WPpLP4SMaeCr/tO+Mt3uskPcz8oZujD
         kEkJBaCswu/vAudlHsXntZ7TvRbWwPUHirGcEnpTpPzcot2ZbMRpSdogbDgDNgdEQwIY
         z+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739369086; x=1739973886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fBPn4+roevj+TUDjbscDOGumF8HQGlMx0VxpqyCPs6U=;
        b=fBr9SLAwAu5Byj9BUf3BuVHclkXtIP6noyJacUMMKPG3sM2tv9IxZvl8gDtQq9UwPe
         4PQ1vHx3RVuUBgEdA8d2LmaxUAkL7ox2QpADp48LGk/bbTR3rUJ4RJVdWJc625qiK9lC
         4tiHJRaxI+KeE7LXEyYczSRwj8ASuy/9/34gdgBOTEplpHimuyXfcbCmHNJMl6irHv/g
         nY0hztVkiHnYUAGkLHO83xz03X0mMZr1hV2MtbTtbdVTPd2mapZT9YhOAUFuQDYAskGe
         eTha1NBtzQxQvIQZJVMc/LXhC604up7E2vjRODBtYMRmwWuvCQ9/qur8HuCINyKxe45F
         cufg==
X-Forwarded-Encrypted: i=1; AJvYcCWuJF264IiWqQtooHNW4dGtH+5PY2noZObNUInYwZqnurQw8RlrHT3WQgB5tPX5LF5CCIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwtiuhS5sCsyPdPh3mgFwL3tZFWDE//ZJFw1nXOHEq6yJD0fYd
	iQxtelWe+6I0SVK4n4bO+Ulod//Sq4UVdYzPEDzrbkDJn3kafgcSEFLbebrcBJv5w/e3ILIvBnY
	o6g==
X-Google-Smtp-Source: AGHT+IHN0TOoYC3DOzPYwF1ZZmZcfPmKRJGI57tCdR6icMedHpSD1MnoidP9HLm3wpE+THtLCdalf4f5a78=
X-Received: from pfmu14.prod.google.com ([2002:aa7:838e:0:b0:730:9617:a4c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:81:b0:1ee:6032:b1ed
 with SMTP id adf61e73a8af0-1ee6032b931mr2819105637.17.1739369086038; Wed, 12
 Feb 2025 06:04:46 -0800 (PST)
Date: Wed, 12 Feb 2025 06:04:40 -0800
In-Reply-To: <858qqbtv6m.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250210092230.151034-1-nikunj@amd.com> <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com> <Z6vRHK72H66v7TRq@google.com> <858qqbtv6m.fsf@amd.com>
Message-ID: <Z6yqeEQeLoTQx_QD@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com, bp@alien8.de, ketanch@iitk.ac.in, 
	isaku.yamahata@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 12, 2025, Nikunj A Dadhania wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Feb 10, 2025, Tom Lendacky wrote:
> >> On 2/10/25 03:22, Nikunj A Dadhania wrote:
> >> > Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
> >> > writes are not expected. Log the error and return #GP to the guest.
> >> 
> >> Re-word this to make it a bit clearer about why this is needed. It is
> >> expected that the guest won't write to MSR_IA32_TSC or, if it does, it
> >> will ignore any writes to it and not exit to the HV. So this is catching
> >> the case where that behavior is not occurring.
> >
> > Unless it's architectural impossible for KVM to modify MSR_IA32_TSC, I don't see
> > any reason for KVM to care.  If the guest wants to modify TSC, that's the guest's
> > prerogative.
> >
> > If KVM _can't_ honor the write, then that's something else entirely, and the
> > changelog should pretty much write itself.
> 
> How about the below changelog:
> 
>     KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled
> 
>     Secure TSC enabled SNP guests should not write to the TSC MSR. Any such

This is a host write, not a guest write.  What guest's "should" or should not do
is irrelevant.

>     writes should be identified and ignored by the guest kernel in the #VC

Again, I don't care what the guest does.  Talking about #VC just adds noise.
E.g. if the guest requests WRMSR emulation without ever doing WRMSR, there will
be no #VC.

>     handler. As a safety measure, detect and disallow writes to MSR_IA32_TSC by

No, KVM is not the trusted monitor.  "safety measure" makes it sound like KVM is
protecting the guest from a malicious VMM.  That is not KVM's responsibility.

>     Secure TSC enabled guests, as these writes are not expected to reach the
>     hypervisor. Log the error and return #GP to the guest.

Again, none of this ever says what actually happens if KVM tries to emulate a
write to MSR_IA32_TSC.  Based on what the APM says, the TSC fields in the control
area are ignored.  _That's_ what's relevant.

  The TSC value is first scaled with the GUEST_TSC_SCALE value from the VMSA and
  then is added to the VMSA GUEST_TSC_OFFSET value. The P0 frequency, TSC_RATIO
  (C001_0104h) and TSC_OFFSET (VMCB offset 50h) values are not used in the calculation.

