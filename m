Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149D86B3626
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 06:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCJFiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 00:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCJFiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 00:38:14 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB07713D7A;
        Thu,  9 Mar 2023 21:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678426692; x=1709962692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t9Y6sZ9dhS8XEP1Hdn508m29BaXuTcNvDSpU0rhGk40=;
  b=joXObK+bQefUNMpIA96mYtBwsD1p7/o6lmW9PSSpdmItEYqFz97PVse1
   7xHSuKBnmQCLngWvWrbFN1qreJl6dr0RSRFFl0fzpzHoL7mZdU+wj3LPL
   c65PJ8Zd+YYiW0wutYWa7nb3vTmRcxFTGu+Ya2jOs7ZQL7Tda+AJhenou
   EzFM5/arhUowl2tuxTQgMZCw58WqfqCf8BfTSOx0YqNXjy36iOmZhReA8
   4ouEtbFENUaOmzzKngMF0S3qLF+XcJ/Yei48zqDB0rAsOfYb0HzR1dhUu
   uMaurfHi+VnplW+26UxMUHqzQCzuH1RnMG1dxw9K2Bb+Tl0MHBaOFmdDT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="325004103"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="325004103"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 21:38:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="787889190"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="787889190"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 09 Mar 2023 21:38:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:38:11 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:38:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 21:38:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 21:38:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gm4Dzk7x3jH0kITf0tLqF9vUlOmr9d4ap4yISHuko/Bxg8j79Wtq2cszt8D1yNU1ujHiLcJtrrPMtyttbZaZqXX1tpTMI8SmG2CdSig9BXRlV7PTyAi6G/L4YWNYGHxu4Rk6AdbWTy9KL9pjIf7z2tVCv/2IDOMgCvob0IqGFs4DMosTSfQUBJ9zc8Wc5WFL+Snt7Thqi+xsje9L4QgOd1IW2yNExuKw9+8UGGTglYUXYtDoocWWL/YnIpEJjVgtc1ddLyx6DV5xf/X4qhtHF5Frsb5VDpnwvcRVcaDuPZiHKxzHbqla9lAxH1NQckAsbACrx75Mmscu6zleQfIH3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9eVsfbIbhc+/lz2irPvl/0DXCgQmm/JSRWxkTm1kFo=;
 b=Im/kHHcifRcxlEYxzqyr6GxaqyjU6aNFK2rS2q0jLRsJq9uhd0do4OFmY7bC0d92mC2QUYWPD4oWswQB5BDjKtzpW7Yo757i8IZS3VCI/IeoMPm0FLhFcpccEC9rXLVlEa1JlkxZ2MOkQE5LDfQZ8/IUfQZXnfjtzNF1CFZlXhuEqxLcPEu3PUSFC7hkw8wV5C2ZVK7ng/baSPYIqBOmYJQg4zZ7PhQ5kwLWmvDXOlrfuvwftJf2SeMEvNG1yg1vfNqMVGalghqoHdhpSRAzoxK535SqqjaIoGZKc/IA0J7hK0CGs5JDqVpiU7MurB46S7r3FJM2ruYpGiIq4ngljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB7496.namprd11.prod.outlook.com (2603:10b6:510:280::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 05:38:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 05:38:03 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v6 11/24] vfio/pci: Accept device fd in
 VFIO_DEVICE_PCI_HOT_RESET ioctl
Thread-Topic: [PATCH v6 11/24] vfio/pci: Accept device fd in
 VFIO_DEVICE_PCI_HOT_RESET ioctl
Thread-Index: AQHZUcIDFCJsi/bz0keBcFidAz7j9K7zeSAAgAAF2KA=
Date:   Fri, 10 Mar 2023 05:38:02 +0000
Message-ID: <DS0PR11MB752926B20944D3B3781D1E2EC3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-12-yi.l.liu@intel.com>
 <BN9PR11MB5276D3C01F75380A815D218E8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276D3C01F75380A815D218E8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB7496:EE_
