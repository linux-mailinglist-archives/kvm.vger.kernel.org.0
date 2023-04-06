Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B151B6D8F80
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 08:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbjDFGeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbjDFGeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 02:34:17 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF32A273;
        Wed,  5 Apr 2023 23:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680762854; x=1712298854;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XGCj4z5U2VZMRmhZP8pPauCt4ykyoYh+pdMpqzaGapg=;
  b=jdjR7rmIIYhjPTkT2F/WrHjBodjowdO8EeEAFZJqPMz3msif7gBNF6er
   uGrgZWdGgYMULAOkeP7s3zvHjnOqiZtBlj5at0THhkuF95vrh9vHxTrcn
   pEOfROt95iHM4fxk6UDOTUTxnQcovSVpfKHtGSfjl8qsIRzb6ner2TU84
   eum72UWt8/xqWuQYhRrxIQNsOOem3URAoFAXyoym87Bh//UN6tKcJs+nB
   RNDyiB8nz8G/dT4RV34PV4Kxa2ouRpcJGBtyC8WlHvx8m223c9XlZKdGp
   4ngdhYARpA5SouwKnKhUhQR9I88sIu9xmItuODxQPUVgfA+dUdqasHD9b
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="428941864"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="428941864"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 23:34:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="776344185"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="776344185"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2023 23:34:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 23:34:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 23:34:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 23:34:12 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 23:34:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UR0E11KqGEYhOKE9fdqYfi3/CzhKWM47S4HUNsP72dcxHL7ujxT4Ns7ydgVzKvLayhKDbwEepB0bGpnF25+WVOa/PLS9pb+IOZmEnzKh9XDSlGHZY3gqK+X8fJUcPbsRXNSvshivZgkHCbnSGCMBcK76UNSOmBSd2+AXWBzh4nEa99D2AuRl99JAphU+MIVv+n09T94vIOQWypTnnoYLmrIwvmH2I4qTQwrI2KzoVlb5/V3tGMN/A48uO+VBNPd/FqF/70ZZ8UsKU9XLVD1/PX1JRC+nxucM5a0O0qV+W7CeaB74b8q+tMNC1qLj9/B0x2VCIk8gQr+VYr+ErbtqSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7cON/sJtagpymD2ncklEUL+gqh6Kn3nFynJQ+ERvGI=;
 b=clNQ7FHNFS6Px+qRFLd3VBKtsoIx+OJi75KKGuhxYs1VeNG6Iz03OBahISLwmRrEGsqi5BVKVg68pDHVbXrDz040uNtTJZ9BflU8u8IW57ZJcjwVS227wcTFNKnfnHK1nYkl7skN2vlYP7ShN4tuUzrlDwejqyNcjGusckN3ouo/OWidXmhxzRwsugIlSFGmX5f4MCZa4HVs/N204oQ5qrGTPtaMnNrT9U6sidE/R7/2CBIXkkq5T6kFS3WN4eI5qZPLiLFcgaTZe2q3bSkFEQM0D55nfu/hVkbO+g1VMp5smpdmHbeqIcSOxEqc/Aavq9YhHYgOaWgiASgFzBUS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7879.namprd11.prod.outlook.com (2603:10b6:8:f7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.29; Thu, 6 Apr
 2023 06:34:09 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 06:34:09 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAqz1g
Date:   Thu, 6 Apr 2023 06:34:08 +0000
Message-ID: <DS0PR11MB752987A5B996D93582F8A8BCC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
        <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230405102545.41a61424.alex.williamson@redhat.com>
        <ZC2jsQuWiMYM6JZb@nvidia.com>
        <20230405105215.428fa9f5.alex.williamson@redhat.com>
        <ZC2un1LaTUR1OrrJ@nvidia.com>
        <20230405125621.4627ca19.alex.williamson@redhat.com>
        <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
In-Reply-To: <20230405134945.29e967be.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7879:EE_
x-ms-office365-filtering-correlation-id: 1334f4fa-c21d-4803-a9b5-08db3668ed5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pmGyq3QIlB4m6yAtw6UYH+vrvbnpuwPv37rH8RBUJSGR+sJiB6Lvqyi5Je9sxErbxci9rjvthvk1jAFTO73brpNy7K5tX8s4T4r83x3L8JSxw0l2KG14dA27Xboc3Y0UYwpZswx7xnk+EtDcB9RFeCnsEwnpRXDO3VNdJPhMr9cDouVqkhjPQEaWZqn+O7Bihurfj/4UjM3UM1so0oFHhiSFr18al9eYWgmmEduYbCiud4WKc29h225hvrVkM4Q2OE43lVV/z3pgbyjW1aQtZcbMITdUomS2zjnrEe28NXuAj+lgmhurXu9jeH0tgm4Lg2PFToP7uEdxGPM4VcTaR66Kf+0kkQ3sqpdjIpiy+Kv+sj+3M0ny92UjiVQr9akb7gXwQIKWbJFEjO/J4+mGG8YrYj9MkVthHvWCn2+2PXwwMH6M2BNpS4aBrCGnC9klcsj1vEdp/L8P5Z+/h6I9IJIAWiRScGUIuAwqX3sD+9ZQpwKyosFnZYdoi27kJi4epJ2d8ZNS/HyDa4/CdiWz7i4rRxoKwshlLEJxuQfp3Yn+nyTNABOdh7HpdcegCgo2EsyH+vvoFmYnxILAQ+A4gW4SAs5sqBgrTPFE7hrVjbTrZ05Sj0lucB0FxGIu7nqU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199021)(86362001)(33656002)(38070700005)(2906002)(55016003)(7696005)(71200400001)(83380400001)(186003)(966005)(6506007)(9686003)(26005)(76116006)(66946007)(66446008)(8676002)(64756008)(66476007)(4326008)(66556008)(7416002)(5660300002)(38100700002)(82960400001)(110136005)(478600001)(54906003)(52536014)(316002)(122000001)(41300700001)(8936002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bXw9ByvmuUwZ6OxhVHNivbTD1LEdTdYGT2/pDXAVej6CtD9dKiekfY57OfWo?=
 =?us-ascii?Q?Ju6jsE6WVJFXb37jjXjvPxYKWk//U1kMDNo1CpkHlfgRNrumTiVrJ5N8Qt8m?=
 =?us-ascii?Q?uHt/6M5rQwBkoj4UJRSbIPPhQu6RZ1S4ommJIRh7l7WlO3FzsXa3UfqaAGl4?=
 =?us-ascii?Q?ebk/O+jAp2jVGVLPeqd34QKRS+kgemNpDeaeoG/JBuOOaFM6V1soDe48sD99?=
 =?us-ascii?Q?/6yoUyBZA2PKTfgGBR5KSmpFQ71ckE14BNfYowhBSZvrqBXLnWAE9O8XwiKw?=
 =?us-ascii?Q?UEY/DT8Si+7S0kTkL5FQC+sSd88Oo3upaMi07Ufei2Gdo+5lCPnGuh2UgISi?=
 =?us-ascii?Q?xC/npSXQt1PGPx4ZCJsEBrfWqVQYZ/nHzYOFjDZ0Kt6WLVZ48vBu2WYDzjvf?=
 =?us-ascii?Q?qeJXIKQPWRB0dC7njL2MwHKI+Pbe0rCJW8pTbGjj5Lc1u8N7xu1pPVJxqGjC?=
 =?us-ascii?Q?kG0Xz8K7W0MIFGH1PBNWJvfujAcqYs1pI7alNkvEcL0/ztqCgPj4wayKIAXh?=
 =?us-ascii?Q?2j8ipUTjKHQCvxRzJjnwU9kUkvVGjF5iKLKBNw//9TcjUECfQu7yOP3cgtG/?=
 =?us-ascii?Q?bIyraZyy1Q4ZIECrI5ywUaJYDzunhD5J+laYmfBbUicJHKl9pqFsLiQT7W0D?=
 =?us-ascii?Q?MlvkFicKJZjgQtLRuAB20Db1RspXFcSXpbfw8zjZ/A+qxW8jpOLr8gt92og+?=
 =?us-ascii?Q?YXa5Hf4HMcZJ5oH9YtRL2+CCgMjITSe2n54I+bqETg1RDs52UvM9CVkNZ5bP?=
 =?us-ascii?Q?LNZXxj9LVN/a7TWD5ue+A4jp6t/evRbY+Sfhle3aoVGavLec1j/UofQv4wmI?=
 =?us-ascii?Q?Cjt6eB4W5di2wD1WFRtpTP8QykxyowuWxe5KN/Iw7O0/eqlVVc1sLBai2ESc?=
 =?us-ascii?Q?MhA7ZWqYrNPXKImXphFLZA8eyFXLfvecAQ5u7M20suY82uphOIRTDEOnrSAm?=
 =?us-ascii?Q?yZ1kO7W8RW8Dz7hbu2694iFx12SNuyuLbEF9W/ASiGQZQOWfAo1ITEt/vpep?=
 =?us-ascii?Q?niQly3J4Qq7I42ojEDc9eyyZad1umAQc3Yy+ffrxUyR2/FdloD1fnj8ndd7P?=
 =?us-ascii?Q?eW1bVcwSgFGjtQFJaFgVlO1FDjv+PdbNmfT4KPRd+pToJ9LqvxTy70++QbER?=
 =?us-ascii?Q?5NCLUYf1LypnZOowCyvS4M7WXxBrb36CkUdM/Cnys0qyOxvxs3aP79BznI4T?=
 =?us-ascii?Q?bbpqnFBlQa5QkywjWmMOZSUuGvOJnQlG3D8tXZqw8ouPCsNxnA2UhCoWTbVu?=
 =?us-ascii?Q?4zAJDVltIMTC4fsJOGB9kTgDs6rZq6zHUCZbN+Sujque3JZ4XZdfs6uJwymW?=
 =?us-ascii?Q?iczRmpDs5j843JZTtcsZzEVrGSeOD4k81prhjax0zKw2VaFLajdv5ORMEwmS?=
 =?us-ascii?Q?Za9D0TDsbK2am+HllylJzbqDFj8nznkNNhOFGjsBV45oItipir0D4f/58ERY?=
 =?us-ascii?Q?vpc7FngA2eEMjrApxZXDoW2spu7CwnmLSQMSO4mcd3iRjS6hbNdVfBYJz7k5?=
 =?us-ascii?Q?fE901SiBVZEGgF0HkHpaBYKmoyQLJ7hYYn8InQ1PM8HHYUz0wBcCSlUf5Bmd?=
 =?us-ascii?Q?ptL6BKAR+m5lzVrCEYjn/3YxRguP1UM1/ONIydRl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1334f4fa-c21d-4803-a9b5-08db3668ed5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 06:34:08.9139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gBhwmIIQxLMI5HUOPcxgerP/36vflXhz8upK4meahocbxBWmXHm2uBfXaLCOZlyLOw1znL+E2Hjhm8Lbv2B2rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7879
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, April 6, 2023 3:50 AM
>=20
> On Wed, 5 Apr 2023 16:21:09 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, Apr 05, 2023 at 12:56:21PM -0600, Alex Williamson wrote:
> > > Usability needs to be a consideration as well.  An interface where th=
e
> > > result is effectively arbitrary from a user perspective because the
> > > kernel is solely focused on whether the operation is allowed,
> > > evaluating constraints that the user is unaware of and cannot control=
,
> > > is unusable.
> >
> > Considering this API is only invoked by qemu we might be overdoing
> > this usability and 'no shoot in foot' view.
>=20
> Ok, I'm not sure why we're diminishing the de facto vfio userspace...
>=20
> > > > This is a good point that qemu needs to make a policy decision if i=
t
> > > > is happy about the VFIO configuration - but that is a policy decisi=
on
> > > > that should not become entangled with the kernel's security checks.
> > > >
> > > > Today qemu can make this policy choice the same way it does right n=
ow
> > > > - call _INFO and check the group_ids. It gets the exact same outcom=
e
> > > > as today. We already discussed that we need to expose the group ID
> > > > through an ioctl someplace.
> > >
> > > QEMU can make a policy decision today because the kernel provides a
> > > sufficiently reliable interface, ie. based on the set of owned groups=
, a
> > > hot-reset is all but guaranteed to work.
> >
> > And we don't change that with cdev. If qemu wants to make the policy
> > decision it keeps using the exact same _INFO interface to make that
> > decision same it has always made.
> >
> > We weaken the actual reset action to only consider the security side.
> >
> > Applications that want this exclusive reset group policy simply must
> > check it on their own. It is a reasonable API design.
>=20
> I disagree, as I've argued before, the info ioctl becomes so weak and
> effectively arbitrary from a user perspective at being able to predict
> whether the hot-reset ioctl works that it becomes useless, diminishing
> the entire hot-reset info/execute API.
>=20
> > > > If this is too awkward we could add a query to the kernel if the cd=
ev
> > > > is "reset exclusive" - eg the iommufd covers all the groups that sp=
an
> > > > the reset set.
> > >
> > > That's essentially what we have if there are valid dev-ids for each
> > > affected device in the info ioctl.
> >
> > If you have dev-ids for everything, yes. If you don't, then you can't
> > make the same policy choice using a dev-id interface.
>=20
> Exactly, you can't make any policy choice because the success or
> failure of the hot-reset ioctl can't be known.

could you elaborate a bit about what the policy is here. As far as I know,
QEMU makes use of the information reported by _INFO to check:
- if all the affected groups are owned by the current QEMU[1]
- if the affected devices are opened by the current QEMU, if yes, QEMU
  needs to use vfio_pci_pre_reset() to do preparation before issuing
  hot rest[1]

[1] vfio_pci_hot_reset() in https://github.com/qemu/qemu/blob/master/hw/vfi=
o/pci.c

> > > I don't think it helps the user experience to create loopholes where
> > > the hot-reset ioctl can still work in spite of those missing
> > > devices.
> >
> > I disagree. The easy straightforward design is that the reset ioctl
> > works if the process has security permissions. Mixing a policy check
> > into the kernel on this path is creating complexity we don't really
> > need.
> >
> > I don't view it as a loophole, it is flexability to use the API in a
> > way that is different from what qemu wants - eg an app like dpdk may
> > be willing to tolerate a reset group that becomes unavailable after
> > startup. Who knows, why should we force this in the kernel?
>=20
> Because look at all the problems it's causing to try to introduce these
> loopholes without also introducing subtle bugs.  There's an argument
> that we're overly strict, which is better than the alternative, which
> seems to be what we're dabbling with.  It is a straightforward
> interface for the hot-reset ioctl to mirror the information provided
> via the hot-reset info ioctl.
>=20
> > > For example, we have a VFIO_DEVICE_GET_INFO ioctl that supports
> > > capability chains, we could add a capability that reports the group I=
D
> > > for the device.
> >
> > I was going to put that in an iommufd ioctl so it works with VDPA too,
> > but sure, lets assume we can get the group ID from a cdev fd.
> >
> > > The hot-reset info ioctl remains as it is today, reporting group-ids
> > > and bdfs.
> >
> > Sure, but userspace still needs to know how to map the reset sets into
> > dev-ids.
>=20
> No, it doesn't.
>=20
> > Remember the reason we started doing this is because we don't
> > have easy access to the BDF anymore.
>=20
> We don't need it, the info ioctl provides the groups, the group
> association can be learned from the DEVICE_GET_INFO ioctl, the
> hot-reset ioctl only requires a single representative fd per affected
> group.  dev-ids not required.
>=20
> > I like leaving this ioctl alone, lets go back to a dedicated ioctl to
> > return the dev_ids.
>=20
> I don't see any justification for this.  We could add another PCI
> specific DEVICE_GET_INFO capability to report the bdf if we really need
> it, but reporting the group seems sufficient for this use case.

IMHO, the knowledge of group may be not enough. Take QEMU as an example.
QEMU not only needs to ensure the group is owned by it, it also needs to
do preparation on the devices that are already in use and affected by
the hot reset on a new opened device. If there is only group knowledge,
QEMU may blindly prepares all the devices that are already opened and
belong to the same iommu group. But as I got in the discussion iommu
group is not equal to hot reset scope (a.k.a. dev_set). is it? It is
possible that devices in an iommu_group may span into multiple hot
reset scope. For such case, get bdf info from cdev fd is necessary.

Regards,
Yi Liu

