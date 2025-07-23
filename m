Return-Path: <kvm+bounces-53267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B462B0F73E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA157173D82
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007231E9906;
	Wed, 23 Jul 2025 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h98pFnhb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6731189F56
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285137; cv=none; b=lr3Yqm/kA8SDnsb+hNZhRv0ICu8BpKvBQOW2jje+IBfI0XeCptUF1CfguDI22EwkwTTRKMFMok/9MKvnhuGlsdIHmN+CfE92Vv7dZi3hFMIpwD1GSBuO+7zmaV3assoGDy7TEa9IA7ZIZwTMaMamALWPpxmGwsdQ5QyyoTa9H+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285137; c=relaxed/simple;
	bh=GqRPDz7Js6J5ALXU+f1ABPbcLmWpDxvD5BvBQq4in9I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=d+Q8NISHHsZojyZ8FkVE8FakKY760OvDvQcnNGBfBOHjoWYkkRcvf7dy6lZokF2Mo+JEn2gK03X6TxDKgPqSg38R6UBBlZ3n0IHZFYbIDt/dNBZOyu7PR+URCDGeek1bB+v+XsB/dcLRooo2yvo+gZ5etgRuZg3RtEHEZ7WhRDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h98pFnhb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753285133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GqRPDz7Js6J5ALXU+f1ABPbcLmWpDxvD5BvBQq4in9I=;
	b=h98pFnhbCK0P0QwFFhbuIsjGi7Ome1H4+5Q9lHdfxnxcZTzFawOiuVcHDoO/IF1o1Ldd3Q
	cTvgahs8RR83rd+ekWgO34HmNZUxeic0gOoWtT3mvGB4cQF0teyYqYd2dAnYJEstZSS6MO
	xuCTXMll6xbJD5c4BlprbBr4J0Q4Gcw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-264-Z-S5dMifOluNmp3csqEfWg-1; Wed, 23 Jul 2025 11:38:52 -0400
X-MC-Unique: Z-S5dMifOluNmp3csqEfWg-1
X-Mimecast-MFC-AGG-ID: Z-S5dMifOluNmp3csqEfWg_1753285131
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-456013b59c1so40799275e9.3
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753285131; x=1753889931;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GqRPDz7Js6J5ALXU+f1ABPbcLmWpDxvD5BvBQq4in9I=;
        b=E7PaB4KPeLi9Yyj7RgtHyqz6KIIv5CmRsYhHcqNRQrFiI9ICDAa6zMVWBZfphHR0Gv
         53ZePTd2NiSqZq5905sTj21UL85k6yBKiWiLISfh9KtJXHn52RttBTiEaOdJyiQXs6g2
         74hIPg3SQ23qmg0SQ9QxFLQTtz18cmgpSFlD4BMUciuMO34X5w3MJf2F6Fkiz1UnneMb
         laH1Hine8ShmWiSLN1+4zq3FKwvtmqj0iTVhjSTwMJuqkt8e3hXXL2KAAOTWT/jQRNFi
         qoC2XfNhs4bShNZnDs+3Q0+mLRl/cJ5fmzdcLMywpGDhX1rDLw3sVNESn8J8khqrUuF8
         FqOw==
X-Forwarded-Encrypted: i=1; AJvYcCWJs+LJy9Pu7geaeeNrNi9DRVnIAN1D2wwFEjD5xB+KQhwU9THCZD/4D8lAlt1He8ek7yA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5bLRFtcw1SFXzE5YjEdIupe/4B0ZcDulJdD1o/yZw8NjajVBG
	0P7Sy6hPVkmTcugt48Nds5iBuHBhdDd8L6bnBbRvUYUx1DQb22AJo7RFVq9sgEAqoqDBvDo7oE2
	9Ns4HRJKSqHTl2/PZ2yEyCwpUn9wmUdyGATybJ77u2Rwb/kaDDy4B5g==
X-Gm-Gg: ASbGncsnKIqbJWsh88cZoUAas8zBfvAcvvBuamRBADtDCvurS+FjjUdccqXdNTV/E3q
	JhUrD+tqfF/5R5anirK2OGxehSiSC+UddyDNbYXQ7HPSUKKa06/IwTxag69oROhHw30uWhPp35S
	hL0QaDrOXqOSZSMAEd2LiGG72NFhxHTtABkxVnlez0XNfg7pA6bp5G+e/jJ35ntPu62rDYA/7tR
	u++qVjIi9M4b6TMqFeydZzsi3izoXw6SY7JyeTCyIvO4Gpze66Am4+9T4o9ABgqQRtrJfEW8J2R
	e1WNiMbfp4CaFNfmpTS8BluqrG8ZdKaU5+W8yiTLJAhVtxZCpZ5CUqgmttPPXBOB1ETNyNxvgcY
	x78b9ycOUlXWf
X-Received: by 2002:a05:6000:2dc2:b0:3a4:e7b7:3851 with SMTP id ffacd0b85a97d-3b768f118cfmr2651219f8f.58.1753285130611;
        Wed, 23 Jul 2025 08:38:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5VNOZ06d9Q7sp8ekogChg0i83vEbzTHM1kvfRBR/uvTvD2QLTEPwMtYJKOiLyp1I3mVdofA==
X-Received: by 2002:a05:6000:2dc2:b0:3a4:e7b7:3851 with SMTP id ffacd0b85a97d-3b768f118cfmr2651202f8f.58.1753285130217;
        Wed, 23 Jul 2025 08:38:50 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45868ef50d8sm27988315e9.0.2025.07.23.08.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:38:49 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:38:48 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 2/4] KVM: arm64: Clarify the check for reset callback in
 check_sysreg_table()
In-Reply-To: <20250718111154.104029-3-maz@kernel.org>
Message-ID: <cdf8ae33-192a-7e6e-8434-e8d336bea655@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> check_sysreg_table() has a wonky 'is_32" parameter, which is really
> an indication that we should enforce the presence of a reset helper.
>
> Clean this up by naming the variable accordingly and inverting the
> condition. Contrary to popular belief, system instructions don't
> have a reset value (duh!), and therefore do not need to be checked
> for reset (they escaped the check through luck...).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


