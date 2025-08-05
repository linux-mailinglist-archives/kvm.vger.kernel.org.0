Return-Path: <kvm+bounces-54031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F5FB1BA75
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E6EE1852CA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 18:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5D629A309;
	Tue,  5 Aug 2025 18:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="HLTWrBPT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BACD15ECCC
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754419833; cv=none; b=ncwOpEqF922X18YzQ9rwu3Kd3Iq7mm+gE+Db7Ld9PRDHMQMR70z7bGRX8HbqtmaziH/PT0SF3Sl+qPxhCKE4vKYfpSXiU+4PjXApyy1odjpTMzVgehUKvy2E/b1PjsG7nJjFQ+oM6JHgP6Lcpl+y8O0dwKbPWEuunOcdsNJasFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754419833; c=relaxed/simple;
	bh=8xkDV6nvnKqz18p09kt9DxrJcp/rPbb8TI9XaRedVeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EoNX+nSPv8OreCaAIeURYe375ByIUdks08ikdJAfC0iV4KceoP7gIynsAd+WMZ6G7/+2TI6nCv9dZeH+AyYMb+xg0ENRO/AKBdoSV70qw7uT86LyUA7y8hbXVxeoMwPd/qg5Ba11Iv6ZLap7QWgTsHSlrIXIDEFj6Sikm0V0c2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=HLTWrBPT; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-70748a0e13dso48524986d6.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754419830; x=1755024630; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eD7sc5m85sAgud3ELjuBp1QiFMlOUf8D825OUZwSi7o=;
        b=HLTWrBPT07y2A4D4ZuKPbq2DyhUVgGYXLMMu2c2/E0FvhG6QqZWvCDkvbihBtzcBVp
         PrTXq0j3fN3225CWzL+YmPtcw6M7a+IJytC66iVLI6yC1PI6AamIgDgbVLebnJw1oehY
         LvLe+uSdrEEjzIjTIKn6kepXFgxes0CfFiZuxhvFydDDzKY+bpWvtUvM2Edd990MXJcJ
         VhAl7KzX0xfJ94iPd/I0080HiTVTOslMDE/gKj0E2Gn3qyyjxYTR+GPyeVgApj00diJp
         XXCMGZXEImHQvK3j7ENEilRWFDnIMl77n1URh/LAvZvWkv4DdKBZpHob15AsmaJNWieb
         pIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754419830; x=1755024630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eD7sc5m85sAgud3ELjuBp1QiFMlOUf8D825OUZwSi7o=;
        b=pgDqfde9kUJMQrss/zSmdk1FGr+PoWAxDnJU742Siw0SfziFeY7h8MBVbtJ3F0tzRQ
         2wsfCIw/YwRjng4Tkeq91FA1OrCFkGEqyc+ZkkCVn2xVMw0ddTwTAAYQghnmSjRfRQWP
         Gg+T8lRy84MZhiWEr/xeyrvbUXrjHRifaOTV+49CgF3WtSL5L80RtqgFfCAZSenkoktP
         dJxptZgd4mKFcvVYkuYnqVPyvREKqHYqYiwxLM9sPIJIhmFY4MVoUG1GGLMGZJXtl3CG
         xzechNL5aYdEAN23KoOHo0lqkivLtheWIykJVeQbNdMfXBnbumb+3Kp3GSA76+ak7qN+
         LUvg==
X-Forwarded-Encrypted: i=1; AJvYcCWQpnFgVhEdbgfK8uLPKavVTgoNWqqCcQd0KGpfMPs03bts3JOo3WmCg+8AdN9om98fZHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ4CLHbu6Ebe7GVAwoV+jWaSasGkVeK7DGomeOhfgjBwZ3oWbK
	h6wx+JMwVPLHJxQN4EmA897lmw++aOgHYB493vWjhyB++3aS8Mten+MZHU1TbyYE/Rs=
X-Gm-Gg: ASbGncuPzrulRAzJPlXhzGeutGuAz6XQqvLAwQWS5ddB86iN1Xi5ZDY7nDAK0PT2vj5
	0PMGFEYVEA+PqLswzZKhY5103sYgmYolji0/aUhvfDOuhY/4atmNCPqaUvZd3nSgBcwUtxAHf86
	B3nAqrTgpOLeALwt9LLt4er4TkPoWXNwnL+HKhoKKiPr4Q5uUjfc3Tw5hYtHHTQQzm20XK1UUEl
	ihV++J1GV+BCN3nQTmBr1/eo+fsg5uRuBYDO3vv/UeyhbbOv+K/wWqUrSKt5S9rnrJaMW2YZ47+
	SnwN1tPeuQ+qGRS+cJXm7NT1S04B6qPUQFtgugemF6u/O7n4ZscQG1an8IMezQlEyblDFHnNvCg
	EYYToA6eLVmuM+N7C+AxH20YOiFn3w8L4fOutoefGsJJoa8lgBrbnbLBxuNa1rinQykETt0T1PP
	2gGrs=
X-Google-Smtp-Source: AGHT+IFUz73JPsmsVXj/PpVdm/pNnW+RRt9Ocg1rj6Ljg9HuNIaRmC2JoU2bp095ebmrLtP+Au7+0A==
X-Received: by 2002:ad4:574e:0:b0:707:60ca:7ee1 with SMTP id 6a1803df08f44-709795fc89dmr5653446d6.25.1754419830513;
        Tue, 05 Aug 2025 11:50:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9d8b32sm73198986d6.10.2025.08.05.11.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 11:50:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujMk1-00000001aFb-1rQM;
	Tue, 05 Aug 2025 15:50:29 -0300
Date: Tue, 5 Aug 2025 15:50:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	benh@kernel.crashing.org, David Woodhouse <dwmw@amazon.co.uk>,
	pravkmr@amazon.de, nagy@khwaternagy.com
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250805185029.GA26511@ziepe.ca>
References: <20250804104012.87915-1-mngyadam@amazon.de>
 <20250804124909.67462343.alex.williamson@redhat.com>
 <lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
 <20250805143134.GP26511@ziepe.ca>
 <lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>

On Tue, Aug 05, 2025 at 05:48:05PM +0200, Mahmoud Nagy Adam wrote:
> 
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > map2 should not exist, once you introduced a vfio_mmap_ops for free
> > then the mmap op should be placed into that structure.
> 
> Does this mean dropping mmap op completely from vfio ops?

Yes, I would aim to that. Once you add the new ops it is much cleaner
to have per-vfio_mmaps functions.

> but I think also prior of migrating to use packed offsets, we would need
> to fix the previous offset calculations, which means read & write ops
> also need to access the vmmap object to convert the offset.

I imagine you'd do a conversion where the first step is reorganizing
the function calls to add a new get_region_info op, while retaining
the existing driver assignment of the offsets.

Then you'd add the maple tree and continue to use the driver
offsets. Record the fixed pgoff ranges in the maple tree.

Then I think you'd need to teach read/write to do mt lookups and call
out to vfio_mmap_ops read/write functions as well.

Now nothing should be relying on the hardwired offsets

Finally you could drop the fixed driver assigned offsets and be fully
dynamic.

> Another question is: since VFIO_DEVICE_GET_REGION_INFO will use mt and
> technically will create and return different cookie offset everytime
> it's called for the same region, 

It should not do this. The new infrastructure for a get_region_info op
should also take care of de-duplicating the cookies.

Jason

