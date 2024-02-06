Return-Path: <kvm+bounces-8085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E206084AF9F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60C8F1F23927
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6913012BE94;
	Tue,  6 Feb 2024 08:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dGWRcoyW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C0412C809
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 08:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707206776; cv=fail; b=HXdndBoDzaLJGJMwNQSAwEwVehpXW3EbzPWiu+l1zQaEunheYYHx56CkLEPZECDomVPH7+hyBdt6FZAS1Bs6Fn8jv8QmMtJir65YIZpTSHUeyRtRgflsXDzuBKN4J5raci7qMgjs7WS31JKoX2tW+z1PWnUdAPZrgNNPbOuztik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707206776; c=relaxed/simple;
	bh=3pwP9QlEZ1mtGygzA4X4E7VB8lvOlxdIYo5tqNfYVPo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D0g8IXwkQV4bNskG0KM1oMpAfwCJVhUKnLWjwwtQSR2CDZXo89PIrzo2MDqR6NUusbUXaN7iLN/VVQjXTTqMFKErH4WHeC1nMgDuIJZQXSbvPxX73wFpWMXFxmF7eLMYac9p6ZxdfGhwv39p0hL0nkwMf1/Burnb+F+9fqdjeUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dGWRcoyW; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707206775; x=1738742775;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3pwP9QlEZ1mtGygzA4X4E7VB8lvOlxdIYo5tqNfYVPo=;
  b=dGWRcoyWQ+3/10YG7gTKcUSNOu2BJOtoETc8J7NySEt2fZ8wi22BeL3s
   10rBdQND/HRjyfXjqCxXYpfYPjB9lIIrMzfsWU6B0t1ZnMOcf/bRTiZyQ
   o15RcRg455/eATqi3D31h5gxLRjNm0iB6dEagMlUkLtAvzJFYHwOYPeqm
   tzt5g3qyamsPF5VzpemnIIEAYc4dXx60wTGR5o26W/UBJBezdHoGreelj
   qukYbKrha7ied5K3ZtOR/afVj1R0eFH41BKjcFcY4LoAgsmq3Nlp9/B5Y
   z2DgGacJhUUtPMZvTZ2iuPu5YOrwDwU9hwNNBq9dv7Vf3Az0ibASZegV1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="11280863"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="11280863"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 00:06:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="1295911"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 00:06:14 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 00:06:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 00:06:13 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 00:05:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDeStbOXTBtaUCi8Q3mSmz4V48AR8fyxOnPiNMBMTw+EeOWkwsTttjQaUfAeBMDLXYp/WvdZ8HC/tHV/n/ACU/gpZZPZqTQ4O+BKfpqM4vqffB0tOWuY14jYY69wA5We4XeIRXpJDoCZJXMd5VHTdSjFZeAZTLy10vCCijaO0psL4lJljjOtZXCJTQNm8j+jBKZEXf4kl3YvRRklNjKWo7BnsO6fwxRA/szQ5ZQwa1w8oIXnNgWoyL+8gLZMwxdaesjXa+pRzkTHlApt1pTkCCY6MMUNmx7FB/0ySKmRESUAMxFGr99BD34Stfg0OnzjpSE9mRTVZAYOux5/hrIquQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pwP9QlEZ1mtGygzA4X4E7VB8lvOlxdIYo5tqNfYVPo=;
 b=VQuctb3J5F1T/bDQBVZK2XHUAUdAi8EEGTXLFXbtWRFR1WbexewgStxt+UkOIobzmhCwLVtqrBCIDlPMjDtommhKLDe//jtRwBCZq3ol7LiJwI8MxW8Q7wnwapdz4QYdAe8y9KwR8r1jWHTPnNHHl1TSjueCWK5numtoZ3XMB2H49kcRyvQcja9YOYb5OPV9qctqvL60bFxthA86yF2jA0ggq25INi8wlbThqNs20PUtGEr3KBGJVN9P4EJSLPsByYZbZDXGS6Ba08VnCezW4+nU0QpnjJrKGkAgmtDesTylrJJMlTJM7RkrRImP10D8fOicp1lGqc1o8IcPhd2K6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7741.namprd11.prod.outlook.com (2603:10b6:208:400::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 08:05:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 08:05:53 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object events
