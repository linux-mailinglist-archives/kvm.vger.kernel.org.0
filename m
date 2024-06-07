Return-Path: <kvm+bounces-19088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDC4900BEB
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 20:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E62E9B23DAF
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 18:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C591411F3;
	Fri,  7 Jun 2024 18:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="COpPL8Ck"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A871DFEB;
	Fri,  7 Jun 2024 18:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717785564; cv=fail; b=KYg3ciCStSzat+ATh4ximOHtrlmL0IRWpxOQsO1qnrzJgSgvOQSAlF0q+1bi+ds23mt4CVQYa/le7n2Zbik64A/9tmSKYO6Iy3DcUhDqz8Xdr0WP/w1g7KLAaTVv+E5KEtkU8Sm7UVMxQ+HArgU/aP5dKaheUqvqcdw895cVW1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717785564; c=relaxed/simple;
	bh=MYKZaSU8fjvXCXfN3oY0bVQ2nWCDFOpOTFpDaPasjpE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=su+R7TVNAoc0P3AAQtq4O/ljOJR1OB6XEGFGknDNqG5uj6Be8Z14LhgXGruTZqHp1Xso4lb5URH85OLV35PtNJW5/lvIjexh+pmuwRvj5nmQl66P7RXWYYkKNclAYfxH6BVQ1JKeCVoOyFa7UIpXCYSGJdxuH1/O4sXFV/JxtpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=COpPL8Ck; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717785562; x=1749321562;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MYKZaSU8fjvXCXfN3oY0bVQ2nWCDFOpOTFpDaPasjpE=;
  b=COpPL8CkCXw/GEHeGIIClt2Z3/qNHZxVptRYlJCZ1WsvEsErsPdendeb
   j+n+4w1RhtWaWqfVU61ufPUaOgBldcjxfhzmFW/izKEnIrMlbTFWVYidW
   GkGiUiUTGnkymEQhslKLYexDNZwhYP7dWX+FIGFp6KKa6uMzSiDQh/33a
   v+yqLRKrbuikIfDeHBLM544w4vvh0wl3DZ76wStKJX7e2PJlNI4WXyEjZ
   RlwgeL3FSGrELZOPdMOynBaVyVlZP/ozQdcNbiHZlnaabr7Jd1PJ0hK8v
   koz36JnKMwGTKe5UAjN7an23LqvL4yyHtPuxqerDGV8yeGyWAJcvVnLhG
   w==;
X-CSE-ConnectionGUID: p5hzlLmvSFei8HjHdRtRJA==
X-CSE-MsgGUID: HUfA6XpkRHKs0hCdUqZ0Iw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14321425"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14321425"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 11:39:21 -0700
X-CSE-ConnectionGUID: OvDZHij5Q6KpYMf3Dk+39w==
X-CSE-MsgGUID: wDFl1TASSPyUs5qLS6LP6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="61593586"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 11:39:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 11:39:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 11:39:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 11:39:20 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 11:39:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcnN7dOsT0oIaFWz06dKm40ee/ES3MiSHnSEz1NMoQN8fXDzbQf1DpeO/VXECDXHbPNLMzQMCDVryzC3GQTt7zSEEW7FDFs+moRkNYwQ8ZihXq3g4msAosUfGAm/G1fvIatQ20cCVF+Ml6OS0VNgB1NfegmaLhe+5d4vx9N4O7H16PzqBqaFnOb3RL/KwOLc4FWuo4w56Y3ITR8AI7WLy3QCmY98U3X7qQpQ/M7DNYRDI/xtNZ5TrPRjkMVfSpVTpOy2J1/OWPgLHKK7S1nuxz2TFJjn7lA8iNu/nsdnZNcBdNxWUQj+6quJ0JTrGZlcZN+Tq79vdnUO5obJumXVMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYKZaSU8fjvXCXfN3oY0bVQ2nWCDFOpOTFpDaPasjpE=;
 b=jGI7G+RjmxgaizzPS5FGofd1l2vGPF3JZzEDgQhV80EHhSFxnm7Obpg4MgmtIHnPT+eVO8Al88FR4PeSdGWXT4r1s6XGn2Yr+cfhvqiIG3W6tp9Ztp6T65/DA6b/DHeIuCMFcfFjd9Zvq/ClyQjygt8NEHXsIWnEC60s8fHL4EVO/tCMlPs5tUyLIJlKAagGgv02SZpOvx5JvJztFSZRQ5KHNz1WUCa6LHq6Tu4QzmfGV8NgTJtBflxUbUI4gd0ovYaeqt4w3Lo1bcrnQu972QW8dB6ZPxcEhguHW5aqcLF/YGGy8iAoBUGY6t019Tyga7sY80F6mmhSziAQYnc+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7670.namprd11.prod.outlook.com (2603:10b6:a03:4c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Fri, 7 Jun
 2024 18:39:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 18:39:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 06/15] KVM: x86/mmu: Support GFN direct mask
