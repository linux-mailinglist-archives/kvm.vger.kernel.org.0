Return-Path: <kvm+bounces-19782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C69E90B2A0
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21FAE1F26C49
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 14:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283C01D052C;
	Mon, 17 Jun 2024 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQKPf0Iq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743F11CF3FD;
	Mon, 17 Jun 2024 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718632264; cv=none; b=bTirE9dSE3NmoVZu+hH+I8X8BvI5i9HPoMYyAc3zFEJCLBB2qLuoh6vONS0Cnhba/wYRQAM7HTnd7rRw+S5iEsJ5EfgfDSsRDU4buOcJdmB9uV0qOZYofpY+zPPg1jj8Yi5S6hbLxFAC0J0JkDvJ+xFLD497TOCNbaslEXzD/1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718632264; c=relaxed/simple;
	bh=WxO8wJJZE1Xds5hTG7TDExzo+Qsu32A6Rbf++HOL+EU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GpvFiYgvD/axcnwSi4Jgr7aJ6itQPCQO8b4p/elxCZjQOoTgIddOX6Dhp9XkxoDp85qYzXMtFdDI6f0+ZRPguY2CDk97D7/Qq308weuh1K1oQazH1REZa2zTKlhjS/kAEQal6QRt/hP7zveLTbDw5JRSvWcc4ij4p0nDNATGbFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TQKPf0Iq; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52c9034860dso5472308e87.2;
        Mon, 17 Jun 2024 06:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718632261; x=1719237061; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7cjNgaPzx0K8Q2oE0VGfsHosS8QVWGPVVkZ0XS7HEDg=;
        b=TQKPf0IqytFGGsqE2xDfJV+Yc75aA1GVgfltTY4XrrInwMIVCjx3BGZ2HlTDbMRnwJ
         XRHsBKL6tbX9NklWtBn9G1kVOhmNQf4sMe56ykL4PUGZ+bBMRgt1fz+lzjHrFshmpNxt
         3Ehb8nqYu4SNJbsYu2Bwvhy5GBpgF65YoUnh7r2JG0a43q7ag4ikgaBefGieszSUKUWC
         +u/2IQY8h9V7c0/zz5Hxr4gjkM5QFZr/JR/tjbY6QKgCwcETuc+nXlJJ6diNXpu3XsHz
         D8kOZYnSg7vFdFf8AIlVMJziVAtBXbYMqyg1pq73R2g3Q6wjMqZRH9KgQeucspWy6cKp
         Dkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718632261; x=1719237061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cjNgaPzx0K8Q2oE0VGfsHosS8QVWGPVVkZ0XS7HEDg=;
        b=S5d4QM/PuVCo0B+/u/BEqzUjwZ8ms1Lw1DBKm5kTN5i6tr3nlSagb4MBnIrTIWsJkg
         Pz7MfNY025VUpsD0JIgCOOo2f989iq+vCYGHpAK5rYzwOvyvahVKnZUBkEEGPTzs0ojV
         7eCXSFUwbNm0pYkPZi2TWrWueX6THHNq5uxskxggkRuRVlqhvKeTRw0n4+/uvcLVDfaN
         XEoJ0SGtVT/3xSvVtGkHyRTi0vGthUKB+VLI7LkXgTGq9J0cnLB3GjynDlO13N76kTc9
         gLKiczHppRV8IEEF4H81SgrEJzU3LsRF4z/Tfgj/FbUAFIDKm+nRt8xX1XbxuX0WAWU/
         0/Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVry97e54w1jMONLsqTN3iQPG8Q/In8s2mmyp6yrh7swqNFmafo9ZrgACCJX413o79jJuAlozTDaI+xcffuD2a5oica049dt4qVMgnn+hu+Gj46IWYL8/upcCeT9Ph6+wWA9I7QGpkoDsP9X71dG/ly8osgu3lDA5aLHV7x7pYU3aAKY4bFjE91XHnVURxT9u06fOl7UhoVEIbupdMaczqYAuW50sNXHyAufRcxsimtk0hVPg/ceQqUXExfaK9u8445wj2+eF8eukwbHmcAObsoR6M/jSKqKlpV6qswmF0/JGIQRlk3Ttq4B4M3JY4XibBSRdmOAhFM4yG1momRIxQif0HajIWaLUvjmSCH1ZKw0P4cy2wRMTqHmayzjPiaExUbrndO7xOupsbjVLTMZEPOmoXJAR45vaR2SaEb5rVLzuHiIvlvuB0/GspkTg==
X-Gm-Message-State: AOJu0Yx44HaNSMGdV8qLfWJ7IGbEjTpeF3P27BEN/w/6rJODn8eFFjCW
	GMV8zZ9B7K28Z7pPIpftBQfPKUcN3OdYimvSvk9ZIElfLSUFCAPd
X-Google-Smtp-Source: AGHT+IHJ0CsNfqdOT8NJ8/aEvcd12bZPn1WcmZOT2dLARsLKNTs8V+RbkzjWhHb4g1pZvloY+oCxkw==
X-Received: by 2002:a19:5e15:0:b0:51d:9f10:71b7 with SMTP id 2adb3069b0e04-52ca6e6812fmr7404820e87.28.1718632260306;
        Mon, 17 Jun 2024 06:51:00 -0700 (PDT)
Received: from pc636 (host-90-233-216-238.mobileonline.telia.com. [90.233.216.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca2887d56sm1239456e87.263.2024.06.17.06.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 06:50:59 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 17 Jun 2024 15:50:56 +0200
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>, linux-block@vger.kernel.org,
	kernel-janitors@vger.kernel.org, bridge@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nicholas Piggin <npiggin@gmail.com>, netdev@vger.kernel.org,
	wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
	ecryptfs@vger.kernel.org, Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>, linux-nfs@vger.kernel.org,
	linux-can@vger.kernel.org, Lai Jiangshan <jiangshanlai@gmail.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <ZnA_QFvuyABnD3ZA@pc636>
References: <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
 <Zmsuswo8OPIhY5KJ@pc636>
 <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <ZmybGZDbXkw7JTjc@zx2c4.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmybGZDbXkw7JTjc@zx2c4.com>

On Fri, Jun 14, 2024 at 09:33:45PM +0200, Jason A. Donenfeld wrote:
> On Fri, Jun 14, 2024 at 02:35:33PM +0200, Uladzislau Rezki wrote:
> > +	/* Should a destroy process be deferred? */
> > +	if (s->flags & SLAB_DEFER_DESTROY) {
> > +		list_move_tail(&s->list, &slab_caches_defer_destroy);
> > +		schedule_delayed_work(&slab_caches_defer_destroy_work, HZ);
> > +		goto out_unlock;
> > +	}
> 
> Wouldn't it be smoother to have the actual kmem_cache_free() function
> check to see if it's been marked for destruction and the refcount is
> zero, rather than polling every one second? I mentioned this approach
> in: https://lore.kernel.org/all/Zmo9-YGraiCj5-MI@zx2c4.com/ -
> 
>     I wonder if the right fix to this would be adding a `should_destroy`
>     boolean to kmem_cache, which kmem_cache_destroy() sets to true. And
>     then right after it checks `if (number_of_allocations == 0)
>     actually_destroy()`, and likewise on each kmem_cache_free(), it
>     could check `if (should_destroy && number_of_allocations == 0)
>     actually_destroy()`. 
> 
I do not find pooling as bad way we can go with. But your proposal
sounds reasonable to me also. We can combine both "prototypes" to
one and offer.

Can you post a prototype here?

Thanks!

--
Uladzislau Rezki

