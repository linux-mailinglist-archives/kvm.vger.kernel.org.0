Return-Path: <kvm+bounces-56454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D49B3E69F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 879B8205B3F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60046340DA2;
	Mon,  1 Sep 2025 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="IeHKIisd"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551B3313E23;
	Mon,  1 Sep 2025 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.199.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756735529; cv=none; b=Lom2AAbhvCcaP5fLRJGI1HVU5iqr38vPDelz1RZkn99VMMKeUwaUHZ6GTwWFB+qqXTe5E5WOXbMYBa97fEyd8OxxUd4l9BfRcvyY+2EK0HHk7Z/0u3ndF1r3Rv2NpjmyQ9Lk7TThDVi4wKtGPnpMgaEaKhzVxv6vh3EGqlbgm3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756735529; c=relaxed/simple;
	bh=ItZqN5Op7g9rIJ5RShixnsRk5gMblgw67xQPu8prjug=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OYnPokyvvcm+u4OyU5xBezzE3pU9q7bA+B6i84FxKrmRkIoRxgsLkVyjE7nZa/BVSyKwQxEfsK39LuoOVyO+zAMY1f6JRwyXDPTer9xDe8DAYSn630h7pS1y3TmuEIM10hqqo5548PIIBILBLesmwFUBow86Hf4izUEJqrefklE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=IeHKIisd; arc=none smtp.client-ip=18.199.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756735527; x=1788271527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kse27neqs7TZ5sTIdJhbs0CXmugDWDcv4gD+1oQQ4ac=;
  b=IeHKIisdRCXoZ5+V441l9oXqa7nrbEkpfLyaC0umnYkFL/LbuVXeiFnj
   BhgsLae20Tlq1w4DSiqC48YHBv+GVqku1yOGfD0fdk6/0lZGbRbuiGVWP
   63r5/nUvd6FMLgpueoH8UgaLfdkjnUSJeOhhv3YaOBZo4m7adb83Tpa7G
   lfEYZRYD4j3yDKoylKH9GKksATNVzCcNeDSd78BLXHlvXyVtH2rIYdW5r
   V7xIJkNaGSvlKMF9+nKvGVtRSIK2LFwVGLqshvlOG5z/KI1SM1ErRbR2q
   tT5PMXQRYJ+SO91KGf1UA/nn9gscfAZJhw0SoT80PRAyGPEepUT8AgZWr
   Q==;
X-CSE-ConnectionGUID: 6cHdMLo7TCuPNE/i2oSWAA==
X-CSE-MsgGUID: 9a3n9BLESJaLUrTeRH3vhg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1361090"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 14:05:17 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:5495]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.194:2525] with esmtp (Farcaster)
 id b74a8fdc-df20-4ffe-a94c-ca7bfc8d3d2d; Mon, 1 Sep 2025 14:05:17 +0000 (UTC)
X-Farcaster-Flow-ID: b74a8fdc-df20-4ffe-a94c-ca7bfc8d3d2d
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 14:05:17 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 14:05:16 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Mon, 1 Sep 2025 14:05:16 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "lkp@intel.com" <lkp@intel.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com"
	<david@redhat.com>, "Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org"
	<will@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcG0lxZt1T5YHk+UqqKLGu1cJJ3g==
Date: Mon, 1 Sep 2025 14:05:16 +0000
Message-ID: <20250901140515.15769-1-roypat@amazon.co.uk>
References: <202508311805.yfcdeaFC-lkp@intel.com>
In-Reply-To: <202508311805.yfcdeaFC-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

=0A=
On Sun, 2025-08-31 at 11:26 +0100, kernel test robot wrote:=0A=
> Hi Patrick,=0A=
> =0A=
> kernel test robot noticed the following build warnings:=0A=
> =0A=
> [auto build test WARNING on a6ad54137af92535cfe32e19e5f3bc1bb7dbd383]=0A=
> =0A=
> url:    https://github.com/intel-lab-lkp/linux/commits/Roy-Patrick/filema=
p-Pass-address_space-mapping-to-free_folio/20250828-174202=0A=
> base:   a6ad54137af92535cfe32e19e5f3bc1bb7dbd383=0A=
> patch link:    https://lore.kernel.org/r/20250828093902.2719-4-roypat%40a=
mazon.co.uk=0A=
> patch subject: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP=0A=
> config: loongarch-randconfig-r133-20250831 (https://download.01.org/0day-=
ci/archive/20250831/202508311805.yfcdeaFC-lkp@intel.com/config)=0A=
> compiler: loongarch64-linux-gcc (GCC) 14.3.0=0A=
> reproduce: (https://download.01.org/0day-ci/archive/20250831/202508311805=
.yfcdeaFC-lkp@intel.com/reproduce)=0A=
> =0A=
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of=0A=
> the same patch/commit), kindly add following tags=0A=
> | Reported-by: kernel test robot <lkp@intel.com>=0A=
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508311805.yfcdeaFC-lkp=
@intel.com/=0A=
> =0A=
> sparse warnings: (new ones prefixed by >>)=0A=
>>> mm/secretmem.c:155:39: sparse: sparse: symbol 'secretmem_aops' was not =
declared. Should it be static?=0A=
> =0A=
> vim +/secretmem_aops +155 mm/secretmem.c=0A=
> =0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07  154=0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07 @155  const struct addr=
ess_space_operations secretmem_aops =3D {=0A=
> 46de8b979492e1 Matthew Wilcox (Oracle  2022-02-09  156)         .dirty_fo=
lio    =3D noop_dirty_folio,=0A=
> 6612ed24a24273 Matthew Wilcox (Oracle  2022-05-02  157)         .free_fol=
io     =3D secretmem_free_folio,=0A=
> 5409548df3876a Matthew Wilcox (Oracle  2022-06-06  158)         .migrate_=
folio  =3D secretmem_migrate_folio,=0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07  159  };=0A=
> 1507f51255c9ff Mike Rapoport           2021-07-07  160=0A=
> =0A=
> --=0A=
> 0-DAY CI Kernel Test Service=0A=
> https://github.com/intel/lkp-tests/wiki=0A=
=0A=
This is the same thing Mike already pointed out (making `secretmem_aops` st=
atic)=0A=

