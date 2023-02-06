Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06BC68B843
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 10:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjBFJJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 04:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjBFJJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 04:09:08 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD40359C7
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 01:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675674519; x=1707210519;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dMvpzlJJ/ab07fEHK/P4N0z63gx3z8k83OqhIoZJMKk=;
  b=WBuAzsoYxHGBugM0LanP2iBYV5fbaxBEmOj6BMebOdgAzuGKjaEupYWu
   2zoLu/NsvOAVC/aLxmvlzxFMtZ7c/YqS8luLznQ2mD7g+860UsgCR8qeA
   jUTrTl9QTl84X8NQRNbgJOXC2QMCJndhUfy4ME/y6Ws9dpqT2Po1CDFkn
   ev59S75blkQUFll6Iy3pCdh7VoLDRUreKBLXDvEn2FSwvi+99AOtBJ0VF
   rl1V2RBbgqcPP3TDFUZmo6whTO7rFf+vapNPtoIyesBIcH/p6VP44px3r
   HwM8ljOJffuihpLeIMdVmo6CBK72keSviH8o9lDFt49r1utMCZ6GpZcYY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="309496204"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="309496204"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 01:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="911863263"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="911863263"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2023 01:07:41 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 01:07:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 01:07:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 01:07:40 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 01:07:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlgvzxR+PR/s87LDfzmtYTJOMejFJf/5fSwh0XAUp5oqeFl+Hoi1AeIKeVTGolqiWcqfkvk8dvKoTe5tpDS6N9E7yyXUgqvDV7sDcZHl3ZDWr0T9BRiZ5UoF/QezD5ctX9qintRm8zF2VF7EW+mA4Jm99Y3XE2BUXX2btutWVPumePSWmOYn6Zwy7pkliypN2qL93smP7VfUD4RQVMZAoGolfpphS6AvoK0hK/PQZkZrzbFhNOTtGLPl65SWhgKJTBeoqYWrV6EvOG0bAU9azuBZz8uIh67BO53Tb/E7xF7+G8DFR9rCIWLFekDbuHFDROhgFm+8QnL/BNUHIy2/VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MmEc5pqkmVsybA6+UF1lFD3UVOmECC02I0Zoj7pbv4=;
 b=jb3wuwqGbLqmmpZGS+I7gT9/Avd5+abgwiHwSLlTVGFHNJJ0UymEYyUFV52waGaJ/Z0u2XqTU9pK/Y5NxajN4zARMaDWTTnkcRHb5rvIkcYzNIpkXUU+iqI8h7qeyVoRHQazYzoMC8rdMCUorHxtHxOD4q5eMxPj1gPDNhx68lLncSVZqNpqpL1v7dMSJ8xumHjK56L2x/p9UdHYmg4vM81XK2cB/VO3tGNujFLa3sXaXqo9pxe0HcswHLkiIBWstj9V4gX6fMLSHEDq/m5iTtVbKtCvFPuVy/SbN6By9TRxTxCqARtE1/He3qi2GmMzau5w/X5b5Qb3469g3WV2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6655.namprd11.prod.outlook.com (2603:10b6:806:26d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 09:07:38 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 09:07:38 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 12/13] vfio: Add ioctls for device cdev iommufd
Thread-Topic: [PATCH 12/13] vfio: Add ioctls for device cdev iommufd
Thread-Index: AQHZKnqc/SVbLQMxcUaLN+TmTkbzla6m9loAgBrJcpA=
Date:   Mon, 6 Feb 2023 09:07:38 +0000
Message-ID: <DS0PR11MB7529F1478765F363FE19480CC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-13-yi.l.liu@intel.com>
 <BN9PR11MB527653190DB88471BD39FD978CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB527653190DB88471BD39FD978CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB6655:EE_
