Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F86867563F
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 15:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjATOAe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 09:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjATOAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 09:00:33 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903A1C13F3
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 06:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674223232; x=1705759232;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8+nca7SQgVmsZA1LPYaxhEoU7vMUVTducPZg8B2l+AA=;
  b=HGiOHJAcnlFUH5rliwZu8GNujg11GoN3OlHNSnPfoNN5z5BCzeBGsZUw
   yK8sUjFACKJufGM7Tjf4CehV5AmkH+8vCcf7UUypAw0TTiMs8BV6sDbct
   k1mrHJ4Su2e0DwYkqWLKthn1rrGqXKEAbqWooUXanQdgkLiDsW7Ghy9Ap
   yT1nX1mLGb5aptDIC0LOq4h6LMvyg/Cfq0qIRTgPEzeGiKNM4eAewNCpv
   317lQU+81ICYnSY7O0CCNZkKw920RRh2OLXIweglvJaKyjwDGCL9xp4EE
   /aV0/Urd7bKbZ+HW9WyXvNgbTUrKQlgHI60nXOZkmXup4aIVx8IBn7ngj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="313468038"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="313468038"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 06:00:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="989404856"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="989404856"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jan 2023 06:00:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 06:00:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 06:00:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 06:00:30 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 06:00:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffG2eFUrmUoIsPg8D5rCBPQn2vTSJWeU6oJKEKmk4t5JTSRujw5aKQn7J8JMqQGrbWweQsKQuyqrAnuMuVktwtgjA3E5v7Qi8KFlL3fuPqhlHQVosgqVlz0DC8PdCI2/PgrnksRCWZmH2Os+DaNMMFRxiVWyryfyf4PRr17tWvml6rfW5ukrMQ7Qt7vAY14xuPzm/JhLvTdxDTHIyHhszek1ArWRoT4tucoGflGXeBjVbWxhVOd5kv3wkMs5lxBiR3nab1HXUkXxVRRj3xAvJTopbrDLooXA4PdbnSQ0tdRgX/6M1IVJ6MQll3yS3P6l7v1tSq8DtogpSK38NLv5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4izblX407dj1zG8wNHA0bIzjP2HuTyLNvMeL8aAO00=;
 b=JFaBFp8DddtRRMePrineucF69yS5cC6Y4PXuWGtJGfj2m9Y8oFBX60j2S0oZWkp0IoayQfF3/edhZFbAvet6gNXJWu7CbZVS3jqYizzz0lWLrD5gVcY1zkbs53yIKjyWV76TivtD9h5UcjQshA8FqXycJqzkCmayL0SnHOEdur4lBmNWHoAndRsYKHQXLZi7v71RMHlyk6aVm9sGcurJI/dKcBOcl1QRqEq/wMdMBX/dPZnOESk/wWXjaXWuWBqfQgZUSHRFadIuye4W0365cEci+8C/fXiXLZ7R/7cEPEnqn42GL9KxdHKDsRyYGsZvw3dZd5enJGgymR6quiloNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7719.namprd11.prod.outlook.com (2603:10b6:510:2b4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 14:00:27 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 14:00:27 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Topic: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Thread-Index: AQHZKnqZqWxc/vWNRUWu7aJW7tOztq6mHXaAgAE2HMA=
Date:   Fri, 20 Jan 2023 14:00:26 +0000
Message-ID: <DS0PR11MB752914C92FEFC0DB5278D8D1C3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com> <Y8mU1R0lPl1T5koj@nvidia.com>
In-Reply-To: <Y8mU1R0lPl1T5koj@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB7719:EE_
x-ms-office365-filtering-correlation-id: 7042834a-c894-437e-d2c6-08dafaeeaef5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dUklLAYhIhs1RobkmVxJ+uLZ2oxtuV5x/cgxEK1KdXKrc7+TaPPAvImIHGZTZXWHK/Nb4vHCv/p2zFLmLz9AXnkRGRrkJch5tBoj5QSTzcc8kVl1ODhsXHHFhrsrsv5/QsgxFlLV1GFBzq4erTRpUsvWJ4iSGvKgWHDyitLeNGW213b67178tCGSwMTb+cLP7PHZqAD5kCqXP1LbAzKSk4aW9MSxO4ckEBO2Kxp63PEnl8c2Klagio5/xToc/qk9UGywTBKOBmYND5lgtQ/tWvOBts3VojyYq3s6B7cG8lFFE5v93Ubza5J47Ny6v8c42AlpWSnP/FDio2iXC+gey7nR3rILyHWaCaZLoeGaZo9j0sUISc0jjljHdujwP9BLDWf5vlTgaswDmPtOmIB/srU8sAePENfHQsYFfgk1q07IfULibE7tHww3mXjLeKWUF5lUcIgbBNMtGnPau4rIRi8X4SG+bpS6h5XfU2DPydZo9IjsSi2WuL+ElO3DLsiHb4bNeWL8J+klk/+kTBk55p2Kr0M/61Rx2Q+z5O3R2xhEhUk2/MyHrQgO2j0ePaHcTPE0L81HAM4rPGL0Xq65ucwdUCd/rjG7lUecvXNSyRO0yCDJ5G9gw5hkSWQfsQ+P4DokjtIBv7GI7LUlWASX9i91JpcXkYUJfdd8WVP+CQM/LsCwjE6OBiIzKo6lkBsn0j+aDF2zybZ9EQFnKxF+Ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199015)(9686003)(26005)(186003)(6506007)(2906002)(316002)(54906003)(478600001)(7696005)(71200400001)(122000001)(38100700002)(38070700005)(55016003)(86362001)(82960400001)(33656002)(83380400001)(41300700001)(4326008)(7416002)(5660300002)(8936002)(52536014)(76116006)(66946007)(66476007)(64756008)(66556008)(66446008)(6916009)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6485CtZ6IFAQtZHREfOSIUpahXeden1bwpeY2vaRI194kRjv/MXAsACzLIeS?=
 =?us-ascii?Q?8mTLixgQUt91L6CshqxAUehMdcJmhSv0+r5BKYH7KMGlM8BWUOMRP4TV44l3?=
 =?us-ascii?Q?wpwFezAN/PcAzFSYz2RXJDlbXvd4KlfdPLQVZq4z9SgZxeidiPETPBpBEsER?=
 =?us-ascii?Q?scku1eVBfywO32k3jtO++IDpLdNnyWWr4K8+YcrVBZAB9HDx8vR+FcroL0Bw?=
 =?us-ascii?Q?993112R4lnZEGgOF2f8b1jy2qqGLWxY1mSD0KcXPLx8QEJEO8XNPsno+nrK/?=
 =?us-ascii?Q?TljRtxbNMyfAuKiPLxn6773BIoPDv6YAKG3jwWpyzh1ytlAHyAR5nVHVY3iV?=
 =?us-ascii?Q?qlO/XZYugXxDx+sFVE70nVx9U/lUkMHJF7lwlS6HVOqp6PQtv6DP7V4dI3Fb?=
 =?us-ascii?Q?vb8GVWDITooK89epLxSQXV802ljkLCZv0T7IU8h5mlIO3AbGanCBbPHZqtsZ?=
 =?us-ascii?Q?GWrZB+dDdFENB0z7MwtVMOkavP5+0MLsHHMcb9IxkWkcL+6lt12pJvW5sLoW?=
 =?us-ascii?Q?yt4iCGnQkEiyJsLmd0Wox/Gy1kMyv6+rXrJa1fPU+/2DVmuE0DlENKG7dvfm?=
 =?us-ascii?Q?5UQGRJYrcqyDXlNDACSxrwt2qnZ0QWluTI70sHHqIez51jLg5XygOzHO4j4Z?=
 =?us-ascii?Q?NOR7NBhkThpt3b5TdHE2RCWAMPbD1YQIsy5uupQzklwfE8v0fxhkDBpW5AvJ?=
 =?us-ascii?Q?YfZbCRnONPHSg0LF8W0X+kv8SM1o8wnd6jQBwhAm43zmnAbA4uPfoMKGIYgb?=
 =?us-ascii?Q?Meb4c9xgVFx2b86p0rCQthKSRvot5bspWKr65CkryrddUopoSd64XuYrakS6?=
 =?us-ascii?Q?kSemG4dyVLKlw4stcbO9fmwR2GrGkEcP98M/VH8Ie2MlJCWkWaySK7hRpCvw?=
 =?us-ascii?Q?tmfSzPhsquTc9sGc5yd+d/zGmnrimfdyph/ZI2mDIF+lmMqZqxbWrB2KFKPP?=
 =?us-ascii?Q?uesYFA6scrmTEXxUj10Q9iznn3p4SCSF9upM70Y6N7yK+rbgUsk6OG0mk+1P?=
 =?us-ascii?Q?maw3K2W82f/bBMW0GZfLkxhDehB4KQh22nqBsMhZ804hIwJPElV923hLwn1Y?=
 =?us-ascii?Q?um9JaITXlCmGFt2HWFDkL8IjGnnWtjB0+YmgsMxRcYg86kJgBTZ7ViYG7Xpx?=
 =?us-ascii?Q?6R5/OJAUUbabupYm8Ptdi+Pm9skGiaxVSH5rd/iQKZFzW5iAsjqDNu9RX1fz?=
 =?us-ascii?Q?Ikpa8a1IVYaH2t92ujLkfVjXhrmGAjb1jOwm+ExvDOKxZeVqNg4RW520rZn4?=
 =?us-ascii?Q?lLqkkpr1wBMhglHmj2Cx8ZVUddDH2/7KXb97F9QUt8Tw1aaEDgGdQq+RziKQ?=
 =?us-ascii?Q?pVoRyL4/nRgbhgX4OkIqOiB+XhF8FhQLZkJmKQjyCTuLpnvLBxHMZX1HP1WL?=
 =?us-ascii?Q?4jxLtY66vOY14GW7LlcUzCq8QfKqmAq+JEL7fXepeNZ1KrOmIIefnX/1vksd?=
 =?us-ascii?Q?Qckq1wgdfNaM0uKh/+b5JLRn1AaDpHAtkcKYtKct22x32FHCrGUuzYsmbFld?=
 =?us-ascii?Q?OlJ+TR1gISvvkabTz3WKxiZOElXbV2rMHRe3Py9pYj/LfYETptAqf51VsTfM?=
 =?us-ascii?Q?0EAt6ISbwxxuxuQqdZcYx7bi79HIa20X1dMSHnz0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7042834a-c894-437e-d2c6-08dafaeeaef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 14:00:27.0228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gwUmpiDhhAhff7Zoeo5pd9Gf+reG7FN/bW/7rMCRjqtVWVHRqqRt7cJq0S+gyIAI31yWbTxUS2al0NLmYctvBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7719
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, January 20, 2023 3:07 AM
>=20
> On Tue, Jan 17, 2023 at 05:49:34AM -0800, Yi Liu wrote:
> > This is to avoid a circular refcount problem between the kvm struct and
> > the device file. KVM modules holds device/group file reference when the
> > device/group is added and releases it per removal or the last kvm
> reference
> > is released. This reference model is ok for the group since there is no
> > kvm reference in the group paths.
> >
> > But it is a problem for device file since the vfio devices may get kvm
> > reference in the device open path and put it in the device file release=
.
> > e.g. Intel kvmgt. This would result in a circular issue since the kvm
> > side won't put the device file reference if kvm reference is not 0, whi=
le
> > the vfio device side needs to put kvm reference in the release callback=
.
> >
> > To solve this problem for device file, let vfio provide release() which
> > would be called once kvm file is closed, it won't depend on the last kv=
m
> > reference. Hence avoid circular refcount problem.
> >
> > Suggested-by: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  virt/kvm/vfio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> From Alex's remarks please revise the commit message and add a Fixes
> line of some kind that this solves the deadlock Matthew was working
> on, and send it stand alone right away

Hi Kevin, Jason,

I got a minor question. Let me check your opinions.

So after this change. Say we have thread A, which is the kvm-vfio device
release. It will hold the kvm_lock and delete the kvm-vfio device from
the kvm-device list. It will also call into vfio to set KVM=3D=3DNULL. So i=
t will
try to hold group_lock. The locking order is kvm_lock -> group_lock.

Say in the same time, we have thread B closes device, it will hold
group_lock first and then calls kvm_put_kvm() which is the last
reference, then it would loop the kvm-device list. Currently, it is
not holding kvm_lock. But it also manipulating the kvm-device list,
should it hold kvm_lock? If yes, then the locking order is
group_lock -> kvm_lock. Then we will have A-B B-A lock issue.

Regards,
Yi Liu
