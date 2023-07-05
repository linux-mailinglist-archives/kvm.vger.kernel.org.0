Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC13F747FE4
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 10:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjGEIkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjGEIks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 04:40:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E836F171B
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 01:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688546444; x=1720082444;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MbgxuJo5yWRdn2ivhBghl8xsmud8ROL25wDUUi+FYBM=;
  b=ZgURAud4KM1moZoIWdFrUIIAtEJiiX5qPKBeHERiZcsdIvYJxvRDmNrz
   tA+MhNcby7teu6vjWmJZj5+Lere14zJNaer58ItPDXWp0+By94fmmlFC+
   GURLrr9fEpADrN4+4KKWFRtFP86LSnYL58EPFY0iBw8tMtV1d6VrJ2cY0
   CN2d6MdcZOFXCxvOr/ZaTjUcCcHem9HEA/D0X+4HtGxWLdQIJw963C7+H
   noFIywJ/yUyIyuU2/dPkG9aVtfzelqGgzw2OBDD48yLj4G2EO4GQSnHrF
   PKVP2Ia0RNc+H6UQ1znstty5i7Jmgzf3rg8/7Y4tN2pbxMnRCxd6VyRgW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="366768999"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="366768999"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 01:40:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10761"; a="965749074"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="965749074"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jul 2023 01:40:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 01:40:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 01:40:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 01:40:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 01:40:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0mxRLzdFjXgu8DXrWlaoGFN3auqqFeMnA/n3lcMMRX6QC45d6029N+6PaBrpKn3NkuUbjmK9bLxMO7WlHSafLaSCIYFr3h5OC509jrtWhqTFIEF98Fg2vRxac4FSFXl9WgmQr+VFkqW5UZrdyFtTao7B1w4+jLDeTgGpO+PmY0jq62LMJuOzNrZoTWzLfWvy7vb2xEQdH1xOx/ryXsxL8o5Ilnhp5dJchi872PLpdhe55K8bUN1RX48GNDeoWPXG1BSCBRd2rRvUy9CdA5pC9+oaM/33EwhvqgwsfaECW8gRP/GAJE9d7ImLREfcyeC2oPDRdV4la2GIvKeiYQzHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QW6mOSnuSacLEqKrTOP9eFdnqUP0LJ3H+DGF7Y8UVJg=;
 b=Jr1kw/W8a50B1PbrqbsXAHg+UGrMo7ASocAJEpyL/H6pkap1ym7cxJ4E99vigoD/5OP31bpnLLdYJZ5xbGJ1DXnQGwkZ4VAroLVvh5wrRDjSPZKmJk0LmZvKW/tywU+/9WlmkKSLp2WCqCc3+gc7w0TyEQSltzUst+CPKpFwJ24I95M1defG6/Ah/ukCfpH0NYtdWarpAbnTmvHwRGJ0QrNAuoSJNhP+eGVEeXf+A58Rv+b0gWea/TbZcSnTZPe8QW58vHlBoqIpKM7qp6ykjPxwJuc12v7K2WYvC2qS7zcqqGaO+aiDXBYKBgXf+vftCYJ0Ggi/jiqL3bNmP7JSvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH7PR11MB7718.namprd11.prod.outlook.com (2603:10b6:510:2b6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 08:40:23 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 08:40:22 +0000
Date:   Wed, 5 Jul 2023 16:40:08 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Qi Ai <aiqi.i7@bytedance.com>
CC:     <seanjc@google.com>, <bp@alien8.de>, <cenjiahui@bytedance.com>,
        <dave.hansen@linux.intel.com>, <dengqiao.joey@bytedance.com>,
        <fangying.tommy@bytedance.com>, <fengzhimin@bytedance.com>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>, <mingo@redhat.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>
Subject: Re: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu
Message-ID: <ZKUsaFzoCzjiGNZ1@chao-email>
References: <ZJ9djqQZWSEjJlfb@google.com>
 <20230704113405.3335046-1-aiqi.i7@bytedance.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230704113405.3335046-1-aiqi.i7@bytedance.com>
X-ClientProxiedBy: SG2PR06CA0225.apcprd06.prod.outlook.com
 (2603:1096:4:68::33) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH7PR11MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: b5b64401-7bcf-4802-246c-08db7d337833
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZFxF3FHOettyBByAefF+6NxgafgI6EgqlOvSbzeRBNyLYoWmAFhzAn727om5skGfN+/KHqIeiS28ZKotO7jjXjydVZpbK/MsstMdNl1ymNAoHrUMcrZy1dXCf7rsx/29zE9wRvF87hjw4CkrUlNSAd9dWszH6VOEK+2pnUq4l9XIRdJFtWMS1cGPyXYn0fanHizW0twQEFhRRO1enz6Ca09xg1kjeMsTUyvvNFwEjEBIA2sirrjMiTGBYQ8+tBZUnCtT0g7+6kKa1c5auPN0rStHEUjmuCzSKPp2SH+Qb4lXeKa5aPd2qT2TpRFHJulzC+3O/m6ve0fEOWlA4pNjo/aqwptpaBd7mRir2wSNret4GS0KOJl1W6TEmivGVn6GccITbbKkAdS4NPb0z0gNrKQDPsdYKYr78TenOu5xizEcqCS/3KCqrtROp3B/ARmxynbDjEEpiQ39RibR/3d8/M5FjDRlUT8j/0MaTaO1CoiUf0EFnui/jYs+9Qv1wwryXIRFt9BU4osuZAJu8WtA6GF6AxvAMDg2pjCUZhcT306XxCbDGUXsx3GtDVbJ2+2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(41300700001)(478600001)(6512007)(9686003)(33716001)(86362001)(38100700002)(6666004)(82960400001)(6486002)(4326008)(316002)(83380400001)(6916009)(66946007)(66476007)(66556008)(2906002)(8936002)(8676002)(5660300002)(186003)(7416002)(44832011)(6506007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?npgASC3o7tTaJDhpDZsP67QNWPuwnqWTFc2JC0jIg5IlwR5Ghzw8l1nckAm1?=
 =?us-ascii?Q?T5Ybwco3f3FJfD5K9BC3kQuL5gkA931QCp8df6PhK2pAaJeNrS0MdaT71+CG?=
 =?us-ascii?Q?TjNIL7uk1dIG6/kbaRf04elcaVZFBXsZzSoBpAQUpUAosu/3v3mWloh98Zkr?=
 =?us-ascii?Q?ieXphm5Q8DFvmGA9VXjj637Ugh+Eb+7HLnBUbudayJeWPQhMp7R0bhwH/h48?=
 =?us-ascii?Q?rm+2KYqdX6zeNkO0EOsNSJM4Hz2dddqxlwtYh+asJxg2IOvWKLYp+4sT5S7M?=
 =?us-ascii?Q?7KzrNY36+6re+kgGiou/+Yt1lZWGfwDiYGeszZxSDgTB9gZZlyo4VPziM+En?=
 =?us-ascii?Q?pgDEonX/PgMM/3tu3mDmQIMz4Ei//RFqq0Hz19+aTtx8DplTPxarERA/uCpx?=
 =?us-ascii?Q?Ycgrpa8hS6I3ifBJZa8X/v3Qw6KIR3Jr1IZ/ltgty7d7ejw7q0k09ygvOR35?=
 =?us-ascii?Q?DEoWsZAmI10cTBwmTJdmHrdb1prXlXOkyI+jkEW8N3DzsnMPEvlj42mNCMDW?=
 =?us-ascii?Q?mqZvWBPU7KBrHIEG9OIJ6IyoEMgLxgP6vpMITiO2viafNQNY45LqyMWzdPKt?=
 =?us-ascii?Q?odd7OE7A680kEkr1gs1O+vZxDIeljmoIA9nOkclzmBb2Vd5YtIg4o4rzPl4j?=
 =?us-ascii?Q?dRV6bP5WRprjDc/k7ttkmmjsl4coPlMQTx2QARtfiwwibmuHWivGxDPKXmDp?=
 =?us-ascii?Q?A3fUwABFtQxbfJRGZaEn91EAv2X+Ul3wWXN61zy675h2/aLfLhQf4mLuD4Yq?=
 =?us-ascii?Q?00A3ShaV9S7M7JEKJr4tLevpk0KuPzc/aczRlExoNvEiHZzMWnGhPIxJ+7V3?=
 =?us-ascii?Q?ZjCzyNGGgVXVV8HLdIgZwXV7i36Al9Gwub4REikGHwOjaexOPT/XEIE5KJvb?=
 =?us-ascii?Q?FKT/wlGj1PCXJLbJq5u9T6YkAVWEzLSBqYJP/n3D4mlWK60p/Ncsy524iexO?=
 =?us-ascii?Q?NNYVOMKRNVRd2RQoC1DsVQI8EFth2kIXMKI+eA/g1GskcX1H3kENPNpkZxE9?=
 =?us-ascii?Q?kkzBpffrYICEmuobddQNmKSoE3Aod1XLcMzfJpVZiWSUxPXj+8lWDHRR+E00?=
 =?us-ascii?Q?Hwc9/WmaJTwDKuyumrB7olrXZqH2ZFkPjaAamApg1UTlyZtlXz2rrTiJErRr?=
 =?us-ascii?Q?7nuHJC5+3A8eCWh4c+HuCcYNyPs5f/d5oSXU2loPQEmP05VypmTD2J2fBQzQ?=
 =?us-ascii?Q?KugDRhea/0IqQYVy2pdUVh6S2dh7EBZsyCssHmx65unh9YSqZI+gGmyRraCg?=
 =?us-ascii?Q?jtZtHRX4tNLaxVbfM86pfkaEn0ABuDTZmNeDgWKyEQxvQM4yDwMRwU9BwHqn?=
 =?us-ascii?Q?zNn9MzlmFy5sVKXxM2yt9Janeuz0kcLe2DnwjHbPPfuk+RvMxw5u7F1yZo+x?=
 =?us-ascii?Q?Ew9HMCI6nDhtJAikUTHWRvVFwJQrdEZTWRE4TkTTSt/BqlGuGs6jkKL3i0/u?=
 =?us-ascii?Q?V99+givG5qmM1+Pph+OjdCLsqCEBpMLQJkTheTC597ZzRlZMcsHfmTLgmuDt?=
 =?us-ascii?Q?Jxhj8/86FHsyqWA0EjDvPiLWpgNsP+1HMztoPCkX/BEsz8jzTLi2kubL7kAE?=
 =?us-ascii?Q?DZLd3IaKUTxhdFivHx5i0HmPDuPqA0OJOZdUAJqJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b64401-7bcf-4802-246c-08db7d337833
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2023 08:40:22.0243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GN1t/AqJwlDJ+0Nb1fNDVXxY23a+YuPNwJHgJkr/tiV1UtQhcJ4cU79lVKTKV4RJYcMDHEUrCZDoyH98LvZQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7718
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

On Tue, Jul 04, 2023 at 07:34:05PM +0800, Qi Ai wrote:
>Reproduce this problem need to use the cpu_pm=on in QEMU, so execute halt in vm doesn't
>cause a vm exit, so mp_state will never be HLT. I am confused why mp_state is considered in this case.

This is just current implementation. It is not necessary to be this way. If
userspace can manipulate vmcs.ACTIVITY_STATE indirectly via mp_state, your
issue will be fixed. But as Sean said, this solution will cause "cascading
effect to a whole pile of things"

>
>And the bsp's vmcs.ACTIVITY_STATE need to reset to ACTIVITY to solve this problem.
>We need a proper set of APIs as you say. In this case, do we only provide a reset ioctl,
>or do we need to report vmcs.ACTIVITY_STATE to the userspace?

The latter I believe. Then userspace can migrate the state. If we go with the
former, the subtle bug pointed out by Sean won't be fixed:

	if a vCPU is live migrated, I'm pretty sure vmcs.ACTIVITY_STATE
	is lost, which is wrong.

Definitely, we need Sean's confirmation here.
