Return-Path: <kvm+bounces-53851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0E2B18774
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 20:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C5BAA872CC
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 18:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B8B28D8E2;
	Fri,  1 Aug 2025 18:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1rUUtcq0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425E623AB95
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 18:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754073994; cv=none; b=W2pmOhnvJO3QFBFpYd/Gc9Uct0dzCCcexXMsP51t6MMNhI7Ll9nv4YhPo0cP3LhOhxUTk8O/+Xzws4wIiZpmTBkUj/tKSyXnfszzBKj4VWpSv7YZp1oasUrvpu+o+F9BOSM6co+kOd6L7sEDM+af3r3RwsUyFse0ezhmTbwlg7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754073994; c=relaxed/simple;
	bh=iuTKwx1riuuxhY/5J2mFsDhn7XxA9QAIr/JvJhOy0OY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g2wpkV3XLOyspH3bak/5TLNHmUZ9WLykTPVEGBNLMu98HZKNWyeZDY2YKyFSme5XMeRbH6arsq3qzE9HBzgsljyWKKM+Qg8nJiEwXxrhQzVDjt/XI4JKCXtYBbXZ4V+kAwf580aBWavoEll3FNlv1sTAMYxbqNNPzKTdgQvQ33I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1rUUtcq0; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71a455096e0so8265167b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 11:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754073992; x=1754678792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2c7bQ162dhyffr+C2PMoaAl+4J9FXAI9hIAhBblIgs=;
        b=1rUUtcq0/jAohKC9WR77PEEg71ubNE7baLWFQA7l+IZJRitNLpOYHJeDaKq4178Tlg
         g8cKYCOL7bwP6S7UyKhC+API+vmHb09NTd5wCC3ZlyO3nAZbMEm9AHtc9T4xbCAGQRbE
         caL9xJ5glxWH5ynyPgVuFDVtgF3zfGW2qXmyW0w8+Ny52I09HyMAr8D0It94L/68sBSw
         Ib9q97yjjdjn+DHE/LTgnpcDcFzjwzGc+nD6KNfT9SpfVpOhoUkNT9IOZsEKpfyrDiqK
         NQ5rgBbHikQ4pdfQ7AKcK+6cQYZmyJyENNy+bOYr8c/Vqf2Yfq2RQNJM+Rfyk6FMf/6n
         iwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754073992; x=1754678792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2c7bQ162dhyffr+C2PMoaAl+4J9FXAI9hIAhBblIgs=;
        b=XVVXK53an4eSji7MzgDuDCQwMxsDuMsAZBbiYBwED1gnmYbdUB1dyj4eijMFUpXXkC
         5LoEypvjJhPfBiIBP4MQ3UCKfk91aUjFKk0qTGVDHMh2dr/oBSuqvUo+vRCOc9Ez/NjV
         4zEZvgp2BOSH01zsp7LAZy47rLK78qvWaLUOGJSjDtxSV2NEX6PnA4AF8950rcnSSz1k
         ZXboD/eC7c2fx3gJSxmlKGf14VAT/yHgBt4cGSH0Lwl86p0Dqbw/U6qua9eplt8uSF0l
         WZq2l2+DlwMQKiGF/yJl81KPA129MIWrocns+kQdd/JhD7XZy9JGOVU/Vt0o2GKd0Jhk
         bRXg==
X-Forwarded-Encrypted: i=1; AJvYcCXaQJjxHbnbEOUqMrsC98pE5KEOQMY+2zQAFL2EP+gFOWkkk0PS0P6Mbvg2nhKFU3q3/vQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIuLIHuXESS25gAWd317BMYE3D9PzbHNFWFwwJrq1R+4Fjdy/M
	nlZoqKGmD8WVA5vj4BcupwJ2b5dzHvNgQALpd4xWUqUJtVaBW+PEP/gfPPIWtkLTPmLwIIMXsL/
	W37Dou+SWVsGkcucUvpDpUpvboqgj5dVX7VDjqTb4
