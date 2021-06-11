Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685C93A390F
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 02:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFKBAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 21:00:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:36655 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhFKBAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 21:00:39 -0400
IronPort-SDR: TA3+Sy/k6ZNvfvFPtjbpSSEFB/0oiMolaeztWI52vPh9gsA3rxqU17EIiUzvNgh7Ygof2tFxvV
 5bVR3IV3RxkA==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="291068332"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="291068332"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 17:58:40 -0700
IronPort-SDR: HVCjpdxTTLWdtJSB70sl23rqY2eCdqiWtFI6dqFjAldb3ikk6x0fPlq8/H326/XNla+GoeZxIT
 qRnxkm/9wG+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="553255268"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jun 2021 17:58:40 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 10 Jun 2021 17:58:39 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 10 Jun 2021 17:58:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 10 Jun 2021 17:58:38 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 10 Jun 2021 17:58:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpBuw6bu3jm+6i2+MPL1+pFLZY9Px43+1YrFGZNlZKGPlOi+hkxi4cPAQ/raKHBuwot+gOXXtDdzNoJnnbk7T2rujEo47o7HzFh8KyJ5RVtY8urDldCTuHzPrOpVYme18CdXe9otjBXgXyucfDYp1Wv+80d6lcJ5bA9CXvxvGYnRf+xN8iHKlaejgcwHMQHxRiCo+guATtNNEKhBbDbqlrKieMgRo9JXQO5ti+QvpA3OYyHz2cA8bYU+q/Wxn6q8NPV7wpPe/qsYV0qmqd/+PVlfgnlWM/dJbDRZodWtvnrr/FIT0J1GY/KLa7nqAGAUORquHx3bsw7Ypz4uU8M0sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wMgVyCpcZbGWIaTpmW5YY7Wtp3y7X+Lf9QvJniLyZM=;
 b=Or1ZvpgX2HAwnO0H5xQFpHF60PA/WyFAjVo/85314Rs8iGf+GPuGgI2Hvfj1LVCjHoZSzRsQQpG7hOSWIhamU/4Kgyhw5jFhZ99JOAMloTNhS8V4AX4LO06/Rb9YA6GdrrWdSg/D6LqXGnPH5rYyirjsj2JKxhHcWBlscsE5vMMdcveFd4oyVijzsQ9959/JMqRFWBrE0aTCKZVrZP1+rPpWV54eMOXGbL4cdlKzO885qMVyRWQkLXpnSpTge1CgYSBFgUr6mrmHylmlxV3+zRQOXcvHiNvUhqAbE6jy7m5CRGkKFkk0tudno15QR6pEAbEmxj9gPhLntlwakF4jPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wMgVyCpcZbGWIaTpmW5YY7Wtp3y7X+Lf9QvJniLyZM=;
 b=RKpdHGD6zUPFt/oiB6fqvrlcmQsr7qePhvbPIQ4YrOIsEJWv9MR/R07kh5g+VHxkd6QT+y4o3yO6mB+mglkHiOOk8MoiVKvQG3fAR5ohpr4spDcQ76moyQcwhG3/H91vu+9k1PlDHvP+qwmidHFFhnHyT8QdTmw37QqKC67XKoA=
