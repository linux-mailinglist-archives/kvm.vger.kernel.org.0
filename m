Return-Path: <kvm+bounces-45752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B754AAE7B9
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 19:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55E064E51EF
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F691DA60F;
	Wed,  7 May 2025 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ULTOkP2D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A000D35280;
	Wed,  7 May 2025 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638590; cv=none; b=KvMEfvoICN6TcJfLGedULH90ScoqqqPa7lIVVfc5gZuh+Prgp9aG5HQa7TJM78JfMO9X6VBiISryaowUL1z06kTcVjHiwIOimePlNo5weYsIFhS/munfVSjK599kPmjLpGlCE2ZTxAgCyOXR3wTQCR8bvnt/xAS55YiG/uQjUnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638590; c=relaxed/simple;
	bh=x1gyXbT/S+B28a6G/kIRZZpjDr3aUMVX/8e55YIp0z8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=oYP2TiNn/1a/GkF8LNfQjBeZ6CGdzVvpk8gzdJu+itZp5096YxA+mxM9jqsn4dEUJXibklBBPvd8V1MQG0BllCC7bGGq9eV/luKYEGdUILXBqOFyToJR6BrMl+iGSCPBNcVEyyVY1qxO2iHMnKHype38G8RF6bvYdZq0fr3Uf9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ULTOkP2D; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-47677b77725so548211cf.3;
        Wed, 07 May 2025 10:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746638587; x=1747243387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epvtqXvzVJ35ldYX1WXocWaJsX9TF2V7woAutSOPuUU=;
        b=ULTOkP2DGVhjtOVQYQItszRUDx7T6AeCglSmQ9uWeQcu1R0G9aSEaNyChG744BEbjs
         R6782UisUWBPYrPo5pmHBewqSbDj7nE1uNr8zVjRVZFsP0+wkJkdYPyq0s5FQAhHucBl
         vDLKueN94WWG8vwp+j0FCxgxB5SC58LCRWWmE4XsPK8jjcDaKw1r0+uJZG4fqmXxtB7S
         8M/JN8t/ILMvaklU331xMMmqCEuyWDFGu5CGQfi+UFEooxFRAI526CV4p0nk6pWct9zq
         SgOmDUaPnOUQshwAxlYXi1/BXh13NwXwr5OtMOUV03WckaE/8weHVWpaCgxLub4IvF8p
         5nxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746638587; x=1747243387;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=epvtqXvzVJ35ldYX1WXocWaJsX9TF2V7woAutSOPuUU=;
        b=enaKHV0tt+TsZFM/hTKJHYWNPhcmynUtgF5Y9jS5fj2uq+4N9LLaEsIU45dBxNaB03
         yxlm4nDD1PkAVoetQeicehDLWvFtnSsjoGSONHDXNsfkqk7q7+uhe4+tMAZMxLhusObV
         WL00d/QdGZPOqA1taVRyUNpyrPAVbpSu8XwAe/WGkvBbDMwaZwiyctxmAqVSom10P9hh
         wQUHA0SWZPXE/Uj46Fcj1CZfbScnDvGaBSZoNIOEypC667Y52XkiI7BEahOvB2euGABE
         Yl7mQDbtBDJ3+xwdYl+HqGwymnOmrW5guyVaufbCVyQmP1T3eprB0Y0kdJ6WIXm7Aaz2
         PGhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmpZDbgsFhgIQ3oIJdOpw4K0zrlKHpgVEPa2Wx5Mckszui+3SoFLHXF0YhzlqdbEJ+DRiW@vger.kernel.org, AJvYcCWwpbZzvjpN2ULKc5rRUD9CN/YIiDuO3SktzSoslyv+XktkJZTeMlkeN5zR7V4+VqEO/gM=@vger.kernel.org, AJvYcCX4kMNL/9F6lyOK28M8hecRd1j5m7+bldzJI9f1JllFz5NV+oO2cflFK/neg9rUjMQpTn6zYHFL@vger.kernel.org, AJvYcCXTVm4jWeKbqUFQlmWz/RwUs5IxXRE2gvAhVIH6L1fdEp5/8QwPxiVZYfmCvBKdtuqlf8sEHt29CVhv+HCg@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0kQU4v2e7Z7x2BIvpbKPDBq1tCo6OqemHU2xvIhXKtjkppWWz
	dZJu/s53MuIYs+9FBTj/hYC+spmMvXvr1brK56wTthoIhtQ72h19
X-Gm-Gg: ASbGncsPC4g4KYmOFYBaTla14hmQ7Z9s8KWhAzBKyOPrFvMqxT1/2wKXTMLa07lKVSv
	1PKINXg0dyOJGtgnSzliqKVU8JyeTxS+qDik5XYWhMYqbkGI5shDaEZYljzySuXgJYTGkKPsQQg
	y/kNnP8wJkkZHJAS9QRJFpbf19K1haimT0LhVOyA5Klc/2EJG3uZ1l30YpzGnbuxRUnFmpRMJgJ
	1FQYiVtyYIxCynnFEKQbUfzKOt+zrmYLBCHJLWQZ1j62VIVtBnNfA4YxfrKawoNXOyYcxc1ioQc
	z9hHHzBd88b5dmp0p8VW+6V2bF9boTqP8zTchS7o7g3WrPYAaDsP+Qa54YfczzRasL0sqVjuGMl
	aA86NaK8CPginAENNXxWn
X-Google-Smtp-Source: AGHT+IHu8OzU2UsytBp5/yY37eO2UZ14MoH8HE3a/AeEucjj4iFUT5vX0fIqAM5Q3dMu0UjZdyS4yw==
X-Received: by 2002:a05:6214:301c:b0:6ed:cea:f63c with SMTP id 6a1803df08f44-6f54c37347cmr1080196d6.6.1746638587212;
        Wed, 07 May 2025 10:23:07 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-6f54264e206sm16721906d6.34.2025.05.07.10.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 10:23:06 -0700 (PDT)
Date: Wed, 07 May 2025 13:23:06 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jon Kohler <jon@nutanix.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, 
 =?UTF-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, 
 Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Message-ID: <681b96fa747b0_1f6aad29448@willemb.c.googlers.com.notmuch>
In-Reply-To: <20250507160206.3267692-1-jon@nutanix.com>
References: <20250507160206.3267692-1-jon@nutanix.com>
Subject: Re: [PATCH net-next] vhost/net: align variable names with XDP
 terminology
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Jon Kohler wrote:
> Refactor variable names in vhost_net_build_xdp to align with XDP
> terminology, enhancing code clarity and consistency. Additionally,
> reorder variables to follow a reverse Christmas tree structure,
> improving code organization and readability.
> 
> This change introduces no functional modifications.
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>

We generally don't do pure refactoring patches.

They add churn to code history for little gain (and some
overhead and risk).


