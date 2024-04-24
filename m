Return-Path: <kvm+bounces-15840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C145C8B0F0D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15855B2E335
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBABE16078B;
	Wed, 24 Apr 2024 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xUGT+1kw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1CE15EFD6
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713973494; cv=none; b=VGWFpMd2g8g4YFCxR0X86o3f7/nfZgJ72TrhSYcvCb3YANP55TKkCMi3rjeNUaLXHhLRuchXwdVjrLp6kCIOW741o0Akhfw9E1hH8L11IYAqexba7IoC7IXPKOJLxuNWWJSEdlGzkc1c7uma1hQBJ4szyTez/wcuDqdlG9qdvhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713973494; c=relaxed/simple;
	bh=i+7ca9F3R2iODML9OguZS+G/rK7IFeFMp6FII54jhQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LtRmFTsSU9UVyoPHGvPbIbj1puOklDwcJhaP2y5PoAorSFxq3KcDisz3Wgz6RSioUSyFIxv2DkprSE5/m2kfljALizdmLxO11G2mxsg5Er/MLxAcfjjlYZ+JmObi2JWBVhlvfCNyxTSZcD9AYbEgmLwS0FXxn+xYI5aJampgxZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xUGT+1kw; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed5a1724b2so31912b3a.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 08:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713973492; x=1714578292; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=isygqxg1DADtvvMpbUH5H9PRVRX6wRPPjYc9YMzxz5g=;
        b=xUGT+1kwxEzpMO+O7wS1ziGG9K2H/oUFR7Sjkm1ASnzzl167N+t2sa5pNS2aX5trdE
         rAkedHiECe05XtwIaPeWAYpNC1rZn/jJRJ+Li5R+WhGLG3nKqHGm/diT08GXCeeZgJrB
         6AsjghV6g2LGmo/XYbas1sIWU7Zknc0A5N04cEFYZTyqByNrn1JtlHnkju9UBQ98eaiU
         vK2cUKf+WC3GAl9Cb0aIItgxJ3qy7/tiRBoZs2HJwcb8oI0397cd6tLt9n2ZZdh+ZSEk
         Aao6DWFijn0is0JoFHGVt/7Dt5nRbusadufSYj7kBy7+ruvU9dvI/MJrNa2Ky5/o08wa
         YhfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713973492; x=1714578292;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=isygqxg1DADtvvMpbUH5H9PRVRX6wRPPjYc9YMzxz5g=;
        b=r36QIL38nqX8nX9gFfwUtMk88bNPCM4MnU+Gq03NOKBrUCV/0aLUMziMIhrw0/F5mJ
         WqewoYgPO/WQCCsVFQVkewMmJw9YiLsk633uQvWfIpAbVPUhVQJ92FKKJgrXqhD0Ktge
         aK7hkI4UPSAz+4H9ER0ryCSXzPICztju0SUdxEcXdO2qvhGi8LHuMm3WGVmm809391jM
         3s2t43TDcBDiGsQGatB9h66mHwmzACHSyt57/OW9a6tCDJ9cpBF3OEnjgT4j086eWhSo
         Nsjol1P59dQdZHdGmIEehOJqVotLJqgxHGtHB2TLaMbH752kzG5Aj8tupFnT0gLB++WM
         LQjg==
X-Forwarded-Encrypted: i=1; AJvYcCV6n/sw9cUiVrROD3btAqlMWtXSKNB7ZHLctBYzYMA18wctBiYaBcg8FCqU2+i5UJ8AZeMFIpNf9fJm0lT8qP3khHEr
X-Gm-Message-State: AOJu0YxFPIWICcGHD7qj/CbDNlk7vsMPn1pGlbsjFhUrOMzspHUmqbF8
	XLjmDnYGl26p9O/XVNhg9xN18Iu3HS+iEebfzE5uXG5nMccbf5fA2JO75kZ8ZaJqSvTJbbq+ukS
	zuQ==
X-Google-Smtp-Source: AGHT+IHS0BxqB9PcoPfboy3NmQMn9RV38ybNDU7Su++NB70GwISBmSLNZI5ND+4qFNSlwp+C1XSavho+YNM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4656:b0:6ec:f5b8:58cc with SMTP id
 kp22-20020a056a00465600b006ecf5b858ccmr437835pfb.6.1713973492116; Wed, 24 Apr
 2024 08:44:52 -0700 (PDT)
Date: Wed, 24 Apr 2024 08:44:50 -0700
In-Reply-To: <20240424103317.28522-1-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240424103317.28522-1-clopez@suse.de>
Message-ID: <Ziko8vNhTeOdfXNu@google.com>
Subject: Re: [PATCH] KVM: fix documentation for KVM_CREATE_GUEST_MEMFD
From: Sean Christopherson <seanjc@google.com>
To: "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024, Carlos L=C3=B3pez wrote:
> The KVM_CREATE_GUEST_MEMFD ioctl returns a file descriptor, and is
> documented as such in the description. However, the "Returns" field
> in the documentation states that the ioctl returns 0 on success.
> Update this to match the description.
>=20
> Signed-off-by: Carlos L=C3=B3pez <clopez@suse.de>

Ugh, copy+paste fail.  Good job me.  In case want this backported,=20

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-spe=
cific backing memory")

Reviewed-by: Sean Christopherson <seanjc@google.com>