x-ms-office365-filtering-correlation-id: ef704f25-e72e-45d9-3b25-08db08219838
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rHMCO7jOEU3XcnhVO/hauoZlM9dq10djMj1CRicGRWGy0Qu1k+mk2wpg2rSUJi+SCCtywA1skLSkEgQWSLBgyT/v769cpoflynjkzGLZuVGv7M1Dghldp7O1YQOgNRZek7/Wx0k+N81zGrlIbcjjaGcNaWQf2pqyMwJcben1BdAK5lPi3DCFSzAPljh3ir//1ly5kBbQIUbCzJDl/nUVIphPhFNTd9gei19gY8WQVIhVbA2DrESUKsW4SllwvWwu3NJLasT4SvVobF+kOY+1mcbvHrer0OvoyBMX8nEGRQa3e0cDhP3i/HoigN4DVEeWt02xyZJbKsM2VvrvUrGKWulxT0pr/X+4XwiFw2OyIz3x/I2/ddqI1hfN0GW2BzrakheYeeqgp0k3XnRzrWgns7mkGmp+qDb2WFc1JDCiD0r7d0qn1vIOzoCkcqmP9buFFi3DBofV5pnDBQ9M5qNtzcjviXosnHcVoObU6giUlfKKhEZg9/6V2NrTNVoFvk0AVaK0k2fFqPtvGFUaatI8oWixcDzF6JR7OsV76sRJug8xXY9p8Wvwli+j9q8bGi3TisbfKaVOXjjDhbQmGRYrbNnBn8cb0dwTruERFeZjbp4x9Mn5ozqB5msQR1gKWaVUESYIYLoyf/coxNjtewWcXaK5yr4SNyw0UKrQX7L7BjuXu97vQNwkXd+FSRhJ1hAxBIhw3VlM/Pxe7dXAIxnmFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199018)(86362001)(2906002)(33656002)(38070700005)(8676002)(71200400001)(7696005)(55016003)(26005)(6506007)(9686003)(186003)(478600001)(5660300002)(8936002)(7416002)(52536014)(38100700002)(41300700001)(122000001)(82960400001)(110136005)(66476007)(54906003)(76116006)(316002)(66946007)(64756008)(4326008)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xj7BUiXTRuUXS5TNS+zSdKJmT7/ThdEy0Bf7H/vKd7FhB6AwQ9Lb/dpxQZX9?=
 =?us-ascii?Q?Gqp1JHS6XzUObMcjPN9i1E2q+jFv7F1mnN5s7NHXGoA9+NW4kTzKl9Hrd6L6?=
 =?us-ascii?Q?W6fnSA+7fcfYlzBO8+abYI2eoW7/yEQEpSx/bb4JibzkrpMxhOeLLVmmvJ5i?=
 =?us-ascii?Q?ZJlOKE7+eYZqFGHHdYmwrS/kXPjhXBev4zlVWw5rH6m5PkUUkAwB/wU8q5/m?=
 =?us-ascii?Q?ZyLfXOPALNtFbJpR/HyTyWadACfrbJFiPyvfQVNddv67UUkQ/U9rfgEoxEJn?=
 =?us-ascii?Q?4UsXiqs35R0KLdO0EP8ZE26JmaL35r8CUcCp7tCv/qqlKOuN2comQr6Aak/e?=
 =?us-ascii?Q?zySoEQnCv7ijQIczGMdmwZBTGqqDmyr+gEdaFY8LpfgyDQDgzXiQ0llV94S5?=
 =?us-ascii?Q?859KpoOAiTkvJG3ZyWEeh7ij+nqMO1e82o/kFO++EDWmF/JcEbBdluWE49yx?=
 =?us-ascii?Q?Y82ly9k49+NCO+67G8wjJTK3KGX/sL+6H0XBJrVV9qPrjT4aXz8emNel1kEj?=
 =?us-ascii?Q?fyj+sVIWSj/6mRAjTCNdyEqYzk+DbtRi1UC4+RybSd2MNmX33h4PSE24M/r9?=
 =?us-ascii?Q?w+h2jk80CMMZamwXtbZZKa8GMHcX1VFr4QS98PZE+SAHvTkJIkX+EyUxlKsd?=
 =?us-ascii?Q?x06tBNmUKzg22kWQZqBwCpcoubdo/Q5S46hRdFNq6uf/61VIWuTzdRDwsRLA?=
 =?us-ascii?Q?h4LunzcaM5CHvBBts2ULxfYOgoAyFbiut8YarvHqCXCapJFuMpv9GerJ2Tak?=
 =?us-ascii?Q?drBH+kWYjzuw1cj3zq/eBsrNKtOZShZgnhFib5lmCreq431r0cX19kc9ohjy?=
 =?us-ascii?Q?Vo7AAhFIRB+qDUPw0Rlv51LHgTvh1D7HE2Im1vPaAKeqBvHmx7FBJeRBYvCb?=
 =?us-ascii?Q?GF1MkiidVoMnGSutXwZf/0P+dBspi9k9PAQrcmRMF2y+zMPO2xaewGrwe/fW?=
 =?us-ascii?Q?09zSibaAuPfknrQatL7Dbd0NJdoO+Sz8Rccnn2dy5pvtupxlsgI9vVyrWOYS?=
 =?us-ascii?Q?Tm2k+8ku+50k3l4cwD6Jy19GMh2TpBCFQEfWWXIxdRETNi4yLkGWjjP2Tne5?=
 =?us-ascii?Q?TKrrJJdVm2FUaIg190vHAParrgOa7wOj6C7/W2NKJeXtU9ubpAQb2UXy/QAw?=
 =?us-ascii?Q?8Dj4DyILzoZMqwG70SYgg5/ZO6/URGpnfNhCcaYOWodRwq16su2ggsZjqr+w?=
 =?us-ascii?Q?GDlXRfDfQ6AsljV+xKQMVG6kxIL3D6+J49LqEoL2mTpyh5EaZGcprv2T5SDn?=
 =?us-ascii?Q?aaHVpsmsD5L8fK6exZ4ba9omIqYCmevvCEkEMJNIZceh+GegyfxEOPMx5+Vr?=
 =?us-ascii?Q?Gzz4cCCaNqrBbyhZUe1QRtXE2q3lC30D/MTQpX3QEhHa8e3Tb+V/QFc0SqTn?=
 =?us-ascii?Q?ocClUZx8Rqe/QwKc83GGounj9u1QL4NDokQ8ND6PEkrqbIx0LVMP3WWCkIaq?=
 =?us-ascii?Q?/RHNOArJgkWBmAXNysapDCkQBv7Zg4OWcHyMFhkEIjs089hg79zA0c4vNijU?=
 =?us-ascii?Q?naMjl1uuHnTqAFSbOwsU+CJ0pVfcQkySo5e7R/McDuT+qdfuS4YUAoRuMH+L?=
 =?us-ascii?Q?NlWfuF3KA0p0nUOLJT7E52scG5/Lb48y3zQkiSKT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef704f25-e72e-45d9-3b25-08db08219838
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 09:07:38.3666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BTbk/jjFy+EnpxuQ4EHw8ANTbsUeVtqiO6R6Dp/VNg2hJlmJ9NHnQdvBEWoYQcQyq4FKakzwKsKy+/FO5GH1Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6655
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
> Sent: Friday, January 20, 2023 4:03 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, January 17, 2023 9:50 PM
> >
> > This adds two vfio device ioctls for userspace using iommufd on vfio
> > devices.
> >
> >     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain
> > DMA
> > 			      control provided by the iommufd. VFIO no
> > 			      iommu is indicated by passing a minus
> > 			      fd value.
>=20
> Can't this be a flag bit for better readability than using a special valu=
e?
>=20
> >     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach device to ioas, page
> tables
> > 				   managed by iommufd. Attach can be
> > 				   undo by passing IOMMUFD_INVALID_ID
> > 				   to kernel.
>=20
> With Alex' remark we need a separate DETACH cmd now.

