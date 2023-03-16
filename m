Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13B56BC500
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 04:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCPDzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 23:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjCPDy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 23:54:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB6337F3E;
        Wed, 15 Mar 2023 20:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678938893; x=1710474893;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/g5fwUl1E4FPYFKB0t/DdPOp0FJvJcHaPm/yCankPp0=;
  b=JG6mJoYCC67ixRVS6faP2Mb1Y2zycp6zYoyqnTEToQf9G4ppi0dnm0bb
   Ld8JTl9ZTHC14qkSWOd1FxFlR7O2MdTKpuKHYGfkuOdSd+8RuX9vAt+YU
   dd9BZgNCvPiLSCaR7LTIP8Qq9cHk6L+ZZ7fDmLB+dJlWjmNqv187YF70C
   tpm/T9TukFAvw69WOrTZjTKBacRws+Y9B1tmJxh6Ok20+sWlSvoIJB6GZ
   qXOEZf2xIKWrgReYFuLw6IlKCJ7D7qaoOt5lDlJpcBCqOb2eO8KBWTebS
   85QTXNLhcGb4Uzhj7Z7rD/7M98qEEUkYdTtueG94XknnrvHtxSTDRIFTg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="336575780"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="336575780"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 20:54:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="823054674"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="823054674"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2023 20:54:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 20:54:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 20:54:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 20:54:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 20:54:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdOQrOI5dcWCHe7JTFNEIJ2DS9qB7EkRJF02BhTRLCHjKqtFrmCUDPtU12+qxe9FwuC2kwXgBQIXYgslvTrEskD5ihBCMqyMgh7NvMqy+vgo7wlnyxj5eEPutdMwofbgGzglX9Xw8z3DDbOBjDJFDcq9YJnp2XIiAnszmM0IoPu5vNh9aCwMTDZyw32KaAyjpUDy8nIHwJi0mh9izcN0d1NVNp34T4eX3kMZgWljIWhMsv0SEwOrS+Iwr5m9P3rDYmHUqu0Ea26ugDl1T2Cs4mVLkXKIPTaAdurFP0LvX5wQ0Jy3jPLd6CqKplw8R+FXJhukJXAdY+yWQqwK/AhLDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmenGUCJA3EnwpHpHztf1qB8QuX/tH4JwvbjHMEuCAk=;
 b=KVxTxemiIixHoHtZFxUEKlNe5jiycQZVi8f3zr99Ae1Tvg1Y3A/7f2MicN3fYWX1MNN4NUhsE39pHt/fzuYyq9vbYs4/fsZbqEgj2aVakORPeFLSuOv8C16k6RI8bXeT0k+zjRxbAgnpSaHysAVoM+rfZkq0/IoRDgquKp3ujcfXfDSwDbEm+zJSVPXPwSPalTyHRoF1B30x7SS29mC8ek1uDJA9m26788r7FloVM2OTkFC62mtA4hst0CCvfhbskkL4IJfCVFVM9PD3noa3sT6Lvd+n1AisD5XW1I19ZUmezQZN0gGla7PLUT0KnOHJ9zoel9I9gFP2Fr7hhM3/rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6667.namprd11.prod.outlook.com (2603:10b6:303:1ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 03:54:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 03:54:46 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: [offlist] RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd
 array in VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [offlist] RE: [PATCH v6 12/24] vfio/pci: Allow passing
 zero-length fd array in VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIJ081R6kW/70aeRy5pC5KSt678flGAgAAKrICAAEmQ4A==
Date:   Thu, 16 Mar 2023 03:54:45 +0000
Message-ID: <DS0PR11MB7529C7D0409B47430D7412C5C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
        <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB6667:EE_
x-ms-office365-filtering-correlation-id: b19e1831-6875-429e-3654-08db25d22e61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fWpTCorCnI6jxbfcJm8AZvYzesr8SxR/3L0P8HepV0goT5pMMjZC4P6cyw9xOVEiREhuu3Z20jklZWsdPR0VNw9EQ+kp0q/iGingGBSm5pOwljLGgNarDJjavpIVz7ApR2dmhipQ6MRWUqkkI1exQiio6Dkiz6azdXtZ31LNCeVty6zFqxKKz93S7vBWYqq9w0uIkzHF/jaIG4FR3VCBWRRPg8R644hzmT4EPocC6rm2/i/rWoJtR33cngUYu6sAcDDqtqzAumwl4/W2T+LCJ6d07C4sxzr50Zv6PLWIH2Mb6kLwCi9FhIVVDC790LMPyzGtRi5Eey9XegzRoIkntoCMEhsWVnP73UcJeQNnZaxb2VSpQn6jWLu1/0ktrSHAkQqQiqE5OudOtICmZu/j6cp8nZ1Sr2fHUv3Cb6WQ441hTJneXlttMMx/cW4As4UH2j60FzKW7u7+G8SROLzngyWqCuIF0DGddsZ9KROw+eO9wB0sCehsnteolurbfDoBucT5c6JH5iFjXAM2AjFBTWeJz0y/DDojmrJVGQUZu7yQd5jmSDTNh99mEc8Qd/Wmkg4EX/+GSsrhYfvxqElaumUMmZfHmWaLDaeBH5L7e+Jex7jIIoJqxPWfO9O3vQIGc2ClPS23ATMXT7HFHNI0QHBjmXdGfpSayVrflvmrHmd5ZD3TupSab3PIN+6iIvuP19RtbyCpd6tcU11+ckCyMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199018)(5660300002)(7416002)(82960400001)(33656002)(55016003)(83380400001)(7696005)(478600001)(76116006)(186003)(6506007)(71200400001)(26005)(9686003)(4326008)(66476007)(66446008)(8936002)(52536014)(316002)(41300700001)(64756008)(66556008)(8676002)(66946007)(110136005)(38100700002)(38070700005)(86362001)(54906003)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DHsIZRvMc5NBXw0daBPDKKZNnFwRaL/9op0oRUWV8xLDMWUHHYLQCVGfFtJL?=
 =?us-ascii?Q?WXgtiEDBNS5wbePZCJh7QoFS+bulr10D6iH1PXviRqtqJ+rzmwiRJP0uaV6j?=
 =?us-ascii?Q?LL/9tTWQhGuiRRv/dDWKzf+KgzPCx9Gra/C4tqFdSCQYvuyw5wpu/XuEmbOh?=
 =?us-ascii?Q?acYUmt7wYnha9JC9HKJ1u0MjlGFvAsySB4G3v0Y6IdAyOYLj0CQ3VMRm9Agi?=
 =?us-ascii?Q?Y/x32kROeBXECqRJt+j15SMInr5LLQmY6Unue2X/ihM0QCZx8X/+ZzWu8hqm?=
 =?us-ascii?Q?VORtDpYuuumSj34lsVGucqlClohCbbyfD0Jx6QGXT6oitIHaqO/nQ3WbtmqX?=
 =?us-ascii?Q?cJee14aw1MHGObYKFSNkBoPMFD4sOkO7Ixlv/Qxg489Hd4cBLxXz2V6p6j86?=
 =?us-ascii?Q?AwkrWwT8Pu6yxAkeAF/oPKlOdd8/QfNdSDvSdumLXW4N2AEIGBpjkVavgrHj?=
 =?us-ascii?Q?sL2ZKBgybSqLYIK/tmfhqizFU8MUHtrCp3GZ4c/uMgdBy8HLShV51IASdtxz?=
 =?us-ascii?Q?CbGhfUXgfFxJAj6RxIpvi2+ckAPXV8YK27CP+VD5tW2D1VH69ogKjbcno1Jq?=
 =?us-ascii?Q?BgChC/ighATL2LoVAd8QV7RrMmXkz5AXimX5Nozm35esCEkSRQO1Q/D3JvUr?=
 =?us-ascii?Q?Gm0ODpN4Xt5YZd4kB935nfXmV/0qAfDtZq5bL0AogG/vM/rR2BIVl0hvP8Pu?=
 =?us-ascii?Q?HQdk0Pb1ShxApLoLsNTXNijzWGJBfKi/y6GFOFJLrwkUZiB2oMPokBRJ1YsD?=
 =?us-ascii?Q?KgQ8k5RjFte2/50fH6qUIoD8kJxd5kz07a76zsFYdVeK+TF1KFktu4Cm7z1D?=
 =?us-ascii?Q?eGMIpUuVGa2sHuGMTgTj/ad9/FOVN4S3dcuxKp8semKwACHZyV6RwqrmMa+k?=
 =?us-ascii?Q?T+l5+XjUEdFkQGyVuI/6VBwWwlhsqlJC65YddI6OW2SFuYDNt4O7eKv0+5Cy?=
 =?us-ascii?Q?b2ZUczkhkzqKi/1M5DzCueMZxzTGQQWUWt8R9z3JzqvtBsYQosulC8BPHFZ9?=
 =?us-ascii?Q?bqP6UKAxTUeu2Fte0wk3uaa1X6pi86Z1cgxrC9cfF6YEFW6qsxKdkIqhNSkk?=
 =?us-ascii?Q?XIdVWoxp8gVEMGY8ibFUuY951C+gfM7gfasyRL8LSOV/vpGQTH50LMRmYBHV?=
 =?us-ascii?Q?AHyJdesiTvPPDUWbf42I/xeHzHo6ssPpX5v48AyfIAA6ln/DGyX6Pcf98EoI?=
 =?us-ascii?Q?eNlM13aNK8XIl9HkyfJFtHmUGeOypjCXZ0BaSSVl9D8yDhIZoLyft1cgkfVZ?=
 =?us-ascii?Q?anOFZc9nUwF2IxdK+RiFt4EqrVbee5jVvf38Bbnl2LCjagbFUhTSuYxEEtcn?=
 =?us-ascii?Q?9qGNzsR+LnZQOE93z7X9MP5pcfa/HjQgWcTwD5u4Zo4qdAiofdD6qaNQ2OHT?=
 =?us-ascii?Q?Nrjp2/LhgC22HQ1a/WHUsIiqQN0xJ2o1fgajozO3Hgxu6QqgvAaz3IlUs+HF?=
 =?us-ascii?Q?zLAS/4jLlaWNp04Nq9zwgUxJRgXuAmdPDzrY7eYII3xoRvouML3LvN9Mqpff?=
 =?us-ascii?Q?mds27Wdb1yvcC1Ui0HxlOje67X8cxT3W+fSFEuPVGTNrhJyEElci9R1E6Zk0?=
 =?us-ascii?Q?KhXVETd1h/T3zYtR1HPwuw2VEwSOvCzRmAOn6YS+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b19e1831-6875-429e-3654-08db25d22e61
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 03:54:45.3915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xe/hf5I7D/MI7bnBig09wo+Y9pKzqFe2C4/C6UDvRjcVWAeI85JUCsiB3qiBxFPCarO/1I6jd5eNj9mnFt18MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6667
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, March 16, 2023 7:31 AM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, March 16, 2023 6:53 AM
> >
> > On Wed,  8 Mar 2023 05:28:51 -0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >
> > > This is another method to issue PCI hot reset for the users that boun=
ds
> > > device to a positive iommufd value. In such case, iommufd is a proof =
of
> > > device ownership. By passing a zero-length fd array, user indicates
> kernel
> > > to do ownership check with the bound iommufd. All the opened devices
> > within
> > > the affected dev_set should have been bound to the same iommufd.
> This is
> > > simpler and faster as user does not need to pass a set of fds and ker=
nel
> > > no need to search the device within the given fds.
> >
> > Couldn't this same idea apply to containers?
>=20
> User is allowed to create multiple containers. Looks we don't have a way
> to check whether multiple containers belong to the same user today.

