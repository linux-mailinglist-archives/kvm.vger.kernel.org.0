Return-Path: <kvm+bounces-59945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 39990BD6981
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 50556351A81
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 22:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A161A2FCC16;
	Mon, 13 Oct 2025 22:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M+x69ki0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7225E296BC1
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 22:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760393762; cv=none; b=OfQFYVQVKPzyxataRpjjeO6bnVpqqeiMT/UvP04wPvb8yXzl+CPKQMvzA1dRZNR7BZC3Pd+cUZdmDL2vfDj+q0jvQ5m+cfj2yw/Zsq9RqtCQ3vN/WLE8oSO04jmhQmwEQU2oCLBHWFHBHwuYMR/1mD2aObwjkLUlnlHBhWJqBJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760393762; c=relaxed/simple;
	bh=EsI8Pj+TMjNMEvffwJXPkIgDDGEuZTpDpvzf3MMl4Xw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GAqJU0CR8dQk27lGgAUqsILNdYC+azENRQPdyFlcpV6ZmZ8ICzpGEtybeYcj9O1Gb8S32IQTD/ukjgpyLhg/l7C3CYuph4f9iIxluxdYyW5A82OW7/61EhXlXIouk3esMuW12KMBSRK/d2KWRYHopvRPqgixJI01GH46poMQ5Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M+x69ki0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339ee7532b9so24204530a91.3
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 15:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760393761; x=1760998561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o5tbyGlkKL3So+hBiWC82PGLyzixJzG0YKnqLTUBX/Q=;
        b=M+x69ki0ocw05tkIMCB6v22E/8G+n9YCTUNObfcztT/wvtPSkefIbeiwlPxO37KtOz
         bGT1A9UF12WrNSaU2MOulpY2ELh3Tz4+zQntwIqoeSqFsVp3Hp8fkWkUK7r2OnJq9YJo
         2kQQb7RLVqfe5E9SAorGtOyK5vlzZy4dZeNZPUZaKwCNgRl3iek4KQBB8ivf+g1C+xfE
         0SHwUTtLXzzF/+GoLS1YHLDalnDI/TTdxJm+FiMskZCt7Tj0H/xDf3NrIF07s2JeCILO
         pCp8a/BKVpIKrdGeBSlaUN0uzFdftPdcG7ea+sEO/hlq6P19xrR5I8tWrAUtPsDzYjnF
         y8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760393761; x=1760998561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o5tbyGlkKL3So+hBiWC82PGLyzixJzG0YKnqLTUBX/Q=;
        b=sBbbCUCCPUdi8Ykswkxf650RE8tBwynI+ojYUM5LCAH38wcHrZxTSSz9YN+mOaI0nF
         DW0rsVrqZ7Zi9evnOo0TA7O2CrsX+0GA52jNN8zWVLpRzbbg4Dp7+TYsX2JpekHGnO2X
         SNrDsSy1vUCQYb0o8dP0S/pkx7xX3OrjamiIvl9AgNy82wmFwlZN34WxgXG1I9jF3UMQ
         6EBwCnHvd2p79rR9C+MlIvbiSR5i17RTXR0nL2yQn4bw8rzu/or4x4SNXmGFr39RkR+k
         yEsLSt2HWnU9fMI8khlvd3YYgivSqFXvmQyHafF06Y4qFvf9VTNfijNpDVp3TYiz6GT9
         3u2A==
X-Forwarded-Encrypted: i=1; AJvYcCUwGQL+8ZoF5bqQV+bg0IThJeeY28iv/rMlSZTGesCK+sZlfMmKm/P6Uy14HcMfQU9jiYw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9FvoiwyZ+0mUNzoN6atNZN2pD3AMELbF8EQlh9T592EGHEB1i
	5gyYzkNhEBF/adSZX7PXN+JBlhwnWwKn6pEgFQyn0cWOreIGJ7jnEjqHHRItDZOaK2PTHDy/5s7
	MoFzsPA==
X-Google-Smtp-Source: AGHT+IFUWxarAg7wsogLlrLQavveY10BjaBC0NiGpa23EdpXu+4jZCMden6QCThEaCSo0ktYnzwUV/xVzQo=
X-Received: from pjbie2.prod.google.com ([2002:a17:90b:4002:b0:329:e84e:1c50])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b50:b0:32d:a0f7:fa19
 with SMTP id 98e67ed59e1d1-33b51375940mr34746129a91.17.1760393760740; Mon, 13
 Oct 2025 15:16:00 -0700 (PDT)
Date: Mon, 13 Oct 2025 15:15:59 -0700
In-Reply-To: <20250916213129.2535597-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250916213129.2535597-2-thorsten.blum@linux.dev>
Message-ID: <aO16HySFc6wNVpix@google.com>
Subject: Re: [PATCH] KVM: TDX: Replace kmalloc + copy_from_user with
 memdup_user in tdx_td_init
From: Sean Christopherson <seanjc@google.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Thorsten Blum wrote:
> Use get_user() to retrieve the number of entries instead of allocating
> memory for 'init_vm' with the maximum size, copying 'cmd->data' to it,
> only to then read the actual entry count 'cpuid.nent' from the copy.
> 
> Return -E2BIG early if 'nr_user_entries' exceeds KVM_MAX_CPUID_ENTRIES.

I think I'll drop this line from the changelog.  At first glance I thought you
were calling out a change in behavior, and my hackles went up.  :-)

> Use memdup_user() to allocate just enough memory to fit all entries and
> to copy 'cmd->data' from userspace. Use struct_size() instead of
> manually calculating the number of bytes to allocate and copy.
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
> ---
>  arch/x86/kvm/vmx/tdx.c | 32 ++++++++++++--------------------
>  1 file changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 66744f5768c8..87510541d2a2 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2742,8 +2742,10 @@ static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
>  static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct kvm_tdx_init_vm __user *user_init_vm;

Any objection to calling this user_data instead of user_init_vm?  I keep reading
user_init_vm as a flag or command, e.g. "user initialized VM" or something, not
as a pointer to user data.

No need for a v2, I'll fixup to whatever we settle on (assuming no one jumps in
with a crazy idea).

