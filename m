Return-Path: <kvm+bounces-61243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F51C121E4
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21D181A259D5
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A0D32C323;
	Mon, 27 Oct 2025 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JKkpqAPF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C14F19D08F
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761609506; cv=none; b=C8c91vSk0JvpyxIyQFqJHPM9LmE3lmzHtbcq0rsuSNnxNSdo30hL+yDda5TIxV6FWINDBvx7WKwRkd+zxNguRPFSm8O5FOMnIHhJ8MkDWa5wA3FQ/IYdpHZtYW2bSPbWu9qAvi5T0ZR25yS2h1/YwH8BNNyW2WPLayRhfA3Mq+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761609506; c=relaxed/simple;
	bh=B3mpFVAR6ZmcNWLBi88Xta8WGYLy+I86D02flIVttrI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XGSwvriTsrzPJ/G33GtJDCJD02sXJUM+NvVjLNUENb7iyeyzwE2vnjz49Er1DLwf7H5wcwED8DO7/ESUgnOfIuHTDT6hFaZxA5h3Thaw7g+Mywz0attfSYB+SYizL0mECuUV5Vr58ytUVksRVTP7NaEBpuhM1WzVXJ/D6fOIzx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JKkpqAPF; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-63c44ea68f6so4722a12.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761609503; x=1762214303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9F1wSsSxhw2D505fXHUdjLY9NdHqh0zXhSCGVR/itg=;
        b=JKkpqAPF2K0zQPqB6mLPQdzCvXG3z9KleGjfprAjVFPvnTyU79PccWGIckYtl5eqPt
         WBhZcrTWIFxDBax5bhpNbLvNk/lDuwE0T14uiLre4McmpbHnY8bi9aKyMwbrYcj3KQLR
         Jq+yez/2IUM5pK/4HBqeHyBDEnEnLDuDehTQLfp+vtQSXoQ2KBDu/MecyHYzXUAFBmsm
         MCm1kOv59mrPEweqLxUhqLs2yee+6r8K/ts7JL0CaW4Aw2/IZ2cMBvB1yVk1gNsO29BD
         RhSV2uuoDIB1AiyWqoWPRyxD5BLXbmNqpP1EpGSHA4SH5kcCM8S/cV+FjRP5fyX1Ur4W
         B/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761609503; x=1762214303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9F1wSsSxhw2D505fXHUdjLY9NdHqh0zXhSCGVR/itg=;
        b=vIUP8SgatpMLGwKzI5fu2k++3uZ1fCNAqYpXBws28oC9kMQpFYarETtCYVyZEoxDEY
         OBP7AKuD+RPgDh1WvjP71wmjGRjIqQNNiAWk5aGYRL7PxtEjRnxyH6vd1Guw8mZOx7cA
         cg6/MST6Y3Uisz3wFE1Th1lT9YsOyypVvubB+jo41SSo6g9N6Or3/djWnoukZOeopuGr
         e1g+k2sqNIVxmGfFkb1/IraMLl4Md83S051+JEFE2HB1fTB9SFms+tTOuVDJY86Pfcr5
         jcSmvAK3K7V+PfOcLm4XF6HYcScLo9lNOm0JCUjEQ376URRKCOxF53vXHRuzgf/jmt3K
         y1TQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCRW9JkHHcw9tXhpxCf/GhKkfWwmnYy9XKEwS7O7Q6ExA3PATLB2gT9BGc3O3/Y+9axTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuTCVfkauRTDoXyccISzNvrRBHTTPLOyKLMfHeEzZekJt+wk11
	VDlk51atoA8s2OKq6zrrrF75tVC7bXLU565YnRc1hbYn0ZOKQN5HU5a0dRnxMmLPyd555art+xh
	umeiDvOrKq1RuTHHqP9fJvYhcx56sDgiRCPWkTBD/
