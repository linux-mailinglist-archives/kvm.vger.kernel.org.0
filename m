Return-Path: <kvm+bounces-16228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B99498B6EC0
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 11:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FF58283ECA
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 09:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8F8128833;
	Tue, 30 Apr 2024 09:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dsOc1z+P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0671272AB;
	Tue, 30 Apr 2024 09:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714470587; cv=fail; b=lV07jzX/pA0VmWM+WjDjS5cztF7ppuFu8nGeopNbTpfgOUlBmgxbDVllmuCPt2+IXLL8vGGTVWDEWjKO8mFG2KTcZfUyfG44Cu82ipVfEfupT3ClCRON5NwGYU9d5vjvJ51+eYQQQ6t6FMv5vALuj47YjWzo/AXcrzlABQqVBqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714470587; c=relaxed/simple;
	bh=dzicFsc8Y2YlEnYMp8+flz3S0RUAkuJc9yRGIxwS9u4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JgsN6QRH5LZas/DmPRI32O+Y65vOLxcaEaE+ukxS9VXKYNojjqpNL9NWewm1iBvlZyB8hq5Q0njYt3fDMY9/ZFUU2N7B68/tl5Ed9nFjQzITeOHmDHMYIi4rD/AhVuA5RrsEV1WR9oW4Boit8BxgdzIAkM+I1Aai07Zg7kaDECw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dsOc1z+P; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714470584; x=1746006584;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dzicFsc8Y2YlEnYMp8+flz3S0RUAkuJc9yRGIxwS9u4=;
  b=dsOc1z+PcKaCUbZwuqvqPIDbeMr81FtHiwHRtii1ETivUk1mwidiy9Rv
   PW2OTR1qmY2ydNTxKchsQnHuODB2keZBU+0YXQ0xgYg0o+xF4ukxW7pE+
   Mt7OrClVOyron9jy0e3be1dndVB/bDbBPgoJq02b4ZboYkLwqk4Dfda0X
   bmivUlQvG5BRA4wQhMXqPNfiPmgYBMFQyZ1VyysY8dPv8QAYFlb3EA45O
   0GyJqjgItXAQ/BK/c/i4hcmY2psiB9XCZ4uyeROirmGcVkjfWwSlkDXaB
   2DLx5Vtdmee6/Ku17GMNjWbznxAmo3RauJ9m1yYiB/6cG1Y84Uh6vgyuF
   Q==;
X-CSE-ConnectionGUID: lztXvI6oRG+nilYqcilN1w==
X-CSE-MsgGUID: onOykXcXQyGvDN90Ini1ew==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10017033"
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="10017033"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2024 02:49:43 -0700
X-CSE-ConnectionGUID: EY0WQ3cKTtqVq3zRVZBseg==
X-CSE-MsgGUID: s4I+QxqhT0GSo2i4V1GybQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,241,1708416000"; 
   d="scan'208";a="26493972"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Apr 2024 02:49:43 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Apr 2024 02:49:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Apr 2024 02:49:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Apr 2024 02:49:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Apr 2024 02:49:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7Y8Yl7mBMbWiUD4uWREb7AxN2bVm7SYihi//chk3RhG/agP5KUW+BO7Bk1vCjcyFiwgN1u+IoLOca0gcPz/NM0QIG43IITnzRfXBSJVXi2Q7tDx2Cj5j0w0koyThjbGi7mpfWLNflcSKVqBfdBWV8Z4XIfnvqlgOFFExzuIwojvNAnF2uBgrriYOg/NQiKFjEZwJ3gT2nLWFjl7V/SXGZ/I/p7u6wWZtkRbDzR7QshqASdnHG4Q8acCQ6bYOGCbCb/iOgNiAfUJAIA8n98Kj8rKxRHsd0OhFySyEVGEQEQrlbuVSSZw96w0NCZtmWqzuuaeJhxnpFbPYJjj+u+FMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tip7hbdvjGdwV4gk0mFo/CfFuPabQWXVMjxIcFXwQWs=;
 b=DV761wXUmq05S2G1Gsodc3XqGf1XnSKHrEgTScDxmRA4rZxY1+HUvX/nwtvbGKXeIVmwWq0/Qz1S/alPoxUOquUqacyp92gu4CjeKiYnZhMNUfKTLGygZOBmwaSmw8B3vaS3FvHqiaCbPYATUf5Vx3v3Jfs+Tzm3RNvR78asElfLtb5Eg76pV686Nt1XgSj4QHJgoKsg/3NFj96khwjJJTJStL7DLQ1tWz6CC/uE4p4i6ihNgD6jTciEb++D8HVXe1zo18+F2QrGrQKLdxVSE/oMgO+omokA5S4jjxyWoaagTYBwe9yDra/K65GY1qK/GRTiHizY95JQCMmOVYZeNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SA2PR11MB4825.namprd11.prod.outlook.com (2603:10b6:806:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 09:49:41 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3487:7a1:bef5:979e%7]) with mapi id 15.20.7519.035; Tue, 30 Apr 2024
 09:49:40 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: liulongfang <liulongfang@huawei.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>
