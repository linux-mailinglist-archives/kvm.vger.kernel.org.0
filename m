Return-Path: <kvm+bounces-26442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4312974765
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1BB4B22832
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD95B660;
	Wed, 11 Sep 2024 00:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJrOEYop"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD18182C5;
	Wed, 11 Sep 2024 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726014648; cv=fail; b=t6GqMoL1a/EBSFI9MtboBnF0kMpxebTUWoQU6AfijVZImtN7D2RmAxo4q8Sz7+aJwiIPE45/u9W8fDYLel7VqouDoVthTf2EwuuU1m4vnrB/O2Js5oV/LX9LNBZvMNloNd9h5Noce9Rg+J/7HAgBHwrIt7Ysbq9ZvRlxKyAtgSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726014648; c=relaxed/simple;
	bh=hQvA1V25yHCM3RMXkfpr11gLJ0dsqJaCicBcSavN+Vc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t2b1SZvcpFZkuUbvYKNjjVdnmPUYZhQA/T1Zm111f8Y+JbtwVw9LbMV7xDU0J7VTYdzhG6dZw+TKU9338GKEf0qtrYSGl4P22AXk6lqimXrNvQlZqK7PNa4tqiaVC4Zhj5XB2VN66AXwLR2i1ovXLcpujv4fI4Hl9qjMFUbRfSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJrOEYop; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726014646; x=1757550646;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hQvA1V25yHCM3RMXkfpr11gLJ0dsqJaCicBcSavN+Vc=;
  b=eJrOEYopE6dzQZJsQD1T+WFJbu5K+aSNl3OYNxEmtmRPkBNeHkfDoAt8
   HRqmijJMqIftRxA+CBk054HnjD6wpirJVxKlBwMNlzfIZsP04dSt8qcUy
   K/GOl+DmN0cZBCMt8cbJixYzDguKKA/Tfrwyz4PT3iLrQELAJhxonIhh6
   chrl89yRNTG5B5OoJhyfwGRKjTnq205ldxV77drb6v9x4a1H/EM0d4P7j
   2gyxFaakyt7mBa2eV/W1rMTBo6/jQpMP+1Glo7DN//D7eFhNvOMFA7wSG
   IkJ3LalE8FRSK4vI1xz3Xff6CQWxPjbRj3xz1Lxs82L7PygPTKyIgB++t
   g==;
