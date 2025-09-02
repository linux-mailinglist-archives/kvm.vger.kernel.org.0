Return-Path: <kvm+bounces-56534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 942B1B3F756
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AF4F1B20D12
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF2D2E88B5;
	Tue,  2 Sep 2025 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uuAK93YH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435702E7F3C
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 07:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756799993; cv=none; b=dNi92JXa5c3oNJuymKIfMHB0TPJTexq0Kq7VwTO2m9c605liBW/06WVImK+B4gS1EK0LwgGUm8tezQWtdfDmnX/t41F/XPyIGp+PsvM6xk3BMGi9Pj9Inz9lONs5QktSHSuvaDQMITuNRA8URWJZ0iOmDzxTfXXKo3VlVxnsuKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756799993; c=relaxed/simple;
	bh=tebRK0QcMgpMQT7H4oKZqhEct4KUpLNswRIw/gQ5Jd8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GdVl22+vAYWv6XLfrL7PvbS7RS5t4QCbKEWd/cBXkXaNJB5hblZAJe+CodXpbmf5sRqitdgMR1dBZJeiXuqfALYV55ky5QgbkdeOPWsxM4+jNFR9GQHIG5p6/FxoQa1gNSh4uFIBc2TlZUTibdNo/eRd1JFEelLIDnUrf9D/+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uuAK93YH; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b30bb04ed8so448171cf.1
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 00:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756799991; x=1757404791; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oNeLWs2qHyUDts+2iHePFK0hNcgX1eWBxmSFpW760QQ=;
        b=uuAK93YHHFDmmTKFvJYZDd9O++g6IPIcA94//Z84CVnkw5SlNIJENssyFlmJQnIoOc
         Yr5MU8Z2/FESdJKdmmUeqq58bpHcwTeTKTs7sTTJjAcV1zuBfS8hv6dBPL22gBbIyQAe
         4J+pKhiLL7uhoYWOxEdTH3hvLotk0PfHyZcXJx222qovWVtLAsLYRNKOLMHuHDiWULAv
         buYbVvW+0ne9Rc+EOcos3+FJWQkJDR4mZFdZegpDyeWOj5XVAn6HNLwPLpyq0edSVoGC
         F7hU/z5j6nUXMycY5kqxqjS5CUO0ARO2hw0up18N48EX1CViF+Khh8pBfbpR8Qg/h/kv
         fQGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756799991; x=1757404791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNeLWs2qHyUDts+2iHePFK0hNcgX1eWBxmSFpW760QQ=;
        b=tZZGs2J8uFM7O4zKuwa2uQMFRFWeCPaRtp3qL/3VFNzL1boGS7rY9bjpHlbw1EHmsE
         GoNYKwnEUsVJhdeIRRFjauxH4vXeaiw6yOThj/W0OEVUCOJ3aZCFO45HInEpPFC5Ykn/
         iWdhDuYRnB/bQ0mNOCnFtjW6PnqyPLvqgILKmUuPwvcSGL8Aibvw07DhiSor6kIncfx5
         3XzYSnlx905E4KhCqIZafgj1YBsaojtGClFM+FkmUoeXuJmal+HQbdu7fluymD596Jjk
         eZVS09gruMbcVE1TTNXzYdeIcGhqAdyCqnQMa47lWk8eoWpQRKhjbMElPufZ7ZChYPgi
         fUdA==
X-Forwarded-Encrypted: i=1; AJvYcCV+zifEiWSzLUKn9RkslmBkFLmXBai5LN/hvrGVml3NMFpbmxRPqxBfwTaDjtVXWs+gEKc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ2mo7/17y6GlWfA6554vJQwEQUQjC+zdp50UFnHydelEW9Blr
	QtP+lQxoefswNdNu0zo8YOPpkMyKlAA6YhYmIj19SWwdJbhIj2yQgT5QhtdpCNjT9A0DKjaqIr4
	94YN4gk3VxUguP976E1svELy9dTOr7sN8wwlzQRu9
X-Gm-Gg: ASbGncucx28DZTQEwzQp46QMWouMwf+bxWRqoVgUey6wdISe9C6OQeFc3ZbnIEmKudK
	5woKVdJHfgzdY+SqGSj6xXccjmh+xk1L8umje6E/PFM0tnreMOTh13cX5x+oP5ic5sZ7UwEpCjS
	QtZJ8ac9ffGtlaplPxQbpxktnHcuU0H7VsVu67Zk8jMZkyUvvw9YP4DKyYWEkPULtzI8n9joJpi
	lkSPmi4ZG4/qMOeIysJG8ZlgprVVIECcbyj
X-Google-Smtp-Source: AGHT+IFkdbqiMarowY+mmKOzuU9RyYySZu0bnzDQg3QNeDfxzMXfy+3OtZ2GRaaDn0H+MAu5W+vNpqCjVKeX20zwo4o=
X-Received: by 2002:a05:622a:107:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4b31b245bdfmr13130661cf.3.1756799990207; Tue, 02 Sep 2025
 00:59:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901135408.5965-1-roypat@amazon.co.uk> <20250901145632.28172-1-roypat@amazon.co.uk>
In-Reply-To: <20250901145632.28172-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 08:59:13 +0100
X-Gm-Features: Ac12FXwFaub6kV3Kd2ykY4foMIV_-u80DlGRtIr2iGvqoKH4iO-6ScE4yMry24U
Message-ID: <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com" <david@redhat.com>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,

On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >
> > Hi Fuad!
> >
> > On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >> Hi Patrick,
> >>
> >> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>> index 12a12dae727d..b52b28ae4636 100644
> >>> --- a/include/linux/pagemap.h
> >>> +++ b/include/linux/pagemap.h
> >>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>                                    folio contents */
> >>>         AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>         /* Bits 16-25 are used for FOLIO_ORDER */
> >>>         AS_FOLIO_ORDER_BITS = 5,
> >>>         AS_FOLIO_ORDER_MIN = 16,
> >>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>  }
> >>>
> >>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>> +{
> >>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>> +}
> >>> +
> >>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>> +{
> >>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>> +}
> >>> +
> >>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>> +{
> >>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>> +}
> >>> +
> >> Any reason vma is const whereas mapping in the function that it calls
> >> (defined above it) isn't?
> >
> > Ah, I cannot say that that was a conscious decision, but rather an artifact of
> > the code that I looked at for reference when writing these two simply did it
> > this way.  Are you saying both should be const, or neither (in my mind, both
> > could be const, but the mapping_*() family of functions further up in this file
> > dont take const arguments, so I'm a bit unsure now)?
>
> Hah, just saw
> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> Guess that means "both should be const" then :D

I don't have any strong preference regarding which way, as long as
it's consistent. The thing that should be avoided is having one
function with a parameter marked as const, pass that parameter (or
something derived from it), to a non-const function. Instead of
helping, this could cause a lot of headaches when trying to debug
things in the future, and figuring out what something that's supposed
to be "const" is being "corrupted".

Cheers,
/fuad


>
> >> Cheers,
> >> /fuad
> >
> > Best,
> > Patrick
>

