Return-Path: <kvm+bounces-8147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E0B84BEF4
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:52:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFFEDB25BCD
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FD31B94D;
	Tue,  6 Feb 2024 20:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dI8Pt14l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B711B81B
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 20:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707252718; cv=none; b=ShTvY54hiijzv0KNfwCRcCIBf2hHzQlczwFRsPno6cVXU3Rw1e4efyjB5RSaREh2CM3Ia1XTyZiSn6rlviohwxdPUU5mgpTZ5FNzv23bgLUS94gBFPtYxQPV2fcvdwxciCedvap15K5Yk5w8ykuoXuEddjEKMUGkcBFmgRdITHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707252718; c=relaxed/simple;
	bh=6f6Qix6f+UWdfRaPzaX+crwa5ujk+FHt0PxZzVbTk2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fTwHqmnZvYDAtCxb9366S97QPlovmYygO++KeTtykQOo/X7Un3edR7tqskXx47bkTD6Qeyd1SfJwaxSYcIQhNy3Gudmf1Yut9VgFgi88o6rkDIALFrCoBHE+58QSrzWd+P+SMuSnqE/ZdUgFuJWPbvZ1dU7Mt2SOjbv66vYQwS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dI8Pt14l; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d968aebbd1so48876215ad.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 12:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707252715; x=1707857515; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JwbhYZHR4hW4due82eTme97f04XbIaf6d9EPvYJz5x8=;
        b=dI8Pt14laIQ7hBtZ4OceMWEWk73T+qoQFwNDRfujpMULS2qQ3zE2nHvSgOdOYnMj/x
         CbVmjX9PDgmYvHmJMn4fga1zIlMhGGpBIkxq9Y8NSTUXw+mUwEUFsMLuaKK4e9GXuP7L
         bH7aehGXGXBDMjCuq50hQavYfnBkZwiuLIljg/J9Jq0HtIhr/uvxI0TTUGftUYyDTiXP
         DsZe1YQXAZmVrkczc+ONBLcW8/GeFLtAPtSYhPl2WaELuTORixaW4rqz490qymc0xCU1
         c2tXvptlq6VrfQ56D/AHIuA3WvRm9Iwxf/fu2Umj1S9U4ivrWph52epJx5HE/Ag/M9IM
         +zBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707252715; x=1707857515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JwbhYZHR4hW4due82eTme97f04XbIaf6d9EPvYJz5x8=;
        b=Dwyb+QXFmgOTi3WWKeAe9apHzTcy5F0/YdMv1aSea+LL+9a1wamEJ/9ATMZv13FiEK
         DFhPJGfqGOsNPS0tb18lv/FdXzNrSY8a9Bqji/lrHME9MstfTLavGk1WWDm+XiMc2HLS
         yvSbZqBnKmE5pjjbFhOdmX1rXwInXOwOk/cUMmvc2F0HZvldX8lXcrMVdXIxxn1de/Im
         XN0SgyHSnHdtgYGoYSPW5n/XeA0Rawr/RrySUUIcp0jzI5KxwBpQfmCgCzIIG3/Tbq9u
         00AtgZgF1zQ/4u5mmIt5W4M2KXZKTSbBcqEfMIDFRTMnwsRZWqr7LWCJAmXbt4fxab4h
         i55Q==
X-Gm-Message-State: AOJu0Yy/E6AO7gecUDMW9LB8gu0YkAgtKYnDm4RSCa29eVU4x1/sVaQe
	QNffYYABa66pGYqGfWsah6MzZ2aR8oVrPFfai2dU2wJVRrfmmO26MSkNx3841TjMdI+Sz9hRNnp
	SQw==
X-Google-Smtp-Source: AGHT+IEj5phGVut6P7UH0HGT2jn7IqSaGP6JthmOgqjg9ZskUGjauEK3HLRpFSTg5biILz4Q+Ty+BMdRsZg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d510:b0:1d9:ae91:7b50 with SMTP id
 b16-20020a170902d51000b001d9ae917b50mr8028plg.7.1707252715474; Tue, 06 Feb
 2024 12:51:55 -0800 (PST)
Date: Tue, 6 Feb 2024 12:51:53 -0800
In-Reply-To: <20231230172351.574091-7-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-7-michael.roth@amd.com>
Message-ID: <ZcKb6VGbNZHlQkzg@google.com>
Subject: Re: [PATCH v11 06/35] KVM: x86/mmu: Pass around full 64-bit error
 code for KVM page faults
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Dec 30, 2023, Michael Roth wrote:
> In some cases the full 64-bit error code for the KVM page fault will be
> needed to determine things like whether or not a fault was for a private
> or shared guest page, so update related code to accept the full 64-bit
> value so it can be plumbed all the way through to where it is needed.
> 
> The accessors of fault->error_code are changed as follows:
> 
> - FNAME(page_fault): change to explicitly use lower_32_bits() since that
>                      is no longer done in kvm_mmu_page_fault()
> - kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
>                         PFERR_NESTED_GUEST_PAGE
> - mmutrace: changed u32 -> u64
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Link: https://lore.kernel.org/kvm/20230612042559.375660-1-michael.roth@amd.com/T/#mbd0b20c9a2cf50319d5d2a27b63f73c772112076
> [mdr: drop references/changes to code not in current gmem tree, update
>       commit message]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

I assume Isaku is the original author?  If so, that's missing from this patch.

