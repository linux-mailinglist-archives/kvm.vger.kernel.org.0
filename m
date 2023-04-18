Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DCE6E5EAB
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 12:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjDRKY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 06:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjDRKYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 06:24:19 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06648690;
        Tue, 18 Apr 2023 03:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681813440; x=1713349440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AYy0vlIEyvZGAjzvf9FzrLjbKgIZWWvOC09+MpZIG5E=;
  b=cERAIGMVzweQKz88tl4scGJzFb4Yqi7bmpPwxN2A3D80bNCzbpt8qe9C
   2kQ7zGUy3Yo7N61BMjqQ75hJFE1jXXFS40gEDbsoeAs9W1JUKgCLKh3z2
   XSqBlxk877vRK5cqB9rPPH5Iwcm2H/ctLrNdCiLg3/RcYur3eOOBQvbJM
   CX6dym/GxWDGYTZW31qV2VmCRKdUhIIWe1n5AWCGF47jBdAtuVie2nEbH
   woeYxvh7ZKZCWMdSt+jxUQYx4x3G1zlmVMqjWQCTTZ2FY9RUBUcRZKmkw
   ZKiqMvpN6IzOBisRT/v1LFgsyXHqJKm92asJitR/i9XlJ196u4p91HLz1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="342623604"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="342623604"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 03:24:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="668468965"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="668468965"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 18 Apr 2023 03:23:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 03:23:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 03:23:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 03:23:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 03:23:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUONHf2Goqh/312ySAXzEXmJ34yHUlL4mE5VzXojJ1YcF8cZJACS+UFO150kPdBOr+pfdaHIFbiYP9TYdMN1r7v5YR4Adfomqm9FZnlbWdeZKm9Xt2GkSyPtqFOlimIRFejfGUOqLOBCES1MFkJM9pYAElLKkGdDmHVdto/SX0Bg6PP3tx0XFIhcRwd+M6B1zXYz1tILm+TzDHrEVXZhDbjIpBfJL2DkgX56ZWk6C4vO+lYH0vs6ByDJyNTeHa/W35laWCe1utK9KpRI+wK0GxOV1Uh42us11YNuw9kDbMuruDYD3OPycQqiibJi+7A7CCRoTMJr3rIHamcDSGT0OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYy0vlIEyvZGAjzvf9FzrLjbKgIZWWvOC09+MpZIG5E=;
 b=JQgN3iJxUxcCipjDjgYhwXEnw2tdBtk8JMvqkt7yDG2Hvjlo52VQn7EAJObVtnqH53TxTC5FtGd9PSRjLo2tLyeSldpME0QnXs43+qvk1TciQ2I099h0uT0lr7g6zdoJWZs2h0msFtFALgMJ8bX1/kypH4drnC1Q8BBizjXP6Sv14PQsABUh0OlIYru6EXLhSPPWjyO72Q6Ecw8t4d1JULvshNGCAS/PcfUWy+KSxBOspzyGO1xtSUUkxc0prr1qF+bCvKnY/vOAmySnZVhDB3yPQfQYAOv9/LAlQte76MHXfzSdhehF4nlMmTIVDzkcmvU4bgCkz0jHc5r/TiBtWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5381.namprd11.prod.outlook.com (2603:10b6:208:308::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 10:23:56 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%4]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 10:23:56 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAFAdWAgAFWfNA=
Date:   Tue, 18 Apr 2023 10:23:55 +0000
Message-ID: <DS0PR11MB7529F4A41783CA033365C163C39D9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <20230413120712.3b9bf42d.alex.williamson@redhat.com>
 <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZD1MCc6fD+oisjki@nvidia.com>
