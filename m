Return-Path: <kvm+bounces-52331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3FCB04028
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 15:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A09103B9085
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 13:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56952571D4;
	Mon, 14 Jul 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yMgQNFoT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE0B25228F
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752499929; cv=none; b=Ijl9Xv9sd2gqYYcGAdNJondD9oZOvt0xRLiNWlpdpMTh4HW+XRZrcdWRFN3BA7lhucd/DI4HCUh1IvKw2HQMrB+QcXuT/9hs2jFHBZpOJposC+UBFJQ1vxib8ZapPHHDsR5CqANkHGs2D2eMoty/ts6cq2gS9fMDA6XZtEUpL58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752499929; c=relaxed/simple;
	bh=pzY1zzP5XZiseR6QvyPRUFl4wC4guT21TFCzuh0WteQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Suhm+uK8F/KCy4Fpuu5wnfv/9h5bRWjDDIDi8Jvg2F6JqGfdNtg9K3sfa7oZ0olhE+kkW6yR9op4Gp9y63IgtVtZ9bsrIbNBJq8vVKOqvdTVM3Rk/ipD+oxE4bwDHXfb+FlAoPsA2Vw+5i6ViMOfNFQzuU72kY5m6CpPft+mxDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yMgQNFoT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e1d66fa6so39796035ad.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 06:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752499927; x=1753104727; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oUNzcQ1xlAA6C+zv++Z/UrxHElTSq2AcaBcHlPI4ybs=;
        b=yMgQNFoT7czQB8N2PDVivvIQuIojbYXw/VxNiS9NDI+ww4a1HQum98kFGDoe80AjE3
         gmyR6DCfmHxHmE7dlucmG01Xh1+Nch+3awNu74/9QnD4U9P3XrB5vcx4g2Nq4iEtOdFw
         g/MlwIz0EvzoUCzPp1Yu+diqqGlkc66PNKGM4qr96XCit1hvjcpvDE47TUHqdg7nT2xI
         Gwlj7fCxym16+O0lMnAV69pfDvhaZNwLCBEvvt/IwsrCSOllZCXd+3P7kfk7U04OTXH7
         NLimouXE+08q3is09RkOdEFILSfR5PQyJ0Zj1Z8zN5Gm5S/q31cw06LeBLEiVwQUXDpW
         qMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752499927; x=1753104727;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUNzcQ1xlAA6C+zv++Z/UrxHElTSq2AcaBcHlPI4ybs=;
        b=FI87soRgFtSwgz4gJPFE2Ms/OsQRmSVlat7Qo4FIYV4R3iERFiUhdsS8UjpdTm0p+8
         jVYj07ZNMn/iZdNg/At+Pk106RvQ/pk1FS28/jfHDRN7xeTPzJnmnxbHfPqRcsq75Nua
         E297HIWOZo0i4N+MgkqWoyqmXLITLnQVuoyn+VNrtfGbSKmjhJpXMgfYA6+hAJc48rHQ
         pC8mroivlUTVApC4Y0FB3R59Eyfpdrx4Sn3GkgaNyYcufCN+S1LZAGUdEQvFt5yfMjCP
         mVC/Bwx8PunDqgFQVa1zd7tVgbR7t4iXbJmtODmRDxs2Ya6HhQoGONHIsqC60Y3Hnf8W
         AqGw==
X-Forwarded-Encrypted: i=1; AJvYcCWYKKUnQwC6YuI3E9uy6mtPsrPJnZgVd1QRUcTOh2wqj/P5lfHsfj7pVuEX0jQ+OfT0YUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGM+bVMk7JEB+unJEl7ChM0Cvo0bLjoB4wBLNv8zuokloY6dxV
	nvQhRqAp1Ccz44kvTmrQKp0cHRKr+K4ooB476i7uYGmUFAEkQ3AMTOZC7y1X1l7luJU+bbA8W60
	rkspPwg==
X-Google-Smtp-Source: AGHT+IHOhQ+T9na3EwZ8qs0c6r6zVVWjEa/PX5Yja9odLBhtSlSKchBHzSBRBu2VFmUKCMfBYNYdJDBtasA=
X-Received: from plgb2.prod.google.com ([2002:a17:902:d502:b0:237:f270:4be1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db08:b0:235:f49f:479d
 with SMTP id d9443c01a7336-23df07da842mr176069085ad.3.1752499926932; Mon, 14
 Jul 2025 06:32:06 -0700 (PDT)
Date: Mon, 14 Jul 2025 06:32:03 -0700
In-Reply-To: <20250712184639.GFaHKtj_Clr_Oa3SgP@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-16-Neeraj.Upadhyay@amd.com> <aG59lcEc3ZBq8aHZ@google.com>
 <be596f16-3a03-4ad0-b3d0-c6737174534a@amd.com> <20250712152123.GEaHJ9c16GcM5AGaNq@fat_crate.local>
 <e8483f20-b8ee-4369-ad00-0154ff05d10c@amd.com> <20250712184639.GFaHKtj_Clr_Oa3SgP@fat_crate.local>
Message-ID: <aHUG06Fz1Fg61NWT@google.com>
Subject: Re: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for 32bit/64bit
 access w/o type casting
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, 
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, 
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, 
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sat, Jul 12, 2025, Borislav Petkov wrote:
> On Sat, Jul 12, 2025 at 10:38:08PM +0530, Neeraj Upadhyay wrote:
> > It was more to imply like secure APIC-page rather than Secure-APIC page. I will change
> > it to secure_avic_page or savic_apic_page, if one of these looks cleaner. Please suggest.
> 
> If the page belongs to the guest's secure AVIC machinery then it should be
> called secure_avic_page to avoid confusion. Or at least have a comment above
> it explaining what it is.

secure_avic_page works for me.  I have no real opinion on the name, I suggested
prepending "secure" purely to avoid creating a too-generic "struct apic_page".

