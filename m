Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C5E776E7B
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 05:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjHJDZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 23:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjHJDZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 23:25:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2B2FE;
        Wed,  9 Aug 2023 20:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691637946; x=1723173946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4NFdjThUg2fMwc91dAZkVxGQkw8KgZzq311JwlXrH1o=;
  b=YXz/BA6ZQ4jx+7qkQ8Gdtq/iJi3LeocTodKV703/4lyYaQjUIgo9u5Px
   Z1vp6KKXOqqlKTnjkKGjcBi2kypOIjTPl2lN2jRDmb3lZPIGA/hP7ynk0
   0jJH4BaTJSXjlhcYyW6SwhxFQdDxmB5n7Iqv2lCjmIQuvosrmZ6MbaFn8
   oKFinw67EqPIB9M9s8QmGFuCMpRpVLcVTmDOSXgYAOgtHSpmgQxKSrUp6
   eYN2GnbNJKxP+ibhbrElOVhYH0CCeUv3F9CnKUiuSWMrHHlD7QRe//Vry
   T+gzB7yMhWARNq0zTxKjwLRTHJKUcCL/gKcxxPw28NqPYhq/KW/wag1QD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="435181775"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="435181775"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 20:25:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="802005995"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="802005995"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2023 20:25:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 20:25:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 9 Aug 2023 20:25:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 9 Aug 2023 20:25:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 9 Aug 2023 20:25:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PdPOwaGNtBmOf4gtFdLa7EZRuInPAcyxVaTZW6tN0tW0QVBUzIiA7uzdhQ65iP8DYR9wFZWTO1RBKWRX1dyN/yZS+Pn02AweF9Fu3NDfzV8RLLnVT0hLCsYouxEOgKAQxtLJwVi+XdeCsFH2OpIp165M8dxNbIq5NOPwlsYyUtzXq/9YsrjQAi6TvHnJokfx4XD0fufR+Wyaww1SY+DYVVQxyaoid2S+zlYFtappX1uAYtHnmIMfV/FDgUOtJRBItxth3b+TBfOJwbHJCC7XWBqcl1DdouK7Lnukl6FfVTF/0cLwzk2mzMMzbSgwswQpNhIrjChVp7YJoAqqs05+8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TV3PTN39EjaTCRcah0QV2FIb6/fQ9439uNzzhJr6gf0=;
 b=oJxjJZo7dCmP91SLvsG3xdSStf53N10q6E+83ySC89uI5HHICRX6TBPzzItqoi6LQLKUx26l1wqq7r3J7yxSB4PGvjzxhUXY11ek49v7K6AWJagQesq1hhxbQWzQjz68bL+UKbejo3gnZaQml7dUOaXzHP3ZYdqgjIIcjg/vo78AT43Lde9Gbo+P/6voQMEeq9yxs3sZrZPIJyXqQKmc7Bo5H6CFc2tmZd4/TOkxj7zkDkfYcwnh9Sz+BRh8DvuRVAMOpff/VpfAhiZl9jmcnnPUjepdCnGnwM6FLVsZIIRAsBegqRKQSALmhRDoqKGh4MXQ9nqUL0ytVNAfh09tcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.30; Thu, 10 Aug
 2023 03:25:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.029; Thu, 10 Aug 2023
 03:25:37 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Jason Gunthorpe <jgg@ziepe.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: RE: [PATCH 3/4] vfio: use __aligned_u64 in struct
 vfio_iommu_type1_info
Thread-Topic: [PATCH 3/4] vfio: use __aligned_u64 in struct
 vfio_iommu_type1_info
