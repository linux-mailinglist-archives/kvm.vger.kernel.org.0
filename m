Return-Path: <kvm+bounces-55778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C757CB3713D
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 19:21:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AC5664E1D1B
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8302E7645;
	Tue, 26 Aug 2025 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqfI5FOU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C32E371F
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756228871; cv=none; b=hMI3UKLHxVKDYoAqdNrN/p7jqcOYNCvlQMTcVnmvVlnUEKOWdV7wc0ocwDR7MCt7ob5zJJOsBuRSvwXK42Rg5KZqq5NN6PVsUiY23x2DQkTHf62cyqwDixLLAikLYzbrICyIzc0FK+giFLAjiOBwk1HsjgIo5mgH+1/vLotIF04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756228871; c=relaxed/simple;
	bh=ObpM4zfxjeNqLpjh6zKTISSq/zqH9nAe3Gg+D1X5idY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hE6XcwwLAf+KcwwgtkvUtjRAycqNJcac7t5EVkbV38D1RXbzOq7mXpgxwARodLk/bSTRxNpyleG9+xvrIGNImWWU3tfr40Sq9OxPbcDZS5wMrHYZB8CBebpVf1bhx3zenJ9hzQ4J0UUP2jjWsmWhqZ3penRduoiP+IWcHk5f3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqfI5FOU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756228869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fixj3Stcqv3YSb/G1fSDEpAaxUmrXH3yvg6FMQ45Vtc=;
	b=eqfI5FOUowe1supvsPw6bcwnwrqeU+AixjavXyuvsYa6tTlsU+oFV72ad2wChIrHGOCI/j
	pfpX8JU/sSANLk/m4KzRuglua5JgtyVHpXUAOK5WQcp1eu3n4qcPDUGffRr0WDPiQJxggd
	Nzo+8jgF9iWB9sMlICe3ss7AEAP/59I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-ImggtzeUMoKv9WsLEltNIQ-1; Tue, 26 Aug 2025 13:21:08 -0400
X-MC-Unique: ImggtzeUMoKv9WsLEltNIQ-1
X-Mimecast-MFC-AGG-ID: ImggtzeUMoKv9WsLEltNIQ_1756228867
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0514a5so26205595e9.1
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 10:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756228867; x=1756833667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fixj3Stcqv3YSb/G1fSDEpAaxUmrXH3yvg6FMQ45Vtc=;
        b=ByEtd+Y+pIg/cdUXV78DRTnnGGPARtVu4aeTC3KiH0xUONsXy1MKcV/51q1nt5NgPi
         SF6DTdGSV6+bsxsCLzTfcDoDUb2U4DC9qxAtLDfB3VRFtw5UufSIlTMTU7yr1/SIKjif
         FbfV3EeHHKTxLXCewza2zzlQhhV0hSo4FQHRaSqdrxh4lH9vVjaRsjORAkPlT4qx1z4Y
         zhkwKipyg6y0j+OZrdEIzTdxkLcGfrUxvEQJ5xiWeUA8jdCs43p5ElM5NTAtvgo2mw1B
         6CO9I4WBthfRR6+g7EA+oGbAW+Dr5QhzAtWNtTagAWghV4/ELvTpOFe3QiO2YEDU4GYk
         OtyA==
X-Forwarded-Encrypted: i=1; AJvYcCWheTS3xqSaXE8aGTRS3knumdRaDyA9SBET8VoJdq2ByI5ZT7aijeVQBmtZBpsecv3byRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzynRWXDdqblLbHCu0b3T1jDZwqBi+zUSo1BAMzr5FXuQxLURf2
	6gwoCNjvNbASRn5qbn2k9tbhpBJQDj0vfEyIn7ugThsa0NseloIdbveT3t4fK6rFGGH4216cgsj
	FNTCmfKryjFYftl7l3Yjf/jJ8ZUPVo95MxdZA76fmrzWz0qsdqxVqhOJDW56pgXyzJYx/T1swKp
	+7lwEgTLpHov44lAly6sE4C0uVIP5T
X-Gm-Gg: ASbGncs/PhYJHMQ2G5nqfPu6+GFGDWDnCh5Fq+R3h1gPRiqJ7PxO31l6JnmbQ7V8b2J
	Mik2dBnTSyz97pjol7Nb37o7ABsB5MLspjIrvauKsfDgZdUpyBzc3zWSv8g27DsdYEAW5F5IRRT
	1K7HgyW3Y0dtVdd2KwDS8t7Ytabp9MUcNRk8hnPN2h0cFsVpNK7REkBOUOdN2flwQuAehmmRESN
	rjGjgmo8+yoDLWx7YsKh5tG
X-Received: by 2002:a05:600c:5494:b0:459:94a7:220f with SMTP id 5b1f17b1804b1-45b517dd998mr127408405e9.26.1756228866806;
        Tue, 26 Aug 2025 10:21:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQK+UMrmTalA/0yt5zGTuiTwqwEKe+V5z92y/ayCCHYPF/64dT/Zz/jRg3RjoAUNG5Qs7uJdCqXDZ8Y/3DTtM=
X-Received: by 2002:a05:600c:5494:b0:459:94a7:220f with SMTP id
 5b1f17b1804b1-45b517dd998mr127408025e9.26.1756228866380; Tue, 26 Aug 2025
 10:21:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1756161460.git.kai.huang@intel.com> <14f91fcb323fbd80158aadb4b9f240fad9f9487e.1756161460.git.kai.huang@intel.com>
 <aK3qfbvkCOaCxWC_@google.com>
In-Reply-To: <aK3qfbvkCOaCxWC_@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 26 Aug 2025 19:20:54 +0200
X-Gm-Features: Ac12FXyzQ1leHRicGbaeNR93onBSfmUg8YaGLjd2_nEWUKqlyFd7oqoW-3jonEA
Message-ID: <CABgObfaZjcDvFVWO7rsr2e_M=F6r=sEq+GHjtEp04uhj29=MuA@mail.gmail.com>
Subject: Re: [PATCH v7 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
To: Sean Christopherson <seanjc@google.com>
Cc: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, hpa@zytor.com, 
	thomas.lendacky@amd.com, x86@kernel.org, kas@kernel.org, 
	rick.p.edgecombe@intel.com, dwmw@amazon.co.uk, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, reinette.chatre@intel.com, isaku.yamahata@intel.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, nik.borisov@suse.com, 
	chao.gao@intel.com, sagis@google.com, farrah.chen@intel.com, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2025 at 7:10=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> Can you add a comment here to explain why this is done even if the kernel=
 doesn't
> support kexec?  I've no objection to the superfluous flushing, but I've s=
pent far
> too much time deciphering old commits where the changelog says one thing =
and the
> code does something else with no explanation.  I don't want to be party t=
o such
> crimes :-)

I asked on the review for v6 to make this conditional on CONFIG_KEXEC_CORE
with a stub; Kai said he'd rather not and I acquiesced, but now it looks
like we're going to need a v8 just for this comment or to follow that
suggestion of mine, which I still prefer to a comment.

To be honest I've never felt so frustrated in ~10 years of participating
to Linux, and this is not even *my* code.  Not your fault though.

Kai, if you're also frustrated I can handle the v8.  As you prefer.

Paolo


Paolo


