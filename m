Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE17408D2
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 05:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjF1DKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 23:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjF1DKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 23:10:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F81330D4;
        Tue, 27 Jun 2023 20:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687921814; x=1719457814;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=V8NkDnbHcB5+Iit+1VxkloAb/ilk+/XIbezfBZDs3Lo=;
  b=GdLN3NwAMa0SWAjAwzMNon+DHektx1EgrocuUQ3ArtNkKdi76iOpszZ/
   T1CnD7GE0Iv+oBlAcZJainMtspBWzrAxVjZSIivZipbrpKi+EthEOwDRJ
   lBm9QFnvNJWPZ3ZwpAKKzpPtt7gyF1o5PNpOcmwd44Dl3fsepdeVJgp6n
   +u0G8Y4bTrgr6xXYk1kGqrL+scTCZ4qtiAmwmRxT/eYlNfRCfcYgHxwSC
   Y9yWX3gfpwE48SFoP3cmuNqgjKY/l7Z2L9hdHcAlNyhOh9Hgl6XV5o6Jy
   vZV15u/IeWo12LnOh7aoXSPOi5tF4e6duHl+P0+nwiuRqAY5Aa2qec4i+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="342074936"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="342074936"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 20:10:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="716767948"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="716767948"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 27 Jun 2023 20:10:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 20:10:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 20:10:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 20:10:10 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 20:10:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNgZP4eoAn4bniWADLXegIKsdb/nFtfphCFnv2B+gl/KIAURHSOaSQtx2U+EkZc+66SBvfbs9oxppholjpfzG10apaIh2LwkAJFhzA2AvVyoTvEcQQoRP3nz0JtaA0SEiZY962atVF2SEDO+/QCtnC43pk3ptsZOHusw3DEa1GD+sn7mztMc6wHFwK1qKNpPEUTUD/X/kU8p0oZDf5md8vNQtHVTxod/T7Q3GA5kPu7a9YG7BVWuYcV86ItaaMG26j99TbSg3GflA4yOqHjEtaxmqLgklfuiJs6Qt9MeGV4DywfzOOjcnRRI8xS0N5tzEollzvyaRLQ/Yk7uct/FyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+2Dwrrz2js1G/DCiLjGb9k2QIN8W48NoC0axczt0Xs=;
 b=ccLMehj1viHviqsnY2/lEqrCYocEBdvmwnkUW4GLmMAArtCwJFk0pzr1jEtrl8K9W6Lh3OJm+QBReda4BYpvMn1GSaU5Dar4znsNNpHyvOHC+8DnPCvQ8G0QauIcmA+qSxgCCL05wlAn2qyZ2y9f+8IlotQ5gW8+NRqWwXWUHfy7IjyQWAo7DhJDoueprz/f7jaINPKRM32OFYhn1qX0zhUwi2TvGH3d/u+Ha6pGx3lGyfb60xLZQg48Sa8IVsCGMbZLVOT/xOAiRkum46NpwYZZx8xF4KAoq3R15ItgRM265aZQ+K4SQftwgDV2jYQ8++UhudSJRcSXMYVHef+I2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.15; Wed, 28 Jun
 2023 03:10:01 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Wed, 28 Jun 2023
 03:10:01 +0000
Date:   Wed, 28 Jun 2023 11:09:43 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kai Huang <kai.huang@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-mm@kvack.org>, <x86@kernel.org>, <dave.hansen@intel.com>,
        <kirill.shutemov@linux.intel.com>, <tony.luck@intel.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>, <bp@alien8.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <david@redhat.com>,
        <dan.j.williams@intel.com>, <rafael.j.wysocki@intel.com>,
        <ashok.raj@intel.com>, <reinette.chatre@intel.com>,
        <len.brown@intel.com>, <ak@linux.intel.com>,
        <isaku.yamahata@intel.com>, <ying.huang@intel.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <nik.borisov@suse.com>, <bagasdotme@gmail.com>, <sagis@google.com>,
        <imammedo@redhat.com>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <ZJukd/bnkffgsQzT@chao-email>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
