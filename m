Return-Path: <kvm+bounces-65638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9CFCB1955
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9680F302CCBB
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C10922128B;
	Wed, 10 Dec 2025 01:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CXP4MlHO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212ED21A92F
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 01:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765329277; cv=none; b=gb8LR5hql4HWo919M7iPRXNAei6mGWYHK73mjGcP6NcMAx8/sBkJb8sQytqX5LU0wcQ1Cy11qUtHCoaME1a8sjhbdV16BN7djOeZpIwYSaB2SWiJXezkWMS7GR6EmoTKJoN4nHQtvLpYPO1snglLGm6XFutpP9YJfNTOvQBZVb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765329277; c=relaxed/simple;
	bh=dLQRgEDj0Vy2eLTA3JA8PCdSfYhHFQFPfH1YQridppw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eic+cF8r+IMYOfvhWoZReaPRrJjn62I6QMlhq/hskwMGy4sjN1XhYq+2HuMKXRKX9SQeUp1Ormgap3J/YXL32KBbMTy6kLym2aM2AvwXYr7mGslVd1m3W48NsL0oIds54DzqWMwnUvEG8Q4CXDGIeGZxUlzTI1HTzkkmnRdtRG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CXP4MlHO; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29e7ec26e3dso92285ad.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 17:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765329275; x=1765934075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FSQVT2VXJxmQcI5luIYdnADTgyF/2rvwCBSOX6th+kI=;
        b=CXP4MlHOVWrnqW1PPbLmZan/WpklQJF/3xhvCqSkrMYO2HU84h+iCL8rZy6Eb7XXxp
         2T5jtEFsAVp9Cp/x/ezazCvFsiqaVfyoo5TLzNAkbL0NVK/VNOvxmEvSk9rzoAvqUo6a
         jIQqVvfo27nASCXvBS3NKLC6D+U0bPkMJBZv4YwAMX1GpDM9J+6qIjVsHQKHusudGef4
         yqmRhqDfdyETXir/Ig9S0ezgraY7WjBgb0QcejUOxNgy2rh/Jr1fCLP/cSJjKvk/jNc+
         7VREAGXxe8Ykpry3GL0rqgUp/zxXAkc7EUtS/C7H0/+h9iBCtrzBH9yibn2q1axH6RpR
         SsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765329275; x=1765934075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FSQVT2VXJxmQcI5luIYdnADTgyF/2rvwCBSOX6th+kI=;
        b=IxF20IASHUATXxX6zOn6v9D3m07acaj70uU+FEzVhsiOhuLt3iGOs/dD8Muth6jCeE
         3Qyc70Ox7L//GEZx8JFjf/xkWGLlvSI+ZWPUE61pjLsQpinyNMuvxblFEHH5YZhdWp2l
         j/K8SjG4K7TUtVtNqk5yyovlcrlPkLHz7YAnwP7cONkY4WXTZ+B6AumiDco31561guH6
         oWns/kqhyDlM3sF9XRAdJyHrJGGW4sQ68URDPkHrGuyN4glOnxsmw47GdWP3kLrjaCa4
         1B86jMB2363xyQQHWzRH82DinTHHGJk0N4081KIfUsP4DhoMzWMngcczxklNKnhQMpUj
         ySQA==
X-Forwarded-Encrypted: i=1; AJvYcCU0jaFOj0Gh01A0/yXmTqE9iMIJme9d9uNGnTZZWgePkt/8gKvo3U0NXZqb7M5XwI3lowE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdC+251AHlEBafItqWL0YqfJE9zRdLmYd+tNHd+h5FEGYStDIC
	nUTL/URKvVafhrXmfSy7J4SAcueRcAyY0pTS1KB8sFUvu5dy6nySCfxFj8x7sYUiCgG8cIgH7ft
	Sq6i8pqKH9Jfe5+lP5YCSVRChTJKk2KhDO4LKkZD/
X-Gm-Gg: ASbGncuOa0wJQqru6qLYhNp8r7cipncNWDy/U2TJ4fHjoq1fOhVVPOhAjaJTJ998oBH
	I/8atxvlJkOg6zaCdYiidS+oJWFU4rHoJzvvnIWG+Ti97d4uCy9stlWijDX+zPeVtwCLej/Glg+
	Gnf15FAHwGLOsK2sUCviqAJrEyk6Q81SqwVLGgP3Qr93yhCkiz1wS69VxO/J1kGhOmwsTUV6lIK
	KzR082KJj3m9jDDuu+mcYFCqT1WkcjeFnHnXQGosnT9eU9jDotEY+nBf11GpSD/4JPHjJM2hB95
	us/N0YJLzlAJjVDP+p51RpLsqA==
X-Google-Smtp-Source: AGHT+IFopKRKZjpKnrTUqMRN/xWm6VHYLazcqoktYRhRySpaeCnm+aDmHI9Mx3XpMzLoisyqEENVW3tiTAwNL3/7AMQ=
X-Received: by 2002:a05:7022:305:b0:11a:2020:aca7 with SMTP id
 a92af1059eb24-11f28e640aamr77483c88.2.1765329274903; Tue, 09 Dec 2025
 17:14:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094202.4481-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094202.4481-1-yan.y.zhao@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 9 Dec 2025 17:14:22 -0800
X-Gm-Features: AQt7F2pL-QbeL9wB48jfU4g42XYUdUsacZRiQCMvv8pJyI3vjfcz9WY4Ec_Y8CI
Message-ID: <CAGtprH8zEKcyx_i7PRWd-fXWeuc+sDw7rMr1=zpgkbT-sfS6YA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance tdh_phymem_page_wbinvd_hkid()
 to invalidate huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, thomas.lendacky@amd.com, pgonda@google.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 2:42=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> index 0a2b183899d8..8eaf8431c5f1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1694,6 +1694,7 @@ static int tdx_sept_drop_private_spte(struct kvm *k=
vm, gfn_t gfn,
>  {
>         int tdx_level =3D pg_level_to_tdx_sept_level(level);
>         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(kvm);
> +       struct folio *folio =3D page_folio(page);
>         gpa_t gpa =3D gfn_to_gpa(gfn);
>         u64 err, entry, level_state;
>
> @@ -1728,8 +1729,9 @@ static int tdx_sept_drop_private_spte(struct kvm *k=
vm, gfn_t gfn,
>                 return -EIO;
>         }
>
> -       err =3D tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> -
> +       err =3D tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, folio,
> +                                         folio_page_idx(folio, page),
> +                                         KVM_PAGES_PER_HPAGE(level));

This code seems to assume that folio_order() always matches the level
at which it is mapped in the EPT entries. IIUC guest_memfd can decide
to split folios to 4K for the complete huge folio before zapping the
hugepage EPT mappings. I think it's better to just round the pfn to
the hugepage address based on the level they were mapped at instead of
relying on the folio order.

