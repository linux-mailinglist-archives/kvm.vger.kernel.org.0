Return-Path: <kvm+bounces-30853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 805969BDFA5
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8007B21149
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1EF01D0BBB;
	Wed,  6 Nov 2024 07:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxOiyE9y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99639190470
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730879044; cv=fail; b=lCgnakTBc5ZrbL6lbQmN5hyTCtjnedRPcmLwEbpFqUiJQRbT865xSwAHUpAwPCXYHOpW4RdA4i3rZ/A/HiPnOABZxxlzq7WN6oBebMn8mjMXescm0G5uibhYc/I7UNk5L+EXaIMFxSN8xfBJJWhAatNpr4enA3hOpBlGtHWR7iE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730879044; c=relaxed/simple;
	bh=qWtFLREmX9oevUiC/qk9tg1JRd65rlrzlJMF9dpHt/Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EOKC8bUXeCVUALa7wpG860Ep3fePjvGvrIz+nzeTnbULvWqAmIZhPN+BIL7i/UsfMfQbRr0+v6DB4BJUFU8JCvfA2IvVMph3P66eAPo4+gDQeIpG9dW6ZtuXZkKLGQh50w5uUUlW6iUqcr5esSnLffNn0Z567/Qv47zjKSqozog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxOiyE9y; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730879042; x=1762415042;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qWtFLREmX9oevUiC/qk9tg1JRd65rlrzlJMF9dpHt/Q=;
  b=OxOiyE9ySN0fNRbF7l3zf+rxhcnHuVn18D8w9z9nhri6JpBobbOU2Nv7
   bSm1qYbtrIIX3ygNlEo4ueMz/ZJMXZ4tvsRlGOhejIqCacTr6UbVe9emM
   UgGl41XRzQhf4U0SSGpOTfwaYDp6As9aULI+nlb32uoP6Z9FOrMoVUKdb
   8/LCQRyIMj27tyTl4t54eHGPc8+HCgJRsk6QGPUAvbhFYYlbjlSgpJhQ4
   ob/8LeCZWzcUXtAU0PoClfJGTEc3Gk2MBbD1gyc/xEKVEbpZxJn3Vfrn7
   KjtNGCwkn/xWq7d1w7EkEeM/6Oa89wP/fBt0dL9BPjZUkpUUBJ/QaUO7j
   g==;
X-CSE-ConnectionGUID: uQQ2S+hhRWGJvJja9Rn1BQ==
X-CSE-MsgGUID: pGyBgk76QU2BrEYbMoUalg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30543461"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30543461"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:44:02 -0800
X-CSE-ConnectionGUID: ZNxe9hfZTXKI5J/Vn2V7Vg==
X-CSE-MsgGUID: pvHxwdrbQ5ivDgBJjMYpXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84524408"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:44:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:44:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:44:01 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:44:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q9YsgxTxUHG/tF4IaMCWOuwRGCJQ46nX/JApOBhSVTcAkfVMhlM9n7dnSQYqkIix8qpvj+G7bfBi15itI8ihE8+VVrc2zqpmhNabJVTuXgbVRWN6+3gvNuM2zZuNRoWQW9JIWzXSdsZzdW/KYCj6LeXxvoTvZiveg5zDNGPX0O84tccOzHz5SJNmM/1RUZyRjBKTtqW3RjeOvHV9GUHRVPsX4xriU6xDCIVnzL89xtWULQBR2yOOCDKKP+h09G329fRmBWE5AzUCLMzzoQPYpR5AQF8Wk14Tfsg2vRNPM0tpUVwPtesLxjZXuezlC/9iJbjzc5ZKBHTJKedBXDW8oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PzMwDCxOMD+FB++YiKMV1xLFkCkpE80a0sbYNlQVso=;
 b=psUBjH0nFR1DLEniXyl3zSj5yW3mOZEdI4/UNToAezTq+8dwUBCiBoMPHOTrqFhjAw7RbFNDVz3rzLw/roOYObo7D3vohJAwF4gPNI2t9bTo+zcu1n952jtpjHRzfY8e83dsQS0Fkbne3gCV9XXkiiEnoaWiO5IJ3wskMtlcc1eV6Tb5+4CMLi+VEbWGx8o+4j2YX5ckRaLyyIVIqbvXLmT/nV1dO0WO8SXnWjo9dTvFjrGddSh0s+cIZQzzAcTlIVTuX/wAnW041SM6UM9YrtMEIJieG/+hUlGYx22bTMWUfbfl5E3WmUA3CrTyvRqFgewr+BgpHFG96NZMdERSkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4998.namprd11.prod.outlook.com (2603:10b6:510:32::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 07:43:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:43:58 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 06/13] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Thread-Topic: [PATCH v4 06/13] iommu/vt-d: Make intel_iommu_set_dev_pasid() to
 handle domain replacement
