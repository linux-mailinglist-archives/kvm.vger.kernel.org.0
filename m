Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114856DAE86
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 16:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjDGOEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjDGOEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 10:04:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9B849CA;
        Fri,  7 Apr 2023 07:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680876252; x=1712412252;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TMSA+zpKxKjscLa5Hr/FnVHXPzLt0Vr7SUtba4wf1uk=;
  b=BRoqMP9T2ezDBfd4gj+3J4fz4x9ERWOWzQslVeKegG1vkt5BGRusvWs8
   ooJZUgBRdC3AHxpYaSiIFsQYzSj0JDkq+BA/WhRTWMtUnO8WatIpwQrMC
   ULrkiLwsbDKEd9IekMLaozsvv1mVV3rJBZeEgGOI5APqlHsPvdVXYjRK1
   8fPn6dkFJeUk/TOwjGz2pzuvSWMuqAtligD1VUbATO98p4FGSnAGD+a++
   9/UO2UA/ljBMyEGSuw4TSz51rGeraRrsG/Nhna5ksM/vu0+/KUWgR+V2p
   0SLBaKzrTYykrE8qdV4JiF7ZXlCmkogh/vP2LQrT4bLsvtG0Hr5AyxFqW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="323360972"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="323360972"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 07:04:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="664894690"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="664894690"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 07 Apr 2023 07:04:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 07:04:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 07:04:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 07:04:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 07:04:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=latcwJECmZn+kXb9iAXE2xvzppUZQIAAJBgIj7dwp1isOAaT24PY+cijEPI2ThaAff0LiLbjH+HQh6oQtohVcYCCSElQIdZI5b1vRSnc5NQBQpFP8OuU0M8ND1+5zJenjbogD0lOf/M2fvfFHPUfe4l4IwplyXd8dxAtpNgiW17GRWMG7a80+PRJFL7pN4iLhiV10DPI0pygM8lLoCabkC2GshGFlWiW8EAWj3G4BqbmUfwJULoZ57XH7Thn6YBjmigw5tKygaY/LX4cxXZ83dwiySzLVzipPrw8tw3G2qCG+itcNdrx8eldv3Cz+mjiSyL+qOAq/fSyS9qQuua2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvYPgygjoA+ckHdHZLV5EaaiZvh+L3pbRICubRkZy0w=;
 b=RciSf76fWxF4hcc53qThCyX0ix3fMHFi9JxY6oKyQX2mIqZmNH6W6eOgwxeBJ8DrFOvkC0XgJdLDLXz35hOajmbO47/2phEkiLFGOX0iOOB1HldNQWGftnsG1hQBiul8Z9V+BZjDxZc2y47Xub+o1aAROttU/F5ruB+lfcfWHH2U8OKUjbpA0wAiBKrsrdVd5rtLKd7WPy90vj4O+qGyaww//XbiUTKOXFVYR4GcMNEvUTZNAaznkV6IuviGwCuhGr+BfWckar1/Qf2sT+jE4jMj/7vZnCE+hZgsayLqGN0F2CC+Xgk2bbETDzy6yA3G4MQ1eyjU732pk65tiTogkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB8324.namprd11.prod.outlook.com (2603:10b6:a03:538::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Fri, 7 Apr
 2023 14:04:03 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 14:04:03 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQgABjWoCABfZ/IIAAIQaAgAAVGHCAAAktgIAAAk+w
