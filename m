Return-Path: <kvm+bounces-54652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C802BB25F2E
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 10:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 820581890BA0
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 08:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E392E7F08;
	Thu, 14 Aug 2025 08:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="V33sZnzp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AA028980F
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 08:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755160774; cv=none; b=svYoDf0zg/j0JPgtrRykk0gC7DQ8IkvWBQtHG087L/uhpdYLM2owZ0kIXzduDeDFAjDKu9PUdW29UG9AsKJUHgUB4exWK0qMEmHREttgGKI2g/9EH1Euxc7QNkxvpVs03zMpL9Ag2pHirPxMgvgfTqLyb/cqbCaD3UPH7lwb1KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755160774; c=relaxed/simple;
	bh=Wpbxg3H5mCQHzc9FzegnauThTQb61yXXabG0/RYvfBI=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rkSpz3jF1MlqE1kKclEGvndqrYNaa8e+1J0xzxkIshConHvB7h8npT2SoKDEhdvktTJIlKF+W2wemW/zGs/VQyJ+EEsesK/zgiUMTn2g7yCuf23BK6WMq5HQznesifwVM0SjpL2qq+5b69Yjo+9CeXFPCeC8bzxw1DHZDKayICs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=V33sZnzp; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755160773; x=1786696773;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=AvhqSFjwyxqluqp6bXu9ihws/0g/zKYoTaLBSW/ZUWE=;
  b=V33sZnzpFll9y8byiTA3Cdr1XyOXirTIrPYbzLQAbAOV6w0hqMwVzMpD
   cdOqkKWPVQ4XKeAy9IEBZe1gEXeEg1P6KHCcu99rOcGRvz9VwMmxjBQ9j
   FZH2gerJDP8w6py/I3hRoLnnVeAq5BAlm59RBDnULzl47do74Z29aPfRY
   xwyD8n6nW/mSxo3YrCTo5t9/GHAZyQyrsHFoUtdI11tvGkzofmQe/AUl3
   YwI5yi5qmkEiZIE0ZhkjiYqaF6mpipaJMO8bsxDyUtOeWUXC3fyqfa82B
   PtL2F1XgFwF+UkECujCPc4AuhtzHuIM3i211GWi2nuQhR3Oj4fzzA9qR/
   A==;
X-IronPort-AV: E=Sophos;i="6.17,287,1747699200"; 
   d="scan'208";a="74741271"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 08:39:31 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:61872]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.12.183:2525] with esmtp (Farcaster)
 id 275213a7-1ace-4a77-a80f-cbb71ad9e820; Thu, 14 Aug 2025 08:39:29 +0000 (UTC)
X-Farcaster-Flow-ID: 275213a7-1ace-4a77-a80f-cbb71ad9e820
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 14 Aug 2025 08:39:29 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Thu, 14 Aug 2025
 08:39:26 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt
	<benh@kernel.crashing.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Kumar, Praveen" <pravkmr@amazon.de>, "Woodhouse, David" <dwmw@amazon.co.uk>,
	"nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
In-Reply-To: <20250811160710.174ca708.alex.williamson@redhat.com> (Alex
	Williamson's message of "Mon, 11 Aug 2025 16:07:10 -0600")
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805130046.0527d0c7.alex.williamson@redhat.com>
	<80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	<20250806115224.GB377696@ziepe.ca>
	<cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
	<20250807130605.644ac9f6.alex.williamson@redhat.com>
	<20250811155558.GF377696@ziepe.ca>
	<20250811160710.174ca708.alex.williamson@redhat.com>
Date: Thu, 14 Aug 2025 10:39:23 +0200
Message-ID: <lrkyq7bz6uwjo.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EX19D037UWC003.ant.amazon.com (10.13.139.231) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)

Alex Williamson <alex.williamson@redhat.com> writes:
>
> Currently we have a struct vfio_pci_region stored in an array that we
> dynamically resize for device specific regions and the offset is
> determined statically from the array index.  We could easily specify an
> offset and alias field on that object if we wanted to make the address
> space more compact (without a maple tree) and facilitate multiple
> regions referencing the same device resource.  This is all just
> implementation decisions.  We also don't need to support read/write on
> new regions, we could have them exist advertising only mmap support via
> REGION_INFO, which simplifies and is consistent with the existing API.

Are proposing an API that creates a new region, which the user then uses
the return index with REGION_INFO to get the pgoff? It seems we are just
adding one more syscall the user have to call before getting the
pgoff. But the end goal is technically the same...



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


