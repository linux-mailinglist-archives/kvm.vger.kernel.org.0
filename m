Return-Path: <kvm+bounces-26011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1383C96F5D7
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 15:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 304C5B22064
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 13:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39ADB1CF297;
	Fri,  6 Sep 2024 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JAw/ow+u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE591CDFD6;
	Fri,  6 Sep 2024 13:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630734; cv=fail; b=s77TPvrvkhpyaUvGoXJnr51CJ5lw6K9i4uq0ij4alvRoxdWLgndBT6ILcz6KB318w8qoqsWFfbIPowOaN/o+HBkIkPMnhs4JJRo6fo4Em8hcs3c9dlGi/enWGzp/gO8nbXZdWuL/1wxIkphz+V0V8JG9Wm0KPFmLgXquHktUl0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630734; c=relaxed/simple;
	bh=9cnPDqcUbj48eQA5I36Xv84WIl8bwIHLy+twSbgLNpI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rAgObPmbBp9jWnZvtJMhLuA+eCvosjQy6wsy9LoehOp/AU6+yz+NPGaa8dAWVmCUtqSOFVtBPktgewPedSl1ijLXFAU4rUxsu0XTlgRXMMilxkKg3ZzL+7FqJu6SaU1Ib9tn0xnAfn+jqkqMp23lrQryfUTxnABFQqArMRQnupE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JAw/ow+u; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725630733; x=1757166733;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9cnPDqcUbj48eQA5I36Xv84WIl8bwIHLy+twSbgLNpI=;
  b=JAw/ow+uvq9r1R4qikr+e11Ag3Ff4RfOpoSWcFegG8zQSt7jT1rknfw1
   R9JR2OykHCzWzFuHmtPDotxUUA24hd+NXth7RIpD6GPqZIiMzte7HT0wX
   OiLbflkZCVQCNCE7XML9eXvv2VpPacStH/aMcbm1+hKhMb9QBME9PM0Fk
   w3HYyjFQu5zBh1Hv/DBGgV2YXfnXz4AvdV4Ki3ItPV0vtmLFylztXfy1G
   Ic7gn3x2yvm3sDHI1/lRz94IKZD5Fc1jYWvllLLLamiX91pjWLQyufHvc
   pZiOV9r2bkQwIkXCI7Ycl3TooaKOqiKIIgbVWzSwyiKsG8+ISomgkXhzY
   Q==;
X-CSE-ConnectionGUID: 90iYokZIRhytLG2tNTpeHA==
X-CSE-MsgGUID: SS/o8mKYS7qCJ3Cd5gKdig==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="28138284"
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="28138284"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 06:52:12 -0700
X-CSE-ConnectionGUID: vqKWFSIzR/eMewHSzQTXsw==
X-CSE-MsgGUID: hE/30wppQJefjyoGjB1vRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="65953555"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 06:52:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 06:52:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 06:52:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 06:52:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tywZUns4VrkP3M/EIrstbV3SKZbLRpaxuTRTeTWUAkULsbO+AdJ+NRfkb8uP+TSyfZXedCWaMzVMKGjoXZ4rIIwTAjol2PBqJgzYVrHEq9DEeIpAUMElYBHKG/Ai9kQp8VQb7wvNXgbD7Iq5EQyI0frWPvyKvOzuWCY4YFNt0b91aYOXgH24fbvc436f29TmlTqYpCArZXiRPd8THsld5Ip+wAdHVkhGesoVU5OrwsVT+85TlTDZVUcZ4RYrv7lgNFe5xx3G3nvvfDiLy/QRd1BlauQETlT8TkFJ6VnduFO9W3+b/SqeBk0eaeANdxzPQKxNX1TUU5hlbyYipR34Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGGk/X72jacc4CTufN6Ychh09FOOeHXfyldcCxgZDCs=;
 b=AMOlSEiHrhYeV91RHKrJeE5FYv1mMIvsIDFodg+OU/s3ZBa5PFHnVVyIeRgfk2B+ZU4ugeE7Z3UbIBjmVLvSKILx8LI9yugvmma0I15TVhMYi3XjMSFUa6tjBa2PgZxLsiJcQZY6zuZz1VkMZYAXNGBofIuWSvDxbFpNjwRnXKH0upMcoLySUvNurmGCwVnOJEzC3UxfnPhR75Ix0n88DaseBh8BNuSbsJZkqh6KrfBlafy7brYbV36WQ40nzQJeIwzWZtY0R/bxpX74ZumjrKkF44wUhip0KrDbEdE/u44Y/A7i76mToYxk88WaIRB4zu7pw40Nw1KHRCNmi/prYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DS7PR11MB6269.namprd11.prod.outlook.com (2603:10b6:8:97::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.27; Fri, 6 Sep 2024 13:52:06 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%4]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 13:52:06 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: RE: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHa7QpuqqDW8ZqcGkOrsxBc8E123LI93xYAgAaNX4CABHu/gIAAKXwAgAE4ToCAAAeUAIAAmNfQ
