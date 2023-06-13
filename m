Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB8F72E68E
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 17:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242743AbjFMPCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 11:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242731AbjFMPCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 11:02:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6B9E62;
        Tue, 13 Jun 2023 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686668556; x=1718204556;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aidd+Bn+a/jlhCpkrpcoY1/99T+DQwGk4kdQ0ZOBk6U=;
  b=Uipd/ninpcvuJeSxcLNNsN+XjCQYimavU2TLsUL4vLo4kuiOvAueTc0y
   cpDq9XIJddAdhYDjDaYNHEpQyeUsyB0Gdv22xG4oRVm8vZQh69gu89TP6
   HQz6ERKCsyFv2jpdfT+0HIGbx+HYDpQA9oeG9PobdxAPu+UeJ/kCxL/w8
   3saVcnq0Q5FqjJw1pifqgAYEp54yuFenda55bf3mBXJ7yPWgiBk7ZJUEG
   f6/FwFdnm0PscYqG6ix0jexSeF6phSeD7dvyw8JUj+kBmTLhuJ1N6q5xM
   DlSHqsnRv5jCOcY/KB9bk3RG8A2njHghJeMFxz7M6KnKmnIbQrGMwwhCq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="348013325"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="348013325"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 08:01:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="835918277"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="835918277"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2023 08:01:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:01:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:01:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 08:01:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 08:01:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6K0l0Ybn+9Stc2aM3jpx+9++NsvK/f62Lsgos2/Lvqp84mOUrIF9MqBrgWUTFrkKVgzTLAo3NfCPe19M+8cw4/wVo+pswkl4SYUfxh0/mbPuYpq6Rn1cUOAYEA6BL0PzvOlBb8NM9R6z800u74JfgX2K5pjcACAnx0dJCPWNTo7CY36qQgkzDMHB18srZnAsy5s8BiUsVXNgIkB4AJX6UFEDnd5hWBp9NPWxtBNpedNVSvFPUPjbFONFIyen1ZFcFFCZgpDLUymcjI7hddNh+N37A7gzRkb2cLhYlEwQJcbgNSwyfoFa78mfEpRvHyGUk335es+W097v8DapKETsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OWKuEN/+WTLGBtRTD6pwQ0e52nGkAaoCATt8jLQ2cSU=;
 b=FEqXXsd8EqnfAv8KB1iFNS7l28Jx7gbAOqtqOcbsGxB3NoJ/jVEqQwIk8YXj8GORk0FeDrLZolFHNQVpk9rkoD8omkc2TPEBr+4OmlB83GxDHEGkUSwM9oNe1uBtc13ep0PvEgeA7jkpYEgSVqditGXONBzpEiJ+qzGdirlnOXypV1IkLw67+sL908B0cYrD0Akma0eAvZ6CkI9nR68zzfFhY30QOqvklXeCOktvltJGIBivyN4lmsrQcgCIK2GDfvg/57Cr17xxNFOsTXWHlp+3no42lBqn5BkAMWpaYsrwjZescF7VO5S5Dp9A3oRLwV8WujPRGFvvleyXhW9Akw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB5081.namprd11.prod.outlook.com (2603:10b6:806:118::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 15:01:36 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 15:01:35 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw5Bdx6t/Ptjk+i/O1PZ4IdNK+H07wAgAB3NRCAAI6EgIAAArTAgAAFeACAAABSUA==
Date:   Tue, 13 Jun 2023 15:01:35 +0000
Message-ID: <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-22-yi.l.liu@intel.com>
        <20230612164228.65b500e0.alex.williamson@redhat.com>
        <DS0PR11MB7529AE3701E154BF4C092E57C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081913.279dea9e.alex.williamson@redhat.com>
        <DS0PR11MB7529EB2903151B3399F636F5C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613084828.7af51055.alex.williamson@redhat.com>
In-Reply-To: <20230613084828.7af51055.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB5081:EE_
x-ms-office365-filtering-correlation-id: e1015750-b152-4846-8b95-08db6c1f151d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: veG4DMTiJNh+bu456ip1hoK+x/p2d3tLHq0z9co4ONM+PymhIXvEGcoUsrRDDMqPmcyzeEkZuu0zds2vvyHoxRgNGa4S9GgMD9zULZFbrr09Y7cOwwxUiYP114omf+oBauyvQM9oN681LtlOrXJxUX/9z6dy96sTJYEg5wT3BI8vFvi/LVMKArNiUcF6Oi9DGGxL5XXUftq/zdfW+xjDQW7b9jke/QZY+YUdCmIZtkjBO1Vxz6RmxjjrDIhCQBTbXiKo4KCeQ2+yErp/B3CCogpj4RUIt/tzkaNvBYLCorPIp+6QvgjtGYRJaiALLTQqFal6UY+0lTf/IsfqZ5MZhakZOiBp4EXp+jdtVvW6a0tR2MJ47z5h1mLI4AW/11udBrQxNFmM0SsfNHIul4Q9+yVWDukj0qbtou1TIax073I4QwC/f22tMIIbhkKoSYhbKEa5IXlJU2ACWt40EfWvLdSEQGR2N9uO4B+CK6jGqSY0ZLhDdcXKq6d54P4Z7sC337bMFSXQ884Mwmp7n02HoVDn1jQuaaYpvGQEIqHXDoPCETpsGEKkKRdRDiIm2PkZMadE07uJCThFfVXQ5JooaL2QHRnelPDroYdEnG1acdW+s7sYygmG0Hk6tis0o6zA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(5660300002)(7416002)(8676002)(8936002)(2906002)(76116006)(64756008)(66946007)(66446008)(66556008)(66476007)(54906003)(71200400001)(7696005)(4326008)(52536014)(26005)(6506007)(9686003)(41300700001)(316002)(6916009)(186003)(82960400001)(83380400001)(478600001)(33656002)(86362001)(38070700005)(38100700002)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0oUhwqNcAL7PsQLfT3rNC/8jldEo2QIXGAytfD4FDE71TMnaJPkd98ar01ya?=
 =?us-ascii?Q?ajjEN747ScMLLiyOL5Ad3qZQuG+KsnI28QFlnW2PIT1t4/abE/bz538xsF7b?=
 =?us-ascii?Q?jY0EweRQKz4qiCp2e3Mg2eQ4crSvOYhqI8ZDG4YtxAnDUomzyhZ8ih8OITD5?=
 =?us-ascii?Q?0hrGrb3pyRIz4+UPOuDKJO7Nzx3ONvDpulHPEKybaSoIt2bU4x9b0Otap62r?=
 =?us-ascii?Q?cimINe0Iu4x2D4SQKgf6ByIjm3SCTUP6rnhQJ1C5knPnub/irNOH5WInCxKz?=
 =?us-ascii?Q?NpiXraF21iB45wxN6irWBbblIRfSWNKfzPGKh9/UlMwPPypVSqbU40N9g7J3?=
 =?us-ascii?Q?Da1l1RNIYfcHrIBfNVUsGAMw5AOpu03JgencSOY2udno0c70BunOMw9ERIjR?=
 =?us-ascii?Q?kJwzrEZ3gInvK8mxs9wY5jJbkKTD2M5SGH9gmAi6hPVGK38cVvvKwBDK2cLC?=
 =?us-ascii?Q?jc/HoY4vq6Q0ahJFl6r32dTteV9yHG3QOoApTmVz1+t87jtrz4aCr38zP7LZ?=
 =?us-ascii?Q?Ve0OykdlCjpniwKoWblD3urgCVo282zxu6NaE6NdsHjdhH5/6OSHWgxV5YIu?=
 =?us-ascii?Q?SyF/3lcMFm2AeB4j7Ii8kP/t7JXZ7Cgj8kXkGOAaQTldE2xHRy0wnXNR2JG4?=
 =?us-ascii?Q?HM5X5tYZAFQ/EzllGv62NAD0+EADhINirnJezPt+d4T0dMDtO7OUqpDEelRl?=
 =?us-ascii?Q?ADS6PYW/vCF35j9zqxQSbTbYuUuyEdrxSmsdlBVwVdOQdjQNLgDteLjh448m?=
 =?us-ascii?Q?FQjRB5GWMQRCdku8LgfsTd34xV38CNGXIBLTi+k4zQetHj9GDmQZrS9nlT/5?=
 =?us-ascii?Q?d4gL7LkPAkv6IGKMTR8I/mCwnscm/CVJ2PuPpvqC4nKwsyiaK5BfughFCpbV?=
 =?us-ascii?Q?UJuTO2HNqAC9RkH/NOTD/2wvCrNaOZYSHX5WSxxuBYYFnL/xOLgG6BdujlM9?=
 =?us-ascii?Q?EBrcSZDRGZ4ajCVky1wQSbitzdfEgUgZWfUa5yxAHjZs4tyaLrW3gUAuTsea?=
 =?us-ascii?Q?xS12EU9prm5tIC6mVVLwha1SUD5lHgIxOCMlptfi4hNYdqNuCFJ030hOYGSJ?=
 =?us-ascii?Q?U+JlWRxdXA/3jszO1UwJ2Z0gsczupVb2r9zEFv2kvma7sBxEOuY1hAyqkk0W?=
 =?us-ascii?Q?CPoHhLTGogCyqcS1jwDR6S9q5Y5G2jeUPl2UI2TztdsICbfLcuwZS4QJUT9K?=
 =?us-ascii?Q?dyJoKxWv8Fca3fD82PDE8ex8nROIHHW8shAprmeUP/8ea9oIFBeGsZxxamcX?=
 =?us-ascii?Q?wTp1E4AqTFeYf5GbrfnV4g3phYATk4ttMTDYzkS5XzJNH01J9ztIlGET84S/?=
 =?us-ascii?Q?K15y5nkT340d1jLMCd4fXhFIQ1sfD2FWvBnr8KSUfKdxk5oggPMettSs2gve?=
 =?us-ascii?Q?IQdShqL5hmZWt2rH4uhaqD2xKL+UPmAGP7bI+nxYR6ooWI4T28brxzR0Qdjb?=
 =?us-ascii?Q?YCaGCzfuYm30XrS7PxP0Mmzd61SybuFZUxrQs6ik5h7If7bHhicUGasYxrx7?=
 =?us-ascii?Q?Mwng4y2DbaRZJqKZgqM717w1OIfxyQ5nVQVag6JlwSTcxjnQXUOb+HMuNovS?=
 =?us-ascii?Q?SAcy76afl4umvrflrAt1x/TjQnJYRnlmSCNKWsys?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1015750-b152-4846-8b95-08db6c1f151d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 15:01:35.6663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /GuIYzKtc2KXlq680gBYSxORFqPEKlpbN7Z7SMhki7jSF12nztNHXNjvplPrvVAnrOs568rW0H85P05VihT6DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5081
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 10:48 PM
>=20
> On Tue, 13 Jun 2023 14:33:01 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, June 13, 2023 10:19 PM
> > >
> > > On Tue, 13 Jun 2023 05:53:42 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Tuesday, June 13, 2023 6:42 AM
> > > > >
> > > > > On Fri,  2 Jun 2023 05:16:50 -0700
> > > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > > This moves the noiommu device determination and noiommu taint o=
ut of
> > > > > > vfio_group_find_or_alloc(). noiommu device is determined in
> > > > > > __vfio_register_dev() and result is stored in flag vfio_device-=
>noiommu,
> > > > > > the noiommu taint is added in the end of __vfio_register_dev().
> > > > > >
> > > > > > This is also a preparation for compiling out vfio_group infrast=
ructure
> > > > > > as it makes the noiommu detection and taint common between the =
cdev path
> > > > > > and group path though cdev path does not support noiommu.
> > > > >
> > > > > Does this really still make sense?  The motivation for the change=
 is
> > > > > really not clear without cdev support for noiommu.  Thanks,
> > > >
> > > > I think it still makes sense. When CONFIG_VFIO_GROUP=3D=3Dn, the ke=
rnel
> > > > only supports cdev interface. If there is noiommu device, vfio shou=
ld
> > > > fail the registration. So, the noiommu determination is still neede=
d. But
> > > > I'd admit the taint might still be in the group code.
> > >
> > > How is there going to be a noiommu device when VFIO_GROUP is unset?
> >
> > How about booting a kernel with iommu disabled, then all the devices
> > are not protected by iommu. I suppose they are noiommu devices. If
> > user wants to bound them to vfio, the kernel should have VFIO_GROUP.
> > Otherwise, needs to fail.
>=20
> "noiommu" is a vfio designation of a device, it must be created by
> vfio. =20

Sure.

> There can certainly be devices which are not IOMMU backed, but
> without vfio designating them as noiommu devices, which is only done
> via the legacy and compat paths, there's no such thing as a noiommu
> device.=20

Yes.

> Devices without an IOMMU are simply out of scope for cdev,
> there should never be a vfio cdev entry created for them.  Thanks,

Actually, this is what I want to solve. I need to check if a device is
IOMMU backed or not, and based on this info to prevent creating
cdev entry for them in the coming cdev support or may need to
fail registration if VFIO_GROUP is unset.

If this patch is not good. I can use the vfio_device_is_noiommu()
written like below when VFIO_GROUP is unset. What about your
opinion?

static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
{
	struct iommu_group *iommu_group;

	iommu_group =3D iommu_group_get(vdev->dev);
	iommu_group_put(iommu_group); /* Accepts NULL */
	return !iommu_group;
}

Regards,
Yi Liu


