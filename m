Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE758715E81
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjE3MIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjE3MIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:08:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED539D;
        Tue, 30 May 2023 05:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685448529; x=1716984529;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SIuhwcUs3CmxnZwNtWIZRN899tqdqeyRfsA0B9HiZUE=;
  b=kUxWq5vf4GETb9cWnrnlfK/G49tlkQ+kukZRt0W/TC5/hgulUdLgMg52
   zgV5wrnnifz2/BIL7g6v8Nha0I50Fx7L2/JKBygNamM1RgYGn+DDvfHvl
   3uS4E9yg5AEwmZ/iGiKjHr9xF+p7VKffrwfz5dDmwNPWsLL5G0AOzBfCJ
   ThdBp+AIKsV/5VV/2oTUVJbmaZ52UFfLZMGWYdOGCAQeMCICRpXkbyfGD
   2ElGKIUYWZB34X5vemTZE5xBGWrQ+KBs87DQdHjGQrGaCZNghnlGFA61y
   o3HLq/klCqZsObsBq+rZBuYYevxgI2fN46WxKW6fJJCmgDTCBlXXTbYs+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="353736273"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="353736273"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 05:08:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880734763"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="880734763"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 30 May 2023 05:08:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 05:08:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 05:08:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 05:08:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 05:08:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZUc4rz2VgScVhTDUc0p+IlZy2/YLdCL3OTyzoBqlDoTERZTLWCRRfI6ihUDzKzpjnQWHGmI3KlkVBRtOEnHPnDabFEywu38ciXKRKfiLQYIWruM1G/B2j+5bqXMcy5k3x3FTl6azKHqoYe21SZyLY8F+5dqOL70Khnv3gDyc8WOTQaBjKkl6fnn+ooqQV4StJEbb4fvU+1YCH+wHGzxu/X4X4AKQWOVBSWwDXQxGCIoWnlynPiPdnyZElDn/LFGIaZEQAr0hkZOb6c+YsIInvplRlm2yAp9zbdPz/9gU4WmNNI7WV8b3P9z0u/AlJRYvzKqQBwhUmMahyOuSAcOxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxjbjZ6OLonJf1BVOc4BCXyxhZBRhXeoS/sQJ+bBlzI=;
 b=GL6yQ6TaQul9ZfHEnehjRAgFNPrbwNZ1v56iSUt2aVeVLM5sFhWOiWJ6IXkhDRR7bWNDO6NUZMkU1aMEmWx0iy1VrghqvKKqNkjnR3jMR5SeJKZDEBgFed3ivd3GM5XSQDO4TemDDW2olWynZhlU/lHiukU0n8629CBPaSEanXHdrx5gY2HGyt518Xo+Yec1TEbjzxaRZzMIGSPeblrLgRAHH37V1Hw2jgL9fXXdfkRtcP+39WA2iH8l/0Uazgj5zfICDlfgawR3Nj98kj/v8w2S3kD3lCy/LnDNN/u+o+3SNYo4rL1lKGNOz4T+lR5Ddc3HbTZg4cyYo5biBaDFSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CY8PR11MB6962.namprd11.prod.outlook.com (2603:10b6:930:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:08:44 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6433.020; Tue, 30 May 2023
 12:08:44 +0000
Date:   Tue, 30 May 2023 20:08:31 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v3 07/21] KVM:x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Message-ID: <ZHXnP5bEvxPrDg3m@chao-email>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-8-weijiang.yang@intel.com>
 <ZG77wu4PyBn1z587@chao-email>
 <23169e5f-9793-9486-fd5f-287e3317b837@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <23169e5f-9793-9486-fd5f-287e3317b837@intel.com>