Subject: RE: [PATCH v5 09/10] crypto: qat - implement interface for live
 migration
Thread-Topic: [PATCH v5 09/10] crypto: qat - implement interface for live
 migration
Thread-Index: AQHab8+8zwh8J6q/SU+vnDaXrayAibGAeCeAgAAv1bA=
Date: Tue, 30 Apr 2024 09:49:40 +0000
Message-ID: <DM4PR11MB55026F0FF713BCB3317F5AC7881A2@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240306135855.4123535-1-xin.zeng@intel.com>
 <20240306135855.4123535-10-xin.zeng@intel.com>
 <7cedf6ec-3c8a-b6d8-d5fc-778554c011c2@huawei.com>
In-Reply-To: <7cedf6ec-3c8a-b6d8-d5fc-778554c011c2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SA2PR11MB4825:EE_
x-ms-office365-filtering-correlation-id: 446819a1-42c8-4e62-b88f-08dc68fadb41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?pSY4uKG2/wwrMsYNlvwwB/LfU1DvmbbKrilcFR9b310/C4RJNT+Z+RQM4I03?=
 =?us-ascii?Q?XvyJJK1z3vg0cu6Guq0v9paLeNMi3vqwv4i5iYnjYuIUWZcmQd08GFL3m70R?=
 =?us-ascii?Q?sI5McRLNsaHOdDoZclqsZORk0TlhRF5a/aPfyAJ1+ozag1GjhUohy8YQpaXu?=
 =?us-ascii?Q?b0QG4DgOw8P5XDYWG4XOG55GgpPEC1SjzPeIpviRTQsNn1wSrmMgQ3oUSTka?=
 =?us-ascii?Q?nkcbyPMDAJP2wZF0BK1vQUVuNJdNOajnRwbu+ngR6EU0aTsEjS42qaz7M8pZ?=
 =?us-ascii?Q?Ff+gYd0PvnQ5KRUoLyeNXsa+yYUZYanlbZ4nmbZZaPlBix7T75Z+FJfV4CmL?=
 =?us-ascii?Q?P1qVtIe+LhdZeUN5wlPmCDD9u/xpSNPpUIyRJX+mEEn55ZBCVcejlfaHkkXG?=
 =?us-ascii?Q?mlbHjV+K7uBpIvN50Byofp+/SWiZMPplGJE9HeqtXGi0W5l4W+IJcAF26Xt6?=
 =?us-ascii?Q?J1YyPPQxZ6msfDxdRQBFsY/9is5AQ6Fghrj+oebRRQ1efHRwFNTu7x0CSq6g?=
 =?us-ascii?Q?wfBMu593JByuBehR5TbV7CH3dHTejxb8kH7408WdfV2yg7gUBMW06CT7/K/e?=
 =?us-ascii?Q?M6xYh4I9MFDb0oORjGSsvGD0RN4uE/Gi3qc9LglWEraRzuA/TdjH3+CRUAVZ?=
 =?us-ascii?Q?RkiDy7LxaAJwAyN44636/fvYC5rLyLfFy5f5xgucikJ2cB2uvm+ydkB21P87?=
 =?us-ascii?Q?ajwUXTVoMFCHh0Z5HMYPbM50zHFadz9/ziGokNrMazTL0NviTNrvetebavdm?=
 =?us-ascii?Q?CSmC5P4ReHrM/kMPzeW/PeM1lLBcGrhxH0OVZJBFWh2iPV7x9dx+abrkiHV9?=
 =?us-ascii?Q?ktalL7IKAjF+iYAo7iEDMTyDzuWrzp3slQAAgXMpd3S2lfvMS/9fhaKlVs4p?=
 =?us-ascii?Q?wqBrNLpVNSbGnlKLHl42tCXbDWPBbfIJTpapDVn4uL/k4y7Yi29gx5lfLZmH?=
 =?us-ascii?Q?k/hAm+VNzlY2eglS+DP6p0MSCct5L9HTYJaGtRAzWL6LFQPKiR4r/UfQlTHs?=
 =?us-ascii?Q?d8qsIXNcfb8gcnEfoSpjqYz+3NWdAIkgDNHKDlv4ibK8O8JSSJBhu7M37jnB?=
 =?us-ascii?Q?VrGvNfK3uFSxcDuDzf69+s1WC0Lox/mzbgdc9jSYqV/l6zzQSNjVl2iH6U6h?=
 =?us-ascii?Q?D6fXb48GEsQ1pUB7cxZlF5KSFJiM8JWdB6bi+nlefwuDb09UFCbJJvIBqeTO?=
 =?us-ascii?Q?PeyPEG7Vfdr4jYeNZaQ4FRbuCX2SZO6ENvhNNrasPUAaTn5iOA1Sz2dNynGj?=
 =?us-ascii?Q?JqtIM4rEGAEAwIH8glcMTD+audI+3bz/n+N4g0Z4VdOr8o/7hFTPyKhxdhsX?=
 =?us-ascii?Q?hS8yjTNBoKcATyTADAVbT7X+ecmXUyIf3+XP/xSQ+dpfbg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3bnwQPzz3jtbCcDewNpBjtL+LFm9GpJLzydtGSo+T+xV6Fp50xc5++/xQHjk?=
 =?us-ascii?Q?ZyoPvgEYzZGF0zyuXpafbAx9vV/wukE+M1A6ahrxFfnfX4AgCmBYr2c4Ek39?=
 =?us-ascii?Q?vy42u1Yh5LjsyZLA4BPkvpay+6q8Ys9fOM6gmXo3nSA3l/0ka7FM9zsk7qSh?=
 =?us-ascii?Q?qH5p+N4jkNbOA7wXnaEGi9759fORviR53DXpZPtvL+8ct5lLmmO+lUAsFXTy?=
 =?us-ascii?Q?diC2Q+NG75zfAbqQ88r2tc4aW1Jcljthd1M5PfVrMsb5xSfTXfDIsChQJkzG?=
 =?us-ascii?Q?LGMKq9UBQeEVwge2B96xzKksqjoM+X5nLQY0mjAqakLalRIRiNR70gkKh5Td?=
 =?us-ascii?Q?uodSuPYF12JdlEb7wlvgCoTstTn3m4l3ra/i+9GWOQNw2cwTOPypKdQR0+Ki?=
 =?us-ascii?Q?gmZk7UV1ekCWLlCDTJW9+4J/fo2l2GTL0c1huqbavccn3DHpJTftytTLonRd?=
 =?us-ascii?Q?4wyw7M6Ub3zs4IBu0WqFY0CA4oMQaMGjm7xBHdE+SoN9ZNf0UOhmbYGW7/mS?=
 =?us-ascii?Q?EGNLPEkHaTeO0osnFGhUPNYttmQwaRZm460fSWr2zgbRM7B+ChKZbXbpF7qO?=
 =?us-ascii?Q?Tol2NV052d3gg1tu6gShBcwtSGmLzvGXWoJYTdyT7UCw217aosfdDsxd6WXp?=
 =?us-ascii?Q?MdmJaeOd8wQEjpf0c74llCdeGtyRnKQRYgskcJ0tjE2isQ4NYvuR4jpngvpL?=
 =?us-ascii?Q?adwTmEaS6fO3HhnG2SER3fI3QhuqZQpqJQr14LS/RLE9nrqt1cxeXURFCgkG?=
 =?us-ascii?Q?r2vXNEufRRxumSQFH6lmmqGM/lgKCPbKJUV4ea8pFO7Tnknz5YqYdJz+k52I?=
 =?us-ascii?Q?7qOU7/BOVkp147phHgIvBUWwuVezEuHmc3Ku0duKmHNm+b/cCsxeNtsz6C91?=
 =?us-ascii?Q?9chZZoFdYWrZ178P+Es+bU81t4OfFVqNhcPZdk4chAtYHo7cKV7VHKjHYh8Q?=
 =?us-ascii?Q?pR9e+5EEtZlmnyWHp/nK0hLwW4Xnv2lt1/PKHlz3O0ZJxAJ2ngXEsCmQ+KDC?=
 =?us-ascii?Q?5G0a6+x/4b5NN1Finyni8XRd3oOplyTSAs7cBR7Uatjr1fQLCqi0Ey6gCZBJ?=
 =?us-ascii?Q?g/Blo/PKrn+pUZfDVAkQbr43b3yRD6HGSXR+7XQbfUH1mYUFNK18aeNQGdrh?=
 =?us-ascii?Q?d9QcLOLrgLwB+cLVGq5OHjbBYad7zdFqFMGY92WRLrySvS3HGYH8V6MQuf2I?=
 =?us-ascii?Q?QMUqEhDv16FdHmBCLqnPo0+7Uzh7zLC9uef7AumCJSYyY2znSLS/j3dpCmpG?=
 =?us-ascii?Q?LDSJdYZKi1Z5YH0cZkA2gTq0jqyrJ8r46JerQ9tjqPw+s2cSD5tertwRTrNr?=
 =?us-ascii?Q?buUbRFiCUhH3AZWghiZ1UT1NKsuCcp/W47tiGBFVXjU7yhvVHKJPytV7T5kt?=
 =?us-ascii?Q?/TITL8VbAfpGGwwU9pgLx9s+y01YU30Og7aEx8MO4qKv35F6l/c4j+aSOqrc?=
 =?us-ascii?Q?jmoZRKi2K0skfSRUxFZU3uG7TrbJfjbix4UhZ8BZYmExgUB76VekPe4VjXSE?=
 =?us-ascii?Q?ww1mB1+A5KAi6rigwW2ttBtWdw3JmHXNAySBFus+X6qZXs3ultVgSFWXJ1ot?=
 =?us-ascii?Q?ZRZPfir0OGQOjMgLMO2Q8//jBS5M3yPc8TH6unwF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446819a1-42c8-4e62-b88f-08dc68fadb41
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2024 09:49:40.9149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hwnnIQ+P/frjlCWfxssDTHsUlKDo4Qzm3hGe8Mq/D2YZ/Jzw14Nao5qclKArSyErUfox/b0SkOxhljKlflvBMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4825
X-OriginatorOrg: intel.com

