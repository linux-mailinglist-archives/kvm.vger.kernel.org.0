Return-Path: <kvm+bounces-24055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0ABA950BF0
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 20:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7107428137A
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B576D1CD0C;
	Tue, 13 Aug 2024 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="l3Re3Ult"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A937E
	for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723572271; cv=none; b=c7zeX9QhZktlLuvdb3bhuFZBOt5thjaYrqcnwZ1K1fOYLQdtuC7PKK5t58coGgi1mASVLbTBwGnoAyOMZXAWoP562rffYYXIrr3FN3cZWppPvTwAU/Y5tyjqJYHiWUncaaDO/zAZ7siaE8Bji6wXOnMUqwIJZh2IIa1J2zv9h+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723572271; c=relaxed/simple;
	bh=RACVbyvGM7WLuPWJKlp7JBe8m7dVqCgYWiQ46lKcAJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCgQcqQkbfOIqSi41UO/T4HsiY8tcC7UbW7bBp4uQWhpr3yNnlt7w5bh39JEs7wl/B2+RPEbHtf02mchIjWsszzCeZtqFdk7t8BiPsMEUETRDQH+ybgqm0b71OIfbU0zT1srlHh2Tyw1GAER8obHZdJ2NVJfsse68BcgSqv+GJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=l3Re3Ult; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-44fe58fcf29so30954491cf.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 11:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723572269; x=1724177069; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kksfCQr3LGz7n0tNg0gURosRXQTwdj7CDeuCdFyRLPk=;
        b=l3Re3UltZh+eqrj18lnkhb0IAY09drzCo3E1+u2OxpHYrK1hyHFZv2LO8HRwhUw87+
         uebqPmhUIv4Qyb0xWMA7IR6e9edYz8p9lt9IR465XAfbUo9iclMapX2cyaREBQwGNjG6
         6rFVcO135n6yTjvyZNfOH0pIzODxznYsHeu1aYgtZqZEWSDvZxvpbjWrtlQrPcINCUuB
         6xxr7Mv/a0IDAd8dnETHTtDfClI/3u6eBwD9csM3Q54ryG+RMygCkvWpM9ncFNl+bRSR
         vMNTk/RvsGgDrSuso/CIDlId1Bwz9MzODIiTZSvsaccwYbrxi+WaAS/Bszjg2UKrUpa/
         WdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723572269; x=1724177069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kksfCQr3LGz7n0tNg0gURosRXQTwdj7CDeuCdFyRLPk=;
        b=NsLLuPhEmj+c1YzQ1LrZPrcEw3iElsmMRhYoQoRo7GJEM9J6vV37aey0w6iYvd4Hdq
         wPP8W60bENx6ggxcprzlyQ158si8nWq7fooRll1KttjdPq7wHDqSNqBPGdUEoT+4HFWq
         gvfyDQPSjjFqQOJhQ/0F05hsc2T1t8JlkJu8tqEURL3txTZ1DiklhRidnO6ZK85RNtY6
         ZfgEWsxgOggmA9cf/7gRzVYXUBzHl+w3O1gkj2kNBIpIakW0kKvIBOyzkIyTl4sY27hM
         +zDbAYdHcrMhIgoQUKeeV1RLDl4XVAXUlvkg/Uo7JglO4dA0/Ft+argfwqdeY+cC3mNX
         RFgA==
X-Forwarded-Encrypted: i=1; AJvYcCUJFX81D97XdDImOT7TuCGR64h6sYkTx+xf4Zr7Hl/0EgfU5CesSiZLM3LSge7MZcWl+ZGydW2vfloX2gJVpt4W0tzf
X-Gm-Message-State: AOJu0YxZFYCJJi69KlEaJcgtWgXY+V6HPLD+40uFIZzhFauHwPts5EZi
	8YvBZu2R6SZ0kh4EfKwmrVwz/kPEeXvzELirVk2pKyPDVQ3qEkqWO7ml4YjlpzA=
X-Google-Smtp-Source: AGHT+IEnopw47eT7OR9xJ5nV3UWOo0qYdrGoI4Q6s2O1Cr+NS8uUxmLKIxJpWKsYqKSAmKbIm8yt7A==
X-Received: by 2002:a05:622a:1b94:b0:446:34cd:9e21 with SMTP id d75a77b69052e-4535ba91216mr1364481cf.18.1723572269085;
        Tue, 13 Aug 2024 11:04:29 -0700 (PDT)
Received: from ziepe.ca ([128.77.69.90])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4531c1abc02sm34169521cf.17.2024.08.13.11.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2024 11:04:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sdvsh-008rWG-Ou;
	Tue, 13 Aug 2024 15:04:27 -0300
Date: Tue, 13 Aug 2024 15:04:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zhang Zekun <zhangzekun11@huawei.com>
Cc: kwankhede@nvidia.com, alex.williamson@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: mdev: Remove unused function declarations
Message-ID: <20240813180427.GQ1985367@ziepe.ca>
References: <20240812120823.10968-1-zhangzekun11@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240812120823.10968-1-zhangzekun11@huawei.com>

On Mon, Aug 12, 2024 at 08:08:23PM +0800, Zhang Zekun wrote:
> The definition of mdev_bus_register() and mdev_bus_unregister() have been
> removed since commit 6c7f98b334a3 ("vfio/mdev: Remove vfio_mdev.c"). So,
> let's remove the unused declarations.
> 
> Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
> ---
>  drivers/vfio/mdev/mdev_private.h | 3 ---
>  1 file changed, 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

