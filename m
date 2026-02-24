Return-Path: <kvm+bounces-71632-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHQYMBfinWnpSQQAu9opvQ
	(envelope-from <kvm+bounces-71632-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:38:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5597C18AA04
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5150430C4562
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3AA3A9DBA;
	Tue, 24 Feb 2026 17:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KyVvMOVA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDA03A9D8C
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771954666; cv=none; b=XMxYJjEKifqBV2LHVQfpS2q9vTptTQ3H7ALdGOSun6qtypgSRKgUdJ4fswAVS/4SI256FhsjBGF5V1MfXht6yPA59t7Ys2fH9iQZ4hCKHmT/ib+ZepChUv7QcRNXwbUqkmM2SN2o7uRgqzzVgHpaFEkk8PL9YRriYMoQFC4ylnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771954666; c=relaxed/simple;
	bh=mCCVv6L04cWt7rC+dXX4D8L5HIoEgr+4KNHsOMYBn7k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=buhQwbNA90fgEpQxjtmq4ZDlS2iB4v/di+8Kwh7I89dG/YEzj5zFa8jjaDCOvo3Y7QAMO7wL/vibukbvwFxujJiwOW7fcU02YXwRFqseAwBHkqtxRsboQyRbxfvMcn5a3w5p5+td7+NM+WiM8+GcCgD74iWHYXMa0OGt0kPubvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KyVvMOVA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a76f2d7744so62212725ad.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771954664; x=1772559464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YBYOBVXP4vivMMEN8JfHO64Zg9pUzxocpjlkKoATuFs=;
        b=KyVvMOVAcn/btlvd/NKGj5h3hwxorHzG32TFQT1aBEtKnWCNTLM6RlofhDWaN/C0Go
         vI1Ry9GDRSxD1ahrr4eBO/7TjE64uBbrOsbatNccMBDYU9ajOTGsWtOU3LTuy7soBs58
         8DXhLAC17Q+XzpJYmjh0Xl0pOnaDirUw0yH3Q9crzNAz9Cg0xPzT4MuN4UcpQ9+bzZ5c
         Qfb94FL5WKDOjt9xkxcahfiUr81KNJqJ3csD1Yr3X67RPTVavVTwT89dtd28i+x8xBOX
         BbSQpG7Q996iyFb0CGrHqctPZSuWjsuf20i0fCu8E7Q7TqzWxSdki6T/y0LP6goqTBuW
         f4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771954664; x=1772559464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBYOBVXP4vivMMEN8JfHO64Zg9pUzxocpjlkKoATuFs=;
        b=MC7rdw8CG/9sL0A08r6sE+LvqLaZpbQ5mkieo5ZK9laG12y8GDnWztVoWa+rW7ZhZY
         oFx19yZNjqFF6oPyMZ7DNT3yam8XaKEbTuOZMC2IJY+QGFH6bS8T8kwWsCzZWSxbIr7/
         3YavkvdYiiju0mW6kC+XdLS9EkYUVxVRKIRXx3Qy6zCaC3dmfimHqVtWSPkWwF3PPChk
         9XbaFDTmAiE0x9NnSZtww3PrTAJuiS3w8tPTfBBgVx3tnT/r+LlWqjhmJlmF4AZKhEiS
         SdtdJYv6pZLJ1ivqtQoADJ1nqeit6iudmFcHauKD5T3hgcrBi/VC1EyJYLbvQXkaTtsN
         LfmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8pX/nGSu6/c6q5LdD5j7ClQdmk01auxqefr/UrzWcfs4f9ivm9UQnwCPmiG+I0kABs1A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyemg7A27Z82WJahSgtC/qsWLSF5qMGhE3KkO1+WNul4zFOK3e4
	qpNV4VyEKdC37L3TuNcgksffQ/WUmLZTEKu/xFU82nrM42Z4cWLmjshHPrXezDpDYAUEklYfMDR
	lXUHebw==
X-Received: from plbiw20.prod.google.com ([2002:a17:903:454:b0:2a0:7f81:6066])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32cb:b0:2aa:d816:e1a9
 with SMTP id d9443c01a7336-2ad744e0aeamr104939405ad.28.1771954664283; Tue, 24
 Feb 2026 09:37:44 -0800 (PST)
Date: Tue, 24 Feb 2026 09:37:43 -0800
In-Reply-To: <20260224071822.369326-5-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-5-chengkev@google.com>
Message-ID: <aZ3h508kM-rDYKIs@google.com>
Subject: Re: [PATCH V2 4/4] KVM: selftests: Add nested page fault injection test
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71632-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5597C18AA04
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Kevin Cheng wrote:
> Add a test that exercises nested page fault injection during L2
> execution. L2 executes I/O string instructions (OUTSB/INSB) that access
> memory restricted in L1's nested page tables (NPT/EPT), triggering a
> nested page fault that L0 must inject to L1.
> 
> The test supports both AMD SVM (NPF) and Intel VMX (EPT violation) and
> verifies that:
>   - The exit reason is an NPF/EPT violation
>   - The access type and permission bits are correct
>   - The faulting GPA is correct
> 
> Three test cases are implemented:
>   - Unmap the final data page (final translation fault, OUTSB read)
>   - Unmap a PT page (page walk fault, OUTSB read)
>   - Write-protect the final data page (protection violation, INSB write)
>   - Write-protect a PT page (protection violation on A/D update, OUTSB
>     read)

Either in this test or in KUT, we need coverage for validating faults that are
reported by hardware, i.e. for faults that _don't_ go through the emulator.

E.g. there's this "todo" of sorts in KUT:

	case VMX_EPT_VIOLATION:
		/*
		 * Exit-qualifications are masked not to account for advanced
		 * VM-exit information. Once KVM supports this feature, this
		 * masking should be removed.
		 */
		exit_qual &= ~EPT_VLT_GUEST_MASK;


Or maybe both?  I generally prefer selftests for maintenance purposes, and you've
already written this test...

