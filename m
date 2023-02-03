Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9DF6899D0
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 14:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjBCNdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 08:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCNc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 08:32:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE61A0EAB;
        Fri,  3 Feb 2023 05:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675431139; x=1706967139;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jQbMH7ME1pA1RSSdROhTnycOXNyVwimnVOTPiKU04hA=;
  b=W+A6Kar0QQ9zqpyibWxOUk8qYE3SOuxJcVJi4ucal7WywPHDJ1Vu95Hi
   Bk1+4bwgXDafT4+k320CsPPvwxHjq7rFPq6yO/1iiktGkhfucpVEMVNzp
   GebgcQ6wMpskQ5zho9iokFsJrTxpkyi5XT1WFzl5zbODVOWbjjJyrCBHY
   cL27OQiGOri08EhD+VLYT6m5BuxXQZq6dHHJAFvna87eLbk07G5VxqSiI
   uWqmXCA/b8ffbdGcmFV0oP4rf3WEcpmujoegT7t0mVUpAaW/TCY72c/xn
   TsYusOolRmHVwh57gKem5ksxpXT+GR2EbB+/pg7PyduWdbDLUvlekeQhN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="330032313"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="330032313"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 05:32:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="729257286"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="729257286"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2023 05:32:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 05:32:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 05:32:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 05:32:17 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 05:32:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD+sl0QnUjhCnGROqUAazUCacUjFqtCJdaAcMmeCxzdRnw01vkmqFHtXn6hhTIFA58TeocA1OMmpkLc7OOu2H0InnR0JbSo3bfQzxKra2ZRdUfbHu+/DZL8B4CEbaJAUq/PsKerk98T7OahiT4CwLCSWZDgj+/HrXj/tmiUcOzsaTv6gwfNutk4ZOiiGw1mAB7X+SLxXFty3pi79AYtkJTjou+/3SXkHVPDR778LtJQzhop+JRrE2cQzMPTXJeZF1mWOzMBudnElklc0d2Xz/Kv3c+psvKoLQeiZl4tyPms6Y0tR07Y3mi1jAj1mO2+tXAe8xkoK+IxzzgniGNJtyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SX04WVzTgU8z99ROLmP0E0EnaFI8/tlDnoGcWMRBh0=;
 b=N9Jh7ifHU+PtY3wTL62UixX0o2Jo2s2Su3PPO3o+YvJaK4iytkKUC9KViGAQwACYTsQSV2XCewDxZOTjIvKW/L5+VZSfphCuHrc7xEyozCtsZU+t7NEZH9qeRP5q4TYUKNHNHeWu9QgCfhz32DFa3ng/eAJY5ZPcAVmnZM+ihqbWan5UVx2Pto+XK8TFt4yY48efwkjoflYf8OqiI39WVmbJ4ra4OQhJ63Yh1LDt9A9cjUMqTRTXsOmdiTgrvH+WL6RCvKlkhnCLlxnfP6slAJLsqrNI+g6EKy3Jk7/Opih4MeeCyrlE46kk9NDfdzggJokLTY81OCHHXLKKSkkX5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7799.namprd11.prod.outlook.com (2603:10b6:930:78::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 13:32:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 13:32:10 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNyMjAB7EXHsi0Ue5s99XWjtHT668DpoAgAA4cQCAAAKAgIAALrmAgAC0yrA=
Date:   Fri, 3 Feb 2023 13:32:09 +0000
Message-ID: <DS0PR11MB7529050661FCE4A5AC4B17C3C3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230202162442.78216-1-mjrosato@linux.ibm.com>
        <20230202124210.476adaf8.alex.williamson@redhat.com>
        <BN9PR11MB527618E281BEB8E479ABB0418CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230202161307.0c6aa23e.alex.williamson@redhat.com>
 <BN9PR11MB5276017F9CEBB4BAE58C40E88CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276017F9CEBB4BAE58C40E88CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB7799:EE_
x-ms-office365-filtering-correlation-id: 830811e4-64ee-44f8-25e1-08db05eb0d36
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N8HXTwFgCXiMb1GYmNsOpWmlCN3D51Ww8ZWK1CC6C3PShK+FliSMSNwZ5agQ4aZj7TrVGea/7qiZUuwKuCun4xoO6QqNatv4JRaUd1CDYxVL6CDH20T2IijHOpM8wUag87t74EsKmjhjZEpWEc9gzwFVMjlOkt0aqYfOb7+PUZ7SBzLVOGNkl2pMhHOSg4smq0dN6ewKgcbDfmfYcw6u+KUiZTcIh8Uz4lq2ZMOGx6zU0bwtxdaRF90dl3rhUQuv+Sd+a15I1Q7266TX58xmIY7L4vB+FEkpd6NfJbOzXFmgJMObYceUDuJjyai2Nz9OLHN4e3xQJedMtzTzotQ0IE1Htga9YG+Tv1dqK7WgvV3KKKwLmycd4CWwiR58oTjYkm5wNjuz32PWBYV12elKl9yXRC1kz6RB7YovfIyfSWgPBOsrkqhzgwxiwzQMIx34Htk87pFXkaROaZIqhvUXvbAt/SaQUVeKU5LYgHV6IIvIZD54wFOVlKmwUxxzEMnPD/h0SGEfMFJI20N3ZcZgtD1jgoHXM7fB+bZ39Htz8fMd1iak3CWvUwBoWAcWo1dVcd6HBRIpnvOsTY19s9W9Y8KYBwmHLipfIu43wH0VMu2q5RDymCkfStXEgiG1TINXrsWAGltZIE/T0HWbG3GF3Zm02ldJHEO8QuUjbvgNrEVuUSChszSHLWVH0Zkj8u80C0WSRLpQtDrWplPtsKVbdrtAIL/C4UJHbiJA84qt1/g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199018)(41300700001)(4326008)(66946007)(66556008)(64756008)(8676002)(66446008)(66476007)(76116006)(2906002)(122000001)(55016003)(86362001)(83380400001)(33656002)(8936002)(82960400001)(6506007)(5660300002)(7416002)(186003)(26005)(9686003)(38100700002)(52536014)(478600001)(7696005)(316002)(38070700005)(110136005)(54906003)(71200400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MMqvv9lX8DfALrqTBktzbO2c+vx8doS6qLbc+tIJyupJPb1Ogu9diKaZ5dj8?=
 =?us-ascii?Q?xhv0X+JszbTWjbZaLEawhwn7nZykTKcuO9aNToKuw33Td0ZhexV21yVkjlD+?=
 =?us-ascii?Q?tNOHb9QbpBV6DPp3a0qrWeXBtRNtLL60ts77lHEiE29bPYk7+ksQ4PjpNlTO?=
 =?us-ascii?Q?FF8Z1g1Jdj7YkR+ZulE5D3+74s1crNUEzoun9X868w0dkeLtShTtEDuDr2/O?=
 =?us-ascii?Q?JpcnGCTS9xiUAbmXsu7cJ47rDSPnwQgCQROJ2nW4aNHoT0gkgGrWRNJE8q0x?=
 =?us-ascii?Q?tye2g3JqomZ1urTRg5a1xovW7Wg7WrJFfD6m1xZE/+HeJQza4lSBoTfAN2LN?=
 =?us-ascii?Q?37BsyWri2obEiYa9Rx0NzYCy76GQYN5UrzCHlhJ+IJYN3HAj06sLdB4pGzOJ?=
 =?us-ascii?Q?6Ea5sflhvgMFiS2Owqw2v0hacoYtEt9dL7TrH4bqEdBJZqvgtFn341UmqkzQ?=
 =?us-ascii?Q?85+Z/hd0pDrvhssdzIxzYe62xHb0ihSUCjsL9l2TssZuOffTR3c5WkM/kpYU?=
 =?us-ascii?Q?2ByCpU9FhXjH4DRbM6FPdivjdueg10JtSUta6cN76CygC4FORQ+5V2raeSGs?=
 =?us-ascii?Q?Nf8TOsvttBbwNjUMukj1QvoTyiCgJeVCcf1g4V7TVI0OVWPvanGZL0jQVLgh?=
 =?us-ascii?Q?ISLUd0L6uwUdv7quOHtSf+hZAanz885tFnaUp7i5V8aI1pHmHXCwbTDerdvi?=
 =?us-ascii?Q?a/o2vPKYEIlAjM0NPhrhF0XCVrcUDRXWKS18Nfk61SKxe8BWcLCKOYu5IWjR?=
 =?us-ascii?Q?AYjAFCq362HuKeVHPE2YlSFuQPv5NyagbtZA57RJAxuPRleCwPSIinXzs7wc?=
 =?us-ascii?Q?A2paRB2wmCLupvLS0X9hEh3Z41IZRZ/ut5Dj37EccPY3tR2MZ9c4v+85GaXy?=
 =?us-ascii?Q?aJGRqM4k7fyCYw6h0cnO/21qU5BuDBcPB64rjyrJ1BdbQGGmexF6aD7kkJ/y?=
 =?us-ascii?Q?DAuttIuwYvQqHHnzdTX8is+nP/Cqhf2qyppV3pQ9lW0Q2Y8ocaHeQSN3uEEH?=
 =?us-ascii?Q?6FVa23Q66ujafv2rNIsRAtTns8qlv3e/yc0XT9z50cocV+RGLbQRtfLIb1f1?=
 =?us-ascii?Q?DMD/PDycJrrqyhdrhAajz4p0iDuZ+kXdfDQ2OjFoYOFLFD5IWsTlONwHUokK?=
 =?us-ascii?Q?BaJr2BXS5Tf72Y3hDAMM/pdvL8OWxPrLMDXnuXp2Zj5GnEPeZ0fSaxGeCOSn?=
 =?us-ascii?Q?92DDFjeQo/lIIwsQ6KpCv/5GgfAroh7p2Mg8YB/5q1oikRH4FNE54n8zQuT+?=
 =?us-ascii?Q?6X6q2acemtVLU0FB7rdTmk8tXoM+gRx3AE0AUcP3iiaUsaLG8hYd7Cn1njTz?=
 =?us-ascii?Q?DMCVxZ5jjk+9CpvXKNASIl0qdTJO9QIs4W6PqfwT1pGkKLF81PaRssnuEkK/?=
 =?us-ascii?Q?j5zxACC8+RJFefYlKJxA/daa5989JGurqLb6dhdses8QJ/dcD59J2KpFNQxO?=
 =?us-ascii?Q?xsBuJ1zpvCinT2R3HZucI8JH4uWP5HIpFDlMcT6LnGaaDf4hyhTAA6Ig1so0?=
 =?us-ascii?Q?GZV4OQS/pdYt3SWKXMqYyLnyz10xdGdxbKZR+SNkL5qLr0qCNJzZB3uEjr4r?=
 =?us-ascii?Q?9XMQDbvR/JbfoVo4N2JZRe4Kwj9hdpnoSv5w7QRi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830811e4-64ee-44f8-25e1-08db05eb0d36
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 13:32:10.0006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eOWyhbNkXAFLBtsk5ScOUuzT+x3cze8LH7JkVT3pmsJQGNlIIhh6MXLB6WLb4hvsG8/guqIclKjQjrhanMG5lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7799
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, February 3, 2023 10:00 AM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, February 3, 2023 7:13 AM
> >
> > On Thu, 2 Feb 2023 23:04:10 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Friday, February 3, 2023 3:42 AM
> > > >
> > > >
> > > > LGTM.  I'm not sure moving the functions to vfio_main really buys u=
s
> > > > anything since we're making so much use of group fields.  The cdev
> > > > approach will necessarily be different, so the bulk of the get code=
 will
> > > > likely need to move back to group.c anyway.
> > > >
> > >
> > > well my last comment was based on Matthew's v2 where the get code
> > > gets a kvm passed in instead of implicitly retrieving group ref_lock
> > > internally. In that case the get/put helpers only contain device logi=
c
> > > thus fit in vfio_main.c.
> > >
> > > with v3 then they have to be in group.c since we don't want to use
> > > group fields in vfio_main.c.
> > >
> > > but I still think v2 of the helpers is slightly better. The only diff=
erence
> > > between cdev and group when handling this race is using different
> > > ref_lock. the symbol get/put part is exactly same. So even if we
> > > merge v3 like this, very likely Yi has to change it back to v2 style
> > > to share the get/put helpers while just leaving the ref_lock part
> > > handled differently between the two path.
> >
> > I'm not really a fan of the asymmetry of the v2 version where the get
> > helper needs to be called under the new kvm_ref_lock, but the put
> > helper does not.  Having the get helper handle that makes the caller
> > much cleaner.  Thanks,
> >
>=20
> What about passing the lock pointer into the helper? it's still slightly
> asymmetry as the put helper doesn't carry the lock pointer but it
> could also be interpreted as if the pointer has been saved in the get
> then if it needs to be referenced by the put there is no need to pass
> it in again.

For cdev, I may modify vfio_device_get_kvm_safe() to accept
struct kvm and let its caller hold a kvm_ref_lock (field within
struct vfio_device_file). Meanwhile, the group path holds
the group->kvm_ref_lock before invoking vfio_device_get_kvm_safe().
vfio_device_get_kvm_safe() just includes the symbol get/put and
the device->kvm and put_kvm set.

Regards,
Yi Liu

