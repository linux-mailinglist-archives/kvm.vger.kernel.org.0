Return-Path: <kvm+bounces-58146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88846B89560
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 13:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FF0117932D
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 11:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5799C30E820;
	Fri, 19 Sep 2025 11:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cJ5CvvFi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C7530DD39
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 11:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758283090; cv=none; b=jHWlzHscrj30qBGdwP4HFAl3MJoADsTAMfryuI8YbA/JmHMWoFr51sHv6gwEw0vRVbtyeXZWyD1IWnxxLQi4IkmRpjaDJo/LJm8fRg3QUVwzoiDp6fG+lMVU4fIVgRkGa5LD7a+7zgnRq33nUzhGd2bjuCVuXG3tkhWFlNkovVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758283090; c=relaxed/simple;
	bh=z76f63pK7iULjhkDPA2cDB1JEhtZUbriGGo8ro5LyIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUOPBu9EFPVJj9wB2vqG5CY9DSNcEf9nFDIEvOUWTRk+NWwgXQYrWVIsrJCGBH9u+pK/JMZrCgTam5TcurL/4/6f28VMFrqbq0iNaz9cCmjMDrV6u1fFTUsreCIpAKef8JatZ5/UDQ13J7lTfTlCHF/kBrCA1agBXJGlWlqmHss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=cJ5CvvFi; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b3d3f6360cso19329011cf.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 04:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1758283088; x=1758887888; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XqkzJ715IFhAdPqz34JG4QrSrgL1I3NolvpeVSTSpSM=;
        b=cJ5CvvFi4Ux+0g+c5NdMmNIvSoh9f0ftQC7qisliChqhhYmJADWMtZsVY6vpSY7DLj
         TBgjaYj/OnvG9ksqbX3WS86N8ABjCPYhprhE4/XH21TFNY9E43PpuILUj9GnbrN0KYdy
         ipUrG6JPg7GuZqbgRRadQfXMX9723oLaKMWW1vkyKhQ3MYvb2x8ETUrPgV69g/CHkk3+
         LnIDz9f7/C6qPMAthQ4jSeIleIvcDdbG3J3V2hcRB1Wvcc8inf13L5DBxq8QX0lrc1zp
         CSlkrOeh/Ky2FQoWjbOIYFUV2p6+ChCrFzm1zCxV6q2QEe4EIiIkZPtMuVSD9EN7d9Xi
         bgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758283088; x=1758887888;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XqkzJ715IFhAdPqz34JG4QrSrgL1I3NolvpeVSTSpSM=;
        b=qIWgq8spI7RihFBf20LboK7jtRfw9aF5zkN342iwiYf+fvD1eii6Fo8TOEeOjXmNKZ
         /lfeBOpmf/Bplxs9DepvwmNfWPGUTgULDxZOSYlfi3ednupj1wKxWip3MHbaKRkER1Wg
         dQIABf8+T9iypsUn5840ZNYXwddUu+eCQgVWxGpA+/Q5eGTZ34neYJ0/SX9rCAEsefRp
         /Rp6p3sy2G7knBgk9iYZbkQOpLEtVhJsd/VQmiQbUGqprvqNjyIL/xCfJcyMQNjBy6Cc
         VRSMcOjXC5KZw5kxa8fBIJAHEQ9F4nzZZ8p6pVVr044swEqk8yO6sXSobno/sYc9lpNm
         CSaA==
X-Forwarded-Encrypted: i=1; AJvYcCUxNfeCiwxeI9+86sI9qfq152Nonb+8cnwcSyfFcEyYbULV6C0qsvyfw2kpgllW/NvEfy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSlB8q9ZWvyeQ1fg4WTV4zFfNoaiAU9NL4l2CfxKEavwhQ2GoL
	XlG9fOQGZtKzSAaFrxVu1Euij31+FDY8/U14wr1MrRrQnGS7oLW49EDVMSjlnCBA8j4=
X-Gm-Gg: ASbGncsriKNP9F7Zl4LA6C1Icr/4gmQLhI+jscKeVj8KqUD57s3kHF3Mmrqdo/S+PZp
	0alMsyyvaR2I4Eq5VxCtrHlUhHZK9NM9H8yu3APreRwbR2IIPpAgA2B3wzBOjsQn9uPD+Qad4/a
	gdOZymdOc6A3gS3lkUwYVCH1mEhlYKVDCvtQa28BOHS1T4UDW9iDsh29WLovr3G28xb/+Itena0
	P4y50eH4YBchJ0XuhcLVg48qKeDwIpsBNmVWVURDb3C81oJqXpSXY2RgdWNj0SF4HbqnsZEIWCl
	iyXwTpOIGKWSylwvmzyeI564Vo6XdRq/R1u4i7S2lAuvZOdW4En8a3yDuaPv5Wfy7mXLbttO
X-Google-Smtp-Source: AGHT+IHAUUCTifYO3tvHTIggD1bty3WA1tAmCInvXz11D2JOt+J25vVYjGygxn7PDvPC0VZaaS2K+Q==
X-Received: by 2002:ac8:594d:0:b0:4b2:cf75:bf10 with SMTP id d75a77b69052e-4c06cbe95ebmr27476741cf.17.1758283087738;
        Fri, 19 Sep 2025 04:58:07 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8363198ad41sm325729185a.46.2025.09.19.04.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 04:58:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uzZkb-000000097c5-40qZ;
	Fri, 19 Sep 2025 08:58:05 -0300
Date: Fri, 19 Sep 2025 08:58:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Keith Busch <kbusch@kernel.org>, Alex Mastro <amastro@fb.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, David Reiss <dreiss@meta.com>,
	Joerg Roedel <joro@8bytes.org>, Leon Romanovsky <leon@kernel.org>,
	Li Zhe <lizhe.67@bytedance.com>, Mahmoud Adam <mngyadam@amazon.de>,
	Philipp Stanner <pstanner@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend
 more granular access to client processes
Message-ID: <20250919115805.GU1326709@ziepe.ca>
References: <20250918214425.2677057-1-amastro@fb.com>
 <20250918225739.GS1326709@ziepe.ca>
 <aMyUxqSEBHeHAPIn@kbusch-mbp>
 <BN9PR11MB5276D7D2BF13374EEA2C788F8C11A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276D7D2BF13374EEA2C788F8C11A@BN9PR11MB5276.namprd11.prod.outlook.com>

On Fri, Sep 19, 2025 at 07:00:04AM +0000, Tian, Kevin wrote:
> memory of other clients and the USD... there is no hw isolation 
> within a partitioned IOAS unless the device supports PASID then 
> each client can be associated to its own IOAS space.

If the device does support pasid then both of the suggestions make
a lot more security sense..

Jsaon

