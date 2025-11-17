Return-Path: <kvm+bounces-63392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 69446C6534B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 17:41:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8409C385587
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 16:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C584F2C0F95;
	Mon, 17 Nov 2025 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WacZeRk3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE9D224249;
	Mon, 17 Nov 2025 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763397050; cv=fail; b=HMSkDQq/sJQTipte6wPIvZ70GExf4x+MqNG8GJ08E17YV7L0EAvraHXYMNEzUEn0FoN5OSy27XRHwUKr6dbjRMZVWZ3oHChd1WwXdNY2WF2/K+xUQenSpQrLaONR0gSAYNZpuNcc/dCOBcynIee3CZNyz/RCoLCCcuxKXY3RNmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763397050; c=relaxed/simple;
	bh=6wY9tfnwTdgT52PVSVJLC1dOuRsV6OhnE69Ic8dpDXg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Mcc5XHNu0MEImE8VC3uJtzGW+gGAm8UwfWPNvHlyil0i79ydcNx2CnGFLM3P4S9Xrbznwp4jrV8tCV/3JwDepQlXgY5sYtc2W9D8xyXda9ICGAdrOA2BqFvPWpGemSQbWYv3653X0Ji6rZs/Y3cp/VZ7z23b9OpxqB+EzJKg7oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WacZeRk3; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763397049; x=1794933049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6wY9tfnwTdgT52PVSVJLC1dOuRsV6OhnE69Ic8dpDXg=;
  b=WacZeRk3TM+XjXgoG8pNNXcYQoNyTx59BxMMG2X3Fd5AglhqYAALKMqm
   kD73H//pmPo7hGHugKMteaW7FBIc9HWMUROu/5On8wIGYWx84Y4xZaYSM
   30dZcB9U/qHwDqsKhnNw1AA4pE9kH6CPQoGbVKJQEbTKNLO4wR+a7wIt3
   RPxt+nl9KRtfkExS/4YEltxexfnQTj3EhUYMI1WRcn8XCnhCyZmZUrfei
   Mdfcz2b57cq9NfIslpdbS6JGxvgBlEjcxtN/fyAzZxJbF6Ruz/KaFuHal
   pEyBz3nicVzLv171JOdF3EeUWQUK7eDQOE/KOypvlLOTs/HoAmEx4Dd3Y
   Q==;
