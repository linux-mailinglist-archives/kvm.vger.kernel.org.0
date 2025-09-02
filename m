Return-Path: <kvm+bounces-56545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0369EB3F925
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 10:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04F961779E2
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 08:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BD92E8DF5;
	Tue,  2 Sep 2025 08:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="udl4tDji"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B14270572
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 08:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756803083; cv=none; b=nYmFCIqEMHQjqQwMDVIlR++j76Tl8lXrTWZzUK4SpD2s8VlgKLQwC7gGCtLp/8XAB9HWVCeJAzx9u46lRq8rXxNqUkAgTNBcd+eQGxSS7aZpI4QG2JTwkctRjk7Ss1O6i0QtxqW9ma847fbeLlZdt5mjeRg7XP95TcA2hCyrHJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756803083; c=relaxed/simple;
	bh=LpctAe6OrOBL+wU0ij68SMzomzlRkC/NvKCrGAq8e4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BCqBEcaJNJl3zG2b9qlFyqIl+CoDyTEubdiGGEVSdjceuFjxnZwZsxVM+3lrRRUHYFt7h2IboXzaLLqVYVDnGEZSwFhfnlbbq6suiJUtXQDWUnsMfeLuIS0cfGIMwpibIHLw98R7X6CHWW2MuIhhNI0drKtfPk6t7RmDno0oEkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=udl4tDji; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b327480fd0so839251cf.0
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 01:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756803081; x=1757407881; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iP4mX/+2DHYze7f0itBbCFIKzjrmdvMk6mmWMpcGwHA=;
        b=udl4tDjisRhkTqM4DVzlMg7eCxPGQtc+ZngDoeNEDpzhKH/RpdvYbKDnLXMSdQKO67
         nBe1R04vzJ0mxM6zczu1e9K/lw99gaO4BwPGNu/eu/+c5+f58g2yFxjA9ew3C0gpKGGe
         4lZ1lwhLU7DLMHaZ190danjDichOEs+W3K6zeM2ehE6+WIfbN3q+fACqFSzyr7SPZKe3
         qNX98YYkB9ksOXXnjrhugC1JceqSaSP98By06BoAwstwIV4e02cVeAp+GaDC3UaD1QNt
         arBIPUrCqG584esFg9gEzCRpNX799IZOpyZVCV5fvkVYcwljLWN8ea4lmfNmuu/3Ro7x
         wxMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756803081; x=1757407881;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iP4mX/+2DHYze7f0itBbCFIKzjrmdvMk6mmWMpcGwHA=;
        b=j1U2Y+uEisNTHSFX18wgoRuCiZeE7lSvcGXK0zoXBQfJApKkjT84kO4pOUOgw5OZDL
         I2ZuGIZw2i1eCRsNUNvkHXcn3RLnn4tf6YqddRZA/KDQI+ZBXM1UDHIL18StSA9J5/ZK
         uuiZ6Mxna/AlzCR8+/oL0a08HUk6Tl2bUydhfbmx5Z2RNfEFBEx/k/VDau0bv2y51pj/
         7wcQtId4u5Q94LT7TfpdjzEmLXvumY0d4GkZgJu7/49gylb+Ddmrr18+S5Wfr5ozyCEx
         OIPk/9JusRiiuo0kK6k4KWEH3valuZBYifLFZG1v5m30yd48Uzr78C5sJcL7iskbvdPl
         n8Jw==
X-Forwarded-Encrypted: i=1; AJvYcCWgtfncvjSru/rTFXBA+190r4c6/66V9KzO77NusrA97HSkcLo18VSYuY5dfa+YVfLzZYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTreKaTrYgblOuqRqv2Y9P61WXI8qYdisBhX8FU5rhsKqDrdgp
	k8Fpovl2Joq4ptvts/EBZQRBEyRBY5DUMF0M/f3CVFzmzHjfBVF7wh9I4dGoCthmtg1zqy6X/T+
	8yCPXuxpg42Z16EFmaZDHQvQdaKLSF08LdFWO2+qx
