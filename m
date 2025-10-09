Return-Path: <kvm+bounces-59750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB3FBCB331
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A2A73B0922
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00774287507;
	Thu,  9 Oct 2025 23:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdDBoi3Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0B517A30A
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 23:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760052643; cv=none; b=sv56c4kPQThMOplhmyfbqgxkXhtF3WQx5zvfiV5HhDd6w/Q2V5iSJO4DL0MDLHjV8jF2cY9VOg9MHuCGo928cieWEU6iL9c+OsdEo2lvZW6h1fnPsC7z5Q7Y0fKEBnujR89lIIC59CEE2ESRBnBQZ7COphk55u3Xc6c9YcFoixc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760052643; c=relaxed/simple;
	bh=ivnI95/4wH2sE/60lYNix0grZ+S99Kw1ZPGOz1sP24k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hevirJ+g4vDewPoUrOTVkPPK9If/z79NJi9BcVzc1LMetxKj88Inuo4qk0yS7wH6izg/hGmS5WN+NV5CD9NAOD2ayB57SjjDh+/5nB1/VOGfzE95kY4GiKDY1eEv4nc/Q6pAKxgttjFlx3kTWGIMWPoUtSjR0cGhF79e6jYaAM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QdDBoi3Q; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-633c627d04eso3885a12.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 16:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760052640; x=1760657440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivnI95/4wH2sE/60lYNix0grZ+S99Kw1ZPGOz1sP24k=;
        b=QdDBoi3QsyiVc4X4yt1Fo4RAionuYP3ST1YBUwKAIJi3s7zCdZFZ9yV/oxoABBWZEy
         WQRN3wmZfgex/tpKAXiPrTBoGzIbdYTAK+BKKxiQBAXSvDOwtod3TOIA34XipddUIuR6
         iRzyFWWujWW6tibq2Pd6A8tuAF/VjlZ0WdWZgCz2V2n5NiNPMpdU0pvdr7or9DW0ZT7j
         tBDfwD7JcSDNAL0LE9Hbl2ePOxNJjU2ImxITUiD0H9lafoHnRmjSiMFMCXLL+6G6iTk7
         eW2frtiAaBv4ZGbY3q4VWuREOEYr4Tt0MgLM09550pAchfXrJR+wyH2zrVaGAZFIKfzD
         vf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760052640; x=1760657440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ivnI95/4wH2sE/60lYNix0grZ+S99Kw1ZPGOz1sP24k=;
        b=Y0ySHvemCRqhcwBuHaeMIOL9dkt1nHiTNm1DiYrmhE33xLJmVvLtt6/aBOHEPZo0qL
         IU/JKwRA25QPpOt1xyAOa1Rsvk6zty7jhN2hxu2Op+lWb9Eq/vR358wZgOL5j6++67ts
         rwk2el6BeKoPaqunOJgUwOml6er2iateyuxJsBRSv86K4bbWHjLf4Z8Buqqv9HyQDaKT
         rcsPKSDFlsFC7Sh+V4Cl+PtCaTUT5m0Pu4LiqmrCjdBsre4brEFeeYMIdIxsnZI6XtNu
         aVR8NiVFfl4i0uSfErSC4jgopS+Nsi6VPpiObP/2veWXD68ZgKtF8sHRZyOkj3gnUYaM
         FPaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/A2+BkPOkDaExhZ5MlXjO7K8qwoUB2eJAjkFC9Vtt/z5JsN81JEb/QyWttjpXgkTF8AE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIPhXdKWkBBRxoJFwwYsD/Ss7rAEZ+uhTHKb+sHLKpL7IVaN9i
	opRCWTsoCWL9gAvS6P5DPz0IzlAwWzI20WNfAcSBEJbHUMrjn33h57+N5NoCHiQXcEcoPppAw8V
	OuT4p3pQkImG577tt8ObGzJNFykPR+S0VleTCvtdN
X-Gm-Gg: ASbGncvlUNYmbHH/n2wVxVsdxLRX1ISkkX2/Z6o15MxUfpuOBCrwe/2W0zWqzdRRv7n
	h9NlT/b4IXCWTXD3b/wlrCGDw4SvQeQzPI3y59kkOKqeGUtAeMciBhN2CDBKq6T669fdn1s0olA
	bceK44KbEP2BbY6Z6r2mYGAlN03Psc9fabWzsSRdo1u+5UZxGuXHl7RJcVrd9fl7eOJJALJ8cc9
	HSs/XLp5XaJb57AgWnQfp6AVLckXje9NUx/xPck+mrrsz2X
X-Google-Smtp-Source: AGHT+IEOTBj54UYI9jTz3gxGnclJ1kayNjmHI406lzTf1JgANvppGkPbXbIA+gJ6Kl3ZFbRXnOZW0vEKxs1YBObXV70=
X-Received: by 2002:aa7:c354:0:b0:62f:9d69:9364 with SMTP id
 4fb4d7f45d1cf-639d52c2a3cmr318785a12.5.1760052639765; Thu, 09 Oct 2025
 16:30:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-8-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-8-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Oct 2025 16:30:26 -0700
X-Gm-Features: AS18NWAx8ShaL3lmvgtqy19Ov8ozeGmr75Qa4-GnxpsoU7OynbrKVwVC3OfQ5OQ
Message-ID: <CALMp9eShyXSx685qTqY_ADEk9O8Mk3btLPPE4-WYPxwghHbQPg@mail.gmail.com>
Subject: Re: [PATCH 07/12] KVM: selftests: Pass the root HVA directly to
 nested mapping functions
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:05=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> The nested mapping functions used to create EPT mappings currently
> accept a struct vmx_pages argument, only to get the EPT root from it
> later. In preparation for generalizing these functions to work for NPTs,
> pass the EPT root HVA directly instead.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Reviewed-by: Jim Mattson <jmattson@google.com>

