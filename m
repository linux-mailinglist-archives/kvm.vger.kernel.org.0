Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0267AD0F1
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjIYHBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjIYHAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:00:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9622B10E;
        Mon, 25 Sep 2023 00:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695625246; x=1727161246;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XmT1UOakWGE3AyQLJPSxxz7htZUJNJMNQOzM+gfcBDw=;
  b=BTbgmKpsBOLtPV/dzFxfav7nrg8kg0PG+ryhTMNyTEQFwpmNmoErcGbX
   i4URT4RcnPHNfOm9oZr9TE8sntZdiBh1uOBBduIcL7fJm9w0QoBFp3644
   pF2NzGq2ToncpQiwntF087fgg+QRzfNlSiRJGtNKN0y7y4i3VnyHd+YbW
   k/BJwohDEWd3TVrH1HBvHC7hkP+Qlp5auyTV18SiEoz69WevFAD8QM8mv
   Prp4IWUmG80LXn8LGfgB4PvflnRUgi4s5lVbBZ4LMzDs+LcEfpjG5pAYR
   NcnjcRyB2ERHTozJg9xGgLpBbQ5I1er/rV9hr8WctNeb+Gz1k4UNMX4Uh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="378452379"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="378452379"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 00:00:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="813827973"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="813827973"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2023 00:00:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 00:00:45 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 00:00:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 00:00:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 00:00:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TmdG3IU+bPoUWlLOv07H3ijPg73fzjY4xTxWXfXxeoNz20L1F1Lv2JJAaH/rCOwLKNj35VGFlarB5Siim2nIroh9Yx/+BNfZSqHaMB8PGdBid8nDbVcIxIDY7X+wwACzN0sFMwaW38Jyrca6VwJoWS7K5fOTxdSA2MKPdh4gtnL/iAdKkvXZRT9ouN87BMv32YelJxiGJ7R9AggEPDJWxYC3WdakV/GcRXRFkUs+zE86RuCi0wUhhlKQDo5JMK4PT6ohKOel/xrNi3krpWM6qdHrg3WUyVFPNBQlFBtIBoESqkodRyvlH1PrCPXeNNLXy0hrN/rw7FtSaeTnjBxtwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+edLGLqNUJiXfcJGM1pg/pNI0cEi+EMfXoX4YS9/vc=;
 b=Rt3vL1xrM5tIghksdRJ6gHezLvoWtwauFAg/3gZIIuBL2x/rHbAiCVeQ9X8ngkjKbhrvQGEuKPphcy4At3mcwUkdVne5TvGMUQeC6UJHl36JPe/WmtHFtBMIS/UN818wHRXgfWmuCKA5PJ8xM4UXN6dHEKoURzfoIy4PgvNkh+m/7hzc1a3MqhvzmzMd/1w1XzLdhSE7qPitz23CkEzJCV7O/koe1wq8M9R/rD/NumUlMoIvOGbVNwHbY9s6bmkegzFnWJ5nnWxXpz638Kd/WhnwVXqNUyq0BLc5BJXJ7mDZuC7eUAdbeOG08QSS8LtNVNEBAkzqOD8Zp8fCFo7TJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7934.namprd11.prod.outlook.com (2603:10b6:208:40d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Mon, 25 Sep
 2023 07:00:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 07:00:43 +0000
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
Subject: RE: [PATCH v5 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Topic: [PATCH v5 12/12] iommu: Improve iopf_queue_flush_dev()
Thread-Index: AQHZ5un40D2tpmzdOUyPzVi0H1ZCHLArLI+Q
Date:   Mon, 25 Sep 2023 07:00:43 +0000
Message-ID: <BN9PR11MB5276E30109C63D06675042758CFCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-13-baolu.lu@linux.intel.com>
In-Reply-To: <20230914085638.17307-13-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7934:EE_
x-ms-office365-filtering-correlation-id: 925e6696-64bb-4638-f2a1-08dbbd952299
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Gu8ckkZODxLruigO5ASbdbM5DAaBUT5rP5eb601MzmCOtMySUr2mh3jIqvO9SZjiHzymoyjM7jp9DmWCjuuTi8tgKw+24RefbReg0ZaLy7KZZgh72CwHnTU1e33Wtb+2wTS4cuvmjfAPR4GNlWo5R5xQWxDpmzhG21Wq8KFlkduxfxeSN7XG/wnvrTWNIQb9v5kueZCxQ4fhtkACREDEk6V07nVmLv/N3Y/rr7L1+nc7tXYMaFdeGP9YRn4QZviULjBlnQ0eTa/0JdLkxpqOt/i+n3SjwhJvBgMgGuqE68tmt7zW/zfKNouuiFSWwGwRZo4gNAGBuMpcnmOX6pGARVbGZ/XzK5R6edNhDr508LHQ7UbLwxY/nTawGvQ1V197DOU1eEXjaq5SR2CA1R4m9kbgKnFROv/PFD0fLlX2mqLyZ4bTwCqvUKF4UJwtsZrh2kHXt5o3Y7iOx0OnE1SM7k0rIzdeSyEmg+kQUHPtL1uesY+wN8emXM/6iM7pm+gPGRIhJq0wmX0Y3CdqdhpSX7YwqElaR5XgyUp1C/VITr9wWjJqtZmy+9rD34dfUa/gx7IyLl9oI4pNCMmpz+7BAmrtS6CwYsEemd6zZw0Fq8BcP1+rdme9ZGJ95L/USHb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(346002)(376002)(230922051799003)(186009)(1800799009)(451199024)(55016003)(2906002)(83380400001)(7416002)(38070700005)(82960400001)(122000001)(38100700002)(9686003)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(110136005)(76116006)(71200400001)(7696005)(6506007)(52536014)(26005)(5660300002)(41300700001)(316002)(478600001)(8936002)(8676002)(4326008)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BU0Jr+GJ3HsyMZPgk+kPRh5qcG0XdWgvfra++giPBgsizSmAsytWUg9HkHU1?=
 =?us-ascii?Q?p96ugXfUdGBX2KEOULvAI9hFlMtMRxw5LXSUqKQns/2gnvK/n4Knxbv7BhCq?=
 =?us-ascii?Q?Nrr0E13QYxiQIRNoJFFKfmCRU38G+JQAoYnWk3uGs3/Q4aZJhe4vcN/f9cDJ?=
 =?us-ascii?Q?yOiPf5X/AOnjLDua9WtRUF0cCbCw1qfaBS46ax6BImnKDLpw5Q10/DpOi73V?=
 =?us-ascii?Q?c+hj2+c264wHn9i0cSToeH9ptwn0ygIAh/93chUkNzhxgzeDYRFDkdAjUo+u?=
 =?us-ascii?Q?2jfOdkAHB1btl7H38pD/8btL+aPFfuOHD1MQjYqbbMjNshA03+8O9PNFgJfL?=
 =?us-ascii?Q?bpWpTu3vGtK4uy945evd9nOlbYXiKzZZ8T9MBsyCXHNHMVjaYlkaNoJ3lckL?=
 =?us-ascii?Q?0FI13TQw+FDEhEAsQD0he7QOcvr7AXl48STVtSwAnvS+RL+27vAFQ1g3nGAU?=
 =?us-ascii?Q?OElx601tlZGX/DD2wd86UHg9fhro9t69EZh322BgjXD09iIlDVZa4SDi978P?=
 =?us-ascii?Q?IABXhoVHsUdpK86yKx8YRHBpySZ+sr22epWFtfS3+C8Cc5bqA+zNZy1KWXLb?=
 =?us-ascii?Q?7lceqwO9Qkz52MWKiei3vyzTHKOPfVdq34eQfX5LIeMRKS4uLG4I0UFBDQAw?=
 =?us-ascii?Q?RQZI318lTtvkf/audHix247pBD62E/mINZILc2Nl7qAd61jU88jGO5UWaXqJ?=
 =?us-ascii?Q?xGhIHsn1JSOj1FWbUvSmM5sJa//jMnM9X+LJlkgyADM7906tPaGzPfkBCN4u?=
 =?us-ascii?Q?GL6LURFEcJaazXT4Zcy8XsL8rk7iZ7JPlHq5cbfO+bKel/Mpxb7z4lY/52w/?=
 =?us-ascii?Q?BGDWQ02rkBrm9TG924UwoCQ7nlgz8OGZefBkArf4PTdIww93ZvrZ2k/CBxgN?=
 =?us-ascii?Q?YOr9dnrPGwR2ayGnVEKNdHVOkUG33vvNjddO5dHs9tA6ILuPf8lBd85srRJy?=
 =?us-ascii?Q?1u11ICbgSmVnmm2MgbOsOwRpNQ6lDUccI6SY/cY1OH/CmDrSr2VTkty4lpoN?=
 =?us-ascii?Q?LMz1pahUNwwE2f5M6+moPr5Ixj33+fOdMEpgiIjBgMPBF4VoCdVK7rYQ3JPd?=
 =?us-ascii?Q?RKN95WFp4qOavCrHr0O6N/22mF8KnSdHxAKcaARQDe94vMzVoq8qrYY9Ml6L?=
 =?us-ascii?Q?trUtdRjOHe+p9lc99kgBz3AlweIqrc4RfYIEbcDWpqe/sD/fulH7TFJzxjrs?=
 =?us-ascii?Q?e1KtLxdFRkCdtHwA5yfO7ZJXGSFkZHp80MDIETpXW32xssqQILHxiyUr8Wf3?=
 =?us-ascii?Q?xEri5kTeKkZcZXfSuno6SzATUCHfrKozlECXKg97Z/FrRl9sOFMhJeh8MleC?=
 =?us-ascii?Q?yeaBI14bLDKWiaJgmp1IYT54B03ousW05Z7NzTntBQYHVmXP2prjsmsT2A2S?=
 =?us-ascii?Q?OCZ53wiEs8+4r2Sfv2S4W9r9DwEvZdjAkKFtf+644GmuhNDsft3i1un+mNLY?=
 =?us-ascii?Q?8YEIP6DDHIQxtplWjr/cN2JIqpbSJOKzz1RqAuoExUAY255Rm13mGsKgvMRO?=
 =?us-ascii?Q?5k0soEBNxhIs+8IRMBvRjIvVGw/DWNZ3BaHdzsPr+oQG2Fg5m2JgzkD/jiys?=
 =?us-ascii?Q?u97WbnTfjUpq8/pS1Z8YfE7B3J2kYXitH9hxPTxw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925e6696-64bb-4638-f2a1-08dbbd952299
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2023 07:00:43.1182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WjUykPxaCnuYyS1Qq8L/Vx2X1aQMfOAZiX/5bbVkiiBRebmOWcm8KA4uFY390NefkE3F9MBH5sMtB8cgCqbwSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7934
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, September 14, 2023 4:57 PM
> @@ -300,6 +299,7 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
>  /**
>   * iopf_queue_flush_dev - Ensure that all queued faults have been
> processed
>   * @dev: the endpoint whose faults need to be flushed.
> + * @pasid: the PASID of the endpoint.
>   *
>   * The IOMMU driver calls this before releasing a PASID, to ensure that =
all
>   * pending faults for this PASID have been handled, and won't hit the
> address

the comment should be updated too.

> @@ -309,17 +309,53 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
>   *
>   * Return: 0 on success and <0 on error.
>   */
> -int iopf_queue_flush_dev(struct device *dev)
> +int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)

iopf_queue_flush_dev_pasid()?

>  {
>  	struct iommu_fault_param *iopf_param =3D
> iopf_get_dev_fault_param(dev);
> +	const struct iommu_ops *ops =3D dev_iommu_ops(dev);
> +	struct iommu_page_response resp;
> +	struct iopf_fault *iopf, *next;
> +	int ret =3D 0;
>=20
>  	if (!iopf_param)
>  		return -ENODEV;
>=20
>  	flush_workqueue(iopf_param->queue->wq);
> +
> +	mutex_lock(&iopf_param->lock);
> +	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
> +		if (!(iopf->fault.prm.flags &
> IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
> +		    iopf->fault.prm.pasid !=3D pasid)
> +			break;
> +
> +		list_del(&iopf->list);
> +		kfree(iopf);
> +	}
> +
> +	list_for_each_entry_safe(iopf, next, &iopf_param->faults, list) {
> +		if (!(iopf->fault.prm.flags &
> IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
> +		    iopf->fault.prm.pasid !=3D pasid)
> +			continue;
> +
> +		memset(&resp, 0, sizeof(struct iommu_page_response));
> +		resp.pasid =3D iopf->fault.prm.pasid;
> +		resp.grpid =3D iopf->fault.prm.grpid;
> +		resp.code =3D IOMMU_PAGE_RESP_INVALID;
> +
> +		if (iopf->fault.prm.flags &
> IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
> +			resp.flags =3D IOMMU_PAGE_RESP_PASID_VALID;
> +
> +		ret =3D ops->page_response(dev, iopf, &resp);
> +		if (ret)
> +			break;
> +
> +		list_del(&iopf->list);
> +		kfree(iopf);
> +	}
> +	mutex_unlock(&iopf_param->lock);
>  	iopf_put_dev_fault_param(iopf_param);
>=20
> -	return 0;
> +	return ret;
>  }

Is it more accurate to call this function as iopf_queue_drop_dev_pasid()?
The added logic essentially implies that the caller doesn't care about
responses and all the in-fly states are either flushed (request) or
abandoned (response).

A normal flush() helper usually means just the flush action. If there is
a need to wait for responses after flush then we could add a
flush_dev_pasid_wait_timeout() later when there is a demand...
