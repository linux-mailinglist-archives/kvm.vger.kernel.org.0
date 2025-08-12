Return-Path: <kvm+bounces-54513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1A3BB2246A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 12:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CE141659F7
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 10:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFF862EAD06;
	Tue, 12 Aug 2025 10:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WE0bWRih"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91916189F5C;
	Tue, 12 Aug 2025 10:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754993910; cv=none; b=XFq0zyjYYwbOHtXKznNG2q8iR1MH+P45CMgI0NokTNP98IvXIf+UPOPmlYMixkUtPSMUKV6x7cHJCWj0KTYofPpKdJ7yH6BRmHbamv3pbvDvAumeIwUm5vtdwfwzDLRHE3u28Db9QyahJ8tbyYB2FN7tQq2tcTdyyLIYwwMhwL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754993910; c=relaxed/simple;
	bh=Bz6TBG3gxi8FiG+ibhXuB9So8hkRyyvwLQokIXq0rxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sEQCpswKhHGPzFIQE3SJcnLlR3vlnyyAfIQYjQl2ohzGrltDe76f1OHTHKLlIv+U7Sj2G0pnT862f8/E01z73v0ums8qjEVnBE/74h0tMAVy2lSgbFbHf4wkuAZVt1ePwQub+6uFNK7KGYXcR8ZI+W3i3JmRXMmvp5GUbmBqEDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WE0bWRih; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-306ab1b63fdso3086259fac.1;
        Tue, 12 Aug 2025 03:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754993907; x=1755598707; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eg4wE+5PRG/8bGt1RO7F5F4ItHMVKsy6gTMOPz3mUNw=;
        b=WE0bWRihZc/iOs7NtYy6RycVDFNSnu+Jfof89aWu7W6V8UU/VJBlTvgLXy1Pm7NXrr
         J0vD5YP1fDLvlwvWjrZVrVboN1rL2slGoyHVypmcjbAr1ZHv1XzqtugQV3vVQZfiZKXw
         eiLl6QRlMhXhhTFFKGGtVS+Nkq4yhJO5ilgvLtCXF+Gvxh8OapKyD+0RrrjDRrVFh4OY
         WP3ofeCyA5DUXDGOzbP/N1jpmziaIMjJBSH1uk6uukAKA2Ws0tB3THIyPUFVBwveCB+9
         EYj6xBqfcwt0vncgIHgoUrM7KGs2jXYymSeUJyappj7NezprVZ1Ck4/ogMzqTnWDjVR6
         kjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754993907; x=1755598707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eg4wE+5PRG/8bGt1RO7F5F4ItHMVKsy6gTMOPz3mUNw=;
        b=brJG/6B2Dcpj0fqsvgXUfFfsRKY1Ske4f+RXkavoT1xxO9lmkig0iFzdYA5a1K9FdV
         8hOJZGeqwl3T//NlbOC6bsM/M9UtYU6XDNdqrTpebYleDAVQEQdfi7cU/mmZS6NbcRfl
         7zNfDdA2NkWnqiIoOSes5DQylQOmc9YvR5dZgSaSY+pt1RXvt5ZRDaXy3etonH2Sqr5t
         wkdWi6TEbOAu9c9Y3xBWmfrdhP/L7ar9DvVcQRYRCaF9uFlsURLR7jeo3VO+dhWxQ/V/
         zOtPp0cNRxBpim/F28k5xJlOKOc4xOMVQhq37p5XhXLnZO2RubpmWTg790vY44R5Yh+M
         vE0A==
X-Forwarded-Encrypted: i=1; AJvYcCVQaO37efQRZy/PRRfzwSIAcbbc+5BPyEKhRhy+20W6ZRm+flMGmAJ9VImY6D8w2mlXDIY=@vger.kernel.org, AJvYcCVveid3GkeJcCVQ1JhwYqOsYRGLwEw/KYTQLMYMgLZP3P/DYlI86andbVuUjmGcRVdTwhl7+CNHGpilfB0S@vger.kernel.org
X-Gm-Message-State: AOJu0YxanjTki+wMLOL388dVI4tLx74FxA4TEj2U6DnXNKdkCbIDCDLE
	WSrfXy4HIhdfOS9oDivXqWcgz4Cif1ym6h5v8D+lyi9KzsZhl40kq1AuACzLtqJimY8AU3siUio
	RJ1jq1dCuNbQbqhB0Ztm8HWu0HsRUkhk=
