Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6D36AB115
	for <lists+kvm@lfdr.de>; Sun,  5 Mar 2023 15:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjCEOsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Mar 2023 09:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjCEOsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Mar 2023 09:48:53 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A8EA5DF;
        Sun,  5 Mar 2023 06:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678027732; x=1709563732;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pSWVOLYqIkOOdoXwaKfqdeTDD0mvZJ3y2etd/bxfiqA=;
  b=kZyZrXFeipE4cPG6JHkECZCKDF5NJ166kuktFygeZuzRhUMuIP+gWRG0
   dMrCx/FA1tv9TPeDvFIYYlVwwZib9S4NAn0h4OpXtLq+iIE66VHRliOWs
   mjrOCpkyRoOxsqVOmHSj/L100l+ycrfmLdL6fa6d9Yx/pEA8OmPppiO7q
   +VYCAV/WmUDzz7a1N0k7Uu83o8bZ/lwouAerKLxMVUrkdsqLm0MnmmjYx
   9i9X7jAbrKBWVK5VpaQmKP8d3N4C/OnqYu5cuyhDQ8F5Iqd3MZKcIpBjh
   NLg2XGiSUY/NIeCHLSOh/UC5B5u67EfX7DDAI7w13fB7MpYytn6W5Rfht
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="323689272"
X-IronPort-AV: E=Sophos;i="5.98,235,1673942400"; 
   d="scan'208";a="323689272"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2023 06:48:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="675896577"
