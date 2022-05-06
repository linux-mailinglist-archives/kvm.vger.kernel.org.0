Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D151CF47
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388456AbiEFDSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388447AbiEFDSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:18:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4677B63BDF
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 20:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651806859; x=1683342859;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rycjiNw+5yhcpOKps1y+yRBj5sHaO59xP8q3vU3TdEw=;
  b=GrhyNWx+2/5wz7GgUfJOnCwueMvhYreSVRwSeQoHWY69u1PE2MYYbopq
   9eyG1ZRYQFyywx1IMGrjMO8E77OBMNmXK4RXNxRR/sJrqeBDEanhy3mOG
   e4CnovwYSpRZx2n26nYX9uUxjSDOZIkm4L7a8TDd4UWMwIfAfWQOaQ1Uo
   7if2Or34ijF0Fhg6gTLreS3dYkfh3e7LimFxBiWzPS8qMGMoRDc61zAqW
   F0XnPoNIbHNnLpfLvAmlNyFEE/ysS56jWRb203liGqbYIrXMnwa65Gsji
   jXqTZHtr7JsXV77aga010QA+TdBdFbC4egyTOUfwnkvxc8zKQ2rcGQGu7
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268476455"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="268476455"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:14:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="600354578"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 05 May 2022 20:14:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 20:14:18 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 5 May 2022 20:14:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 5 May 2022 20:14:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 5 May 2022 20:14:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ic7ZNDKpD+UPolbAElO0/tkTcDjAtv6Zu3FcYsm5u8bgOgAGPgkRUrf1Xh81JhO9cZ+ghVEHljQ7tEru7HVNw1cGvJvYK6gYo8wdBHSzeFMAuP066fFKq93WkwyiCo67NHMMDApCYGIorXwYIMbhkAfIrog2vaeVK6fX0EBopPRJZfgcWS6F/HnhcxwNjxN2zmKwxY6GhvqjJ/SQBRrB0St/6Onb4P24KrHy8PFFJd3Adl3Vo05Xyhzkby9htd97mo/p9g/f4fdeLhoUKe9oX7rsk31ARD6fH+8CXT/wxEpkJkAB272TUHGRJEtPC4RB+68o0afVY4wLMRM+lGSsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rycjiNw+5yhcpOKps1y+yRBj5sHaO59xP8q3vU3TdEw=;
 b=l43AaFsMJzukPjORAdCjbOOUvOusRpc5JwDDurwVKYaIjWueXI7AuunDXZIquBEAa0vBizeYq4j9J+/NJo4w1c+OI0tQGg0smxfgxMn6EuamRXkFFTDXCmcTVZCGN7tPCN9WhcijfYuITaHnfw6bWpED9jEKXxWSWjK18U9l6zDENGZ1e6DJaDFJCVobzodaTEzW5rHqFSQLOOzr37QvPvs+RYe44xiNY+RkHWn/bLGargE/kO0Jtk17ydldnpgbu+rWhko0NPgmBN99B8SlXyMAO9EWWg88sr515Tkcn4bXyY9GjT1dePu0/IXp31Uz3Lb9nnrE5lfVEjx2+Z1cJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6469.namprd11.prod.outlook.com (2603:10b6:8:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Fri, 6 May
 2022 03:14:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 03:14:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Topic: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Index: AQHYW0R/S6mfDid5yEe6M+QKFrUDn60GOWsggAWwCICAAAubgIAD+0BQgAAo1oCAAA4PYIAADwWAgAEBrNA=
Date:   Fri, 6 May 2022 03:14:15 +0000
Message-ID: <BN9PR11MB5276C8D07C213BF225D9D2D88CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220502121107.653ac0c5.alex.williamson@redhat.com>
 <20220502185239.GR8364@nvidia.com>
 <BN9PR11MB527609043E7323A032F024AC8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7b480b96-780b-92f3-1c8c-f2a7e6c6dc53@oracle.com>
 <BN9PR11MB527662B72E8BD1EDE204C5538CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <82366a45-937c-eea9-259d-ac718249bab1@oracle.com>
In-Reply-To: <82366a45-937c-eea9-259d-ac718249bab1@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f3ee844-cc35-45e6-799a-08da2f0e8083
x-ms-traffictypediagnostic: DS0PR11MB6469:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DS0PR11MB6469F4D01C145881B8F01DBB8CC59@DS0PR11MB6469.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3GaFdDOLdk0FaApnB9h7YVoPCxVLAZtrGBpIAPL0M+zh2ANvCHTQGPG2aWZtdo+BCxtHjYAOjuUZVLOjy9Xq8HPikNdgHlvW9q66Jm5NzMjXJc3WF73wlDcMP8dL5lXGVKve2a2jmUQYZB9zugKN4LN99DDP/qynHO+mLL/AKf6lZy4bTHGQlIlhbVHz8pSqoT0EVp8yCEEN5QYly/lvKjOxxIZ9Ktsqn7S3ninx4ZnpreQXDSEKd+rQaU9GjrATxjSE1izI/TeaHXJM4uLvSfvzY2ldOmCV3yiw+lz/BLc5VCnei1DkbzbTlXmcyvKJF8DAUmwb+A/+fcDZn1Fn/kwr27Q8ZhPbV0kl/EToY7vhBjkBrvzHuvp4g8PxHkq6YQZRv4y6v23nSmcTt86QwiSMVyVz/IRiW9a2i8bz9Jsord2By5VdhrBtuvCVwvEiWIG7xPUBLvNb9Se7vmVzeDqcm+Ix3KzALvGg5Ls86ywh+yirENyYxI5weZzyRlvrlx9tukzuNC+na+aKE3LEiA9xQUwZVFT/Q57rs/eYsrYIAGCO7dbWW2dg8ppf2I6G7XjhUlJQAdc5F5K8rr3Bul4n+SUJxGN3/nDIB+q58zKEPP0WgF0TZaTw0GisYRWdDfk66JGXY9dsHvPGMm2mf6ZWyQA28iIOKqVDnETdp3QXqH2OGmA0oCVsDtjEu44y9bWErJ3PnI4oTyv9BWzo+ySF/nBhen0+r02rhyF6OT4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(71200400001)(86362001)(83380400001)(33656002)(186003)(7416002)(4326008)(66476007)(8676002)(66946007)(66556008)(66446008)(64756008)(76116006)(55016003)(7696005)(9686003)(82960400001)(38070700005)(122000001)(8936002)(2906002)(52536014)(38100700002)(26005)(53546011)(5660300002)(54906003)(110136005)(6506007)(508600001)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWdzU2RWTUtRRURKd1E1a0VhNTZrcUR2VlFvZ0lsZ0NhNmIrbkg3R2pubUpw?=
 =?utf-8?B?bmVSVTA5YUFacTVJdlpSREcweDJLcUx4ZU9zYlFIMk5zNGNaZ2ZkRTZEb2M4?=
 =?utf-8?B?SFdPWk9xeUlaT1VPRWZPNVlQU3pseUVST0c2WjNjdFBIMFJtcmdTY0QyQUhZ?=
 =?utf-8?B?MFNtY0RtWEVQVVVwNHZKeEJLcm5PbXJSQStzd2pmaWwybHEyemU4VGZycGg0?=
 =?utf-8?B?b2NyeWlPaU9DYkpOT0xETjBCTE53QjQ4c1BZYjQyenpFZTNyNlJ5QUlJYVNY?=
 =?utf-8?B?TGQ2VHRkVXVIcDRPaXBsZjhoZmRSOUVwQzFid2ZjdVB1Mmhka3BFc3lVZ0Mw?=
 =?utf-8?B?REFkVDVRUm55eDM4enlrV3BRdHd2eDdLeWxCWmsrK01tOTJDRHpyYzFubUJD?=
 =?utf-8?B?VHF3a28vcDQ0M3c2NzcwSTZxZ1BPc3pCcWpCRXVKd05vMnVLWjhxSjh1VlN4?=
 =?utf-8?B?NnhmSURIYjdIU1dqeGxDRnBaUkNoUkM4bGRmTDJvSGw5Sy9meUhTWWhqNnlU?=
 =?utf-8?B?RXp1ays1clZhOVhzTklmZHp1ZUNPVXptSUN0MmcrL2JIUTRzcy9aRlR3VGZZ?=
 =?utf-8?B?T2ZpSm5IL20xOGR5eUV5ZytWSVc4dU5PNU42VmRPSlFBaE5HYzNjQmFOckJN?=
 =?utf-8?B?aVM4aWxJZFB5MmhuOVZ1ODJSM3BBRXFKaTEzZFVjMnVPUE1sZEh6MGJkZ1JR?=
 =?utf-8?B?SmN6bXJha05TbEhYdGVocVhZRklIT21nbGJkRnZYNkdqRkExcVdIQTVKWWlm?=
 =?utf-8?B?NlRXQnRKWmtBV1kvR1JBalAwdGlMY3psOWtQMTFxbGYwQng3dXZMSEdlN2VL?=
 =?utf-8?B?YjRLQzQ1TUZDTlBsQmp1eU9ETXlHd3p5ZHR6MktGcTNQUDNreHByRkgvOXlO?=
 =?utf-8?B?MXlDRlBvWUtnTHY3WXpKNGkwSmdoMHF1QzdiN291QVlFTzdXb2M5SWlhQUpE?=
 =?utf-8?B?Y1RJWWJZMlRpNzBLSkZFWWxxOEx4bDAyTHdnNllOWS9nanRvcmh3Y3puZEpw?=
 =?utf-8?B?WXVyVmJjK2dNdXRXaHBmSFhyU1lzWWZYbjdxbk55MWtmMDJZZFVmd3RWS0lG?=
 =?utf-8?B?eks0STNCcC8zLy9kb1NhNmFpMmFSVVRtb2NmbEhZR1dtK3ZSdUZsZEgvRGxi?=
 =?utf-8?B?bTQ5Ylp6dERIQTRjY1dtbXZ1L0pMTWt4ZlB5Vit5VE0yV1hBZVk2VW5jVlpv?=
 =?utf-8?B?cmxFdEpaaUplc0tRdCs2TGh5QmNVWFd2elB0bG93dUJBSzllREp5ajdOaW5H?=
 =?utf-8?B?SWFMQnUyNjI5cXI2SnlnQ3hSZzIxZXdPQmpRcEhCNENTelUzVDR0c0JqWnE0?=
 =?utf-8?B?SGY2SmxmRkZBQnFqenVqMW9rajh6RGtjbllUWnRHUTJCb1V3djNDNVhlcXQ2?=
 =?utf-8?B?R2RpQVVvSGpaM1BuR2ZBYm1IMjB1SVlBR1R4MHdVZXZ1a1FLOWtCWWY2bzlI?=
 =?utf-8?B?dDc4cGI1OTVSODEwSVdreDRCME14L0JoaDM4b3dzZGdKMDMxSWo5S3hoTkVa?=
 =?utf-8?B?U2tid1JMekFRRWV3SFJKRy96UEllNHpVMW9MdXpXeEdqaVc4QTZwc1dFZ3FL?=
 =?utf-8?B?V3dqSVFxazYvWDdyUWtHNVYxSU1aeWR5Y0JEcXRFY1Rad0NKem9sUWpOS3VN?=
 =?utf-8?B?WGVVZ2dYY2xMYUlqRlY0b1lCQzBRYm9oYmN6VU1NV2RQTVNWRXNMM0pQeVY3?=
 =?utf-8?B?bk5TS3FrcnNMTlpkQ1NWNmZEaStmTktuTW43UVozL3QxZkY2NzU2MWYzNWwr?=
 =?utf-8?B?M3NEaU1DdGpBY2x5WlZsTHBaUFQvcmZ3ZE9yY2taVUFlMkNwa0E0NUpxdmxq?=
 =?utf-8?B?R1EwcW5HWVpwVDJ5cS9Va3RSYzZwNmdHeHc0WWloVmVxancwV1A3eUNTT2RV?=
 =?utf-8?B?YjEreG1adklkUUg4WEhOSHd4SGQvNWRFUnJpNFB3dW40SXNqY0NFdHM4L0p1?=
 =?utf-8?B?TmxMaElzNGk1WTVsdHZLTDZJbDdBMjhaT2EwcFlMbTRBZ1U0OElLbkJNM0k1?=
 =?utf-8?B?M3NvVWE2YzhNT1NxNVppbTZSKzE1N0xSK3hHWWlMM0s3aXBYaDJtMTVmemhz?=
 =?utf-8?B?TllvYzdMRE9ML01rTHpjdWlWWHJZenU0bE9pUVMybCtlZ2lDYVh5TUtsY3pK?=
 =?utf-8?B?Kzg3QWE0VDhJdjhWbk4vSHgzenNsNEhtSEc1eXpiK09QUGp2Zm9rc0thNkpQ?=
 =?utf-8?B?M042U1dPTFR5L0wvajF4VXdqZmxTcTZwbEl4eHZOeUZqSWlvTUlEUjN4dVlr?=
 =?utf-8?B?SU1iWVBzZ1dIVzRFK096RTk2VHNCS2ZKaVhiUjQxOXVOcWZNZERLQm40ck90?=
 =?utf-8?B?bmJZLzVDT1dhTThuUkRIaVZhdFpFdWtMVTdUakdBK0xoZkl2WURiZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3ee844-cc35-45e6-799a-08da2f0e8083
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 03:14:15.8181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wya+WySUvOLppNz6LbCU2RI4aCPvNMlvgoeie3RljTm43r90C+48vJsxvhA9AmWopEfs+8ghPsZRG829RQCZUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6469
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKb2FvIE1hcnRpbnMgPGpvYW8ubS5tYXJ0aW5zQG9yYWNsZS5jb20+DQo+IFNlbnQ6
IFRodXJzZGF5LCBNYXkgNSwgMjAyMiA3OjUxIFBNDQo+IA0KPiBPbiA1LzUvMjIgMTI6MDMsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBKb2FvIE1hcnRpbnMgPGpvYW8ubS5tYXJ0aW5z
QG9yYWNsZS5jb20+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBNYXkgNSwgMjAyMiA2OjA3IFBNDQo+
ID4+DQo+ID4+IE9uIDUvNS8yMiAwODo0MiwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+Pj4gRnJv
bTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPj4+PiBTZW50OiBUdWVzZGF5
LCBNYXkgMywgMjAyMiAyOjUzIEFNDQo+ID4+Pj4NCj4gPj4+PiBPbiBNb24sIE1heSAwMiwgMjAy
MiBhdCAxMjoxMTowN1BNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4+Pj4+IE9u
IEZyaSwgMjkgQXByIDIwMjIgMDU6NDU6MjAgKzAwMDANCj4gPj4+Pj4gIlRpYW4sIEtldmluIiA8
a2V2aW4udGlhbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+Pj4+Pj4+IEZyb206IEpvYW8gTWFydGlu
cyA8am9hby5tLm1hcnRpbnNAb3JhY2xlLmNvbT4NCj4gPj4+Pj4+PiAgMykgVW5tYXBwaW5nIGFu
IElPVkEgcmFuZ2Ugd2hpbGUgcmV0dXJuaW5nIGl0cyBkaXJ0eSBiaXQgcHJpb3IgdG8NCj4gPj4+
Pj4+PiB1bm1hcC4gVGhpcyBjYXNlIGlzIHNwZWNpZmljIGZvciBub24tbmVzdGVkIHZJT01NVSBj
YXNlIHdoZXJlIGFuDQo+ID4+Pj4+Pj4gZXJyb25vdXMgZ3Vlc3QgKG9yIGRldmljZSkgRE1BaW5n
IHRvIGFuIGFkZHJlc3MgYmVpbmcgdW5tYXBwZWQNCj4gYXQNCj4gPj4+PiB0aGUNCj4gPj4+Pj4+
PiBzYW1lIHRpbWUuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gYW4gZXJyb25lb3VzIGF0dGVtcHQgbGlr
ZSBhYm92ZSBjYW5ub3QgYW50aWNpcGF0ZSB3aGljaCBETUFzIGNhbg0KPiA+Pj4+Pj4gc3VjY2Vl
ZCBpbiB0aGF0IHdpbmRvdyB0aHVzIHRoZSBlbmQgYmVoYXZpb3IgaXMgdW5kZWZpbmVkLiBGb3Ig
YW4NCj4gPj4+Pj4+IHVuZGVmaW5lZCBiZWhhdmlvciBub3RoaW5nIHdpbGwgYmUgYnJva2VuIGJ5
IGxvc2luZyBzb21lIGJpdHMgZGlydGllZA0KPiA+Pj4+Pj4gaW4gdGhlIHdpbmRvdyBiZXR3ZWVu
IHJlYWRpbmcgYmFjayBkaXJ0eSBiaXRzIG9mIHRoZSByYW5nZSBhbmQNCj4gPj4+Pj4+IGFjdHVh
bGx5IGNhbGxpbmcgdW5tYXAuIEZyb20gZ3Vlc3QgcC5vLnYuIGFsbCB0aG9zZSBhcmUgYmxhY2st
Ym94DQo+ID4+Pj4+PiBoYXJkd2FyZSBsb2dpYyB0byBzZXJ2ZSBhIHZpcnR1YWwgaW90bGIgaW52
YWxpZGF0aW9uIHJlcXVlc3Qgd2hpY2gganVzdA0KPiA+Pj4+Pj4gY2Fubm90IGJlIGNvbXBsZXRl
ZCBpbiBvbmUgY3ljbGUuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gSGVuY2UgaW4gcmVhbGl0eSBwcm9i
YWJseSB0aGlzIGlzIG5vdCByZXF1aXJlZCBleGNlcHQgdG8gbWVldCB2ZmlvDQo+ID4+Pj4+PiBj
b21wYXQgcmVxdWlyZW1lbnQuIEp1c3QgaW4gY29uY2VwdCByZXR1cm5pbmcgZGlydHkgYml0cyBh
dCB1bm1hcA0KPiA+Pj4+Pj4gaXMgbW9yZSBhY2N1cmF0ZS4NCj4gPj4+Pj4+DQo+ID4+Pj4+PiBJ
J20gc2xpZ2h0bHkgaW5jbGluZWQgdG8gYWJhbmRvbiBpdCBpbiBpb21tdWZkIHVBUEkuDQo+ID4+
Pj4+DQo+ID4+Pj4+IFNvcnJ5LCBJJ20gbm90IGZvbGxvd2luZyB3aHkgYW4gdW5tYXAgd2l0aCBy
ZXR1cm5lZCBkaXJ0eSBiaXRtYXANCj4gPj4+Pj4gb3BlcmF0aW9uIGlzIHNwZWNpZmljIHRvIGEg
dklPTU1VIGNhc2UsIG9yIGluIGZhY3QgaW5kaWNhdGl2ZSBvZiBzb21lDQo+ID4+Pj4+IHNvcnQg
b2YgZXJyb25lb3VzLCByYWN5IGJlaGF2aW9yIG9mIGd1ZXN0IG9yIGRldmljZS4NCj4gPj4+Pg0K
PiA+Pj4+IEl0IGlzIGJlaW5nIGNvbXBhcmVkIGFnYWluc3QgdGhlIGFsdGVybmF0aXZlIHdoaWNo
IGlzIHRvIGV4cGxpY2l0bHkNCj4gPj4+PiBxdWVyeSBkaXJ0eSB0aGVuIGRvIGEgbm9ybWFsIHVu
bWFwIGFzIHR3byBzeXN0ZW0gY2FsbHMgYW5kIHBlcm1pdCBhDQo+ID4+Pj4gcmFjZS4NCj4gPj4+
Pg0KPiA+Pj4+IFRoZSBvbmx5IGNhc2Ugd2l0aCBhbnkgZGlmZmVyZW5jZSBpcyBpZiB0aGUgZ3Vl
c3QgaXMgcmFjaW5nIERNQSB3aXRoDQo+ID4+Pj4gdGhlIHVubWFwIC0gaW4gd2hpY2ggY2FzZSBp
dCBpcyBhbHJlYWR5IGluZGV0ZXJtaW5hdGUgZm9yIHRoZSBndWVzdCBpZg0KPiA+Pj4+IHRoZSBE
TUEgd2lsbCBiZSBjb21wbGV0ZWQgb3Igbm90Lg0KPiA+Pj4+DQo+ID4+Pj4gZWcgb24gdGhlIHZJ
T01NVSBjYXNlIGlmIHRoZSBndWVzdCByYWNlcyBETUEgd2l0aCB1bm1hcCB0aGVuIHdlDQo+IGFy
ZQ0KPiA+Pj4+IGFscmVhZHkgZmluZSB3aXRoIHRocm93aW5nIGF3YXkgdGhhdCBETUEgYmVjYXVz
ZSB0aGF0IGlzIGhvdyB0aGUgcmFjZQ0KPiA+Pj4+IHJlc29sdmVzIGR1cmluZyBub24tbWlncmF0
aW9uIHNpdHVhdGlvbnMsIHNvIHJlc292bGluZyBpdCBhcyB0aHJvd2luZw0KPiA+Pj4+IGF3YXkg
dGhlIERNQSBkdXJpbmcgbWlncmF0aW9uIGlzIE9LIHRvby4NCj4gPj4+Pg0KPiA+Pj4+PiBXZSBu
ZWVkIHRoZSBmbGV4aWJpbGl0eSB0byBzdXBwb3J0IG1lbW9yeSBob3QtdW5wbHVnIG9wZXJhdGlv
bnMNCj4gPj4+Pj4gZHVyaW5nIG1pZ3JhdGlvbiwNCj4gPj4+Pg0KPiA+Pj4+IEkgd291bGQgaGF2
ZSB0aG91Z2h0IHRoYXQgaG90cGx1ZyBkdXJpbmcgbWlncmF0aW9uIHdvdWxkIHNpbXBseQ0KPiA+
Pj4+IGRpc2NhcmQgYWxsIHRoZSBkYXRhIC0gaG93IGRvZXMgaXQgdXNlIHRoZSBkaXJ0eSBiaXRt
YXA/DQo+ID4+Pj4NCj4gPj4+Pj4gVGhpcyB3YXMgaW1wbGVtZW50ZWQgYXMgYSBzaW5nbGUgb3Bl
cmF0aW9uIHNwZWNpZmljYWxseSB0byBhdm9pZA0KPiA+Pj4+PiByYWNlcyB3aGVyZSBvbmdvaW5n
IGFjY2VzcyBtYXkgYmUgYXZhaWxhYmxlIGFmdGVyIHJldHJpZXZpbmcgYQ0KPiA+Pj4+PiBzbmFw
c2hvdCBvZiB0aGUgYml0bWFwLiAgVGhhbmtzLA0KPiA+Pj4+DQo+ID4+Pj4gVGhlIGlzc3VlIGlz
IHRoZSBjb3N0Lg0KPiA+Pj4+DQo+ID4+Pj4gT24gYSByZWFsIGlvbW11IGVsbWluYXRpbmcgdGhl
IHJhY2UgaXMgZXhwZW5zaXZlIGFzIHdlIGhhdmUgdG8gd3JpdGUNCj4gPj4+PiBwcm90ZWN0IHRo
ZSBwYWdlcyBiZWZvcmUgcXVlcnkgZGlydHksIHdoaWNoIHNlZW1zIHRvIGJlIGFuIGV4dHJhIElP
VExCDQo+ID4+Pj4gZmx1c2guDQo+ID4+Pj4NCj4gPj4+PiBJdCBpcyBub3QgY2xlYXIgaWYgcGF5
aW5nIHRoaXMgY29zdCB0byBiZWNvbWUgYXRvbWljIGlzIGFjdHVhbGx5DQo+ID4+Pj4gc29tZXRo
aW5nIGFueSB1c2UgY2FzZSBuZWVkcy4NCj4gPj4+Pg0KPiA+Pj4+IFNvLCBJIHN1Z2dlc3Qgd2Ug
dGhpbmsgYWJvdXQgYSAzcmQgb3AgJ3dyaXRlIHByb3RlY3QgYW5kIGNsZWFyDQo+ID4+Pj4gZGly
dGllcycgdGhhdCB3aWxsIGJlIGZvbGxvd2VkIGJ5IGEgbm9ybWFsIHVubWFwIC0gdGhlIGV4dHJh
IG9wIHdpbGwNCj4gPj4+PiBoYXZlIHRoZSBleHRyYSBvdmVoZWFyZCBhbmQgdXNlcnNwYWNlIGNh
biBkZWNpZGUgaWYgaXQgd2FudHMgdG8gcGF5IG9yDQo+ID4+Pj4gbm90IHZzIHRoZSBub24tYXRv
bWljIHJlYWQgZGlydGllcyBvcGVyYXRpb24uIEFuZCBsZXRzIGhhdmUgYSB1c2UgY2FzZQ0KPiA+
Pj4+IHdoZXJlIHRoaXMgbXVzdCBiZSBhdG9taWMgYmVmb3JlIHdlIGltcGxlbWVudCBpdC4uDQo+
ID4+Pg0KPiA+Pj4gYW5kIHdyaXRlLXByb3RlY3Rpb24gYWxzbyByZWxpZXMgb24gdGhlIHN1cHBv
cnQgb2YgSS9PIHBhZ2UgZmF1bHQuLi4NCj4gPj4+DQo+ID4+IC9JIHRoaW5rLyBhbGwgSU9NTVVz
IGluIHRoaXMgc2VyaWVzIGFscmVhZHkgc3VwcG9ydA0KPiBwZXJtaXNzaW9uL3VucmVjb3ZlcmFi
bGUNCj4gPj4gSS9PIHBhZ2UgZmF1bHRzIGZvciBhIGxvbmcgdGltZSBJSVVDLg0KPiA+Pg0KPiA+
PiBUaGUgZWFybGllciBzdWdnZXN0aW9uIHdhcyBqdXN0IHRvIGRpc2NhcmQgdGhlIEkvTyBwYWdl
IGZhdWx0IGFmdGVyDQo+ID4+IHdyaXRlLXByb3RlY3Rpb24gaGFwcGVucy4gZndpdywgc29tZSBJ
T01NVXMgYWxzbyBzdXBwb3J0IHN1cHByZXNzaW5nDQo+ID4+IHRoZSBldmVudCBub3RpZmljYXRp
b24gKGxpa2UgQU1EKS4NCj4gPg0KPiA+IGlpdWMgdGhlIHB1cnBvc2Ugb2YgJ3dyaXRlLXByb3Rl
Y3Rpb24nIGhlcmUgaXMgdG8gY2FwdHVyZSBpbi1mbHkgZGlydHkgcGFnZXMNCj4gPiBpbiB0aGUg
c2FpZCByYWNlIHdpbmRvdyB1bnRpbCB1bm1hcCBhbmQgaW90bGIgaXMgaW52YWxpZGF0ZWQgaXMg
Y29tcGxldGVkLg0KPiA+DQo+IEJ1dCB0aGVuIHdlIGRlcGVuZCBvbiBQUlMgYmVpbmcgdGhlcmUg
b24gdGhlIGRldmljZSwgYmVjYXVzZSB3aXRob3V0IGl0LA0KPiBETUEgaXMNCj4gYWJvcnRlZCBv
biB0aGUgdGFyZ2V0IG9uIGEgcmVhZC1vbmx5IElPVkEgcHJpb3IgdG8gdGhlIHBhZ2UgZmF1bHQs
IHRodXMgdGhlDQo+IHBhZ2UNCj4gaXMgbm90IGdvaW5nIHRvIGJlIGRpcnR5IGFueXdheXMuDQo+
IA0KPiA+ICp1bnJlY292ZXJhYmxlKiBmYXVsdHMgYXJlIG5vdCBleHBlY3RlZCB0byBiZSB1c2Vk
IGluIGEgZmVhdHVyZSBwYXRoDQo+ID4gYXMgb2NjdXJyZW5jZSBvZiBzdWNoIGZhdWx0cyBtYXkg
bGVhZCB0byBzZXZlcmUgcmVhY3Rpb24gaW4gaW9tbXUNCj4gPiBkcml2ZXJzIGUuZy4gY29tcGxl
dGVseSBibG9jayBETUEgZnJvbSB0aGUgZGV2aWNlIGNhdXNpbmcgc3VjaCBmYXVsdHMuDQo+IA0K
PiBVbmxlc3MgSSB0b3RhbGx5IG1pc3VuZGVyc3Rvb2QgLi4uIHRoZSBsYXRlciBpcyBhY3R1YWxs
eSB3aGF0IHdlIHdlcmUNCj4gc3VnZ2VzdGluZw0KPiBoZXJlIC9pbiB0aGUgY29udGV4dCBvZiB1
bm1hcGluZyBhbiBHSU9WQS8oKikuDQo+IA0KPiBUaGUgd3Jwcm90ZWN0KCkgd2FzIHRoZXJlIHRv
IGVuc3VyZSB3ZSBnZXQgYW4gYXRvbWljIGRpcnR5IHN0YXRlIG9mIHRoZSBJT1ZBDQo+IHJhbmdl
DQo+IGFmdGVyd2FyZHMsIGJ5IGJsb2NraW5nIERNQSAoYXMgb3Bwb3NlZCB0byBzb3J0IG9mIG1l
ZGlhdGluZyBETUEpLiBUaGUgSS9PDQo+IHBhZ2UgZmF1bHQgaXMNCj4gbm90IHN1cHBvc2VkIHRv
IGhhcHBlbiB1bmxlc3MgdGhlcmUncyByb2d1ZSBETUEgQUlVSS4NCg0KWW91IGFyZSByaWdodC4g
SXQncyBtZSBtaXN1bmRlcnN0YW5kaW5nIHRoZSBwcm9wb3NhbCBoZXJlLiDwn5iKDQoNCj4gDQo+
IFRCSCwgdGhlIHNhbWUgY291bGQgYmUgc2FpZCBmb3Igbm9ybWFsIERNQSB1bm1hcCBhcyB0aGF0
IGRvZXMgbm90IG1ha2UNCj4gYW55IHNvcnQgb2YNCj4gZ3VhcmFudGVlcyBvZiBzdG9wcGluZyBE
TUEgdW50aWwgdGhlIElPVExCIGZsdXNoIGhhcHBlbnMuDQo+IA0KPiAoKikgQWx0aG91Z2ggSSBh
bSBub3Qgc2F5aW5nIHRoZSB1c2UtY2FzZSBvZiB3cnByb3RlY3QoKSBhbmQgbWVkaWF0aW5nIGRp
cnR5DQo+IHBhZ2VzIHlvdSBzYXkNCj4gaXNuJ3QgdXNlZnVsLiBJIGd1ZXNzIGl0IGlzIGluIGEg
d29ybGQgd2hlcmUgd2Ugd2FudCBzdXBwb3J0IHBvc3QtY29weQ0KPiBtaWdyYXRpb24gd2l0aCBW
RnMsDQo+IHdoaWNoIHdvdWxkIHJlcXVpcmUgc29tZSBmb3JtIG9mIFBSSSAodmlhIHRoZSBQRj8p
IG9mIHRoZSBtaWdyYXRhYmxlIFZGLiBJDQo+IHdhcyBqdXN0IHRyeWluZw0KPiB0byBkaWZmZXJl
bnRpYXRlIHRoYXQgdGhpcyBpbiB0aGUgY29udGV4dCBvZiB1bm1hcHBpbmcgYW4gSU9WQS4NCg==
