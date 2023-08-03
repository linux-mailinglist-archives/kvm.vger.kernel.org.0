Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A1B76E2F5
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbjHCI0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbjHCI0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:26:04 -0400
Received: from mgamail.intel.com (unknown [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EBC5587;
        Thu,  3 Aug 2023 01:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691050880; x=1722586880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6qSwiQEsUU8xccxB3B06NZFjjhdA3H4clIm7FpEw4G8=;
  b=Mt4MCCb5KSzxpzrNenAje/KTCl1YjQpjJzAH9gmy0SLRVf6WuHxejov3
   aC4we2D0mc1KkQ1vxk1i1HAkV/abm3rLu45dTmnLsZP5z1KXW7g3/Hasw
   UEr9klIwCS15C0BpuTE7m9FZYVv+J4WIUFw8EkrJt/6qVK0d5lU1d7PN7
   kDo9Oip2/BbsbII0LFaoIrA3zp9Rbyngj9B6HgzBR+lbfTWAMQKiUyrnm
   VLYzDZpwMVaMm8Pg6Dt7gT8c5THI4V0s1snh3sLZrXoyuVDHkD8m4mYLG
   iHeWb9LPgBXDGl5sce1Bi6H2+TEdv3CuWIkLaOAX4NViuHcwwSDO+N2B0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="456183760"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="456183760"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 01:21:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="729486927"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="729486927"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 03 Aug 2023 01:21:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 01:21:12 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 01:21:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 01:21:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 01:21:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8KDZtF22xnyXs5wtITPf+Fbc8pZfblfQA06Qp7N2a9WJ4Q137KPe6kzU+TouyF0RGphpOVKykeSh5nJXsgs7uSkSkZj1lEbyp9SUSFfjcXH3ZI6aFU3gN2KJxrwytaWbmEVGFm+1Nw5Pq9jMyHXKcrUwaf69YVn77tZlv9D/2NajB4QNrED06HnEjQUvR++Ndu5II+obwZrL7RTUNMZKRJpTJoEYHBwZx7NuCtRwiQjc3t05Hf5pe+tjAToOgZGNB9mPHJJU2Mm+hFZeiJWrJnmlAD1scExPkWmmVd0gFakW1cHvb/aZgbqGzB4FknbFMqvWJ7tt+X/3iM3IqnE2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4N088lbNJFwTnMXVlORuFDzNJGk7ptpWs9Tz+soC1Qg=;
 b=kxY+/q90T/NwtWb/U9RMzPDijht2MRgFPKKqHpoxXNMjk0ivkWyEADGPs4f5Rt8Ac4Gr5MnOzqP/BEOWfGKKatnlB8M2qDI5wGhKhsNhIMk9iJeFXdE5Y8lJO9+oZTa7+rNVcva0h3xFzqR+rKhMXVyGKeMszNn36YLAB5fB0uoH8YFoY23BCHspRyWJcN7vgQ0QY1rK92RJLvP0kCpInhKxeQ4F1u0/xZKdTSqYHMg7T5lJF8vRnGlE/nE2v0HGICDtxNdzZ+lspXIYLNRI6EQUPV2ejoUVzFzOdpM+ZyJ5zZLEc+v7GRlTHgA9aRiunusbl6I8ocRUFNASJJMS4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5226.namprd11.prod.outlook.com (2603:10b6:408:133::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 08:21:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 08:21:10 +0000
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
Subject: RE: [PATCH v2 09/12] iommu: Move iopf_handler() to iommu-sva.c
Thread-Topic: [PATCH v2 09/12] iommu: Move iopf_handler() to iommu-sva.c
Thread-Index: AQHZwE5jBtluSn/9HkqmCn18ZBTnja/YRTEQ
Date:   Thu, 3 Aug 2023 08:21:10 +0000
Message-ID: <BN9PR11MB527611063D3B88224AB769B48C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-10-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-10-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5226:EE_
x-ms-office365-filtering-correlation-id: 463e35fd-9458-4ba3-6840-08db93fa9821
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ttD83ldhlFIU1Ot/vn+plF3k3JU8lcYqa4tyJeP4Chw8sooCdStGTLJq29Gfplx3KgwHzE+V0aKlRFYeVgJO2QJsIxFjv8wzFW7kRlBhXPwdhH86BgNHZnrFapQ4IxtuUXlBNxssFTO1+RYs0srefeyoRLgYVC2h4BAsDa8Htxb0g9cYvw4S9qJLlTDOP7E5eHdexX0nBh/GGGBCZaSkZoCd3f36qzOET7us6He1QDpT93QlFthyua4BBCXRZ03ZaGEljGrWS7E0GYWZ8A+MDBAoMrppVaN6EYqeRzLocCiqZdef816yr5kYSS0Wg8NVy9ROg19NyKiUchTI1UNL3Ap51yL4vuRxWnPliYbIPxUP9omJ9vEXBGeYQ7mcYemZa3YLEh4YSSF+Wh2K4wihCvSl3XJo2pOVPNLqbns5yIOwr0/C6DeGA7Ppy2efEOr62/Erk/lY8Jnfnd0B+cI42G/bFg6cX3odbDqenzzed+epGwG2kPFR0ixMED92dSVh1IAguKK6Nx8g5Od7/A4oO2dy/mbeXbWcgQzH4j9WqkyWjRd/6pKyDeYDluO1tZs5ggSqak6SiryUS46QU72sGRFQEoUlWTX2b6d4J85Ht6kqgELagNIX9ww/t/KZenNt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(6506007)(26005)(186003)(41300700001)(4744005)(52536014)(2906002)(66946007)(76116006)(4326008)(64756008)(66446008)(66476007)(66556008)(5660300002)(316002)(7416002)(8676002)(8936002)(7696005)(71200400001)(9686003)(478600001)(54906003)(110136005)(55016003)(38100700002)(122000001)(82960400001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Q9mtya4hV9pDtkeXNA+jgFTeQS01XzjNBuwxnpbWYp3HhJz8KxAED29XeVJ?=
 =?us-ascii?Q?zpo6D1Se1+j1niOKlRiVYu5OZ32Q9qdNrlLp2MHd9j0n+6SuZxf8EJfSN99z?=
 =?us-ascii?Q?H/H0MqtCbzcwduHm1QfHT3OaUeUApT7ovftKDKwZ5/e1NoGHKCVjzbCOzObN?=
 =?us-ascii?Q?1275VofY3Wa7NyLbApnUSVTryigHt74l2wzHIp2yNZtnGnhgRLAKYg5BJl3E?=
 =?us-ascii?Q?odaqh53zVRZB2AKGym4IcxjG659HOAhWZSfsoOUVU19mVDwZvKP13/9TYss4?=
 =?us-ascii?Q?kXw2ShwjeJeWchV9RcLbeYGP4aTRCh71caAgJ6TnSn9kwfdqOz2Iq3vFmkAm?=
 =?us-ascii?Q?a7QW0qyWMTJcsnMdJti20rmOp0evLvpUkvxCx+ySAew5fK406vrdpfTLGyps?=
 =?us-ascii?Q?ScI/5KWcdSQyfqKhjFMqdNp4099jdPMaNrIiBKpAXUH+A3BgwuBy0EDbUMSu?=
 =?us-ascii?Q?f8apq/O45ok5QNhS5rD51CjPgl0rSS4wAlBiNyLkKowRnmvJ5m+U8d8oAZ+/?=
 =?us-ascii?Q?/V1c6suaixX3JfNsF7G4l7HDixpP37mOuGG2Hj1A8VI+tZ6RT1KrUgCA05M8?=
 =?us-ascii?Q?UHGRR/OPj8HHTWD2YbmzkXtDA3GhXjTYXf6/GRa4MkkLI9Al4t6bMluAum2I?=
 =?us-ascii?Q?dXZLF/cU4NWbV0aj1wL+AsTwWMhrj0CuAaP3EJRoICwjCeoHWMQ29h4zEVkl?=
 =?us-ascii?Q?Yp/G8jc5QDMsR3H5Ta0oCTufqQOF9rKy8OenD9VsJs/JQEFPxwWSgP+7mf86?=
 =?us-ascii?Q?OlAStWu+5NcaWM+ZGTjzJZYU9AmN3m8wHNaMHwRZRsbra9gZQafeCFEn6pw4?=
 =?us-ascii?Q?AHnJ9PgHUlpGTDaVD6oiTVg9HYg2d0459d5S2oBvhX/xN1lt/aEpd/aiufEC?=
 =?us-ascii?Q?PBHf1wRxag6LQEGxRJqpB/Ccnz0ATFOQMdK5NVzuAnChDiVQx9xGa+HV9//Z?=
 =?us-ascii?Q?bDyCPzBbqmcJwZndkW5PQGBuHY1VgJ5k7ZlKKxx6fzAh9Bm6xvZnn2kZwvCP?=
 =?us-ascii?Q?+TbEh26urLka1RY+7aOlkA6utNInWAGsMbO5NCpeQNaaqvL9Zg5+4WSRsl4b?=
 =?us-ascii?Q?GEB0rMc9DpUFcKyLCJfHFRskcfF0sqh6Wn84sc3TUAmnDk1/yQc7q/JSwEJ7?=
 =?us-ascii?Q?M+sS26WqRGr/UvKFtyT/bFHWIZKq0cggzxjnwyKVnetIFafCjGm4+BaqV9uW?=
 =?us-ascii?Q?0TKxT0XfNMXWud2nXGN5g12Vyz2Kh8v8AZWde8dN3BdoBMoNI+8hgTFc2CJi?=
 =?us-ascii?Q?cUQE35gO9BHIBfZOK+cnywkCU4zYDDAhbr6EBY2eqHCuwpJgVQ44N3BcnN4p?=
 =?us-ascii?Q?rHAtlg0gz1Vv05aJzPjINNefFT8K9ZyzyRO9C8WYMzycXSEKKSDra+Vo8/00?=
 =?us-ascii?Q?L/w3S/9adPteeVnkSduhVJ+7GkbOD6WUAVg3pMPHDU3Tu9Y8QZmyjMcIXqXH?=
 =?us-ascii?Q?c4WZOzMxW5HCEfAo+n+JdW7BvrPuKvTskvL+Xe4WLTL+wItx1MKr8hEyneym?=
 =?us-ascii?Q?qAjLMvo8BLXaS6Np7UYEpELUB/cO1VN6abIeKRnBEcYqNQxruV2rrEX0qeuf?=
 =?us-ascii?Q?j0gAbBk/weJVVNKa6RR1F6xCEqb/w3OUCbNTIyFR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 463e35fd-9458-4ba3-6840-08db93fa9821
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 08:21:10.6459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XmKgudVJ3SI/AtV4XTJUoAXaiI651TMeM69ShfDZFb/D8p8DQusQ38NDHWy+LPktqcCWBJXkv9iObDnUNZuQtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5226
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Thursday, July 27, 2023 1:49 PM
>=20
> @@ -219,3 +219,52 @@ void mm_pasid_drop(struct mm_struct *mm)
>=20
>  	ida_free(&iommu_global_pasid_ida, mm->pasid);
>  }
> +
> +static int iopf_complete_group(struct device *dev, struct iopf_fault *io=
pf,
> +			       enum iommu_page_response_code status)

iommu_sva_complete_iopf()

> +
> +static void iopf_handler(struct work_struct *work)
> +{

iommu_sva_iopf_handler()

