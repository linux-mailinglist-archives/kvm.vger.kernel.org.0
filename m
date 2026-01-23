Return-Path: <kvm+bounces-69029-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGKrL9b6c2mf0gAAu9opvQ
	(envelope-from <kvm+bounces-69029-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:48:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F2E7B3E9
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:48:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E411D301980F
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18F42D3228;
	Fri, 23 Jan 2026 22:46:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E202A190664;
	Fri, 23 Jan 2026 22:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208393; cv=none; b=PvyaSqugfnz5+9EgunYTm7kE188/XT/AFmCytMqkTf83HlfFXAXtdewo4hbKig3SswClifYSRWKH+ep/fEFPPGEqakYAYOIPafIt2V564XI7YxnnYD3sOruwCrmVHvZOokCy2bGj/5Gwx8hGTBMaDRflccAF94lXvD+tUAxSMuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208393; c=relaxed/simple;
	bh=fyNOIml0uwf4cqGl7TAjzi/z4yElhqkwW+9XzD4DARs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fp1s7ALzDeCDiqW50YO06HQRfOorQGP3yqKTd7NbZlz+lLzAE0HGoGhDaZfjEDvKoudqkG1tLcCp6dy8N1rtbt+fXKnRDJLimrPfkkA5naxNnMF6I82eMv5RUrq/Ul6lSw1rnR7afsN4tRPragxjTdvARmwAlcdpxtKii6Y1+nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from [10.88.16.10] (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 7A04A2339E;
	Sat, 24 Jan 2026 01:46:29 +0300 (MSK)
Message-ID: <8d23522a-efbb-4d4c-7ecb-f9de87b44677@basealt.ru>
Date: Sat, 24 Jan 2026 01:46:28 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] KVM: x86: Add SRCU protection for KVM_GET_SREGS2
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20260116151523.291892-1-kovalev@altlinux.org>
 <aXOuwWI3WcvT6Ccb@google.com>
Content-Language: en-US
From: Vasiliy Kovalev <kovalev@altlinux.org>
In-Reply-To: <aXOuwWI3WcvT6Ccb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[basealt.ru:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[altlinux.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kovalev@altlinux.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69029-lists,kvm=lfdr.de];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 22F2E7B3E9
X-Rspamd-Action: no action

On 1/23/26 20:24, Sean Christopherson wrote:
> On Fri, Jan 16, 2026, Vasiliy Kovalev wrote:
>> ---
>> Note 1: commit 85e5ba83c016 ("KVM: x86: Do all post-set CPUID processing
>> during vCPU creation") in v6.14+ reduces the likelihood of hitting this
>> path by ensuring proper MMU initialization, but does not eliminate the
>> requirement for SRCU protection when accessing guest memory.
>>
>> Note 2: KVM_SET_SREGS2 is not modified because __set_sregs_common()
>> already acquires SRCU when update_pdptrs=true, which covers the case
>> when PDPTRs must be loaded from guest memory.
> 
> On the topic of the update_pdptrs behavior, what if we scope the fix to precisely
> reading the PDPTRs?  Not for performance reasons, but for documentation purposes,
> e.g. so that future readers don't look at __get_sregs() and wonder why that call
> isn't wrapped with SRCU protection.

Agreed, moving the lock inside __get_sregs2() makes the requirements
clearer. I've verified it fixes the issue and sent v2:
https://lore.kernel.org/all/20260123222801.646123-1-kovalev@altlinux.org/

-- 
Thanks,
Vasiliy

