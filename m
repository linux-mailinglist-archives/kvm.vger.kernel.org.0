Return-Path: <kvm+bounces-27348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A430E984267
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 592DE1F21032
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 09:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83629157468;
	Tue, 24 Sep 2024 09:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="an+0u5Rf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E61D15533F
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 09:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170859; cv=none; b=KZpdf4AYsiZrbysfV0YTlaDsyvIFAVbFKIYBY+rdLilmysk4+qBFStYEhmfzLrwDX6MWSEW5MmArfmPxfIAMBS06BPDWTZwlfO0oSpo/XyFsAHe5Qr3apu6vDBmoOb2C6xIpBBSD7SN3PVYcJz5Y3f+iMVss++oEUecDaI53bW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170859; c=relaxed/simple;
	bh=lWmCJtqv+vQCD54caHjbHBNnTILSelPZSN58h8zdfU0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvjBTXHrwIdYRvPrp3ImnJd886/KBFtFgpyd7bFcx27dVmBbBfE0KH/V5Uw1Xv4CUSo622hyv9MyB5y0NhVJM8fDnA2pmugvTUA+00v4zfcodJkSSOoBIHJx/881OApq7QiP6wroM5dqwaRzNJqRzXXA8Sgo4+1iBCtwl3tDE4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=an+0u5Rf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727170857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VJB7ipz46koHNrHbD2B3lzoMb/WDq9C6nVfTbT9ZPF0=;
	b=an+0u5RfyDavY2F6ZoyAGxX0he0mgDddtGXKdg9tV8Cp1Pr3+85nfdI4FO5Wws9zdoy10O
	yy0TMu5dKumCNNpziizRCZ1PNBecnWncIhFQ8KgDv/QoZ4LgrYGuJ8buFfnYmwjYJK6r4F
	9IKsng9DaEktHgc5dsYGObdrNih0Ma8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640--njKLk-tOn6IDgN1k0O2vQ-1; Tue, 24 Sep 2024 05:40:55 -0400
X-MC-Unique: -njKLk-tOn6IDgN1k0O2vQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374ba33b2d2so1613943f8f.2
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 02:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727170854; x=1727775654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VJB7ipz46koHNrHbD2B3lzoMb/WDq9C6nVfTbT9ZPF0=;
        b=g/POzJpcuRJBDVYmBlCxz10vO6klIkX4ZClKC8qykx88slEIG0L3FncCpnVlMMb9B5
         AWS1q4mjyKLgB2Q6llH6wgkJ17cPb5iCD9F5DKDxmP1sa7wWJqU4Fu/8o1o3KaoO97vC
         O4iFz/saUXGYQtJTxfKuY7OhH0foAiUPmkeQbaEFFeA7LjJA+wjKPW+1gH7LDA8D8Gdb
         3lKLcXCkxEfWDwdlTKwRHQsfiIXuWZmsV6N5lpQbm3CiP5qcC/bKzCl03mpBMHw2iEMJ
         Tk+i9o2y/k0bMXo7MHwteDYhkYYv474LLrijGVf+Q00Ml/17kVUHDZoJE325TsVO8Smc
         HyCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDnxIfjzxTm+KgrZKQ/zHCSfWbbivM1iSH5t0TC5Urp6jMaS7BpMrExB2IAONGC1CTaXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO6iF1owyFe0CIcA8gUz3b1sKvs7zH7eTKIrF0R7LogCCAeR0H
	AkohxxKSokbN/Lq9oVdHPF/veh4ST8LN2UTEj6+ATvqvVRn9zEszcUIMP2okjH0iICCtI2kMCAW
	ES3GwU4Ey9eRxxoGlO7EDcE5x5B0wlnsFcapwkKYS4vmEtmGKYw==
X-Received: by 2002:a5d:42d0:0:b0:375:56ed:a3a0 with SMTP id ffacd0b85a97d-37a4236e123mr8350630f8f.43.1727170853824;
        Tue, 24 Sep 2024 02:40:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtt9E1Goeg1abwDliN1EoQRDnu8vzFS6ICWKIFrsgHRaj8NAcm408nZayZB+C2juZ13OwrcA==
X-Received: by 2002:a5d:42d0:0:b0:375:56ed:a3a0 with SMTP id ffacd0b85a97d-37a4236e123mr8350617f8f.43.1727170853434;
        Tue, 24 Sep 2024 02:40:53 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc2f9669sm1093440f8f.68.2024.09.24.02.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 02:40:52 -0700 (PDT)
Date: Tue, 24 Sep 2024 11:40:51 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: boris.ostrovsky@oracle.com
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Eric Mackay <eric.mackay@oracle.com>
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
Message-ID: <20240924114051.1d5f7470@imammedo.users.ipa.redhat.com>
In-Reply-To: <534247e4-76d6-41d2-86c7-0155406ccd80@oracle.com>
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
	<c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
	<66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
	<CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
	<77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
	<Zh8G-AKzu0lvW2xb@google.com>
	<77f30c15-9cae-46c2-ba2c-121712479b1c@oracle.com>
	<20240417144041.1a493235@imammedo.users.ipa.redhat.com>
	<cdbd1e4e-a5a3-4c3f-92e5-deee8d26280b@oracle.com>
	<534247e4-76d6-41d2-86c7-0155406ccd80@oracle.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 Apr 2024 12:17:01 -0400
boris.ostrovsky@oracle.com wrote:

> On 4/17/24 9:58 AM, boris.ostrovsky@oracle.com wrote:
> > 
> > I noticed that I was using a few months old qemu bits and now I am 
> > having trouble reproducing this on latest bits. Let me see if I can get 
> > this to fail with latest first and then try to trace why the processor 
> > is in this unexpected state.  
> 
> Looks like 012b170173bc "system/qdev-monitor: move drain_call_rcu call 
> under if (!dev) in qmp_device_add()" is what makes the test to stop failing.
>
> I need to understand whether lack of failures is a side effect of timing 
> changes that simply make hotplug fail less likely or if this is an 
> actual (but seemingly unintentional) fix.

Agreed, we should find out culprit of the problem.

PS:
also if you are using AMD host, there was a regression in OVMF
where where vCPU that OSPM was already online-ing, was yanked
from under OSMP feet by OVMF (which depending on timing could
manifest as lost SIPI).

edk2 commit that should fix it is:
    https://github.com/tianocore/edk2/commit/1c19ccd5103b

Switching to Intel host should rule that out at least.
(or use fixed edk2-ovmf-20240524-5.el10.noarch package from centos,
if you are forced to use AMD host)

> -boris
> 


