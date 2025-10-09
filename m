Return-Path: <kvm+bounces-59739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BD3BCB1A6
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 657DE4803E7
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4F1286D40;
	Thu,  9 Oct 2025 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vJKZSjqZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE7C223DEC
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760049287; cv=none; b=mxhVyoxJiMcNTn/biW2IbgP4hV8tIJNqbmDMlwKQz6H/p8L+hjIiSUjL8XCtI2e3kxacjO6TyZMx1tN+P0D4Cci6/6nJ2nllfwNgzg1tFzBPKW1OBtpk1hYO5YofhO0xJw4NPSA2HzAqyw6gT+/LBa2MCOv9yf2SbF2c2mt6AM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760049287; c=relaxed/simple;
	bh=9jN7yy4faemkFk4CnVeK+ylZLzuZ08PbRW1aI3m6yEo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l7EP0XP9welEITjxF6wuwsR94jP91iqShnrVB0vp2PsbBw/rBxnCLgz5PbjB/WXR9Au4My0sIdobNmk0SOv3s+alfFjhBeTbNJtvxA1tIVTcLiz+IT5T+sWc4x1tiYVbjcVARImcSENAskmqPlvWrDmED6R8ILM4LSv81GjgPvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vJKZSjqZ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso1954453b3a.2
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760049285; x=1760654085; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+k+gk6VQNvvMox+c8DfhOTxAsmkufNVxeH8bt4I1AGw=;
        b=vJKZSjqZ9kuwQ8GJa4DlhMc5aexAc6Gf2CnjKpZw9HxfJAF1ORUZ6zXdLnslK3WSQd
         /896TxGuO8Hk2CF96t6kNNALf7mBJXmDv6MtqOAZW8oUBWsbH4IkEMEbeVSEBjo6NsUz
         xtk9PZtix000TQk/NRnJgxT5R2BT5zxMpON2ixwhG2MpQ9cMYe1tsj2EAQplDGOIB9wn
         ZV6jfvHWbq8WEMFJdJPxvx+xmTMm/ZlHD+F+wgnoSJ+pU/RWALGx2U2B0iCBF+bDC7s/
         +ekqf6ZUe78STuJkah/mehxr1vYDao0CB1ZGOjxBF6Ac2nE/tWZnsGHuY6fgOS13+PTQ
         F2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760049285; x=1760654085;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+k+gk6VQNvvMox+c8DfhOTxAsmkufNVxeH8bt4I1AGw=;
        b=UJ8OkTp70orADi2PWL18221pQOVS2aktfqVPN6jNMrySMs266P0rJVGTUGVTbYdmai
         mo4ynm7nI5uJm57ieBuEdo5uL85xmThCz6qbNbHcrqoTYdIzxQ7hjgsqPuBTt2ag5ZNz
         TawgbZw6WDOJ2sfC57WoThxZ+eGu/aQ4EFSKU0MIJ0ZmDTfEge/U58eZbREiPFUy3YQe
         lTeW+MtO5YKLDX8T6PLklPJQ6O0xAWUK/UNOVIOQyyJozJUXeeV/g8haS6MVtrBhLP7b
         i9AcZmdil43o4h0RaUe2y/HqNMi9BFUZp0z6+ofO43F3JchkChNc2m24t+7PZjMIYtvJ
         0G1A==
X-Forwarded-Encrypted: i=1; AJvYcCVjk0Uhd8F0dwRx5xq/IpKprfboHLvA6KCHEXrRLH00reFzOpnktrUPZhRw/A/fvUpz0Xo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCXItdEviLTKyKZqI1srmeA5RmZB90fCUMckknbjZTE1MLn7em
	tLKO8KE3e4nTkng3zMm9Cp/2OgoB6bAWNzgOw+RANU+UEHVl2+LuzsTEkp93y28JB05kB7ZLlsi
	ISG9M/zlhx6FS+i64ls/l7BhgdA==
X-Google-Smtp-Source: AGHT+IFT3+ACqwDT2lCoDe9XM9NV6pIpsUJnUvsrRoGgkm257Ov/Ea7I3q36/zx0MsZeeBCKYpcs1LHgia7b4IPfmg==
X-Received: from pfbgu11.prod.google.com ([2002:a05:6a00:4e4b:b0:77f:3d60:9807])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:391a:b0:77e:8130:fda with SMTP id d2e1a72fcca58-79385ddc9f9mr11632278b3a.13.1760049285570;
 Thu, 09 Oct 2025 15:34:45 -0700 (PDT)
Date: Thu, 09 Oct 2025 15:34:44 -0700
In-Reply-To: <20251007221420.344669-9-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <20251007221420.344669-9-seanjc@google.com>
Message-ID: <diqzfrbrhfgb.fsf@google.com>
Subject: Re: [PATCH v12 08/12] KVM: selftests: Add additional equivalents to
 libnuma APIs in KVM's numaif.h
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Add APIs for all syscalls defined in the kernel's mm/mempolicy.c to match
> those that would be provided by linking to libnuma.  Opportunistically use
> the recently inroduced KVM_SYSCALL_DEFINE() builders to take care of the
> boilderplate, and to fix a flaw where the two existing wrappers would

Typo in boilderplate!

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>

> generate multiple symbols if numaif.h were to be included multiple times.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/numaif.h  | 36 +++++++++++--------
>  .../selftests/kvm/x86/xapic_ipi_test.c        |  5 ++-
>  2 files changed, 23 insertions(+), 18 deletions(-)
>
> 
> [...snip...]
> 

