Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D8F67183B
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 10:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjARJxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 04:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjARJwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 04:52:35 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21E08F6FA;
        Wed, 18 Jan 2023 01:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674032626; x=1705568626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+DqGMM7FK//HvRCeoew/HBwRh/IgD+YzFPi1adu/6ls=;
  b=dMTchO8rNEjNTM4WNfSbpjFrOA7lHkxh7eO3SSpOvvRV3qy3nhXxGSpA
   ChfeDSf4+VPfpjpPWvrZ6tgzc9FQEMDfuJ6GpLV8mzJwai23qtA42/Uqu
   gSilWXZrrsGEp3Ez/kFHA78sBeg84M0n6dv0Wks3ecvbyYdEe5kmqyylF
   pnmS2PINWP6ZdEu1AcnEO8Cepdqu0q2AJXbVMigoQrv8+QjbG0O88ljwt
   i8K8ZjH7HqGJjK09HRPYpPakbFJ6/N7dZruEP1BKq9I6qyQP7xKXqgj/6
   fOj1j9mboWFO+1wsXXGhRJXurY311e34N8PuXcVsYDT3KggYD4I4g43XU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="387286548"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="387286548"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 01:03:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="690106625"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="690106625"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 18 Jan 2023 01:03:34 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 01:03:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 01:03:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 01:03:33 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 01:03:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Azx+2PrIG9D6biwx+1q038lcfib3sJJFLTYfHiXSSZJaNE6czjvGU0NCoP+ENEx4fzwR+BXclU0Xf2XKJr8NoF4FdRYU8+hOP/6POnGgacAd87isqTJzMBMHM13gquZo+Bk78xl8bsEu3cMrX+TR3MgozyuDZ9rtVA7g33w6sewes0G5UpzhR1WFB3O7QNLl7IvwDg3V+Ii8GuuJ22fmqY73RH5R+G8umeC9ZnZ480uM5ri44pzevDONvMjWcO9czJ8wudzG+47OEqRs0jO0TxZMpr4DBxlki32NrwJok6AO5yDqUHMJxqOyveS7U4bMfnJAwDwylfd4cgeYipB0Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ohEwB7gkjQkf0KTJ9KuC1Y8F2yCy5MX2wGjQgKc15mk=;
 b=YilDPRfNiS9gIVlptirnzZyWkAgYn0PTxzAowZjw4fHd/wWhgjzLDMpsOQAOQRES4D8iMs5AYJLwMe5llj8ujFfaHI0EaVOePtVrQtn3IHhs+YnsD6BcdcxSZIupqNYjfjyPDThdGIzY5tghhF31DGtpGiFu8amz8w3Y3qIADbaHUb/ks5vh317P4tiraHfD+oZcFNiFerF/JGI4XC4Mg8Wm37S2OB9x0eqFdGOSe2zoT7QI7o7gzDzPWgpWEL6Z4yYK9TjM+ocy1nSBJoC2Q9RZgHJ1GEPaUZ0eSiNgKqWT8APgskJSNVW/NyOtAzi5nDXV/c+qZX5HRpOBztenIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4831.namprd11.prod.outlook.com (2603:10b6:a03:2d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 09:03:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 09:03:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Thread-Topic: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Thread-Index: AQHZJ6vANRoQ9x2rxUaXBLM6X5ngE66jJF8AgADCPMA=
Date:   Wed, 18 Jan 2023 09:03:30 +0000
Message-ID: <BN9PR11MB52763D861C254248FD33F65C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230114000351.115444-1-mjrosato@linux.ibm.com>
 <20230117142252.70cc85c7.alex.williamson@redhat.com>
In-Reply-To: <20230117142252.70cc85c7.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4831:EE_
x-ms-office365-filtering-correlation-id: c6fbaf06-41dd-45cc-1238-08daf932de9e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ViDXmfTXbharyN9okBC8Mo+J2583UO5favjJLkfEudBvya5LZaqmJ88kVgMPTEuWRptmFww2W+AoBpVQhQzxv0OP/hLi7kbjbD9jpDGzcToFbmVu+ZahsaoaCFAuyh79n/DSevDQUaHU3RPfagw2nxBcbZ0y9h2LtNAZa8JI5wrB1pvBWkHos7v3Xhcf3jX4n0Ydh6hIGRxBDN1F5et1ve2dUx6aZKGWZ+Q8iYqpz+wTUgjZIkGhZ+JhGrcCU8J3bNWKlA4SdZ6IyxB7yG206Ay1RB6T8JhnHK7WHh8FTK/n+Bnxideu64IPQ1cdvkcGLGvE/wg/rz9YMzaHosMUYGc4cKgHqGg3v03kfCJC8Tz8jmucHDend5OEDGfRhpG78f//gZ4USP7nKm4oc47GLktos/hRLcoRF8n1CdLSNnxKCIcg919n6IFKGT108zIxgZ8qrkKY/OgJhnxuFhnLfzbAN5oW4vrRETQAf48zJ+aRyEz+hA0cEcs6be19zyiEEs89+MaEzNnmnSFWyD4bvx3Js64QdAieSAXabyhFmh8TDCc5EdM1iHaUwRD+5jaWqPAh+yqQrWCK1BHT17cWij9ODXJOJf6uWubNjp+9skbZAGsbj4gFeJxWwk812qLKIaaBc9mkLjUeZ6pmK4Ke74c/dKUDHzi8OOwHwQnJjNPrt8MB1m9h+S/gtiucnIRaeB5KChNQQn1ZQoxCY06Ct0KaGKyfy78lBvf34845ryM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(38070700005)(33656002)(86362001)(2906002)(7416002)(52536014)(66556008)(55016003)(66476007)(76116006)(66946007)(8936002)(5660300002)(82960400001)(122000001)(38100700002)(316002)(71200400001)(7696005)(54906003)(110136005)(966005)(6506007)(478600001)(41300700001)(8676002)(66446008)(64756008)(4326008)(186003)(26005)(83380400001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w16QGxzuI6P3GQ9yGqXexPojEepje9l3Q5puR+NO9Z6cU9OgVEkE3R/GDA4B?=
 =?us-ascii?Q?lVp7FXyyYILcsd8p5QW3tq4xEKXISRMrVsBAYTYhmVImyrP55W5TVPSbUos6?=
 =?us-ascii?Q?Pr3NqQYeRqW4Ye3D2YpolsdnVaIe1lHk0PoB4sa5Zx3200Mlmc+2WJYSnPl8?=
 =?us-ascii?Q?JXpBaIhd2Uykw+Xk1kHIp7MsC6mHAl8XzzjP+P5MRc5YozuqWGlsRhtdmIcg?=
 =?us-ascii?Q?8fSbmwtXniZ34jB03Q899mBqNeDYMQWFsJGs2s1TwtRPXf2IweMlhmuZr1E9?=
 =?us-ascii?Q?h4mVUPCJLvEc9IH0EsbOGmLz54Lo99id2MSddWXKO0NMxT8xp6SmrB5DLFDJ?=
 =?us-ascii?Q?8e3di8mbMheIgWeA6frevWtGBSoExi1KzYDEQ/meyqexldpC0e4QNG1KcveZ?=
 =?us-ascii?Q?mXzVIpAL9+SlHSEp+ja9Y7iRPwzHrnE3mGoQx71gTC/5K0kyPb2J2fOdKOTr?=
 =?us-ascii?Q?8UaMUpUPIBsHT2IZlKXgL9c3Bhpogh7dZyQRPdGAkqfu0ct0kzDj/fVMovoD?=
 =?us-ascii?Q?rI7+HdSQW+kRLkwjFVUtD3lkRSh70wHU3aA7l23sLwCCCnTmf8rF8qW/iV4z?=
 =?us-ascii?Q?+2V25MsH6aM10l82TuLowsXwH3MvIYTcUwHjXqF9PjjijSPi151NM31C6Ash?=
 =?us-ascii?Q?mXEqVjDrBEm6VYXvBwkasPQqpUWo18YpBIighi7x/qdyJqw+O+hCANq412v7?=
 =?us-ascii?Q?n5T0gSpuMsBClRnvrHPUJ6g87RZTj5nuY69Xsu2/Mtu/l3rvISRHoODXMq1A?=
 =?us-ascii?Q?1/gzv3pl8FiGYTB7kyoODPDpTgxMNWOuMqjCBlNXTU4W1Rx7vQlCkuna+kJH?=
 =?us-ascii?Q?qACk91TgYbdD82k7WKqy1L+6s7Vj7KANQzLKh6Wdbsx7whp92V9rLPsk1giS?=
 =?us-ascii?Q?4zmwTFd/juas91SVIOtYDgu3k/bqDfxj2q0w7C12VI0VtC2UqFdyDxdmPGlT?=
 =?us-ascii?Q?q6o/AzKocqHxcMjljh3DpvMcvE4T6Wk0SHVwAaf92XbqmDKnr8hC36K5eVNQ?=
 =?us-ascii?Q?I9Y06OLB39htpA7VbrKZzKGb5OJiTkpFPLFe7dTlpXAmRttzliUZ1In7KkCp?=
 =?us-ascii?Q?gQODpVvgAPqe/1xv+kV8EpUaLKLsxsiNUTUtjm8j39vYwLcWGSkTDWQKu0nG?=
 =?us-ascii?Q?91mt6P1k//3004O2JN1HSQwiC9QPCbm1iaQkfxX+4QSFZirIntNVfMxmXhgq?=
 =?us-ascii?Q?6CKvx53Xh9GncqrAOBTFOkKcLIYbO0fdMIatcM2RBaASgv6/sZgqy+LEui17?=
 =?us-ascii?Q?+c1LA0LzMNIrB7tcXs5Yi2uZEc9qSFe9RWuVWG7+bWxbcZZ50rtMhTlV/1Tx?=
 =?us-ascii?Q?6pzeGxiG7zB3T4eHCLWeql8gPfo2sEdugyB1HUU+Tj3xrGyaPUmGH6Z8E80T?=
 =?us-ascii?Q?cXjzGs3WhT9ZAlFeRGXrGyxYZ5bVFIE7D367D80ZTcj69dLwLurkz3/E022Z?=
 =?us-ascii?Q?qDmJHZr7u0HOGkPBTDix7Jkdkr/jKoWroUGAJLLFvYkKjoImtYLlpfa/ziKc?=
 =?us-ascii?Q?6zsj78Riq8MGq3Eh4s1OxeedxGe0o5IQIMS/63TndVuopMNwGqpbEYJa56s1?=
 =?us-ascii?Q?D3OOv2Kjxb/6RC0CEeikAGzY7qAXhwsEEEtFOGeR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fbaf06-41dd-45cc-1238-08daf932de9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 09:03:30.4772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elifOfvBBwlgjVVY5I6EnPM0MjpHo6XHlBTiujoXoI2Z23M9biv45Ubh8gQqGDxMiPECbeqkKzcOCSAuJWrJug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4831
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson
> Sent: Wednesday, January 18, 2023 5:23 AM
>=20
> On Fri, 13 Jan 2023 19:03:51 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>=20
> >  void vfio_device_group_close(struct vfio_device *device)
> >  {
> > +	void (*put_kvm)(struct kvm *kvm);
> > +	struct kvm *kvm;
> > +
> >  	mutex_lock(&device->group->group_lock);
> > +	kvm =3D device->kvm;
> > +	put_kvm =3D device->put_kvm;
> >  	vfio_device_close(device, device->group->iommufd);
> > +	if (kvm =3D=3D device->kvm)
> > +		kvm =3D NULL;
>=20
> Hmm, so we're using whether the device->kvm pointer gets cleared in
> last_close to detect whether we should put the kvm reference.  That's a
> bit obscure.  Our get and put is also asymmetric.
>=20
> Did we decide that we couldn't do this via a schedule_work() from the
> last_close function, ie. implementing our own version of an async put?
> It seems like that potentially has a cleaner implementation, symmetric
> call points, handling all the storing and clearing of kvm related
> pointers within the get/put wrappers, passing only a vfio_device to the
> put wrapper, using the "vfio_device_" prefix for both.  Potentially
> we'd just want an unconditional flush outside of lock here for
> deterministic release.
>=20
> What's the downside?  Thanks,
>=20

btw I guess this can be also fixed by Yi's work here:

https://lore.kernel.org/kvm/20230117134942.101112-6-yi.l.liu@intel.com/

with set_kvm(NULL) moved to the release callback of kvm_vfio device,
such circular lock dependency can be avoided too.
