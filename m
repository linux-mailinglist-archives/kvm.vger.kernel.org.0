Return-Path: <kvm+bounces-26753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA92B9770D4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:29:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3EDA285E41
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4001BFDEC;
	Thu, 12 Sep 2024 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W6GSm8TP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F81B12FA
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726165785; cv=none; b=PjYjRozFc192CaEr1OHL5yVq+wplymX4BEYBLxv+tPkeAOGYoyojMH7WsvSqPkM8fPC7csjwgJyA9rABKXZO4B7xtPHez0JC5/6pzO30eQb7qCUAbs3pmMSSqRNgqPSXKkC1pXMFWQEXBOxec7XbKS9R+8cRoD7BE7LorPrCBX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726165785; c=relaxed/simple;
	bh=gqzQaTlpGo+QX2EPoFVnO0rEY31FWTVAiW8vn/iHvw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rXEMyD71MVRmnc3kKRxZg+rxp7mPET3qW50Fh18fjgc+KSjG/iaopoNAj/wqa/LTZ1W5KFmJHd9hajGrnvHXgdpO5pKiXfnpJu55GYwOsqfuyeQEdacbLgZ5cQxXQNojvg2e6Si1+XNCC5Adb4OBLvVTOWckZQp+XIW5bd41kBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W6GSm8TP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726165783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDIH4mBgl9RAQst2WRBMWUVmbQay80eGVTkA1/RxoHw=;
	b=W6GSm8TPFQ4mblieTQ/xg/Ff4CBw7pjPw+8vCfLDoTBm5/eiJB+v4J9b4L1bp4bFR478sJ
	7TnWQGoOt+pa7u7QMsI3x/fHF21Q4pmmwsPZpz6ecPciNPqDOHrYiaKZooF5tnp/b8NTwz
	neKreHCDb+KOFBFmxbaNwGaHdebpbQI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-4lfJC74vNiW9FPlv-PLmyA-1; Thu, 12 Sep 2024 14:29:41 -0400
X-MC-Unique: 4lfJC74vNiW9FPlv-PLmyA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374b69e65e8so604504f8f.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 11:29:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726165781; x=1726770581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDIH4mBgl9RAQst2WRBMWUVmbQay80eGVTkA1/RxoHw=;
        b=nBxIbPtR5C1o+wf0L8g5REPsH3rhGeZTS4Ltu4AmWJeyNpRCx2XsRqJyfMD8/qW+62
         EOQXFBbAUQm5w7I7X9X03dgPJnZ7aMhqNkZccu/sZg5X/OfRLP2FYH0KMfxz12h+eugh
         0OAcz80KTfiwjmCOl/wSYiGgO83YpjDKrCA+QVEtLDj8ZaUdeIR32/3r9x/EQAt1JJ+g
         ENeaQ7kDJ3ukVrp0X0V34R9WRDzZYfuznL+Rr53VJstOw4FWq+aOhgbd5fbDHcmUj9lE
         63dKHTpY5NN+uyfKNcloP7lamQgcsliKizzNQ1tE1A5MlNU4KaWUN/ZomjNTgs7Bpoxq
         +8LA==
X-Forwarded-Encrypted: i=1; AJvYcCVQyAkz1X6BLn6XY45PefHLlGlcqeS7ozCRxBo0+a8TDuhFbzoO+y+I5h412B1ct74bUhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YypmpRRpBH8WjJB/8K3vOfJTXN3BnyNrQP4E8rJtLI7w/Rh775h
	Z0RkFJjkt94s/bSC6arSgY6q6BTgWZlkDCwvsRudGbndXrLffdJALKGuKsQq6InjsLm5U36red5
	3VlTsCtx77rI1FCXevJ+31Zja8qicX8M/xvLIgz8aBFrT++tkWrQT92XOZLNF+d6RB3ZrouNL5q
	gSwlZ0QfSlM/8FzMOcSBiQSxYJ
X-Received: by 2002:adf:fc0a:0:b0:371:8c61:577c with SMTP id ffacd0b85a97d-378c2d121c0mr2267734f8f.26.1726165780676;
        Thu, 12 Sep 2024 11:29:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQtfXLWHi72srHCUSdiyqWsp1/7c4sM6L9CY7al7GP3wF3pMbjYvkXS86BtezLsnLxSofUqszJG/BpEF6KTZ0=
X-Received: by 2002:adf:fc0a:0:b0:371:8c61:577c with SMTP id
 ffacd0b85a97d-378c2d121c0mr2267720f8f.26.1726165780132; Thu, 12 Sep 2024
 11:29:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com> <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
 <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com> <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
 <ZuMZ2u937xQzeA-v@google.com>
In-Reply-To: <ZuMZ2u937xQzeA-v@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 12 Sep 2024 20:29:27 +0200
Message-ID: <CABgObfZV3-xRSALfS6syL3pzdMoep82OjWT4m7=4fLRaiWp=XQ@mail.gmail.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com, 
	tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 6:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Sep 12, 2024, Paolo Bonzini wrote:
> > On Thu, Sep 12, 2024 at 4:45=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.co=
m> wrote:
> > > > KVM is not going to have any checks, it's only going to pass the
> > > > CPUID to the TDX module and return an error if the check fails
> > > > in the TDX module.
> > >
> > > If so, new feature can be enabled for TDs out of KVM's control.
> > >
> > > Is it acceptable?
> >
> > It's the same as for non-TDX VMs, I think it's acceptable.
>
> No?  IIUC, it's not the same.
>
> E.g. KVM doesn't yet support CET, and while userspace can enumerate CET s=
upport
> to VMs all it wants, guests will never be able to set CR4.CET and thus ca=
n't
> actually enable CET.
>
> IIUC, the proposal here is to allow userspace to configure the features t=
hat are
> exposed _and enabled_ for a TDX VM without any enforcement from KVM.

Yeah, that's correct, on the other hand a lot of features are just
new instructions and no new registers.  Those pass under the radar
and in fact you can even use them if the CPUID bit is 0 (of course).
Others are just data, and again you can pass any crap you'd like.

And for SNP we had the case where we are forced to leave features
enabled if their state is in the VMSA, because we cannot block
writes to XCR0 and XSS that we'd like to be invalid.

> CET might be a bad example because it looks like it's controlled by TDCS.=
XFAM, but
> presumably there are other CPUID-based features that would actively enabl=
e some
> feature for a TDX VM.

XFAM is controlled by userspace though, not KVM, so we've got no
control on that either.

> For HYPERVISOR and TSC_DEADLINE_TIMER, I would much prefer to fix those K=
VM warts,
> and have already posted patches[1][2] to do exactly that.
>
> With those out of the way, are there any other CPUID-based features that =
KVM
> supports, but doesn't advertise?  Ignore MWAIT, it's a special case and i=
sn't
> allowed in TDX VMs anyways.

I don't think so.

Paolo


