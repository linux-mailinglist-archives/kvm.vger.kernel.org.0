Return-Path: <kvm+bounces-3378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9D580391B
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F8681C20B6C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3282CCB0;
	Mon,  4 Dec 2023 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="GSUQDSm5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5FFC1
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 07:46:15 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-77dd4952308so388668485a.1
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 07:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701704775; x=1702309575; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8iquwFJQyk71rcAf7xkyhz3akCPnZ/KEnHmlA88vUE=;
        b=GSUQDSm5t8HvtbZvi02K5jNSrBWa7EXWLMTt88RQxn3nfqkKvWqrbMnDPMVh63TSIV
         eChCyvaTYtbgWCaww0/b65ZwY2QcKTK8FQEujdcigBPmRrAKS255b8bOQWrHsA4gAgv6
         8IvPY1jVhq+2DAkbwsZww2RVGkpP/DlkrZPXyWmliGI6Ttc3S+JzxTQGdPu8uCNh7VfL
         r9DWo6SBuvho2npytT0Ps0rLLeUKz+yTMEpHwVTeyC6skSaOa3r/1Hwc1wZh6kMJjisG
         MebYADY5xL32bwjHpUx88YBvBAVX5ZfM0xvDKZK0Hb6AK346EXBNRMKeCEBM19qenGQQ
         dwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701704775; x=1702309575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8iquwFJQyk71rcAf7xkyhz3akCPnZ/KEnHmlA88vUE=;
        b=Y/ZT/ENI73d+/WunNz3qkAyldWdj3IenoGg3Q3bADq/I95YhEXxn8VneES6NmKu4mJ
         PfhSrNleaLqsj6esZRrxA3n84cRO88442GXO89tVgQxZlC6F/uECWScf2JTkqsOTaA+v
         9Wj+xpz9xpMa72c8kMK/6fQ8EYIB+75AMp3K92lov22dQzaSzNXpmxqR0MdcmDXyA7hG
         Hr+vqH7Gg770lW9CCCJew3dUbJVuksa/+TbBJ8diYPTjKJX7cDaKJiREgQNxtGrKKqL7
         PBNB1Zh/GhoZh/E6pwVgASPcXfIgKo5A4t3eIZgXFtuKSLRxaMgbyyB92QWV1GfW9cue
         nNnA==
X-Gm-Message-State: AOJu0Yy5Gs4VdQHh48IFWJLHqmxd2lFvs7XsyJ6f6WxRm456sp29RcrN
	/zxB/peAqxCgZ4OdbSLD5nz3ew==
X-Google-Smtp-Source: AGHT+IHZ/YjqhcwYOYNjJPJwfMXPr4ZvabEUYITVmxFGu7AYOahIpSZeLYjDRbOsJKMlo5t+5tEaqw==
X-Received: by 2002:ae9:f808:0:b0:77b:d6fe:8412 with SMTP id x8-20020ae9f808000000b0077bd6fe8412mr5286240qkh.38.1701704774948;
        Mon, 04 Dec 2023 07:46:14 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id d23-20020a05620a159700b0077d749de2a3sm4355611qkk.67.2023.12.04.07.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 07:46:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rAB9C-00B400-1E;
	Mon, 04 Dec 2023 11:46:14 -0400
Date: Mon, 4 Dec 2023 11:46:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: account iommu allocations
Message-ID: <20231204154614.GO1489931@ziepe.ca>
References: <20231130200900.2320829-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130200900.2320829-1-pasha.tatashin@soleen.com>

On Thu, Nov 30, 2023 at 08:09:00PM +0000, Pasha Tatashin wrote:
> iommu allocations should be accounted in order to allow admins to
> monitor and limit the amount of iommu memory.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> This patch is spinned of from the series:
>
>https://lore.kernel.org/all/20231128204938.1453583-1-pasha.tatashin@soleen.com

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

