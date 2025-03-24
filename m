Return-Path: <kvm+bounces-41810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A65AA6DF00
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 16:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA9B97A348F
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 15:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1804261570;
	Mon, 24 Mar 2025 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x28Vd55p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648FE3D561
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742831450; cv=none; b=WdmXK2KXQz3k77k3Dn9IPhX/8TLgec3NDeGy+UiU5ymp/1ZN6CQXtHtLuocdgfwN8oVdMjdGb55gogu3Mk8Wj8wspCWkNkh5XNzECzkEjGxQwo7PU7DCzgHtLIc2RwMHT+DLFN17sX7+hcMbBieIHSlQqFW4FNysxw7QbQVtUkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742831450; c=relaxed/simple;
	bh=G73BqoZTSqdB/GPULe2VlsnAncHW1WKkv8acByNLDMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyHn+UpEUcn3VZ8GPp9Kpbe5EwzWgDks7hdopFze85Eajxb7u4AZAdGF+3tGThmBtG8K22l0B3JULTNtVuJvdWKW5qNWMXwPD3f1cPIcuTIhvHgs2Ra8B5TQ834Sw24QESmiq0FcxOolx770G0sCWrGYplSGzwFEZdvuFfXFMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x28Vd55p; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39130ee05b0so4310099f8f.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 08:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742831447; x=1743436247; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qXRhGeDkSWGWmmVuNBstp6OZum7jWU1CmWmtDqvRvak=;
        b=x28Vd55p5hYXJse24F0oG1mc/h+4ZrLjBi5YIs6Viznb6lKj/gfkwwUr1qJfgAIdb8
         YkOYjMiqGt7UdbJWgeVRWrF4iIddNDf37X67JI2TfJtSgG6/v6gVa8ohfZbu+dmGELe2
         dlguOFN9yDX7cu0nFS1rY4hpzSVGz7AL6uSb25tZ6TP30HYs/IezDS1T81i9k49d5FLl
         AOgeV/JGEQOey2cUJO9stlZzdYYtlR45+chfyS1Q+fh97Kz3Zr0hYBZr6tbUfev/d6g8
         y5qD6B29C7j0mvwY7lCEb5TXpDdKAJYEwLXTfWp8hTulmDWkuXgao+V/QKfV3CAFVBQA
         VmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742831447; x=1743436247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXRhGeDkSWGWmmVuNBstp6OZum7jWU1CmWmtDqvRvak=;
        b=PW53oNAcW9V2vg8Y36GU0Og3ejic6hbtawWWt2M5KHWohUBr/urdwvhCiUk3PyNEaP
         AVZ+xYRyCnA/wQ+gdZut8NG+kCH70D+v1M1MKfU1lhnS/3ePn1PCU0YA68tZC7L4FPY3
         BYy0JXZszMFk4/bNEM3MxObxtCia8LPNjnVMebyEl0G77gyQjllG8nR13FIZE70diz7i
         FQa7/ZdlWllYJNKAd9I39LHGLs6c+Q4ZfK+Q262EPhYY20S9rCYnRZ6SjayKqbI9bcpM
         hWft66fLe7cROD+sehjDEOMs0JceGXb+lVc1Hneo0h7s8hjujsTkMQymvH7HnKd9tJ1U
         vvRw==
X-Forwarded-Encrypted: i=1; AJvYcCUr35C453GZiNkoL2bkPvnERcginssCZrC1y6tWdA01IR+lYD/UiEVyCx9h9yshclpgazs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/GMcRnnsW9c+qOIZCF2bkd1w3Jthno1W6Dl8wjstQVRW/BvVU
	VgANWc/8oHEfeIp467V1/YPI/w8sice2DqNMX5atTS4/GeWOkHeARC5RsCq013k=
X-Gm-Gg: ASbGncshcRC0kEbwkOsuGk1RVpu+IdZ7t8fs+I+DFbVIcESA4CIKLAZANSlEfp05tve
	/lBhECzJwVoS+iRULOfdZ5DpDQ2DvnzPejUXz7TPbGQddYO8BHjryJeZeg+JIWv+NawNMYObKwJ
	FDl3QvHmRzG3AYttXruAFwPjaJtirST2XTOkKLo1chKrurc/geZGreXodpOifv22JxNSEOBp1RU
	pMwP3MdG1pRq5Yks66Y5+hA5RrWD/0i382IN5SZDN/houlKDBgS9iPoG/TuEVUALq2DORQWt0ws
	kvk9L2C6RHhcorI9aQuy56HPqCQL+QGFdSOHHNTAhMk=
X-Google-Smtp-Source: AGHT+IEZjj1zr6KjWFTQYscKYFXgO6ZuF3B36U9IG1e4c1569+owWLaEi5bGV7PTpDSJmekOGmMX4w==
X-Received: by 2002:a05:6000:1a8d:b0:38f:2a32:abbb with SMTP id ffacd0b85a97d-3997f8f9d54mr10259058f8f.4.1742831446672;
        Mon, 24 Mar 2025 08:50:46 -0700 (PDT)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a3f36sm11533049f8f.32.2025.03.24.08.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 08:50:46 -0700 (PDT)
Date: Mon, 24 Mar 2025 15:50:45 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 5/5] arm64: Use -cpu max as the default
 for TCG
Message-ID: <20250324155045.GB1844993@myrica>
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-7-jean-philippe@linaro.org>
 <20250322-c669034d2100a75ab6e53882@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250322-c669034d2100a75ab6e53882@orel>

On Sat, Mar 22, 2025 at 12:27:56PM +0100, Andrew Jones wrote:
> On Fri, Mar 14, 2025 at 03:49:05PM +0000, Jean-Philippe Brucker wrote:
> > In order to test all the latest features, default to "max" as the QEMU
> > CPU type on arm64.
> > 
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > ---
> >  arm/run | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arm/run b/arm/run
> > index 561bafab..84232e28 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -45,7 +45,7 @@ if [ -z "$qemu_cpu" ]; then
> >  			qemu_cpu+=",aarch64=off"
> >  		fi
> >  	elif [ "$ARCH" = "arm64" ]; then
> > -		qemu_cpu="cortex-a57"
> > +		qemu_cpu="max"
> >  	else
> >  		qemu_cpu="cortex-a15"
> 
> arm should also be able to default to 'max', right?

Yes I'll change this.

I didn't earlier because it failed when I tried it, but it looks like I
had QEMU=.../qemu-system-aarch64 in my environment variables, overriding
the default qemu-system-arm (32-bit only). "qemu-system-aarch64 -cpu max"
doesn't boot 32-bit code, but "qemu-system-aarch64 -cpu cortex-a15" does.
Anyway, without explicitly setting the wrong QEMU, "-cpu max" works for
32-bit.

Thanks,
Jean

