Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A8B6CC6FF
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 17:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjC1Pqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 11:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbjC1PqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 11:46:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4807849ED;
        Tue, 28 Mar 2023 08:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680018345; x=1711554345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uSXsUW0kwhLZk7aM9KPHi6kcOevFGMTKJ+fMxgeD0Wg=;
  b=RfJi4tZ9AnTage6CFmmaN9j72xhtPGXZoWr41t2Yrpn2zHRP8hJFV2Aj
   EvXdBrEJPmzeHicxzs+iRrtmbB3PUv9FsJOsZaU2Xu2ZKUY8x/h51WB2g
   +bRCiSwFtMSKb44yw37COwHzPdUkAk/mYIY8KatITH+fSr0LYT0tiRgCp
   d1K6YuNGF+wix8CX5XQz5+AqzTa1GQ5hTqKxrossYEXPQNE7+VJxBLh57
   x2h6kuHR8NPhAbLS4L6MjUNGCEb8JAzN7qO/OLvjB6foAtAKM6Nn438FG
   Lavt0jEXOdIuCpuPx0CxykCmiwIrHVcU2OjAcb9UtaottS8xkMwZKmMNx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403217361"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403217361"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 08:45:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="794877561"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="794877561"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2023 08:45:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 08:45:42 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 08:45:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 08:45:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 08:45:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW2DqHe4XsNd/WS0UZL3mhuf1QN7MMIvt/uiDqP+3GB5HTr1TVOzyYUbVO0JkwBoJmAXWddl8p5usWbtcQTWlJbA5VFFZGApoKdp5cwTt6mTvno3sawGfs/MHNiNrF0xjwxU6aVBxa/nraBETcHs+KVx3eGuPgKUqEV91AWGROM9fvSUYR9IkDcX+E4OGsRH31ODhvMEYdY9DDj3tqzvY7GDSld0FW6CjAR+JJIZoBhg0WcB+Og6qWXZTBsTbHcMN7P4QnHb7rl0JEP2Ic5eyLga0S3r51m74UMvXsgaKE69giL2DbZ/ZPPDxFV71c2vHMfAsWA6pWrxs/Lp0W2jNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSXsUW0kwhLZk7aM9KPHi6kcOevFGMTKJ+fMxgeD0Wg=;
 b=OajIOsb3Kuz5Ajls0V9V8rH6lhiMsTBAq4nxRKKyJEpw6t1dnwBryCMhIaw++J3MsswpUR6gNp/h2CNVdoUUzmNnlXQzHotGJExZoDUIkDypLBSUOzi2qNoYfUsIruwYImiCXPODCKQ/WXPms0MJCwFBBt7j9Ex55Cprz0GhpY9PWymezk3gkjXAc3hQhCthAQ80HGIevjDik2tFQ/lc+FNdL0j82QLXRkOdM8oEWiwDYqI4VANRA6XWIO9a4FTXnUj3r8I2m6iqyINQ9jkc1pi2kq/RtDf83nE9sn3aMaU/ZeWDFE3SdpIggJdHfLEfNmDqpkL/QinA300t8kq+iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6909.namprd11.prod.outlook.com (2603:10b6:303:224::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 15:45:39 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 15:45:39 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92Dc+A7iEOnEaMeK3O2ipWfK8PAuSAgACBxlCAADScAIAAh+4AgAABaZCAAARdAIAAAahggAAHN4CAAAKPcA==
Date:   Tue, 28 Mar 2023 15:45:38 +0000
Message-ID: <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
In-Reply-To: <20230328091801.13de042a.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB6909:EE_
x-ms-office365-filtering-correlation-id: 78f97ddc-a2d9-405d-06b6-08db2fa37ac1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pHbdisQJ8RyjxnJ3TSTTobo/faNTisVaKaQICoY7S+kAO44+ed058ZV9AO0d/sCT8BNOnGO5/NObjbAhNDVDr3pzI8uNmDXmkRI/p3s+Ny+/KY3J7fxpBWbDDDKA4VB4X30ervK72ZDTZ/NW4rLFqmzRE0ac8Uc6UYbFCpA8V4z/pC4bPLlHuRDDWwlNdxFAeIXIycgHYxMlqbCj4kJxjAIyC5ZYBgzKQw9Dg3YpDyAABS0hdUlSeLYW6QgTQQ4vp+BJfy4XHWUwPgIRzDi0Ayg5E/j6z5q+7+mTbYNMPkyY2WS08Yiq2muW0EpsQipAUf9cEsTioVX5FcyxZHOTC+pqDQ2GQ3bcS3g0q0OUqCv/dZwi7bf9jYjcpMavr4d8ny2oD1Uxr4GsSSF8Nlbzy7Mp0yLehozIamCREqGBLiLdFxbxzgLCYd5qSIDRQxD5nwQKMsi3VqTxa63zBYdzvsZQpXTY3PDW63tcuBJvXeGIXEM4wVmVNQ/TEAjHthf1mg2Tz/HIcqgCAGPFbZTVEt6QkZRX/F39FWHJW8grvmF5EDt+r7IWiDzDq/NN6dFn4xZqIhZG5ZmCt18mDqbKAGZN6ze8u6BOOFOhEfGnCPtP+CzQ9jnZhkiw7nk73MUm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199021)(5660300002)(2906002)(38070700005)(316002)(478600001)(122000001)(54906003)(86362001)(83380400001)(7696005)(966005)(82960400001)(38100700002)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(76116006)(33656002)(71200400001)(6916009)(55016003)(4326008)(9686003)(6506007)(52536014)(7416002)(8936002)(41300700001)(186003)(26005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3E1aDd4NDNOUHFZWDVVSkFiZFBUVlJjcTR2ODFnZ3BwRzBnd1RpZDVOOW5j?=
 =?utf-8?B?ZTA3UGJicllYcVpUTGRlSk1ES0pQMnYwVS83TkFiMGdJVXgzc1BmZ2JNajls?=
 =?utf-8?B?MTV4QTlJalJNWUhEVlh5T1gvQWowVC9RSzMzR2JQU1orcE13VTI5elpJaVNq?=
 =?utf-8?B?RmVYL0VoZTZxVU5HVlpmTVRyOXJlSUU0YitQNXlQTW53VHJROG9oQ29Da1Ix?=
 =?utf-8?B?a205N1c4OWZKOFBnb0NGNVFLclBrN3Zab0Y5WGRydU1uUTZoQnNnVWJkcEE2?=
 =?utf-8?B?RzFxbTMxTjRLVEE0L3J4NEo2Q0IvMVNKdHUxTXFnVC9DVGozdWlGYWRrdG1S?=
 =?utf-8?B?YkRlbWdOQzdHZFpaaTBLS3Rmeng2a05HTFJIV3EwL3k0NmFWMG5zS2FjY2ps?=
 =?utf-8?B?RUwvcDVVcW1VN0FIKzJXcUZnZzR6WUxlcU01QzllQzl4NUhUKy9BOGQ0RlR1?=
 =?utf-8?B?QzJlT3Y0amMvZ3lsVENRODAyNDU0elpVc3NxaDR0L3FFdHpUa1VGTjh0UXdE?=
 =?utf-8?B?QUs4bnBGSGN5SlZGbXN3Mm5YbVhWSWhnbm44amhmakF2V2hSZG5tZlRyZXFP?=
 =?utf-8?B?YVdJNmdjUXBpQ2lBYS8ySm92b2ZwdzFpZ3RlVUp3SVFCV2R2V0pDWHA0Q0lC?=
 =?utf-8?B?d2tTVnk5eTVlWFlLRi9MSDlrRVVsWXJ5WWFuVW5MRnMwT3Bmd1NJMTQzZjJ4?=
 =?utf-8?B?TUZmbDhlN3FFcEVKZjMxV1kzS2F4V2lJR25QaUdnK1hsT05maG9iMzBQT29N?=
 =?utf-8?B?OER4WXBXRHE1WndMbFZ1STRXR0xieE9HLy93RHJLUXI4WTJxbzNSeGgvRWhl?=
 =?utf-8?B?YVdIb1VwRVdWQVV6MEpYaWxldzRVOVdGc3dETkFCWldxRFIrSDhhOTM1ZzFw?=
 =?utf-8?B?MUhzTlpKZ3BpQjhmZldIR3BrT3A0a1Rmb3YwV1lDUEg1K0RRRXZTSFQ1bnRv?=
 =?utf-8?B?NVBNRWo5bHg2WmY0T0NpcFpXOHIycDU4Skt4aVJYeElSWmZYVmM4YlpiUGo0?=
 =?utf-8?B?VCtaNklPaHBNL2dwZXFiTFJaUXdjd2VYeFVXMERGVkg1bEVQZlFZaHlZYTZ0?=
 =?utf-8?B?bnJ0WE5WdmVqMjNwa200N2l1ZldETXJQaFdqL0Ryek5xL1FiL0l4U2NmWUdX?=
 =?utf-8?B?UnRWRGhmNDd3dENxSzJMYUY1dDdOU20rTjkvYUpoYjJ2NFpQL2VYbnhlQnZm?=
 =?utf-8?B?QTQya2Y5ZGhMTERpUWZLK3BucW1udWVWSXFjcjFqbmtPcVFab2hheTA2NzBU?=
 =?utf-8?B?MXJjTnlPbXJDRnkzRUZpOUJ4YnVBZkVtTVJGKzJncHExUFZ2UEJHWnJJWXFy?=
 =?utf-8?B?aC9UZXFoREJFNG5HRHVIQVVMdkMzMWRyOXl6cHdQQzJmNUI2SDdUOE41bTZL?=
 =?utf-8?B?YkNxY28zVzZHS0hZUlk0bHVDMHVjTzh2UmVDZkEzeVFSUXp3SHUyQXYwRTBl?=
 =?utf-8?B?TGJ3YnJFdlh6ak15ZFpQQzVFaTRTblBRZ25ZMmtzeDY1NVFwSEV4MU5ObzhC?=
 =?utf-8?B?Q0RFRDJGUVJCTkFmbkM4V0VLN00rMkl4aGxkRkNudHNYWDFUOFJOVEhiK2Zs?=
 =?utf-8?B?eDVmU2srbjJiRUduVEl2Z3pNMEsyZEZTMHh1Y21jUmI2ODlicjEzeGlFbGpx?=
 =?utf-8?B?SS9VNHZZcHF3QUtKaTZ4ZmJOOFF4OUd5RGNpY3M1aisyRUN3cnZyK0FQN1lw?=
 =?utf-8?B?cjhVVXc3U1JvRXovZ2c1Wm9sU1NzemR1enVoZ3dwT1g0R0YzeFNRQWt6VGVx?=
 =?utf-8?B?MHo0YzN1WnFpWklFRjAzTXdHL09Vd25BditOQTJQc3RKVHM4Qm9VcmtNZmpk?=
 =?utf-8?B?NXlnelI3dHVFSWNPN3dobVROWWZuWEtueEZPcFM3Z01qL09NR1VrL1luUkkz?=
 =?utf-8?B?SmpWU0RPMVZad0RIT281ZXRFZXRhaGh4THkvbDljQnkzRmVkL3lBY09XQ2lF?=
 =?utf-8?B?Y1RvQmZBSUxJcE54Mld3YjludnhUdlFLanpjNkUyMkR6cXVLVm1LZEhxWGwr?=
 =?utf-8?B?c1QxTVh0ZW04SjVrRDh4bnZwMzBXWSt3RjNDTzJoV2N5YlhrUFlaRkRhMHdR?=
 =?utf-8?B?amxleThieGd5RzVqbVRyVXV5ZFRlVTNkbkZxUEJmRTRCNDVFVVJCN0V2OSsw?=
 =?utf-8?Q?BUKU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f97ddc-a2d9-405d-06b6-08db2fa37ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2023 15:45:38.8077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pk7xnvPzTyHgcQK2fVZ93lrDXWNiAR1skdedIv9y5/y50c+lQmDSQLQpffMpXaoeFNsymafgtpD3DvzbK5G8kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6909
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBNYXJjaCAyOCwgMjAyMyAxMToxOCBQTQ0KPiANCj4gT24gVHVlLCAyOCBN
YXIgMjAyMyAxNTowMDo0MiArMDAwMA0KPiAiTGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwuY29t
PiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNv
bkByZWRoYXQuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwgTWFyY2ggMjgsIDIwMjMgMTA6NDYg
UE0NCj4gPiA+DQo+ID4gPiBPbiBUdWUsIDI4IE1hciAyMDIzIDE0OjM4OjEyICswMDAwDQo+ID4g
PiAiTGl1LCBZaSBMIiA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiA+
ID4gRnJvbTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4g
PiA+ID4gPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAyOCwgMjAyMyAxMDoyNiBQTQ0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4gT24gVHVlLCAyOCBNYXIgMjAyMyAwNjoxOTowNiArMDAwMA0KPiA+ID4gPiA+
ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+
ID4gPiA+ID4gU2VudDogVHVlc2RheSwgTWFyY2ggMjgsIDIwMjMgMTE6MzIgQU0NCj4gPiA+ID4g
PiA+ID4NCj4gPiA+ID4gPiA+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlh
bXNvbkByZWRoYXQuY29tPg0KPiA+ID4gPiA+ID4gPiA+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDI4
LCAyMDIzIDM6MjYgQU0NCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+IEFkZGl0aW9u
YWxseSwgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5GTyBoYXMgYQ0KPiBmbGFncw0K
PiA+ID4gYXJnDQo+ID4gPiA+ID4gdGhhdA0KPiA+ID4gPiA+ID4gPiA+IGlzbid0IHVzZWQsIHdo
eSBkbyB3ZSBuZWVkIGEgbmV3IGlvY3RsIHZzIGRlZmluaW5nDQo+ID4gPiA+ID4gPiA+ID4gVkZJ
T19QQ0lfSE9UX1JFU0VUX0ZMQUdfSU9NTVVGRF9ERVZfSUQuDQo+ID4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiA+IFN1cmUuIEkgY2FuIGZvbGxvdyB0aGlzIHN1Z2dlc3Rpb24uIEJUVy4gSSBoYXZl
IGEgZG91YnQgaGVyZS4gVGhpcw0KPiA+ID4gbmV3DQo+ID4gPiA+ID4gZmxhZw0KPiA+ID4gPiA+
ID4gPiBpcyBzZXQgYnkgdXNlci4gV2hhdCBpZiBpbiB0aGUgZnV0dXJlIGtlcm5lbCBoYXMgbmV3
IGV4dGVuc2lvbnMgYW5kDQo+ID4gPiBuZWVkcw0KPiA+ID4gPiA+ID4gPiB0byByZXBvcnQgc29t
ZXRoaW5nIG5ldyB0byB0aGUgdXNlciBhbmQgYWRkIG5ldyBmbGFncyB0byB0ZWxsDQo+IHVzZXI/
DQo+ID4gPiBTdWNoDQo+ID4gPiA+ID4gPiA+IGZsYWcgaXMgc2V0IGJ5IGtlcm5lbC4gVGhlbiB0
aGUgZmxhZ3MgZmllbGQgbWF5IGhhdmUgdHdvIGtpbmRzIG9mDQo+IGZsYWdzDQo+ID4gPiA+ID4g
KHNvbWUNCj4gPiA+ID4gPiA+ID4gc2V0IGJ5IHVzZXIgd2hpbGUgc29tZSBzZXQgYnkga2VybmVs
KS4gV2lsbCBpdCBtZXNzIHVwIHRoZSBmbGFncw0KPiBzcGFjZT8NCj4gPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBmbGFncyBpbiBhIEdFVF9JTkZPIGlvY3RsIGlzIGZvciBv
dXRwdXQuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gaWYgdXNlciBuZWVkcyB0byB1c2UgZmxh
Z3MgYXMgaW5wdXQgdG8gc2VsZWN0IGRpZmZlcmVudCB0eXBlIG9mIGluZm8NCj4gdGhlbiBpdA0K
PiA+ID4gPiA+IHNob3VsZA0KPiA+ID4gPiA+ID4gYmUgc3BsaXQgaW50byBtdWx0aXBsZSBHRVRf
SU5GTyBjbWRzLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gSSBkb24ndCBrbm93IHRoYXQgdGhhdCdz
IGFjdHVhbGx5IGEgcnVsZSwgaG93ZXZlciB3ZSBkb24ndCBjdXJyZW50bHkNCj4gPiA+ID4gPiB0
ZXN0IGZsYWdzIGlzIHplcm8gZm9yIGlucHV0LCBzbyBpbiB0aGlzIGNhc2UgSSB0aGluayB3ZSBh
cmUgc3R1Y2sgd2l0aA0KPiA+ID4gPiA+IGl0IG9ubHkgYmVpbmcgZm9yIG91dHB1dC4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IEFsdGVybmF0aXZlbHksIHNob3VsZCBWRklPX0RFVklDRV9HRVRfUENJ
X0hPVF9SRVNFVF9JTkZPDQo+ID4gPiA+ID4gYXV0b21hdGljYWxseQ0KPiA+ID4gPiA+IHJldHVy
biB0aGUgZGV2X2lkIHZhcmlhbnQgb2YgdGhlIG91dHB1dCBhbmQgc2V0IGEgZmxhZyB0byBpbmRp
Y2F0ZSB0aGlzDQo+ID4gPiA+ID4gaXMgdGhlIGNhc2Ugd2hlbiBjYWxsZWQgb24gYSBkZXZpY2Ug
ZmQgb3BlbmVkIGFzIGEgY2Rldj8gIFRoYW5rcywNCj4gPiA+ID4NCj4gPiA+ID4gUGVyc29uYWxs
eSBJIHByZWZlciB0aGF0IHVzZXIgYXNrcyBmb3IgZGV2X2lkIGluZm8gZXhwbGljaXRseS4gVGhl
IG1ham9yDQo+ID4gPiByZWFzb24NCj4gPiA+ID4gdGhhdCB3ZSByZXR1cm4gZGV2X2lkIGlzIHRo
YXQgdGhlIGdyb3VwL2JkZiBpbmZvIGlzIG5vdCBlbm91Z2ggZm9yIHRoZQ0KPiA+ID4gZGV2aWNl
DQo+ID4gPiA+IGZkIHBhc3NpbmcgY2FzZS4gQnV0IGlmIHFlbXUgb3BlbnMgZGV2aWNlIGJ5IGl0
c2VsZiwgdGhlIGdyb3VwL2JkZiBpbmZvDQo+IGlzDQo+ID4gPiBzdGlsbA0KPiA+ID4gPiBlbm91
Z2guIFNvIGEgZGV2aWNlIG9wZW5lZCBhcyBhIGNkZXYgZG9lc24ndCBtZWFuIGl0IHNob3VsZCBy
ZXR1cm4NCj4gPiA+IGRldl9pZCwNCj4gPiA+ID4gaXQgZGVwZW5kcyBvbiBpZiB1c2VyIGhhcyB0
aGUgYmRmIGtub3dsZWRnZS4NCj4gPiA+DQo+ID4gPiBCdXQgaWYgUUVNVSBvcGVucyB0aGUgY2Rl
diwgdnMgZ2V0dGluZyBpdCBmcm9tIHRoZSBncm91cCwgZG9lcyBpdCBtYWtlDQo+ID4gPiBhbnkg
c2Vuc2UgdG8gcmV0dXJuIGEgc2V0IG9mIGdyb3VwLWlkcyArIGJkZiBpbiB0aGUgaG9zdC1yZXNl
dCBpbmZvPw0KPiA+ID4gSSdtIGluY2xpbmVkIHRvIHRoaW5rIHRoZSBhbnN3ZXIgaXMgbm8uDQo+
ID4gPg0KPiA+ID4gUGVyIG15IHByZXZpb3VzIHN1Z2dlc3Rpb24sIEkgdGhpbmsgd2Ugc2hvdWxk
IGFsd2F5cyByZXR1cm4gdGhlIGJkZi4gV2UNCj4gPiA+IGNhbid0IGtub3cgaWYgdGhlIHVzZXIg
aXMgYWNjZXNzaW5nIHRocm91Z2ggYW4gZmQgdGhleSBvcGVuZWQNCj4gPiA+IHRoZW1zZWx2ZXMg
b3Igd2VyZSBwYXNzZWQsDQo+ID4NCj4gPiBPaCwgeWVzLiBJJ20gY29udmluY2VkIGJ5IHRoaXMg
cmVhc29uIHNpbmNlIG9ubHkgY2RldiBtb2RlIHN1cHBvcnRzDQo+IGRldmljZSBmZA0KPiA+IHBh
c3NpbmcuIFNvIEknbGwgcmV1c2UgdGhlIGV4aXN0aW5nIF9JTkZPIGFuZCBsZXQga2VybmVsIHNl
dCBhIGZsYWcgdG8gbWFyaw0KPiB0aGUgcmV0dXJuZWQNCj4gPiBpbmZvIGlzIGRldl9pZCtiZGYu
DQo+ID4NCj4gPiBBIGNoZWNrLiBJZiB0aGUgZGV2aWNlIHRoYXQgdGhlIF9JTkZJTyBpcyBpbnZv
a2VkIGlzIG9wZW5lZCB2aWEgY2RldiwgYnV0DQo+IHRoZXJlDQo+ID4gYXJlIGRldmljZXMgaW4g
dGhlIGRldl9zZXQgdGhhdCBhcmUgZ290IHZpYSBWRklPX0dST1VQX0dFVF9ERVZJQ0VfRkQsDQo+
IHNob3VsZA0KPiA+IEkgZmFpbCBpdCBvciBhbGxvdyBpdD8NCj4gDQo+IEl0J3MgYSBuaWNoZSBj
YXNlLCBidXQgSSB0aGluayBpdCBuZWVkcyB0byBiZSBhbGxvd2VkLiANCg0KSSdtIGFsc28gd29u
ZGVyaW5nIGlmIGl0IGlzIGNvbW1vbiBpbiB0aGUgZnV0dXJlLiBBY3R1YWxseSwgYSB1c2VyIHNo
b3VsZCBiZQ0KcHJlZmVycmVkIHRvIGVpdGhlciB1c2UgdGhlIGdyb3VwIG9yIGNkZXYsIGJ1dCBu
b3QgYm90aC4gT3RoZXJ3aXNlLCBpdCBsb29rcw0KdG8gYmUgYmFkIHByb2dyYW1taW5nLjotKQ0K
DQpBbHNvLCBhcyBhbiBlYXJsaWVyIHJlbWFyayBmcm9tIEphc29uLiBJZiB0aGVyZSBhcmUgYWZm
ZWN0ZWQgZGV2aWNlcyB0aGF0IGFyZQ0Kb3BlbmVkIGJ5IG90aGVyIHVzZXJzLCB0aGUgbmV3IF9J
TkZPIHNob3VsZCBmYWlsIHdpdGggLUVQRVJNLiBJIGtub3cgdGhpcw0KcmVtYXJrIHdhcyBmb3Ig
dGhlIG5ldyBfSU5GTyBpb2N0bC4gQnV0IG5vdywgd2UgYXJlIGdvaW5nIHRvIHJldXNlIHRoZQ0K
ZXhpc3RpbmcgX0lORk8sIHNvIEknZCBhbHNvIHdhbnQgdG8gY2hlY2sgaWYgd2Ugc3RpbGwgbmVl
ZCB0aGlzIHBvbGljeT8gSWYgeWVzLA0KdGhlbiBpdCBpcyBhIHByb2JsZW0gdG8gY2hlY2sgdGhl
IG93bmVyIG9mIHRoZSBkZXZpY2VzIHRoYXQgYXJlIG9wZW5lZCBieQ0KdGhlIGdyb3VwIHBhdGgu
DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9aQnNGOTUwbGFNczJsZEZjQG52aWRpYS5j
b20vDQoNCg0KPiBXZSdkIHN0aWxsDQo+IHJlcG9ydCB0aGUgYmRmIGZvciB0aG9zZSBkZXZpY2Vz
LCBidXQgbWFrZSB1c2Ugb2YgdGhlIGludmFsaWQvbnVsbA0KPiBkZXYtaWQuICBJIHRoaW5rIHRo
aXMgZW1wb3dlcnMgdXNlcnNwYWNlIHRoYXQgdGhleSBjb3VsZCBtYWtlIHRoZSBzYW1lDQo+IGNh
bGwgb24gYSBncm91cCBvcGVuZWQgZmQgaWYgbmVjZXNzYXJ5Lg0KDQpGb3IgdGhlIGRldmljZXMg
b3BlbmVkIHZpYSBncm91cCBwYXRoLCBpdCBzaG91bGQgaGF2ZSBhbiBlbnRyeSB0aGF0DQppbmNs
dWRlcyBpbnZhbGlkX2Rldl9pZCtiZGYuIFNvIHVzZXIgY2FuIG1hcCBpdCB0byB0aGUgZGV2aWNl
LiBCdXQNCnRoZXJlIGlzIG5vIGdyb3VwX2lkLCB0aGlzIG1heSBiZSBmaW5lIHNpbmNlIGdyb3Vw
IGlzIGp1c3QgYSBzaG9ydGN1dA0KdG8gZmluZCB0aGUgZGV2aWNlLiBJcyBpdD8NCg0KDQo+IEFu
IGFsdGVybmF0aXZlIHdvdWxkIGJlIHRvDQo+IHJlZGVmaW5lIHRoZSByZXR1cm5lZCBkYXRhIHN0
cnVjdHVyZSBlbnRpcmVseSB3aXRoIGEgZmxhZyBwZXIgZW50cnkNCj4gZGVzY3JpYmluZyB0aGUg
b3V0cHV0LCBidXQgdGhlbiBJIHRoaW5rIHdlIG5lZWQgdG8gaW52ZW50IGEga2VybmVsDQo+IHBv
bGljeSBvZiB3aGljaCBnZXRzIHJlcG9ydGVkLCB3aGljaCBzZWVtcyBvdmVybHkgY29tcGxpY2F0
ZWQgaWYgb3VyDQo+IGdvYWwgaXMgdG8gcGhhc2Ugb3V0IGdyb3VwIHVzYWdlLiAgTWFrZSBzZW5z
ZSwgb3Igd2lsbCB0aGlzIGJpdGUgdXM/DQoNClRoaXMgZG9lcyBzbWVsbCBjb21wbGljYXRlZC4g
8J+YiiBtYXliZSBtaW5pbXVtIGNoYW5nZSBpcyBiZXR0ZXIgYXMNCnRoZSBncm91cCBpcyBnb2lu
ZyB0byBiZSBwaGFzZWQgb3V0Lg0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
