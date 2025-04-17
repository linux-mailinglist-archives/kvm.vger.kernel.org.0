Return-Path: <kvm+bounces-43588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADB2A92429
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 19:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B94B219E340D
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 17:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F2B2561C1;
	Thu, 17 Apr 2025 17:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hGWGHyv6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA771255E58
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 17:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744911472; cv=none; b=Sq/GunpmLQVnFRDsL0mtgwJCwbEtZt3IvFIFFNL9aEXAdn1YU9r59huEJwDOWazaTn0kpkz/GLvORUP0rAAJ19Su2j49G4AQc5ELWQjG3MFyPOcgDHhVIAZVPT4L/+5FNYq5G0M0Ce6xBNmNK2Ggt2YdfoliHy9dHGke+iBcJlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744911472; c=relaxed/simple;
	bh=Z0sFzb5brbKQVaF0C8OLPsVeNcVcEevptZnWFDnVwVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S7sVcg6QfZOgUrH3N1/eY73F2K45NzoTp3l5RyUDqTn/gr/jFpjI0DcxuSPJh+tWvPhvo94ogJ2tKhUEebm9xJARo2vPdlWlMZVfvbiZ2S5LdAt7+02kBptZ1YhQ7ELY3YSmyp4QC4+fa8x66jnCksr+lQcKEu8XWFYKSoh6lcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hGWGHyv6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744911469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z0sFzb5brbKQVaF0C8OLPsVeNcVcEevptZnWFDnVwVA=;
	b=hGWGHyv6DFvRgckJ4Zn6FLvvrJ+gX3WsDg92DVgoqCCeorrHJkZ9GnPQEW0Nf1i6hv5GYf
	oqJLEa5fCBtUSTgTMjBo/cD0SmWVkKNC8lsKWHti6MTxpmTysZLa5txvfZ51+llXT6hfE4
	KoH1w9c2DDmyNYBnhP54gbO3g4YFxYY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-dshBwAYjNG2UecmFWcy6IA-1; Thu, 17 Apr 2025 13:37:48 -0400
X-MC-Unique: dshBwAYjNG2UecmFWcy6IA-1
X-Mimecast-MFC-AGG-ID: dshBwAYjNG2UecmFWcy6IA_1744911467
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d00017e9dso6088625e9.0
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 10:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744911467; x=1745516267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z0sFzb5brbKQVaF0C8OLPsVeNcVcEevptZnWFDnVwVA=;
        b=N91Lkxp4KUj61pJ9feo7xuoYYnabcoHKc59KYtB9jlpWOmoKLlLqlKaCMb7vN537fj
         OJycMGx3UQ/ERu6KjVgiZXMdFrqMajanNNrcknP4mB9mxIbN/5X3kq1Dc2H3MbDZ1Oyr
         ldG2nFP5IvXdhGdZcRDKs2wp3PpArCMspVCU2HsZV+pfBYyprPmGjQuRQ2vDVz9AbqmV
         BEnKe8G2YxKw5VznKzxF6sKhjdgk723obDHSxhRtxfRvUhgbf5gzRmuGzemB14wkemEl
         wI0ZI1nm/oMk1MmW1CevQ+PpBve/jPARDS0BDe6nujlxs9c2aKdOs06Gs3Zpt68fr85j
         fLnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoLv8Xo311T7IXqEvXFdfKqj3363qtAtfc0xlq45VHtUhsU0eimgB0G/8hjBr+SEKt1hQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3YPueamSl/jG56RIhgEu3BkgA+EIK6Vd7HdLw9hzKCyogZCz0
	UM69R0jofu0CeX/L21hNS7SWt+4ZcoRN6BWeey8dCEel1v8MbVOKVkW3mTdP0chNh6lhXhiy8AJ
	SRldPWxwEBEgBn3hJJ4haYYHf4aO2SFJ5vrfKi8ZghlBW4MgN4rkVM1JyJKrpTYpmIE3zxS5MSw
	XO/OJDtak/MV7rpQrrBlIjAGFR
X-Gm-Gg: ASbGncuFVEyyfgnjne+oe2dsABUOHpX9rTCe6HhOSBk2wjEuRBP7Wb/KV5Na56wX9lQ
	xSIWbUxA9yVzb1GHIQhik+yuw4f6zvut4XY9uaCXhJ7lL2cJvjaTbGq67kt4YDGGrpZ76Xw==
X-Received: by 2002:a05:600c:384b:b0:43c:e7ae:4bcf with SMTP id 5b1f17b1804b1-4405d5bdb1cmr78617415e9.0.1744911467340;
        Thu, 17 Apr 2025 10:37:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB6JNchYDi6dPBvFLX5ceNDlu/RLfP5VkTWs33YKOj+4WfauYjEYQ8SROPk+2SXPnT+n9TJHZTcIOdUpA2GS0=
X-Received: by 2002:a05:600c:384b:b0:43c:e7ae:4bcf with SMTP id
 5b1f17b1804b1-4405d5bdb1cmr78617165e9.0.1744911466985; Thu, 17 Apr 2025
 10:37:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250404193923.1413163-7-seanjc@google.com>
 <0895007e-95d9-410e-8b24-d17172b0b908@amd.com> <Z_ki0uZ9Rp3Fkrh1@google.com>
 <fcc15956-aad0-49ea-b947-eac1c88d0542@amd.com> <Z_7X3hoRdbHsTnc8@google.com> <de563c32-b124-433e-9d16-2544c41e2be6@amd.com>
In-Reply-To: <de563c32-b124-433e-9d16-2544c41e2be6@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 17 Apr 2025 19:37:35 +0200
X-Gm-Features: ATxdqUFeNPvQVED7_AzqwVcYqyNzFA-G-bDhGMcN4bAaQKzHQa7gq22ssnm_MNc
Message-ID: <CABgObfb5QngpP_DGLx_6Y+wD+-3aSOnYUsdHCpym+V6VxY8krg@mail.gmail.com>
Subject: Re: [PATCH 06/67] iommu/amd: WARN if KVM attempts to set vCPU
 affinity without posted intrrupts
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>, 
	Naveen N Rao <naveen.rao@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 11:47=E2=80=AFAM Sairaj Kodilkar <sarunkod@amd.com>=
 wrote:
> I think it is safe to have this WARN_ON(!dev_data->use_vapic) without
> any false positives. IOMMU driver sets the dev_data->use_vapic only when
> the device is in UNMANAGE_DOMAIN and it is 0 if the device is in any
> other domain (DMA, DMA_FQ, IDENTITY).
>
> We have a bigger problem from the VFIO side if we hit this WARN_ON()
> as device is not in a UNMANGED_DOMAIN.

This does seem safe, but its more of a VFIO/iommu change than a KVM
one so I'm not too comfortable with merging it myself; please submit
it as a separate patch.

Paolo