X-CSE-ConnectionGUID: ddVgsy0lSLytNggYBDWAcw==
X-CSE-MsgGUID: IKkJuFH5RH+WKNgTYxUnSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76079077"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="76079077"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 08:30:48 -0800
X-CSE-ConnectionGUID: egJpZVQNTeaR8dUmCKw4xA==
X-CSE-MsgGUID: KRmiMSpgQVSwXCH8iKF/vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="194963420"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 08:30:48 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 08:30:47 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 08:30:47 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 08:30:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Db1OAiDU1bq/NkRtxhxjXYpFjKJ/MQJkoqwe1kFpJVjKM82r7FDbv8gpW9BO9j4HZjBvxlQ+Fj8TCp9yX0bBjpIMpouGRe9hDtK5O9gTAp3/kgz8q3GOeOERn4qD+fygP1NrU+LDxW3oDS7rJT01Wku8DG94Jt2bIIqdRgwgiHrLB4mctLzroUEgOojiARzYfQBZIiPSTBQVttzL2AoRldR74kcfx3+i1cqB1uLUCve7ZxziB1HWnPUw9XHRvd5f5MJkb/3YxKj/IT8x9W9cyarCg2KLZd/KEom+ba3ePV0ygePtlezF/lUpWBetbmzN2CWa96A4qRlb5eOp6gKAUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wY9tfnwTdgT52PVSVJLC1dOuRsV6OhnE69Ic8dpDXg=;
 b=IGvDp3gg3eNijt12EydtpY9gEjwanlMvBHj7AY7SoSf1p8NK3tWy40kQl7DbV909wjkcLYNuXLSqddBc9SPBwS1lOwz9UgZbxiSIhjyXUYJnI4TBUrZ0NbGHVqoCMcsM7tCQyCrNoTKCODldKTPA/L36W6tyIZdHFeAO9ef6HeRF8/WWmYIwbGIRyGB3VH48wJ/ms9QClJ6OoAPnhirtgbMz6VlKeLusI8Ttlm/U5mmRlDdOj+9tD9I99h+QgCzTEnbKSdEH4VXujCUWIOoxpJXjhwRBW6zI3zqagxqiqxwEhvfNVqvQCwfTQC5aCxD9GTE4Yl1Rb1tZVjXxfvuU5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7164.namprd11.prod.outlook.com (2603:10b6:303:212::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Mon, 17 Nov
 2025 16:30:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 16:30:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Kohler, Jon" <jon@nutanix.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of
 the fastpath
Thread-Topic: [PATCH 2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside
 of the fastpath
Thread-Index: AQHcSr1b5K/fECNp/ES17skI77l1obT26MAAgABA4AA=
Date: Mon, 17 Nov 2025 16:30:38 +0000
Message-ID: <a84c72849f021c4fec99caadd0a681146d8e5b6e.camel@intel.com>
References: <20251030224246.3456492-1-seanjc@google.com>
	 <20251030224246.3456492-3-seanjc@google.com>
	 <aRsXVvDHsdCjEgPM@tlindgre-MOBL1>
In-Reply-To: <aRsXVvDHsdCjEgPM@tlindgre-MOBL1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7164:EE_
x-ms-office365-filtering-correlation-id: 91a76f6f-81d1-4eb0-2736-08de25f6a45f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Uk9VNFlYcmNrMk10cHVXSjRkWWRBditLR3hha3haRjVkS2EyWkMzVjRMSTh5?=
 =?utf-8?B?bEgxUjB1b1B4OCszQ0tSbkpuUkFsaHQ1QkNxcCthR1FURjFmUHdJV1RMS3VV?=
 =?utf-8?B?aEpPMFU5Y1ZkMFlBY0RDZWRqR0x2KzlWOGc5Ykh2ZUtzOUxseWUyV2NKQy95?=
 =?utf-8?B?M2xyTEtZUXpZNVJ5VW8ya0NCRiszRXhqRFc0clQ3WTdnS0ZUSnRlZHNlWXBt?=
 =?utf-8?B?OXRUMWNteUpNeUVPb1dkT0pjSnNNdExzSzJjQnVJeEdGa2VKcVpEVHQ0V2Vx?=
 =?utf-8?B?WldXNlVUUGhxRkFzQWdZUkdvTW5GV3FrekZvcjNVMzYzUnRUdy85Rk9uaGwy?=
 =?utf-8?B?SncvNTBrRExYZER3d2xyR25kU3U5ZHU2dlJMTGpmcGJFbWJNK2cyV1ZOTjdy?=
 =?utf-8?B?VUI2eXlMVU1IRzhrcmJMbm1UdnpEaG80Q0taZ0o4ZmthNVhQMlJXcDloQzFk?=
 =?utf-8?B?VmNzc1VCN01ZWlhzSkNzSFFqbTZ1Vnpqbmc0ejJESjJRZi9IR2piajNZTThz?=
 =?utf-8?B?NG5waTNTd1p2bmdObmFQcDFlcUFsTm9pbExPblJrR0N2Y1ZVWk4xdGdmNFB1?=
 =?utf-8?B?Z3ZLclJ2aThBbUF2eXFDQ3VIQ0lFWVJyWUZJWFRndXU1NGhuOGk2QXJTeEJt?=
 =?utf-8?B?ai9TSk5oVDRDZVo5VEdPZWFsUjd3blRFWWk5ZUpWVXpDbFdnSjRKLzBnNXhp?=
 =?utf-8?B?dkM0U0FhTzNqWjB5RmRHZnM0YjZBSXpUbi9telUza21xd1RxSHluOUNIRExy?=
 =?utf-8?B?NGo5YlpwaDRPdWJQY2xndjlUQmVWVE5VQWlmUHdVeTYxc3d6MzVDZ1VUNHhT?=
 =?utf-8?B?eVN1OXBxbDB3N3M2OE1DNWVDRWxqT2JnYldzRlJEdkc5WXJ1Qi9LUDhCK2pM?=
 =?utf-8?B?YUt5bDg0UWpMQXBDUmdidEJvdU81NWdEeDkyU3dLOXY0cU9odWI1Q0tSY1BQ?=
 =?utf-8?B?YzNRcEFqZzNrNHhrR2J5OWlXREFSNGs2bGpSZ1RjL3F1ZUExNWtJQkpMTENO?=
 =?utf-8?B?WFgvNlRrRW5zendoTTd6cHI3eWVsSFNyZzRSZVJ0Z0tSTS9qNkdwMmhBalEw?=
 =?utf-8?B?czNiTzhPN0FRY0xyalo0SzFwekJoYk0xZ3NFUzIweXRQUVVHRDNmTnV3Z0Jz?=
 =?utf-8?B?V3A2ZFliME1sVHZoSmpDQmZpam44NlZNZ3VPYWNjUUpwRHFJd2hSKzdUOGdF?=
 =?utf-8?B?bmpIaUg1QzVjTGwvR3paY0F2c211L3R6dE9xMTR3cyt1MG9SZGxTa0JQamhF?=
 =?utf-8?B?ZFZyTjFqbXZ0MnNaak9UeDMwRGNkUWdSTWJoMHZxOHhBcXpFblFwQkdvem8x?=
 =?utf-8?B?OHZJdDVTVEpXdldLUWtXbHZKL0FVcDRhcnhDWk9peE9oQWR4K2xXZkdSd0Rz?=
 =?utf-8?B?TDNMY2RmVVpZd2VQTmlIY3dSWlJWNEdzZDVrQkJqeUcvd3ZhYU81aXJxcWVI?=
 =?utf-8?B?QTJ4ekZpNU9UWVdvVkhzNG9TTGcwTnNHc0ZuMDFJTEVYYU5BSGRwMldsYm8r?=
 =?utf-8?B?aDZNMWd5OGVrZzBYaFIyeTFxeGU1NFhIQVNRRFNxZ0V6TFFqR0NwTmRrVkdH?=
 =?utf-8?B?ODdBVkxtanFmVjhwWjN0L1hTTWMxY2FOZ25GaklST3U2ZEhxRytwT3JXUHRq?=
 =?utf-8?B?US9MZUlqdEpFOHE5RTFmeVZPTGs2VHhkK2dPUi9JOTI4NHdSY2xBTzhtUlYy?=
 =?utf-8?B?K0x5NFZqRHZ3eDRaYTNRa3NOdkpORmd0YVZBay93d0l0OWFuQ2tXNXUyVEpv?=
 =?utf-8?B?cmwyRlJMWTJ3dDBieHZ0TGluWWxIc202ZFdUbStjTURtMGorVGRoWVlUd3V4?=
 =?utf-8?B?OVNueHBGTTFsU2FHK0wrL203ejZjOVNDUmV5VGpHeE9LUmZ1bkJaakwrT1Nu?=
 =?utf-8?B?ZytVYzBrQkg3TTFkUlJoVTF2WmplRzFoNDVqUWFLWFNXSnlta25IdSt1eWdo?=
 =?utf-8?B?bnJwb0ZpL0JyMlczdXNrTk0xT0dGK1pyR0FKdEl3akZ1T2I1K09EMjBKSEYw?=
 =?utf-8?B?TGM5WWdNTVFHNVAyUFpGNGFvcWdHVXpOSzdSbndka2NZZ2Mxcm9aNHJJUzhm?=
 =?utf-8?Q?u+kgP+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXN6M25Ubnl4eDBIaVRJaEREemVBRUx1WGR4VmpxSit4L1h2a0JkbHNPWFBL?=
 =?utf-8?B?Q0RIMWVMZjZtcG9ONXBnU0dNSjFKZlg1SmliNFpIZGFFQjF6SlgrVXEyMFZu?=
 =?utf-8?B?bERuVTY0aFJML0FUMFB4LzJnSlJoOHV3TXBYZXhPUTVFM0Z0M1BwbVpBbXZW?=
 =?utf-8?B?K1JvUGJWTkdaNTlabXRqYTZUcFlwVGwxY1BMTWZ5QU9MSjU1Z1BZRDk1eksv?=
 =?utf-8?B?Q3ljdGN3U2FhL1dXOW0vVWxuVlk5RFk3RG5hbVVDYk00dndqSmYzOHJpOGhj?=
 =?utf-8?B?cVFVNGlDekw4eWhVckZnOE1XKzRkeXk0T1RxcUpSVXAwM1gveHRvanZWVXNs?=
 =?utf-8?B?bnR5cmlxdVUyWGtac2hFbXp6ZnpXNTZZWkxwdW83eVVLUlJDd1lnSkxkNFl3?=
 =?utf-8?B?eFNhb0dvbmpaRGs3VWhRaDRaMzhlazdnQWZJTWxoMkJaSTJYSVhMVXp4QWR6?=
 =?utf-8?B?NkVMRitvOUs4eFZ2ZTlOaWVKOFllUGRRS3F4ejY3akZKTlNYVjJzcEM0Q2VE?=
 =?utf-8?B?QjNPbzB6YXpxUUNFVmE1eGszazdmSCtRQzFQNnBzNHIxeHZtVFdndWpLYys3?=
 =?utf-8?B?aHF4eUdhRCtYWmNrbTBIZHJYQUFQWC9qWlZodWhFQ3E2V0lSZTFjaStGTDRI?=
 =?utf-8?B?ZnBZQllUUFhheVVON1YxaERVazJYOVo4MjJKWHBKSjlJVm5IWjJBQ0czbng0?=
 =?utf-8?B?YjFKc1lULzhVT1BNSlFxUHRoNnE5K3pWVjM4MjlsMHBkNVFRNFhVL1VpNmll?=
 =?utf-8?B?OHBsN2ZQei8rZGF5Mi9OL2NCVWNxejM0QzlIMkFneHJ3NTU1NzdlU0ZFYThk?=
 =?utf-8?B?ZHBLaENPbW53MUF4K0lMalBvL2xwejZGcDdRenBaR0o0dThyUVA0YzZFUEp0?=
 =?utf-8?B?VnMvaXpOaUZvaGIwRXdlYnVaYmhmZzBia0lvYWllREk4VWkwQTJBc1QzRUxS?=
 =?utf-8?B?dlMwK1A0aW1RWXhCaGwrclVmanEveStWUEJYR3hhZDNab08xeVZFMWh0Zmgw?=
 =?utf-8?B?R3N6ZlBUbTJQZndHK0JoNEpTY3g3SS9rZEprejc0dUs4UXQ5RHlHVFh6a0I4?=
 =?utf-8?B?dXZwSjVOdCtjT2NmY1VZMHhZMmh0MFgveHNOM3RkWHBwMjR3V3ZCa3ZmMHUy?=
 =?utf-8?B?aTF0d09aMVhwNlBJZTNHRW5qNWZ0VlVXRGt3RUlNUE1JVGpKc3VXMThHU3dG?=
 =?utf-8?B?OFlwbklGLzY2WldyUWhHR2hZbGNWY09VemZDekJwWTJuRndjamN2bGw5a2xq?=
 =?utf-8?B?M29oUWVKWG9qQytSYkVxQUIxWGFXSFRISGdCV2hNU0tlRzh0NzBDY3JUVC91?=
 =?utf-8?B?UzZkSHdTTndlRXMrcTFjOVVzMHNNUnhUak9kY0lROGNBbnpoZTVmbFJCMDN4?=
 =?utf-8?B?ZldUZzBFNjB4WkpmeG4rckZBY1ZtcmtqczBHY0dJNW43SGxmTWtvRmRSaEQ0?=
 =?utf-8?B?cjBlcFUyUHBFOUJWUzJnOG1xT1VoaVJZanlzc1NMZEFJSmtXOHl0WG13M1RZ?=
 =?utf-8?B?UkJXUUVUdllTTGZpak91SFRhdFN0dEEvOVBvQ0F4MmVoc1ROWjh4OFFrU1cz?=
 =?utf-8?B?amJrM0U5aGcwdjVpZVk0NTNNQjVUbkxuQXR4UXQ1emEyZzZCRHlkM21XZ1M3?=
 =?utf-8?B?RXp0K1I0YWYwbjBhSEpaU2FXQzI0cVFoWXRqU3FYVm83YkkwME0wUVdBdHVp?=
 =?utf-8?B?bG44WHJhYWRDZVJidXArMEozeTBrUGN1M2lxdTZJV2FlOXUrdThic2ZLMnhL?=
 =?utf-8?B?aVRiMUZJNnlVaXZqUWR0STIraFVHMDRxbTZ3dGlxaHVnNVFZTXdiU0JpbTlF?=
 =?utf-8?B?YW5KUzhmYktuSHA2SUN2cHpFREVnQUEyZFpDV2R3SFV6ZEsvcStMeWRVR1RR?=
 =?utf-8?B?Z2hIM3NBcDhzTFJsOVlKOTRhOWtqWSthVkVVN0doUG04bk1hVDJ3T3gvT0tQ?=
 =?utf-8?B?bSszblBYV2VhVWJObERFUVhrUDhET29Ua2pMTC9hbTJPNVNuUmNicnZKNFJQ?=
 =?utf-8?B?YWc5dDEyTnZVeTQvVmw1N3poLzVLZFI1azBwTEVUWm80M3VlMCtXaHFnRW5l?=
 =?utf-8?B?NUhsMFJxb0M3T1J2Y0FWUU51Qnl1cml4SmRIQmRZU2IvZExGcHFqT3JTT0h2?=
 =?utf-8?B?S3hqZ2Yrdjg3NmRPdnZTelBVZEpPRnViaHJ3R3duUHJlMjN3OVlHMkxVcUJP?=
 =?utf-8?B?T3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64A164DDE373264A858FCDBF58A18B1D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a76f6f-81d1-4eb0-2736-08de25f6a45f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 16:30:38.2676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ROEN7y/ScHoQbpzkLRXyj5NUdOs4cpd5vD7939pFSxYAVoaKDqs2Ye2moW4lBt682DvqoBBi5q26sioEINUH7JcHnp8f63ur/M9filLaAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7164
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTExLTE3IGF0IDE0OjM4ICswMjAwLCBUb255IExpbmRncmVuIHdyb3RlOg0K
PiBJIGJpc2VjdGVkIGt2bS14ODYvbmV4dCBkb3duIHRvIHRoaXMgY2hhbmdlIGZvciBhIFREWCBn
dWVzdCBub3QNCj4gYm9vdGluZyBhbmQgaG9zdCBwcm9kdWNpbmcgZXJyb3JzIGxpa2U6DQo+IA0K
PiB3YXRjaGRvZzogQ1BVMTE4OiBXYXRjaGRvZyBkZXRlY3RlZCBoYXJkIExPQ0tVUCBvbiBjcHUg
MTE4DQo+IA0KPiBEcm9wcGluZyB0aGUgaXNfdGRfdmNwdSh2Y3B1KSBjaGVjayBhYm92ZSBmaXhl
cyB0aGUgaXNzdWUuIEVhcmxpZXINCj4gdGhlIGNhbGwgZm9yIHZteF9oYW5kbGVfZXhpdF9pcnFv
ZmYoKSB3YXMgdW5jb25kaXRpb25hbC4NCj4gDQo+IFByb2JhYmx5IHRoZSAodTE2KSBjYXN0IGFi
b3ZlIGNhbiBiZSBkcm9wcGVkIHRvbz8gSXQgd2FzIG5ldmVyIHVzZWQNCj4gZm9yIFREWCBsb29r
aW5nIGF0IHRoZSBwYXRjaC4NCg0KQWghIFRoYW5rcyBmb3IgcGlja2luZyB0aGlzIHVwLiBJIGhh
ZCBhbG1vc3QgZ290IHRoZXJlIGJ1dCBsb3N0IG15IFREWA0KbWFjaGluZSBmb3IgYSBiaXQuDQo=

