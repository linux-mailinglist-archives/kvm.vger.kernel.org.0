Return-Path: <kvm+bounces-24233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCF59529D6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 09:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4135C1F23116
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 07:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AFD17B4E5;
	Thu, 15 Aug 2024 07:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JEFEUfOa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E5118D65A
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723706712; cv=none; b=VbAjn8K5XeLxcNqVgH0TWZYm21rmGnPEToj1kVBipZDtd6aOCBk4DOlFKu4pz65XEtNH7kuGiGa3IMsQqbHWbnOhDNMtSGPT/cR1ZbIESwE54ACc/C+fJXgj19lYVjxbIHn/SMWPWYUw3vSnX6KRt6dr5RruaVNnIzjTELWJt0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723706712; c=relaxed/simple;
	bh=Ow1/2PM/XA+bt7tPUEZgVaKKbLuhy2wTsjK7gDnB3a8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tWkjvVUvUTDUNMAjwOP/5hupXZUFqioRq58GjFNRrZTZT/nh9sSTo0H7hcT9IdggpDG1NjKHEgi2th3jWEJ1Lq42d925wuOrvUFr1k98KE9GKkE52u+p18d54HyvOudhwDep6PlzN4+MByEqlhNISkgYvYrhgBeI5H0nwdc1PD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JEFEUfOa; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4281faefea9so3557085e9.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 00:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723706710; x=1724311510; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fz7V9Tu3EtjBhPrJHgxXfRiSyngyRtnzUolHcCZqMic=;
        b=JEFEUfOaPVL/CGLz6q4MtIptjf31pzDPOz48Cq0lSXWWwkkePefrvzEZovygOTkoUG
         6047gj+inLwyjaP/IyD4nFPXMcGv9mUBuLj5+4l+tDDCOAA0NauqH5yjzUTzaYjOrxtu
         2jiSrtuAjz93pm3sqzE/7dehhpPlm7+IvPK0fvwa1SYLCGMc9/Kl9n02THEjoMf7RQUu
         O4YO7mxmpgvhRpfprMdQtKvSMW7+eGoFPzwhc5jUTgs9Sc5hU8cgJOA9NMDuJH2bcAY8
         KdyeAClNVdzI79jVDDNazGkpSb/DgwKTFe6aF9tL/GE+drvRRLqQRR3F6Dj8CAUm2JfR
         Cj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723706710; x=1724311510;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fz7V9Tu3EtjBhPrJHgxXfRiSyngyRtnzUolHcCZqMic=;
        b=dtNs6xLAI7Y+Thu0h3maHCwFue430BqcRtxRFBC14fpHWihn8T2/77u3dafjfXOc/T
         seDXvCcmaJi+Uwx0MLIxslmcBxKVVaW//P0rhRybV1TGLxQOSU7a8WdX5nP1b4JE40Cy
         UFPdN/Mks9jm00DVjwRXI38ROqKUVCFW20tnimbQPf4SY/8i2Uu2JPcGg5IZHHs0S9yB
         TSonjmj85MIH5fm6mOs2+TYvOEl4q0wKpM2ZeDPClyh2ZNnYUyhME9SggjbBPSTx6dhU
         fCeT5wcXXJNPqHPwYaIXwCD6r5O41xVHMbYhTo0YIOWYFa0dR9VaGHZh91YjVHy1Dp6m
         Xm5A==
X-Forwarded-Encrypted: i=1; AJvYcCXBBkIP8SlqGX2KsFnzhvXUQa01/4Tn6vaaa3U7EntjsRch4gNfKRk9G77u761dB4G9v52yWHbOudSYAnaQFaz8P72H
X-Gm-Message-State: AOJu0Yx8SXP/2mXkmcf42ltg1wiP7kasd9EtGIFvjhJFIHvM+EdqO9qS
	vyIyLP2Eg0M/gdLB/wwsAOhYLcNycv8Xe6qPjiR+bfhDxxC10DtJE03tenZbEoGK49mPvJXD870
	g4OBd0XM5Uv9h6wJNIsoHa2o5DDM7m6HuSgHt
X-Google-Smtp-Source: AGHT+IFDY+rlRX/qSGEGOl7eRG+hjtAxUiHzOwQTJK7cDbUC27G98FAuS1SlS95X/zfj/rFIWeJixLWpZK/CGw0VdqU=
X-Received: by 2002:a5d:660b:0:b0:36d:341d:6ba8 with SMTP id
 ffacd0b85a97d-37177821d90mr2579225f8f.63.1723706709402; Thu, 15 Aug 2024
 00:25:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com> <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
In-Reply-To: <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 Aug 2024 08:24:32 +0100
Message-ID: <CA+EHjTxNNinn7EzV_o1X1d0kwhEwrbj_O7H8WgDtEy2CwURZFQ@mail.gmail.com>
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
To: David Hildenbrand <david@redhat.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Patrick Roy <roypat@amazon.co.uk>, qperret@google.com, 
	Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Tue, 6 Aug 2024 at 14:51, David Hildenbrand <david@redhat.com> wrote:
>
> >
> > -     if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> > +     if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
> >               r = guest_memfd_folio_private(folio);
> >               if (r)
> >                       goto out_err;
> > @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >   }
> >   EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
> >
> > +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
> > +{
> > +     unsigned long gmem_flags = (unsigned long)file->private_data;
> > +     unsigned long i;
> > +     int r;
> > +
> > +     unmap_mapping_folio(folio);
> > +
> > +     /**
> > +      * We can't use the refcount. It might be elevated due to
> > +      * guest/vcpu trying to access same folio as another vcpu
> > +      * or because userspace is trying to access folio for same reason
>
> As discussed, that's insufficient. We really have to drive the refcount
> to 1 -- the single reference we expect.
>
> What is the exact problem you are running into here? Who can just grab a
> reference and maybe do nasty things with it?

I was wondering, why do we need to check the refcount? Isn't it enough
to check for page_mapped() || page_maybe_dma_pinned(), while holding
the folio lock?

Thanks!
/fuad

> --
> Cheers,
>
> David / dhildenb
>

