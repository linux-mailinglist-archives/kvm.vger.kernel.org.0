Return-Path: <kvm+bounces-33910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AFB29F46A3
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 09:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 239A81889646
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 08:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE58C1DE2D8;
	Tue, 17 Dec 2024 08:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jFCw6vNY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF7A192B66
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 08:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425841; cv=none; b=QzpibvsYd1TrjAgJTx5cncos8JqmyySKwJabM6Bop8lH4iPL/NBcbYpuF+AA4saWDSnqXCQzM02wMfNZq3IWAKo6keVGsYWU2AklKjLMeY7WvQJ8ay8rUTsw24iyQWfT9A0co2YOa6Ez7whUuJRYHBaMv9atDI4oZzgiHzuoCgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425841; c=relaxed/simple;
	bh=my89gapazaRXABx0ds8EDdV5LyYYL2x4cidIM74wTVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBC1brqDFL/oUPaxAtll8ORaa9tuNUvaIqkY0sLdMYseuH/33h6Yq2m7tGRDLYNMUjeODlbQv/E2hrZq4TNFMVY3Oc2+IqqQqh110l5oUW1Td0mhgeThJkfg19BlwtU/vBLgh8mfhSyiXqh5HO8weOqqmNQe/n5esFYSFKUziN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jFCw6vNY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734425838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e36MqRAUUxdsVobCeHh3rEjTnXYHMB/28HuSecqnBzU=;
	b=jFCw6vNYan504jBB4wZB9SbjOBHITFDAg51rRIikZ7zjte6SXLjM/ETav1Ygwe83k4CPOC
	oD+jYi+rXshEBZItmoOMRk4oY0ow1pIsK2lMWH8W+CYbdYhA9O5XM+VKvZigpYKLYtaT9d
	lzo7CeluNgWScLqOV8HwGU5dB5zDbxA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-3L0nztTZPjGW9DtLi7gXvQ-1; Tue, 17 Dec 2024 03:57:17 -0500
X-MC-Unique: 3L0nztTZPjGW9DtLi7gXvQ-1
X-Mimecast-MFC-AGG-ID: 3L0nztTZPjGW9DtLi7gXvQ
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6d8f0b1023bso56485106d6.0
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 00:57:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425837; x=1735030637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e36MqRAUUxdsVobCeHh3rEjTnXYHMB/28HuSecqnBzU=;
        b=WM9EwwXzD3dKmKiZF9V1er0Y54IZF97YyWNxSvOA4w55cF1mfl8itrwQoMSZa5WPlI
         cqx8wJ7QAgof6iDUZ/p9YrP46+ufsRJNSGD7dd9M+a/1kpv7id93fGo9EwblOtArqh6b
         odr0XDiVzYhxylIqNz5ME3BUBURtVtYYvHDBTPdtQjyMJwwEspGVd5CuIncZ6rckf87I
         Cpc7a+xBYtn3/2uEtHSslFGYfU1mGM6CZese07KD6IOH+7GCaO4tK0z5cldJ0ve2qTLt
         85KQ1Z/FCCGylwDHBpQLi14NLQfLytv4HXxeOB1b3w6pLwT+IBRfFuez2C6zf/jdmer/
         p2iA==
X-Forwarded-Encrypted: i=1; AJvYcCVdYkptn1AN/5FGjaIlLB23F3tMBEESuxQ1fzyPPSGYw0BwUoEQt8PZE/HuHEjOmPhHWl8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxU8wlnNMMjdRTATyKHG8GDjUIwtrKOxK5yTV6Ni5JCZJWDsNee
	MqxU7HJICWGtrRo2XtjJ29PtJza1a+tygWsENwJIFBJHu4PED53wMZI9zKKfO7rigcX57aaSPuB
	J7mPPaRnlDvm42iSrMFAQTWr8f/tJ/6nigztBP1kMu044WaQRtg==
X-Gm-Gg: ASbGncsoGgK55IOo2Nd5fYgF8jwddCMUmWtL20nvaAyIXpGfilNn4/eiKDsbErGVpjj
	7CqEvrWUBy95cnTrYiagAeS1+3sQRjGPSClZwwOyX9T/98g8w8NWOLMB+IKvwAU94SWS1sYAgJQ
	JdqpQAInkDp7VmncY6WPDXy6bFbRpjiCcmFH/6eom2kpQHJG0unr2DBS173p2soNNTnbq2fcGee
	6x/1KKaYFPjcXBlf8X+ZyTSwNaZx4AxTfj5YcBLBi3MLBDFRFXsqNJWjTF6orQjx5VY2kURZu3R
	glErqJYqnp16qwyU5/sNm1Y3yYvUgr1bdnUng2uI1pw=
