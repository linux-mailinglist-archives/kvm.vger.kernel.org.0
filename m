Return-Path: <kvm+bounces-50987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D98AFAEB787
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 14:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15EAC1C42ADB
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341AF2C08CD;
	Fri, 27 Jun 2025 12:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WCWQ3WX3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F43260574
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 12:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751026747; cv=none; b=KYHhmCnehNdZ+jtrp9Za+XG+GfYvXX11vBUR2TuF+hmLn96GkEZRmNiX8AY7cRZ3oBb/niwulasuQ8G8Z/rjeFjh6fIKDZUP8xQtUlLacLLPzOTk5drl4bni08UHQskgLIHkxHz8qXJgQ6EugcPZqChmHopnz+cSS6Hdmmb2Y2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751026747; c=relaxed/simple;
	bh=slF6+o5/m2p6wak/qyv3aOZ7QF/BqfaTzzXLO2276P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDMPx75V1K3n1AwOVYt/OfNIsqqxqJ2jpoXkQ/Wh/Zv65RqNIDlUjBETS0qS3vocGbhwKXk7BjmZqR3KNn09+vrfxPvAOmeQNFOzzb4B4+lUvlgcWAD4XtmhYDaN2DdPa9Sq3vKuGI9aTlIxpk/ynXyI5vlPNigRnE/WsRla5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WCWQ3WX3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751026744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f6jJXeMQ/vnhzBrzmpUv0seoJn2P/YNLb2Myi7IvEQY=;
	b=WCWQ3WX3ZSP+D6Ntpn417w9WimFcOzqIDwVBM/ut13tp+t4zmjbyGwxIembbH9G74PtmYD
	ATc1c7NZZiChwK2Wxv5Y2Ob9qFOhh25GnYlwpIts0jJNwuLhVm26dWj3WSfoU7xV+1abA5
	UmUao0T1c+w5/9ak3HHLaPai76DTu2M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-YGWA-2XJOy6XxZm0A2m1cw-1; Fri, 27 Jun 2025 08:19:02 -0400
X-MC-Unique: YGWA-2XJOy6XxZm0A2m1cw-1
X-Mimecast-MFC-AGG-ID: YGWA-2XJOy6XxZm0A2m1cw_1751026741
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4532ff43376so15698735e9.3
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 05:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751026741; x=1751631541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f6jJXeMQ/vnhzBrzmpUv0seoJn2P/YNLb2Myi7IvEQY=;
        b=l3aYVI9UMMOWMroLs6YpQIK89xq+f7mChS/sk9jFbQUgqHGqNO6qJBvpu6RGcANml1
         BgErYjfhME1Be7Iw5hJcS90AxFwGFs4M3UG+SIZgVpycPQTXqZmJU9s+ki+FdBnrzjTC
         eYVFsfoTHgwFlA1EVpSSoKGblNANmWGaOji+es+E63Ss1vsEaliz3sei/N40KoTdwTsU
         hbYlg4tpK1N3M7s7LgnQJNDUMTO+7sWLZ4x/K3J5fNjjmOQtfU/ArNBYAoBk7UIfJJHm
         YS83oSM1QVxQMLKehhj04pZMMqilXqu9xOXSWyXd2PfTqbF257T6NVgaS7jDWqpTe8ys
         gqRw==
X-Forwarded-Encrypted: i=1; AJvYcCVDN0I7OxVAU0Wp7tEUY5pElkL0hypn+wAxHESmEFDT6HB/8YM/08plvvp4dvXskRAu7Vc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxuf7U2xsDt+E2AYSTDKpDcoUcimZk+E8PLynYDEh/UmDdD2uql
	5IArXkc/Grz6Ty3QVNcCXNPMCskk3WjTqs9YOpu3vNM5qnOjv7OHeMNQpm5OGc3EoIkVOdRGUvh
	eYNvPqFiwmUlPuHvIXPZOKx+R1E3P+WpMjNsr2kWO7/DrofYx7BdS6Q==
X-Gm-Gg: ASbGnctgvF4mQHai+Zz7nqjBRjOWZ1Jf5BCaf23Uk5n6Ch3WJXRWKP3tYuCXrkrQugz
	V+utRgRcrMiGWVm2ckK2XeP2s3mrxfzALSA/l/Q/apzRrt6l80tnJSam9E2X2tLQyrP2Sc812xZ
	2BGsSpCdS7KUEH875Ww5PE1EksXL2jP9/28vbzNZ0t1Ku/fCHF+0xsJM4hV6CJm/q0LqpjC7sDa
	sKswCNU4mcbCbSuQighuVlr/VdclBj91twEw98jnhlZ4ppgE+id57gNt5JdLzCXHzQ6jPJdw4jc
	/ZsDsnxRBsUlsnk7
X-Received: by 2002:a05:600c:5309:b0:453:8f6:6383 with SMTP id 5b1f17b1804b1-4538fe82d3dmr27458805e9.15.1751026741066;
        Fri, 27 Jun 2025 05:19:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8Y0sn1jx5MdC9w7dDN0iUWZm6OaT49+ak5Q8EkEy4A0S52w62hSdkOIT68jNHQ/zLuYwgmg==
X-Received: by 2002:a05:600c:5309:b0:453:8f6:6383 with SMTP id 5b1f17b1804b1-4538fe82d3dmr27458465e9.15.1751026740617;
        Fri, 27 Jun 2025 05:19:00 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152e:1400:856d:9957:3ec3:1ddc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538a390d3fsm50138915e9.1.2025.06.27.05.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 05:19:00 -0700 (PDT)
