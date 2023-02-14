Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E4E695CE2
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbjBNI0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjBNI0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:26:10 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649B810F5;
        Tue, 14 Feb 2023 00:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676363169; x=1707899169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X96riEyRfVkm0gK03D8HqX6eSyB3e/OPTnI6iIKglrA=;
  b=GPoBZuj0jykC6yI/QaWTvHc65vapl87D/Q7S/fpcOq6IzKg/rWwcsdD9
   CCP8YbtIw+Xh+PA0tErSJ/elnrIYDwS4wAkBN1n8T2vFY+vSC9LCxO167
   a6Tara/cOqoyvPlZv1UDzYaKLaaGvq0vNl37sMxCVzaIcEoS+DirdKpbL
   8j3IMcRJQUP2XJBqC0q8VaS0WKSVLq9lHjEakWuphubOEIk+sLt2KI64n
   5hUusw8MjhkWgpPm10tUp4nE4HvtUjbYcWOG6h4dA16XmQjsku75UUqH0
   WPAUqt2mPFdxZBEPLEFIhtUuojfsluTuthlmNjgoexEfqtYv/gytj3jxY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="314751932"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="314751932"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:26:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="662473313"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="662473313"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 00:26:07 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:26:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:26:06 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:26:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:26:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2Dni5S7ex03uAoLY/J+WYiITXGYXoRZb8MeO/lZDTFWGYCG/cNFj/FUtfu7vyiITdWOfKmG8t7AlAFcOK61gzl7oqJRtNxasx3z49cqo234ieGhSJFWtLGqdJEW+SqbB3zyWQac6pNXBarGqKGmxA3IoLMtyefdptVPegY93JcY1X4GyFxNhmG9Zm419/McuMoamu/yX1/ZD2pxsKltp4J9bSRkSnushnrs/RAdhoUwci1us3WalZzMYzP8+SAbU2j5344jIB99wubzs16GKqdiUKGhdDiCMZheMNIiaPRqYoONbRF25WXQFvR25JC2LWCfV3RiQkIjLAUzrL34vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gL9B7Fza/VrFpQzvssl8lP2s5aJjCF6XrkS0jAjeFdA=;
 b=CSeFNR+dCFhHo90jKp+kv7kwBA86WJ3AO06s/B1tn1TdeCplnEXKiH3I54sDU+0mztxgBiROf4viYdmsucLaPNQPFP2vkZilGV8i85rfbJN55yIcxYJeB8nd6oNLpyJyViKTuYiJwJdK0AkRoimuGbXVEs1mq7OwP/FoZH81l7RtDlSwjQFbddNv8YidnID1rXskujg8F7r7490/HTE/G0XfeOiKbfKkQUqmRnFyj635QSKyjrkAW835fVoHyby1AhdWDe5w2IY7qy/c2KTAoqB6oDvltprvCPkgLkER6fNGYU5hCNReG/R5xcqcA5K/HPx9NMF3/2A2xKNe55MVxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB8003.namprd11.prod.outlook.com (2603:10b6:806:2f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Tue, 14 Feb
 2023 08:25:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 08:25:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 12/15] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Topic: [PATCH v3 12/15] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Index: AQHZP73TQUDUskIjsUuQwVp/wZc6qa7OG3Ow
