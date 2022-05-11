Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859DD5228B3
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 03:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbiEKBKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 21:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240124AbiEKBKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 21:10:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0478321935A
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 18:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652231429; x=1683767429;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vfqeC+Pyaad7s0gECVHGMGnG4Wu9E/8f6EbRyxynj+E=;
  b=b4lTjoxRxcIdPoqFu8wgP1ihwnrk8EvS0j4l06HVTGn8c3CPOroBCwc8
   zxwMamGGBYtu2k7OQQlSnjwens3e1fJGymklaITqKvvjcXjG7zGvKP880
   LeFEcoQhZI0QHvZFPcjFQaovRqJkLQnIMRlxht7GORUr4FlROqbBb19zy
   PF2alPtU+cX+A4fD8+EotgIYKVA3FZrht84TDhSqaXQUivcoUlvnLROFJ
   oETpGizHGGabFmF1kV6IlmVk7Fiuru4+GHtoyjLxUD/pvAzBb66sH0jDf
   Lh26xEopEsIK+DTmkWyjk+wtsBPKtoUltluEYVfN2LK3DMdrM8V0pGSWf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="267137384"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="267137384"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 18:10:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="571856532"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 10 May 2022 18:10:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 18:10:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 10 May 2022 18:10:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 10 May 2022 18:10:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 10 May 2022 18:10:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFloAoLnMD4FkmyJLsIp2T7ZMbDICwgjLpoQ0n0JiBYN78pMZHdoQHp1e3L8pcUfOS/sMP8nyummmlutgeNBlNXAKSO1qpN20n2jPOhZDqDM74Ss5yR4XIvkWZOVXJrklwNFWogvQ0QiGNnSSJV/ppFiAvChRnPP80XPCRLNADF6I/IJ4xgkRWHgP9g/EZ4smJTy0pjt7aEW2OX9SHNgrWabEVFy8A6UGnwUIjFW5/PLayXtEiBayrFU1yDSI8PI1QWIVpe2jMTUdLilEm2/FHkr2F7kd0/yXQf/pmFWc8t3xaGF/nqXORnGWaQsLnXNMD2dEAZ6BZhH73Yj+vQ8Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfqeC+Pyaad7s0gECVHGMGnG4Wu9E/8f6EbRyxynj+E=;
 b=MDunntAmFsE07ravdjNic0FZ9BKpQ8pFHeIAd96DOFZcsvty5R43iG0l2hLLXMdeBN7sPCz4onivUr4k/ttRU9d6zuYSX/FcG1dc1lwOUWNlXtXwzicFmAwhvXDHV/HFdObSAs8TKakIYH7DPdCTPGTjcUf+ONOlAVzs91Gg1bL9UVcsOjIheQEGNndQsoIFrv/UTaydeZNpaWfO/tiJebUowIjwZyFSGhUXaxkq8cA/FoOoFW0yfqtnUJue0sPhAm9SMnzs13yYlDaa9kIq7rdDrj2qQmiNyVrkOkQijcP/veuWB5EoNKuxuqstjeiI2APw+LWPoTuaiJAhsDeUBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR1101MB2285.namprd11.prod.outlook.com (2603:10b6:301:57::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 01:10:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 01:10:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Martins, Joao" <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Topic: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Thread-Index: AQHYW0R/S6mfDid5yEe6M+QKFrUDn60GOWsggAB3owCAACSFgIAI+m3AgACMaACAANzWEIAAjfgAgAWZrqCAANFfAIAAsyWQ
Date:   Wed, 11 May 2022 01:10:26 +0000
Message-ID: <BN9PR11MB527693A1F23B46FA9A26692A8CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
 <20220429123841.GV8364@nvidia.com>
 <BN9PR11MB5276DFBF612789265199200C8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220505140736.GQ49344@nvidia.com>
 <BN9PR11MB5276EACB65E108ECD4E206A38CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220506114608.GZ49344@nvidia.com>
 <BN9PR11MB5276AE3C44453F889B100D448CC99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220510134650.GB49344@nvidia.com>
In-Reply-To: <20220510134650.GB49344@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39bdb9e0-0dfa-4f98-922c-08da32eb0815
x-ms-traffictypediagnostic: MWHPR1101MB2285:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR1101MB228534C50BF976887035E3888CC89@MWHPR1101MB2285.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KGaCxU2KQ8s7I6/mI6+laNvrRbc+PPiv+uN5s29z7vKowbS+WmiXPY+ULrfIVtBvwc0mnAOAqeDX31clPH6dwWVNIEE8kwaFDELsTlX6skU4BRyiUWHXA6og7Z9g+v8ONPIPFKJa44F5JRB7MgSJVaCGjUx+X59W1hTFaDpYg6Ml8w3zImJ0LbDzSKgvqDX/cp8Fe4J2RZ46MIU5lji6LP8inMMCD6q5J/AfQDYcCKJ/iiVnDsCHElSXCza5zi1UU7ZI58vVQpXPoN6JVnrASR+l7/ZXgbetpwRSUW3JYlcdQwMoC489V6fmVa0NQWhsx4qtUOzp8XpZ7CupGN+H8HvHlAnsdISz9PYSj7xGIZSp4xSOXXE3xkqcmwCMBdaVoN3AXbOk4qedNZAWj4QWb3LKgDBpucJvpyFRWhCumVcE8qfkd87ylGSK99f4wHxufYcLruvAMb3Fp2wSXtmIWQqt4otftnXgTolTPaeM+/AhlUAbI4t6pF4XE0Ib4yySrJU7QihcHK7GvP5URG9vl3wl4We8asqTM+MopX3yZ2zW5EeVL6GwDzYxL4p7iFJS4X+cDGhq3n0veF71OwN+LhDj+hj8wkN+tqVXW6imd0pflV6jR4W149kJ6Xk2oA3zEocF0JWlUM7Wna+O2AQ4sIiePpVZ4+bIXafqc8f/FKKkxkHlaIAtsQ2I90+rPIFUGblurjsBuyePiG5dKTGaZQF0kDr9kpOiNufR8S0EnXo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(66556008)(76116006)(64756008)(8676002)(66476007)(66446008)(66946007)(508600001)(83380400001)(4326008)(71200400001)(26005)(86362001)(9686003)(316002)(54906003)(6506007)(6916009)(7696005)(55016003)(52536014)(8936002)(2906002)(82960400001)(122000001)(7416002)(5660300002)(38070700005)(38100700002)(186003)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZABPx5Eh//T+4bE3MW4D8Xi+J/DVXboJwvfZBFT5COxyYnsM7AzKshgvVjVy?=
 =?us-ascii?Q?meUltDgIaacQMOsFUnAJxOjCVKo5U2HFpXp+F4OXWE5+XdtYuosOsnvb7VUH?=
 =?us-ascii?Q?pC+HibOtsvxTrBAtxMonqrSMGYQUZRHFZZBe5tiVDZ8SiVU+7el/0ZsPHb1O?=
 =?us-ascii?Q?cpwD1ehBUTMNU/5/OU9m/DFXmdGY4oPD3glQNFR+QH00Rhvv7yGCyh7UvXdG?=
 =?us-ascii?Q?H9T5L4UheYMN2f26RdekAvTUSBp+CRYZxb0gme9EZhlNTiIYbc4QzNXNigoT?=
 =?us-ascii?Q?/ZiC/8fKGUHeBWH64Fv09X0hbQ71uf/n/a6lWIXDTlMwgvP4wbKfaSo54qVl?=
 =?us-ascii?Q?uTmtxR9euM0nIbDbUUHSd7SZWzvDAy7zFa0mHKHvwyeE8f1AnJxhksfhHs4g?=
 =?us-ascii?Q?1BTEWeoM65LOsYKvBucpljGTiKB5meF+lbrz6SYNotEOI6Dj1zUC3FXepuO7?=
 =?us-ascii?Q?hYmU8TDMKhftLIPS/JzuhQ5aJ4vP1kPK8AUCwANSHRvWxYLDqBXYjTHpVoDy?=
 =?us-ascii?Q?xRPuZ44oLLfGpOTlTeLUgx/NDDI54NHzay04jFPkHlIp86R18Pgo62KUp6IG?=
 =?us-ascii?Q?k0I+0rfwuQ2bag+7JY+l7VIbqHc8sMk5slQZ/hpuYPSYC3iEPz03M39fByws?=
 =?us-ascii?Q?f78gSBuufD7avfNsLms3RdvgagBW7x58BrZPwTsa8uKqUKyT04IC08IiSHAw?=
 =?us-ascii?Q?Ko21ZHRI4STOrCG7n6lyL1HDopO/T+UkH8LSY/lx/beLCcYn7IDar1FneIhv?=
 =?us-ascii?Q?V88+mDg/hGf2SxExjZ1JwJzWM3bQB0TevhIVnKxvpDkGdWrWKmVAX9Kol8uJ?=
 =?us-ascii?Q?rRYZhHsO/BtQe8KKnyi5Ycif7It5ZW/S3xOITOri2WqZ0bV7VIQSl6dU3Hgx?=
 =?us-ascii?Q?LACRGEHJLrFI7V0z5dybpo29k14caf+fCPcKupeuq2ngoPZWu2kjPr5S6iwt?=
 =?us-ascii?Q?vrO+oGkc/pqtsjppO835QbjNvz96tHpzZSURFe/jCnURYhTkEgI6EdazGhyL?=
 =?us-ascii?Q?b7Et5DW797AEEHL9gFSINu2lvf1mQGwlWXJ7QT/QixOYccCYfXuYyvpmimjj?=
 =?us-ascii?Q?rpauK4TDUgpbJXpSigEXNGjKH39/ILr6B6hkq2tkFC1oXwIbLSSyTarfcQry?=
 =?us-ascii?Q?2AKz7qRwtReCttqqE7AnFhU+BamNZNNeaplKNhemD4rKf4JkSIG4M6SIReKM?=
 =?us-ascii?Q?n4AvesQN7ve4gXwgFCz9z2Em+X4wfFbSgNPlbQsWRIelT4pCCG86enA9Nxtn?=
 =?us-ascii?Q?SJKjI13gQrBR77+cFK+/yuCxNc8NmmfXAVRPO36la7J8Cs1Mnxb5STZ3LMEg?=
 =?us-ascii?Q?wo7xPxzG10XuzXjyA8DNheKCNOXUs01XWOCpnIv7jYlZ2BcGf8aat6vwybSW?=
 =?us-ascii?Q?CjGCqYEg6FLkxyrp+F/2m3lESI618lafFyU7SW5UpSGZuOCmlBmaX8Lx+iLm?=
 =?us-ascii?Q?MYhTCXVqLHMwfSbQRRwnUPdGr2NDgbt5uchu50g6JuyhAj13GjJlXahFTrzS?=
 =?us-ascii?Q?c0TWSoNFcVRKzPgY+MS8uEBNVKSr/XUQCMi6afSHoSO6st+qu5P3sryoxauo?=
 =?us-ascii?Q?1JQhkQpuGAynxIzJ6QUAXGFKJCmYkmTusss5hacGBUxcBVEjjAiZCs9gOShC?=
 =?us-ascii?Q?dnXLEbAygHFZO9FM5eIQQwH7wOdn1E+8C7GxhWCR16jymQd6n7AYDNrTfV0e?=
 =?us-ascii?Q?dGjfS6aw9EdU6yQ/inV0Bd/qv74Jvu75rWWrclobPurEXoWH3H4GILJ3/BDh?=
 =?us-ascii?Q?LyTyhfVbIQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39bdb9e0-0dfa-4f98-922c-08da32eb0815
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 01:10:26.0212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iy989ap1jvJSMRIJJtDXkJWmT4LDjIAb708TXi1zuu9gfT1ZwhfVzmsHgVTmKHOdDISnb2V+n5P3Hf2fBTcN0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2285
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, May 10, 2022 9:47 PM
>=20
> On Tue, May 10, 2022 at 01:38:26AM +0000, Tian, Kevin wrote:
>=20
> > > However, tt costs nothing to have dirty tracking as long as all iommu=
s
> > > support it in the system - which seems to be the normal case today.
> > >
> > > We should just always turn it on at this point.
> >
> > Then still need a way to report " all iommus support it in the system"
> > to userspace since many old systems don't support it at all.
>=20
> Userspace can query the iommu_domain directly, or 'try and fail' to
> turn on tracking.
>=20
> A device capability flag is useless without a control knob to request
> a domain is created with tracking, and we don't have that, or a reason
> to add that.
>=20

I'm getting confused on your last comment. A capability flag has to
accompany with a control knob which iiuc is what you advocated
in earlier discussion i.e. specifying the tracking property when creating
the domain. In this case the flag assists the userspace in deciding
whether to set the property.

Not sure whether we argued pass each other but here is another
attempt.

In general I saw three options here:

a) 'try and fail' when creating the domain. It succeeds only when
all iommus support tracking;

b) capability reported on iommu domain. The capability is reported true
only when all iommus support tracking. This allows domain property
to be set after domain is created. But there is no much gain of doing
so when comparing to a).

c) capability reported on device. future compatible for heterogenous
platform. domain property is specified at domain creation and domains
can have different properties based on tracking capability of attached
devices.

I'm inclined to c) as it is more aligned to Robin's cleanup effort on
iommu_capable() and iommu_present() in the iommu layer which
moves away from global manner to per-device style. Along with=20
that direction I guess we want to discourage adding more APIs
assuming 'all iommus supporting certain capability' thing?

Thanks
Kevin
