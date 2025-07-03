Return-Path: <kvm+bounces-51477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 248D5AF71D7
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:13:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 185773B86C4
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C212E175D;
	Thu,  3 Jul 2025 11:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZpEgArdw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C70F1E5B72
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751541140; cv=none; b=Thx+mtdgGI4bMK+iI98PailYu2WHds4fHmcGxfqACz1xCDQRslwWL04QFwM8HuRbsDpBGe7sFYxYo1TiSYY4NcNxEeK9Tb8h7dx9EwF8xgzYsZw1hWp4VFo4Q6hxX4tH6r/e+7F7y+2a4o5ukeL28bLEC1pvC9yvvxhJWLGsS1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751541140; c=relaxed/simple;
	bh=bihF1qMOyKgYkmhiJ1U6KBKy1pzwOukLKYEfDly5ihw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/x94O7AelAQxc2nL8eAHOA6cq9aNP6p2PQC7ZyFdF2UQHDNmZ43/MVANl4j4pzwUP/eIwLHL7bSAc2Y/vntIPK8uuzYCm+25jZXqtm9+tl8SvR6g1bxupkgZ709V0FYBSxQU+xjJXbEK+wFR6fqe3GAC6H+BkNac+7CqikDObg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZpEgArdw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-235f9e87f78so57158235ad.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1751541138; x=1752145938; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Bi07Xa1ZYxOiNG8G/e9FKN2IkTvUaWt67C3ZOXAsBA=;
        b=ZpEgArdwt7zC2F+yjkdSrFD1Uxdt/qh959K4vEs2PDnvEN0U19pNUm6mK0Cxwb1bFB
         TYUAZemqrKId/G71GCfxFqWnE+dI5F9SA3nGsfGo8DoWqlDTw7rkfVAReod9eabZ+xEo
         7XEkane57y53YtG3Lsc28YVr5bAXXG4f48t2E/ueDXcdJpBolOXZcaI5mUpKykJdo6H+
         IhonqZAv5a9nKBBEZbJCQbqW0Cts5Vmld31Li0UAa42USYoonVtF9ixUbrXUVJbHXbLb
         LCa0XlApRwX7DYTH+QI1i/d4/SqwdI8AzantOBmeZqOcVSoppA3Hj7YYaByeEC3Wb10Q
         4Knw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751541138; x=1752145938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Bi07Xa1ZYxOiNG8G/e9FKN2IkTvUaWt67C3ZOXAsBA=;
        b=UICeAmXSkUUk3pT+igIj6eL1dk69pMGNp7+ayJ+PRvF6t4hnGyIzo/POuZsVv7yRYd
         rAOIca913TYP6dOKbBhiu8Af2dkQUTn7rEPfjtB2L9WMp4VKwAW34xqyD2hHUmR61/3V
         QSU7hHrKnDfE9MPZJ6y6TAUlFmnOyyWKG6sr6nFClW+Acw/yJEk8tkMRlIU2zj52Qlj+
         VRPJse/QoJkJXx7wDGKSgv31SgKf26aiEbqb0XAa35VgcJyMYRAa6LTwU9UQ27nAbIiZ
         E/q0CBvjwE7FQ2XPx5HlaNyHBUxC5yXf+W8/7atPgUeBhpDTA/+ajYgo/bhP5aiC6lzR
         Qf5g==
X-Forwarded-Encrypted: i=1; AJvYcCWjFCBAL6PX0y5i41vwrMlDuxygTF3SVRQBHkd/6glYRx4psHtYIMeG6756tyhGfI6nJf4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEP+Krp72Mww8oPHg7NCMHcv5536JREX54c92HapWwcZL/Vqrn
	w8SQ9+CKSDTCnvHKraZ4xhoIJi+XQuFs4XekmnusnBN7FkPS7MF1/v8erGv8lZtr1SE=
X-Gm-Gg: ASbGncttv5Zlnbo3Oz67wrp4ipatRUCoZDSdltNPzlB5/bC68FqrudET/54rJtFvV3n
	YPCha4g+WNBGAcPdHwRdu8FKZ6IQccDa6m91WIxyIPi+A0jc/aDX+wxFRDMf2eJ24YmMzINdyp/
	9pRemeJVbLrH2zFart16yzvplQMnZivftCfawp48JeqqSsZ7QoUYatsRM1goAAycHQvZ5r6pxJN
	pNzZEi6bBGkZ/IciXEjkUnhvCfEuArMhWe3dT8Su56BpZfqpDEFJsd9OvwB0BejGZ4fldKpp59M
	HOF+HcgYNx6w1o7ZU5gYK1fa41PQwLbu9mIp
X-Google-Smtp-Source: AGHT+IGu+iz//6ptjIiTWMElugg1B4roY1I/9EYRDfQHICQLOGN2lg2bGldKdCyM/eDynJL6WK36Bg==
X-Received: by 2002:a17:903:1a67:b0:235:a9b:21e0 with SMTP id d9443c01a7336-23c795742fbmr47326015ad.0.1751541137726;
        Thu, 03 Jul 2025 04:12:17 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f1814sm147706655ad.57.2025.07.03.04.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 04:12:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uXHrU-00000005CEV-151S;
	Thu, 03 Jul 2025 08:12:16 -0300
Date: Thu, 3 Jul 2025 08:12:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: lizhe.67@bytedance.com, alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and
 vfio_unpin_pages_remote() for large folio
Message-ID: <20250703111216.GG904431@ziepe.ca>
References: <c1144447-6b67-48d3-b37c-5f1ca6a9b4a7@redhat.com>
 <20250703035425.36124-1-lizhe.67@bytedance.com>
 <664e5604-fe7c-449f-bb2a-48c9543fecf4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <664e5604-fe7c-449f-bb2a-48c9543fecf4@redhat.com>

On Thu, Jul 03, 2025 at 01:06:26PM +0200, David Hildenbrand wrote:
> > +{
> > +	struct page *first_page = pages[0];
> > +	unsigned long i;
> > +
> > +	for (i = 1; i < size; i++)
> > +		if (pages[i] != nth_page(first_page, i))
> > +			break;
> > +	return i;
> > +}
> 
> LGTM.
> 
> I wonder if we can find a better function name, especially when moving this
> to some header where it can be reused.

It should be a common function:

  unsigned long num_pages_contiguous(struct page *list, size_t nelms);

Jason