X-Gm-Gg: ASbGncvXLET6CwSaHB498QJnXPM5egMBAwUv5nDL15JKzLYVLXtMmN45a49vvpJc5ln
	T9UczHmWdkCPAkXJpKDcg7AC2P3uEQHfuVbzcIlS1i6BqlEzEqysFm7VrPbnsG+9B5m0N5tokf/
	DHeZp8zeJMDnlZDbwGY9ISD7U2OM38i/4ri9FZVwvGHDFpGCbOjRS2d/3BCN04+LoLmfC1z/zmc
	CLLidY=
X-Google-Smtp-Source: AGHT+IHA0Xv5J7+oGM+5EIMa/TgKIPqiKF/W6nLtsDXM/L8bTAhhbxwmGZWD74HIRPitMmLb2XvWetVleZJfdJfBL94=
X-Received: by 2002:a05:6871:6205:b0:2c1:ac88:4a8d with SMTP id
 586e51a60fabf-30c21152297mr10911149fac.30.1754993907541; Tue, 12 Aug 2025
 03:18:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806081051.3533470-1-hugoolli@tencent.com>
 <aJOc8vIkds_t3e8C@google.com> <CAAdeq_+Ppuj8PxABvCT54phuXY021HxdayYyb68G3JjkQE0WQg@mail.gmail.com>
 <aJTytueCqmZXtbUk@google.com> <CAAdeq_+wLaze3TVY5To8_DhE_S9jocKn4+M9KvHp0Jg8pT99KQ@mail.gmail.com>
 <aJobIRQ7Z4Ou1hz0@google.com> <6a1d61925118b93badc777c2b9282d190c55a32b.camel@infradead.org>
In-Reply-To: <6a1d61925118b93badc777c2b9282d190c55a32b.camel@infradead.org>
From: hugo lee <cs.hugolee@gmail.com>
Date: Tue, 12 Aug 2025 18:18:16 +0800
X-Gm-Features: Ac12FXxGLATZGJ7RoDOdiXtGF_l2O8hV2IV1qNheuXDCF9NpwqbqYPnaHVon3C0
Message-ID: <CAAdeq_KUjUFz0y5rspoWLonxnh8C06NV5Dn4pGuuYPPaFJJ6XQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Synchronize APIC State with QEMU when irqchip=split
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuguo Li <hugoolli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 5:39=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Mon, 2025-08-11 at 09:32 -0700, Sean Christopherson wrote:
> > On Fri, Aug 08, 2025, hugo lee wrote:
> > > On Fri, Aug 8, 2025, Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > On Thu, Aug 07, 2025, hugo lee wrote:
> > > > > On Thu, Aug 7, 2025 Sean Christopherson wrote:
> > > > > >
> > > > > > On Wed, Aug 06, 2025, Yuguo Li wrote:
> > > > > > > When using split irqchip mode, IOAPIC is handled by QEMU whil=
e the LAPIC is
> > > > > > > emulated by KVM.  When guest disables LINT0, KVM doesn't exit=
 to QEMU for
> > > > > > > synchronization, leaving IOAPIC unaware of this change.  This=
 may cause vCPU
> > > > > > > to be kicked when external devices(e.g. PIT)keep sending inte=
rrupts.
> > > > > >
> > > > > > I don't entirely follow what the problem is.  Is the issue that=
 QEMU injects an
> > > > > > IRQ that should have been blocked?  Or is QEMU forcing the vCPU=
 to exit unnecessarily?
> > > > > >
> > > > >
> > > > > This issue is about QEMU keeps injecting should-be-blocked
> > > > > (blocked by guest and qemu just doesn't know that) IRQs.
> > > > > As a result, QEMU forces vCPU to exit unnecessarily.
> > > >
> > > > Is the problem that the guest receives spurious IRQs, or that QEMU =
is forcing
> > > > unnecesary exits, i.e hurting performance?
> > > >
> > >
> > > It is QEMU is forcing unnecessary exits which will hurt performance b=
y
> > > trying to require the Big QEMU Lock in qemu_wait_io_event.
> >
> > Please elaborate on the performance impact and why the issue can't be s=
olved in
> > QEMU.
>
> Is there a corresponding QEMU patch to use this new exit reason?

No, but the patch is done and will be submitted soon.

