Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689D15093E5
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 01:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347953AbiDTXy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 19:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiDTXyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 19:54:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3167E3DDC7
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 16:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650498697; x=1682034697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kOQz8ZIf7WTNK0/DTuUr2kfqh5FfBoM6rkim2Y0rsTQ=;
  b=dMjKy6n6vFuEYZh4HPE86snWgYrU+uEXpyjZQgGNTygrd+myMGs/obrM
   aDu99lqofpJEoU98gl0PbLueBHZIy38m4n4nHfyGIdodKYj9QLgi+qQqG
   BCnmSx6ngCHBnAmVvMAHu6e9Hdo6/jzy8te85w3R0DUrjzvnSrkTAyArG
   N0FJGuM1a8QU1nMFWnH9zRwjGO45XuZrR8tXToie1qi75BUSdQPuvrcWP
   YSakLbtGK1Wgr4QH8tggMdh7FplYHozFJt2AnnksuxrjY+QPQHd5LdpgQ
   QHr6n/ECBp/IicihJFH+BlZ4e+82pqzmKf350DmgwUjCLo9PYw17GgM/X
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264352246"
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="264352246"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 16:51:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="647880423"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2022 16:51:36 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 16:51:36 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 16:51:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 20 Apr 2022 16:51:36 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Apr 2022 16:51:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=El8k1i/B0xuRD4pimgydsVm7X3Xxw2Yis6sDEoOwPsJFgN1T7Nw26eF/be2KLhwGkPEZ4/qlE8M4FWh+t+/gIXD53QU0swLoAZmXq2QA0aFWEQB5TnjeSXjfzrSo4aoz+3QxS1ottmVoj2XoeVne9+jJtYPZTWlC72kBPT9XpQYjESeM1E39WTLw2UTRz0WFqn5w5ACjTUw7Dvvq00K8qiKpfBY6ZaLNw/OxpBAGnh9EabzmgvgcFB5TZlUgFDq4W4N4bQlPJaNssXl8U1EaisvlEL4W28sqwVLfYUbsFScMppkEYpA6qE18RO1Aj7zMqi30atG4pwX73DNfVG4YhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzCcI9PiKyrc+AHOTZ2bxG9Wu+5yejJELHGWfPyQahg=;
 b=C17JZLgThuBpBPunbOAdVrGLeQESy18dB6JO98XYzjhi8cQ61vMA2WIMyshdCZNc9fA2LYKmzdj697AEUhvJsQSd+u4dS8XLayKl2yBNjsteP4QXLuDteOA+OcCzrOZQvGCSTf3ZX1Y7Nsu3QT0cDIWB7kHC2hyAkJZZXzM4GWEE7aaXTZf+2mjbfoX+VoEa1tjT4nO46OfOOVTC35l+vL3dTuM5EvammkPpupfgvq/ag9jI9Q+FOikIc9wPA8jr83XBDGX320hmjNqYMihCswl+FhtxjRQ70rHrtaXXV3E6V097ajj1CW/hljerWrpHnWxXi9OCLkSQMjmpKYn4xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CY4PR11MB1815.namprd11.prod.outlook.com (2603:10b6:903:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 23:51:34 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303%3]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 23:51:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 6/8] vfio: Change vfio_group_set_kvm() to
 vfio_file_set_kvm()
Thread-Topic: [PATCH v2 6/8] vfio: Change vfio_group_set_kvm() to
 vfio_file_set_kvm()
