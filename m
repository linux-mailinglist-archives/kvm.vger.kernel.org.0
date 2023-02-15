Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B63369762C
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 07:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbjBOGMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 01:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBOGMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 01:12:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7276A2B09C;
        Tue, 14 Feb 2023 22:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676441555; x=1707977555;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rKSvii4izCbFzLd59KlxggAFJWuGL98rnCfBhB7n35M=;
  b=c7U+kqoJnGVSWmW/t/hLofdKgX2OzIiDwpY+yHaobCdlXOI+96YdgN0y
   fKcsQbFW1nEaNeKQVaL2FLN/hC8a6r1VMf4vuP4ybochM47Dxuo39yv0y
   FP+oYhgNOj2zJ6pCPWhVc9Jka5cwIKP0OMvuZVSWcWx+axcG17FCcjJyz
   foo+i2qcw3az8aWfOFmeFqlSJ9mcAYXaaKbTKJ0E0vhy5isDMuY8ESIgl
   4l2hIyl5uHYAnJ/VYF18vx6q2GZEsFaVUckm4bj8qwmgdNBDaFVv9jo1U
   siyELOquXXVoLslY+ppTFgTQ+VT9vApnzM59GtwO55/f3nHK7bV/KFCq4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="333491479"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="333491479"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 22:12:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699834180"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="699834180"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 22:12:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 22:12:33 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 22:12:33 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 22:12:33 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 22:12:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjLMV7rHu00EmKoj40MWGWBp030IX0SswjRP/qzcAouyf/iCNxIaM4WlKi7VsUdMQXM2DY+oH7Ga/Z5L3GwIhnI6YRanl7kv6dfvb64F5oDL8anl60SIyBF1ryfOjkQ+IZ4yDaqnz32XPT8wC1rwRZtMGGeeTRGHTEr/6uGGCE++ckZVTrhyZjPzVUU5PWrUfUguP2tzwG8tBHmknDKCPGT6rJctCNQBx79dGQnIcIOAuJxRhXzhcp1LXncxKaomfyg4bHScB9zbkIX/ftRQGUsjiIFowVK2PvJKyLrIA8ztq+ht+IRyvQRVPFgTzHEggW7kXUu/cUKsR421Y5wN0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJdhwP11DA/ZpHvH4BdevvQiUtOCzbgYkw+fKHAhrOE=;
 b=k2vfvSbrQpDLGCySe/+9hqXzWtX4WDYLISsutHvs1s0HbSauZ7Yz9kMRwD8xNakfqLdEIQACxrbbrELKlaJfqqydvhBqFY3vAnL3nMHkiuGZBoqCN+6THrFGtb+YP3T5WRJoDVsgl49jjBgqyqRQX42YT6Ri+MmT3++8eOXRznZPUy+1dBhVL+s3J2NQERI0CnDyTFLndcYqKNfozLmjg+CHl2B4MA8oawNORiZBXCW+YUycnQMdeiP3INpUK31WCvcaGqSL4fO5xYqO93S/NTwCJ3MWHbq5pHFx+uOeSPncU61Ru1LHk0/cKGI58RWvdd1tr4W0w+FxDSZMH1ENUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6465.namprd11.prod.outlook.com (2603:10b6:208:3a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Wed, 15 Feb
 2023 06:12:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 06:12:25 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 07/15] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v3 07/15] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZP73RyMfaLAQfAUi7LXLQMyKUc67PDOQAgAB8WnA=
Date:   Wed, 15 Feb 2023 06:12:24 +0000
Message-ID: <DS0PR11MB75295428ED6DC4246288006DC3A39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213151348.56451-8-yi.l.liu@intel.com>
 <20230214154634.4bc5dcd6.alex.williamson@redhat.com>
