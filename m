Return-Path: <kvm+bounces-24381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A5639547EA
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 13:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EAFB1C2394B
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565C919E7D0;
	Fri, 16 Aug 2024 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s2dXlMio"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D6434CD8
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723807190; cv=none; b=IF6MZY6UkQ4cWAI4pJQGnLkBr4+5oF9BMbbC+ftElPqihaxbngPJ7hMHtldb3mCfF6D+NawYIS8GkACG4PAoo4NfOQGYBBapdfoWirA+ykNbZo4WSyWO9WfcWNq6qOt2x/2uPgaU3p4AG4TYLmTmD/Zc42HE3Vz3IhcNUf6I9TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723807190; c=relaxed/simple;
	bh=0YEKbCgqjCKTnqIvucJPhNpFU/zKUOwOBiiXIpasgTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KWcqV2aixi7ZijsxM1TAoOGZemGS8eMgjihwyrfGeN0UjIvKRCta+kVwNkjOvZQvjb5f74WlW6p+HCqTOiA/qG3c/BqjS5qlbHbdpfE5i52SLpSTpJEO8ZUL3YOGzmhP925/q3VjLGQmcBzHBtbmWazCP1+7GenzamTA+UU/g8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s2dXlMio; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-427fc97a88cso14016495e9.0
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 04:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723807187; x=1724411987; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rZ/Girz08IZmHtZsrVU+idIVHnjPppCsG5oXI3Hdtsc=;
        b=s2dXlMioN1qbV4CEl5gw2hyxbqedO1CTzQTK/YbtSZXVwjP7eDi2YFlS6KGltDTekd
         SZNLndwRF9Mcw3f0e9ITiALoMsA8haeQhxxHdmf6zFjtXhlz8kmA7L/j8BtcF8Vz8OUe
         vzLqyvE45hG+2Wt8L1rkzTzFzAFyjAh6k/RMO87AGHRsnTf7oeD5V2Z65z2/LloblcHq
         +SdPxtfr41P6+A//WreI682gTlWGyAs96Pl8OLMtIbk/dLqDDiC/m9iXI7Nen5i+uOLn
         p/CBfSE3wyyeqPUZqsJUCa+yT7QEJY5mrNdKNEDbzvQhiMD0SatoSFVQZFr7UXF2sMGC
         Sh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723807187; x=1724411987;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rZ/Girz08IZmHtZsrVU+idIVHnjPppCsG5oXI3Hdtsc=;
        b=VLYtxMJQYyVLl7dUXHTjiKsNgpxclAhLW4fDvWQn6+tYZU5u8u27P5GRBpu63gStP1
         AmuWq2jtqi/pYzXY4MMQIH2D9tlI3EwUOstGfVypv9gNPCboYAFc5ZTx8YGOy2jE41m2
         TMFIxBLY80VU2Pe7m0KZyLoUUXu+x6iFe96dC3PMc0DejWB3W+Qf9i1zOxvuecXIb0DQ
         GIRlEFKFIAMsiikqWpn8Ywbjp+9RNdyll/NRc4dmziC54YYagSuA+rOyS0uUFtS0yblg
         rME7KVjWayo86CEnouiMhS2aprtAp3Drby7PMOtzL0YtRypXcKdYQ+8mhIQ+baJpU++L
         MkqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlpxgtEpSEnMGpJOZffFkogoFDrCS+skPmbT4/tv4QMpk5JgvuDLk12QexImbtmVWJ9I8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvZ+MkBMCf+rcFdp1MY5OZZwPNhAl45gyM7+5gcex40L3vmbV9
	XAZvHrEl6sefhFSpahdfdv/dsCtH72QFDOEYv6h0k+WaLQwBPkluRmUwYKoxuqB5jUnjWc+uNWn
	OvzwT9Zrm0q87UUKicgnGWaW3uHR3UiPo9PZ7
X-Google-Smtp-Source: AGHT+IFjh0jaZHz+bXJLGOwDlxY14HFpbgg6MC9AUdExHwCz1VC6lyjw8E/zebexbyTLHtHDRbeRFor8g+UdLx/zwRY=
X-Received: by 2002:adf:e388:0:b0:368:4e28:47f7 with SMTP id
 ffacd0b85a97d-37194314f7emr1429125f8f.6.1723807186811; Fri, 16 Aug 2024
 04:19:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com> <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
 <CA+EHjTxNNinn7EzV_o1X1d0kwhEwrbj_O7H8WgDtEy2CwURZFQ@mail.gmail.com> <aa3b5be8-2c8a-4fe8-8676-a40a9886c715@redhat.com>
In-Reply-To: <aa3b5be8-2c8a-4fe8-8676-a40a9886c715@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 16 Aug 2024 12:19:09 +0100
Message-ID: <CA+EHjTz6g_0P+t3wzV99hBtf9rd2Lvn-vwYb2oKZaXxSLs5BzQ@mail.gmail.com>
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
To: David Hildenbrand <david@redhat.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Patrick Roy <roypat@amazon.co.uk>, qperret@google.com, 
	Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Aug 2024 at 10:48, David Hildenbrand <david@redhat.com> wrote:
>
> On 15.08.24 09:24, Fuad Tabba wrote:
> > Hi David,
>
> Hi!
>
> >
> > On Tue, 6 Aug 2024 at 14:51, David Hildenbrand <david@redhat.com> wrote:
> >>
> >>>
> >>> -     if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
> >>> +     if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
> >>>                r = guest_memfd_folio_private(folio);
> >>>                if (r)
> >>>                        goto out_err;
> >>> @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
> >>>    }
> >>>    EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
> >>>
> >>> +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
> >>> +{
> >>> +     unsigned long gmem_flags = (unsigned long)file->private_data;
> >>> +     unsigned long i;
> >>> +     int r;
> >>> +
> >>> +     unmap_mapping_folio(folio);
> >>> +
> >>> +     /**
> >>> +      * We can't use the refcount. It might be elevated due to
> >>> +      * guest/vcpu trying to access same folio as another vcpu
> >>> +      * or because userspace is trying to access folio for same reason
> >>
> >> As discussed, that's insufficient. We really have to drive the refcount
> >> to 1 -- the single reference we expect.
> >>
> >> What is the exact problem you are running into here? Who can just grab a
> >> reference and maybe do nasty things with it?
> >
> > I was wondering, why do we need to check the refcount? Isn't it enough
> > to check for page_mapped() || page_maybe_dma_pinned(), while holding
> > the folio lock?
>
> (folio_mapped() + folio_maybe_dma_pinned())
>
> Not everything goes trough FOLL_PIN. vmsplice() is an example, or just
> some very simple read/write through /proc/pid/mem. Further, some
> O_DIRECT implementations still don't use FOLL_PIN.
>
> So if you see an additional folio reference, as soon as you mapped that
> thing to user space, you have to assume that it could be someone
> reading/writing that memory in possibly sane context. (vmsplice() should
> be using FOLL_PIN|FOLL_LONGTERM, but that's a longer discussion)
>
> (noting that also folio_maybe_dma_pinned() can have false positives in
> some cases due to speculative references or *many* references).

Thanks for the clarification!
/fuad

> --
> Cheers,
>
> David / dhildenb
>