X-ClientProxiedBy: SG2PR06CA0203.apcprd06.prod.outlook.com (2603:1096:4:1::35)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CY8PR11MB6962:EE_
X-MS-Office365-Filtering-Correlation-Id: 818074d5-a39b-4344-8b6a-08db61069cd7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCEemSzyt+BKSge3MCcV4tnA6RusCVnw1BXwW1EKwZSvO8Es7Tcqmi++WSoLzyQumWMN7rfvs/XYfT/KSB88e7s2ImJ7OyHAS3AjbYCrEsE7ruQHOvdwRoG1QU10ZLFqdV2R/iImVNMvZnvNOr38qOD+WNvkVlqoU0P0oAQo00EVSAFazinAsA/DI3hBZHxcFRNfr5C9H3z9rKTyd+1LDMTEYORPs//gtUyOgny8lh+MOhWsmno9iqw9CFgl2mLLBlw/Pz2f30/OK9L7h+ppFXyAZ+dL2iZ0/LZLAIqRMl/E0me8iPlmQvonoocB96X85r5NWG61MQ3wylGBNJJy4wZQeGK4t8BZzE16ZRl3pXmVL1z+yEqv9gQB5DDrureTmlNGWXE6IfAVIa2/PQ20DX8CgpLsJEgoTlAukb6pnjh0+i9a2mWMipvV/w7tkOchIigTHBgq8Y2gLJySqkw2roJ5WAXPte/hBh5yNLe21h/3vmQQHCWhTWE1csVCN8rWkz5fAGzjXQPYGjW2MaOpPAI5aaqjqkudZYvlkyzfnXYRx8rbrysVBZNkZZ4CR5/e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(186003)(38100700002)(41300700001)(6506007)(6512007)(9686003)(26005)(6486002)(6666004)(478600001)(6862004)(4326008)(66556008)(82960400001)(66946007)(66476007)(6636002)(316002)(5660300002)(8676002)(8936002)(44832011)(2906002)(4744005)(33716001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hp3vWte5yvpXSRCBdB119r1hOGuiXz0+M3L8wX67UEQtJvTgIi+KjquwfYz+?=
 =?us-ascii?Q?DDtBckgVxiPldJSZyAeBBcywpDoBaon4zYMWBgBsJSwHP6nzE2VZGZtVpiby?=
 =?us-ascii?Q?/3SSMVt4b0V9BycLYkTItPKzsxZj5ivXBPWC5YpSPwdmNXyhC1w35eOheM5p?=
 =?us-ascii?Q?Qfkv1IJZ5RumBXhBaHwnEL2gqAy+DJyqDSBHvIU0r2hDUK/X8fidRZkfIeCx?=
 =?us-ascii?Q?ljNndLGDMcWIw0415WKopAq2XX5eCK0ToPYE4i+9uS6STvoKujyt0eKe61rD?=
 =?us-ascii?Q?KjPpZ/NRlwdTYP7QCmB9t5dwOlKBoQ4sceARfYR8cwFmrzo4VCN4Y9+vaxCP?=
 =?us-ascii?Q?8XFTrn8S0K5z8RNeKC8BOPlOinnXPi8ltsUkXV0s670T07yX3mzPBsmeyd8G?=
 =?us-ascii?Q?pnJ9O+wgo43pgwL2uUL08mhycyN7nQViIP9omGyQXczhI0eFg8R/BzYslrG1?=
 =?us-ascii?Q?qeWmaBhkTT7Cz6vkWsKVF/L0YuhBCyvoU489GAHncpn+GWl2jFhLdmiUNvIT?=
 =?us-ascii?Q?Jcpcd9YowInypQOpYcFlUfAN+O5F+5Y94ox7dNXBaZQ3RHTQuqhH7RU55lW4?=
 =?us-ascii?Q?BtpdbE/WV62TkZNBgM/emC3/ry4fkJb3dmiBXL8r8e+tEzyDJJLr1z5cZ8s0?=
 =?us-ascii?Q?K9auHY2JiSxDMXWkGg38RSjy24VnVM7g1t1GFC3zNhNv1lJtdCAToK7oGkGP?=
 =?us-ascii?Q?A7SFbwz+20w/TU7RPUkXM7w0LO+Ri4GK+DL49LvsQw/N9u6a+TLLT3dxPdzL?=
 =?us-ascii?Q?NxpoRpEZfWX7DMRRG0/lsFWAAlbLGP4i0Cw43YMWCk0giNsG541QmkAI+Y2R?=
 =?us-ascii?Q?v2cB7Kr6dnCnFSC7iPhEQegWct35oCYlq+3QfsOuZmNG/Ayt+vxq1LEqFSuE?=
 =?us-ascii?Q?nvM0juaJbVtkngZG4EuyyC5t4zIPnkVrGdjl66RJqrQxbgTnanm8B1ssxgba?=
 =?us-ascii?Q?TiVI8RN56Lv0q5lpxCfxRoE3Qcr94RHVwGpTjstG9FtwEeAsNjqiGDhIp9vZ?=
 =?us-ascii?Q?pHrqynCGil4+bUdBfATzRJTYk5visn7Z1iTsnkWQO33Op5fKNGxLE2zDFqZh?=
 =?us-ascii?Q?mWAnJdH0aYDTUEv/lWyzqO9MG+BntSWIFAbUf+sPFMvsacDKTDfKijKeUjM/?=
 =?us-ascii?Q?RnE/cnYjnMTVZ3o62WdHk4tXH6LPUaa4/QsyprIUfslaGT+ccyA3I5IQinqE?=
 =?us-ascii?Q?aVyUSyAz5XrG6KGkam1g9XJxZSU8QoFssQB9f/iASpsN4Z1sAtjDKjFR4n/G?=
 =?us-ascii?Q?lraI90VlLc4tI6422iDW2rwJfwkdsj0VGgjO+YOcjJOCVw1DlONdLhfcUdru?=
 =?us-ascii?Q?j1d6//cbMISvCbiZQydGl9zg/K/rSlIbc8EF4hAJKoSbIc18pYor234fKUnH?=
 =?us-ascii?Q?hhUpBrvs+zywr8kHVmgD6yJDQwMsy4Gz/QknVTPZ855KWcNs3rQh43PKWrF2?=
 =?us-ascii?Q?zpTIJOnE9gG4sH5Z52DLttKGybPw53GvnaP9iARZdaZIJNrQCwiN8fjOKfoz?=
 =?us-ascii?Q?wXR8ui2BqQtY3oCfEx2IsADRKHlBZbufqDtOe4RoLdLy0fC42aJ4qvn/8NjP?=
 =?us-ascii?Q?D1WbR+HMhk5K9pgOJUlDmRRubKNkbo7vwYdG3XiF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 818074d5-a39b-4344-8b6a-08db61069cd7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:08:43.4431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtdqMT9Ggsw3roQEh3jcMxWnLeC1TiZMhv0RSi42U97kf604PTbkpvD7G5NcTvHkhpJK6kt66xGe161UdL9eKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6962
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -3776,8 +3776,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> > 		 */
>> > 		if (data & ~kvm_caps.supported_xss)
>> Shouldn't we check against the supported value of _this_ guest? similar to
>> guest_supported_xcr0.
>
>I don't think it requires an extra variable to serve per guest purpose.
>
>For guest XSS settings, now we don't add extra constraints like XCR0, thus

QEMU can impose constraints by configuring guest CPUID.0xd.1 to indicate
certain supervisor state components cannot be managed by XSAVES, even
though KVM supports them. IOW, guests may differ in the supported values
for the IA32_XSS MSR.
