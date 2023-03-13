Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224626B761F
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 12:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCMLiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 07:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCMLiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 07:38:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCCD59FD;
        Mon, 13 Mar 2023 04:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678707487; x=1710243487;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rABYiajc9sK2VZ+YT+KMTLElYh6s//0o9Lj5iIQG1T8=;
  b=jF4ww7E4hRTfq/KgUMAmaBWee4IkQ5/Usw2bEbaYWj9JPLlDc4GwrcIa
   I7M2Zoa6kVb4XAuRjp8aL4xZ0jwDeezg7/pXREMBsx1PJALepI2/YeJsr
   IQCes3yMBBMj5LNfLU92lR607WQ2gQdTk2MmhPB8PTPqDyFV54E3amt1U
   VDvHNe9p8yqoFk6WELL4W5t9C18cJ2losADmH8SvpjMK7c6wolZaC4lKm
   8gS7TgFt2r4rszwnPSZjpRutIud/nhghtsGUy/snFNdoCakObujw+Gg8k
   pJG/7+nTvCORvOBgStYJmCw3uu2y1a2XByYAR8mLpcRvzyTB0xnn1Lfjx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="337144944"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="337144944"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 04:38:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="821929749"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="821929749"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 13 Mar 2023 04:38:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 04:38:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 04:38:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 04:38:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 04:38:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZ3aID6PJj9SjFsXeodZHYkz8SUSrbFjCoaWTKbo/l2ETHNuoVzTFdZK2WaiNXJtynAnwC1II9RIEe9vXumnNbZ89WHrqXDbsND0KP3tkR5BCq7p7Hqccaj0G5MaIiWMkszK7upgFsVaY55BVgsVGSShEDjOWHqFGwxEKY6JZ6EghbANhP1maYs4fILCmFdRPlLJo/xiv5mM1GbWY3VHqjVIMU/R+3knQY4aAMDYkCxC9M5tzJOOyZdPO/Vj9nXu3T3dqe9Ec9MA6VAKQBC92WXXDVbW/OPQIq0awkqOkGCaG7wMPXVwznmEcw9xc1e+7MWyd2NdeLPVb1An4yCzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rABYiajc9sK2VZ+YT+KMTLElYh6s//0o9Lj5iIQG1T8=;
 b=SDq5YY/E7PPIdMZAhfzS0GTq8UI56LeSiFzHfKiRBMiyUbtkIpFKmz1jhGy2uQzXYC3+uVbvEiCWftpdBb0JZ4XjFG7bUQw91qCzmr5wLno1Nfhjo7GBWQ9ff395pCYu05ZVYIB68auwTTCqqhG6/dkJZT4EWW8ScCnV0b53Bvnlkq/6QFSNfrFHsegrMEtLZZdcg/g6CxOvR8mGB8G1lzyj5c6q7OC87DlcknzVZO4Nln2nU3qkMqya1absrIx7bjO+V9tmtEjE2tnPr2AVP0VxW2HlQdTovp/qeqbVJlhJf0x9Yuopite6Ygz7VCepXwx/sINZQWMHiJJRUvIH1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN0PR11MB6182.namprd11.prod.outlook.com (2603:10b6:208:3c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 11:37:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 11:37:53 +0000
Date:   Mon, 13 Mar 2023 19:14:02 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: VMX: fix lockdep warning on posted intr wakeup
Message-ID: <ZA8Fev1rPB/78jNk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230313094753.8345-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313094753.8345-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SG2PR04CA0181.apcprd04.prod.outlook.com
 (2603:1096:4:14::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN0PR11MB6182:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bc05b31-b037-4b78-0cf3-08db23b7619c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6i3h5gtb/DMusJpBaS6+FQ8Xh9EGa4CVbLfp9XehdgwYOOIiwdEo/obJlQGjBxDVFegN0jrCDC3heDgyMAvZjKy9NLNk3RT0kuo635TGw6RFAqElbuYl7c0iGXiysREoMV4RUI7zVoT622sX7uhshynjTfOiCWWJEn1RhoggTSLka/RKOHhNc3hxovwktDsOhzTOcf7npIk4XSSPsUi3aI4XhZoDYpIU4OY7da9QJfpyPfdcnFMvA4T4SyUA2bKaICgU4/upJRfyMwwKNn7KEkY6HOT06dptWth4fI1x2Lpfr+EaaNxOlQuv92BkFBYISZZ4HjsiE4c36IXWqkGy/iZKxdsi0d1dVKuwE+z6/QwqR3B1FFbJCPV1xehJby7Wbn1duyadYup4SWOTC4+tP58ZGAf2eb2rnTcd78bYdf43dUGMr5Qs4sFme6KKOHMXReJqf8mbHPk/go25eClXNNP78EV8rFgRXgAfVz06SD6qy9zjlPGukSAVkeoBuNmFTnwEHlX2H8g1eENv5LawepTMpfwYyZV36GW0mNclRgC35Qe/jHUBCzmnt+MkVrbZcjIf3DLkTGq/iGYewx8Du4GnHfXR4XxSyMuGSV58GaNE8i1b6ePcHg6ZxIi4PAF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199018)(86362001)(558084003)(82960400001)(38100700002)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(54906003)(110136005)(41300700001)(478600001)(316002)(6506007)(5660300002)(2906002)(3450700001)(6486002)(186003)(6666004)(6512007)(26005)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBn0PXtDXWj6P+OVnpM5jJOvU8KEx1BbOB41zexGZVKfKYv4lYbgRDcB2Sq9?=
 =?us-ascii?Q?B+RPe6Z2Gc0WY1Ki6nCpY31DsErGa2vJyCFS4lO9ZGdbjeO8foMkFhXa0hO+?=
 =?us-ascii?Q?wN9dve/gEBEcw78z81onIVZU2iibLbLtXyDdasimakmIRUDqXDifshUhYBle?=
 =?us-ascii?Q?oNBbrICo23pVcpzMCdxzU3mb8q+CgYBy1eTIHB0E/8f+2uUzlz0U9tvWK4Eq?=
 =?us-ascii?Q?kH2/Dl0mh3znxFlMC/aYGLcSe5oUsq541t9fL5L5wO2W1Z5lmICtSQHGeUlt?=
 =?us-ascii?Q?+iYmJ7KLHcS2JvJKMUcWC1aSZD6b6QV5+Gl8UtJQX+xHaKPiLSFTd+JkIiTn?=
 =?us-ascii?Q?7BLvySGw2iBXuPc9fncQWdHwhg1aUEyeQYx7HYcv76cJWqzn6aQKnAaxpOsc?=
 =?us-ascii?Q?HWSD1/HyrGuSiiYe2A4llex7F6n/hTF9dHqRwSjZgRT6uvCKK4M5KuPp4qCO?=
 =?us-ascii?Q?E7wf65MHh1zpQSDmjCK3HHFnDC+f6A7GSiHDwhN8kAwqmzJEgtVUXG6sOTs9?=
 =?us-ascii?Q?sEOqyBHBcdU9aqXDefPkyl7ixSna1T9SsijTs05b20k0r8HE8gpQgnt3mVzm?=
 =?us-ascii?Q?FHoHplUBMHYbU7wDM0SiBZhGnfnAAJ+qg3eU4sksUCjJVQ5YO05ZnXI94NbT?=
 =?us-ascii?Q?195L/IVyJEywOnmfyZETxEPbPAcBB80BrGlUzWdBI2qcbTK6l4wdI/AjnSEK?=
 =?us-ascii?Q?gOQFo2698E6GVzB882HGSpHEOron2yojjkFzYovXfDcdSUV3MY/LoTxC7jOO?=
 =?us-ascii?Q?oolAY0yq+Jz5VT7Mj9YE7oFp8qrSKj4imnIm9QtLa5vh+epip/njKdsYRcTU?=
 =?us-ascii?Q?6S4cJU1gqrMNkQ4vgolBzVaFmSLWqCrgi3liHQQG7KLWNdDb2hALzaK59m9j?=
 =?us-ascii?Q?E8UdoIEXo+xP0n3z/AygmaiLTwg/jkXrD424u2a44uXGd9dTfpnoRrRE3FLY?=
 =?us-ascii?Q?+ZXmHOax9OJ9DJKvAeyie8WxHDO4LIEBnTgBbP3jcG6ov74IQBqZBVzcfKKK?=
 =?us-ascii?Q?9NBT1i8I8N0gjNGubpv7AEarD/N+Cvf4TSveOdn4g9B1e0Y1fn9bBJclk2oR?=
 =?us-ascii?Q?BpWUFtEXT0OB5Q5u9EtsBLNDboldpBxF5JJwtUVRaEeZwl+xNmNlISHsGfCM?=
 =?us-ascii?Q?VzPpQkBDNYVuzAUmW0cMhwUafdS1fBWr893ZW3g1h5MW+KjWllH51SZVnr60?=
 =?us-ascii?Q?31exZrL6yits5bS+9hSjLlRJ80/XC2pLLDwQwkKcgNH8mmt0BsbvTPUSeaIm?=
 =?us-ascii?Q?thcKRZBY2qmWT0+yzU6BJ8Knb5z3q7+NA9UxpJx1ZDBnek+a8jL72ha/UKdR?=
 =?us-ascii?Q?bIez9ZJMbdNaXM1+L+QSOMaw681LXVEwqwTjZgEq657PRj5Odqjwux/ajP5s?=
 =?us-ascii?Q?AUx/hquzAnIpJjOgbR1VCEp4PIgB+pKSnaD/HeRXyB1BwuJSLOZ85evcTc7W?=
 =?us-ascii?Q?t4B2pzCGII6k136vJ8Ic+o18Hsr5zV0sdEZZH1pN/ZUsANG2JoKU7Wyxf4n1?=
 =?us-ascii?Q?hmEH29ZUxSkblrLZI1W2r2tfqFSCssfF3zBnysCHG4iSlH4Rns7njPgWHjJX?=
 =?us-ascii?Q?TDEV6UXHcRdvGJmR/H+Is78RbA18U3jxU4J0CSONlzFc8+DNdneBKYUks9nm?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bc05b31-b037-4b78-0cf3-08db23b7619c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 11:37:52.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZPsQJKqe+3lG6B8VWisg2Aef+UbmFwU2jr+MKZ5634+FtRdZDUTomN5JHFfvgEHdtbZjKbuST6atGmZQLQJdVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6182
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sorry, please review v3 directly.
https://lore.kernel.org/all/20230313111022.13793-1-yan.y.zhao@intel.com/
