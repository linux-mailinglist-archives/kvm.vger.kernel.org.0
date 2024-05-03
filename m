Return-Path: <kvm+bounces-16545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC978BB5C9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 23:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1BD7B2452E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 21:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53DF58ACC;
	Fri,  3 May 2024 21:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OmUaLXQp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9ED535A8
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 21:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714772029; cv=none; b=cRqVmc3CxO82ijQeJWh6NVqQdFkeqb0IFNnlWZ4+podEYg1eSfILeizCcfHXQkawp4R4W+sfAT6BfrCzUp/IQrynPQJuoJXA+chiNuYiKnCvJGqoUkOOOAV6ASg1YQmMK2yvbLFaJ4U79SRNPli6J8kmk14h2epgBdGbehxV5Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714772029; c=relaxed/simple;
	bh=2p3EmqeLa76hFcxzVFu3IM1y0mu3LdQ1D6og4KfIlyc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GuSbmLe8DIo0GKjH60ZB4CmdZesvNWrllRBOQt2CoUC6Dr+/wPsBBHDUVKih4P4z9ciYImCEaAQ5n4Dao+fC7ZTyk55NCNhdOzku46caI3AGxNPaCTWTHhBU9ERbtEOBdH66Ch06aQ03YiebhMDpSq/JYOD/pVnrpERcFFzumcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OmUaLXQp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed663aa4a7so204097b3a.3
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 14:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714772026; x=1715376826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MlrISKi2c+M0hlWH8F4xXuKQHxXn7iCZjvDMr+QQnwo=;
        b=OmUaLXQp24JfPCMh5pOxUVioevzmlQEqyZSwtrWKODVyaGCrGZ2Lt3Q9tO6POuOTaS
         GyDUNpr3YtVpdZau2BeUI5vLgkRAEi6HG1P7s78Dnl6he+PYsF5YO63sRioI4+w5MXrw
         woz0Bhcov90Rhk1qomiNFfym/PrfV62UkO4YtkK+H25dgtO2F1OUpJfx1kesv2CR9xAQ
         K1/RsYhakr8ylcNuHuql2/1KvFG1TkHL6vFmgoCSMO8yd7daiigCP1dVhOQ8CeSvqWfl
         wMZBsuzKoSlWSJ5xp0+anL4P0bqExoeCxaAwNGZ/doIPlQZoQsbKvz86KTiIy02y7yza
         u7Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714772026; x=1715376826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MlrISKi2c+M0hlWH8F4xXuKQHxXn7iCZjvDMr+QQnwo=;
        b=ez5gUJ118wk12xvCql1I8USXfHbAQZ51+W3zzkObWwT1/6kLsxGZEuAClm1FfB2CHU
         L1HPXg1k8qkd9Pd/WYavNMG4Yary7nsWUDuFws/t9F/hvNqfe/WelO42RCEOJGwt2IFw
         vdlTmcabFqxLDHnbpqMXWyLHrf/h6UPnrLVTqPvbwQyN6q58ie47/Fe7YJT7bCwUogj9
         eUgoTHnj2QbsBg5BgJnVWD3mP1O8U/6joh6dfb9kllmyKppp5K8SC3tJOSM05ix3lnN7
         RWC27ZUJYRiciODJhZpZWj+//bUZ+mLWrkJgNzvHxsLnbNb1iN6E0TGXPZfak8grcacT
         14ng==
X-Forwarded-Encrypted: i=1; AJvYcCUVciSowxC2tvhxPHSwq2psBEPRQ7QaoqhZukjpM9BEFv5+edhHOHZlEgPxlg+qmSe2b6epL4cJuiNlPIV7Yjs4kHrt
X-Gm-Message-State: AOJu0YwQzgRlzA5BoNAB6pBPyy4sOrhoiAiYomNuHiVRS26FDBIKMWzd
	VQD9p3jFvbs0vgrGuPX4WEiYbooI1xJ22FCc0wFq4qjTmUUlC979dyzB1+xzu5NmE0+ccrgDJmt
	b0w==
X-Google-Smtp-Source: AGHT+IEHyKqw2sfoqSfrlqHZmBh3uSQ8p/kW7UX2W50ATZadR3KM3oZfm4nJXRLPcnOkKXVpCRpkzPQWRKg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d8a:b0:6f3:84f4:78e4 with SMTP id
 fb10-20020a056a002d8a00b006f384f478e4mr124606pfb.4.1714772026488; Fri, 03 May
 2024 14:33:46 -0700 (PDT)
Date: Fri,  3 May 2024 14:32:14 -0700
In-Reply-To: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240418021823.1275276-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <171469178174.1010245.3908365461241095071.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] APICv-related fixes for inhibits and tracepoint
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="utf-8"

On Thu, 18 Apr 2024 02:18:21 +0000, Alejandro Jimenez wrote:
> v2: Add Sean's changes to [PATCH 1/2].
> 
> --
> 
> Patch 1 fixes an issue when avic=0 (current default) where
> APICV_INHIBIT_REASON_ABSENT remains set even after an in-kernel local APIC has
> been created. e.g. tracing the inhibition tracepoint shows:
> 
> [...]

Applied to kvm-x86 misc, with the previously mentioned fixups, thanks!

[1/2] KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if APICv is enabled
      https://github.com/kvm-x86/linux/commit/6982b34c21cb
[2/2] KVM: x86: Remove VT-d mention in posted interrupt tracepoint
      https://github.com/kvm-x86/linux/commit/51937f2aae18

--
https://github.com/kvm-x86/linux/tree/next

