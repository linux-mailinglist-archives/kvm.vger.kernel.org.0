Return-Path: <kvm+bounces-68057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB8A4D20799
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:15:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 99D323015907
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B782B2F069D;
	Wed, 14 Jan 2026 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cOMtfzm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7949F2EBBB7
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410757; cv=none; b=sJS5aBQ2pcfgKXv0x+kd2f1noNNXkgLdasTau8GZSepWjQ/ZIolMGpFyQR2cU/co4Akn5aWM6IcHRAKU8d7PDf9dLVEXfbgKvcXecBvxmZwXJbvKNosrBVYna2Nexlp5lBJYS2H05wOg64L9ElfDxSVzwM2oaB7giuzeY+8YAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410757; c=relaxed/simple;
	bh=PL79vSldCKtASYKnl7kt5MCW4dDYwKlzHx5ppwlIl0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oRlxRDQxMpPhnZQ/WuhG/9brkB2xi+2/OEwqFAeh8Z2oA6ReMxPCFVnjRqWk6loke4l/mSu+wj8z9IQAL7Szfdd891T8l4W8J/hsiz5hFLy/yQhCGvkfOmm7XIjpxW6gCI2DeyEZ1abbMwnLC1HCz0GKx87BGaqiHuV0We0dzKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cOMtfzm8; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81f3c14027cso599020b3a.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 09:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768410755; x=1769015555; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JXX4CYzqo8iPchV5iHBX2x1afORDmInP6zpB6RX87OA=;
        b=cOMtfzm8y7NlmC0UGsv/RhH++X6P8TJ/Wv9DyO50s3TjEx6j7dPVMsV+CrklEh41J+
         mLE4cM99VeH0pA1rY4avG8+Ab0lfDTM33YoGASNPVQlZHMACQIfqIQvPEzbHcBLulH59
         YvfCYRSP2T8wEe4044aUI7hjAGSDEx2O3ULkqCt2cGHILKyXINcieutS1rVhtotKe24r
         CXe0/mcNRYykMFF/myH4cQcU3D2BRAo3cS1ITxeU/vkK713uM24hXm60Ly0v19u2yuCI
         m2MmMqwd90IJVYPNLrkHLQj2gorJ/1fqjY3jdBRkiW6aa24c1nws8zYe07MsvJ7xmxpR
         CJEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410755; x=1769015555;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JXX4CYzqo8iPchV5iHBX2x1afORDmInP6zpB6RX87OA=;
        b=v1dYFmocnT67pTd1iytdhmqQcj7V15lFl8nFlR0fhBdylsJSlBCqBRM76pxV6yzU2z
         oejOcPSLOX7aIUDBo3PyKnziId2/yiWpEOh+97lPGEY1/CpOPxRh3KEmmaSJhqS420hp
         n+NjOEUMnMPCyW0hA51/6bxKSb7uVkJHhK65SK0VtNGXwE7xxbNTxCdXI9rHMwVYX85G
         sPGPWBmlQ6n1LUkC5UKsPclt4w+hZnrq6sCyQjMfx86pl3TRbWuVY7XnOKoI5wBhjbqv
         KX7pqAL8IC/cS182Tva+winq5Cf/zr+fjOKEG2wgyswq9bYwxbRQlKb19usugC4f8HVC
         0ZiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGPQj8up3FNYPPfGeKUbRybDF2a6POHQRMvKS/qW4bB0ry3CF+yiWRQUrRJA7wAu4gDMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE8n5CE51eRRTPnsbtIYIeRqkOnI1leEChx4sbchbSXqtL6RSd
	X1JICjjXyp+63q9YlTgdA02RA1kmEh96Z6hIIgJGwrHQqqeGG0YoFVpOD3Oy4+sTVA==
X-Gm-Gg: AY/fxX7XpXLWPKiQ+PM4CtgMFktGfruqtUfhaR2yuPxjTIrfmGF1UFAkj7VDJlN9UL6
	uNYfob7VECzVjLRAr2kFcwo2HpMo3+j8KjQUtjFDN1+Y/80Upjk92DPhrlAvdW3HQIVBX4TCO/l
	B7ETzL2EzhYBFANKY0eA/xj7EcjRyJG2z3tYizXJTpcwnhHWTPswAkX5ZEwwOEd1rDGHbf4WdEx
	Nn9zEGxtbRoL/mEvp9Lu7lzOFXJ3Rpo6KWDqjRPSG5RmIke+78TRVNYYlazFumXZHyVCCcpSUv1
	hi7XoNUYh8J84PVBOgbg/SgQIbzPvX38fPpApq89H2w0A5VUs3PBZr7MtCKVH6NhtAN9rrBrRxX
	VYfZLRaAHcn/qRVZmyFkP1B6ZxUNZzPmp5P8JpgOX1PvAmQyRKqROXpO74ZhmEaZFDC2dOauPvi
	zjIY4E0B58/nrfAXMyD8Yr49ZnhG+gRW4LaOPHCs3zfxaU
X-Received: by 2002:a05:6a00:1818:b0:78a:f6be:74f2 with SMTP id d2e1a72fcca58-81f8f0089damr146513b3a.5.1768410754527;
        Wed, 14 Jan 2026 09:12:34 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81f8e4f5276sm130598b3a.24.2026.01.14.09.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:12:33 -0800 (PST)
Date: Wed, 14 Jan 2026 17:12:29 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] vfio: selftests: Add helper to set/override a
 vf_token
Message-ID: <aWfOfT3vZSWfa4-l@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-6-rananta@google.com>
 <aV7kq76DYIx8aNVv@google.com>
 <CAJHc60xMgz=JuqTesqC9h0axFMQnLX-eYbGBi=DG2_gDbdTnoQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHc60xMgz=JuqTesqC9h0axFMQnLX-eYbGBi=DG2_gDbdTnoQ@mail.gmail.com>

On 2026-01-08 01:45 PM, Raghavendra Rao Ananta wrote:
> On Wed, Jan 7, 2026 at 2:56 PM David Matlack <dmatlack@google.com> wrote:
> > On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:

> > > +void vfio_device_set_vf_token(int fd, const char *vf_token)
> > > +{
> > > +     uuid_t token_uuid = {0};
> > > +
> > > +     VFIO_ASSERT_NOT_NULL(vf_token, "vf_token is NULL");

nit: Drop the "vf_token is NULL" message. It's unnecessary.

> > > +     VFIO_ASSERT_EQ(uuid_parse(vf_token, token_uuid), 0);
> > > +
> > > +     vfio_device_feature_set(fd, VFIO_DEVICE_FEATURE_PCI_VF_TOKEN,
> > > +                             token_uuid, sizeof(uuid_t));
> > > +}
> >
> > Would it be useful to have a variant that returns an int for negative
> > testing?
> >
> I couldn't see any interesting cases where the ioctl could fail that
> would warrant a negative test.
> The 'incorrect vf token set' is validated later during device init.
> I've implemented a negative test for this.
> 
> However, please let me know if you can think of anything.

I didn't have anything in mind, I was just curious.