X-Gm-Gg: ASbGnctNcYKylua4YSKnr9ipz+l28kdjAFABC93u3D81dfKlMXPx1IBFoBd/7H8bl62
	eqdnHmkAFbX+3zQme8Qf1KmpGeFHr+dM8ZUWAxB4+71z7xldWnns/IY8xMl6rBnT4L6NMgB4cDT
	7l5A2rgNsqHaRSad2TgSnP2wPoyNBf35eLHrVRen0/CP/CdqXeqskanf1Y5KlhxSn4EILcjssQh
	6gw1lPxA94YnCw9e4FlzM3MRw==
X-Google-Smtp-Source: AGHT+IEl9wSTHdiJwZPLw2efIYDBOrEGcJPxDblGkQXiafOiZIaocXkLc6odVx1VLSTjodsqJVOs6KtZuN8sumvistY=
X-Received: by 2002:a05:622a:a28a:b0:4b0:9c14:2fec with SMTP id
 d75a77b69052e-4b325008444mr9184701cf.8.1756803080383; Tue, 02 Sep 2025
 01:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901135408.5965-1-roypat@amazon.co.uk> <20250901145632.28172-1-roypat@amazon.co.uk>
 <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com> <862475d8-5a4f-44c3-9b3f-56319f70192d@redhat.com>
In-Reply-To: <862475d8-5a4f-44c3-9b3f-56319f70192d@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 09:50:43 +0100
X-Gm-Features: Ac12FXwr7whnN-VXo5s-ZgZo6eW3l7wyHW3APjTTLjncve_-hqyXmzJXVm4lqgs
Message-ID: <CA+EHjTxymfya75KdOrUsSUhtfmxe180DedhJpLQAGeCjsum_nw@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: David Hildenbrand <david@redhat.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Sept 2025 at 09:46, David Hildenbrand <david@redhat.com> wrote:
>
> On 02.09.25 09:59, Fuad Tabba wrote:
> > Hi Patrick,
> >
> > On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>
> >> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >>>
> >>> Hi Fuad!
> >>>
> >>> On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >>>> Hi Patrick,
> >>>>
> >>>> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>>>> index 12a12dae727d..b52b28ae4636 100644
> >>>>> --- a/include/linux/pagemap.h
> >>>>> +++ b/include/linux/pagemap.h
> >>>>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>>>                                     folio contents */
> >>>>>          AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>>>          AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>>>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>>>          /* Bits 16-25 are used for FOLIO_ORDER */
> >>>>>          AS_FOLIO_ORDER_BITS = 5,
> >>>>>          AS_FOLIO_ORDER_MIN = 16,
> >>>>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>>>          return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>>>   }
> >>>>>
> >>>>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>>>> +{
> >>>>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>> +}
> >>>>> +
> >>>>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>>>> +{
> >>>>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>>>> +}
> >>>>> +
> >>>>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>>>> +{
> >>>>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>>>> +}
> >>>>> +
> >>>> Any reason vma is const whereas mapping in the function that it calls
> >>>> (defined above it) isn't?
> >>>
> >>> Ah, I cannot say that that was a conscious decision, but rather an artifact of
> >>> the code that I looked at for reference when writing these two simply did it
> >>> this way.  Are you saying both should be const, or neither (in my mind, both
> >>> could be const, but the mapping_*() family of functions further up in this file
> >>> dont take const arguments, so I'm a bit unsure now)?
> >>
> >> Hah, just saw
> >> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> >> Guess that means "both should be const" then :D
> >
> > I don't have any strong preference regarding which way, as long as
> > it's consistent. The thing that should be avoided is having one
> > function with a parameter marked as const, pass that parameter (or
> > something derived from it), to a non-const function.
>
> I think the compiler will tell you that that is not ok (and you'd have
> to force-cast the const it away).

Not for the scenario I'm worried about. The compiler didn't complain
about this (from this patch):

+static inline bool mapping_no_direct_map(struct address_space *mapping)
+{
+       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
+}
+
+static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
+{
+       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
+}

vma_is_no_direct_map() takes a const, but mapping_no_direct_map()
doesn't. For now, mapping_no_direct_map() doesn't modify anything. But
it could, and the compiler wouldn't complain.

Cheers,
/fuad


> Agreed that we should be using const * for these simple getter/test
> functions.
>
> --
> Cheers
>
> David / dhildenb
>