Received: from BN6PR11MB1875.namprd11.prod.outlook.com (2603:10b6:404:104::11)
 by BN6PR1101MB2209.namprd11.prod.outlook.com (2603:10b6:405:50::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Fri, 11 Jun
 2021 00:58:36 +0000
Received: from BN6PR11MB1875.namprd11.prod.outlook.com
 ([fe80::391a:c95b:69f0:ded7]) by BN6PR11MB1875.namprd11.prod.outlook.com
 ([fe80::391a:c95b:69f0:ded7%12]) with mapi id 15.20.4219.023; Fri, 11 Jun
 2021 00:58:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Jason Wang" <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAAR+AnQ
Date:   Fri, 11 Jun 2021 00:58:35 +0000
Message-ID: <BN6PR11MB187579A2F88C77ED2131CEF08C349@BN6PR11MB1875.namprd11.prod.outlook.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
        <YMCy48Xnt/aphfh3@8bytes.org>   <20210609123919.GA1002214@nvidia.com>
        <YMDC8tOMvw4FtSek@8bytes.org>   <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
In-Reply-To: <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.143.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04a42b2e-7e22-4cdf-31f0-08d92c740b1f
x-ms-traffictypediagnostic: BN6PR1101MB2209:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB220912110111D92387A0731F8C349@BN6PR1101MB2209.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M5la4aT2l+aHgatqEZHPMESxmQ6cDxR9sxWz4Ejz4+vz4wstGcL/SLeDVPzfnzOiEzNKePHePGl3ORNXiz7Q6YjLnfTrqhO6bXFPXL1L4TauuKTSOCqd8Yh8CuFIFCCuWAot2kmPE4BlkgwA5hWyNplNtXFfE2ZAB5lACBKU2QZBBwwl67Im6HCUV2OpVorLd1GZitVVPgBJhwXQOmtJY4T+sO26zEZU406r0W9MpC2ZGZcCD+7nQBmcPlJNpko5RfWImoAorCmJoP/wlFqrMiuhP7bm7deqhPeV1qvewEgKZeXQcsWj6l62ZFgNnFKATviEc9ccDeCoJLyAgci33CgJlQOCGHrFDdEMVjTxD06kj6wUCOMjcCm/aLQw/BAK8PPUy3QYWexZdyoaQCKiJCsRJDSJBrVfCXRRznqkUlFg9nONe9RTiPLc2EAi3ASF8hFjkQJdTGN9GpM6trLXnkAW3VS6Y3uey0eVBKilHbHoBYnRIq6YuOc5PCuzf7sCI8Gj1N/bm7KCSCzi7xXmJ8DAhkK515OVFiZyD34jqY8FvkjXD3ffHZ1wTZBo4a53nAGDBPCM9GLl2bhvq4gxHHkw52PZEeVXkt8sWI/kcCI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1875.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(8936002)(478600001)(2906002)(33656002)(86362001)(5660300002)(76116006)(38100700002)(122000001)(64756008)(66446008)(66556008)(52536014)(4326008)(66946007)(71200400001)(66476007)(8676002)(83380400001)(186003)(54906003)(110136005)(7696005)(316002)(26005)(55016002)(9686003)(6506007)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l7SY/G1LcTn16vDXNjc2DXBFiRA99C6cZzZCCJFq44Fu2whOwPkAcW2VRCop?=
 =?us-ascii?Q?xVP0n//evjMoVCqfjf5uJHiq3tel9S+gsdnWO6ZsomOnbVS+ogvKD24OSfxX?=
 =?us-ascii?Q?d0kOGf66RIjhRqJC2KA/92teHu306prH7w8qYnrUfJSqe5OK5fJuqcPtL/r6?=
 =?us-ascii?Q?l6qVz/KVEn0rPiS+K82AbQYmIhsXF3sDsOF2s+BOkrLHFIY9kaNxBKm4zrfa?=
 =?us-ascii?Q?+px3D7LHUxnvLBcSC24ChCcnQeEP4UXKB/DtLROwcEv8ONwZs89xV7p9f2Gl?=
 =?us-ascii?Q?rJqJs2dHPtGis1h1aycGhe4d3lex9wYSxSj2mFS/J6PJR2Kz27kez2Bh/q7l?=
 =?us-ascii?Q?CH+DSFrrXJRDh1GFntd685BiA9YqZ2h4JueitjXwYeUS/lcYfYrtny3sE7VN?=
 =?us-ascii?Q?jktPVTQCTCYuI9WS4albsoRmM7aXzLCMZW9ekZuL7LiAN46TUy4mjafEfwMo?=
 =?us-ascii?Q?MqA8DloXl5fjeacBkhWixwH7lCF0uYn4LiLvfxRP8PxHRZldBOPqZBqAvN+6?=
 =?us-ascii?Q?seRuAIAVx7Ua1gwt2FBBtOoF3SNr1Xu7Xb4JXL516bS/GtXCXjgZlnDQek4P?=
 =?us-ascii?Q?uACS8K4MmY8074CkJ915rGNTdLywBPxfKtDrNGM0rrpOI11DtgRUj+mp8inV?=
 =?us-ascii?Q?GIzC5zZUBxYNEkEfXOQBgxS50VBEATODaIJ4ZcBKhtt1BlSGMDH2c2yXQBVR?=
 =?us-ascii?Q?dwInPqh3r1qlgOc9poC6RoDzCxn7Z0JL/Udx4Ani/97HdCRTQ13d5hMxjGm1?=
 =?us-ascii?Q?njzO32jSsCY5BKnhRo7xfj6Kr69JGsu9r/bgXKajpuoaw42Ti2i64jW3Rmr8?=
 =?us-ascii?Q?+Bq3JGPU5ctLQuXu+R9xjRUwTY/nj6BoQDpiz2SKEclqFGGEpr/o+gZAb/ap?=
 =?us-ascii?Q?GFXkmQVOn9yybzrNp+4jEw2u/TniOvbl/v91z3zBcUWtDaZNdjUO6bf7NruQ?=
 =?us-ascii?Q?F9nH2xun/8zWRZGqOdfKxPRd4fXC3A+CHNYB051f3QsZ4HgVBOS/cVc0lAvE?=
 =?us-ascii?Q?oNHbfH72HsiFYhISKsAXlBig45HUzEVgBCebJ6GRKJec7DYxWkg+2VPLqHNO?=
 =?us-ascii?Q?S7a8ar3Bj5HTTFqmoT0Xs2atliwzQw/sWWcSQfhssyrDO/KsrYXg0oeD3VSt?=
 =?us-ascii?Q?4FsN33g9xkoUUTTfW22ABDzcJAK7Opgke6iNmQZCxTXpw5/eldkI08ekQasv?=
 =?us-ascii?Q?g0sCqZ7auCHxHANCVUmv+/01PJvASzAEgGmzNzLe7tykBpQ/iRirOf/i7ZwX?=
 =?us-ascii?Q?w78Els88zh5mbC9ahUMWDfkxcXD9YpWpVk+Wdv7ou7iXRcWpNNXP/dyRLusm?=
 =?us-ascii?Q?uGscxbbzMnhPe5cWmgYUvw0Y?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1875.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a42b2e-7e22-4cdf-31f0-08d92c740b1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 00:58:35.7131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hi8zIacWJPSkzKmJOGzWf9XDfiZyzk3nkSfVfW0zOezz++OpluEuff4BOGsqjm+zdjg0fqEYmmPLNDpr50VGhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2209
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, June 10, 2021 11:39 PM
>=20
> On Wed, 9 Jun 2021 15:49:40 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, Jun 09, 2021 at 10:27:22AM -0600, Alex Williamson wrote:
> >
> > > > > It is a kernel decision, because a fundamental task of the kernel=
 is to
> > > > > ensure isolation between user-space tasks as good as it can. And =
if a
> > > > > device assigned to one task can interfer with a device of another=
 task
> > > > > (e.g. by sending P2P messages), then the promise of isolation is
> broken.
> > > >
> > > > AIUI, the IOASID model will still enforce IOMMU groups, but it's no=
t an
> > > > explicit part of the interface like it is for vfio.  For example th=
e
> > > > IOASID model allows attaching individual devices such that we have
> > > > granularity to create per device IOASIDs, but all devices within an
> > > > IOMMU group are required to be attached to an IOASID before they ca=
n
> be
> > > > used.
> >
> > Yes, thanks Alex
> >
> > > > It's not entirely clear to me yet how that last bit gets
> > > > implemented though, ie. what barrier is in place to prevent device
> > > > usage prior to reaching this viable state.
> >
> > The major security checkpoint for the group is on the VFIO side.  We
> > must require the group before userspace can be allowed access to any
> > device registers. Obtaining the device_fd from the group_fd does this
> > today as the group_fd is the security proof.
> >
> > Actually, thinking about this some more.. If the only way to get a
> > working device_fd in the first place is to get it from the group_fd
> > and thus pass a group-based security check, why do we need to do
> > anything at the ioasid level?
> >
> > The security concept of isolation was satisfied as soon as userspace
> > opened the group_fd. What do more checks in the kernel accomplish?
>=20
> Opening the group is not the extent of the security check currently
> required, the group must be added to a container and an IOMMU model
> configured for the container *before* the user can get a devicefd.
> Each devicefd creates a reference to this security context, therefore
> access to a device does not exist without such a context.

IIUC each device has a default domain when it's probed by iommu driver
at boot time. This domain includes an empty page table, implying that
device is already in a security context before it's probed by device driver=
.

Now when this device is added to vfio, vfio creates another security=20
context through above sequence. This sequence requires the device to
switch from default security context to this new one, before it can be
accessed by user.

Then I wonder whether it's really necessary. As long as a device is in
a security context at any time, access to a device can be allowed. The
user itself should ensure that the access happens only after the device
creates a reference to the new security context that is desired by this
user.

Then what does group really bring to us?

With this new proposal we just need to make sure that a device cannot
be attached to any IOASID before all devices in its group are bound to
the IOASIDfd. If we want to start with a vfio-like policy, then all devices
in the group must be attached to the same IOASID. Or as Jason suggests,
they can attach to different IOASIDs (if in the group due to !ACS) if the
user wants, or have some devices attached while others detached since
both are in a security context anyway.

>=20
> This proposal has of course put the device before the group, which then
> makes it more difficult for vfio to retroactively enforce security.
>=20
> > Yes, we have the issue where some groups require all devices to use
> > the same IOASID, but once someone has the group_fd that is no longer a
> > security issue. We can fail VFIO_DEVICE_ATTACH_IOASID callss that
> > don't make sense.
>=20
> The groupfd only proves the user has an ownership claim to the devices,
> it does not itself prove that the devices are in an isolated context.
> Device access is not granted until that isolated context is configured.
>=20
> vfio owns the device, so it would make sense for vfio to enforce the
> security of device access only in a secure context, but how do we know
> a device is in a secure context?
>=20
> Is it sufficient to track the vfio device ioctls for attach/detach for
> an IOASID or will the user be able to manipulate IOASID configuration
> for a device directly via the IOASIDfd?
>=20
> What happens on detach?  As we've discussed elsewhere in this thread,
> revoking access is more difficult than holding a reference to the
> secure context, but I'm under the impression that moving a device
> between IOASIDs could be standard practice in this new model.  A device
> that's detached from a secure context, even temporarily, is a problem.
> Access to other devices in the same group as a device detached from a
> secure context is a problem.

as long as the device is switched back to the default security context
after detach then it should be fine.

>=20
> > > > > > Groups should be primarily about isolation security, not about
> IOASID
> > > > > > matching.
> > > > >
> > > > > That doesn't make any sense, what do you mean by 'IOASID matching=
'?
> > > >
> > > > One of the problems with the vfio interface use of groups is that w=
e
> > > > conflate the IOMMU group for both isolation and granularity.  I thi=
nk
> > > > what Jason is referring to here is that we still want groups to be =
the
> > > > basis of isolation, but we don't want a uAPI that presumes all devi=
ces
> > > > within the group must use the same IOASID.
> >
> > Yes, thanks again Alex
> >
> > > > For example, if a user owns an IOMMU group consisting of
> > > > non-isolated functions of a multi-function device, they should be
> > > > able to create a vIOMMU VM where each of those functions has its
> > > > own address space.  That can't be done today, the entire group
> > > > would need to be attached to the VM under a PCIe-to-PCI bridge to
> > > > reflect the address space limitation imposed by the vfio group
> > > > uAPI model.  Thanks,
> > >
> > > Hmm, likely discussed previously in these threads, but I can't come u=
p
> > > with the argument that prevents us from making the BIND interface
> > > at the group level but the ATTACH interface at the device level?  For
> > > example:
> > >
> > >  - VFIO_GROUP_BIND_IOASID_FD
> > >  - VFIO_DEVICE_ATTACH_IOASID
> > >
> > > AFAICT that makes the group ownership more explicit but still allows
> > > the device level IOASID granularity.  Logically this is just an
> > > internal iommu_group_for_each_dev() in the BIND ioctl.  Thanks,
> >
> > At a high level it sounds OK.
> >
> > However I think your above question needs to be answered - what do we
> > want to enforce on the iommu_fd and why?
> >
> > Also, this creates a problem with the device label idea, we still
> > need to associate each device_fd with a label, so your above sequence
> > is probably:
> >
> >   VFIO_GROUP_BIND_IOASID_FD(group fd)
> >   VFIO_BIND_IOASID_FD(device fd 1, device_label)
> >   VFIO_BIND_IOASID_FD(device fd 2, device_label)
> >   VFIO_DEVICE_ATTACH_IOASID(..)
> >
> > And then I think we are back to where I had started, we can trigger
> > whatever VFIO_GROUP_BIND_IOASID_FD does automatically as soon as all
> > of the devices in the group have been bound.
>=20
> How to label a device seems like a relatively mundane issue relative to
> ownership and isolated contexts of groups and devices.  The label is
> essentially just creating an identifier to device mapping, where the
> identifier (label) will be used in the IOASID interface, right?  As I

Three usages in v2:

1) when reporting per-device capability/format info to user;
2) when handling device-wide iotlb invalidation from user;
3) when reporting device-specific fault data to user;

> note above, that makes it difficult for vfio to maintain that a user
> only accesses a device in a secure context.  This is exactly why vfio
> has the model of getting a devicefd from a groupfd only when that group
> is in a secure context and maintaining references to that secure
> context for each device.  Split ownership of the secure context in
> IOASID vs device access in vfio and exposing devicefds outside the group
> is still a big question mark for me.  Thanks,
>=20

Thanks
Kevin
