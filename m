Return-Path: <kvm+bounces-20942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C789927145
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4410B22646
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0DC1A3BC2;
	Thu,  4 Jul 2024 08:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DDDD77Nc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD15410A35;
	Thu,  4 Jul 2024 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720080652; cv=fail; b=sgxTzA4k36+dxSO0sm7fHZASmBRtTVoMyMwYPdipvSRZyfUGc+0UmYFY/nh7NJ/89px8iJsep5gziAr8mXRFQZGGtsWxJJfghAU3CyvM/ZyvmEXdlFdA3I8CJgNWc55QeTIDksLhts0TFYe6o4leEFKrLOA+L6ArqO34XX/b5Eg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720080652; c=relaxed/simple;
	bh=eqYrgicXq708vqbCcB9tI0MrJ0U1TrT08ashONzmfQU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FmZi3EWVGUlfvo+WZxXcbH9Pr9D/KbWwztQB+rtaa6sL2bSYQ+3QAYT94iqQOImlsKTgg7Nu7JnoCqSc0jwKc8HmFUmMGxt7vuYCiOk98h1Ki69pJwMWluf2xIpoFgRdxu+h9765FaEr1nmQpieNs6cy8UKMIGXyO1olZY1ZFj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DDDD77Nc; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720080651; x=1751616651;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=eqYrgicXq708vqbCcB9tI0MrJ0U1TrT08ashONzmfQU=;
  b=DDDD77Nc5rJzH0wC2I7FLSGtjC47prA9y1+UZi0ygnYIIMOwX+P1nLh5
   1NPsKSGYDrJqx21hoMunharNL546sT6wrfqTjwNCWP+N3Rtl+AihiRkS9
   VOwNJ60SfcXtL7jBZWarZmkdn3CvamQMPk3fqys+jVz+442FC8Prw/Pm9
   SOuqYOknkX6Ece8db1uTCIJgvUoww+8Bm+8DoRoGsWIdodRAhO2XCp4qr
   RlIGeck6YI/bMKY15BxE3GNLR9ca3UEHXw5pg5hmVWTKL6A7R7SzRXdpz
   hzINREkyNKbvzNrPPdOIs5rwye1rKqHI93glqv9RwRLqmoeAKuGRc6+D3
   w==;
