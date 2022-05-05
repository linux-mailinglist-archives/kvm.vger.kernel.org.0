Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3734C51B982
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243311AbiEEH4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 03:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiEEH4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 03:56:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3005F488B2
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651737193; x=1683273193;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ACW9HuoYFCsok7//uGTU7fg0pgPSma8RCBOJgtRuOPE=;
  b=AFA3Ss7djzLQ5z2xUVDzpvj7hJ/STEsghe0yMQtSp5OEaiPwExi3ZGWC
   57uTt87Ap8WBp15UhJA+k3xTMxG+t8RXCwuV3cKdxzUe586BKTmQ8r5F9
   oFkXfPjI1Gcq1/g2kFzy9fD18zL1nEaJhKKiPTelR6IA+2jMpt139IHwX
   sAgUPHy+6uSt3cIIsJd4g7DldPChJt7l64gdzABVrIUWt74wLQ0qOpTVr
   jGLmqNWl9Fy87fzPTj+CbIfcLNH4tkVEPIgck/YNfWzEhrQGNrYwL7WxT
   LW/uegkEyY3XvqP6lxehP7Oq/RlD0kS6gbHrJ9ApCHiTWTrehMIx4WZfT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="267918094"
X-IronPort-AV: E=Sophos;i="5.91,200,1647327600"; 
   d="scan'208";a="267918094"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 00:53:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,200,1647327600"; 
   d="scan'208";a="549245067"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 05 May 2022 00:53:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 00:53:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 00:53:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 5 May 2022 00:53:11 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 5 May 2022 00:53:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuXQ1dmkaUfFpFt/Y1YjQeRCUGpSUQ4bhVcOX+vx0eWw44tWXF8dpbq6J1RcsxK5H95V0m2AWg3Ie2cQrELJIG42PqLu7Isg5FlDERXVNY/3YW1h7MoZp25adVBoLRHiWLafOvgQFe/REWQ4m7PSWs4pcQjueV4QubJ3NSw8NkvEJhMtsG3y0nnQ7+G/y9NEN0voCoWpAHdqOBFQTDX3DdrD62D1dWTujb2N2jZ5djTSsZQjCXGnNJpYP6NbZolzUaWHvP9pmCBHKs+X6l2JUhD1JLibQg1UE+gFAeNrnP9h7gypfDmhiS23DoIH5gjNkb2JZsVscRh6RuffV3JVVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDu8tLTCDHGkqwRl2wQCviufls0U4jO1X8cIYbtEldk=;
 b=FGnj7yR8AjfvqPc4ScLw7Z1cQadJI6FnfKTqWEWYDuwhOHM7O2ct/H3FYlAHxKruo99ETYahQQ9q/9KPgdEg8riyMP0NZ/9fnVemoEaDGjcN6qqvbCS6vBry+drSIW/paoIvoWDPMgWgPIt/yWUkhBsbCjyWjcSNzP66P9Qv9dS2a4wQAEybuYU9mExjPkD3ieERrSXg35sbUDQ5OZFdvo7txr/Ox1VXd1gpTV3c6wW2cFOSJqY1qU/Gke3xM4GKa8Jo+BEutZroLjK5xVOdfk9XLcCB43IxuQyRdsy3TmgLySKGiLNrTtF98f289qIuzJr1XETRlqJ+MYHeWIWXgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB3085.namprd11.prod.outlook.com (2603:10b6:805:da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 07:53:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 07:53:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: RE: [PATCH] vfio: Delete container_q
Thread-Topic: [PATCH] vfio: Delete container_q
Thread-Index: AQHYW/l3YA4XRsk520+2Ru5SO2XKYq0P8kmA
Date:   Thu, 5 May 2022 07:53:09 +0000
Message-ID: <BN9PR11MB52760B24750CCCE9A65EAA118CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a1e8791d795b+6b-vfio_container_q_jgg@nvidia.com>
In-Reply-To: <0-v1-a1e8791d795b+6b-vfio_container_q_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e057a70c-d65e-476c-a2ed-08da2e6c4c16
x-ms-traffictypediagnostic: SN6PR11MB3085:EE_
x-microsoft-antispam-prvs: <SN6PR11MB3085F23E15A030894F0E12DA8CC29@SN6PR11MB3085.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hL7mZAcLL6RfQOM+JnD6BW1mzo9T34Gdz1pjBm6iuVQIE5PuWj/erjfElU7YJGVTSVPzNIoTX0Z5to87qBX4Qh01qtMibMk02m1KW0m7ZILHz5OasrsAa9EexSGIrF8RAJBggkiocd7C1FPSDzi7pmZg5jLmlikX9tysqavar3BJ37R1YpjE9Y6ecHavjnf9yBWUT49TsAb1rQQZI29uldCOMJvRfLbI/yVS57V3QXkFMV55NrNT+OlXKHrPpq1Q/RwAYuydKWoEaNrXF7tMQmBMnoBhGIOIxi6+5vDpufLnBSMeJED8UFWIu0tpH2JZDJSfcBHpt4HuN0kJs6BgpNrjUvt9mGs2qNfjqsu5hgCZnXCa5mbX2eYOHkXiUqgC7SZcRNgEoQTc60eNq9KEBC0T94RjuxjPF1EdH89Ud5oh9e1JKp3FqmubxHMbOvClHX/y1MDAmhJ1nf0+jvdixnvePdNEIpjlREasEbl+DmmRCmuvGAmdXi82MEjWQPCoprXktvTN2ZHLRLfClNcQKRx0D0xZo/yNsFab0dOQCmZaku8XpBadc1Ek2VcLh4vFeJNhJt5Eu6rKCm8mrIDo9o07go+yFDtBPyBw4U4MTvV1iQLotTEiNOnVlBQj8S1LIs+x8IqbQJMPFN+0QG7OTA3yiy1MxpTKdipNXQLqbBYapvR5gblVkR9p7YXpzTBpRuEZFF5TWO/sz+0ONFuRmg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(82960400001)(2906002)(5660300002)(8676002)(66946007)(8936002)(26005)(66556008)(66446008)(66476007)(64756008)(52536014)(76116006)(83380400001)(38100700002)(33656002)(86362001)(38070700005)(316002)(9686003)(6506007)(7696005)(55016003)(110136005)(186003)(71200400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8jbhqzGtO6q50MXjrkbxYBJhLsl550L+f2gPrr9+L+QX6d58/c2KzzIqTRiT?=
 =?us-ascii?Q?2ioSjiGKR0EpIREYq/MMqnC+1zZ9EeoIsqXz7H8mlDMcb0bxAXxCaGenoKSs?=
 =?us-ascii?Q?R3p1yxNtHdWwe4Pkd1ketjAuGSt833CbCHOv8wLbikcH9Cfr1Tki87Q9I7zW?=
 =?us-ascii?Q?3m+7Dhvn+8UjzQdyqxbzuVStjbIyyrBUf/N9GDYYAetbIBzBZ0qxBzmdPfUZ?=
 =?us-ascii?Q?5EHpsbFylguLnM29Yw2IfNIn+qHuF518YLO8D5amiX8XWshHmRrVRT5VffRw?=
 =?us-ascii?Q?kW4QAQdVPrxgr81vU+17Bm8Au3G2x9bp1RRClJv6ak6IAjdTfg5ZJihY6x2i?=
 =?us-ascii?Q?nu7nenkcWXmAaz88SEYAFNSIbhYeILac5kHHt3jGpizXEihH8KzjX7BhN2cp?=
 =?us-ascii?Q?x96RdVk61v7gFHtlfM0d7Gi7m+Q3ZTk0gmNJLBJg11K+az8oSGVVf50Vb4M4?=
 =?us-ascii?Q?uErMGPMAyI4Hq8wkQBcTVxq9OfS+wlcHts3z4qBHy+1R6jAOzOPfTlo9bjzb?=
 =?us-ascii?Q?EnJ6goQN/rHAmEKRf0llh6JaIhY036YkTpX7PMLwuRaYH4+s+xgTsY9lQJAI?=
 =?us-ascii?Q?fzS6LKs7nNhNvYjvTFnh09kroLzBogC2NM5w/ZOKXtRxQXfPen1imkFibrmq?=
 =?us-ascii?Q?YJq3XGpoKGZh/PFh9VrfguCNS/fAWZuWVd3ZWRlAlc13+1hcpWZRtNJxn8T7?=
 =?us-ascii?Q?RkCspBpXaP5obRORMcOKuHInmv9YQhzpaFWFkPFbK6xF04zHvYDGY3HDztML?=
 =?us-ascii?Q?chGoEybUNLvFo8hEkaku0JSn25vg6oGGGmB1AWpQp8MCiy3jZ4PdiOK/aJKv?=
 =?us-ascii?Q?W9HYkxtooPSOaKQyVAWZmrtS623lDPuZApsw7DtKt/A4sfbOLwjxn2pZjg9h?=
 =?us-ascii?Q?Gw/EVCjKAxf7BNNSWyN4HKD1O/zZGFW99H2xeXqV9wuY5VWUyT4v7PJbZjmJ?=
 =?us-ascii?Q?tj+rHbOqg5IEh+mNeTlObJv5St9r/ROVpDRx88IZKRnroOMXn7HEJmKzUgEk?=
 =?us-ascii?Q?bCAUt6BUxbq4AGiFTDMjn1Yq+YaKlOe7VLnWBnEmY6SueVgtP2x2bXMMpCkr?=
 =?us-ascii?Q?xOf8X5khD7xCfk7XTJww5XA6LqNumzIVR0BCSoePKKyyX/NK8t6gFSheNmms?=
 =?us-ascii?Q?nVuSEft3YwU8dKHSpwioW7BR6kE3EwghMPUrM8W2mWeHeNjkhbsmEgFsFl3i?=
 =?us-ascii?Q?FHbfWl4mB7yV7e63MqsBV8QjxpDcpqCreU7+bKO5L+Jbiv8SgYczumupu1zb?=
 =?us-ascii?Q?5on7JXyIZAWOgBvBRerNtCY3i12LklsxlB3oTEwFEUwK5nWJeK5ZjECHAYYC?=
 =?us-ascii?Q?3AJcqjx1PzephoLgCIi3uGjn6666b8tVYTVATpJenWG+d/PHd5R5dOi5/jc1?=
 =?us-ascii?Q?qg+JnG/ddAd1mphuPv6teAHDdYWrKxAEXWueP/+iRwIzviRMs3NEL8sjyQi+?=
 =?us-ascii?Q?0gTZkuAhkTJdPzQzuLj7HSmwBMSPddHGDMcpSKLc8Diy619r3zcYi94Tfgsq?=
 =?us-ascii?Q?vR4ijQ0DjsGzLBENkTTzqoVeHhB7BJSDGBHutK1RV/1TmZsSyZrkxB0dxUIw?=
 =?us-ascii?Q?Ousgiqz1M0Jx0T3eD/2ezkR28oG2nwxATPag1Cc+lgTImktRO3IwL28CRlba?=
 =?us-ascii?Q?HsmsTXFUyBWOMKL48Ge22VFKW+WWFeBthy61QLSleCeBxIfwpNjufDYmpx5D?=
 =?us-ascii?Q?nVWwoQ06GEUyjVqGDfwswOuODbQSahi7q2NhVTq5r1aXHZ4/2GS0n9JTzrUq?=
 =?us-ascii?Q?G0zIzgxfCQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e057a70c-d65e-476c-a2ed-08da2e6c4c16
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 07:53:09.3619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rxhgsTXbJG6PD96C7w7dQu3EVT9iU/0LtRBbnEoda7r4Y+zEmvDeXRoHaCeDy9VTopP2eo0x7tdsZG6ytZtzbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3085
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, April 30, 2022 2:46 AM
>=20
> Now that the iommu core takes care of isolation there is no race between
> driver attach and container unset. Once iommu_group_release_dma_owner()
> returns the device can immediately be re-used.
>=20
> Remove this mechanism.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 20 --------------------
>  1 file changed, 20 deletions(-)
>=20
> This was missed in Baolu's series, and applies on top of "iommu: Remove
> iommu
> group changes notifier"
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 0c766384cee0f8..4a1847f50c9289 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -74,7 +74,6 @@ struct vfio_group {
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
>  	atomic_t			opened;
> -	wait_queue_head_t		container_q;
>  	enum vfio_group_type		type;
>  	unsigned int			dev_counter;
>  	struct kvm			*kvm;
> @@ -363,7 +362,6 @@ static struct vfio_group *vfio_group_alloc(struct
> iommu_group *iommu_group,
>  	refcount_set(&group->users, 1);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
> -	init_waitqueue_head(&group->container_q);
>  	group->iommu_group =3D iommu_group;
>  	/* put in vfio_group_release() */
>  	iommu_group_ref_get(iommu_group);
> @@ -723,23 +721,6 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  	group->dev_counter--;
>  	mutex_unlock(&group->device_lock);
>=20
> -	/*
> -	 * In order to support multiple devices per group, devices can be
> -	 * plucked from the group while other devices in the group are still
> -	 * in use.  The container persists with this group and those remaining
> -	 * devices still attached.  If the user creates an isolation violation
> -	 * by binding this device to another driver while the group is still in
> -	 * use, that's their fault.  However, in the case of removing the last,
> -	 * or potentially the only, device in the group there can be no other
> -	 * in-use devices in the group.  The user has done their due diligence
> -	 * and we should lay no claims to those devices.  In order to do that,
> -	 * we need to make sure the group is detached from the container.
> -	 * Without this stall, we're potentially racing with a user process
> -	 * that may attempt to immediately bind this device to another driver.
> -	 */
> -	if (list_empty(&group->device_list))
> -		wait_event(group->container_q, !group->container);
> -
>  	if (group->type =3D=3D VFIO_NO_IOMMU || group->type =3D=3D
> VFIO_EMULATED_IOMMU)
>  		iommu_group_remove_device(device->dev);
>=20
> @@ -984,7 +965,6 @@ static void __vfio_group_unset_container(struct
> vfio_group *group)
>  	iommu_group_release_dma_owner(group->iommu_group);
>=20
>  	group->container =3D NULL;
> -	wake_up(&group->container_q);
>  	list_del(&group->container_next);
>=20
>  	/* Detaching the last group deprivileges a container, remove iommu
> */
>=20
> base-commit: 46788c84354d07f8b1e5df87e805500611fd04fb
> --
> 2.36.0

