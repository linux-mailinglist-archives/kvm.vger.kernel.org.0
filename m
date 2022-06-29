Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E083955F674
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 08:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiF2GVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 02:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiF2GVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 02:21:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8CD1EACD;
        Tue, 28 Jun 2022 23:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656483707; x=1688019707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1IucJ5l/yaAWLzGcbZJe46zUCR+nC7G2sWKklk9SArw=;
  b=Gc8ZSZHLknDzXo2+yn8EUrRAC4X93mxvmG+LQ3YTqb68Kc1/3uhcnYqH
   rsfwfcc+oZ9QrVtrHGKD0sORbqTs9T+W6axM9I4e30xuFqX6DVfhvPCoc
   Z1hcisv6LTugKmbSSRHkOEUA2qm+H/bPjMYWz8C3NWhDCt71kwjAKEh06
   NLNEfScp6600yCPlURuJB0KysFtlmR2gDDymLM++lqDkEyC8xpaSGOJlr
   qtvx1rYoBv/TakNHdQ0uaLexwzgP7e+71vsAspbcMYz6SwNkT5b8fZDCv
   AlIkAKZg+6HWHc8dvz3fDRVhy3NpUURj0iMgORfsbMS49u2T0WZxCBHqD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282670643"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="282670643"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 23:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="767453771"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 28 Jun 2022 23:21:47 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 23:21:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 23:21:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 28 Jun 2022 23:21:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 28 Jun 2022 23:21:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vql4MelqRdZMHroCzqnIdrp216SQQdKouTzr3COJSnYy1RQ2o4nNFYX36zMjCDBBgbpBleQAnRaGWdcozGkOr9fH1VO+t2BC+0frp3A7zbh73N8JuY/5Z4RAGWPUih2+0I9D5iDYdHlQfPQ40UOfW+/oKs38VmXVEY0WCPIkjNNUNky4KlC9pK8t2EHfZPOU2PYg11aBDYQGIHzFtfM5lug3xICYgUdUYl6++8P9EQ/fVTv2LFVNMGOxiFuDkNZG1HdIIegQWJkokKM0BvQbnAfu4uUNAUNFIRonJTdHn3rD8Tydnlwb3Fmq6aEXHNDXoWpuB1A2zH8ENbbfqp5v0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/uZJE0HMFGnneyLJ0T6A7MckjfM0+TmDY+HuZtNm68=;
 b=Eq0JP6N7yBQ2Eebh1djzfBqaI1zZeEhuJ7jPBr5G4lP6P4Kb7XkQ6fsmNb2oG6fxyPQMVkGWdxEDyh1As115h+1Lmj8fD0SJGx/An7mTco2496u5ZghedFpV3i635u+YTAWFcIxeoqnLuUPbRAHd3NNJZXW76LAezi+QxL8NhUxtCByAy+fBOF3G4st5wQREZx12wI/xuI44lO65mVsztcPTd4c7uYv4krl6/AqqQpIA0e0WbqcCZhTIWF4syfvoFBRe4J2Qv3zmW8dGJhl3mHdTJmbtoFgzWJcugfMYGwU9B7Q0DkPNTG6d4hhiSMdrAQ6NboFT9DgBGk4fjlRvtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5564.namprd11.prod.outlook.com (2603:10b6:610:d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Wed, 29 Jun
 2022 06:21:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 06:21:44 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Liam Ni <zhiguangni01@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio: check iommu_group_set_name() return value
Thread-Topic: [PATCH] vfio: check iommu_group_set_name() return value
Thread-Index: AQHYiIjgvSabqDh7/US8kcs8Uw9Raq1l7ycg
Date:   Wed, 29 Jun 2022 06:21:44 +0000
Message-ID: <BN9PR11MB52768490C7979AF1228B7AC58CBB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220625114239.9301-1-zhiguangni01@gmail.com>
In-Reply-To: <20220625114239.9301-1-zhiguangni01@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e4d9290-9b79-4f07-55e7-08da5997a390
x-ms-traffictypediagnostic: CH0PR11MB5564:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bfmzaeMr0qip5NiwGMRXafAaNP41A4ASJzRqjNiREWYwUByP8/PddWo5+qVybtyO+/DXfAfVskFo1jbMJSlwhZGr1C6o3ZeEGO7DIN23jwH7ukEDM4PhVhZQ4rHVEPSBUx/MmzJ/Z823iBWJSGxbXCVnAiYjbEpPUsjDxfROFidAAIHIgqaJPHgWf/qpbEhbwSmtXSVgUQZ75ZGhrkerJFn++IRBxk1+UK/xKJ4/TZk2MHRClkc05woZAgdwcrSlqcWng/AT0OXq47k8v3p5Z4UkWakfBBUq0aTLnpfp7ZFCh6k+26Ht75VyFbHyd+LkTXian3mEAX02ocVTkzNAS3zkPzOLORmChEoygopyMWGnweJ0er3FI6CftENJ/9O9S2TzrE5nJCK6KdYoeNqVDkDGK2X5oG+DRAozhHbauxI986c72SR2NT1GEApH5iM4FQkBRddv1MObAzwq2bpEI63rXZ1GEsR6JPo+7baqH1CwtUWMNCRw9KhnWldCEiJl+DUs7CZqDIt5GtOdhRIWdy+fXGicMmiC3w1P274FCCS0rMJUfsn8v7OSPUugqn4ROy3DIeNmBFVnD/WLCDtJsuDZOYvh3jpkOrLh392rSO1FHYHbvxrkH1kI+GaDpX981Di9US/Znt9lqKXb8zy2X9A/cRTUrpjzeBCILZiZ9jnjp60adyr3wvvleUg0BV71NLUM0XPUeHokw2QRtqBLUEb5V3dH1aCAC3vzs1JRV1OLrikNLSkRMB4Yl980io1oubUx6d8RA8Zr0F6DxpHAsyDgEFS65R/yxzmUuupBzwQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(366004)(376002)(346002)(86362001)(6506007)(82960400001)(7696005)(71200400001)(4744005)(2906002)(8936002)(52536014)(186003)(478600001)(38100700002)(5660300002)(8676002)(9686003)(41300700001)(38070700005)(33656002)(76116006)(66476007)(83380400001)(316002)(66946007)(64756008)(54906003)(66446008)(110136005)(66556008)(26005)(4326008)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+Oiz5XTzR2wfr82dEZ2HW+JIYZV17m7Lu2RPDmQjoEGUdaqohNME9vGlTxvQ?=
 =?us-ascii?Q?VPWg4ueT8E31PSF5/wPhG5qJwm9E4AWdeZIJJTbPlSRUY2AeErUOpMM3TsFj?=
 =?us-ascii?Q?DHKpBbXf6RH9kmGrqSwB6yYCSb5UgGoiVkza1uo4NMGPvSnSznWEIJNorCIx?=
 =?us-ascii?Q?k0YuP9RIaKFk0ij9Eg+fUyz9bShHA5eIDB4nnOh2wZKkKIoZ7j/ChXGLVtSI?=
 =?us-ascii?Q?KhDxaSd/h8S74NApJbZMCPe00Wck6KCp0DYIvH/q17tCT2+dwfIk/hzeCTqY?=
 =?us-ascii?Q?LSHeVvnoZvLbrbvvpE39nDmgR3/SfHV0KEINLR1psIjWoZBxYLGFp0HFICDW?=
 =?us-ascii?Q?l+YiFP1wgrDqx/U9xtDT7tSh6HlnCFKk1uVO08/LFEyaNk2+gr1nbdVqIPtj?=
 =?us-ascii?Q?oBd2+jPujgAvHQVlg4jGg0b7VKQ+y3D/ttYclZr0yifeo73mMixImVyW9J5J?=
 =?us-ascii?Q?ejia3d7xG26gGO5NnVLAff5wCRHeK6whUOfkIL5c+3s9auLKXcFNxVSu489c?=
 =?us-ascii?Q?axDXX0EiLvBHnwdUbBeWjJ0y91AdLlCWyTY0biDiDw5rERGtJzZPoAm3N/E6?=
 =?us-ascii?Q?IY8mSivtRMH2tFg+ckVQ8wUwYSU5yaxPgW1pZs3ne9FlMEGIZ4O3vVFgAI2H?=
 =?us-ascii?Q?1kxyVSL7Mw5ZY7AcnRoide2A60XcUMHff+LkjwaGVEZVfyX5N9pOp9dWPik7?=
 =?us-ascii?Q?ey8Wh3GfPS51MwwPkRkM6H85LAkxBKtzrzA7d5dj4f3/v997kHswWw+FhkGb?=
 =?us-ascii?Q?OPEqGah6A2Wqw9fp9nWypoN12awbuDI3ahVSXEN1YVkxvU4lGPtm3FdETDQ1?=
 =?us-ascii?Q?rPRN1fg4RGTL9dq2Oe/mP4QszXHNYYGx2/KGrbjCaWaLRz51d1HStmCV5tgb?=
 =?us-ascii?Q?cEH02kO5miBUgs7sl9UThUi/ASIrGS/T1j17cecvRSLg+WFbGY8Bw91K5jHM?=
 =?us-ascii?Q?FKtsd5UgVjUdd2kj73ZXMc1b4OJUBOjezAHEqr5fVP/2mJttniOiD/SW3Jr3?=
 =?us-ascii?Q?HVb053EbP5Dh36rWjWmM5qdVFPm+ZBEWUtjVtbnwhdDP8i/qYYbhIghtmJHw?=
 =?us-ascii?Q?iq/iN7SDkf1egX099HpcggrQBD3V9XXA/Mh1ZKed3IO/6XkWnvDuvvCzI7ck?=
 =?us-ascii?Q?Cg6mqOrDLmkZpgA/T0xWPY58GontEWNdfsbTID2JSo/qEnodFhE0pmXr1fj7?=
 =?us-ascii?Q?bpY3fzTmT48e4Rg5DFDvcqoaARAotdtV4DiqG9q0RUAk+V3RSLXZi3V+6PEe?=
 =?us-ascii?Q?AvhAAn3ASOdio3DGDfVqXXxtpPjsLV/W5j8AhLm3IyNpjnC5OwlfqGMeDNa9?=
 =?us-ascii?Q?FRd3CiuNqvZfA+zVrbioCHXFgjbzGOLjyplaz4ND+8nYsjKwJpDSE11P733z?=
 =?us-ascii?Q?K2bJIVpjArDhjbaxar/AKXwnWhDzsy2+asbR4CZ0ejGzLfSCdCbjruz3Ozwq?=
 =?us-ascii?Q?YRJ2LVRiVk9M0tv9+vK2o4mG4AzPtbzTPl4Jc9NgpXQaZzT5u5KAHMEL/h8k?=
 =?us-ascii?Q?1JZ0vgq9wdTlDhwL683VeUVnJTTYoza8rsAotagJH3TubH7h91D5oA0rXxmy?=
 =?us-ascii?Q?ivIG9eQAaPsNtaeFUsa1iKEg3ETiBVes1dn0dUlN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4d9290-9b79-4f07-55e7-08da5997a390
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 06:21:44.5269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uV40Dg5B/PJBxRxKZ4dBIRWW59vAf+hb7wTzoyYJ4ZdY7/wsIBflpYZk7URz+rxCmJnYRmJO3tf/cXsIhBq7+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5564
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liam Ni <zhiguangni01@gmail.com>
> Sent: Saturday, June 25, 2022 7:43 PM
>=20
> As iommu_group_set_name() can fail,we should check the return value.
>=20
> Signed-off-by: Liam Ni <zhiguangni01@gmail.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>.

btw you probably also want to change other callers of this
function for the same issue.

> ---
>  drivers/vfio/vfio.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..ca823eeac237 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -504,7 +504,9 @@ static struct vfio_group
> *vfio_noiommu_group_alloc(struct device *dev,
>  	if (IS_ERR(iommu_group))
>  		return ERR_CAST(iommu_group);
>=20
> -	iommu_group_set_name(iommu_group, "vfio-noiommu");
> +	ret =3D iommu_group_set_name(iommu_group, "vfio-noiommu");
> +	if (ret)
> +		goto out_put_group;
>  	ret =3D iommu_group_add_device(iommu_group, dev);
>  	if (ret)
>  		goto out_put_group;
> --
> 2.25.1

