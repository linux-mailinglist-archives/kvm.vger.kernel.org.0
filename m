Return-Path: <kvm+bounces-35950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEA53A1675B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 08:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA8C11662D5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 07:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650DD18FDD0;
	Mon, 20 Jan 2025 07:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JC5aR3Z0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0A818FC83;
	Mon, 20 Jan 2025 07:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737358192; cv=fail; b=rxs8c8de8h0tjO8xh70OMz4AYPHN5+OIcoO68kbYvotNsfBxe0i/VauPXT+nZrwaloyrYu/vJkvVvBSwHEhw4VA4KZJ21IFXq/Qgy+mEBv4XU6F0NtJdR4x2FOpBQPfGQtET1IP1P1gHDfV/HrS+j4s51VwzveMX1tAkRng9f7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737358192; c=relaxed/simple;
	bh=B68myvyj2JQ/OJQQ0oDVrmkjsE1bqpnmn2Rvnx6FZUQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cubkjwz//ZhNMCyXzbFjaazFsM1vBMfz/RfSpLTdtOCfwJJ+b//KGLsYAc5rjPAbQjU9Q7q2yxfLsLcb2YE6ZShx/0V7dsHPmocU06ZT5HNtiBbMUWRp3E4PIQj6TMrSyCdIA14wJQwZB79tUTTprzHcVWWAPRDjVfpde6QQKpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JC5aR3Z0; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737358190; x=1768894190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B68myvyj2JQ/OJQQ0oDVrmkjsE1bqpnmn2Rvnx6FZUQ=;
  b=JC5aR3Z0agFEobJSO+mS/WaJMiJnYLgrXuUcVJV4fVbh4cvmDpNnriaA
   4oEzyQ0pntm38d4+op/eDMG4JETwjs7FHTnLmGhJ0k9Z9H2rQ625gfFrw
   jZYFNxTS2TCcQsZ3c9LsMeNEf4Cx8JUsbJZ36rdzKd082j57rPoIUVx3h
   oMsvSVBImGNBE7vjuZuh8SfHc4TFd4g1RrsLnrgPcStm/LTjzqo6hKkV3
   4nh7sngxmyrA7USUs3sPf+nGI8uGs1BBioXuqkrb1+BHWOhMtytBWxkN6
   pvWWc+S7+vAGUo7P5e0kE6ksCBzG9A1CKEvJ4p1Nl1tgDsifb27XIyEvX
   A==;
X-CSE-ConnectionGUID: BnTKGCAPQ2GFFv9PiVESGQ==
X-CSE-MsgGUID: hu8lgL+STtaZuNCCr+fzbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11320"; a="48389177"
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="48389177"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2025 23:29:49 -0800
X-CSE-ConnectionGUID: qb1l6TjARdSQK0p+sdwMJg==
X-CSE-MsgGUID: czTVLOZnQ1uimGxLOeGkwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,218,1732608000"; 
   d="scan'208";a="107007215"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2025 23:29:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 19 Jan 2025 23:29:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 19 Jan 2025 23:29:48 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 19 Jan 2025 23:29:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4dTrTcJxu4SBKcaK2aJgI2bkwGBPFPLztKMUL3yFmb/nwgppgGUL/WJDg6m0f4vv5wDupiJFRQ107m8D5XSt+8bQRyP8Wt6nsygNkEO4BfclEOFVGc781hJQ0H5M0zaTiugQ6cLpuaNQfH6dW8gAQFmFDr1kc7UwacwKd7bQ1s6M5p9NmuHdi1yyDUfDmp+MsbQYep1fHmHGZO9q86LDYabNGqnLWNW2RUwxvR243XcYuHPwHyeq8oBXn1JKFydsU8kLR2CWEu7Vyy7wG2fhKZhJLcRWyPmtLoq6biWohE6y5YZcIkEgfu/rmhWOLsgViXE9+be354Z48iOf6j0ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3WNYVffjBCHPqGYstKExlLaCIHLFPRh43es5/8Aeuc=;
 b=TzLEPwK9B1U1dfrRrmC2RtkNy8p9E+cz7qXdAyThgfIRmgJA94frE8as9R3/00vepHcbZNaFCkIWZeARBWkIf/2FJAVWibnDbJFqeCNIiv4o4f7UzdWIzZSBngAOcOoBKd8H9r7HFqG7GDE8zyWH0J6B6GF40TEyVgOWuB/5K1GmTM70z9v/z4E+bCkvGunhvL1Eb5YD09rAHFaZbY5h/Ugwk+9rmIgf4+wMwQFssGKmmUWmgCdVIxDIl7sQKJ/t19PBdZCMG21lhGqh72fttQmXkVKzV8Rf7Vp3aRfEkp+/V17NYZaDmkiPcwgX+qS9Vb/obvm7CaUcmTLNpWaOEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CYXPR11MB8664.namprd11.prod.outlook.com (2603:10b6:930:e6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Mon, 20 Jan
 2025 07:29:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%7]) with mapi id 15.20.8356.020; Mon, 20 Jan 2025
 07:29:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "zhiw@nvidia.com" <zhiw@nvidia.com>
