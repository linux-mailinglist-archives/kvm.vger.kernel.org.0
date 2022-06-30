Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1EC5616E7
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 11:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiF3J5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 05:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiF3J5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 05:57:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FECB43ACD;
        Thu, 30 Jun 2022 02:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656583053; x=1688119053;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+FQoWI2x5q/W3vI2/1Jd/xXZW9MALmSfzQJKgwB7DEM=;
  b=H4pa7e42Zo9/45EcxXpOijwv+GxyyCbxrEyjtc98V8AYY/wmLULIWW8u
   2N/PXU+SII30pHrFnUbdSf9rcodQq5FN5BxJaySveLmEbRQ3fKdxyP0rF
   ySsNCeVgn47PwbqKf3ZAGRdNpReyRazdZOGO2hUEmuQ7gPdf+XtHhriQp
   Mfo1xxx43t1i5iH5Ircbo0KcxCxAVh0MdQxGupdirL29KN43/U7NtDLEb
   Y2TN1qUcKX93GGAeJ8ZOSQdQuJESnyishXq2J/2636cRP+jUw6hdKi55N
   g9EhX+CxonJupAe4ea7dfrcFqQzjy9Sogq3CGCjOvTIb0Y1NTLOAYs0vs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="262709160"
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="262709160"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 02:57:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="623679928"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 30 Jun 2022 02:57:32 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 30 Jun 2022 02:57:32 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 30 Jun 2022 02:57:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 30 Jun 2022 02:57:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 30 Jun 2022 02:57:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqNisA2otygb+ftiIsGBtG7ZBe/MvQShBJ4ts1wjLJZsVx8a8A2t7DOnQTpQrxDqjq7Kx7nKkOUdNV5FY5drjMcWTB6mG6s4lPr5IAkFfbr+fbvW5OOnCVaenhoF0HZbQ4LwGCpjZlnXveNUExeFk25aZmlP/WOjDiqHooMb9SGExdujh4yY4hZobOX4dcWQiOS3aBxmRhZK3cmtWl4Z7//GIOFy8nQmwTWR/OgMfOjidq3WWcxRclQIenIRrxHJTcDiX60f6VnEg8c7IrZNMhwvVnu9Js5HAmF9r9OcN9jppW6+e08xVU/7xFHcMPQ089grXGOQu6ddtqTKOG0NZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+FQoWI2x5q/W3vI2/1Jd/xXZW9MALmSfzQJKgwB7DEM=;
 b=dMDkccYofApsFKHE7poh2mqEwiMIogIb0EcN8bMxaeUWCg59Ml+lxmKZB0XznLyKV72C/QP7P1C2bGJwu+VsFFyam69aZo6N2d1Bj/A6hAjmIYjAJom73rV+tGo7cWCcBmaz/wrCCMgVA8f0/s7nBFF/htd8yLr8uSmHa37W4lE2D329PIbbKay9bS+cisNDeJlhAvpF3U0mcfQtYk6e4xaBZE0DnujfNgrUjV04CbQlPW1P4BIPjeQmnip54RJ9KAZyhEYBaEIEetqvmrAJKe1y8M30yZnEoIo4EaA5JNv3A46Xav72+imslXNFrzvuPGtdIztw5iJq2M6H1qOPbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1814.namprd11.prod.outlook.com (2603:10b6:903:11d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Thu, 30 Jun
 2022 09:57:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5373.025; Thu, 30 Jun 2022
 09:57:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yong Wu <yong.wu@mediatek.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Topic: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Thread-Index: AQHYhzwc+z9iMdoELUOwrg1xSZWs8q1dxv6AgAATDQCAADDjAIAACdeAgABJGYCAAIGdgIAH9C8AgADSuACAABo2cA==
Date:   Thu, 30 Jun 2022 09:57:28 +0000
Message-ID: <BN9PR11MB527663460076DA4BC8D34D3F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-2-nicolinc@nvidia.com>
 <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
 <YrUk8IINqDEZLfIa@Asurada-Nvidia>
 <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
 <BN9PR11MB527629DEF740C909A7B7BEB38CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <19cfb1b85a347c70c6b0937bbbca4a176a724454.camel@mediatek.com>
 <20220624181943.GV4147@nvidia.com> <YrysUpY4mdzA0h76@Asurada-Nvidia>
 <e5799215-8b55-90a8-7ca4-35f85ffb5969@arm.com>
In-Reply-To: <e5799215-8b55-90a8-7ca4-35f85ffb5969@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e66232e-4ba6-432a-24c5-08da5a7ef172
x-ms-traffictypediagnostic: CY4PR11MB1814:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xM3SG8o23y5dUzUvd1z3prj/jBAcGHO/3ubWHYmdKAxR9LKWN44sfs+8x3XomTK781TzoUDGs/9+yoak58M0J1fSmj8JfSpePMBNjM1t6ABU6zXKwTe6q97LLP9VHyryPT64O0vQLXqNWfDWEvqd/zcpUH5GR22A23xLDgSmRiVe/WOYP8UgP+TddpYW2ZydXnnn5XahKbpLFetxsYM5wA31lJptH+cbIIGwBFElNGHi6xvM3jeO6dfeBVk8YREOu0mXRRKMzC13Bu6Jx6u8z7lJMyzWp8nzwPTA1xb0HFVQvEQ9n/0XoMGySeMSLrI6l9XP7wMvrOQndKiVZCmB92WOueB9QfVrpJKkzZhymfCOZpy9W12qG7o5DpIsT+dpmIIJiZ/zNzTCxUguDk2ruBeRnMDT7FQhnCMaqnz4UWEedV+SK3wGm/dfuNvUy4oHFfT6F4Pjs6y/Yhgs0E6sUdZ33cT2XSTEwq9UsxUNAIgbL3dZ11efyg3ZRc7LBq107Gyb15FSAPYbLrz5Fc7yBWplJRE+CsjMmZ01SAyCDBxZuFGWixcnjv3MnLJ/ZNIz+pk0wXFe/a7FezGqhiv9457PQ0ivBTqshDPZophFxgJxe+RqVa7aemFWzRAZ+kFhOXcxvbK7yo+Ze0oydgwKgQga3Y3PxKzVuN6nrpij47F/0qIWkqvhNQbmG3vQCExhLSfxhwePwEzgCqga75Qr3Pzv+DWyG878FLOOTLFESW3h7nwtXy91aKUmKHSIcy+wfAXj6Bpo5fLaW7rb/84ATfgUbwO/SaMjmAkEuym9cLfiviRx/iSb2zqR0OXnLx25
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(136003)(366004)(39860400002)(376002)(82960400001)(66556008)(66946007)(52536014)(71200400001)(4326008)(8676002)(7416002)(66446008)(41300700001)(53546011)(26005)(38070700005)(64756008)(9686003)(86362001)(66476007)(478600001)(6506007)(7696005)(76116006)(83380400001)(8936002)(55016003)(122000001)(2906002)(38100700002)(33656002)(54906003)(110136005)(316002)(5660300002)(186003)(7406005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGpHdkYvb2VuSGQ2Um9lU0JyaWRzaWNOMEpRaFByN3VhM3V6VGdMaE5zWXNz?=
 =?utf-8?B?QzlLVTlvVS9CNEh5bDM4a0xGWEtMRWxDelVyWm4vQ3ArM2dWWVFSL1FITFFN?=
 =?utf-8?B?dUtrNHplaml2aHA2dHdzbVIrRWFkREF2MnovN3kvemlEd2owUjdYNEtPcGxp?=
 =?utf-8?B?RmRoV0pxamNUS2JUL2FJQ3JUdmErVFFhTXY0NnJKSDAxRkhqeDcwaGl5RElS?=
 =?utf-8?B?Y09hMC80R3M2Rlhvek1SOTlib01hOERhZi84M0hUZkRJUzRnVUNGMnlVMDRS?=
 =?utf-8?B?WGgrYXNkRHlpSUNTYVRnZFJUSzBYdFo5SDRwSFlMeHlNTGZQN0J5ajdoZDNs?=
 =?utf-8?B?dVJ1OGtzZ2pVTDNRMXdNeWswRHRiNm1CMkIzN1NZZDI0SXI5cjFNakdLVWZt?=
 =?utf-8?B?RS8yN1lxOGFjMjIxY2orR0NKcGt1d2JZdEZudDVPK25XRGVlcTBXeFIvVUlk?=
 =?utf-8?B?aW5HR2ZLU0pmelVnWDluazdDN0dPRFJTWU5teXZCSmpkSUNGTkcvTDd1b1M2?=
 =?utf-8?B?OW5vTVJiUzJZTW5mbkxvdzIrY2VwOWtJTjFtc3VoRzFVQ0lrNzgzTkJYSjU2?=
 =?utf-8?B?UVdycU1wdWg5T0ZEZ1FGM2k0azI3Y3NrQVZSUkZndTFIcUZPZnZMNG5Dc2pp?=
 =?utf-8?B?M1BvWGZTN2dPcEpCSWVaMStZQWxSRzEyb0d5MmNNZDhPcFdTVTVVdWVRZWl4?=
 =?utf-8?B?UkFwK09hcDgramViV2E0T3hPd2syQmlsL0FCaGdPYTIxa096Z3JRS2I3MzVK?=
 =?utf-8?B?R2duQllrdnNqcnhMQWYyblVNd3NTZlRGeGhKdlZEWldEclI5VTIwdTd0VFJV?=
 =?utf-8?B?TS9rZ0hVSi9iTjNkVXl3RzFTdUNBNG9vWUF1OC9sQklxVm5SeE9lQWNzS0xx?=
 =?utf-8?B?WC83NEowVjNiQnNBNTAyMEZlUG1jRjM4VHhIaENpZXlwZW8veWJ5ODBsOElx?=
 =?utf-8?B?d2RJNmdQT1UrM3h0TzhXUDRCWUhqSmN2WFFyNjhYbWJQMDJnaU1MNm1VRUJP?=
 =?utf-8?B?bUI1dW4yM0xQY1J1bzJwVzl4cnptM1B3WGR1VkFBelp6QXF4S3lYQjRPNDlx?=
 =?utf-8?B?VUFjL2tmc2dlOEpVWnM3VHhlMm9FRDl3MnhJOTRYd1FlZFhJUlh2VGNYNVJQ?=
 =?utf-8?B?OXdPY3NJTERCUzVtK2o5Y1VDeDdhREM2TWhLbUloVGN1Yno1OVFaQ2gvYlBB?=
 =?utf-8?B?ZmlDVEdFVHh1WUs5SzhVSmF0b3dIREVUL2NydVNoRm1Cd3krWWZLSGN3Y254?=
 =?utf-8?B?NnVCOEtkZU1sZXdxdVA0NmVGOW9CSHFVejhXWXBFaFhlTTZQUDNKOS9lNzdv?=
 =?utf-8?B?eUExdEphU0dqNEwvNmFMaS90VTBnUjNTSUVUMlBhWWJIYitiaFg4R0FNdWZU?=
 =?utf-8?B?OWRsODJOcEx1ZnJhZzVNckZocG5UVEZFZ05GY3NDdDlkYVFjOGQ1bEdDOU5F?=
 =?utf-8?B?V3ZDWUhLU3BxeGNPSnlzZWk2am9rV3FOczBqMXphbkkrcWxkOEJrZHdNT1Rp?=
 =?utf-8?B?U3F6Zm0wWVRGc1p4NmpWK09WVFZsRkgxeFpINURpUmJFYWErWGlMdlQvdTVn?=
 =?utf-8?B?TThERkZvYnNIbHBFWUZscWsvOTRGN3p6aVJNeGdaSUxuVVY4alh0YXFvQlF2?=
 =?utf-8?B?ZERrNVUzSEhFaTEreE93U211VSt3S2Vkc2p6R3FDa1JlR21HZ0hHR2ZkcTZL?=
 =?utf-8?B?RG51VmhRcmViR0xpeFRNSmJFSDRmaWNDQXg2NmpnMk02SFBUT2xTTFZPbmtC?=
 =?utf-8?B?UkxrWCtRVTFuN1BSdW1VeGx3dk5mSmZOZ05aMzFwb3NsOS9vOVJRcm0vOEVD?=
 =?utf-8?B?MGtwK3lmc2h2TXp6c2dhK1pTZmxSL3FRR08rdkJIMTJVNnpkN0JjRmlvVGR2?=
 =?utf-8?B?dHFMd3c3bGVTZHQ3NnlOWS9YRUR2M05mTnUwZVJCUytPT3RLMENjL2RTbWht?=
 =?utf-8?B?M1htcHkrTld5dHJ6clFaTUVlYXRVTVY5MElwckJJSCtMQkt4RDhrQVY0c3Ir?=
 =?utf-8?B?amN4R2IzNU4ydWNIbkR3akxldXhySUl4b0tOMWNKNGhNUjBPaTRDd0ZqNG1V?=
 =?utf-8?B?S0NFck5FbXJrUGdrTy9mOW1senc2eHMvb0E4V2JrSWhzREIvWFBOdng2Vm4x?=
 =?utf-8?Q?8cmuZhsnSQKww7e53zBW7Af2N?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e66232e-4ba6-432a-24c5-08da5a7ef172
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 09:57:28.8889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jPCq+RD1a4QbiLE7FeCrALtSYohkj6YHQ3/ZhYi7M6w/vv//B2psJZu2YAMbEqrE+fAraWHFvNEraC3cgt8DsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1814
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBSb2JpbiBNdXJwaHkgPHJvYmluLm11cnBoeUBhcm0uY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgSnVuZSAzMCwgMjAyMiA0OjIyIFBNDQo+IA0KPiBPbiAyMDIyLTA2LTI5IDIwOjQ3LCBO
aWNvbGluIENoZW4gd3JvdGU6DQo+ID4gT24gRnJpLCBKdW4gMjQsIDIwMjIgYXQgMDM6MTk6NDNQ
TSAtMDMwMCwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+PiBPbiBGcmksIEp1biAyNCwgMjAy
MiBhdCAwNjozNTo0OVBNICswODAwLCBZb25nIFd1IHdyb3RlOg0KPiA+Pg0KPiA+Pj4+PiBJdCdz
IG5vdCB1c2VkIGluIFZGSU8gY29udGV4dC4gInJldHVybiAwIiBqdXN0IHNhdGlzZnkgdGhlIGlv
bW11DQo+ID4+Pj4+IGZyYW1ld29yayB0byBnbyBhaGVhZC4gYW5kIHllcywgaGVyZSB3ZSBvbmx5
IGFsbG93IHRoZSBzaGFyZWQNCj4gPj4+Pj4gIm1hcHBpbmctZG9tYWluIiAoQWxsIHRoZSBkZXZp
Y2VzIHNoYXJlIGEgZG9tYWluIGNyZWF0ZWQNCj4gPj4+Pj4gaW50ZXJuYWxseSkuDQo+ID4+DQo+
ID4+IFdoYXQgcGFydCBvZiB0aGUgaW9tbXUgZnJhbWV3b3JrIGlzIHRyeWluZyB0byBhdHRhY2gg
YSBkb21haW4gYW5kDQo+ID4+IHdhbnRzIHRvIHNlZSBzdWNjZXNzIHdoZW4gdGhlIGRvbWFpbiB3
YXMgbm90IGFjdHVhbGx5IGF0dGFjaGVkID8NCj4gPj4NCj4gPj4+PiBXaGF0IHByZXZlbnQgdGhp
cyBkcml2ZXIgZnJvbSBiZWluZyB1c2VkIGluIFZGSU8gY29udGV4dD8NCj4gPj4+DQo+ID4+PiBO
b3RoaW5nIHByZXZlbnQgdGhpcy4gSnVzdCBJIGRpZG4ndCB0ZXN0Lg0KPiA+Pg0KPiA+PiBUaGlz
IGlzIHdoeSBpdCBpcyB3cm9uZyB0byByZXR1cm4gc3VjY2VzcyBoZXJlLg0KPiA+DQo+ID4gSGkg
WW9uZywgd291bGQgeW91IG9yIHNvbWVvbmUgeW91IGtub3cgYmUgYWJsZSB0byBjb25maXJtIHdo
ZXRoZXINCj4gPiB0aGlzICJyZXR1cm4gMCIgaXMgc3RpbGwgYSBtdXN0IG9yIG5vdD8NCj4gDQo+
ICBGcm9tIG1lbW9yeSwgaXQgaXMgdW5mb3J0dW5hdGVseSByZXF1aXJlZCwgZHVlIHRvIHRoaXMg
ZHJpdmVyIGJlaW5nIGluDQo+IHRoZSByYXJlIHBvc2l0aW9uIG9mIGhhdmluZyB0byBzdXBwb3J0
IG11bHRpcGxlIGRldmljZXMgaW4gYSBzaW5nbGUNCj4gYWRkcmVzcyBzcGFjZSBvbiAzMi1iaXQg
QVJNLiBTaW5jZSB0aGUgb2xkIEFSTSBETUEgY29kZSBkb2Vzbid0DQo+IHVuZGVyc3RhbmQgZ3Jv
dXBzLCB0aGUgZHJpdmVyIHNldHMgdXAgaXRzIG93biBjYW5vbmljYWwNCj4gZG1hX2lvbW11X21h
cHBpbmcgdG8gYWN0IGxpa2UgYSBkZWZhdWx0IGRvbWFpbiwgYnV0IHRoZW4gaGFzIHRvIHBvbGl0
ZWx5DQo+IHNheSAieWVhaCBPSyIgdG8gYXJtX3NldHVwX2lvbW11X2RtYV9vcHMoKSBmb3IgZWFj
aCBkZXZpY2Ugc28gdGhhdCB0aGV5DQo+IGRvIGFsbCBlbmQgdXAgd2l0aCB0aGUgcmlnaHQgRE1B
IG9wcyByYXRoZXIgdGhhbiBkeWluZyBpbiBzY3JlYW1pbmcNCj4gZmFpbHVyZSAodGhlIEFSTSBj
b2RlJ3MgcGVyLWRldmljZSBtYXBwaW5ncyB0aGVuIGdldCBsZWFrZWQsIGJ1dCB3ZQ0KPiBjYW4n
dCByZWFsbHkgZG8gYW55IGJldHRlcikuDQo+IA0KPiBUaGUgd2hvbGUgbWVzcyBkaXNhcHBlYXJz
IGluIHRoZSBwcm9wZXIgZGVmYXVsdCBkb21haW4gY29udmVyc2lvbiwgYnV0DQo+IGluIHRoZSBt
ZWFudGltZSwgaXQncyBzdGlsbCBzYWZlIHRvIGFzc3VtZSB0aGF0IG5vYm9keSdzIGRvaW5nIFZG
SU8gd2l0aA0KPiBlbWJlZGRlZCBkaXNwbGF5L3ZpZGVvIGNvZGVjL2V0Yy4gYmxvY2tzIHRoYXQg
ZG9uJ3QgZXZlbiBoYXZlIHJlc2V0IGRyaXZlcnMuDQo+IA0KDQpQcm9iYWJseSBhYm92ZSBpcyB3
b3J0aCBhIGNvbW1lbnQgaW4gbXRrIGNvZGUgc28gd2UgZG9uJ3QgbmVlZA0KYWx3YXlzIGRpZyBp
dCBvdXQgZnJvbSBtZW1vcnkgd2hlbiBzaW1pbGFyIHF1ZXN0aW9uIGFyaXNlcyBpbiB0aGUNCnRo
ZSBmdXR1cmUuIPCfmIoNCg==