Thread-Topic: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object
 events
Thread-Index: AQHaU55VErLgbW2DsEuQXOOLlNC0xrD7a26AgAAWdoCAAXP0YIAACGSAgAAA/PA=
Date: Tue, 6 Feb 2024 08:05:53 +0000
Message-ID: <BN9PR11MB52762D4195A72EBF5CF627EC8C462@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
 <20240130170227.153464-3-yishaih@nvidia.com>
 <BN9PR11MB5276D9B9CA3E4F69D183D94A8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
 <99c9fe4f-1812-440f-8f35-64a714984598@nvidia.com>
 <BN9PR11MB5276795DF79D924246ABEDC88C462@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f3d8fb33-d1ca-4836-9b6c-dd95b17d901b@nvidia.com>
In-Reply-To: <f3d8fb33-d1ca-4836-9b6c-dd95b17d901b@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7741:EE_
x-ms-office365-filtering-correlation-id: 57ad43e6-4a34-443b-00ac-08dc26ea70d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frJb9499wEVzcR6/BN3r+MhbrAAedmIIyxUPagVufDSDSarjYEfuw2AStr49vqg3Yj2Dn97UgHm2DwUEoyPKrgnFREy/mdm4Lpwi1Bo8ZlcMKWy+/GexhdLOIM1fduAktwGTfnD4gKyIaXCwxPhPPl6p0Frkz+PfyKqkSE6Zbdf1re96TFioqNK+8Usqx00tGHjR9hvFVsIDL5Obi6hYrNSxbCuKAx4gRkERPnXJsXVVhCpejndsKzw802Xmh+tyWPIMN6lG8bGgoiTlaBG7ukjnTfiBl+taZsRMF5KU8ZquoFlUEcqFfzR7Q1VMumLCOI87/jYVYnZ/HJxjx62kQcAFsCP+7dvB193SOFu9nzCqOP4vhrUHrGSehw85oDEifU5pnNIrmv3PVT4xj+1YhMdjghvgUMqoHFvQWJ389mt+Yyu/UMa3SfiF7TLkSBjTtaLU/zM/t2q6EEmVIT++WQ5XtIUNdFjl5sndp8vRrkX7Nz5XEH99nkxcub6w7ASusFYpnDZV76fgVSfbznJGC8jcPvBkYlzdsRQxLESkRrAQiY35HrjrhRZc/Vx6Q8cqp9T/8Fazyw8bZiM4AsS3JBMcWBCKlBF9Ho4oco3L8PXjzILCZEJJqru3NyHkA3sW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(5660300002)(52536014)(2906002)(55016003)(41300700001)(83380400001)(26005)(122000001)(82960400001)(38100700002)(86362001)(9686003)(33656002)(7696005)(6506007)(110136005)(53546011)(8676002)(8936002)(478600001)(71200400001)(76116006)(54906003)(64756008)(66446008)(66476007)(66556008)(66946007)(38070700009)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mm9ZY2p3dmVMSzlEbE1mdytuQ0ZEMGk5WFNaWDhXbTVhOE9kb2xJWGFCRXFt?=
 =?utf-8?B?ZDN5SGE0dkZibDdYaHcvSE9NSkNTaGxOTWFqaFlMN09rd3QveGppS2t2OUxn?=
 =?utf-8?B?aFlDQUprYTRQU0VpY0tWYWZWdy9RVDliK1E5SWNoQnJUV0tKT3prSlJaQnlM?=
 =?utf-8?B?ZDJXYVZCS2JGc1hNbkUwaDFHNnU5K0Jqc2FJTkR1UUxzTTc3Nk5WZUtHOVk4?=
 =?utf-8?B?akJ1S2JnWWxtUW8waGNKeGE5cFR3M2d5YjBRbGhPLzRGSlJSWTZtcnF5YlRZ?=
 =?utf-8?B?QWQrMzBycGc5di95RHVNeG1ZWmtIUlFYV2NMV3JGQnhFbWFYY0wzUnc2bVFa?=
 =?utf-8?B?TEhrVkZEMGJhSERybmdYM2x1ZDUreXNuYzV3eWZoTUwzdEp6anRtbXNnd21E?=
 =?utf-8?B?ZG03MXBqdWEwSmI1RFJTZC9YTVdOaE1WMGVVdU9Ub2V1ZUpNKzBYWlpJb2Zt?=
 =?utf-8?B?N2Q1bjhBdW9ucis2cTdiLzBjN0FzZU14ZjlKZ2pZOW54SjE0ejRYRTJ3aktC?=
 =?utf-8?B?K3JEWkNNTm45T1BiQWxRVjBtSll6RGNjUm44aG5oeWlXcXdpRXN2S0tvbWdP?=
 =?utf-8?B?eW4vSUt4dXZMQ0Z1aHpjZTNxcHZubWw1ZVVtNWg5THcxc0VzSjV3NmV6OVk0?=
 =?utf-8?B?bHFDaGhmRFZYZ3ptVVRkK1ZGQVV2Q3NSTVB6cVF6TUFERGJKSlV5U2dOeDN1?=
 =?utf-8?B?WDBNaE0xQzU1SXkvZ1NTRzRPdWFKZzFiYkZMaUIzMmxJNDdmOU9nWndlOHZU?=
 =?utf-8?B?Y2VXR1MyM2dWT0F5cit2TDliL3AzcVJMZlFadnBoWkxSVHJHVGxOWWlZM0NB?=
 =?utf-8?B?Z3NpMjE1MGhMMWtzWmN6dWdiTEZLTXBwM2xBa0h4MElrRzkwRFZCYlQ0Tnp2?=
 =?utf-8?B?eXZEb0t3NXVxOHovRFF4eUdKd1lLbTlxRHJPTEpzVFg2dEVaODVrdklsSVdT?=
 =?utf-8?B?S2dkSGZBWmJPcGE4QVlVdm1XRjdhU1R3L1Znd0I3aTdLYnI4Y3NqMEI0a1Vr?=
 =?utf-8?B?OHNvZjhVVVE5SURJcHlrL1paUjQwVlFnaGV6RHoreFZTS1BJVk0wakk1V1BE?=
 =?utf-8?B?YzBkblUvMDNBUzRsRGtIdlJYTFQ3RHJjcVRZYXhiY2c4ekZ0Zi9aS3dUVGNF?=
 =?utf-8?B?UzNlNGQ5TEIrZVhYLzlTeGNmYjh6VnN1RnFvRXNZQWNVVHlKVzgzNGJZcGxC?=
 =?utf-8?B?c0NKbFIxaFEvaUMxOGxia2RjM1NiMzFkcDlOa1pqTXZzYmVDRlM3cWNTaHN1?=
 =?utf-8?B?ZGZ3VkV4UUlkbUZXUW1yc0tGWjFaK1pnTS83ZDQ1dzNkR0dFdWVOL25LNlBp?=
 =?utf-8?B?SjdIN0c5VWd6TVZWUGNwZUF2OEVhNWRsTUd6anN5MkFtaEtjVThnVitkbi9J?=
 =?utf-8?B?U1U3WExZeDQ3ZmZXVkVJd2V6Yk1MT0tSSU91MU8zcFdxRU5vMWlnNG1uQnYv?=
 =?utf-8?B?VzJwbkJZWElDZ2ZlTFNBU2JPMU5PeTdQMmVMb01DWlFqOTkzNUJhYWpHcjFR?=
 =?utf-8?B?ZmdQc1dzWlpEOThVT2tRNjJyeWlhYzFjVnRHSWxzSk5nUHU5MHBiWVpqK2tr?=
 =?utf-8?B?aFl2VllNR3lUNDg4ajhtUlFJVTdIVWlnYnhOOUpVc0tFNS9NekVZMHZDMnFF?=
 =?utf-8?B?WlAwNE1kMFFXdUp6VmlwMlBIblF2bDluNkR2M0hQYmxsVTJPS0l1Mjl4R0tM?=
 =?utf-8?B?ZG1kUy9KK05JNm5ONVJXQm9WWDUrOXhtaVlwS0FpbEJrZjdWMUpCUjJ4S2l1?=
 =?utf-8?B?eUJ1RUpOUWlrY0NRYnRBME8rNGJlNEVKb0JDY2wyOC9rN0tMeElTL1lWVzRp?=
 =?utf-8?B?cjJCalhiZ2w4bGc3OUM5QURtM1RqamY0N3FuZFdwbWJlblh2WjZibXhCRHRo?=
 =?utf-8?B?SzJpdGZzMXdJYUQybklqVWZnQ3VFTWV2QVFkMTRGOW84LzRvdUpZcVc5SWRz?=
 =?utf-8?B?ZjNjRzN6ZDFWNjliSEozS1B2eUU1Y1RGcXhmMng2YndaaHhZVlZhU1JTVk9B?=
 =?utf-8?B?elpDYks0SHYwdGc3bWZQbmptQmphMm40OTRFQURqakgrU3JlSTRvQ1BGTDhx?=
 =?utf-8?B?TUE1TUtGdXo3UXZqdmU5MHo5bmE1clVKb2hvbWtmbFBtU3dNRFhwWFdMb0FM?=
 =?utf-8?Q?4j9fqZibf0WpeQwfmhXtZhOM8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ad43e6-4a34-443b-00ac-08dc26ea70d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2024 08:05:53.6312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: atz6kYXJrOhIK05auk3/io0BLy2JaFlrT7Ul++ZbDWnENxX2UaVFnNsiSPhk8e540XzMdJXBOQgEIZMH7R8rNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7741
