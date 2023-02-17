Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2A569A975
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 11:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjBQKzR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 05:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBQKzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 05:55:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EF362413;
        Fri, 17 Feb 2023 02:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676631314; x=1708167314;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SGTybMZtDR/AS0X3Sa6vTTdD9iechdHTYAV3jcyA9Ic=;
  b=IwmsBtufRMX2yAYyEZKnN7M2zx5UlFMEwo9FQNbU9NIBKzqBInVh41GF
   9hDldu/J1gVO8U1pjnDSeoHfV35dzlJqhEThRWdEunJjaTdUalMvsdG14
   4vueAghNf7nD26uZsLrqUDpabKepx3hcQm38LJ0pwnwn6xHSH4h+YkPeY
   E8EDpsHOMI18MnKC/8/e0vlOsAn3VAXQwDaaNF6WnySn5xMTroBGfQ3UW
   KxcE9OoHNTLYWQNT8hcEvgk3CLUUmwVfNexO5SEZqkmwh/jvx1oHA52pB
   rziyyivygBbKh/DvQJowCIOwnPLSNcj/qutdshyUVBui6OQudIaEreste
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="359409726"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="359409726"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 02:55:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="759317252"
X-IronPort-AV: E=Sophos;i="5.97,304,1669104000"; 
   d="scan'208";a="759317252"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Feb 2023 02:55:13 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 02:55:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 02:55:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 02:55:12 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 02:55:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmXVDAB/uHvrVYae9TFqZHs5jlfpM/ntRl1ag+2tHLLoI+ibnTF4aZtI1Q6JowNTvn1Lg6YQZDoOD5WyGR9nLI3wjnC/3Tucb1EokBdwD4VZTubTYbwllBx8nGBZHaaou+i3p+CHfUF3W9GFUYpuJV6FTAbODBSnsNyjnUk1fhpcHfeGhf8YilTpgqToWwXEkwpQCMSx+lX2ucMKWpj4r0GKSnyYZ7/LeTrSqQe/gYL4Uy6N9afuMdAWiwdtUvijuspQR/2oqjtNfCT0MkiCBO/DgsY3VXyt9yLKXY0M0vobjeNH1LnivcnTnui1dHI8hXsg9UH9ZqZeo78AoqL1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VR/DJnJgKtDHJnStJh6Dk8T3027aBa3uTM/0cs+9Wpg=;
 b=c0cZFZDp9DhkOn83NPvpKo0cOn6PIZ585++3gL5n4S/y4eaSYP8pjweX/m2BKofAvWhB0iX0J0CTj2zX828dm/z1tg41nLukLSRSxfLagAm8BRcRR/ghltTEva3zMSmuBVTs0I31OQyVsFpFP5aB+0NkglWu58QJZeqoG/aJ4A53kRrfgM/tMrfwN8ILhnYOqnN2E2sKxDgAbBSvfkRJFOaSqdFRMTevOK5vULmaLuR58np+1GDn2h2Am90b26/aolSiPeP+0pFuLSIHSED+2AXVmpJGCDZXL+14Y3cOtjnil5E5IOlDW2ST+JuhFe3RdDnQuua9RsaxIGGEF5pd6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6615.namprd11.prod.outlook.com (2603:10b6:806:256::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 10:55:09 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 10:55:08 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZP73OQ1XOEaarRU+iobEkUB6WaK7NioEAgAAlR2CAAFaKgIAE9K9Q
Date:   Fri, 17 Feb 2023 10:55:08 +0000
Message-ID: <DS0PR11MB75293D6F394CA6F255D05159C3A19@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-4-yi.l.liu@intel.com> <Y+rLKvCMivND0izd@nvidia.com>
 <DS0PR11MB7529B43C7D357D8A0C2438C7C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB7529028251B2DFF28A3CCD00C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529028251B2DFF28A3CCD00C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB6615:EE_
x-ms-office365-filtering-correlation-id: 0f975c3e-8a21-4a91-97c6-08db10d56f69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: emx84CV7Dec0IHsJMAghLyDv+oj1DRIU26RZeCvMMR8OcX68mJPjhO26rmHUxN1RBphz4807mEYLQkaizv+KOmsaYc2WuhJnWk/4IztZUivupPv79KjjlJenicVHzA4kRcos96jRjGx1s9DxKL9Iakw+7l8nnd/UXRKkf/ss7zRb1TTqVGkmuPeoEEgHeNRDe+RrbF3zrs3oFX8gaukoAocNN2hafZlYwOc4XHtr1URE8featTu2bpSVCwxjz1TZIHrADnlGouAPxj0t615WpYnXpO8yMP3+OjUOas25wyZaZA5uJqOcBZWByJJIgdxTMDivNKitADtPt65RcemNHq0rsUnl6b6Djl5f53m9/xHWW9HZ4JNIUGJ7mTamPB/ZKbaCBxCZ6RU+4WZeNM2uj5s+EFkCL+/HuQJ81x5oLfQLh9FY8plm4pfIdsRiVaBZM6JbnMecVwPOfn8+iZmM/+Wylg8lR92nVk5kl6CMsghb/N7lxc4KZtoON6WncxY5MKi4uUAXeEktY/x5TXayHDVDEP0xEiK4/LNqsSHWl7XPGI96pNPAGBSJnljmY8dhQhAGyutXkWBj9q9RljFoUxS0fU3xtNcLnLKZGkTGpcB1dK61V8Dhcd0qqjYdPRXJLqq4HqPocnR/2hMYxKTx7rpB4+Hx8oMGN5oTO88+n0oCeOiiNQQuM2jM13H1/D6wPnY/LUmsrI5i2zxaBdBD2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(8936002)(41300700001)(7416002)(71200400001)(52536014)(5660300002)(110136005)(7696005)(478600001)(66476007)(66446008)(66556008)(8676002)(66946007)(76116006)(64756008)(54906003)(316002)(4326008)(2906002)(55016003)(83380400001)(33656002)(122000001)(38100700002)(38070700005)(82960400001)(186003)(9686003)(6506007)(26005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DaXTZ9e/Z2SG/xxTxoACACDttVddxS99eZ0NigvpDhBVK/Ubnf62aXYr16Cv?=
 =?us-ascii?Q?jKnTXQAQxHTREPL+ju2f4OY4YV3xP5HejtZ8EE4bxtsijfxwknD0IbIUD772?=
 =?us-ascii?Q?Bgb5sOlgqG9SOuyPFwtnP691Dx4sQJTyEJVWsjb2Qhniyt/QjXbwWRUqqaXQ?=
 =?us-ascii?Q?47ei2Y5R0+E0FMcxanql2Jr1seh4K0vtvLTLs/REmpWiSpqZvaBhhYwYWkNf?=
 =?us-ascii?Q?apiwQwpnoQ2cfxN/K4LBNryny92K3+agSkcPjBW+QMJBhtjj+mWDP/LiXQSY?=
 =?us-ascii?Q?hxE2XtTy3fERBbmQRTyDCyrGo1KWFopGCPfM8TW8xtql8/blHYcO6XrZkoA5?=
 =?us-ascii?Q?Gl+WQmz/Yd8bbhMHoaQMhSSpLO3AN+56ChCGvZgf5unJVxsRoaTfAgebSRZu?=
 =?us-ascii?Q?jJ5uIs5qRpWgsgRVZWs7rABf4qrgLHOaOpuXujS87Hasf89Vz+zK1PyDKz0W?=
 =?us-ascii?Q?TjOG+Hjz5hAg175jtHBBniJQhRSVnwFwxgSKvd+MVWLRN3oAFkGM10CMaNr4?=
 =?us-ascii?Q?BgZKsNKT97s2fM/y+41n4bQvKXfDwcSHEkK6nktv8Jfiva3Kd6vn2jaWZzo4?=
 =?us-ascii?Q?YdmeaCDr6mbq0YNz+BLOg3nfLYY9MbQaAXObCZeI4esRstUUVOqmYCEYfRl7?=
 =?us-ascii?Q?izQTSnRKR8JUxIXVgtsMODj61SoTeK6WYmictUlROKFKTbz+3yjy3LhE1y/D?=
 =?us-ascii?Q?yy2CPnJPNRoVNmSOHIQGODp1oDzwSUSU5Tb+Ry2vjqwB+MJr+oGbOg4esblD?=
 =?us-ascii?Q?mJ9ihyZXPc44/xfw1JViWhgSpmgdpS7vf/CUJdTysW5H1QafVA8J3L8jtRq/?=
 =?us-ascii?Q?I3kUz8w4uuOf4T5ZWi4Jkdmk/ij4B1Dcw8dty3N6CgDNMQ0fs0K+nMlwgHkA?=
 =?us-ascii?Q?RSkIpM1rMPYhb7FH/3lYYHD7r64oaCbAN3YWQ31RwTXbsdGklETbLum+TyQR?=
 =?us-ascii?Q?oApdxqa50GgubW50j4XK38ci/5XWbiVlr50o2d2zFG0uu5RK6RmN8ztYy6Zn?=
 =?us-ascii?Q?faZCgpUKCQeXcdYAqz3GHMuWLsswxpkGArVTmIhL2MSwxhIEV0kg0V4nXXe3?=
 =?us-ascii?Q?HbQm31NX0mkew9fSF9DLalbLZgjRZibnoRr03ZAWAaBeNl5CnFTHGLraYzVO?=
 =?us-ascii?Q?bcwAo/K14xdxtGWDfpkhEr/XxYPbH7nySV9eKpokrtfwfGmgJfU1A/vsRyQO?=
 =?us-ascii?Q?zB4uYmICgamvM9Mro7AXF175//PcEWwQgr9DO1jQAxc5vrkKXADWJnzciqbz?=
 =?us-ascii?Q?opWJymclW8DGugzRttt2URlDttt5/2qHnbDnSTVuqCRUKmNKMVJKeUMs3EUo?=
 =?us-ascii?Q?5FnuuTo+/jqN6dTkMO1xHOsBMYVnduO759TYd0VJbTYcyMHjpaa11yW5S7H2?=
 =?us-ascii?Q?7jaxzKL6E3hGnNCSWIOfgbgoTRy+TJZufIgpuZQaaEbzRFeZOyIQJApUA0CZ?=
 =?us-ascii?Q?ZP1K1Y44ebU2TNotYYgChFHg3uaYHgaYF4/VwGQuO9/hzr7ubXg6Nep5T+eW?=
 =?us-ascii?Q?pcsDfSQOKiTFRC7Kpl+GsOakJjurF1jX0kCBBmu3EwXIVrMnK5d/X52ZsUdz?=
 =?us-ascii?Q?dt/Rs/x77EGrBoAUYN4vJT7DXhj1dVHFTNCtwmis?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f975c3e-8a21-4a91-97c6-08db10d56f69
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 10:55:08.5856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DyMOaeYIyenW7P+XtPAvA7BjTV++deoSXBd55hXZ6YpqeWBkw2s3trPGpv6EdlerH33eW1HkJ4TcwIffprwqHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6615
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

Hi Alex, Jason,

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 14, 2023 3:19 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, February 14, 2023 10:03 AM
> >
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 14, 2023 7:44 AM
> > >
> > > On Mon, Feb 13, 2023 at 07:13:36AM -0800, Yi Liu wrote:
> > > > +static struct vfio_device *vfio_device_from_file(struct file *file=
)
> > > > +{
> > > > +	struct vfio_device_file *df =3D file->private_data;
> > > > +
> > > > +	if (file->f_op !=3D &vfio_device_fops)
> > > > +		return NULL;
> > > > +	return df->device;
> > > > +}
> > > > +
> > > >  /**
> > > >   * vfio_file_is_valid - True if the file is usable with VFIO APIS
> > > >   * @file: VFIO group file or VFIO device file
> > > >   */
> > > >  bool vfio_file_is_valid(struct file *file)
> > > >  {
> > > > -	return vfio_group_from_file(file);
> > > > +	return vfio_group_from_file(file) ||
> > > > +	       vfio_device_from_file(file);
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
> > >
> > > This can only succeed on a device cdev that has been fully opened.
> >
> > Actually, we cannot. This is used in the kvm-vfio code to see if the
> > user-provided fd is vfio fds in the SET_KVM path. And we don't
> > have the device cdev fully opened until BIND_IOMMUFD. But we do
> > need to invoke SET_KVM before issuing BIND_IOMMUFD as the device
> > open needs kvm pointer. So if we cannot apply fully opened limit to thi=
s
> > interface. Maybe an updated function comment is needed.
> >
> > " vfio_file_is_valid - True if the file is vfio files (group or device)=
"
>=20
> I guess your point is this is also called in the pci hot reset path. And
> in the reset path, the device referred by the device fd should be fully
> opened. vfio_file_is_valid() only checks f_ops, which is not enough to
> show the device is fully-opened for cdev fd. However, view the high-level
> flow, for cdev fd, the device access (neither VFIO_DEVICE_PCI_HOT_RESET
> nor VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) is not allowed until the
> device is fully-opened (done in the bind_iommufd). So if the
> VFIO_DEVICE_PCI_HOT_RESET path goes such far to call vfio_file_is_valid()=
,
> the device should have been fully-opened.

One more thinking on this. For a single device, my above reply is true.
The device should have been fully-opened when its GET_PCI_HOT_RESET_INFO
and HOT_RESET path have been unblocked. However, when there are
multiple devices that have been affected by the hotreset. User may only
have one device that is fully opened while others are not yet. In such case=
,
existing vfio_file_is_valid() is not enough. Shall we have another API for
this purpose? E.g. if it's cdev fd, then the new API return true only when
the device is fully opened. Any suggestion here?

Regards,
Yi Liu
