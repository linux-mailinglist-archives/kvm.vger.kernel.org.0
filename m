Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0E6FECC2
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbjEKH1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbjEKH1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:27:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEB81BC3;
        Thu, 11 May 2023 00:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683790059; x=1715326059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YDz6aR87yJyRoOK4Ldb8tdnZoqP/xo3MrsNhxfk3+JM=;
  b=nHj/PDFWHLeNRIj5nXW6s38AVo3aV/jCMWPlrsMLPYfKKwI0qkgJjKQa
   NkMXiKEW1DSmO8rP3p5zWBo2mToJdDaVrY287zDChDLWOgKNVs/bc+tor
   Om9+vyt5oLKYQ2TQ4pHMHiSn30g7flKgZIjklB5mcLtb7+u84ZH8Y3HBp
   JIlsqR8mGiKfK0VNEWoq/3QFK4l/5795ES/iOrGXB8WH8mE+vtNqmZM/C
   2pPFUtN3xEAdsmwzzOBg+ycrDZYPSGoAIa3IKMHQCU+Sz5ORW23vMCflI
   owgcr3b+w6V+luHhi0dgYXiTwG04fx5OUGd8WzAFhDuBZvaT5OVNc0Wlm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="436751348"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="436751348"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:27:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="811486695"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="811486695"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 11 May 2023 00:27:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:27:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 00:27:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 00:27:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 00:27:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwVmcQXuUAQFr66ZGHqsMqFwy+WfcpG6SVALJ9NSJoUvjjPiN8jXm7iCdPeFQApAtSpis0Pm80Bw2j0GxpF4uWU6lpyGhgUfa+5GTKxTDjnik0m8Fk7+b25hkfEaParAfn87qF33ldqe9oteSa0hgCYLAUqyEH6rYkSXPpbM3pAOQ0Fah46QMFC5qBeHniVIGSUKoIkAErPzSXmnIZElNIaplhDMTXOsYqtD0nMxFBEb2Bu3pjA4EICbz654rDX0FMXxnHXoU4BtzSxEvpTSNQGFYLFbyLVAwLivOYWKcpzmO+rb82pTn8SXxS8D+6FvVmQzBhJqaFCriXvd4RZ77Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSM4a1+Q8jBqZ3hn8dHlRTTsLhaSJ8xtqi+mQsxvSPE=;
 b=fdgezxnLHLbLPRx/cKnjon5wRghQMPU93jHVEvmtLjDMDLnsEzGkNLeNewpfj/OL7raB6quHD++/ICMkYDl1iXM0zDH82aaPbE+yeiKxk3USlJVOQRmpU7Bg+KNJkHLb3RrD6446ZB1qozw/CkZz+rZJKm53qwvb6iSlItu30+64rcXYMuWzfoxsJlgVqM+4qobY+QtTW2+sCC7akGSPrlYBAvcf8tBac2BQX3aCaTQmOvpt+3rpO9oBT2FEOtTNYu/zTMD7ICoz4neN9EsO2QDQkhlJRU2xois/YHt4XBCdg/6DqTcZyJL6oEO8Z6lm6VElkHR1Iyuhy63inst0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7453.namprd11.prod.outlook.com (2603:10b6:a03:4cc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 07:27:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 07:27:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5ABFkrqAABzyefA=
Date:   Thu, 11 May 2023 07:27:27 +0000
Message-ID: <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230510112449.4d766f6f.alex.williamson@redhat.com>
In-Reply-To: <20230510112449.4d766f6f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7453:EE_
x-ms-office365-filtering-correlation-id: 56a230d0-cc44-4cda-31ab-08db51f12c34
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: trOaE18oL8IMKu3AtdG/PJOHepH3h+Oy8pQpw7w9QYhFWoL9F6J7CO43AIPbf1Lsf25DmyvTZ+Rtj+eXK4R5FlGCnNuvqWLcJPuu1D++cSjGkKIAdS02mYo6R1Vl2bs7U/uV+a0chon/SUTvr6pk1+GdpGL7ZC7pqONv+Lh1Nve18povGqu5TD9QTPnzE4TDNHwmsljcmn+qQ7AsekUzQ7zrv9lVTyrm65il7HtA/kcJcbRyInKAznE1XOyq7/oOr+vjRbJHNrSrtHZQbL2hO5boTen5wXRewjv0GWVWF9PRBf80Fw7s0dQU1NzGTUKUKwcIqB3z1DzjRHDCw298nqHk1OPOD8dOEtQ8kVCmrC72X4Ew5Eix5f/72CmRGvsbibJBEajW8iQy5/3YlFP1BZmOB8N055LRHbSGhoodORrsq+uCKkND2lvSOCvohVeXXnDUCJCHrlAvcFtseQHbcBTJ8AvtKAEkwsCoob+q2WJV7IrPZ/Dnd5oEncj7WzBuopVf5cipSInYS/vpa+YLZXoBpL/i3599mhUjTk7mU5V45+KEYrFmD37RhtmJWQO/7wYzFlXS/QXEeK6PNmsX0ehj6oH7RkKZykm8aw9gm+BdTFgaDj+EBvUwTyALPgk/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(7696005)(6506007)(9686003)(26005)(107886003)(83380400001)(3480700007)(38070700005)(86362001)(55016003)(122000001)(38100700002)(33656002)(82960400001)(186003)(54906003)(4326008)(2906002)(5660300002)(66446008)(8676002)(64756008)(316002)(66476007)(6916009)(41300700001)(478600001)(8936002)(66946007)(52536014)(66556008)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q/CfRWGeydSGmxYHa2vaycoUsujYgJGSTHoPLv2mRFeTER/3qhTSE5mv3mJV?=
 =?us-ascii?Q?+6kx0+1foWuwuMDClJJNch+ZOqVcSztyMK1opyEzfZ1g/rfvcm+o3adL6en3?=
 =?us-ascii?Q?Z0aqGwYJVCeT59iiyZkLxVz8Xb4aq7xQXjG05a8iqxCf6C6MfyjX+8yiY5NM?=
 =?us-ascii?Q?iztNjLpSawqZbFqE7vZFpWW+f0455VYgftwDHkdvyM2T9b2aloTcrj7iRIVD?=
 =?us-ascii?Q?PP+FIf5dlLDxP2gQIVIY51biPbt8hFoKl29pLnR14xejHmtAkftwOb+XCiDO?=
 =?us-ascii?Q?vj8xoMpXUgbyJXCXQdVOzUdbdfFznE0PUcstOhfPOF2ik+PBS7/gyUYNdOrH?=
 =?us-ascii?Q?YFLr2Q7bc5yHXPMwQpuw6/yhzAb96vDtmypoAFveBq2LNKTXA6NvgVQw3Mxh?=
 =?us-ascii?Q?LNAT2sN0d3N0cFH7LSMF6TGQuBhXnJezEua6UFQO+4wUQkwdJxsvquFZfH0X?=
 =?us-ascii?Q?SPnvzJD3giL9kXlDrgjxnbgnx+GUFAESVabSDma9itA3j4kOZqp57g0pSDiL?=
 =?us-ascii?Q?tCMWORnx2LVUx/pAZt5M0145mczSKi5zF/IkA+XI5ED+psRCpAG7gGMJvcsU?=
 =?us-ascii?Q?6p7TCSuP7prK5r6ScHOKMmAEkqNR6xM/qeKIr2YenxGXoj2KLRpT9/R8vSRZ?=
 =?us-ascii?Q?cNtvetyhvGq8ojdQQys076Y1XR2sjJtHfsl6mEwLaqo9HR8zTxuMCCzBBaI2?=
 =?us-ascii?Q?a5ysgPkvZ1HLiVIYGeOQNrqJPINA/c74h2aagtaFn0f8jxdu7jH0aCU4+Ucs?=
 =?us-ascii?Q?kJln1TgWBONBLBcj8pnhfumalHOAE0qeiFcNZ13wPSBUVsMbic2RNgwny6cq?=
 =?us-ascii?Q?Pf3RvpCf4YLI3DXJw0/osJ7rlVQtUa0s+TnuHtw6Nww3tz2DMsxbeuGem0OD?=
 =?us-ascii?Q?uBHl1MyW97TZmiqMuQes+wogS4F/tSqJdNvYBrkUl5MJsxApjhn24lWl5IMB?=
 =?us-ascii?Q?Luw9FLeVqDp75xr2Xed/hPDs5Aok+QaPdNSrT2JIavuF3fHFLqQ+bcQPj9Iv?=
 =?us-ascii?Q?nkGxi6IlvMWyw9rg5zgCwzG5NjxrAinqTvim9vLCbpQVaGiZVsTXlJiAkmla?=
 =?us-ascii?Q?gii0QAh6HsjSeHx+6oXMHU7d2kwG7NsHYP+Sv8ipjXkgl0+mqSwx8gCh5lBQ?=
 =?us-ascii?Q?OukANvYkeXHUqPh5Fm5RWke9xP8cJV4rnefxoC84wnUFCXaG0hFmbADl3CDj?=
 =?us-ascii?Q?7FX+s8R3mnl6L4RMMCnhmHBv94un4u+JzTdOpD0oiUMzV0pHlg2NF8j9iMDn?=
 =?us-ascii?Q?LKRMavx1xXGU/4DpY/xvpq4va3Zu5Gt+NWWh4PMhhPzXaY83rdl/5VGp10CV?=
 =?us-ascii?Q?ebUtwtsCNFzucm6Y82pVdSuflnJimxu71dhL9dqP6P8Sq46Cw3lheXLZR72X?=
 =?us-ascii?Q?DjaPJEtOGhdzGpNxlHmcY6qOm+bOVfdh/Qo2JMFONLhFfCneJPoTJZU1njMx?=
 =?us-ascii?Q?86l+DSCx2KDYazfVQj582B4asvvzBEkR2AggkH9d4Y5sKz2edzLuUO0/PsN1?=
 =?us-ascii?Q?9qlLbJ83lP4ijdfLIbEYVmFnQKF0dkvmdiGUHo9RTfBi7P15TiI2CBOd1ByW?=
 =?us-ascii?Q?vOrmH2U0QwzOJHWmHNcDIcWJIrGwW9PGWkUS2QNM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a230d0-cc44-4cda-31ab-08db51f12c34
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 07:27:27.3124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0UzFnBpH3VMxQsQdJfzg2d+GEh4sZC1CNxxEgIyWgcJTUe4xARDLM8bDEZCGEf8eEb6LK7gGcvqUFg0cfoIv8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7453
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, May 11, 2023 1:25 AM
>=20
> On Tue, 9 May 2023 08:34:53 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > According to PCIe spec (7.8.9 PASID Extended Capability Structure):
> >
> >   The PASID configuration of the single non-VF Function representing
> >   the device is also used by all VFs in the device. A PF is permitted
> >   to implement the PASID capability, but VFs must not implement it.
> >
> > To enable PASID on VF then one open is where to locate the PASID
> > capability in VF's vconfig space. vfio-pci doesn't know which offset
> > may contain VF specific config registers. Finding such offset must
> > come from a device specific knowledge.
>=20
> Backup for a moment, VFs are governed by the PASID capability on the
> PF.  The PASID capability exposes control registers that imply the
> ability to manage various feature enable bits.  The VF owner does not
> have privileges to manipulate those bits.  For example, the PASID Enable
> bit should restrict the endpoint from sending TLPs with a PASID prefix,
> but this can only be changed at the PF level for all associated VFs.
>=20
> The protocol specified in 7.8.9.3 defines this enable bit as RW.  How do
> we virtualize that?  Either it's virtualized to be read-only and we
> violate the spec or we allow it to be read-write and it has no effect,
> which violates the spec.
>=20

Currently the PASID cap is enabled by default when a device is probed
by iommu driver. Leaving it enabled in PF while guest wants it disabled
in VF is harmless. W/o proper setup in iommu side the VF cannot
do real work with PASID.

From this angle fully virtualizing it in software looks good to me.

In another thread it's suggested that enabling the PASID cap should be
opted in by device driver instead of by iommu driver.

If that happens then vfio-pci may want to call into the PF driver
when the vPASID cap is enabled in VF. If the physical PASID cap in PF
hasn't been enabled then enable it. The PF driver will track which VF's
or its own clients require the PASID cap and keep it enabled until
no one wants it.
