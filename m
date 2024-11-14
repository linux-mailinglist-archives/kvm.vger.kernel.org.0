Return-Path: <kvm+bounces-31884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D01259C9252
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 20:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F93DB279EF
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 19:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355F219D088;
	Thu, 14 Nov 2024 19:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CwQ5U5DI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D662F1AAE30
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 19:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731611559; cv=none; b=UGzS4vNXrl25SFF1kw28o/xLqcd5p5qeP03XNdzm7aHIBkbd4JGM6t4hd7awY3L8KBc8G6HgdYRADm4aW55+n2lKPWfotuBG/QLsn39fRe/jlPdfjy35NOCBtsg519lD9gVkVNkGO9UoE9t4gsaKJPlduG1VnznZp08eaupt2AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731611559; c=relaxed/simple;
	bh=aVOqnpVhD2G7zEh7K/9vBdzZy82Q16uLtsqhHUm4mTg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrPsXMPRLEIVUmoYcFreKYWHl8pojIMs9/P/Bs7hJlRkP7eIBiV9xnrIlelVerJKGV8gwX6j+luiun63dPonsHEcctmMZAdFGBw20ny/LgIgivp9QLzZKrJCCyLnHFCKy7mMdxIJIalQb441rM3+Kobc3ljRiIIdzdKHKb98HFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CwQ5U5DI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731611557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s2LqRMLf5vHEKXOXwsKLoHWlUkg3buPPjEbjSS2+C24=;
	b=CwQ5U5DIUzJYAolF8OaQAgPQzcJwyABYjIp45r6usDt1DYFh5tN0imqKoRmjNIhi7kxo/t
	lISEbp19cqWUkIwfjup4tGolKcDNiCeM2cr7TkxPhK36F/qm93oT/LUwKpNYDo61mzmPyP
	VBeRe33jXKlQxcgP/WvABdg4OgF4q4I=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-tuQKS9RzP1St61vaU_PmnQ-1; Thu, 14 Nov 2024 14:12:35 -0500
X-MC-Unique: tuQKS9RzP1St61vaU_PmnQ-1
X-Mimecast-MFC-AGG-ID: tuQKS9RzP1St61vaU_PmnQ
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5eb85207c7dso32055eaf.3
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 11:12:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731611554; x=1732216354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s2LqRMLf5vHEKXOXwsKLoHWlUkg3buPPjEbjSS2+C24=;
        b=MZiuC9bt5CZKFRihe6a9it3gdJ9/ZKFBhSVeQLVrzZe7fI8lMyFKHcGBQ8ApCYd7B4
         lQg9rWHW/WM+nOl34EV5wi1KozCQQn8a2pkiPzTr7aeZtbZrACy1oogzu71+qxrp5MFH
         Rb+0aFga3SHnR9FO14oCE2iO4TbtfiUt6ej+YO/wQyBXiOHZZnPV1hQyITvrQIWU+0Kv
         cktP7M5g4sI1OKHJYk9rdARaL6d9ByYbvZd8wlZrwyX+0ncXpZpHdyTc/8vu/A5oYmx/
         9iISQHyt2mmHu32PLOnO3vP4uIAlzbqFSd5tqGR6QhaeaolBQybdF+BCXPd2ok47wIiI
         CyGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCub7RDrWvQU561B7L8iNTJdqojqqKDT8GVc1osx7TNH//Zm4FWFwWUUewm8trCOQxp2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YytSUR65XpiC62rHf3FjXEjxwIA8hLmLnqRsIxYBKCyUlSGml+J
	HCWPJNwouvIffUCSP41TTUASkkIHM1JEw/Li877AO8EruG8RI6mAG4TiiugbybBFrAry8pCYz5V
	lbhVxpR6pq4cyIeJj3r64gvv0KzukcM26jV3/nptBhrXlSbHg/kPHreqLxw==
X-Received: by 2002:a05:6870:2a4b:b0:296:19b2:d571 with SMTP id 586e51a60fabf-29619b2d93emr509394fac.3.1731611554137;
        Thu, 14 Nov 2024 11:12:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/Z3pl3umzWbmtK0RC+Zbn5aa5pwea1uwaWCtHBK6M8iCXnMSKNwwHgdm3d+IDTMuNhk5hJQ==
X-Received: by 2002:a05:6870:2a4b:b0:296:19b2:d571 with SMTP id 586e51a60fabf-29619b2d93emr509388fac.3.1731611553871;
        Thu, 14 Nov 2024 11:12:33 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296107fe2cdsm772245fac.3.2024.11.14.11.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 11:12:33 -0800 (PST)
Date: Thu, 14 Nov 2024 12:12:32 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH vfio 0/2] Fix several unwind issues in the mlx5/vfio
 driver
Message-ID: <20241114121232.3491e28a.alex.williamson@redhat.com>
In-Reply-To: <20241114095318.16556-1-yishaih@nvidia.com>
References: <20241114095318.16556-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Nov 2024 11:53:16 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series fixes several unwind issues in the mlx5/vfio driver.
> 
> Further details are provided in the commit logs.
> 
> Yishai
> 
> Yishai Hadas (2):
>   vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()
>   vfio/mlx5: Fix unwind flows in mlx5vf_pci_save/resume_device_data()
> 
>  drivers/vfio/pci/mlx5/cmd.c  |  6 +++++-
>  drivers/vfio/pci/mlx5/main.c | 35 +++++++++++++++++------------------
>  2 files changed, 22 insertions(+), 19 deletions(-)
> 

Applied to vfio next branch for v6.13.  Thanks,

Alex


