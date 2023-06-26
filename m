Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409A573E282
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjFZOvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjFZOvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:51:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2287410EF;
        Mon, 26 Jun 2023 07:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687791096; x=1719327096;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8/vz1KQ5TuzmRDZ8vbly3Nmk5Krsz1jRPeF8kkS6vYM=;
  b=k1pgrjSCh/kvZueEPG3nv0lGAHe3KwjZKZEvGrAYXc++Gxg4QgiOVD2p
   RadZZLqlZuNRgNxv1bLlgqdgs7Iup+hjTe7Y8tYR6CuqNPDqM7/tjrfNh
   f7pzqGlOZaMJ9RsNwehkSBZsQ/HHWJDqAxumI59MOG9wNeFDKnIG7LjBR
   4UVoj+dyhkbB9mQW7viVmzPrQ5JwN3ImCTGiQl4wPFmIQIPvIoOVRYKuH
   Wp2S2uNQVENcgqgzNkN5z3M64JtbPFVsLPEBpbxRcBeuYjm0wqCalDqEX
   /sXHiNltJ4QjwMIolGaS4oCK6pzUu0DHmW400m8fMWNMF4OYf52YYxLNP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="358783408"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="358783408"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:51:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="840297921"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="840297921"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 26 Jun 2023 07:51:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 07:51:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 07:51:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 07:51:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 07:51:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7RBWoFp+GK3VV3DAjG5BSEo5KVZYEFeNuvzd6/i/7yxsMTfEHu3SwbZxArT7P2YXjokjPa670JZLeLe5agkPPk2OpCFi+c6JKJCk8NB3QiE41YYIkGtTCPIKrZuNk2kjt0GNWXpPVb6CPRof02JfgsaXbCjkVyTGhndpNWxrxj9KEtPMB/Ubx1taY9zFbI+ziC/HaB/m4GuC+g19VxPr33Sjkgif3CYeLLu9DJbdUPfvgoE353lK2oUWDk4xTQ4+ZwlwxYNaLUIc73MGnnek0pT0NOY+HfEhfa4zmDqJwur3kfdUiyiYmjdfoLXUNS6ecea2D96weBME7X6b4CGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=est8SZ8VFuwsBAle86L68sLH005vqXNRZPBCPR8r54E=;
 b=Wa9zr1ccnVcRdGhR+NCGfIjWVZdTWz0ak5POhP547lkzFDSZpzqxe4WRwfy+Iprn6s7+EklsBLMNrtECjgt3rdVfT5HubwSJ5FXHJ4Z9Jmyd98bA1u7LYlPmnDfu83zq0FxUU3yO040R7sSphsXY7dP/KhK1vT6a3+DVw7XHdnaQaqWXuENYVI3Pw7xAlycrES1d89fU7wbRur10YXHeAQjvLbFPnzu66v8YOWoEg+59wionkmJrFFYrQa+a5t4dDlsuccnzzBsTbeoEQ+lBhvbiWAWB3Izee5ay/m7WJ+s9nv/5XZALirBZGzhUnlKDkGPujI/9lwPtQO5soV5RKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA0PR11MB7257.namprd11.prod.outlook.com (2603:10b6:208:43e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 14:51:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d%3]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 14:51:29 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZlUw0PINbjPidUkeXtdGCTAzTl6+YsS6AgAQ157CAAEl6gIAACkuwgAAVLOA=
Date:   Mon, 26 Jun 2023 14:51:29 +0000
Message-ID: <DS0PR11MB7529790B9BDCB83BAA20DB77C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-19-yi.l.liu@intel.com> <ZJXFEbmY7BOW6QIe@nvidia.com>
 <DS0PR11MB752904E31251E05619A442B9C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZJmK6ensADJS/kms@nvidia.com>
 <DS0PR11MB75291F4581566C7B78DC110CC326A@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75291F4581566C7B78DC110CC326A@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA0PR11MB7257:EE_
