Return-Path: <kvm+bounces-59208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D7EBAE383
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DC4C7AF443
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBD330F55B;
	Tue, 30 Sep 2025 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+Rq33Ql"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0426F2472A8
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253758; cv=none; b=uFnYrJjrvRhZ/tRgI3oALN7cbzFq0d8xmYhRoc0ZGmrLmWWPbNOBZnMAy+W72bJ7vS48PNnKMoqVMb0JRmtp8E5xiNDurZ4TdF+aO3ryw5JveOiPVoq+uv/AeD/4n5fXbOnm9Az0VPYn+6J5ugzn2Ud/vnAFhurbZMVUfQDEvv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253758; c=relaxed/simple;
	bh=cA+GuZ8vUMDcn1Dg0PjYnMccmnveoznbfhGWc5zNCCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgiCKBYiq7zDMROw322zG9p3PTgVYh0cXLKsGElwNFaNUFJ78wFvCmRnY0bkFeZzCQ47NXaxaTJ9qiLGzKk4MPstUQcmoaGqmh7BGcFXA7momZD6gBDXGoKQt/8RM1pcNjHDBFQqsg6s79mZwyaJTIpH6jPEVui4U/orPnhCmqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+Rq33Ql; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759253755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dxpyWC+z0+GgUOe2275ohM0grFu0b3i5OGv1YPDEOOQ=;
	b=P+Rq33QlaSHAqjYWnQpY0mE6xZWf3/RHUmxkn4tZb+iVarP3az2ix0XT+SXThLw20MvIYq
	iVBKKHNzI6C7gWnHypL1+eT30My/ZetjqHrFZrTqbKhTTDCYja3T0I0i6xHglhm949ksS4
	MuyDMfTnEZQbuY0mRQ+0ZlgphFgi0o4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-8OxgdzpcMfWL8n6kcRlyhg-1; Tue, 30 Sep 2025 13:35:54 -0400
X-MC-Unique: 8OxgdzpcMfWL8n6kcRlyhg-1
X-Mimecast-MFC-AGG-ID: 8OxgdzpcMfWL8n6kcRlyhg_1759253753
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e375dab7dso30563235e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253753; x=1759858553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dxpyWC+z0+GgUOe2275ohM0grFu0b3i5OGv1YPDEOOQ=;
        b=wPtoXnEqTCAYzyBkhFdt1QHsLuv5W9gX4rNsnbXaXhjt7/yCbzB5BQFiWl2oS6ikT7
         82DDEXCWtKNuirMxzNNJ0HHJhWtyP+6bTmMcVMTXudYzFkwQgaKD14UFaM7cNuuhnU7T
         r9oS/xnZV0HfSjK9PVlY6CD1VHs0iHzkL+2A7fBHI3SbsUqu2XVXfhhKAlaiLprXV/6D
         9zbiiYxyC0JTTIR2HqAOl4GGt2MpWtNhJ9lFhQjHA08gWRvZlhlHs6oIDvMJFlozdHRU
         0RPs/KVAreWyIdB2cwE2+9omnZlYmzyuUutEZvB6kBfZXaeaiABb/2Rkg+ewQ865xd+j
         x6iA==
X-Gm-Message-State: AOJu0YztLOE1l+LXP3meAOEb9l5XReEvGOCoNyOTY4wf2Fo6kDL7nF+n
	3Nv0ELxdMT5ToWeNuPa/3xva3zfrp+ZMlq/1Z4r4zNWKVVlEJhh4mkoWMFiVADeKIGIuPR2/PAz
	/ZxWxIrszoiXYTWGqaUmGE/v1+H1/8jg2d5X0nCp3BHEOZGRtrQDKmsVUIke/aUswHSU+VNVS6Y
	YedoZ3VkFwKllWtzz+ydgNP38+1d6Tpdhz5DZw
X-Gm-Gg: ASbGncuT2t5k3GW352Jdrnq89wLte2RibhQU6Kd/GrEdKunKhnrcpHkG5EZTBU3BrdQ
	Rf7ez/gCmYeOFlD3GvSDFxsZ8RdmSLN+DoyTwF7OxIuWVJh70KM7/CfR9vwB85jmxpYPh7p5csB
	PRm69u/BwkxbqNFagfgdOQrf/ydMSr004obEn9nfugvqeKm+iWw+5MiBpsd6WMWiHr1wLYsDf1R
	ZO86CqgVTJwT3kgQXLyM+WVzg6mWNSh
