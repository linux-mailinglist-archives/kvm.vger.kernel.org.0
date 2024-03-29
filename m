Return-Path: <kvm+bounces-13047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD3589120B
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 04:32:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DC9C1C223C1
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B9239846;
	Fri, 29 Mar 2024 03:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k1rcH0UP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27608383A0
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 03:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711683167; cv=fail; b=Ex5lbkLkLgE2CdbVvPTl8LbKZnux1UXUJn/Qt4w3L5xSm7PtAEUlyOBzQVDm6u7lT/z0oesUVlGOQ1Jl3zrvcU7QWur60soD4tYRWOByllhJssR5giyifd0ixCbN0suVs+injq7m8S5v/0ytLnAuPeYY0pwdkoEig3BJ9z2ItYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711683167; c=relaxed/simple;
	bh=OfJ0EozQLsxQXVXPSIK445U9j3StaKzw3aJApqVVaTo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jOED7szT0kO4n0zIotxPiaadkSL9B5yAZDFeQBMTxwJBGZ99VC4HN4jH7JITYQ3ouxXq1asg30mdOwJjaO+ptnyG7TVCLIhuKqFK7Cyymk4zO1cOsSrHewVh4E5md67FoeA+B7EP7MjbUeB6R6Bx3C1P9NTec+09SpUjaomXI2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k1rcH0UP; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711683165; x=1743219165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OfJ0EozQLsxQXVXPSIK445U9j3StaKzw3aJApqVVaTo=;
  b=k1rcH0UPNXqtTVP3J4OcYKSEiQxu9RdzL5CFhPtID9i/6tiYUVjzKRtd
   VOHjV25V8cAwzPPijEunZ2BtRktu/E6n/T7OW6nwbVkycu7le1dNl7yfj
   N8dEBQLVXUmj5GFhWV/wRKvr0zbUWRy5Du4ArcnbwViQMC95Nh1qY+fD3
   wGA+rKLxWyKTnrdLFElen87II5dyisR5qlBswy64zpnMb0tzRW7tFS9bX
   Dzs8IMrRUvloCaiW/C3xMEdi6XHRWWROeaM3jxuKRxmDIgQbsP19vDSAE
   y0FiAIBNoG5jyGq391PiDLAoUMZ/WCMRQ0RCL5d8cCU5Yr3Nj47h2qRMn
   g==;
X-CSE-ConnectionGUID: EPbP8iXxTmq80vQegY/0dA==
X-CSE-MsgGUID: 2AcezkR1Timg3OqM8Gk9+Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="6704562"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="6704562"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 20:32:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="17312989"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 20:32:44 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 20:32:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 20:32:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 20:32:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 20:32:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLWD7PZQER3K1Ubt2U9wBYh+Z4OZztzdR3+4lpKYLJDgw3p0ZVei/9LDU1qGdw0d4asEwaI280U1il33vqQBUlfvu6TsTNsNm+yCkh1ZQ2OFFGYbPBcN10WarFKh8hcByApWYL1DveSvlCfNMEleZL3bScBec0RiwGXLpuHe2v0X+GKudtyfc3p8NtaXvR68vUCdjPq7HfQjD036rOxuBrvG1VaInzk+qR0ysXl6I8jja/95mjsDM8S/xxudakHFRQKXvVZ65Ax4pwMF09/wtZR1e37PNo2Ii4QQMNWp24UMuErJY5jq8I4XPiMMxaHAE+pwKS3gmDA9fbzI127FjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfJ0EozQLsxQXVXPSIK445U9j3StaKzw3aJApqVVaTo=;
 b=F6pOgCxDXurPJclvUsJdE+NuH5iM0V0kj6Uo+vpPaX+byYn1iqaYqlTYc9XB9vVbmG/lEJGwTOQF7atFYVuGC0yO6MpaXyWjS9C3xvm502Lpb+lE9MNAzLAYKYHXjDL9iyg4jR3ati2JuYqZKjEbdLpuZMjKi22P38kNz/A/ZwFxuVTN6iyrlfHX3w9G9ly/Eq/FzXZyZuRvlsHk5/u6KvAD8wcAa05a2ijjbZ99stJYOfX7sS7tB7y0/GGkgMbaL7NwNSBLjJYzxX5HPoQViag+kZsNXqRqfW+HTuqCJzATQUIewU8FrYSmnACxjrWyu1xzjo+zLlOqYbCsPZI0VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6191.namprd11.prod.outlook.com (2603:10b6:8:ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 03:32:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7409.039; Fri, 29 Mar 2024
 03:32:41 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH v2 2/2] iommu: Pass domain to remove_dev_pasid() op
