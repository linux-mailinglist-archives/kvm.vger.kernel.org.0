Return-Path: <kvm+bounces-53222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E297CB0F18A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D23B53A4B53
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 11:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A252E49B8;
	Wed, 23 Jul 2025 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V906kXSO"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF2A2E542A
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 11:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753271117; cv=none; b=DaQltNWskBlWOKahqXV/n3Y26Kq0man6uvJ5CkwYPDkn/dd21UfRvpmCsb245VUmgFZBDdfzJMKDBa/9Id0XtkchKg38vFP3jhRNDtDWtulOtrO1dHSXLxNB/WNoDxcY8AZU4DUJWd3r7xyiiOd1Z5CUR4TBWeNyas2fIlAr6MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753271117; c=relaxed/simple;
	bh=owZiUW8Siyx2lF0K51cV1c/Sdy6AymBUIZnkSBWXW5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sMikQfTMTH3iXeswkiM2UYRWUgyGgjnTTqXmhxj4mbznJrda0mAnS+HQopuTza+tJpmiSDVOR6PtbJ8VXSmqHshxi+fi/3elB+L5Af2JFI+L54tl8GwBtxkt2bcuo9tr1EfYRjO+y+A01zMcVe+UmVVZhseGOcMZSuETE6qt0bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V906kXSO; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <63b70aa3-5b20-464f-83ac-97b6a78c99f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753271102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l59cD6t8x/yYppwAMFqjuP0HYW8qoCrV0FHN2nRJB/Y=;
	b=V906kXSOWuv2GItOcDK540WJ3tHmdbNrKADl+IxsddBmeLbJQzIDavJMyUe5zJ84UCrZ+p
	/twn4ph0k0JIHqifJ4/aBEq9tMIzVjHm6gxNN3l5P+YcW81TP0J9XHd+QbgzDbPy/wLKf0
	EssEmv7nn7aObEElJagRnU4R8JLKNsU=
Date: Wed, 23 Jul 2025 19:44:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v15 16/21] KVM: arm64: Handle guest_memfd-backed guest
 page faults
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org,
 qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org,
 hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com,
 fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com,
 pankaj.gupta@amd.com, ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-17-tabba@google.com>
 <07976427-e5a4-4ca4-93e9-a428a962b0b2@linux.dev>
 <87pldrtj1o.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kunwu Chan <kunwu.chan@linux.dev>
In-Reply-To: <87pldrtj1o.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 2025/7/23 16:20, Marc Zyngier wrote:
> On Tue, 22 Jul 2025 13:31:34 +0100,
> Kunwu Chan <kunwu.chan@linux.dev> wrote:
>> On 2025/7/18 00:27, Fuad Tabba wrote:
>>> Add arm64 architecture support for handling guest page faults on memory
>>> slots backed by guest_memfd.
>>>
>>> This change introduces a new function, gmem_abort(), which encapsulates
>>> the fault handling logic specific to guest_memfd-backed memory. The
>>> kvm_handle_guest_abort() entry point is updated to dispatch to
>>> gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
>>> determined by kvm_slot_has_gmem()).
>>>
>>> Until guest_memfd gains support for huge pages, the fault granule for
>>> these memory regions is restricted to PAGE_SIZE.
>> Since huge pages are not currently supported, would it be more
>> friendly to define  sth like
>>
>> "#define GMEM_PAGE_GRANULE PAGE_SIZE" at the top (rather than
>> hardcoding PAGE_SIZE)
>>
>>   and make it easier to switch to huge page support later?
> No. PAGE_SIZE always has to be the fallback, no matter what. When (and
> if) larger mappings get supported, there will be extra code for that
> purpose, not just flipping a definition.
>
> Thanks,
>
> 	M.

Got it, no questions here. Feel free to add my "Reviewed-by" tag to the 
patch.

Reviewed-by: Tao Chan <chentao@kylinos.cn>

Thanks,
	TAO.
---
“Life finds a way.”


