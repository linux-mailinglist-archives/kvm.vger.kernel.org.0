Return-Path: <kvm+bounces-8999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 788DC859B18
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 04:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 059701F220BC
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 03:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87024A3B;
	Mon, 19 Feb 2024 03:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ma6SllY4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BB24405;
	Mon, 19 Feb 2024 03:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708314070; cv=fail; b=qjaaEPs4DhZLaPjNTa82XgLTCaE589dVL4rzHpb6W00BzMQ3fR9y/6wS4ot5QoKEwF+DauY1trjj83y7SQYdfG4zQH+r6IEXW/ukwrlUJoxn+I4DtzPvAuKLIgsuSEj3CLHo/6pYhqkTE4RZrg/f6sazHZDVn5E2+EcHrqDRJ8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708314070; c=relaxed/simple;
	bh=Sb2eZ+5DLqGYV7jIqfDgdDZKPs4ujOzzhHSqnfi5fEw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u5pdtpGs6TrvIQ7TxokLfWGFbppF/0PL14scoxpasTeWt1eZhrMAfWIx4CMYjehZ9d+z0MFRQejtcITKBjCoNJKprm1Rr00RpS4EVwXIF82ep5LWTKxoNweOKrI1zvw3ZPm4BQKkMH1R4tV0L4/hCu+XSQ/cPtgcRCGgUl5uM9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ma6SllY4; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708314068; x=1739850068;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sb2eZ+5DLqGYV7jIqfDgdDZKPs4ujOzzhHSqnfi5fEw=;
  b=ma6SllY4SQxRmfWSC6UEvyD46Kpuxn430JUCG+40s5vOH9aCuusMcZ2y
   yoOIddVsZzD2qbAFo8n4AumB3szpVeknoaUri4MwLST2ABL57TZNnbi6d
   4mybIQJG3gTxB1TC9PbSXcm4dDwkXnidds1DjSqkwx0lLyx/NJsskMw8X
   SwHiFhSjFCQWHNGxrGiRP+RUjyVzqoJbFm5/v3cA8mVIpylhNIPy6lJnt
   BQrzWLKr6B3ww0UbLvwRizs0q5dLLYb6Nr4aSV9vE0AVEVkxtfU4ukewW
   R93zZUkthdPAeQMV2WVYfME9ZLWwqP1tnCscEsNzlaO6YU67jpYvWeYbL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="19806126"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="19806126"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 19:41:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="4333353"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Feb 2024 19:41:07 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 18 Feb 2024 19:41:06 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 18 Feb 2024 19:41:06 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 18 Feb 2024 19:41:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+G6a1CCMjsA0U2g7C7UblRazoGNVN/+OoA1r/EJ56PY1O6c4yqYcYfZPMYyN8wDgOZiDH9PQep1o1sOjMDTtrD2PsfSf9f/OrENOZ7aEsXTsUQ/tuEnvKvXRydIB01BOgBiRfJrCagNH8RmXAW6Ec59/Y0NhaBwTf5n9/hhG7hFzIc7kKqlMzJzgtwMXYpq9XM9HRm4s2nVTyygsMPpTxuKm6YrspbHBpgriFCKpxECG3ned9tKbENKLjDHXzt3p7eTCyNIx3dPp8Pi0QHYU6W/s9ZdzIdzA1SQiMPDkwfD16vLk9rgNOzEjx39ob0AqSkKucJyFtCC9GKKSLeefg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UbNIxFweh6/J4f9tqQDfikZVoCGqtXGArn4U9f+qyJ4=;
 b=UvvsGvmz4rEcSzLKlof3Zhu/vxIsmwFdfGr4RjmAWpA/Gg8BmIYN88YCFlvpdKiFbcu/sJJRi6SoHRrKg09IvpNOvX078KVVeQT0uPUYrmmXVb1BaGk1TKZNgd9TtU4cFKl5FOcoHZkw1vIhU11XDoYgdJvAca/sQY2ijVrVsv00MjouifWdB7DY7SvXCHf74W+dIxiwbNXTEpyU/NTq/snK3hENHihbBo9jhRnEKTk1YKkhIjg8zM2XnrtYec2UqJ4OrI8kEBAWHM4pS4Yh0rOfaVk6jEyJagbFWTASXo+S92CeZmq+q0usTNZHoqL5nRKwtIYCkxh2iwX5u0G5vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5687.namprd11.prod.outlook.com (2603:10b6:8:22::7) by
 MW4PR11MB6983.namprd11.prod.outlook.com (2603:10b6:303:226::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.37; Mon, 19 Feb
 2024 03:41:04 +0000
Received: from DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::7776:7cd5:2c6a:1e9d]) by DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::7776:7cd5:2c6a:1e9d%3]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 03:41:04 +0000
From: "Wan, Siming" <siming.wan@intel.com>
To: Kamlesh Gurudasani <kamlesh@ti.com>, "Zeng, Xin" <xin.zeng@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Zeng, Xin" <xin.zeng@intel.com>
Subject: RE: [EXTERNAL] [PATCH 07/10] crypto: qat - add bank save and restore
 flows
