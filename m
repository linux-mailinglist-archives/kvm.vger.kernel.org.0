Return-Path: <kvm+bounces-17334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A37FA8C44FE
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 18:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15CB9B20DDB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B586155355;
	Mon, 13 May 2024 16:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNqmLJSG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426E415533E
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 16:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715617254; cv=none; b=idNtCAn+wM+qpmiMFq5Y028K4iDwWeD6W45qIjV0bn/ckySJ9JGe3fISURvQlC/OK3OJxrtPJtiHr2vkG11NHsOPbppcUkDtYfj62nSc0ZTfypJgLDfSj5XH8l1mdymE6u8fbXk/OW7rz9Kof23dT6tEHf6fzomyjfPkRotPfTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715617254; c=relaxed/simple;
	bh=BdY/cBLngQnlcwyixvI71fNjSSKMQrGCPriZ2LpM/Ic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MrTf5tVpn0A8G6NbvFtLku6BNa7yW4TMTRbp8vIOQWVAHSupXMbJofY1vVQmb7WBtUW1eNoq/HXSt5jakudTEbic2WPWh9JY79veNqS0fK1i2EP3zF1YzTsUFtW3aEzb2zTh6OXhw/rSQJ2zOWl3ImLgo3ZaWH/NSSgmQ+QAzGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KNqmLJSG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a49440f7b5so3883840a91.1
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 09:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715617252; x=1716222052; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zgt+w/nU1JjUrZ0GRJPLjZLIv1xcz6lTgN5YKDDkzT8=;
        b=KNqmLJSGpLRA+dQx83K8Sr37612TC3IE4T2huVpE6xzee8kFLmHl+q+Vfw8InNTvIr
         ErmhgUtLq4hpc6iwAmUR3XxQxIwYybcNVDBYuhvECqof78EpEqoFWoaPgJVBr5eJd6xO
         nviPf3KbcM/8aK6PrYHsCDfi1qGnoDkY8ZhWV4HAc3HMnSkdjXKTAVf/EX/uQ8nFP3Gh
         IG8tp3WdJB5gtwbCnvyOulGJM+ZCP0J1HGv4Gd8F4Olxb8UgBNXFTzzG6IhkIGEDUH0i
         pjQ5nx9r+MgNN/Z959gSonbKSTu7O/y6ZrphF/RNn1qPtpQYY0rgIFaqwiYUly8gunis
         pb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715617252; x=1716222052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zgt+w/nU1JjUrZ0GRJPLjZLIv1xcz6lTgN5YKDDkzT8=;
        b=bt7dk2GS2c+YXT+6c5Hv2/iOCZlKJ9vUnw8KlaX0DOwbnFSykUxonlyZGiuTRtW00Y
         oshQvW102c3umLNboB2QmlfiSXAaei8J2RwpRuwRuV2Fp9/JWdGBhd4GPF22DfruiFFE
         GktOg/Qgp+SCt1JJt5spbuS902C5GhDAQfZZ7qD6NzqyuPzfATce0ZpWm8wgHn72X3Ow
         Tmkj0mFsbvU+51ZOmIc2OX7m1j1vXa4UJr/ECWn1DHG2UMJBo18KK6ZmZvxRS9kBk1/O
         WRdPP04u8keireoKNuRkib8lJRo0iEmr/Z18Z/y//EYK+9d45DXD4TzJhiAq5Ri4JOKX
         p/KA==
X-Forwarded-Encrypted: i=1; AJvYcCWBWViVX76nWMDfYSunUdlUpaB0eBkI6Uf6orCfxtTrcnr+hbm39cAcrxc/1i6hNtXEKcwWkckCdcWf6sCG8TX1x4FP
X-Gm-Message-State: AOJu0YxDrYdVRDoKXjSEqlVfBzE+6vh6r8LloV+XoTSt3dgqLJNzUsqx
	PCL2O+FM5m9/DfcTpLZWaYUSy/36Rjyw/TqaalNNCzDNQwK/sz/yrhfyNHN5kC20h1I6lnMU52X
	t3g==
X-Google-Smtp-Source: AGHT+IFHnrXdTgKbPjNIvcthWplF4GAmm0C+xXuTvFWx+kW05nR4GtvDbz0e+nNcsaVMkxBWnlqwf3ezKV0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:350f:b0:2b4:32ae:483e with SMTP id
 98e67ed59e1d1-2b6cc03bd09mr29750a91.2.1715617252422; Mon, 13 May 2024
 09:20:52 -0700 (PDT)
Date: Mon, 13 May 2024 09:20:50 -0700
In-Reply-To: <4f2112f3c4f62607a1186faa138ccc06f38ee523.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425233951.3344485-1-seanjc@google.com> <20240425233951.3344485-5-seanjc@google.com>
 <4f2112f3c4f62607a1186faa138ccc06f38ee523.camel@intel.com>
Message-ID: <ZkI94l9rcfBSH0pV@google.com>
Subject: Re: [PATCH 4/4] KVM: Rename functions related to enabling
 virtualization hardware
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, May 13, 2024, Kai Huang wrote:
> On Thu, 2024-04-25 at 16:39 -0700, Sean Christopherson wrote:
> > Rename the various functions that enable virtualization to prepare for
> > upcoming changes, and to clean up artifacts of KVM's previous behavior,
> > which required manually juggling locks around kvm_usage_count.
> > 
> > Drop the "nolock" qualifier from per-CPU functions now that there are no
> > "nolock" implementations of the "all" variants, i.e. now that calling a
> > non-nolock function from a nolock function isn't confusing (unlike this
> > sentence).
> > 
> > Drop "all" from the outer helpers as they no longer manually iterate
> > over all CPUs, and because it might not be obvious what "all" refers to.
> > Instead, use double-underscores to communicate that the per-CPU functions
> > are helpers to the outer APIs.
> > 
> 
> I kinda prefer
> 
> 	cpu_enable_virtualization();
> 
> instead of
> 
> 	__kvm_enable_virtualization();
> 
> But obviously not a strong opinion :-)

I feel quite strongly about using __kvm_enable_virtualization().  While "cpu" is
very precise, to me it implies that the code lives outside of KVM and isn't purely
a helper for kvm_enable_virtualization().