Date: Fri, 27 Jun 2025 08:18:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 net-next 4/9] vhost-net: allow configuring extended
 features
Message-ID: <20250627075441-mutt-send-email-mst@kernel.org>
References: <23e46bff5333015d92bf0876033750d9fbf555a0.1750753211.git.pabeni@redhat.com>
 <202506271443.G9cAx8PS-lkp@intel.com>
 <d172caa9-6d31-45a3-929c-d3927ba6702e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d172caa9-6d31-45a3-929c-d3927ba6702e@redhat.com>

On Fri, Jun 27, 2025 at 12:28:00PM +0200, Paolo Abeni wrote:
> On 6/27/25 8:41 AM, kernel test robot wrote:
> > kernel test robot noticed the following build warnings:
> > 
> > [auto build test WARNING on net-next/main]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Abeni/scripts-kernel_doc-py-properly-handle-VIRTIO_DECLARE_FEATURES/20250624-221751
> > base:   net-next/main
> > patch link:    https://lore.kernel.org/r/23e46bff5333015d92bf0876033750d9fbf555a0.1750753211.git.pabeni%40redhat.com
> > patch subject: [PATCH v6 net-next 4/9] vhost-net: allow configuring extended features
> > config: csky-randconfig-001-20250627 (https://download.01.org/0day-ci/archive/20250627/202506271443.G9cAx8PS-lkp@intel.com/config)
> > compiler: csky-linux-gcc (GCC) 15.1.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250627/202506271443.G9cAx8PS-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202506271443.G9cAx8PS-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> >    In file included from include/linux/uaccess.h:12,
> >                     from include/linux/sched/task.h:13,
> >                     from include/linux/sched/signal.h:9,
> >                     from include/linux/rcuwait.h:6,
> >                     from include/linux/percpu-rwsem.h:7,
> >                     from include/linux/fs.h:34,
> >                     from include/linux/compat.h:17,
> >                     from drivers/vhost/net.c:8:
> >    arch/csky/include/asm/uaccess.h: In function '__get_user_fn.constprop':
> >>> arch/csky/include/asm/uaccess.h:147:9: warning: 'retval' is used uninitialized [-Wuninitialized]
> >      147 |         __asm__ __volatile__(                           \
> >          |         ^~~~~~~
> >    arch/csky/include/asm/uaccess.h:187:17: note: in expansion of macro '__get_user_asm_64'
> >      187 |                 __get_user_asm_64(x, ptr, retval);
> >          |                 ^~~~~~~~~~~~~~~~~
> >    arch/csky/include/asm/uaccess.h:170:13: note: 'retval' was declared here
> >      170 |         int retval;
> >          |             ^~~~~~
> > 
> > 
> > vim +/retval +147 arch/csky/include/asm/uaccess.h
> > 
> > da551281947cb2c Guo Ren 2018-09-05  141  
> > e58a41c2226847f Guo Ren 2021-04-21  142  #define __get_user_asm_64(x, ptr, err)			\
> > da551281947cb2c Guo Ren 2018-09-05  143  do {							\
> > da551281947cb2c Guo Ren 2018-09-05  144  	int tmp;					\
> > e58a41c2226847f Guo Ren 2021-04-21  145  	int errcode;					\
> > e58a41c2226847f Guo Ren 2021-04-21  146  							\
> > e58a41c2226847f Guo Ren 2021-04-21 @147  	__asm__ __volatile__(				\
> > e58a41c2226847f Guo Ren 2021-04-21  148  	"1:   ldw     %3, (%2, 0)     \n"		\
> > da551281947cb2c Guo Ren 2018-09-05  149  	"     stw     %3, (%1, 0)     \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  150  	"2:   ldw     %3, (%2, 4)     \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  151  	"     stw     %3, (%1, 4)     \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  152  	"     br      4f              \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  153  	"3:   mov     %0, %4          \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  154  	"     br      4f              \n"		\
> > da551281947cb2c Guo Ren 2018-09-05  155  	".section __ex_table, \"a\"   \n"		\
> > da551281947cb2c Guo Ren 2018-09-05  156  	".align   2                   \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  157  	".long    1b, 3b              \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  158  	".long    2b, 3b              \n"		\
> > da551281947cb2c Guo Ren 2018-09-05  159  	".previous                    \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  160  	"4:                           \n"		\
> > e58a41c2226847f Guo Ren 2021-04-21  161  	: "=r"(err), "=r"(x), "=r"(ptr),		\
> > e58a41c2226847f Guo Ren 2021-04-21  162  	  "=r"(tmp), "=r"(errcode)			\
> > e58a41c2226847f Guo Ren 2021-04-21  163  	: "0"(err), "1"(x), "2"(ptr), "3"(0),		\
> > e58a41c2226847f Guo Ren 2021-04-21  164  	  "4"(-EFAULT)					\
> > da551281947cb2c Guo Ren 2018-09-05  165  	: "memory");					\
> > da551281947cb2c Guo Ren 2018-09-05  166  } while (0)
> > da551281947cb2c Guo Ren 2018-09-05  167  
> 
> AFAICS the issue reported here is in the arch-specific uaccess helpers
> and not related to this series.
> 
> /P

I think it's due to code like this in your patch:

+                       if (get_user(features, featurep + 1 + i))
+                               return -EFAULT;

the specific arch might have a bug that this is unconvering,
or a limitation, I can't say.

Seems worth fixing, though.

Poke the mainatiners?
-- 
MST


