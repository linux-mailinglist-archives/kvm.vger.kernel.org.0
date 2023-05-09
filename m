Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59876FC1CC
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 10:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjEIIhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 04:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjEIIg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 04:36:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74E94C2F;
        Tue,  9 May 2023 01:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683621416; x=1715157416;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=VGUigynqRW3vmyM7d6/kO5gpqJBDzEx706ExPYL3//E=;
  b=AdvL3yDRyH+6K72pbUhofVjj505ZnWsIkGHzABk8PPPa9iXbd58hluiY
   MGsKq2wMl1SHCKsAMaRTG10rDpZuz1Ru2jJa9J5V5w9mv37fRacAvZy2G
   Dy/sDBuPR+Gil7GblJfiW4z3ktVR1MxZWfGhrRmEi+P4ox3Qa4wmqIP4z
   kdTHbW61teYkuCrRZ5Y/TqDJJHxuzahf8naTtg1gOfYKcycz8gMvaQHRT
   Dzk8UJBST6417O3kycXLk2tayaAt/ppBVd/v+DoGvZyrRUGgs17cN6mpS
   +5txSQlaHfhKc0GasnpVkE8um1l3jqe1+xCmrZInnmsJFDNZb698YDf0G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="348670094"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="348670094"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 01:35:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="649195033"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="649195033"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 09 May 2023 01:35:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 01:35:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 01:35:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 01:35:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 01:35:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8FOf00ApgxvrD2AqX+j0qtZfhqbYdzo9G0/o3dSAV/6hxeQwKD5yeXwSJ70ztH5sPkQE8vZIUAKCBYHNqKpLVZSzH8rU+duQu4VwTESC/vMzhvj8QtGF7GehyDpyjckcwM4cxBYyFt7O/S004dy1aYKAd5bTp97BsR20AnrQiflGnofGHkZA6kXKiIogP9kc5aUiB80S5TLHh+NH6WWkabkGYP53xGRVgNCOJegTiprbHiaL1fH7V44CDC5RJFOT2rE+YX/CZcDhXBgIIaTL+pSUN8H89K3zgvadwbJq+FcXoSAkwnDQ/qf/4q53zrFWEjk/iuT1B52UBUMUnHADw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTW4Iy0HqJeufF3fgsTHkTPdPPe94+5GWhIaTPjIJBI=;
 b=hrYVl3Jji53j7Cq0+vPeQPszcmrBb2GuocGAtw1qiZRRoliUXLuR+1v3ESsbV2kQHs93CLApLh37Xr112ZUvF737RYBLYnpM2R8utY0SPn9f3zOH5nKDHdZkKypv26I3RzBZhwwxu6BmKbzQj+dgdhagVm9hs68h7W9eMjK/2rbZSCl45ji5YPd4UrwXBuWwZYJ+bdt3JEZEDwOJbwOA0BkAVMKIzz3plc53rceh1++aVAs9RoUDX/DFOPutwEYKD/ns4IqX+ZObZLcXRe7ruSzvW5eSp2jOaevnsNez8CsP32Eb65/dcO/WSuYj+EqwNkdY9f434XLa28lvPAFdCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4654.namprd11.prod.outlook.com (2603:10b6:806:98::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 08:34:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 08:34:53 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5A==
Date:   Tue, 9 May 2023 08:34:53 +0000
Message-ID: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4654:EE_
x-ms-office365-filtering-correlation-id: 1a7ba2b1-c60f-40d1-935a-08db5068433b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q5bXL8sLnxUQFEUMc6dtfmV0C3n0OrhSTrbT/3v78pYvZl3rlt9CljH1laW0KvxMGPPFSyjVp0cOo9WF8s3M2/mZIBc/idRqrGKvfYvWNXbOxa9Dtg7zWLUeRXgMMF7cdcqg+vOJJKY0TOZGR2oEHfClQmDAxYVc088H2s+4hyFJ5K2xcF6HdSTdzVtq4oiT/b8w5gWAqLcyiy9QyGm00oCnSFBWb1ZED1EauhJ/4YxT82+Qynf3VR59ShOEyWOli21EDPgcXP3AwCp0UcsF2A6zCVQTjOKKoWX2e6viAKm9UyxnzkPx76AMDVOzU9O4v1Sf8Tkbbct/aOV9FH5Yr38+V6pCUZh34hcYj8fjKWwFLuourby1F1EiSpjTlY2aKSmZ7rw8wPtD7OGXH2ueL1QRc7ma2oHapbmjLRFYSXkIz0eJO19+aS+JVoLxhhDRkjR0BxybXfet2v+E6rnEXaLpxzg8el8PvymXojXvMoHYESgwWXmRRmf2WL++NIsWP+B8yRw/sWhfV5mzupsX/0bTZfDmslS8kBNhCcs49jAo8mjYoNitngTrEAQhlK7OXtLj4tejLF3IfFMmitHYcNSp1L1aCAMQesCWdBRvvEeR+pqMWDGLykKVjSjIJePu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(33656002)(83380400001)(3480700007)(478600001)(7696005)(110136005)(71200400001)(54906003)(6506007)(186003)(107886003)(9686003)(4744005)(2906002)(66476007)(52536014)(38100700002)(82960400001)(66446008)(76116006)(66556008)(66946007)(122000001)(64756008)(41300700001)(4326008)(8936002)(55016003)(86362001)(38070700005)(316002)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Sz6nw5F3wM3iwj9FOOkxblPPR0T91ND0oM1yBHRDZ8iuNmhoaWmyf/SXoqTY?=
 =?us-ascii?Q?l+DJjaMxWtAgXAfO7D861vauOYwwxbJ2JHVr2oeXJecrwe1jGrjCkoQrH9Lm?=
 =?us-ascii?Q?eh7LTERka3j5tCYNqeg6s/pKvONAtZyQNnLqrbWUWvUZYdqWsvKf61dB2WAY?=
 =?us-ascii?Q?XcbDxY3o/y6limvUqYbj1UfE1Vl6CvvH7o8Tt3fCKOhiWNnB71R0jJ6h8iHz?=
 =?us-ascii?Q?KIU8UCgXFi22mlQWX+y5+HJc6n/QseVum8RIqmlx18BPjm8TKCBF0nCv7m5K?=
 =?us-ascii?Q?S+YcmvOSes7VVyD94oH1e+Ouj9fZn+vwXQjPkBD6veeuHGjnmMbsBxw1jo1c?=
 =?us-ascii?Q?sW5aSOzZ8xjRFZgcGwY1OZIgXvKCV3bbZKRu9JPG47KoZuOzzpTuJKmBkZ3a?=
 =?us-ascii?Q?tdkkXTi4epkLhLzsuQW8KcuRQ3BY/Gn693P0LAeFrdWclXnd7tg4ywtOEsVO?=
 =?us-ascii?Q?r4GNM6exVxBa2VskbMVZESoICc39f+8ExeOXY+mzRR1Ntkj6atGz4lNwsVVz?=
 =?us-ascii?Q?OkoFG14g7sWNn5NQSjhU3Du43kxTSQumxhiMrqlcoDISqFd9sDtYyDz5JODt?=
 =?us-ascii?Q?BNtrD+efW/5KMChprr150+2ozY8qgiyb38nai/TB3WhaW/Pc+7xbsE456tkW?=
 =?us-ascii?Q?89Cjq3f4geWE0RjXOLmhQbsQ0KkiEe0S3dszBNa5l8FD/sDWV4fjDYmP0dUk?=
 =?us-ascii?Q?oFkgUJhJQI6OQQZ11+ERNJ8R3myQbiRHgW+1uAGgrcEjOTxBv7jyfTkfoflL?=
 =?us-ascii?Q?lBaIcIK01NfWIe7Kitj8ltSAWmGnPJlI3gNVBkWB6NQq0kmay4PpUi68+miS?=
 =?us-ascii?Q?yslpBl5NGHO+JNEDjZ7CqAFdp24MEMw2lxmLlNfM79WGD+7gbUjNJFOlVls+?=
 =?us-ascii?Q?XoH8kCXaW+hun/Msc6svYbCStipMrmBPU91HJ42hP7bpg71PaVqGhXvm6wCe?=
 =?us-ascii?Q?LP79e3Rve3IF7BvZr7lfNQNml16hRWcrban7pSvz7quxqg+bRybX6uJV8On6?=
 =?us-ascii?Q?d/ssFmhccgdJuV5hS4dC+odikKQUz67s1HxrAPP+nbC2d55H9E20Ew6ulILn?=
 =?us-ascii?Q?xLVXA23ucWG5LHQlCs7nHK4iqJsJya8RCZLb2rJjT0vxEb8VZ0r9923MoqYq?=
 =?us-ascii?Q?Q2EjaozaUhThPPRWzMfJj5cxLtnODYfbsbIH4jplmD7qNRYSC+/WdT4lRPN/?=
 =?us-ascii?Q?h0JwuwF9J+0IM2XR20kzjmotXTjCbuOWmx/Pr5/G7KYKoyLIf5PwaIxNmZ/X?=
 =?us-ascii?Q?uM4Y+eSYq/onjkDsMDozdcCFdxWpDl+LAofRL8/M52kfuO+Jv+SDDhLJB6sv?=
 =?us-ascii?Q?ugYMJ94KfGdEfgimdCP+AcStiypcEYa9bEvfceGaKA9KiH9FlYDZfkqlKUZf?=
 =?us-ascii?Q?Ez1W3CVW4aOZEiweeRt1rXM8lTP65FZ3qHOA6/sews4nSkGOXpIS9xHHMe1j?=
 =?us-ascii?Q?MLHJ/2oQaTmrHovNJombZafDAoq5Zy5uGMPyz/+/EMbQuJrk2AUpHoYJE2aw?=
 =?us-ascii?Q?8DhDTQHDnq/x1QSc56ewy5Ddrmtb54o0urFKFjOgPOKmPPwKeR5z30OP8g?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7ba2b1-c60f-40d1-935a-08db5068433b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 08:34:53.7823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RMHFb8ZQBDyRaD8X3MjhFQriaM/PIhvgoggnn6LfLxGQR4vGqfNqmWUUcSyKnUjKXSLnvjbwU2Um7hW9I3WcMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4654
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

According to PCIe spec (7.8.9 PASID Extended Capability Structure):

  The PASID configuration of the single non-VF Function representing
  the device is also used by all VFs in the device. A PF is permitted
  to implement the PASID capability, but VFs must not implement it.

To enable PASID on VF then one open is where to locate the PASID
capability in VF's vconfig space. vfio-pci doesn't know which offset
may contain VF specific config registers. Finding such offset must
come from a device specific knowledge.

iirc we haven't closed this open in previous discussion. It's probably
right time to revisit it and agree on a solution now.

Three options on the table:

1) Use vfio-pci variant driver. Easy to support especially when the VF
   also plans to support live migration. is it overburdened otherwise?

2) Have vfio-pci maintain a table tracking hard-coded offset per
   vendor/device ID.

3) Extend PCI core to allow PF driver specifying the offset for VF

Which one is cleanest in your view?

Thanks
Kevin