Thread-Index: AQHZywUDvpHBRYjKtEWFDXR9GZe5kK/i3eJA
Date:   Thu, 10 Aug 2023 03:25:37 +0000
Message-ID: <BN9PR11MB5276D1304E854E2AE7E8EFA18C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-4-stefanha@redhat.com>
In-Reply-To: <20230809210248.2898981-4-stefanha@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6011:EE_
x-ms-office365-filtering-correlation-id: 35ef5d58-69fe-42c1-de6f-08db9951776b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8g5rpKW5F8TWWifsmSbsQgWd06Q9ffHZ9B/5wAJgLd70MjGlKW1zuy48hstj6IaOtq0F9fy32WltxicMcD7z/kWrGgS9a+PdJL/4oU8y0ArKM5k+Nb5EdyJ7mAPJFbK+QFoFvjnJfCkcJl88eY0hsUggJ54kZ+//r1U2YKQ3H0g69rRbXCK2/UW8pmlG1AFj0AggvKsYTG6tLFSZGjWXZYn5tufYapf1rHLLOz5VTVRkpYccL/TmluF7QAp7gKORYKL0VgbuuscPQ+rTteVKObhKR8UKrHNxswUmhPjzEn/omuV4dFjfDgBZUS2/bl8VhKBq4IEfJzC4qV5jZjypUaZJ+EiaDAkH9BkqTgE4O4TK10E0gBtkma2lZSql2T7MX6PAqve2rrIwI5FPFbMTrJAPZkxOsCKfyua2ygEOL6m2ttwaWdguJg7V788YbDdqf6BBfmHXx53+417UBfbaQ0nm0hhe8VjjLkfrvaBQrifLfv4fDT0cHcHpWUpZhbYeIZVcFpLSQO0ZoxUvvVQdS81TG/6zIc0F6NvXwlf26xQVuBgQ00ARXJ1CnOeYTm+KZV0bQcfhYa6RyRDf/UBUf/Z3eEHFxFR+wu91+grqywiT8QTt2Or9li8+WVCSG7y6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(396003)(366004)(376002)(186006)(451199021)(1800799006)(55016003)(66946007)(66476007)(66446008)(66556008)(6506007)(76116006)(26005)(64756008)(54906003)(71200400001)(110136005)(478600001)(33656002)(41300700001)(7696005)(316002)(4326008)(9686003)(4744005)(8676002)(8936002)(86362001)(38070700005)(2906002)(82960400001)(52536014)(5660300002)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DGQSHJjcItM8z2RaIipFyI9pXqueTvLimHpIGMjSi1/kk1MpDwJNK1Yav6p3?=
 =?us-ascii?Q?iPrwUht34WXiiGPYHNwadfaAgaualLPE0+e7OxTQDP0wU10yiFEB9e3EJ8D7?=
 =?us-ascii?Q?LB7KwnHwNeh9vi7PkkeNJBloBYZSrV+HyBW1wL1ts36TXB/MskKTg/GmTizx?=
 =?us-ascii?Q?7f7DMYSIVzJTrma55S71Ga34NxC0G6uXEwwoDTjL7Eb7Pr7Bf1m39WieWvka?=
 =?us-ascii?Q?HcVeumsmXlp5owv5BG26FgRMd3ZlaMh3Qg34OECcBjlxosSRe7sEDYCnU9sZ?=
 =?us-ascii?Q?nrAM4/AtxZZ5/bFGwa0GjU/2e0Uj3DFvD03kE7fJKJukOoxIq+rmRbyStEav?=
 =?us-ascii?Q?aDk0Dk7a5/JCL14Hy+m3L+ul7a71P39ymapwg5KKEPqspnD1IIIlSKeSIKMe?=
 =?us-ascii?Q?wU0Rk4ggtt8GMFYGchwwMCemB/lnU+bWSXcU+Ep2XkvqdKtc0gvBVgBo/3g9?=
 =?us-ascii?Q?uuOV3YADNAuY96rNvqhKJ634oO4PhmoS2hm1GTmxPXyUk+Txx0yPeRQfztlS?=
 =?us-ascii?Q?iuZDsI2iI2wNnD3sXyIpxDMcUvvViE7BvLomxGoU2Mg53HhGPsMGcHhM6zTM?=
 =?us-ascii?Q?uKDjTj2yYT/Eofcr4IILCc90IyQ8q2fL5IMTnti0JOmVykPVbQVWrIzCDOfH?=
 =?us-ascii?Q?fkG2j4hfwgYPHAThPgPf8GlSYkjIYCAME5m0lV+lKchWeP4EPX9n+XNAXbPV?=
 =?us-ascii?Q?e+NjU81k8V1x6wkoStx51jQJKwhv4GKSaOLSmU/P7zTfvlqpG3VQywV6MqfD?=
 =?us-ascii?Q?rrCRXSa2nzscOs+xepeGvWB5GmUlwgGwbPFYx9Mx0BF9sxR4KtuPB2l8+FQE?=
 =?us-ascii?Q?IoSJSpm1syxC31HjjZa9+xFSYjOAZhlWuOQVvHDFYQCSLV/IXi8AF4tyKcEV?=
 =?us-ascii?Q?Hkw8eZyNgvYVV77BfIYhFvXMjf4fcY7gZBsUHCdLQ6DZX0rYkyMYWkNczYfu?=
 =?us-ascii?Q?bQq+bDSnlxgxeXx8rh/baA/tNsXwuXpjv4Xl6o7TWIxnWSk/MK4ndc/MibvD?=
 =?us-ascii?Q?9DlkvIjWa1KIpkbqNkMLFzQMnNyuEc5f1OmilsenEx0grawdmw3lcPbMYU5a?=
 =?us-ascii?Q?Ny7SIp0f4Nuf6XPE9c56tPdetT3mNdcfkMjeuIOxRQbj1q0hNVXOzKiSk4T7?=
 =?us-ascii?Q?kg06zvSohXCxFO7uIvonoGZ89GzlJ2Jj/8a1Ly0QOTtL8iPHLk3Rnmn9fT0n?=
 =?us-ascii?Q?37wbRY4A6jLAolE2WZEwpuPSa98iSYUo79YVtIXsdr9TusrtfhKM531uwzoJ?=
 =?us-ascii?Q?aRMK4yZaMfTsd/NjE+aidcszQPQyQxv7Ac0QHLxSAjgcvh1v41x1ZeM6M7lI?=
 =?us-ascii?Q?Ifn0uHzMV4/IOt5QiJjLYW/Yo3dB2+FWcgq2YPhHhy183du1nLBjg1XKbjcc?=
 =?us-ascii?Q?10cl1dMiGT+mou2JoGdh/aCum/OPDuniQDYkT6F9+AjNmPLbKQGr4yMMdzYg?=
 =?us-ascii?Q?I+xd+QSwYKDJSt4bIS6FCkVrtyVj40SjN+tBuE3quexED8oaOzZd98t7BVll?=
 =?us-ascii?Q?iq2Y5lvjwt9Ku2Zu/j9JhqXvrMjyOOF3byjjIAtro8egal1IS40tf/k9ZnQ+?=
 =?us-ascii?Q?33gvYahE3SZy5Ka9JP6yO9WlrdTaDD2xur1BNCdW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ef5d58-69fe-42c1-de6f-08db9951776b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2023 03:25:37.7412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FPPUGowUskg4wujQefugGL3FJ+LVLZT5oPDgS0qriYi1RionSvK5PdvQFZYJVTuM64NsXozVI7FfHo0qvBaFUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Stefan Hajnoczi <stefanha@redhat.com>
> Sent: Thursday, August 10, 2023 5:03 AM
>
> @@ -1303,8 +1303,9 @@ struct vfio_iommu_type1_info {
>  	__u32	flags;
>  #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info
> */
>  #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
> -	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
> +	__aligned_u64	iova_pgsizes;		/* Bitmap of supported page
> sizes */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32   reserved;

isn't this conflicting with the new 'pad' field introduced in your another
patch " [PATCH v3] vfio: align capability structures"?

@@ -1304,6 +1305,7 @@ struct vfio_iommu_type1_info {
 #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
 	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
+	__u32   pad;
 };
