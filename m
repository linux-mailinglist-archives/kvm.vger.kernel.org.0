Return-Path: <kvm+bounces-33243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 224DB9E7EA6
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 08:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 988D5285EB2
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 07:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D704513A3F3;
	Sat,  7 Dec 2024 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="py7KvUFt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2982D27E;
	Sat,  7 Dec 2024 07:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733555701; cv=none; b=KD+AFnTDfgRTU68YHZn+EiRJSJaxkoKNgOWHAP+AxQlAsEt5oUW7rVoLjDClU59PKCtpQHBY3Jpi3bFHfPXm6WMwe+x5PrW5GY+yGVFhz+ksdkLfq/QgYcK/Z9HXQcsqiFBsK7GQbokwDt83MR1bKXKomY7mD7STTXsNrUveP4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733555701; c=relaxed/simple;
	bh=oAnCIry7zz0LHB2JW5rkUj+VTlRZl6GeP5F62hw39yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgWPBOr5S4Nnm6hwbJx5GKcqr/6v37ZRciLpUplsHcu6kYgjh9tJ8KCpTYUyMvRyJJmBrGwJ70xEjgT4ENiibbtBRgKpMJa4doS/OkwiRMgPmgxkjvpKTEkgnpA6k4TT4CQF7iqIPcwN4duZqpESTPsOqPxfXmAvGNE0NnnW19E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=py7KvUFt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF90C4CECD;
	Sat,  7 Dec 2024 07:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733555700;
	bh=oAnCIry7zz0LHB2JW5rkUj+VTlRZl6GeP5F62hw39yQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=py7KvUFtZppqNtobuVWrAtrD0KzRh3xrhqdYXD4b2BBIl+lqwCXNYgtsisWjkwNu4
	 H2AbmUTKTvXiw+Y85xQCkb57jphuQiRBjZrSBntJWxcGDgYBA0dgZWrvVbcqxduhVY
	 5iZcI15Cyhok4bRWttmALPJulLQ1zBaHTXWjhDgcSZxdjTdVTPGwOzv/B/9PJKpU6g
	 64nGyRFfxYBRm4tPoKnTtycZJfxHNNb9YyTnKlIP3LDkIFu1o00VS5XK6SaXz11ElV
	 aLH/lhF6Qd+h+H1ZpDPlo9b57QnW/KbXG3hz/maOo0seAu0VG+Wtqz9TnT8JSYfTZF
	 JKIVeHHZys28Q==
Date: Sat, 7 Dec 2024 07:14:58 +0000
From: Wei Liu <wei.liu@kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Kai Huang <kai.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH, RESEND] x86/mtrr: Rename mtrr_overwrite_state() to
 guest_force_mtrr_state()
Message-ID: <Z1P18uRSY0dSQjfi@liuwe-devbox-debian-v2>
References: <20241202073139.448208-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202073139.448208-1-kirill.shutemov@linux.intel.com>

On Mon, Dec 02, 2024 at 09:31:39AM +0200, Kirill A. Shutemov wrote:
> Rename the helper to better reflect its function.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> ---
>  arch/x86/hyperv/ivm.c              |  2 +-

Acked-by: Wei Liu <wei.liu@kernel.org>

