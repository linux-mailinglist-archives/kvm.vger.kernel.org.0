Return-Path: <kvm+bounces-61318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AC797C16517
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 18:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 597314FB039
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 17:49:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD1234C9AF;
	Tue, 28 Oct 2025 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quZnmOVL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2033CEA7;
	Tue, 28 Oct 2025 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673768; cv=none; b=oS3xE2qX58jdIbrCvPY2pGpu2FUPRax0Ngso1dgxqit6SPALK03dhHENEoBkahSGAWCYJk7iF4bJ5BnFjHlz7jla0t5ZOV67DZ0yy5Do9fCby2X3dLGuMnQYjuibXbcqwbAR+8/g6NgO6flAYHBoMOJ1bts5nYmhVTK1neCNvrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673768; c=relaxed/simple;
	bh=vunf56U5PcZ3/tDBjhpbxvdftWozMDKJ8pa5fyEIV7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AvrytTCtOMQQRvxiDke2HWaNfbeFlCqalUg3N2YzXPyMAIdVV5UBX/zqaPwQl/FAYFWNcD3wIcmHbh9wOE5h5niML25U5XJqzAm8f/JpEn5UQ6adXq8CSNGvPfuqfhGeWj0N+GqD7DSUguYfm4/fiDoxeUOrh74StD2syv/Ife8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quZnmOVL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFADC4CEE7;
	Tue, 28 Oct 2025 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761673767;
	bh=vunf56U5PcZ3/tDBjhpbxvdftWozMDKJ8pa5fyEIV7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=quZnmOVLSlMynA7G0LD7XnOq1NqPcp5r79JIFcBz8EKFK1d0gm8QKnJ7z18nm6muU
	 +YsJbMwC6CTTTTtyw0qQ7tmH50KR6UmvfNFS82UjWv1rg4g1qnrfks8aOTESFzmirs
	 a5OltNN2bRbv43CHTl0pR5bT1mT53yig5ObrvZfZvV/qQaZt5CKnU/6osmBzuJC+13
	 SKgCQHSXbiwC8VtcZOxdtrVsPRgZr4HIJ6mv+WXaUoEOLo9W1z0CBPjdgGkSeiQQWd
	 5TM0xT0vAW5HWz+4ZbFydDr4ZldINipvbNCrLOmgwrD56+clANqaCS7bE0Pu4N5/Wd
	 Y01nyrDTmdrEw==
Date: Tue, 28 Oct 2025 13:49:26 -0400
From: Sasha Levin <sashal@kernel.org>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"thuth@redhat.com" <thuth@redhat.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>,
	"alexandre.f.demers@gmail.com" <alexandre.f.demers@gmail.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"Chen, Farrah" <farrah.chen@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.17] x86/virt/tdx: Mark memory cache state
 incoherent when making SEAMCALL
Message-ID: <aQECJnXwVKt21xhc@laps>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-328-sashal@kernel.org>
 <5f7a42b60c5cf1dba8f59c30d5d8f20a95545cf0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f7a42b60c5cf1dba8f59c30d5d8f20a95545cf0.camel@intel.com>

On Sun, Oct 26, 2025 at 10:25:02PM +0000, Huang, Kai wrote:
>On Sat, 2025-10-25 at 11:59 -0400, Sasha Levin wrote:
>> From: Kai Huang <kai.huang@intel.com>
>>
>> [ Upstream commit 10df8607bf1a22249d21859f56eeb61e9a033313 ]
>>
>>
>[...]
>
>> ---
>>
>> LLM Generated explanations, may be completely bogus:
>>
>> YES
>>
>> Why this fixes a real bug
>> - TDX can leave dirty cachelines for private memory with different
>>   encryption attributes (C-bit aliases). If kexec interrupts a CPU
>>   during a SEAMCALL, its dirty private cachelines can later be flushed
>>   in the wrong order and silently corrupt the new kernel’s memory.
>>   Marking the CPU’s cache state as “incoherent” before executing
>>   SEAMCALL ensures kexec will WBINVD on that CPU and avoid corruption.
>
>
>Hi,
>
>I don't think we should backport this for 6.17 stable.  Kexec/kdump and
>TDX are mutually exclusive in Kconfig in 6.17, therefore it's not possible
>for TDX to impact kexec/kdump.
>
>This patch is part of the series which enables kexec/kdump together with
>TDX in Kconfig (which landed in 6.18) and should not be backported alone.

I'll drop it, thanks for the review!

-- 
Thanks,
Sasha