Date:   Tue, 14 Feb 2023 08:25:57 +0000
Message-ID: <BN9PR11MB52764F3A8B61409BCF5ADAE68CA29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-13-yi.l.liu@intel.com>
In-Reply-To: <20230213151348.56451-13-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB8003:EE_
x-ms-office365-filtering-correlation-id: fdf4ad49-c1bd-4789-18c5-08db0e6518df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZqKEsrDYqKWM39g2x60exhs+bx8HN3WGEn3ub1Ovp+vEDE2P/yS+VoECKgJY+Vfk5bo7XPJkfQIEfswNW1EL0/XSwtzbKiggo7n1uU8cvZGZ00ogH1BvF4fmwFD5IPC7o9xdmNmVSErrC7Ki5qVUb03VNIz8ABPD1s2dAlXx5IYzd1b2nlpWEqEByjA6UuQ9hAVQBPAmI7FAPywTIuMRjkZbniZAcd+V2ordwimMP25JfjUv7v82J0hFXU6BEIZSS8VjMG01uS8Gc0RV41CZIE0PnmO5Sy9LfleMj9qrDYFYi/u/RFf0ckJ4Dd16mxBrD96BglDdZ493z1MnVLIUkJQQK+jNcx9PmV7y/Ws6J40f5M2gLrrlsCH/We1PPPSuObngwKpNrJ2nAcs92/Z7neEpLpHNTh4kHkfx1lhU0fcTKcdXrucXcxaSQLLWnO98PnsyuheJH2pgz/tdiOIg1Is/hrAWvJjIqjfz1FUn4QzgnoA5+cZ1e+vWOptn8TMo17bNciPrfpKFOEEulOJB4LsB5vvZ0yequQjRecyCME/74Hshs50mxace9KQ9XXfKIfhfM/LRtF4gbxBsPoLfphGUmnUX8VIebaM4Dq+IDPMaBzBzYjMQ7i0XPzfVpZMcahG4u2fLYCAWLwKjXL3SlJ0V2JtIWxslEK3XqiDa85LDYsFW8S4e2I5PQrM9jBAATmKMm0ngADQwiXpDh4hNew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199018)(110136005)(54906003)(122000001)(8676002)(82960400001)(38100700002)(86362001)(38070700005)(2906002)(33656002)(316002)(52536014)(66556008)(4326008)(66946007)(64756008)(83380400001)(66476007)(66446008)(41300700001)(76116006)(5660300002)(55016003)(7696005)(186003)(26005)(9686003)(8936002)(71200400001)(478600001)(7416002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/UT+Fk+XVKjE0iIj5t+IKi7j1TRAHrE+oJr1A6R8l5v1cOndLV++g4xndqN8?=
 =?us-ascii?Q?yLbQrcvy4z+mZHXhNOMGhEPcLqgNT9o4WHJLu8JgaqeGI0GDL1qr/51SN5fR?=
 =?us-ascii?Q?WE1saLqJTXByxVfpvTyOyfubM6fjEzoQwwOdfC3ZFKtQJsKxKcBtqYYYu2Kn?=
 =?us-ascii?Q?ppYPT77aKMv4xPwwDN/XAwTlT8lfy/I3AqgD010jgxx8qBjNTo+C7culEBlU?=
 =?us-ascii?Q?AFAAhVbKEzcgRqI+R5S0zPXWogRnfnDU+YUMgGAtGUleCcQyg8EccekPoBKE?=
 =?us-ascii?Q?s5Rhit1t4MfZDFSoWqdA5yPNl17Th+AdxK5Zinbcdj9K0K6Kq3a1WD8KofzI?=
 =?us-ascii?Q?nN/4IFDFz4GXAYirIT+2/B7xbp2m4vTeouTQsb2fyZunCE7ItIfxJ+EgcGOn?=
 =?us-ascii?Q?RlWkzIcJjYb6mZBC1aj89CUbX9RrAPIeFpRzn9a91NOxVT42To+yBo/Uh5pk?=
 =?us-ascii?Q?PGo0E4+Nt2pkqNtd4+9qdz7yUIZYPIL5nOBWxGmLuZDva7zRiFYHjdbcf47p?=
 =?us-ascii?Q?D0pffVeeqAuxWjsIqIVCDdwJB+12CXPRLd+doDYwUl1e6zsU3fjf2c9YcNQ3?=
 =?us-ascii?Q?yOAi2tCv+HeSZ5ZgNlmQ4F9t6HJUQ5gjfr9qiSUz1cXCwug7tt7aabzTEa4N?=
 =?us-ascii?Q?XWAKVWkb86742lG2tG1r8Ra5chfO7Ml8kj4cqgZ+gcrWXiibr7yxefQnpOig?=
 =?us-ascii?Q?/OAjvTOkuHBzAcyCm17O88tr4nCxXulV2seGikwQHs2FQoG8r5Pc1WpNVFUx?=
 =?us-ascii?Q?A1Cds8mgr1tbS64laaPsvIlKIkeODy7a6+Dh1swBkSLu76l7SDst9vfWX1Cg?=
 =?us-ascii?Q?SfxJCjOUCHsOlhzcdsLVS9XUtjcX8gU3B+GIsUVpuhEdoPUrTS37iaadtJpd?=
 =?us-ascii?Q?xqyXZVmjRkbb+pfU8v7VRsmsZdVjIPeq7QS0bXZBj48+orJJ01qvdEDxKPMy?=
 =?us-ascii?Q?7zbzmI+nmzIeht8fCPcllUso8FY6/3VTwb8eeFuxlZp73vRDUSJC0BnRNudR?=
 =?us-ascii?Q?1KriBTvFMRCE0MLP0J3/SLfwHXBQ45ivv0Z+VxCx0jgRFMRIAbJm1P9sJpQ4?=
 =?us-ascii?Q?0cCot2+NcrXxUgSHu6nRLWvvttHJTmc/E7KgmpAk+inAWvIslCZRVn37a3dD?=
 =?us-ascii?Q?VMD//v/d8HZaqO1aFvMd4ir/q2ILuBVjRPoXN0/nwsLfWZDBpp180tPoAC+B?=
 =?us-ascii?Q?fdsVZ0INnHh9t3Z8lm/2Cr7NvyxHKiNpMYaua/wEmGeMBupqcEkOuXbQN0dh?=
 =?us-ascii?Q?+AHTeiwbo37gs0CP7uohwNfyyT9H2D8AU/FyMuJ9hz5FT1AbAqNl8P5h6dRS?=
 =?us-ascii?Q?VYL9BXnNlYmbKGPtEh386R2OL96YLHRVsidDTkDEdTwGXAzEpEXEDtlWKmfT?=
 =?us-ascii?Q?0YD+duEcJzUXrrwSecCjj79ERsQl6tZ3gYqlM8vekmfGvQnsOAaZI3C7ergw?=
 =?us-ascii?Q?30xvvoZW9Jp3JFRKU3OEF3xCh6XdBue2BKqKjG9cdiZSdXoF+QXpglPwrmMi?=
 =?us-ascii?Q?wxYtIjZwmu9wTmxWXeAR+X15y6PCQWnv1wmtUBd4Evjgk8UFz0CdSaJEFux1?=
 =?us-ascii?Q?jBLnJIs3B5OYyrxeUMJbzGWep1Y0aZ9wGcIMLBdZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf4ad49-c1bd-4789-18c5-08db0e6518df
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:25:57.4192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WxZLXDVcURLGo+cAJu/UXHA8Fpa7Z9VauChXnjH1+955zm0+M/lDlDYFyNQ5C+vJZgJDe4QhsaLbt/JnYdKkeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 13, 2023 11:14 PM
>=20
> With the introduction of vfio device cdev, userspace can get device
> access by either the legacy group path or the cdev path. For VFIO devices=
,
> it can only be opened by one of the group path and the cdev path at one
> time. e.g. when the device is opened via cdev path, the group path should
> be failed. Both paths will call into vfio_device_open(), so the exclusion
> is done in it.

the exclusive part between two paths is handled by the last patch.

this patch should stay with explaining single-open facet in cdev path.

>=20
> +	/*
> +	 * Device cdev path cannot support multiple device open since
> +	 * it doesn't have a secure way for it. So a second device
> +	 * open attempt should be failed if the caller is from a cdev
> +	 * path.
> +	 */

remove the last sentence.

> +	if (device->open_count !=3D 0 && df->is_cdev_device)
> +		return -EINVAL;
> +
>  	device->open_count++;
>  	if (device->open_count =3D=3D 1) {
>  		ret =3D vfio_device_first_open(df, dev_id, pt_id);
> @@ -543,7 +552,12 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
>  	struct vfio_device_file *df =3D filep->private_data;
>  	struct vfio_device *device =3D df->device;
>=20
> -	vfio_device_group_close(df);
> +	/*
> +	 * group path supports multiple device open, while cdev doesn't.
> +	 * So use vfio_device_group_close() for !is_cdev_device case.
> +	 */

I don't say why multi-open is the reason to call group_close(). Isn't
it straightforward to do so in the group path? I'd just remove the comment.

> +	if (!df->is_cdev_device)
> +		vfio_device_group_close(df);
>=20
>  	vfio_device_put_registration(device);
>=20
> --
> 2.34.1

