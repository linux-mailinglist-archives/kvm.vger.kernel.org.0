Return-Path: <kvm+bounces-39193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B854EA45034
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 23:32:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA5C43B3109
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD71215176;
	Tue, 25 Feb 2025 22:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jHGM+7S9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA4214A67
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 22:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740522529; cv=none; b=Wi3Hk2Yg/UGM3C31XBEtP52p9VRx2qMS9etl5Ovn+e4rVAv3kkej2dqsyHknoGMcZ4YOlks5UHm2IZ/LdjKQOINCqGaH0RF8k933tfLXc/2va+I1m9pYFTPD6HrNyfCrcJVMi6WEvyHLlQcuBWXeXwB/CUAXP/mZVHmykBtnemM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740522529; c=relaxed/simple;
	bh=JpnNtM3ALYIN6NMVHSPc0tO/Xi12yjgAOZhMGdcbQN0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V5YHqOS4KR/52a7PlSsztBuMfzf5pXrgmLSY2uphL9t+NAFYtRgP43SJPFpiz3CP86nyFRdOp9Yo6h+cljrprZMXt6DVI9qkqI5PIM1wncO7Tdl5/DVUqmGzllu6NPEMxuhH0vOTZliKQQMzHT/XY805n9hG5oq4s5qOWmbQAcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jHGM+7S9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc46431885so20108913a91.2
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 14:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740522528; x=1741127328; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZ1g0mrUUxkUYLXEel+mk1QRtmfWBrQqVWukeD4l44w=;
        b=jHGM+7S9+d9FoqpOcxU6ahtmLahb9lkHowAepW+B7hLQ7CDp4D7ZSfQxaraLOF1Pxl
         ZDlzxL2HQN4L6vSjYAkY37L0gX8LpqmtGm7bobQlNP/iOqrGLqET+GHWbltlmRvzdGdr
         HzeU35TzOKAqS2vXshmAJZPl5ya2o7l3seyj9WXGg24aqg5a7xsE236cCMBRsDAajGuF
         ud0VSiKesGyK/N/+lZu3xCqNWA2R/nvePli+fVGDH4rPVcOm1lg5akCBR0/Xg47GaslS
         Jeo9DQvoH4D306DGUREcCODU6tqoM1tqxuqvpgQPO86xgoFlg7wgiz7Xic6mGuat/kRY
         dRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740522528; x=1741127328;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZ1g0mrUUxkUYLXEel+mk1QRtmfWBrQqVWukeD4l44w=;
        b=Kqyl5sDY6G/PgXGkFUqrxvuZu0X2yzIp1G8ONbr0rgwSJxfRl3e8Q9r0tEc2XDi20i
         99IZSBDcU4bnmziPFZLpw358bqmGau/D7Dq5bHPP1riCHWk0ZqoMvCunLxz79QKD63e/
         WEPQ1LhFMFFhWI7N/dWEBMI4JOBDtmsi09C/PuI6i+uls8u7vmu8gbLxz2HSTgUF/0B6
         v9PBJWGaNOcg1VSFjobL4xU28rOdaBaSzSZUOnUj6nYti9NLC2sz5pp9Qpj5A8WAb/0o
         U9yqRZ+a2Kij7apH8zeFKFDOWoX6wAwUgXq8LvSLQVovVFHu/afRgjsk7+m6z5oXLHH1
         O1iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrspKCf678VTEJGfdDSEPvNma8yfmc6XV/76sJFlGBiRQdDY/K8SMJ55ZXip2+bTJTTQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdzcq3tGV0ZGzEhAukCsXbkCf6IfDPgRTsPDiMKkDC7MssSkDX
	jhS9ejKDsgZjdfqbY1ADOtep/TLym+4n378V5HXpj263NuzMAJ32KfhZWud3yB8o5e7nWuZxbZ2
	K+w==
X-Google-Smtp-Source: AGHT+IHPMOLjqXDahjHXCs/m7LvJtLpfnNjXUG9EkPnxnpvT/GyZUXLxwNikQZw5S5HAHQIVkJ1YiRiJceU=
X-Received: from pjbsg17.prod.google.com ([2002:a17:90b:5211:b0:2fa:2661:76ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1344:b0:2fa:2252:f438
 with SMTP id 98e67ed59e1d1-2fce8740eb3mr29741371a91.30.1740522527792; Tue, 25
 Feb 2025 14:28:47 -0800 (PST)
Date: Tue, 25 Feb 2025 14:28:46 -0800
In-Reply-To: <20250225213937.2471419-2-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250225213937.2471419-1-huibo.wang@amd.com> <20250225213937.2471419-2-huibo.wang@amd.com>
Message-ID: <Z75EHspU4ZPcqw0U@google.com>
Subject: Re: [PATCH v5 1/2] KVM: SVM: Convert plain error code numbers to defines
From: Sean Christopherson <seanjc@google.com>
To: Melody Wang <huibo.wang@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Paluri PavanKumar <pavankumar.paluri@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 25, 2025, Melody Wang wrote:
> Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.
> 
> No functionality changed.
> 
> Signed-off-by: Melody Wang <huibo.wang@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>  arch/x86/kvm/svm/sev.c            | 12 ++++++------
>  arch/x86/kvm/svm/svm.c            |  2 +-
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index dcbccdb280f9..3aca97d22cdc 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -211,6 +211,14 @@ struct snp_psc_desc {
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> +/*
> + * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be

The use of "Error codes" is confusing due to a psuedo-conflict with the below
comment for the "Error codes" for malformed input.

On that topic, the comment for _those_ error codes is a bad example, and shouldn't
be used as the basis for copy+paste.  Most notably, it doesn't explicitly state
that the values are *defined* by the GHCB.

> + * communicated back to the guest
> + */
> +#define GHCB_HV_RESP_NO_ACTION		0
> +#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
> +#define GHCB_HV_RESP_MALFORMED_INPUT	2
> +
>  /*
>   * Error codes related to GHCB input that can be communicated back to the guest
>   * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.

Now that GHCB_HV_RESP_MALFORMED_INPUT is properly defined, this comment can refer
to "malformed input (see above)" instead of open coding '2'.

