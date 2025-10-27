Return-Path: <kvm+bounces-61172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E553C0E43D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 15:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 38CDA4FA1AE
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 14:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3782730214F;
	Mon, 27 Oct 2025 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MfvXtR4/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE1D261B67
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761573751; cv=none; b=ZoHNjsqrapsOUodD/aLFSYCS1iijdZh/LVWmHPEhhyebIkQjxvyJ1h4xW/fAYbm4DwXdspzWtpOGHiiQXhY8KlpJxUvLuXQ+g/hf1b3Qtm9AzP49ejMSFw7ce+7gRxsu0/CDyrpPmoA2uP0Kx2nEeOKBXquKkm3KOD0O3jFKJLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761573751; c=relaxed/simple;
	bh=shyQnY3YHWfiVFVYpdQzZRY/aKcQtMNw7xgIsZxMDkU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=AMjPhbYG6i/Lh0PTsXbAKoTbAmsGHMdSYbiqFCcmHPAPpVouH3Y4w5b9pDZkO+1bZYlrbs9MhLFJd+smY1ofi8jxb+e6jjaOsm3T3kp/n9YX0Nlul7Oc9+NXr22fvK+SPGCQVJC2y9bnw3H/ePk/f9WTGB5s+kvOaD7MP6VEeX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MfvXtR4/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761573748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=shyQnY3YHWfiVFVYpdQzZRY/aKcQtMNw7xgIsZxMDkU=;
	b=MfvXtR4/5qZAKlkvxlCX8n6PVXN8TVMzVeJfyB11OdZxjDfAMO7PHmURWK/DqjRIHNehjm
	g1Xd8f9q6S+3fj3SvLghXkb4Sx/AtjOZIovuyVmD13ZDBKObexraoHlvbPW2HRZd3GY7BC
	thGguWZze3bDBU+fDtHKTjq/wEa4BXo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-a0LdRKMiOYKxnOM9HhyUPw-1; Mon, 27 Oct 2025 10:02:26 -0400
X-MC-Unique: a0LdRKMiOYKxnOM9HhyUPw-1
X-Mimecast-MFC-AGG-ID: a0LdRKMiOYKxnOM9HhyUPw_1761573745
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so2775925f8f.2
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761573745; x=1762178545;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shyQnY3YHWfiVFVYpdQzZRY/aKcQtMNw7xgIsZxMDkU=;
        b=D8Fmgi3FPz+q+dodTJLQbPQRmYBsAIhajWEPX3/+tT+fdFwkhuh6ktun2QY6cv56gR
         rXeFL3M/KTuR5dgcA5dl9nbcJMlcT/b42OYyT7iujToDp+Fh2P2lCRs1wo3OVD5Y42lT
         QtPxI3TQZCRG5ngtFXFDDakFBINSMCm2l6ZcdMuxwNCwYk0alztBAnfWcakGp5sA3Ko4
         +MmjlXoFsNMyooZNIV5R63vKLP9mmrEZ2bnR2PcY8mDcVqUy+H7NBYTlleLCCEMwH+wc
         MHzbieqJr+naXJmlrOLEg5PHfu4l05IvdfsSQ84PauCOWOWdZVUGPPdJCY3JbxhNlais
         RMjw==
X-Forwarded-Encrypted: i=1; AJvYcCVVY+PinaCymR40YwupsY/L+5EVWisx36uszXalrBCrM32deCygrGB/qGggb35tEEYIUKc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy40I/1t9s2Nf7kD8etYUTqO2HhKSeBCTKFn3hglqN4iFfZDn+8
	wRi3rIOxH/F1ttg5N0lBJ+5th8DZmUkt0kQuO2Rph6jmE/oVZF4m4l+KwVfl5yyhRoKLhzjQ6B7
	xG8zumxu7N5d4pVahJK9i+snVn9wuQCoteuVyx30kMI9mPOzKKX+z8Q==
X-Gm-Gg: ASbGncv4DOyMXkQA2nYRKZDOFaADL+oJ7m2+68khj3IeIOQYFtdRdkzdix7+Xski2Vt
	ztPANshPcidQr7ZVkVriETmSDa/YnJDSADcbkaJ8cvsZDwYJJl5//3/MN9Fqu0K1lNdotRhbERK
	GvodhUBA1XZAu6wdXi4INZTInZncApJzymFvj8AajU9x8t4GE2lvjmlBrYu54uw5XQ9QS89VLQ3
	vYESR4WIHVK0XcBRLL6cqhfhf/n0ximOh9sS02bS6u1z/ks92QvRzqsWz6pIAB50EUQPCAnzN0a
	+ydfrRkO8/IUaevc0rYLrHCufUUvZuuHgfhmBkbip4NzYpSZcwYXVhwdSZhzRRFFYWxYapTIhQd
	8e10zkG0lZjedx6gjSPDFsgyX4UGWfDENE9dnRCk0g7toJwh+
X-Received: by 2002:a05:6000:288f:b0:427:a37:ea3e with SMTP id ffacd0b85a97d-42990755b87mr8916537f8f.52.1761573744793;
        Mon, 27 Oct 2025 07:02:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETyCrcEtLcl3q6Rbfg7qOzwYfycn5fPY5jgI68IwSrW44NCEA1DZHmuz8NQf54cnQJ3dYQ8g==
X-Received: by 2002:a05:6000:288f:b0:427:a37:ea3e with SMTP id ffacd0b85a97d-42990755b87mr8916495f8f.52.1761573744177;
        Mon, 27 Oct 2025 07:02:24 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b79cbsm14242478f8f.4.2025.10.27.07.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 07:02:23 -0700 (PDT)
Date: Mon, 27 Oct 2025 15:02:22 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
    "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>, 
    "maz@kernel.org" <maz@kernel.org>, 
    "broonie@kernel.org" <broonie@kernel.org>, 
    "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
    Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, 
    "yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Trap all if no in-kernel irqchip
In-Reply-To: <20251021094358.1963807-1-sascha.bischoff@arm.com>
Message-ID: <e2d3e614-4e5e-7ad9-5cc6-867d85dca5c0@redhat.com>
References: <20251021094358.1963807-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 21 Oct 2025, Sascha Bischoff wrote:

> If there is no in-kernel irqchip for a GICv3 host set all of the trap
> bits to block all accesses. This fixes the no-vgic-v3 selftest again.
>
> Fixes: 3193287ddffb ("KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests")
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/all/23072856-6b8c-41e2-93d1-ea8a240a7079@sirena.org.uk
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