X-Received: by 2002:a05:600c:1da5:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46e6126a7a0mr5884615e9.24.1759253752857;
        Tue, 30 Sep 2025 10:35:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKPvT1CCgwVJb3rScTwbJPb+4nEbYDGCeYf8obJyyGqHWVpBgGTiZ6pg1mDGgl3uwkm82Nv1AW7LuKBbqZEaE=
X-Received: by 2002:a05:600c:1da5:b0:459:d451:3364 with SMTP id
 5b1f17b1804b1-46e6126a7a0mr5884435e9.24.1759253752462; Tue, 30 Sep 2025
 10:35:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <20250927060910.2933942-8-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:35:40 +0200
X-Gm-Features: AS18NWBnsoSryzCQfIOe25iLO2gHWRo2iGtVD2ADwzO_Avqip5ID8Or--bNDX_Q
Message-ID: <CABgObfY0xtd1nB74deM3xNinFkb1tixHL0WYMd=qmT77tTCLAA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SNP CipherTextHiding for 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> The tag has all the details of the feature.  Note that this is based dire=
ctly
> on the v6.18-ccp tag from the cryptodev tree.  I included all of the ccp
> commits in the shortlog just in case the KVM pull request lands before th=
e
> crypto pull request.
>
> The following changes since commit 8f5ae30d69d7543eee0d70083daf4de8fe15d5=
85:
>
>   Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-ciphertext-6.18

Pulled, thanks.

Paolo

> for you to fetch changes up to 6c7c620585c6537dd5dcc75f972b875caf00f773:
>
>   KVM: SEV: Add SEV-SNP CipherTextHiding support (2025-09-15 10:14:11 -07=
00)
>
> ----------------------------------------------------------------
> KVM SEV-SNP CipherText Hiding support for 6.18
>
> Add support for SEV-SNP's CipherText Hiding, an opt-in feature that preve=
nts
> unauthorized CPU accesses from reading the ciphertext of SNP guest privat=
e
> memory, e.g. to attempt an offline attack.  Instead of ciphertext, the CP=
U
> will always read back all FFs when CipherText Hiding is enabled.
>
> Add new module parameter to the KVM module to enable CipherText Hiding an=
d
> control the number of ASIDs that can be used for VMs with CipherText Hidi=
ng,
> which is in effect the number of SNP VMs.  When CipherText Hiding is enab=
led,
> the hared SEV-ES/SEV-SNP ASID space is split into separate ranges for SEV=
-ES
> and SEV-SNP guests, i.e. ASIDs that can be used for CipherText Hiding can=
not
> be used to run SEV-ES guests.
>
> ----------------------------------------------------------------
> Ashish Kalra (7):
>       crypto: ccp - New bit-field definitions for SNP_PLATFORM_STATUS com=
mand
>       crypto: ccp - Cache SEV platform status and platform state
>       crypto: ccp - Add support for SNP_FEATURE_INFO command
>       crypto: ccp - Introduce new API interface to indicate SEV-SNP Ciphe=
rtext hiding feature
>       crypto: ccp - Add support to enable CipherTextHiding on SNP_INIT_EX
>       KVM: SEV: Introduce new min,max sev_es and sev_snp asid variables
>       KVM: SEV: Add SEV-SNP CipherTextHiding support
>
>  Documentation/admin-guide/kernel-parameters.txt |  21 ++++
>  arch/x86/kvm/svm/sev.c                          |  68 +++++++++++--
>  drivers/crypto/ccp/sev-dev.c                    | 127 ++++++++++++++++++=
+++---
>  drivers/crypto/ccp/sev-dev.h                    |   6 +-
>  include/linux/psp-sev.h                         |  44 +++++++-
>  include/uapi/linux/psp-sev.h                    |  10 +-
>  6 files changed, 249 insertions(+), 27 deletions(-)
>


