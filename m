Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5134E730D8D
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 05:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbjFODb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 23:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240835AbjFODbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 23:31:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19E2271C;
        Wed, 14 Jun 2023 20:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686799901; x=1718335901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ynhAwMOdmWSyyaFleTx2Lg4PD2s6FNWe7qAygI9peRM=;
  b=nPp5VaLO6Kw8U3J+6TvU88TsOyjU0YpA6q75+jiyjmxYvtnlHT0QUeoA
   YvpOKNkwbdDC6roUXoMlgCFKzYMYwwdtDs/IImqEMEqbeh/Ol/e9xyyNs
   l3q8WhD/yPTYLlGyUX/iUBNdzs8ec9iCuziVfbmJE/yZ6Co4IAXEmV5pB
   PVSzuG1Sy2aviVMtlLeILBNctLtMEmho0RMpX2owDOFYj79VcsKmVRiMu
   Vpf5ViW3x/Uupm6DYaYB9rA+mAHg5gMNPSebMXCMBwxs4ESivjjcgmt3A
   qtADGSmy9osq/OasxhZGrPU4NtwsSb6kGO4VYy/+YLCavohUtorptkpjj
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387218447"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="387218447"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 20:31:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="959009611"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="959009611"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jun 2023 20:31:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 20:31:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 20:31:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 20:31:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 20:31:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBm747WunI82vhm8xypVvqZabYWO7zDz+FrgUD26c6HFDdKA0SDABWn6HwN1A17N/HQDtuQ0KSOOTpv/h2ACTlzL27QyzbrNdIGXMRBVtIttdYglXL8fjUr8ZHdjLQgaC+EwjVMWbF7bqTVKSx9wSjTarnO7qCH02TMp5mbMq8RnD963/J5CfHxhmdCkiqmhXKSiRvzTsw3wetpVm0KJ7af6oEu42gTC8lcOPPqxSi1WO0eWvUgy8hsmlPOMgtnoDazQwgoVBXjvngn32uRtbqjwiKWwAjrsMBX+sOoNWltCoDLFkdchfL9WpU/6hfJZwK946KccFP3WM2ASGb4luQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynhAwMOdmWSyyaFleTx2Lg4PD2s6FNWe7qAygI9peRM=;
 b=k9XgTJROOj/zyTc0ExmvJAvwpGA9AqKks5Sfv6dzvjK4m33HV7NFjJZw68/C+F+sTTI7/b/U1k07dRoBcZjF/smq3wBqIP0xrjuEezyP7v/JR9IK/H3ulurff5fb9w9E5ZnwJOKbX0Pbfrz2rcJimTZ6d5HiBxi6W+n+iftxefdYeR6oMOFRP+2r5IRPLNGotgndJypfXn1ZKrSBjC8N0ecQ6zQbm7bTBx4yxiHtAj2q5qs4098ZvscgcmkhXpmAx3+6erJPGHCnERAoongVYvbZxWDHGqLBlZ7xdEM750FYcz8Xf/R7FAsd60BY8KTwYaomGr/JXPaFXSEgxWzaSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN2PR11MB4631.namprd11.prod.outlook.com (2603:10b6:208:262::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 03:31:36 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Thu, 15 Jun 2023
 03:31:31 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZlUvxjWjQHBtl702niB2RsWbvNK+JHZUAgAEMNoCAAB/9gIAACruAgAALvoCAAAB9wA==
Date:   Thu, 15 Jun 2023 03:31:30 +0000
Message-ID: <DS0PR11MB7529F040A43594B6A8E79874C35BA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com> <ZIi0Bizk9qr1SgJ/@nvidia.com>
 <DS0PR11MB752932BD50E4F73FD7982DB0C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZImv2bl1COqA/8c1@nvidia.com>
 <DS0PR11MB75291989A5508781BB471322C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZInCs7augGxSzWYp@nvidia.com>
In-Reply-To: <ZInCs7augGxSzWYp@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MN2PR11MB4631:EE_
x-ms-office365-filtering-correlation-id: 7ca3a318-11f9-420c-d9d8-08db6d5102bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mn8Y5ZH4zMOjBjTeUtmBs8sIUdYwwXMp0ahcAOZuOvf9aiqsuFeyGoWRS4h7ULQiRK+pN2lcKZ6llP+zfbQ6tZ8hq0Guunl2Q4RsIO5qmqBHmovbXqNW7brPybzc0KgpsqQybOtPDLAMOrBdzHkQAo6RKH7mJGROyhWfMpyc+1CwKZ29iQYdASVQ5CJgbp+DnYV4NRU6a0G4xTt/hvAXcst/n17tq6i8H0zFnKIoWEscHy+UfbSlplLdNfYLVWD90BjIKKKd3mOFnMUI/aSsyTUBHFTgE32bpevUqnT//yN1VSpA26oZ898LN/JXyjNXN/Z1JhM/D9QWa3Hm09eNIw+cdZuQEJKrro0S2Tm4T1q7Pm3YGuczF4qUzAhVi7Jx5kilahg+d6ylnDwIpf29TqAQhUt6ZEleFR1luKdD5llw0b+g9Ehq1XwSZB0/w4S5hxspSOfYsaFkEaoBzMj/cgA02rrExwZhsr0xM0A/aeM4Zr5EMEVdfwqkVXSlapZnpuLTe32rlbV/LLD7YSTqfMIfHHPVdLNTisEdd6eVR0mD9GD6XRmn42eCWTFi5mDjCIgPmrb802zcW2MziOKqeMukhuHQ42FUMdesJU4ZBcbb6IMH9YA0I0ZAEAgAwNra
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199021)(9686003)(6506007)(26005)(186003)(478600001)(7696005)(55016003)(71200400001)(2906002)(52536014)(33656002)(316002)(41300700001)(8936002)(86362001)(122000001)(38100700002)(5660300002)(82960400001)(8676002)(7416002)(38070700005)(54906003)(66946007)(83380400001)(66476007)(66446008)(76116006)(6916009)(66556008)(64756008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWxVai9Eb0djU29qWDRreUJPUTBZWkZTSk1uRnl2NkRnYzZwVm9tcXFGUmdp?=
 =?utf-8?B?RWxYQlFtOEg2U0RxVUx6MHlCS212UTU4eGVzemJmbnJXUEx6VUhzZGU1SjZ0?=
 =?utf-8?B?SUNLV1BCcUNreHowRmJuekI1cEJrZjhKVnJuOGExZ1ZESENHcFdaSXlOQmh0?=
 =?utf-8?B?aWJjdW5hYXhWeUlIcmpMT2Y0Qnd0WkExUCs1Z09GUlVuWHluaXIwQUdiSnI3?=
 =?utf-8?B?UTl2WmRQR3hEbWdEMzdKT0t1bUZKTkYzYXM5L3NmbUloZTJETjlOSG5CNkVI?=
 =?utf-8?B?ZFdVZjg4R1ZWQ3hlU0RpY0JhYVNJK0lEeWZsTVBNOTN2NTF1d3lmZERvN085?=
 =?utf-8?B?RC9OdmtmOFJLNUxEa2pJTnhjRHR3aTI3ZzA2ZEhtYjI2a0paSlBpSHV5RUto?=
 =?utf-8?B?R0l3K3Z2dWZIeEtla2ViVElTRXcydiswaXhwZEFEV2FOVTgycGhkNFV0a0tZ?=
 =?utf-8?B?Q0dVOFNaUWJmcmVHOTRKdVE1QWg0M2kvK0dndlBOQThVVlhHelN4OVQzbDIz?=
 =?utf-8?B?ZmhGVjRmY0RRaEFVdCtRcXcwUjU4ejF1M0ZBVnZhVnAvdzlQQktKbWg0YWNq?=
 =?utf-8?B?YmpQckZUSFJZbGthRzMwYVRZazlhMEk1ZDhyZ25nY00yYkNnK0RxOXl0MkNp?=
 =?utf-8?B?WllweCtTZXNlSGphak9PZ1czUm5vZlNmaERNS2xxaXhBZnlCVDJveDFhOHVP?=
 =?utf-8?B?UTZMMmcrWkJQZmh4VjhDRWlGQ0R5MlQ0RkdMQUdnQ284VWdHWjE0Q2FXWTlj?=
 =?utf-8?B?K1YrOHY1KzFEMWpYUysyUDR3MlliNFNTd1RJOG5seXd2ZUxKRUlXNDFQdkJX?=
 =?utf-8?B?N29FaEExcGhWYnFkcEdSY3VpOWtmR010UERkd0g2dkRvQXhjejBENnU0S2Fs?=
 =?utf-8?B?UFZVeFpqOVhZT1ZCWnpPMWR5bVBxSy9vdGVqelk4Q3ZVcFNJUDltdmdRWXJD?=
 =?utf-8?B?d3dWK09qUEJOQlBYOFM0THJhanBpbDdVU2V1Tk1lYUl3WXZtdWoyZXF0WmJX?=
 =?utf-8?B?S1AzeEViNSt5UHRwRDJPWUcyUWd5eUx6YUxnZUNnY0RBb0JtTDJCRWRIZEx0?=
 =?utf-8?B?NldEQzUzMnM2K0w4UXcxNHdCc0FTcVFBdS9reWdKMHNqYkFUSk5rb2VReDFx?=
 =?utf-8?B?bTVGVnUyVHJoM2VLcjdGZmxPRWZPT1lHUzhBODV2dzFCaUI5TXRRenU0aXNi?=
 =?utf-8?B?SmFYMUpLTmNLVkZTbmlSNzR1TzJUcW0zUXlPVWFpNTdzb0ljSjU3eW5tNSt1?=
 =?utf-8?B?TVRsQUZ6RUVscGtjb0Q1b2tLcTJTNG82WTFVVS8rWEdteitnOW9WL29vSTJa?=
 =?utf-8?B?cjFVc1gxVm00MmVGTHhhdUM5MllXN1p3YW9NelpNNVdHWlZidCtJRFo3NTd2?=
 =?utf-8?B?N1Q2ZjQrQTB3ZDNQVmtrcjJrS1EvY2tRUXB5S29oSmphVVZEZlZ5N3pZZkpt?=
 =?utf-8?B?UWQ1aWZ0QStZa1ZwbHNVek1WZyt1QVRGc3Bmdm5STFpYcDlXVHUrUTN1NGIz?=
 =?utf-8?B?R2M0ZnhzZ25uNms3OExLQlByUkE4Rmp5UDJPeTJXdk9lM2RRc3ZNV3pkemZ6?=
 =?utf-8?B?TlQvWUQ2V1dsSmtaOUhuYlZ3TXlzZ1NNLzZ0dnlUTldEK2ZJYk13TENvdzNx?=
 =?utf-8?B?VTFNb2hsM01pcVNRVGthSlVSUzBkYTJyc25mMWpYL2o5KzFIU0dSa3hieml4?=
 =?utf-8?B?RDI0a0RiMWNJRWFTeVVCRjBUZFl0VGZpaXZRSUN0UFJvV2ZWcG5rVWxSOEE4?=
 =?utf-8?B?a2R6eEMyaksxbG9qZ2djOGp3WDRqNXBYVkwwNGZ0SG9QZ1lqaXUyU244ZWpF?=
 =?utf-8?B?bVJ0VFEwZmo4NnN5MnFYL2JjT3RuRTBHc2xyZFVobnVzZTU5UUZpaFFiNjJX?=
 =?utf-8?B?cEtBNkxIdldPS2xQQ2VzSTlIMW1SUHF5NlZpYWw3aVFONzRhVm5qMGc2TEhC?=
 =?utf-8?B?U2VBRU1vOEVjVTBaRklGRy9MM1A5aDltQWp3WFYzMTV5NlNNTmY0UDBReGdO?=
 =?utf-8?B?Q3NoWURSL3h4NXhZeGt3STEySUFyQTFXekw0cGtrMHZHZmdRd2JMT1dUYzZy?=
 =?utf-8?B?TmcyV01sbWE0b0ZXcGYvUHV4NFlCckk1ZXdHamEza0ZhWTdRb3M2U29jYUNR?=
 =?utf-8?Q?pzAk57RcQ79rXmeIeHjIXG3lX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca3a318-11f9-420c-d9d8-08db6d5102bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 03:31:30.8582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJDfD3R4qx2kHQsu5EGJjKLhJJkusT5N6v72MCbxyCWtXqWRXL1SLZrcooHhWHjZfurr/Zs/IjrR3X8kq2MeTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4631
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEp1bmUgMTQsIDIwMjMgOTozOCBQTQ0KPiANCj4gT24gV2VkLCBKdW4gMTQsIDIwMjMgYXQg
MDE6MDU6NDVQTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+ID4gLUVBR0FJTiBiYXNpY2Fs
bHkgbWVhbnMgdGhlIGtlcm5lbCBpbnRlcm5hbGx5IG1hbGZ1bmN0aW9uZWQgLSBlZyBpdA0KPiA+
ID4gYWxsb2NhdGVkIHRvbyBsaXR0bGUgc3BhY2UgZm9yIHRoZSBhY3R1YWwgc2l6ZSBvZiBkZXZp
Y2VzLiBUaGF0IGlzIG5vDQo+ID4gPiBsb25nZXIgcG9zc2libGUgaW4gdGhpcyB2ZXJzaW9uIHNv
IGl0IHNob3VsZCBuZXZlciByZXR1cm4gLUVBR0FJTi4NCj4gPg0KPiA+IEkgc3RpbGwgaGF2ZSBv
bmUgZG91YnQuIFBlciBteSB1bmRlcnN0YW5kaW5nLCB0aGlzIGlzIHRvIGhhbmRsZSBuZXdseQ0K
PiA+IHBsdWdnZWQgZGV2aWNlcyBkdXJpbmcgdGhlIGluZm8gcmVwb3J0aW5nIHBhdGguIEkgZG9u
4oCZdCB0aGluayBob2xkaW5nDQo+ID4gZGV2X3NldCBsb2NrIGNhbiBwcmV2ZW50IGl0LiBidXQg
bWF5YmUgLUVOT1NQQyBpcyBlbm91Z2guIEBBbGV4LA0KPiA+IHdoYXQgYWJvdXQgeW91ciBvcGlu
aW9uPw0KPiANCj4gSWYgdGhlIGRldmljZSB3YXMgcGx1ZyBpbnN0YW50bHkgYmVmb3JlIHdlIGNv
bXB1dGVkIHRoZSBzaXplIHdlIHJldHVybmVkDQo+IEVOT1NQQw0KPiANCj4gSWYgaXQgd2FzIHBs
dWdnZWQgaW5zdGFudGx5IGFmdGVyIHdlIGNvbXB1dGVkIHRoZSBzaXplIHdlIHJldHVybmVkDQo+
IEVBR0FJTg0KDQpZZXMuDQoNCj4gSGVyZSB3ZSBqdXN0IHJlc29sdmUgdGhpcyByYWNlIGNvbnNp
c3RlbnRseSB0byBhbHdheXMgcmV0dXJuIEVOT1NQQywNCj4gd2hpY2ggYWx3YXlzIG1lYW5zIHdl
IHJhbiBvdXQgb2Ygc3BhY2UgaW4gdGhlIHVzZXIgcHJvdmlkZWQgYnVmZmVyLg0KDQpUaGlzIG1h
a2VzIHNlbnNlLg0KDQo+ID4gPiAtCWtmcmVlKGRldmljZXMpOw0KPiA+ID4gLQlyZXR1cm4gcmV0
Ow0KPiA+ID4gKwlpZiAoZmlsbC5jb3VudCAhPSBmaWxsLmRldmljZXMgLSBhcmctPmRldmljZXMp
DQo+ID4NCj4gPiBTaG91bGQgYmUgImlmIChmaWxsLmNvdW50ICE9IChmaWxsLmRldmljZXMgLSBh
cmctPmRldmljZXMpIC8gc2l6ZW9mKGFyZy0+ZGV2aWNlc1swXSkpIiDwn5iKDQo+IA0KPiBkZXZp
Y2VzIGlzIGFscmVhZHkgYSB0eXBlZCBwb2ludGVyIHNvIHRoZSBjb21waWxlciBjb21wdXRlcyB0
aGUNCj4gL3NpemVvZigpIGl0c2VsZg0KPiANCj4gWW91ciB2ZXJzaW9uICBhYm92ZSBpcyBuZWVk
ZWQgaWYgaXQgd2FzIHZvaWQgKg0KDQpHb3QgaXQuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
