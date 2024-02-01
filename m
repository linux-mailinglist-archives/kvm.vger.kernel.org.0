Return-Path: <kvm+bounces-7772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 587C284644C
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 00:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCFF9B24AFD
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 23:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6DE47F42;
	Thu,  1 Feb 2024 23:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v/wj039i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326747A6F
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 23:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706828838; cv=none; b=fAN3iefRuCHGVht3Z2YCeMpe3I03jvUk8qL6omhMbbFFS2P+lmIzB8iJzbF5uZg7iYyAdoB2Nxz2TnaKMt3jYPaMsxUmvD1IzENBx4HN8W8cmrXzol24+Bj7T2hLeV/AHqLLCq0JbWvfPmWwEbZ/HuVb8PRgyOlWmUpgvRuAnkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706828838; c=relaxed/simple;
	bh=I76CglCGE8XV0CLPk3po7oh0blPqrJkRM7X6uqanmqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dVyGDZNyKzvvbdDrX3mHJYFlTA576mfwsX1c435Y/g6aUlQy7Tfgbu+nVEp/CRI7gO+CurpmqzevBRP2c76ey8PWwHjDkJP7PXjdVhvZh43M2CzHvw/iwLqy2b2rdQ32HQr6KYG5QhwEqbp8rdpxeoat7o/rZPV9HvtXlIi1a9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v/wj039i; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40f033c2e30so13168155e9.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 15:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706828835; x=1707433635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQyhiXqR7IPsWPNFg93pPqSoLhrG9kaVyEGBzhJkkaA=;
        b=v/wj039iFQTYYNKyGnIFFXfOXjWYX1av9EMCjTalRh7urCLX4cwZ8XAk8DSst6Gz+R
         qPV8Z3WfOoGHQ/C1Qyp4FNAZNBjAB7u+vwGfSYX36GFv5HH+T+K7QrRp0FvoZcqNZ4ps
         J/wfoHIobWgEhi1dkenGX37PtSXUjhhZVPFU6OZCzmjsDhvpjiPPMDTjxQ208ZGPomxH
         7UWubrwnDQ9uqOAzkODw9tyHJDCejYxq+0BsJKwIHfLNa81iM4jqMgE/B9ZDz0FeGX9Q
         g5WdMOYgfYLeduWuoia9QY2H/QSZRHd23KUpCC8Re9eB/ANaqpb7t48Z+jzxM5ZcOzD1
         7z7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706828835; x=1707433635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQyhiXqR7IPsWPNFg93pPqSoLhrG9kaVyEGBzhJkkaA=;
        b=U4JXAs2R6Pg2Z/ERAbW1+wk836OKc/NsGhVleSyzzt+vDieLNeiy9QIsPluYSc16SV
         v3jrWQYxDdOhP/Thcd0kWmSeSaO688CE44qJyFUSbxrYAirpMbIWMGDUj2J7AFHWCyoV
         j/RFj3+gfS1ca5WQ4vjA36X3VKWPoHhBZIl5L7JDNSf/SkTdN5VBFR7Gb0E2LMZ1pvLB
         cyfYNYJAsVIGntKSFtnaQvEQahHOhIGa/OWacUSCGyBW2Z6HnmXoGsiKiq4ati2yY6M8
         VEglDxSBxC1NcwTMvbVF6sI/oiRfuVCcVpvjaZT3O8Bd8p6zs7Hpt+jCFWcSATz8iKwz
         Kwyg==
X-Gm-Message-State: AOJu0YyOZS57NSUhUlDnR+WjLfL/ULB7m3z5bGY2+1iZzEJaD2+eUQiE
	4BEXp9jJpJO53RtJy+t11w3+AzWDW+hsVaJqZhPNLuU0uYnv5A1dWGoDThmmadYZ/T/qDLOl2Ad
	fJRTpX3liYi1ta41MEeqkpdbzqDZzkUbBrh0H
X-Google-Smtp-Source: AGHT+IFUyzOP1lFIQ2rqg4+kqhv4bCVr+vDW1FiHVZFCovsKsh7x223pnzRV1uMJ8nFv+NgWISFo2f9cjdqDXi253t0=
X-Received: by 2002:a05:600c:3d98:b0:40f:c655:abd2 with SMTP id
 bi24-20020a05600c3d9800b0040fc655abd2mr99427wmb.19.1706828834811; Thu, 01 Feb
 2024 15:07:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <97bb1f2996d8a7b828cd9e3309380d1a86ca681b.1705965635.git.isaku.yamahata@intel.com>
 <Zbrj5WKVgMsUFDtb@google.com>
In-Reply-To: <Zbrj5WKVgMsUFDtb@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 1 Feb 2024 15:06:46 -0800
Message-ID: <CALzav=diVvCJnJpuKQc7-KeogZw3cTFkzuSWu6PLAHCONJBwhg@mail.gmail.com>
Subject: Re: [PATCH v18 064/121] KVM: TDX: Create initial guest memory
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com, gkirkpatrick@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+Vipin Sharma

On Wed, Jan 31, 2024 at 4:21=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Mon, Jan 22, 2024, isaku.yamahata@intel.com wrote:
>
> The real reason for this drive-by pseudo-review is that I am hoping/wishi=
ng we
> can turn this into a generic KVM ioctl() to allow userspace to pre-map gu=
est
> memory[*].
>
> If we're going to carry non-trivial code, we might as well squeeze as muc=
h use
> out of it as we can.
>
> Beyond wanting to shove this into KVM_MEMORY_ENCRYPT_OP, is there any rea=
son why
> this is a VM ioctl() and not a vCPU ioctl()?  Very roughly, couldn't we u=
se a
> struct like this as input to a vCPU ioctl() that maps memory, and optiona=
lly
> initializes memory from @source?
>
>         struct kvm_memory_mapping {
>                 __u64 base_gfn;
>                 __u64 nr_pages;
>                 __u64 flags;
>                 __u64 source;
>         }
>
> TDX would need to do special things for copying the source, but beyond th=
at most
> of the code in this function is generic.
>
> [*] https://lore.kernel.org/all/65262e67-7885-971a-896d-ad9c0a760907@poli=
to.it

We would also be interested in such an API to reduce the guest
performance impact of intra-host migration.

