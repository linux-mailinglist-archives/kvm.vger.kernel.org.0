Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B8D74077A
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 03:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjF1BKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 21:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjF1BKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 21:10:18 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6AAE7F;
        Tue, 27 Jun 2023 18:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687914616; x=1719450616;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t/M0dS9hmC6RMioZUi/vQQRDMupvsjRhYpyvpDXOqH4=;
  b=UGsEljW46+2Ia0F9MZvqB49uRQXINdxV8BYhIJG6Fh4nhrnlxaOvbb4+
   4yjCJvFinrawkmSMorArpvcRQno3ts0INol1k8biY/ECP6XldVElc4Pq9
   /VxG8JhoGuRzmmL411/V26rVLhWk4VwT8iU/a7xPHyXuj4n6LPrFGeznP
   q9eXhfwBPkS8u/5h8pzCMQK6BNjv0IWyxVNV1DDCyQwJGM9YndQRGxPSV
   5VTYva/X91VQHrQk4ldcmFBfg/jEE05m5bLXDXPwdh63bk0OZmrMD6uX2
   JpqqJTdAz5JN7HyHgua3SdQiRqQSpOk4jugqLnMQXBnw8yAMPfhPtkjgx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="425392071"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="425392071"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 18:10:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="1047193732"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="1047193732"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 27 Jun 2023 18:10:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 18:10:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 18:10:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 18:10:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 18:10:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmZVwnfLNKuwhXIj3aT/IYmKnbN97DQJkdR2MRg48xvRl7sljV6r4ZeRqDvJZpu9WFCBFhC/CfTsQItsZNtyBPK3UttmNoYRBTyOCaxhfJDIiNPuCV2mGmJ4vK5Hw+L6FuDfQK5Xce0semgFAYkNTWiSdmX6O8/HBR4eOomhAwUDUv8Dk2NxV5AvQBGi9aF9zACM4ah2MCFFa36m9Rcxl82uD6tepf36hVnI2tfmkYz+jbWNnKh2rgBD2uRjz4aqbmDsK3cKG9max2DkGbYdbJ+WZo69k5iehb5/fYm0cM62bHpxYr0+qdvKip+IKpeq5cQBJ7JUpIpPUpuHPjYDfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/M0dS9hmC6RMioZUi/vQQRDMupvsjRhYpyvpDXOqH4=;
 b=XLPBJht4T2YC/q6dgpVc65mYmZvn/KELx/W5Tqb4y+P6MEtRkp1UxBmkAZWMPc8kveBgskYE9/5lOtpcOJWmQ7jA0GImmHhEZ1kwP8VPOkdGBlkgIuC9U5Qmh4zeaRRnIpywgltjKjkPdXFgpoxWq/73OWKuwSqR/x7NPLDqli8xMb3inXnt73lLmwaqArkwASun0Ey8/Ix9gItQ01vOwsX8Qn584RnOGGF9jKYCaWfeh0J/RnajEPM1hHx+kf8Rp1UDHOGBxVIxBkfrlonugoBg1/Kvnk/GQ/+0vmsOgn49yC0TF/wxpbH42XHP/sLM3uxkh9bigp4Fi1Vf2CwBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN0PR11MB6253.namprd11.prod.outlook.com (2603:10b6:208:3c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Wed, 28 Jun
 2023 01:10:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d%3]) with mapi id 15.20.6521.023; Wed, 28 Jun 2023
 01:10:11 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Thread-Topic: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Thread-Index: AQHZoDaix48j/fAvNky2csY4DXj56K+V1V8AgAiMsLCAAIHJAIAAFvwAgAB7smA=
Date:   Wed, 28 Jun 2023 01:10:11 +0000
Message-ID: <DS0PR11MB7529FD534104E123BC7A3CE2C324A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
        <20230616093946.68711-23-yi.l.liu@intel.com>
        <20230621155406.437d3b4d.alex.williamson@redhat.com>
        <DS0PR11MB7529C5F9C31CE343AB66B0D4C327A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <ZJsKXoK7SF359Tb2@nvidia.com>
 <20230627113430.129811ef.alex.williamson@redhat.com>
