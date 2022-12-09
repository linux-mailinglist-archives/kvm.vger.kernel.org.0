Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25EE6488B1
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 19:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLIS4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 13:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiLIS4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 13:56:36 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6144CA4302;
        Fri,  9 Dec 2022 10:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670612195; x=1702148195;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0N/B3McSUWucYVSPZ9npi0//QYQxqoxF7k2iYYYmaBE=;
  b=C0mUHTQwdVY1vOCR+o0oCui2JIV7yHtqTNpoiU5jeys71kMxJcQ6akb5
   2toqc3iGiM2y3bvAYrrjrDzuTzt8jXPJb9dFSefZWxTJ/8CaF1oHRXYva
   mJx1zFwRQEUdSpDA8j2SDoJSzhwIZzQ5U+ruMS6hxhlk6l9xfHbSq+FgB
   o+GHSrUbBM4+os5/w74dwy8yst08UcdAJmD8t54mmvmQDiZYCU4hx9sLV
   t9Ur77OQAb+WM6+07LSF2di5e41kJCfemRfc0KWGZ7kaenpFRfqZ+yPyl
   9+q8108tWlh1f9sDE8lTa0r1WIdBiu684swzkUFJpFs3pppz3nROF9Qbo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="379742266"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="379742266"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 10:56:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="736305438"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="736305438"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Dec 2022 10:56:34 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 10:56:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 10:56:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 10:56:32 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 10:56:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmA72rcsB8Oj3UVaWV++hjHN6xuIE/IeCzX9iygvjL9LtBqYZF1lTqxBZ9dGD1LEJZl4YESTnLqDLYjs4a+LZX1owcxtfUAbVDCrTNQ0lmh9AljjQbTnQW2m4+eT4lW0cDx5vLVJUkQzRyGR4jPgU1ZOh70H1NFOV+4AzDYLhBRiWfM2EVRxY05bTnMcttFJCHQPkoWlzpYlrswZQOwrhaOiJuENvnqQMcawID9tdBDpiIfWwzEMkd656rrvoXi1s5kEGJluMnaldHE2vyDRFG7zvYnwbvKzcHcBV8uEAMfnmLKmYUtEmwpmXUYiJrLEl8daW+8zJbA6ok8lI0GB7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0N/B3McSUWucYVSPZ9npi0//QYQxqoxF7k2iYYYmaBE=;
 b=RkRaayFZ+S0mT+N70ghzlwyEhlBYWm2tWcKzoN9xuY1+Ucz/vCHZ0feAPVKu3EgQz6/lyINvS+Ovtbo2c+mFT1ebPImQcqfmyt5BlAW3J7qlk7QRXfNB4MBnC2HJGtyO53FQGdiPhsdP5lMggg724xbRcwBYGH8tX+K+MgtfyyI9oy77FvxEErZphsVO2M+HmkPX6oPVAeXmywm/U+V63dS1ngYsU/NRZpQr9mKVs7fDfeV8vqFh7KZG702yTjDLISl8UxvRYxIfUocXUU+sfJfBff7aO2IJ1q983c8a9mhz1vRwbj9r8LQFjMRuiswm0QpPT0p+1xm2JvdQ4o2JKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 18:56:24 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::bf35:8df2:dcf2:1232]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::bf35:8df2:dcf2:1232%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 18:56:24 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
CC:     "Rao, Lei" <lei.rao@intel.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>, "kch@nvidia.com" <kch@nvidia.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Li, Yadong" <yadong.li@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "stephen@eideticom.com" <stephen@eideticom.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Subject: RE: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Thread-Topic: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Thread-Index: AQHZCTfLVudoTcTfbUW71RdNMUs3aK5gYwIAgAB8LwCAAAPrAIAAF5SAgAAEXoCAAAOwgIAAEcqAgAAnS4CAANPxgIAAXv0AgAAE+4CAABT+gIAAGaOAgAAOwACAABFFgIAAGmYAgAH6rFCAARSRwA==
Date:   Fri, 9 Dec 2022 18:56:24 +0000
Message-ID: <BL0PR11MB3042C010D7673B87C3C3C7B78A1C9@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de>
 <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de>
 <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de>
 <Y5DOAKArjyfb6Mcz@ziepe.ca> <20221207183333.GA7049@lst.de>
 <Y5DyorZJPdtN5WcX@ziepe.ca>
 <BN9PR11MB52762EC4F67AF2198EB379FF8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52762EC4F67AF2198EB379FF8C1C9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|PH0PR11MB5658:EE_
