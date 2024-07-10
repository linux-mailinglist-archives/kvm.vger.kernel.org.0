Return-Path: <kvm+bounces-21342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A2492DA62
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 22:46:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 662321C20A7A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 20:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A934E198A11;
	Wed, 10 Jul 2024 20:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CU0wMyne"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F096DF71
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 20:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720644404; cv=none; b=FcYPR8T6I7Vw/FMcEyBl4GidQQE4Ho6/c2AEuqcfBHI9DE3Ak+2LHhvGvo2aQTT45U3r1c96c+pscJ/dcnkX8MSAPIX0H3HUjdbUgVFZAwRb/SNePvd7HzcChhyQCj2U/n3HiagzOUDoa6Bi1o0HyBTe2jFtw+loQIJ5MqIwbEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720644404; c=relaxed/simple;
	bh=d/wF/+1szpn74odmbOk4Ueqm33+P/Ge8CGNfNiGpOXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d0j1n7b80UJhWQ7aoI9s3M3QCe0ij/UkrwwMGH6R/+J+Sj128h8HZzgmcF8mVMBv6TAWg5GhP3JxEYsXFILzhDD5fCkCQzm1gKZJVH4Dw3zV0t/v/wr7EudVDJ44tKAWusebnyptKp3fKbMbitjdOfhozmCus7iBsAWoEQZ9a6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CU0wMyne; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-25d634c5907so137146fac.2
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 13:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720644402; x=1721249202; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6F3+lAkPEQaUNUkz+HZyDAW2CgNWSyFvymAUJjriBA=;
        b=CU0wMyne8FC+btzBmO1h3IXlIvPB6LTzB3BaG9p6wgmi444FclaGv6Qb0/7dsgo25I
         qqnKOq3zxENDzndyc7LG5kVLd1vx4ERgeApEHA/HsWElbznRbQRMgtHkaD6wASp2gLJu
         ZA7i+GWVaNzJlkbcvP6staQ034yq+qgdtnt8jbaJM3wRLqu6E9n4pcZ3mlcJyqkgmVts
         KWkgF2xOSwlKAzkzhD88sBojU+OtxoF4CqXRhiWyqO/EH20IfBSeLHyt8Kej4RmcUgB6
         OjD0twIwrWAZgRnSzDCQLosSHc/42wT+iijR/wR8/D+KFrMdpeM70j4pBH7NFbxzz7rh
         ZYbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720644402; x=1721249202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6F3+lAkPEQaUNUkz+HZyDAW2CgNWSyFvymAUJjriBA=;
        b=k4fz3i7xZeBDNGmbE5D9lX5Dl6fmyyX6bFRMW11FQT8eU0PipVua/fW52tcHd78U++
         31NMbHnoCTb7B2mW3HDyJdCln8mj7Mv2TaRYzBfOCIB8bQBZEvTPIaIIqI5DN+GtxFWp
         QqKPg/yA13hwEuN8NbSatmTyEqEPd2tE4vytPsOyBD+vDOl3SNs4WQsKiyof3Y8Uecil
         KwQRI0HG+hcJC+wqUFdc/BmqZ76VOV4qb7EYt3YMLQZgxkDgXusvcn4K+tQsqGC8fCFJ
         qmecRLXTyMzGEOJZ3bZylksDJldsVz+Pff5H5VdY448fmXvmsDfo6bbDflNF6Dgy2pxq
         NBPA==
X-Forwarded-Encrypted: i=1; AJvYcCXEeLxKBeLhltGnaXOBKl1M68cmexla/F0CXbWxm1ksDplUBbiLVtkxTNaolyr+Fczh3NxRlLfLVyT+1J7Jap9qLM0E
X-Gm-Message-State: AOJu0Yx4zRWQr8ogZ8P8OzK8WQNazXl0px+L5q4kWpWZxoYuThNYRlhl
	mb5hvPgYgHdSQ2i5eFe4pIrI/uaJRQjsnbOhXGm/o8pbHSSwtNi/fjkDxfa1ow6wNIIwWIb5W+s
	bnw67xMLVOHNRrqvipQvAGGvgEBixPcuuJOC+
X-Google-Smtp-Source: AGHT+IHD1pUbDguSz3tSAdKmeDxXAVUwdA775CP8W5jvdh+VyIuiUP9SiOWpO0PMRvWwtfyaygRzVjQpA89XTrIeujE=
X-Received: by 2002:a05:6870:5491:b0:25e:c034:31d with SMTP id
 586e51a60fabf-25ec0340354mr4342969fac.50.1720644402407; Wed, 10 Jul 2024
 13:46:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710174031.312055-1-pbonzini@redhat.com> <20240710174031.312055-3-pbonzini@redhat.com>
In-Reply-To: <20240710174031.312055-3-pbonzini@redhat.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 10 Jul 2024 13:46:06 -0700
Message-ID: <CAF7b7mogOgTs5FZMfuUDms2uHqy3_CNu7p=3TanLzHkem=EMyA@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to
 pre-populate guest memory
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, seanjc@google.com, binbin.wu@linux.intel.com, 
	xiaoyao.li@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 10:41=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> +       if (!PAGE_ALIGNED(range->gpa) ||
> +           !PAGE_ALIGNED(range->size) ||
> ...
> +               return -EINVAL;

If 'gpa' and 'size' must be page-aligned anyways, doesn't it make
sense to just take a 'gfn' and 'num_pages'  and eliminate this error
condition?

