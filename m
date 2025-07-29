Return-Path: <kvm+bounces-53620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA4BB14B88
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB4E63A36F6
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291E52882D0;
	Tue, 29 Jul 2025 09:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MJPv58gI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA611624E1
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 09:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753782203; cv=none; b=TIdyESYeDa5/avMh5ri/liwrlE4XB8Jz1/0asKF/h/VD5GuGJ8kAZszGpeA5/IXAEDNuOO72v9xQz3HiFC/qJvcMfhFH+310uNHNgy2/XNYakVvKkV6BiJtDtthOhQbBk0zcu72ABrKL7NQLToNx+vQIJ4JbWcLwYTC2ae8BBgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753782203; c=relaxed/simple;
	bh=0bD2+OWtX15JO3/cWHqoWANhRWODiM9cluWkkflGAq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cd5/wbOtFsxqHbkkTIvrsY0XB4N7eIrZVUWY0ftT8LDxbyHDE+M6jrhjDfRkIVQ0AsmRPHNqE+Z9HTVIM3jFquJxz+sdjCrYiGSgM/fScuwH/8Wtn5Kgxp47IRlE3f9lo1wOB66kwlbDSopnwAruqwyuZeEAC+HkBpwGGiQ5QmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MJPv58gI; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-456007cfcd7so49775e9.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 02:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753782199; x=1754386999; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1rI/78m+XwnktafE+ygrVP+MfYIVlmgGuVpeyq9N6L0=;
        b=MJPv58gIhAxmqfyuEMAItdyonKHqjpgXINtXt3rQfxQ/3i/n5PsHBmez52tJp+8Y5q
         4NIdobPa/dmfqeDtlE+LAGWFoTIVfuzsthAhhx3FgXdaVKwwZhYwUMeCN5Ozs2s+CY1N
         uj2evHIKjDzhVHaQZ8Hjun+CZERMvlul4U0J1KZ30hSAoz1p/Aa4CslP0EkxnJuiGNcV
         0hYpnY/us+5mO91OP82/oprZf/0Qd1ThbiWLSMJMKwbTAiYgbBkUDcbfVNnb11sZ/d1Y
         TTnWp1+d0BAlsKqIhaXx0qnT48EJdAmdWiNNa6Ysk9j8I45eNc09q6frIrUWUj45NSBQ
         Hsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753782199; x=1754386999;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1rI/78m+XwnktafE+ygrVP+MfYIVlmgGuVpeyq9N6L0=;
        b=Ox3i4sC54YVy0NfMenBCOKysCwK6fBB1KySCmKLCCv5cdRFufwwtEHg6eBilNdLlKQ
         wW9U4fpojJr5TowdjhqBw4QpgwhGSE8smIxh7vUQEYawGfBGeKPpdgu6N16hLOoiM45p
         QSiqvRt9xwhBDQEuOBFLhF8ow9XbJjJ3d1GxIv8SE/FGhm/pycC8P3CrjdQRbHHJchf/
         sWqFWl/2ipy2rf8nZlK6NgaBkbvGHJchIW+/0kVW8SI2acrE213X9kbi5olIQAunnYWf
         ut5d6sf17AM+lxUMCRRnta5IOef3JBSILRyj+rnHuQ5VzBM2qG0sYLJlCyIRo7Dyfrpv
         1L/Q==
X-Gm-Message-State: AOJu0YxHJDSjmM0B6+b4KNJ7s2xfbWFr1LKLE8VcCLZ3r84GFuHWUoxU
	+mP3wHUKX3RaEuud9N2LDBoF/yvSahpG1fzwIO4RfW8MHq0mZbbvG2Z/X4MOM2TIQw==
X-Gm-Gg: ASbGncucnFeqnJYJfxKtLaXQnrHMrb7cPqzpSS6TbG3myIcYLw0jivyA3Q9t9O/7zjU
	YBfe14p7gFcRj9eGmq7igig81EnphpOZPD5wsrKDkS0LzLwGCbvvI3rgGD4N4D38awetnsjFJIk
	SKdL98Ctxp9Tu2n+H6Xmcit01l8pSgop0bgh3qUct8hzg837wpPZrzAZOPrW7G2q3sMNv7cxp7c
	V/l/lrliP6WYjXZa5YwVPqZoefim16DPRBFLRTgg4eQR2FBZqhGDugsZCkFWZ4LVVC6rjID1HFR
	Lfmra2sFCZ7PTm+ShAyPJRNKlPED2xY41Q+VCk8gwuBFDIvOL6E39zom8I0JDzLrUp4X079nx5p
	IY0kE6tgL+1oXzK5eYqHaz/s3Fyee2lwx7F7HgwhPf8Z/apfF1+RpPJQlSg==
X-Google-Smtp-Source: AGHT+IFC68faYj/oMpI20JVx1LDKHgPfTHmPFgujxw6yI6+QGVOqecwGVCYY2/jj6/JRPGf8lVZ7mQ==
X-Received: by 2002:a05:600c:4e8d:b0:455:fd3e:4e12 with SMTP id 5b1f17b1804b1-4588d646f0bmr458835e9.4.1753782198603;
        Tue, 29 Jul 2025 02:43:18 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778eb27f8sm11743653f8f.16.2025.07.29.02.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 02:43:18 -0700 (PDT)
Date: Tue, 29 Jul 2025 09:43:14 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 08/10] vfio/iommufd: Move the hwpt allocation
 to helper
Message-ID: <aIiXshblqd5GwpIF@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-8-aneesh.kumar@kernel.org>
 <aIZw0DnAniP5G6KG@google.com>
 <yq5abjp3bmu1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5abjp3bmu1.fsf@kernel.org>

On Tue, Jul 29, 2025 at 10:44:14AM +0530, Aneesh Kumar K.V wrote:
> Mostafa Saleh <smostafa@google.com> writes:
> 
> > On Sun, May 25, 2025 at 01:19:14PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> alloc_hwpt.flags = 0; implies we prefer stage1 translation. Hence name
> >> the helper iommufd_alloc_s2bypass_hwpt().
> >
> > This patch moves the recently added code into a new function,
> > can't this be squashed?
> >
> 
> Yes. Will update the patch.
> 
> > Also, I believe that with “IOMMU_HWPT_DATA_NONE”, we shouldn’t make
> > any assumptions in userspace about which stage is used.
> >
> > The only guarantee is that IOMMU_IOAS_MAP/IOMMU_IOAS_UNMAP works.
> >
> > So, I believe the naming for "s2bypass" is not accurate.
> >
> 
> Any suggestion w.r.t helper function name?

Maybe just "iommufd_alloc_hwpt"?

Thanks,
Mostafa

> 
> -aneesh

