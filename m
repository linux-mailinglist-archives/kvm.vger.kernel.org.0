Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DAB76E270
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbjHCIG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjHCIGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:06:02 -0400
Received: from mgamail.intel.com (unknown [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A939C7EE9;
        Thu,  3 Aug 2023 00:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691049410; x=1722585410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yb4Jpf96KPTV0WLZJycBmyLkTe03i4L3k1NMQRIMDBA=;
  b=aYAc4+OuuFnG5iuzOfSwpguAZe3/vQ5Ih009wcfPrdtysYIylVnHBrm1
   i438EM4x8kavkbUZGsnnh5UMio7PVD7Ma80aMsqHPNCMvPiepYpZ5dObT
   9phlQST8HX0G07A0HUGdO/aVamgmS2g3tG0ywoX5EcOYz3FbOzVbIUYl7
   rq52umtgxaukVb4xdUZxIxTQS9HAYynTR8Ci6fIJ2Xghue+m4QWBG94y1
   OSyq9g9fVdf8l2/coD/7kAadX2ThMJZYVw2XCASXke+EERowdTEYd+ME/
   ZGUdA1JO3kpGF4PvYivjAca5ebhdVNdsnymmd1aaLZt8tpqphUJ8wPdRH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="367257215"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="367257215"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:55:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="843493256"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="843493256"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2023 00:55:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 00:55:18 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 00:55:18 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 00:55:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 00:55:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwfULG3qYKa7aBl2lxXxwTV9XqAQnLxySDTbj4IxYqEWuNBnFsBJ5wt5cLPyVElQfDmppqMPpWnMJUfhDl0nfVDUGQBcql5XqCzVOV3wWmc4mVaWEa9TNae3DzvwqJz/F+SxV9TVSAEhOExYUlTMMEWGW4EOHinjCQPr8YNKjhlM5WuMrRRUL4+NLFdajhFPsReuyO7/4xPiWHp558QW2Vx3I2Xjau7Rar92MpdcyQRhInQVzSHwSEYqJ+o6ERNXc7bMl71omFBYPWh6dHuzCACXjA0m9zQqsVcPksNFxfEaFF88wwxoILN0lnuIbFtG/H34GwHCwE6HE3L6PD5/sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yb4Jpf96KPTV0WLZJycBmyLkTe03i4L3k1NMQRIMDBA=;
 b=KLApCgL6GJfbKYuI+N43bMg1G30Hl+yKg3TQOBgDtPxQ3YwqkTu5Hxpk9RP0qKA0Npkga9JyPaifkbGDuVFJwH3qNP36BDCkavngsVdJyIwVQ37FTeds/Kq7AzCfOaQqD/f/dcePE27RPaBkfzRhyZvNpq+bpNrPRjJkhGjElvbZZ0v+nNFrR/SQ/9TB4ZXmwtZqx9J5BO/V3/6maPtLP9/3Nqp5zvSB8cgOnxYcyPjwCTvfMq6tlRnhzt6bllNekAHuuGUf2lNiTR03jD0r+YhPojuMP9xPAgO3oHcryEUv0HrH9wQg8ufsJriqAn8KtiU/GnQ9U6sGx/QeyS9Izw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6881.namprd11.prod.outlook.com (2603:10b6:510:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Thu, 3 Aug
 2023 07:55:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 07:55:16 +0000
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
Subject: RE: [PATCH v2 04/12] iommu: Replace device fault handler with
 iommu_queue_iopf()
Thread-Topic: [PATCH v2 04/12] iommu: Replace device fault handler with
 iommu_queue_iopf()
Thread-Index: AQHZwE5XIH5F3/Kb/0+mFLbrTyCEJK/YPvtA
Date:   Thu, 3 Aug 2023 07:55:16 +0000
Message-ID: <BN9PR11MB5276101F4CD2F9B4CF479AEB8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-5-baolu.lu@linux.intel.com>
In-Reply-To: <20230727054837.147050-5-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6881:EE_
x-ms-office365-filtering-correlation-id: e8864183-df69-4eda-1645-08db93f6f98a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cTgYbDBkjK4LIY6JUuC3fdhUxLtxVAXlyuDIhRuLPtsL5oHs04h02XhKIwvJmRtTnR7oSGsutzivMnUrAEeLvC+RBb3e2Hi65djWw1nAkjamhkcOLuttapN7Z0g4Ehb1zgaBhD9sqbVj9ap6kZ2iCPUfNaG64XTgBulILMfOh1PfJrUqGK32mbmIa0wnwQXX/cW8ZBS7wl+erKBC6bJl7kAU7or8Ryz7gjOrBrhxipAmccfL3XuUnd5sA9FBUf6hH4QaFf+2w/rctNppwlsL/pl2hcbkCrOvKhPNvttKmpwvjJ6uZ8sySM6bDox//G7K+GuLuQnQW9SaENH6u2mSfD1+ycopJZ6THWvo67OVXGPsO1iv+blnMIWAirdzLYWwYOuRFb7Nk0fzh3bdHk1XbQf4SFB3YWdhQkNHmmQbZhGLy4NRyJUF4EC/OW4O8hg0UxvbmdyQsWwGYyzVJrYfjhUx9f7L96RNI0+WC5hzOdTtg77lFbg1ZZg+kx0jQmf+z12pgQH97rdmdv6x/wNIArwuYSZlv9w7aTV2QzW9YPcKkz4f4//3vrstCYvBwJXf+J6cd4P7XFUks/WztZoic7JZAuT7gNjQzctxfk+UqqM1DEO4wLntUgcg1IYckJas
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(38070700005)(86362001)(33656002)(54906003)(478600001)(110136005)(55016003)(38100700002)(82960400001)(122000001)(6506007)(186003)(26005)(8676002)(8936002)(41300700001)(52536014)(9686003)(71200400001)(7696005)(316002)(4744005)(66446008)(66476007)(66556008)(5660300002)(4326008)(7416002)(64756008)(66946007)(2906002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Iki+YgetONZ3kA1+Wji4IiQWpfGf0DuYDZor5HVz/AUE1vnZIGAorHSuoMD4?=
 =?us-ascii?Q?CnKY91HT8kq/7yFXcyuXjNS/3We/uISJ98BnbBEjNGTDFM6m3b/XCV6WJxtA?=
 =?us-ascii?Q?CMsMyt+wylNGaUtAULuOTnFa+Zeq93XYPRyCoCE7toOXI0ROho3YCbcT5wAn?=
 =?us-ascii?Q?wk3plnE2N2ekeG2DBFqggakgDvR1e344FPLQuDLhIa6U5QleqMDJ49t7Emz1?=
 =?us-ascii?Q?WeN/1vmBd6bs2TjAbDV6Q57h0vZgXNM7Q2XH4aoLBIsdfoYjO1GFyY0Fpsyq?=
 =?us-ascii?Q?xlhjJJGxCTwIhLTI9qM8s7FG5mA0KYEEVZbZ2xx2mJCZuBnJ7pnqedLG5uuV?=
 =?us-ascii?Q?IXJe/xG2xrVFxophbisHQ0qKDcE0z300wdhuRiUWRrKjlmZp+Idph6LaMOVD?=
 =?us-ascii?Q?ubWhfxGEtcmsDdBeHca3UuYEILknNqFqeZKuZyE20BLoxP9zBL9/7ylEMvZC?=
 =?us-ascii?Q?hRicePHh2kiGBMW4bppSAcnJE35jxtz/Vfy47cv7a8pXa8Oq9OiiCBbOzgoE?=
 =?us-ascii?Q?e0OR9ItYSNcSAfOTolgmY4/jjPBnhXGWjhr1TE2yZ4mdqfr1xdKaBsCSOShn?=
 =?us-ascii?Q?coCpVodfYnrqWfcFn8uhLk/xy95Q6LdyqiYf4OcuTXSq0mcrbT6DiAx8+Z7b?=
 =?us-ascii?Q?hrRczCx9pT70os02IZ0jbFv4DQhDIA1nRfeLF7EgJoIdfK8B9lU5JgXgvbH3?=
 =?us-ascii?Q?h0NC7qPB1JfTWWqMM4qPmXIzhvwH9XiE+UcDoV7TvjenvOK6/V/TyHKCaunr?=
 =?us-ascii?Q?BIfnULvFsoqwMmFLkTDw7dycMh5ywquffd+psEMl9z9f0rixNmI8/3LZEriZ?=
 =?us-ascii?Q?sRQsF3NW01/bJjD6dELrTrBvCircFB1IXF0mDHbfXj/f8LL2xTH0CHveNsml?=
 =?us-ascii?Q?CZ7X2iTxe3BhbPrjL0/rmkZk+pOSXwGNAqUb9p/Ivq+9TftcbPoMCIDglDwO?=
 =?us-ascii?Q?Wnuw7jpz3zDpNpDCwHI6N80GQItxOaSMYNM8PuD1cj9GjENrw1FWVOyTzpwH?=
 =?us-ascii?Q?QAcUfQkVA1j346K8Mj4zV0X+tMrlc73rxXt2uvgtv7Ua5v+0mncpdyYVSWbU?=
 =?us-ascii?Q?nqeunfjx3fVbLIOZpxUfA8Is6HSpxxkMSUi0pP8tr/9XRER6iRBHzBM/t4E2?=
 =?us-ascii?Q?hqkaLIagR6lOSc4LhbPzMRwPV9l77bdlybmzm4Sajontnml/GU/HF1/Nsf2z?=
 =?us-ascii?Q?hQ0TnzMzmpLha6+/JkSo51TmPZeawuXXhpW+XNVuJVE/teV9GiDSGEGFV8qv?=
 =?us-ascii?Q?I0T5Gj6FaSoTg28pxC/SIH2rZOXk8MXAfGuHQ9FSmk4LCKMejpggM8/DyqBF?=
 =?us-ascii?Q?d6LdJofcLGqPXW8xgxNXgDFm22gOnUWoUnZZRGvJYAQca3VGP0oq2rUU1YdT?=
 =?us-ascii?Q?Y1mOyYdt2UztfoBiZ1xc7PQHy67jpbAV3KBWJu/tod8UeuVXEb+1Yy7IjyVL?=
 =?us-ascii?Q?Ogl+RigZAgE8xbkcucyxun/07bfbBmo0ehNhj1gU7auC60Yt/khpAfmcQB0r?=
 =?us-ascii?Q?ScE8afJ0DmDsHTlCRDWH22QDrubkkzGz1w1QOl7BhdjFcLkXiLtHLqk/h6yi?=
 =?us-ascii?Q?/qm1RGRr7lx/GAotqxElKeeZ1GieMbrrjgWddJQB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8864183-df69-4eda-1645-08db93f6f98a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 07:55:16.0829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zyXHj9FnCevhLizMp5ZdpPLOF1SGAgMLwloBBAmLc1svLEOhTmwGsxOuu+qp1eeiEdov/hg3D+hT/pTN1AxgHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6881
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
> Sent: Thursday, July 27, 2023 1:48 PM
>=20
> The individual iommu drivers report iommu faults by calling
> iommu_report_device_fault(), where a pre-registered device fault handler
> is called to route the fault to another fault handler installed on the
> corresponding iommu domain.
>=20
> The pre-registered device fault handler is static and won't be dynamic
> as the fault handler is eventually per iommu domain. Replace calling
> device fault handler with iommu_queue_iopf().
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
