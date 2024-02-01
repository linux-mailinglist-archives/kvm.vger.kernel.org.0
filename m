Return-Path: <kvm+bounces-7736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A65845C03
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D609CB2E56B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797C2626BD;
	Thu,  1 Feb 2024 15:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OomsUXrW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8FA62159
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 15:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802389; cv=none; b=EcMiwhNYMZDsUqepUNa2Eo2KQop59/hc+7HwTju9+e2/vliqVSrIp9/7uvtrreQNOEK9GXFRzZagaTLSZqtn5Sh30lGuIqmIuztmKrQUXomXwHWZ0e/YkpPR8dVR3GqcjUwidVkfxBrI3OVAyP8UGl9JS+hleLaDpyovxO0PebQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802389; c=relaxed/simple;
	bh=FNJHQ8pJXT36VqFlM1SA6DkMrPT0+YUA6Rj5q50WrWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RTUct7eksGCoeGIel+sQxfSlzeZAUKGYJJ4UrJBAtnqM+6Vu8Z18e+6kKcVOBn1uVNTM1Me8bG6MOnn/osnasULg56KHK1K4iEZalijShXXWVFI29Dx6gBRA/OeyljRMLxThEqG2auZMBlpR5bE+Qqw34bf/ACQkxf6RJKI9hJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OomsUXrW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706802386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gEOm7jSo2AEqVXKKLj//3vg9u/H5Q/zbUzqoRszUSKY=;
	b=OomsUXrWCvVji2vfUYPYvriCjD5IJuH/GFh2LhUg/Yn0gG/0wMq35bAB/Vomfb4CgPx1Qk
	kao57Ndo7SAHdqucZbsV0rBKwSA6KjZ9KMH2ensjiG/yyHo9ukz7pXKFmhbywmDBPtcixP
	avXvgazkuh8fW48UVYl3xye0SyG+lHk=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-dPz5Eu_8ObeFgflzDn-hXQ-1; Thu, 01 Feb 2024 10:46:25 -0500
X-MC-Unique: dPz5Eu_8ObeFgflzDn-hXQ-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7d5bddc5a8bso545078241.1
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 07:46:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706802385; x=1707407185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gEOm7jSo2AEqVXKKLj//3vg9u/H5Q/zbUzqoRszUSKY=;
        b=TXYC1s59q9CRsy1lAO1BIsyX6kvCVO/iZtY9qUzq4u+uRZcbU59Nvm1peQH2pNza69
         ecpoj1rpQSovaK6FyGlO+HLMFO7jtKHkeZH97HLoFPnTVmXttNptyucQxtQIyGfukTQX
         gU+FFyujIYTOuztCLWeWoVUKPb9GR+foRtT5VUQD8KL7PQ6ApFbmCDlfjYgIRJVsb4xh
         H0d3s5FwNI7A89LvzsIcEHAeksDp5OednTL1o1jS2KsRf1gjz+g7GtdipO0MQErxrRZy
         pcYjsS/xh6yujWzB80ZOEsxFE9eq/44TR1BWW4yBbapB/nAueQPl8c5puUPWJpQmE3lm
         TZPw==
X-Gm-Message-State: AOJu0YywNG6efq/RPWm7YBJ4H9tRBRVJJPFPCh1rZNOYGC4nuRoyL7NP
	b2Kx2qGln/GrkH1DCKAxXjWe0JS67Ym8iFYnzI48qMF27787eEyAZGpFIhpZO/Q2/A312oRfJNZ
	lUP8umYnRaZMkcGkp9c2gSMiH6/q8LSY4R8iT53QEl7h1uD0EFOQjizii21zHWWCh1X8CDGmlXp
	oT3tCR49eyADnQd1k5Ws5/q2qh
X-Received: by 2002:a05:6102:18c5:b0:46c:fc71:584c with SMTP id jj5-20020a05610218c500b0046cfc71584cmr62837vsb.22.1706802385192;
        Thu, 01 Feb 2024 07:46:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHX2rN1Zzn1bhCilbvAuGtiDDUAvnFKPvLtzVG6cM37SpLqg+N2G2IXDzPX4jRggQvgEuxXLfhBq12/eBBNo+M=
X-Received: by 2002:a05:6102:18c5:b0:46c:fc71:584c with SMTP id
 jj5-20020a05610218c500b0046cfc71584cmr62823vsb.22.1706802384969; Thu, 01 Feb
 2024 07:46:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231220151358.2147066-1-nikunj@amd.com> <20231220151358.2147066-11-nikunj@amd.com>
In-Reply-To: <20231220151358.2147066-11-nikunj@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 1 Feb 2024 16:46:12 +0100
Message-ID: <CABgObfYwtMQY-E+ENs3z8Ew-Yc7tiXC7PmdvFjPcUeXqOMY8PQ@mail.gmail.com>
Subject: Re: [PATCH v7 10/16] x86/sev: Add Secure TSC support for SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 4:16=E2=80=AFPM Nikunj A Dadhania <nikunj@amd.com> =
wrote:

> +       /* Setting Secure TSC parameters */
> +       if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC)) {
> +               vmsa->tsc_scale =3D snp_tsc_scale;
> +               vmsa->tsc_offset =3D snp_tsc_offset;
> +       }

This needs to use guest_cpu_has, otherwise updating the hypervisor or
processor will change the initial VMSA and any measurement derived
from there.

In fact, the same issue exists for DEBUG_SWAP and I will shortly post
a series to allow enabling/disabling DEBUG_SWAP per-VM, so that
updating the kernel does not break existing measurements.

Paolo


