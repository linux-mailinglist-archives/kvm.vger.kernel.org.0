Return-Path: <kvm+bounces-20111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F8FB910A17
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 143671F22CD0
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F3D1B0109;
	Thu, 20 Jun 2024 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iud9z0Vm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B901AF6B4
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718897946; cv=none; b=ih+uev/9y9Ko2J3yYiSmlHlZi3gVXVhjBeW18Sm2PMItWOLEXq3LkhbcFKhb1GAHgfv3cyTAmHE84kEOMDzX4HD4R8VsHysNpoAtvJQctD+g+P8nlEsJSOPQNJPZzktQOxfm3DJbW4bURUc4wfRpiLimR7YeVQzkkZmyw2+z8UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718897946; c=relaxed/simple;
	bh=7MB1I1UVOTEXCsm5pjN83xKIVZzA23rlgdy0g9R1YFw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rFw9h3IShAr33n0SBIRatSExN4t4ypOzk6SVyPz2PDj6cfcG1w4TpZqF04VfEO9gUYpokEavOFWeoJz2F6IZvGZmiSpfc62to6MpNs2bTV5qFjmErpnRnz/RN8RmHIEj52JFHmz+C4HELW8cJAx4B8XzgeKSFwJoGgOANLAFDno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iud9z0Vm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718897943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7MB1I1UVOTEXCsm5pjN83xKIVZzA23rlgdy0g9R1YFw=;
	b=iud9z0Vmv23WuKzEh/U0gQsP5ahiH3aU/uLMjC1HsWaak2I0BEYgJdxw+phnWdnfbOIePb
	VpJd7jENreBRWGeb6cYQgMKGA81ooqOdnjXiwkyu1mhEpo4zkBUr1HIP847msuDCZun4mQ
	340ELtqUTZggX/vO/ghmJIstXelfTYo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-383-FnQAOfqSPa6Y90n3UT1t3g-1; Thu, 20 Jun 2024 11:39:02 -0400
X-MC-Unique: FnQAOfqSPa6Y90n3UT1t3g-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-79553562d81so158974885a.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718897941; x=1719502741;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7MB1I1UVOTEXCsm5pjN83xKIVZzA23rlgdy0g9R1YFw=;
        b=HGQAW3slJ0navPfTKpORaShbg/gGBuvSMuzmKFltW8j99IYPxkkxZrhJsd5zie7hgB
         vFVuoasxentGZ1iG87sSE/ikZt0I08/xNSU+trF1+gHEIgClXimVat3IADGOBCTfH8Tt
         XR6BO9TtNOh+/3QJno8axB50gYJckh3gW6HTd8s2iWIcXSZpzEra7HiT44K7y6Drh+jE
         ijzR95Eyr9cb4uM/ROjGNv3ACXfM1QUuDDWsdSYaTMz2yB6SISuoHgV/wNoszCFFFVat
         4O9nEq8OcW2Vqqm/SnYVSv/5QWOwHtAFC1+EZx6uLKg7lx7efp5KpNV7IJBVfQZSy8+x
         HIOg==
X-Forwarded-Encrypted: i=1; AJvYcCX5rs1sZrJwYOtdV39WBtmbQJhFAjAZJs5QgsyhxMr4xKcbY64xg3YCLNzYIfGeQGinWpMpVrTSg8cJxWG1OQtZ1Vq+
X-Gm-Message-State: AOJu0YzHIgaBhxK2kXLT4fLtUajZwnrhkGSfClJtAFjUVaVfhY+cKbxR
	0VwBIE+gNao0SR0YGOpFpCHB9x0L9ijIydOfkmu/u/KtxfcLTEjUqh9eET4Fj+c5fTLGYGMTeZE
	IvsT8wG7ABW2lrodX5hmgxPuQy5spJMPVI7LbMhShWZIVAba9jw==
X-Received: by 2002:a05:620a:4109:b0:796:842c:77ef with SMTP id af79cd13be357-79bb3e1178fmr615651785a.10.1718897941543;
        Thu, 20 Jun 2024 08:39:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvwSPJpjWm/tOIuX081oVCD2HT9fyPjYjPX7yKJ9jzORjE/DVs3ALW+IJEPIHcnQvKKzPyyg==
X-Received: by 2002:a05:620a:4109:b0:796:842c:77ef with SMTP id af79cd13be357-79bb3e1178fmr615649785a.10.1718897941256;
        Thu, 20 Jun 2024 08:39:01 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-798aacc5267sm705627685a.18.2024.06.20.08.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:39:00 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:38:55 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 01/10] KVM: arm64: Get sys_reg encoding from descriptor
 in idregs_debug_show()
In-Reply-To: <20240619174036.483943-2-oliver.upton@linux.dev>
Message-ID: <4474548f-f30c-5369-d058-6871caf04d67@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 19 Jun 2024, Oliver Upton wrote:
> KVM is about to add support for more VM-scoped feature ID regs that
> live outside of the id_regs[] array, which means the index of the
> debugfs iterator may not actually be an index into the array.
>
> Prepare by getting the sys_reg encoding from the descriptor itself.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


