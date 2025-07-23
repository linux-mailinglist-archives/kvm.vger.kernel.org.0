Return-Path: <kvm+bounces-53268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E01B0F743
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:40:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B7513BCF33
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051041FAC42;
	Wed, 23 Jul 2025 15:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X33EK5DF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD591F873B
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285210; cv=none; b=IVRTOBy4WvWbjUoSj79mKumCg3d05EAAGTgdJAXveUVe6x/R9fKQT+DyHiNZ4RjOPY3Lp9R7oaIiZiqgGTrlsgxdgvQDqrh3t7nKNouTo+58siK20BfUA7qphipN6j9scyV/Bwex2GiLa1UK/BgwWK3vhysy8Xx+8DopI+ndmto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285210; c=relaxed/simple;
	bh=BbnjsD8D8fd/oPMol8b7h4DNOpO8k+r3dNGd6webbIw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=X3gR38RDJNj33m80qgk+mMFERcxP4S9BcLtPN0lspPna2Ge/oganNAts0YZfKEwaWii5Y390D76rZkctau4D7PDhWog4thKnhbjis14vlubF/e/HuBmtj/mwf/l82Uzkb3a8BtmX74d++vTOJ0T1Ljw0tx+0am90bRDjJrx4OFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X33EK5DF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753285207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BbnjsD8D8fd/oPMol8b7h4DNOpO8k+r3dNGd6webbIw=;
	b=X33EK5DFbHQWUYLzTgiourtxi66wtqfJdyItbgcsqu7a6SjgNta4oY8eO4yCB/bud40eEN
	vh/0MD5ZshYjsjPe1/cGfapSfTVp265pMmnel2lG9Ka1VYAHsb6hKAsuvmsHv93UFJNkPY
	t9K4mCLZjzFNVhFXFd36Chymclapo0A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-Rq-5KL0BMzODfiKmAISjWA-1; Wed, 23 Jul 2025 11:40:06 -0400
X-MC-Unique: Rq-5KL0BMzODfiKmAISjWA-1
X-Mimecast-MFC-AGG-ID: Rq-5KL0BMzODfiKmAISjWA_1753285205
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a5780e8137so566589f8f.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753285205; x=1753890005;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BbnjsD8D8fd/oPMol8b7h4DNOpO8k+r3dNGd6webbIw=;
        b=qlpsckwh9piMeVjPtUZUAbBuh+QQv25iHovm+x2D0OMyc89g0qkEjdh0bMwCVcDnwD
         GqU1umbiaYbasAp9HzdYJUUfS+IgsOLqm1I1Bxh4Sxbf0bweR94nD2ql9dUQ0DdlPtYK
         BjBRMAiQxBDN4sy0P3cv49Naqwg+N/+SohKuwPkHqi3A16pLUFVgtHFkLDTBOWVuo4wp
         fi33m3xIUNXZSyG6RgNXZ/KLTiHhXnbLPpOf2TphsZ6rYYqtsOuLddzR5qKnKQTtcHuL
         g6rliMFILIHeX5odH4oI+7DjsEeuvFV/Cs1b6A6SHyWjHrNugmW8JQn4OUdLgGiURg77
         YORg==
X-Forwarded-Encrypted: i=1; AJvYcCV9+2Mq8lp7S4KTikol7J9UH/d4K3e2i5fpkaNGda9ONx7WrQd46LrVSgh/731RzVvXxTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxEEPTlAoBLi7JC1yjaoIJUTg0YQ07WUrHRIGNgT25JFYwp5rH
	Vw/T4oy5S6RXGC7CUfL7s219NUR4SQ6Jv5gvsKx26uCdfHjfm2b1gKedtBstQinJz1sz8+CUpuO
	WmzPEq8HW6PBW807ERHxXlvRWCmbG+xXTu4Opg701iX/mhpA+MQRqLA==
X-Gm-Gg: ASbGncu5n9gicpHapTxmj6TzF9ZWOUFDcMoOfSup9K2qoA13hLBhadZaJ6L+TLORRt2
	ZJ3HYtj4Igt68jPEKWhIkueR5I3ghUFBMR379XE+1ThsMqLMzX02ZwZ+SmM60guiDzpo05IClyt
	qGFAzRy7+FVHab1BiecusrutXPrcddWod0uMADZ/O5/qIKP4AqMf1mIiqS1xERZx0G+9jdnSQJn
	YozYGgjTAF1ZLk6T+j1lIzpjAUdi9/vKAtGjTRy7rl+74FxFtFnOHmZ+rI4AQ6wj/77ZH4IqOJz
	5TO+TpH4dgQBfixuiGdq5Sul/VVY1pD6o6JAjlTUdxUmL/g672iBRnb3z9kLLrubydFem33mpht
	OkrxQaUW75YG7
X-Received: by 2002:a05:6000:2403:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3b7634e592cmr5632737f8f.15.1753285204888;
        Wed, 23 Jul 2025 08:40:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsc98BzmsjHqrVG2AWlzqEG9l1z4Dg4Bl7UILlo445wKwDwA6rd8BWhQgGwVIisFVWO4wVpA==
X-Received: by 2002:a05:6000:2403:b0:3a4:f722:a46b with SMTP id ffacd0b85a97d-3b7634e592cmr5632711f8f.15.1753285204420;
        Wed, 23 Jul 2025 08:40:04 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca5c5e3sm16917670f8f.78.2025.07.23.08.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:40:04 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:40:02 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 3/4] KVM: arm64: Enforce the sorting of the GICv3 system
 register table
In-Reply-To: <20250718111154.104029-4-maz@kernel.org>
Message-ID: <601c0048-ef37-0695-8c46-e703884b3612@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> In order to avoid further embarassing bugs, enforce that the GICv3
> sysreg table is actually sorted, just like all the other tables.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


