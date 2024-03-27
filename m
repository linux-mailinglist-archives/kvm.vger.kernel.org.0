Return-Path: <kvm+bounces-12886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 918C488EC51
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:15:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCE2BB22D28
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AF314D439;
	Wed, 27 Mar 2024 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="Q8RCx+Bj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C94E12E1D4
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559640; cv=none; b=BwqoyApWTfqhZHkutbWkdHDAWfklFkBeVjn2/QyxIakJXGE2LHnu3VnpQbdI6JFTvd3o7VgJ3Fh/QgnrWyXbtFXVK+y+wEP5ERYI+YuC5Xf30e3TIJNA9Xsrf6D9o8l66wPWqeXRBdkTQVmbY94ZQu8I/PO3MINxechM36tnY4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559640; c=relaxed/simple;
	bh=5INNLRQXzuPyMpRSnbERCyPrXj8AG+R9HQxkAJbkUr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FMVxSsA0Irn1x6RCxrOk5py8X/LdaBDbiDz6XuCkiNJu1oZSwvYi8njLN5WOPH+O2hmBoAVG0dKTaEV4sAtQ9YODntih+QEPCirpjFOhPMEXAR7huCNWRLvUsQHBb5srqtAzQrOZ4e0Ty+TvIkN8XCDiQ/nJIHHA3LLRXGKdAUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=Q8RCx+Bj; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-414970d4185so177015e9.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 10:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711559637; x=1712164437; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vu7suNCUX1YMKGA4SET/IwU/8+fAPUob1HodKRWXOiw=;
        b=Q8RCx+Bj8gBR0vKDGnmNLdr+9w20w69IxjOZWwdoilDuRp2mnIuhhcDkG5pkAXB2iJ
         NI/8cXcit+2f/VxXSXCjn3FBTqWEkdjzInI3ykmROI3dbidqBpU527NtKPO6cpGDmHZ4
         xm2v4F4gyudgoP9XxiZMDcaaiBojVrLKIcPZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711559637; x=1712164437;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vu7suNCUX1YMKGA4SET/IwU/8+fAPUob1HodKRWXOiw=;
        b=bUP8sVQx5DXBYBYLTT/Mn0twZuZ5ogeQ7oTwHvPMHjYT+KZ2qU9TAC5f9EF24f+tQX
         gfA6iAobDq7ygpSir/tDDVTZPSmm0CJ26AbgGAyYJCTvqcSKayFajCuqESM1HPH4dEWs
         R5WBij/t34BZ5VvC0it89b1gHuXfHVoivkP478fxLUeZaxsXS5WpTzRcyVNPu2HjAjvW
         u+tG9vHPsLITmp0CbOU2tYVc3zZQMfsDgqz58CucpUdogi92Pc/j/jeAlq3XCcnLcpzD
         LDDK6fYbqGcQdT/VTBfgbPA6JNG2C1fIQ1TfR6AoSvyccRawPfNtxg1XHDzbrf7vBIn2
         V3Ig==
X-Forwarded-Encrypted: i=1; AJvYcCV6/reDS2p3uznz6XDs3CKOPBAJNCVcN/+91UlJQfw2iPvEW8JAR3b7rGSFHSxg8QpQKNeEpY3Z7LQeOpZWNJ6urdkA
X-Gm-Message-State: AOJu0Yz3Syb6ahu9K/MMWA6efg9MIh1P0UDljjSyblq8ML3rHKWSvFwX
	QOfqTvrSOt4orpTiUvkq3sZZYWGLroDvLseeZ+p3aLtYdGZyszx090BmFZyPcNc=
X-Google-Smtp-Source: AGHT+IHuzwyfCe0U7WV3L9+qNX5m7LH+o76ieKYIT56YXzVsC6yBJ1zoRlezauX/mZrHEMHFIXhO1A==
X-Received: by 2002:a05:6000:ac3:b0:33e:64f3:65a5 with SMTP id di3-20020a0560000ac300b0033e64f365a5mr433896wrb.52.1711559636869;
        Wed, 27 Mar 2024 10:13:56 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id w17-20020adfcd11000000b0033e786abf84sm15317168wrm.54.2024.03.27.10.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 10:13:56 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:13:55 +0000
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
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH-for-9.0 v2 15/19] hw/xen: Reduce inclusion of 'cpu.h' to
 target-specific sources
Message-ID: <5cac8283-2e26-44dd-b113-d8499a0ef618@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-16-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-16-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:11PM +0100, Philippe Mathieu-Daudé wrote:
> We rarely need to include "cpu.h" in headers. Including it
> 'taint' headers to be target-specific. Here only the i386/arm
> implementations requires "cpu.h", so include it there and
> remove from the "hw/xen/xen-hvm-common.h" *common* header.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>

Acked-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

-- 
Anthony PERARD

