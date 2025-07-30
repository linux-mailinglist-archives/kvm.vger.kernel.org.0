Return-Path: <kvm+bounces-53752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 763D4B167B6
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 22:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5ECE176D5B
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED8C2206B7;
	Wed, 30 Jul 2025 20:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hbyngq8M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BE921E0BA
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 20:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753908011; cv=none; b=HCRaHDR2/w2jn3ENvWuFPFMagz37QdGXwA1NtPYXo3fjG0DOtz/YkO/GlKRhwsbUR0kRnuixf/GIbizCziCN8GKIIRPL5vU07fzhSxG1a9jJTqVP9gaWQZqVbGHHVJnfstRLLpdV01KFjYhBEsEAci4eafQwtrR9a7otoalAgjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753908011; c=relaxed/simple;
	bh=Ss9gtlimy0f/vE9T8pbjlbe7fjUDfQlSuPwVBz5yDtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9QbxGlNRkppjYy28PIhqMBQflRDIjjRRw5eF+2yJehAMG8U0dUF2VcOaUjITvxc6NIDOaodpn6uj8jHdGTt0zsqDURNHtFWYJBNcIxjhW1U1mI659b6Su8NYPVXIHJusfZBHwLuaWNSZ3prph/y46Kbb9FvHsKq64GBo2Y9W8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hbyngq8M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753908008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iwvrflfsUr5/SpKHTN1DO4Xu230YzowRJGinhMxBnP8=;
	b=Hbyngq8Msz5UXPMwp644+1oxSooQyKqF+akjgSeDOeU4DbtbA+2DyH+74+132uyrrGwBzu
	R2k2sHHH5O2oofPK4U4iSY7zKUr5X5g++TsYYJ2PH9Jr0jAm6JL97t74crCXlI8U8xx9Ef
	/bvSgkOhEb7L8lk0dFdFJ56i1NGLklM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-eix2hNV_Pde4cF77CltVuQ-1; Wed, 30 Jul 2025 16:40:06 -0400
X-MC-Unique: eix2hNV_Pde4cF77CltVuQ-1
X-Mimecast-MFC-AGG-ID: eix2hNV_Pde4cF77CltVuQ_1753908005
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e36f4272d4so47263885a.0
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 13:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753908005; x=1754512805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwvrflfsUr5/SpKHTN1DO4Xu230YzowRJGinhMxBnP8=;
        b=MFwuD6btZHHQz50HV0SGTIpuJvnpUf2rlUkeXUdNOrj8Cy/EjJmD2OznPeFbbY5Hex
         kKIFYAvgJg4ySdAvLjpl05lnMCHLpYo2a9aQ6PqXHyVS2EINBiE6s3bpowe5Kprc1EvL
         iXaFkhg1+iou9twzjVAMmEuUKgqftXrxVTckZ1e2xW5gC/Caay1csqA0GVHZg+0kMS9o
         2oDFRKAnLNLFkQM18hl2j0LwS484UWoQRmlys86PfACeKQ2OorSPmiXKfWBOh3nXzvS2
         asRR9kdWrwh18k2Sx0mRGBMNr4mk+TBoFT2k5rpBo/u5mkKvVti71LCwxzd5WlLceoOL
         9qlQ==
X-Gm-Message-State: AOJu0YxJMyqRHdvEFt6pV4QoYXfEh/b41fU2LBhUlLQ0yJqT6Y86tQpn
	q+hwhw2DUZk01q26smLeqnk3B24jLOxC+GNfJ0ZW80D8kdCLd3w+RKUtihVIBqqPb6U6zP4ddOd
	7acfgO+qehb6vaodQAOjfuZwX1Se9234+hf7Xjt7D6m8zyqFBw85uB/wSJ6tzcw==
X-Gm-Gg: ASbGncvnO76xfTyjYfVXyrIiqFgURvya8srTtUaZkJeL7lmUQhIWiM1AlhjhNH/vf4j
	o20KGGxRKVt9YOffwJOI1DBfUDW2kUL4k3zHvQje4UoO3uLzKa6+XUcBmzyAiGZe8MWNo/5N9Ob
	yTeoHKFeMzOfzH5qHNuHjJv1fCr3y7MmbQ1b09cjsOcYaukyIPLK2+EcAvIHfZ2Ttm1FZemT+vD
	jQAHElmz1ChbzVfJ3DARHFNCPw4LjPKBHuVrSNmRBdPgzFMXG5dD8rRkOwhGCFFQjxmei4noXmf
	RtFakip9IhCxtPUj4pn3o453Qr5MeorI
X-Received: by 2002:a05:620a:cfb:b0:7e3:5550:22af with SMTP id af79cd13be357-7e66efe78d0mr710180485a.16.1753908005249;
        Wed, 30 Jul 2025 13:40:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsbBjtUBvLfHCEEJMgO8bEzXFZ81pjBKic01E1bthRJZl98Z5UENJgv8AgBD+gSw249BVCKQ==
X-Received: by 2002:a05:620a:cfb:b0:7e3:5550:22af with SMTP id af79cd13be357-7e66efe78d0mr710177585a.16.1753908004828;
        Wed, 30 Jul 2025 13:40:04 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f742e7asm448985a.71.2025.07.30.13.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 13:40:04 -0700 (PDT)
Date: Wed, 30 Jul 2025 16:39:52 -0400
From: Peter Xu <peterx@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 1/5] x86: resize id_map[] elements to
 u32
Message-ID: <aIqDGKJxS1Nn_g-5@x1.local>
References: <20250725095429.1691734-1-imammedo@redhat.com>
 <20250725095429.1691734-2-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250725095429.1691734-2-imammedo@redhat.com>

On Fri, Jul 25, 2025 at 11:54:25AM +0200, Igor Mammedov wrote:
> currently item size is u8, which would truncate APIC IDs that are
> greater than 255.
> Make it u32 so that it  cna hold x2apic IDs as well.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