X-Gm-Gg: ASbGnctYlJk35vYPXCydi1xj5m6d9tjXGUohd+MR1NNIape7RXXgndpWSuq65CApDjy
	BpeQponjCsRzTqorM+4t4NhyKwKxg0cMuz99tk0Rs6Zgi9pGVXAbkccFVmq1LVHtvxa29tlcTN/
	mysC0UE/A91G39Q9ACYpl1eubT+jawu//tegQK2SuAV7wIrl6naD5w6m5KFFkv/4FiOhc+Rn34u
	6Cuex7XfqUA937qDE9+B+UgcsmI84JN58jCXE1wTjcaMbakMQ7mWeAtIKmnVmMkgkjbO2E=
X-Google-Smtp-Source: AGHT+IFI7RbCRSrkZ+26mAjogVrTWudlWrC8fSNj8O9PmlVdQ7Csv0X4ZvVnTgaBHpL6T+OSCphRK3ecNFW9+faxMrM=
X-Received: by 2002:a05:6402:206:b0:634:b4b5:896f with SMTP id
 4fb4d7f45d1cf-63f6f88db75mr39252a12.4.1761609502550; Mon, 27 Oct 2025
 16:58:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com> <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com> <aPe5XpjqItip9KbP@google.com>
 <20251021233012.2k5scwldd3jzt2vb@desk> <20251022012021.sbymuvzzvx4qeztf@desk>
 <CALMp9eRpP0LvMJ=aYf45xxz1fRrx5Sf9ZrqRE8yKRcMX-+f4+A@mail.gmail.com> <20251027231721.irprdsyqd2klt4bf@desk>
In-Reply-To: <20251027231721.irprdsyqd2klt4bf@desk>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 27 Oct 2025 16:58:10 -0700
X-Gm-Features: AWmQ_bk2eMNKxzyzah9DPVxHOoXxsYy6Xljo8QBDtIqM98MaTcgTmbgiB2zzshM
Message-ID: <CALMp9eSVt22PW+WyfNvnGcOciDQ8MkX9vDmDZ+-Q2QJUH_EvHw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D cache
 flush is skipped
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 4:17=E2=80=AFPM Pawan Gupta
<pawan.kumar.gupta@linux.intel.com> wrote:
>
> On Mon, Oct 27, 2025 at 03:03:23PM -0700, Jim Mattson wrote:
> > On Tue, Oct 21, 2025 at 6:20=E2=80=AFPM Pawan Gupta
> > <pawan.kumar.gupta@linux.intel.com> wrote:
> > >
> > > ...
> > > Thinking more on this, the software sequence is only invoked when the
> > > system doesn't have the L1D flushing feature added by a microcode upd=
ate.
> > > In such a case system is not expected to have a flushing VERW either,=
 which
> > > was introduced after L1TF. Also, the admin needs to have a very good =
reason
> > > for not updating the microcode for 5+ years :-)
> >
> > KVM started reporting MD_CLEAR to userspace in Linux v5.2, but it
> > didn't report L1D_FLUSH to userspace until Linux v6.4, so there are
> > plenty of virtual CPUs with a flushing VERW that don't have the L1D
> > flushing feature.
>
> Shouldn't only the L0 hypervisor be doing the L1D_FLUSH?
>
> kvm_get_arch_capabilities()
> {
> ...
>         /*
>          * If we're doing cache flushes (either "always" or "cond")
>          * we will do one whenever the guest does a vmlaunch/vmresume.
>          * If an outer hypervisor is doing the cache flush for us
>          * (ARCH_CAP_SKIP_VMENTRY_L1DFLUSH), we can safely pass that
>          * capability to the guest too, and if EPT is disabled we're not
>          * vulnerable.  Overall, only VMENTER_L1D_FLUSH_NEVER will
>          * require a nested hypervisor to do a flush of its own.
>          */
>         if (l1tf_vmx_mitigation !=3D VMENTER_L1D_FLUSH_NEVER)
>                 data |=3D ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
>

Unless L0 has chosen L1D_FLUSH_NEVER. :)

On GCE's L1TF-vulnerable hosts, we actually do an L1D flush at ASI
entry rather than VM-entry. ASI entries are two orders of magnitude
less frequent than VM-entries, so we get comparable protection to
L1D_FLUSH_ALWAYS at a fraction of the cost.

At the moment, we still do an L1D flush on emulated VM-entry, but
that's just because we have historically advertised
IA32_ARCH_CAPABILITIES.SKIP_L1DFL_VMENTRY to L1.

