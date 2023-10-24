Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C47D5958
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 19:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbjJXREk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 13:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbjJXREi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 13:04:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC55118;
        Tue, 24 Oct 2023 10:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698167077; x=1729703077;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wuFFBBOF0f6sohSN/+TPeeYaDHLCjsfu7LYve0DKGWs=;
  b=BGkjjU0E4ld7596VAZL7PIH7OwdDLKBfQRsMieAiZQucLxutdFq/fXUG
   4ofQ75TM1L5rS72BmAVROc1oF59FwU+XlE6KPfoDV+ixDNy7pb54SnISw
   zRs0ZKDT1wZiDaifZCtDVj32BJOzV0A6FNb311yc+tfeJ+r5SlF8F/FEt
   VjmuxxA6ZW/+1Jsi4KldNZcYpGVrDx7ihWT5wi1ytrHyB4koeel2fy9a/
   OdfV7ZauSfHimiUBl7wNEqJb67AK30olCdoGEweG68xQxcbDDaKjWPVpZ
   LxZuCQOfVRUUhlVxa8C9QmRV+lJdv/HnNAhNI4uTSq90hQxXNGHs/5EIM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="418239378"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="418239378"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 10:04:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="793574435"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="793574435"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2023 10:04:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 10:04:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 24 Oct 2023 10:04:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 24 Oct 2023 10:04:29 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 24 Oct 2023 10:04:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KB5edfZs82atOEzWv2TJPJIoYfV2woRH5bqdKYMGC58o4A7IHNel1DOGzHXSTp97DjdR5os3nwcpbiUEWE8AcMCWOlEpE/O3VbGLr5UKRRwQuH4pWp96BtiuzYI1Nlxa07sNkMENLsSf1Yqipn3CiX3uT9FW3INPSXC3rqpJfRgUagbexsTY4TZQ0qtXQ73akGPJ5L7bdf+b/xTe5felf5RI2Ht7veWlURDls4NMHOCy6Stm9kwqT6EihGMhX57DYF8P1R/IooIYr3TYZxRl88N9AOGIlJ6YDGw4bp92geanpsrb4gbFPj44FgSeEQ+vRx1Q6Q7eGJQZ604GS/yvHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZFMaI0bXeqmzCJLz/EnbTzAw2PMgJmDHYH1Zj4FkJw=;
 b=ag27CMUMTGDkeCtJPUsjUn/iBwsSLt1jo5enQOnTyl8I7DmiKy0fPmWfdLDeR4YGYnMv9B9FXz/qzOkf0KWtJmN3byKMpuZPmHpxOVqEqphklOVdVaamxIKt1ubmBlsruiwXJjoVsYTTA1u8vhgQG7kOKnFkL0fQUL5+B3i7HL4KCn4QA4ozPrO+FCc6FWLt7KjLU6AxkeziM16KwDZYniP8L3WWR4wxl7s+BIHgYHBHEStyqZ91uYBy4Ctq1BldKcWz46jw7GApw4Pnez3GCuCCBHuKams6GnIUrQHBJ/8NL6T5KmQvwlBePLg6XUBLBASGupY1s2+n5o6qLrqPGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB7327.namprd11.prod.outlook.com (2603:10b6:8:105::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.29; Tue, 24 Oct
 2023 17:04:22 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::e75f:ec47:9be1:e9e4]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::e75f:ec47:9be1:e9e4%4]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 17:04:22 +0000
Date:   Tue, 24 Oct 2023 10:04:18 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Alexey Kardashevskiy <aik@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lukas Wunner <lukas@wunner.de>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 12/12] PCI/CMA: Grant guests exclusive control of
 authentication
Message-ID: <6537f912dbb83_7258329424@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1695921656.git.lukas@wunner.de>
 <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
 <20231003164048.0000148c@Huawei.com>
 <20231003193058.GA16417@wunner.de>
 <20231006103020.0000174f@Huawei.com>
 <653038c93a054_780ef294e9@dwillia2-xfh.jf.intel.com.notmuch>
 <38d0c5ce-7de2-47fb-bfaf-50f900b7f747@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <38d0c5ce-7de2-47fb-bfaf-50f900b7f747@amd.com>