CC: "aniketa@nvidia.com" <aniketa@nvidia.com>, "cjia@nvidia.com"
	<cjia@nvidia.com>, "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
	"targupta@nvidia.com" <targupta@nvidia.com>, "Sethi, Vikram"
	<vsethi@nvidia.com>, "Currid, Andy" <acurrid@nvidia.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "danw@nvidia.com" <danw@nvidia.com>,
	"anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>, "mochs@nvidia.com"
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Topic: [PATCH v4 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Index: AQHbaTjKAev7boxR4k+sUF5EINbSybMfRXwQ
Date: Mon, 20 Jan 2025 07:29:45 +0000
Message-ID: <BN9PR11MB5276398787A61A1EE8AF92E48CE72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
 <20250117233704.3374-3-ankita@nvidia.com>
In-Reply-To: <20250117233704.3374-3-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CYXPR11MB8664:EE_
x-ms-office365-filtering-correlation-id: d2c8b387-0ae1-4371-0b40-08dd39243687
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|7053199007;
x-microsoft-antispam-message-info: =?us-ascii?Q?fgTcKPEHLmJCMBYRyPzA3dKIN7YYDfNrhME9Jfm3lC8VZ3ape+ZxjlTu7d1K?=
 =?us-ascii?Q?zz5GGUSTZ1NsH5Kh1NqKvAF8vqX2Yrl+yguO/MlcAo6OFx4DzcEW67n8x0pb?=
 =?us-ascii?Q?K3/su1oN7U4HiI39foLtDTcJt6CZbM8JVMTJh20CIYvwiRKol1YD4+dXgPoP?=
 =?us-ascii?Q?dzqdqdmdUH1PulIlUaIaI2DYtNasJbDz3aOMQdh6tqg+oO58XfvoEWwgR1Qq?=
 =?us-ascii?Q?1klk2xABbXHedoQUfbQKk0qR5vtYPb/oltgAbIsCiw3nNZpSqUGoIeludMKa?=
 =?us-ascii?Q?oadA/WU12eBbw4untzCPTMnfTLonBVlpSmCRNvMglIZGkqtUu5n1gIcc5Xmn?=
 =?us-ascii?Q?AMLZUxMoKgE9zweMxXjcYqeKnF8X7orQK7/EpuSNGcsIpDYtun66Ap6AV0JH?=
 =?us-ascii?Q?6aul2WT6clBiBKdLgz4cvxcqyfl8A+T+pocYy52E0+VD4nzcZX9HvIAmlgoz?=
 =?us-ascii?Q?92gg8jV7pnJWLKsXkIta8DDKCeULFCXVSlKU/IO+BJBZykq/BuqyWPF0soIC?=
 =?us-ascii?Q?Zf4qu3BXmwaRgV9ghrwEEgVfLAPnMvFeX71/dpFdV3LnCdQ2FrszeX1dzllm?=
 =?us-ascii?Q?SOqx8ei7LO6pWNQcpTo9qQSzVhm2INdo2gNJeIdehEZZ4603Z12GDsn4AInZ?=
 =?us-ascii?Q?892lGmWGw5JokFCZEaHMvuKgHFFld+xXuv3kZmXlAoI/GkI7fQyLJ6R4cLfx?=
 =?us-ascii?Q?ehOzGgPQUR/XSfilzN9LkpmU5IO66yKWwWVGdmTIVmMvL1/HyZ9CnfXlyMpl?=
 =?us-ascii?Q?VMih7EWJo4QIPFPRsGGnpOK3tTbrUSbJOpYTWVM0Xbv5rLeaGjL9L9zu0wQH?=
 =?us-ascii?Q?QUU9HAs55XfMzxwZNKqDji/0t9a99xNSvMgcBKXIS4mYZP3cLx4ffdklyNag?=
 =?us-ascii?Q?aBte7GejtMW4YKZBBPEwMWDG+fvBOVS373HpVWNGvjJIm/ZV1ZGCuWwZqqDV?=
 =?us-ascii?Q?UeAZo1gcr1fDj73XoFaD5R5SdcQuTXrWB1ufCtjY169/BEufH7aqCGCt533b?=
 =?us-ascii?Q?d32CdKw/vJcdGz8gvuH/rtewtycaszbhg9DHXKCLrHNohd7sKMRIGN0Ms5wI?=
 =?us-ascii?Q?UdZG9Dt5QgifdJAPsGP14Eidsg0IMONkTJLobRZFOReS64+jyhLps71zOsNs?=
 =?us-ascii?Q?DHpZ0Qb8JQqZjOssGgVRpX1sjWS2mhONrk4oQi8lKgIjjie9EBhF10H3clVB?=
 =?us-ascii?Q?wgpvH2qC8BeW94fvgQAcZRNNpEJQuKiwaTiyxqzjJMP68aUOBRPVN5JorBLk?=
 =?us-ascii?Q?XpYiCo0DIYt8hUs+MvB0zFRASEp8HarBfVz8QgBHm6HVv0gGuiZGhOV3bad2?=
 =?us-ascii?Q?GrO+g8AKcaYTzLxRvKSK5IN4bCTsbiE/AHvJ7FOqcbYFoauzm6hhMyfzux/R?=
 =?us-ascii?Q?rsgM5R/43+1azvphGQu42jZ2AOd9akPoLjlf+LHsH6dkiXtuAWWqIRggPnaS?=
 =?us-ascii?Q?ceitoAJ01JSvnH7VxCtI0IWoFd4DWoQN?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CSfCdX4B0L3BphvvqS76VmmIkmrLYsw18HIG/jRsIMaF4KkJeS2zaAnTUO8v?=
 =?us-ascii?Q?bCTfeaYWGY+XQSmSE6STpOmKnbtrJ82X9uV+ZBTvjxG3YdEvgaiHNyTUggLc?=
 =?us-ascii?Q?PnOKQvc+IYqQHzCLEla7txrbfyeLf1VM/rweGRTKH8du7ORGyPzjWrTdnpkG?=
 =?us-ascii?Q?2furJz0mcAY8xCrfi4QxoYCYWrZFt2+t6wnISsZlSaK0ngsIOJ1z7Rt+MFRW?=
 =?us-ascii?Q?6d2/6ezQNYf5VTzF4UrGLWAumVd5IB7s7lRBWMmZPRsAx2EshBFhLibpt+DG?=
 =?us-ascii?Q?6Khyk3RNri5pkSpkY6BPULP8W+R1BdBDt4PabRML7M5VHDlqXGMQhTnAPzuO?=
 =?us-ascii?Q?7b4VW7BV6HYdzk5QvWRP14h5nn9HK2oZJ5U+CduN1x5MA6iFXZmydTQmDdi8?=
 =?us-ascii?Q?tOUd/58bnuz7Cp2Xvx0h8NqLz321z9jNuM0fOysPyc//YkfTr5c8BvAJGvuu?=
 =?us-ascii?Q?gGbME9mxAgv/25IHw/TFlBkHOprXAWp1D6VYxc7jnduRrjwsi0HZ+Jek19uQ?=
 =?us-ascii?Q?DeQ6SWqToBjqZAgZ1CudIl+5E+2Pwx9m/2Vj3+7c+XFOp9lyVb0HWswffwdI?=
 =?us-ascii?Q?IIwmVBHMR34B2CGRfGNvNvcBnKelhPCWfuP/p5Yl1zlA+KrH0fscoqAEJc5a?=
 =?us-ascii?Q?M++tl5qwYFv9ndnIZaB+rFv40+DBYJevY1Q/HYK8SdyF2osS0zY2xp3GK3Vf?=
 =?us-ascii?Q?OVJVPFNY68pD++XNii/c+FG+JtVtfOTP4pMUbirn1dvVEWVg3CZ8vgbbVpT7?=
 =?us-ascii?Q?W0Eo+yOT+t4ApE33uxOxwjNvDaahJO0Iy8GEFY2kpkdrTAEX9CGVwbpQ91Kw?=
 =?us-ascii?Q?XFZzPCilStI8JuH208yHsteOmqIrEiFDDeP29ni/tuDdu1vdXQIGnVPRyXUE?=
 =?us-ascii?Q?TO4uhXg9nBpcKcRpxnBvZU74nH/YkwfnQhEcrWnbPV+yiuX0lMtiyg68sGnH?=
 =?us-ascii?Q?OrlvoTobhfYGTlCDECfFCta8QsFCJUtuVqB2rBr30kJRuxS6M1olaT6qJGgy?=
 =?us-ascii?Q?4YUA8ghVAVVL+J9OLB1xnloaqcDUa2SEpXnH+3lR3MalfEHA+7fSCGj01DDv?=
 =?us-ascii?Q?HBCZXd8h0DDbrBQIfvDNImFMnbnt1liTZ1H/qjoX441YWv5YTumwVor6317a?=
 =?us-ascii?Q?dPjDO5G6XFWvl4OMDTMydGsXOspoAcGQPXWmjneT1NKTqkkKEN268IdiB+QU?=
 =?us-ascii?Q?6o1Ar0WoawvKOLNJZGIQULUQYVkW9oMxlR/CTA5VuD66ym3dlGI5moM51iN6?=
 =?us-ascii?Q?onC4gmN3fpWCcUdc2CMNrKL2eml+oJgv83fqejmSnb+F0pwuzTrnpNRXiMn+?=
 =?us-ascii?Q?GaguW9kimFFem8bxwrxBt65x1xcbyuzqtXBW1AgXQ3d2UgA1ms5tlsfg8Q8j?=
 =?us-ascii?Q?LCqaq7tJYLlkL3DAh3VoMQEBIeU91YwMWuzw0+SVxD3rqkSbb7C7POSQkpUP?=
 =?us-ascii?Q?gM+txSTLiFLEHnB6wY2woSWxphFojKmAMYWmkx87+egOI8Ap3yTi6xmbmUtx?=
 =?us-ascii?Q?JkhWWyosYDGLdHraoDvjMRGCWkFqzEWEmW4eJW4FreB7uReli1y6pjCrkvXt?=
 =?us-ascii?Q?7KfneZ7cqpoM+C8ylWY5cV3pjw3fVoqdFLr+6c9H?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c8b387-0ae1-4371-0b40-08dd39243687
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2025 07:29:45.2453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NiSPKoAFxEaXQEagQWVMB1pBN8agIEr52Jh4i97byZxA5RHRt0D/Hedjt+25VbRvjxt+fgX+nBqVfHB33TNq7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8664
X-OriginatorOrg: intel.com

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Saturday, January 18, 2025 7:37 AM
> @@ -780,23 +787,31 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev
> *pdev,
>  	 * memory (usemem) is added to the kernel for usage by the VM
>  	 * workloads. Make the usable memory size memblock aligned.
>  	 */
> -	if (check_sub_overflow(memlength, RESMEM_SIZE,
> +	if (check_sub_overflow(memlength, resmem_size,
>  			       &nvdev->usemem.memlength)) {
>  		ret =3D -EOVERFLOW;
>  		goto done;
>  	}
>=20
> -	/*
> -	 * The USEMEM part of the device memory has to be MEMBLK_SIZE
> -	 * aligned. This is a hardwired ABI value between the GPU FW and
> -	 * VFIO driver. The VM device driver is also aware of it and make
> -	 * use of the value for its calculation to determine USEMEM size.
> -	 */
> -	nvdev->usemem.memlength =3D round_down(nvdev-
> >usemem.memlength,
> -					     MEMBLK_SIZE);
> -	if (nvdev->usemem.memlength =3D=3D 0) {
> -		ret =3D -EINVAL;
> -		goto done;
> +	if (!nvdev->has_mig_hw_bug_fix) {
> +		/*
> +		 * If the device memory is split to workaround the MIG bug,
> +		 * the USEMEM part of the device memory has to be
> MEMBLK_SIZE
> +		 * aligned. This is a hardwired ABI value between the GPU FW
> and
> +		 * VFIO driver. The VM device driver is also aware of it and
> make
> +		 * use of the value for its calculation to determine USEMEM
> size.
> +		 * Note that the device memory may not be 512M aligned.
> +		 *
> +		 * If the hardware has the fix for MIG, there is no
> requirement
> +		 * for splitting the device memory to create RESMEM. The
> entire
> +		 * device memory is usable and will be USEMEM.

Just double confirm. With the fix it's not required to have the usemem
512M aligned, or does hardware guarantee that usemem is always=20
512M aligned?

And it's clearer to return early when the fix is there so the majority of
the existing code can be left intact instead of causing unnecessary
indent here.