X-Gm-Gg: ASbGncskIHmQwPBb8BZD8JLxKp4EH5oZX41hGaibu9xKABGQEbW+eOeoglpJObiwheT
	5GaP5+wVrWVbDmWWKLhX+VUFVg9TztlUIG63MxXhXaMgkQuoR2PCJ6g7yri9uZ0EQF7Ab15E7Sg
	BPqt2LVQ7vz2w/5vgXpNPQOECvMatZUEVlCqYDYBEWXozhuzsaTnzjc3KHxdP8uO1+foQoOKleM
	vUu8QYByRZZPa9DiP1/u9FIY5PLKaOoVmwEZw==
X-Google-Smtp-Source: AGHT+IEl9yX593jURawHLWbkAVgQAYSYsMpaUOTywvKTzCY1mB223Rq26/uhMv+My9oQ9rjrYGf4rC+/HsCsxlqvW3Y=
X-Received: by 2002:a05:690c:488a:b0:70c:c013:f26 with SMTP id
 00721157ae682-71b7ef7b402mr11188117b3.33.1754073991958; Fri, 01 Aug 2025
 11:46:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com>
 <20250707224720.4016504-8-jthoughton@google.com> <aIFOV4ydqsyDH72G@google.com>
 <CADrL8HVJrHrb3AJV5wYtL9x0XHx+-bNFreO4-OyztFOrupE5eg@mail.gmail.com> <aIzLBWqImtgtztOH@google.com>
In-Reply-To: <aIzLBWqImtgtztOH@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 1 Aug 2025 11:45:56 -0700
X-Gm-Features: Ac12FXxAU2RUoTM8vbbi5zAcMiC3jCiOxjwk0GR-osMUp_HPSvA3qzKWlQIC99M
Message-ID: <CADrL8HX11ee3R9HXexk3PbhFRKoOPfW6_=c+OOcaWE=0WJ7K4g@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] KVM: selftests: Add an NX huge pages jitter test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 1, 2025 at 7:11=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Jul 28, 2025, James Houghton wrote:
> > On Wed, Jul 23, 2025 at 2:04=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > On Mon, Jul 07, 2025, James Houghton wrote:
> > > Right, but we also don't want to wait for the initial fault-in either=
, no?  I.e.
> > > plumbing in MAP_POPULATE only fixes the worst of the delay, and maybe=
 only with
> > > the TDP MMU enabled.
> > >
> > > In other words, it seems like we need a helper (option?) to excplitly=
 "prefault",
> > > all memory from within the guest, not the ability to specify MAP_POPU=
LATE.
> >
> > I don't want the EPT to be populated.
> >
> > In the event of a hugepage being executed, consider another memory
> > access. The access can either (1) be in the executed-from hugepage or
> > (2) be somewhere else.
> >
> > For (1), the optimization in this series doesn't help; we will often
> > be stuck behind the hugepage either being destroyed or reconstructed.
> >
> > For (2), the optimization in this series is an improvement, and that's
> > what this test is trying to demonstrate. But this is only true if the
> > EPT does not have a valid mapping for the GPA we tried to use. If it
> > does, the access will just proceed like normal.
> >
> > This test only times these "case 2" accesses. Now if we didn't have
> > MAP_POPULATE, then (non-fast) GUP time appears in these results, which
> > (IIRC) adds so much noise that the improvement is difficult to
> > ascertain. But with MAP_POPULATE, the difference is very clear.
>
> Oh, right, the whole point is to measure fault-in performance.
>
> In that case, rather than MAP_POPULATE, can we do the slightly more stand=
ard (for
> VMMs) thing of writing (or reading) memory from host userspace?  I don't =
think it's
> worth plumbing in extra_mmap_flags just for MAP_POPULATE, in no small par=
t because
> MAP_POPULATE is effectively best effort, and doesn't work for VM_PFNMAP (=
or VM_IO).
>
> Those quirks shouldn't matter for this case, and _probably_ won't ever ma=
tter for
> any KVM selftest, but it's enough to make me think MAP_POPULATE is a patt=
ern we
> don't want to encourage.

What if vm_mem_add() just returned the VA of the added region, and
then the test could call mlock() on it? That's actually closer to what
I want; I want to avoid slow GUP as much as I can (though mlock()
isn't perfect, it's pretty much as good as we can do). So we can
write:

  char *mem =3D vm_mem_add(...);
  mlock(mem, size);

instead of

  char *mem =3D vm_mem_add(...);
  for (tmp =3D mem; tmp < mem + size; tmp +=3D backing_src_pagesz)
       *(volatile char *)tmp =3D 0;