On Tuesday, April 30, 2024 11:10 AM, liulongfang <liulongfang@huawei.com> w=
rote:
> To: Zeng, Xin <xin.zeng@intel.com>; herbert@gondor.apana.org.au;
> alex.williamson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com;
> shameerali.kolothum.thodi@huawei.com; Tian, Kevin <kevin.tian@intel.com>
> Cc: linux-crypto@vger.kernel.org; kvm@vger.kernel.org; qat-linux <qat-
> linux@intel.com>
> Subject: Re: [PATCH v5 09/10] crypto: qat - implement interface for live
> migration
>=20
> On 2024/3/6 21:58, Xin Zeng wrote:
> > Add logic to implement the interface for live migration defined in
> > qat/qat_mig_dev.h. This is specific for QAT GEN4 Virtual Functions
> > (VFs).
> >
> > This introduces a migration data manager which is used to handle the
> > device state during migration. The manager ensures that the device stat=
e
> > is stored in a format that can be restored in the destination node.
> >
> > The VF state is organized into a hierarchical structure that includes a
> > preamble, a general state section, a MISC bar section and an ETR bar
> > section. The latter contains the state of the 4 ring pairs contained on
> > a VF. Here is a graphical representation of the state:
> >
> >     preamble | general state section | leaf state
> >              | MISC bar state section| leaf state
> >              | ETR bar state section | bank0 state section | leaf state
> >                                      | bank1 state section | leaf state
> >                                      | bank2 state section | leaf state
> >                                      | bank3 state section | leaf state
> >
> > In addition to the implementation of the qat_migdev_ops interface and
> > the state manager framework, add a mutex in pfvf to avoid pf2vf message=
s
> > during migration.
> >
> > Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> > Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> > ---
> >  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |    2 +
> >  .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |    2 +
> >  drivers/crypto/intel/qat/qat_common/Makefile  |    2 +
> >  .../intel/qat/qat_common/adf_accel_devices.h  |    6 +
> >  .../intel/qat/qat_common/adf_gen4_hw_data.h   |   10 +
> >  .../intel/qat/qat_common/adf_gen4_vf_mig.c    | 1010 +++++++++++++++++
> >  .../intel/qat/qat_common/adf_mstate_mgr.c     |  318 ++++++
> >  .../intel/qat/qat_common/adf_mstate_mgr.h     |   89 ++
> >  .../crypto/intel/qat/qat_common/adf_sriov.c   |    7 +-
> >  9 files changed, 1445 insertions(+), 1 deletion(-)
> >  create mode 100644
> drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
> >  create mode 100644
> drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> >  create mode 100644
> drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.h
> >
> > diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> > index 9ccbf5998d5c..d255cb3ebd9c 100644
> > --- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> > +++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> > @@ -17,6 +17,7 @@
> > +void adf_gen4_init_vf_mig_ops(struct qat_migdev_ops *vfmig_ops)
> > +{
> > +	vfmig_ops->init =3D adf_gen4_vfmig_init_device;
> > +	vfmig_ops->cleanup =3D adf_gen4_vfmig_cleanup_device;
> > +	vfmig_ops->reset =3D adf_gen4_vfmig_reset_device;
> > +	vfmig_ops->open =3D adf_gen4_vfmig_open_device;
> > +	vfmig_ops->close =3D adf_gen4_vfmig_close_device;
> > +	vfmig_ops->suspend =3D adf_gen4_vfmig_suspend_device;
> > +	vfmig_ops->resume =3D adf_gen4_vfmig_resume_device;
> > +	vfmig_ops->save_state =3D adf_gen4_vfmig_save_state;
> > +	vfmig_ops->load_state =3D adf_gen4_vfmig_load_state;
> > +	vfmig_ops->load_setup =3D adf_gen4_vfmig_load_setup;
> > +	vfmig_ops->save_setup =3D adf_gen4_vfmig_save_setup;
> > +}
> > +EXPORT_SYMBOL_GPL(adf_gen4_init_vf_mig_ops);
>=20
> This GEN4 device supports live migration functionality.
> The above part of the code supports the live migration function and
> has nothing to do with crypto.
>=20
> Therefore, these should be moved to the vfio/pci/qat directory.
>=20

Thanks for the suggestion, but
1. The migration operations of QAT VF rely on QAT PF driver sitting in
crypto tree to handle. Some of the states can only be accessed from PF by
PF driver. For each generation of PF, we will have a PF driver. It is obvio=
us
more clear and nature to make these operations part QAT PF driver rather
than the variant VF driver.=20
2. The interfaces are defined clear enough to understand the dependency
of the variant migration VF driver to QAT PF driver.
3. A device driver sitting in crypto tree usually not only provides crypto =
stuff, but
also provide helpers to support other functionalities such as the non vfio
use space process access logic, it does make sense to provide migration hel=
pers in
device driver as well.
Those why I prefer to put these helpers into QAT PF driver.

Thanks

