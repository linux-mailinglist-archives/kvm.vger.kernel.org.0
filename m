Return-Path: <kvm+bounces-55037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CED42B2CD5F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 21:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 054FD3AADFB
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC46831E11F;
	Tue, 19 Aug 2025 19:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MekgsoSn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8223101B0
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 19:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755633137; cv=none; b=kBllMLBNm0fiAF/91JNBvddqaFNifbibqxGCuwOSEVybXjDEYtzvoPypo5WcAKB+LgGp3AFtuJmkXiN5f9xJ4QlYPp94zvM+xigXK960FiDD29HlF11f60zfzjh5K9a8FMxRG5YM/CLxkHH/wk59R3n9WK7TU2JeoRRNpSKfgKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755633137; c=relaxed/simple;
	bh=0sozDLdExk4TXDPAbLlvtjYjRMNIf2zw8zW+AEC0+Vo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bTR/WwZDFSydhEx5CguE9LYUj/VM4viGLnQ7QAftwF8sePnFiPL28Yyx55x2CnXe6otZDHRMX2d70PdaiMbK8YAvHJu7sJo9qY41mDTygT905D8yjRpC00RqQwBE+b/0qi7vN8jq59yplE3X5GvlJ8tjl6/PimAg7DSbKT4Ge7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MekgsoSn; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-242d3be5bdfso39975ad.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 12:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755633135; x=1756237935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oh+5SXJ8jwRghKiHuR27o1N7jn63j3LWzKXisi5w8vo=;
        b=MekgsoSnsCsxx0qE0Rygygu4Hjp7XsLreZC1o+h9wSfCI/e+7sSxI6CfU0tHGKTL8R
         1ceVa0U2dULV59eVI9J67yxvy9vt34yh3Abxo80Jq3MbvTJqvjmvfhtcTMtQmr9o8yDd
         sOkAfOZwER62RMme4ZAYu/yMyZJk8jKPN59UPhQ/hoWX6hhI1Z+jp4oX+gl05AgbJVYM
         M8Qm/yTOMRlvdUvna902Pd5hyAVfz1yFii04ZIY018olvfbogpkYR3IA6CDDwB5wgnGD
         nbvTDlIyvBwyPWso72BBmzLqwbLEw8DVVpGzqTusB+BdUhhOPcNPjFE1s2pHir2DNOhO
         dWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755633135; x=1756237935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oh+5SXJ8jwRghKiHuR27o1N7jn63j3LWzKXisi5w8vo=;
        b=ZpuQUPu6BNxjM2vAybwb27UFDz2QQwrLroQUSBFtVvDlCEA15Y95K36b3GPcXPuR6r
         jtPhHZst2//IIebIwo5hBCU8wKQg1O4TRDPRa1qgH3Yie0uR8zGSWAhyRdVPTeMEpQ1z
         q3jYnA9n0K5VvHdWy3TDFfoVgfoa8ql4J7ZDF+RU64w7T/rzuJGRYpOZUong+Z+V1XRW
         oEBZ4M+SweQ/5ux1PMsn2s3xvvfvYckHFJrs0sBYPPUdFxnBNNXaj+hXKE1fV0WKT0MO
         lhL9/2Myh3amxLF5Un2+9u05gARsdcsq9SGes5CpsXAjCOgmT3M3FZi1cfYwlW9/xhgi
         PGGg==
X-Forwarded-Encrypted: i=1; AJvYcCXq8KtnGeCSPIne+XQbU1BWGDPEex3dlXoFRycHPNxBC8FlrcaUqxVlmcnxFAtkjR3fSfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl1Lr1VwVoNA2N9E2rt6MOuyqkVoeoem+U19elMovStoN7/529
	B0LzTKwxMY8aVpVzYHmEjL0nlZi111ZOnuhjXD0N0iFS9BLji0raBGyMPqm9OtHWJ0Y0kDBkRqi
	1oeLteoOUig0XJcVMjPKCHjKz5B0igYXPj0cpb0ar
X-Gm-Gg: ASbGnctH4NPgZh/88+eESVPK20nKJtmf6eJxTa8z+dRrINrEaNN0Gcfh7kwdNzg0nQk
	kNTpTFPAl5pwiQ9e45/Sc2SZialNYKmTJCYvKjlufy7D9n+7cclHBwI14CsRT9PEi34404eGVm/
	jTQ+YxIJGRYwQNvYqt+ZUPYSeiQF18DJghw8ylIj0zhVLGQgldfpMSKJJdITKwYqXoz6zvHcKjX
	nr2owe8vwgLngfswk29BvVmElynzfpopKs1pEMc4+S2wxaXE3Lazbo=
X-Google-Smtp-Source: AGHT+IEJpI8p7NnvP/c/59FjU/wf9B/5rXjt/otrwieXuwkOUkHzVDMcgSlT+2mX7NEyFWVr6PWEvalh0vkaZ2IjDjE=
X-Received: by 2002:a17:902:f54e:b0:242:abac:2aae with SMTP id
 d9443c01a7336-245ee9394e3mr839915ad.12.1755633134713; Tue, 19 Aug 2025
 12:52:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250819155811.136099-1-adrian.hunter@intel.com> <20250819155811.136099-2-adrian.hunter@intel.com>
In-Reply-To: <20250819155811.136099-2-adrian.hunter@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 19 Aug 2025 12:52:03 -0700
X-Gm-Features: Ac12FXysLHdcINRFHicQ-VtnUWBRJdLVcQCFN3WT1zgmca0lszc3C194HxKOgCc
Message-ID: <CAGtprH9PdJDzZb=YwOSpFjgNjn0W2K6KFsJNwuEgCSBZ=9f3vQ@mail.gmail.com>
Subject: Re: [PATCH V7 1/3] x86/tdx: Eliminate duplicate code in tdx_clear_page()
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com, seanjc@google.com, 
	Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kas@kernel.org, kai.huang@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 8:58=E2=80=AFAM Adrian Hunter <adrian.hunter@intel.=
com> wrote:
>
> tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
> logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and create
> tdx_quirk_reset_page() to call tdx_quirk_reset_paddr() and be used in
> place of tdx_clear_page().
>
> The new name reflects that, in fact, the clearing is necessary only for
> hardware with a certain quirk.  That is dealt with in a subsequent patch
> but doing the rename here avoids additional churn.
>
> Note reset_tdx_pages() is slightly different from tdx_clear_page() becaus=
e,
> more appropriately, it uses mb() in place of __mb().  Except when extra
> debugging is enabled (kcsan at present), mb() just calls __mb().
>
> Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Acked-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Vishal Annapurve <vannapurve@google.com>

