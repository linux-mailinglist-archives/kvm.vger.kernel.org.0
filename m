Return-Path: <kvm+bounces-53271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87081B0F788
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD029163933
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488201E9B1A;
	Wed, 23 Jul 2025 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLAetlwa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E326E1E500C
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753286213; cv=none; b=RJJk/NQxzPjvYNS4jb22uZ1Nd9hQWI+bK2M04IKGLf0qAEM8R7jCk1YYovMltf06An3gv5r6QyyfqUkWactbplFwEsy+wIFz2XwdME9wFAIHpbrOD+eaXv15vb3l3Q+DgAaej4zNEXRW4hIaSBr9f7OLXWHlGRrfsfq1kjvIlec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753286213; c=relaxed/simple;
	bh=Xx2dqPhZid/DVjqgMSquhTFU7ay+TzkkNAEATL+i+gw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nx+2oQFam0dP9s+Y9DWeaOseE1qoe3jvIH6fbhsfHyFXBHg/oCzV0qZhfKg8PRA8NlE9bRgilLfatj/U25BTGD45Oe1uhx/TVhMcq4FSnsJZzPIDZD6wkJg2EXLYeWOM55Xt+6nLEkoMt4F09IM0/NXilIM+PAQaXLvpC7adSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLAetlwa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753286210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx2dqPhZid/DVjqgMSquhTFU7ay+TzkkNAEATL+i+gw=;
	b=PLAetlwaIF7gPljppXI3fSZ/ViAqY0/COZ2KBeqPdblSjvtB+VL2sCQq+BDBquxGAm7TPf
	E884AWOxm2h02MAqk/JWITl+v/BwwnaNsW5vf7oErXrsoGx4PUKcNtlKn+AxJNRDWuQuHI
	RYlay6WJsfwRBRDvsRfrt0b6VR9E5UM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-0dTCmq-jNly6p1jukkJ7_g-1; Wed, 23 Jul 2025 11:56:49 -0400
X-MC-Unique: 0dTCmq-jNly6p1jukkJ7_g-1
X-Mimecast-MFC-AGG-ID: 0dTCmq-jNly6p1jukkJ7_g_1753286208
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b604541741so5028851f8f.3
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 08:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753286208; x=1753891008;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xx2dqPhZid/DVjqgMSquhTFU7ay+TzkkNAEATL+i+gw=;
        b=qQSzcN0AVOoY/bno8pDNc6KmueHXXb7S1xcR3B+x7haXT+Hxoe4tgCkxPilgZ3l91Q
         44kyD5UFirM8AipWXtOg/wpMTJOM0QCecPkhLwtLTbqPIp8PgP/TwEBvSG1tgk/qV3a+
         3LqNu8atTYoyEhQa3Q7pUpVwAzoEPBU8ovsxIX1gi1x3xhmzzvgL9XT3HKA+Ij87zJh/
         WzJq1aFDRLMx/wE09k/OsHpoVZMYzETqe9st12yiZcEBIvT/vz9PPndvpn/JO6U3B5YX
         9lIB3YGdfAC8KNl+XC+tJKzYcvXxFZa50EekTRuggMhJ2GsjcV7hzfl5trd+SrluqOVH
         RR8A==
X-Forwarded-Encrypted: i=1; AJvYcCXr2UPYrwxvTIk9NCImtZSa5lFPnIIIX1b+5c8ZvgW0yxW68uje2S/pD0GisCp3Blj2kcc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRD7CsmTiX810j08ecXFuK1Fwk7UmKgra5oRyhMx2j/h3zkZjY
	ophgErzOC9AVagDd12XKYpXutBKbsa1XlijkTnKs5HOJnxvGcKtmvnInhQ9bcFpv4ZKD8y3SzLw
	1JodpVihtREBzej8EdRtv7FM3a/m3EJkLg9np5gchFi1gQtjT1P4QVA==
X-Gm-Gg: ASbGnct0l3ZYG5tVR7GCveCtwUy3CaaCHSAFnPitp6lJRuVLQFpcBGR0kh+jmLjt2QS
	Ic4NoXXIb91RWMTA9VL9raATa+ue96CnD9RR1oE2FaM6oSLX06geq3NIi65DHcnXre0Bf4vkgrS
	RU+1BXpZywDyydw4V9Whd5LHLHgSE4jdZZl0DC+DD/EOpirY1C1qPbgSyH3FkzlACyPENzAu29M
	M2JSPVrDKywyLsuloHsylqKA0p1jENI/71eEmlQBp76/rUGspEpFLdBUD3KllVyF5rfQhL1U+3b
	LqS5Z4Qwz5PzFU++SCzl/h2PrEbe8v1SO+wEM/MnNnjKFlVyZPpJ/U/yq8ChjgRB/HzYdr9Ecyq
	m0cg72/BwdHmS
X-Received: by 2002:a05:6000:26c6:b0:3b6:2f9:42b1 with SMTP id ffacd0b85a97d-3b768eedb05mr3113399f8f.13.1753286207904;
        Wed, 23 Jul 2025 08:56:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRkJqxrVVPLRiwaF5PbaKWf414l/WBiJeIdnuyQV3tqT3YAeHRnT1isf7baSPgjvG55wCY9Q==
X-Received: by 2002:a05:6000:26c6:b0:3b6:2f9:42b1 with SMTP id ffacd0b85a97d-3b768eedb05mr3113379f8f.13.1753286207521;
        Wed, 23 Jul 2025 08:56:47 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4c88dsm16709093f8f.60.2025.07.23.08.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:56:47 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:56:45 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 4/4] KVM: arm64: selftest: vgic-v3: Add basic GICv3 sysreg
 userspace access test
In-Reply-To: <20250718111154.104029-5-maz@kernel.org>
Message-ID: <a6ed6e2e-38a5-41fe-7a63-0418d4ea7661@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> We have a lot of more or less useful vgic tests, but none of them
> tracks the availability of GICv3 system registers, which is a bit
> annoying.
>
> Add one such test, which covers both EL1 and EL2 registers.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


