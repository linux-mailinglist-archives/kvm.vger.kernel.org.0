Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7E74E702
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 08:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjGKGO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 02:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjGKGOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 02:14:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA901BC;
        Mon, 10 Jul 2023 23:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689056093; x=1720592093;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l5i0Xa4P0ItZXOFIZm4tJERzjODQkKvf93IVVETG01U=;
  b=G0N3E9YOtw7LvQq6q/fVlRbFiOHscV14XaesF/d4X0z0Hi/siXCHIt3B
   JwwPN5znunu8dtcrHPjhVto70yLBjyTyxV3nYqRfE8iJoX2gcc+1sSyPn
   5AySSHdIVOgViVgUmFfVM6ap+XqAU+x0wyDVXyObiMa8LWWVRM62HxGCQ
   4g8u2WURgZKf26xq85t6OkEdAOLaQapOK7h6lIrfhRjao11xt575HMeav
   t7aibERpCv4cRNNZV6JSK4RGStoUXMlmg7zf0WUxEkAzCyl6zWNq7Qey/
   FFoP9z9A5CqS4pdjqsCydMI+Su1ivV4COvn/7VGlNYmLYluaoD8SaZWEJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="361997435"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="361997435"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 23:14:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="1051640011"
X-IronPort-AV: E=Sophos;i="6.01,196,1684825200"; 
   d="scan'208";a="1051640011"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jul 2023 23:14:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:14:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 10 Jul 2023 23:14:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 10 Jul 2023 23:14:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 10 Jul 2023 23:14:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEqIumLvma3JtOU0Yd+4+Dv9jQq/E2kXpkoco7M0ft4s+9ZEwLsEvY0Xgz5AOzBg33T5pyc6PdGMXd5J5y3z/OMDjrOfsD0M5b8k3eyWp9CFQXkGVfj/ucGrNK/ml47d/eXIYMHWI0CgfOk7B2GRi0wxD5bZTG4hE4H3aIxG5ImLbxGM5S1cftcjHfcZ2nRrfnxctMbPw4ViZOkjOIGg5pnjri5xC+zhBPTk/DFjE73UyNiFFyqYCabZbg0p5+SWY75gDx639GhaEnHG+FxqOgxsTpgNCG58BjgVQ7jINO0u/vhUVwvD1t4DJ/siZFk9QmgRqU8eSN3CuKUVz1tANw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CcHCg2SffVyR3Yq5WlZlTCTL1MqlSbz+RPtbh/vCzM=;
 b=MXB/XB7W0XpgLk9u8XiWxXhOODYx91VpsDUFeW1sqyqMT30M4ARBUMm9SJNH+rMIECGtaXn6LULZiujt0MpaTPNMaEP/ObQDEj0bAYwMeFjEEkJGW2v2cZnd/DGOofs6jmep/JazuDEZOExPS4I8JLF5h7z3LFZIfv7fMtK2em5eBobmLGY/3QUMgfsudAGealf3yUIPr4HCzugsQAH0pW3XHLOMLOy0kc1Cz1lG31h0GkQ2OQlrGyEeUVAvtneevoeGkRfOrUQgz2a/2HGRbcktf1c4VpfAtPh/x4u7ifW/70mB0B6ZizOLxlB7Xph1lhnsrj6K77mDF7IcI7sHgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6847.namprd11.prod.outlook.com (2603:10b6:806:29e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Tue, 11 Jul
 2023 06:14:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 06:14:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/9] iommu: Make fault_param generic