x-ms-office365-filtering-correlation-id: 317dd1c8-69e8-4bd3-98d3-08dada1711c5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4/CBgC17SfNq8PMqtPkbIJS063broIJn8w6DNT+d1hEL3rx6l5JArEFIzW+SJeu5xDs5nkZQKX3DUADwiPrwhDfUBdJ/ObyDU7oQ2BOumibIFIgNCtRsw8F30rGma+9aFzeQFbUEMdKVIsajeiTrCXqa1cgDzpMXyjABb8UzRyoLCNmUKFuugW/9wmo+5DsW9DzKE2SvvmIMt0FUFilkQ/+t0PW3HPcxt0qgMzUOkOCc4XsX85zE+VWi5CM9BmiWKSsnI+FZYcOqyMeoZ0LHgt8rnrEq3Nypq//teXEm47tLkzxF/8eKxm6X39rEagYVzzCYpTyigVY3tScRwWO7YnnoSxqSTb2DcyD4NljwmBgyJOJK9IucfhyIpmfQ1uPHs2eWrXiPJwWL6RDhOpWOfmBEZkJD6XSap17CO7jSC8nGrCswsrMEksMB7gvk7G98rJ16i43hD0RhEugoQwmUoAeJW6DMTiDVl/7zumAv+H9D1E4oMpLB6R6kS4GGvv2YtctRnotkBCcVw7KIw4jx1sPjVD8OKoQNri6YcsBbF9Ll6CFhd39BJUcCX952NZgBmhJEq7XiJe9JfD2INgcnN/w+gCOVEUV8/UuiMc+6J3HoclKqNX5XLTf+4OEK4RJywgppCqDNUw6G7JFtu2Vp3XLqYmyIAyFz7WbO8z6pLC4e9ZNwYTQXXmIs1UfXicAeLvQmELR1BVdp8AMCEXxsCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199015)(6506007)(7696005)(41300700001)(4326008)(52536014)(66446008)(66556008)(66946007)(66476007)(71200400001)(64756008)(8936002)(76116006)(54906003)(110136005)(478600001)(107886003)(316002)(8676002)(86362001)(82960400001)(38070700005)(122000001)(55016003)(9686003)(26005)(186003)(33656002)(38100700002)(5660300002)(4744005)(7416002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjlZNG44TXVqcEZBYWluV3JBOW01QkZZd01MZkhsM2ZBNXNOdUxpRE1aeEM3?=
 =?utf-8?B?N3oxTVlLVitlZUZRdHhRUzNqUkdsbldrWmNoZ2ZHQlFSQ3VCMDIxMEZBb1hy?=
 =?utf-8?B?L2tvVkZ4RjZPckFydnFUMTlRclNFcTlEMkl0VmJ2UCsvZVE1VjFJQmtDTHB0?=
 =?utf-8?B?eStURmQrVUlNTmN4Y1FXTkJXc01WK0ZWS1hJZlpRUm9sRW0yTHJrSmIzNmls?=
 =?utf-8?B?NjJ0aWxnZ0FWUWxNQTFaL3huVTJZS2tIRktjZlZ0eVVjb0xYOEp4bzBndnpY?=
 =?utf-8?B?d0hUcllkcThTU3VrMUFaeEFFcFpJakNtNXV5bEJsS3RhR2ZlaSs4aFdNZkYz?=
 =?utf-8?B?UWFjM0JQREVvZzUrREE0SlU4M0Jyb0F3QjVqcUFqV1NWMmZTVWdZa0IyOGxH?=
 =?utf-8?B?TEhZeWtSN3U2U1l2K29VeitYWnFBM1M0dURKL3dMU0xXL3k0TWl0cGMrSmZm?=
 =?utf-8?B?dEtvTk02d1VlMUZGdmVoN3dadFNuRG1GVkFBaytaeXJwV2liTVNTRk1KbXVP?=
 =?utf-8?B?VlZWWnEvRFVBN0g4Z2E5NnBsZWYrV1VscEMvWkpsTEFwbnplZ2I3b0Q3NHZ2?=
 =?utf-8?B?VzI5YTVFZnliSmpDUGlLNC8vWGxJcW92d3BrRmpTa2VQUW1yQ2V2OW8xWDhY?=
 =?utf-8?B?RGxFb2JkUmVoVlBobzJMbGVnU0pQY0IxT25KVnVFQlpKemdQSHpoRFd1U3dw?=
 =?utf-8?B?ZTBRa2gwQmNNOCtoK3E3TUU5ek4rMk5mUEsxcjFDaXhiSlMraXF6Y2VENnhE?=
 =?utf-8?B?eUVKdEVacjdxaVdiVFA3eGt1bllzUmxSOHYwamtla2g5bE5VMU93Q21tQ3lG?=
 =?utf-8?B?enZwK0Yrd1Y5OFVDa3VUZE0vT01HSEkrU25zTk1jcFlFK1BGbWtRY1RoTWhv?=
 =?utf-8?B?VzZPMGtKeXJUN0ViYkpxV3Z0TWRiNkxZZDNhMU1xNE9xc2dkaEUvdTU5SmZV?=
 =?utf-8?B?bFcybW9ZNzcyZ2R1YytpYkp6NzBDYWl2K1p1eW45bzFwaTAxWllPTWJHNWRZ?=
 =?utf-8?B?cGdPZTFQeWpxV2ptY2ZMeURDSFROWVhWZE1idVdzQVNSWDdVWTBNdEJ2enJp?=
 =?utf-8?B?b1Z2ZDFBcFcyUFlxVUFQcmVCa1pDWHNPU3BBWlR6Ti9uM2RZTDFTbnpZSW4r?=
 =?utf-8?B?VEhjLy9yQzgzd1NPVzJBdW1BYWNwODJlTWJPN0hQRHBVYTJGY2N3U01Ua21L?=
 =?utf-8?B?NXhjM2s1ekFVTHZKdUlTUTNTdHU3ZkFGdnBTUDRIOWIvaERETy9xVXlQb0t6?=
 =?utf-8?B?c0o5Y0tpbjFtNTNJTk1Td2FoS1VKdkNzdmxCaGlzT3BaTmxSN0NxaksrUnZr?=
 =?utf-8?B?MXZTUU83MTZwYU5vUGtjejUySHg2VmZqSkI1azNBdGhrQmZFaU1TY29ReEdq?=
 =?utf-8?B?bFc2R0s0SkxzeVAwbEYyK21oU1ZzWXhJbDNKa1RNcU5kb25hM3d5SjJrVk1W?=
 =?utf-8?B?OUYzY0pKUnk0bnhObkNCSkg2RXY4dGJldUcvc25ka3ZFanZXbHp0REFLU1A1?=
 =?utf-8?B?cjVJL2c3TE9rSzQxQUxBdTJBSElsWFRlQkREemRvY2dlSHFsbk5yeHhHZlA0?=
 =?utf-8?B?aXFWL1J4Vm8zYzJsTTAvRGNvdEthMklSbkFkUTBTMGxHMkV2cW1NSWNmSzRG?=
 =?utf-8?B?SUFmZWk4MjJjb1I2aEkwb2tIdnNKZk44bUpOcjhDSzhGMGoxSU84dGlGRDJG?=
 =?utf-8?B?b1QxOHNoUnNxL3grQlBTMlFKM0JJOW82ODZLYVNxeUFpdVhXbXJpcGcyOVg3?=
 =?utf-8?B?RzNlWWtmdE41OVFxYWk3Y3R4cGV6bjBjdlh1RkpFaVNuRERtV1pVYkFVN200?=
 =?utf-8?B?clk1bXZIaXh3RXlzTnEzTHgzclNNNkxVdEE0RkJlSlNsU08yRlRWcFdjMDh6?=
 =?utf-8?B?c1NrU0xjL3Fhemx4OTVTWkxTSDBnWGdGM01UcEU3R1lwMmZBM3dZb3dlUGdy?=
 =?utf-8?B?dlhnaGtJM2tuNHNBV1p6R1BmVWFtOStzT3dWOHZQQkRUcTNKR1dpa21zOWkv?=
 =?utf-8?B?UitJS3NkRFU1TmszakhLYmUwcU5wZTZUUElTNnErRVZkdEhQbktiWHJjY3NN?=
 =?utf-8?B?VzRCdkkzRGhYU2kwY09sV1BsTE53V2ZFRmtVeG5MS0xSTGwvTWRHdmJZRC9w?=
 =?utf-8?Q?wGC5pRmyeoc+XxO38OnVbMH7P?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317dd1c8-69e8-4bd3-98d3-08dada1711c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 18:56:24.2986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iZ7rbEiSCqIGE3JaSiZ442w520cmryLYlGDkagmZfM0MsaWOhdQWMrmgBc0WK+msN2En9H1wyvF154lwuEjNfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5658
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gSWYgZm9sbG93aW5nIHRoZSBkaXJlY3Rpb24gaGF2aW5nIGNvbnRyb2xsaW5nIGZ1bmN0
aW9uIHRvIGV4cGxpY2l0bHkgcHJvdmlkZQ0KPiBzZXJ2aWNlcyB0aGVuIGFsbCB0aG9zZSBkb29y
YmVsbHMgc2hvdWxkIGJlIGRlcHJlY2F0ZWQgYW5kIGluc3RlYWQgd2Ugd2FudA0KPiBleHBsaWNp
dCBjb21tdW5pY2F0aW9ucyBiZXR3ZWVuIFZGIGRyaXZlciBhbmQgUEYgZHJpdmVyLg0KDQpIYXJk
d2FyZSBtZWNoYW5pc20gb2YgY29tbXVuaWNhdGlvbiAoZG9vciBiZWxsIGhlcmUpIGNhbiBiZSB1
c2VkIHRvIA0Kc3VwcG9ydCBicm9hZGVyIHNjZW5hcmlvIHdoZW4gVkYgZHJpdmVyIGFuZCBQRiBk
cml2ZXIgcnVuIGluIDIgZGlmZmVyZW50DQpPUyBrZXJuZWxzICh3aGVuIHRoZSBWRiBpcyBhc3Np
Z25lZCB0byBhIFZNKS4NCg0KPiANCj4gRnJvbSB1c2Vyc3BhY2UgZHJpdmVyIHAuby52LiB0aGUg
VkZJTyB1QVBJIGlzIGtpbmQgb2YgYSBkZXZpY2UgcHJvZ3JhbW1pbmcNCj4gaW50ZXJmYWNlLiBI
ZXJlIHdlIGp1c3QgcHJlc2VudCBldmVyeXRoaW5nIHJlbGF0ZWQgdG8gdGhlIGNvbnRyb2xsZWQg
ZGV2aWNlDQo+IGl0c2VsZiAoaW5jbHVkaW5nIHRoZSBzdGF0ZSBtYW5hZ2VtZW50KSB2aWEgYSBj
ZW50cmFsaXplZCBwb3J0YWwgdGhvdWdoIGluIHRoZQ0KPiBrZXJuZWwgdGhlcmUgbWlnaHQgYmUg
bGlua2FnZSBvdXQgb2YgVkZJTyB0byByZWFjaCB0aGUgY29udHJvbGxpbmcgZHJpdmVyLiBraW5k
DQo+IG9mIGEgc3cgZG9vcmJlbGwuIPCfmIoNCg0KWWVzLg0KQW5kIHN3IGRvb3JiZWxsIGlzIG1v
cmUgZWZmaWNpZW50IHRoYW4gaGFyZHdhcmUgZG9vcmJlbGwg8J+YiiAuDQo=
