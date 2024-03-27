Return-Path: <kvm+bounces-12873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD9A88E7E7
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 160E32E6691
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:07:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590CE1494A1;
	Wed, 27 Mar 2024 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="jDpAnQKV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7FC13118D
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711549666; cv=none; b=d5xUG8A0DRFbycy28pZ8TdzcfAU/RJCtviYleWbtnqOwZzis7zDjq461ywXN9f/FZT39PyqZ47CZgcVe7wD4haFovm2eywKLTLPZ6/eC/6qr29iCd0fFlbXMRNTWsgBk3k4ob9UyYnLfk1A+2aac5dVliwnufL4UMXMPdO0A9/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711549666; c=relaxed/simple;
	bh=+hgLF5y9KatuehOfxSRrfbQH6AQg63HYNQlEzuhw/ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccr5UDm4JlUmHqxeWz4IZpJFKvXQY4VfsVS6KlW+ybkKGo9W6IZrXy/FjOQsQzsNXIQOgzvCYeIYgJZ7N4nRnTb4PY1OYzhryJKS51LpLM9ZbDaXAPpm07bcrmFq0ZfTGB/ig5B//IN8Pvm0/p3EMgdzc9WfjgHk6HUyJlH5oxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=jDpAnQKV; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5157af37806so8039297e87.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 07:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711549663; x=1712154463; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6s9TY9/Cn4vJqrwwNmvG7/hGbs5cbUMGy83r/DdqAYU=;
        b=jDpAnQKVU0cQSc9PnFbZ0inZc/ySFgPbHicMsoKupJNAs9hLBzo42yodPq84aZ2qV9
         eU+/5QKZ2a93cGUvIuQS7FZr0zmfbgusLuhCdcmm2Wy42OuatReyJWRnqLzBfz97FcTj
         y0yyQlyC1d8YFATT8QLNvos0O9BSaQmyYxaiM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711549663; x=1712154463;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6s9TY9/Cn4vJqrwwNmvG7/hGbs5cbUMGy83r/DdqAYU=;
        b=PmMD4gCyQknlw0hxOIwUvkMtUWP3Nk7R5WqTS9/D8BHuDrZZrwd+/GdQr/79AlziIx
         cOWHAQmDN2Der4NHkxlyfRxrVJlPwliD+FQdBHxb7vAqDEJS/G5WjMl2Mior3ULOx1MA
         9qI32Sez6cXMNnwBi4cxPxygDa5sK4IXMs2yhFBClmAcUvuFCjW+aTak+cRapf3+iN+z
         92DtuhHjTChtX1VLZLy6XhHjl7ccx485vWmscksqGUvFSCIQIB/O3LKPr/EtrUb3qne5
         C1PvZWdFCWWRiutwG1Vqcc1jHAdnN8CY14SF/rCLiNmfrNZ8ZZQ0jhhVpoULGwCmsyVf
         ChxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRyjGLualjA9IgKl0ERaz8ezKtrw2C180tuXIvBfJdA5serJaE0umqoe/DgFcbsffXhgdt8lJmzDzDFBBb4bzA0gjp
X-Gm-Message-State: AOJu0YyTP5nvam/hvCaHkiM7mK7jMskqJY3wxxEPW8xE3jwI4ietkcrl
	HnsvesROGuy+p14FYaHG1zvWjofXYYxTtlNQ1MAoAgC6MkfwwBwyYnt/ivF9CcU=
X-Google-Smtp-Source: AGHT+IGfOGc5SfDKXbq/6cWQXWrbWdawL9QipNh4y7lGdJ/Uq0Y4kUnfad0T2fo+7kdSA94cBcA4PA==
X-Received: by 2002:a05:6512:6c3:b0:515:ba94:8929 with SMTP id u3-20020a05651206c300b00515ba948929mr4374913lff.32.1711549662886;
        Wed, 27 Mar 2024 07:27:42 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id jw24-20020a170906e95800b00a49856ae93asm3739062ejb.198.2024.03.27.07.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 07:27:42 -0700 (PDT)
Date: Wed, 27 Mar 2024 14:27:41 +0000
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
Subject: Re: [PATCH-for-9.0 v2 12/19] hw/xen: Merge 'hw/xen/arch_hvm.h' in
 'hw/xen/xen-hvm-common.h'
Message-ID: <8829dd17-308b-45fe-8d48-a980470316e8@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-13-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-13-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:08PM +0100, Philippe Mathieu-Daudé wrote:
> We don't need a target-specific header for common target-specific
> prototypes. Declare xen_arch_handle_ioreq() and xen_arch_set_memory()
> in "hw/xen/xen-hvm-common.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

Acked-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

-- 
Anthony PERARD

