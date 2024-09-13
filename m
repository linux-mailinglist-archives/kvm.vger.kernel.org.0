Return-Path: <kvm+bounces-26855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C71978803
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ADD91C20BD9
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2C4132121;
	Fri, 13 Sep 2024 18:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iluuAxg+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC29126F0A
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252762; cv=none; b=qoHovrrGkl/FzMQoglplMycL8yqZRza36PGVSzuGw9A1iSBmpl/NCJqlpV2XOZO5h3jClfa/SCoDT03vNI67Bwz2CelWJ1P3CQWMOYpQ0nFxXl7DkPK1pkhYc+ivJ2KsPNX6ZA57ziIwJZ73EE9Zkr32gCf6kz18W1HyVG+y1+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252762; c=relaxed/simple;
	bh=0mjinyG1vQ9VPNowu/aF5fd8Gaqb239gzFrjSTjxTd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWmq4efYrvv1VFEs2aH2szGfsYIXIZak1HnYXNv9Ig4Aprg7nKex53O3YJnqgNnT241EXE/iqzOVA668fqd5ZhA06wyP2R6Uecw9hbLvjhX6Pj/B8p5seIfpxFjkEqmSx/Y8SHCNy/rZJHD1bbvAkoZC7bfOxQtus4eycUcWtMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iluuAxg+; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a045f08fd6so29785ab.0
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 11:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726252760; x=1726857560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ud/mHHSQausWCzpDvdCBlAPv0KqUcssPpprLfydgrHM=;
        b=iluuAxg+ka1+Y3GeozIGqQjmcbqFSOMpMxovWiTykqZgJBXRcbi1kkstf6VN/m+Mug
         t8zVJDTUt7gcGiVZJ2KlG4u0MC+WNusMS+Rb4mtq3SXnQHlAJEekngph91vVL4ZpaJ/J
         yWHRrMbHyPerzK3ocbtVTunr9ROKDyeBmD9rQS+M3Bj5YVuEPTygVqL6rW+csTLLx9QB
         eMYwLCjQaXq/zq9Gl05aUgfH8kuNVzxofPqa9qxyK2CCCygsf4uggyJCMy+iE+l2waV8
         MKkO9EG1E9i19shxV06/dJ+4HoFXcKWQEPDfVwJXxeBo6oz0VcQ2DEsBzrGB5VjBErQZ
         MhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726252760; x=1726857560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ud/mHHSQausWCzpDvdCBlAPv0KqUcssPpprLfydgrHM=;
        b=ObhllEw6zRU9QkpLqxttd3IbcpKf89loWhcgqLkBKSEdLGasoFuh+lp5lJxsnD5HtQ
         NLP3zKQCc3SaZCsxvpgBdnewj9jNsO9M8VgZMRWHdE935nFwl4a6NgzVo9XuNNl+KWHf
         vpysQcCGk6DEsDzm2AB30PPzRgGjABfGB7usy9Ux7oCAoEX/mAKL+u9n2dj7KDtText4
         nuGeOmBoGvJ26YcW0GyJL9084YbDvhUlxsTn6YzFSacix3CxIqeqynwl2F6uXKahBSVZ
         Rxgqx4n4jFA4ab9ad4U1GHqcj2BUrTwTOWrQuUUmWuUT38aAO0uI2OnFLLzq1aV1kuhO
         ZnSw==
X-Forwarded-Encrypted: i=1; AJvYcCXJkZNbVdWg1BSz2moCcUaTA6LipR4tfvwWi8K1HWNuZ8gtOGIeeL6nIcbHAfRxYYbWync=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaaNJh9y7h3grjtNYOGf0IBzxDZjgFnbDRl0g4dV6UOC6ljam0
	3j7OUPDKl14uQvK+3afbQELqYbAsawxrKrM6wM1CvKlk+59rOolfNR3j2G8bHR+2l6Ei6y1e7IT
	qHo/sx+BO3vBhCC0yO15mdVWUZVexwSOa9Ywn
X-Google-Smtp-Source: AGHT+IFIB+0iYlnluWMyxDDG65+XyKrHZg/GyrbyaUN2OxJI1M8y35fV8elsIsbPrdyS6cnglGKL5tq6VIqj4bPlvlY=
X-Received: by 2002:a05:6e02:1886:b0:375:edce:baf1 with SMTP id
 e9e14a558f8ab-3a0856cf368mr10155715ab.13.1726252759723; Fri, 13 Sep 2024
 11:39:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912141156.231429-1-jon@nutanix.com> <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com> <20240912162440.be23sgv5v5ojtf3q@desk>
 <ZuPNmOLJPJsPlufA@intel.com>
In-Reply-To: <ZuPNmOLJPJsPlufA@intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Sep 2024 11:39:07 -0700
Message-ID: <CALMp9eRDtcYKsxqW=z6m=OqF+kB6=GiL-XaWrVrhVQ_2uQz_nA@mail.gmail.com>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for 'spectre_bhi=vmexit'
To: Chao Gao <chao.gao@intel.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Jon Kohler <jon@nutanix.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, 
	"kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 10:29=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrot=
e:
>
> On Thu, Sep 12, 2024 at 09:24:40AM -0700, Pawan Gupta wrote:
> >On Thu, Sep 12, 2024 at 03:44:38PM +0000, Jon Kohler wrote:
> >> > It is only worth implementing the long sequence in VMEXIT_ONLY mode =
if it is
> >> > significantly better than toggling the MSR.
> >>
> >> Thanks for the pointer! I hadn=E2=80=99t seen that second sequence. I=
=E2=80=99ll do measurements on
> >> three cases and come back with data from an SPR system.
> >> 1. as-is (wrmsr on entry and exit)
> >> 2. Short sequence (as a baseline)
> >> 3. Long sequence
> >
> >I wonder if virtual SPEC_CTRL feature introduced in below series can
> >provide speedup, as it can replace the MSR toggling with faster VMCS
> >operations:
>
> "virtual SPEC_CTRL" won't provide speedup. the wrmsr on entry/exit is sti=
ll
> need if guest's (effective) value and host's value are different.

I believe that is the case here. The guest's effective value is 1025.
If the guest knew about BHI_DIS_S, it would actually set it to 1025,
but older guests set it to 1.

The IA32_SPEC_CTRL mask and shadow fields should be perfect for this.

> "virtual SPEC_CTRL" just prevents guests from toggling some bits. It does=
n't
> switch the MSR between guest value and host value on entry/exit. so, KVM =
has
> to do the switching with wrmsr/rdmsr instructions. A new feature, "load
> IA32_SPEC_CTRL" VMX control (refer to Chapter 15 in ISE spec[*]), can hel=
p but
> it isn't supported on SPR.
>
> [*]: https://cdrdv2.intel.com/v1/dl/getContent/671368
>
> >
> >  https://lore.kernel.org/kvm/20240410143446.797262-1-chao.gao@intel.com=
/
> >
> >Adding Chao for their opinion.
>

