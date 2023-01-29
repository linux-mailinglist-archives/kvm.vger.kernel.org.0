Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9016367FD6C
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 08:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjA2HrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 02:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjA2HrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 02:47:10 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FC91EFF9;
        Sat, 28 Jan 2023 23:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674978426; x=1706514426;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pe+fxxroHvbEh79dlKPYHtpwvzuWVAKeequTTDy0EHY=;
  b=NiRw9kh/pJF+2CQmzqS6OkaYWHi21c0h6U3gJ+rdZ2tRen+6Ctq/wcWz
   K1p+1rJiDBSz2pfep97JIZolIHWCgO/PxtzeXqQFNO7KoFW5x3QuYftRa
   rmFJzYgjy7Fzv7BrsIJ2dfQ8haTz08GzLxK5XGVgSk5iCaOgTk0AJ8L+M
   5gFBht3Mby9KJquv+jCVoWGlNNEanI+ZeSqbsYT03f1lcIKWZSxZuYIGg
   sCb872wKt5l/vx3zJMOhXpkpQecPFGI85QCTxY2EX9wM8f683Yyr/LOas
   7OcR2W9MIuIOWjczn648mOCjsL2yQBwKnYOkAXL0PxPouWGBuQr276utS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="315329213"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="315329213"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 23:47:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="665723040"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="665723040"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jan 2023 23:47:05 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 28 Jan 2023 23:47:05 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 28 Jan 2023 23:46:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 28 Jan 2023 23:46:58 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 28 Jan 2023 23:46:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSj9GULtI1BHTJtYRSxS5w6TIBk3JXt06Qi5b3q7RhylScZNi52nerjXIXSZMlaYJc27Qodr/3YEKe4mDXB8TFD3hzxVqe/vuVIfR+9YVwXwN+gIpCbs3N9Dx2bJO9OE9VoCsTFzhjc67UjrikwgZatVxlyO/7bh7S/jLP8Paw90C1i2fMEP0SfaQIMx26QHKkheOkaeBWRud7dR7mLaARpANi8z4crwhqP/I+dV14ILDxoaVSR8uVYgNkqYNI428tqTzCgwUhiEZv/1vyJMlqdqIlV3+mQgG7Fr7bKjykVSVdgdAdW750JLqlnQCnEXUAud2cU29PteRjOUX/cUnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pe+fxxroHvbEh79dlKPYHtpwvzuWVAKeequTTDy0EHY=;
 b=BkPx7oQB4Y2UzSU4Tx48voTkSyfheOhqXeQhzoTQPnB5VJ/pV77iXNbF2zcaY9NdS1LNRI3bzq4t7zxRi3s16DmFk+mYkeiK8d8lZudkNJUYhhE/NoFOXNoYJLiwbJsyAzSxp+Kmw9tCN/02ufRQdOHAHhjmIZHQDXeW1RzA3tFSDy5wPdzfHdiyR7Wb9Sz6gn7F8+7FRBnNiWoB2MQ67p8RLQPDWb2qFWFTve9x/0eYzrvbYk2t4IPO8wxBjO/RvVTqvLWUhUlWM5qRRZ2sJVq4Hpc9xx3fR+jlU7wmelHV11lflQDhkp+7blDNZ0b0y6yt4ZsLFq+eR+82fXOfmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CH0PR11MB5377.namprd11.prod.outlook.com (2603:10b6:610:b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 07:46:56 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::2caf:11b5:858d:2978]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::2caf:11b5:858d:2978%9]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 07:46:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "agross@kernel.org" <agross@kernel.org>,
        "andersson@kernel.org" <andersson@kernel.org>,
        "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
        "yong.wu@mediatek.com" <yong.wu@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
