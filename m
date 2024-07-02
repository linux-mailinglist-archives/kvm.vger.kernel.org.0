Return-Path: <kvm+bounces-20813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E84D91EBB8
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 02:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75B71B21E21
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 00:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338BE3D6D;
	Tue,  2 Jul 2024 00:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XOzI15dz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700D763B;
	Tue,  2 Jul 2024 00:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719879428; cv=fail; b=fJtCftk3owBVPRo5F4XnsYLprchaZI9b8PBGnCJPm4CIEK1o2TCgrOCkByc9Xwc5mmhg8m+9k9j2OBYJ8kr6KFk3dG6Wh2Q2Vx9lYKD6OhKNAYMNaF48gPpDSKjdHKPOFuoj2WbHcODduMeZyODNO9htkcR84lfzmrNChBqkUIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719879428; c=relaxed/simple;
	bh=TOz7h7orUhSGG/AlQwvm7hmAU0lQoCDUpB3gNjpwc7M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cOA/4hOgIgJAHACDlp7CQZ1HQtBWImLFTEaZOaAaqvsYEYK9iLt2aHgbpibDXYyzajeq1lBcyIAZXfAwWq1SToRqZr0Zh2DNm9SoYmyiFM+NWB+W3vx4+Vus1LjaBZ11Wds5KPTueqeH9+zZCp1+yinbCRs4PuRPaAcrsX70gUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XOzI15dz; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719879426; x=1751415426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TOz7h7orUhSGG/AlQwvm7hmAU0lQoCDUpB3gNjpwc7M=;
  b=XOzI15dzi6+JSYcUQHPMSaKuBfjJfinvM85kSuvxRVjaMWDEfpkys8rn
   0AZPzGb8xG0ou4wLFhRvw2lzFic4FDPbYzbzX+B9EpuLmWiyeJpArj0TH
   +3uEfrdyQVI+Io7d8GA5Dve8RAX+n9TPLFtqhYt9CByt9mtwcCEGiyXkH
   X2d71jtq0KMm9ckYfrm92vcl4VMtvG20u/vV8Ty8ygMGBbDPQUZTIrknt
   AjGDf1l+RXQW/UTq4A5sV+TeeLfKo6D+rReToCEfKlZXKE7kSN/Lnh29m
   3+2p0+emhekMhvO80/mZ0MrJqAaMA8hd1bOBbvF+3F6NHhz6IIlQMUi/q
   Q==;
X-CSE-ConnectionGUID: k1rZhNLmSMunCAn7EwuHYA==
X-CSE-MsgGUID: 8KL2TUdnTqOakwDjPsEzoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11120"; a="28431296"
X-IronPort-AV: E=Sophos;i="6.09,177,1716274800"; 
   d="scan'208";a="28431296"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 17:17:06 -0700
