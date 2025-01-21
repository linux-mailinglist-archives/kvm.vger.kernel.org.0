Return-Path: <kvm+bounces-36186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FE8A1863F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:48:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F387A1664AB
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 20:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F5EA1F8671;
	Tue, 21 Jan 2025 20:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PK9ALH2C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805B71F63CD
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 20:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737492483; cv=none; b=Ehh/BKqNXD1hN7vx6CZez7cnyw/nvGTBku3UERXkhD7iEw/2lFFbNcKZfDwJw9z4kxORIy1zPnHjyUT7/jnWE/Ebw1KCzj6KHliZ9XYumYY0HfWRYIkBTXV47eOPJRc5tkoG9YpZtcmmY1I7kFYv2sUZsaU/8GTT6voLjT7+5II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737492483; c=relaxed/simple;
	bh=g6gsRKJh7V7n8xwdh+JPKCk0Lq/C+rb/lPQNDYRoAx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmEcN7DZKLOdn9U/TKauhLBzlbAsCbdHuzYajb/wZY/c8A9VFfvAV/uVW2LCZCKsX7D2c+g3aHKxlP+vwpMEETqp0gVUeTIw/3cT9AgLAZM1D5Z+R7bDE0ewh8h/RPzWoBzuq3fXBY8RYBXfW9vuMjbiwdO9ef2bufeYH/5RVR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PK9ALH2C; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6e1a41935c3so84927406d6.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 12:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1737492480; x=1738097280; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ow8OnSOBUAvF1sR6NsRcQ1mD4Budky7KnwU2LvfpPWA=;
        b=PK9ALH2CTpxIquPHRrKlIFzCv4C0a9qLPFP2xvEL2ML0hneKUJ38EeputpInMz4tT2
         mAfD5ckrYzU9r4K6c3HyUq8rmBy2JMERXnWR1Jr0ECTS7WQ8/UcRIhDKN3KAbzzn/AvM
         evj7pa8a2USTESwwXhdKUCcyPoLSMCHrGWveqKHzVPQsKFlcFtGTBStPsiRpqVXelLKH
         9D4uFdE4/3+HpuKcKTsRg1THPfparzEN8IFD80yNVkvrbsagTs07yY0sGCg7PyanDPxB
         CCXPJQ8KA2z8EZXOXSFOZqEK3qQCn9a7k11n2PlwwxeebZgZ9BKHNBT2sx8AJpldPXDA
         Tq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737492480; x=1738097280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ow8OnSOBUAvF1sR6NsRcQ1mD4Budky7KnwU2LvfpPWA=;
        b=emF0rrK9br5f29IhR37Ku//QtOq0ln1iWEhk8E5pKDffBxJELOhbbDWuHomJDXEaWG
         xa3JThCdwseJxVwVA7ocsG5rDSsWPckpl9t9KC1WD2yj6Vi6iTaayTzgiQd2m7PiItoJ
         /0pQvUgcxPFhtw80ISij3g3Cn5pc/Z2yEt1nO8MNAVJ5a8vM+CNSENKaO7b8l00H49Vp
         edP+DCleC37sx5g9EGyQSNr4XI5NrB5xEfvh2B629Z0hnzxtW+KmnMHRn4KO8T7KE/OX
         G6jBhjr1fDx7Wy17Y0tQ9sE0cqgBFwdlx6eHmYPYB373ADqbrU9y62wSSz5BxVQVgzSp
         1haw==
X-Forwarded-Encrypted: i=1; AJvYcCWdiOH3n4P6SwsgVHjgddWzOies/NJv1/WYq0sV0IcWw39oQPOiGn2jJLMJbjvopZNy6b4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yys4Frv+9lBkxym0K5RB7uJwT+eJaHzuOVx57ShRzBKVC7T5FM6
	m/Lnmcj/CQPimgYzLNcBp58sjAPYxV0u5Y/CHFMbPO5AJ27klVgTjq80MspDadk=
X-Gm-Gg: ASbGncvCD7xPNpSU8Yp5sq6zQeAuVzfV/Cq6cC/mCXQLZZ0og/upjrU7485rgToDHRK
	1RUz2VmL6NUBCSwdq9znQm+s9nGq1PYe4qQ6qNHgM4S2LtlR+s4e65ULIr8FtwR1lTRAAspvVrq
	48NIXq6Lw3VLuD8PjHFd95x5S1CJHpdW2zvseB/IMicep4yO2LBTqARyP5G1xi3rYYj4Jruyod8
	R0K6PpWXZATyMcekYArPf9xq5iRf4wBkVVRUErWC3aI
X-Google-Smtp-Source: AGHT+IGpzHbNEy913KwGqLDga7j8XCPTIu+0UlJOC0stjfVReFdRGhjNtDFMtiwPVLFCCekg9fkq/A==
X-Received: by 2002:a05:6214:1cc7:b0:6e1:697c:d9b8 with SMTP id 6a1803df08f44-6e1b216efb9mr307486706d6.9.1737492480304;
        Tue, 21 Jan 2025 12:48:00 -0800 (PST)
Received: from ziepe.ca ([130.41.10.206])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afcd388asm54445966d6.92.2025.01.21.12.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 12:47:59 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1taLAE-00000003k34-2XRy;
	Tue, 21 Jan 2025 16:47:58 -0400
Date: Tue, 21 Jan 2025 16:47:58 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Wencheng Yang <east.moutain.yang@gmail.com>,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] drviers/iommu/amd: support P2P access through IOMMU
 when SME is enabled
Message-ID: <20250121204758.GR674319@ziepe.ca>
References: <20250117071423.469880-1-east.moutain.yang@gmail.com>
 <20250117084449.6cfd68b3.alex.williamson@redhat.com>
 <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
 <20250121083443.3984579a.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121083443.3984579a.alex.williamson@redhat.com>

On Tue, Jan 21, 2025 at 08:34:43AM -0700, Alex Williamson wrote:

> This description is unclear to me.  As others have noted, we probably
> need to look at whether the flag should be automatically applied by the
> kernel.  We certainly know in the vfio IOMMU layer whether we're
> mapping a page or a pfnmap.  

It is not page or pfnmap.. When vfio is using follow_pte() it should
extract information from the PTE and then relay it to the IOMMU. The
iommu page table and the CPU page table should have the same PTE
flags.

So, a pte that is pgprot_cached() should be IOMMU_CACHE, otherwise
IOMMU_MMIO.

The encrypted bit in the PTE should be mapped to some new
IOMMU_ENCRYPTED.

I suspect AMD has created a troublesome issue that IOMMU_CACHE
conditionally implies encrypted depending on their platform features
(meaning cachable decrypted is impossible). Arguably a higher level
should be deciding this and the iommu page table code should simply
follow IOMMU_ENCRYPTED always.

That might be something for later, but I would note it :\

> In any case, we're in the process of phasing out the vfio type1
> IOMMU backend for iommufd, so whatever the implementation, and
> especially if there's a uapi component, it needs to be implemented
> in iommufd first. 

Since iommufd won't be using follow_pte() it will have to get this
meta information from the FD, eg through DMABUf, and there is a huge
thread on how to go about doing that..

There should be no uapi component.

Jason

