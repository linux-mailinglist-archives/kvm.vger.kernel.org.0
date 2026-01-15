Return-Path: <kvm+bounces-68222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C072AD27683
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 27BDD3153CE2
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395403D3317;
	Thu, 15 Jan 2026 18:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DVDmN8C6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DD43D301C
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500373; cv=none; b=h3Kybuy0m4/eQ/rufOcd3SuXxchTaiSLhU5mZ3U++SVYYo5rlpOHsjf+h3Ioq+7Ck9vS4rA6QJppNB5jIMuKm+oQD7dp1d0qkCjOhUjKNTL4C0xSz0vA4LpcKsaw1QTfnF3RxNnoEBDGQu3FKFlcs79oahYu44qZS3DlmWFMu4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500373; c=relaxed/simple;
	bh=Exppa+fvFnZDSzfgEoO0isPt4brqzr+0/NQtFqU7kXI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CLBWs6PkR7MBhJvQCyDV/fbjXU+fmuq8r8+iTFhpQy3k8mWhVLs8kS70P+I8tirzO7HttHUxA5RFVvYXbbEv9mNY48V701t71tViscaUUEy86rFsIdTv+0jpLZwTp1+aGcKIp+ETYvp/2le5BDQqGhh1iquysTwvyg2Mp4nP3bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DVDmN8C6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c37b8dc4fso2165336a91.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500371; x=1769105171; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1uqUPVaTEkff6wsfE3L2bqEiARCuGC2uqb7juZRSNZw=;
        b=DVDmN8C6Z4LwZ7FgbX3fPdaCdCLV8ZdnA72rSc3vFdNtr1d2T4r+lGkzEX6OLQdHcL
         iIFPKfeOa2lA06z40/P+KimI8nZfZGH/wVbT0yzlSBrh+PqYUbDH6+cM2SB2YYiEROT6
         kZ0nGhZ4WJhU31Ojm/6BxII574kgga9yFdlQ+nnPH45QPIty7lfXoW2zbQZd4N0G1jx1
         5rkOBkGhci6SfD1zzMuGjzSmzB2o8MInnLHTc6yBQuWXQUoVKzASrAS08RZ6NT67MOXg
         gbZ7SFVHSlXdtvKUt4BFdnSNHYV/Q1PSbQF/U3zZCr4pbEy+iDLTUo4aqJ7/jFtCF33b
         J7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500371; x=1769105171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1uqUPVaTEkff6wsfE3L2bqEiARCuGC2uqb7juZRSNZw=;
        b=FHcJp5Ko9jzHVDmotrinQ6XAl48oNr3IcWNGl2+A/l9oHR+JDSsc60IdyabsTPimpI
         hhBwjPg3TepS6BopKT9DQlACGe4Ht6W02FuJa39hjUmxqlk1Qnz0Emq0Ca54ql0kOiAC
         6pRVyVUQ9g4WTpCpvEOhO22hW+wWv4u6GgQ1u+zc5caIZel1ZbVV0207QGf9RcDMWRce
         yJB7zeSZxkaWYkY+NTqzz+Djn3MgO2z4yVeyGxPL2kqv6DEHutN3f4KlCzD7s7CcMMYY
         2yvojUc8R3m+TU8Ky4zJXc5WuL54vI0Wd9Mkv0WHZ2/drF1cbQBA2eUbncegEUoR/F5A
         Weog==
X-Forwarded-Encrypted: i=1; AJvYcCXJ6yOZml061dlDb2y2aG0kdWRlc6f2vtEhzQD9eT/3JVJQfuqCs9YViiFRS+yNMxxA1eU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrQadLcxZzBaSDJNYVwvBGJyNzBxP+T1hDX8PTeYU27O/92B6G
	tvDG8oCJM9RdRX1C5w0OClgoQ5UTwrM7+aniOBoLEVsBT+raHizFSAqOFtRFcoXdQfE5Jn3BR2P
	XPckDig==
X-Received: from pjzg6.prod.google.com ([2002:a17:90a:e586:b0:34c:2124:a2b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:37d0:b0:33b:8ac4:1ac4
 with SMTP id 98e67ed59e1d1-3527329c896mr168776a91.35.1768500371573; Thu, 15
 Jan 2026 10:06:11 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:23 -0800
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849903000.720660.2401438098975748028.b4-ty@google.com>
Subject: Re: [PATCH v3 0/6] KVM: guest_memfd: Rework preparation/population
 flows in prep for in-place conversion
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	David Hildenbrand <david@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Thu, 08 Jan 2026 15:46:16 -0600, Michael Roth wrote:
> This patchset is also available at:
> 
>   https://github.com/AMDESE/linux/tree/gmem-populate-rework-v3
> 
> and is based on top of kvm/next (0499add8efd7)
> 
> 
> [...]

Applied to kvm-x86 gmem, with the tweaked logic I suggested.  Thanks!

[1/6] KVM: SVM: Fix a missing kunmap_local() in sev_gmem_post_populate()
      https://github.com/kvm-x86/linux/commit/60b590de8b30
[2/6] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
      https://github.com/kvm-x86/linux/commit/0726d3e164f1
[3/6] KVM: guest_memfd: Remove preparation tracking
      https://github.com/kvm-x86/linux/commit/188349ceb0f0
[4/6] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
      https://github.com/kvm-x86/linux/commit/b2e648758038
[5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
      https://github.com/kvm-x86/linux/commit/894c3cc35b89
[6/6] KVM: guest_memfd: GUP source pages prior to populating guest memory
      https://github.com/kvm-x86/linux/commit/ba375af3d04d

--
https://github.com/kvm-x86/linux/tree/next