Thread-Topic: [EXTERNAL] [PATCH 07/10] crypto: qat - add bank save and restore
 flows
Thread-Index: AQHaVSVB/m38AurFzkKxVGnzjrvP0LD50xgAgBdMZaA=
Date: Mon, 19 Feb 2024 03:41:04 +0000
Message-ID: <DM8PR11MB56875F986E6BC02D408CB4708E512@DM8PR11MB5687.namprd11.prod.outlook.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-8-xin.zeng@intel.com>
 <87o7cwzn1t.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
In-Reply-To: <87o7cwzn1t.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5687:EE_|MW4PR11MB6983:EE_
x-ms-office365-filtering-correlation-id: 68c42700-edec-43d4-a333-08dc30fc9982
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dqhhW8GsSviHn4+icbtS0QNDC5TZA1oT73+/Rsg/9eyMSdOwdh1aZaCVdWxaHZhFfxsOrQTFgL6BOJodnBi9foztFshd1ALkO8nLli9MHY8mt1Y3qsPDMvXF1DwGZ6MHYW8+tW9Z/E2JQFLbUiz/+p7NWCoTyLRmPSEnxFdbKFU6n73J6MUkBhRPXbj2j1Ds+v/0tp/YnfKEeQKcN03VTqYxzexjvIg0GAQ5YJwtuG3bMDnlidfoXIjVbPwqpgMYoZNX7DlEfi8wxAiDB13A4FpBiqNhtG0fDH4b+aVqSaUU2neCXlymSGrGpnXKJ7MG4J9OHgUogiJln3fRq/O7sIKHlKljDfPC0tIkCgelf+AzFoRfDmG4C8weX97P5YWXlasIre2Ap4ZawY53zW0mMIpRvLEDwDpvLkpkmUR//mJpBGqHCG0AZB27Z0RLiQAuCvYr/oHVT66idan9GuS6Dw5PeVFZ/stv5pC0XR8IC8tqGhkKz6D7hXb/CWjkBPPhPMGHo0KVkUKMPVg11A9q8PGyF4VQRYlxMh49HwLeDzdbBxIGdr5+XC5OtMIlTYqnOXd5zyOgvdB+VqJ8uTujcu0fqe5QSdt0HiBbxloIhy0+q5hKYPmOg2pkB2jOQb+EOh0qum7hCmwrJyjf1menzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5687.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(39860400002)(396003)(376002)(230273577357003)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(6636002)(110136005)(316002)(54906003)(41300700001)(55016003)(15650500001)(2906002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(5660300002)(4326008)(8676002)(8936002)(83380400001)(86362001)(52536014)(71200400001)(921011)(478600001)(26005)(9686003)(38070700009)(53546011)(6506007)(7696005)(38100700002)(107886003)(33656002)(82960400001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2H+p/KCSA5or/q3emjRq20LU+NYQDDDk6WBEiZB4e3dfC14ODdmW8wPMFyja?=
 =?us-ascii?Q?B2rsYrf9z92+A87iQM5Dg4uaiFff9xZwpr33Neav/hZWXvaDgANdMNTcxvSz?=
 =?us-ascii?Q?P4hAJEz0Nnp25cvB1qDYAUIsKq1vTZeWk1HNKumzEwY6FA0YFHwUjIFdGicw?=
 =?us-ascii?Q?v/0qUS6/stRSnd0osh4nltfifPmz2lUsNJ5HWvPp5LBY5cPI1JEWJjdchqC5?=
 =?us-ascii?Q?1XRDo4xq62hTAdsApXPuns6yaq35MLw0eWaOcF19NxmnQgus+9/F0UMNmS0F?=
 =?us-ascii?Q?tk85Uya/h3KqnB40i7ZgcNTPmBsXVEkh2Tq3uIoewNSZwWX2TQOATgsPg5/C?=
 =?us-ascii?Q?i5Hgkh4hZiUt6gMyTBWQfpc5WzQAwjsmf1EQVSjtX0EgIzimwF/ltHWx4a3G?=
 =?us-ascii?Q?I9k4LtOM/TzJ1T4cD8q7GpPqBDLv3PvYeTXbGR5k5KuN5/lSnCfiIDXsNhEd?=
 =?us-ascii?Q?rTgRadIqME5hrz+osrtk4dkwaUH2FyYN1cOK52PJgFzOUJCbYj3TzlAi2+Vd?=
 =?us-ascii?Q?7wCG/lF7tr4NM79FmXyeOJsA00zj2BM+HKQTwP4xIER5D5HCMMR7tteDU8Mj?=
 =?us-ascii?Q?EXhvRXEGVgUpwEG1zEuOAIpygZHeqpFw1QffSa6QBlbxbB2wK4O7lE+0fNTY?=
 =?us-ascii?Q?V76LanP3e+K7ay/P8KF4Dwym4jb8qNkEBqfd1tFARNqQS9IWKwkJs1sMYG3+?=
 =?us-ascii?Q?PJ5UeafHur052ZX+LPjPxMjIGwgpaq+7mGy4T3E2nFFQ5QR+aDk+ojUZBUHQ?=
 =?us-ascii?Q?jLjtWef0DjxmW8HKxvinvaQsFJm4x+SQxTwNKcdrVeVIxfRmTFn4TNbOcSuY?=
 =?us-ascii?Q?RfitBr8RcTfmfthqKJdk7AeJbsEFdor0BFz3rDdip1GcCtSGyS7kGate5PLe?=
 =?us-ascii?Q?8sirut8K3o4eMJRd0mvuH/yKX7dpoJavXHBuWobYwSj0+Bwzz56ID9FsT/2w?=
 =?us-ascii?Q?awej4r8uckPwNqqeHPxqsz1wD7QDw/nZfbD6b2MGBnEm9q6awFW6e8wqTWks?=
 =?us-ascii?Q?mhDaYuQqdm48YfpBT7oifEequdKngCp0m7jKucFEqXBT4W2//jj73Wn3UF4a?=
 =?us-ascii?Q?Q4enE7+82m3+NgYfcUO85pwtDivfbTyVxrqDVo78tnfiu9Qo6kZ0RNtOnj+R?=
 =?us-ascii?Q?kB0mun1/UOF32exEfCLchsOz7xbVfF2tacMDtoc85lpvCz8eh2RMrOwQe4/b?=
 =?us-ascii?Q?p6eWPVBiei57NgI4j4p0Pb1GtsIkNDfjYz+UMrzPQYiJbSOQa9chO+71Iybu?=
 =?us-ascii?Q?84LyBzrvi4KVoWbs+QpFso7dQJl+Q3b0DBxvSPgwDatZTXIk+nea1uXlD1B2?=
 =?us-ascii?Q?Fd/R5qvQiao5+t2tfvB2uFBlIA0msWfqOPAqB6N/LsR9958y4dBLyiwrd6Tv?=
 =?us-ascii?Q?q/1yMCpnPf9Ve1ovY8hEkWfwKA+ptfTCrE5JNP3+xPf+JRGD7zYv/tVmG2oZ?=
 =?us-ascii?Q?/MhCQDqVL7+CSQiBJ0C2eWSBtUcTgYWZjWJEpIOmOQB7JdJZL1zM2P2G4v+F?=
 =?us-ascii?Q?6Xvi1RMzw1OZ9/sa7Bu1H8TKtp5+r4Dc5b6Jbqn5flPMDXQi+e75LdwVrL7h?=
 =?us-ascii?Q?NJTCmiVDZbrMQW5TRGY9wGfg9K/5qcFUF3uJ5D07?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5687.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c42700-edec-43d4-a333-08dc30fc9982
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2024 03:41:04.4802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ILrHAIOqiL7jHnmCg1YZvokdlgZ00up5pZxzrbLyIwAnsfx0/79OT/qBg9S80wxA/dAAc/D9PgvtdsKrjCEJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6983
X-OriginatorOrg: intel.com

