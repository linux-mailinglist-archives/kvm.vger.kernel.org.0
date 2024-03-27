Return-Path: <kvm+bounces-12893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18FC788EC9B
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A9EE1C2F2DC
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AE314E2CC;
	Wed, 27 Mar 2024 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="l2dylyxA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B39A14C5A2
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560428; cv=none; b=J9WMQDZihHplAYp+UBL1r4GKNlnkou2lgyaYtP4Dn2tAWWUzt9BpzjvzBDe/uvcfwPa78tZ1TcnH/l4wMqAgAC+tnhBCLJF+dZ1MCAq4qmSuR89leKMtjRPeNsihgnw5OjNSR99Fy41kMHvolq9w6gr71Hn3aAUnMl5SQ6MijV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560428; c=relaxed/simple;
	bh=suC0aon1kO1lvMDpWuInYC5evdT1O6yjZOLLAzUj1LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gx/JPogbJYriUEcx89ROsAyKCO9b13KILdANeeEa1plxsAbKTeQt5o2XNwgV5Mw4ozUuc3cK0VoSEpIkcTgyE1PkkkfbcjgQEbHkXwE+yN7ZpifOjHF8gMGuBNgSXE7V4XaTLgGFXBTGpmIX6+d1dOUYSVyKdd7E2TDiw7L7grI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=l2dylyxA; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-33ececeb19eso4607599f8f.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 10:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711560425; x=1712165225; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LOeWq64vcMpyC+dfgqU4qcoJI/qjRuI1jSd1ZXO7Aa8=;
        b=l2dylyxA65PK9Z3lLHrq/lQC04cpXAcYmTg2rn9Lp9ouE9XXLLUoWBqywnWcnivtSE
         FE82ONie3wv7bZn3vIA1BntOQkz/VFrvNWUG8DOFhXA2Ujf65TeAr/otMpp82dukofiL
         WoFWVFsmc1/u+rkDvfyspwWcyu+w5Kpug51Xo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560425; x=1712165225;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LOeWq64vcMpyC+dfgqU4qcoJI/qjRuI1jSd1ZXO7Aa8=;
        b=D+GP/KCLsSd3mcQ+UKjZL2VNbGNb1mSdI54FG5Hi8w11qoO8o2AjHRkFPY8zH8zeEb
         2diIIAiHNC+mChCdJgRpjdMk1SQy+TdtTF2Wf4NnjT83FvGiVuTvMCLiqa/SoFKcw3R1
         9uoTDs2WjXK0lesjK4cY3Ba7j8BDxBQC70JIPvuGEKp82VAbtgMP8EsgObpmA94pszWC
         6TErcZ2HFHCRiZxIAdtC26+1IiypQWxjRbXUTnkIEj2k5uTKnkKUFdtOBKIo/4FsSaA1
         VHUjQe7AMzbJNR7rZkIoNNqdbihXUtXPlQgLr+zzs0W+NMx+N71Fh3j/S0OuKE7wzi6P
         lpxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIPXIIQSFPbuTM1H+tz5u2cxGhFD5P84TImGpUGQdjXvysGXQoGlTwLSVgBrE2KmQPoOxNXizU/4wu7hbVpm+P9u9f
X-Gm-Message-State: AOJu0YweU6/SM0cN+onjgbuxfosefJwL9eMiLPBhy1QtnTZLxPgio9+Y
	hOepvw7qxYh84xicrZjmwdiqmVGc/rUzWpmjYVvaEw64XLjBoKtVMSvN89sS5x0=
X-Google-Smtp-Source: AGHT+IHr9JM+c5QDCOdkTDoDNItACvq5s9onzO3m1fxTIw9ef9+p/5BHroxQSnJUYc67vBX8mZewQg==
X-Received: by 2002:adf:eccc:0:b0:341:d64e:4966 with SMTP id s12-20020adfeccc000000b00341d64e4966mr424121wro.61.1711560425465;
        Wed, 27 Mar 2024 10:27:05 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id fa7-20020a056000258700b00341c6b53358sm10953709wrb.66.2024.03.27.10.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 10:27:05 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:27:04 +0000
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
	kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH-for-9.0 v2 16/19] hw/xen/xen_pt: Add missing license
Message-ID: <71182998-214b-4e38-8420-79edb92ec09c@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-17-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-17-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:12PM +0100, Philippe Mathieu-Daudé wrote:
> Commit eaab4d60d3 ("Introduce Xen PCI Passthrough, qdevice")
> introduced both xen_pt.[ch], but only added the license to
> xen_pt.c. Use the same license for xen_pt.h.
> 
> Suggested-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Fine by me. Looks like there was a license header before:
https://xenbits.xen.org/gitweb/?p=qemu-xen-unstable.git;a=blob;f=hw/pass-through.h;h=0b5822414e24d199a064abccc4d378dcaf569bd6;hb=HEAD
I don't know why I didn't copied it over here.

Acked-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

-- 
Anthony PERARD

