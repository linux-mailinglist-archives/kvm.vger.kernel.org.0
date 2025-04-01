Return-Path: <kvm+bounces-42320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85687A77D60
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB49E3AD8F7
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 14:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1D8204855;
	Tue,  1 Apr 2025 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Yc7TqD+r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42981C8639
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 14:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743516702; cv=none; b=ogJVgyDnL5/ByKlwkwctZOMePb2F3w9v9SrA8bVHuX8WdGs/7sv/K5D6Q3ilOJIobubBAhmmORHxWT+gnkOeNzXrI+O5+/1zb4Ktwt4fNi57uthrGZe0cP4JREe9X2PVC4mbxvaxoXwdPqLrLC8o44grdlTEX/2BBFAVE+R0kCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743516702; c=relaxed/simple;
	bh=0trOQh+jrJl3FmJf61aJ7jvlRp+qH/hSBjq7p2l8A8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9EM00gJbFvtmuwjXiP01+i7PSwMymKWKu6nTO6RH+iQr9QZHzPZDTuX+ylsKMmxnsash6GP21CY6ymB7IRx8GlY7ZNq0PdrgSkfE/G847uvYWwwI6a+vzWCPQp0Y+cs59k8br6eQJ1gM+E/SEIs8UMDszCOs37ILUiDXMzguuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Yc7TqD+r; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6ecfc7ed0c1so48155376d6.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 07:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1743516699; x=1744121499; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0trOQh+jrJl3FmJf61aJ7jvlRp+qH/hSBjq7p2l8A8I=;
        b=Yc7TqD+rnF2D4uO+5IYqM0hZHyoGRt5eCy3t/VEno38WkiIEXr8IscWlCQeDVu/0Rm
         BRKhn40XfReOuNvUyUqZWR2CSfOQpCl3Qzg1A4f3pL4PmNYJMgJWzu9UFOZxsMU9hpUA
         yUwDhUuAaS1zNCSg0rgmUmyp70yR6eUBasKdZfjto6dOmSALa7lSzXc8Q9rBvRUBjPM0
         puDVIwa2rbite5Ej2r9C8uVBseQ0czZML1QFxjr7bLQyeJgMyTLr6RL+VQlkyFoMIEup
         3LSZ3RsjFc3reJmntwjrw3FGwPnzlfe6ZJBFRGNl6FVQN/ffqXljxQnSP4td5vztXkaR
         s+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743516699; x=1744121499;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0trOQh+jrJl3FmJf61aJ7jvlRp+qH/hSBjq7p2l8A8I=;
        b=ChpnyBzQ02J9I4kJ0Kec0+OHE7ADC9UZAFZEwCmGk6jciwIcwLcWOQN5SDRPkM/hSH
         bU9banX2Xn3KDHTGj5tFEk1GkmshoKAgwQ17zR2rIXE1cedQts8K8W4Cj93Av1/YfQAE
         tWAxkgpLRNW3SHDMgFbhff9IRRnn37lKQ5qGrtwGge3HGqe7khcur4mqgXg1TbC8SpX0
         hPEE8yJwmccL2RcAb3Gl0r+8nchV0mQXbo5EZSqWa9ImNWokWNKkcSA+G07Bx/RqPyYU
         x7so95Mn3dY0LIbydlbwosxa1n+xlkblpkERC5+B7f6A5/jmGCugOSVmIbSL9rfUSf9g
         qxqw==
X-Forwarded-Encrypted: i=1; AJvYcCWFPTS704/aL8E27cMs6Hm6VKRA6GOz2nE6VYURdNgMXe995uplOjL0q7U3HSP/nQMYWBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD57ve/MWGbDBmWkRN1KZdwk3hCIt9DM85WccoIyGn4zGZnVi6
	keBBkAePcJhmMcHS6YBSE6u9kfLzU7mVDGbhJI5KITd5VD2576bM7IfYRY6ufq8=
X-Gm-Gg: ASbGncsx+t7Sqp/oTdxNhsMCFdoCMK3RP8DTEL9XkdURnqIA2vbUIHmuF6jkpCD9rTN
	owM2v04qBw+9bZ9B7E74G2IL8Rv9l0I1e0TeLCf7BBC5hcbS/EALMd2CkJ3e5TacmkD3wxwGeS3
	bKkPlT/hCBnfp03ubpo91eTw/slM3zuiDy5cxnhVlc7AXveeqT+8JPN3fhJBKjJy+3f2d2t1r6g
	dte5aLLZCFTDydZIuVo2pOBI7dFW66BC9Alv1ZeBfznh8hfWRG4EmcQX9yu5o35SJBfmcmD2TmA
	thSEiRdhj8/C9UR6jA3UQMnkxD1tBwV7vKE6Nxi/ikAqqwXlsFZ8UOMus26BIiNLPKUReHajXwA
	g1qtJzURhfJVtDnftFHe1JIY=
X-Google-Smtp-Source: AGHT+IGuee4s3yxDEPSINUAFtQsa9ux8jxq1OoSPRsoWojLLXuG6p9Io2ozsOuCD3yEeRFQ6PGF9AQ==
X-Received: by 2002:a05:6214:e48:b0:6ea:d604:9e59 with SMTP id 6a1803df08f44-6eed5f89c29mr176486186d6.9.1743516699490;
        Tue, 01 Apr 2025 07:11:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5f77804a9sm658374285a.112.2025.04.01.07.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 07:11:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tzcL4-00000001LLA-0nQB;
	Tue, 01 Apr 2025 11:11:38 -0300
Date: Tue, 1 Apr 2025 11:11:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	nd <nd@arm.com>, Philipp Stanner <pstanner@redhat.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	"open list:VFIO DRIVER" <kvm@vger.kernel.org>,
	Dhruv Tripathi <Dhruv.Tripathi@arm.com>,
	"Nagarahalli, Honnappa" <Honnappa.Nagarahalli@arm.com>,
	Jeremy Linton <Jeremy.Linton@arm.com>
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Message-ID: <20250401141138.GE186258@ziepe.ca>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
 <20250304141447.GY5011@ziepe.ca>
 <PAWPR08MB89093BBC1C7F725873921FB79FC82@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <20250304182421.05b6a12f.alex.williamson@redhat.com>
 <PAWPR08MB89095339DEAC58C405A0CF8F9FCB2@PAWPR08MB8909.eurprd08.prod.outlook.com>
 <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276468F5963137D5E734CB78CD02@BN9PR11MB5276.namprd11.prod.outlook.com>

On Wed, Mar 12, 2025 at 07:53:17AM +0000, Tian, Kevin wrote:

> Probably we should not allow device-specific mode unless the user is
> capable of CAP_SYS_RAWIO? It allows an user to pollute caches on
> CPUs which its processes are not affined to, hence could easily break
> SLAs which CSPs try to achieve...

I'm not sure this is within the threat model for VFIO though..

qemu or the operator needs to deal with this by not permiting such
HW to go into a VM.

Really we can't block device specific mode anyhow because we can't
even discover it on the kernel side..

Jason

