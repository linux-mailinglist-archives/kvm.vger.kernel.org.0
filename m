Return-Path: <kvm+bounces-53272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A633B0F78A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E82191C808BB
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B871EB5E1;
	Wed, 23 Jul 2025 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n3YGcbU3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CC7C13B
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753286238; cv=none; b=RihgKOxpHFEbOPs4lpomQ+hnQmmuW6fExwxZ1uWECxohwu/g+l/Jnw7Ij2FK6A2EkK44+3JvM5vMAaSR2SnEleyvJOOkEYoJdy8SRZkmysJut1YfVfRkTUsVxfDoCEJO87plGasfvgk591zv2NSi7IfYnhvWp7Rbe3E3zsy9BMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753286238; c=relaxed/simple;
	bh=6PAkTe1dj1TtO1WACsCPAZuyivpj6xQq+J5+CpFI4cs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YB2+0Eps1fGT/K0MWBlRYywKUfoFxKkYoQN1UcxMinUeBlw9q/ntTadWrwunMK5MopZbHhhqE+yOYTyVEAYNsYWIKHz72gTvOEllcvUIi8bo++YA+glVJQz1VfZHS7Avv+nlU8jtNVFtN6Iatair4M+aT7y2cp+moNGpwpfdmZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n3YGcbU3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234fedd3e51so69095065ad.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753286236; x=1753891036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pnll/DJyW6AHp9YnPp0+5ZkZG0dK6J64xQlXrA23muA=;
        b=n3YGcbU399jZMhaY0C9XwcMWr7uKYBeI4Rxs0DkXBRoRLvdfBWA0CYU63RAqtqDUe2
         QBPfNOgtI6A744ZSeqAmyFWnn0gYZkIGBPmheVP4NtuxOTvPsGYd9bSrm0WfPSD+jH0h
         wnq5wvs6bLVtk9Xmcift6wJqAshdVlL2dmtquDJMQQ/49eygJF5+x+18keWg6OccmVWF
         /iHnSf5inGQARaRs70yMiF6hBT8JHTbROs6M1U/lUV4K4q42gugPuWhGUzYOJ5CWfHp0
         aJLaCU0rRQFG4ms+xuW6v7UD8CWmcrLZiF93Q61lmvv93WH8123Sun6MBO47s+6T9Xls
         8DRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753286236; x=1753891036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pnll/DJyW6AHp9YnPp0+5ZkZG0dK6J64xQlXrA23muA=;
        b=gAuToMd0ik1r/dn2MT43uFUwR5BTZUtDdQM1u27+HQujA6yHhI5kzK6UUYN5flPXA1
         B5uAwjHmZj+gtpU1Pmiq9INSPb58cK2FKS2Lwq1I4cYbXbfcNSJrbcr7DePjIYYQ02dK
         1c7veAn+V4/P4r4I8rpluuE2RbuhsHxpaPV0Mvphs/IUbDaDHh9fUDU4vg5W9ZPnt6rt
         XzbQAuI4QdJTk26PO096gwrXZDWfGzyTni1/+8ty5YpE89zhT8VpaQg9YtfKfB0aNT1i
         CUZiNvuBHh6e1SF5LGTnIVNt/v0YK3nhnvoiUYrBkeHyHmyADS4z5u0RVwXrK4gc3O3L
         K3+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXe0Cg5j5+eaS+/p3aCTUB7zSL2a2VjeZ5+3gMNe+yKv1ClFw2xhi+QwknS9u+ACT5qkpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ4ka0bg0hg7ELMNtmsYMSQB+qdM/pzZ8flLVFALa8lDbCBUwf
	Fh5CgLl04AC+zvkR5SFWNbtF3xHCWwtFeHffStAKkW2IAc0LCP07Tb/p6hcaVZQSEnMpPskc902
	gBNieFg==
X-Google-Smtp-Source: AGHT+IFFztsHdzhGL156gGYuLAl7YBZxBB76oIkYrIz9tRK0i7YqAXFfsNkZmV6Q+PyuD/S0tjzOV1yCoXg=
X-Received: from plgp7.prod.google.com ([2002:a17:902:ebc7:b0:235:6d5:688b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea06:b0:215:8d49:e2a7
 with SMTP id d9443c01a7336-23f9823e7f5mr52579355ad.50.1753286235929; Wed, 23
 Jul 2025 08:57:15 -0700 (PDT)
Date: Wed, 23 Jul 2025 08:57:14 -0700
In-Reply-To: <20250723120539.122752-2-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723120539.122752-1-adrian.hunter@intel.com> <20250723120539.122752-2-adrian.hunter@intel.com>
Message-ID: <aIEGWoM-kY_6gL8N@google.com>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in tdx_clear_page()
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, vannapurve@google.com, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, kai.huang@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 23, 2025, Adrian Hunter wrote:
> tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
> logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and create
> tdx_quirk_reset_page() to call tdx_quirk_reset_paddr() and be used in
> place of tdx_clear_page().
> 
> The new name reflects that, in fact, the clearing is necessary only for
> hardware with a certain quirk.  That is dealt with in a subsequent patch
> but doing the rename here avoids additional churn.
> 
> Note reset_tdx_pages() is slightly different from tdx_clear_page() because,
> more appropriately, it uses mb() in place of __mb().  Except when extra
> debugging is enabled (kcsan at present), mb() just calls __mb().
> 
> Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---

...

> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 7ddef3a69866..57b46f05ff97 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
>  u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
> +void tdx_quirk_reset_page(struct page *page);

Might make sense to have this be a static inline so as to avoid two exports if
KVM ever needs/wants the inner helper, but either way is a-ok by me.

Acked-by: Sean Christopherson <seanjc@google.com>