Thread-Index: AQHbLrwb6yA5+Txn1U6CRFaWuvNtKrKp4ZDA
Date: Wed, 6 Nov 2024 07:43:58 +0000
Message-ID: <BN9PR11MB5276AB2D5E8E4B3E77476BA38C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-7-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4998:EE_
x-ms-office365-filtering-correlation-id: 6a0bcf46-5dcc-4e56-14a3-08dcfe36c642
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?wy1Jt2yrWAUu4nAzhiiToay2sV2StEskssWInCHTOhNS2R9J/EqHmYiPfcfr?=
 =?us-ascii?Q?dBuutb97iwZpy1vVCFBePKGfQD+2cKj0Id5yDCIIuz6aIEQr9INUbpec3MtC?=
 =?us-ascii?Q?7KG1UMrvyCX8tQTkyjbRnkDwdzLuguRkn9hN1T9I/DGHgG4JfopfGxY6pMmz?=
 =?us-ascii?Q?iHhC8bdX8uFoWA4hZm6NgI6GUdCCVcPsaUuCPMzrFVOVE++J4+Nua4glTr7I?=
 =?us-ascii?Q?ePc91LsXthUcaOEOAaHx6nqwDl6+1nTtFD9iVrorCvnp++7JgyueOLVcc/ig?=
 =?us-ascii?Q?0uWdgYMyyxq4ROxjhImdRnkuaAeRgH6EoXNfDj3K5Oo24dImtWw0fjkges2T?=
 =?us-ascii?Q?0taN2w+9IqJMsYATo2Wb9tjyIe1cwS4Xym7mlxiiGMksRRpHT7osRg0wrxlz?=
 =?us-ascii?Q?iFYjqKKyYJNQmWyhX7xeHrddVnUN47fVf5JTyDx37UGsIyVR+heTh4D9nIcY?=
 =?us-ascii?Q?7EfPjYHY9L+T09VmsD29VEa2sEzrmB2nlyONQCtLcrKfvD9JNwPxrRBocPyG?=
 =?us-ascii?Q?WkfvFoJwrAm8wH1DuspxiQSqHlzr5AYrOun6UhUIspqdT8DSp4+k9kRTF2Nt?=
 =?us-ascii?Q?c3gUHxFgQsLsRif//fg8nJYH11Q1Nqa65CdapKa67Z0TjmwzZmwscnUQM4BI?=
 =?us-ascii?Q?3OuPfLUWkkwB09xbXFTO994Q7TI8N9dAnFuGdSMqNQShMRN6G9RHwxwG3r60?=
 =?us-ascii?Q?8A4vDMvjso8ZbHoW4UF7JGQRYni+vdnQsVhWEYUngNO1LKet5xVf1nXvK1xe?=
 =?us-ascii?Q?Mb/eTXiGBNeUnRijw1kzN1jkmtyHrV0dMk8LwgUq+ji5ima1/fceKtInmTfi?=
 =?us-ascii?Q?lkNPT0TQ8sFVWUkFnNdVmbiHW9HCBQ/soT6UG7BmahZM9EKwc9+llqS6bUgp?=
 =?us-ascii?Q?EmGal0XzFdxnGEmbDfIJZCI5hNwVrdobMcw7v/mCcdVXZvMalSWVSMzcRqQ2?=
 =?us-ascii?Q?2RGT3/lCNDfjyjA7OMjYxzkVWQzCVKJ2gKiBSgvtZL2jLUXtsk0MgVmJtSk0?=
 =?us-ascii?Q?EzLitBK4qC8xV+lBFnNBF56aaBIxyZ2x3I4qQq/XZr25+DMox78m1mduIDM4?=
 =?us-ascii?Q?ioM2jDdGFdtytwrJ2xMP3PWTDcTkn8O0GjI7x0RsvWGNi68PT6mJyhMcjKYT?=
 =?us-ascii?Q?FkUXfoyj9aZZEkRYJuoQnkY9aUXkqzZkDPM9uixdOX5zdSWea4kEy3dmPcjb?=
 =?us-ascii?Q?HeV4ikgbgzwyHHlPzQx2NhXerg1tbnIgoLaSBZR5ybOeJHVmh+QOqx8Woed2?=
 =?us-ascii?Q?53CEUpp6jSpgFX+zexlsqj7X1vbD/7T9mzrKqXcb5MJMO4vGMYfeKYjMMYdr?=
 =?us-ascii?Q?VDFzaRhzReXJUY5c4/8DL6QKS6fQa1lRkcQJXn8Er0A9Asp+oQwpx2K2HzTu?=
 =?us-ascii?Q?bZQFApE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cSSIJPwJ1JxhrevymzZx8BHFplW580ihJ3mJvTGgnRw16ycpXSkd1TWxslPi?=
 =?us-ascii?Q?tNWipd0tYJBpGpCgL4QCKs+YdoXCEyVmFDtuCdjcHq12BrJKzzn5AFoPEDTL?=
 =?us-ascii?Q?JN09ovVpK1ENVAaxL4oortDA0aFHwnU0iubEnlzV9nWNuc336RrXcNk2WQ8B?=
 =?us-ascii?Q?X8ryPsom8SSb4CAjWISjYG3DZVROKL8VhPC3zaK0XYKk6BkpUQmeGuL7w+dn?=
 =?us-ascii?Q?MRLUSHDeO5pzNtubI16SgvdM9qIkXjCvSXTW050aKNxELfSp5MmazJ3XqmdD?=
 =?us-ascii?Q?vqUO4X5uJySRaGSYBRID7p8snYxZ6Cl/PabvaiRgBDYhyveSFCi3Z9WufBnp?=
 =?us-ascii?Q?p9XltqORDPBoowsPXjgzW/NlTB+mIOsQe7QGiP4M+AgQD6oJQXRqfVUgTpr4?=
 =?us-ascii?Q?++6wl6VSw0QWqZ8nzMSNxeNNZ1GVw5Y0FaZeofxbIFxBgrs3pq1whxSsiCzd?=
 =?us-ascii?Q?1nUHJb9MiAiZeiZK13438KKWlWSzIwnz367ulQb1PNaZHc+qBU6VFaGzNoq5?=
 =?us-ascii?Q?TgodKrp2D/vJIs0YVgO30JXoL2Xmy1muWyCj+c2PtrRGNZxByaUHAJ/Hv+Wc?=
 =?us-ascii?Q?JwNriQm7DrSYNkkMpuvKNeot4XravN8EhcXJQr+3CUa66KYUouUNN9pPEmM5?=
 =?us-ascii?Q?+x43DtCyj2ODMny7WpctN5kp/o5ZpyQ/VXHhY4f3NB3YVorDGso+O5JJ964w?=
 =?us-ascii?Q?gdReoFjHyRCqBED2FgWYOkRG4diatG089f1beL3ss2XDmKPNYe+T6YY6Bfm2?=
 =?us-ascii?Q?yvuDuSr4WoVe7Wcc4aREOb02H9lV3CrBt//fMT3VBMYZurXPW05C2OnDr64c?=
 =?us-ascii?Q?XBnPKbgnZLGbwoitmalby7U4ievbsQOB6rjNB65h3N0q8WQTac6bIAWRG22w?=
 =?us-ascii?Q?GgnWMEBQ+hLVtFxTvBdqEGWpspZKdkH3K7zAqxCfe7kBW7azWouQA02koDH9?=
 =?us-ascii?Q?7BFYx151/xCqpooHz6zQxjlMLTJ+F8RGqjzQ58gMJxLQrCUbwJ2Cj65kxtP3?=
 =?us-ascii?Q?vhb9UQSlO4+JJHXoIQiAG6gAxRRW1O1C2b46R/xOuocmcHPPBOdg5TyrOK5n?=
 =?us-ascii?Q?vmf+MPK++TynEjnhhEoo5z18FNAEDixH86YvzKjr5+nTNPTFeea+XQhAfUiE?=
 =?us-ascii?Q?D+gnnZ93FjCd7wJLgQjb+YFp+U9hGNT/wPpz+ZWQ+XHZxlDnmmhQQ7zRrs6E?=
 =?us-ascii?Q?BKrEaxLtqDaV81v2zjcAAg7rAG6w5nvAtdtdoO2RJftsYrMt72Yp89XyMiYc?=
 =?us-ascii?Q?pM66JY/a8pzekMr1PvUWgtK5KmGjgAnQujA66wnB1dHoZ0a4w0s4dEQeoAgI?=
 =?us-ascii?Q?ltk3fM6ClKbIosl5Pia/iJB2WFLi9BTSpQa9I02KXCcrmEag+KtUCHI4KZVW?=
 =?us-ascii?Q?kc82Kk+MYtfYBycMlU3VfhN0GwbmrV+MBTgP7xZwfl2U5mZDcdMZq3Etrq3P?=
 =?us-ascii?Q?nu1/yoUIzxxfWfp2zGEwBohzdVjbRa2GP+hy5Q08WswzSrMsPVhD1B3hRE6s?=
 =?us-ascii?Q?1DfgfahB5VFk+VH57pRnjpyaH+aIHCRzU1CZK9aczqzs4vfEsMTSyr0iZuRz?=
 =?us-ascii?Q?kpLR0TF5mjlUddj4NQhjUQChTh2yrWWQNnenzIOu?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0bcf46-5dcc-4e56-14a3-08dcfe36c642
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:43:58.7488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 32Lijv+ASrx9CQuj6NB5Ha48AKy5HJRqp8BsA+oDZVdZfBVPoYuM7sSXOT0Ei74aoYV+EgL71C37//B5TpaSHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4998
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
>=20
> +static inline int domain_setup_second_level(struct intel_iommu *iommu,
> +					    struct dmar_domain *domain,
> +					    struct device *dev, ioasid_t pasid,
> +					    struct iommu_domain *old)
> +{
> +	if (old)
> +		return intel_pasid_replace_second_level(iommu, domain,
> +							dev, pasid);

As commented let's pass the old domain pointer into the replace
variants.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