In-Reply-To: <20230214154634.4bc5dcd6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6465:EE_
x-ms-office365-filtering-correlation-id: 121778c2-7343-4e37-bb9c-08db0f1b9b6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7SKd8foVYXRNR6qBlRcEMAN9uwDJ/oUHre9EXDsf4gpc9+cxvFOHudj3FomUV+QQbNUthXHAL7U6WcNlXPL7rj5ELn1flXiANp7mve0eD5QfzSnNFWRepLuYRqEeBNUTJYv9feuIDmx8NDPGzH72w+HhtYIZtoko+E8m4vlsAXZwdwAGysVdFaJpe53EE1klwOdcqWaTLagJ7YGTqp1DtwHI0DbeDCWjFd93LwPHlwoQquZ6qjpMpGYLsuHAASr1PCYxxR3XkFPZyvIU1iTpRQYe09XuH01oPfrZkkXrtS5zJrJ5dXP0ai9pnNsKALwzroFecykugUG3LXnUxwko42YaH3BCQi/lU1pt9+1hlqEcp9/mX0aZ2/qeJ7u3Nh/N30PW1l0tATksIkg49vL08PZUynu48xeJNPEPJ4c2sReBMgs+v+D52mfEQovdpUIGqK0XzvzwYJPssjpXUV7Lm58nKvlarnjTLdzZ1KRdL9dKAq07KMQkmk+e3Qkd7StgL8nL2MyTlRv+p7uGqgr6eGA5y54zH0Q/hNktO0VKaHTA3DgdPDobDRKf4PtSOeKCSReI31B9f1sf2zzRqiIeL4jx77KxnkveOvIVpQ0bnCWLekWPh4x3sS+zC04RdulIEpiHsOYaUYhkIKwzaDMYYsLuMw/DPQvAQK9YES+aY6WYAzuHCC1iSapZ53uk/pXtNqLokJ9+IXxKepR+z8xOTZWs+vn6aVk8mTrfuICHICI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(7696005)(9686003)(83380400001)(2906002)(71200400001)(8676002)(4326008)(64756008)(66556008)(6506007)(33656002)(478600001)(26005)(6916009)(66446008)(186003)(41300700001)(66476007)(86362001)(5660300002)(38100700002)(38070700005)(122000001)(55016003)(54906003)(52536014)(316002)(8936002)(82960400001)(66946007)(7416002)(76116006)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3k6lHfrotg/HMCGbjOi0RqC+L7Z/l04qUzeOgM5z99Eh7HYL5rcsi5ZoBTS1?=
 =?us-ascii?Q?HXWxO0zVVrrBfnJrSprylqovSL/BBWH48UFSIpbrsg/EOtB3u4Pkb3U8UKKS?=
 =?us-ascii?Q?GlfhxsDnBeHcxCPLE8JYAYyjXfy8BzebI4msNUyBRFqHnI1NGX8ZApHP9iw3?=
 =?us-ascii?Q?GZE12DbcV+JU8Z9izTMgasszUHKxDzAjjKA2Dp7JZ2GXXtAPi+MpZRAjgS/e?=
 =?us-ascii?Q?yOSJc+EYVzd0UQL1lpE566bWXFpZ8fXHYxyka4M60T6dvTk0QawQy+XVBgOB?=
 =?us-ascii?Q?VU9Ssy2SOe/ovTITP/+zlPn5yb4tcmafMObt0RoC6rauCws67w19Qc16mGuz?=
 =?us-ascii?Q?pRYv2AxEb36x/QrSMaECJjQcIuklIPpye9gR6GuJPlZAHUDfIWucg9sTegho?=
 =?us-ascii?Q?WljCnF5DdMV/DceEKG3+o2mlKABahhLdCQsz3+pK9BWL0AtPlfw0T+lBSjYJ?=
 =?us-ascii?Q?sTkpPilju4ZugaZWIf5yKcn7umADm9CDoq+4uiW8Gswa5schOHjWgVnhv5Bv?=
 =?us-ascii?Q?L9OPxJBEiUnDFvoO4XoCldG6hE9GO9V4s0BaDfrUIW2ce9ydiihPLC9+pysN?=
 =?us-ascii?Q?RO5TJO0wZoYJrLoxUbSUA4nHyGNrwe/3iSm5srv/ATNhZMeAvv5ESx9DwXs9?=
 =?us-ascii?Q?J0CHkrLxmo0UH8txR1q60rZGow6bidA+QZY5XMMNx++si4GbtDJwi4J5k0i3?=
 =?us-ascii?Q?4VCBUFhlri/WLHVMS/LQtFE9nnVezIeAdH/FGOCUTfJF/n92ZWvcQVxZ9zgp?=
 =?us-ascii?Q?xAtCEM1lEU4M3yGxufBDSkLE3rmUGbJyPuDmhNYbdiCnir+zkC6dUvpZq9ow?=
 =?us-ascii?Q?+dgGPiGEIzpYo8oavGP3RsW95mo/euipW/jlEPUaOzSvbesX9AIEK4+9K5Lb?=
 =?us-ascii?Q?siFM/NYKqwCzC4EmW9I1MtWLZqb7Pwfap+zziMQ2XQqYOx85nXOqv/7g4LYv?=
 =?us-ascii?Q?SiBAC+Hu85vgnWpwQ/ctwCr9Fn9GTGkISCRLYPXzVczQdtAhPxjmy4n7Fmfv?=
 =?us-ascii?Q?iN5eLSD3YtmdCzWux4y1oJPzcWKrCb945M4iH95RL7P4zWAtOVGZc7KTp/lW?=
 =?us-ascii?Q?S5HIGT2LYxEz2wTVTn2DPdkTLPDCJ6ew/5IX5Kpgv5/+Ks5tkh9ZUaRtB1v1?=
 =?us-ascii?Q?F1DEfP2Rprzv4hv+CkPZQmAvLtTWLg6V1x5c5WhD7FWcom4k/HXYY2S54jQh?=
 =?us-ascii?Q?adnkyRl+P729ExrJIF11qmnFJnZyFvBefEK6N6hSTz0PbEW2BSmYzOqZaAyU?=
 =?us-ascii?Q?d4kkQQj7djV1ITidUZX0mN6erjEAyxt0r720SC53a6oKpKI8d+PIyk15J+T+?=
 =?us-ascii?Q?xS1NNl53OUWUbuTXb1LlrtClMbs+Kta/MAMRgyp0/wPlNANjtwCeKkFi6XhS?=
 =?us-ascii?Q?WuVXIJ/GrugGI06KBKM6MbDv/XPt1iwcHqdlf+AvCa+GrzHKNbCEAWT89d7H?=
 =?us-ascii?Q?XQYwwdp7CO091pWhp2Xg4xLuAJgiCWDiVsmMZuWcrsEoU9D7JJWzG8TXrBa8?=
 =?us-ascii?Q?S7r8cQfDacq7pahJMmGqZjpk9+iSSmBWFtct4SNWoZEXO82kpj3IDNV0ujHx?=
 =?us-ascii?Q?XG/UKGlKvGonP1W2UYW9g6fwbEHeCqVGsTg8YUh6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 121778c2-7343-4e37-bb9c-08db0f1b9b6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 06:12:24.8716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sRgq+R4ppwxO0/eaq4rc21+WfH/Vn9ihD3uJxPtkWjRO5RUzMquPLHW0N5R/xjW3NoYUwK8S3MTPdjdIIrY1Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6465
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
> Sent: Wednesday, February 15, 2023 6:47 AM
>=20
> On Mon, 13 Feb 2023 07:13:40 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > Allow the vfio_device file to be in a state where the device FD is
> > opened but the device cannot be used by userspace (i.e.
> its .open_device()
> > hasn't been called). This inbetween state is not used when the device
> > FD is spawned from the group FD, however when we create the device FD
> > directly by opening a cdev it will be opened in the blocked state.
> >
> > The reason for the inbetween state is that userspace only gets a FD but
> > doesn't gain access permission until binding the FD to an iommufd. So i=
n
> > the blocked state, only the bind operation is allowed. Completing bind
> > will allow user to further access the device.
> >
> > This is implemented by adding a flag in struct vfio_device_file to mark
> > the blocked state and using a simple smp_load_acquire() to obtain the
> > flag value and serialize all the device setup with the thread accessing
> > this device.
> >
> > Following this lockless scheme, it can safely handle the device FD
> > unbound->bound but it cannot handle bound->unbound. To allow this
> we'd
> > need to add a lock on all the vfio ioctls which seems costly. So once
> > device FD is bound, it remains bound until the FD is closed.
> >
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > ---
> >  drivers/vfio/vfio.h      |  1 +
> >  drivers/vfio/vfio_main.c | 34 +++++++++++++++++++++++++++++++++-
> >  2 files changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 11e56fe079a1..d56cdb114024 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -18,6 +18,7 @@ struct vfio_container;
> >
> >  struct vfio_device_file {
> >  	struct vfio_device *device;
> > +	bool access_granted;
> >  	spinlock_t kvm_ref_lock; /* protect kvm field */
> >  	struct kvm *kvm;
> >  	struct iommufd_ctx *iommufd; /* protected by struct
> vfio_device_set::lock */
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index c517252aba19..2267057240bd 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -476,7 +476,15 @@ int vfio_device_open(struct vfio_device_file *df)
> >  			device->open_count--;
> >  	}
> >
> > -	return ret;
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > +	 * read/write/mmap
> > +	 */
> > +	smp_store_release(&df->access_granted, true);
> > +	return 0;
> >  }
> >
> >  void vfio_device_close(struct vfio_device_file *df)
> > @@ -1104,8 +1112,14 @@ static long vfio_device_fops_unl_ioctl(struct
> file *filep,
> >  {
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> > +	bool access;
> >  	int ret;
> >
> > +	/* Paired with smp_store_release() in vfio_device_open() */
> > +	access =3D smp_load_acquire(&df->access_granted);
> > +	if (!access)
> > +		return -EINVAL;
> > +
>=20
> Nit,
>=20
> 	if (!smp_load_acquire(&df->access_granted))
> 		...

Got it. also updated other similar lines.

> Thanks,
> Alex
>=20
> >  	ret =3D vfio_device_pm_runtime_get(device);
> >  	if (ret)
> >  		return ret;
> > @@ -1132,6 +1146,12 @@ static ssize_t vfio_device_fops_read(struct file
> *filep, char __user *buf,
> >  {
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> > +	bool access;
> > +
> > +	/* Paired with smp_store_release() in vfio_device_open() */
> > +	access =3D smp_load_acquire(&df->access_granted);
> > +	if (!access)
> > +		return -EINVAL;
> >
> >  	if (unlikely(!device->ops->read))
> >  		return -EINVAL;
> > @@ -1145,6 +1165,12 @@ static ssize_t vfio_device_fops_write(struct fil=
e
> *filep,
> >  {
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> > +	bool access;
> > +
> > +	/* Paired with smp_store_release() in vfio_device_open() */
> > +	access =3D smp_load_acquire(&df->access_granted);
> > +	if (!access)
> > +		return -EINVAL;
> >
> >  	if (unlikely(!device->ops->write))
> >  		return -EINVAL;
> > @@ -1156,6 +1182,12 @@ static int vfio_device_fops_mmap(struct file
> *filep, struct vm_area_struct *vma)
> >  {
> >  	struct vfio_device_file *df =3D filep->private_data;
> >  	struct vfio_device *device =3D df->device;
> > +	bool access;
> > +
> > +	/* Paired with smp_store_release() in vfio_device_open() */
> > +	access =3D smp_load_acquire(&df->access_granted);
> > +	if (!access)
> > +		return -EINVAL;
> >
> >  	if (unlikely(!device->ops->mmap))
> >  		return -EINVAL;

Regards,
Yi Liu