x-ms-office365-filtering-correlation-id: ae8ff934-a390-4d90-937b-08db21299de7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TAlg3vPxFJLqSy1ZNMEZM9I9lNBPcalJBlrexoUYN2hdQ7ZP+dRF/DC1ArNfUx7gGgDGlwAzIVLzrdA66if9KI41Cv4VQelXL3oSbIFaWD3TuFKS+FwccnOID1wBHcZAz8yT3DXpjF7+D91GZ1fXf2uMlBbSmtWlvMXf6f9J4PfEePZu4Schcf3u9kZ3/CMVzlLDx1n9W8zCiuIyQXBN4IW/gTYbHQir2Zzuf3T27F0IzAH+W6Sncell00yTkBTF2m4uJiJGoDHW82tZwaVGL16DOgLdGQPBsF6IY9pI54aPvk+CfiY/9gFX5Wfq8hSuJ7388/rznT+MCH/pBg9W9qJ9O0yFULO0n0zEBMRHVl9ElI76E70/ZhTiR1q1pm4nAkk4uaCING1gSHGDcRxHPS7dxZCywLDDpwV08A13yUAV3mkDxanKscU52u/GzioW5bY8OWpAiMC0oPWZkX+bqebuIY4CLQz1HwRGZ0WIHlS7N/b1sbNrgE+5x3J4qDJ3LiFlE4nGrYrp2SaHz+IVbpE6aLcTNt7HMdhQ1eJ8r16VzyeY4I//BuN6rX/QHG3Sg/lOwYEpKM1i+7HAueMQaw1aBvi8g5YRlx1IkERsrEIZjklqrX40pgM3k0QjBjIsO0yevnnYvrKEOTzGzmBJ2LT6IC16URZFiVPaNfS3sL9KBpBMxPTwUYdK7KN0B5xvB/Hmb1SwyOQSGgb8QGgq3wyFanZ1HcT0qJfPgxHSRyQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199018)(33656002)(122000001)(83380400001)(82960400001)(7416002)(6506007)(26005)(186003)(9686003)(71200400001)(8676002)(7696005)(8936002)(5660300002)(52536014)(66446008)(4326008)(64756008)(41300700001)(66556008)(66476007)(66946007)(76116006)(86362001)(2906002)(110136005)(38070700005)(316002)(55016003)(478600001)(38100700002)(54906003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P2ZWMqjfeuIRosikgTq9ns9qy+qpSKO4T3DA4srZgpzyLb/Eua3wgkvZcU3g?=
 =?us-ascii?Q?EhPABQ1cb38dgJNPMY35MeKjjHsUMz3cZUuP+b7BFWUesfZVA7eGgGjbnheI?=
 =?us-ascii?Q?XrvOf6grH99IAvmFNR6EOWZnliAEr7bmoZqUOABwBLEtXc/tmPEvHYk4/9HY?=
 =?us-ascii?Q?y1Gq/UGnE4L8FON7eGWWw2cRLO08SgvdshVs8Ybv0SIZd6TBeZmHxFI/7f7U?=
 =?us-ascii?Q?b/rEtpsahTmpuL83WWT7DC2QPhUXqDQSbrlA0Rs8VSPi/9j7AiJHHFnHOUJk?=
 =?us-ascii?Q?nrEx1WyDZtTYgifkSVbrmAyMOfGGCjGERDATUmpz03zlk2//n0wgiT99XgGj?=
 =?us-ascii?Q?NwTRgFUeOailsqlOToBZTYm59P1t0ImlqvKx2Y7m2OOe1hsBSdLOESkEYzNH?=
 =?us-ascii?Q?+z10IaQDBsjBAmM4J5rXE1FOqIr3zUJHFvtcr8ETDhiofKWhOjJzifbPx6ho?=
 =?us-ascii?Q?lzXRQi/Zl+rgbj53O/Qz7rkfHXyxFoGnOjz79xlAcakVqx0PEazpRcx0/teq?=
 =?us-ascii?Q?V1n9CbWqnG3mCPD52OpFuog7kVJfYPaEXdEYECAI4UnFNeRxMdVZGImwdGTG?=
 =?us-ascii?Q?K0CxYEVV+37P2ycNpkWueT42+3uGFeY1w27nL0fuKxhT8cm/qx10UJSoxore?=
 =?us-ascii?Q?ndJajyWgsO/Zc4kmMYD4jpaqEy2tn5WU2PfkXfYYNK23zi6vlMFCQcgbnb60?=
 =?us-ascii?Q?kK5zu/zya0kXb9ZQ+v/q1uvCBZZzFTyoW4hZIl532FYo5ZRIr+FatGVISTz3?=
 =?us-ascii?Q?LtcbF8xNol/04dSjF1dbh2we7/oHLNtwRbtMwrKffukH1WyVXgpBL7qybqTA?=
 =?us-ascii?Q?cZLUiW5WKL1d12qmAWnkGCTQUC79mtFK/70WzywGuimVedSGm20q4vy+EIdd?=
 =?us-ascii?Q?BmQgZ1+m74Txgvob3mbq/PiV3grl1M+Kj2U9WCAHLt44mqYYTPYN2tt1gEpI?=
 =?us-ascii?Q?6MA8wmxF7sRgxCkQM2ThRoWauETA5pLNevJ2l5RpdLjIRRf9STvPBCvtosJE?=
 =?us-ascii?Q?xagUDYmldEmYXsZXNqdExJ97AaU5eE694Vn6LcMHo5VeLohioLUISpTuu8FK?=
 =?us-ascii?Q?h80gklEKqBFkNGvhDNwkf9hvX7AawzNglurLT3NokLlg5VlR/H4Tp0DaQB/P?=
 =?us-ascii?Q?k22RAnsPg13JGB/Yqt1UapRejbldNLdIC4BQc2eCzjafZqwWXxP+fK5E1sDk?=
 =?us-ascii?Q?S/E/tpXW/oLb1Bjsh2mEo7pPivilsyqzmqKoVeSmu4eP9tvfXNPOhYUzUJaq?=
 =?us-ascii?Q?zWCM6sWMNOPtRFemitdDb5Y3Ct1jSiFV5FNavDvkXsibxN+Mixxnk+s3/SaF?=
 =?us-ascii?Q?I3BEuljnvrrmuKSjNks6vU8shcM+u9DAFBsT1CipRNqANnFLH7ztwK3OoMaJ?=
 =?us-ascii?Q?h4LQNm4rsNfl6zlcpaDrpKRy8N/hSEWSnrt1WOsCx+k5x/vEWuYe1ot4Ej7Z?=
 =?us-ascii?Q?Z8wL3ve3zY+gC2JTF9ZFuSQXt7Rnav4qRitMeo1OdTsTS0f5RtBMDhizalRv?=
 =?us-ascii?Q?JuBU1F2ucssDBN1Wuc2vu/hGGWRj0PTxmYTgJ0GY7e4I4UAn3ectNs1byjwy?=
 =?us-ascii?Q?QrOdfPz15WHG11FeD183wpq27QddcHrq4tLHzVGt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae8ff934-a390-4d90-937b-08db21299de7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 05:38:02.9164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UBOJHWvL1HH1dQAREO3sw7ElIIbuM/WtSxrVkFOUeDTe29MMMtwrTCwg5OnXI9gUfbNMl2fSGXS3jH7KY08NqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7496
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, March 10, 2023 1:08 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, March 8, 2023 9:29 PM
> >
> > @@ -1319,8 +1319,14 @@ static int vfio_pci_ioctl_pci_hot_reset(struct
> > vfio_pci_core_device *vdev,
> >  			break;
> >  		}
> >
> > -		/* Ensure the FD is a vfio group FD.*/
> > -		if (!vfio_file_is_group(file)) {
> > +		/*
> > +		 * For vfio group FD, sanitize the file is enough.
> > +		 * For vfio device FD, needs to ensure it has got the
> > +		 * access to device, otherwise it cannot be used as
> > +		 * proof of device ownership.
> > +		 */
> > +		if (!vfio_file_is_valid(file) ||
> > +		    (!vfio_file_is_group(file)
> > && !vfio_file_has_device_access(file))) {
> >  			fput(file);
> >  			ret =3D -EINVAL;
> >  			break;
>=20
> IMHO it's clearer to just check whether it's a valid vfio group/device fd
> here.
>=20
> then further restrictions are checked inside vfio_file_has_dev() when
> it's called by vfio_dev_in_user_fds().

I see. But it just has a window in which a device file has not opened
device yet in this check, but opens the device before the dev_set->lock
is held by vfio_pci_dev_set_hot_reset(). Anyhow, no issue. So I can change
it. Then vfio_file_is_group() can be removed.

>=20
> if fd is group then check whether device belongs to group.
>=20
> if fd is device then check whether device allows access.
>=20
> i.e.
>=20
> >
> > +/**
> > + * vfio_file_has_device_access - True if the file has opened device
> > + * @file: VFIO device file
> > + */
> > +bool vfio_file_has_device_access(struct file *file)
> > +{
> > +	struct vfio_device_file *df;
> > +
> > +	if (vfio_group_from_file(file) ||
> > +	    !vfio_device_from_file(file))
> > +		return false;
> > +
> > +	df =3D file->private_data;
> > +
> > +	return READ_ONCE(df->access_granted);
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_file_has_device_access);
> > +
> > +/**
> > + * vfio_file_has_dev - True if the VFIO file is a handle for device
> > + * @file: VFIO file to check
> > + * @device: Device that must be part of the file
> > + *
> > + * Returns true if given file has permission to manipulate the given d=
evice.
> > + */
> > +bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> > +{
> > +	struct vfio_group *group;
> > +	struct vfio_device *vdev;
> > +
> > +	group =3D vfio_group_from_file(file);
> > +	if (group)
> > +		return vfio_group_has_dev(group, device);
> > +
> > +	vdev =3D vfio_device_from_file(file);
> > +	if (device)
> > +		return vdev =3D=3D device;
> > +
> > +	return false;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_file_has_dev);
> > +
>=20
> merge above two into one vfio_file_has_dev().