X-Received: by 2002:ad4:5c6f:0:b0:6d8:a32e:8426 with SMTP id 6a1803df08f44-6dc86ad7976mr257129846d6.3.1734425837029;
        Tue, 17 Dec 2024 00:57:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7OHDlYB62X/RjbCS6tlztv/Jo/Zkez7NULudfz1M3aDsbY23BSx9G1w3C9AIZrsP6H+k8zA==
X-Received: by 2002:ad4:5c6f:0:b0:6d8:a32e:8426 with SMTP id 6a1803df08f44-6dc86ad7976mr257129666d6.3.1734425836698;
        Tue, 17 Dec 2024 00:57:16 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb (host-80-40-237-196.as13285.net. [80.40.237.196])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dccd25a0c9sm36322796d6.33.2024.12.17.00.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 00:57:16 -0800 (PST)
Date: Tue, 17 Dec 2024 08:57:11 +0000
From: Juri Lelli <juri.lelli@redhat.com>
To: Ranguvar <ranguvar@ranguvar.io>
Cc: Sean Christopherson <seanjc@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@gmail.com>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>,
	"regressions@leemhuis.info" <regressions@leemhuis.info>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM
 guest
Message-ID: <Z2E858-8jA6_xWFd@jlelli-thinkpadt14gen4.remote.csb>
References: <jGQc86Npv2BVcA61A7EPFQYcclIuxb07m-UqU0w22FA8_o3-0_xc6OQPp_CHDBZhId9acH4hyiOqki9w7Q0-WmuoVqsCoQfefaHNdfcV2ww=@ranguvar.io>
 <20241214185248.GE10560@noisy.programming.kicks-ass.net>
 <gvam6amt25mlvpxlpcra2caesdfpr5a75cba3e4n373tzqld3k@ciutribtvmjj>
 <Z2BaZSKtaAPGSCqb@google.com>
 <b6d8WzC2p_tpdLs36QeL_oqtEKy_pRy-PdeOxa08JtTcPhHNNOCjN73b799C0gv8NnmIJKH9gD6J4W-Dv5JKEVdrbMoVUp3wSOrqEY_LrDg=@ranguvar.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6d8WzC2p_tpdLs36QeL_oqtEKy_pRy-PdeOxa08JtTcPhHNNOCjN73b799C0gv8NnmIJKH9gD6J4W-Dv5JKEVdrbMoVUp3wSOrqEY_LrDg=@ranguvar.io>

On 16/12/24 20:40, Ranguvar wrote:
> On Monday, December 16th, 2024 at 16:50, Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Mon, Dec 16, 2024, Juri Lelli wrote:
> > 
> > > On 14/12/24 19:52, Peter Zijlstra wrote:
> > > 
> > > > On Sat, Dec 14, 2024 at 06:32:57AM +0000, Ranguvar wrote:
> > > > 
> > > > > I have in kernel cmdline `iommu=pt isolcpus=1-7,17-23 rcu_nocbs=1-7,17-23 nohz_full=1-7,17-23`. Removing iommu=pt does not produce a change, and
> > > > > dropping the core isolation freezes the host on VM startup.
> > 
> > As in, dropping all of isolcpus, rcu_nocbs, and nohz_full? Or just dropping
> > isolcpus?
> 
> Thanks for looking.
> I had dropped all three, but not altered the VM guest config, which is:
> 
> <cputune>
> <vcpupin vcpu='0' cpuset='2'/>
> <vcpupin vcpu='1' cpuset='18'/>
> ...
> <vcpupin vcpu='11' cpuset='23'/>
> <emulatorpin cpuset='1,17'/>
> <iothreadpin iothread='1' cpuset='1,17'/>
> <vcpusched vcpus='0' scheduler='fifo' priority='95'/>
> ...
> <iothreadsched iothreads='1' scheduler='fifo' priority='50'/>

Are you disabling/enabling/configuring RT throttling (sched_rt_{runtime,
period}_us) in your configuration?

> </cputune>
> 
> CPU mode is host-passthrough, cache mode is passthrough.
> 
> The 24GB VRAM did cause trouble when setting up resizeable BAR months ago as well. It necessitated a special qemu config:
> <qemu:commandline>
> <qemu:arg value='-fw_cfg'/>
> <qemu:arg value='opt/ovmf/PciMmio64Mb,string=65536'/>
> </qemu:commandline>
> 


