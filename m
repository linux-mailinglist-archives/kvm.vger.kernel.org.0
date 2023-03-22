Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18D66C4BDB
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 14:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCVNda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 09:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCVNd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 09:33:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161129000;
        Wed, 22 Mar 2023 06:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679492007; x=1711028007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oMuyBxnIQRvRvQ5wi0ytDabKArGgI026UZYp0eN3V3w=;
  b=Nj0T3HnF2htg0W9QE1cQnMm4a4U/S1IL9utDV5NVFLQJLAICpzJOq/Zv
   Wu9XS4mrlM0+CCPmbjABHZXTTtJxJr8+4Aqq0/53POj3KUbUXfsmXbl/v
   5cUYTcHkanXRmxJTDD1CLxRCM1Cy9rBXsMfXgFt+U3fa5E57BgEW8AIpY
   7FmsOGbYTh6I2pEMs1DOVEOKdV5qVmPyRhPl4i/G513qHbTQv4dRNzgsB
   zGzkxMnQ77PEMNlFYEURXqn5pfcKNxvz6w5f1OlUintKNpLqZGcFTlIrb
   gJCjh+Q/sZlFBI37AcAAPsPuZTVN9UV9LVTUTMl5oe68Jlpl2DdTu7zPN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="366948558"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="366948558"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 06:33:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="684312291"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="684312291"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 22 Mar 2023 06:33:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 06:33:14 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 06:33:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 06:33:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 06:33:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kB2Zes2VJGyyQDmQwKW1qRyHbb/7Zfrb6IStrR9CR1XncsiXpDgXRKb5iMZ04saeE3FUmbK5XIGnKscq9uE+VKOa/ngN76P80IOpN/qQ8egvOCLIoItCM/ZWMDAj2wZFqxuB7YewSpQm1olDezC3UzjRR2P5TQgtrTAqGaRhh9G9coGBpVfCiAeEIg0qgYYTUufY7ojSz0LAXCNZb+c9Jgdw+hCVVNwQMK07lPa+1pu2EMB9C60BV23IZezJ7xI0RelqYCg0v5MllfnvLfPykyrnLpjxctA+YE1GjHZcqIqiR369AcMdYrBv7mRqMfz8aFHpdmZ8oy4SyA7sc8wYNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMuyBxnIQRvRvQ5wi0ytDabKArGgI026UZYp0eN3V3w=;
 b=HJHQsSueiHUM8HU7bUJuJgB0OyhUFi7vTpKsJN3VAgFe9mUeZMEmddJ6PEqU7csw/SNu5Gr1WfKA4m1KZeukm9LUzLD7s/PhNeeDci1O4hqM397yuC9900Xg/RWoAJZZEBDCVkrQcTDQpie7Ff/5ZPoFsAkQjNaznu7oF1ZiLVRF8HrMedFERLW4m3leAl8QUZPLbAfkPB7Kan95btj66ppn/fI8YbMRNQVBFV+NbtGMNw6d41egcXtdCXUOR6ClpI1YRaHuo7b3ku9NJ/r8SDLUl4H2BPzDocJJeVn1baGzAfj+R0e0CWjIQL2AoFN43WH7+8mHW57LcqoZCOFx5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5553.namprd11.prod.outlook.com (2603:10b6:208:31f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 13:33:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 13:33:09 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZW095081R6kW/70aeRy5pC5KSt68ERp6AgAANFoCAAV3gAIAABT4AgACOijCAAHSzgIAAD3jA
Date:   Wed, 22 Mar 2023 13:33:09 +0000
Message-ID: <DS0PR11MB7529E4C6196C8581CD39A7C7C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316182256.6659bbbd.alex.williamson@redhat.com>
 <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230317091557.196638a6.alex.williamson@redhat.com>
 <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBrx98kqNZs3jeWO@nvidia.com>
In-Reply-To: <ZBrx98kqNZs3jeWO@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5553:EE_
x-ms-office365-filtering-correlation-id: 8f86db22-89bb-4314-8c12-08db2ad9fa2d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wfe9lm6Qg/WC3mTiu8fAJNIwABfdVWeljU4LjAD/HssHDQgIgK3UQGXsipLRnupKtldqWY/2S/DBc8ysBieu7lBPYaNh/btEbvXA75aFjZslb5DOO7daHUXL7YfddPD6+DZQHmM1slzlRTlo6K4pwmcm9wimtcRHVD/OVaF1+3lOvdtY7TzGMZ0eLbGKj+JHfNGesEm3PvlaVGVGveKSuVZIBXpfhegE67LLQMPP4oM7DCCaP6hYsIItTRhAg7hojplHhqRAyEIOXOCiZG1ozA19JL645MLMfSMXwbcAN/yDixMprY/GJGrUpHnbZEn/l8YWbTrgIEDFvegBC7+z7Ccs/mtDjJWVzAJfOoyvgjVtaPK3RjkrewRB2XwTwTqtOilkIIecVoAGNXmmRHsyhsXMIHnxAfOZwSilAlX45DEC3kfAEehwh6sDV+7Zul5gQqtXo3VgOO3rJEN9UX+yQ3L+XTeTJpn5ENZ02sLHUMpB0XLXNvklqisGDS/k7tTDcBA/gdA12CFTC5y9sedowiK4KI7UAKW1y4sQYEeIPO4C1NRVMPB8EiP8+MIHXtM7lq0b1GMkdaFIbHECd2SNqMuZri3h0sDl64c/T9n7hlI98g38mYlQuSbBtawUBNglLchLz91Psbge/VusoCHPYkdvTw65HeGBMkoQHu3zJFBDz+YpVirG9vODrh5RP6MEXgIzL0X2TjBxGvSzp9/Vlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199018)(86362001)(38100700002)(8676002)(83380400001)(71200400001)(7696005)(55016003)(4326008)(33656002)(54906003)(66946007)(7416002)(316002)(2906002)(5660300002)(6916009)(76116006)(8936002)(41300700001)(66556008)(64756008)(66476007)(66446008)(478600001)(52536014)(122000001)(82960400001)(6506007)(9686003)(26005)(38070700005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?huZ39hwwUGDInIo5a3KyBdwfB/7W7RD53TlnghwXXtA474VHv6YqukiljzcW?=
 =?us-ascii?Q?ube+ZrJNeA/Ik3k6P8gxF8al37UoZUwotyws1pXeOxPG8nVwrV8JQPWLEMOd?=
 =?us-ascii?Q?uKg1IkyVgG8frk8O5daQ4WKvpQrS2jBd3gZyQ68kNkB2apJ/yGZJh7fB0pcn?=
 =?us-ascii?Q?CqNpt4P0I1g+i8F1Onw1dg/CncQV+klAJoHHOaFwP1EB10JdMMe5oWW7pp7x?=
 =?us-ascii?Q?Dd0e7vvEetOvSOKkwTgjWwtuKSgKx4HvEV0pT40v5Br3UbbUKJVZJYVTDK1C?=
 =?us-ascii?Q?t4IZbZY4fI/DXFjZLIzkmIvG7CDxxy7UaZlh0UfS/TEV0P/LQVK+Dsu7wQRT?=
 =?us-ascii?Q?mXDmH5tkpA9qf6Su0PsTwWpZYr2in85heZMWhCAaODwlDEedP+eeVaEVmqh8?=
 =?us-ascii?Q?mMYPbAE4laFkJt+Xe6EgKT/uB1kS3eaHAm9YmDvhLVXmnMWzkJIyjgHBPDL7?=
 =?us-ascii?Q?RSt8bUsBJXM4akfQB/GAqS/Cn+916opYGQjKKDwigODRu3y36R4lkuXReyVf?=
 =?us-ascii?Q?DaffsLNbLJ7Pd8eA23AP59tVmOnWfcu/Jap3FmtS0I5YSpzjvhr6Tm4D2Jy+?=
 =?us-ascii?Q?4P/iLCwMiccUPwjS4IXLuLlcxHjl45a6ZJxkFUmiByS/51iKlUeygtHxt/zy?=
 =?us-ascii?Q?nHtbQ03QXCDq1U3EpGRejTjfG8akA5p5SCrja4uYvyyJx2b/QN9f5opXPC0D?=
 =?us-ascii?Q?ovJlW+Uoeywz1aD7Q1pYmT3XDPH0I0HjYPgViKrSm2XFYo4MzTpjykHN/Riz?=
 =?us-ascii?Q?XIFSlroJI71Qd9s4t2zbMpBBAJKXs9jNCUEbUx73DIklV2Phg1oxaSZcJ4DB?=
 =?us-ascii?Q?ueWvAmpldJkRuVO9QQj/5IOGBffKhcl6VRfmaD2eg2mbO50QugDL2tbtSuFG?=
 =?us-ascii?Q?doqwB4Dh7512fD8wkbaUxPjetvFo3RJrBBQeV6sOVI/fW4tTPFSBsmjytVLp?=
 =?us-ascii?Q?aUM2Tmyztvaq5kqV9Se85B/hFWN7lOtKn5N9JNnMwOFLla2EsJdSZwP7Iowx?=
 =?us-ascii?Q?5BB+99bPscXXIP7BVSpqyhsLrJZhkNLVggKFpllodISAuBY7RMDTM4LljBtr?=
 =?us-ascii?Q?1gzwlvI9WPG34P49f/80xhijXrU5/SgbXGQNiJpfc8P2HeR2xWE0hOTrqDze?=
 =?us-ascii?Q?xLs7V2ZPTg6BPsyUDnrcMRNoyIZFHqiorxRMFLvbv7OnxiWKMroMjfsrGMCf?=
 =?us-ascii?Q?hkKlc+4Ha+DsYB/gcf71kIFYya+/bV06sBSuIr16zsSQAqdvl1465SZnYgBI?=
 =?us-ascii?Q?t2DZvXfbKDcTgva/rTC6uxNtol0r/zcoGxlQ1fqSNs2pDz4bLvWcE5HjFLfz?=
 =?us-ascii?Q?/9MZcoqMoOrdOi3pclzzMHA6nx7Bt0rKyX029kr+/46wFY9+adGtMvucTcrL?=
 =?us-ascii?Q?QfEwRQLcKAou4DM1kD1GgvznBz1kU9qMHkM1Frfy25oqnjpA6MWwdM3Ef4rK?=
 =?us-ascii?Q?IWzVxT+3rJ8HX3VY2EX0fa77Ruzy8+ZB8QFqQCvstAV0q9tmo8o3bfxotvz1?=
 =?us-ascii?Q?u8qKx/+0YJ6aHyS2yJQUW1ESigm6xTEhIpOZYT52ZlzY9+PE/5begqnmkLzH?=
 =?us-ascii?Q?roF0gxrqSfHNVSASkp5Iv5INw1W2Hm1o1G7ODc8I?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f86db22-89bb-4314-8c12-08db2ad9fa2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 13:33:09.6303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2wHQiN32c47H3h7QPGlcBMyQXFmtXiRX+GWiaCe7deDHxICFk2XL2jg+5fiFAq4cgV6+yMbu9TZUtN+peCBqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5553
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 22, 2023 8:18 PM
>
> On Wed, Mar 22, 2023 at 08:17:54AM +0000, Liu, Yi L wrote:
>=20
> > Could you elaborate what is required with _INFO before libvirt can
> > use a FD pass?
>=20
> Make a new _INFO that returns an array of dev_ids within the cdev's
> iommufd_ctx that are part of the reset group, eg the devset.
>
> qemu will call this for each dev_id after it opens the cdev to
> generate the groupings.

Thanks. So this new _INFO only reports a limited scope instead of
the full list of affected devices. Also, it is not static scope since devic=
e
may be opened just after the _INFO returns.

> > > But for the current qemu setup it will open cdev directly and it will
> > > know the BDF so it can still use the current _INFO.
> > >
> > > Though it would be nice if qemu didn't need two implementations so Yi
> > > I'd rather see a new info in this series as well and qemu can just
> > > consistently use dev_id and never bdf in iommufd mode.
> >
> > I have one concern here. iommufd dev_id is not a static info as much as
> > bdf. It is generated when bound to iommufd. So if there are devices tha=
t
> > are affected but not bound to iommufd yet at the time of invoking _INFO=
,
> > then the _INFO ioctl just gets a subset of the affected devices. Is it =
enough?
>=20
> I'd probably use similar logic as the reset path, if one of reset
> group devices is open and on a different iommufd_ctx then fail the
> IOCTL with EPERM.

Say there are three devices in the dev_set. When the first device is
opened by the current qemu, this new _INFO would return one dev_id
to user. When the second device is opened, this new _INFO will return
two dev_ids to user. If the third device is opened by another qemu, then
the new _INFO would fail since the former two devices were opened and
have different iommufd_ctx with the third device.

Regards,
Yi Liu