Thread-Topic: [PATCH v2 2/2] iommu: Pass domain to remove_dev_pasid() op
Thread-Index: AQHagQuv9W0ucrYMtEelOd6nas/lBrFOETbA
Date: Fri, 29 Mar 2024 03:32:41 +0000
Message-ID: <BN9PR11MB5276605126E8C9EBE26FDC648C3A2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240328122958.83332-1-yi.l.liu@intel.com>
 <20240328122958.83332-3-yi.l.liu@intel.com>
In-Reply-To: <20240328122958.83332-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6191:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QSY3cSiDl4P/y76AmABspTOOfO5tThwX1f4rgm6HkBZj6044YTG3JrLDzUYWFwQHKNmUUiCs+nXQCcUiqRFk/I8uCY2fbta4rJRUfkxiobNKlsHGPxgAAAdEEG2WYwWcu/jSB+CEVUXNdLKL5Diaq7vJXflKw9XVMNuAIlKJzi0b40SJV0/8lRFz+cW28tlBPi5VYkS8XSBITq5b1FugT1lI6qo1UJYRmOd8eI859zRwNGOJWBNsHQzCBk4PdPXb+wUNkcVHOWsrz8XhLkN2Zf7y9Sa/qL3nH6ZAjVxVdYUKbqLvrlA5ivwy9bshurHNRi4hZZ47j860MbrJPaFbdzNucrsv2m3w7OobjY0JYVDZiUQ1BJ9TrhRkSofVI8eTFrn5Y9YBkHHVXGBIsUGPBTgwHU+tnkIH58GSSjktRagZ+TMktUJXE1NVgK8+K3RqkQTaELOpZn8yrkuGjjDKCKVniCvZFxiPfxAJIM1uTgxVTAtzA4lpVQiKody+5xAJv5pGCOMCeLDEvQfCA+xV2eMRFEBHY2A2oRgQvCCJYuSC+q2aIPvBqeA+FdKZphGHs+cbgZ+m8E/y8ljqOL9vKUtsTelHTJdXRedfGdC630a32WGv5WYTK3Ga1GhApOfsCjVfbqd872x7nRuRNoxMIf2qY+Ztw8VPybqAW19yhCQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SigyMS7dbvDkGO73MvWGUMHAxXSXGUyY8v5oe7mZOnQMuMgJAWPxRaL5+fnE?=
 =?us-ascii?Q?cBNmtBMMw/8j5cGxO2jtK6I35Uk+RrYkOWfwgF7DedmK2+xkdx7wOnxJ45mm?=
 =?us-ascii?Q?OCJeipGXWFpkpklL7XDINktS94MmXHkcDvRIc/+omHDRhMzrNaixJ22L9jRp?=
 =?us-ascii?Q?DPkouCewn+IHYNwdjmIv2frGrlvhAAHP4TeboLCF7nyd2SiYgC2jztMgc1v7?=
 =?us-ascii?Q?b/ifgC0+3MAEv5WSVXDsEXBakTa8lit9GLBgd9Y6yxquN8IiKDrlA5gQXc8Q?=
 =?us-ascii?Q?gcED1FElG3W3LIYMQiPRcllVHGf5q8FSWKgO2cgoop7/PRnhEmAInTXZ5j2t?=
 =?us-ascii?Q?S9+5FJhWZVctt8ZkLshQUwODveRkpspO5q+zjY0k2mQTBXurvVOuflyY3Bq1?=
 =?us-ascii?Q?1LjHS+QAkGYac6UY6FzvSdB8n2Iz/1lmEA05XChXldHYJhaESsW8fJhq0NvZ?=
 =?us-ascii?Q?OS5Q1a8o2uvADUJ+jAzhhRqwY4zjDs6cyPs1uMyiuHDZkGL+FhxIRj0TMshF?=
 =?us-ascii?Q?Mwkm3NcF6DSyi3C1w8LfGrCZVAPKE+ciwAPqDt8UNJpoIwe93b6YjtnwCzDP?=
 =?us-ascii?Q?53RoGXxhamYaMeYkHLb7lr0fPnO3isfrfRzAcJzph7oaaQjJH24czw0bXBg9?=
 =?us-ascii?Q?jiyoVJ4i9HYbDVLwxWJdFTGC0KQLY03eFVhk6AUYBXo7OG+dgV8M8FY+otNq?=
 =?us-ascii?Q?FIeNnb81KUHGoeU2HdB2oHg8BToIHBjfhSQH5I2+qI/YXZnfy6W+ERScRLjE?=
 =?us-ascii?Q?esZuy4TLX5/gAjFffth4E4CIUeFlD2UY6wdLw1/YQ5/7O6KONbn/23xDK0RA?=
 =?us-ascii?Q?WyJJ1x6QDnLb55wXrAlx93lA3GJ5O2Ut6dEzAREGnDNO7D8TNAwpJP7fGDk3?=
 =?us-ascii?Q?niBmbiLMMYQE3pXAaSrmrdFoWXBRmW61KzBffso6uQNc2NlVKC0yWagSE8ho?=
 =?us-ascii?Q?M0PKUEEGrLdGkN1H7h9G0sKV78vzFIBxOrR2Ffif+Cv1TQfPxDRalquUdi4P?=
 =?us-ascii?Q?zIWu5iH2EBAjHihSDDiRfeUuUHOJZ8xQSm5G0UJ61G5RlLAMNoT4TQQqVOQN?=
 =?us-ascii?Q?3WrqfQBI6id7VksM8DCuq5unWxRjYBZ9xzztOo7X7cRhBNlyLx8Hec3QNmeB?=
 =?us-ascii?Q?DjUrRbjIKIxRFJTXjcQ9tUHuHu+uktmFE7Aj1T6p6F1TLeMqI2IlEmRGKlh1?=
 =?us-ascii?Q?cxt18fI8UNi1mBwAV6+z9998wPsMZMAH80Tqjj2WF5U6pxMJiqNZN+98sjGW?=
 =?us-ascii?Q?Db/vVW13BsCkUcKCd3/fSJoK6XaMDcZtPof411YwxTxB/Bx43NqV5Gv3LL1U?=
 =?us-ascii?Q?SP6fGdeBVNV3+YkBHmJr6HtOhlbbW/a2BULIK6hpS1ym8dQjUOE5u6Yy5hCM?=
 =?us-ascii?Q?q/DtqtpKEE4ZQ9GdmOmyUAhdzHZGwjvSVkRSxpAgfMPOp4E1cSvtDt8tKSLV?=
 =?us-ascii?Q?5XOeQWJ4ak3VK+B8RSi7YiIeoZoYgq74Kx+OVdTwYLKoDHdH7ktA48cjy1u4?=
 =?us-ascii?Q?s1CzUs4VavUEGAyL/GFJItaxUdDvsbkw299RQf3TnjQg7esnWAygF3CLKRC5?=
 =?us-ascii?Q?cmqxp2OkG4yo4Fo4R2T5pox2QjQE2Bfbwkg/rUAS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e93510c-cfe6-4064-0017-08dc4fa0e3a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2024 03:32:41.1833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RxB5Yivgyov6/8ARqtgUYgSXzkVdURwbb0NMAllK1Bni6dKgoG9e68MqrwsP3arMr2dMhKsoeMrsEt3K1CfebA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6191
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 28, 2024 8:30 PM
>=20
> Existing remove_dev_pasid() callbacks of the underlying iommu drivers
> get the attached domain from the group->pasid_array. However, the domain
> stored in group->pasid_array is not always correct in all scenarios.
> A wrong domain may result in failure in remove_dev_pasid() callback.
> To avoid such problems, it is more reliable to pass the domain to the
> remove_dev_pasid() op.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

