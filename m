Return-Path: <kvm+bounces-20723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C1B91CC15
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 12:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1975128323D
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 10:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54FAB40862;
	Sat, 29 Jun 2024 10:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="eTKxVpf4"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B593307B;
	Sat, 29 Jun 2024 10:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719656909; cv=none; b=mB/ADe3na4Z+B7MoaiVkt9c9NaqN8NAqNAm4mkd1tHuuYeUf9XToda5wJ6R5DLjiCZd4MqDehxxsIQdj97gwcx2noKu6T/KyEL6Qu96N8s5aFQQ5eLIvNZmJOVeEioOLHD6dU8Wf0bnk83RzDG+pwlBz2sZg3rKia8MEDT19Wxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719656909; c=relaxed/simple;
	bh=1/yARHR9SHet08uI61IaNxSq96N+lXYPBGDCsLMXCPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnQ8raPnWvzE9icamz+TIh5PFlXjLFok1cTv2vgQ9k+ejEzxgaeh7nsqnCsBnqOiEi7WPPRSJVGNz+CJiJx9VDSDKA05YVYWwZ+vmRPaVkMYvihfmwDjHQqjzZe6SopDA9QspwR/u7L0/eghBM9fcDZH8RDvvhhuPvzyuMvPjrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=eTKxVpf4; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B4D2940E0219;
	Sat, 29 Jun 2024 10:28:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mdtp8sMsz3tF; Sat, 29 Jun 2024 10:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1719656892; bh=a3wU1AVAS15D/Do/PzS+fcnK93oC2QSkchGw7qh5910=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eTKxVpf4gUNi7WF+5MQpgUVPKoe3UliF2REYbTABNmCh9R+KqQcKRZK7s52yK6inb
	 GGx4d3X+i+PN2Bnn0OohfxS/LFy+TVEdFeV9HmGL18Uz3Oc9CQ9T0V4gn7ea2kbjGk
	 Iv0gvjNr26o6kweFQWN3aoAFzIO+y7JSAii5IdzWhtAiZKTXWUZqGfkCD7y2jtJ45F
	 RJ8nY4nr/d6PW888CFvkCwdM2U3oh96bAgOkslb2mzFWijXd4xmiT6lcu34qevgxgg
	 6rj89jg/P76+hiKebKK0toHvDIaE9jd4lEKbunijCeobG4orpGSmqcjWBiQFIryW+P
	 hXq+vZ0OUJP3wjthH6rHuPGfuIyheFY1+iqv3LA//hE2jw91qjBKXX2TwL3MCuvM9R
	 ppZ1otGvk0bzxDCSJOCrXHiEtrkcjPpB2O0NaZAiHx8kMTjMCirkCdshL/8IAQ+S9H
	 BrA3i/QQbpasrcMzC7vQEupnQIh/Sr8E9RCamr5iY0CmtPnYoNbH4NKuvPRVuvbc39
	 dt4rcZPX5hDF8cIX7ZwBJPeauBg4Yvu9jWeJn4UT40hu2DMGDYmqU98XAZ0FXtZ0dl
	 svmsgXtMRUvdGcbeqNBs0RyxYdyRh/C9Gt1WHNs266o2R5uVdEkZSHMizcWRgAsfSb
	 r3MB4d1whDaxH7NoewvaniYw=
Received: from nazgul.tnic (business-24-134-159-81.pool2.vodafone-ip.de [24.134.159.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2185040E0192;
	Sat, 29 Jun 2024 10:27:59 +0000 (UTC)
Date: Sat, 29 Jun 2024 12:28:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>, Amit Shah <amit@kernel.org>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, amit.shah@amd.com, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
	kim.phillips@amd.com, david.kaplan@amd.com
Subject: Re: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
Message-ID: <20240629101930.GAZn_fssQgI2eoSXC7@fat_crate.local>
References: <20240626073719.5246-1-amit@kernel.org>
 <Zn7gK9KZKxBwgVc_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zn7gK9KZKxBwgVc_@google.com>

On Fri, Jun 28, 2024 at 09:09:15AM -0700, Sean Christopherson wrote:
> Hmm, but it looks like that would incorrectly trigger the "lite" flavor for
> families 0xf - 0x12.  I assume those old CPUs aren't affected by whatever on earth
> EIBRS_PBRSB is.

https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html

We could add NO_EIBRS_PBRSB to those old families too. Amit, feel free
to send a separate patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

