Return-Path: <kvm+bounces-2793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5256C7FE0E1
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 21:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DE39B21008
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 20:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19A860ECB;
	Wed, 29 Nov 2023 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZMkuqEdh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC820D68
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 12:18:40 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-3b837d974ecso102510b6e.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 12:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1701289120; x=1701893920; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Lp53QluNv4WhhdcXZkD4YoVlGdIpJB4VhJ1Lx/HjyA=;
        b=ZMkuqEdhdBnajAZ80cMj30hgdtfUvcBCH1ra697mDkBeNucu9ddv5IlVJXy+/mvSGL
         R/2fOzZ01p6R4hQYKOl0jIMO7zuqzTxfFpenYSfNQDCCdF1+IZ4x84KYuEqbFxXw98el
         5qLL3q9ay6XFigl3nUMbkYJ9yHJpHlyfuVP9lwKLJZVxaIoxqOTPG3K20fWKI5rPDuLm
         bu3klCuqm7OqRNCHi/Ye+qfq1euaklh5PhCezvbApRVsGZd3EvNw0vyxwpEIXPteiir9
         5VXcwScTMDMEso+kbUIuJT6n6bUZpjKkRr6nBqpLvN/AeNb46OX34Lt2mGDpE29kE504
         nvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701289120; x=1701893920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Lp53QluNv4WhhdcXZkD4YoVlGdIpJB4VhJ1Lx/HjyA=;
        b=PUx+BMmU3v9zv478t9bMvyzD6t2qfqP0AgDqKgga8QM82JrfSUtlOhrjIgCXLCbgbT
         EU3ps+kSOK5t8JweVLuoXga26H9FkDoOCQJ9+slWVxT1B6H25WnFgf2bAd+m32d4Q62w
         bp7AyBXmyopzzzr03t6At+USR/c0f6H2oyqrMj61f8zkd/HHcIKTXa4UYNcou8UOi4J6
         KcXG6d17/3dRTayL05Akt6hLkTGID0c9sVo8SpkNcQKv0uv8gHta5i+pZE03fhTanHrn
         25PkXCHAgCfMgC/BJPAW5/IrsaPdeZqQEViCx74pBQzP7awdIsGyZNH85ZUEF6qw6q+1
         whiw==
X-Gm-Message-State: AOJu0YzysDdfandqCR+4Pg4A051NxPdKMcL4NGh2HIMef55NHg5nqUZQ
	Hh4wSn/DT7XFX+vW/IdYt4ub6Q==
X-Google-Smtp-Source: AGHT+IERXfBnQQiRryRCqi6gVZlah11bhAemTbrIbuIkAC7r69cFrbq/dBpIPM2clwdqrYccLzDwHQ==
X-Received: by 2002:a05:6808:1645:b0:3b8:3e7c:f827 with SMTP id az5-20020a056808164500b003b83e7cf827mr22187927oib.14.1701289120221;
        Wed, 29 Nov 2023 12:18:40 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id m6-20020a0568080f0600b003b8459f2ec5sm2354758oiw.55.2023.11.29.12.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 12:18:39 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1r8R14-005pWb-UE;
	Wed, 29 Nov 2023 16:18:38 -0400
Date: Wed, 29 Nov 2023 16:18:38 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Brett Creeley <brett.creeley@amd.com>
Cc: yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	shannon.nelson@amd.com
Subject: Re: [PATCH v2 vfio 0/6] vfio/pds: Clean-ups and multi-region support
Message-ID: <20231129201838.GM1312390@ziepe.ca>
References: <20231117001207.2793-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117001207.2793-1-brett.creeley@amd.com>

On Thu, Nov 16, 2023 at 04:12:01PM -0800, Brett Creeley wrote:
> This series contains various clean-ups, improvements, and support
> for multiple dirty tracking regions. The majority of clean-up and
> improvements are in preparation for the last patch in the series,
> which adds support for multiple dirty tracking regions.

I did not look closely at every line but this looked Ok to me

Thanks,
Jason