Thread-Topic: [PATCH v2 06/15] KVM: x86/mmu: Support GFN direct mask
Thread-Index: AQHastVu8k/3LnCT00Gh+DIw8MCP5LG7+4QAgACyz4A=
Date: Fri, 7 Jun 2024 18:39:16 +0000
Message-ID: <9423e6b83523c0a3828a88f38ffc3275a08e11dd.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-7-rick.p.edgecombe@intel.com>
	 <CABgObfZuv45Bphz=VLCO4AF=W+iQbmMbNVk4Q0CAsVd+sqfJLw@mail.gmail.com>
In-Reply-To: <CABgObfZuv45Bphz=VLCO4AF=W+iQbmMbNVk4Q0CAsVd+sqfJLw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7670:EE_
x-ms-office365-filtering-correlation-id: e26f907a-c56e-4198-6559-08dc872122ca
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZlJRMG1zb2ZIT3FzTEVYRlZhOFNkV3F4V2FNSnRYY3U5RElmeU5xdVlpOW9Q?=
 =?utf-8?B?UFE4ZldtUGY3cjk5L2VxTVkvUk00cVgvMG0yTG9Sbm9NbStJVXh2bm9tWFdr?=
 =?utf-8?B?Q1NpQ0dyQjlzbzU5UHNxZmNNK2c5QTB5NkczcXVXcFE2T2tYVERyUmdKeG1U?=
 =?utf-8?B?cWpReEcrZTk1eFRzcHhRQmVncnVYWGxrMVlmVWZnbEJ0U3pLa1NvY1NqQmVW?=
 =?utf-8?B?SVMvZVVWT3FwdVJ5eUhrKzk5N3phOGZkRTRURHJTcnErOGY2TzlCRXVRcm5X?=
 =?utf-8?B?YmZiemJESUVhZG9Cb2J3ZVBvK2pOWkZhVFJZdE81UFdkcFNoM1BPR2hHZnZy?=
 =?utf-8?B?WUx4WXJJVzMzellBbVZCYXA2eVlpSkZUeEJvWW1xaTZ2NmdYRkZuVThOREJn?=
 =?utf-8?B?cGZvVmltUFFDQVFseFFwWkVtVFMxOTBkaFNiZlZnMGR6M2wzdlRCTHpSOGY2?=
 =?utf-8?B?RGJhbnZEd2gyVTBjMjVQZ3ZVVUtwNm9wY0ZCUHBEM3IzOUZjMXo0WC9sZHgw?=
 =?utf-8?B?NHRtTGVLMnZBcjZKbXpEZVdYbXFiNHZSRlNoNUxrcDQrM2JaMVkyRGpBNStq?=
 =?utf-8?B?WWxFSGFhVXFsdHpycnhCTnhuakNhZGhkSEI3NkJuUk8xaHI2Rk42ZGVJSGI3?=
 =?utf-8?B?TzZXcGQyN3paaDI5SHd2WVJQc0Jjbk5SRXZVRnljcHUzbVYrTSttbWIxY2p5?=
 =?utf-8?B?TDMrTFNBUGE2eWdIZmpmWUlVbW5rSFRLZ2NOSGJzUTBLZWg1Zjh0TWNDcW5q?=
 =?utf-8?B?TndSdVBwSUVnMmVselI0YzNnMG1ubWpRRDFqZTRybWZCM3YrdTBmeGdiN0tT?=
 =?utf-8?B?UFpDN095dkdCVk0wMFFGMVI5eWNSdXM3Tk1PUmp3VnQ1YWpHNkdZY1Z6SDNv?=
 =?utf-8?B?cUt0WndsMUF3UGQ2U3Zmc2tzMnMxOXVSWG1BMGZUeUlrUkJLYzljdFprYllC?=
 =?utf-8?B?V0hwU01jczNpN21vclJkTVU2dTd2Wis4cTNQcHhXdS9xZCtYUWpkMTZIbVZK?=
 =?utf-8?B?dzlEaVBIekI5Q2ZnTGR2bE1EYTNnd0xNZEwxSEt0ckZMSHZPMklNaFlwSGJ4?=
 =?utf-8?B?WkUrQVk1alhubXVwdXhjaWZqQ1ZoUlJUOWlTdWJnRElPNlNHYzdCQkVzdWE2?=
 =?utf-8?B?TWZGN0hvVnh5ZU41UG01cGxwOWl2YS93OFlxNU1JandDM2RJcXJKUlkzaFVh?=
 =?utf-8?B?T1JaY0ZKTHMxV2xZM3loaGoxeFlqSUY1T1pIczJ2NHVpRTMyQVdXNGlDZ3Bx?=
 =?utf-8?B?ZDNtYWp2dlo4bWR1Q1hTMmFCQzlWbWhJeEloT3dkdy9KekY1cXNjSzl1N0Ja?=
 =?utf-8?B?Rkg0VW5vbmhiTUM5TXJhcE1EaTdmQlZMNjh6VzJ4eFdXWTNBSlNtSmZYblk3?=
 =?utf-8?B?WE1CeHZzdHVaRURoaGpPUnFJZ2VTUUx1UjhuT2lrUmFzcllyYmk5WWVZNmFo?=
 =?utf-8?B?c0d5VkVSUStIVWFkdGtaeURtZUZGbXpiUlY0ZVlIMEU5UmNFcGhEeGZpLzhH?=
 =?utf-8?B?SmZPQXgzUWdBZ0ZTVUlCOWhlL3IzeGpSTUdsdjRMYlhtZjRjY3N3bWZxcHJm?=
 =?utf-8?B?OHJtVmJVVVVucitmVUQxbFVpUmk5WjZneUhMaWh3TElCL085S3MxcEdjOEh5?=
 =?utf-8?B?aENIc0k5YlozZHZjbjd4RGF3dGJJdVM4bnUxRUMxM053UXVuU28wcEFMaVRm?=
 =?utf-8?B?U082YXowcUVuRXpDbkFwWXQ3NUpFbmpCZ0NLY0M3UmZnQ2Zwd1c1QTVFUHN4?=
 =?utf-8?B?cElqY0lKTmdBcWpyazhLbllCUzljMWZCMzhEY2pWM0c5MW8vampxdWpZenVM?=
 =?utf-8?Q?M9XRIyDbzzuIpvXKEPG7MK3yWaVeO8ousWNQ4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHlMUHlOQ0doUjhzVkdzWmdtQThqWmZUU0U1dTQ1eE0wSVg4NlY3YllqeVY4?=
 =?utf-8?B?ODVyN296dXQ5RnczQ3cyMUFwaDVqb05MT1A5MDZqSkg2UllUa2ExWmJFOHg5?=
 =?utf-8?B?RTR1ME9TZU1kNW5EbEZJS3ZUYWRVdTNzdnZGdUJ2VWFvVXpEVkhiK042N0kx?=
 =?utf-8?B?cVhNekYrdWl6a0t6aGtVWXh1WnU2QnY5cTM4dFF3bHJZeXBzWmViaUg1aGZE?=
 =?utf-8?B?MmgzVjJRN2w0SGVFeU9ucjdhKytwbmNJUzN1NHB6TUM5R1Q1NHp1Nlk1dWFn?=
 =?utf-8?B?cFdKOFEzR3FiYVRtVVhseWcrSmFsNzA5UnBmOFQ5KzJROWZkekdYcVJrOWFD?=
 =?utf-8?B?cFZUcHVYWGVWM0lqb0t6dDFEUUNab0NrakFySjFtOEM2bnE5cWErUS8wV1gx?=
 =?utf-8?B?OVRESHl0QXpxa1R4SGVnNjFOK3cyRE10cDJ1SlM4TTdJdThDRlVXODM5cTZM?=
 =?utf-8?B?QlMrSi9HbjA1ZVRHclpxMEtBeUhWb2ZFdytvM1BPMWQzanVlT3hKa0R6VXZL?=
 =?utf-8?B?S2FqNm9WY2c5YythOWJ0T0EwRHdCNEYrRExLTkk1aDhRQ2MzQngra3JmMjhT?=
 =?utf-8?B?TlVEOURoN0xzNnROVWpXWlRENUZzOE1aQXNnT0NSWWZaUHJjUVhwc1pGeW4y?=
 =?utf-8?B?UU82V3BsbFNjdXk0eXdzbWVsektuK2p0SWZPMUp1RTVzU2ZXeElQdi9tUGxL?=
 =?utf-8?B?ZGl6RVNFb2JSOGRFQm04SXVDbk9XMjhDMGltN1NkRXFFaXBVOWhwelI2bGo0?=
 =?utf-8?B?NlpaSHZ3T0dDN1A3Y2kxWFNRcGF6cFcvYTBXMDhhczd0cUVuVGdZd2o2b0Ey?=
 =?utf-8?B?NTZYVEtZbUE4dXFyQTJKaFRzOGJEd1RPQlZBSjVraFpDV2dqTmNha1pJQWY3?=
 =?utf-8?B?b3JzZjZKaFVIU2VTbERjN0RHY2VBV2c2dzZaaENmVXpiNVlZaGdHMUpyMXFV?=
 =?utf-8?B?V0Y4Qmc5K0E5QVBRS3d4RGY5M3RPdFBKM2tGTHRRMUNFNnNhczFkQUkyd3RG?=
 =?utf-8?B?RkpvOUZxK3Q5QStBS0RuaGpvNFhKbG9BUEVQYm05UXFPQ1h1dE0rWDZ5aUdi?=
 =?utf-8?B?ZmZRME90dnA2VUdlRnZlUjFNcVpUamVJWjI0cTVoeWhtL1RUKzFYUlVFb3hv?=
 =?utf-8?B?K1NZVTVCWFBYVHZYSkoyZWNUK1pBeHViVURITzREZGtrWHc2K3JjZGVVUk5J?=
 =?utf-8?B?MW1WSUE3bzhZYUMvd0xVYW94QkJmSDc1Q1VSSStZNGtRZmkvWUNqbGFJNytv?=
 =?utf-8?B?TkRlTlVCcUVQNVZUbUJ6VVRxRGI4b0E4WkZZeWtjUWlpbDFMYXpMRUtLTzJa?=
 =?utf-8?B?eWgrbTFURkFsT1F5ZFlIMmtrRVJPOEppWTIybVdtY1FzUUhmRlFWUXFwUGwz?=
 =?utf-8?B?RGV1WEw2VTNUK2g2eUdRdGkxSi80LzlEVVMvSy9GNEh4a2REcXI0R2lWS0tL?=
 =?utf-8?B?d0VQTkc1RFc3bW1DdnlwdUQ2TU4vNlJEYnQ5SVVKZkU1ZkQ1eWpoRWIrS0Ni?=
 =?utf-8?B?MEQ0aHVmemVQdnpkMEhYMDZJUzBLdlhwNDdBek0yajF3Z05saGVBSDV3K2JM?=
 =?utf-8?B?VmJQRVBQdVJGVlYwdFJsSE9HQ1hPZ045NnpSbW85Q0d3UFZtd0ZORy9uOXlL?=
 =?utf-8?B?RmZtcitubTRqSTZrNE81U1ZlWERCRFl2VXFLbWNsenJiT3lIc1N5WitaMW1p?=
 =?utf-8?B?U2xZZmdYUEpqczk5L212aVpUcE1EWVBqT3BTaVlab1ZpVWR1UDZXeGdUQUxu?=
 =?utf-8?B?TFpSNTRhZ0UrU1U2NW5UMGlhby91blYzazNySmtLVm5yWFhOWkNhM0Nxc0Nn?=
 =?utf-8?B?cC9XR1djREN6WUVmQXBORzM3MzZrZGd3OXcrZU5lM0JnMjNibTZVTnJSQkc4?=
 =?utf-8?B?NloxaWtpdldBbGVCM0phanJUcDFlTWo0cTFtY3QzN0wyWW5zaWhWZWVac0dK?=
 =?utf-8?B?S3FNdlZNMWZCSENHcnhzOU1mT2NnSENXUHpUNzdtSmpoVzNBd09zUDAvUkJ3?=
 =?utf-8?B?QmpKNWUrczVnVzJtRWcvSmhhNDcwZVF2enJYSW5VbUIvSW0xMHMraUZsM0do?=
 =?utf-8?B?bEdQUkU5NEF6RE0zcVZNUXk5b0pSWFhBdDl0VS91dHFWY08wVVpvUXNpMDU1?=
 =?utf-8?B?RnFQcjQrenJRSWxwWklLaktIamp1SmtnTFhucHpaTFRMdnZRV3pjYmFpS1VP?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A6261C7FFA0D247ADE3784A68ACEF2B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26f907a-c56e-4198-6559-08dc872122ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 18:39:16.6818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cysuWC1/N9y9rzK5RSJgKGezH9RlQY7Anzol84obBMUBuUh1W1RJEIbZOS3JW4UlZs8s3E7bx6QGpMbpK11UuFibgqANM+xgiAJbEFEIyns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7670
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDA5OjU5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBKdXN0IG9uZSBub24tY29zbWV0aWMgcmVxdWVzdCBhdCB0aGUgdmVyeSBlbmQgb2YgdGhlIGVt
YWlsLg0KPiANCj4gT24gVGh1LCBNYXkgMzAsIDIwMjQgYXQgMTE6MDfigK9QTSBSaWNrIEVkZ2Vj
b21iZQ0KPiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ICtzdGF0aWMg
aW5saW5lIGdmbl90IGt2bV9nZm5fcm9vdF9tYXNrKGNvbnN0IHN0cnVjdCBrdm0gKmt2bSwgY29u
c3Qgc3RydWN0DQo+ID4ga3ZtX21tdV9wYWdlICpyb290KQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKg
wqDCoCBpZiAoaXNfbWlycm9yX3NwKHJvb3QpKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiAwOw0KPiANCj4gTWF5YmUgYWRkIGEgY29tbWVudDoNCj4gDQo+IC8qDQo+
IMKgKiBTaW5jZSBtaXJyb3IgU1BzIGFyZSB1c2VkIG9ubHkgZm9yIFREWCwgd2hpY2ggbWFwcyBw
cml2YXRlIG1lbW9yeQ0KPiDCoCogYXQgaXRzICJuYXR1cmFsIiBHRk4sIG5vIG1hc2sgbmVlZHMg
dG8gYmUgYXBwbGllZCB0byB0aGVtIC0gYW5kLCBkdWFsbHksDQo+IMKgKiB3ZSBleHBlY3QgdGhh
dCB0aGUgbWFzayBpcyBvbmx5IHVzZWQgZm9yIHRoZSBzaGFyZWQgUFQuDQo+IMKgKi8NCg0KU3Vy
ZSwgc2VlbXMgbGlrZSBhIGdvb2QgaWRlYS4NCg0KPiANCj4gPiArwqDCoMKgwqDCoMKgIHJldHVy
biBrdm1fZ2ZuX2RpcmVjdF9tYXNrKGt2bSk7DQo+IA0KPiBPaywgcGxlYXNlIGV4Y3VzZSBtZSBh
Z2FpbiBmb3IgYmVpbmcgZnVzc3kgb24gdGhlIG5hbWluZy4gVHlwaWNhbGx5IEkNCj4gdGhpbmsg
b2YgYSAibWFzayIgYXMgc29tZXRoaW5nIHRoYXQgeW91IGNoZWNrIGFnYWluc3QsIG9yIHNvbWV0
aGluZw0KPiB0aGF0IHlvdSBkbyB4ICZ+IG1hc2ssIG5vdCBhcyBzb21ldGhpbmcgdGhhdCB5b3Ug
YWRkLiBNYXliZQ0KPiBrdm1fZ2ZuX3Jvb3Rfb2Zmc2V0IGFuZCBnZm5fZGlyZWN0X29mZnNldD8N
Cj4gDQo+IEkgYWxzbyB0aG91Z2h0IG9mIGdmbl9kaXJlY3RfZml4ZWRfYml0cywgYnV0IEknbSBu
b3Qgc3VyZSBpdA0KPiB0cmFuc2xhdGVzIGFzIHdlbGwgdG8ga3ZtX2dmbl9yb290X2ZpeGVkX2Jp
dHMuIEFueXdheSwgSSdsbCBsZWF2ZSBpdA0KPiB0byB5b3UgdG8gbWFrZSBhIGRlY2lzaW9uLCBz
cGVhayB1cCBpZiB5b3UgdGhpbmsgaXQncyBub3QgYW4NCj4gaW1wcm92ZW1lbnQgb3IgaWYgKGVz
cGVjaWFsbHkgZm9yIGZpeGVkX2JpdHMpIGl0IHJlc3VsdHMgaW4gdG9vIGxvbmcNCj4gbGluZXMu
DQo+IA0KPiBGb3J0dW5hdGVseSB0aGlzIGtpbmQgb2YgY2hhbmdlIGlzIGRlY2VudGx5IGVhc3kg
dG8gZG8gd2l0aCBhDQo+IHNlYXJjaC9yZXBsYWNlIG9uIHRoZSBwYXRjaCBmaWxlcyB0aGVtc2Vs
dmVzLg0KDQpZZWEsIGl0J3Mgbm8gcHJvYmxlbSB0byB1cGRhdGUgdGhlIGNvZGUuIEknbGwgYmUg
aGFwcHkgaWYgdGhpcyBjb2RlIGlzIG1vcmUNCnVuZGVyc3RhbmRhYmxlIGZvciBub24tdGR4IGRl
dmVsb3BlcnMuDQoNCkFzIGZvciB0aGUgbmFtZSwgSSBndWVzcyBJJ2QgYmUgbGVzcyBrZWVuIG9u
ICJvZmZzZXQiIGJlY2F1c2UgaXQncyBub3QgY2xlYXINCnRoYXQgaXQgaXMgYSBwb3dlci1vZi10
d28gdmFsdWUgdGhhdCBjYW4gYmUgdXNlZCB3aXRoIGJpdHdpc2Ugb3BlcmF0aW9ucy4gDQoNCkkn
bSBub3Qgc3VyZSB3aGF0IHRoZSAiZml4ZWQiIGFkZHMgYW5kIGl0IG1ha2VzIGl0IGxvbmdlci4g
QWxzbywgbWFueSBQVEUgYml0cw0KY2Fubm90IGJlIG1vdmVkIGFuZCB0aGV5IGFyZSBub3QgcmVm
ZXJyZWQgdG8gYXMgZml4ZWQsIHdoZXJlIHRoZSBzaGFyZWQgYml0DQphY3R1YWxseSAqY2FuKiBi
ZSBtb3ZlZCB2aWEgR1BBVyAobm90IHRoYXQgdGhlIE1NVSBjb2RlIGNhcmVzIGFib3V0IHRoYXQN
CnRob3VnaCkuDQoNCkp1c3QgImJpdHMiIHNvdW5kcyBiZXR0ZXIgdG8gbWUsIHNvIG1heWJlIEkn
bGwgdHJ5Pw0Ka3ZtX2dmbl9kaXJlY3RfYml0cygpDQprdm1fZ2ZuX3Jvb3RfYml0cygpDQoNCj4g
DQo+ID4gK30NCj4gPiArDQo+ID4gwqAgc3RhdGljIGlubGluZSBib29sIGt2bV9tbXVfcGFnZV9h
ZF9uZWVkX3dyaXRlX3Byb3RlY3Qoc3RydWN0IGt2bV9tbXVfcGFnZQ0KPiA+ICpzcCkNCj4gPiDC
oCB7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoCAvKg0KPiA+IEBAIC0zNTksNyArMzY4LDEyIEBAIHN0
YXRpYyBpbmxpbmUgaW50IF9fa3ZtX21tdV9kb19wYWdlX2ZhdWx0KHN0cnVjdA0KPiA+IGt2bV92
Y3B1ICp2Y3B1LCBncGFfdCBjcjJfb3JfZ3ANCj4gPiDCoMKgwqDCoMKgwqDCoMKgIGludCByOw0K
PiA+IA0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHZjcHUtPmFyY2gubW11LT5yb290X3JvbGUu
ZGlyZWN0KSB7DQo+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZmF1bHQuZ2ZuID0g
ZmF1bHQuYWRkciA+PiBQQUdFX1NISUZUOw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIC8qDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIFRoaW5ncyBsaWtl
IG1lbXNsb3RzIGRvbid0IHVuZGVyc3RhbmQgdGhlIGNvbmNlcHQgb2YgYQ0KPiA+IHNoYXJlZA0K
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBiaXQuIFN0cmlwIGl0IHNvIHRo
YXQgdGhlIEdGTiBjYW4gYmUgdXNlZCBsaWtlIG5vcm1hbCwNCj4gPiBhbmQgdGhlDQo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGZhdWx0LmFkZHIgY2FuIGJlIHVzZWQgd2hl
biB0aGUgc2hhcmVkIGJpdCBpcyBuZWVkZWQuDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAqLw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGZhdWx0LmdmbiA9
IGdwYV90b19nZm4oZmF1bHQuYWRkcikgJg0KPiA+IH5rdm1fZ2ZuX2RpcmVjdF9tYXNrKHZjcHUt
Pmt2bSk7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZmF1bHQuc2xvdCA9
IGt2bV92Y3B1X2dmbl90b19tZW1zbG90KHZjcHUsIGZhdWx0Lmdmbik7DQo+IA0KPiBQbGVhc2Ug
YWRkIGEgY29tbWVudCB0byBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQncyBnZm4gZmllbGQsIGFib3V0
IGhvdw0KPiBpdCBkaWZmZXJzIGZyb20gYWRkci4NCg0KRG9oLCB5ZXMgdG90YWxseS4NCg0KPiAN
Cj4gPiArwqDCoMKgwqDCoMKgIC8qIE1hc2sgYXBwbGllZCB0byBjb252ZXJ0IHRoZSBHRk4gdG8g
dGhlIG1hcHBpbmcgR1BBICovDQo+ID4gK8KgwqDCoMKgwqDCoCBnZm5fdCBnZm5fbWFzazsNCj4g
DQo+IHMvbWFzay9vZmZzZXQvIG9yIHMvbWFzay9maXhlZF9iaXRzLyBoZXJlLCBpZiB5b3UgZ28g
Zm9yIGl0OyB3b24ndA0KPiByZXBlYXQgbXlzZWxmIGJlbG93Lg0KPiANCj4gPiDCoMKgwqDCoMKg
wqDCoMKgIC8qIFRoZSBsZXZlbCBvZiB0aGUgcm9vdCBwYWdlIGdpdmVuIHRvIHRoZSBpdGVyYXRv
ciAqLw0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgaW50IHJvb3RfbGV2ZWw7DQo+ID4gwqDCoMKgwqDC
oMKgwqDCoCAvKiBUaGUgbG93ZXN0IGxldmVsIHRoZSBpdGVyYXRvciBzaG91bGQgdHJhdmVyc2Ug
dG8gKi8NCj4gPiBAQCAtMTIwLDE4ICsxMjIsMTggQEAgc3RydWN0IHRkcF9pdGVyIHsNCj4gPiDC
oMKgICogSXRlcmF0ZXMgb3ZlciBldmVyeSBTUFRFIG1hcHBpbmcgdGhlIEdGTiByYW5nZSBbc3Rh
cnQsIGVuZCkgaW4gYQ0KPiA+IMKgwqAgKiBwcmVvcmRlciB0cmF2ZXJzYWwuDQo+ID4gwqDCoCAq
Lw0KPiA+IC0jZGVmaW5lIGZvcl9lYWNoX3RkcF9wdGVfbWluX2xldmVsKGl0ZXIsIHJvb3QsIG1p
bl9sZXZlbCwgc3RhcnQsIGVuZCkgXA0KPiA+IC3CoMKgwqDCoMKgwqAgZm9yICh0ZHBfaXRlcl9z
dGFydCgmaXRlciwgcm9vdCwgbWluX2xldmVsLCBzdGFydCk7IFwNCj4gPiAtwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBpdGVyLnZhbGlkICYmIGl0ZXIuZ2ZuIDwgZW5kO8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBcDQo+ID4gKyNkZWZpbmUgZm9yX2VhY2hfdGRwX3B0ZV9taW5f
bGV2ZWwoaXRlciwga3ZtLCByb290LCBtaW5fbGV2ZWwsIHN0YXJ0LA0KPiA+IGVuZCnCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwNCj4gPiArwqDCoMKgwqDCoMKgIGZvciAodGRwX2l0ZXJf
c3RhcnQoJml0ZXIsIHJvb3QsIG1pbl9sZXZlbCwgc3RhcnQsDQo+ID4ga3ZtX2dmbl9yb290X21h
c2soa3ZtLCByb290KSk7IFwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpdGVyLnZhbGlk
ICYmIGl0ZXIuZ2ZuIDwNCj4gPiBlbmQ7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBcDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGRwX2l0ZXJfbmV4dCgmaXRl
cikpDQo+ID4gDQo+ID4gLSNkZWZpbmUgZm9yX2VhY2hfdGRwX3B0ZShpdGVyLCByb290LCBzdGFy
dCwgZW5kKSBcDQo+ID4gLcKgwqDCoMKgwqDCoCBmb3JfZWFjaF90ZHBfcHRlX21pbl9sZXZlbChp
dGVyLCByb290LCBQR19MRVZFTF80Sywgc3RhcnQsIGVuZCkNCj4gPiArI2RlZmluZSBmb3JfZWFj
aF90ZHBfcHRlKGl0ZXIsIGt2bSwgcm9vdCwgc3RhcnQsDQo+ID4gZW5kKcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFwNCj4gPiArwqDCoMKgwqDCoMKg
IGZvcl9lYWNoX3RkcF9wdGVfbWluX2xldmVsKGl0ZXIsIGt2bSwgcm9vdCwgUEdfTEVWRUxfNEss
IHN0YXJ0LCBlbmQpDQo+IA0KPiBNYXliZSBhZGQgdGhlIGt2bSBwb2ludGVyIC8gcmVtb3ZlIHRo
ZSBtbXUgcG9pbnRlciBpbiBhIHNlcGFyYXRlIHBhdGNoDQo+IHRvIG1ha2UgdGhlIG1hc2stcmVs
YXRlZCBjaGFuZ2VzIGVhc2llciB0byBpZGVudGlmeT8NCg0KSG1tLCB5ZWEuIEkgY2FuIHNwbGl0
IGl0Lg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4
Ni9rdm0veDg2LmMNCj4gPiBpbmRleCA3YzU5M2EwODFlYmEuLjBlNjMyNWI1ZjVlNyAxMDA2NDQN
Cj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2
LmMNCj4gPiBAQCAtMTM5ODcsNiArMTM5ODcsMTYgQEAgaW50IGt2bV9zZXZfZXNfc3RyaW5nX2lv
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiB1bnNpZ25lZCBpbnQgc2l6ZSwNCj4gPiDCoCB9
DQo+ID4gwqAgRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX3Nldl9lc19zdHJpbmdfaW8pOw0KPiA+IA0K
PiA+ICsjaWZkZWYgX19LVk1fSEFWRV9BUkNIX0ZMVVNIX1JFTU9URV9UTEJTX1JBTkdFDQo+ID4g
K2ludCBrdm1fYXJjaF9mbHVzaF9yZW1vdGVfdGxic19yYW5nZShzdHJ1Y3Qga3ZtICprdm0sIGdm
bl90IGdmbiwgdTY0DQo+ID4gbnJfcGFnZXMpDQo+ID4gK3sNCj4gPiArwqDCoMKgwqDCoMKgIGlm
ICgha3ZtX3g4Nl9vcHMuZmx1c2hfcmVtb3RlX3RsYnNfcmFuZ2UgfHwNCj4gPiBrdm1fZ2ZuX2Rp
cmVjdF9tYXNrKGt2bSkpDQo+IA0KPiBJIHRoaW5rIHRoZSBjb2RlIG5lZWQgbm90IGNoZWNrIGt2
bV9nZm5fZGlyZWN0X21hc2soKSBoZXJlPyBJbiB0aGUgb2xkDQo+IHBhdGNoZXMgdGhhdCBJIGhh
dmUgaXQgY2hlY2sga3ZtX2dmbl9kaXJlY3RfbWFzaygpIGluIHRoZSB2bXgvbWFpbi5jDQo+IGNh
bGxiYWNrLg0KDQpZb3UgbWVhbiBhIFZNWC9URFggaW1wbGVtZW50YXRpb24gb2YgZmx1c2hfcmVt
b3RlX3RsYnNfcmFuZ2UgdGhhdCBqdXN0IHJldHVybnMNCi1FT1BOT1RTVVBQPyBXaGljaCB2ZXJz
aW9uIG9mIHRoZSBwYXRjaGVzIGlzIHRoaXM/IEkgY291bGRuJ3QgZmluZCBhbnl0aGluZyBsaWtl
DQp0aGF0Lg0KDQpCdXQgSSBndWVzcyB3ZSBjb3VsZCBhZGQgb25lIGluIHRoZSBsYXRlciBwYXRj
aGVzLiBJbiB3aGljaCBjYXNlIHdlIGNvdWxkIGRyb3ANCnRoZSBodW5rIGluIHRoaXMgb25lLiBJ
IHNlZSBiZW5lZml0IGJlaW5nIGxlc3MgY2h1cm4uDQoNCg0KVGhlIGRvd25zaWRlIHdvdWxkIGJl
IHdpZGVyIGRpc3RyaWJ1dGlvbiBvZiB0aGUgY29uY2VybnMgZm9yIGRlYWxpbmcgd2l0aA0KbXVs
dGlwbGUgYWxpYXNlcyBmb3IgYSBHRk4uIEN1cnJlbnRseSwgdGhlIGJlaGF2aW9yIHRvIGhhdmUg
bXVsdGlwbGUgYWxpYXNlcyBpcw0KaW1wbGVtZW50ZWQgaW4gY29yZSBNTVUgY29kZS4gV2hpbGUg
aXQncyBmaW5lIHRvIHBvbGx1dGUgdGR4LmMgd2l0aCBURFggc3BlY2lmaWMNCmtub3dsZWRnZSBv
ZiBjb3Vyc2UsIHJlbW92aW5nIHRoZSBoYW5kbGluZyBvZiB0aGlzIGNvcm5lciBmcm9tIG1tdS5j
IG1pZ2h0IG1ha2UNCml0IGxlc3MgdW5kZXJzdGFuZGFibGUgZm9yIG5vbi10ZHggcmVhZGVycyB3
aG8gYXJlIHdvcmtpbmcgaW4gTU1VIGNvZGUuDQpCYXNpY2FsbHksIGlmIGEgY29uY2VwdCBmaXRz
IGludG8gc29tZSBub24tVERYIGFic3RyYWN0aW9uIGxpa2UgdGhpcywgaGF2aW5nIGl0DQppbiBj
b3JlIGNvZGUgc2VlbXMgdGhlIGJldHRlciBkZWZhdWx0IHRvIG1lLg0KDQpGb3IgdGhpcyByZWFz
b24sIG15IHByZWZlcmVuY2Ugd291bGQgYmUgdG8gbGVhdmUgdGhlIGxvZ2ljIGluIGNvcmUgY29k
ZS4gQnV0IEknbQ0KZmluZSBjaGFuZ2luZyBpdC4gSSdsbCBtb3ZlIGl0IGludG8gdGhlIHRkeC5j
IGZvciBub3csIHVubGVzcyB5b3UgYXJlIGNvbnZpbmNlZA0KYnkgdGhlIGFib3ZlLg0K

