Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7676AB827
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 09:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCFIXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 03:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCFIXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 03:23:33 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EE4A5D0;
        Mon,  6 Mar 2023 00:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678091012; x=1709627012;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bs6pE4hJSGlLoLdO0ionyydJLEbOQpRNyhqE3jVpLjA=;
  b=Dyt0obsR+POe6CckK6+ieGqtsqIvY/7E5Z/qzbDtlJOYP9fqGIV+AxkY
   D5W8MZsQRoOyneONAOUQu7sERmfbIMQr1Zt4TIDxxVagHTWDu23j7u2YA
   kBxAZe4OKjhnHMN8niE33QX0GIEe7eAfzEMuPp5Cwp45Q70o1+GIOwMbV
   LOWNvb/H40JiygrrxvxCmGfSC8NFKyTB44yILp40hhq2/RkSasnkaOsE1
   DSh/Lp/+7ig2x8TME1i1lXKr1wwZAXsXnyThi7q53GbBn2HdCUG/YfScb
   TMG047E3tAdx6lnvQeD5UACtiCOhxyIwaCNq+S9mi5Q1ntzvOk9pLx93E
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="335521073"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="335521073"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 00:23:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="819223289"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="819223289"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 06 Mar 2023 00:23:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 00:23:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 00:23:31 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 00:23:31 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 00:23:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCEUv5R0M7mhnyR+vxwRkG5ROpHQ2RGTjGqJKTcchfKPXhgvcp3nFE8hwWgmEpc8Gp2hKKdjS5gfY1/I2zw7uIZgwTVf+0ra7RgMCKgQhaRhkkdSYBerdNXXVoPZvsOlK2DS8ZE8EMBtQRRfjRd6y+MtTOG29LUG4v/HZCTzJoGQu45YvjLyWAC+dw9jy9dT6gcl8C0Rr9L9wVQP1bLP88J0CwUeDZ3FOaL9LpWxf3HT8tYPWixWV/yvp3mAuF6hAi/SxXzOH1zJSY0PRyDdyu4Apze/rVgpHvql3KsYDu6aIiLCwMlC89cEmzKZeX/xpeVVx69IfmEPpWMkGxtzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs6pE4hJSGlLoLdO0ionyydJLEbOQpRNyhqE3jVpLjA=;
 b=Qt7EIqW3dCwRhTYXDG6syObAjMUSy+8nATZucT23mXBChDOoePRLdw4ViARUpN56wxENKwmh6LVjQbOfLgMe9FDf2mPWHqHh7D/V2OptnDX6qkiq8b8Mi7M6mXWpR1yzdd66xs2K40E4LDSwC+toC1qSg7+PN5PmPo3gs38RN2YgpIwP4XXbM1JyM0Z3uQ9s/8dVqcK09BcVSJnk6Tjrjp1Wrfaukg/BRdjXZIE4ivv3cPJo3ZYMWrKJJc/VTA0ss6J3VLibOc/CXLEbwoTG31Gy5Zeh9uTmWJ5vj+qL26Nml5TzTk534CdJp50S3ibacu5LQKcnY7irO43vACn/KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4714.namprd11.prod.outlook.com (2603:10b6:303:5d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 08:23:29 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 08:23:29 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
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
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbCAAC27AIAAHWOAgAECO4CAALuIAIADATSAgAEjvQCAAAHWIA==
Date:   Mon, 6 Mar 2023 08:23:28 +0000
Message-ID: <BN9PR11MB527691C6CEA8A1E120F105D38CB69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
        <20230227111135.61728-10-yi.l.liu@intel.com>
        <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZACX+Np/IY7ygqL5@nvidia.com>
        <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52768A29E00D8FDCB9E6B4EB8CB69@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52768A29E00D8FDCB9E6B4EB8CB69@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4714:EE_
x-ms-office365-filtering-correlation-id: 5cc9bc19-faac-43bf-dc47-08db1e1c1092
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pZiN6zgm+LKc56Qjin3UqMsqDZ7R2zteIeMjPVxUBSZYkuHoxolngxkSjin95yCEBqV8wMbjz6bEMPAqPnFIS658o8PKsqn5SaqwsuG54Ym/+BpI35GwKAMqynO+kEghxmh6X6bCOIhZdHQCT7F7SMjjyklgjTx5c8AY+Vcz8x5XNONTwt6m4fcrsgFyG35Yzu+efTQTGyHMKra3aCKpSDXG543OYZRn24smmLctjdfmiPxMfgehGWRdj2Q5ETowicDoQxkNGcPawXqYTddCkC0vrUA3pancKuFOdJsyd6dUBVVF1HM8CcUoX7GYybPwGDkR9migAukIvoB6KRuSCaDTfF4pCBhdw8d0E4AaM1WAywe7zVMz3o2SyXn2siKd0WycRlHUl0LHiEaGuTQIRoCVlha0X7lQbdhdKoTjfOG9wXQB8dTOK7xpuL3lScOwz7bpgrKYsvTzigsfhQRzMFZD+Tp7gca1k/pjck4BJ+DBLhEHZIq9FFMBd58Jy1R7xpyXw8cz7iPqFAJlmh7VQ7YDm3aK0Bnt5PtXliuKk7swJ7mst/sVCNeQRi6JlZsNOaYTrp/9KVsdUrcwlPVgBGEnoYZkJpQWomv0FNA6EEclKDGaFK7Jt9/4iZ27unVMOeo/niyumm7R54XCV/4HqPUb7p5+/GJnS/PE3Gz/YmCAYRSNUy+RoJ3tZZf7ZgtVOSFAY98KD7FZ/eT5f06/PA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199018)(52536014)(7416002)(5660300002)(8936002)(76116006)(66476007)(41300700001)(66446008)(66946007)(66556008)(2906002)(8676002)(64756008)(4326008)(54906003)(110136005)(316002)(478600001)(7696005)(71200400001)(26005)(6506007)(186003)(55016003)(122000001)(33656002)(86362001)(82960400001)(83380400001)(38070700005)(38100700002)(2940100002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2t1bnNNMG8wN2czN2ljRlpaeW5uaFJBaVI5d0dEUjJSakVNOHVwblJNalRD?=
 =?utf-8?B?TkhUNDV5RnI1WlJ0eWh3STMxV01FMUpsdW9COXFmMXZFSGJ6RmNiR3FPQ3Uz?=
 =?utf-8?B?Q0lCUmlIdjNkbVFYeHBGeGVpOHNoMU5aM2VjTXZ4cWJXWWNXNUcrU2RDSzBT?=
 =?utf-8?B?WHlPeU5YOW5YTlFkaFNYNjhEY2VCWXVxNEFSSTN4UUZvbWhQbDhpMVZlc2Uv?=
 =?utf-8?B?WUluSWJOS0JIRFZZWTdzSE5IMEJBaWZvMUZIeE83VDh6RVB1L3g3dzAxcmJk?=
 =?utf-8?B?blBBcUUveG9HVm1UbCtaU2sxNWU0d0VrWE5DNThkMjNZdmFkOEFRTEpPdnlF?=
 =?utf-8?B?ZTZ0bmhlemp4aUxwZHNJRFhBcnV0cDBKWWJUbTZGbVBzVXdMNDlzZEdtaWZS?=
 =?utf-8?B?VXNGbzd3N0doQWw1anV0bkZmejk5cThEVFArUWlXQWxKSHNLbWJTT1FVSDVY?=
 =?utf-8?B?bU9QdEVxTHVDMGZjYkt5NEFVNjJKTjNzbVFqODVGOWMxbjdaTkU3UkhYK2gz?=
 =?utf-8?B?TWpTUnFNc3JmVmw0dXRPUk1Cb2dFK3dlSXJmTG1uRWlDNjdvTWl3QlphUURo?=
 =?utf-8?B?cExGZTVJZzd0VGVHMWNwdmt0bW1uck5IREkyTHZKWHM2U21aTU0vMGY4NDVS?=
 =?utf-8?B?L0ZIakdCT0ZHelBmdnpWSm9FYkt6V1owcWhuS0xibFNUd3BrUm55VXV2L1ZF?=
 =?utf-8?B?c2dSK2lpSnlzN21qbmF2a3VvM0JCSFA0L0xCUkkzVDM2ZXRTcmRicjhHTGJp?=
 =?utf-8?B?bGdFNmtyZ1Qxb1daQklURDFySmhPcWJjVXI1TW1TK1A3MW96VXVURDBGTzF6?=
 =?utf-8?B?czB4RjgzK3owbWVpZDQ2WHFvQW85Q0JURjlIUFBOVkE5dGtTWW5tQ01xMWRG?=
 =?utf-8?B?VDBBS29BUCs3RC82eVdHRml2YWFUUUxLajlHa01lSXRnNnQxZkhaejJJbll1?=
 =?utf-8?B?TTVaT0VxL0h4U3diZG8vZDl3RmgraVVrUVh6bXJ2elZ0YjBsYlRPVU9yM0Yy?=
 =?utf-8?B?LzIxaitzZUFOVzBwdkdiS3lEWkIwRjFBUEFoRUlSSzhDdzhYY3BwOTErY3Iw?=
 =?utf-8?B?aXprcG5vZmxhKzAwdFRrd2RJY3I5WjZhekZQZGFtT1VGVW9OZm1xUllEd3ds?=
 =?utf-8?B?a01WVXNFck9nQ3hLR1pzeDZSeC9hUlRhb2JEY2V6dlUrSnFDU0YvYjM1Z2tN?=
 =?utf-8?B?YXB3QlFWcW10cUticUllVTlHeHVRR3Uxd2ZXSWsydWN0V0tSaTlvS3N1OTky?=
 =?utf-8?B?bUJtUEs1VVdDSzczN1NMYVVnK3hXQS9GcCtxYVc1b0R2cHlyN05TVGU5YkI5?=
 =?utf-8?B?RGRoWjYycXZ0bVpwZ25ydWNjWkEzaXhpckF2Ulo4VG04VEcwRWVpL0ZBU1lu?=
 =?utf-8?B?M1dCeW9TS1ZvMlZBNzU3eUQ2OGpQUVZNaEtvRHdMZTFFMnlJL0d3T01HRlFy?=
 =?utf-8?B?YXp3QXJ2WUJjbmRTSW5hZExyYmRMWmE2Z3dENDQ2aWF3c2VRcStDRW80a0hF?=
 =?utf-8?B?ZWlmYzk5Nzh5Vlk2ZlNQZ3FBUEM0K2RpRGVDdTZodm9JMXVXdzRQYVJaVmJW?=
 =?utf-8?B?aERmbis2ajM3YXoxM2tHb3BpN3ExR0dVcDhqKys3WXkvcjdhQmt2K3A0YUZJ?=
 =?utf-8?B?OVFxY0VRNnBLbWY4MEpzVUM3bTBIaXQrcmwyWHArQXVBZEVCNlo5SmE4UnlB?=
 =?utf-8?B?KzRack80VlhkaEVoanlvQzRYTmg3cDN4NUNtb0luMjAxM1lOYUtraHNnZk03?=
 =?utf-8?B?NDVIRGFjVktkcTE5WkpVRW1SZ0RRVnMxUTNRZUFEdWo2K2RDd2lYTXViYWxS?=
 =?utf-8?B?QlVzZXQ4MmNZandlakhrOSt3S1lTU2cwbXpLNDgyNW5iZ05MRHhORlFyc25j?=
 =?utf-8?B?SDROVWwvL0UybFM3NlJnV1J0RXMyeVZqSENIa01SbFZwUWJ2bzB1ZTQycEgr?=
 =?utf-8?B?VklOdEd2eVFBbVl6L0JBVWtmRWlwMTNYbFNIeW1QSTB4d0VBZWdReEw4Uk5r?=
 =?utf-8?B?WWNscktIeG5qTGIyR2dGem4rK3FNN2xsa2w0aFppL1JZU0R5cEplaXkzaCtq?=
 =?utf-8?B?LytOZGtneFZvblNWYUhYV3dBaHVHcHR6YTd2RTZhUkh6eStjU0tJQnU0bkI5?=
 =?utf-8?Q?CiiE77aJ5wabqxGmDylzfA+0a?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc9bc19-faac-43bf-dc47-08db1e1c1092
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 08:23:28.8409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yMCxC6Knp5ItrQcMUaVm0SUdoKBgCbfjIQf1TK6XroMzP43+nRhtWyEkRerFbQR177KM9PgKl1O020Ump10tzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4714
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgTWFyY2ggNiwgMjAyMyA0OjE3IFBNDQo+IA0KPiA+IEZyb206IExpdSwgWWkgTCA8eWkubC5s
aXVAaW50ZWwuY29tPg0KPiA+IFNlbnQ6IFN1bmRheSwgTWFyY2ggNSwgMjAyMyAxMDo0OSBQTQ0K
PiA+DQo+ID4NCj4gPiBIb3cgYWJvdXQgZmFsbGluZyBiYWNrIHRvIHByaW9yIHNvbHV0aW9uLiBB
bGxvdyB1c2Vyc3BhY2UgdG8gcGFzcyBhIHNldA0KPiA+IG9mIGRldmljZSBmZCwgYW5kIHRoZSBr
ZXJuZWwganVzdCBjaGVja3MgdGhlIG9wZW5lZCBkZXZpY2VzIGluIHRoZSBkZXZfc2V0LA0KPiA+
IGFsbCB0aGUgb3BlbmVkIGRldmljZXMgc2hvdWxkIGJlIGluY2x1ZGVkIGluIHRoZSBkZXZpY2Ug
ZmQgc2V0LiBJZiBub3QgYWxsDQo+ID4gb2YgdGhlbSBhcmUgaW5jbHVkZWQsIGZhaWwgaXQuDQo+
ID4NCj4gDQo+IGxvb2tzIHRoaXMgaXMgYSBjbGVhbmVyIGFwcHJvYWNoLg0KPiANCj4gaWYgYSBk
ZXZpY2UgaXMgbm90IG9wZW5lZCB3ZSBrbm93IGl0J3Mgc2FmZSB0byByZXNldC4NCj4gDQo+IElm
IGEgZGV2aWNlIGlzIG9wZW5lZCB0aGVuIGl0IG11c3QgYmUgb3BlbmVkIGJ5IHRoZSBjYWxsaW5n
IHByb2Nlc3MgdG8gYmUNCj4gcmVzZXQuDQo+IA0KPiBmcm9tIHRoaXMgYW5nbGUgd2UgZG9uJ3Qg
bmVlZCB0byBib3RoZXIgd2l0aCBub2lvbW11IHZzLiBpb21tdWZkDQo+IHdoZW4gaW9tbXVmZCBp
cyBub3QgYWx3YXlzIGF2YWlsYWJsZS4NCg0KYnR3IHRoZXJlIGlzIG9uZSB0aGluZyB0byBiZSBm
aXhlZCBpbiB5b3VyIG5leHQgdmVyc2lvbi4NCg0Kbm9pb21tdSBzaG91bGRuJ3QgYmUgZW5hYmxl
ZCBvbiBhIGRldmljZSB3aGljaCBhbHdheXMgaGFzIGEgaW9tbXUgZ3JvdXAuDQoNCldlIG5lZWQg
YSBjaGVjayBvbiBpb21tdV9ncm91cCBpbiBmb2xsb3dpbmcgcGxhY2U6DQoNCisJLyogaW9tbXVm
ZCA8IDAgbWVhbnMgbm9pb21tdSBtb2RlICovDQorCWlmIChiaW5kLmlvbW11ZmQgPCAwKSB7DQor
CQlpZiAoIWNhcGFibGUoQ0FQX1NZU19SQVdJTykpIHsNCisJCQlyZXQgPSAtRVBFUk07DQorCQkJ
Z290byBvdXRfdW5sb2NrOw0KKwkJfQ0KKwkJZGYtPm5vaW9tbXUgPSB0cnVlOw0KDQo=