X-CSE-ConnectionGUID: qp41HNzFQpyj9CaKhZ1Bbw==
X-CSE-MsgGUID: 0X5uKJtISTywipCD7zjJbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="35464753"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="35464753"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 17:30:44 -0700
X-CSE-ConnectionGUID: AEieED/mRUm0z88+KudKjQ==
X-CSE-MsgGUID: mEXdJWnUSluFfNk5t4Zlgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="71997822"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 17:30:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:30:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 17:30:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 17:30:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dsQv70/A40H1d0MgoCVJmkp8fmX2kHnmUZshy+sr5lZqQPPIm0+dSVZ4FigvUaSJ02NshaWLXt2lXKX1zkAYl7bizZ1+giDIr8slvtZExksO58tvewxpHzifa32kCVVY48oSEMrlFsSi0wFqlDB0luwc8GQSH/AhH9ezDh+bT4jeA+MNu1qBdA3Ym2treWw6xYwPTHAGGyGAWvJRYf+Cw1Ch4h6Q2RCX/gGvOEGLde5ZLndQKf1JQa1zbCiSsa+9MMPieuprnQseIdLeEPTPQNxge0sufuv2MCYlEgvkAH3FUOr3VtbrSIsLwDdnTk0vD7TChC8/rlwjKGGNsBFLEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQvA1V25yHCM3RMXkfpr11gLJ0dsqJaCicBcSavN+Vc=;
 b=aZQZQ9NgChz6JcI6lT99KMti6D6uKKPP1IySs6INoN1KzXQxJPC9ZqRPOPxzwN4+6qpFj+matmO3uw/6PYgITyKpjpDQAYWpg9fpFTiOxo8ftkAgb8ET1WmNvPyioGI3fUeYN+S76UANXlIw2lzxnaz1GFs1w5LGt4W5NXgcdMMEfgxwA50nW8WIdRZIH2msyD9CaYHo6YJWCnPrD26mw0bAeO2DnODUQef7NGiOzTfKHyfL0VM0oloV+4uURCcpCd2b9ZEYujuF5Cv2/kFLnFg19pet5hkKPahc/hF77lSZcXVb4MnW4hCsq6cBhjmmUaRsTgQk/dOZfo5YoeMfHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7936.namprd11.prod.outlook.com (2603:10b6:208:3dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Wed, 11 Sep
 2024 00:30:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 00:30:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Topic: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Index: AQHa/neylxoaYrTILUWaulhlDyL5EbJQ4UMAgADldQA=
Date: Wed, 11 Sep 2024 00:30:40 +0000
Message-ID: <2f311f763092f6e462061f6cd55b8633379486bc.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-17-rick.p.edgecombe@intel.com>
	 <09df9848-b425-4f8b-8fb5-dcd6929478de@redhat.com>
In-Reply-To: <09df9848-b425-4f8b-8fb5-dcd6929478de@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7936:EE_
x-ms-office365-filtering-correlation-id: be108937-e46d-4b27-8921-08dcd1f8f72e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cURhS3FvSlN4UGwwUUlHMXJHZUdWNDQ3MDd6Qi9hendTRmNwSVZKb3hhR3lV?=
 =?utf-8?B?M0YwazBaZVJPTHZ5OWpxYklNY3lvSUVoeGJmNHFkWHFjZGpBOE5Zc2ptZlU2?=
 =?utf-8?B?Y2o0SU1NZTdteTJHNFhsbFFUeEprREoyZElpN21XUlZTamFhaWw2Vlc0eFJB?=
 =?utf-8?B?OG81eUJIdmJwY3EwUVNneEpQSTR1U05jK2R5clByUnNwdXdTYzViOGd1QS84?=
 =?utf-8?B?cklhazdmYjdvSVNpL3Y4UWF0WXlDSXdyZXdxeEVYdDlxZzNFR01LQUVRMm1k?=
 =?utf-8?B?M3Jab0I4ZFd6OXBGU2NQMGxSOVdNaUtuMVJ3eXc1c0lYTTEwRUZYeHN3SHI5?=
 =?utf-8?B?Qk9tdVFWZHYrdHZ5bDhiOENvZC9meG9EcjQ5c1dxSHZvRUNqUkFDOHlYcXNR?=
 =?utf-8?B?Q09CK09tRk9KWHZtQ3pNcGRReVgxbk5aaGRXbHQxOFFNMkdWZUpKYUFJOXFz?=
 =?utf-8?B?U3ZTb29HQS82ZWNnTFFjR2Mvbk12Rm9kUkR4Q0FoMGlXQTBjenM0YTUwMUVU?=
 =?utf-8?B?UkNIYUZSVEJUdzZQYTYzQU5QZGYxUEFjVFZNR28vdTliMzB0d0VwcXd3VEg1?=
 =?utf-8?B?YkVYZ1UwOHU0ZWcyNVpNU216SUd0MklKUEJoakdBOFpXZ1FOWnYvencrUkdZ?=
 =?utf-8?B?RVFtb0tZSGFsamdUTktlblBYMEZvZ0w4R0ZiNFBmL0pPWHhpVld6c2VrbUx1?=
 =?utf-8?B?MDlRUms2OStTMVo2U1B0aHZGRzdGeWZPb2F3SElpSzZEQy9EY2daY3lMWE5l?=
 =?utf-8?B?MUxvSkRoSWdrYVlGaE05eHhtVm1wUG9zbHB6RDNJMldUZm5RKzV6aFp6eGll?=
 =?utf-8?B?SjlkUFIrcE5MMnBndnNhRk5Ld1NpN1NINmJ5NGROMDdDdkRjZFhzc1lMdEhK?=
 =?utf-8?B?Q0hKblVRS1RleHg2LytXaDVXc0YxUDhEUFJZcEoyWHJ5dmZwUzY1c2dsZkFG?=
 =?utf-8?B?TjRyK01mNElkdjFCeGRLa3BkbmM2Z3ZNZ05uczVFcjVvT3NkR0NORFB4eFZn?=
 =?utf-8?B?KzZmWllyS3ZLZG9kY0ZjN0JmTkV6ZUhBbHROUUNWOG5MUXMwUzlhTXl2c1ZP?=
 =?utf-8?B?eWhJZldWRmVaV1Zjc2EwdXcwNkp4b3lZYTBRNGkycEsxTGlmM3kzb2V2c3d3?=
 =?utf-8?B?WDZtS1BxdjB0S2VEZW5TcnI1eHBZNVloUHRiWm4yTVBKU1Z4YUw4Qm1xWk9L?=
 =?utf-8?B?RUplNm81Mll4bVh4L05Ra3B1VVpuVkExbXRrOTRzYlNMdW5zak9mUXZRZkZL?=
 =?utf-8?B?ZnRWTFFOM1RVZzNvbW9GcGZ3REhrWWNkWlVlY2tMUHVydHd6OWJPWkxFVnA0?=
 =?utf-8?B?NDU5VUhwakRYck5CNDFMSGZaMkhicllZTkZRdjNYVldvbWhzbE00U2pab2F6?=
 =?utf-8?B?eHRWbGNvcGZVUTFjd0ZFckxYTjNNV3l1R0VVRlhHaGUrWHFmUi9QdHhPMlFr?=
 =?utf-8?B?Z0ltWEYyRnZMTk9hc2NzRDAwRHpVaGpMbU14RytKdnVBb0gyL054UFNBN2hE?=
 =?utf-8?B?eS92NXhnbUtVa3hmNVBVNUhFbU0wVmRUMTk4R2w4VVpxNWQxb2FBWlA2VXcr?=
 =?utf-8?B?WWRlVkVDZ0dabnpWVzZsTklna3pYZjdGRVNZOWFTRFkwL0VCcytFVEZiWXUz?=
 =?utf-8?B?UWYrV3pzckRJcDBkZkllcm1BWmNVMWMxSGhUODFZSTMrZ0RMcElRRHQ0WlJV?=
 =?utf-8?B?Q2R5ZEw3QXVBQ3hKK1NMVGl4OFdpNm45Z0N6cXNtaUczOEFSL2I2bGxibUtE?=
 =?utf-8?B?YlFETHhzb1NlVjFBcTAzQTZOY2g5UkVxTU5qbCs1c1U3TGFaRUhIc2tXeXBK?=
 =?utf-8?B?WDQ2Q2ZhWlRzdHhJQWltaSsyK1dOK0FwT3QvTktOS2xZNllHS1oxeFE5dUtF?=
 =?utf-8?B?c21QZENIS0NWSVRyYmtRVmNHUGRONHliVUFvRktsQlViYWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3VqcEYzdEpNdzJOU2RRTCtLSEpOWU1EazBwSStPN0w4L0JTVGtlc2VOdE1Z?=
 =?utf-8?B?SHltNjU0OUV5cGNrdnIzVmJhZDROWjg0YmRORFc5blFWcE5pZ2V4QkoyekFL?=
 =?utf-8?B?Uy83RWZ0Q2xCZW1zS2lmbXI3dkZPK1V5NWFHSURJNk1zcit6Skl5ckpJSHpY?=
 =?utf-8?B?a3F3TUNuTjZVVEI5L2VCSmszMFpPTExoelVrZVlRWHR2dmlrRkptTDR5STFp?=
 =?utf-8?B?MUNBbWNHeXZSZFNHbkdEbEE2bmE1dXRLbkdsdndkdjAvcHZiQ3JQYTB3cElH?=
 =?utf-8?B?M2FYeTkrTDNBMGh1d3FIMDh1a3pGQUVSVTJVTkJ5ak9HdnhYS012YkJEWDVz?=
 =?utf-8?B?am5lRkMxazVTTkxRc0ZXTDhhWHp3ajlkL0V5eHhHWmlTMWQ2M09aRmZ1U1FE?=
 =?utf-8?B?Wjh6clNrem1Cc2E4YXZDa0txV0dTVE4rclVkQzJUbXlLL1lZK2QvMVFabXEz?=
 =?utf-8?B?L3NvZlJtYzloUlRGZHhxb3FZWW4vUUFraXZjaUFqMC9HQ3NRRDh5ekdYNUdk?=
 =?utf-8?B?L3A4dW1QMVdPa0hUWlJXc3JVS0E5MU1ubjdhMkVHNDBDdForWDZWS09KWWsv?=
 =?utf-8?B?VlBuR2QvRWRPbXd0OVF6ZU1QNDJ6a245YnJTUk9lVVhHR1lETVoxKzhHV25t?=
 =?utf-8?B?MCtsdWMwU2w3QmRVZ2N4QVRLdWZncjB4a2ZZUFR3bFVlT295NGsxbjF5QkZ5?=
 =?utf-8?B?UDdIcDB4ZGZaMkUyeTJ0ZzZ2cDJaZzdpM2F5ZWVyWkRxV2FSbkFJM1R0ZWlv?=
 =?utf-8?B?WmU4K3RxcFhOeit4aGYxbXZWSHpHNnJQcU5Rb3ZpWDdnVWVXSXhMY3Z0YUxY?=
 =?utf-8?B?WFBxTHIrOE8wclh1YndWRFdUa1pkdXdYNlVma1YwL2J1elpLZ0xxcDJoZnp2?=
 =?utf-8?B?ZStpeDU3ejFEa3lvbUZldFJhcmNkcW1vemFkRjlPdnJ4QVM0ZDFCT1FwSm9D?=
 =?utf-8?B?OW1sMmRSWFlneFRNbUxCLzJnS2U2ZU5OZkF4VUFDSWRLaldETFlRUFBSL1Bq?=
 =?utf-8?B?RjFaNTg3N1Zpelo4Wkk1UnozUExudDVOL0lRNjZMQ25uVm1vS2pIemd3Yzhs?=
 =?utf-8?B?Unc5WFhoN09YNEtTYmhFRTdQaHZ6OGNFTVo5ZmJ2VkZRQTRhQXJiK29MekZO?=
 =?utf-8?B?UE9jMmZxaEtDRUU0a3RjaDlxZXd1TEpESjhMdS9nQkJwYWxpWFd5aXVMNmRJ?=
 =?utf-8?B?aEl3WnVIaUwyRUwxTHJ1YXVLQ3FxUDRmMTJFVlNnZzZlZFZWSVgzbklQMkdQ?=
 =?utf-8?B?ZHFvZ3dBR0lvZGs5SDdaMlRIazBkOXp0Vm5qTUVnUTk2VXdGRFRIZm9CZHl4?=
 =?utf-8?B?WENYTW9RcFZGa3BqVUhDZEVwOXJrMm95bzZyVDNLelg4dCtEb1U4Q3k2UVJk?=
 =?utf-8?B?YnRoZ05BOXZaa3BobE9BaDRkNEhkZWRjWlZGM3NsdWJWL3FpT3lEYU9iaDFt?=
 =?utf-8?B?UlV3cldUT05kZEZGdFdXL0hmNXpjdGFRcS83OVV4bUNYQTNNeXl3UEc4YjU2?=
 =?utf-8?B?WkVtazBaN0FlV3JUK3RIQmlOekhvNUZpcENZRUpXb2lTMDI2bHdwQmtyV2FJ?=
 =?utf-8?B?V2c0SzAxSHVBMXRIbDJqUjY2L3NNMTVQSVEyemRrUE9xTmxQMzBFc2hsV0ZD?=
 =?utf-8?B?ZDRRWlpEM1F4WWRFY0IzaGEzZzQ2bkw3TGVoN2pZcUdxMGlReXMxak5Ga3dN?=
 =?utf-8?B?RDJNU1ArQjhjSmxNdjZNMHhodnVLWC9xR2ZhNTNRUHhLWHBHKzROZFhFM3dh?=
 =?utf-8?B?bDllWFVNTjEvQlRZWWM0UXZnSkNIK0o4NlpqaW5tRzhrd2ZsaFFYTzdld0dY?=
 =?utf-8?B?Uk1HSEdGckcrZEI0a2Z3SWhZYkVNVXROajV2bFArQU05V2FrZW5ESUVCNXZh?=
 =?utf-8?B?VUpJYS92N01sZU16enZiN24xZmYzRzhkRkdHa3IzdHFhTzFlaE5lTS9UOFRQ?=
 =?utf-8?B?SmdlMXdSekpzNWtBZUZjbXMxSzdtbjRDRkZqNkZtSS9tUExRQytWelZpVGxq?=
 =?utf-8?B?YkFOUVU4REZUSzY0ZHpGM09YeWdIUDU1MDNuM3dEbFIvM3JERGJvcTdBU2pk?=
 =?utf-8?B?QjJmQWpHdHlkMmVieDJkSkgvbk1WT1R0ZFhheHFjV29LY3Q0b25DWGJ5K1V6?=
 =?utf-8?B?OEJMR1VGbUNscTBmZnVkZDA5UjhzeTJFcjhpUHlMSTlZN2l2dnF4azVYRHhK?=
 =?utf-8?Q?x3/DlnFfKdSgQzIY+F93e7w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88CE69C573A57749B32B71C0AD21A04F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be108937-e46d-4b27-8921-08dcd1f8f72e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 00:30:40.8723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5HEuGohvzsLfCvhOIwrnlCkZ0lnQJUqvwd64cVMGOPHAjFn3KYDfLOvfcGLHDqLie1BZ3z7lvMySoF53q1KnqavWpmITFDUGPVnjJmbYHXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7936
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEyOjQ5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiA5LzQvMjQgMDU6MDcsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+IEZyb206IElzYWt1
IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+ID4gDQo+ID4gVXBkYXRlIFRE
WCdzIGhvb2sgb2Ygc2V0X2V4dGVybmFsX3NwdGUoKSB0byByZWNvcmQgcHJlLW1hcHBpbmcgY250
IGluc3RlYWQNCj4gPiBvZiBkb2luZyBub3RoaW5nIGFuZCByZXR1cm5pbmcgd2hlbiBURCBpcyBu
b3QgZmluYWxpemVkLg0KPiA+IA0KPiA+IFREWCB1c2VzIGlvY3RsIEtWTV9URFhfSU5JVF9NRU1f
UkVHSU9OIHRvIGluaXRpYWxpemUgaXRzIGluaXRpYWwgZ3Vlc3QNCj4gPiBtZW1vcnkuIFRoaXMg
aW9jdGwgY2FsbHMga3ZtX2dtZW1fcG9wdWxhdGUoKSB0byBnZXQgZ3Vlc3QgcGFnZXMgYW5kIGlu
DQo+ID4gdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZSgpLCBpdCB3aWxsDQo+ID4gKDEpIE1hcCBwYWdl
IHRhYmxlIHBhZ2VzIGludG8gS1ZNIG1pcnJvciBwYWdlIHRhYmxlIGFuZCBwcml2YXRlIEVQVC4N
Cj4gPiAoMikgTWFwIGd1ZXN0IHBhZ2VzIGludG8gS1ZNIG1pcnJvciBwYWdlIHRhYmxlLiBJbiB0
aGUgcHJvcGFnYXRpb24gaG9vaywNCj4gPiDCoMKgwqDCoMKgIGp1c3QgcmVjb3JkIHByZS1tYXBw
aW5nIGNudCB3aXRob3V0IG1hcHBpbmcgdGhlIGd1ZXN0IHBhZ2UgaW50bw0KPiA+IHByaXZhdGUN
Cj4gPiDCoMKgwqDCoMKgIEVQVC4NCj4gPiAoMykgTWFwIGd1ZXN0IHBhZ2VzIGludG8gcHJpdmF0
ZSBFUFQgYW5kIGRlY3JlYXNlIHByZS1tYXBwaW5nIGNudC4NCj4gPiANCj4gPiBEbyBub3QgbWFw
IGd1ZXN0IHBhZ2VzIGludG8gcHJpdmF0ZSBFUFQgZGlyZWN0bHkgaW4gc3RlcCAoMiksIGJlY2F1
c2UgVERYDQo+ID4gcmVxdWlyZXMgVERILk1FTS5QQUdFLkFERCgpIHRvIGFkZCBhIGd1ZXN0IHBh
Z2UgYmVmb3JlIFREIGlzIGZpbmFsaXplZCwNCj4gPiB3aGljaCBjb3BpZXMgcGFnZSBjb250ZW50
IGZyb20gYSBzb3VyY2UgcGFnZSBmcm9tIHVzZXIgdG8gdGFyZ2V0IGd1ZXN0IHBhZ2UNCj4gPiB0
byBiZSBhZGRlZC4gSG93ZXZlciwgc291cmNlIHBhZ2UgaXMgbm90IGF2YWlsYWJsZSB2aWEgY29t
bW9uIGludGVyZmFjZQ0KPiA+IGt2bV90ZHBfbWFwX3BhZ2UoKSBpbiBzdGVwICgyKS4NCj4gPiAN
Cj4gPiBUaGVyZWZvcmUsIGp1c3QgcHJlLW1hcCB0aGUgZ3Vlc3QgcGFnZSBpbnRvIEtWTSBtaXJy
b3IgcGFnZSB0YWJsZSBhbmQNCj4gPiByZWNvcmQgdGhlIHByZS1tYXBwaW5nIGNudCBpbiBURFgn
cyBwcm9wYWdhdGlvbiBob29rLiBUaGUgcHJlLW1hcHBpbmcgY250DQo+ID4gd291bGQgYmUgZGVj
cmVhc2VkIGluIGlvY3RsIEtWTV9URFhfSU5JVF9NRU1fUkVHSU9OIHdoZW4gdGhlIGd1ZXN0IHBh
Z2UgaXMNCj4gPiBtYXBwZWQgaW50byBwcml2YXRlIEVQVC4NCj4gDQo+IFN0YWxlIGNvbW1pdCBt
ZXNzYWdlOyBzcXVhc2hpbmcgYWxsIG9mIGl0IGludG8gcGF0Y2ggMjAgaXMgYW4gZWFzeSBjb3Ag
DQo+IG91dC4uLg0KDQpBcmgsIHllcyB0aGlzIGhhcyBkZXRhaWxzIHRoYXQgYXJlIG5vdCByZWxl
dmFudCB0byB0aGUgcGF0Y2guDQoNClNxdWFzaGluZyBpdCBzZWVtcyBmaW5lLCBidXQgSSB3YXNu
J3Qgc3VyZSBhYm91dCB3aGV0aGVyIHdlIGFjdHVhbGx5IG5lZWRlZCB0aGlzDQpucl9wcmVtYXBw
ZWQuIEl0IHdhcyBvbmUgb2YgdGhlIHRoaW5ncyB3ZSBkZWNpZGVkIHRvIHB1bnQgYSBkZWNpc2lv
biBvbiBpbiBvcmRlcg0KdG8gY29udGludWUgb3VyIGRlYmF0ZXMgb24gdGhlIGxpc3QuIFNvIHdl
IG5lZWQgdG8gcGljayB1cCB0aGUgZGViYXRlIGFnYWluLg0K

