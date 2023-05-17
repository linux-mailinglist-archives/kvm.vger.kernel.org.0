Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD3B705F19
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 07:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjEQFJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 01:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjEQFJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 01:09:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00431FFC;
        Tue, 16 May 2023 22:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684300195; x=1715836195;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9Gu3SeHmAO8WIxlFj+e9CrhjyrqklEw/SvHVOz5mg0s=;
  b=c0niVxEeFAO/aGmMp0KlUr5bEUt9u7YripbC6am8FFTjhg/F867PWE3N
   KWyDFXpkVMaMrVJQogGUICfZFe3Pt469drrF/pPjjOZLe1v2/+DTKFTv6
   S+iLbDcixHtzZE/3rlxuW9KuHiRg2Pfw97zqsUzNQxs10wkacA32CLuZ5
   4X8DGKrogbzAYNhx+11/eLAWQAD9A7a6m6Eu5PHtj92uFLXRU6Td+hnoS
   rdUFiR6hup/yArFhDa2M+TpbqThZdUr5aMn6HGRKPyV1/MvmCS+JYZ1XG
   Tx3WakKKQGRzpTpg518cx+WuqDnscGZfEr4F3C51vOlpSb9pjsJfjGsmp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="415075606"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="415075606"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 22:09:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="701607318"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="701607318"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2023 22:09:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 22:09:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 22:09:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 22:09:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 22:09:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krvaUmryK986gjdJ2gMjnoCMR6ymVWhZHln+f6CoDbuwTcTqDu88OCNZoLnomq4J+JX3Oq+kKaow7NljRkK69YjUaQNRfriJbdJuj8IVPHVqSPE9JUs55dsPEH6lAKWXKpkVYi9tLZ2iriai8KpGAKxsqjEa9AD+SEpYckvU+M6fuL6vGR+Edl3G6COhl7ZTfQr5Zpw8ZLJ7sanbBuGjcVC0HY1bSBbu+kQSRmJUKw/zZObjFBsWxtZ3puyXVl4jMf2jBbY8vMU11Gtc4zTQR5QzKMZAph8nPzLM6WkVX8o66WRs+BrI9QEZlziKNU2fBbYY5cIJEeTd5rTlH+YKVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=87vN+snK0ACml4F5MWPR/gRNL6siFB8zXJyWZf+WPXM=;
 b=D34RHap2iNOzML+nwCQzcsz7ASLor2afvvo55B4QLNoD3cihB9IZ9G9MMvLR5FUmN5ErjNtbRPuVAo4drCSvhPkLR08I64jP7Dgel1ruI1sQX/cIiBizmTD2vFOobHg0aAOL8F5j7xJYrLKRF6v1/D+2f3CUqpbCcVioOWxDguQ6wKm7Hcnj0xoNlheHILMy2NyiIZ2Ql97pbzg1lmZ53fqBufia5AWTVvS9P6bZKijRY1HzOT7Wn6lv4D00Q9NieMPJ/poCf6gOKSdYu10s+cT2YMhDwFVUu9vwRcPx66sB1LIbZuCJy3w66J+zjT6bsQqFLWXKh5D8jnDiIgASoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7924.namprd11.prod.outlook.com (2603:10b6:930:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 05:09:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 05:09:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Baolu Lu <baolu.lu@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5ABFkrqAABzyefAACRsDgAAgPFxwACXecwAA2iwDsA==
Date:   Wed, 17 May 2023 05:09:44 +0000
Message-ID: <BN9PR11MB5276355D5D025F6F29970BF58C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230510112449.4d766f6f.alex.williamson@redhat.com>
 <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
 <49063f2e-4ab5-1e20-093d-e1a0b3c15481@linux.intel.com>
 <BL1PR11MB5271F073616B5869E380DD208C759@BL1PR11MB5271.namprd11.prod.outlook.com>
 <ZF6pNjFCBgLt4phV@nvidia.com>
In-Reply-To: <ZF6pNjFCBgLt4phV@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7924:EE_
x-ms-office365-filtering-correlation-id: 81b4d667-f221-4be4-83af-08db5694ede9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w8wJ0qxkEVO3gz+UQmnNzTnBP94eBfU6IvqSHqad5AbJpwN2nBfyzuG2S54r+KTsIKa/Wut8lUvZo6n9pO2RYNEaiHSuN4e7phAloMyJs1VAHYDo0lrpaHYKBVWl+3xuQ471MXNxSbLJoVQJAMZUQxue2sHMqB/d6wjIXmZVusO7LJm9LPOxmNNqMpHXEoZc7+vD4vuvEmfJd4+EDqmOYEg30nEOzoteONrYgJpzu3MBJfE++ONTk6uzvQZ0ccVUJobm17ofkP1SqNGyNHdbK+c7+QMPV283cSmkTSGXu82Sl7x6H4lUGmMUgy/1zbTIZrdAwxMW20QL9RT1s8EL84vY6ROJvWMQe5YRtWNQkAmaNwcUkAFlElIGshzTN/rcL8kGXbnh/eoWQxrw8fci641MNC9uBN0/E33KGGx7/Tf7o2s92o4e+qe1noAaRHxLYMhm4qWOEy02zsG1uf/iVkv0YeUf9DATA9YK8ONyHgBpFvskefkWh6hoVRAoiBIBnKLfKqCHTarxIeY4TvoehNyMNqfyHaQhzfVRXdyXF8DDL/pp7/QjNGImV1z9LbNvZKynN0+QI66zdeEomz/Uz696GZ6oNMX0xOS6RNHgGhPy9oJa3gPuN+eP0aEmm0OZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199021)(9686003)(6506007)(53546011)(26005)(55016003)(83380400001)(122000001)(3480700007)(38100700002)(33656002)(86362001)(38070700005)(82960400001)(186003)(7696005)(2906002)(54906003)(478600001)(66556008)(316002)(4326008)(6916009)(64756008)(66446008)(66476007)(8676002)(8936002)(66946007)(76116006)(52536014)(5660300002)(71200400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XfEURY+ZLFm8Mz0kkeCxcQmcmTwcWPlsYD1RP2eAqJ6M9cgo8Pe8J4GAVWfB?=
 =?us-ascii?Q?+p5oV5gg/4PhSMyNyB4RZHyeEU+R9vymxQodo5bn1CCY5ZpzD7AcrlR4vtmT?=
 =?us-ascii?Q?x1U2UK/GT3WOVljmdHVgGtfGeYM5NC1QaQIcQwiRuWFiWosurlvuq91UFYXV?=
 =?us-ascii?Q?y48K81vpO6nK5WvFGF29QZ2tbZ8gh+mP/2M3Wbj3NAGQ8Zy3tYvDrk5QUFx5?=
 =?us-ascii?Q?NEJhBYIBOHdqdjiiyd2a39mP43zGBxDKayfIlPW7ILsfPejf9EF4bVn+C+/1?=
 =?us-ascii?Q?j698X5+P5BeNsJr+uQO/VIPmSZhQVPpsEIr8iLA2SLnHFQKp2kizmPlNlfhQ?=
 =?us-ascii?Q?WP62sEuuHDyFMvUTEBQMokBo+n+dPuV7c0/KZ7f5Z9RTxkTMBjb3Oh1yi+BM?=
 =?us-ascii?Q?RT5GPZMTfbcdEixkXvyYjo8dzCytb4CFtGmZhrBUT6Kzmd+Jqwu7JBVCPeOx?=
 =?us-ascii?Q?Y8ft6RpOzHffi3xr3er6JmfN/L4u9A+KtzMLBcp2nuuaTvaCgOB0cIYomV4I?=
 =?us-ascii?Q?czAbAsWrMB4Y3Ie6zbCGBYRo/Yf7swp1ypqFPRjeHlOP5mi1UAhBfKubWqaq?=
 =?us-ascii?Q?AkO+xg+Y76S0weObLHVhnYZYMlQZUPbbCL4MVN7CcMptrej7aG7N5E0MKMXN?=
 =?us-ascii?Q?XHvzVoemGNq+K5VIa9+i4p8+OsMFL/CaN/1sCZy//cStlLuWnz9BsoOuPwd+?=
 =?us-ascii?Q?ciKl0FKJauoUg8UrRbzp9Bh+atjmezNQu6osyDoyrV4bHfxJYIfCVjytTdkl?=
 =?us-ascii?Q?AbtbkqGoFmJyooHHvMY8A3J751fA1ZbL5TO0gqqtz8d8cVKIwsweyldMr+7e?=
 =?us-ascii?Q?dGzvDz3veruncEQraw7RyLR3/t1wuKx00KU87UINqy5tshXoHMMn+Oqjmm9e?=
 =?us-ascii?Q?On22rReejcbBItpm4taERdlAFTflJrN4trLPzTWXvCJmAWC8XVjyq+tDxR+7?=
 =?us-ascii?Q?xtcLWlsQAlywsKwJe6SJTu6zuLGj+lP9yc/Z90pmkjRocGOXzbF1WXxeSJDj?=
 =?us-ascii?Q?IjS/C/+r0lEdpI7f2oUYge0Xy9oilaOAsv8G6r4MHfZP3yWkYD8cx0ACJrE8?=
 =?us-ascii?Q?9M0g4xylpFsnrybyxamM+gU5n1rjSthBjpP0+MLFJvRNKO2sMqk6xqURa7hK?=
 =?us-ascii?Q?wNmXNex5saIW0TsiB38O8YYOpGeA4IMAFSbHNUzdj6d2hbg67p+hYLoOuD03?=
 =?us-ascii?Q?KQZgmLl8+6s8MyiGesw6XexhHAC822C769AkoAkEqDA9DN8KBP+xr7j1UxQW?=
 =?us-ascii?Q?AdsPgZMCLPvb8fRisHX8hbOp8BxDmz36YhMa3JchL1xW9yhvKo0miZ2bArri?=
 =?us-ascii?Q?Qpm7ip7OMXDVH4UW+w5yzfkTbJuaruBBrOVcveoBtwKNpaWEANZc0m41/wH7?=
 =?us-ascii?Q?d4inzIlw0xn4I98IYGfM1lbOGRSlFr+V3FU6X99AmYFS8XGMFFNGPuhGL2C4?=
 =?us-ascii?Q?2pAnNEZwDzdgefYbNf56Zfcvh9/EdomHM1J2F0EUDSDuLLKf1Wx99nsvqd0a?=
 =?us-ascii?Q?sJXx/jlXL7umwvWE6678LL4/KleXWry8cTgZvGfJLrSl/mrw+H+VQeqFBpVa?=
 =?us-ascii?Q?fJheV745vPI0/L1KibfuMzouoLq5ii7/fLF8p8tJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b4d667-f221-4be4-83af-08db5694ede9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 05:09:44.9589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iJkQ6fwrMEqSOCJCkFdvyQ0nRV5fM+4mb1KMkD15XjexodTqGhgFR56A8HoKMUmlZ3acCbkieAimEU2rap4HSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7924
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, May 13, 2023 5:02 AM
>=20
> On Fri, May 12, 2023 at 02:59:40AM +0000, Tian, Kevin wrote:
> > > From: Baolu Lu <baolu.lu@linux.intel.com>
> > > Sent: Thursday, May 11, 2023 7:34 PM
> > >
> > > On 5/11/23 3:27 PM, Tian, Kevin wrote:
> > > >> From: Alex Williamson<alex.williamson@redhat.com>
> > > >> Sent: Thursday, May 11, 2023 1:25 AM
> > > >>
> > > >> On Tue, 9 May 2023 08:34:53 +0000
> > > >> "Tian, Kevin"<kevin.tian@intel.com>  wrote:
> > > >>
> > > >>> According to PCIe spec (7.8.9 PASID Extended Capability Structure=
):
> > > >>>
> > > >>>    The PASID configuration of the single non-VF Function represen=
ting
> > > >>>    the device is also used by all VFs in the device. A PF is perm=
itted
> > > >>>    to implement the PASID capability, but VFs must not implement =
it.
> > > >>>
> > > >>> To enable PASID on VF then one open is where to locate the PASID
> > > >>> capability in VF's vconfig space. vfio-pci doesn't know which off=
set
> > > >>> may contain VF specific config registers. Finding such offset mus=
t
> > > >>> come from a device specific knowledge.
> > > >> Backup for a moment, VFs are governed by the PASID capability on t=
he
> > > >> PF.  The PASID capability exposes control registers that imply the
> > > >> ability to manage various feature enable bits.  The VF owner does =
not
> > > >> have privileges to manipulate those bits.  For example, the PASID
> Enable
> > > >> bit should restrict the endpoint from sending TLPs with a PASID pr=
efix,
> > > >> but this can only be changed at the PF level for all associated VF=
s.
> > > >>
> > > >> The protocol specified in 7.8.9.3 defines this enable bit as RW.  =
How do
> > > >> we virtualize that?  Either it's virtualized to be read-only and w=
e
> > > >> violate the spec or we allow it to be read-write and it has no eff=
ect,
> > > >> which violates the spec.
> > > >>
> > > > Currently the PASID cap is enabled by default when a device is prob=
ed
> > > > by iommu driver. Leaving it enabled in PF while guest wants it disa=
bled
> > > > in VF is harmless. W/o proper setup in iommu side the VF cannot
> > > > do real work with PASID.
> > >
> > > [sorry for partial reply]
> > >
> > > I am attempting to move PASID enabling/disabling out of the iommu
> > > driver and give its control to the device driver. One puzzle thing is
> > > that PCI spec requires PASID control bits not changed once the ATS is
> > > is enabled. So I also need to add iommu interfaces to enable/disable
> > > ATS on devices.
> > >
> > > By default, the ATS is enabled by the iommu subsystem to utilize the
> > > device TLB, the device driver needs to disable it before change the
> > > PASID control bits and re-enable it afterwards.
> > >
> >
> > ATS is also relied on by PRS. Not sure how that will be affected when
> > ATS is dynamically turned on/off. and PRS is not tied to PASID.
> >
> > Jason, is it still a strong requirement to have driver-opt model for
> > pasid enabling? iirc it's first raised in a discussion for an AMD GPU
> > scenario [1]
>=20
> It is sounding worse and worse as we go along..
>=20
> AMD and ARM both have the issue that the iommu settings and domain
> types depend on if the driver intends to use PASID or not. There is
> some small performance win if PASID is not used and the iommu driver
> knows it is not used.
>=20
> We also get into some trouble with groups, I think, where it will be
> hard for the iommu driver to know which mode to use when creating a
> domain..
>=20
> But, if the PASID control for a VF is on the PF then I think it is
> hopeless. The iommu or PCI layers need to make these decisions and
> drivers have to live with it. No PASID support unless the iommu turned
> it on.
>=20
> This still suggests there would be some driver call to the iommu side
> to check that PASID is setup.
>=20

yes, that still makes sense.
