Return-Path: <kvm+bounces-12868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB32088E70A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC3721C2E9AF
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3A915884B;
	Wed, 27 Mar 2024 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="kWAOXb8P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A313212FF93
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711546656; cv=none; b=LShWn/NMKSO81sGaAc+zBLN2aZR4Kj0eyVpDE8Az6rct/U1bg4M4VgBxqmcwUBefUFKVYVpokRLrYqL5FmlvGNUJpNpwL8qt4oozSnaw2C1PcEPhKNnMuBZMnFWNGbU5E/jAt2OP8gOL3qGrGmfW0rf3c971sthWvr7VfjGHka4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711546656; c=relaxed/simple;
	bh=paoSEf4ZM5IsUSOLesj1TKibOzOe4X8nq0RS77nHBuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBCBltf4WRQfncj69r+D+D1yNfMm9iA4im8Pu8uNAllyx8yKRqXqQ90VFAOVUz5W0xhQzh5idk8oCTSy5hHm/g9gRYiMyxodQUX7I4SxWLjSVuKCX7rrdk/s9cfR3YvE0rQ+xvWFMtpGJsaoM0LjdRIJp0gO83ryUBZw6+cXdAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=kWAOXb8P; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-414946b418dso4336795e9.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 06:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711546653; x=1712151453; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=smTZluOGn/fUn3D+QqeEnI8LdPKMkXjE5Ourcjod5Ew=;
        b=kWAOXb8PMmnC5tF4zrZRGKvsKAFGLB0wX0yP5ZIYQj1CyVixInkftrqEAu1ei48n+u
         QUCmLEJF2BnLEWWvhSp8G9a1MXgBCaRWh0URHmKFzuzaTlAV8BMcGfQXuk5AX9jgzI5b
         uf2u9QYirkHo6fiIH3zmKhE/ow8l2Ib67L0i8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711546653; x=1712151453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=smTZluOGn/fUn3D+QqeEnI8LdPKMkXjE5Ourcjod5Ew=;
        b=DSsBLQIuk4G02jFK8lPFgns0Z4cCZXMpdeZ+o8nlH4eGD69aZNkSUdKFJaFpmmNDH+
         9Y++iAoXL0hcqddgbtulMg/veCK2kAIroaOC5Wa3zFe/5T0kBC9PMCYYnsGp0f58Htn+
         RMB+dAMC71kNt6yEd4m4I+O6N8CXEi9K27K7Femalvgjs+Lf20cCgjOn6NldY6vhY7A+
         /GQvZs6ZHobWr46mbPR/se/9TBhhjVkDHbfJgSMuGnTaLz0XdkvnrxgnnxU41OAUW3Nd
         VMdyVaaXEwmUaWjbz1qdAhyG2ACGq46X5UqcMXzdoTGste3loWeE2lMhSB2xrP1dHiN3
         o4CQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCzojQTji5CIDhPUFh6w9UwqTi8D4wyevVCZ8gMfzSJOqiAmG+AZCR/D6L9e+NjTg0eYDIWXFuKpRiuLsCz08tDwWX
X-Gm-Message-State: AOJu0YxcWgD9zUWwBJiLddgwkUDHDsZgjHQCQWcvlVEClWECq9oYt2q8
	k8iZuRNE2e6hNqOnb0GoRxiYZ9ttQatAPfd7nQdTLhUUUVgfm0p78b29k0Wbu4o=
X-Google-Smtp-Source: AGHT+IHmCd6Z7pLRTa8judRkvI7RAqt4OfBOEutc0X/kcSqKXxmUpEJ5ND/lGGVRsxmC7KvW/3fTRQ==
X-Received: by 2002:a05:600c:1c8f:b0:414:669b:aa9 with SMTP id k15-20020a05600c1c8f00b00414669b0aa9mr9727wms.28.1711546653009;
        Wed, 27 Mar 2024 06:37:33 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id q18-20020a05600c46d200b0041488978873sm2166371wmo.44.2024.03.27.06.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 06:37:32 -0700 (PDT)
Date: Wed, 27 Mar 2024 13:37:31 +0000
From: Anthony PERARD <anthony.perard@cloud.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
	kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: Re: [PATCH-for-9.0 v2 11/19] hw/xen/xen_arch_hvm: Rename prototypes
 using 'xen_arch_' prefix
Message-ID: <3c553c67-c54c-4156-8d69-bef3476b63a2@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-12-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-12-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:07PM +0100, Philippe Mathieu-Daudé wrote:
> Use a common 'xen_arch_' prefix for architecture-specific functions.
> Rename xen_arch_set_memory() and xen_arch_handle_ioreq().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Acked-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

-- 
Anthony PERARD

