Return-Path: <kvm+bounces-55922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D2DB389E5
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75DF51B655F6
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A57F2E54A9;
	Wed, 27 Aug 2025 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yzbc9/zz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BDF2DEA7D
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 18:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320914; cv=none; b=N9vbnmIciSXQlG/PTsDPQNV4rbH+gQDQxBtzmF9KtYaoY9h9fMEvVKBY8g5bxAk3IEL9kbSt40jym5V2OOuZM4Dy/tKF5+Dg/7eNxh1zOEURxIRImlhCCm9G/t3PCxuT8njcFFfnwfvBawZY+Dtfy6wTna6pbIlfq5UkNLRV6sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320914; c=relaxed/simple;
	bh=agtBMNUn3Gwl9m7m+4izGb2+GjZI8T1IegpTOKuGGoc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/8F9W+NqLWfKLoJzXPMRzLzxBcttznNSum5XF4yD8AJnKj2vP3qrW1eJaDWBvzl2gq4Hit1Zj7ddKQAqQi6f5/0PwP1RvRrzUJRWJBOkGYp6tw9cASCVxi3quHkr4mBEv7eT0Fw2yOb1uqPbUAiZ+MNrvGW7rxeBTfNY7KT9Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yzbc9/zz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756320911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8++aFhGainNDYwExZONwqjK/iJ18+hnmhdbGOzB7HmU=;
	b=Yzbc9/zzQ4oPZOq5P/gDHb6VbWQtd71LLKA/SrBYR2sZIz4P58l3tfv6eP4N9HxSxzE7+C
	UXe+gXd0bXudfR5WFSmIsZtJreSiHr3sxLKZUmMDMNXsROkbqbL73R8Dum9p38i45s86Y4
	QCFFR3Psamosn9EuIvszdIXLPPfkTfg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-G0H6StsNMDGY8geiMzRliA-1; Wed, 27 Aug 2025 14:55:10 -0400
X-MC-Unique: G0H6StsNMDGY8geiMzRliA-1
X-Mimecast-MFC-AGG-ID: G0H6StsNMDGY8geiMzRliA_1756320910
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ea4d2f503cso393905ab.1
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 11:55:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756320909; x=1756925709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8++aFhGainNDYwExZONwqjK/iJ18+hnmhdbGOzB7HmU=;
        b=hI8xx2AqLnhZryvFAIwZmtYdwgXGjm+tN3V6eEKIQN6r0n3yujppWQ39Y8TInTTllR
         zf7IjyCaWsXt/xGr3IltEOYzUXzAmahqpzQJsyonFuasQprDg4G+c5o0cR6h2Rde3PZO
         W98kQmMWzaI2Y/Pxjsc6PhRaSapzZrTMBfG/U3j/Svr95iwtfBD7eOzI+Llt91ZC1oic
         gmhhvPeR3qNLPO9wEQtAUlcvlekzm3dwLVqPEu6SskIBgxb+BuRjyeOkO92M++MctMl7
         Qc7ZV37mOeJ20+GlKBEx4lcjB/osqjBLNVLFLFYK1FDiXS6+sHxr0Dgv2txB5pEUk//x
         k2FA==
X-Gm-Message-State: AOJu0YyEeiclcQPiD9+/Mlp0ix3Fp3dNgzhEYRAcj6TheBLLxXsICqfC
	G9KwUvBBAtkLgCzD6qEBfPdlYW42q7h0cuPlCl82tP3avIeckkna2ArDaZnOYLjdXszpYtJUjEx
	pEYlFOCOpyh3xb8jVtKU94zeHMTI+bF7SClaGxlHxLtqApxRxSD5p6hZsUE7bmw==
X-Gm-Gg: ASbGncuoz6uqu7qIjGroLkrkDBxERO3/u4lfFIl0l1EIrvjD0yK9B+RI/tgTj4U9dv3
	zFG7Jl8EBmIpvmce8trEZV4/DmSFiiTs08hupepPewz24Sxc8zXLMSlG+pqfiVIMFVZlUiKAKmT
	eb/sK2enTI1qy4PdnUk3obuEJpjqOXSAlVvV4ggQAFxzDDKf4aIzcPjsNdjhCIB20g+VqmrLRWY
	gu3BxxCXbvIxcSyzkMv//GuY/kD5K9ypssBdBZ77kKlq66kLOBWJjnVQR0EKOY7mcPpCYHtFcD3
	uBlcIy1bwdhiNc9KEJEgGIHfI8Ubc3c/gLD3w/LiU+4=
X-Received: by 2002:a05:6602:6d89:b0:875:ba6c:f77f with SMTP id ca18e2360f4ac-886bd12f6e0mr1153119939f.2.1756320909009;
        Wed, 27 Aug 2025 11:55:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdDKGxdN7lZTrjF1t/hR5pLOxm848azGffRUtAGXsrM4Y7GHBpN6/GovIW0l1YT0aBTs9CgA==
X-Received: by 2002:a05:6602:6d89:b0:875:ba6c:f77f with SMTP id ca18e2360f4ac-886bd12f6e0mr1153118739f.2.1756320908616;
        Wed, 27 Aug 2025 11:55:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8fa63casm825799639f.17.2025.08.27.11.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:55:07 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:55:06 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: drop redundant conversion to bool
Message-ID: <20250827125506.5e41e8c5.alex.williamson@redhat.com>
In-Reply-To: <20250818085201.510206-1-zhao.xichao@vivo.com>
References: <20250818085201.510206-1-zhao.xichao@vivo.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Aug 2025 16:52:01 +0800
Xichao Zhao <zhao.xichao@vivo.com> wrote:

> The result of integer comparison already evaluates to bool. No need for
> explicit conversion.
> 
> No functional impact.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to vfio next branch for v6.18.  Thanks,

Alex


