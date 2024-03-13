Return-Path: <kvm+bounces-11764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 274B187B218
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 20:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB5761F2731D
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 19:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D832F4C600;
	Wed, 13 Mar 2024 19:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jQHCEXmc"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FE24D59F
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710358972; cv=none; b=MxkdlgAuldz4Dle0egXOPURgWtp14QLLBmtr52qeDDvCO+sMTZ1SMEme6qPe+4oEX/iyQweYEBJcHs7vXHoH+XKtSVVeWWOdXY60Qcq1zmysFeY7Wc6M7iMFae7AWATbtBIKs/KA4nddlJ+2VVlaFvyuPlhYVnBaYYMLHG+T6Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710358972; c=relaxed/simple;
	bh=E+jLFz1+KAMdfFOIEDPlUwPmAJ/O4s0jS/Ky0Fcqb9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=na9VDQvn6SxAdoQQMNjN7alHw7FIZCFxPi3096B901a5Vr3i5vCKs7vBDYdApyEUomCkoy5i3sYFYoae3L3AYFulPDMFQuJUWaszojy0mIC6IyxcyPzFk+4A/409mRldR+PKVYAxKrVYc7iqGpIUOMgpGiRzw6UpnxxyQPrMOBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jQHCEXmc; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 13 Mar 2024 12:42:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710358968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dk+nf9vh0nOvWNFnphPCv/gkG9LNigZwfhqnSK2cUmQ=;
	b=jQHCEXmcdKpEnoJmAzzx7S4DkZ6npgZkz9+EDG59h2VMgjNuBFBiLgcwV1NE2R7OgC0+Cj
	KTWfhUFQcnFWNNmvdw2IXL8AcJYSVF1X75rL8yZlR6w4e/ppsGqaRzCLaAuqWVuOiR9V8l
	RQ/hqGQkwmV1rszlm0/Y6IwwDmZzmAI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: Add PSCI SYSTEM_OFF2 function for
 hibernation
Message-ID: <ZfIBr25V0ulNGUHN@thinky-boi>
References: <20240312135958.727765-1-dwmw2@infradead.org>
 <20240312135958.727765-2-dwmw2@infradead.org>
 <ZfB5BMfLHWhQXLZY@thinky-boi>
 <d140bb65f02d2b0e33d176beef400d9e22bebafa.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d140bb65f02d2b0e33d176beef400d9e22bebafa.camel@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 13, 2024 at 12:53:45PM +0000, David Woodhouse wrote:
> On Tue, 2024-03-12 at 08:47 -0700, Oliver Upton wrote:
> > Hi,
> > 
> > On Tue, Mar 12, 2024 at 01:51:28PM +0000, David Woodhouse wrote:
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > 
> > > The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2 function
> > > which is analogous to ACPI S4 state. This will allow hosting environments
> > > to determine that a guest is hibernated rather than just powered off, and
> > > ensure that they preserve the virtual environment appropriately to allow
> > > the guest to resume safely (or bump the hardware_signature in the FACS to
> > > trigger a clean reboot instead).
> > > 
> > > The beta version will be changed to say that PSCI_FEATURES returns a bit
> > > mask of the supported hibernate types, which is implemented here.
> > 
> > Have you considered doing the PSCI implementation in userspace? The
> > SMCCC filter [*] was added for this exact purpose. 
> > 
> 
> For the purpose of deprecating the in-KVM PSCI implementation and
> reimplementing it in VMMs? So we're never going to add new features and
> versions to the kernel PSCI?

I'm not against the idea of adding features to the in-kernel PSCI
implementation when it has a clear reason to live in the kernel. For
this hypercall in particular the actual implementation lives in
userspace, the KVM code is just boilerplate for migration / UAPI
compatibility.

> If that's the case then I suppose I can send the patch to clearly
> document the in-KVM PSCI as deprecated, and do it that way.

There probably isn't an awful lot to be gained from documenting the UAPI
as deprecated, we will never actually get to delete it.

> But to answer your question directly, no I hadn't considered that. I
> was just following the existing precedent of adding new optional PSCI
> features like SYSTEM_RESET2.

Understandable. And the infrastructure I'm recommending didn't exist
around the time of THE SYSTEM_RESET2 addition.

> I didn't think that the addition of SYSTEM_OFF2 in precisely the same
> fashion would be the straw that broke the camel's back, and pushed us
> to reimplement it in userspace instead.

I do not believe using the SMCCC filter to take SYSTEM_OFF2 to userspace
would necessitate a _full_ userspace reimplementation. You're free to
leave the default handler in place for functions you don't care about.
Forwarding PSCI_VERSION, PSCI_FEATURES, and SYSTEM_OFF2 would be sufficient
to get this off the ground, and the VMM can still advertise the rest of
the hypercalls implemented by KVM.

That might get you where you want to go a bit faster, since it'd avoid
any concerns about implementing a draft ABI in the kernel.

-- 
Thanks,
Oliver