Yes.

> >
> > +	/*
> > +	 * For group path, iommufd pointer is NULL when comes into this
> > +	 * helper. Its noiommu support is in container.c.
> > +	 *
> > +	 * For iommufd compat mode, iommufd pointer here is a valid value.
> > +	 * Its noiommu support is supposed to be in vfio_iommufd_bind().
> > +	 *
> > +	 * For device cdev path, iommufd pointer here is a valid value for
> > +	 * normal cases, but it is NULL if it's noiommu. The reason is
> > +	 * that userspace uses iommufd=3D=3D-1 to indicate noiommu mode in
> > this
> > +	 * path. So caller of this helper will pass in a NULL iommufd
> > +	 * pointer. To differentiate it from the group path which also
> > +	 * passes NULL iommufd pointer in, df->noiommu is used. For cdev
> > +	 * noiommu, df->noiommu would be set to mark noiommu case for
> > cdev
> > +	 * path.
> > +	 *
> > +	 * So if df->noiommu is set then this helper just goes ahead to
> > +	 * open device. If not, it depends on if iommufd pointer is NULL
> > +	 * to handle the group path, iommufd compat mode, normal cases
> in
> > +	 * the cdev path.
> > +	 */
> >  	if (iommufd)
> >  		ret =3D vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
> > -	else
> > +	else if (!df->noiommu)
> >  		ret =3D vfio_device_group_use_iommu(device);
> >  	if (ret)
> >  		goto err_module_put;
>=20
> Isn't 'ret' uninitialized when df->noiommu is true?

Done.

> > +static int vfio_ioctl_device_attach(struct vfio_device *device,
> > +				    struct vfio_device_feature __user *arg)
> > +{
> > +	struct vfio_device_attach_iommufd_pt attach;
> > +	int ret;
> > +	bool is_attach;
> > +
> > +	if (copy_from_user(&attach, (void __user *)arg, sizeof(attach)))
> > +		return -EFAULT;
> > +
> > +	if (attach.flags)
> > +		return -EINVAL;
> > +
> > +	if (!device->ops->bind_iommufd)
> > +		return -ENODEV;
> > +
>=20
> this should fail if noiommu is true.

Yes.

Regards,
Yi Liu