Hi Kevin,

This reminds me. In the compat mode, container fd is actually iommufd.
If the compat mode passes a zeror-length array to do reset, it is possible
that the opened devices in this affected dev_set may be set to different
containers (a.k.a. iommufd_ctx). This would break what we defined in
uapi. So a better description is users that use cdev can use this zero-leng=
th
approach. And also, in kernel, we need to check if this approach is abused
by the compat mode.

> >
> > I'm afraid this proposal reduces or eliminates the handshake we have
> > with userspace between VFIO_DEVICE_GET_PCI_HOT_RESET_INFO and
> > VFIO_DEVICE_PCI_HOT_RESET, which could promote userspace to ignore
> the
> > _INFO ioctl altogether, resulting in drivers that don't understand the
> > scope of the reset.  Is it worth it?  What do we really gain?
>=20
> Jason raised the concern whether GET_PCI_HOT_RESET_INFO is actually
> useful today.
>=20
> It's an interface on opened device. So the tiny difference is whether the
> user knows the device is resettable when calling GET_INFO or later when
> actually calling PCI_HOT_RESET.
>=20
> and with this series we also allow reset on affected devices which are no=
t
> opened. Such dynamic cannot be reflected in static GET_INFO. More
> suitable a try-and-fail style.

Got the usage of zero-length,=20
>=20
> >
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index d80141969cd1..382d95455f89 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -682,6 +682,11 @@ struct vfio_pci_hot_reset_info {
> > >   * The ownership can be proved by:
> > >   *   - An array of group fds
> > >   *   - An array of device fds
> > > + *   - A zero-length array
> > > + *
> > > + * In the last case all affected devices which are opened by this us=
er
> > > + * must have been bound to a same iommufd_ctx.  This approach is
> only
> > > + * available for devices bound to positive iommufd.
> > >   *
> > >   * Return: 0 on success, -errno on failure.
> > >   */
> >
> > There's no introspection that this feature is supported, is that why
> > containers are not considered?  ie. if the host supports vfio cdevs, it
> > necessarily must support vfio-pci hot reset w/ a zero-length array?
> > Thanks,
> >
>=20
> yes. It's more for users who knows that iommufd is used.

Needs to be more accurate. Only users that uses cdev.=20
