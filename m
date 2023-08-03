Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9F376DCD3
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjHCAoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjHCAoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:44:10 -0400
Received: from mgamail.intel.com (unknown [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C7B2698;
        Wed,  2 Aug 2023 17:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691023449; x=1722559449;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rkqLLp+dn4VE+FuBhuGyXoJSxYvGwpU1xBIKhCktz8A=;
  b=bp42+hWEu/43ZDAD0G6Ddv1oHrcDCQeF0vKoHvCsFKesWAUx8CZjmk77
   JDGq1Dw/GqIvJAOtbXAc0QB7BHAkHcC2dTjJcCbGctu44PmqeVrSfDVqs
   dU1TtVNGL01AFENsyoGnzhibrlwDYFkjQXpLTXvxp3Zxn4BaTft7zqc6I
   z7SLxhINy2+2CE7ZQMrKhXziHEPIiqlDDO/xKfg9Op6bxPzyLsM4t7hWh
   63CnCeO6AfeFsGZhQrygzKrq1F3I31ojTeauwIaBR2zpU75DikBzSdyvo
   z9WWAJlHCFtwNNnrtcVhY0skSJuyYQMISMo7p8YvjUlNw+SQ13PEyeMsc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="369739233"
X-IronPort-AV: E=Sophos;i="6.01,250,1684825200"; 
   d="scan'208";a="369739233"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 17:44:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="799324573"
X-IronPort-AV: E=Sophos;i="6.01,250,1684825200"; 
   d="scan'208";a="799324573"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 02 Aug 2023 17:44:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 17:44:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 2 Aug 2023 17:44:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 2 Aug 2023 17:44:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 2 Aug 2023 17:44:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqtN59uSO4Gwg+RxACupwXXwcHQsOHsTVU7tNYplx7+YAsCnfv5tINi991feu9pTz+EbQ/w0U1wPze8jmZSqIQtM/VjnwQr0DockRed82+e3u/8gX5XDVJUEk547kOz21ED2AUlIU2RUb+xiTWH+7f90aDBMVjyU6v8T5NBzm6Ym5cT44cUKYLDowYeYRtqevCfwXnFYYgtqw5S6abHL0YEtXoi6kJKgGWx13tgsqJbJPL02NmH7IefFgGQBbzTwqnExZg/+Udo5Fav+rx43xtWGU5WF9f7iqDUKkpWKZVaKf2UbsC+ORt/OV9ZJYeqdufv2JskR4NCLAQbt4i0SwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMcHCc7lJsfuHgEhnJpwfeq7rTMX7Pxf00DgDd2DDcc=;
 b=PBTfYXXOsY7ZEt+DWuceBp5x7YG2YQkN31ZrjR4TiInREtNJr+N2Xl2LAe+e8VOy3DRHO5Y7+6RYEUZeo7b7yk50nzEKnStA81MrJE8fE2ZtimTAOK+XTonUZ6DTQI7f1+fzay056hXDBbdXheskJi01TRnoanAWaFIqyDvFsDNivWsNcZZRg5Pw4sbcf9secSOdFzRZNKVk59AywUkClur2Y6xhPfbNtPiWzGGxT+F/ijRjlvKOyzk183GilpFG3HnwncAvYUoXDQXiJFdW5i3JnBWMbXaPyge/Bk5+Rsmsx0PGeYbqhXAEChItAM3pNEAI9pkv6rOTLD7mM57s0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6325.namprd11.prod.outlook.com (2603:10b6:8:cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Thu, 3 Aug
 2023 00:44:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.020; Thu, 3 Aug 2023
 00:44:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] iommu: Make pasid array per device
Thread-Topic: [PATCH 0/2] iommu: Make pasid array per device
Thread-Index: AQHZxEIikFkwfZS1EkGjLQBwv0SKWq/XDxSAgACuMQA=
Date:   Thu, 3 Aug 2023 00:44:03 +0000
Message-ID: <BN9PR11MB527649D7E79E29291DA1A5538C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <ZMplBfgSb8Hh9jLt@ziepe.ca>
In-Reply-To: <ZMplBfgSb8Hh9jLt@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6325:EE_
x-ms-office365-filtering-correlation-id: d3491b7c-358f-41bc-8abb-08db93babc10
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iw+gZfoOSxEPh5+o/dxYfwlgBFK2YZwsjYhl95rsd9gLEWBPUhjU467inQN4TBfHL9N1p7lXZ7cJAKIXusdpI8brDefQRY915jietIC8KYHf5LDqBulD/RuXGXs8zx4CvVkafx4DmW0qJEeIqS/lC+amhO9hccUNINKOt4+n0m+BQnk3TYleG8EyBbjX3X0jUUWzm1kCLeiCoDPjGb/5+hl9d9vG0tTPE8Va5BVAdz5RjVVYjklzdA24cgQEPobTSqZi4/iLm29nfeHNdK8RHeDZnvu7XMhgFwyY88diyeKb4i+2TFsDvMSy6Ykp+dmMMwQBgoc92i9ES75iJdWwAmt00UZSuFS6lHPFlASNuoW2rmYCjN1oJPuZHA988gQ3ib5X7K/r6P05op+K4XNMO1A/fB0zNF8GPtreUWiPr/VSM3J2P4eQAM+yEXyKryDGCd8AJpzF6g24l6BvfxLdTX8psSpJKfXNkoUsBjhdsrr8M9ZQa98ZLzd2gWrqh3FklETwMcPLQmyqFV90r7g1jmXGRzwzpxPRtU4igkBiVWOmM84MPUIz8jbDqTXMjpWa98rjry9U3NUhysoK8PRt2d9uiiFPi+VEskpUIxZ1Eco=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(55016003)(186003)(9686003)(966005)(316002)(478600001)(122000001)(86362001)(54906003)(110136005)(66946007)(66446008)(66476007)(71200400001)(66556008)(7696005)(38100700002)(64756008)(4326008)(33656002)(76116006)(82960400001)(6506007)(26005)(41300700001)(38070700005)(8936002)(8676002)(7416002)(83380400001)(52536014)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QUBNzmeaInFgN+emZ88A7zmKpu6t2zQUzGZ5N5fpQ7jiEGg7U+3IwsGQ7qLD?=
 =?us-ascii?Q?jU65hvA3b6Ym4ehaQvjNIMmoIDWCI09/OpLk0ecZxTqVXUUoWV/F506ka7sl?=
 =?us-ascii?Q?yfxzhfsCJVpscqA4AjBukFg8E3Gand7gZU3M69lRL4yrMmvD2+gEjFDKtFu5?=
 =?us-ascii?Q?+3to34AIxEHDx76TXfqGdtWRYhuQce1/oU0a3BlJH+05KHc1S9IoY5tNikb5?=
 =?us-ascii?Q?nqw7Zasae8SMEUR+T2/DtihtXGSOYMOa6jDxL2QYslw4BkOdkWX63NQXga6y?=
 =?us-ascii?Q?x0/7c4kRiCi5h4h6DCqe5dWshMuyHPt4BOSwg4bigKbsltGkwdrQ47qGGcZR?=
 =?us-ascii?Q?UHDRABbSQSExudIObrD7FOFTYg4quhaEOcdPmGmqpqgnLRuFaEvGQLoKwrQn?=
 =?us-ascii?Q?5Ex3UkPsK6+JP3xRG8HnX5qlBvbcyNj5gHvK5O85MuJ6eARky8f7/2RHwTKt?=
 =?us-ascii?Q?x/F38SR9vCndc+PKCvNSSquvz5ffOLdKaJlv0MZEYJgW44xr6qQ4zy9Z28rL?=
 =?us-ascii?Q?d17BMyOO8l864m/jvlgUHm7mezYkODMQsaeIf9DtM1hU2efV6Ad4NcRwsgF+?=
 =?us-ascii?Q?JInOM7R95PxMKlW5Lsecasy5dCUUsyU+XABstwGMn016/HKM/nJD/Ho1Lgkg?=
 =?us-ascii?Q?VuMNPqeQ7idpQiqwsJh/+4Q3EhxWskxgdI9OS9s1p2XXbHaraUDB2IV3Wdja?=
 =?us-ascii?Q?AjvzPkuFyV/GKEO3dE8xhcXCthf4692anwBKMyc2GZU5cyb/kHyJMvjkZmBE?=
 =?us-ascii?Q?RZjYx/FJ7A+gyuRLl4hABiG6g+tv1Xy0Ip97IQLu3FQOwPTJj18KtDHpNmnq?=
 =?us-ascii?Q?x8nbbp6q5rlVbWBQbTkES0zF0bGs0hwDoJwTjT7uw4ytR9EYGQ+TMMhGnIEi?=
 =?us-ascii?Q?kgPvt8Y6CNR4AjTO4/vtwbohKa3M2ISA/ok/Jh+yHV3r88aN3uPBkoZk3W6G?=
 =?us-ascii?Q?tGjil7pKUeVsxbhYCOOR8UROY3PcCD4j6dgCzYuANv4q+hFrvj9DXL4FPtjG?=
 =?us-ascii?Q?FMhNj5HfKiUSiiRN3Zhf01y5DPxrTQ8LqBdspQMOnZFcX8U3iN4sEm22lBSt?=
 =?us-ascii?Q?RhzcwuGcjEE2e3oseCy/QDRDYCmUO4uYLtZIFGeFwcYF/c3kUtuID2uU1Xi4?=
 =?us-ascii?Q?4JT9cc6n6PrQLeJuxpiME8SiCpPvtYNqzh9yxtA65leOD9zktZ5ElxhmVDHc?=
 =?us-ascii?Q?b2sCQbhJPvv5BpVv/vjNnzyUt3I6o+m1XSGWTImV5sOH6vrZOyosqllK+01i?=
 =?us-ascii?Q?9l9bl4HhnjhJ+PE5M/vFzZQQaPtKi0j/eSCnTptZIiO+u6h11kLDXipdDC2O?=
 =?us-ascii?Q?Wt/MU/pkS5mGcwJLZvwX3bHBZj/VVyNL7OLuPUs4dKKk/lh4JxKalmqT7r2n?=
 =?us-ascii?Q?SjsfuN19j6qW0nRS3qb+vPjbK8Ys3nBrR8aHNr1euksVL0ebQ6wzmqYUEASC?=
 =?us-ascii?Q?Iraw4sE9ld/kXfnh6lUKimnJlqHAyy4ufPDm3KFJwxA2ss1OJYvzONshrBKn?=
 =?us-ascii?Q?Nd5/yCuslS4qlVP8PAurkKBErnXnKx630Rt4FzI5UIiobVPxcfcb5w6XqvcK?=
 =?us-ascii?Q?7aqCmPEHQKMvXJCW3FG39IXr3Vakf/H1fFepX922?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3491b7c-358f-41bc-8abb-08db93babc10
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2023 00:44:03.1114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0fh88BW12yyYgl7QcQRxRIz7lADGu+yvqOdUTBQanyiVhMuCHrJwWYyTqzkBelhEbT8FDrCAQvh5nJ/e30F4ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6325
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, August 2, 2023 10:16 PM
>=20
> On Tue, Aug 01, 2023 at 02:31:23PM +0800, Lu Baolu wrote:
> > The PCI PASID enabling interface guarantees that the address space used
> > by each PASID is unique. This is achieved by checking that the PCI ACS
> > path is enabled for the device. If the path is not enabled, then the
> > PASID feature cannot be used.
> >
> >     if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
> >             return -EINVAL;
> >
> > The PASID array is not an attribute of the IOMMU group. It is more
> > natural to store the PASID array in the per-device IOMMU data. This
> > makes the code clearer and easier to understand. No functional changes
> > are intended.
>=20
> Is there a reason to do this?
>=20
> *PCI* requires the ACS/etc because PCI kind of messed up how switches
> handled PASID so PASID doesn't work otherwise.
>=20
> But there is nothing that says other bus type can't have working
> (non-PCI) PASID and still have device isolation issues.
>=20
> So unless there is a really strong reason to do this we should keep
> the PASID list in the group just like the domain.
>=20

this comes from the consensus in [1].

[1] https://lore.kernel.org/linux-iommu/ZAcyEzN4102gPsWC@nvidia.com/