CC:     "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 0/4] iommu: Reject drivers with broken_unmanaged_domain
Thread-Topic: [PATCH 0/4] iommu: Reject drivers with broken_unmanaged_domain
Thread-Index: AQHZMoqzQ5srsykynEue8R0BgBzSX661BYgg
Date:   Sun, 29 Jan 2023 07:46:55 +0000
Message-ID: <BL1PR11MB5271CE591B0CA093C8900FF78CD29@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <cover.1674849118.git.nicolinc@nvidia.com>
In-Reply-To: <cover.1674849118.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CH0PR11MB5377:EE_
x-ms-office365-filtering-correlation-id: 400a0a63-9ff3-4edd-f6fe-08db01ccfe61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5q1W07vUdnq7E9SDxMNfj3qsMip+gnsnZQOlto7o9LySgQ4teaSq1HA+T+7ZPKtUeveht2+jkVTOh5Sn+u+WCJq9jhbHQPcOB+snDhLdRjFS7dAcMvjh6UAv8Yr0dMTtpcGbI60DYnf+dRrANlfHhurdgg9SLuZeffOgmMgqz1gDEK837w5Hzh4XoX7AUk5d2oVWJXkEflbj50kMSQtGNCAfwhGO1CAED0dZIfo7y4+dAOsj6vMnKsoeky+6LFzBa7nKOfeG0cdws2H7QmWX4jVxjaz6ZYZqui4gfLRJwJbv/h1VBR/DKD67xoO+iJhA8E6/p5MPQGFoB7Sf0p6GkCOVMxp1X3sI9lmcwxqJXdSA/HnYCnuZZcDiPjoNQjZIaYfK1FThBsE22yB/UNcpsI76O0l0GjRVhZsXpz+0GcVZyRsmyXFhbrsMHB4+OoSbBjoxN8mSP3K2Z99RT6iXhXKrswoEwJXdHd1HZSTjR7gs73ZZ3VjmHXlhJG/eCB27TOojSFxWycQ+gaCLgq/NGthTZYxHXAiSoVW7EcGPqnOPm20z8EdAWfWMLs8mP8YdGnFphKy2OkWCbNceauDs/ojEOOUda36njY+7BqodybT3wXx2W5J5EfQbVIFCRcR60nUCTAJfat+WW5KdZVyW45gZ9IMlC1kMfvVnZmTZQNj79QI4PnUw4M4doFPAadMIrIQmBeTPSxChBKfxH+xRu4u/lH4oJ2kpb/Quu6P4y2E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199018)(2906002)(4744005)(5660300002)(7416002)(55016003)(82960400001)(186003)(122000001)(38100700002)(26005)(9686003)(52536014)(8676002)(86362001)(4326008)(66946007)(76116006)(110136005)(54906003)(316002)(66476007)(66556008)(66446008)(8936002)(41300700001)(33656002)(64756008)(921005)(6506007)(38070700005)(71200400001)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RbPeaX33POKw6flRhCPNOQcc1lKXmaeFyRYSxhDUq7PkqojgbJiyTZ0tz5uL?=
 =?us-ascii?Q?1yc0+KExtmi4tJ2MyDlvDIfidGXB7q7ScPdyUVOuBBctrNqSwywKrjx5cAW+?=
 =?us-ascii?Q?DlruU8gPbseiYQ0Njcvp8x7L0RbVVcrgxR+BfmQLhrneF8mpTI4R+OkqwrEs?=
 =?us-ascii?Q?QA9MSaVvaTY6Jw/aQMZ4sCwAKJiEadxQXK9VfjkPJkaq/WhmT0ndU1/0LXyP?=
 =?us-ascii?Q?BRpphYw332KTe9ZdSPNOxdAxs3PjeTww5ugrbee6RJ3EkZkO+Atc0lKz42gq?=
 =?us-ascii?Q?x1iWnhOA6m7CHrLH3btYCLlo0/zFqxWGwU+oWnNxzByxyogwfNGUIA3PjtQj?=
 =?us-ascii?Q?thZP1gs38zAFxe/JztzFk8k+JnnCkAGlx44fVwWU06hU6Yu5/yrdPpcdNij/?=
 =?us-ascii?Q?hk3hFq9/+nPr+JRzT1nZzidZmt9KNHvTsjs+QexVlfl5glF9nqRK0ZDyfbYC?=
 =?us-ascii?Q?ZqatXbAYxM8X1Ss7I8ibMkrwmUXotjHBK4yXIl0MOLTHQac3PXFNx2lrm3Rl?=
 =?us-ascii?Q?d0H9X79BgoNly8NkJYpItPKw7i6rePjXbvNs4lADWACX9icS3GBMD7INI+Ko?=
 =?us-ascii?Q?frzgVBF2ryKBYly9kQpjHk0mSyS+7Dyq4AhwasZE+jbn1/HD/G9/QI++/KfV?=
 =?us-ascii?Q?88XAiPdD561yrYAc0jfXBo6kQNbXfLtVlX8tU8WfE4nRdZk64ipGmMjHrIck?=
 =?us-ascii?Q?Cosqn2XaDNYRoQfg++1tgYGkjO2poR+louT4h8+C8KRc42/ZsBcuotD8WjXV?=
 =?us-ascii?Q?vkTdwNPIJ1uoDsWmhpNC5iFf+8ZDBDxE5eXE668mskv8xtNpKPad691QcWHg?=
 =?us-ascii?Q?JsSDrciOHP1K6Z+FCxNb7p9duUQxkxKLWMTygV6lk5vompru6aoXPqd3dtcb?=
 =?us-ascii?Q?PdCo2JcqTmmp/JoONKFqlvaOCh+pIuMZ7/8b/vSTCVTSRLUOnW+dwp4P21JF?=
 =?us-ascii?Q?uuFc0XjDecp39XEwUBsT++eR0BgLy0MiosGuUVPpcjjUbp7Ln9TFqnC7iKnd?=
 =?us-ascii?Q?Ov0nYAWn2xqSqeMS6G+vhogQvuFyfSDQppXqLOV4pyQ/QX+Dli76UNTXTgXz?=
 =?us-ascii?Q?y5yNTPa6NBVPYOJ+fCnnM9xEUoVPEfdMGR3xykMNpRcr84Jd02XerfZM7zaJ?=
 =?us-ascii?Q?fCPl6y+cwMTOrG74Wkreb/URrtb1z4ELX/dGm6fQ2rSq219DfhZtaP6YTebu?=
 =?us-ascii?Q?JoiWKXOHhOpzTmrmN4SFOzuXFl7oZEpcWUu2bEj8KgzolWv8mmtBQ4RBz9Go?=
 =?us-ascii?Q?rYvwfXWqPJUalDukhEuzfiKrRNZacRd9RYtISt8YCj4Ji4VTJ+qv090rgzHl?=
 =?us-ascii?Q?pLZZWBNhB4CNwOdMTYb2F4sLrOSju7tzUl1/riX6y+sWi/Xl5M0puXvF1mml?=
 =?us-ascii?Q?jI5XvcFlsxV8pTruPDBXMKrO8HMUrpLc3NnfFYvdTU7mj6acwwVwk3TAvqmv?=
 =?us-ascii?Q?7FH5WNUXjCSqEngysbjdqw7RvSqr2nacuf2NZEHEqe4Hhr+xf8MBDKsAJPJI?=
 =?us-ascii?Q?sTBXd3yUFRLgCdgasLccEKejNK4R6ceFp6+mW4FnNt8jSJ5UHPsVOREIf8/X?=
 =?us-ascii?Q?Fs9xWgZIcAbBPXRM5bxXx18ijpuXBHfIncWhOESF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400a0a63-9ff3-4edd-f6fe-08db01ccfe61
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 07:46:55.5533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGApY2u5FO8zLE+SXyjEJRFzW5iyu1+gqQ3JW5qAHWUJ9Oy7GUJhrQAFVMckzbl/fkGj4FoTzneSuTYypcqw3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5377
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

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, January 28, 2023 4:04 AM
>=20
> Hi all,
>=20
> Both IOMMU_DOMAIN_UNMANAGED and IOMMU_DOMAIN_DMA require
> the support
> of __IOMMU_DOMAIN_PAGING capability, i.e. iommu_map/unmap.
> However,
> some older iommu drivers do not fully support that, and these drivers
> also do not advertise support for dma-iommu.c via IOMMU_DOMAIN_DMA,
> or use arm_iommu_create_mapping(), so largely their implementations
> of IOMMU_DOMAIN_UNMANAGED are untested. This means that a user like
> vfio/iommufd does not likely work with them.
>=20
> Thus, mark all these drivers as having "broken" UNAMANGED domains and
> add a new device_iommu_unmanaged_supported() API for vfio/iommufd
> and
> dma-iommu to refuse to work with these drivers.
>=20

Why not making an explicit way to mark which drivers are tested to
support vfio/iommufd? Not sure whether pure code review is reliable
to filter out 'broken' vs. 'non-broken'...