From: Kamlesh Gurudasani <kamlesh@ti.com>=20
Sent: Sunday, February 4, 2024 3:50 PM
To: Zeng, Xin <xin.zeng@intel.com>; herbert@gondor.apana.org.au; alex.willi=
amson@redhat.com; jgg@nvidia.com; yishaih@nvidia.com; shameerali.kolothum.t=
hodi@huawei.com; Tian, Kevin <kevin.tian@intel.com>
Cc: linux-crypto@vger.kernel.org; kvm@vger.kernel.org; qat-linux <qat-linux=
@intel.com>; Wan, Siming <siming.wan@intel.com>; Zeng, Xin <xin.zeng@intel.=
com>
Subject: Re: [EXTERNAL] [PATCH 07/10] crypto: qat - add bank save and resto=
re flows

Xin Zeng <xin.zeng@intel.com> writes:

> This message was sent from outside of Texas Instruments.=20
> Do not click links or open attachments unless you recognize the source of=
 this email and know the content is safe.=20
> =20
> From: Siming Wan <siming.wan@intel.com>
>
> Add logic to save, restore, quiesce and drain a ring bank for QAT GEN4=20
> devices.
> This allows to save and restore the state of a Virtual Function (VF)=20
> and will be used to implement VM live migration.
>
> Signed-off-by: Siming Wan <siming.wan@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Xin Zeng <xin.zeng@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
...
> +#define CHECK_STAT(op, expect_val, name, args...) \ ({ \
> +	u32 __expect_val =3D (expect_val); \
> +	u32 actual_val =3D op(args); \
> +	if (__expect_val !=3D actual_val) \
> +		pr_err("QAT: Fail to restore %s register. Expected 0x%x, but actual is=
 0x%x\n", \
> +			name, __expect_val, actual_val); \
> +	(__expect_val =3D=3D actual_val) ? 0 : -EINVAL; \
I was wondering if this can be done like following, saves repeat comparison=
.

(__expect_val =3D=3D actual_val) ? 0 : (pr_err("QAT: Fail to restore %s \
                                          register. Expected 0x%x, \
                                          but actual is 0x%x\n", \
                 			  name, __expect_val, \
                                          actual_val), -EINVAL); \ Regards,=
 Kamlesh

> +})
...


Thanks for your comments! Will update.

