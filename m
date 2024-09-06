Return-Path: <kvm+bounces-26004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3205F96F2BE
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 13:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFB001F2321C
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 11:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061851CB33E;
	Fri,  6 Sep 2024 11:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oiTFTX09"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0DD1CB33F
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 11:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725621568; cv=none; b=uz5TDL6eqytJO63C7t8qcwKvW/rKaPnnfkfxH9Mm0qSxrj3LhdCjAI/b1sDiite955R4mEi3K1mASft95RAaTy0SqdKFBocwPsRH6tE4ANCYebwa+Hp4bqBGcnOeHLVZWgJJW3ydOetMQswxgyvAMrYmA5yVY/9OQwMn3LJGPBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725621568; c=relaxed/simple;
	bh=vTXh2jfXglCKeDT3dSSr+fZshCnSK18p1ShB3uHeRz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iF8MYnWMUA4l80avkplBx6TQjdrVRdiorLsEqMPh8Y8petqqPVRT27YGL5zdi9LLPTm4R08CeNXmN3wLW0/v6YnPj8c71n1CkCinKGj2I2pDJtI87thSHvZZUYoXnRQbdsumzxn6RLvRY84i0vZDyRadTQwAHGm6pJMu2+8DFVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oiTFTX09; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42ba8928f1dso35875e9.1
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2024 04:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725621565; x=1726226365; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Udbu1uIWP4j4MINPqgqM58X+79eAgEAS4xRqqOQw2xU=;
        b=oiTFTX09pITnbGc6CcNJCqb6xTAD+W1gzWR4LG4Vt4zC6XWKcZSMfxhbgyVl3SB4DR
         hMBZ+QmayT/YA9FhEzLhrssEDWiYPGR1dEcijQ/Mw8IetnjZk5ezKtYGZmKbOhM4D/xE
         VJ8jYUZmXHH/TCTXxdJWF01ED3MrBhyhCEZmGFET4gjVzUm0EjN7QwEKDtOlkAavCRx/
         FBD/WsQxiWiP/X6RjY0Ug672KGDro3SZAY9xYXeENGQprugurfQaRAOwcTPRUdwEoZ26
         RIp5nKlkv4KfO+Gtc7l+T3puxQITOA0/bMSQJ/ojfs8pdV6zZ+qE21OD3cQJOlQw/cg3
         0vPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725621565; x=1726226365;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Udbu1uIWP4j4MINPqgqM58X+79eAgEAS4xRqqOQw2xU=;
        b=eLTXMMLVnTTGUSXnjf05P0ViGb0FKuZ0x9I/k3ACrmRdUDOMc1CMXmWL+UIrMEh18K
         DNtp3j9y/a3BBCWfJO64NQX/OiAd1w+Ugx5XngieGl9PPXE2NZmHrupiKz0yS1jfcXSQ
         YEEsG7Waq3CA8qRcfaELv9M9J5z1YqZYn9AnaRXR5K7i8tvTIFi2LW/UV8n9k2D480H4
         9Wr7AdZTLBwk8mmoTGTz6gW/W4vmlf4LF4wYzIP0vzcjMEGVQ/Z6KHDMSe+4pt16egYl
         jGb8YQiDzV3VZV6+EyD6j+nJbQLV1HX0qyW4lJckRakffbRqVEcpk6XwBRsJEWjz8JLF
         S7rA==
X-Forwarded-Encrypted: i=1; AJvYcCXkieDk+UrSK/KN3I/T5aKgwsudjnKTrELC1rJHYG4y7F+zVloH6vMz5PFaBHJgLdiM7mM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpwoLuhHv9p3FIUDSqqu5VFNjLmmba2/XXEfdw2Z1Dwky0PQq5
	uhB55J+QZakde7zK5S7I+F5goPwSsTsg6Sy//tsfUmrqq3XVJaessgQECpdULA==
X-Google-Smtp-Source: AGHT+IF28frk+mNvBQvzqNFR1XDVIRQtdpQ86tusQ1uuAu2EpW1M17z6bTXUWoFUjfxKXzcEdY+eFA==
X-Received: by 2002:a05:600c:cc3:b0:42c:9e35:cde6 with SMTP id 5b1f17b1804b1-42ca0592bbemr713575e9.2.1725621564295;
        Fri, 06 Sep 2024 04:19:24 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ca05ca63bsm17229795e9.12.2024.09.06.04.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 04:19:23 -0700 (PDT)
Date: Fri, 6 Sep 2024 11:19:20 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	"acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <ZtrlOCUoUKNfHvd_@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
 <20240830171602.GX3773488@nvidia.com>
 <ZtWPRDsQ-VV-6juL@google.com>
 <20240903001654.GE3773488@nvidia.com>
 <ZtbKCb9FTt5gjERf@google.com>
 <20240903234019.GI3773488@nvidia.com>
 <9e8153c95b664726bd7fcb6d0605610a@huawei.com>
 <20240904120103.GB3915968@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240904120103.GB3915968@nvidia.com>

On Wed, Sep 04, 2024 at 09:01:03AM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 04, 2024 at 07:11:19AM +0000, Shameerali Kolothum Thodi wrote:
> 
> > > On Tue, Sep 03, 2024 at 08:34:17AM +0000, Mostafa Saleh wrote:
> > > 
> > > > > > For example, KVM doesn’t allow reading reading the CPU system
> > > > > > registers to know if SVE(or other features) is supported but hides
> > > > > > that by a CAP in KVM_CHECK_EXTENSION
> > > > >
> > > > > Do you know why?
> > > >
> > > > I am not really sure, but I believe it’s a useful abstraction
> > > 
> > > It seems odd to me, unpriv userspace can look in /proc/cpuinfo and see
> > > SEV, why would kvm hide the same information behind a
> > > CAP_SYS_ADMIN/whatever check?
> > 
> > I don’t think KVM hides SVE always. It also depends on whether the
> > VMM has requested sve for a specific Guest or not(Qemu has option to
> > turn sve on/off, similarly pmu as well).  Based on that KVM
> > populates the Guest specific ID registers.  And Guest /proc/cpuinfo
> > reflects that.
> > 
> > And for some features if KVM is not handling the feature properly or
> > not making any sense to be exposed to Guest, those features are
> > masked in ID registers.
> > 
> > Recently ARM64 ID registers has been made writable from userspace to
> > allow VMM to turn on/off features, so that VMs can be migrated
> > between hosts that differ in feature support.
> > 
> > https://lore.kernel.org/all/ZR2YfAixZgbCFnb8@linux.dev/T/#m7c2493fd2d43c13a3336d19f2dc06a89803c6fdb
> 
> I see, so there is a significant difference - in KVM the kernel
> controls what ID values the VM observes and in vSMMU the VMM controls
> it.

Yes, that’s for guests.

What I meant is that the host sysregs are not read from userspace which
is the synonym of reading SMMUv3 IDRs from userspace, instead the kernel
controls what features are visible to userspace(VMM) which it can enable
for guests if it wants, as SVE, MTE...

Thanks,
Mostafa

> 
> Jason