X-ClientProxiedBy: SG2PR03CA0088.apcprd03.prod.outlook.com
 (2603:1096:4:7c::16) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW3PR11MB4683:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac695e0-a236-4a1c-2a39-08db778528c3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2agx/sSPv6bXwUMUTagc8kReB8MueMczByr0eIV5GGcBWLYOyZL+z0YrUyEJdkc89jitlFvPOODtsTEXVJem1z+a9GS9T0DgkMqQbKzcKt+qtHuEy+J/6qc1yRmFIywY8caccfhSr24+geAAPC52xS14eMx7sey2jQQ+C5l3SgdSXIHbypn4hwfr1tJIHmat3gy71bCfQ0qACCL0aEjdevkdV7wwNyfN/lPo5s4fM9SiRzxc9c0gxx8inFDYO5weeojmbSoNgwTxWsg6vAxEf3HPf+x6ddYVrRU7Xs4yUHCUPjdK9Qk2FLAHXmMTgI3wa/skeyGQkqUQVr+iQH/u2pfzwLxeTItTcIfFGH2hkTonMHh4KYPC+KJy8xtWU1n/WY/bggYZzbipIkSCoa9g4tDmZ0xqenP6rwa4NRGmT6s5CBNLEtOiaEsZO/iwQA3D96t+T/IoXSTcl7+S++m+xS/1YYzbo+8VJft9oMHD/ZzBCooExAhdQdu13QTepcfisAn+siN5JsluiuUTZSerLsuLfcecjFQ949B4iIdvIM8m64LAEA52FHPsIq3HFIGj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(316002)(38100700002)(82960400001)(6486002)(83380400001)(6666004)(66556008)(4326008)(6636002)(66476007)(66946007)(41300700001)(186003)(33716001)(8936002)(8676002)(6862004)(26005)(86362001)(6506007)(6512007)(5660300002)(7416002)(9686003)(2906002)(4744005)(478600001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D/C0Wa+JlNdG6T45xzj2uTpK+r55ppb/TOl209DeQPZLwKE91M8T9FmhfeT9?=
 =?us-ascii?Q?YzlAQuK7EmzwQR82WiAiRYT1BsPmNEpc1L4LfZFUZShlH4Kyidc0fVZkdARb?=
 =?us-ascii?Q?EQtRaGNR+1ZvUYfyN+T3GxHakfTVWludD8LkWZNYojh6WgZYJ9oQJi0+M4sP?=
 =?us-ascii?Q?qU5BA/YtfyGkyNCBcOLeIxK56qEeQ8qG9l8uzp8PO6foyDxd8Kys4A28FkNo?=
 =?us-ascii?Q?fGYnra6u5vMyn9wj9Zt19DedokJP5B8ok2FfJujbs/2JGp0G3+Vlbe9x1yvc?=
 =?us-ascii?Q?udMBEwidRyydYivzrhgtOSFDMJDs5Gw1RFSch0ysZSYeNEwjzRO5up0nke/v?=
 =?us-ascii?Q?Vp8YmZuvcyc6s/oukNHFfGZ0bPt1gmWhXBzrrMzUyyS0wb/UegL5SZxjv+Yw?=
 =?us-ascii?Q?uC9kaFXLRZBXelVMmoad8AAJgv4qcuLmY5yK6WYd56uWl/w+tZSlqnzhpDo5?=
 =?us-ascii?Q?rslcN2sfJR257Yux64uuQeAV38XaUWUbgqtzgz7b0PpsCvNJdkgIS3fByoJ9?=
 =?us-ascii?Q?Nhj8BZmwwyCcWBZxM/IDwuIpIXWS2JC73sbuoMS+lY87WaaZSutoWgflci3P?=
 =?us-ascii?Q?Gi0/RVGkcc2G/motvnPtpvfrHThG0R6d94TAg4VgguzbMTO0Bv65stNdUrsn?=
 =?us-ascii?Q?WFFD9ntrxHx2/ujsLZQMg2RjHW43KR/JdKodq87LhPUT7IuilrbyxxQJ9Kbi?=
 =?us-ascii?Q?ckUQJUKAFuNLcNcptvV3erP4heShZ3e2s7aw5RCZRmneoC1oUPQmgcaW8Zg7?=
 =?us-ascii?Q?qvtBrmks0IjKgwfMeuI5eu+8UWe1/BT6yEKoJXX9wO048AH1TZPSfDsD83TS?=
 =?us-ascii?Q?bLERd9hCBYwl/5J1CNHgGzojwDPXi1vsfJeDXYnsrYA2jAqkWsQkwdqjbSzt?=
 =?us-ascii?Q?nOvlbf4J+/6deAsqAQhpI42t5liKU74k96xw2z5gxxUirRpmDskwPpbIHVAd?=
 =?us-ascii?Q?W4zDKO3lUhznpK9LnPgO7OceKIjfqiPkKi/9QE5pd9W4RBSN/TcY8p2waU6C?=
 =?us-ascii?Q?B1VI/bKfp/njlv8C5iYWtnq70R6fJAHS/Wt/9QJykgPCxwbzl+/SuI4w6Afb?=
 =?us-ascii?Q?iEoaUiAsOrDNOT8Md2UQB7N/98y+uSupFM+62Ylg7DUwxgX8DWiAefTD4jMi?=
 =?us-ascii?Q?3hkgitOyUsGbsZwiFofl340XJ6wwby9YrMjJAW+h4JrIDfC1GgCOQ36ZkWbr?=
 =?us-ascii?Q?sMt4CDej2pzTLDJqUNAh9YMPRskSMj5MrEJnVtBzqOna9xm2+gb1nvz4GCwp?=
 =?us-ascii?Q?WM7ZcYjWMa1ZRxWk5T8vlE2C+hdcP4W8BZECmw9qwjUzSA1oUQQ74uEBaSfq?=
 =?us-ascii?Q?ngo6ZyMlvLM6tbE2stWECH5Hrat9tvXH/03gnI7G1mz4GVSVZksbEIp00VDT?=
 =?us-ascii?Q?FBDnlpK/D6RxW82mvxhDHs0bzq+KFiU5JdNs8hCVSbhOrcc1l4qZokypTCMV?=
 =?us-ascii?Q?JVQMnQOvPnk6PSMMFR2LzxpRxUM2KyijnGXHzZTu7BxwR82mpEeEBFo5ewIa?=
 =?us-ascii?Q?AY4iS3865+eynp6tve/ONAeAZwjfFxkXJkWygPsra1yEoq1PfIcxqrdZx6Vz?=
 =?us-ascii?Q?Ir/0YuAp5FS/TImNV8x0OYercqxVsTdlawL6fbRa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac695e0-a236-4a1c-2a39-08db778528c3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 03:10:00.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x7vNoHPdtYhBn+M3t6NJh/yxX871Sec8rxqgwq17gZiZGuDpdkcS+1NWAgAA6ez3UWl6dMoKULFH697rpKI0Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4683
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

>+/*
>+ * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>+ * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
>+ * leaf function return code and the additional output respectively if
>+ * not NULL.
>+ */
>+static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>+				    u64 *seamcall_ret,
>+				    struct tdx_module_output *out)
>+{
>+	u64 sret;
>+	int cpu;
>+
>+	/* Need a stable CPU id for printing error message */
>+	cpu = get_cpu();
>+	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
>+	put_cpu();
>+
>+	/* Save SEAMCALL return code if the caller wants it */
>+	if (seamcall_ret)
>+		*seamcall_ret = sret;

Hi Kai,

All callers in this series pass NULL for seamcall_ret. I am no sure if
you keep it intentionally.

>+
>+	switch (sret) {
>+	case 0:
>+		/* SEAMCALL was successful */

Nit: if you add

#define TDX_SUCCESS	0

and do

	case TDX_SUCCESS:
		return 0;

then the code becomes self-explanatory. i.e., you can drop the comment.

>+		return 0;
