Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08946D5722
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjDDDUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbjDDDUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:20:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29972C2;
        Mon,  3 Apr 2023 20:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680578412; x=1712114412;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1gVe8eD8X41+TqBFrq2qUuAF6AXP+K7iio7P0DOh3Jk=;
  b=jMEQx2utadE73ESKc4VpcJ+VeSf7f2/QoFptYDCeao6+980IVhnCSNtR
   YJaGof5z4qSQMK1k0JLF9mWNds2jWER/EW+vuE94HNRb98JFgjzwAT64w
   n2iOSRROVN6vdSECa7zM9Pk16IaopEto8qjyW8sqt7ExASiH172OqKOSA
   up5JWS2JJv5s9vSGfwwI69kXqgNCnSb1IsT9KRbNgdxnbN9Lueku4Ab0t
   TKlhJq15wEfd6tipvrj0kL97ep/fjHOtvkhggN95woRvUh6t2gjgmuGr1
   PNgb0WGdVImtByVIS0LsZZzgKK24sUlog6EvzXmYoaK55pNrmQWcDufEL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="407138354"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="407138354"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:19:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="679732699"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="679732699"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 03 Apr 2023 20:19:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 20:19:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 20:19:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 20:19:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 20:19:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6xXUOud7vkL5gOD0hIQm2E9koFn41uA6K0PiklJbU5DbsJEryQlVaYbY3H1biLsd2HO++mFMRmSbCxKYQa+oaBwgWQWrmXbbSTKZrI+hB9BV2O2Movg7oXPYwMT/MkdXCJQGmhnmCOWndHeZCTAHXccI3lI2BDbAF16a4rGbiVKi3avXDpa8zPYkbdObRyktHlEpaooLcYUtJJxYAReypJAQ+J8Ouj1veQwWKVZoAsx0GsNkqy+k5SNS6ZfFswBtXlMEnANxw3jn3TToWnCUPzekC55hZtIMPDtUSJ7PVt/IrHXdBcpslMf65Bw2Ws8nl2fnWRu80PPMesWDLbw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6v8VqOXo1Ns3NeDIxypUegTjPIWZe20OgpO/kXWzVs=;
 b=IkAlJgw/3VT7THWeVBpYaRd48W3EkmopED7FljWFUpGQl6VJDSrM9KLU1+l8qHwMMAbWIyI/UE2j6eW7itRHYQSOvg1yEi/jzfTNIXHA3bAA/PIzKf8irgYPPCkHWvK3CukvffF2pI+nkcA4FCNixIdnjeDVM5YUBWEH90pCSnJIBNbGyxH/NzlIf+53wyIwCzripTuvKPrqHxU9BQte7D04bm7TZMn7MIG8IqLMGYz4E/T7HLs3nZIRlW1/dv/aUoQhotT4lN4m/EhgpKn3Xjswp4rTGfE+POO145k9oufHbWZWpWZBj8hutUPYBK7GjNV9wR1gATkXSWiKeXYlQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by BN9PR11MB5225.namprd11.prod.outlook.com (2603:10b6:408:132::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 03:19:53 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::174:6bb9:46fa:f97e]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::174:6bb9:46fa:f97e%11]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 03:19:53 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Thread-Topic: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Thread-Index: AQHZYb/Rk3to+fQWNUmPjc7xA3v1Mq8UqOiQgABDWQCABYmzAA==
Date:   Tue, 4 Apr 2023 03:19:53 +0000
Message-ID: <MWHPR11MB124531FF4E6A4A2293D292D3A9939@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
        <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
        <MWHPR11MB12456636D269F997D1812FF8A98F9@MWHPR11MB1245.namprd11.prod.outlook.com>
 <20230331075122.736bdb98.alex.williamson@redhat.com>
