Return-Path: <kvm+bounces-52209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE96B026FC
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 00:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F4CB17F6D5
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF392236E1;
	Fri, 11 Jul 2025 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PCDlkVPp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8810C221FB4
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 22:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752273370; cv=none; b=tv/zLpbfBhEZEEGbKd/RC62ZcJB/M5hBZAgZC5qe4QnyYxLxV3i2sp8SAQ5o/g3gkg6ayknp1bek/wEd+NXWhsw2Q5mPZtCRRoCOSxz3actESiBevmIfF6WiAXPnNqTZPrGsl768bXR6QuBqTkOYRuWBOgCYgOVyEoh/XsBe5DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752273370; c=relaxed/simple;
	bh=VvTwpYTJ6MeGpD/+57OCgrd7w2qY7aibk0SWMCUOT70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxCIfa9ULLFRV9847MtQVR+aRnXRcqRSgszDsGRgppnXDrwPDUO4+qErjihrzZz7qMJqS3J/fxhTM9fJ+sAzAa7hdAxpDIKuq/n8FEZrpSoTPfc3X3+JHqpu0XlHponauiNt1xxjr8+IxFozWtge4jiBi59oGkwIAFV38WpdCdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PCDlkVPp; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6fd0a7d3949so36231536d6.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 15:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1752273367; x=1752878167; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R6jEezWUjvICh7/WW/Ivp+Swoo1QztjCMy3V/+iaOS4=;
        b=PCDlkVPpd/WtdaAq9vJw/9zRSf+kB2eUVHmV+FQcRhkARfqifVtn3CjCtRVHFaDBIT
         kmoummMcGb2T7T0oaH5G6QezXqX2+WR39voR8iRwcryIrM1SvyKiBCq7D98MPA9zFQIT
         XE22WMMBL83SL/X5VGHAobT9hHkmhMJllimOjAZu/UvMsPQJVgkeNQfdQEk5tfdLPaIX
         yNNHMQw0sxOwrjcW0hDNWGx/srBX0DJNRfhfCDl+JrDhlcYM2YrOAX4QZLF9+0RUHSBq
         aua+Yf4E1K6UaB8fEy5cNIaW4omw+b3lwEEcLZe19M2+k3QYEXard8/MczF2lHAnAgmD
         djMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752273367; x=1752878167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6jEezWUjvICh7/WW/Ivp+Swoo1QztjCMy3V/+iaOS4=;
        b=r8AuASF+3JiHeVTmQ1z6J9p6n71mLVJoFaCO+P/rIod5rYJPtu50+tF8XqHyt3ZtL5
         BeRdNUljH8vqeTQHaY5QwPTkp6POKpNblr8KPnrPpXzRQPwD9UI/bp1/QdP6pLr8gqnW
         vWVjg4obmR3yfW+oBmQRL1eWLtd+XWp5ZXLtUo5c/d8VS5aEKpxH69lLVU6TT+kxuxR4
         4PBKivLJpOIkVWz7Z/I9nXpSY6DmxDoIWXZeeU5aF+tBtSyi/Hoi9dUErD5F56nzkSIk
         vB8VV0A2ifq3AnL4x1iLXF9e796dCu9b4FO69EpU5PKKpGOzHYVUp5QphxR1qj8jdmEw
         fddA==
X-Forwarded-Encrypted: i=1; AJvYcCXtSJ3Ndd4c6wzvAMfTt9e49nKY0NHx+qq9ZsMiQzPBk/lPgJVmi56Z0ChAFSTVPT5pknc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPn4p3QvmRbBIHxXkycZobOtm6LHplPW63esOYFbyofO9z6I9J
	+eYQqc1dntVMm1N9po6nTmXrvtlHJeY3Zsm77iygHXtik9WhwlEbmE57kwusj1YgBMI=
X-Gm-Gg: ASbGncuQA6nqyq0wFPTnw628AHmMpNcBNr9bBXSEq5rBlItMwwERo9+5JXuMksO2efT
	AKweJMTBgiJnBGWvo+3zSU/eY4Kjen8FSuNpltOWPi25NdGbCVJgaR3A6R/46ZGF5iJy8AgGYBX
	cm7tIF0Kka6K+v8PiRQCBuPEtrgJHZOARxuw+dfrqQpJ9Usrvovro371zG6ezbtM6HrjXKeQDz3
	mNFYO7k8FUTH7TwHoF6bcztZ5RnprmGggedbRQmBfd1B/6xfdVEkdEk6mG0WteOYEqTHKoJCfgr
	2WFtPS85oivjkmjsF+uewR/aFW3uoTMpVJwYorn6lg6rOIgsarZjTCCYlTysRyFVGijmlEELlWX
	sqNCuqeqsFWHztuEcF7lpHdIGBGgDLNRP6zXSK+d6+1QnNXi5CJiw4Z0dbLwFPPH5TMv3s2PJzg
	==
X-Google-Smtp-Source: AGHT+IHcy1eXPnyRzznoEf2npXkMyCOaTtdOXhPkzHUHvNfiFnAiR4oHyRzA4NVeqBX+We1cjFjHFg==
X-Received: by 2002:a05:6214:2e8a:b0:704:ac9b:f69b with SMTP id 6a1803df08f44-704ac9bf745mr39098586d6.3.1752273367266;
        Fri, 11 Jul 2025 15:36:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70497d39728sm24160086d6.79.2025.07.11.15.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 15:36:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uaMLd-00000008LmF-3pds;
	Fri, 11 Jul 2025 19:36:05 -0300
Date: Fri, 11 Jul 2025 19:36:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: lizhe.67@bytedance.com, akpm@linux-foundation.org, david@redhat.com,
	peterx@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Message-ID: <20250711223605.GE1870174@ziepe.ca>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
 <20250710085355.54208-3-lizhe.67@bytedance.com>
 <20250711153523.42d68ec0.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711153523.42d68ec0.alex.williamson@redhat.com>

On Fri, Jul 11, 2025 at 03:35:23PM -0600, Alex Williamson wrote:
> Don't resend, I'll fix on commit, but there's still a gratuitous
> difference in leading white space from the original.  Otherwise the
> series looks good to me but I'll give Jason a little more time to
> provide reviews since he's been so active in the thread (though he'd
> rather we just use iommufd ;).  Thanks,

It looks fine, I'm happy not to see any folio magic in vfio for this.

Would be nice to see scatterlist use the new helper too

Jason