Thread-Index: AQHYVOwgkWjP+xDfqkm76KoR2eY7O6z5eTOg
Date:   Wed, 20 Apr 2022 23:51:33 +0000
Message-ID: <BL1PR11MB527185A7D22F84AEDD7BDC818CF59@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <6-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <6-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e26c3c7-6f4d-4d58-b360-08da2328b2f5
x-ms-traffictypediagnostic: CY4PR11MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR11MB18152B9D9F0F9EAFD90888488CF59@CY4PR11MB1815.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZUQoX/b9SRPEkz4SU5bgNl7UKg6SsGeVi0603iC4BXlsYRrGGNtLFjeVCDG3AtFmWcFacEH8M25U4dEkZUk12zSApwmsaM8/njN63i6iZuaKh1XPf+V1FIIejkuSg/mmj+1LmJtHalAppLeF6MUDBgStn2dKupbaHVUi1sieR/utB43PhjfYkN/e9Ps0ZkEranVegFx+fXgu9+/xpGyCM1VMbyDEMSjTAT33EpzGrzr75IyiooJsvwPfqBKBbD7N4SDVFhJqafmCc3JLiylBuhWku7hfbxHPT+atXpUd0Un9o/7klIXqfiCbB+Zx1srfq2vh6OCdilnRAFwOpJEsM4E5LTaDI3dX5fOMx9f1QA9Cy+D3DC0pwPOAdEY7gVqTy20zxfZBKYnjQQ+ytjPNtOu55kLvjHD5CtPD+y6AfL8z6mLT8hRqSsyE3TueFA2PEbGOGWZjMWJJ6lhITdgL1dRpfs1sptMF2tJbGl01ftM1+fwG1MukWjxBWM3kX5ZjMOctYWA+DRa5IMpnsKPE3sbi6M0eAHEpVMuKOVNISIId9KRJcVGnrabylj45/rOaayqBDcDIAsyhdbBPj9gkxzMOdNPfFHn12tg6vmWW7F6tLQ21rTkSnWrUurvA8C2GVV7nLb4Bg0gXojB3m8yr0gJrjOHTW1F2Z30Ss1c4izXwfDnnMqXnC/pWfSFkpH2c6bGR6AzBPVOHoDCZzXe6FA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(8936002)(64756008)(66946007)(8676002)(4326008)(54906003)(66556008)(76116006)(66476007)(316002)(66446008)(52536014)(110136005)(508600001)(71200400001)(26005)(2906002)(6506007)(7696005)(9686003)(33656002)(5660300002)(107886003)(86362001)(38070700005)(38100700002)(122000001)(186003)(83380400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lqmNwH52aFF2S6Q5VSRQOT3USTLEuQ/yy3YD6cvzuDyZNCd8BAhQ6uVDAbJF?=
 =?us-ascii?Q?oFhN5BXM/AM84iAWNinrKfBU0akLC33YZx5ueHuQ2VbttUW+XXnYw6Y1Y/yl?=
 =?us-ascii?Q?wdmeeo9FfDkT+5JNtbloC0IsoAbQWyc1CT7Ia/OAVcwHoS4sqOCUXy4ckNM9?=
 =?us-ascii?Q?n7ucQOaYza+EKpc0nwBXfD9dhwaz56Hxv9pmIrhvHVRHSmesDkRGWAoeG/Gg?=
 =?us-ascii?Q?NxfGHs7bZCbNaRRKggBfQKAnF9wi0otfkME5aFGoHIScObeTsu/jwS0GmtHZ?=
 =?us-ascii?Q?grvD/J3lcfAKfXELi6nOBYoJTkhsl/G1wFhTt1LsnLcFOJFfh8Cr1yHWovnz?=
 =?us-ascii?Q?K6iI20he6I0WwK1p3o5aPcBZibjF+pzX9uNTThR4aCGOheMFQirZ0LguaPJP?=
 =?us-ascii?Q?DLSdDwEyF1pHgAC3zwwSNxQ5F8lAXS6RJZ830/cFwe29goKKrUQZ7pqY0W1Z?=
 =?us-ascii?Q?qgbUyfblzmFNVGkYE0z2dpEP2Vy1m0lJhcE/ZPfB8ll5ez+VAinyg673IWq8?=
 =?us-ascii?Q?U4iyOiWYu+BqE+463dWygoSAvSRDLFRkGPDyXIx97LdH3pc3AGddP1/1gmCF?=
 =?us-ascii?Q?9hxhbG5qCJqqrzYWob23yC06rzVvpQ4WlVgXRgtgCfg0yqus+QCTuJlcPSqq?=
 =?us-ascii?Q?9873JsU7sVi1R5GyzTXMXtWIh37KPg9/iqcCgLgpBtnE9djR5SiU6xYQ9pfW?=
 =?us-ascii?Q?AduSGBLFnkCVrBuceE4EpyPHVOI17gGQ9z2jkC+ezYfCh7pzklR5jpQ4JAcA?=
 =?us-ascii?Q?atKJRpPqUF4XlEwjS+9YRLqRZrC/fB/zQwFVkDep83p/pgQtSV1uEeNGkqOM?=
 =?us-ascii?Q?Ql6dro/3Cme1WuP6nG1V0u0aoze8LLCM59MZU7L3QZs4/dY7tgrZ03JRjMNV?=
 =?us-ascii?Q?Qa7Pu11QlHS8cJSsa4UpXzq3tX/FiaBCtNh1FFYbLOT4OHVx1N8X+7Qt0F9x?=
 =?us-ascii?Q?A6LWTmsrlRwfol+tU8UJRcKjVzHg6UNG8E97Ol/LM5Htwbi3wbentmtaO3e5?=
 =?us-ascii?Q?KBN7rhJOev04/ZmOmhr0mMJdTWVXjUHeWAXTN0kuWr7cs37SgfM71pdY1zTP?=
 =?us-ascii?Q?sHzDEgmcJf+Gpy/a+HlGd0ifTRtZZXPXYdy08f3r1o3n6HOea/honNzlZ72P?=
 =?us-ascii?Q?Pa+c+IcWYy0DbI2Xqy0l2RmPUGwzXLOXGGdYBeVBhMyYhKGMS+6vjZnW8HkM?=
 =?us-ascii?Q?WWDzg5b2iucRXTj1b7bzEZuc0/zXxQqRxVuiTctfRiAfu/YF4XG6/TlBzMcR?=
 =?us-ascii?Q?BwnxHS9CNQWaivUC2ACnsWOsCuGxg1Iy4oXqyAjngcOMtcpSEqA6BWk4wtzp?=
 =?us-ascii?Q?XKmmckSZWxmMEhYKJ3RPxm6tq2RhMRb0IROVzA7xhSMLaOpmCufnBF6Qv/kE?=
 =?us-ascii?Q?QzUKW5e7cHov0owvqSzPWKJPhQhVqC2QRffJnxZGU9XQqmLjQJCfP6Xcv7je?=
 =?us-ascii?Q?zgpGHLLkDfPH24bHH6VBr1GUDPEQnXyoFG7T4dGHAgYMhWGXRlpZEuhI1MVD?=
 =?us-ascii?Q?MCr2Y4DpSKBP/2F8ZtaXl8QrJI6Bl53LbGphzTSBlS6OV9MgCX3s+vRsb4uD?=
 =?us-ascii?Q?riDBxV+2AbInM+j95UN9X7dzqwzH7+VdSnvXCvpXzSe6oq2h/DgGunVeaV3h?=
 =?us-ascii?Q?V25+WG23Ixz2y/iZFRbKeo3q9N6FjDqHhrx4LV+tls48dHQdl2LVw0xwIHhF?=
 =?us-ascii?Q?y8Jk9l/1PmSvDfXSjKDnd1B6HzE3LBejj0L9l4Uk/LxJa8iiuzp9yedGc1Xp?=
 =?us-ascii?Q?9so36MDmfg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e26c3c7-6f4d-4d58-b360-08da2328b2f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:51:33.4300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XkGtbvCLD193EscqK8TKjJhFz3/rJmm3LTkvjfn+PdGsy1zN6/AvLK8geTI665i4SRA/GDTpFGZThE1p5m3DSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1815
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 21, 2022 3:23 AM
>=20
> Just change the argument from struct vfio_group to struct file *.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c  | 29 +++++++++++++++++++++--------
>  include/linux/vfio.h |  5 +++--
>  virt/kvm/vfio.c      | 16 ++++++++--------
>  3 files changed, 32 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index ae3e802991edf2..7d0fad02936f69 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2035,6 +2035,27 @@ bool vfio_file_enforced_coherent(struct file *file=
)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
>=20
> +/**
> + * vfio_file_set_kvm - Link a kvm with VFIO drivers
> + * @file: VFIO group file
> + * @kvm: KVM to link
> + *
> + * The kvm pointer will be forwarded to all the vfio_device's attached t=
o the
> + * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
> + */
> +void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
> +{
> +	struct vfio_group *group =3D file->private_data;
> +
> +	if (file->f_op !=3D &vfio_group_fops)
> +		return;
> +
> +	group->kvm =3D kvm;
> +	blocking_notifier_call_chain(&group->notifier,
> +				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
> +
>  /*
>   * Sub-module support
>   */
> @@ -2446,14 +2467,6 @@ static int vfio_unregister_iommu_notifier(struct
> vfio_group *group,
>  	return ret;
>  }
>=20
> -void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
> -{
> -	group->kvm =3D kvm;
> -	blocking_notifier_call_chain(&group->notifier,
> -				VFIO_GROUP_NOTIFY_SET_KVM, kvm);
> -}
> -EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
> -
>  static int vfio_register_group_notifier(struct vfio_group *group,
>  					unsigned long *events,
>  					struct notifier_block *nb)
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 7f022ae126a392..cbd9103b5c1223 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -15,6 +15,8 @@
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
>=20
> +struct kvm;
> +
>  /*
>   * VFIO devices can be placed in a set, this allows all devices to share=
 this
>   * structure and the VFIO core will provide a lock that is held around
> @@ -144,6 +146,7 @@ extern struct vfio_group
> *vfio_group_get_external_user_from_dev(struct device
>  								*dev);
>  extern struct iommu_group *vfio_file_iommu_group(struct file *file);
>  extern bool vfio_file_enforced_coherent(struct file *file);
> +extern void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
>=20
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned
> long))
>=20
> @@ -183,8 +186,6 @@ extern int vfio_unregister_notifier(struct device *de=
v,
>  				    enum vfio_notify_type type,
>  				    struct notifier_block *nb);
>=20
> -struct kvm;
> -extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm=
);
>=20
>  /*
>   * Sub-module helpers
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 2330b0c272e671..2aeb53247001cc 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -62,17 +62,17 @@ static void kvm_vfio_group_put_external_user(struct
> vfio_group *vfio_group)
>  	symbol_put(vfio_group_put_external_user);
>  }
>=20
> -static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm
> *kvm)
> +static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
> -	void (*fn)(struct vfio_group *, struct kvm *);
> +	void (*fn)(struct file *file, struct kvm *kvm);
>=20
> -	fn =3D symbol_get(vfio_group_set_kvm);
> +	fn =3D symbol_get(vfio_file_set_kvm);
>  	if (!fn)
>  		return;
>=20
> -	fn(group, kvm);
> +	fn(file, kvm);
>=20
> -	symbol_put(vfio_group_set_kvm);
> +	symbol_put(vfio_file_set_kvm);
>  }
>=20
>  static bool kvm_vfio_file_enforced_coherent(struct file *file)
> @@ -195,7 +195,7 @@ static int kvm_vfio_group_add(struct kvm_device
> *dev, unsigned int fd)
>=20
>  	mutex_unlock(&kv->lock);
>=20
> -	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
> +	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
>  	kvm_vfio_update_coherency(dev);
>=20
>  	return 0;
> @@ -231,7 +231,7 @@ static int kvm_vfio_group_del(struct kvm_device
> *dev, unsigned int fd)
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
>  		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  #endif
> -		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
> +		kvm_vfio_file_set_kvm(kvg->file, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->file);
>  		kfree(kvg);
> @@ -358,7 +358,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
>  #ifdef CONFIG_SPAPR_TCE_IOMMU
>  		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  #endif
> -		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
> +		kvm_vfio_file_set_kvm(kvg->file, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->file);
>  		list_del(&kvg->node);
> --
> 2.36.0