X-CSE-ConnectionGUID: nQL15VesSp+twPh38C4ACQ==
X-CSE-MsgGUID: k+MJBGFOTB2W3r4ZjHL1cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,177,1716274800"; 
   d="scan'208";a="45665158"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 17:17:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 17:17:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 17:17:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 17:17:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 17:17:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EL/RvD7qI3+5tMhVYtgf1krR6izc5X71C2g09ILN+Y2GSCmrgJm/jq06X6cTiVozaV0A1C+jAueQhdXQWgYMHygpnXCG5KCcIgCsC8bz7tQAhlwvAc/0dmmgKScJTt9pJXbpzQ2N+g/BeVVJOfM8j6TGbh7UtnD9sbQbBXXUkDOzVg7xrSYlab2tLYchLCgIOeWWqnYswGcidXLrNdMhTt6THlztmVKujL372shAMEYEDxDoiVWnRxwUtJZIIYVGtN/KBKcogQh38Jbp+gCnddxtXzXCMvVZpXRVBttJodXUmO3crMbQaN39uKUZVW8OnIYTnA17qPCUqiA+LLr8KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6zlFYjqULphPTtbwDdlR+Uu22qS3rjxyDeiSXX6NEw=;
 b=DM3vXxE/ZAuVz+J8FU7n6mgylB7VJZ7MLwvrwnIDyrLgOR3yEfpIE0TNg309T/bXchaRf8xxmzHPNYxuU0pYp+sVl9Y0ykziCLALoZ9XtLQybSqAk0mBbcfq8gq/eM19imjVQNQNAlhPFa1GIdROIQu6lHwOYcj+IaB5/PavzaX4v6ftMK2xgFfptAg++4JkjKIi+AyOiPBXS2dYq7mpmdCfv0xOEApEBXvajHE1Vjn6P/HoxUipaZI0c3dKnPTuASTY9zIQ38xTlpuUu+LQ1iKyFEhCxtVictodjVachZOx/gOyb45aX5LHcvzcZp60/7fGYQZzcB8KUBAWEVxOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB8108.namprd11.prod.outlook.com (2603:10b6:510:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Tue, 2 Jul
 2024 00:17:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 00:17:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>
Subject: RE: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
Thread-Topic: [PATCH] vfio: Get/put KVM only for the first/last
 vfio_df_open/close in cdev path
Thread-Index: AQHayW6q9Ma1HJkB/EOYHWiKOaLUf7HhiCJAgAAoR4CAABm0gIAAyxpQ
Date: Tue, 2 Jul 2024 00:17:02 +0000
Message-ID: <BN9PR11MB5276546B8657FB468F5BA33F8CDC2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240628151845.22166-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276059EAED001D833949DF88CD32@BN9PR11MB5276.namprd11.prod.outlook.com>
 <fddd5230-28ac-463b-8536-ee953072d973@intel.com>
 <ZoKavalggv/iXCPB@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZoKavalggv/iXCPB@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB8108:EE_
x-ms-office365-filtering-correlation-id: ce0ea0cc-3678-4693-baac-08dc9a2c4c30
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?srVSY/fXQwX65Thc4kZIGlgBt5T3pFPHOeWWwhjQr/52cN+0PuhOCZlCeioH?=
 =?us-ascii?Q?bz/XHmequq7i/0RH4YK35NcyU9r9Al/fkwG4Aew94W/HraTN0ffS30fMMSXt?=
 =?us-ascii?Q?qrfqHJsQnsqqnbUhoFZ6YE40ozpP1JzENv/46IBoUjn4gKHudk9lcrMgLey8?=
 =?us-ascii?Q?nNA50NIFqquhiwTvz3Y6FDKBPPoMCCY9pDc6qxCNFwUgaJdEQzlFgVTKYZ4r?=
 =?us-ascii?Q?OpfClWi+U273iwm2QBE99LtWqybdELVdheOjqYRg8GpENbUHeGJ6lEAoqYKN?=
 =?us-ascii?Q?ZsoysJekCnZRRWHs2ExYiPC3zBX2ZIVu3VQSjKUf4SvjWgLaWq2SPQDm4/Co?=
 =?us-ascii?Q?kfI0Hipkpc51/mTrZKfJjq1aOX6mTUZjLOrGG5BpWsG39agKzfo4k2WcmGMf?=
 =?us-ascii?Q?q3cBLJPeZN9RiT5ezHQoT7Nc9FnPE+Y8W8CMFXlOAT7c8fHEOtE4RF4en2Xp?=
 =?us-ascii?Q?HhtwZkUx+tthRFTUXBzmXQjpRUqEvJVUB06BIQv06P4IOodDeBVHPfsA5pbo?=
 =?us-ascii?Q?nJrUiCjyw8UGdxuaF6KZQzi5SytCjy6Hc6Q5H3snlIWBWvBcmXdI3WdfDM7h?=
 =?us-ascii?Q?DfFBAD7vZ3DgQ8GmrrCOUUuxLYh7qzoAuues8BzR4Otd1GuVPTcZKMVzLasr?=
 =?us-ascii?Q?t0SY5owYCQ6pXDuatx46ZKybYdbbK+2lzs3g/xAigj+ZPCHIvv8RIaulKzdX?=
 =?us-ascii?Q?+0jTdz5edt8gxj/o7cflyRdLhVHe0cSAzfm0nz4pwOGheSr1NN9LUq22rqFy?=
 =?us-ascii?Q?2f+NxTHlA92KEMNuaQYD7InAVgGO8HC7V3dBIpEUMfPs5lFEqvrw22S1YXRA?=
 =?us-ascii?Q?1gew0egucO5gmix5J2LQfNxgFACv8B72NfGhLh3MMR/Q8kFQC2dg5Y/4Nil/?=
 =?us-ascii?Q?JguGh4wzr8bwlJiTOcmUAhktzIY/8uXn/PKsOxI6WzhLZ3VblQPr5KA/MWaD?=
 =?us-ascii?Q?V0atAfgcoOw4srERKhBgRh+7c/GhUiNIWwB1j0Dwzw71/3WAKDBwwgWX9nJP?=
 =?us-ascii?Q?2shwjJrpZ0uTndUA/WADv/gHY+dfdx4mb67LIx/Xe1g/jqMDyGWB1RF1oYve?=
 =?us-ascii?Q?+4JdMytTsmovAW/ihTQ/GAfct0G50ZhH9MyZ27d5J7NEvdIf8OgPAWUeyJ4u?=
 =?us-ascii?Q?GvRSR2MAGpv9G/HW2C90JV0Oz7JVL6w84xZWDU6+HjCgwB3h5QRg9fZdJ0N0?=
 =?us-ascii?Q?HSf32DJMCt+zMeO4T2jwFyZs9nIso//+ZtquWt3PP8To+7rFRehhpQ+b05AN?=
 =?us-ascii?Q?auX6eoJ2I9miFggWOT9BmwSD5RcVeVxhMcScFHZXnvHsagsKD+qTiZRnOjch?=
 =?us-ascii?Q?n2SDoN1svyLE+8yPKzy1x92pZPFP17zLilQwNttrkz7zks51ay+0XlVziAZ4?=
 =?us-ascii?Q?9XcoUuDsZHiCAHYualpHVBw2vIcdo3/Vv7jaah5c/CdhjJtXLw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VTV6IS74YdgzFZftFz6cVcfbDGmbGi18GjcIuwsuYlCgY3xcSBPqhK39v3Ot?=
 =?us-ascii?Q?0aukV0Ndlx5lxRybasCFQFMQTpH3smABxVTRuk1aaWpAlm9F00kBNtz3iyRf?=
 =?us-ascii?Q?p6tDoVphcCAvD5qPyHEm276vE92kkAU6FurlOSY//vAqLmAcKaYAxHFuyzqL?=
 =?us-ascii?Q?Nuw/sZSucAkfzqyAEzpSxzho78co9qfv+wSUGDn/zNvybDlzqqrvqOuIqHdD?=
 =?us-ascii?Q?YzkzgSO0Q/AWAUXjhvs3mV6kfPfNDDmGmG9WR90zRfN6TJV/NPAjil0rSlrM?=
 =?us-ascii?Q?CWZEPOAKh+4Nu5oQT3Na1Az0TellKnj+cDAjuMmU5+LJ+BotP+9XPxNWgFWc?=
 =?us-ascii?Q?er0SU0wCRxf1Zte3jvZgpucfCExmdtZtK5D8qV6LwssbWAgpGuWCW6ZW6mRb?=
 =?us-ascii?Q?Qq0e/woyq6sc5y79ZNdX/EQAWMGb/R6ArW0jxM+KUrPJnMIqP8vQXE5aJ3h4?=
 =?us-ascii?Q?ezYr+jT4qzlj+qsOglRgEMehONQmECKuR719Vrh9fY/3w82lhRUhXnHtqqTL?=
 =?us-ascii?Q?CNjM8n+jU3vTsubAPkWT8ldmITreGV+AdqawXn2V+EOoOCuju/AG16nL3PAI?=
 =?us-ascii?Q?z1TKSl4eCH+puxIvJCCd+eghatRLGa0NMJcoKDOusYUVHkjGR+75oXoYogUN?=
 =?us-ascii?Q?LG1EwQctfCex+MTaLK+u9QrtAvrYgRbBprfOAY8Sh9Qr+gJqt8dRRNM1ua+J?=
 =?us-ascii?Q?zIkb5crD6zUD4rOLqGdpbc0K15gKRWhZqAdt6R97EFL4tJSHrZst6l4+agEp?=
 =?us-ascii?Q?y72tzunYwZdbjmSzdl8pHxcdHwIykzL6gZ0KLGq0/bjh3gUIRRj14Vz1en54?=
 =?us-ascii?Q?14hUMpt/3/TDulsU5qCWyKolaw0+pVNXAlomlwVrwAp/vUm1sHlHgTI3YznY?=
 =?us-ascii?Q?K337CHhnRUOy1QY8Tal22yqoOeS/jbIKNR1nEwGWDNtKHSE4P/tWlF58l4eN?=
 =?us-ascii?Q?Xz3avzRY8+uUAyFUW1y4Q+MamPrAhU2XTjto78j1YaKPyE2xTff0AhEWkT/u?=
 =?us-ascii?Q?O9tY2bW+BSkY+yPqxAXHGdFF9IOrm9lWTnD7ABjB1TJv7Dmkubc8+ICn8cyx?=
 =?us-ascii?Q?kiqh1ErJHyUDSNqoIsxFt5v6u0LT1nXwDgagzR6n1MEWDaEQ3Y80blKtRc3e?=
 =?us-ascii?Q?KuIuyXHH4IjgTLtoGfl0+9SF0gCpLhW9yeCnbe3tk5UbuePFBOz9PhIO5wsW?=
 =?us-ascii?Q?sHV4Zps0qkk6IC4L8SuMz8GZ1G2B4LN18T4VK1I3tczSHl345mvbB/kNQpdw?=
 =?us-ascii?Q?ijNB8RqWo1A8Eao/GxGS0LyjvnzOA71GhNMwI3l9NcmftN/QaEJ3rpthsCg4?=
 =?us-ascii?Q?59+fG3Xgrz4myYhO8QLtKVGt9/hISPXMDO7RshttdPk0D1DYT2jQe8XWC9Mn?=
 =?us-ascii?Q?5BzR2rpZvDOfmPpBunx8mblgrX4b0HLzxqYoJN+93AG850DNXG0Y5mvPkV/p?=
 =?us-ascii?Q?2wCCSzO9zSfbqsVR2oXxG1ra/ZgN1AzWjn10VR11tmq0Fa/GNI+GrbxSJzi9?=
 =?us-ascii?Q?x14wGaWoGsz06kASaZv6p4ANI0oAHdyT5jzR56Ms03xthJY+VHcr730MogtJ?=
 =?us-ascii?Q?8crLKE5LP7XIv7w3N0XaJnxsnn+dwKKpgJd2gH5J?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0ea0cc-3678-4693-baac-08dc9a2c4c30
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 00:17:02.7009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H5EaNMw8eyAUykQX2i6fU82G2LmUMXWRZtFHb/B2q6lT6m1scjwkxxp1ObR6Bg9rW2yh7KfNV8QiPuC2NAaRBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8108
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Monday, July 1, 2024 8:02 PM
>=20
> On Mon, Jul 01, 2024 at 06:30:05PM +0800, Yi Liu wrote:
> > On 2024/7/1 16:43, Tian, Kevin wrote:
> > >
> > > what about extending vfio_df_open() to unify the get/put_kvm()
> > > and open_count trick in one place?
> > >
> > > int vfio_df_open(struct vfio_device_file *df, struct kvm *kvm,
> > > 	spinlock_t *kvm_ref_lock)
> > > {
> >
> > this should work. But need a comment to note why need pass in both kvm
> > and kvm_ref_lock given df has both of them. :)
> So why to pass them?

hmm actually passing them is wrong especially for the group path.
We have to get kvm upon the first reference to the pointer otherwise
it is prone to use-after-free issue.

>=20
> What about making vfio_device_group_get_kvm_safe() or
> vfio_df_get_kvm_safe()
> not static and calling one of them in vfio_df_open() according to the df-
> >group
> ?
>=20

yeah, this sounds better.