x-ms-office365-filtering-correlation-id: 8ace1e90-72b6-4bff-ba7a-08db7654d2f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mBTTXqX0fXv61YOIjy6rHs9qrlbRjNa/fUMkVnS9bUG/Zmu4bOwVFWHOChuKKGCJqYU7QgWOqq9XVI8fXJmr2zkLFvYwNkqzTEA9AKDwKhsiNjU4AGB/xq6jcDZioP+KerW23smqrBWsMVEXdr+8cNoIn6mnlvi9PJ5hpkeWvsxAswUXzHkygVV9DVOl4NYgy8GNurq3Kg0DUY6wq9NUGMeKCh709EsH42TW6SxP9Rzckwls983yxaMF2qXUSvJ8OUf0S7vGef86ZqYAQkGTcyS4gaEKpsFqFMzwYSYXQuobvIqjyb+2BOrO+AjeE4id78th/TgdqfDnhqHKbtwKm1z5m+S67D64cjmSbNce5tkE1Uvd3H5VSi3z9OGYMaBynVsnAHCa85zlSxIjiw1f3vEAtv51kkqSy2sUvS7+su68xK+rjWlhFVnC9n2v2SDzBHnt06Adv8098zpKzmCNzcbvr3dVx17IxjTqeAmcQ4nmEXZ88l5u5Un+f37OQqh76VYofr0zCFKEIrfWMbwDLpNv9tBwnAA+R4H7MAX7ZNpd9LjmPfOtJwefZAwZr+Hs6IDZyNSuSAYfDORvoefTqSXsBujXqW+l6l/qhKh0l6aMcxpTRN3YkuVDlwY/1EJl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(9686003)(478600001)(7696005)(71200400001)(54906003)(83380400001)(26005)(186003)(6506007)(2940100002)(66446008)(2906002)(5660300002)(7416002)(52536014)(33656002)(38100700002)(122000001)(4326008)(66946007)(55016003)(82960400001)(76116006)(316002)(86362001)(8936002)(8676002)(41300700001)(6916009)(66556008)(64756008)(66476007)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Uvte/HUR8ACLFD/5jt4rMvPCkO24XN261eSlJ9DhYTZr5Zi9u7RBu6zZY7dN?=
 =?us-ascii?Q?HhXIFVt06EP2cPH7kro9Gspb+7azyZ7DLZW0+1gLJtVlCujZg24BuI2vhRQX?=
 =?us-ascii?Q?7H9LmE5Jj+r4ry7MYK3u2BPextqiegCZyQqBSxCD7DWEfr/Gu+fe+4M2dcfK?=
 =?us-ascii?Q?6zf4+bYeLMfiYYF7YLC3jOURhvthOAZCk4pmoAlLjVJ3LX/24SWrOfaVP7kP?=
 =?us-ascii?Q?Ee2PtQ4M4ptKEKhBWMzuWqVJD5016UsctCDRl9NE8Ob+Mhg2ReTbcI8Ljggo?=
 =?us-ascii?Q?QDjOwxnOQCnrhVoSqv0VTMS/kTAPyVnF53HFBTVKtO79FKA9RrLxSCnnzFV9?=
 =?us-ascii?Q?CggeIrBrsEIXKZTXG3Bby3kr7+VJ4noFoEGtCqXOz/MgsrIBsZA1ijna46Qf?=
 =?us-ascii?Q?R+0dQr/pcVHHhiz0pgbReisrm0N+BKSFF/Z6V8MSuNoewga7zGbCx3Xy4PGK?=
 =?us-ascii?Q?TUF0ObudIGGrBgKqMCVU5BsJ7dvOQFj+tmX6CDJxmJh7sv2b50si9YGv4QP0?=
 =?us-ascii?Q?jFRczbXZmE4tBUCiY8Qlpk5kZ2TcI/FIQBHnW+hEIMkSojLcEXAJLB68aaFp?=
 =?us-ascii?Q?q1hwHDrYx+i+uEZ2hpa6R8/7zNI2tVLtHCFnlLH528nXHkF6YKPubHEl82b5?=
 =?us-ascii?Q?hdDqtD5YWV8QHLo0PaJKeKBIhya98za9kCifbk7MIpNEswF8aqy93SgPoHjF?=
 =?us-ascii?Q?ScqDJRbKahCakowUOKXAQT/X3XgJvQiBazGdv14OOgk0zJ2heYRjDywk89LX?=
 =?us-ascii?Q?n6rhbhrJ/UENWA/+XEliDMWq4oArcvsv/Wge/NL1E3U9/pPdI9qiluaMyBxE?=
 =?us-ascii?Q?E3cQ51AkrkoSUj5/PuQL685g9w3wXpc6q/51B5lhRJZgiIq/yfqQzCYnSqEa?=
 =?us-ascii?Q?W3PP3LVMpD01g5a/JGiV3zpY6QLjqnDWo++aXHmuCW4RoK6mc3pr205ihUyF?=
 =?us-ascii?Q?rgUdOWWKlonqhYFF3OWUjt9ghQ8byZWyY86wLqszX0Bm+VihogDlQpZnYiBF?=
 =?us-ascii?Q?Cz39EUX6bfcv9q7yTuW1MpHIWOnvipD8rzbari38qH+NDai8xO+JPLmWSx/G?=
 =?us-ascii?Q?ui99el0D+gZbbBMUtJNFOgeqwcRZevNltpy2ttVC12lk9ARwM+C2J+etbkt8?=
 =?us-ascii?Q?hJdEumkwPxjgtZfPIRhmvP6RP1HWzBT7eZ7g3LEkoV2uNTH8G93AtMkTuWNq?=
 =?us-ascii?Q?Zbun69uh05QKI+oLTSy+NHdxXt4lBCdsPswJK6LY+l64hFcjDdbzSaXzo1Yy?=
 =?us-ascii?Q?R4+HA97mUmEKiUqll4v1KZvcLZvUAKviz2rGBdRfVZ5crsjY8bemDATO+A/G?=
 =?us-ascii?Q?2rK+sjzUQ/QiaN8tjm5NPbC76emcidnZFdsjBTfzR+1D8qI/HD2UniPhYxDV?=
 =?us-ascii?Q?iPN+4WuQElSirM6p0RU6uv1h7inPDCMcb+G2KOACpdOA0Qc6osj2YSOlSPGX?=
 =?us-ascii?Q?iiAFPSMXrKjgMPTMa0INUMtQPoeLTQBH+CBSzOJIzLdJfYGzQd3aSBoY6Pf2?=
 =?us-ascii?Q?fnROW+Pv3Slt5IBpdVO7MQIRyxlB2AiaWjLBa6S7oe3GDBsxIqXemceeRf0m?=
 =?us-ascii?Q?xk9mRGyiSZVZuyQmxEI70GUQ2R4gI5nDFfIr5i7N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ace1e90-72b6-4bff-ba7a-08db7654d2f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 14:51:29.1497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HlHmurwn/r27p7thkBW0SJ0/85rTK8Ryvd4QLY4fYtGlbDPROkv/WG44UKh07/nuMSnodN1luxkvSzJJqoq5MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7257
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, June 26, 2023 9:35 PM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, June 26, 2023 8:56 PM
> >
> > On Mon, Jun 26, 2023 at 08:34:26AM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Saturday, June 24, 2023 12:15 AM
> > >
> > > > >  }
> > > > >
> > > > > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df=
)
> > > > > +{
> > > > > +	spin_lock(&df->kvm_ref_lock);
> > > > > +	if (df->kvm)
> > > > > +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> > > > > +	spin_unlock(&df->kvm_ref_lock);
> > > > > +}
> > > >
> > > > I'm surprised symbol_get() can be called from a spinlock, but it su=
re
> > > > looks like it can..
> > > >
> > > > Also moving the if kvm is null test into _vfio_device_get_kvm_safe(=
)
> > > > will save a few lines.
> > > >
> > > > Also shouldn't be called _vfio_device...
> > >
> > > Ah, any suggestion on the naming? How about vfio_device_get_kvm_safe_=
locked()?
> >
> > I thought you were using _df_ now for these functions?
> >
>=20
> I see. Your point is passing df to _vfio_device_get_kvm_safe(() and
> test the df->kvm within it.  Hence rename it to be _df_. I think group
> path should be ok with this change as well. Let me make it.

To pass vfio_device_file to _vfio_device_get_kvm_safe(), needs to make
the below changes to the group path. If just wants to test null kvm in the
_vfio_device_get_kvm_safe(), maybe simpler to keep the current parameters
and just move the null kvm test within this function. Is it?

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 41a09a2df690..c2e880c15c44 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -157,15 +157,15 @@ static int vfio_group_ioctl_set_container(struct vfio=
_group *group,
 	return ret;
 }
=20
-static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
+static void vfio_device_group_get_kvm_safe(struct vfio_device_file *df)
 {
-	spin_lock(&device->group->kvm_ref_lock);
-	if (!device->group->kvm)
-		goto unlock;
-
-	_vfio_device_get_kvm_safe(device, device->group->kvm);
+	struct vfio_device *device =3D df->device;
=20
-unlock:
+	spin_lock(&device->group->kvm_ref_lock);
+	spin_lock(&df->kvm_ref_lock);
+	df->kvm =3D device->group->kvm;
+	_vfio_df_get_kvm_safe(df);
+	spin_unlock(&df->kvm_ref_lock);
 	spin_unlock(&device->group->kvm_ref_lock);
 }
=20
@@ -189,7 +189,7 @@ static int vfio_df_group_open(struct vfio_device_file *=
df)
 	 * the pointer in the device for use by drivers.
 	 */
 	if (device->open_count =3D=3D 0)
-		vfio_device_group_get_kvm_safe(device);
+		vfio_device_group_get_kvm_safe(df);
=20
 	df->iommufd =3D device->group->iommufd;
 	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_count =
=3D=3D 0) {
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index fb8f2fac3d23..066766d43bdc 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -340,11 +340,10 @@ enum { vfio_noiommu =3D false };
 #endif
=20
 #ifdef CONFIG_HAVE_KVM
-void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm=
);
+void _vfio_df_get_kvm_safe(struct vfio_device_file *df);
 void vfio_device_put_kvm(struct vfio_device *device);
 #else
-static inline void _vfio_device_get_kvm_safe(struct vfio_device *device,
-					     struct kvm *kvm)
+static inline void _vfio_df_get_kvm_safe(struct vfio_device_file *df)
 {
 }
=20
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8a9ebcc6980b..4e6ea2943d28 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -373,14 +373,22 @@ void vfio_unregister_group_dev(struct vfio_device *de=
vice)
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
=20
 #ifdef CONFIG_HAVE_KVM
-void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm *kvm=
)
+void _vfio_df_get_kvm_safe(struct vfio_device_file *df)
 {
+	struct vfio_device *device =3D df->device;
 	void (*pfn)(struct kvm *kvm);
 	bool (*fn)(struct kvm *kvm);
+	struct kvm *kvm;
 	bool ret;
=20
+	lockdep_assert_held(&df->kvm_ref_lock);
 	lockdep_assert_held(&device->dev_set->lock);
=20
+	kvm =3D df->kvm;
+
+	if (!kvm)
+		return;
+
 	pfn =3D symbol_get(kvm_put_kvm);
 	if (WARN_ON(!pfn))
 		return;
