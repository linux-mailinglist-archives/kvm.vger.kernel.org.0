Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66A968CDA4
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 04:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjBGDwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 22:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBGDwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 22:52:33 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144562BEF1;
        Mon,  6 Feb 2023 19:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675741952; x=1707277952;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4fmLtn3LuN8wCUktN2uR2GfrXyxdS1iznudQ//vdHDE=;
  b=U04AsgSDSlCnQEjf5qc3rTGTl1N+gauptIbTdAyoCYkmahjonAf9rKXZ
   BmPvdwwNTmZlbualzC5W/amUkOgyKp/dDCP5gRPudQ0J2dKBvJSxFozVr
   azNDGYnJ3TqcySZo98/DRvxDzZVg+Lj6fy9ToOtBKYIqxOuJbocwmlmB4
   7HK4GZ4+RGHEWa34Q94yGNg6kMDeAm48Sgpg7eoHJD8rG5mnuFVxS9uJI
   7X0CBKUDQeUGgdRinaXFvtQb/UK6H0nK+iB+J/N5oNLvvy70813eIDOxy
   ZCQiDlAHajpEWTfTQiEdWImncjk8GL/PF+zU5Te0CcLdfBRJhIfpU9b6Y
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="331530778"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331530778"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 19:52:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="912175296"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="912175296"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2023 19:52:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 19:52:29 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 19:52:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 19:52:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 19:52:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSn7ZL5cyrvfTPnma34X43IK9h7+rXXp2WZRWDjPO4qWm90LQmFqHVgAeYlfaUvZJs84e4dylx/q2EZdd4uS4+E5IBP485IUxirEvbchaUIhiPDruX7lfwQAVeb/ZLF+6tL5bMl7mGtRqk1MkY0ShlD85MVwiYUDgptKTAOSaU2tklbH2jdVZYJHD1HkoNIWt6mh1MOv6VcFkJdfRu08jq67BsvJ5xMnqBnRLbXwQeM8ebY0fAojDiDpx7GfEjxbaMOcLrMQQDlmTXBUA0mnVvY7bIacnNzNIVU8MbJqDm5lybUcWsFglZD7ANw7k3/Gbkf0jF0XPTTZvlVXEgqDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fmLtn3LuN8wCUktN2uR2GfrXyxdS1iznudQ//vdHDE=;
 b=JTQ8grjaslRBQin/BbjT+LFsTA2bertCPkuGh8PRz0LKrVe1uPg6NL+613krGegz65cRKKRUNjMMNpsTJ01/Z6lVuBul9DvOmzOy6aGLFBvRU89F5/CWKYjOSbZEq252Oh+FbM9qS22QgZ+Oen5zxB1DItdaIqt6qEzFkd51yGUrVXqgDsY/srw6rsSIbk4GCjwWCnIuXHEPE801I5gRxp8xbJm0yUSa7mg6BBGjeRooAR7Kh6aefsYUUmAuTz+XyUk0pVVuFz7GVywJ09J3jtvR7OZTOWnVEfblAw/XjhK83u8a/CHb9yBKaRFzlqi0sT22+W2Olbd412Z+nH+ecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5176.namprd11.prod.outlook.com (2603:10b6:510:3f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 03:52:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 03:52:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 07/14] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v2 07/14] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZOgo/RJPtWsqmDkunQHE1j0WQCq7C2hUg
