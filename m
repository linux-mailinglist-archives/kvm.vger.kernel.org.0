Return-Path: <kvm+bounces-12803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E0D88DCDF
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8ED2DB2548B
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96EE12C7E2;
	Wed, 27 Mar 2024 11:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="lB/2GNDf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD2D12B15F
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 11:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540226; cv=none; b=IvDXUxYSZYTRwdw/j0w6N23+dsew8WI+bc822IsKcMhsfxfLvKGVgZ9UQUeiMpeWBO3tnY8heLcVxMtlon6y4SGtORUMVTLhLKxlA28X+EYIPx2MeQtXA+QC/np/ZhA+GGsKMma18sAE1xpQ6YUWpjmDC2ZcnNnacTdjf1Oj9bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540226; c=relaxed/simple;
	bh=I6XcDgr1EShu8zJctZvYMkKHpS4Yx6165q2gwZkVqxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DV7k0HDAznATI0+exTUYzj/jposPmjT/CJ21T11ZyhsXY6N1q98m/DjZ+ruJTxBg3e2DrNLdZCGKjkUW4BRcjCYdfyD/qB7cz1maYZc8sUsfTiTcPgnkI85YKeLdFYI03eWaeK4oT0PtJ4MgQPPK8UaN4Z2mJzbC00X1rV2N7jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=lB/2GNDf; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a46d0a8399aso133131966b.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 04:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711540223; x=1712145023; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4FC6f2CiQL5W1YZBJ6SK7a0UwL0NwwFJDhTY6Z9yEh8=;
        b=lB/2GNDfvtR7eAF50dP1r9QoC45Ui3fFj0EM1eNCbhsBVwSOdNkIoyuU5M0Bysw0wH
         uC2kIkuAQCFnpRhQ4V/QZAZHCCNj8LDkhpz+mDFiru1j9p3PU20U9UuD+1PNf05igvp+
         Y0lxri9fC9hQ88BJy//F+gsl1vn4H/z9fO2AU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711540223; x=1712145023;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FC6f2CiQL5W1YZBJ6SK7a0UwL0NwwFJDhTY6Z9yEh8=;
        b=dVQwcBDzyOlJqOWL8TZqGTWwDkulndc/2m9ovrXHx7nP78dL/aZ/+KwBsnONCom+Tj
         XRBCyKkIoNMYXE2cC2iuNnPPx2Vqb35hZ9HyrBkUsNALbLDkjuMtMbZdSi70FBo17tTA
         95LgVAS4/smLFT222ceekECK9FkZA4l/U81yB/o/zohqWn5uL8X5uLjV29iVFMM19ITX
         H5NNm1WOYSzJNjwTrfKF5UJuiCkMPpxk7heEZdykc5FhQQtvWuLhG7vVDS9afFLwjN1J
         Er+KZ7SeS0vpGbB4////S7lHPBJ6tOacKhinZhdu8pUA5fB7THzPYI60LQLwwJa4YgoH
         VGCw==
X-Forwarded-Encrypted: i=1; AJvYcCVSiAgCyLZ/woMzKOQ5Wm1jnEHVnaWdFxIiG+ii2tNWKcToljD178h2LmR+ZQV4B+t+T+9RqQ8TxgJ5axU8maSj/mzY
X-Gm-Message-State: AOJu0Yzv7eHLfGfdsYI4Zk3OPyHUfNgE0xcgD2jPG7Mef1wrNgW5lvei
	nGpug/R8pN7rwRKZC3+ni0pfX19b56TrhPEq2QmeGWQM1Zx8UArMGcrPjly5SQ8=
X-Google-Smtp-Source: AGHT+IHjrlueyINri3BcwMN7nzklq3D6QJVA6wmS9ETMB5MPCffXe1tqgCTZZJIf53/O2Hw5bsVZmw==
X-Received: by 2002:a17:906:a890:b0:a47:134d:2fc8 with SMTP id ha16-20020a170906a89000b00a47134d2fc8mr3629567ejb.10.1711540223416;
        Wed, 27 Mar 2024 04:50:23 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709063b8100b00a46fbff47a6sm5322360ejf.168.2024.03.27.04.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 04:50:22 -0700 (PDT)
Date: Wed, 27 Mar 2024 11:50:21 +0000
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
	Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH-for-9.0 v2 05/19] hw/display: Restrict
 xen_register_framebuffer() call to Xen
Message-ID: <7e08a2d5-7d90-4d48-85e5-4c7e39d59c11@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-6-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-6-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:01PM +0100, Philippe Mathieu-Daudé wrote:
> Only call xen_register_framebuffer() when Xen is enabled.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

I don't think this patch is very useful but it's fine, so:
Reviewed-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

-- 
Anthony PERARD

