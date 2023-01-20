Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC26E675823
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjATPJG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 10:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjATPJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 10:09:04 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576CAC1302;
        Fri, 20 Jan 2023 07:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674227343; x=1705763343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VRvMg1+PcDCvm6YVj27d5iA7xXg3vUrv/MIh9uHeaRQ=;
  b=TSMXHm23gFo2BOx1F+49Mrn6yi9JcUU3YaTUewyGU58dw7dM7uFgJLVe
   +t2RAn27JPTJmdaWC5dc8UaSWcEZ5Z07OZQSwsS66390l77tdPZVJreKL
   2aPfA+d/+YvBpXPIaQ9/G7OJGy15rqbUaKPR3XCx3IPGNivzH5X9d1Z5A
   kO+Z11/cTvFJFAP3A2nx4u76gGZPQp/A6sQyr8qM6WWLX2zju3ZhGSqjR
   MSjzSHqVHigiSUTQK9hpsmhT6VRwkubCbv6OliKBkx/1KByxJmXPWfEN+
   F0UVOMal9J2My60bgG6spV6PxL2WEhvUW5mX5EKkH0PI+PHZOss4qKymZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="325633903"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="325633903"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 07:09:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="729142121"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="729142121"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jan 2023 07:09:02 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:09:02 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:09:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 07:09:01 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 07:09:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUhEerkALofSXFKSm1H3hjvquObw4Jq+68cui/lCBv9lBp/pQMMCFRDdDDAIn2ZhUhWmeU7uFMLyVz5vNIiiFer7Qdz5s2QDjU0NiV5o1AgFaKN7tqI7MBwVsRqwBvFvZ81jbW+Kt9ifk5XOgbLF0qIiSMV/Tqk4Ho4AQY97JSxeN4sX5KhE6poKop2y1ikjTlSQuywyBUzH4Gtnl3mYsl8VfUovfjah/OqOeAqiVMrwVTgCrhvuDZdJhTiEqK5BOmUvlX7LOaGpS8jAN+xU+LCDhCR35+s4PeDFjzZ6h8KPkc4RPHY7KrFuNh7CZtSWJwdB3TucvjYWbquqQ7JAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAJGl9CLkxBoRSEG7lwZTXqzJ9gfhZPZbnet3H+0GfM=;
 b=C68H7DqDii417nk4Kz067+ZWl8g6pDxOCwKuYoQg1cEwByF9l55f594T1zib/XLrbdvBAQJs389Bh3fCtRTLS60p1OczKbgE/ZLQQF2hnsRn50kND4fdYt9VJin3DTQR3tKu8A12CKBOshdLwstA/tPOkmzIQ2EUiiTQHqEqm3901wPszHFSJQodRh6uDtYbKLWxSsdJJ141vttR4xH1/cPgYF3JskRpLh1OFvJxhyqM3/xe7Wu2VTUdQnaOJVXJdIgUDrM60ISMCnfVip+GURwzUEXwF5MXTbfKUT5BcHivQXHKhJGE7tl9yBU0aG2i7o1kzfTs2hujUnTlQJFZ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Fri, 20 Jan
 2023 15:08:59 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 15:08:58 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Thread-Topic: [PATCH] kvm/vfio: Fix potential deadlock on vfio group_lock