Date:   Fri, 7 Apr 2023 14:04:02 +0000
Message-ID: <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407075155.3ad4c804.alex.williamson@redhat.com>
In-Reply-To: <20230407075155.3ad4c804.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ2PR11MB8324:EE_
x-ms-office365-filtering-correlation-id: 587bd1da-4093-4a50-72e9-08db3770f12e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2tmyii705eokvqe/Ikf+iAEl4y0Sp7odQ0yuelLlSkr4joZmZr9V92xLCBK0JCjgC5OSM78Unc2XzjXZZBiaHfahW7IUUhd0ULWSbULIVnfuP7cLdc4VY84Um86jw+Gdh7Tnx396oYI3z+1FCBCLuaH5S1SKYi/eFYhobAK6bIG13S/oO9G1qmtPVWyIcj/aNb56GFX6y2djt4pDBI+T/szr3D4xVPoW7G0+H5PHXeDc0o7NSl3GBzfVmSsipt1bKwHtR2PUHNpTMnduoMvywicRK5U3+b04tA5AvIM1d9AhV9DfSU3v2GfRLEHsd09uEytHG7ykhhiyx003PfG1Giotm+v49wNKeqZXMUOZ5WeGhRx2YBj4G7vGXQV7UtXcccq5WgowDh2vyp/CRkssagrQ0SyKAVmwSJSdybRVbGXw/n8y4AB66JtdTGpuxPtc2t8GAGdTJR3y2p70jvP9ET36DBRHp0bNFl7u24MafPlfIb8w12VVmMVaDlJ/tHiwyrBgobswVe/UTZHhQLueAkVj1nVHhMQamA1YdaBSx7c4PO0b1cyO4NuXW73p7g9L9xhNvbcjGzIlqhoqIUBH8Azv/Q832RB8ZYFHgK2HEyA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199021)(71200400001)(9686003)(966005)(6506007)(26005)(186003)(7696005)(2906002)(41300700001)(64756008)(6916009)(4326008)(66946007)(66476007)(66556008)(52536014)(66446008)(8936002)(76116006)(316002)(5660300002)(8676002)(7416002)(54906003)(82960400001)(478600001)(38070700005)(122000001)(38100700002)(86362001)(33656002)(83380400001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fHr/P62kSVB+2ga/Oqm/ERMRCoFder3iAzg9lA9aNBHOpcknuFfeQt7StK55?=
 =?us-ascii?Q?CS7ftF3J8iK3QMqRiP4n9qlMcLTgyfOOLEw1oqRVbw/ryUVy5sqlp5+qZpY1?=
 =?us-ascii?Q?KmKPdEtf/X37Ml5CVdoVxxFRqGPhtNe1bqOf08MxgvE8Sif7OhzuZU5In0IY?=
 =?us-ascii?Q?ExI/4Z236q7dyUmgsPBpayY6+3TusyArceyxR+zwJ2O69gi5xiZGQvplgxyA?=
 =?us-ascii?Q?xDOubqKmB3+ZvAxTLJTu2SBjgB8TgThA/kj915ss1b4wlsGY6x2bd2oYyza5?=
 =?us-ascii?Q?TWbnMHcEogLvXaUh1pMG0DOuGMMdUkHWI5a8yRu+iuFFcLT9VTgB9bhljLb/?=
 =?us-ascii?Q?nwAuC2EObu9yKs+SekMROfEBBnsKbCKeiCkoqDPU0OsIgK/ezOlF+w69krQy?=
 =?us-ascii?Q?ER8uLwKMGvYTATD1o0E8uvsOHVzfDHoV3+tUOylwTQs8vnVkIkN92bZJn0OK?=
 =?us-ascii?Q?U/8CdVEVjy0zKbJYp/By8zd3JdAJ/aX/Ry9MFW5tZ5MJbRZETwf/lVp5YK+R?=
 =?us-ascii?Q?1X9UyONaZ9tiLq6VGBiX/S+MbkOD/JGN0z55LFkpCDUpCDadjQVM/QcbymCm?=
 =?us-ascii?Q?YVQ6P7XojqTfFZWxUDvgtB8Q/NcUZsJhLifuVzrCr8af1TKF6edAHErw4PQh?=
 =?us-ascii?Q?PewQPjyxlizeNLM1UlspH6QkSPnyvjIOoilzvgFkGfXzPz/UT0IIOJ/5yVPc?=
 =?us-ascii?Q?a4/VXTP6lAQxlj05TEhLgRu2jc5XxYz4Tf4+Fg9RZhuvaypf9md+dx9LHgXp?=
 =?us-ascii?Q?P7DKiMV6sEYByGFcp8SA+deX8xyMXJXsgm3Ik+L97NW3bb0UsD6u4FY0KbSX?=
 =?us-ascii?Q?RMJZPobRVCNWn3a+qEx2ky26i2N2AmlF+CLCXyXBwHJqay+5/0FhUBL2yvHv?=
 =?us-ascii?Q?rBvwJN/gzQGv6QEH2RDuwANVymTMpSu1RCBavA+qOPScsSHy7vTZklrd8G7I?=
 =?us-ascii?Q?yR9DuRDjeYXinS45apsQX4l8TnlRSO4hI1RBiRMuj4j1r1Bo+kib/L7xQ0ow?=
 =?us-ascii?Q?uaWMl+NXEKLklAMqe72YvEpTpKF23XoMWcQbV3Csc7b2gb0JDgMRAd5KFTHn?=
 =?us-ascii?Q?chY4zZI9tZUpS5cxbjjpSuyzrBir7f35j8RbBU0nB3Ek8ql0lSlDGL+j5b++?=
 =?us-ascii?Q?dq6FDEh0UB5J9xcf+htTTZ0lZp0Bnenvf2r6UThzlbcypj/r7r3qeMLn+7j7?=
 =?us-ascii?Q?vJb6dEov3+JD2+6S7kB4GqSVs9JFKsEOmvwKzYcuOLdPLbBXUhHzbSHJ7cVD?=
 =?us-ascii?Q?t92WnOOiT5QwWtoXzF63iveSxG5YyAa3rXPgtEZYPQVHOoMRxbth0zS8ddP1?=
 =?us-ascii?Q?7XLxwJmt0VDfGJj4HZh+0Kaizfyf1VdEAY0T0b1V7GxqoFL8pazxPaEhVnVb?=
 =?us-ascii?Q?nnfIOiPS4R6Gi1AkI8jmcrNu0P0a4f5VZraSKrb1GyDEay0fKjJ37pwPA9am?=
 =?us-ascii?Q?d95HSJ1oLn0o251r9e87Jd1BZXbsAHsuQsMCpTzWl+Az5FwMR0cImrSETVs5?=
 =?us-ascii?Q?ftZFCpf2sorrI4/d8SbIDJyZpxlohWU63UgE/xTB1ecptBc/tth/OxQwU1UZ?=
 =?us-ascii?Q?om9pAlCfBFwjvk9DLSk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587bd1da-4093-4a50-72e9-08db3770f12e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 14:04:02.4705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Csh19TiWbcXoveecaErb9iDnT0xCxrucT3Sh+vV4uieCoxMU1ln0VE+gDHcT2/Xqsj+Vh2zvgH6BaSd8X+c2hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8324
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 7, 2023 9:52 PM
>=20
> On Fri, 7 Apr 2023 13:24:25 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, April 7, 2023 8:04 PM
> > >
> > > > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci=
_dev *pdev,
> void
> > > > > *data)
> > > > > > >  	if (!iommu_group)
> > > > > > >  		return -EPERM; /* Cannot reset non-isolated devices */
> >
> > [1]
> >
> > > > > >
> > > > > > Hi Alex,
> > > > > >
> > > > > > Is disabling iommu a sane way to test vfio noiommu mode?
> > > > >
> > > > > Yes
> > > > >
> > > > > > I added intel_iommu=3Doff to disable intel iommu and bind a dev=
ice to vfio-pci.
> > > > > > I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noiommu=
-vfio0.
> Bind
> > > > > > iommufd=3D=3D-1 can succeed, but failed to get hot reset info d=
ue to the above
> > > > > > group check. Reason is that this happens to have some affected =
devices, and
> > > > > > these devices have no valid iommu_group (because they are not b=
ound to
> vfio-
> > > pci
> > > > > > hence nobody allocates noiommu group for them). So when hot res=
et info
> loops
> > > > > > such devices, it failed with -EPERM. Is this expected?
> > > > >
> > > > > Hmm, I didn't recall that we put in such a limitation, but given =
the
> > > > > minimally intrusive approach to no-iommu and the fact that we nev=
er
> > > > > defined an invalid group ID to return to the user, it makes sense=
 that
