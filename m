Return-Path: <kvm+bounces-57642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 802EEB587BA
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:43:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B8B84C3233
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FAC2D7DEF;
	Mon, 15 Sep 2025 22:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZeqskzkJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083162D7DE2
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757976203; cv=none; b=FXabh5gkbSwqrIf2jRwej1froTyxMtFg/4cAfNHmp3w0GU9NqGmfIPxrHs/NRWOLqD7UHkQ2nbMBBr4dEQ72A+dzn/HdmLweES58teFu+JupLRs3PQjeWgIgv3e5SHtjFeboY4rPYjqm5u3LiD8o3Syhs3urFG5nNZ+fLxkQrqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757976203; c=relaxed/simple;
	bh=UL9ofUZ+TLGr39CpuRj0A0gQ2R4cng1g3sobE8KYVrQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0fxYVOLeLeGcPfGnftbYU1zdhv2wsvWVhVEgZSXurFD3NPLGUf8B8na1LwUMIhRpknJeYGbIfGVTb90RbEbur7ASDdYrQxv5cVkzTPBQqRZXZy+CxwhT2tEwgLiIhq0ii7XYBFtfQLbjn5u6/rpi/DYFsXdKr41jhP8wnjc8e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZeqskzkJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32db3d5f20aso3950901a91.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757976200; x=1758581000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTmKKOoK9HRH7Hm55Fje656r3lIJJVbPXOnql+zF5l0=;
        b=ZeqskzkJZwkjYV28ivmYnsoYmnebbPSfXNl4Ldvv/8y3eky9k+PzAmeu5iDjzTn+Y3
         iBpMA11gZTLrool28csGkK2Nkat6zBtIpvP1zZgg2mZ7Xww/Kibu/NeMsW+HfTUq1g+6
         qpkRmVuDIcsYvNB4/rWRPveXBepWirQ+trwbAW+QS5VdduaoBPNGwYvbcQQ8+IQyVoNI
         GaKutQsxP/ayLaeG5CwM47YeeoQOYmg8Znch+X2qIn5JgdbcfKJGY+0VJ5fLVgj30/9h
         OzRxCHjNOuIRbcxMVfSSGEMLgcXw+lseju8JorQuX5moKrK7DBOmpTgR0eC4hOQwaGyA
         aBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757976200; x=1758581000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTmKKOoK9HRH7Hm55Fje656r3lIJJVbPXOnql+zF5l0=;
        b=EMKHoaTDxWMudUgIrSi2QD4b5G3ssPJgne6Snrb7HyGAjJSuocULREkuAfRp/oMfEB
         2t0ZgqYn4xVrT5UlSmLmr3LlIhGK8V5mQ5ZxnTE1maM3eKZ0jJxjk95cuHu+oZ8yULRT
         d6zsvycSd1K3uj6z39q+kG83bJlyKODnFIgD+LQUvnfxhdMaCC8M432zVNMeKH2kC4c1
         AKvQcu2hr68C9g1u2wr5u/vCNvJ4VOCSuhWZbOXHZKoWSVYGIumsejY2V/uuv6TWqSaw
         2LvGcNjG7OaRasj1Rq2uQ2IrDiMPlydefsqu99vpivmjD/Yt2BCa2MaR5qtZaWUAPEYF
         O9aA==
X-Forwarded-Encrypted: i=1; AJvYcCUv0AvKvTab942WR1xbVfpPkDNNw3Dy+t6EARic2W7KkeZdkcUAgqgTB5VgVLOtqCjo3ko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdplc4vcCjZjTEPKrvwwSTYNnhnoWI7myTsMSRaqEqmqndFSA/
	bGb5GxClBChoFvTopCCcgJxshH0+OkHt8SIkzmZmoI0+ZLQ1RgNfl/kMlBfj6nAh/LZRjHNpMdK
	gAyNPjA==
X-Google-Smtp-Source: AGHT+IHyB1Zkkw8UWqFOUv1VXd2ZvxF3Tlz4wNersnSR83RRj+4ouFnOKHHJrI75QZ57u5yLMJyvKuNEAk4=
X-Received: from pjbpw1.prod.google.com ([2002:a17:90b:2781:b0:32e:3830:65f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4c:b0:32e:3c57:8a9e
 with SMTP id 98e67ed59e1d1-32e3c57a4e1mr7675380a91.35.1757976200369; Mon, 15
 Sep 2025 15:43:20 -0700 (PDT)
Date: Mon, 15 Sep 2025 15:43:18 -0700
In-Reply-To: <1a69b5a7a6eea24fc93f9dc5fb60bc9f434568d3.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1756993734.git.naveen@kernel.org> <1a69b5a7a6eea24fc93f9dc5fb60bc9f434568d3.1756993734.git.naveen@kernel.org>
Message-ID: <aMiWhrNEEQgxx8g4@google.com>
Subject: Re: [RFC PATCH v2 4/5] KVM: SVM: Move 'force_avic' module parameter
 to svm.c
From: Sean Christopherson <seanjc@google.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Joao Martins <joao.m.martins@oracle.com>, 
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 04, 2025, Naveen N Rao (AMD) wrote:
> Move 'force_avic' module parameter from avic.c to svm.c so that all SVM
> module parameters are consolidated in a single place.
> 
> No functional change.

As mentioned in a previous patch, these should be consolidated in avic.c, not
svm.c.