X-IronPort-AV: E=Sophos;i="5.98,235,1673942400"; 
   d="scan'208";a="675896577"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 05 Mar 2023 06:48:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 5 Mar 2023 06:48:50 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 5 Mar 2023 06:48:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 5 Mar 2023 06:48:50 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 5 Mar 2023 06:48:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoWdBOfqHup4nQXnzgHwswBaxyNJ6g3qR2i7TGLe3/G4kW6o8HvcVId0IePmY7dWibNKvM+ZLJnQ/gm2FTCnviHrYWEJEIrhN2J8pWC/PabzYaneG3aqYR0AdUWqO0lOxUw9rksgRWXJ+XnUbzArKj+57vT8i0hjWiIRXsd0aTF3dKETZ4DVzeC2Qu4p7IDVUltEFn/Mge1p72IM05JV2osUrKzYt0rSioiXbYhPgzZIJvFkWyQ9nUgb0vneUdteB1Lz2jmScrWRsLphQFbSQY+L5vXsDkwrXQHqRXNcFDNvmMWSq2ofc0ItWUklHj6nsLtHYpEdiTwDIGzrMa7fdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSWVOLYqIkOOdoXwaKfqdeTDD0mvZJ3y2etd/bxfiqA=;
 b=e34WQCo5UJ4vFnR2+zLIvbXLgQWPDypvPwfNlIb7NbmAlOGXizhE5+snZWqcVJKGVt1+uCcSj3GZ/VN7uFOmaq9ExZ7JcOEkX5f5gSNjiGArJxm/WWwXOvK9MArDtchTlVqLydA8wRhkXjAIBZAML3iYQjwSiqe02M07a52cTI9FOvOQYPBCM/Ps3IGAM/DI1GSppmbFEb7eqxxl08yWvtNppayeIeb1r33M097WS3AC6Pxs5eSUajdZmqMUON9LzWkchroH0I/AcyXb1MO63UlbeS+OZWgD3507AFcs30wc8i8JxAeyCQxtC1iv7truXPlVuGjwPaHMJkebsfArlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW3PR11MB4540.namprd11.prod.outlook.com (2603:10b6:303:56::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Sun, 5 Mar
 2023 14:48:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.023; Sun, 5 Mar 2023
 14:48:47 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAC3GEw
Date:   Sun, 5 Mar 2023 14:48:47 +0000
Message-ID: <DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
        <20230227111135.61728-10-yi.l.liu@intel.com>
        <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZACX+Np/IY7ygqL5@nvidia.com>
        <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
In-Reply-To: <20230303095542.2bfce5c2.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW3PR11MB4540:EE_
x-ms-office365-filtering-correlation-id: a30def52-d509-441b-dae0-08db1d88b9e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Dzkh+J6DQszklgzVfsZGjxUf5PGA8GQCGItRdzj/Y2ZqRAAShLVVy4y2L/Cm6X/5mYmEKkzzM+xe+dxGUYleaxnaofRbSBUlmmzNnCiq+1zNocwGqYTz5nPJm7FoaGxmxSL63JhpuHva3nUo17cJm3FaaTsFJm97vHCyjMMeaXAgKkrkuT7lxEHEDMI69Ft3y8+XKspKwnbCm9XD8KlYxQnM6JzM2xutxj8hr8WzXbLnTeqk+LXmFTuUqf8hoNBaKfpF9Gx900oMYX/nqdOf8dAhpj4PW7uhbish+Ze5dYjIKuH+MBeTUKckXkHqixwAmq+i3cDotQO2kgMKj8SX5hH/PYisUa7pWkSiakBVI2p78X3Jbx00ccR4/kVxmGJOGbMgMVF08aSob3HLKbgxbYj/TjUOmpNaFFsZJxMDMZQPt/H+XmQ392w7a2MN9zLyVz2TN+socSaNBI4zeW+DThx3uWsWiNlcqIKQYOm/ruiX2GKazf7tVnh43S/IsuQgJ0y46jyyuvt8chvow9NiEDku5stsosdMq1SPu+yvqkf5qDfeRlpADRIjTC3ZI8NBsgc5D2Jm80VyramzzFRoWmhCJB595RQUiYK1LBwzhZTVCSKupXy5NqyxfsdeDHWyX7aq+5wFfB2wDwXBB0cBnTlVsgGYFwYNcreTwIbHxaXkicI8lo7Fqn9nNtv/EdRTJ8dITiCJhJYGXHHkYFVcrXyCs9Z3V8LKwJWawU5pGk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199018)(8936002)(7416002)(5660300002)(52536014)(66446008)(76116006)(66946007)(66556008)(66476007)(2906002)(8676002)(64756008)(4326008)(66899018)(6636002)(54906003)(110136005)(316002)(478600001)(7696005)(71200400001)(6506007)(26005)(41300700001)(55016003)(122000001)(33656002)(86362001)(82960400001)(83380400001)(38070700005)(186003)(38100700002)(9686003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDFqSkNac3UySDNzNC9FK09yMFBGMmZnbXU2cHZMQWJjcGt0bWNOamM3V3ds?=
 =?utf-8?B?Rks3eEJqY2gvcWJMMG04eGE4alVWQ0hMWmJTSHo0QmNGTnVoVE1qK01CSXRp?=
 =?utf-8?B?Wlg4alRxTVlaMEcycnBvOXhHM09telVObWY0L1VsLzdLSGtQQXZqUXRTbFAx?=
 =?utf-8?B?djJJYUxWblZwMHBsbmw4VjdTYVplWDNaVmUvWUtyMGlpcnZ5a3ArYUtpWHlC?=
 =?utf-8?B?Q3REY2pwNGV6OEc3M0toQmVkMkNrNEE0WnhuWW5rWTNxa0V6YUNZd3ErYjVU?=
 =?utf-8?B?Nk9nQW5iSVVWTTNDZ2ZSa3ZndUZYWTB1WjVpSStsenRiWGxYanRRZ1duOTdL?=
 =?utf-8?B?Y1JUV28zbXloek5KcnBtUWY1T0lWbHVMUVpITWg5S2xZd0RvWTFZSW15SjZw?=
 =?utf-8?B?dExNWmhTS1B6V1dMOGhhWlZZUWFJaWlWMy9WU0VxeHc5b1JOVUxpQ2pGdng3?=
 =?utf-8?B?VGFWcWZNRGp1M0dNVXUwbGxqcnRNNklPeE1MYjZOUVU1QlZVQk9qQlRDR0M3?=
 =?utf-8?B?aVhYMDkrcE5rVjNkd3h1YkNNbklaZk0rWWNRRGJmMFZMZ1VYQ3RVRUNJS3hq?=
 =?utf-8?B?QlFIQkZ5RHdUWlpjLzlVOWFVOVZ1TFFNaENBUU14V0orSEJTd3BvTCtFdGk2?=
 =?utf-8?B?V0Jyckt6aFV6d2Y0QU9wRGJjV1htTDN5VXErbGtlVDhKeVZSV1MvaWhwVGEx?=
 =?utf-8?B?eGc4d2Q1VkxodHh5WUZBWFJtNklVYkFjNU9XOE5paTJIY3ZGdXNkaUlzczFH?=
 =?utf-8?B?NlczZGF3c09NaFJPbHlNbGZ0U05zUk00SnZ5bzUzL1duQ0plaVFhenNUTGhM?=
 =?utf-8?B?Z0tqRlZ3UGJRbTM1c0NyQk42b2VpODVLdlBLWlNpb3VzZUdRWkl0QkF2NGND?=
 =?utf-8?B?V0RUWWV4c0NaaXgzazRlOXQ2ODZIeDh2M2ZOVUZpeHlBczlZb1lDZXVPVnY1?=
 =?utf-8?B?ZEFsaGh3bmExWXdQcVRYVDA0a20rMUdBUXVwdTdSUERJRDVzVzAxS3MrT3Zv?=
 =?utf-8?B?VU5aQ0o2a0hySTVJaWJFSk1ReWxIekplWmlOQk9CRWtSMUNRVVh1NklrcWMw?=
 =?utf-8?B?Vm5PSzJtc3d6Um5CYVl0M0VSVkxjdnlmZ3diWkRKcEFST0RQajVVSEpMdlR3?=
 =?utf-8?B?Y2JUa3BQT2IvQnNKd0ZuOEkrYWMza2JwcnNEUHBvSE5vcnFyR0phNWZMQVd1?=
 =?utf-8?B?VmVYQTE4aXJaQ09rNDYxcTg2YXNWV3Y4b3V4QTBNMEd0a1VxdHFyWmtCYzcz?=
 =?utf-8?B?dFJyS1J0Vm12WlhXWWEvSmxjcUY0WnZIUlZoWWJZN2xoVFROVzIzdDRyVjFE?=
 =?utf-8?B?c2o4amNXZlRKOFpBR3liamhvOGlLdjdjMG14VC9ZMTRJOVZLUGQwV3B4cm9W?=
 =?utf-8?B?T0Y1cHZzWTd6SVNQODA5SWVUdllKaXQyN2NrL2JaaXY5ZlhQaDQzR0c5NmZD?=
 =?utf-8?B?R0xBbnFqVUNRdlFMOHhDaGVkVnc2MFRrSyt3TDQzRTA1NDFHVEt4UHhhNUN3?=
 =?utf-8?B?dzlrMEdzWndBSGorb3dxc1RhY1EyMzZ3eWt5SzdLd01pYldFa3NwZnk0QXRF?=
 =?utf-8?B?Z1A2ZFhaTXBDL1FkV09qN1YvV2FiK3RkNFFYd3pUSGp0Umt4cFBPaE9xeGYx?=
 =?utf-8?B?bUd4b1hTd2VvcGRGemZOOFlETzFqNzhBWmVEOTZnRjd0Uk9UajFXNEJId2Zp?=
 =?utf-8?B?VU9DdWViN3FoR084cUZPY1hkaFdGbktQamlLUTE1MlpvTjZZc0ZGek5FTFpC?=
 =?utf-8?B?S0NqRUlVN09iWU9mRXJEUVYwanFPekdVdnlGVUExV2NUQzBiZGovWmF6N1Z1?=
 =?utf-8?B?WlZHZnl1OGlrRFhPaExJM3h6Smt5ZlZiYTltN0VQM1NhUTR3YytCbU5GN0dq?=
 =?utf-8?B?MFFEVk9tMFRoZDRiYThDTThjSFV0K3VKNmg5YXNWT3RRaGlDc3k5V0pOcGxl?=
 =?utf-8?B?RFZmWTFNN2dCQ2JteWY3L3Y5SCs3a014QjJaTzdBdFJnQ1FwNjM2WDZDVFQ4?=
 =?utf-8?B?VlZ5NnZJc2FWTHU2T1hsYWR2Z3Ztak4wV3JlNlZuOXpxdWhraGcwQmVYQlJz?=
 =?utf-8?B?NElkMkxWejVwYnFhQTA2eTNWQ3RzbmlsclkyZk9TNnZsSVAxeWNHSi83U2pP?=
 =?utf-8?Q?nvqzzB3QzQWGAg54o7/R9kUQw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30def52-d509-441b-dae0-08db1d88b9e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 14:48:47.4037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FmFC7UDqSlLOW96RHLbqkQdPewVSQRPGPQPVuEFg8LehhK4pYO4DicA2IhP0qKgoIKNdrJdcld81sl0CdkrqtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4540
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgTWFyY2ggNCwgMjAyMyAxMjo1NiBBTQ0KPiANCj4gT24gRnJpLCAzIE1h
ciAyMDIzIDA2OjM2OjM1ICswMDAwDQo+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNv
bT4NCj4gPiA+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAyLCAyMDIzIDEwOjIwIFBNDQo+ID4gPg0K
PiA+ID4gPiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+ID4gPiBT
ZW50OiBUaHVyc2RheSwgTWFyY2ggMiwgMjAyMyA4OjM1IFBNDQo+ID4gPiA+DQo+ID4gPiA+IE9u
IFRodSwgTWFyIDAyLCAyMDIzIGF0IDA5OjU1OjQ2QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3Rl
Og0KPiA+ID4gPiA+ID4gRnJvbTogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4g
PiA+ID4gPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMiwgMjAyMyAyOjA3IFBNDQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gPiAtCQlpZiAoIXZmaW9fZGV2X2luX2dyb3VwcyhjdXJfdm1hLCBncm91
cHMpKSB7DQo+ID4gPiA+ID4gPiA+ICsJCWlmIChjdXJfdm1hLT52ZGV2Lm9wZW5fY291bnQgJiYN
Cj4gPiA+ID4gPiA+ID4gKwkJICAgICF2ZmlvX2Rldl9pbl9ncm91cHMoY3VyX3ZtYSwgZ3JvdXBz
KSAmJg0KPiA+ID4gPiA+ID4gPiArCQkgICAgIXZmaW9fZGV2X2luX2lvbW11ZmRfY3R4KGN1cl92
bWEsDQo+ID4gPiBpb21tdWZkX2N0eCkpIHsNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBIaSBB
bGV4LCBKYXNvbiwNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBUaGVyZSBpcyBvbmUgY29uY2Vy
biBvbiB0aGlzIGFwcHJvYWNoIHdoaWNoIGlzIHJlbGF0ZWQgdG8gdGhlDQo+ID4gPiA+ID4gPiBj
ZGV2IG5vaW9tbXUgbW9kZS4gQXMgcGF0Y2ggMTYgb2YgdGhpcyBzZXJpZXMsIGNkZXYgcGF0aA0K
PiA+ID4gPiA+ID4gc3VwcG9ydHMgbm9pb21tdSBtb2RlIGJ5IHBhc3NpbmcgYSBuZWdhdGl2ZSBp
b21tdWZkIHRvDQo+ID4gPiA+ID4gPiBrZXJuZWwuIEluIHN1Y2ggY2FzZSwgdGhlIHZmaW9fZGV2
aWNlIGlzIG5vdCBib3VuZCB0byBhIHZhbGlkDQo+ID4gPiA+ID4gPiBpb21tdWZkLiBUaGVuIHRo
ZSBjaGVjayBpbiB2ZmlvX2Rldl9pbl9pb21tdWZkX2N0eCgpIGlzDQo+ID4gPiA+ID4gPiB0byBi
ZSBicm9rZW4uDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gQW4gaWRlYSBpcyB0byBhZGQgYSBj
ZGV2X25vaW9tbXUgZmxhZyBpbiB2ZmlvX2RldmljZSwgd2hlbg0KPiA+ID4gPiA+ID4gY2hlY2tp
bmcgdGhlIGlvbW11ZmRfaWN0eCwgYWxzbyBjaGVjayB0aGlzIGZsYWcuIElmIGFsbCB0aGUgb3Bl
bmVkDQo+ID4gPiA+ID4gPiBkZXZpY2VzIGluIHRoZSBkZXZfc2V0IGhhdmUgdmZpb19kZXZpY2Ut
PmNkZXZfbm9pb21tdT09dHJ1ZSwNCj4gPiA+ID4gPiA+IHRoZW4gdGhlIHJlc2V0IGlzIGNvbnNp
ZGVyZWQgdG8gYmUgZG9hYmxlLiBCdXQgdGhlcmUgaXMgYSBzcGVjaWFsDQo+ID4gPiA+ID4gPiBj
YXNlLiBJZiBkZXZpY2VzIGluIHRoaXMgZGV2X3NldCBhcmUgb3BlbmVkIGJ5IHR3byBhcHBsaWNh
dGlvbnMNCj4gPiA+ID4gPiA+IHRoYXQgb3BlcmF0ZXMgaW4gY2RldiBub2lvbW11IG1vZGUsIHRo
ZW4gdGhpcyBsb2dpYyBpcyBub3QgYWJsZQ0KPiA+ID4gPiA+ID4gdG8gZGlmZmVyZW50aWF0ZSB0
aGVtLiBJbiB0aGF0IGNhc2UsIHNob3VsZCB3ZSBhbGxvdyB0aGUgcmVzZXQ/DQo+ID4gPiA+ID4g
PiBJdCBzZWVtcyB0byBvayB0byBhbGxvdyByZXNldCBzaW5jZSBub2lvbW11IG1vZGUgaXRzZWxm
IG1lYW5zDQo+ID4gPiA+ID4gPiBubyBzZWN1cml0eSBiZXR3ZWVuIHRoZSBhcHBsaWNhdGlvbnMg
dGhhdCB1c2UgaXQuIHRob3VnaHRzPw0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+
IFByb2JhYmx5IHdlIG5lZWQgc3RpbGwgcGFzcyBpbiBhIHZhbGlkIGlvbW11ZmQgKGluc3RlYWQg
b2YgdXNpbmcNCj4gPiA+ID4gPiBhIG5lZ2F0aXZlIHZhbHVlKSBpbiBub2lvbW11IGNhc2UgdG8g
bWFyayB0aGUgb3duZXJzaGlwIHNvIHRoZQ0KPiA+ID4gPiA+IGNoZWNrIGluIHRoZSByZXNldCBw
YXRoIGNhbiBjb3JyZWN0bHkgY2F0Y2ggd2hldGhlciBhbiBvcGVuZWQNCj4gPiA+ID4gPiBkZXZp
Y2UgYmVsb25ncyB0byB0aGlzIHVzZXIuDQo+ID4gPiA+DQo+ID4gPiA+IFRoZXJlIHNob3VsZCBi
ZSBubyBpb21tdWZkIGF0IGFsbCBpbiBuby1pb21tdSBtb2RlDQo+ID4gPiA+DQo+ID4gPiA+IEFk
ZGluZyBvbmUganVzdCB0byBkZWFsIHdpdGggbm9pb21tdSByZXNldCBzZWVtcyBwcmV0dHkgc2Fk
IDpcDQo+ID4gPiA+DQo+ID4gPiA+IG5vLWlvbW11IGlzIG9ubHkgcmVhbGx5IHVzZWQgYnkgZHBk
aywgYW5kIGl0IGRvZXNuJ3QgaW52b2tlDQo+ID4gPiA+IFZGSU9fREVWSUNFX1BDSV9IT1RfUkVT
RVQgYXQgYWxsLg0KPiA+ID4NCj4gPiA+IERvZXMgaXQgaGFwcGVuIHRvIGJlIG9yIGJ5IGRlc2ln
biwgdGhpcyBpb2N0bCBpcyBub3QgbmVlZGVkIGJ5IGRwZGs/DQo+IA0KPiBJIGNhbid0IHRoaW5r
IG9mIGEgcmVhc29uIERQREsgY291bGRuJ3QgdXNlIGhvdC1yZXNldC4gIElmIHdlIHdhbnQgdG8N
Cj4gbWFrZSBpdCBhIHBvbGljeSwgaXQgc2hvdWxkIGJlIGVuZm9yY2VkIGJ5IGNvZGUsIGJ1dCBj
cmVhdGluZyB0aGF0DQo+IHBvbGljeSBiYXNlZCBvbiBhIGRpZmZpY3VsdHkgaW4gc3VwcG9ydGlu
ZyB0aGF0IG1vZGUgd2l0aCBpb21tdWZkIGlzbid0DQo+IGdyZWF0Lg0KDQpNYWtlcyBzZW5zZS4g
QSB1c2Vyc3BhY2UgZHJpdmVyIHNob3VsZCBoYXZlIHRoZSBjaGFuY2UgdG8gcmVzZXQNCmRldmlj
ZS4NCg0KPiANCj4gPiB1c2Ugb2Ygbm9pb21tdSBzaG91bGQgYmUgZGlzY291cmFnZWQuDQo+ID4N
Cj4gPiBpZiBvbmx5IGtub3duIG5vaW9tbXUgdXNlciBkb2Vzbid0IHVzZSBpdCB0aGVuIGhhdmlu
ZyBjZXJ0YWluDQo+ID4gbmV3IHJlc3RyaWN0aW9uIGZvciBub2lvbW11IGluIHRoZSBob3QgcmVz
ZXQgcGF0aCBtaWdodCBiZSBhbg0KPiA+IGFjY2VwdGFibGUgdHJhZGVvZmYuDQo+ID4NCj4gPiBi
dXQgYWdhaW4gbmVlZHMgQWxleCdzIGlucHV0IGFzIGhlIGtub3dzIGFsbCB0aGUgaGlzdG9yeSBh
Ym91dA0KPiA+IG5vaW9tbXUuIPCfmIoNCj4gDQo+IE5vLUlPTU1VIG1vZGUgd2FzIG1lYW50IHRv
IGJlIGEgbWluaW1hbGx5IGludmFzaXZlIGNvZGUgY2hhbmdlIHRvDQo+IHJlLXVzZSB0aGUgdmZp
byBkZXZpY2UgaW50ZXJmYWNlLCBvciBhbHRlcm5hdGl2ZWx5IGF2b2lkIGV4dGVuZGluZw0KPiB1
aW8tcGNpLWdlbmVyaWMgdG8gc3VwcG9ydCBNU0kvWCwgd2l0aCBiZXR0ZXIgbG9nZ2luZy90YWlu
dGluZyB0byBrbm93DQo+IHdoZW4gdXNlcnNwYWNlIGlzIGRyaXZpbmcgZGV2aWNlcyB3aXRob3V0
IElPTU1VIHByb3RlY3Rpb24sIGFuZCBhcyBhDQo+IG1lYW5zIHRvIHByb21vdGUgYSB0cmFuc2l0
aW9uIHRvIHN0YW5kYXJkIHN1cHBvcnQgb2YgdmZpby4gIEFGQUlLLA0KPiB0aGVyZSBhcmUgc3Rp
bGwgZW52aXJvbm1lbnRzIHdpdGhvdXQgdi9JT01NVSB0aGF0IG1ha2UgdXNlIG9mIG5vLWlvbW11
DQo+IG1vZGUuICBUaGFua3MsDQoNClRoaXMgbWFrZXMgSmFzb24ncyByZW1hcmsgKG5vaW9tbXUg
c2hvdWxkIG5vdCB1c2UgaW9tbXVmZCBhdCBhbGwpIG11Y2gNCm1vcmUgcmVhc29uYWJsZS4gSWYg
dGhlcmUgaXMgbm8gdi9JT01NVSwgdGhlbiBubyBpb21tdWZkIGF0IGFsbC4NCg0KSWYgbm8gaW9t
bXVmZCBpcyB1c2VkIGluIHRoZSBuby1pb21tdSBtb2RlLCB0aGlzIGFwcHJvYWNoIGNhbm5vdA0K
dGVsbCB0d28gYXBwbGljYXRpb25zIHRoYXQgYXJlIG9wZXJhdGluZyBpbiBuby1pb21tdSBtb2Rl
LiBJZiB3ZSBhbGxvdw0KcmVzZXQsIGl0IG1heSBtYWtlIG5vLWlvbW11IG1vZGUgbW9yZSB3ZWFr
LiBTbyBwZXJoYXBzIHdlIG5lZWQNCnRvIGhhdmUgYW5vdGhlciBhcHByb2FjaCBmb3IgdGhpcyBv
d25lcnNoaXAgY2hlY2suDQoNCkhvdyBhYm91dCBmYWxsaW5nIGJhY2sgdG8gcHJpb3Igc29sdXRp
b24uIEFsbG93IHVzZXJzcGFjZSB0byBwYXNzIGEgc2V0DQpvZiBkZXZpY2UgZmQsIGFuZCB0aGUg
a2VybmVsIGp1c3QgY2hlY2tzIHRoZSBvcGVuZWQgZGV2aWNlcyBpbiB0aGUgZGV2X3NldCwNCmFs
bCB0aGUgb3BlbmVkIGRldmljZXMgc2hvdWxkIGJlIGluY2x1ZGVkIGluIHRoZSBkZXZpY2UgZmQg
c2V0LiBJZiBub3QgYWxsDQpvZiB0aGVtIGFyZSBpbmNsdWRlZCwgZmFpbCBpdC4NCg0KUmVnYXJk
cywNCllpIExpdQ0KDQoNCg==
