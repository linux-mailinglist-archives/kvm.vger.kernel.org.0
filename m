Return-Path: <kvm+bounces-26730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D724C976C98
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1593D1C23A9E
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 14:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBF91B9B31;
	Thu, 12 Sep 2024 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fooJSFvf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725FC15D5D9
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726152508; cv=none; b=RNFbhKrVnyG3GXyThK+x3BoZxoca53yVo0xdmGsARV3CjnK60JwESrDhtDPG3qgbIDF1rqOKYDyNKZt2iakQvXavNk3YuFinmrCpNf8FcCo6+g1+yhJxAzcY0jtCGUD0uB3gSwrY32t4wY9+4W6UkRPbnH5V4lOS1zO0LyVmNQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726152508; c=relaxed/simple;
	bh=I9BquQXnctDUQmS7DDca+GWzDirl5XIj2/CUHw17JVU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cp3C4jPdwkN/K2J71mla9Ki5E+bO0R5L3KHCjIsSxgYivPiYJ0OLPp62a3+B+YM1pmw6KxuUuG1W717eQy7ZYRPf7byf624CYh3IYULFXeqFc31xvVAVTYk51lf0p7lG/vb1GNIOIHLBeT19hyNwiOaBpETbWKz524JcXUkDUCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fooJSFvf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726152506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9BquQXnctDUQmS7DDca+GWzDirl5XIj2/CUHw17JVU=;
	b=fooJSFvfkSQIdbnplLzPXMPpP2YLC/DKI5CppGP5EIadQQ/XQfOIR8sZaAOjp/wNh92Dx9
	OMUvvBwGgazcZC3j9rGbAt9ooT/nTAWxMvG180K9/6HBFTTiPidTUFl5rRwO0wXc2EOYf6
	5hUo71F493ZHKclkgiErCM5toPsivGA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-XGOYmzmGN5CPa42_6ActJg-1; Thu, 12 Sep 2024 10:48:25 -0400
X-MC-Unique: XGOYmzmGN5CPa42_6ActJg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cb0ed9072so9093585e9.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726152503; x=1726757303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9BquQXnctDUQmS7DDca+GWzDirl5XIj2/CUHw17JVU=;
        b=OykZ8m5peyv0A4qauCTyxJAOUdYYYvVdvdhlTTm1WpPLz4WCOuLyVKuS3QH6bpQ/L6
         l9suOux6mqyP1o0c7HKGWInuvx0GVk1NqigkEU1V6GRGNEw2QPeuBTMJQ3OA4euVmqPD
         lgzhdWZed/HmPUjXwzwYKAbyz13daLrfS2S32hz+rGSw3yF4ixNoYcZ4r+crTPtH/aCg
         YrZN9qqq0zXiwiZNtppCEi8yQRwd55hETAzZaAEnMCnI37wi3EwdbPoeWC2HZsl4kz0R
         ZL/xp2mq1k5UK5OcBhpcRunK+jsS2dN54goBdyP5Cswyrg5HHNNjT2M3LauqxdkRtckv
         cScA==
X-Forwarded-Encrypted: i=1; AJvYcCXOeQy0qSakkIka6M+hWw+6LJK3CM1pplxYW+8iTeMXdJW8EY/sr15RYgpDVBcTMKeYliI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxuTqAhQADloYTt3vL8KhuUxaFRz6vcg87ty3yG8sG6JK5ZvVB
	oSbKE4iF2Xslh89dQooPQHLVFfnVf4+L+sgvMzZbsPuXCpeDXxNolEo422XdCRyeWGjVgPCIUHk
	tDXyIqmkrHK+68IP2FXYnSebGOYxATVobhLAI80wU9Ivut5pvJIW9ipRV8OwgUEp8vpxRwpF/VQ
	pXucVfdfYbeWCI1MgwTErUco3I
X-Received: by 2002:a05:600c:1d14:b0:42c:a8cb:6a5a with SMTP id 5b1f17b1804b1-42cdb5486fdmr31431335e9.15.1726152503195;
        Thu, 12 Sep 2024 07:48:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpLGl2xBFllVesJx6Z/wIIk8uIHfpyIB3c2nK7IUhZ36w6vosYUWk1abhfW4zozWs0K5LGLOIaGzqJfExBIMs=
X-Received: by 2002:a05:600c:1d14:b0:42c:a8cb:6a5a with SMTP id
 5b1f17b1804b1-42cdb5486fdmr31431095e9.15.1726152502670; Thu, 12 Sep 2024
 07:48:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com> <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
 <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com>
In-Reply-To: <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 12 Sep 2024 16:48:11 +0200
Message-ID: <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com, kvm@vger.kernel.org, 
	kai.huang@intel.com, isaku.yamahata@gmail.com, tony.lindgren@linux.intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 4:45=E2=80=AFPM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
> > KVM is not going to have any checks, it's only going to pass the
> > CPUID to the TDX module and return an error if the check fails
> > in the TDX module.
>
> If so, new feature can be enabled for TDs out of KVM's control.
>
> Is it acceptable?

It's the same as for non-TDX VMs, I think it's acceptable.

Paolo