In-Reply-To: <20230331075122.736bdb98.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1245:EE_|BN9PR11MB5225:EE_
x-ms-office365-filtering-correlation-id: 1be6c5e6-77aa-4a37-f359-08db34bb7567
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ua4HEzZxu/LLxo/7JJ16NdgabDfIQMxYczzcohdBtu1Gvf8YFJjbHDR1wCdSNFY26sSTYks+watocXDGjwhX6/TZnUMQRtdpMhqnS3TNBUc1iX/ZUmDvdYjiLM/zSKkVATHRs3qAePM3+fkEQ+tMKVhptytmj+sKYcGUl1reHrmZv7U+O+9FlRfM67LpxpLaSXZZRSFcXD2jgNEoFCGLwChreDu0JYUtBZsqGXePaMonJq4CbPC+71EqEKIRrcOPegcjr6YKamEgn6NclucYhGg90qQFghwSlZTdLub1ubqiGjD3FlWDMnhc0yBJvqWAmRamHHkE0pqSumt7frte04tK+49KV3XFCMZlzOKWjSUn6kz3dZNycmSjtt1/oItVsal0Yz5B60bZRE2DlSTuiFn/f/HsczdcQu/CaqXF6AiNuwM51Mx3U0dk9OQWCguaZCYx8sjPB5RBR2hqbe7EgrueI6TJyc7vmB9gaDmTx/AUmK9zJfG2Me7Vh3BS/dGkhRknL1CgaDg3zsWZA41S6F+Nv1N6iJ9pXqvzkXdE9r74675v7T8MZJ2dzfBd5mRiXBYz4YQ+ANuWbd1uOw6uDRUb2eOqFMsERJxZtnv7xKqAt33MazBV6nXLeOi0jhplESD+4nHVluNd29y/dakH1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(52536014)(41300700001)(71200400001)(8936002)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(54906003)(7696005)(478600001)(2906002)(6916009)(4326008)(186003)(64756008)(5660300002)(8676002)(6506007)(9686003)(26005)(83380400001)(82960400001)(122000001)(38070700005)(86362001)(38100700002)(33656002)(55016003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FXoyFnbiatkVwglOT0atBFhrGVIkOH7Xd3li7pbIvtgeHxbJKWpxOemQs4QT?=
 =?us-ascii?Q?T5Ew4dBuxB72BMdxBqKMBw84BigbmtCcTPRDnMbJhOkYyNwwBQFjxc4rONUR?=
 =?us-ascii?Q?8K54MmSunbQypUxD4Niy7PvXa6heNBrbD229m/r6KpBfefyQglDaxhwIFPzX?=
 =?us-ascii?Q?W7lUX0tmlEIR4dj9tGqyIP0LeOoBnmbaus05WY86wrwfKddme3XokXkI3fMC?=
 =?us-ascii?Q?RFPdXCu4bv2TgoYiMYnLSkd6dOS+vln3N3YFp/Yb8fdQ5/JjOsVCm3DmiPZA?=
 =?us-ascii?Q?SUvwiNgtUHqeMo8ynYSPvWFxahPALMDE/ihodQth8oKkSQA+duCalK5Jud5y?=
 =?us-ascii?Q?seNLJaZwMITdLLZBva+P7DO6LtaqaSjhzfInkQBhBRIpHTZQfFdWRUUSNqJR?=
 =?us-ascii?Q?ck+2UugbPWmtBf4QzSrXDdLhtAAlmddHUW+zTsnwaez29DCa0sbFYGGmzNCw?=
 =?us-ascii?Q?6sn40jGXkZhg9dJNq8Osdsrl0SaXILSIwqrmGh5vdeXaI9APayLp9koOV1AF?=
 =?us-ascii?Q?dboczDtdWE9H52hr6ZLNMsC2pJU0zXnDKUxzc3SCQIiLahSEGvduXgK6D9jo?=
 =?us-ascii?Q?rMwyvpVtyJLEwM58kCNGG/DZrBBVFwpNlcSiuJigGhAPw1rvUYf0HQ/kJyFS?=
 =?us-ascii?Q?gUyb5Bx5tLKeCUs0ZfUElZ3440BFJ0qUn+6kCxQbsC9GJdwCrW1uzQrmAqXp?=
 =?us-ascii?Q?v8KNBTcxtyN8W0KVWIScjh/7WKwyf8vFvHFJIxmPAW9jpFNH0y1RtdFiohZM?=
 =?us-ascii?Q?YDJ+52l/fQ6sqbPIx6ZISmQ84GHd0kArfYYmCMzYoYlXKIY7huWGpFeN4mbh?=
 =?us-ascii?Q?roAszvIjqb2zE6si78U+iXjaR+cFNvFfuftHBAk8K0m/Pb8/O1L0pgPdWYaV?=
 =?us-ascii?Q?mfbg6x+kL5bFuJbK9AVlSl6Diy1aZYuiemZkV8dltceKRUgOAWSh27/KKveP?=
 =?us-ascii?Q?FJsObxqBZEVLWqFyJ+e0sWpQaeKqE45WtSM6wFQyluGOXdpAbo08GKEZPT4A?=
 =?us-ascii?Q?3h0d1T2TipW8WhX3gNPz+d3z+A7ZZ9i/I77ee3kkMngO4pxHuwLe0R1ZnOZK?=
 =?us-ascii?Q?ck5ai57o/0BkPERtDUvvCqLF+9SewLf53PJAMYrQhzUQCLQ0EJTl4bak6yVF?=
 =?us-ascii?Q?xbJYz3BcmQTxrTDJtAa84rPJq4T6B7ut+SY3eHkZKJiiHZ39cL6GGHtc6LKo?=
 =?us-ascii?Q?2xYOdtI6QcBx+2v06wbAOMuyQ6H9MzlsKDfe8Gnm61NX62IxoWTM6S1AL1bL?=
 =?us-ascii?Q?RnsZCLi8Gi1mhCWDSiOE2AG7RgGPkUYdN+89p0uWFwO/CtXsCjJeXWfZCuAR?=
 =?us-ascii?Q?ztX7jVJWa24OIH5PmB3ZJ062Oo7czbJIC+KTHdZ4g8XZt900sYBh9nHmgdKc?=
 =?us-ascii?Q?KxC9Rh2shIQyC/XhUqmsD1W5drMVbuaDIf0S6OmEnIT4V/f8pYNvIV3vWM/E?=
 =?us-ascii?Q?I8Xlf3ZqGT76zjCHgSQ6p7sahEv2RTbsZOggzhaJI27zaDlIe7OEdzy/CwDF?=
 =?us-ascii?Q?Ggya5suQaEz8lHpKM2RzjrJcEpkdbJeIGLHV6IEvyUNvHJjdORubsjrwmrM1?=
 =?us-ascii?Q?OL8Q5BX5eSqoOLGDJH8jj4ISLU5QeanzWpUcLhmk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be6c5e6-77aa-4a37-f359-08db34bb7567
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 03:19:53.6206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X7Fu3zTdolxSbu64WRisHBcL0ZSgUosXm2CEgiSI+o2gqFt1RHKbUezbNUkISr+8myjJxVwQEbBPHvNpVrI14g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5225
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> From: Alex Williamson <alex.williamson@redhat.com>
> On Fri, 31 Mar 2023 10:02:32 +0000
> "Liu, Jing2" <jing2.liu@intel.com> wrote:
>=20
> > Hi Reinette,
> >
> > > @@ -409,33 +416,62 @@ static int vfio_msi_set_vector_signal(struct
> > > vfio_pci_core_device *vdev,  {
> > >  	struct pci_dev *pdev =3D vdev->pdev;
> > >  	struct vfio_pci_irq_ctx *ctx;
> > > +	struct msi_map msix_map =3D {};
> > > +	bool allow_dyn_alloc =3D false;
> > >  	struct eventfd_ctx *trigger;
> > > +	bool new_ctx =3D false;
> > >  	int irq, ret;
> > >  	u16 cmd;
> > >
> > > +	/* Only MSI-X allows dynamic allocation. */
> > > +	if (msix && pci_msix_can_alloc_dyn(vdev->pdev))
> > > +		allow_dyn_alloc =3D true;
> > > +
> > >  	ctx =3D vfio_irq_ctx_get(vdev, vector);
> > > -	if (!ctx)
> > > +	if (!ctx && !allow_dyn_alloc)
> > >  		return -EINVAL;
> > > +
> > >  	irq =3D pci_irq_vector(pdev, vector);
> > > +	/* Context and interrupt are always allocated together. */
> > > +	WARN_ON((ctx && irq =3D=3D -EINVAL) || (!ctx && irq !=3D -EINVAL));
> > >
> > > -	if (ctx->trigger) {
> > > +	if (ctx && ctx->trigger) {
> > >  		irq_bypass_unregister_producer(&ctx->producer);
> > >
> > >  		cmd =3D vfio_pci_memory_lock_and_enable(vdev);
> > >  		free_irq(irq, ctx->trigger);
> > > +		if (allow_dyn_alloc) {
> > > +			msix_map.index =3D vector;
> > > +			msix_map.virq =3D irq;
> > > +			pci_msix_free_irq(pdev, msix_map);
> > > +			irq =3D -EINVAL;
> > > +		}
> > >  		vfio_pci_memory_unlock_and_restore(vdev, cmd);
> > >  		kfree(ctx->name);
> > >  		eventfd_ctx_put(ctx->trigger);
> > >  		ctx->trigger =3D NULL;
> > > +		if (allow_dyn_alloc) {
> > > +			vfio_irq_ctx_free(vdev, ctx, vector);
> > > +			ctx =3D NULL;
> > > +		}
> > >  	}
> > >
> > >  	if (fd < 0)
> > >  		return 0;
> > >
> >
> > While looking at this piece of code, one thought comes to me:
> > It might be possible that userspace comes twice with the same valid fd
> > for a specific vector, this vfio code will free the resource in if(ctx
> > && ctx->trigger) for the second time, and then re-alloc again for the s=
ame fd
> given by userspace.
> >
> > Would that help if we firstly check e.g. ctx->trigger with the given
> > valid fd, to see if the trigger is really changed or not?
>=20
> It's rather a made-up situation, if userspace wants to avoid bouncing the=
 vector
> when the eventfd hasn't changed they can simply test this before calling =
the ioctl.
> Thanks,
>=20
> Alex

Thank you very much for your answer.=20

The reason is I see Qemu has such behaviors sending the same valid fd for a=
=20
specific vector twice, when it wants to disable the MSIx (switching fd from=
 kvm bypass
to non-bypass).

So the right consideration is, userspace should be responsible for avoiding=
 doing the
same thing several times, if it doesn't want that.

Thanks,
Jing

