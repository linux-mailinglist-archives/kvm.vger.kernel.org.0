Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC76568C237
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 16:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjBFPvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 10:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjBFPvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 10:51:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5391205C
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 07:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675698674; x=1707234674;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=duBH/8Ndw66VXeVIOzb+SQ0sAAAMZg/YDHvO5ijQRCk=;
  b=fE+0rH1DFLEbferHnI34DvUkIrccOU+06rbftnsl0b+TjRvzTzDMtO/A
   KtEDiP77j3mCTIo1wUbOt0CD5O2uzg1inSKbDBsRxY5KOxBqpE9RQgN4l
   27zcYfZp3yHFghURqb6oEQbt3LPnxJ/kjGUeqn+/TLtFakFLrBrHZqSjd
   VBVwBUvHw34SHBuOviaJXCriEWC+PSBhkK6dRCvPfOhe7tNSi/lp7Dvk4
   UtfjJ3mZakQZX2yJF0Ylo5GADDbLedYY96U32rCvghLiobejFJpRJvxcP
   s6cNq2mhAfkuGYzrycrsIIhdOJMvYIAmGzl/VcwYMslml5xqekhQ1R+Mp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="415454401"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="415454401"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 07:51:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616482311"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616482311"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 07:51:06 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 07:51:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 07:51:05 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 07:51:05 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 07:51:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SqCnBr98QMmoZfh2aj6b8W/yFTTn5qSZagm5qrrg7gRILTdnCNq+kyTgI9PmxxXMBHXVkTpMMIzDKB5ZPQl7LsOgC0JVqdxUsWPc0W2x3NKeZ3b8U+TxexdBg7jkdD1GVpwfytXn+H7JH02DVmKcvtPR4A5VuXfb4cvPpcf0mmUNKCxXl8qcgilweVyErS3tUTlj4zhSjipZ8YYATfqt171dyTMFcrD5ADTJ4zbfBFAhYUvA4wowb7okk7nrEPuSx4JRY0M1h++ZzKQwwfAHUOApEsX46Kp1EDRAnNN+1WgzvbpYHe/lAYWGRJS7SqAmJ74r2spoXTcoLQOEWdNEGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIE+8rj60oX88C82N6GkAkXCduksij/R8/0aeBNdM1M=;
 b=Aw89aVp838CbGreuyQfo/hVe8fJFt9HAdInPQwF9w9X1oHHfoigr7DshB5wTErFJ7dxHoNkU4eSZjMDiat1z2yld0KdSUmN/Qnl6Oq0/iGaGbVyp1wY3uJuUTOLeYrjpXw2kAWweDc1EkmKw5zJX56ap6ksuhLrK+O2vTQuyDQymBNtlyadC9/7CSpfcTdHCAGkg6eY00+i23mG2exmL5EryuDss05blAGFEqKpfLS4yci/ZTNLvqRZgyVVJ2VWWjrwoEItu+mQKcDkJg4/OA6hCLNkc7knYDMUTe4c2kkN6NQ+feOMVl9HonWbVAIt+9PebcpQ8mUuSAljs2ZZIiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4543.namprd11.prod.outlook.com (2603:10b6:806:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 15:51:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 15:51:03 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6mbRKAgBCCdhCABEMGcIACZfGAgAPY7eCAAF/tAIAAVAKAgAAKR0A=
Date:   Mon, 6 Feb 2023 15:51:03 +0000
Message-ID: <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
In-Reply-To: <Y+EYaTl4+BMZvJWn@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA0PR11MB4543:EE_
x-ms-office365-filtering-correlation-id: 5018024d-4342-4503-cd1d-08db0859f38a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5GyNFc5G0GYlxy8iAW6jXtGAvFEetD6q+0HRaw9huHWEuk4ufuRJHVKxAwqR6Ss9qDVUHPoeMRLm9E1aH8BOHJYzjiBb9BFxDlvksu6b7GSdObRraANZ4D65x16JkFEDTanbTXdkmgwaQxQHacc2+T/ubnNemPjwlt6oklbLGdUi5Rb9QiOI1TrAQqrbbsESomgoy90ORbEJtfyYPKgRoLscWpo8QW2iSgW/g81/e+LKK8zNHlLjGsQnaqr8e7HxUSBmfaUrF5/RqYs4qHzuw5RXxdJ3v1Mpi2WQEmUdGFzCk70Jo3VFk/gU+cs27woop72NbN9xn6WIPmhniIQtDds+yKW2BI9SPGibhCRpe4CqbUo0fZ+g7FpEHtJDrkWtdbMtygp18OgM38w2IU4F/SKN0DVjnWwz7vJHTXkpd2Nf7UK6OhjEXLErNIu9W2Msy31ayJ9lwFcbC569kMEmxIWICHFSVYtN/GoFAXnVNQKRa3PZi0R0PTdiH8zlqwCMzfaR+fYgnEP5HzKVdaVsdsnEVb3X1Zy3uRIwtfOkuhBBfJtwiQ1iv9zKlWPGGnRDGMbCR79cs3frw1lZ+KMZMSdZ0sIc+kMik7zf/9lna50TRk4RI+AqbbW6VvAnZjHLGKKYLNFKuGbKN1X27k6mLWOI5+Linylgmh64i+TzBEDJL7CLvs0sBUmaEpPjl4ZJI78TSGBhb6YCPMLwY84bPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199018)(33656002)(38070700005)(86362001)(82960400001)(38100700002)(122000001)(64756008)(66556008)(66446008)(52536014)(8676002)(41300700001)(5660300002)(66476007)(4326008)(8936002)(110136005)(6636002)(54906003)(76116006)(66946007)(316002)(7416002)(4744005)(2906002)(55016003)(478600001)(186003)(7696005)(26005)(9686003)(6506007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MCq8k3/FGK15w1rGqF6YjBfCwBSihtFv+pca1MbN8D93n/MoIO3sjYJY5b7i?=
 =?us-ascii?Q?SZUPuJleLAxFujXtybT7HbDdNsdyZ7Pxt57Nre/4AerTUDbgZyvQN/Ln6+xF?=
 =?us-ascii?Q?eu1bCecC7+vGGCl65yFo+MhSTw/BL1e0eixrI4td41JZYplGh7yIr0MtS/x5?=
 =?us-ascii?Q?c2UXLGj/kG6qcGu+gw/MG7tMW8PkILybYuhNQFFg39rE6zqywCrvXRaW7Cks?=
 =?us-ascii?Q?kyDoRbw3qW94QX5dTMHfgAFesGu319gNWjK4HkNEg9a/3VPNEtP6MVpdi6h0?=
 =?us-ascii?Q?8h5/rG68wr2WtGuS6l86qKEkzd+CsyeMxjqB4OEKMH43t8Xq2uIey914cdIX?=
 =?us-ascii?Q?yWxOCmkz42UYLT6zHpcrJe+IdtkSST9Kykk6CiWgAiqeP17eGhdh3x7FEr45?=
 =?us-ascii?Q?3QBlj6aE4DVmJCl19Z1LQrXfMXvOikDnaA75kQ271epDai6ZXk4cuseYNJ5P?=
 =?us-ascii?Q?7c3w63kQ/2LwxwdT3TRiTEsKkfTVWFzd5Q6HHnNdZw2GDY48xyroPyYaBlj0?=
 =?us-ascii?Q?D3MsvyUWKKO2Edb82hd4/elqB7ZeJyA/JwotEyJ/kJF5vqpACMehnG1a3r0E?=
 =?us-ascii?Q?Y2fn2IJdfCiK3/sUU6UDdVfm7bPa2uALemGr/o8j3TDRJEkHD9vMfi5mAAFv?=
 =?us-ascii?Q?aHITc/8qj89AAmbJomicebXpp3xddUNX6iDEc8adMgYT/JOVNXcdRl8rlSab?=
 =?us-ascii?Q?WrZIs7CadunwEQQCYB/t0FsdkqOqYzVWGLd8QKA4BsULzgcNshPg7OxLxSm3?=
 =?us-ascii?Q?DLLwdfD2FfK5jT07sGnBcond00JSg3JyOFCN6WSYWZA1NiHVPWTHuTyXVIzH?=
 =?us-ascii?Q?1yjxFbWT6qFnoQpVzSXLytIVnhbmoYb1kFUqZqFRn5BYDCR4scBa6/QexBbO?=
 =?us-ascii?Q?dqdM+QyS+w9AgtrFVQS54h013qcdcr2JLiRzSAw30zK28cJrjVA5RRxNu9uv?=
 =?us-ascii?Q?Z2RlwZpSPqYVrAfIwEPQnQl6bKe+84Oa5r/jrAxg0HX15pXcDxPSouTeIro2?=
 =?us-ascii?Q?Zyd2VTX3Qr6bxxxZ53DLD7N7LRs/afAeLhf9zkckkWB5hLj0YFCPye80WVyl?=
 =?us-ascii?Q?cFWP5iVsfKF2jDSgkjOKz8W8KEj9puelfm+L+Vg2Z+cKSp42jVnJhjXt3SHe?=
 =?us-ascii?Q?qypMmY9A8uQMS0FZ7ZljFDVUZ3iplSndfNidUqrvb7GwIfmqfOX8YXPYg5UH?=
 =?us-ascii?Q?SWajq6CHz21QZ5swblS05NAXu+2CzmpJ5yiPsAbnlmxX8G1GwujZ/lZREaRB?=
 =?us-ascii?Q?MWhkS7CDBhGvmE+sU1ZeRWwj1RSXjFnAAUa0P62JbaTxI7A0NLuZRUAdA7mz?=
 =?us-ascii?Q?t2scLecaMUFpK/zg+ohnQ/XWXiprouRWkaQv7ibUuOB+4U6z+jaKYy3I1Duh?=
 =?us-ascii?Q?nX3q5TC2SI47CboA/qFVDYrFx1oBoWBLx3dblH7FMngPmIVU+CQzyMd3eGJR?=
 =?us-ascii?Q?g+KhK36z9nL0j6bHEJ0Yd0DGZe2WkM3g5jI/j6qa2SPPsdJjS2RZzZhcb8+x?=
 =?us-ascii?Q?Af79PekuN9F+68YIn8SEZAyXhNv8lV3XvD9WNuBwcXuOwQzqqKjidnja+gcB?=
 =?us-ascii?Q?/3fwtni4BbmLBw/H5pMPSrkXRbdoyumVNyQ6MhY0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5018024d-4342-4503-cd1d-08db0859f38a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 15:51:03.3972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g/JCOg6xHvgwQgvoRiexBes6B8w4ZmXLpfqgqcqDKjOwqfL1aerduv2sG4Y+l5qDGfAx3q27knIl8VWb95hnhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4543
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, February 6, 2023 11:11 PM
>=20
> On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> > It's probably simpler if we always mark DMA owner with vfio_group
> > for the group path, no matter vfio type1 or iommufd compat is used.
> > This should avoid all the tricky corner cases between the two paths.
>=20
> Yes

Then, we have two choices:

1) extend iommufd_device_bind() to allow a caller-specified DMA marker
2) claim DMA owner before calling iommufd_device_bind(), still need to
     extend iommufd_device_bind() to accept a flag to bypass DMA owner clai=
m

which one would be better? or do we have a third choice?

Regards,
Yi Liu
