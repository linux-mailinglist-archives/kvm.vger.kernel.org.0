Return-Path: <kvm+bounces-45201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79FC3AA6C86
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 10:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F8CB46699D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 08:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3148922B594;
	Fri,  2 May 2025 08:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CsCcumy8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDEB19D891;
	Fri,  2 May 2025 08:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746174623; cv=none; b=KZBlj1XRBYAKyhRy/UsblUD+hbUp/l27NPZEvgK8I0in3verkqk9BRxL0PsNtWGMx+P7R7gAUSvMwSzL9qvxH/NE3zyKGe136hlgeTE0MbRK5o1yz0AU62eAdPiHF+if8qjxsJXyDJifkuZqc2EJy/qgy79c+rPfAzIbUD7R9jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746174623; c=relaxed/simple;
	bh=XJ/fOLSZPcDhzbn7SBomjY3ra1ercNwGTwdTApCpr4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brY3400eAxSuk/zowbNfnpHI3c9CVRv2qjSxRPEMq4fTPbLU6RsYvl+a5++wwLNj+WdQvAl4VxiKFs1pF8meCC1zsjD49yNmZdXtCjaNlxyiLCDmajVAE4wk35YjzCpRIZ9qNlzUCO9AOw1ziIDqX7aEfzUjlp6h7kmETpo2UJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CsCcumy8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BD6C4CEEE;
	Fri,  2 May 2025 08:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746174621;
	bh=XJ/fOLSZPcDhzbn7SBomjY3ra1ercNwGTwdTApCpr4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CsCcumy8yvL+I8c/Q+4FCgid3SiZumzGsXHXwXMdYu5Pb//5a+dPYvjCYyRD0S7xR
	 8OsobySDrVsqsSztegV67tmw+EzZy4UOm+uiwwLSOqz/aq7BngmEF9jCSpd5akyoGf
	 jMaLyfr2RqTyi2jyDa2H7KelSZY5d/1QPDkg1pXrmQa9gQSSLPwb/gIIrSfO435Of0
	 0gqTeWxKfMi1jh6+Z8xUkVFzHKvRcUa/gyVx5VK12AAAxHeKAUA7qDytqmewnPFkw4
	 90zUASti8CLXJfv7JW3XsRHfW5jf8FmECPis1Q3MnBN6EE6TFStJAALK1mkZJmFN08
	 ftBTm+oNzkoJA==
Date: Fri, 2 May 2025 10:30:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
	netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
	peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
	tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
	seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
	kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
	dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: Re: [PATCH v4 10/15] x86/xen/msr: Remove calling
 native_{read,write}_msr{,_safe}() in pmu_msr_{read,write}()
Message-ID: <aBSCk5phiMYO_B6T@gmail.com>
References: <20250427092027.1598740-1-xin@zytor.com>
 <20250427092027.1598740-11-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427092027.1598740-11-xin@zytor.com>


* Xin Li (Intel) <xin@zytor.com> wrote:

> hpa found that pmu_msr_write() is actually a completely pointless
> function [1]: all it does is shuffle some arguments, then calls
> pmu_msr_chk_emulated() and if it returns true AND the emulated flag
> is clear then does *exactly the same thing* that the calling code
> would have done if pmu_msr_write() itself had returned true.  And
> pmu_msr_read() does the equivalent stupidity.
> 
> Remove the calls to native_{read,write}_msr{,_safe}() within
> pmu_msr_{read,write}().  Instead reuse the existing calling code
> that decides whether to call native_{read,write}_msr{,_safe}() based
> on the return value from pmu_msr_{read,write}().  Consequently,
> eliminate the need to pass an error pointer to pmu_msr_{read,write}().
> 
> While at it, refactor pmu_msr_write() to take the MSR value as a u64
> argument, replacing the current dual u32 arguments, because the dual
> u32 arguments were only used to call native_write_msr{,_safe}(), which
> has now been removed.
> 
> [1]: https://lore.kernel.org/lkml/0ec48b84-d158-47c6-b14c-3563fd14bcc4@zytor.com/
> 
> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Sign-off-by: Xin Li (Intel) <xin@zytor.com>

'Sign-off-by' is not a proper SOB tag, I've changed it to Signed-off-by.

Thanks,

	Ingo

