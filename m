Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6D3569A5C
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 08:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiGGGRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 02:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGGGRv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 02:17:51 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADCB275E4;
        Wed,  6 Jul 2022 23:17:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwdODXa7IOtSbBe3SSzLbmkbZ2MvNcDsq0DSDALWkwPd2X8QVeYVxVbhhzSpxQoC2IxQ523Wdy9q6Y3U4M4vCP7aegnof6DDW6lpeoqcb7xC4EIsSJ3nqisD2O3WQw2R/WMK6tysuyP3W2UrJxzVL+oI5JPZEK5xtN88WC4vUbyWon1wqxvkFUz8eU+3GM3dSVC6vQJ/BJLZ4lSNMbdulChjklnZ4i9j7gP+bGADJwXVuuvHjxXaN4iJfTQFwiWXJjKHe5l6ol5kxsi+74FNuuaLDDSwYqnWDhM0i7e9ZeZWl4fpGEJTxR6SZ5N06B+3C2f9p3GQg6YWyTD+v+HJXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sxhwa67gU2p5f6Jk9J++Fz8LYJZ3fWZGHdj6ExbkvQo=;
 b=VXvOA+H4kT7Aw5vKrw6ozmisgiMszyoYS9I/FiswbW/UYJj8XOrvk9J4Z2l8qE+IP1qfPBnoy6SPTSTqsMZRrucevTlLaGELzkQKZcF7bFVtR9Z3zNvqu9a9guAk4YwZa5+dAmdtznmsYozEF97IH3Th2J1gMHNitSmmj6llRk5R9+EKiOoohBoCL+SEvMp/MOM5BpkVfL6A1cvVj/zEjlSwpVB4WCzC8kzKsR/7jFJgG0dJ0e82ry+hpuj/R78oMpqjIaEm1p7DuRbNhnSduxTsLsfVaZpur7uHE/PVFpn2FX1I1UAhFuTUfupUkKst3AS/fyKVNMWk9Ontn4IGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sxhwa67gU2p5f6Jk9J++Fz8LYJZ3fWZGHdj6ExbkvQo=;
 b=GOoZP2/PB+2gkDOGFNqpZTMQxMJkzCnE5Om0m5ykev1RUl/O7d4c/Fe9VFqa31JEYC8ncoaJ4x1iAe1IH/pGMTuepYqKuPS2B6SGw9PCk60YAACBXuDNj1m0f9uL++j65O21MMHz69BHsc8VlADZSuNFxT7v76+9f/xXKebNJ/TLgmiMOSdNXDQPtyWPDs0onnTKEanKRAWFuQxVUEdCr6O8/Ejs0gsooMJpmGKeKio4HgPndXLzxVjvseo3jmBEHLBqmqnZ77RpRjClLlRYtQWziolurb5A081XW8tWa95finomAKDEQqRRoazWvo5Os6EC2ltGD+RcFbv5jSZ31Q==
Received: from BN6PR13CA0048.namprd13.prod.outlook.com (2603:10b6:404:13e::34)
 by BY5PR12MB5512.namprd12.prod.outlook.com (2603:10b6:a03:1df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 7 Jul
 2022 06:17:48 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::90) by BN6PR13CA0048.outlook.office365.com
 (2603:10b6:404:13e::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.14 via Frontend
 Transport; Thu, 7 Jul 2022 06:17:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Thu, 7 Jul 2022 06:17:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 7 Jul
 2022 06:17:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 6 Jul 2022
 23:17:46 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Wed, 6 Jul 2022 23:17:44 -0700
Date:   Wed, 6 Jul 2022 23:17:43 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "tvrtko.ursulin@linux.intel.com" <tvrtko.ursulin@linux.intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "jchrist@linux.ibm.com" <jchrist@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [RFT][PATCH v2 0/9] Update vfio_pin/unpin_pages API
Message-ID: <YsZ6h/XGX1RpXQQL@Asurada-Nvidia>
References: <20220706062759.24946-1-nicolinc@nvidia.com>
 <BN9PR11MB52768822A11C158214C6A6A48C839@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768822A11C158214C6A6A48C839@BN9PR11MB5276.namprd11.prod.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5aea160c-e4d3-49d4-3f2f-08da5fe069b2
X-MS-TrafficTypeDiagnostic: BY5PR12MB5512:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7vsBHlVdEAVYoOXSCJVgavi4Xz+fz6sevdZZKv/kH+/J1MkS4HyTqUN9m8Bb3dHTlT6DtDb3Tk0+JB/nwaS34qdEBkJHGhCQ05qgXS0rVM74XwEOngFBdDEbIojk8rHjoMIviOHSE5bngUk/oAwePJnipUpOoayxXVQgPp51qT8sEKFDqVzno/EG41IkBCQg3CG+W2K2bbVe4tUTnRlfWxatM75hRq93OH4Iww9my4oar9OTzXsRwwfjqK6VPEVOoHoik7EnKGe7FHvd2CFkm8df+czVqxOT5EB79EoHzbyJ9UJj0/8fCaHKdbrIwHKY3q1RNuTntJPCLdb1NwC39OjD0U1MXAikrS6DHWK1jO92O7QAJEOxAdGGXQ/tDR+mHMlGt2YbvDO0FxMSDJRSe40px3/hud/1X/lwc7gsiCpEFocO+5EDgxqc7SCWus706CJwK6ieThwRfZjkYk1M7cIWFmgFHL3L0EhuLoZq5jiPgg+ZXHvZzlSbJ0Xsy21ghttP1bG3UhjJGwR4ErPHAADY6iRWTUN+nQbPpdcFL/ditwitF5Am1HTVvXlgHjlFMGQPpAbkF3jb4UUgL3/InYdSTJRQdYFIUUyrYQBewUEKwJi0P07vH/ov7NTJdeszOYo20jgrwq0qkgtqFhKpht12XGCZ58jpAI2N+9HMtc921MzCteuN2cd9Fba8oCHtxUESkPGfJ0gl+uJdjThTUk2rx2jPnL7TB9MZXHJIKcJKQZPdUciOkrM6UeZQHOlhJC47im8590fzU+ahYfU8a5PvqjQ+nMmh7w3KXPyCvOeYXoE2AI41/Uy3oGWAKClrK23cdzp11StYT5M1Ww0/HYUrefP4yf60yQ5uCZvXBlxv0CtxBoDmWI+qWHFRtdTFJw1Ya1f3lrY41abgEcXA4CrhiiUS5csuerTmJ74nbLCFaVkLjx1cp7TZuRnNswO
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(40470700004)(966005)(478600001)(40480700001)(33716001)(186003)(4326008)(2906002)(41300700001)(54906003)(6862004)(356005)(316002)(47076005)(8936002)(7416002)(4744005)(55016003)(5660300002)(7406005)(336012)(82740400003)(82310400005)(81166007)(426003)(26005)(86362001)(9686003)(8676002)(83380400001)(70586007)(70206006)(36860700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 06:17:47.5073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aea160c-e4d3-49d4-3f2f-08da5fe069b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5512
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022 at 06:08:45AM +0000, Tian, Kevin wrote:

> > Request for testing: I only did build for s390 and i915 code, so it'd
> > be nice to have people who have environment to run sanity accordingly.
> >
> 
> +Terrence who is testing it for i915 now...

Hi Terrence, would it be possible for you to pull v3 to test on?
https://github.com/nicolinc/iommufd/commits/dev/vfio_pin_pages-v3

They are basically same but there's a new DIV_ROUND_UP change,
which shouldn't result in any functional difference, IMHO. If
v3 passes, I can simply add your Tested-by when I respin it.

Thanks
Nic
