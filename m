Return-Path: <kvm+bounces-19076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D042E900A68
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 18:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 671C21F24219
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 16:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF0919EEC3;
	Fri,  7 Jun 2024 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4/em0Xv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FDA19DF71;
	Fri,  7 Jun 2024 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717777741; cv=none; b=etX7WK7WX2efOu+bpshson5MuDS/n8qIeteXyn2ZrNWIfOLHosPLT0APmkwNyNWl2iwDOGazV9HZJIv5m529ZGND/nDcAOJMAIGNFRNU74afiSMTY/9JaMFbZlreqth9qzxEZ+U2BDO1VeBbB7nfAfsS0p5P5nBhmHS/TLrhYdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717777741; c=relaxed/simple;
	bh=1wGhhmJq/xUhMmXlkArOGi3wVi33minnfJzQj9uCKUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tk6/qs9aH0a5+qB580zse8afbAo4gsfNJjvYqI4BcyE7AIY3jLbI3uGqjJ2iV6P9NgW/duuRPsorHuIbVpD6zdlglhs3YtLnYGAyfgtgbd/qzUndzs2xHAMp1n+opADw3zSoKNa3BOxr+FAy7HUMruFHVhLnDT7h/k3wepTpoUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4/em0Xv; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7024d571d8eso1967470b3a.0;
        Fri, 07 Jun 2024 09:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717777739; x=1718382539; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z5U5vYedi2Uaq0jp7wwznCLlOkYCVT2//3vK0sKJfPk=;
        b=W4/em0XvUJ4w7QnstIE/UMzM2IwyF1eHS695/tWqAnXyWfgyTc/w/IJOBGnVearw6T
         9QPVuKLFWk/3+6kLv22iDG15lHOew9xOCtfJi/HH7fYBiX0zVtBmU1+uchnS2hpBHAQo
         9wYqCQxPfENELeGRKlsd72ZZm3LUn3pbJ9D88SJlyJnkqFq3ckxCEe0lui8obg54BQy/
         5tSu/1UNOZWhtgjfh/jYm/2c3XmFeiM8/+GEMUYROc5G2myro8Ol9IhFrAp3QBF9/HrK
         dg2m6kR8+jyg9qKCii8iJdpkAZR3/LurBTEb1LGXTPSE9LH27XoNAokFG3d/bB4mJR9k
         6Txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717777739; x=1718382539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z5U5vYedi2Uaq0jp7wwznCLlOkYCVT2//3vK0sKJfPk=;
        b=T25jXkRBPWCRy35GUAZcLhw5JJffNHWSK7Zo3CYX9p11RW4R/whYgiWESUnlqz2Nld
         OO1rx5EZv3XM8R5Ejgqh8953aHGiRDA990skYnSogFLACqTiel10F5QgI4RBV66zTwgW
         JicFlCja11iKAwVgnmv3sdh3wM6FRFILtznjz5RZHSyb1XOxDjlH9OY2AbTGRbj4YYpt
         i1hwpTp5HqU1zrx3e+MXtC8iAR1PnPqjo0NEwEwjbRQ/Rcv4+Diwj1kRKaFleecPUSUB
         EWFAqMkeuEBAF1w0Wf9FfMZeSe8rEluKrn7MrI66HvgAspSj0Nh74AiyclshitCdMlyS
         LUww==
X-Forwarded-Encrypted: i=1; AJvYcCV9VZeY4dnt/DQZhlXElOJ+hH35sjZOb+WqDGYTkNf90uaGpR4tGxFmyp85NeIVKWfL4MO94mLuCVzHOVjnvoZzT0Yu3sMdaThme0svGsltxbt8lIMPdFUJr/Y0J9fEIxmoWM4cm4Ut9xgMD8XBkrUbSCqpmNBnrMaEZw==
X-Gm-Message-State: AOJu0YwGKp6jJZem+99eG7mVubtcHGswV7TvWW/Sp3s5OZCMcqhrjajC
	+2PS1M7Fdp29LkbftQT30wzbpzSXYZjJNIjNI/YhRnVoeOMVaPre
X-Google-Smtp-Source: AGHT+IF46sBs+Uh6sVLy9BmR7z4ajfG6b0Ftovq0XkmXzu35fi1XHga5oRNdcSpljNGAmIRJiqupWA==
X-Received: by 2002:a05:6a20:1590:b0:1b0:259e:c8f3 with SMTP id adf61e73a8af0-1b2f9ccbc20mr3708325637.54.1717777739366;
        Fri, 07 Jun 2024 09:28:59 -0700 (PDT)
Received: from localhost (dhcp-141-239-159-203.hawaiiantel.net. [141.239.159.203])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd50bc26sm2757124b3a.180.2024.06.07.09.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 09:28:59 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Fri, 7 Jun 2024 06:28:57 -1000
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, griffoul@gmail.com,
	kernel test robot <lkp@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 1/2] cgroup/cpuset: export cpuset_cpus_allowed()
Message-ID: <ZmM1SWBf5rb7P2je@slm.duckdns.org>
References: <20240606151017.41623-1-fgriffo@amazon.co.uk>
 <20240606151017.41623-2-fgriffo@amazon.co.uk>
 <8936c102-725d-4496-b014-cc3edfccf4dd@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8936c102-725d-4496-b014-cc3edfccf4dd@redhat.com>

On Thu, Jun 06, 2024 at 11:45:37AM -0400, Waiman Long wrote:
> 
> On 6/6/24 11:10, Fred Griffoul wrote:
> > A subsequent patch calls cpuset_cpus_allowed() in the vfio driver pci
> > code. Export the symbol to be able to build the vfio driver as a kernel
> > module.
> > 
> > Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202406060731.L3NSR1Hy-lkp@intel.com/
> > ---
> >   kernel/cgroup/cpuset.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> > index 4237c8748715..9fd56222aa4b 100644
> > --- a/kernel/cgroup/cpuset.c
> > +++ b/kernel/cgroup/cpuset.c
> > @@ -4764,6 +4764,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
> >   	rcu_read_unlock();
> >   	spin_unlock_irqrestore(&callback_lock, flags);
> >   }
> > +EXPORT_SYMBOL_GPL(cpuset_cpus_allowed);
> >   /**
> >    * cpuset_cpus_allowed_fallback - final fallback before complete catastrophe.
> 
> LGTM
> 
> Acked-by: Waiman Long <longman@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

If more convenient, please feel free to route the patch with the rest of the
series. If you want it applied to the cgroup tree, please let me know.

Thanks.

-- 
tejun