X-OriginatorOrg: intel.com

PiBGcm9tOiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT4NCj4gU2VudDogVHVlc2Rh
eSwgRmVicnVhcnkgNiwgMjAyNCA0OjAyIFBNDQo+IA0KPiBPbiAwNi8wMi8yMDI0IDk6MzMsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlh
LmNvbT4NCj4gPj4gU2VudDogTW9uZGF5LCBGZWJydWFyeSA1LCAyMDI0IDU6MjEgUE0NCj4gPj4N
Cj4gPj4gT24gMDUvMDIvMjAyNCAxMDoxMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+Pj4gRnJv
bTogWWlzaGFpIEhhZGFzIDx5aXNoYWloQG52aWRpYS5jb20+DQo+ID4+Pj4gU2VudDogV2VkbmVz
ZGF5LCBKYW51YXJ5IDMxLCAyMDI0IDE6MDIgQU0NCj4gPj4+Pg0KPiA+Pj4+ICtzdGF0aWMgdm9p
ZCBzZXRfdHJhY2tlcl9ldmVudChzdHJ1Y3QgbWx4NXZmX3BjaV9jb3JlX2RldmljZSAqbXZkZXYp
DQo+ID4+Pj4gK3sNCj4gPj4+PiArCW12ZGV2LT50cmFja2VyLmV2ZW50X29jY3VyID0gdHJ1ZTsN
Cj4gPj4+PiArCWNvbXBsZXRlKCZtdmRldi0+dHJhY2tlcl9jb21wKTsNCj4gPj4+DQo+ID4+PiBp
dCdzIHNsaWdodGx5IGNsZWFyZXIgdG8gY2FsbCBpdCAnb2JqZWN0X2NoYW5nZWQnLg0KPiA+Pg0K
PiA+PiBEbyB5b3UgcmVmZXIgdG8gdGhlICdldmVudF9vY2N1cicgZmllbGQgPyBJIGNhbiByZW5h
bWUgaXQsIGlmIHlvdSB0aGluaw0KPiA+PiB0aGF0IGl0J3MgY2xlYXJlci4NCj4gPg0KPiA+IHll
cw0KPiA+DQo+ID4+DQo+ID4+Pg0KPiA+Pj4gYW5kIHdoeSBub3Qgc2V0dGluZyBzdGF0ZS0+aXNf
ZXJyIHRvbz8NCj4gPj4NCj4gPj4gTm8gbmVlZCBmb3IgYW4gZXh0cmEgY29kZSBoZXJlLg0KPiA+
Pg0KPiA+PiBVcG9uIG1seDV2Zl9jbWRfcXVlcnlfdHJhY2tlcigpIHRoZSB0cmFja2VyLT5zdGF0
dXMgZmllbGQgd2lsbCBiZQ0KPiA+PiB1cGRhdGVkIHRvIGFuIGVycm9yLCB0aGUgd2hpbGUgbG9v
cCB3aWxsIGRldGVjdCB0aGF0LCBhbmQgZG8gdGhlIGpvYi4NCj4gPj4NCj4gPg0KPiA+IGV4Y2Vw
dCBiZWxvdyB3aGVyZSB0cmFja2VyLT5zdGF0dXMgaXMgbm90IHVwZGF0ZWQ6DQo+IA0KPiBUaGlz
IGlzIHRoZSBleHBlY3RlZCBiZWhhdmlvciBpbiB0aGF0IGNhc2UsIHNlZSBiZWxvdy4NCj4gDQo+
ID4NCj4gPiArCWVyciA9IG1seDVfY21kX2V4ZWMobWRldiwgaW4sIHNpemVvZihpbiksIG91dCwg
c2l6ZW9mKG91dCkpOw0KPiA+ICsJaWYgKGVycikNCj4gPiArCQlyZXR1cm4gZXJyOw0KPiANCj4g
V2UgY2FuJ3Qgc2V0IHVuY29uZGl0aW9uYWxseSB0aGUgdHJhY2tlciBzdGF0dXMgdG8gYW4gZXJy
b3Igd2l0aG91dA0KPiBnZXR0aW5nIHRoYXQgaW5mb3JtYXRpb24gZnJvbSB0aGUgZmlybXdhcmUu
DQo+IA0KPiBVcG9uIGFuIGVycm9yIGhlcmUsIHdlIG1heSBqdXN0IGdvIG91dCBmcm9tIHRoZSB3
aGlsZSBsb29wIGluIHRoZSBjYWxsZXINCj4gYW5kIHVzZXJzcGFjZSB3aWxsIGdldCB0aGUgcmV0
dXJuZWQgZXJyb3IuDQo+IA0KPiBBbnkgZnVydGhlciBjYWxsIHRvIG1seDV2Zl90cmFja2VyX3Jl
YWRfYW5kX2NsZWFyKCkgaWYgd2lsbCBjb21lLCBtYXkNCj4gaGF2ZSB0aGUgY2hhbmNlIHRvIHN0
YXJ0IHRoZSByZWd1bGFyIGZsb3cuDQo+IA0KPiBJbiBjYXNlIHRoZSB0cmFja2VyIGNhbid0IGJl
IG1vdmVkIHRvIE1MWDVfUEFHRV9UUkFDS19TVEFURV9SRVBPUlRJTkcNCj4gKGUuZy4gYXMgb2Yg
c29tZSBwcmV2aW91cyBlcnJvcikgdGhlIGNhbGwgd2lsbCBzaW1wbHkgZmFpbCBhcyBleHBlY3Rl
ZC4NCj4gDQo+IFNvLCBpdCBsb29rcyBPSy4NCj4gDQoNCm9rIHRoZW4gZmluZSB0byBtZS4NCg==

