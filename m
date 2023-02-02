Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D08688A72
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 00:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjBBXFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 18:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBBXFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 18:05:16 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D407164C;
        Thu,  2 Feb 2023 15:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675379113; x=1706915113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9A02vOBtiyi0KjufMxU4bs/JzlS+rsSRuujCtM123xg=;
  b=lADa705+NDDkivyJTdvhElcTC6g9J+zEdcWZSU7s3pYJuDLNh6bnf5Rb
   WpJd89GwNymSNb32auC5Okgcmkt98g88m9TXnHdb+umaKPhj0vcXw9LzW
   8oBP2TLEAeYew9A8iHPUnTFcmaEOuFrb6lgana68fhOdnj7/LVRBM+wU7
   T1MUKuH7B1IwAT8No+j8D5Qnitks0qbr2T2+bG1qCKB0zLCqnKJxWCmrv
   oUEehZAWssA9Jt/ZE09umgRbchf2OYL56g9m1YhJNwa6mJ1RWPFAwZaGQ
   rDpoIE8F3r8mKlWooWAtWDplk6W4bmn3ef5mu2wuUIk/TQWDVRKLLB5NK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="414804349"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="414804349"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 15:04:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="665483741"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="665483741"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 02 Feb 2023 15:04:18 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 15:04:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 15:04:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 15:04:18 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 15:04:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIo/+Z0lHncQGQdIKRMwcykQ01sfAG+phimNaezi7RInqLjDzzMsK7S7MjAUjubTUjcuVYaFGOm+JILf/GUecSOHVNFGcK5wAMiiClxFhDtYhQ4ZoumodWm0E8nOunQkLPdJ9WS8eFy/P9eLA/oQcflr37y6UVBaJBDV4O0d2nQwtMkh9VsTtC6nhTotQEVwntu9EbdPamdrTVTJ0SQae2FiYdBL5bJQM0wx0oph08Sg554NrEemxh8a4svZ/0ybdRUKkwRmJmbgSsL66/HbEsPydWW+aof8GNnfIvNmd2ObmSdlNme6D7+DvaMptaAO0L/NMdROF4c9CR9fN1Y3Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+8awIdNGKhJ/VRiVk2p+jl2LL7bfVT3xbTIQSyHECI=;
 b=IjcLKXsnb2pH/1H+lzvE2UcTi9GaHJhZjHIwutqX3ZFRWxeksmGSPiTHit3dwSNpKe6rs5tyBCel6iIJhr/YsFhzzOZA0x0qAp4rJrRW/sSvlQkzY9ZbZp0QYbjr6zvAFX0VBeGzsMJ6LNyLMRDY3yOU2kBiV3jH3tbrFbDaJ8yORwpwcB6Ics0NId4hdkAbifLplYBlyU/+Jbj5Z9Q/qDcb8ok45EEGH/jdakvPrOY1+fu3LOWMGj4KI72L7NciptroluHxDClseW7ngMelUp+SIxBIRHKXq6cHQC4vDXjWugB/Qwqd04cx1aSIMi+CCi0H+ThjLwF4h/44gyQTKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7146.namprd11.prod.outlook.com (2603:10b6:510:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 23:04:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 23:04:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
Thread-Index: AQHZNyMj/DyFlYgOy0urx1B0EjoKIa68DpoAgAA1mqA=
Date:   Thu, 2 Feb 2023 23:04:10 +0000
Message-ID: <BN9PR11MB527618E281BEB8E479ABB0418CD69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230202162442.78216-1-mjrosato@linux.ibm.com>
 <20230202124210.476adaf8.alex.williamson@redhat.com>
In-Reply-To: <20230202124210.476adaf8.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7146:EE_
x-ms-office365-filtering-correlation-id: da9353e5-7eb1-41c3-4517-08db0571cb2d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OapXXy/fyjFpVymo+mcJaju3+SaFAg/XeMMX8XCEUjeNFQzNoQjFJEyOaYAQsNreper3TFkUxYaYUF2HblZlIr01jvzAXJKYakwHMEFgvLDuy7IbFhEpgbY8it9m0cHjc95PytsoLPskk5CeB/sbZmWzTPhexBVmDS0r2wjXLSe6+vcRNI0aGFsMCmBtv24InVmIIWzZx1pdZDmHYV4PTnOtycvtX/KPbdLUZifWm9bwvrermpZ25z6UxMYmc+BX2NkcetILKifapRvq+iFHkY10+GtkUYOnxlhCYyAqLEHtu86QvVimijc0Fry8XFETcHpVHHaGR+lwy89yFEHTkDgNPdnTacESo4JppMZCzqxM/lTlda+0KQUvoQTYe9eha7MErbsA28zp6JIYBlRNqzjOLX5IQibOHBrReTkN4v7aeAIm+51DE5q8u95MY2xSadb2Nrb02dTQaVy0o99MBqfguHLVoFsE9s5+47LkpWNvgVq3+oL7IlLSGGs6siwXsRvjcK6aFa1jn+SfX/LkbZi5WUJyYuxb+0qjk2zZRdwzqj7y7o1TQdCpVqKF6AGBWeQ/ZvsoXiIsLNeWpCVuVsPkPxTb36TWm0c3VHrwuOn7KInXs4b30EL3Orme3Zmn88uI26ixX5duzaC5528gCgRAT9cOAnrbYpTspKRiXkkC559I5u9c+zF6G07vzGdWMSzq10ydr6nFmI4SLamfIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199018)(76116006)(186003)(8676002)(38070700005)(38100700002)(122000001)(316002)(110136005)(54906003)(5660300002)(2906002)(7416002)(8936002)(82960400001)(66446008)(6506007)(66556008)(52536014)(4326008)(64756008)(66946007)(41300700001)(66476007)(83380400001)(55016003)(9686003)(26005)(71200400001)(33656002)(7696005)(478600001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zcNDVPKE6Lhp0zSTQtQ9dBUbmntlY+ONfpNFqmlMZxTDEsNRougQGGjPJ/ai?=
 =?us-ascii?Q?PLAuEnO2Rf1/GIcNF0CPLP32D30xO7y/BM41KN/ErVbdiRftETTe1Iy4bpb/?=
 =?us-ascii?Q?K5dK8doAew0s7OkqRio0c9z8hH5HMmXKSUP46wDcmC61SxECEtncasrDjnc3?=
 =?us-ascii?Q?+zdt5GUsy4soY9fn0lAnJiQH6i5J+WTVCawSDJvlUiuRb218Rchn4jyRA/Dr?=
 =?us-ascii?Q?mX36SN/AQpDL/yvjwbgQLWkvSTZEIKuhpapgEFIyHjuNZiHJ108raqxo7BHR?=
 =?us-ascii?Q?v51zssdRxdAuwzfCtQrNtDvdpnzaj0l06Zp0c7i9vFtj9y18Q/xKDFG7zZI3?=
 =?us-ascii?Q?g7RMeTSqExYOT7Sg+2JRUZ+MUCzGESd+47TlSPOk4tgiwLZB0V6xapLNVY5j?=
 =?us-ascii?Q?E9ZLbIz+RjgUsF0nt5Q/ICGX+12BIE98vpApmo8MIb7Zta4uob9RwVmzfYM1?=
 =?us-ascii?Q?jj9nMcMuWqWAnvfqIM9R8eQf8+1EAcajvmF1TuzLVXH9QHmme/SiQMu8clus?=
 =?us-ascii?Q?unuj0B8UXH6hNOH5Oq9uzWH5jMCdyPUj0IV2A1CQfFw6ZywJkQLD4Bcv7BFm?=
 =?us-ascii?Q?65txeOnxHG+CJJHreaaIQJGgJAEL64k9GbtZy32dpIiGTztP0ThaS0Se6359?=
 =?us-ascii?Q?tLO3oIJXMI6+kXpmY+mckF2n1WZQd+eZmU9pYXI/Yc2bg6GJtzMybHrbfucv?=
 =?us-ascii?Q?4Jy/kfXTBreaqfzRtDObeKwmqzG3wvRzjRRn/w5q+FMQO58EfwmGJ3Z60R/e?=
 =?us-ascii?Q?oOGEkRWoc3G/hz2PEAOi0e8YUrE/YqLM8jyrguHYee0fOtxXYUSr4Cpp2jnS?=
 =?us-ascii?Q?TLOUvy5vfhXT7YcF0ckta7mppFm/mVz5VlUCbHPdyKiyzohiFHxOCc7qTu/E?=
 =?us-ascii?Q?I/bPboJKI12nJCb4SN9dMtcD07mkHa8swaJRahF4gj7G+icglFQ5PZkK1SMw?=
 =?us-ascii?Q?PTysxpIIEuLXBjlxuOptMA0D32AplANrf+cDB0I3DErYPmUDYYVxhDMN8YWV?=
 =?us-ascii?Q?pSGqjuhd95XtXKeQhb1hzXffo8ambvOShG8w6XaRKDeLoVzYB2GjHm9XwhKb?=
 =?us-ascii?Q?d2cnc4fMIr5nULnEYLYyYShrw4TBLbRbuYIrB9rqJAH/lv51UW+i5MAS31CN?=
 =?us-ascii?Q?rXhCcR3GO+nd7gteYVYkQC7RDIpEqOSo8yn1lqkqWZ/vk0siOo5QSttmsXgP?=
 =?us-ascii?Q?OY4Y7Lj+Yxe39TMFi13lQ2Yructt4LMc3q1LFvxpSBdxr4h6lixUSC9McrIM?=
 =?us-ascii?Q?fLPBUxpbOkC1m5vTirlJ6WITMvJUg6LCusBpQJRkip2ddZpIzligc/wPQ3U8?=
 =?us-ascii?Q?kq/pIoZe5kLeHS9zI0rZ6+tsMX/iOnA4s7LpqJMygnCBeMkIAE1+oAOZzzGV?=
 =?us-ascii?Q?R0Hj/vsRnKzacJ9YH/KoDGj2HJLMHEGA35Qb2677ee5i0Cz8SLRIFMqdQryW?=
 =?us-ascii?Q?s5KHuYbsXuo/+hMSRDXE/idxmAH8mSNSqaE8TYuokkx28BEdfaud8zBcAYu5?=
 =?us-ascii?Q?rmSIf7dIoaaKoaUGMqf4MZ6KdbCbbqnJkYXtJrMpFQyusVYOGWDNPl15Nviq?=
 =?us-ascii?Q?SbSnY15c/Zg6oBFs94MUZYepr+Js2zyD18s2yIHm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9353e5-7eb1-41c3-4517-08db0571cb2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 23:04:10.0617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6O95gKukaSnRu6TBdcPRyB1SEXbO/HiRqbehD7aBKeOo1NIVzUluFHzHIDrZ7oz8bT5C36t9DQx1Ac0FlnSKDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7146
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, February 3, 2023 3:42 AM
>=20
> On Thu,  2 Feb 2023 11:24:42 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>=20
> > After 51cdc8bc120e, we have another deadlock scenario between the
> > kvm->lock and the vfio group_lock with two different codepaths acquirin=
g
> > the locks in different order.  Specifically in vfio_open_device, vfio
> > holds the vfio group_lock when issuing device->ops->open_device but
> some
> > drivers (like vfio-ap) need to acquire kvm->lock during their open_devi=
ce
> > routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> > before calling vfio_file_set_kvm which will acquire the vfio group_lock=
.
> >
> > To resolve this, let's remove the need for the vfio group_lock from the
> > kvm_vfio_release codepath.  This is done by introducing a new spinlock =
to
> > protect modifications to the vfio group kvm pointer, and acquiring a kv=
m
> > ref from within vfio while holding this spinlock, with the reference he=
ld
> > until the last close for the device in question.
> >
> > Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lo=
ck")
> > Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> > Changes from v2:
> > * Relocate the new functions back to vfio_main and externalize to call
> >   from group (Kevin) since cdev will need this too
> > * s/vfio_kvm_*_kvm/vfio_device_*_kvm/ and only pass device as input.
> >   Handle new kvm_ref_lock directly inside vfio_device_get_kvm (Alex)
> > * Add assert_lockdep_held for dev_set lock (Alex)
> > * Internalize error paths for vfio_device_get_kvm_safe and now return
> >   void - either device->kvm is set with a ref taken or is NULL (Alex)
> > * Other flow suggestions to make the call path cleaner - Thanks! (Alex)
> > * Can't pass group->kvm to vfio_device_open, as it references the value
> >   outside of new lock.  Pass device->kvm to minimize changes in this
> >   fix (Alex, Yi)
> > Changes from v1:
> > * use spin_lock instead of spin_lock_irqsave (Jason)
> > * clear device->kvm_put as part of vfio_kvm_put_kvm (Yi)
> > * Re-arrange code to avoid referencing the group contents from within
> >   vfio_main (Kevin) which meant moving most of the code in this patch
> >   to group.c along with getting/dropping of the dev_set lock
> > ---
> >  drivers/vfio/group.c     | 32 ++++++++++++++----
> >  drivers/vfio/vfio.h      | 14 ++++++++
> >  drivers/vfio/vfio_main.c | 70 ++++++++++++++++++++++++++++++++++++--
> --
> >  include/linux/vfio.h     |  2 +-
> >  4 files changed, 103 insertions(+), 15 deletions(-)
>=20
> LGTM.  I'm not sure moving the functions to vfio_main really buys us
> anything since we're making so much use of group fields.  The cdev
> approach will necessarily be different, so the bulk of the get code will
> likely need to move back to group.c anyway.
>=20

well my last comment was based on Matthew's v2 where the get code
gets a kvm passed in instead of implicitly retrieving group ref_lock
internally. In that case the get/put helpers only contain device logic
thus fit in vfio_main.c.

with v3 then they have to be in group.c since we don't want to use
group fields in vfio_main.c.

but I still think v2 of the helpers is slightly better. The only difference
between cdev and group when handling this race is using different
ref_lock. the symbol get/put part is exactly same. So even if we
merge v3 like this, very likely Yi has to change it back to v2 style
to share the get/put helpers while just leaving the ref_lock part
handled differently between the two path.

Thanks
Kevin
