Return-Path: <kvm+bounces-60011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30350BD8F70
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 13:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4365541C81
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 11:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24999308F1D;
	Tue, 14 Oct 2025 11:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PKF14+p4"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655C22FD7DA
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 11:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760440643; cv=none; b=IxwtjN0sGkg1b95odxAb+hOpeSgCL73VtU8MWCJySPNZT/kfhWO8g0+wJ5c32YhvZNV8IAXtDQUi/upBTYJ8jZ2F1zt4vq4iA+BJU8Xg9iitAnzhGXrqIam1VpfQAr0zsucGs1kNKxjOVuNhpQWGvLjS2ws806lnRbIEpZwZcCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760440643; c=relaxed/simple;
	bh=tA4kJCCvcyXiX0nM1QGV3wY/m4opVXSJ2CDn8zjw1jE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HdDnwIFGeT6ZWi8QwuIjHN3cdsvPp4Xjq1tl2zCcpcoiaPTwMZ4w6WqCN+F1JzT+8O2LRhnRvjeeCv8S6w6K7CMAdamIxDGPdsCO8ueaG9M1BgspIlVJFVJjLgc8UzK/6LpttGbMADd+SW20P0thZVvEePS41q45hqft94sI6y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PKF14+p4; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760440629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRrWMAZv6TAU0NDQXDUp1aJo0V+tJdK71nK9ZNIKdmc=;
	b=PKF14+p4Uih9rzcdLt0F7+ANwijTt5tHVmSAXxtoY4VCWL/Cdyv+K/nmmISUWS7k2ib+JT
	gSETMDasjTT7xyl7DTVznTAgkuCQeshiypupOR/pNTwYYaOF9ra9TJS0Fq2oozP8ibO29R
	NRxD8dughvQLXYoBNK1ufi9MncEoMZY=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] KVM: TDX: Replace kmalloc + copy_from_user with
 memdup_user in tdx_td_init
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aO16HySFc6wNVpix@google.com>
Date: Tue, 14 Oct 2025 13:16:55 +0200
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <B3004060-F512-460B-BEEC-C6F335ED6456@linux.dev>
References: <20250916213129.2535597-2-thorsten.blum@linux.dev>
 <aO16HySFc6wNVpix@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On 14. Oct 2025, at 00:15, Sean Christopherson wrote:
> On Tue, Sep 16, 2025, Thorsten Blum wrote:
>> Use get_user() to retrieve the number of entries instead of =
allocating
>> memory for 'init_vm' with the maximum size, copying 'cmd->data' to =
it,
>> only to then read the actual entry count 'cpuid.nent' from the copy.
>>=20
>> Return -E2BIG early if 'nr_user_entries' exceeds =
KVM_MAX_CPUID_ENTRIES.
>=20
> I think I'll drop this line from the changelog.  At first glance I =
thought you
> were calling out a change in behavior, and my hackles went up.  :-)
>=20
>> Use memdup_user() to allocate just enough memory to fit all entries =
and
>> to copy 'cmd->data' from userspace. Use struct_size() instead of
>> manually calculating the number of bytes to allocate and copy.
>>=20
>> No functional changes intended.
>>=20
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> [...]
>=20
> Any objection to calling this user_data instead of user_init_vm?  I =
keep reading
> user_init_vm as a flag or command, e.g. "user initialized VM" or =
something, not
> as a pointer to user data.

No objection.

> No need for a v2, I'll fixup to whatever we settle on (assuming no one =
jumps in
> with a crazy idea).

Ok thanks!