Date:   Tue, 7 Feb 2023 03:52:27 +0000
Message-ID: <BN9PR11MB5276373EFEBE732B431D87408CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-8-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5176:EE_
x-ms-office365-filtering-correlation-id: 0c48eb49-9330-44a7-4103-08db08bebb07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v+Wzg4QOiqDCxXnUroRASoqJkHbHZVAy3vSUkkZavJe3CVm51RqZNTJD4/WGdI/A6gbMjN2p5qRssAm4qa3x9cWjl7C/c6l5SzSgUmT8W9MHGFN+Z217436L8NMm57xT5ZpdqmqyxY3bTxalcommDL9NKzHxylLVORU2qy/CO4/PK7td8hR5yhf/Z/rdJzx4xRVPODuM5Nbu7k18bYb76FSMHXxb72MrGwm4r1JWStE0Koe/Fs2+rLzzu/+cJZHJz1XyZvefyQbSrDm6vZOGKXv/gE96HRK9tZGd9EVGHSyGfRFRWfNVh/cTL4DUlrJH4x55h7ey+Yq6v1DlJ3C+Kl2BjgeO/4hutdYsej4+MvhkMEbjf0TFTQHXga8CjzOG8lgGZYjvzSbjr4wVG7PABHPZRDLyQKJPe+IUvzLbOsE69/lmhASWHQdRmdTNXH8+zxjJQxl1EePBu1Yxi7oStOccCc66PydoX+O2PAc24lQHIhyMejeIT3f5LfvaeSqxhPkpMMuzBuxzbLHJmuPojT5OQhWKAp2QQ5phyGx0YzNTLTvTVlSIlYyHOFT0dPHGkcgx/titchzTdpbO+ebqzDaW0LoIF6p7hvqDexK+MwGady0jkQz18Og1Iv5/+RTXHl0iMLwMRUVNic4HCGfZek2jou842rd7Gm/1dJPjOXljLB/nb2GgihzjVYKpd7bIkpNSQZ2+Gz2b5wX3ZocSYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199018)(2906002)(7416002)(52536014)(5660300002)(8936002)(41300700001)(38070700005)(33656002)(122000001)(38100700002)(86362001)(82960400001)(7696005)(186003)(478600001)(55016003)(66446008)(64756008)(66556008)(66476007)(4326008)(76116006)(66946007)(71200400001)(83380400001)(54906003)(110136005)(316002)(8676002)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WhJx9GP66nAo3TAdkT+6nY9Ioo9pZ0dxBV0EM6xhOLNsLaePFjrmhC9zIBCZ?=
 =?us-ascii?Q?o+4ejz6vDrPu2gyzPvfyN/gT20waW2Jvv2enYiiPYjyWahBcbeXZ5jtIaKd6?=
 =?us-ascii?Q?r8XfBj51xxIXKj5voMJCQI2zDhelRBSKvE3nY86tt6xX06nntjeQYyan8KTd?=
 =?us-ascii?Q?cLpl8fFp9kklMZehJz79LzRO/pwjAl4kaT1J6208yBJNzGmoYIvUbifh/iqV?=
 =?us-ascii?Q?OZRBssQlwjPz926z4lnI0996Vg64IMMw46+JolZhaKFNHFE7d7q4UN8+/lQv?=
 =?us-ascii?Q?xdp+hlCaHY5fFQkQRhgOXYyLSPA87M2eKis+56ew+XUuvcRSOBCMotvC/NO5?=
 =?us-ascii?Q?kQK4rke9YQ1fhV/Pi/QPbjK9faavueviNJQNYZLPMfTECgcmR6vb4OE0zdbj?=
 =?us-ascii?Q?m0a9EJKoLGI4mwho3y+1Wvxlk1Fg4XWsJnL9AjUqGY79TyNOtiLwS6JgblX5?=
 =?us-ascii?Q?SCBBc9cGFaDtoywjqPrkAmm3lKQhB0ULeGzM63Av6FSyeIJ85GkyvSuX7hDR?=
 =?us-ascii?Q?yjqL4OqsCU7+BS1Er8x9rVLcGaStHgmYlIpO53SvVjidpQ5BoCcMU3xMIYE6?=
 =?us-ascii?Q?kLCAnDgLA68RFXDdbAn6AeIeDI62Bc31m46PPVFTkSKC9CYfaWP5t8+le495?=
 =?us-ascii?Q?cDAEHxpY3aFFd18MeSxZVBug20sXi8W3ZSnAvq+EEPCHqiHiUlTIGeGO7c+l?=
 =?us-ascii?Q?OQo5brKeBYBxk2RJQOePBZh6l9qKp9BmfNDkaGlPhToDv8c9aWS5iixOOkR3?=
 =?us-ascii?Q?dCci4n2xyg2oK/K4tyh8qqYRNIigUIS2WX71JXBPNSVPDVrDgLzTor1fkI3u?=
 =?us-ascii?Q?C0vxyi/8HqUkTtXcUYpgqTd0Wterp6Nvdm/Eycg3sxQuY/CekTJ8UiiOqQsz?=
 =?us-ascii?Q?WDtnVg04jIrQN+lU0IELeMKFoCcONKfthjtaaGGjtgYOIuuFRXaAW/bTl/ad?=
 =?us-ascii?Q?e9zqABZhEgVQjujYosVgc+H1tjOoPl1WsYziP/Q+kTBRj3aWjjd6fTDf7yU9?=
 =?us-ascii?Q?h7NYaUq+es1lyTf9rrMQ7aXe9FqXXxW/2UScPh09HULo2MqLO4ZBgzBQ6k7x?=
 =?us-ascii?Q?x9kmhGW6cO8lOxg0SS5bLVAzORzr0Ov7dueveVanI1ft+Gw3Azx2EITmT0ER?=
 =?us-ascii?Q?HItRIQNPbAxwWNzWKr7sjmZr5DAHl0CoFaW7KHJgw6HpEKUilO1nbO45M9/u?=
 =?us-ascii?Q?8h1vPSrmhDuOoo13RBMIt4qSoeqk3c1sKcms2VzjzijkPpa5Lmyq1FsSa4EY?=
 =?us-ascii?Q?EoABI+2NEs6fLH4mqZlGclZukwsxWIGWybDKeDQmzXr4qn+39LvoSOPrz+Za?=
 =?us-ascii?Q?ilLBkuidoqQnBajjqNug1rfpDc0hNNMQ4hewYWljpi9cHXLaar+0NV3+aJuh?=
 =?us-ascii?Q?/GJnQoa22BkxyBRwU8UJHs8t9FBSuXHynxrDsjjQTJeAQ0nPkQc8rNe4Y8UK?=
 =?us-ascii?Q?sJhqEryxtdU3JBOtGXwkjW52NTmx4xH8fDVRR06y/OS1Epi+KwdKAuboxcfV?=
 =?us-ascii?Q?urQ+7gSLQl0EOiIj7+PW2VRAho++6KPBJcJ/0XxpGWP3ttABg5lGpc2ib6y7?=
 =?us-ascii?Q?qc3yo5U/I9ZGw2jGlGOIh58JDYuJIfAHKOvMqdtN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c48eb49-9330-44a7-4103-08db08bebb07
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 03:52:27.7525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E0NFf2hGkCrNGu0iq0XSZhVOEQKqIvGIvdniQ66H48mQZu4B8SaSb8v+OLESLear9jD3elhFVHHc3CCDkQoxeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5176
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 6, 2023 5:05 PM
>=20
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device(=
)
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
>=20
> The reason for the inbetween state is userspace only gets a FD but

...is "that" userspace...

> doesn't have the secure until binding the FD to an iommufd. So in the

"doesn't gain access permission until..."

> blocked state, only the bind operation is allowed, other device accesses

remove the last part which duplicates with "only ... is allowed"

> are not allowed. Completing bind will allow user to further access the
> device.
>=20
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
>=20
> Following this lockless scheme, it can safely handle the device FD
> unbound->bound but it cannot handle bound->unbound. To allow this we'd
> need to add a lock on all the vfio ioctls which seems costly. So once
> device FD is bound, it remains bound until the FD is closed.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