In-Reply-To: <ZD1MCc6fD+oisjki@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5381:EE_
x-ms-office365-filtering-correlation-id: dbc905c5-2d9f-492d-0689-08db3ff703e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0TXoXY2YKuQptz0yXBLRD1HYumnt1hj+rjUtXIndAhG1HDVBfZmoSwx6b1/H703jkUyvUoOS9iIsMZqoorSRYiVXRFE1TGeV/TaRmqrx26Id7zMmCXp0yU/s8niGRnLVbhT8qKNtcqz9jH+QptzQz+HJwc7+cwdmSBXfppNYLSNwC7lGF/6YokYyn18XKiq5S7h/V05fX+2xET5SPGgKwXOgiPOEmDlmyAgITQUK5iRQOQn5WEIAi0vfBfv/Gf95l7gbJx4AAcwMAqGo0U63ZxA4P/1KGB7JiAiMop3guDzHHdsk3vZy5vJCN18UxNkWee3iY29o04Yf9yfEHBl/EU5h/N2kzSKPbr5R0iJvjXcns4uabcizCUCBC8R1oGHQkAue3TtW1cLZqIiNNX7v+tjm94K8H/liJ52k8PmcFePj7/hh1CeGWWY0MiyhU0XUvMlxa+OG7LPaNpjTFstcBn7MA27nfAJwNfM+VVHvdwWgYSgw5oCN+MvnW5CKpT17M36+IWqyeiqjp0AM9YgxzT1liBXI6AJJBINdZYXs70t2jaTF/Ob7+FfFNKUY9SfBagxRZWxzWQSp4LreNMKNtn3kcIT1Cj8vgqjZekrXhdn5uNm3og5G9VWti8cZYeiZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199021)(7416002)(38070700005)(52536014)(2906002)(5660300002)(8936002)(8676002)(41300700001)(122000001)(55016003)(86362001)(33656002)(38100700002)(478600001)(110136005)(26005)(6506007)(9686003)(54906003)(6636002)(186003)(71200400001)(7696005)(4326008)(64756008)(66476007)(66556008)(66946007)(76116006)(66446008)(83380400001)(82960400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RH6qlimKZa3oQRT5mTekqdzxcvIpbOeje28tmSntDXjz5YSTIQWbhcGoxgxg?=
 =?us-ascii?Q?QRrMDwvBu2TD4q9QBQdvpuNe9oAyS52cbz6unXrQrs05W/oidu+CMbUobbsE?=
 =?us-ascii?Q?F+P0BuvruPc2uwM9MdeOJMkat+on27xSfJSzthVM+BoT4M1dgJTohETKCWFv?=
 =?us-ascii?Q?IAQpMuzMJ7gFrG9/zduVEq2T9jrFQkCKQJ4//38vf1mTeZd/BbEhTM8Ajtjv?=
 =?us-ascii?Q?8Ila7Pj1I2DECRAybshLCcJ2e/Ism0v7QVOsJknjkn3okm7lQZCfaNY+/mYE?=
 =?us-ascii?Q?PK6QglwCXOZX6i5BbZ3yvY7ga36JIsKg2Pdo0cPN8Eorh5rYIXclxpA8H9wf?=
 =?us-ascii?Q?Diek9KCcBUsN/qnxZJRB4BCXyd9zJW/O/ZyZUAI0qKMuyYET1J/Or8FUR1ze?=
 =?us-ascii?Q?nwBTta4FKthJD03eXx9hOuXKfb8WmCrIwEI9xdBXxbEbSFVaBvjNPBIYzUL6?=
 =?us-ascii?Q?iUw8SFp/EUrmq0buVtjJ5agatHsmQ4u7PyIliVPMr0WMxitdQYj9LgBoQvqg?=
 =?us-ascii?Q?nzlCpV0LglSv4q1ip5C+kdh25Sj9ZYtkQJgrZwBTYTnEZB3rj+cwW+zr+P+4?=
 =?us-ascii?Q?JzrNpe546dPzb4zKPXidJ9wO9HjyHeMAwslMCVI1ZAWqtjJA0/gZjX18JysW?=
 =?us-ascii?Q?07dd+loYCGsTBmYhBxqllom4NOiI9NJOoUS4z34wiXrfhg4CXHZzU146eQPX?=
 =?us-ascii?Q?7sTINocu66RJk+UYKjR1pmgl401+Hu0Pcldd//kV1w7K/mFaYlVkqhYx46uZ?=
 =?us-ascii?Q?Q+Rsn/WIHCYrVMvZXlgkaRMp9zyUZajOnemR6IhmhEqz1jQPAFeOCSQ1KlgW?=
 =?us-ascii?Q?nbGITT5vJaCijL1CgX6aHxbsLdeLMy7QMe7X72gT6gDHZXBE5j5AOTQWsN25?=
 =?us-ascii?Q?EBjRZyKJfNEYO1a3Cb58yVNzozumk9Rice1uFk+hL5/Cwn3yNZjEPIwAypRH?=
 =?us-ascii?Q?+ece6wo8DluXusyY7rWoG5EXSPezcE/OlGqnLRtfNY5riLcyimzL0nw1G6e7?=
 =?us-ascii?Q?Xx8YVPGEg5P//nz37kjkiSJgkeohAMAcguGfnpvo3NIztmJask1Scu+DhAcA?=
 =?us-ascii?Q?Z3PNASeMYJ5N4LKjpRfa8l7dORlGQFjIBjzah3HUJfl9Ytj67vjDe/P/xVum?=
 =?us-ascii?Q?HxzjQ1Zxhs8gimDjGNUWPiXBH80a2jh6menQ72uYxq+GT7zmpAizeOybhE/9?=
 =?us-ascii?Q?LdPsnNIfKzkLYw7MGbf+H+AyPhXaDkdLloU/7ZFmKlFNFJswK2i8GKDxbrHq?=
 =?us-ascii?Q?feEcqhzI35k8+YtjaqAm1LipwpbEz3UcM/4Le3XNhdPHCNU9TUG0pZbL2ixW?=
 =?us-ascii?Q?cIHFwm3r09ooAMf/C35AUAgmvnb6RcfCBWieUhpq5YCr8/JrHI+BQC/DXLqr?=
 =?us-ascii?Q?aQz+VfwtnAkaBx7jD3+ajNrYKeMwJFnIknJmCGMWA4s/XGWL8xNwEOAlUAeX?=
 =?us-ascii?Q?BFCBDW1WjdR5fJgOy5vTQqTRTLFvSMhWmxBqAcM4FPJvfMZbLVxgJQVVSslu?=
 =?us-ascii?Q?UywBPGoaGHroHygMfbcBVo0uXrV4v99OlUgx9t6z3juCuD51oQqK0tmwl+DZ?=
 =?us-ascii?Q?xsk6FgVHb7PWIY5ID+dEktZxIx/rYYQ2amsYAUIm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc905c5-2d9f-492d-0689-08db3ff703e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 10:23:55.7593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C4zyYn+q7E5FJ6bvkwkXvzYKhIFR5tn7N/oMD74Ecqwhkf/zJ7dedEjnhjUunn4PQwlpcv5lOOs5IpVY8OJUqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5381
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
> Sent: Monday, April 17, 2023 9:39 PM
>=20
> On Fri, Apr 14, 2023 at 09:11:30AM +0000, Tian, Kevin wrote:
>=20
> > The only corner case with this option is when a user mixes group
> > and cdev usages. iirc you mentioned it's a valid usage to be supported.
> > In that case the kernel doesn't have sufficient knowledge to judge
> > 'resettable' as it doesn't know which groups are opened by this user.
>=20
> IMHO we don't need to support this combination.

Do you mean we don't support hot-reset for this combination or we don't
support user using this combination. I guess the prior one. Right?

>=20
> We can say that to use the hot reset API the user must put all their
> devices into the same iommufd_ctx and cover 100% of the known use
> cases for this.
>=20
> There are already other situations, like nesting, that do force users
> to put everything into one iommufd_ctx.
>=20
> No reason to make things harder and more complicated.

Ditto. We just fail hot-reset for the multiple iommufds case. Is it?
Otherwise, we need to prevent users from using multiple iommufds.

> I'm coming to the feeling that we should put no-iommu devices in
> iommufd_ctx's as well. They would be an iommufd_access like
> mdevs. That would clean up the complications they cause here.

Ok, the lucky thing is you have merged the patch series that creates
iommufd_access for emulated devices in bind. So cdev series needs
to handle noiommu case by creating iommufd_access.

>=20
> I suppose we should have done that from the beginning - no-iommu is an
> IOMMUFD access, it just uses a crazy /proc based way to learn the
> PFNs. Making it a proper access and making a real VFIO ioctl that
> calls iommufd_access_pin_pages() and returns the DMA mapped addresses
> to userspace would go a long way to making no-iommu work in a logical,
> usable, way.

This seems to be an improvement for noiommu mode. It can be done later.
For now, generating access_id and binding noiommu devices with iommufdctx
is enough for supporting noiommu hot-reset.

Regards,
Yi Liu
