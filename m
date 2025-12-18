Return-Path: <kvm+bounces-66248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E97CCB7EF
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 11:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 684EE30EEFE4
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F2C314B60;
	Thu, 18 Dec 2025 10:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ln4zUsPL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GqZX7u7q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3D23090DE
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 10:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766054879; cv=none; b=TfNoLSVK/4mGa2nGX6rT7lOg+byVVTb+oZ4z6s/lQ4tCn5CTXHL2ZmDHXW32FErckY16W7BI75PHDcKIF8Slj4AnFhd0pS96727sZrpQded/HzMXG6VMxWs9qVYZ6UKr95Kh5hf8uU6yIX4lqWaiqtoJqL25GhttkhiM8E94HyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766054879; c=relaxed/simple;
	bh=bC5rC0odBPaYGZvlXWgt5joBmxtgcwQdHn95OPKSfxk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UM1Wqx92eR8XC0i5aa3ZczHnqqRqZBsatVC3vdW0N6D7hCFYc9mdgYlztHr+7prNDZn5MHVEK1MUrvN0uVReboieIAn5ASlpU2c8PPCeaNNsVVZZkgQh9ag3JlFWUIwSh4Rur1zXZc6R5bQAcfxoWrDYxCEay7K9RXSaqIuWbeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ln4zUsPL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GqZX7u7q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766054877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pp9UhEKJ7Aa1makSg7Sp20zlDcbU41vV+Bf96yUQzM0=;
	b=Ln4zUsPL0TCDxEbDoPstzbUJ/TMsuVlk/tCPqoZU3GjpS0cNL0inLprW2yEfUMrh+cI1sY
	A8Aso6VREjlV34AXsVcQuijvSwQOP0oGq/tcYFS0Evm2uc0Ur3L/u1l35jRmq3FGs5Px59
	GDbEmAXtuJAvX6yM6jeD+VPOMPnCSeA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-OmHnQHudPPmBQk4EvqdyLw-1; Thu, 18 Dec 2025 05:47:55 -0500
X-MC-Unique: OmHnQHudPPmBQk4EvqdyLw-1
X-Mimecast-MFC-AGG-ID: OmHnQHudPPmBQk4EvqdyLw_1766054874
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430ffa9fccaso438703f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 02:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766054874; x=1766659674; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pp9UhEKJ7Aa1makSg7Sp20zlDcbU41vV+Bf96yUQzM0=;
        b=GqZX7u7qixtHAPBin+xa28sYgTei7D2RUueuBYGVN2NMx1RpgLlWhQVvF6GxfPTIUu
         ldF12m9XL0Ibdcz0y4VjN3ZS39A7NZNjwBQQ6TCfF1v+PkmEoR9y9qaI/NlhLy8D2grA
         vksSEVdLGVLDPV+B/I2iHuflih/M2Bq+mRuAC0hTV3dzb0vajc+ZcW76IJomHwNbysCH
         5TSctjmbjgO/uAJmsa5bU9lf+/PZ9u6Qsg6/x/IZPUrYdb6gzxB8WZoiarJ3qFzJs5eg
         J9CtemWgcPiyh/sv8iKSnrFgY5Jhg56+UcmeXAEiRxVWYYxRsEAS3KSyaJhtR9macDdC
         fO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766054874; x=1766659674;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pp9UhEKJ7Aa1makSg7Sp20zlDcbU41vV+Bf96yUQzM0=;
        b=nxo66+N+v33r5OflvO/uSVJTVUdRMERs172pBFAdnqDw26MrZCS5O+XxK5fMZASRlN
         rGE4hWQhy5wG8aUoZggrGPStaEGDtFGsIFvyQfObD+TCfox5hLG4rtXCeiewdeD2eNKO
         3dx0KWMv9gWIG2TJFLDpoteXcCq/UmDgl1Dh43EX9nZRk7Qiw3Yl55pcfN6mCSCpX5ea
         gNFIPdOhn4AGRh7ZQ5Qc2MAUk6D8C7TfNl1MJBsKne8wGgYMektfqOfXK8G1U69QmUnz
         G4jSRpINDtK24Vg53W8B3Tx6hd1T8xRATdbK9UbuOJYCQBizRVBubs84lSIaAzaxrq52
         rCqg==
