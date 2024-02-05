Return-Path: <kvm+bounces-8035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2644B84A12D
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 594491C218B7
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 17:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D5E45949;
	Mon,  5 Feb 2024 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="jsMRoJ2z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE0947F52
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 17:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707155110; cv=none; b=ZmAPJgOGhP7vgrYzCzP7DJbT6NqPgpaybgKp5JQqdi64SYrRpca5WOGMH0ro3yOOphxC5aIcbKERi0j0qBm3x97Y8EuFxJzkKERHioTFzmC397DlPIqyNWs7mNPZYvB6ONWBEhxqm522HNKLbP6iAxvYPDzjAKBdPXfk4qKXtRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707155110; c=relaxed/simple;
	bh=Kr2vrWVlUyntHvMw7Si5zE2PHtWM0mT+einhFyctsMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shC0KE4KeCKzYxdgrloo36NZSPllljBSxnBuROtmlURmKnU07iviwBY0/g1aq5MQMYqG0bYzOm9Oy4HxLk4PVB/QShY8ps4NlaB0IYyKpECnKljqAatnPkcNzLn5cM+UJWOuJzn6ud1wbc4LVx6wEYmcXhcrK/bbbhVFp9hr+/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=jsMRoJ2z; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-68c813ba956so23320856d6.3
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 09:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1707155108; x=1707759908; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kr2vrWVlUyntHvMw7Si5zE2PHtWM0mT+einhFyctsMw=;
        b=jsMRoJ2zE4vu6qmvUlqL8POfKb3VpE+2XVEC27n8vACxFPeGElYxUmvZildNnYoOu/
         J0VXY7zabjx+mmzFpc5OzHviOd3oelQl0StOaqYOyTAx4Y2sjpR4O8NTbnPIRgU7cMFi
         m86nLowDbBv45N/VYMWjMosC/bx63oYAKOjY1MJSRQrfEgNb9eAaxmw0AIQEqs0XOvfV
         DEzIWfy8nlcLvSwffjoCHCXPxdpDQp8+bqrPkSw906iWVvfASo9KV8SlYE93YtDa0zw5
         tjZ/WKWsXa4ksUpLky7m7YNQl0BbjxoJEMuOv0SHDn8GDRT7R/TkZEnwO+295HTLauhT
         EbCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707155108; x=1707759908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kr2vrWVlUyntHvMw7Si5zE2PHtWM0mT+einhFyctsMw=;
        b=Dh/zwHBYh+TV/lSS+QOj/Qaf6TbtUfzFUcsU98i7Nd9F05igTnab2lf43MZLNdTmRp
         zyQ2kG/PPnM2IN95nte9xelMuA2ix4eFeGhlpU+uzX4z/588LWlW4W3N/4M4tLthO72C
         XXbNlcLFelcNLBfRRXM7C2kuyrRd6cqx91craZdRGO9Ku0+Qx3UHKPjKE4fPtrCW8G4P
         8fqk4h2tKVQeJWLEn/ze2l2nde0XafIeMVMzp1NeTlOgkrrGgi6b1kT6x/qRrwtdrxAa
         Z+8sTBeLMZfL3wX3G8ZiBfPbCYPEXqiOAMB8feAGEI7hjwcj3IXC55jijnFJzjwd9xnq
         vXOg==
X-Gm-Message-State: AOJu0YxByBNB55TpVrAuKL3G6eDCX7kvu9WOGj7r8F4I0Vre5yQWtNTQ
	WlMcoyINLjl4CNiXDvFY/UMfncPdN6OmkwNl87jZMdLcWPYqHpGPhy5aXdlWZkU=
X-Google-Smtp-Source: AGHT+IHYMw0vd64OVr0zEMte3BX2BoxkRkfAfpiJiAxhjtbWihbl0rcbbYsuxMOB9Sysr++MU/eDAQ==
X-Received: by 2002:a0c:e14b:0:b0:68c:850d:7e12 with SMTP id c11-20020a0ce14b000000b0068c850d7e12mr85628qvl.50.1707155107926;
        Mon, 05 Feb 2024 09:45:07 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWYPsWNFHv61exg+gMCQoag7gBZCOBqvyfZr1G9u+oPjqyrOwq3LYPfZ8DHnZ3lXGCW2H019rMJwKaxvLdC5XJN8bQPMtNx4sk0ynWnOH6QQ0slFrl5Ptdld6MfH+LsWOHXY6wGQ6IS12X4C5mk7za1Dt+B8lfZb10uQeB7pc/qZi7KKSgE4gi5/CGlXF+4KBrVRqMRlkZd5pnzVvhMFtp+/ID8YmfxZrrlM0m4QZoS0fYfjZl2v7d6XT0Gx8rUoXS0m9BTSzGFi8JG1cntWWEOJqGd7n7hHxxx4nUep3NwoA6HXavGEL5rXEZrdH+4UAd5sTZupOuxdbJV7A27rTBK67ACC96kircN6b9iBI1gGhtBpK9vNzQrHhudWql3BnS1EE1AS6aSX0WJ9rQHdrdmf3f9tnqcPEtENeciOx5OKeqVX5FAJReENYnTCNdQvPLNQer06oyzN3teSNcXQ48e1ehHBdIWISjJ7sB2lCzU73LG6HbNiR6oXT2JmXEqVaaiqtvL9iLUZ27KHPnSmSugFdYit9jQu51JSiHQgMtqIEKWj8uDuoLdyqhILWFR2ijsYJiEOHPgbH/hy+qkOlatgS3FAMrr+S/UgXx1wrJIAxxRZPk41WEdoxjJjHo8C0dZRbsUwVnhWcFMQZxRkFnSxxmnzmE6FnjNBZzNic9S6vFkSUtAKElK/+YSZSgxAevXVtsRW/5Env/IJqiTts//EICbFYy2RiY+TC0rAd9SM2NM
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id lx13-20020a0562145f0d00b006819bb31533sm176462qvb.99.2024.02.05.09.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 09:45:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rX31n-000fbS-19;
	Mon, 05 Feb 2024 13:45:07 -0400
Date: Mon, 5 Feb 2024 13:45:07 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Gowans <jgowans@amazon.com>
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
	kexec@lists.infradead.org, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Alexander Graf <graf@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	"Jan H . Schoenherr" <jschoenh@amazon.de>,
	Usama Arif <usama.arif@bytedance.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	madvenka@linux.microsoft.com, steven.sistare@oracle.com,
	yuleixzhang@tencent.com
Subject: Re: [RFC 11/18] dma-iommu: Always enable deferred attaches for
 liveupdate
Message-ID: <20240205174507.GD31743@ziepe.ca>
References: <20240205120203.60312-1-jgowans@amazon.com>
 <20240205120203.60312-12-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205120203.60312-12-jgowans@amazon.com>

On Mon, Feb 05, 2024 at 12:01:56PM +0000, James Gowans wrote:
> Seeing as translations are pre-enabled, all devices will be set for
> deferred attach. The deferred attached actually has to be done when
> doing DMA mapping for devices to work.

This shouldn't be part of your solution..

A DMA API using driver should never be attached to a device that is
being persisted across a kexec. If it does then the device should be
fully reset and re-attached to the normal DMA API iommu domain.

You should be striving to have an iommu_domain to represent the
special post-kexec translation regime.

Jason