X-ClientProxiedBy: MW2PR2101CA0002.namprd21.prod.outlook.com
 (2603:10b6:302:1::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bf37a73-4756-42f6-2e8b-08dbd4b344f9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svskZXefIWhY95qrWjTShqGCwp0FHwnLy3cqKun0cEVKonan9q+W5E4JtdHwEsM6fvzELvbfeoe9F/DLnExHa/LPCX6FrLsJr716fKzR1ocRhS5L8Gbh5CIGRL7suMBZxiHLWBCIXTCEKf6TpGewS/VuW3qr8MhlvYVNS/jkqYuDkrFBDaxe+SuMzjwrLb8uzMbDzUQlAJZ4DodRxLpD5Uetf6Wvy908qDy8Jfs7f0pnQx6jmfxqT8IS5QiTBP18k8N38jr3xhHiZ/JtOXAyFX5d9fKf4/xXPRNgN+PdP42BJeHOdxBJAuNYHVfKE9a/5HMgl82gV+B8+MPwZOUYlkofh4vAKVYRPaa2VH95jz+OIYdNlWr2ykS9w4grpEBlzdsnrgPkOy50xYiX1p7EfabuaIW4ycz1rAoY+zA4XXQRJeQnXcHMQ3eIYObbALogWz40eBi4T2LSJOgGDIm0nmrIRm4BNoS79oESF4M+NpK8KopCf6X4S/A5WKMzHimxgPxW3brLUFQ71Wao7fCTHyWWXIZy6J0UzkHOpvTzz4XUdqpi59Ojh7iyvdgSvgOw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(346002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(4744005)(2906002)(5660300002)(8936002)(8676002)(38100700002)(4326008)(7416002)(41300700001)(66946007)(54906003)(66476007)(86362001)(478600001)(6486002)(110136005)(6666004)(6506007)(316002)(9686003)(6512007)(26005)(83380400001)(82960400001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xLPzBIxHuhLmt+Y86UZ0l2prwOBIF6/P95r82JZAbc6fPjwxS+/8IweKEPRD?=
 =?us-ascii?Q?ewwxfNiYRkr/HHpQntw9PivzrqjFSPHp2w4dfQrkm2qAPoKfelHesZE8IwwU?=
 =?us-ascii?Q?mqied0p7n55pp5Ymm0ecrEn7RgwtQq15/NHPmOVlDPYjw6mCTYyhNSJIJxGk?=
 =?us-ascii?Q?19NVRaGq8lCv6RBWvSNDf/ZhQvS+nt7T5jF72f29FfRz7t0jkjGpWP9rzuZi?=
 =?us-ascii?Q?LBk1+Fgwwo3sec2TR4lluPaO7YON0AyJ43Zs8olfZ5BWZ4tO+z+wKkj71llw?=
 =?us-ascii?Q?wWvu6IhFygZkg3a7TVkj6lqdUGQJ8O242YaJxRHQTcHADUBwSDI99XcrcyTI?=
 =?us-ascii?Q?s/c/uZvlLd+FANsTxiIHoW6Nozbst9AlsW22SFUutGndnW767Ow5bixL3g/I?=
 =?us-ascii?Q?AAUtSulu6nGiFcN3NNAQwSAuOTBszJhgT+ggbrWbpbNwh/AKj7bzbnttASp0?=
 =?us-ascii?Q?y09fAQ3r1KVRLa8NxmbnAqhXzSxKHoBD8lgjY3hM1WV6W6Z/ZnPoVDwbdo0/?=
 =?us-ascii?Q?aF6pnt0Rj+rKbSxThp6ZgWd0I5qfgJjQpy1HJRgOIR1f1XnI3A3Y4bpM6O6C?=
 =?us-ascii?Q?QGvjG7RtJJaeTPLSdvTi9V2bEGDu9nA//0BRiZ8SADPvD6bCbTfTPqpPJGZU?=
 =?us-ascii?Q?YRw2lwp/l206HTXrbEMuoUWgB15HkRKWxXL9QPcMkFKEKnoFKdYAicWABqBv?=
 =?us-ascii?Q?wo4s5Gb86oFwd2APr1rAqH12GmCmFZlSu0JbSFaBwHeY06fgDRdR4OjdYIGa?=
 =?us-ascii?Q?QHs/izaEi/rhAszzloSHXsjx/iHjHyaQ2jUHLSnyg/aWi209QOBvcozpMFPF?=
 =?us-ascii?Q?HN5yk2x/iwbgH9YhcCZlkZ6gEhIDvrlU4LsbuGI2R1n3bvKg6hLbyjxy19hb?=
 =?us-ascii?Q?XBlk244k7e0OSiqNy3llN9EklSym+GZlnW/tWih+ZtsBdsCgHHH36Jlo0s7h?=
 =?us-ascii?Q?YItrguhwfeotRFbJEbKjoHKMEnBTGa2jPW6xcL5/yeffLZ31pbyGZRPV/eyX?=
 =?us-ascii?Q?eoieVurCKfFMfUPFf49M/nQFXmybrpBjRgtvZUktNupM0H2f/L7pf7/aE1uN?=
 =?us-ascii?Q?7PIpv9mM0fXigOo5qCdfTPB7ci3vwA7dG7RyJ8iD0cyrukiJiYfhSuoaPp/R?=
 =?us-ascii?Q?JSGheIGj8fUTojMBYCBIrBSSX2Iv/JYSbcu8rpGazxIT5IeFwRUknaW/Zi99?=
 =?us-ascii?Q?nqb6W4jitqkKsowxhj/FsmqMfv2L1ekHz7JjoKx6l5YrmXycYjry5iicNeP2?=
 =?us-ascii?Q?fEbR7x241lKvo/388l1HQ2k9BKfJjvCwcITBixIdfDjmfyzJlV/DJGfceqeo?=
 =?us-ascii?Q?Q2SzQS4zyizNFbT+bTUPhKeGCXMPyux4KAtRMmBh64jEGVhzCCX5fVmQh+W/?=
 =?us-ascii?Q?rRYhJHUJUKZZJ5oBj8zKCuxjWf2ZDnXa9xfADnM9st6zJP/VkffgQOBRHKMD?=
 =?us-ascii?Q?pOOadvQuT4bt3Osd+WGX3KsclfPHV5hdaAReCGnOa1PE6dzZ7jx+Amp/pGm1?=
 =?us-ascii?Q?SpJYz4fYAQsfLsOBcPVpji/HBIrsCZ4Vu7u1XnQEfyJFT7YBh/q3bJoAHTVO?=
 =?us-ascii?Q?q/f5dgHI9EP7olvG6fU5/CL1qs8vNaWnurCW5fCYNCXfZLhnz6HSEYtOVM2j?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf37a73-4756-42f6-2e8b-08dbd4b344f9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 17:04:22.7143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lt/2q3zPqnlV2piswBHuZWpagEggOrkDHKTk3h6Scu4wNkKilcdASI5lMUzJSYdQWwmSKL3ntAtgRcULWW5DdN6vPyJkl+As4Lz36uO9AI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7327
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

Alexey Kardashevskiy wrote:
[..]
> To own IDE, the guest will have to have exclusive access to the portion 
> of RC responsible for the IDE keys. Which is doable but requires passing 
> through both RC and the device and probably everything between these 
> two.  It is going to be quite different "host-native" and 
> "guest-native". How IDE keys are going to be programmed into the RC on 
> Intel?

I do not think the guest can "own IDE" in any meaningful. It is always
going to be a PF level policy coordinated either by the host or the
platform-TSM, and as far as I can see all end user interest currently
lies in the platform-TSM case.

Now, there is definitely value in considering how a guest can maximize
security in the absence of a platform-TSM in the code design, but that
does not diminish the need for a path for the guest to coordinate the
life-cycle through the platform-TSM. Otherwise, as you mention, passing
through the host-bridge resources and the VF has challenges.