X-CSE-ConnectionGUID: IDF7iNo9Q2Sbbdc5JvFjtQ==
X-CSE-MsgGUID: 8f3705UVT6mKywKll/1trw==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="21214805"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="21214805"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 01:10:44 -0700
X-CSE-ConnectionGUID: McaZQ6XsSW+8IEJyHH5nAQ==
X-CSE-MsgGUID: /Q8sGgUZTtSlFT7K8hdlaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="51110889"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jul 2024 01:10:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 4 Jul 2024 01:10:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 4 Jul 2024 01:10:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 4 Jul 2024 01:10:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdb9FFxuXgc0gAwAQU9WbVvP7UqxKGqN7mZOfnbKvuC4pQMTK9Nl6NwyMfOYfzTRx2pkXK6cU6Lqmompio02CHqzKHuPnTzc4yI2aNer2diNGBtBqNW/l1IQdE7TxUnkN5bfUmXxj3+zsn1Hc03XFN0/1yW9ga5jzdpMdC2eRTXnglYm1MLNBLXQeXNQXDmOFpvimssNjiQiuPhx9y3ANeEsdQEtz7fPJxuTtbUCFCgYdRuzaB3hmo4mn4x1MxdZLVPuydzrbnIGsDgvPpHmSug9sRk981KkU+weuJ2a+9obbgka47JsynGAPMLAAYrRa+g5W9SHKq2XrcEzrA9sDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sA8TMMkCULyg1uoLJ8pxVY8RHpocmc2wX9z/jverJI0=;
 b=Qq1COcvJaov2gNIQjclMBsNTrikx8N+GVdiq7GRC5TvDTUZZXTDmhSRfHKgHU0B5gPU94Lo7hOl85KQlbH8bkU4cwGM7mp4h3nqFWlHROY2mY87crQi7x97nqgQIJ2yHFnxPHqCDc47Y+Nui9IzLG4MCQBET26wJo0WSNIqFL88JlOJEOYY0SQlS+LyqN48ErfdwpOi5lzTMsmxkTvOKVJfs5lkL00rdp07S92mTHZZltj0ZwkxccQYh01p37QF6Dy0i5X8nQBa22fC6z34gI5HTXxGAoy1/NHo9G751PSxNCu4dKM6IQkeOXTWHMJbwGBKhEDLXsg1YY/KIJJO8QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by PH7PR11MB6748.namprd11.prod.outlook.com (2603:10b6:510:1b6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Thu, 4 Jul
 2024 08:10:38 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.7719.029; Thu, 4 Jul 2024
 08:10:38 +0000
Date: Thu, 4 Jul 2024 16:09:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Message-ID: <ZoZYryszKWI5IYy5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
 <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
 <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
 <ZnpY7Va5ZlAwGZSi@yzhao56-desk.sh.intel.com>
 <70dab5f4fb69c072493efe4b3198305ae262b545.camel@intel.com>
 <ZnuhfnLH+m3cV2/U@yzhao56-desk.sh.intel.com>
 <7268ff80d3825fa6d7a50101358b47d5fbe86d5c.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7268ff80d3825fa6d7a50101358b47d5fbe86d5c.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|PH7PR11MB6748:EE_
X-MS-Office365-Filtering-Correlation-Id: f0b3695c-acb6-4c78-b3ae-08dc9c00c97e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?jH0fGWy6n3SvhUxvW+fhzOSCSJV+5fSu1APCt+/nAeXRSGCPVnku4sU8yO?=
 =?iso-8859-1?Q?S9IB4oxAJ1Hgu9QG6pynP+u9VVqGBE9XmrFzMfWfCISHc3Pe1IFSdX5/aF?=
 =?iso-8859-1?Q?y4tr1mm4IF1vhEoe4OGnFySkKAiGne84qIxBSPLKu/8gclG2kS7nl0MwKz?=
 =?iso-8859-1?Q?NrHjjbw4UTfHK6/nBky3AOHYxKMUDpCIj+MuoIv2hPSmHUtIISQxzQSqJa?=
 =?iso-8859-1?Q?AWzndYtluCdtdQtPfyKg5RFJ0INsOlbU5EMyd8a5ojReOvljiatmN+Jt1i?=
 =?iso-8859-1?Q?SjsAuIMv7S08Pwzt2pkbLoVY9zNA/GP9BJ1/VElcp6WFWTdtoboj4lG0M3?=
 =?iso-8859-1?Q?6wmzGjrQRxiikCMoGVrMnHxqsoolAxc8G7PXH0eQYrwyrD38WFFmVib+c8?=
 =?iso-8859-1?Q?0h0Zrj+i0HwXdoYWSSTy/rd5oNYpZ7lr5L2io7b/ARz073ourDEg4agukq?=
 =?iso-8859-1?Q?AC/fJgOijsIpGAOwk6Mi2OWmYixuDZsggS/qM00gTGdyKNgvvnbXvR5nJ6?=
 =?iso-8859-1?Q?4P+iwZOwIapIWi9dGLLtgNe0t6Zpx+fMaQnnu5HyGZq5B4v0NuWDSW2VFa?=
 =?iso-8859-1?Q?vOWvQZwzpwDJfeGS4QQbjCgMnNw2Ym038H076kxduvHGEmKjiT7x3hHdCm?=
 =?iso-8859-1?Q?WOD2Bl0tuWRGSPd+lOZ2c4ILstq3/XdBAAV9NMswCoNOKyongT5PHbKEAG?=
 =?iso-8859-1?Q?Ux0kcKCz/uxQOD2tNztM8VtOvWrV/GjFJ/IPI/7bdY2syizjx+zZujn59m?=
 =?iso-8859-1?Q?8EELy0iXM/LWgE+6KkAoMtaI4wDWuWlLxciiJVPgwboaRcUicCBN83Wtbe?=
 =?iso-8859-1?Q?ne+klF5256n5aA47FaKeC1lufLvKWKFrftrkuo61aF/HcV9eZ1kjZvCzlu?=
 =?iso-8859-1?Q?rilEunT9Y5mN3DU30BYiei88k7ygNx4i0CZpNTcnZ0CZ54h8ot7Ji2DfYl?=
 =?iso-8859-1?Q?5xVcWCTp32cH/iIgk5NN49VzlVPmKz1eX2y0byVq/anbwSm0AqxFM+5ETB?=
 =?iso-8859-1?Q?FRAFabZqakmF/B96I3WQ6hsR98EUgnZos9jorRyPgQUfhGi0Bqsy0yqahD?=
 =?iso-8859-1?Q?2pq03n++7bShQ2XkD260ZLuAMD8BGSFAwrE7Y8dIckBELkm1rVDoQU220t?=
 =?iso-8859-1?Q?9gvzQTPl3nGOBp8/7Vg/vvNrejNN5IWBRo+l0BoUr73GsNCKgUL0Y6B5Q0?=
 =?iso-8859-1?Q?zBmwFxuUenW/8wzXUdUa44MtKMXDZN18aBasjuflq9QvTHp3gxEePYg3R3?=
 =?iso-8859-1?Q?9SnyOG8NC6d1V+XffV+x3mgdMhcb1Cnv53cySiC+Au5ijwmaKG/uwYXeAt?=
 =?iso-8859-1?Q?hEDFmwK051AOQcjrk84SXzJ1HNay1T8XJ1opAZgoppSWIHA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wby8nipfq8VHJbpZvWozKufG9jPc2e6f72Ieeyt6y1JfUx+0TmK/688NFM?=
 =?iso-8859-1?Q?OxowKkFgTW5YGvKcgl9bdon6jPNe7H5W8yj854i34i1BtI+vMqA8++wc8F?=
 =?iso-8859-1?Q?gBx67ojQaNPRFHFxe8+OpC5ZWNVZlLzcVPRpzgxhbqczFzj/qboPUEDx2N?=
 =?iso-8859-1?Q?uoMoYtpdLTYNvNudO7urRWb8/NxsfM/Gyn6MFOaKsbT4qTL6OZqZlJubQf?=
 =?iso-8859-1?Q?VGXTOIiDH+eOGi8Y7CrqzPVdwF8TAV4FnkX+U0kg2Nf+6vWmPI+8PNksne?=
 =?iso-8859-1?Q?w7H8H0w6fPAQfdzGhBdN7xQgB0gy0aF3itsWxaPr7TMlS5Xc7t0EpNBV1F?=
 =?iso-8859-1?Q?D4M1dDv1vnUJv//RHhPD0VvyBvbm5X3GmPotSpoZfE3ptpz1bvKq/WSejL?=
 =?iso-8859-1?Q?WqqgimDA316JqUXiRsUgjTwgZ+371u6hyUxl0hv2+ivu/d+YefxAvGJ2Lq?=
 =?iso-8859-1?Q?X6woZwU4blwq5G0pLZNjP37FTihu0V2fcH+cTiFEY9hHUoyh7C4k8IsVrB?=
 =?iso-8859-1?Q?OABzJs48oiIDdDmejxWBmr0ckeiR0BX/CGJ9+oIv3RfZV4vg9PeWXiPTe4?=
 =?iso-8859-1?Q?4h/3OHEa7S2q/vRJXuBUObFCfvTH7049oufxgl+SZNlABGCbVwNcpzY/AM?=
 =?iso-8859-1?Q?PcVxC3lCOPSJrcIa4jCEC32lyTh62gfYj9pVmK8KTpPqR9nAw33C5IxrNf?=
 =?iso-8859-1?Q?jDdCPv1IqiyQ6CXntN/yv2JrQm3Cznij9m9ZekGMfjoQEdnsrmzfyAWGHv?=
 =?iso-8859-1?Q?L4Whp4JtfB3ikwi8K9B4iVYAVuDmFl1egO2uk1m9M/75vACruzZRwW83BR?=
 =?iso-8859-1?Q?pzefy+7w6dcsvICyQC2Gn/SKjVv+n7ZBk7jTl0ynr2CoHeJhcKKTIWJbiI?=
 =?iso-8859-1?Q?EcXxCl5D9DYN7PalR/L9exz+AL+bNB73stJQxF4bMFDuHjWBQHDFPra4PV?=
 =?iso-8859-1?Q?oQvua42nn/lKqgomCBbGSA+vZmC0Vg19mK02+xa6sEVcbNEFieiAO4hY3O?=
 =?iso-8859-1?Q?rjCjWgp63aO1tXyAENl+c3quZ4FbmG90XY/7HwcuouqCWjjbaQTu9O5xPY?=
 =?iso-8859-1?Q?OHhNnDYa7jTrCIgxuxXfhbaYHrYzBeXTzDeLFHPE3Wghp2jsQNUbBZIR//?=
 =?iso-8859-1?Q?10KFLe47T+R2FuktKLthXvdqb5VkqJTVdkagwwP0rjFuGC/jAsbBHxmGHC?=
 =?iso-8859-1?Q?4KbIEOPLtYRqHiDpehxV+wODiIH7K2oDc1+CZaNlACeILHhcadDmUR5hw/?=
 =?iso-8859-1?Q?pbGwrKiwsspVjNU5C6xbNwwtErqdRNGGbCGuUDZycsXKQ/tJ2zyTLXkkBP?=
 =?iso-8859-1?Q?OXOmavmWeoUqSdBWwiykQ8dT9csW3Hn8VYY02kGGPc257/tLZ+QfaLV4Xs?=
 =?iso-8859-1?Q?Q5T9QqKrtbD0DyGuFx4atgLuG/nR0TxD3JQmJMaehsyG54UcKk4OFSyI6V?=
 =?iso-8859-1?Q?VO+ayjRPDcjHRypxFATeCRComohZkLO13VMMu76+5dfIQgTRLq8xmfUwcT?=
 =?iso-8859-1?Q?opoegisXHEy41VwTf0jTV0iJ5pwhVTwtaBXy0Zmq+DnsOkyL9Hagq0xL9R?=
 =?iso-8859-1?Q?H0Va0aMh4/d4TfL36XtSx2AhR1wC5iN+vEK09FtK4NuAIApAdyO7EdIU5u?=
 =?iso-8859-1?Q?Ha2xWAK6AgXDGX72jnkJuG+QQJVQMkMCFo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b3695c-acb6-4c78-b3ae-08dc9c00c97e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 08:10:38.1702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/NAsIPBO8BTcaJdJtdQGTIs5Z3gnQBSAM5aHnN0+PD4HfUeyDqmDTjMpQJtePZfW/mbeDrWXqwNL+dnH/DXJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6748
X-OriginatorOrg: intel.com

On Thu, Jul 04, 2024 at 03:40:35AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2024-06-26 at 13:05 +0800, Yan Zhao wrote:
> > But we still need the reload path to have each vcpu to hold a ref count of the
> > mirror root.
> > What about below fix?
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 026e8edfb0bd..4decd13457ec 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -127,9 +127,28 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
> >  void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> >                          int bytes);
> > 
> > +static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
> > +{
> > +       return kvm->arch.vm_type == KVM_X86_TDX_VM;
> > +}
> > +
> > +static inline bool kvm_mmu_root_hpa_is_invalid(struct kvm_vcpu *vcpu)
> > +{
> > +       return vcpu->arch.mmu->root.hpa == INVALID_PAGE;
> > +}
> > +
> > +static inline bool kvm_mmu_mirror_root_hpa_is_invalid(struct kvm_vcpu *vcpu)
> > +{
> > +       if (!kvm_has_mirrored_tdp(vcpu->kvm))
> > +               return false;
> > +
> > +       return vcpu->arch.mmu->mirror_root_hpa == INVALID_PAGE;
> > +}
> > +
> >  static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
> >  {
> > -       if (likely(vcpu->arch.mmu->root.hpa != INVALID_PAGE))
> > +       if (!kvm_mmu_root_hpa_is_invalid(vcpu) &&
> > +           !kvm_mmu_mirror_root_hpa_is_invalid(vcpu))
> 
> If we go this way, we should keep the likely. But, I'm not convinced.
> 
> >                 return 0;
> > 
> >         return kvm_mmu_load(vcpu);
> > @@ -322,11 +341,6 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu
> > *vcpu,
> >         return translate_nested_gpa(vcpu, gpa, access, exception);
> >  }
> > 
> > -static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
> > -{
> > -       return kvm->arch.vm_type == KVM_X86_TDX_VM;
> > -}
> > -
> >  static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
> >  {
> >         return kvm->arch.gfn_direct_bits;
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e1299eb03e63..5e7d92074f70 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3702,9 +3702,11 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu
> > *vcpu)
> >         int r;
> > 
> >         if (tdp_mmu_enabled) {
> > -               if (kvm_has_mirrored_tdp(vcpu->kvm))
> > +               if (kvm_mmu_mirror_root_hpa_is_invalid(vcpu))
> >                         kvm_tdp_mmu_alloc_root(vcpu, true);
> > -               kvm_tdp_mmu_alloc_root(vcpu, false);
> > +
> > +               if (kvm_mmu_root_hpa_is_invalid(vcpu))
> > +                       kvm_tdp_mmu_alloc_root(vcpu, false);
> 
> So we can have either:
> mirror_root_hpa = INVALID_PAGE
> root.hpa = INVALID_PAGE
> 
> or:
> mirror_root_hpa = root
> root.hpa = INVALID_PAGE
> 
> We don't ever have:
> mirror_root_hpa = INVALID_PAGE
> root.hpa = root
> 
> Because mirror_root_hpa is special.
> 
Good point.

> >                 return 0;
> >         }
> > 
> 
> Having the check in kvm_mmu_reload() and here both is really ugly.  Right now we
> have kvm_mmu_reload() which only allocates new roots if needed, then
> kvm_mmu_load() goes and allocates/references them. Now mmu_alloc_direct_roots()
> has the same logic to only reload as needed.
> 
> So could we just leave the kvm_mmu_reload() logic as is, and just have special
> logic in mmu_alloc_direct_roots() to not avoid re-allocating mirror roots? This
> is actually what v19 had, but it was thought to be a historical relic:
>    "Historically we needed it.  We don't need it now. We can drop it."
> https://lore.kernel.org/kvm/20240325200122.GH2357401@ls.amr.corp.intel.com/
> 
> So just have this small fixup instead?
Yes.

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ae5d5dee86af..2e062178222e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3705,7 +3705,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>         int r;
>  
>         if (tdp_mmu_enabled) {
> -               if (kvm_has_mirrored_tdp(vcpu->kvm))
> +               if (kvm_has_mirrored_tdp(vcpu->kvm) &&
> +                   !VALID_PAGE(mmu->mirror_root_hpa))
>                         kvm_tdp_mmu_alloc_root(vcpu, true);
>                 kvm_tdp_mmu_alloc_root(vcpu, false);
>                 return 0;
> 
Perhaps also a comment in kvm_mmu_reload() to address concerns like why checking
only root.hpa in kvm_mmu_reload() is enough.

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 03737f3aaeeb..aba98c8cc67d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -129,6 +129,15 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
+       /*
+        * Checking root.hpa is sufficient even when KVM has mirror root.
+        * We can have either:
+        * (1) mirror_root_hpa = INVALID_PAGE, root.hpa = INVALID_PAGE
+        * (2) mirror_root_hpa = root ,        root.hpa = INVALID_PAGE
+        * (3) mirror_root_hpa = root1,        root.hpa = root2
+        * We don't ever have:
+        *     mirror_root_hpa = INVALID_PAGE, root.hpa = root
+        */
        if (likely(vcpu->arch.mmu->root.hpa != INVALID_PAGE))
                return 0;
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a5f803f1d17e..eee35e958971 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3705,7 +3705,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
        int r;
 
        if (tdp_mmu_enabled) {
-               if (kvm_has_mirrored_tdp(vcpu->kvm))
+               if (kvm_has_mirrored_tdp(vcpu->kvm) &&
+                   !VALID_PAGE(mmu->mirror_root_hpa))
                        kvm_tdp_mmu_alloc_root(vcpu, true);
                kvm_tdp_mmu_alloc_root(vcpu, false);
                return 0;