Date: Fri, 6 Sep 2024 13:52:06 +0000
Message-ID: <DS0PR11MB6373523CB032761B2A1BE866DC9E2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>
 <ZtWUATuc5wim02rN@tlindgre-MOBL1>
 <ZtlWzUO+VGzt7Z89@yzhao56-desk.sh.intel.com>
 <Ztl5muQNXr7eGLWU@tlindgre-MOBL1>
 <Ztp/lQ/SaCe+/4qb@yzhao56-desk.sh.intel.com>
 <ZtqF8O56_h0_g6oD@tlindgre-MOBL1>
In-Reply-To: <ZtqF8O56_h0_g6oD@tlindgre-MOBL1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DS7PR11MB6269:EE_
x-ms-office365-filtering-correlation-id: f929355b-baec-4a0a-d691-08dcce7b1821
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?V/h/XYjKwg6NYBbgFkNI850c9Ta1NVhYOAkvLDUh2ke3HR3QV/EzweuuRi?=
 =?iso-8859-1?Q?mZ6j9TptUKlFyBrLUS72safY1CGAZNkhi5q/3knijmIlo5tkMYgp1PX9Wo?=
 =?iso-8859-1?Q?ityA0OfJkrGdTwARf42jZiw+wkLwSMbViedN6+dBiTNuWHF6OebKKcUL5F?=
 =?iso-8859-1?Q?MkUZZcLtssB6edL2cNbob0+nlRNe8J2ELg8YhHpj3PEXe7r8tTulhtSXOS?=
 =?iso-8859-1?Q?mmyHjeXBSOOW/ljOZhS2K3uPCaj0G217TDkm+JAcGvu8jMm2Y7w4XqpFKx?=
 =?iso-8859-1?Q?huFyHTYtjRErGAASEbRuTm0L3+7cN9N/0bMjDRY/T7Ci5WjWsAJgR2P2KS?=
 =?iso-8859-1?Q?yKDA+4GUJZKztntJTZ29zFefERWEJpmCSy/Mu8gFNey2/Zb2BfWsvAiFg1?=
 =?iso-8859-1?Q?QppNGDVHYrBHsi53sgCCebwJ37MiE2Kqua3Vcfyi2WlSc3+6lExtqr5vQY?=
 =?iso-8859-1?Q?lzcfpr0H9SdGaxSk/xfwn4Va5GA8CnFyQM/baIF0P84coG7PqXcQJ+RWAq?=
 =?iso-8859-1?Q?QpeMJDQdxLSjzJeplRwYkYqKPxEVaCKHP8ihxA3rsii06sTLRSbEthKliR?=
 =?iso-8859-1?Q?7jS5bHOGZBtNFmcEPhee8P+ghBpiireEbXua6+dwryxwndSuch8OlNyndg?=
 =?iso-8859-1?Q?LGbv4IdfhUjyQuIOECg1eJL39hdNidPWa2l/TDOL9Uk0B5ErpsHavvZC6c?=
 =?iso-8859-1?Q?FkdbtMu7bQv+7vkW1k0GITmSWkmkwD0sDfFKjhz/aiSzQb1Z34MO2Wtk5c?=
 =?iso-8859-1?Q?UqbL+iN/4f8P1IahFMo468UlQhNyaEGJaUfIVUwxd8U8s0gYgZAFlZfc1s?=
 =?iso-8859-1?Q?/HyM/1vU3zGIYmcRar185Sx3FeXAAtPZGxIIp0+EY3M02/XTfDCqqJbuau?=
 =?iso-8859-1?Q?Cqsq39jzJyuukS9ka3NNowVgnKaoWGUQTNLKSYl/JZ74P2id9gC8IOgO1Y?=
 =?iso-8859-1?Q?AZcb1lslIYYHcNiyRm7fLSwCvMuDOqLr0DFR1BJXFWbNPAKQj2UgzNUE7d?=
 =?iso-8859-1?Q?M7XaIgBYASuOB+1/0Be+NEXX8FOlCvA5iXnhKsHKmoVN7pFPwPHDYQ5sdW?=
 =?iso-8859-1?Q?GfDqK9t9+5e3fklKJVCu3Mx0uGZBg2vY6dRtMqKO2YWmKj/0wnyYlmM6J5?=
 =?iso-8859-1?Q?6uIBzeFJDncvWuITjGmqsaBp8YFVikmSOgpiLddN7BLUweCFJLV0d7/wyq?=
 =?iso-8859-1?Q?q6SL8+e6U4UthSce0VeK9E4E84dUJtoLdHx4GC4h+/Uk8HjV5gRwidCOB7?=
 =?iso-8859-1?Q?oJSu8LiXQb7Fa3j394Tae/cnK5l0m+oRBT5YiOGgIl2DIrq2KFDphG+c5l?=
 =?iso-8859-1?Q?8HWsmIp1acbNp49MfDjKEoNxBv1CQydNc5/EooDGr5IZva5N46npOXLyoO?=
 =?iso-8859-1?Q?iWdhtSpOQfqM6PAQfhdOKAKpgNZQpObPOHYCFtZBdPdCoM3792efNLmbYo?=
 =?iso-8859-1?Q?Nr5m0ePkfeUEpiVEVhZfFPlDJbVpLvN7mm8jwg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WyU3NILla8fri0BKKHwQ1uCV6338YjT0HyF3rg89LOBP5SOP/zn0nG3tdM?=
 =?iso-8859-1?Q?9GeTmY33o4WNCpJSkbouDej/As3vWbF3egq76accEKA58PR39Uted0MNzQ?=
 =?iso-8859-1?Q?jtCaq1WiPmgL/O9tPw6scNE3BlLdw8RA8V95JwmbfvI6ZqAFA1m4ydq1gZ?=
 =?iso-8859-1?Q?bTttUgoCi7Gw6ipO+giud8J+awjehR3O4arkIRJ96MZraY9bJb8bBduQPH?=
 =?iso-8859-1?Q?Eyj5qGDL4LXNc5SOjiHmdbFlgiuDetMRhynpjZbZmLQ3B7CVxXsKAqoKW7?=
 =?iso-8859-1?Q?TB2M//bTMWqu6HfQvatfUoJLFzi44BQGGcx7cbfKumX7OIp7iuteEJy2nJ?=
 =?iso-8859-1?Q?ISpT5z4wXWgWk2dyNsqCC3ocLGcs3O8DHXiZeDSBTmoG9u1MqaE+K15k7W?=
 =?iso-8859-1?Q?LQaTb3sp8JDLib+Rrl9ky9zxceKD1dEpAFsHT3JQmfX7/H2AQIruhiermn?=
 =?iso-8859-1?Q?jAPzaX27aHuLX2VnAjOE6XZH79xmGqY/qRgSemHKFh4o5JGXScRvjtyexE?=
 =?iso-8859-1?Q?7hQNJL7Kh5CfvpBA4wT7dSpV2OzHwMbl4KD2gs8aQ1AOGhBj2vCY69c/Fn?=
 =?iso-8859-1?Q?o57iGnYsVNcDnN4PR8ZmMUnwyu7SoRS06XtT1BiwmKWJQ6alY3GJwrgZ//?=
 =?iso-8859-1?Q?O7Eo0TaH6SyE4e1qgSmc+kHP2ryZGBXDzIv0g4LR24IpKF/uHemNxibKS4?=
 =?iso-8859-1?Q?r166AZjllPtchAVBNJpJw9SrM8j4f5c4xoR79M+u9hDZwohI0DvDfUFx9+?=
 =?iso-8859-1?Q?1R5D5TSsVPBfKu3U1kKVx39VZrJO0O+eQBvf/9tFWp2b7cW46zlB6PHrBy?=
 =?iso-8859-1?Q?6ZeyCvYAFG2f/qV/FZ/MCv8ggQWNQ96SNVukqN90OmWhM72zXyi9vsNlMF?=
 =?iso-8859-1?Q?sIVvjKkaWUceSfNjtS6/h65tZ/VJRL5KXlv6bFhEKw+1/P7Y1HyJFUpYSs?=
 =?iso-8859-1?Q?2ULSmCTjUEWhYQnOzW9IMKW/4MgpROIkH9CsiNYc7AEsnVNfiusxO8fOE+?=
 =?iso-8859-1?Q?gamt21S9LhQ+mQeW3PKsXu3n/Lvq3xF6ifRd8Cb6aaYp4kvDiDIyqvxFTl?=
 =?iso-8859-1?Q?JifF2PMmsQnyMceI9mjuot1YaVQlBzrJ7b+Iqd9SChuar1KHjsJc97GdGz?=
 =?iso-8859-1?Q?IzxA/qoV+rugypY6wbvd6l0bIz8YLO2GhtQeffD35wd3w4R4YYeYCZ2/Ut?=
 =?iso-8859-1?Q?trxiniEOBT29BddtM+YtgqcpkqJ7HVrnDUd0eJwlgIAOFmj1b817vuyoTf?=
 =?iso-8859-1?Q?5lT5khTe2pTU9OD/tAE2NkP1ScA/bJLJvDJkbo6yDvXHaO8tADsZl2Zzq1?=
 =?iso-8859-1?Q?eUkU+CkHNTGHvLNA6W3iMwTqdppyFpUMiuvnfuW4BzukT384uR635dmoZG?=
 =?iso-8859-1?Q?5xrkixvNZw6hcFTKDwuus7JKh7PpizoFJH0AO17nRx7fM03h566+BnCDct?=
 =?iso-8859-1?Q?RM3soDtDqBbHUD3wTA/zmsismjw3TJM/9Eie4jUSQWG4uGlqzdo89kG3d8?=
 =?iso-8859-1?Q?HtB/gF3SwgcJ+EujP7HQ33GCglpH5isfF48KI2EEUNubHDgZtfUtcYR15q?=
 =?iso-8859-1?Q?UqKmAI9KMP7fKLCbcaZm8i/5hqUoTucfTL6wWBiYPHy4PKvw7hborwtkyP?=
 =?iso-8859-1?Q?B6OB3YuUgrWPQEeRjSoP0+plD/lvBEDW8b?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f929355b-baec-4a0a-d691-08dcce7b1821
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 13:52:06.0538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zs0fizpPt1DCIrFg5d+oubV5RIIGzQjM95aiq2BbsFQ+jahA9UiTwgs0yfVNbM6LxEdAHHo1gzIgM+633AUcjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6269
X-OriginatorOrg: intel.com

