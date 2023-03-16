Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E6A6BC76F
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 08:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjCPHkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 03:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjCPHkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 03:40:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09978B060;
        Thu, 16 Mar 2023 00:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678952428; x=1710488428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IUKsf2CQ/Tbp+oEJIbZANw0IU/vzwZbkI8qTwg7zTag=;
  b=U24wbAZN5c4e8uBkZPvg2XbuXRbHYH+7yQC/dnOgLpj3IqGLP12oUuL8
   vb2Ozw9SqhUX+F0C3wmokl0TeszVN8aFH5mu05q23Vjsl3gaPh6fUth4i
   7/Re6hStB+RXTTtv/QNHi7VVhWssxTihFuom9rUEbsInzPhBXGFrbNxIL
   3UNJomCjJVsD4iet/anGyQTs8Pd+ZFru591284Kvtj9MIDQjK124hyd5Z
   GoaG1pdYDYjb+z2O5+/vmQjJ/0guoIWIkAsGyqGAQF9aRHW0g4utnmouy
   DRFT6sM+86O0iXSXg9KY7IqVE9/2eh803oya8fX3dVp+4ExMjNXM0QlZ9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="317565691"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317565691"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 00:39:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="673042638"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="673042638"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2023 00:39:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 00:39:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 00:39:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 00:39:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 00:39:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuI7i19U5w+wKvdxxt0IZiKRV/fuB3ImWp09YbZBAH5hB2IAyx6AzrGHy6bVsxnDnFp5D3MIbgErfLdeqCbZUmolT4hI5C60EEpOrvFQX8zkYHBvcYBR+YAZIOfZDSJVWXnbinXKYSZPgbZfAmNVlBr8qZzNTaYySqUL9zRATQbHyHSe+dQkvQyl3rdpV/cQfh95iaM8GHVuE1t48f8rWD5KFM0ho2wmhxHSwJYEkLc1PB6ooOgRTnzr9+4C2b8eMv0C2xF4WVPGnFsVjd7QILFAqJ3u7rgOnlzJLsz4Jbq4J5AQYtfK4rZSi2u8z/yrmnaxUXG3hafpNM7QgSLklA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUKsf2CQ/Tbp+oEJIbZANw0IU/vzwZbkI8qTwg7zTag=;
 b=IRdzs44lGMAGtFCqgCqFaWuKmbx2rGOgbV4u9qG9zMLnS46Ho+DDSqCGAV2GPbjLxw1mP0yFBzgRMnJ5p0XtkQhOGDdFYoly/sQmnXjGBLaiqCui+x0VwuHMxSwm3/CXsxnrckysqkPV6zgZF5oubJ08Z7dVntuRrjcktYTDFTN1ka9HpsLswMPRK4mpo5ImKC4KTe2COwjNfvjgFwgy1OAITslymvwex9Z8Ci08TmOm/dTw4HF/pcDmTZb/EUeEq8uU4jBghtbuw3sHB/ESAPM3ojOYD0iEGiFqOLXJXDgxm8eLbuhA61HHBQhkSiHdKgyOPISpTUDX3UkQYRfeWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB7509.namprd11.prod.outlook.com (2603:10b6:806:346::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 07:39:50 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 07:39:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "Xu, Terrence" <terrence.xu@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: RE: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Index: AQHZSpxK1lmQCF+hqU67xTFYCSDhDq7jLB2AgACBDoCAAOlEAIAAn5IAgAIKi/CAAO3wAIAA+kPAgAEQJQCABt1mAIAJIAFQgAJepACAAIl5QA==
Date:   Thu, 16 Mar 2023 07:39:49 +0000
Message-ID: <DS0PR11MB752919DAF139D5776BCEC23BC3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
 <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <SA1PR11MB5873479F73CFBAA170717624F0AC9@SA1PR11MB5873.namprd11.prod.outlook.com>
 <Y/64ejbhMiV77uUA@Asurada-Nvidia>
 <b7c1f9d5b4b647f0b0686c3b99f3d006@huawei.com>
 <ZAE2J0I1LiBjWUnm@Asurada-Nvidia>
 <d59a0262d5bf423c9e49ad4ac6015296@huawei.com>
 <ZALspPvvLGFuK96F@Asurada-Nvidia>
 <90a277ea100d496b82f8cc84388bbca2@huawei.com>
 <ZBJTUiukDLysAeAx@Asurada-Nvidia>
In-Reply-To: <ZBJTUiukDLysAeAx@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB7509:EE_
x-ms-office365-filtering-correlation-id: e2153078-2037-4c6b-7457-08db25f19f67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g5sQjlUr+H6YuF6xk+3kwSIwL3G2jtBPBn7Cc1zdQwAnAKbFJ3rs8JlrTxidYmcrwdhWMZNGCvRdyAR8LFjBoJqBya3T4ktfaQYl5S3J2t+Qh0Rhobc3nQVMeh98Zfogh4gb1ohD+3sACq4UkUEdc8ka4CMwj+iXYenTCE+t1DYRGjBxT/L0xcX0JGhSUbF7R6t4qUR5l4P/XkMO6HNE4OGotYc/cuILLgvfOx+1x8P9A1JwN3baBvL2zp7p4YWaHyq7wF+5WVpL45ep/wF/0/ErlKZQjPeYq8GOQZRTZLM8w7/PODZB+DEYrnXths0pc6eEzaTRJuUjKT4VNKxoyW35z3Lh8ecB3LnWIaXg5Yh8+cBSg/jDjwFrPbYkSOGfEhjeDEhV+CGOUFxqxWN1hG0LF0lxwrd874cv4AMTAbu6ekJBOaDeTEAAeGu7FxFcKxwW83Bso+0V/o7x4aTKM4kq0hOmCLLohehtAfk1lwnRy034Rj0Ay4qgj7YvaKZBdG78GSNrB7vnWszm+1bsscFD3slVLjLKN4PniTNzGuFHAeI8WUybDO3iNfK7YfkspmyCl2Uk2Q/GmdRgcjGNYJdTpcTmwhOsa26+nep5y3WQ2bjA6h908LI46TgiWgMD6FJAbtyTT9xTbQzlm3hsoO3M4z/wXiT1sv356Pi/MbH8JsLHkrD+n5WHXOY+QTxE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199018)(54906003)(110136005)(478600001)(64756008)(83380400001)(86362001)(38070700005)(122000001)(33656002)(55016003)(38100700002)(82960400001)(966005)(26005)(7696005)(71200400001)(9686003)(316002)(186003)(6506007)(5660300002)(66476007)(76116006)(8676002)(4326008)(66446008)(66556008)(66946007)(2906002)(41300700001)(8936002)(52536014)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkNvOVB4NGJsYmxEME8zTjlka00vZE5ROVczN3N4Nmh3VCtCSzRQSVVZUnBO?=
 =?utf-8?B?MThhUXhxQ2l1TzdpWjNXVHAxaW9CTCtLQkh6UW9FQTV3cXlEYmlEdHJ4NGpO?=
 =?utf-8?B?eWdCSEdndWZEcE1XMjJiSXJKVDYyVnRQVVFxTzFIbmJ0ak14UnFpZjNMVDRy?=
 =?utf-8?B?NlhNMStUeEY3OWNPTHpiLzhpOHNmVit3RTQyWkx4ZWRVcXl5T3g1dkVPRG05?=
 =?utf-8?B?U0FvZWhwS00vMVZIeFkzaTRPK2ZBYWRYblFvK0lzKy9keHA2Z21PcVBXenJz?=
 =?utf-8?B?cW11NWhoWm8xZ0NNRkdHQklXN3daeFlOcmpPNW40UDk3UTk3aFNuV0lZblRy?=
 =?utf-8?B?aHVSMU1LRFNYRThiZDY2U2pLMmhsZ1QxOCtJZnVadlBHc1RKYWFiNW5DRG9w?=
 =?utf-8?B?UVI0Um5iL1huUWNmQytWTXdJQ3NMVzdrVzM5bEwxN3pXM3hIM3E3OGtvY1dD?=
 =?utf-8?B?UHNBM2RGelRzWDlRUXd4RU5aSTFYdVJxbmVNZVBobmRWd3hQTnlYcVIycEpQ?=
 =?utf-8?B?U0orclB5UUN3MWxRRWJneU5OQmhvTS80dG1RRjNQQmxTdVNnbDFFRis3RHVl?=
 =?utf-8?B?b1FnZHVNRE5JRjNnZmZDdHBMeUo0alFOYjhleVFWY1VTd0tqZDdxaEZVeTVO?=
 =?utf-8?B?MnVVbDJ4RGNxWUVLWnZCNFp0NitJVmtsZWdOT2d5amJEQ2g2T3poanlMRmc1?=
 =?utf-8?B?MUtFamtwWndySGtTT2toakpnenoxQnFEYVcvcFh3OVdXNEQzM3B5MEczbWQy?=
 =?utf-8?B?R3F6amhHTC9DdHBPZzZ5SU1KV1UzeVMwSmI3MDdxSmw1a1N6NjBGemd0ampa?=
 =?utf-8?B?bmM2OGJEejdKaXQxcjRCMWg5OVRxZDFsVWh5ZWRGYkxsSjhtSDdSZnZYSXEw?=
 =?utf-8?B?d0VLZ2RFbXhNTGpRUHBsZ3Znak5wY3BPd3YyQjJGejk3cXdEYlRHM0NEVnhp?=
 =?utf-8?B?elpWN1pxaGJmTlBqM3ZFL2VFc3RScmtIbS9wdVNiSVBKeTBRcEN0MEh0Z3dL?=
 =?utf-8?B?dVFSV1dmWkkwWHp6UWZlazBENEh4b1hZL2dKN21ST2YyTWVWcjVPcDN2TVZK?=
 =?utf-8?B?blZ2a1BhVkdZKzdDaGprOWVYY29uTEE3T25WQk03a3hSUkdWcnE2eitnZzMy?=
 =?utf-8?B?WDJxUmVzVFp6SEplRzFkak9BL0F5TjMvRGlEclRGRzE2S3pWYXgrcFZRdEdI?=
 =?utf-8?B?Z0p2TytUYlVLUzNDM3ZSMVlYSVYweUhxWFZucWkxbm8yUEJWcm41VU9DZUxC?=
 =?utf-8?B?bHV0UHd6QzROM1NHOFRuaGFpL0hNTjN6T1lkL0ZGWVBOSjRwZlVuUzVzQ3Y0?=
 =?utf-8?B?QWhBL3dMOGg5ZDY3R29QVzg1eGpRdkJpRG9Zc3hsYzFkZTRLRkVaMXM5akF5?=
 =?utf-8?B?V2tqZSs2aEhOUzQ5dlNaQ1Nha0RFa2JFMnpORVhWMHlIWnVWQzVod0NRYWpK?=
 =?utf-8?B?cjdETjdNNTBMSGU4dWRqT1ZIYnY5R0JyYnFoRDZ6NlVVdGVzVDRYeEJkbytE?=
 =?utf-8?B?d083TEZXMXVTOERhS1ROQWRrOTNRcURwNVE4MWRJOHBXRmVrQlJGMjc5YUts?=
 =?utf-8?B?U0I5cmh1dDdTYUIwaE9KZ1BPa0F3MGxvbVJ4ckQybm9CdzN2QjJPb01zVjli?=
 =?utf-8?B?L2Q2TFVJN05hMW1ZcVhZQU1QMWluSlBFK0ZiM3Mxd3dmajhiaGc3RFlpNFVk?=
 =?utf-8?B?dlNmNExoN09wK0ZSdTJHbzJDT1UwR3VEZjhzUEVGQzJmSFFnQTByOXc2NmRI?=
 =?utf-8?B?MzZ0M09UMXBnSkpOOU9CUG94VGtZcVFBY2djVDN5QkhnMkFrQ01pamF3ZTdo?=
 =?utf-8?B?cWUvaWllWDhTaXJVM09VRzZSblczVjVPeW1YQ3FrREJwUDkwTjN4NUlETEJ6?=
 =?utf-8?B?cnkveVdNbmhzNGI2SEZ4eEZNdkRIUVc1OXpKYXk3amxqR3c1OHlWRjdOS2E0?=
 =?utf-8?B?ajduWGN1QzZkUU55NXRWZGJjVXRNZFphaklGenljTzR2VTEzVDUyM2RseHhH?=
 =?utf-8?B?Z29VUmRnczc0YzVsdis1Z3AwcHRyN1Q0d2VIclNjeXBIZG83TndpUVBHeXBt?=
 =?utf-8?B?NDRreGJVTEh3bktQdG5ONThtcW1uK09RSEZpZjJlb2xUdW5EdVRJSkFDNTVh?=
 =?utf-8?Q?tRJWtEhkrnimNCQMGQUqUM5S6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2153078-2037-4c6b-7457-08db25f19f67
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 07:39:49.4134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1/4u1Ho6caBiT2ioPhCPuOFRLgaYT3cuQ9Z9HvUIAqPPwyAwZj5p+g+i9nyG9jMfT0P+TaOjBotCEIp/gVpy2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7509
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBOaWNvbGluIENoZW4gPG5pY29saW5jQG52aWRpYS5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBNYXJjaCAxNiwgMjAyMyA3OjIzIEFNDQo+DQo+IE9uIFR1ZSwgTWFyIDE0LCAyMDIzIGF0
IDExOjM4OjExQU0gKzAwMDAsIFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gd3JvdGU6DQo+
IA0KPiA+IEhpIE5pY29saW4sDQo+ID4NCj4gPiBJIHJlYmFzZWQgeW91ciBsYXRlc3QgUWVtdSBi
cmFuY2hbMV0gb24gdG9wIG9mIHY3LjIuMCBhbmQgbm90IG9ic2VydmVkDQo+ID4gdGhlIGFib3Zl
IGlzc3VlIHNvIGZhci4gSG93ZXZlciBub3RpY2VkIGNvdXBsZSBvZiBvdGhlciBpc3N1ZXMgd2hl
bg0KPiA+IHdlIHRyeSB0byBob3QgYWRkL3JlbW92ZSBkZXZpY2VzLg0KPiA+DQo+ID4gKHFlbXUp
IGRldmljZV9kZWwgbmV0MQ0KPiA+IHFlbXUtc3lzdGVtLWFhcmNoNjQtaW9tbXVmZDogRmFpbGVk
IHRvIGZyZWUgaWQ6IDQgSW5hcHByb3ByaWF0ZSBpb2N0bCBmb3INCj4gZGV2aWNlDQo+ID4gcWVt
dS1zeXN0ZW0tYWFyY2g2NC1pb21tdWZkOiBJT01NVV9JT0FTX1VOTUFQIGZhaWxlZDogTm8gc3Vj
aA0KPiBmaWxlIG9yIGRpcmVjdG9yeQ0KPiA+IHFlbXUtc3lzdGVtLWFhcmNoNjQtaW9tbXVmZDog
dmZpb19kbWFfdW5tYXAoMHhhYWFhZjU4N2EzZDAsDQo+IDB4ODAwMDEwMTAwMCwgMHhmMDAwKSA9
IC0yIChObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5KQ0KPiA+IHFlbXUtc3lzdGVtLWFhcmNoNjQt
aW9tbXVmZDogSU9NTVVfSU9BU19VTk1BUCBmYWlsZWQ6IE5vIHN1Y2gNCj4gZmlsZSBvciBkaXJl
Y3RvcnkNCj4gPiBxZW11LXN5c3RlbS1hYXJjaDY0LWlvbW11ZmQ6IHZmaW9fZG1hX3VubWFwKDB4
YWFhYWY1ODdhM2QwLA0KPiAweDgwMDAwMDAwMDAsIDB4MTAwMDAwKSA9IC0yIChObyBzdWNoIGZp
bGUgb3IgZGlyZWN0b3J5KQ0KPiA+IHFlbXUtc3lzdGVtLWFhcmNoNjQtaW9tbXVmZDogRmFpbGVk
IHRvIGZyZWUgaWQ6MSBEZXZpY2Ugb3IgcmVzb3VyY2UNCj4gYnVzeQ0KPiA+DQo+ID4gSWdub3Jp
bmcgdGhlIE1NSU8gVU5NQVAgZXJyb3JzLCBpdCBsb29rcyBsaWtlIHRoZSBvYmplY3QgZnJlZSBp
cw0KPiA+IG5vdCBwcm9wZXIgb24gZGV2IHJlbW92YWwgcGF0aC4gSSBoYXZlIGZldyBxdWljayBm
aXhlcyBoZXJlDQo+ID4gZm9yIHRoaXMsDQo+ID4gaHR0cHM6Ly9naXRodWIuY29tL2hpc2lsaWNv
bi9xZW11L3RyZWUvcHJpdmF0ZS12Ny4yLjAtaW9tbXVmZC1uZXN0aW5nDQo+IA0KPiBUaGUgc21t
dXYzIGNoYW5nZSBsb29rcyBnb29kIHRvIG1lLiBJIHdpbGwgbGV0IFlpIGNoZWNrIHRoZQ0KPiBp
b21tdWZkIGNoYW5nZS4NCj4gDQo+IFlpLCBJIHdvbmRlciBpZiB0aGlzIGlzIHRoZSBob3QgcmVz
ZXQgY2FzZSB0aGF0IHlvdSBhc2tlZCBtZQ0KPiBmb3IsIGEgY291cGxlIG9mIHdlZWtzIGFnby4N
Cg0KQWhhLCBub3QgcmVhbGx5LiBXaGF0IFRob2RpIGRvZXMgaXMgdGhlIGhvdCByZW1vdmFsIHdo
aWNoIGlzIGVtdWxhdGluZw0KaG90LXBsdWcgb3V0IGEgcGh5c2ljYWwgZGV2aWNlIGZyb20gdGhl
IFBDSSBzbG90LiBJdCBtYXkgdHJpZ2dlciBob3QgcmVzZXQNCnRob3VnaCBzaW5jZSByZXNldCBp
cyBzb21ldGhpbmcgbmVlZHMgdG8gYmUgZG9uZSBkdXJpbmcgaXQuIEhvd2V2ZXIsDQppdCdzIG5v
dCBhIGZvY3VzIHRlc3QgYXMgSSBhc2tlZCB3ZWVrcyBhZ28uIPCfmIoNCg0KUmVnYXJkcywNCllp
IExpdQ0K
