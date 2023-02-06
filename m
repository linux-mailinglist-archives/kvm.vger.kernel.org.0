Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D8C68B4DA
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 05:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBFEbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Feb 2023 23:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjBFEbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Feb 2023 23:31:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D9D199F2
        for <kvm@vger.kernel.org>; Sun,  5 Feb 2023 20:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675657857; x=1707193857;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BP4QF7uQbjdbzIcR/hFO7CbFhdsLXWUqthV/Sr24jFs=;
  b=iDfQZb1u8uM19/z6q8mMcBrzqW5sUn0uh9yRXxApln/4AfFXHBi4Z9KI
   X/iOxpdwndEW7E5n1/20lriMjx1PzMVTd6kysibqwD7J3Obg6rBGzXfyA
   v2vsg0+2YCNpXeDRPD0nenDEjE4D0MY3ceMlNlAB1A9l8UqbYG6wVQB2P
   Upeq1WMujIAWx1vocSzBzEH6Auv9szYfYUkBuAe6uUJ1BpRpbX4z5ge7J
   qEATn8ZJuV4/X8Xg19+zy2o69FxTFnCK1cXouAt+wbhVxH/Hc9F1atDte
   iPZ1LGkIHB6pHkyU5YWYDx9YVfrbcNkcrQO88EpVRmQErJsEM5oMhWQD/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="326819158"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="326819158"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 20:30:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="840233391"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="840233391"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 05 Feb 2023 20:30:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 5 Feb 2023 20:30:56 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 5 Feb 2023 20:30:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 5 Feb 2023 20:30:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 5 Feb 2023 20:30:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmLZkr1DLpKAj8DWG+fi5Pz1y7KPRBHaom0f4OxMQJM3AJGw2bOi4QiuyzYkoqN7AWOgBj9SVyAzR6Q12S4YtLxDQUTNGZKeDeWAGqnSIqEXgoH3Hqwvj6RlhXgoKRjmWLEVCMHGSZ3vVun4DNX06MxWNRqMcin62+p7E+skAF4pgpJnyXO3Y7rcjQLZ1NACqhPjo5II4VklYLTbRrcNscfmgpv3fiQ9jMmOZ2AXlhhD/lqmH9qfBrVG/UMh80xu+A2SHOuaThEBZdTrSSDAv9hduNewp3hr04oFRltkPDZEFmd9lRCYcMltpXVAXf0j4WAfH+xqwZgwZvkIf1ddQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BP4QF7uQbjdbzIcR/hFO7CbFhdsLXWUqthV/Sr24jFs=;
 b=XhFIyJfQ+mEoHo7dLA9nKi2guCiXtqtJnbpM3Ylf9dQcu+LGNPKGCS5vo8c0fWEPioI9979B3TdO6GfIRDHDF+Q3ArtMvKjwRv/Xj0dm8OPyyk8oepFZJhMXhWL9t5a7T4d4J2NtUGUc0MxIciMC187FzPWt/wUeoiwJam78w4tAsgeSMPf4KZbF4cF3mEMJZJQECXOKfIHJ7d4a0ytAC6vBrx51Ak6fDU9H9sdev1gFFEpq/ISkWhGoLsSyhYYaQPRm7gYA1t/jEz5Az2PlDOmal3hUupdh8318vrGfDjOQcoRtXnrZpMoqeWCya8vM5U/UISCpQ5oryxoqAoJiZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB5972.namprd11.prod.outlook.com (2603:10b6:8:5f::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32; Mon, 6 Feb 2023 04:30:53 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 04:30:53 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6mbRKAgBCCdhCABEMGcIACZfGAgAPY7eA=
Date:   Mon, 6 Feb 2023 04:30:53 +0000
Message-ID: <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
In-Reply-To: <Y91HQUFrY5jbwoHF@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB5972:EE_
x-ms-office365-filtering-correlation-id: fd85d75b-ccc0-4d4f-72b3-08db07faeecd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YcZXrSMdBKkjjSZ+mTaDrbqiGVn32yC3oQb5y6t3Ay/8MnFiRvK/sC4GOrE5ChobMr7H13mbRTh0IR9N4dkhZ6+/jkC/3SQtPHclH3kIyjCpyUZgjyRK9J7mlhAeXFQDM3FLDVl4rgst39fWUV0tFqaqocfOtOb0SDnob3R38YbuTKfiQQGzlewOMi8x4i9T9yEAmuvc0P0P97HEi4GU5/iC2eg1OACr2UaW9ZlAnBM1Sm1+o5FBQWoJOLbLEd/sZqMS15jVL/PcXbTSRIoLeW1hqSr/qWmIzbPnVXmKPEqIwNijYmD1jO3u3qk2XExa4oXTghJQQT7984XnzZCnx7R6fBzT6or8K9X1g7/KeYvFmhXKNEmdV2YfWKfDje+6KsRdIp1QQalWXAxZ4lheiun0/jSsYgwffG4LmbQQaUCadthHxNMtqRFW42hfkJDonG5SlXSJysCyXPqEP0YD9zeytvpir3sJb/tADtQ+TSa2moAcOcdq1WmSHRSyrZCo/NtGMfpM6f4yzKhkVZZQUpUs+4CD2byT8LLBX1VBwgeZHmS23Pb1mssZGr81TM0AO9YP9mUWFFAH5Ym0XgqK05jM1+w2vkIrOGvIUYQOwqIx0sLWm44yNAfJx15aKEdGNTRvZEEAT7pdKO6pZMuSmKU0NpwanvhAGko8KI2PI27VtoFOo9chcI4iRMXzZCu7/8kfIYxo4QXdUCGEDlSmVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(346002)(366004)(396003)(451199018)(8936002)(2906002)(41300700001)(33656002)(478600001)(52536014)(71200400001)(7696005)(86362001)(54906003)(38070700005)(316002)(55016003)(38100700002)(66446008)(64756008)(122000001)(66556008)(66476007)(6916009)(6506007)(66946007)(4744005)(83380400001)(186003)(76116006)(9686003)(26005)(4326008)(5660300002)(7416002)(8676002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?c4fIyyJL2vgN09RjotIamHLe1tYqNQcOAH7+86w6vVRM1qtuIEMyBaUoAb2u?=
 =?us-ascii?Q?DCTw8bfnfg9rlGaJl/FUI0BYR/20cvoU/iQRWJjOpW5fOfSyHbBYBLm1Mbxa?=
 =?us-ascii?Q?B7s3iHFh1kgpMHlqpNw0tl+o04zXoO7ml0iQK+6lNVd+CBGR/5+3sJVLx0fP?=
 =?us-ascii?Q?yEcz4g+1X/MO17ys5I6NYiQgQtTd2D/CZjttMd4M74PtlrxaGLjntGG/o/Dg?=
 =?us-ascii?Q?3KmFBBqiWw8NTZObq+wQBqfjgb0mKfU2QuRnp5RQgpyFLgKHcnxuKnUXsOYO?=
 =?us-ascii?Q?fdcvt6YlYg/OGiS9+bRJLwZRbzGKb7SzhGOMiKATgCBNEaPrXw1xtBDnyOXm?=
 =?us-ascii?Q?oBBPwXFAWzoBiJRa0tUiX40DPLG6sffUBXCoD+ess+dWtrdAN2o25KcZScVP?=
 =?us-ascii?Q?t9v3qB1xsd1DgnYz/oFBssT75IYxSYtdLw61iZIKrI1yH9EuRiRPHB8Lci5+?=
 =?us-ascii?Q?CIPLNzuLCTxwEg58YgaZ/w8Qn75FJXFoq4ZWWGj0l3Hlag4GjqtdteKGUBHX?=
 =?us-ascii?Q?vs56A23iH7rTtqIXyDzq4+oORnYE5vrv1T//SdBo6J4aVvQc48Fa6JY/JIr5?=
 =?us-ascii?Q?MLMKaDsW/nKi2HFi8eP2fmQFJ4CjmmsFzu99H/r3gLUtL/N8GHoKp0pi6Tfm?=
 =?us-ascii?Q?KTrAOOQQCryzu6bmNmIyWNsO9KVjpLNqZFzE8YSSHkNWjWcS//m34h0LNjQX?=
 =?us-ascii?Q?kq0L7AVxYCWXFjf6qpmSznaqKd4P50ewsmVVkRcvHVfwCm/SrTHvfsPlum9z?=
 =?us-ascii?Q?urK25gL8l6tTrm8JGVV2gKYrr4o1i8CrIbEgPJo5XdJea9uDY6BA0DVa/WWS?=
 =?us-ascii?Q?E+41TljzT7inv0NHoGnCXzMmRvizvLgKOAt0iP3LhHObJDzboL7ZsnH2eD6U?=
 =?us-ascii?Q?R7RB8orIwwd1yfTvOvrVGEATNJhh1Ccjo7fN4UZINwiqQc8WEwGmDCB4PDYc?=
 =?us-ascii?Q?0TkrmTBAReDNajMJBAdNv2JeeO9WaRTD55YpSjZmxxgCGiHg0FuCl6gvK4Z5?=
 =?us-ascii?Q?tMPZUTglzzpk2AQkF/wyi+WoHh6vMfGw03Nd1EXlpe0W08r6uKA/7Jm+BoFS?=
 =?us-ascii?Q?13sEuMV3ppKlifnyE+el94h1KLXQrz9nUSEp9mhg3cz1HDX7az/+niBPhQRB?=
 =?us-ascii?Q?8e0pjqOlXoDUPYy17bSpBdew+qtwNeG1GKSQkXEFcYXx70erRS1bldnZPG79?=
 =?us-ascii?Q?xxdH3jD8vR5z+aioixdgh9e84U2dE7r1CGBhOmtYM/DIAZlraxSP9gfZTbfD?=
 =?us-ascii?Q?tojM9krc+xFLjOgxvgieykFKo6VMF7q7RABWGKlP+nzmSM68MBiusTYsqCkQ?=
 =?us-ascii?Q?dGTDVhiQOgNGuowgS8AVe7lYLj//twuybnXcth3SWG/U/SuAvdzWAqtMRCpI?=
 =?us-ascii?Q?6695DqripTWR3esK3sMZjPQnQRFaiq1BOM/1fSuWZjOYQrcpbgWnW+XZnVvX?=
 =?us-ascii?Q?/lwDvWhIwAfMcKYq0hpyyiAR40DyAt0zQnZKcmSRdqj9H20aVnJ/vJYkX0NW?=
 =?us-ascii?Q?BAHWqCUCquoMniH+KnLX17r0uw0dAmb8nsUuVrRTv7u+JKOoqw2IlTNa6Qx7?=
 =?us-ascii?Q?1A6DpWclJSd2EwWwrFuvLijb7U0maYmE1HY07VCd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd85d75b-ccc0-4d4f-72b3-08db07faeecd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 04:30:53.2248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YQ8NmgTJD4kKIABeeta5MmM5FfAMmMKQelUY3RpYbXGLAr/fMBR28qCexzdfkXDhg77jFn/6FHbmkZHDf+Jtmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5972
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, February 4, 2023 1:41 AM
>=20
> On Thu, Feb 02, 2023 at 05:34:15AM +0000, Liu, Yi L wrote:
>=20
> > This seems to be ok. The group path will attach the group to an auto-
> allocated
> > iommu_domain, while the cdev path actually waits for userspace to
> > attach it to an IOAS. Userspace should take care of it. It should ensur=
e
> > the devices in the same group should be attached to the same domain.
>=20
> Aren't there problems when someone closes the group or device FD while
> the other one is still open though?

Guess no. userspace can only open devices from the same group by both
group path and cdev path when the group path is iommufd compat mode
and uses the same iommufd as cdev path. This means the attach API are
the same in the two paths. I think iommufd attach API is able to manage
one device is closed while other devices are still attached.

Regards,
Yi Liu
