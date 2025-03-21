Return-Path: <kvm+bounces-41720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA46A6C3F2
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 21:09:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F27BD46353D
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1148F22FE18;
	Fri, 21 Mar 2025 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="szvwozRf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C692B1EE033
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742587779; cv=none; b=P3qAxMRuPJTDFlDGJMokNCtQvoh4uPxto1xhk7itNT9La6Ncha0ykjzBjFQSwXB1qYWocAybftPZ5P7IUoKAMzO0YMrFMQqTbI2PmwKczYdrFVJZ91AeClEGRoGa/UxjrbDyV1H2fIQLXsyJh5ellG6v/+0t9F1D5ZBUh4h1kPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742587779; c=relaxed/simple;
	bh=j7v4UyN3Lp06V7pnTSO7Y60kFvGuFMETg8UlG/4uups=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZWEb7RaonsgMBrGZjfuKn2kkJ5pqJ2Fw6MjixPp+ZM7iZc+y6bfoWovPgpZgRzAwbVnPzlaT/kvYCxLiJ0J/5akonIneTFxBqdV3L8OdBlwVQ4PKEDoYmKxwV/5HXeLKodtxsS8uLf9MCXP5sG9Zl/hyeG6p47RNW7anw9pdm14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=szvwozRf; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240aad70f2so53855ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 13:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742587777; x=1743192577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOafnUEiyJ1Gb55WuZtMSsEWQiRaElw+RW4n0rhAEXA=;
        b=szvwozRfWB1grVVyT/c9RDVTC1ET42xEP4iJo4c8YjiGcRzYKpcDI1e1HZQ2USUPbF
         JrFVHwfe+fAxVBig+UD8HTBxs5NUeyNRZdf/bqusEu322/HwBHm9BP7JzLBx3qFWRY3T
         E93TCKWRJX0qMxkKG3R0Amitjdvu486yRYvw1eWLFijogyzV1APC1v93DYPTV/M2xbxl
         rvlT+3ZgowlaINKibrJkC2WUUsAz2yb4nvvAGeMQ+Vlo77Bcr9AG4wI+5yu0CtXrYKtW
         +GluraDVDHwbZFLann+YMJFgB5iSldf8gZ5XfJhKKJ/gQhvhg1E08Yy4tZie1oF9f5zk
         KONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742587777; x=1743192577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOafnUEiyJ1Gb55WuZtMSsEWQiRaElw+RW4n0rhAEXA=;
        b=erMbXPw9nSNME+rH2CRmmU+2UdnuD4wdxiSiyzpbAOAfHyosN7NqBkAdcdDA321GHv
         AkW/XoqawYh/iY7zbPzGWjDv0q/W6oHQstJmX07crfGSdWqV7iiHK4rzmITufBK1lz06
         fGGQQUl/JRZoEgL0i4N+bYZD+EqVYXDoid2fVfnQuprn1gZ8RbZg+qfQBh6fx+rR9r5G
         PpJ4dm7yIADh72XW7qxP/PkwuJXykofTXn+pB2PrQ/VYtg7m+c5+qrB0hmaype5XmQO5
         zpfxkHxGT6CcZJJdc5zh5c2KN7hROmxpgHnOpCzTCNB3dKoao/XhDD67LaMqGR60RhKj
         hn7g==
X-Gm-Message-State: AOJu0Yw1U7Gby7L+W0XxgqYlAsDK9quOCr/tOjqQh6GD+POpgm/LEaJx
	oCe64iYkob+zVPVZlEcHb+apTh4xuyyUaFz5ycJxZKjUUmiRN0wT8xaS1TmAq/fp93+Z4l5kMvD
	3wqxMaDdqJAsn3w0R2yZ/ztCTPtJwRPNKmDRh
X-Gm-Gg: ASbGnct+tCroRwjFZCHDJgl0eBO0mdt3lQ7XdpjSFIGcjRCI3PoBHCH7s/9apDYwDlV
	0Xq4ShU3R/rsuH/Sey/WiLhOnUw1GPaHfTkyi43L3MZQt+ATtGUdrYhaihDHyRzkPZLWVdYSTA+
	MS9rdpw6z3AdL0X5mBMGuzFY5LkwCEY6DPk1YuxgzF+veP2QsEQ87Y8RJi
X-Google-Smtp-Source: AGHT+IGvpFGTBfp+MabVEeRllxzafgiPZ/ufd88zI3l9ZzdBHzykrz1eH56xXT4l0ISQ7CCp7LJf4v9pVr8aBdYDYqU=
X-Received: by 2002:a17:902:9a48:b0:216:4d90:47af with SMTP id
 d9443c01a7336-2279877f21amr402005ad.29.1742587776587; Fri, 21 Mar 2025
 13:09:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318162046.4016367-1-tabba@google.com> <20250318162046.4016367-6-tabba@google.com>
In-Reply-To: <20250318162046.4016367-6-tabba@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 21 Mar 2025 13:09:24 -0700
X-Gm-Features: AQ5f1JrkVc_diymZ4izcsLOGZymRKApPTUtoUgAcDro_HwSXX5c65PWftGZjJzo
Message-ID: <CAGtprH-aoUrAPAdTho7yeZL1dqz0yqvr0-v_-U1R9f+dTxOkMA@mail.gmail.com>
Subject: Re: [PATCH v6 5/7] KVM: guest_memfd: Restore folio state after final folio_put()
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 9:20=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
> ...
> +/*
> + * Callback function for __folio_put(), i.e., called once all references=
 by the
> + * host to the folio have been dropped. This allows gmem to transition t=
he state
> + * of the folio to shared with the guest, and allows the hypervisor to c=
ontinue
> + * transitioning its state to private, since the host cannot attempt to =
access
> + * it anymore.
> + */
>  void kvm_gmem_handle_folio_put(struct folio *folio)
>  {
> -       WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progr=
ess.");
> +       struct address_space *mapping;
> +       struct xarray *shared_offsets;
> +       struct inode *inode;
> +       pgoff_t index;
> +       void *xval;
> +
> +       mapping =3D folio->mapping;
> +       if (WARN_ON_ONCE(!mapping))
> +               return;
> +
> +       inode =3D mapping->host;
> +       index =3D folio->index;
> +       shared_offsets =3D &kvm_gmem_private(inode)->shared_offsets;
> +       xval =3D xa_mk_value(KVM_GMEM_GUEST_SHARED);
> +
> +       filemap_invalidate_lock(inode->i_mapping);

As discussed in the guest_memfd upstream, folio_put can happen from
atomic context [1], so we need a way to either defer the work outside
kvm_gmem_handle_folio_put() (which is very likely needed to handle
hugepages and merge operation) or ensure to execute the logic using
synchronization primitives that will not sleep.

[1] https://elixir.bootlin.com/linux/v6.14-rc6/source/include/linux/mm.h#L1=
483

> +       folio_lock(folio);
> +       kvm_gmem_restore_pending_folio(folio, inode);
> +       folio_unlock(folio);
> +       WARN_ON_ONCE(xa_err(xa_store(shared_offsets, index, xval, GFP_KER=
NEL)));
> +       filemap_invalidate_unlock(inode->i_mapping);
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
>
> --
> 2.49.0.rc1.451.g8f38331e32-goog
>

