Return-Path: <kvm+bounces-42122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E3D8A7343A
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 15:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250601746FA
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 14:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F1A217716;
	Thu, 27 Mar 2025 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pAijumPJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AD41F1911
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 14:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743085151; cv=none; b=FXgD3ngHE1T6ktASljRmkai4dxwPAbMWal/U8eQqnTn47YgYknD5wmuaAFltz0xOaYWVY1CS5saHEdLExmXk6Lb6kFmkU3ciRnRnM96Je/9e7uGjGeOwW1WaraH5oE3F/4yKloemdZQiYqD2tv5qh4A16jB/iDR5212nrnKRyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743085151; c=relaxed/simple;
	bh=n9lJXBUGa5zrXwrCUF2Kk6gcmEYUNLHmq/4L450ViQk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sWFAd4kmq0FabEwMW9k4L8x+opn8rJa0/5giYkXBroxkqRBX7hZAgXEkFAPENqtGm6s5G+upvcFKKmme3TPW51r6TSLWzrXD0GOJQ26uKp9SvbXCjOVhMUFFv0QPGDsrscMI06HRHCQ2NYMPdL2PdDzNZqJetQWsxrb7dLgotq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pAijumPJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-225107fbdc7so20060005ad.0
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 07:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743085150; x=1743689950; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a6zhaLPdcwFOXcRVTwEe/u/+t8uTzMuCjiG/G61KRZs=;
        b=pAijumPJuMVuXBHMePHlf1CKrdS8grFGMPosIImDa5vKsrX6Z7LlpE2WNuKe9OyOKE
         aWceQyCfuI5hYCeM2VgNnKNaCIDqvZpZUq6iwwOstJzMopyXy/eEiZtnPJSDL2L5Gwv9
         NafzcpxMZ7e9vGRgCvsR6Gqun8vz+zlOzuvv+YiFSkU8wuFCWx+avv3iaXWdY0ylANJQ
         usFqolmWw/j1yZBb33xlfmvpIUpHA2kqZ86aIBvVUqeTaCaIhqB9G+b+3/IxvXIv4+Jc
         EIQsnpchf9qsU2Wub8zQPY59uvDawdRg3/V0DP3EK1YbL1OtujZFuj+f1brtiiRbdUcv
         nB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743085150; x=1743689950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a6zhaLPdcwFOXcRVTwEe/u/+t8uTzMuCjiG/G61KRZs=;
        b=fkGDYZO55YxWXveaDxwf/GfEzQMEcVJTDL8LyDxTf3Ot93+tuOUH3zLFQH9dcJG4v+
         1VTVx/RMKFJXgrdN073LDymHurvW9p3e2DSv85t1KccirLeDw5DqUtBqOq8ilKajYHRN
         xKryPy58jD6igOAaZNmNWSmTk7gSS8iblcbp56ojI2EcT5PeHzDR9WuwDWoReuXsolog
         WuWVgTxG7E3RdedRtroraseeFhKGK9joKdE2EllNF9kNMc563dbnZ7hxOc+69hP5Pcjo
         spGnordTT6KM4aU+4EiOxe36vqfUphMdjP+0fHG6DywCf2KqT7Il0X8t3188xPEl81te
         MpXg==
X-Forwarded-Encrypted: i=1; AJvYcCXOiY3706SHOwju/ZfMtBZd+uEtHCJSMIDGGowDHS5ipZCzZ2mSgqZk1dcknu2g3aEdkOM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwadCeQz2+KAz/LunZz+y5Y6QMgR/j4Bj8NrGS37JLzLkXMdosO
	FC2sdwowr7JG0naGA4ZZMzhbvZMeWdNtcyDXy6M14DcPgLRaoJUIH07VA2/iMt02UyoPIQqu1T/
	oJg==
X-Google-Smtp-Source: AGHT+IGGMam9T8WozeRkBPD4Zm4Ke69jphYD5viKBJMLvC6WDpQ9ldVOH0lnViHJMtvgvrrUpiHczcFTs7o=
X-Received: from pfbdr9.prod.google.com ([2002:a05:6a00:4a89:b0:736:a983:dc43])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88cb:0:b0:736:d297:164
 with SMTP id d2e1a72fcca58-73960e0bd64mr5021035b3a.1.1743085149770; Thu, 27
 Mar 2025 07:19:09 -0700 (PDT)
Date: Thu, 27 Mar 2025 07:19:07 -0700
In-Reply-To: <87msd6y8a7.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-14-Neeraj.Upadhyay@amd.com> <87cyea2xxi.ffs@tglx>
 <Z92dqEhfj1GG6Fxb@google.com> <87y0wqycj8.ffs@tglx> <87msd6y8a7.ffs@tglx>
Message-ID: <Z-VeW0IuqMI8dYlH@google.com>
Subject: Re: [RFC v2 13/17] x86/apic: Handle EOI writes for SAVIC guests
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org, bp@alien8.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 27, 2025, Thomas Gleixner wrote:
> On Thu, Mar 27 2025 at 11:48, Thomas Gleixner wrote:
> 
> > On Fri, Mar 21 2025 at 10:11, Sean Christopherson wrote:
> >> On Fri, Mar 21, 2025, Thomas Gleixner wrote:
> >>> 
> >>> Congrats. You managed to re-implement find_last_bit() in the most
> >>> incomprehesible way.
> >>
> >> Heh, having burned myself quite badly by trying to use find_last_bit() to get
> >> pending/in-service IRQs in KVM code...
> >>
> >> Using find_last_bit() doesn't work because the ISR chunks aren't contiguous,
> >> they're 4-byte registers at 16-byte strides.
> >
> > Which is obvious to solve with trivial integer math:
> >
> >       bit = vector + 32 * (vector / 32);
> >
> > ergo
> >
> >      vector = bit - 16 * (bit / 32);
> >
> > No?
> 
> Actually no. As this is for 8 byte alignment. For 16 byte it's 
> 
> 	bit = vector + 96 * (vector / 32);
> ergo
>         vector = bit - 24 * (bit / 32);
> 
> Which is still just shifts and add/sub.

IIUC, the suggestion is to use find_last_bit() to walk the entire 128-byte range
covered by ISR registers, under the assumption that the holes are guaranteed to
be zero.  I suppose that works for Secure AVIC, but I don't want to do that for
KVM since KVM can't guarantee the holes are zero (userspace can stuff APIC state).