> > > > > we just blocked the ioctl for no-iommu use.  I guess we can do th=
e same
> > > > > for no-iommu cdev.
> > > >
> > > > I just realize a further issue related to this limitation. Remember=
 that we
> > > > may finally compile out the vfio group infrastructure in the future=
. Say I
> > > > want to test noiommu, I may boot such a kernel with iommu disabled.=
 I think
> > > > the _INFO ioctl would fail as there is no iommu_group. Does it mean=
 we will
> > > > not support hot reset for noiommu in future if vfio group infrastru=
cture is
> > > > compiled out?
> > >
> > > We're talking about IOMMU groups, IOMMU groups are always present
> > > regardless of whether we expose a vfio group interface to userspace.
> > > Remember, we create IOMMU groups even in the no-iommu case.  Even wit=
h
> > > pure cdev, there are underlying IOMMU groups that maintain the DMA
> > > ownership.
> >
> > hmmm. As [1], when iommu is disabled, there will be no iommu_group for =
a
> > given device unless it is registered to VFIO, which a fake group is cre=
ated.
> > That's why I hit the limitation [1]. When vfio_group is compiled out, t=
hen
> > even fake group goes away.
>=20
> In the vfio group case, [1] can be hit with no-iommu only when there
> are affected devices which are not bound to vfio.

yes. because vfio would allocate fake group when device is registered to
it.

> Why are we not
> allocating an IOMMU group to no-iommu devices when vfio group is
> disabled?  Thanks,

hmmm. when the vfio group code is configured out. The
vfio_device_set_group() just returns 0 after below patch is
applied and CONFIG_VFIO_GROUP=3Dn. So when there is no
vfio group, the fake group also goes away.

https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/

Regards,
Yi Liu

