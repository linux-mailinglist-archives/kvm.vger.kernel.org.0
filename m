Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D072D6BC250
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjCPART (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjCPARR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:17:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A80585B3B;
        Wed, 15 Mar 2023 17:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678925835; x=1710461835;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y1MVpcc2Ce2dPcNtlFWbu6inF+aLTRfFXzcQIJE48Hs=;
  b=KAgNoRCun20XjF9He44WlaWDIQLURBx5ZwRzkJGQHuO8KcFsSwiE9nCA
   so8nMNq9d+KB5+07HsMjI81IijH6nEXbgRQFd22OkCzqus0FsJF79hT0S
   /3DVzVnwPwFRTpvUxwxQVJk2Zifqw5GDZNW//QbKLqnXuJBfhcRiXqUcQ
   OFwVciawgzS+M2m13iMg/uV3Wd/Okh44GaHe8cogam+24t1UKkw3MdKfG
   r1OAI2hC1sBHiuEBO+9X3MBeM4H7joFIu1hub5vliqOjJBPGnvQmEy5lS
   Cv/XfqQrdawCePkAST0O+N40cegYugZzAxdmILOOAwiTwpnSWflWXV7Ap
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="340214529"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340214529"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 17:17:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="629645631"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="629645631"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 15 Mar 2023 17:17:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 17:17:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 17:17:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 17:17:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 17:17:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSPDxD4pawZZXUUTAYYbzwsQOy/z+hFjX98nSFM7GvLVrtZMifz307D3qt7hKMMwXGMNYcB5MGRWovlFji/mvvAh3wnI76rax1L8tnDos7eFn1zzH+A4ztGc569/afq5U/1qMqWoeIJwYMgf3qSN+18Hx0mwr6z201g8t0c1+2Euhdq/PeSniUz/JdAafQKwKAyY9bIGG68tZSmOW/cF7mN5hTCnQkTI46DBzEvJyXdCgCIoWWkDeJY6x/vJtWbQoWtJNR1dOSZTk32yYkkPPRrXD74szQ5DIbRIjkn9k8SNOqdRowA++6+l277YUEYkwkqti/jXJ44siRMIx4IAlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1MVpcc2Ce2dPcNtlFWbu6inF+aLTRfFXzcQIJE48Hs=;
 b=PpIh073PRjHYVh78PxUacggvrPzdDCtM8h+1axhLfDPD3OBiPK8E5E3YgCeYKqbuY4NIWxONjGSocH3hp4cTJ0hHv0fn1gW4tBlJk90Wz4ec3R3PMKEtt7wsHyIRBC2GK2ZnarENBrnA9Zx2pL8KbUA/7He3IkdGgkflLDiSA6Soz95sTObaA+gAF1PVhZCdDejlXE51gHSaYEFGMNYr1b97+7wDCkiY7Ufx1QqTilFTw9SFwms2Mckg9BVgCgck3FTmEcp+E0jgXKkHkhf4c41mw1dYrJIpOk1sX3UzLPF96rMmPfRbxE8U0eOyLIpuRGVDCqExketgpReepry6jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6548.namprd11.prod.outlook.com (2603:10b6:510:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 00:17:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.030; Thu, 16 Mar 2023
 00:17:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq7zRkyAgAdh/YCAAL9UkIAAAa0AgAAIMwCAACIVAIABAddA
Date:   Thu, 16 Mar 2023 00:17:11 +0000
Message-ID: <BN9PR11MB52761ADF0DBE0D81AD856BB58CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBDCCYLJn32Yk/eI@Asurada-Nvidia>
 <BN9PR11MB52766160C546FA5075B191258CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFj8AZ4gWOW1PQs@Asurada-Nvidia>
 <BN9PR11MB5276FDB32A40B521C0E351E68CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75295B8B4352698CB165B300C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75295B8B4352698CB165B300C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6548:EE_
x-ms-office365-filtering-correlation-id: 8be198b7-13b6-4c74-1d65-08db25b3c96e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uaiCzXlCjpW/eXOCBZuPA2bWRz5bGeLt4si8RoQFSBpmkpTuJv4+Hhfx7l49JXWlTBNDHFa4JNYNq9MDPG8QI8hpN4hGz1+QEXeIx4W1rLcO/cZAoHfJsBu/AI+apiT79t36nBMJnGBCd2gMUCZSWJjJKGwN6EeAXJpUoO6fPQiY/+X0qotU9/cNOUtYd+FW7X+8tMO9q4SxrJu0Yp8jW5FvdFHk9p4uzYcKM9vPTVBRbpya5WbEW2E1ZCq4oe0vLY4hd5lFv3/kHZJtSdEWsxF+lGi3li4mUr3xzFSx9PVvL3WrEV7vm2DAgsW4pmFDt1njltcTvzQTPDPoSRD0U6pBlvsBC5Y+gjGUJ/MV62aAkJnrMxVDK0mfisklG1m+qhVeJkReM5AdADKhAUsiFy5rxem8lW0jVl/xw5vb/WQUhCp4lfZFK3oW0EBefeB4ImvBIcYcnY0txcGMZmxIwmxoTRciVDe0/H8K8lJLgWXXR8BcuL6aBXtUGwDF4SM/LBvLdlaEHyq+ddCsg/RR2a/J8hgt/cAXXUulqQEXd55U+px2H8fFCCkqArwLYW5K5wvNeJM47/aZ9teGOdTF5ht1de2ITry/jH5YDbXMuk6sM5gzxInqFBO4O9RPvkRd4igQafeU2vQAXH1CovnHI93NQcIcFnfH9D48fmzjASDlSgK5SRnxeAXJqSgYzLQFeLSBmiqtaQqXSfGiVWO1Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199018)(82960400001)(122000001)(2906002)(5660300002)(7416002)(33656002)(66446008)(86362001)(52536014)(41300700001)(8936002)(38070700005)(66476007)(76116006)(66946007)(64756008)(66556008)(316002)(110136005)(38100700002)(8676002)(4326008)(55016003)(54906003)(9686003)(478600001)(186003)(83380400001)(6506007)(26005)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0dpbTVMamJrb285MU1KWkNJT2JuZS81OXhCcUVINGRGN0RXUHNQYkdiMTZ3?=
 =?utf-8?B?aVUvYkVqZW5UZXlWWTg5Q2VWY3NLUUF1SG50dmovRWtHYloyZ09DRkorRW9r?=
 =?utf-8?B?V1ZrYU56R2ZNQmwwVXVqSFFiR1haV0JFTVdnUHoyL3FNQytHY1BBUmpGZUJX?=
 =?utf-8?B?QUovWmxyNWxEOUN3Y1ozamsrYmszSVEwY0FNYXA5M0VWSGdvbzJCdi9xMkZW?=
 =?utf-8?B?L0cwZDd4ZHlZYUtRd3c3TkdkQ0ltTHVzdzdTUG5VdXdjcjdCUkNPYVdGa1Bv?=
 =?utf-8?B?c1ZjTGR1d2FzK2ZvWXQzQ2htT1ZZM0xWcGNmS3B5ZzROYXA0UzZCR2lUd2JQ?=
 =?utf-8?B?anpta2VPR1h6NW4yaTEwbHhmR0trVDZCRUROQjNkV2QyNUx4NUdZcko0Zml0?=
 =?utf-8?B?Vk1JNVlxcnVKaXRtaUsxOWxJdVZZMXdKeVRrV041bG1TSXB0WHNkdWJrbFN6?=
 =?utf-8?B?cnk0WnRXYW1palBJbENQZnBKUGsyaktJeGg3V3pOcUpVSlZDeHd5TEhZaUFJ?=
 =?utf-8?B?Vno0RWxacEMxTkxUMWpwcW81UFk0N201SSs4bjN4eXM1OExLVTBMTVZ5Y3hU?=
 =?utf-8?B?MGhwUlNlOHNnNWdheWF5OVpiS3Y5RlN1L0JoNVU2QmovZlNjVEpXQjNTS3FZ?=
 =?utf-8?B?dE5hS2wyVVpOMElLcG05UzMrci81V3p3elBrSmsycXpEL1c0Z0l1eGxTMWJR?=
 =?utf-8?B?bCtSbkhKSVVnU1MwemNhV3JsbnJyckVQK3dpdWJYYkl1cmdXNTNraTdTbFJh?=
 =?utf-8?B?WmgrWXljQnhUR2xTYStLeWJqV2hybzFFV09HanFhcEEzYnRaUXkxbE9GOEdo?=
 =?utf-8?B?VzVHcjM3V2VBWTBnRlJyM1Y4bmsxbnhmQ250d3pzY0llRHFOMGQraUlDaWxW?=
 =?utf-8?B?dXhzMlJJK1BueStRWVBveE1vVUFZT21lMUhWZE5HemlSeHcwZ2V1NG9WZ1Vy?=
 =?utf-8?B?WE10Y2JpU2llczJRUzNNVWpWR0tmOGdhb2J1U0xnOGVHRlFiSytJQ3lwNGc2?=
 =?utf-8?B?YXphYW0rUFVnV1dwZEpjNmhLWjNrSk94R3E1Nk9xTURCVUtUT2NneEwvYnhy?=
 =?utf-8?B?TWkySkwxbzNpVm5xSmNiMXh3L3F1SlpzcnRoY3BOZkhqNGpnOUhqazhJWGIx?=
 =?utf-8?B?OEwvb3BCdTNpdzZOcjI0NWc5Yi90TDkvczczZ2hPVjNrMWhMT21mK09DS3Uw?=
 =?utf-8?B?K3h2WVQ2TTlmd2pLQk0vUEJMcktlM1V1eFAveEtBd0dpaVZJNmllMkcwMTlK?=
 =?utf-8?B?TGRqYW83WnNaVEpFQi9LcFZKa05YY0JpWEN0bk52b05WaFNPWXNITkovR2pZ?=
 =?utf-8?B?TU93WEhPOVFjd1oyY3NJYTlTbWJXTytqMFZ2clcvOVBJVkQ5L3gvdTJ4bHhX?=
 =?utf-8?B?MW9DMUk2YzVSRy9kTlp1cW1aU3E4N3MvUTV2N1BPMXVzL1JLNHpBd1NyNzJx?=
 =?utf-8?B?K0kvRUkxTnplWnMxNG1Tc1FEWFBFVVBhSCtUOGx4VGwyb21ZMGRrazNKNkRM?=
 =?utf-8?B?dTB6YlpCaG9yMWhQUXFYV1UzY2haVGFBQUJ5MlAvbmZUcDljVGhrVmFCeXZ0?=
 =?utf-8?B?U21UZkhMUnlYTkt6UEpnQTBuMG5heXFIZkVzWTNVY3ptOTA3V3FNSUdNUDFs?=
 =?utf-8?B?OTFPZ2U0ckNDWkhnTlpIcXVzZ0FCblNqQlJ5SG9Eb2lRYmlpcWp2Nm1aSDJH?=
 =?utf-8?B?V3JHOUplNjhzeDl2aGJmVmRMRXdRV0pOdFFmdzVOZFNHdzBFZVJlU2pSWFg1?=
 =?utf-8?B?cUR5SHo2YU85TnZ5cFlHeHIyTGY5VWcwK3NaM3BHaHdLcEtKbHMzUmx0Y2Ni?=
 =?utf-8?B?dGZEa2RJUElCWDhtRU5RNHlJUW1ncFRJZVlGWWVIWlorS3Q3cXZDNFZzcENl?=
 =?utf-8?B?cXh2eXoxNjZXa3dFUWdwcXl5WlRzSktBSjUvc2xXRmpuSkl0bTJxOTRUb2Nq?=
 =?utf-8?B?R1gyd2FUV0RSRmorbjM4cWhzdEtGTUtCaTNUK1NrMDBjSFJzOVFtc2lZU0ZX?=
 =?utf-8?B?NGFBWis1V3I5aFpVN0ZMNUo4Rkd0NW5xTFMxUkRnTjZIZzZSMXorYW5CRjdF?=
 =?utf-8?B?QjlIbU1KUjRVbXV6dVR1TFVsVGhXMk1OVGw4TFJMU0NqZkVxbU81eTRlMFFk?=
 =?utf-8?Q?Jt6NwZmn0JyEHezX5R7IXZkZe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be198b7-13b6-4c74-1d65-08db25b3c96e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 00:17:11.1550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Aa/iPqVXOKiYeBHQLHPoo7TDtFd9U/Jyb0BhTchZYSzyoU1Riolvjf6UHiMuFckb6/c4DH6qTimE4x7F8Qo9SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6548
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBNYXJjaCAxNSwgMjAyMyA0OjUzIFBNDQo+IA0KPiA+IEZyb206IFRpYW4sIEtldmluIDxrZXZp
bi50aWFuQGludGVsLmNvbT4NCj4gPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDE1LCAyMDIzIDI6
NTIgUE0NCj4gPg0KPiA+ID4gRnJvbTogTmljb2xpbiBDaGVuDQo+ID4gPiBTZW50OiBXZWRuZXNk
YXksIE1hcmNoIDE1LCAyMDIzIDI6MjIgUE0NCj4gPiA+DQo+ID4gPiBPbiBXZWQsIE1hciAxNSwg
MjAyMyBhdCAwNjoxNjozN0FNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiA+ID4gRXh0
ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4g
PiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gPiBGcm9tOiBOaWNvbGluIENoZW4NCj4gPiA+ID4gPiBT
ZW50OiBXZWRuZXNkYXksIE1hcmNoIDE1LCAyMDIzIDI6NTEgQU0NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IE9uIEZyaSwgTWFyIDEwLCAyMDIzIGF0IDAyOjA4OjE1QU0gKzAwMDAsIFRpYW4sIEtldmlu
IHdyb3RlOg0KPiA+ID4gPiA+ID4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcg
bGlua3Mgb3IgYXR0YWNobWVudHMNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+ID4gPiA+ID4g
U2VudDogV2VkbmVzZGF5LCBNYXJjaCA4LCAyMDIzIDk6MTQgUE0NCj4gPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+ID4gQEAgLTQ0OSwzMyArNDUwLDE4IEBAIGlvbW11ZmRfYWNjZXNzX2NyZWF0ZShz
dHJ1Y3QNCj4gPiA+IGlvbW11ZmRfY3R4DQo+ID4gPiA+ID4gKmljdHgsDQo+ID4gPiA+ID4gPiA+
IHUzMiBpb2FzX2lkLA0KPiA+ID4gPiA+ID4gPiAgICAgICBhY2Nlc3MtPmRhdGEgPSBkYXRhOw0K
PiA+ID4gPiA+ID4gPiAgICAgICBhY2Nlc3MtPm9wcyA9IG9wczsNCj4gPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+ID4gLSAgICAgb2JqID0gaW9tbXVmZF9nZXRfb2JqZWN0KGljdHgsIGlvYXNfaWQs
IElPTU1VRkRfT0JKX0lPQVMpOw0KPiA+ID4gPiA+ID4gPiAtICAgICBpZiAoSVNfRVJSKG9iaikp
IHsNCj4gPiA+ID4gPiA+ID4gLSAgICAgICAgICAgICByYyA9IFBUUl9FUlIob2JqKTsNCj4gPiA+
ID4gPiA+ID4gLSAgICAgICAgICAgICBnb3RvIG91dF9hYm9ydDsNCj4gPiA+ID4gPiA+ID4gLSAg
ICAgfQ0KPiA+ID4gPiA+ID4gPiAtICAgICBhY2Nlc3MtPmlvYXMgPSBjb250YWluZXJfb2Yob2Jq
LCBzdHJ1Y3QgaW9tbXVmZF9pb2FzLCBvYmopOw0KPiA+ID4gPiA+ID4gPiAtICAgICBpb21tdWZk
X3JlZl90b191c2VycyhvYmopOw0KPiA+ID4gPiA+ID4gPiAtDQo+ID4gPiA+ID4gPiA+ICAgICAg
IGlmIChvcHMtPm5lZWRzX3Bpbl9wYWdlcykNCj4gPiA+ID4gPiA+ID4gICAgICAgICAgICAgICBh
Y2Nlc3MtPmlvdmFfYWxpZ25tZW50ID0gUEFHRV9TSVpFOw0KPiA+ID4gPiA+ID4gPiAgICAgICBl
bHNlDQo+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgYWNjZXNzLT5pb3ZhX2FsaWdubWVudCA9
IDE7DQo+ID4gPiA+ID4gPiA+IC0gICAgIHJjID0gaW9wdF9hZGRfYWNjZXNzKCZhY2Nlc3MtPmlv
YXMtPmlvcHQsIGFjY2Vzcyk7DQo+ID4gPiA+ID4gPiA+IC0gICAgIGlmIChyYykNCj4gPiA+ID4g
PiA+ID4gLSAgICAgICAgICAgICBnb3RvIG91dF9wdXRfaW9hczsNCj4gPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+ID4gICAgICAgLyogVGhlIGNhbGxpbmcgZHJpdmVyIGlzIGEgdXNlciB1bnRpbCBp
b21tdWZkX2FjY2Vzc19kZXN0cm95KCkNCj4gKi8NCj4gPiA+ID4gPiA+ID4gICAgICAgcmVmY291
bnRfaW5jKCZhY2Nlc3MtPm9iai51c2Vycyk7DQo+ID4gPiA+ID4gPiA+ICsgICAgIG11dGV4X2lu
aXQoJmFjY2Vzcy0+aW9hc19sb2NrKTsNCj4gPiA+ID4gPiA+ID4gICAgICAgYWNjZXNzLT5pY3R4
ID0gaWN0eDsNCj4gPiA+ID4gPiA+ID4gICAgICAgaW9tbXVmZF9jdHhfZ2V0KGljdHgpOw0KPiA+
ID4gPiA+ID4NCj4gPiA+ID4gPiA+IHRoaXMgcmVmY250IGdldCBzaG91bGQgYmUgbW92ZWQgdG8g
dGhlIHN0YXJ0IGdpdmVuIG5leHQgcGF0Y2gNCj4gPiA+ID4gPiA+IHJlbW92ZXMgdGhlIHJlZmVy
ZW5jZSBpbiB0aGUgY2FsbGVyIHNpZGUuDQo+IA0KPiBUaGlzIGNoYW5nZSBpcyBvayBidXQgc2Vl
bXMgbm90IG5lY2Vzc2FyeS4NCj4gDQo+IFllcywgdmZpb19pb21tdWZkX2VtdWxhdGVkX2JpbmQo
KSB3aWxsIG5vdCBoYXZlIHJlZmVyZW5jZSBvbiB0aGUNCj4gaWN0eCBhZnRlciB0aGUgbmV4dCBw
YXRjaC4gSG93ZXZlciwgaXQgZ2V0cyByZWZlcmVuY2Ugb25seSBiZWNhdXNlIGl0DQo+IHdhbnRz
IHRvIHN0b3JlIGl0IGluIHZmaW9fZGV2aWNlLiBOb3csIGl0IGRvZXMgbm90IHN0b3JlIGl0LiBT
byBubyBnZXQuDQo+IEkgdGhpbmsgdGhlIGNhbGxlciBvZiB2ZmlvX2lvbW11ZmRfZW11bGF0ZWRf
YmluZCgpIHNob3VsZCBlbnN1cmUNCj4gdGhlIGljdHggaXMgdmFsaWQuIEFsc28gY2hlY2sgdGhl
IHBoeXNpY2FsIGRldmljZSBiaW5kLiBTbyBtYXliZSBub3QNCj4gbmVjZXNzYXJ5IHRvIGdldCBp
Y3R4IGJlZm9yZSBjYWxsaW5nIGlvbW11ZmRfYWNjZXNzX2NyZWF0ZSgpLiBUaGlzIGlzDQo+IHRo
ZSBzYW1lIHdpdGggdGhlIHZmaW9faW9tbXVmZF9waHlzaWNhbF9iaW5kKCkgd2hpY2ggY2FsbHMN
Cj4gaW9tbXVmZF9kZXZpY2VfYmluZCgpIHdpdGhvdXQgaWN0eCBnZXQsIGFuZCBpb21tdWZkX2Rl
dmljZV9iaW5kKCkNCj4gYWxzbyBnZXRzIGljdHggaW4gdGhlIGVuZC4NCj4gDQoNCllvdSBhcmUg
cmlnaHQuIEkgb3Zlcmxvb2tlZCB0aGUgZmFjdCB0aGF0IGljdHggaXMgYWxyZWFkeSBoZWxkIGJ5
IHRoZQ0KY2FsbGVyIG9mIGJpbmQuDQo=
