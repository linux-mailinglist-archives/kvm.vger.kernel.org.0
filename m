Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BC868D92D
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjBGNTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBGNTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:19:24 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9707115
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675775963; x=1707311963;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4VwtEc40lmotLQuit0XjtOINVr41mPFrDYNcYE+e+eg=;
  b=SIkMPIgldS+CfZ9ocP+iAw3rZSo41aaXPtguBijQ+RWV2FCrbqxeHFQq
   jHYtB7JtEdJvLz8wa7GgxqgGv5hDbITpBk9UeC4SdvHtEqLsQ0EaFcXXz
   zXYTiA1PjccmXUcMkCoQlu861xWJY9AzIyo4E01SaxRlgAX79PfZfc648
   7Hz799IGItKo5unkXNaj1NI7P7LOttYUJhiEY1ujJF6BnoqnUz2w9lk/p
   QuTk7y/n/wRSiekVPFmUdYz3vQ9xT9gdUUiHGV8NFsbx+JSu25Exp9zXM
   HfULzR03+uwPnWhNgS7nrGSZrvxuz+sH9z8U0ucbTItbeF4lDLcG1T8an
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="329519019"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="329519019"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 05:19:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="775559419"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="775559419"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 07 Feb 2023 05:19:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:19:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:19:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 05:19:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 05:19:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUHb2aB3h1sOiSX+u0T8RGr2krNCqBrL38QCgJMPJOOZMapKZ69oH9nQMnlNKNkM05uWe3WMorvUiL2IFFIAY1pkimUAURDE2/7Kp/Tp7TFeRKAmARHBEJ/gSlj/qDkFV8VYvVT4WWxr/zWaXIBz4rNsu3/C71809HdvrSILJaI9zUx/GHqxc4OTyiYGVTtttrDFNWuGuJjQUAG3+9Y9dmQDUOIzYz5dczsz3gGEDyJ8w4lDOhfk5m6nLna3kOsLXYnvIJVfVxCOqmQj7njS9oVtqBcYv61PTTMxfK8WQj7mNKHfZz7IY854GhWyKV4KQDLLniWWuJVezUrvgqh4yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvQ5NNcsy2G6Q8GfuaUZjqAx4l6T1B91cwoSR61N4gM=;
 b=ImiZBxkU11z4aV4PZ48g1z2Cm3KFGOmmsgoqhI0+7VxV6NqnQmM4yrndJ3NPEBH0BV6k454SOIBxBkgT2YIaLfKBhUbJZeFczSsfuk8K9A94gtpCO6ogKoB6snJnTBOvYxsS4eajTW/raNvydgfINj2YSCQYv1sLpeGwz7w42JZU4nxJKGPdTjcaYV9W3/0RtD+rAZIA48e4aWoGUqW/l1goxAZMTPgQjpqk9LVyZylzyYOlbNh+08WVadHl0oCaZh9xuD5CLJvsI+9KtxFjJ2DjovTDbqEr4avZ+LJaCxM1idWF9u62NqE97GjSohUF61khtQ1+a3nJyp+C+wkRVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB6766.namprd11.prod.outlook.com (2603:10b6:a03:47c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 7 Feb
 2023 13:19:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:19:10 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6mbRKAgBCCdhCABEMGcIACZfGAgAPY7eCAAF/tAIAAVAKAgAAKR0CAAJOnAIAA02sAgAAAXAA=
Date:   Tue, 7 Feb 2023 13:19:10 +0000
Message-ID: <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-11-yi.l.liu@intel.com>
 <20230119165157.5de95216.alex.williamson@redhat.com>
 <DS0PR11MB752933F8C5D72473FE9FF5EEC3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB752960717017DFE7D2FB3AFBC3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+JOPhSXuzukMlXR@nvidia.com>
In-Reply-To: <Y+JOPhSXuzukMlXR@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB6766:EE_
x-ms-office365-filtering-correlation-id: 87e3f0a1-26f1-40e2-524a-08db090de62d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KyvNjenWWusopI11GV8QuOhzq9U9X4qFMpcYnSLAhwpK5+xEQbpsFLERqryWfqueS4NMQkAGWJQ26ELblX4XB9hN8993qTZXil5WtX41r7QnpI71HgsTZAyKIM+HbKEhSXuJfoQW4aoqIMP6JtkJPAsvghie3FFRSIIKgBoY6eUoywiQzGPEmONNtOJnaqYp3+UWye/7kpDk/31Vn7cPV2dStMR0ELFEyoy4dYcaRNRH/waQC31Cq/3KchYqnkzEeJ8Bc5tlurcz83c8wNf4yM01cQHsHDVoMNP5vzGhzVpXnAc8nkuGIqjRWpd9WoXZoBoUGj/lncYGF5i7l44HedaYoRmMY7GGPirR56q3zslZnM4cI3H5+G7oTMB0w62ASQl8IDYHpRr0YGNDkanX9j9b2xCtl7yBeAnHf9hvdfONQh3BZeCGL6NNpWFHpt4Se2f8IepbGDjh/RFLOuNm2imiAU+EG4JdUhOot4mt+uuggpUEWcW1nH4gad74jVp9/dMZUW6gTBxqRljSG6cgHc54Aw3Jum9FE8staFyigNQFGark7xyf25ITy/rBHLcFIxTf4oT6SUmo3OiG1gnXEZxEsyDBwbw3cHOWgP3Mm4lR/0FotGW0sKXNseYpvcAIEm6Zygq4mZpOYwbhYbDe6ziVwoCc3xZh/x83jcaU7gyEiSZxT1z1M0xj1JBLekeFPLG7w55m6Fl7smq2tc0wpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199018)(66476007)(66556008)(64756008)(4326008)(76116006)(66946007)(8676002)(8936002)(66446008)(41300700001)(52536014)(316002)(54906003)(110136005)(6636002)(2906002)(7416002)(5660300002)(55016003)(38070700005)(71200400001)(33656002)(7696005)(82960400001)(86362001)(9686003)(6506007)(478600001)(186003)(122000001)(26005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CMb9mV43vFfVGtTw9zjgp+MarZEVBYfffc8dHzgrH0+t/CrMGsQ1c6u+ajuB?=
 =?us-ascii?Q?9WJVibqnjmvj3e4toB4b50+fDKKZyTu3mDPQfoB9i9HJJ3w1YgCTprHHX6i1?=
 =?us-ascii?Q?KpO02zmmip+PtS0ymy2cIYJDsDqHM0iDngxEG7NXcHQJO1NUzmzmIDAqVD3s?=
 =?us-ascii?Q?S0r7sDYZURhzOG2a5XPkhkIBG08B1ttsEBi/adN7SOji8gseOmsEw7SNyoQS?=
 =?us-ascii?Q?BXNfFSpiOgI+OYrQ/oPgsD12AXTq+1TXLLDMgcMYBq8bjpJ2nrmruCVVP4qY?=
 =?us-ascii?Q?0OWYFaxRyphMTvnyEcjrP3/QYfYjQGFB1emCBIu6ybU3kCqcwMonHHIFd0HL?=
 =?us-ascii?Q?ny7yVdGGkEb9dOTxuCeA/z5YwQ7s+Tz2s8BrSSS0S5S9igMLzezpvN5Mn1hI?=
 =?us-ascii?Q?DKczskHweH3wGBUCaexFq/r9jdG7T9aWEd/TcPH/5vgT6Xq5v9Nlo5LLgSBv?=
 =?us-ascii?Q?E4tZM0taAcv6LHSfOwedQYqVeMchQ2PDawqOrD4EQwlYiLh96kc+CJWB4tg7?=
 =?us-ascii?Q?IDwyYsFJdFvwR+FkXbJg0T0Wdziu23F3EG6AsYewGNQjVFMVkXej8Hur/quM?=
 =?us-ascii?Q?yF4ost865P6hDXb9WeUEbL4/RazZfvHgVO8aPcDRqExFeUpFDsMsl2bsXlSP?=
 =?us-ascii?Q?rywwj08iiGQuufxSNHxS2NpxzPAtsXBdf8HheM8ODIoPXr7HDwOp0RWJXyga?=
 =?us-ascii?Q?zFd3tdAi9917ztQdRvgw+SR1KoFIONlxrTTkDlKoD8tQW29ZnUgWlXPTHW1c?=
 =?us-ascii?Q?6l77C51oeqTkGhk8FJ8iP7A5IvjL31mD2Z4Y1ay5VpxZ71IYpNK+i45FOyg5?=
 =?us-ascii?Q?bl9aNJ6/3WHKrz1DFVPi+BNoy0vrkDcuwN13d2ZM1vWEUXa/s4qW03PO0b11?=
 =?us-ascii?Q?hYK+NAxaVsvDbl8140xaLDxRpHZHpr66VHLOTOTkxvr8EU/mn+cZwUgHMtga?=
 =?us-ascii?Q?fr6ogiJZMq7fXSDKuQTwv4LMPhG2rO4rR9dN615+0jF5+V9a/RJaJDFShx/+?=
 =?us-ascii?Q?pSboBMEMV+zyMxB6f7hg5ueLfJDqT/PWJFWlt7E1zQJVgK2iTOsf55ly88+K?=
 =?us-ascii?Q?2ifz48MflXMU5d4I+rjEJbpYaUIWunP0kuUgDwYelKczjDAW6CCA638hlu2t?=
 =?us-ascii?Q?9w5Wnc/yngrn3qxHcGqN8XlvmmlW6poErRlyMi04Dj674Noa5Hr8M3KWj1sC?=
 =?us-ascii?Q?T23CwpfeT+WZYa2hOouZH3RTX1Ya47P1STrwG+XaYhkdrAEJzQgC+IjJ2ke0?=
 =?us-ascii?Q?OkpPBkUVDpuy3ANVm1wJA8GG6+8eA3es2/BIdBhm5MQOOMPMpKn/NMwi6AA7?=
 =?us-ascii?Q?vpgAQHlPOhrTVz8M8/pvWizNdzpERiihPGBAKTypWnrq65aQDekngMbxxgSl?=
 =?us-ascii?Q?TTp+6V+Qm69LF8PLTmWA18O4+szAA0CYkOUOQirPuV0biCK+mON+RPG+xPgT?=
 =?us-ascii?Q?vqMq+0bT37r5rOFQjTTRvHFELYVcNuiL+Eq67vTD4LzvqRLjTGMmjbXctnbb?=
 =?us-ascii?Q?t4iPQx4Wq5b2nwRG8mB5IJOSa8unzfI0VXSgYQZ+wIZ4TQBW65zK9jw1Q8Qq?=
 =?us-ascii?Q?Zq8p0EQBZl+xpZvhOLOXwF1WBj8W0l4uVUEe7ffG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e3f0a1-26f1-40e2-524a-08db090de62d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 13:19:10.3543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fk1wJbJ0mgs9BZB7LgVFMvBtfIJflEtpQZsaAQZ0oOldabACGDImVNDQRR9iVtt357sYycoO+hMA7/C0rJz/wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6766
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 7, 2023 9:13 PM
>=20
> On Tue, Feb 07, 2023 at 12:35:48AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, February 6, 2023 11:51 PM
> > >
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Monday, February 6, 2023 11:11 PM
> > > >
> > > > On Mon, Feb 06, 2023 at 10:09:52AM +0000, Tian, Kevin wrote:
> > > > > It's probably simpler if we always mark DMA owner with vfio_group
> > > > > for the group path, no matter vfio type1 or iommufd compat is use=
d.
> > > > > This should avoid all the tricky corner cases between the two pat=
hs.
> > > >
> > > > Yes
> > >
> > > Then, we have two choices:
> > >
> > > 1) extend iommufd_device_bind() to allow a caller-specified DMA
> marker
> > > 2) claim DMA owner before calling iommufd_device_bind(), still need t=
o
> > >      extend iommufd_device_bind() to accept a flag to bypass DMA
> owner
> > > claim
> > >
> > > which one would be better? or do we have a third choice?
> > >
> >
> > first one
>=20
> Why can't this all be handled in vfio??

Are you preferring the second one? Surely VFIO can claim DMA owner
by itself. But it is the vfio iommufd compat mode, so it still needs to cal=
l
iommufd_device_bind(). And it should bypass DMA owner claim since
it's already done.

Regards,
Yi Liu
