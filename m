Return-Path: <kvm+bounces-61472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C280C1F8CF
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 11:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CD04134DFD6
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 10:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1D535580A;
	Thu, 30 Oct 2025 10:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hzmzDqAZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C781C350D79;
	Thu, 30 Oct 2025 10:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761820139; cv=none; b=glWoAQUHFzXxNGHb9RL4Pn3XRGZPjI4hsigQrfY4LLOWThWZieOojnrxQWBB8Di2ygMeoxDnRDLVDM+YtsBbS5PqHkQLfx5L43FJuVHisq7it8QmwMVYx4VqrxkcW6HKdP6cZQAx2+Y7aqJlLmYhcblnXlc3kwjA1v3Y/bvy/Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761820139; c=relaxed/simple;
	bh=AifIUuNwhTe15u6vhAo7fW9AvS5TadottclufhTDVFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNvcCdABwEDE1ly3oEabSoXwbDSn8q++prBPKqbkF2bdG6mCid7+1nvY7RYwX40G8nc3fl/Lmikm4EpMcH4IScQSN/GWhOgik/Tdr+Mn7+cJdXXmA91WnsEScVew38gcen+TxjpCarEjhr2Y6Y3vzAWzyy7jQeisriGSWHm37As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hzmzDqAZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2E9CC40E021B;
	Thu, 30 Oct 2025 10:28:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id UymOqoxP1A1F; Thu, 30 Oct 2025 10:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761820129; bh=WZZ6N+wcXa37HBzA5ts6flFieqWk4sP4JA+15EAS45U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hzmzDqAZcDuVVdcb/zrFbu80QwFEgGX4v5eZRvHiSEmvpa45Ciu5FGZzZtHPexp7a
	 yLP8XMmG4L3tDQgeNfI+jQv/+DI1ilDPEhPuzPlpSWXn4zVXGpkKb1gfwhMWjv0+67
	 Fjv0RuEQEysYiqkl8FkmTZndM+B5pvlLDvJ4AQ7RnqIDmkrnc80D03NyUauqJHf6jv
	 4FLURMd39H5SAsYB8/F4bps8aVtv4X0Yt72zsfEqNFU3mV+FzTN6UNmhUM9Z6JvJ55
	 ZqTcdheAk/cTUHWJzx/opM/IGN2uuFqlaeiKlGYSs9K8PvfPhhPVWgS05IrOC8U3tu
	 hOvbvT0p7AxmX61qfgl9w1XzgfOtUOdSYOK32iTR+qtaZMrA9FguevLwQQWp9644l5
	 V+690Bj7iltdneXdDS79cgRuC5fTgBNgxLURKZpq56oDI/TBLxajEnuJXLxedi6lY8
	 ljDOUkKo5t/kFDCd0Za6ZrCd40ODw/nHBdJKr3ulDZfUlV/0qWIP5QJkzYucbP0DQe
	 CZfLmyAUI50X8aiKj2H9ok2ONspMDtLqid3pAaTadGzVPnLP0X3EGK0KyHmdgUU/Ij
	 NTYYNCI42eEBkjHr4//ZWpIdoCj28hT8lK4vYH899nKArqPZYics89IATtNG06WXKX
	 isYNjdM7JaLaz5vNi6QWAUnA=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id B831140E015B;
	Thu, 30 Oct 2025 10:28:33 +0000 (UTC)
Date: Thu, 30 Oct 2025 11:28:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH 0/3] Unify VERW mitigation for guests
Message-ID: <20251030102826.GAaQM9ykytR9Dm3yEb@fat_crate.local>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <aQKxVLoS2MzBiSIm@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQKxVLoS2MzBiSIm@google.com>

On Wed, Oct 29, 2025 at 05:29:08PM -0700, Sean Christopherson wrote:
> Any objection to taking these through the KVM tree when they're ready?  There
> will be a conflict in vmx.c with an L1TF related cleanup, and that conflict is
> actually helpful in that the two series feed off each other a little bit.

I don't see why not.

At the moment, we don't have a whole lot in tip touching that area and if it
ends up appearing, I'd ping you for an immutable branch I could use.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