In-Reply-To: <20230627113430.129811ef.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MN0PR11MB6253:EE_
x-ms-office365-filtering-correlation-id: 4693d867-101d-4729-dc90-08db77746bd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JEytIbo0DEJB1xaQG1h1JtfJkpRtlAqr5hUSdfxJ3SzgGQj6br1WV311COTf2g19u68WNLl8HGT+V/FLUkdmMP0AkutPVp2Z/IEsnZwx3KBUj+wCdpEB1i03WPXxcmLv6ozvggpNHzd34oobjkgN2oKNdoZUwAlH7vWi28rVEwOd0gDg7w4IhG4vr7U0hg9zL0GKtloYgyf2zMOt/d2xZwMqNVGTb2NUsSrpQkFKqLUfCSoG4joO9jdJ24kxJ7SJYBFdVLAe962VQFueFUkb3LnYPZzIQzc3+d/NzIvhAblYflVSmLqJWkLl53rzrhBEXlT/TAog9aRp101zh9YNTh5lD5HbYn2eR5oRzBs5DCYX155h/c0cqe2Am4J26SEjVC7P6A+288CU4cB6HFdAgVQ5P3TAS+rn0RX1c00g/vkMmCvcsTqpnmsfIS2Oo5L8hbIFvH7oB+bgbQYL2bpQdrnYpgnPozMo7nTNIMMbRLN4XAG/2f3k3PQPUK7dXO3XbxRT8yZTJq8SlHEsf0rsoyLXGB8i9kQfP8HbUng0gua2QRwVi11G1CZUtU2lfpJHqESRtav+bt9ncv3KsLS2tnxoeXfI4OM6qsAXSVUvdWr7Xw1Z6cqLzspXQODZC9n+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199021)(110136005)(54906003)(2906002)(7696005)(38100700002)(82960400001)(83380400001)(26005)(6506007)(186003)(122000001)(71200400001)(9686003)(55016003)(86362001)(41300700001)(478600001)(38070700005)(64756008)(66556008)(66446008)(33656002)(66476007)(316002)(76116006)(4326008)(8936002)(66946007)(7416002)(8676002)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmYzeWxlUXpROFpjY1NNWlVjUjEva09RS3B2bVZraDBjTWtuUWo3RzhIVXJW?=
 =?utf-8?B?VzBEanRNR2hqMnU4Mko4Wnk1QnJQMHUzd1RqMlJoSHRTVDBnK0tpWGNCY0Ji?=
 =?utf-8?B?UU9pTGZQdDVsbHJXN3RmZS8zU0RoSHF3NGpoWGs5WjMydkhWZVBlOWZqa0dS?=
 =?utf-8?B?YTVoaGZpS3JQblNhS1RobFQ1NXRFOW1ieEdod3dMODRjcmdXUkF3UFRpOTJ5?=
 =?utf-8?B?WU01dmNtalNpQTh6MVdGZTNVQlV3RTA1cndJbnNMYnNBc1NtT2dDTXFpQjdY?=
 =?utf-8?B?dXRNWEFjWmlRK2FmbUFwdStjUTY2djZRaTBWdnJNbGNWUHh3M1ZNc3M3TmFi?=
 =?utf-8?B?aWhza1dIaFNmd1hlM0xTcVlTMzBPWFllbHRyUFhYM1l1YzVydi80UmkzaHp3?=
 =?utf-8?B?SUl2c2lUeE5HQWg5STNhdHZMei9hSWdFSXRhMFRPMURyQWRWN1g1MVNiNlly?=
 =?utf-8?B?dXZJRGFrYkR3V1hjNFE0ejFIcWpxSkdIM0pXZkJYSmQydlB4QVA5Y0srT1VM?=
 =?utf-8?B?K3VNcGxaY0tCOFFUQWpPbEpVR3F1MnIrUStHc1M3YXd1Y0ZhbDZ4ODFBVVFo?=
 =?utf-8?B?OHJuYUhmaXM0bzRwdWRXMUl4QkppWVp5TlZVUWZwNHRsbk1qWDdFNkdDM21R?=
 =?utf-8?B?ZlgxUHEzWGx0TzBRaWkyaVVIMFhkRlRpa1hPdzBRMVZWZ2s0ODdRTG5EYjFZ?=
 =?utf-8?B?aEUrb0RjYzJQTVR0YjRITlVCSTlzT1JyanJLcTJLSE9lZlR1bGx0Zk9UbUQv?=
 =?utf-8?B?bW1UYzB0VHFxTDZrY1lwUUprTjN2c1lvakxiS1YyUTEvVnN0REZrcGV3U0J3?=
 =?utf-8?B?SGFMY1ZMRi90NnNlWkZoY3ZTUTluQ0FEbzY3YklXQzAvOUIvYzF3WXlmOFdl?=
 =?utf-8?B?R2wwMHNmMlVLNWdLeEErdXE0S25qWVZIdjIwVENLNHZIWXlZVVhxVW96NkZU?=
 =?utf-8?B?b2VhUy9ET3o0TVo4U2NlMUJ4dWg4RTg3K0Z1U3kwbndjVW90a25TaFhxalZk?=
 =?utf-8?B?S0F3T252TWNRZVlwSzNDc1c3RGxOZGZ2WW8ySUF2N2U3b3pCZ25IaUoxQUY5?=
 =?utf-8?B?UVlwL0VJbWdGRlpFSkU3R0pTY0xrSTUwZEc3bGk2TW9kQUdWM1dJcGJ6WnhX?=
 =?utf-8?B?ZmpUd3VWZEswTlB6c3VucEFVMmNzMUxYaGFRUnJtODA5ZEFzK00rUzhQZEVQ?=
 =?utf-8?B?Uk5Ud2JxYUMyTGNCOGdKNWZjRWRpL0JvVUhrVExNY0U3RnNOMDJQM0gyUWNz?=
 =?utf-8?B?UEZCNTN6OVN1SVo5cVE0REJsYUJyR0VBZCtaZGwxQlg4aUZ1Tk9VN21TVUhm?=
 =?utf-8?B?K1VZMUNXeE9QTnhIYTY5NVpSeXhSakVEUThIOWRmOTlXcFBlR2RKOVEvS3ZL?=
 =?utf-8?B?UGtLQlBGekR0SlhaSkNtKzNyTXZ2MVhhcG8xRWE1RnVXYjRRcWxRUGJvSktP?=
 =?utf-8?B?b1pDU1dsS0pRWjFDSUVuc2drZXJ6VnAxK2JnOGxWdTBTcDlnYk94QWx6MXR3?=
 =?utf-8?B?KzQzWE5IUnRURHpickJOTktaTWFKWWNXY2dSRmdQMTBGeWlKQktwUmcxN2xB?=
 =?utf-8?B?VTVSL003SmxuQVNoRFFKYmZtNDlkZ29JRjBYYlB1VEhWcEFZeTZYdXNYM3A5?=
 =?utf-8?B?VkJIcHhlVkhFUWRYb2Q2RXE0Q2JESTlrQ3hiSkowM01FaERzeFNBS3l1a0xK?=
 =?utf-8?B?VzRuZ1FUVVYrSlc2aWhrMi8xMTJ5SzRkNjVFUDk0eUtqQ2JDNStYWWh2SnBD?=
 =?utf-8?B?OHQ0SzBQOUxLMG9nbVEvZ3d4VkhuQWM2K0hPVkxSTElxRGF6ZDdnSG9abkhp?=
 =?utf-8?B?bks4TGtONFVzazQ3Mm1qOFhQUStmSVA5Y1BjY09pdnFyd3VBNC8zelYyejFr?=
 =?utf-8?B?QUIxcjE2d3JOVy9Ea2YyOTA0LzJ1RjAzL0krc29STHMvUTR2YUVkN29ZcWNT?=
 =?utf-8?B?Qy81ZjZ2Kzg2aUJ3aU1HUjBpR3ZUcTJRWW1Jei9xVFB1dVpkWHQ0aTVSb0RK?=
 =?utf-8?B?QjVDREdvbHBPWmNKQnJUOXBHWmZlM0l3WVhNc2JBUzBTT05NSzlUVkV5bklE?=
 =?utf-8?B?MEY4SnFLM3RyMlZDd29uQmZUeitpeEYwL2ZoYkxPWWhjZjhIU3hvV3F1NGM3?=
 =?utf-8?Q?p9brecZLVnq37dam4x1U6a4p1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4693d867-101d-4729-dc90-08db77746bd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 01:10:11.1994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5DCW5F5ihkCnWS86JVSHYVy5IQ+GoAnp0i4VlSS8VfqezRCvHp3Kmdp7jPsovVFC2i2tUDKZJQGfbrxRiITglw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6253
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIEp1bmUgMjgsIDIwMjMgMTozNSBBTQ0KDQpbVGhlIENjIGxpc3QgZ2V0
cyBicm9rZW4gaW4gdGhlIHJlcGx5IGZyb20gQWxleCB0byBKYXNvbiwgaGVyZSBJIHJlcGx5IHRv
DQpBbGV4J3MgZW1haWwgd2l0aCB0aGUgQ2MgbGlzdCBmaXhlZC4gQEFsZXgsIHNlZW1zIGxpa2Ug
dGhlIHNhbWUgc3ltcHRvbQ0Kd2l0aCBsYXN0IHRpbWUsIGRvIHlvdSBoYXZlIGFueSBpZGVhIG9u
IGl0P10NCg0KPiBPbiBUdWUsIDI3IEp1biAyMDIzIDEzOjEyOjE0IC0wMzAwDQo+IEphc29uIEd1
bnRob3JwZSA8amdnQG52aWRpYS5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBUdWUsIEp1biAyNywg
MjAyMyBhdCAwODo1NDozM0FNICswMDAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gPiA+IEZyb206
IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gPiA+IFNl
bnQ6IFRodXJzZGF5LCBKdW5lIDIyLCAyMDIzIDU6NTQgQU0NCj4gPiA+ID4NCj4gPiA+ID4gT24g
RnJpLCAxNiBKdW4gMjAyMyAwMjozOTo0NiAtMDcwMA0KPiA+ID4gPiBZaSBMaXUgPHlpLmwubGl1
QGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gPiA+ICtWRklPIGRldmljZSBjZGV2IGRv
ZXNuJ3QgcmVseSBvbiBWRklPIGdyb3VwL2NvbnRhaW5lci9pb21tdSBkcml2ZXJzLg0KPiA+ID4g
PiA+ICtIZW5jZSB0aG9zZSBtb2R1bGVzIGNhbiBiZSBmdWxseSBjb21waWxlZCBvdXQgaW4gYW4g
ZW52aXJvbm1lbnQNCj4gPiA+ID4gPiArd2hlcmUgbm8gbGVnYWN5IFZGSU8gYXBwbGljYXRpb24g
ZXhpc3RzLg0KPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiArU28gZmFyIFNQQVBSIGRvZXMgbm90IHN1
cHBvcnQgSU9NTVVGRCB5ZXQuICBTbyBpdCBjYW5ub3Qgc3VwcG9ydCBkZXZpY2UNCj4gPiA+ID4g
PiArY2RldiBlaXRoZXIuDQo+ID4gPiA+DQo+ID4gPiA+IFdoeSBpc27CtHQgdGhpcyBlbmZvcmNl
ZCB2aWEgS2NvbmZpZz8gIEF0IHRoZSB2ZmlvIGxldmVsIHdlIGNvdWxkIHNpbXBseQ0KPiA+ID4g
PiBhZGQgdGhlIGZvbGxvd2luZyBpbiBwYXRjaCAxNy86DQo+ID4gPiA+DQo+ID4gPiA+IGNvbmZp
ZyBWRklPX0RFVklDRV9DREVWDQo+ID4gPiA+ICAgICAgICAgYm9vbCAiU3VwcG9ydCBmb3IgdGhl
IFZGSU8gY2RldiAvZGV2L3ZmaW8vZGV2aWNlcy92ZmlvWCINCj4gPiA+ID4gICAgICAgICBkZXBl
bmRzIG9uIElPTU1VRkQgJiYgIVNQQVBSX1RDRV9JT01NVQ0KPiA+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBeXl5eXl5eXl5eXl5eXl5eXl5eDQo+ID4gPiA+DQo+ID4gPiA+IE9yIGlm
IEphc29uIHdhbnRzLCBJT01NVUZEIGNvdWxkIGRlcGVuZCBvbiAhU1BBUFJfVENFX0lPTU1VIGZv
ciBub3cgYW5kDQo+ID4gPiA+IHRoZSBleGlzdGluZyBLY29uZmlnIG9wdGlvbnMgd291bGQgZXhj
bHVkZSBpdC4gIElmIHdlIGtub3cgaXQgZG9lc24ndA0KPiA+ID4gPiB3b3JrLCBsZXQncyBub3Qg
cHV0IHRoZSBidXJkZW4gb24gdGhlIHVzZXIgdG8gZmlndXJlIHRoYXQgb3V0LiAgQQ0KPiA+ID4g
PiBmb2xsb3ctdXAgcGF0Y2ggZm9yIHRoaXMgd291bGQgYmUgZmluZSBpZiB0aGVyZSdzIG5vIG90
aGVyIHJlYXNvbiB0bw0KPiA+ID4gPiByZXNwaW4gdGhlIHNlcmllcy4NCj4gPiA+DQo+ID4gPiBA
SmFzb24sDQo+ID4gPiBIb3cgYWJvdXQgeW91ciBvcGluaW9uPyBTZWVtcyByZWFzb25hYmxlIHRv
IG1ha2UgSU9NTVVGRA0KPiA+ID4gZGVwZW5kIG9uICFTUEFQUl9UQ0VfSU9NTVUuIElzIGl0Pw0K
PiA+DQo+ID4gVGhlIHJpZ2h0IGtjb25maWcgd291bGQgYmUgdG8gbGlzdCBhbGwgdGhlIGlvbW11
IGRyaXZlcnMgdGhhdCBjYW4NCj4gPiBzdXBwb3J0IGlvbW11ZmQgYW5kIGFsbG93IGl0IHRvIGJl
IHNlbGVjdGVkIGlmIGFueSBvZiB0aGVtIGFyZQ0KPiA+IGVuYWJsZWQuDQo+ID4NCj4gPiBUaGlz
IHNlZW1zIHRvbyBjb21wbGV4IHRvIGJvdGhlciB3aXRoLCBzbyBJIGxpa2UgQWxleCdzIHZlcnNp
b24gYWJvdmUuLg0KPiA+DQo+ID4gPiA+IE90aGVyd2lzZSB0aGUgc2VyaWVzIGlzIGxvb2tpbmcg
cHJldHR5IGdvb2QgdG8gbWUuICBJdCBzdGlsbCByZXF1aXJlcw0KPiA+ID4gPiBzb21lIHJldmll
d3MvYWNrcyBpbiB0aGUgaW9tbXVmZCBzcGFjZSBhbmQgaXQgd291bGQgYmUgZ29vZCB0byBzZWUg
bW9yZQ0KPiA+ID4gPiByZXZpZXdzIGZvciB0aGUgcmVtYWluZGVyIGdpdmVuIHRoZSBhbW91bnQg
b2YgY29sbGFib3JhdGlvbiBoZXJlLg0KPiA+ID4gPg0KPiA+ID4gPiBJJ20gb3V0IGZvciB0aGUg
cmVzdCBvZiB0aGUgd2VlaywgYnV0IEknbGwgbGVhdmUgb3BlbiBhY2NlcHRpbmcgdGhpcw0KPiA+
ID4gPiBhbmQgdGhlIGhvdC1yZXNldCBzZXJpZXMgbmV4dCB3ZWVrIGZvciB0aGUgbWVyZ2Ugd2lu
ZG93LiAgVGhhbmtzLA0KPiA+ID4NCj4gPiA+IEBBbGV4LA0KPiA+ID4gR2l2ZW4gSmFzb24ncyBy
ZW1hcmtzIG9uIGNkZXYgdjEyLCBJJ3ZlIGFscmVhZHkgZ290IGEgbmV3IHZlcnNpb24gYXMgYmVs
b3cuDQo+ID4gPiBJIGNhbiBwb3N0IGl0IG9uY2UgdGhlIGFib3ZlIGtjb25maWcgb3BlbiBpcyBj
bG9zZWQuDQo+ID4NCj4gPiBJIHRoaW5rIHdlIGRvbid0IG5lZWQgdG8gYmVuZCB0aGUgcnVsZXMs
IExpbnVzIHdvdWxkIG5vdCBiZSBoYXBweSB0bw0KPiA+IHNlZSAzMCBtYWpvciBwYXRjaGVzIHRo
YXQgbmV2ZXIgaGl0IGxpbnV4LW5leHQgYXQgYWxsLg0KPiA+DQo+ID4gSSdtIGhhcHB5IGlmIHdl
IHB1dCBpdCBvbiBhIGJyYW5jaCBhdCBSQzEgYW5kIG1lcmdlIGl0IHRvIHRoZSB2ZmlvICYNCj4g
PiBpb21tdWZkIHRyZWVzLCBpdCBpcyBmdW5jdGlvbmFsbHkgdGhlIHNhbWUgb3V0Y29tZSBpbiB0
aGUgc2FtZSB0aW1lDQo+ID4gZnJhbWUuDQo+IA0KPiBOb3Qgc3VyZSBJJ20gY2xlYXIgb24gdGhl
IHBsYW4uICBNeSBpbnRlbnRpb24gd291bGQgaGF2ZSBiZWVuIHRvIGFwcGx5DQo+IHYxNCB0byBt
eSBuZXh0IGJyYW5jaCwgbWFrZSBzdXJlIGl0IGRpZCBzZWUgbGludXgtbmV4dCBleHBvc3VyZSwN
Cj4gYW5kIHNlbmQgYSBwdWxsIHJlcXVlc3QgZm9yIHJjMSBuZXh0IHdlZWsuDQo+IA0KPiBBcmUg
eW91IHN1Z2dlc3RpbmcgYSBwb3N0LW1lcmdlLXdpbmRvdyBwdWxsIHJlcXVlc3QgZm9yIHY2LjUg
KGFsc28NCj4gZnJvd25lZCBvbikgb3IgYXJlIHlvdSBzdWdnZXN0aW5nIHRoYXQgaXQgc2ltbWVy
cyBpbiBib3RoIG91ciBuZXh0DQo+IGJyYW5jaGVzIHVudGlsIHY2LjY/ICBUaGFua3MsDQoNCkl0
IGFwcGVhcnMgdG8gbWUgdGhlIGxhdHRlciBvbmUuIFdoZW4gNi41LXJjMSBpcyByZWxlYXNlZCwg
d2UgaW1tZWRpYXRlbHkNCmFwcGx5IHRoZSBob3QtcmVzZXQgYW5kIGNkZXYgc2VyaWVzIG9udG8g
aXQgYW5kIHB1dCBpdCBpbiBhIHNoYXJlZCB0cmVlIHRvDQphc3Npc3QgdGhlIG90aGVyIGlvbW11
ZmQgZmVhdHVyZSBkZXZlbG9wbWVudCAoZS5nLiBuZXN0aW5nKS4gSmFzb24sIGlzIGl0Pw0KDQpS
ZWdhcmRzLA0KWWkgTGl1DQo=