Thread-Topic: [PATCH 5/9] iommu: Make fault_param generic
Thread-Index: AQHZs5RHv1DdatEmukqpigeHJWriGq+0FnVQ
Date:   Tue, 11 Jul 2023 06:14:42 +0000
Message-ID: <BN9PR11MB52763F7A1433C73CF6589F2E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-6-baolu.lu@linux.intel.com>
In-Reply-To: <20230711010642.19707-6-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6847:EE_
x-ms-office365-filtering-correlation-id: 84d65bbb-afa8-4458-a02d-08db81d61de7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /KO/+dd1wBO300w8DALXx6yxuwoa64Umfsb62iift+jH8OhYEA7RaLYTCUxuEevPRxdUi9HNCXnDdskfjgePnl+/XcaTJuT17MRfuOCqQrnAW7oVn3T40smiTb96Uys/S/Kqz/uli1Ugl7eqyxBiQXbNrbZkl46LBzEyt5YVVcWkdNtg8A/2iofPXhOXwIumSZK5ZiCeZSczGxSIVpZYaFoQfX/idtelH4U08mfRWLGJiVObqZLqC9i8dpxlTO5cnnWT0mZ/TgQk1wvTmROFxgpQmnPAWsEzKGjmfD2DFL22bvCkjnCuwT23ySsLPHEgUT6h7CooAt4TjSvPs+7YPBrQRkRkVOcTOzvYb6b+4XgsWsboEeQW3iIdPCMZIte0kurto7MHvTB49tflq6KPaY/vJrNttPVQ00BtFBeLHJfXNLJyEd/TMWyEpNC5H1d7Ipdtk43RVvPHdNDivhhXENZNJ2+2hr7HEUICY1YpQuoDXEl4p/Wg0T2qDmEEii+1vDxzyECa3ZAQYCcK3dlmwLPSRsRmQU7fKqy3mYOeT8FValpeTl394Bo/L8BYTVb8iojVFl2SEgIju8X8fbq+0wWL9lbXGVJO74SWeoWBITjq+N2Fss50Jk3gUE8voyhctWdoAA6jdERAI6K0PFQRyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199021)(7696005)(478600001)(71200400001)(110136005)(54906003)(76116006)(9686003)(26005)(6506007)(2906002)(186003)(316002)(41300700001)(66476007)(4326008)(52536014)(66446008)(66946007)(66556008)(5660300002)(7416002)(8936002)(82960400001)(8676002)(122000001)(64756008)(38100700002)(86362001)(33656002)(38070700005)(83380400001)(55016003)(4744005)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yfw/rNkClyF5HvethVKMCjkS550pltRj20iP4m4TxwvOsD//CJs2cOrIpedR?=
 =?us-ascii?Q?AYKcdwkrRICWvTn61zrgV7ZywrbWiWqpjArtZL9iz8A1Kqf3V3nrwiCFXsLv?=
 =?us-ascii?Q?po14f4Hi/fVd0uls7LyphxA04zrVf5wIx/ey2fsIqyVoJ+d7E2LmGjzd3npa?=
 =?us-ascii?Q?rTXWd3u01HtDk7cWdBcw4sawcM6Naty54gHgiaArut8Y7LSf0R0pGbIEpUb4?=
 =?us-ascii?Q?0uOdAKQm0F2XYuahP7fXLU4gyfyhagsZZzuB6zBbof8ED6lhSTbSCDLqJnnD?=
 =?us-ascii?Q?V5DQogSFGUfq2YSeTCVf1ElRUtGaPP5w6YSdaWXLzuAIg6G60DmPbSdcVaRA?=
 =?us-ascii?Q?KtyoktbipjmwWj6arOlIsjphvpq/YwlrFb1XRPBcBK8F2vyzwNe6vM7oM1iH?=
 =?us-ascii?Q?Px2rEZ7ZzrZudDv8cBtV8ay9kfLyVa6rKFcqESTjoP+vgKnCAsmI470RPIrW?=
 =?us-ascii?Q?2/WVaUoUimUtHJ1ILIdag5542ad6JH5X7GIZCrZrqg3QD4+DKhvplL8xN6wu?=
 =?us-ascii?Q?Cb+F0E0aX7wG+phqgpH6MMO1VME5VeMSQFSpZHyamZo9eVYeg8oRDd2rQ0AT?=
 =?us-ascii?Q?ogtxCbWUHKU7+TH6/y5wAEe2NJkZn9/y9bEUBRgdY4Ad2XMeyEmtobTzYw9A?=
 =?us-ascii?Q?yF5GYebEoTnZyoOtANnIA0lxS+bLp7cdwF9WPxd72d4QPOWc+gM9+ON0Mdg8?=
 =?us-ascii?Q?tf+pbROF74Ew4Js6PG5FRh5QFwpnAp16N23WPIGma18ZKjkOVDRXaZU7FMDF?=
 =?us-ascii?Q?l5nVsgkbsOCa64lzzUulU9jBKnz7XP1muQARoaho5aOcRFarR5PIb3GFLtTe?=
 =?us-ascii?Q?KuKcBbCMw5u+xnPJXFwHIEU/2VFE8ATLQQaiub10y7dOgldsrewV43QU8V3o?=
 =?us-ascii?Q?QiGSOi0Su0XpArjCbh4ZeymM5uAtKiv348+9zl7RDYKPED8Wc/gCmJ1FeE/X?=
 =?us-ascii?Q?gTKU+RKUqZLt4eYSIov7mbRiFEZtbiXOB0ObJ0SBAzw9s5sST9qaL+uBb/2K?=
 =?us-ascii?Q?GwFD3j3SEtCowN4HN3bftpnr4jIBDVy+CosxfGsGbW/X3nmSNKJO0DhVzORz?=
 =?us-ascii?Q?HZ/GOsieucB95w+YzhiCmjUQZgSGs0I79rZK+LXHTZ/7a9Yl0XBeQxUiCz70?=
 =?us-ascii?Q?PTSsn2KH8sN3asZISaBrZ/aElYw7bR5JFQYdsCqJACLF5hStuYf/Dl9+D3ll?=
 =?us-ascii?Q?C0YGygGhewG9NaArI2SEQfg0dj3EbvERvQQ5huv1IdZ0a4m5D40niQjOl9BG?=
 =?us-ascii?Q?76jaSjn8ox5bxI6JGe0HbMmgeeTMYdAFn4FLWaYr62TbftspKyg7kVDHSggy?=
 =?us-ascii?Q?QQiEAp5iri84wS9rCs1FvDmFH7KslP4SQNByL1lZbOdNL8pnvDqMlmS7i5+A?=
 =?us-ascii?Q?DpKf2T9aV8A3sd3OFuJFJKjKs76JnU8h+JzUQhqPzC43U414+U0emDUoBDVg?=
 =?us-ascii?Q?HOozRY1mvkGmvkfbFdlXdraKZhThrBww4eLFhynlmSdiPNRW756Mw7yqJNcA?=
 =?us-ascii?Q?C1U7MmHc7mYcrYbaEFWnAF6TKs4EOkW07J/icAjnGpPGRgeEKAuRWBWDRRd7?=
 =?us-ascii?Q?cXxegUxEdVSUBQKACODicg/fLcddSbCJC44gKs90?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d65bbb-afa8-4458-a02d-08db81d61de7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2023 06:14:42.7737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NcGo4E6hIkNomILy2MN/BPS0Anl4PfChC2yservpMKrfQhX9mRMKByLCT4RI0XlALc0n2RHF/3Lzw9DYTEOQgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6847
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, July 11, 2023 9:07 AM
>=20
> @@ -299,7 +299,15 @@ static int dev_iommu_get(struct device *dev)
>  		return -ENOMEM;
>=20
>  	mutex_init(&param->lock);
> +	param->fault_param =3D kzalloc(sizeof(*param->fault_param),
> GFP_KERNEL);
> +	if (!param->fault_param) {
> +		kfree(param);
> +		return -ENOMEM;
> +	}
> +	mutex_init(&param->fault_param->lock);
> +	INIT_LIST_HEAD(&param->fault_param->faults);
>  	dev->iommu =3D param;
> +
>  	return 0;
>  }

Upon above changes is it slightly cleaner to call it dev_iommu_init()
to better pair with dev_iommu_free()?