On Friday, September 6, 2024 12:33 PM, Tony Lindgren wrote:
> On Fri, Sep 06, 2024 at 12:05:41PM +0800, Yan Zhao wrote:
> > On Thu, Sep 05, 2024 at 12:27:54PM +0300, Tony Lindgren wrote:
> > > On Thu, Sep 05, 2024 at 02:59:25PM +0800, Yan Zhao wrote:
> > > > On Mon, Sep 02, 2024 at 01:31:29PM +0300, Tony Lindgren wrote:
> > > > > On Thu, Aug 29, 2024 at 02:27:56PM +0800, Yan Zhao wrote:
> > > > > > On Mon, Aug 12, 2024 at 03:48:09PM -0700, Rick Edgecombe wrote:
> > > > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > > >
> > > > > > ...
> > > > > > > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd
> > > > > > > +*cmd) {
> > > > > ...
> > > > >
> > > > > > > +	kvm_tdx->tsc_offset =3D td_tdcs_exec_read64(kvm_tdx,
> TD_TDCS_EXEC_TSC_OFFSET);
> > > > > > > +	kvm_tdx->attributes =3D td_params->attributes;
> > > > > > > +	kvm_tdx->xfam =3D td_params->xfam;
> > > > > > > +
> > > > > > > +	if (td_params->exec_controls &
> TDX_EXEC_CONTROL_MAX_GPAW)
> > > > > > > +		kvm->arch.gfn_direct_bits =3D gpa_to_gfn(BIT_ULL(51));
> > > > > > > +	else
> > > > > > > +		kvm->arch.gfn_direct_bits =3D gpa_to_gfn(BIT_ULL(47));
> > > > > > > +
> > > > > > Could we introduce a initialized field in struct kvm_tdx and
> > > > > > set it true here? e.g
> > > > > > +       kvm_tdx->initialized =3D true;
> > > > > >
> > > > > > Then reject vCPU creation in tdx_vcpu_create() before
> > > > > > KVM_TDX_INIT_VM is executed successfully? e.g.
> > > > > >
> > > > > > @@ -584,6 +589,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > > > > >         struct kvm_tdx *kvm_tdx =3D to_kvm_tdx(vcpu->kvm);
> > > > > >         struct vcpu_tdx *tdx =3D to_tdx(vcpu);
> > > > > >
> > > > > > +       if (!kvm_tdx->initialized)
> > > > > > +               return -EIO;
> > > > > > +
> > > > > >         /* TDX only supports x2APIC, which requires an in-kerne=
l local
> APIC. */
> > > > > >         if (!vcpu->arch.apic)
> > > > > >                 return -EINVAL;
> > > > > >
> > > > > > Allowing vCPU creation only after TD is initialized can
> > > > > > prevent unexpected userspace access to uninitialized TD primiti=
ves.
> > > > >
> > > > > Makes sense to check for initialized TD before allowing other
> > > > > calls. Maybe the check is needed in other places too in additoin =
to the
> tdx_vcpu_create().
> > > > Do you mean in places checking is_hkid_assigned()?
> > >
> > > Sounds like the state needs to be checked in multiple places to
> > > handle out-of-order ioctls to that's not enough.
> > >
> > > > > How about just a function to check for one or more of the
> > > > > already existing initialized struct kvm_tdx values?
> > > > Instead of checking multiple individual fields in kvm_tdx or
> > > > vcpu_tdx, could we introduce a single state field in the two
> > > > strutures and utilize a state machine for check (as Chao Gao pointe=
d out
> at [1]) ?
> > >
> > > OK
> > >
> > > > e.g.
> > > > Now TD can have 5 states: (1)created, (2)initialized, (3)finalized,
> > > >                           (4)destroyed, (5)freed.
> > > > Each vCPU has 3 states: (1) created, (2) initialized, (3)freed
> > > >
> > > > All the states are updated by a user operation (e.g.
> > > > KVM_TDX_INIT_VM, KVM_TDX_FINALIZE_VM, KVM_TDX_INIT_VCPU) or
> a x86
> > > > op (e.g. vm_init, vm_destroy, vm_free, vcpu_create, vcpu_free).
> > > >
> > > >
> > > > =A0=A0=A0=A0 TD=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vCPU
> > > > (1) created(set in op vm_init)
> > > > (2) initialized
> > > > (indicate tdr_pa !=3D 0 && HKID assigned)
> > > >
> > > >   =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(1) created (set i=
n op
> > > > vcpu_create)
> > > >
> > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(2) initialized
> > > >
> > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (can call INIT_MEM_REGION,
> > > > GET_CPUID here)
> > > >
> > > >
> > > > (3) finalized
> > > >
> > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 (tdx_vcpu_run(),
> > > > tdx_handle_exit() can be here)
> > > >
> > > >
> > > > (4) destroyed (indicate HKID released)
> > > >
> > > >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(3) freed
> > > >
> > > > (5) freed
> > >
> > > So an enum for the TD state, and also for the vCPU state?
> >
> > A state for TD, and a state for each vCPU.
> > Each vCPU needs to check TD state and vCPU state of itself for vCPU
> > state transition.
> >
> > Does it make sense?
>=20
> That sounds good to me :)

+1 sounds good.
I also thought about this. KVM could create a shadow of the TD and vCPU
states that are already defined and maintained by the TDX module.
This should also be more extensible for adding the TD migration support lat=
er
(compared to adding various Booleans).

