Return-Path: <kvm+bounces-18936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 015328FD27C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A61DF1F29BB6
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947C614E2FD;
	Wed,  5 Jun 2024 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f8ytL5+z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757BD27450
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603720; cv=none; b=U8HBW1Mfyh/1fizcfjv0K7b60fx7sSZXnigvBQlgWgGdFYuMvPIZLj1Ur36IsfstZKKeee0Wts8EmHvCUYsoGIsWda9IgkA8AdwuJeO/gqRiNtJ4cM3VGC1MCRqpf9i8xhKfzZmvZzQNXXzyta91H4XIGv7LMb83T6A4GRf75mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603720; c=relaxed/simple;
	bh=Uoebq8d39cwBmfl/sEA3jZLdwg0xjkyHXqdcnp0MSeo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bqNvIyJKPcBXMGU27BBTQLnIRf64mZqsegeMAdS7cQlLGKCHtoZBF1Vllv7+LrM551mpFS7KVwbMblZtrNMHffQIZBd3ovErsJ3O2oNnBP8T5DR3uSAbmAVHEPenoA7sSC6sSLxUUt4WS9omZp0YrKOd0ZAdxtcMtGkxytAoqzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f8ytL5+z; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f65539265dso120655ad.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 09:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717603719; x=1718208519; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xVP/fQo6YGBI5rKBazu01EhU4Lb8Hm5ujEWUF/3ZPFg=;
        b=f8ytL5+z3a6/A9veh/wTSyGKWqh9PjrE+rdon/rS5gu0ERLYlF080k0nJISz0QYP/Z
         MHMTSkH8TNugKq9l44EWtzZT4J4VnvbfYnVpQiUdLXaxOetgRrmZ5sT/TA7uo0sigy1t
         4HiIzH7PQ1cv/Fq6Z0VPkE12zYOYXhB1uT1lSYWTocLfJ+pE7NrN5sBsClHo8Y+BiCQ8
         RPoYLFlq5TXG9qEczhZI5JRYm2/DtX9f21QIPH0B0x2Q89htGc818jgAnFhzSR4YNHTf
         S3zISLhInA3jGh4QDGJXhwPbojojhfD9Pe9nadCq5O+W3F27GncDyD2fD+haGv0aqZCI
         R8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717603719; x=1718208519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVP/fQo6YGBI5rKBazu01EhU4Lb8Hm5ujEWUF/3ZPFg=;
        b=H6R2J987tKbK8K4ZkJ/HTDBH5XFkIcvfhZ2bPprTf+0BYoVA8eHfTfnQixeIl6WXnC
         jP3LQVneVM9MFmF/6FyQtpTiTyYzGyQMrYG9VxDWPJAEG1Zny5yD0QWChwX5gTiMVQAL
         nsTnp3TMGbchKn3Wz89ptZCHJuTJOddrKXlOzyBO5xAqif/iN8n0Fa9bi0NddxS0QkLg
         o9acV3yNFIMD6etVHHCK3tFMNgWSzP5Q/Te87W5uO0GYfj8ClbzebbdJWWR4drBHbrNb
         PgfeTA4K3MnPaLICCR/r8oGULQkrbF/9yYXaIeiF4/IJ31t2AHPugFNJ6/By001Kd0G5
         1GEg==
X-Gm-Message-State: AOJu0YwmCd6EFTJUEF8j9+rtIn3ZEr8cbVVDrPsUGOOwnm/3gJjfFGKv
	/Vi/18j5bt0v+yZ5S/lMSiuVRyq6X5VuWUSLbmkIuiyTdZvmK97nOCu/R2hzRNuBnCPvMTQ0+Zo
	0Bg==
X-Google-Smtp-Source: AGHT+IFYTcpSDoPDKEWKPHFtaZmyTeM20KKrhkW5ogmah0zKK24eOOsBRluPKmiQ7zwrcBoPFol2CotobFo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e88a:b0:1f6:3414:6a83 with SMTP id
 d9443c01a7336-1f6a5a7c9famr1626575ad.12.1717603718553; Wed, 05 Jun 2024
 09:08:38 -0700 (PDT)
Date: Wed, 5 Jun 2024 09:08:36 -0700
In-Reply-To: <20240419161623.45842-11-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419161623.45842-1-vsntk18@gmail.com> <20240419161623.45842-11-vsntk18@gmail.com>
Message-ID: <ZmCNhDt0UaDpuqu-@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 10/11] x86: AMD SEV-ES: Handle IOIO #VC
From: Sean Christopherson <seanjc@google.com>
To: vsntk18@gmail.com
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jroedel@suse.de, 
	papaluri@amd.com, andrew.jones@linux.dev, 
	Vasant Karasulli <vkarasulli@suse.de>, Varad Gautam <varad.gautam@suse.com>, 
	Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> From: Vasant Karasulli <vkarasulli@suse.de>
> 
> Using Linux's IOIO #VC processing logic.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> Reviewed-by: Marc Orr <marcorr@google.com>
> ---
>  lib/x86/amd_sev_vc.c | 169 +++++++++++++++++++++++++++++++++++++++++++
>  lib/x86/processor.h  |   7 ++
>  2 files changed, 176 insertions(+)
> 
> diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
> index 6238f1ec..2a553db1 100644
> --- a/lib/x86/amd_sev_vc.c
> +++ b/lib/x86/amd_sev_vc.c
> @@ -177,6 +177,172 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>  	return ret;
>  }
> 
> +#define IOIO_TYPE_STR  BIT(2)
> +#define IOIO_TYPE_IN   1
> +#define IOIO_TYPE_INS  (IOIO_TYPE_IN | IOIO_TYPE_STR)
> +#define IOIO_TYPE_OUT  0
> +#define IOIO_TYPE_OUTS (IOIO_TYPE_OUT | IOIO_TYPE_STR)
> +
> +#define IOIO_REP       BIT(3)
> +
> +#define IOIO_ADDR_64   BIT(9)
> +#define IOIO_ADDR_32   BIT(8)
> +#define IOIO_ADDR_16   BIT(7)
> +
> +#define IOIO_DATA_32   BIT(6)
> +#define IOIO_DATA_16   BIT(5)
> +#define IOIO_DATA_8    BIT(4)
> +
> +#define IOIO_SEG_ES    (0 << 10)
> +#define IOIO_SEG_DS    (3 << 10)

I assume these are architectural?  I.e. belong in a common header?