X-Forwarded-Encrypted: i=1; AJvYcCXe0TpLom/+cG85xGjA/OMETyM0ljR7kuCOhIYRqtMPfRHXugzP5f/gPz7UwepsUl3YzZU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTZD84FWnJczS1ishUMChZ6RDityhzn7ERJL3nO6Ij3ILYv/R0
	JxOxm718SQbCjfRx0zfGtVW5i2CXsrx/eckTgtL4HzCgOXVEoi0LXHxfS1vDZguF+3NikVH8iYL
	XXUxrry1cbAPHtVUuGELBwq1STlikfON9xpVnEOHI8E3cttnxZhWsqA==
X-Gm-Gg: AY/fxX5cts/VZPrkS8kfLXbiAlEq5Sg6VJxnlGgyKhT9VNtMPesuVlDyd+/zhiiLcdf
	bw0wmIeIyNkNcNfli8us5DO37qcmAy5W3mp0Oe30+9p7W1s1x/Hd1bkZdW5vnTVNFXQlEFbEJEW
	Nl7ZiBUMclft9LekABuYq8dKEmzBg7Rbjt3t5FfoNCy2IU4TPHxu3GzxsSkadv+RFbZscINDt/s
	7FU3tKHZHSxINrZs4lkJQ9Jf6Ar1m203+HyefcpfoDuWDQVdhTzOtF8Vp79ZlVlwclH9FL/uNuP
	GkazDHGQnezHkzSKga7ayvdX3e9QQBggqeMNjKIsJEZiJ/nnEGBs/qLIq6aveDVU3fskGaiwRnr
	yi0dNRst4X+fJG9rDl2yibFBT7T0D5hBUv4bTc/iAui9gJPJ2iHvI4+lw8A==
X-Received: by 2002:a05:6000:2310:b0:431:c73:48a8 with SMTP id ffacd0b85a97d-4310c7349cfmr5741361f8f.29.1766054874042;
        Thu, 18 Dec 2025 02:47:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFuywpjPrOv/NfID+cPGxbswKBxASUTRoemJwfrew+cKOcN66jSr00yj2VRvWLEsTsvRQvgw==
X-Received: by 2002:a05:6000:2310:b0:431:c73:48a8 with SMTP id ffacd0b85a97d-4310c7349cfmr5741323f8f.29.1766054873556;
        Thu, 18 Dec 2025 02:47:53 -0800 (PST)
Received: from rh (p200300f6af0aa4009cef065b67c5ea88.dip0.t-ipconnect.de. [2003:f6:af0a:a400:9cef:65b:67c5:ea88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432449987a4sm4239256f8f.31.2025.12.18.02.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 02:47:53 -0800 (PST)
Date: Thu, 18 Dec 2025 11:47:52 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>
cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <20251202160853.22560-1-sebott@redhat.com>
Message-ID: <ea9d0e28-27eb-be68-7292-780c0120f1c1@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hello Peter,

On Tue, 2 Dec 2025, Sebastian Ott wrote:
> This series adds a vcpu knob to request a specific PSCI version
> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>
> The use case for this is to support migration between host kernels
> that differ in their default (a.k.a. most recent) PSCI version.
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> Alternatively we could limit support to versions >=0.2 .
>
> Changes since V3 [3]:
> * changed variable name as requested by Eric
> * added R-B
> Changes since V2 [2]:
> * fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
> * removed the assertion in kvm_get_psci_version() so that this also works
>  with a future kernel/psci version
> * added R-B
> Changes since V1 [1]:
> * incorporated feedback from Peter and Eric
>
> [1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
> [2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/
> [3] https://lore.kernel.org/kvmarm/20251112181357.38999-1-sebott@redhat.com/
>
> Sebastian Ott (2):
>  target/arm/kvm: add constants for new PSCI versions
>  target/arm/kvm: add kvm-psci-version vcpu property
>
> docs/system/arm/cpu-features.rst |  5 +++
> target/arm/cpu.h                 |  6 +++
> target/arm/kvm-consts.h          |  2 +
> target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
> 4 files changed, 76 insertions(+), 1 deletion(-)
>
> --

Anything else that needs to be done to get this merged?

Sebastian