Thread-Index: AQHZLOCowN6l2rEgl0uw/AQRWmSbkK6naAtg
Date:   Fri, 20 Jan 2023 15:08:58 +0000
Message-ID: <DS0PR11MB7529B08476DF1764F1B6C007C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230120150528.471752-1-yi.l.liu@intel.com>
In-Reply-To: <20230120150528.471752-1-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB5832:EE_
x-ms-office365-filtering-correlation-id: 78f7b398-8f01-460b-c422-08dafaf841c4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rZcBi6EIXDkgflLaSKuopYoZk9kfTmKkTwHMn/iryUI9GBCFQdkLrdC9gk6FnVkYGzBRGztFHQ0mzFdHkNhDgRFwZptKb12n9wUHmnZBGxBwpk/QmXLduKmYAk1LGLRPnWLvxY0ahcwABZ4/y+fckhAz7l9sA9yDMtaNIZPGXDYyo+XL1GDPevBWG9KgZhq3Vub4PBJiksBVe9tyLmr5b8Ixk83/sNxB08yQXEk+1kfVmoLbbwO4Sy7EPLc7HOQcGywPFw5kwwcG3w/nGIZlrEGjWXjKQpfXw2r64YRpk2cuph8k6drqHFZOIWNRvIzu5kFSoQdf4BVdUiNUDZngJE0f2tK+2ptBfssN/A8IoiPbN/52gulogCUVVbWtrF0hPO+0AFMUV7DhAkT8zLKCtcCTylEDfBpSQcOgDxZAYGsdtWlv7txBntA9W/2lMXzTjgD8yFGiiE0AYnlynJfTi6FHhbPbNoU/hWgkPgZwfodnH4Wwe6iuMxwiWWS+GTAjs1HAmY8H9zO2VNi69MbjiNtMYU7EP8OENwnaHmajuU6MTb5Qsu0eiiaJ79ibWCYDzX2TGYEyh7Hb4TzlaMT2KRFA0UtSqWfQcFNJnjlSvLVpUCoo6Hbez3C4GvTjmnWvBstgSt+uwqH2z2KZVJRl056f53VwAfwrM/XQ4jj1dDJTMW1Q+ASS8ljMvLsNo3C104qOne7ywqF6wa3Jq7FTwY4S76h6QkhskgxdU4k0vtE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(38100700002)(122000001)(38070700005)(33656002)(55016003)(86362001)(82960400001)(7696005)(71200400001)(9686003)(186003)(6506007)(26005)(478600001)(966005)(5660300002)(7416002)(2906002)(66446008)(52536014)(66556008)(66946007)(8676002)(64756008)(4326008)(8936002)(76116006)(66476007)(41300700001)(110136005)(316002)(54906003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MazrZjcZ8uUDc+iQNHxAu882f+kbfnXMSuHsvfR5NFBxEIwUS/amMuJEwoMR?=
 =?us-ascii?Q?XPnkRSVn2npV6XmH/YeGRAmGkUBAhaq0dkgVKGoBujY6HZixEd1iGolBhrQA?=
 =?us-ascii?Q?sXzUkoyrIV0cHhu3WT+YjDG7eb89xDo7RHtVvP0JV6CQIKkXBCn0av/Gh5/U?=
 =?us-ascii?Q?8xY9QO0ZlD9Qnu4uXpVKhnwxc7Tapl6UailEPUJ14V6UwCEpWyMQHgRhGU7Q?=
 =?us-ascii?Q?ZxV0HMy9lNuWO3x5ZOqxC5PoabuBK7WNcs1O1vbhltZOEPnR1HOijm5o/X7v?=
 =?us-ascii?Q?wey/h9490ypYQHgWvmTDnsjqHSCnzDd4lsMPr3qvEyAEOY2Jxj0g7mHziwgd?=
 =?us-ascii?Q?aCKeCW8q+ZpvxZcqUtg5cMZw+0dS6IOw8f32pcQWkx6EOOFqHljeWyrHvKbw?=
 =?us-ascii?Q?8SgYbRDm8fHnZeLJWZREJj02otDr7UwTvZvHFC0zaGFpJxQgtiwWS7lWORGc?=
 =?us-ascii?Q?Z+H8FV3I50MCEZzV4yx2vDtWTHBWXh5NV+Pec2j0MK4LcdHo6bAJ4lh3evPm?=
 =?us-ascii?Q?vuO52guYx+6DZaGlwOIPJdkGPg4IhVOGbNg6+63jsdti0KIk0nKR4m0b0WCI?=
 =?us-ascii?Q?iepEJgz1b2akdeh2XGTMEeh3L3TzGwr1Ff3SPpByyKVBirzqPJSPgRru2T3H?=
 =?us-ascii?Q?tddtkWdecv/EElegmrgXwS2vepm6/V5tS/7tBOTp6wO4zp6GErMnizz0ZUTy?=
 =?us-ascii?Q?WB+XKaaTjcsFigOMcskK9X6DC9mFuwJZ9wGB16/lk73PQVOnADshW/K1fbSI?=
 =?us-ascii?Q?TomAczcNgyuNDYG4bLyeNN8ae1J8cVqBwiG7d5CGoVuTMoohkGr8S3TiSzXm?=
 =?us-ascii?Q?YKqRVC/mtR8BuKzXBLDKWQEP4af2P0uDdnK09mAzPFrVrNFJ6AQ1VKnyz/OP?=
 =?us-ascii?Q?sPoMPDbJk51GyjkeYDPxQaAhd42NFG/BWPeXNdo6MaeqeTf0nQ/4vpd2WU3Z?=
 =?us-ascii?Q?tGYF7sFNXG4+PMTX937i+2l1hInuAkwMoipbMAcDJ8y0QDVASUhNR6edm45J?=
 =?us-ascii?Q?rsoxSB6RBWa5rx1/mN7Iesy64WsqMnMiDwJI30pJhweP2knoxJ2IpmSm6hR1?=
 =?us-ascii?Q?5gvWvtznaHPhIIvnq4uZR6WvchcQ6sb+WyoyB4HqZjMPXgttZH33Z9TWshw7?=
 =?us-ascii?Q?SOQ3SvQ6VT5pX3tl7woOLMTBuD7E9WQ+MD+ThvjO4hyQZMdujxnIg544j/4p?=
 =?us-ascii?Q?qKSYV/t/CRW3E5faiZJrSH7xnPlRzZXkxY57wVmblEPUwju4Dqf51rC/xj3p?=
 =?us-ascii?Q?xkaPE1aETyKUXvhO+yXPsXgsYXJyfFitRy25SvI8GceDpFq08jH+6DoJgKX8?=
 =?us-ascii?Q?f/coFUa6pyXHBaU36mCUzkiHCAeLw0NRi1va3W0TKlVB2YO3sdS8ffe7suoH?=
 =?us-ascii?Q?w2tNH0Yr9CDRN6AHpSJnU4t4phSUB55KZBGoW2bHYn8oDszsdJlyUR6AMmzK?=
 =?us-ascii?Q?LJ5/KcUrjKT5H+PmOsLjJb3kyJIQh0Ld/YzTEfVxNFW92mXqAbot40ry3eDR?=
 =?us-ascii?Q?Eh9QSs320m27FWPGlY52W5VTq6Q9ffIT7/muvC3tZDVAxQvJHd4VB1cOOmwv?=
 =?us-ascii?Q?uu5O4mQScwrX+/s42kgxlKb18bi2qodDWh5qiUUQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f7b398-8f01-460b-c422-08dafaf841c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 15:08:58.7968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lKDvuco3RjJb8nE/n1I7UkMrTS0iRA08YhrRCJz5anABsH+5b0ArCLyAAmkGvOz97AFi+L21iWurdBv1drLkFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5832
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
> Sent: Friday, January 20, 2023 11:05 PM
>=20
> Currently it is possible that the final put of a KVM reference comes from
> vfio during its device close operation.  This occurs while the vfio group
> lock is held; however, if the vfio device is still in the kvm device list=
,
> then the following call chain could result in a deadlock:
>=20
> VFIO holds group->group_lock/group_rwsem
>   -> kvm_put_kvm
>    -> kvm_destroy_vm
>     -> kvm_destroy_devices
>      -> kvm_vfio_destroy
>       -> kvm_vfio_file_set_kvm
>        -> vfio_file_set_kvm
>         -> try to hold group->group_lock/group_rwsem
>=20
> The key function is the kvm_destroy_devices() which triggers destroy cb
> of kvm_device_ops. It calls back to vfio and try to hold group_lock. So
> if this path doesn't call back to vfio, this dead lock would be fixed.
> Actually, there is a way for it. KVM provides another point to free the
> kvm-vfio device which is the point when the device file descriptor is
> closed. This can be achieved by providing the release cb instead of the
> destroy cb. Also rename kvm_vfio_destroy() to be kvm_vfio_release().
>=20
> 	/*
> 	 * Destroy is responsible for freeing dev.
> 	 *
> 	 * Destroy may be called before or after destructors are called
> 	 * on emulated I/O regions, depending on whether a reference is
> 	 * held by a vcpu or other kvm component that gets destroyed
> 	 * after the emulated I/O.
> 	 */
> 	void (*destroy)(struct kvm_device *dev);
>=20
> 	/*
> 	 * Release is an alternative method to free the device. It is
> 	 * called when the device file descriptor is closed. Once
> 	 * release is called, the destroy method will not be called
> 	 * anymore as the device is removed from the device list of
> 	 * the VM. kvm->lock is held.
> 	 */
> 	void (*release)(struct kvm_device *dev);
>=20
> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

More background can be found in Mathew's work.
https://lore.kernel.org/kvm/20230114000351.115444-1-mjrosato@linux.ibm.com/=
T/#u

Regards,
Yi Liu

