Return-Path: <kvm+bounces-7002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFDAC83BF0E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 11:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CC68B29F98
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 10:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1B22C697;
	Thu, 25 Jan 2024 10:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjB07dXj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735CB2C684;
	Thu, 25 Jan 2024 10:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706179096; cv=fail; b=sXPnhjmmc4ZCZiUxIQ3pgL3Buh3qmx+Hb8TG7JzPUgA+98+SZbKdrJiaRSE72DUOfQoI1K+5ItrREOe6ZteBJqixm+f0k3fsLmSQGEgICouX1hc7bgm98W/WLRDangQ329i+2CjMJnI5n9/fTPbw0tcd7gH84FyW2QLQdCpmIK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706179096; c=relaxed/simple;
	bh=B5pKK0NpOMW1BDoxlI6xE0C5f3R7akCMBpuOwmhd5O0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lXHp/4XfpL/NObShSbxqeAd6NMVy3p5J8JErjWTBbZ4Shd3TvsZxL19DLSITXTYdClika4JWdLL9v1udKalpF/lx7xqM5YFGO5BORVmI5FI9oUdT7ucBIls2M/WX2Lz52xHOKXop+8bKr4OowH40Rb3db7lMYIqxlMvWEutGuy8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjB07dXj; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706179094; x=1737715094;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=B5pKK0NpOMW1BDoxlI6xE0C5f3R7akCMBpuOwmhd5O0=;
  b=fjB07dXjKp5qDhuVKo7UAIWmX0e2ANwZrd3qMOs0gyPmUvEjE+uGrPmw
   26aQ384nW0QSbIEnLQ+8N8yFQBQUHgkCsaBu2zWq+OYmdGzibjcp3H4RG
   9FL0UzxviWExZoC4byi/RTg9mO9zjUWtXNLLOBNAU4D4nua6hSa0yK19A
   StaRzx4b1XGaREXJf10j9bl+6lVjHVKLKOw446GDw1k+ukyaW7CZQtSB9
   h5z5oEZJTlP/Aq7HPDRzsw4uX49tEOv5nkHBvwqoWIFeK/SUHZEagopUX
   m4wjL26WkdzvEr6Csh90pqogKJuf3Idzu5WZWBC38lrkXLA8OzOjRQPbf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9237680"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9237680"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 02:38:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="820756158"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="820756158"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 02:38:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 02:38:12 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 02:38:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 02:38:12 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 02:38:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOmA0vspScGs2lWb4JsUzYxPNxb02b8c/LaMS9n+/G5alOs9WcuT5kuZYGGBkU+KAg1tCXy/j5BtG3/T9uakzVBsNBFtQUmfVlcyREBVrTNWjX8D0VKdR27daTZPIL06k+pgBRLt5NdBlVBW/IE7bPfCZvWMq+SzQun00qqycc0wBbISdrA+BmPzyVQjZAXv+Cpq6CALO69tC4JU2aWHH04CzG4xFIFqRhSK+78DddTwQX4AYtOZBbhKobFFZsnmBs/uY831oJoE0YIYa+J3aUosqYLhyVi42FKebcrOz9KJ3lPEF1T86c7QCC6JlLzFCv9SQsgsPrD4CV4OcisGMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B5pKK0NpOMW1BDoxlI6xE0C5f3R7akCMBpuOwmhd5O0=;
 b=mSOjeEu+fsHQC2g2FcNJZC8sbntsUFNyJL6AMx7NcUSQfmkfi/UzNY+v+Dp2cyfRAwEtLvHDBHUW5qNJQOJV9C5r4EISNuSCIj818j255OVi5m36E1BSiwybEQbcf2dZOplrtXlis+khHTWjTHvqylf1Cp9hAO+2bLuaTw48OT8tqMqxywRXrkzVQPSqGx9C/bu82Kd/WgIts5+lVlQlkvpU1R7FnbPl4Rbb7mNtdQ9gjX8K7vyNphfQ/hwHBl8aKG7hKB3Z9KghzU+HKZjJVM/kk8EO1VgCeKpp7u80hO8+/KMVza477lZdRdWvLdb+x5lwL1ma7SSwI1J10/umZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB5972.namprd11.prod.outlook.com (2603:10b6:8:5f::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.22; Thu, 25 Jan 2024 10:38:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7202.034; Thu, 25 Jan 2024
 10:38:05 +0000
Date: Thu, 25 Jan 2024 18:37:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 12/27] KVM: x86: Report XSS as to-be-saved if there
 are supported features
Message-ID: <ZbI6BCTG5wDYz2ut@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-13-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-13-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2P153CA0032.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::19)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 57db667e-45c5-4cf9-67c0-08dc1d91b6bb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D9dRtFWpn7tumTOEgDPgYf2V3BtmAuCGl79EpXd4lHob3S18G8IJ5cRE5MXbJkiGGwWpy6fNPBT1gOrvgfB/2+ttfFn+Q6UBGDz1gTTazuh9LfDY2JYpzqiJE7nszDYHo/h5bOV8oGDyTsdrvLOjGx+aNvAqJWIwwHgFCVpmr082SwhZ97jfq4UwfQaw7PdlF0LSnZJLsqyySkHlO4oyA7/534b9/tyReEbG/zWqKE5mOQ4CJb8RMCXzoWMmUOaMgDV3QqcsEHzTBWow8/H7nJEC8sD/risqCeSF/KImA6T6ri6QwJFQDaGUGNaZY7gz77H14uLE/7uWco7p/CuWHwhZJ4+G+PxEQvZ3gyG0fDgNfqEAM6ERWE6iTsDXu6+SemlvRacPcrdrr9QFNYBcgytfuzSDAW1r7QOduDDBYK4jAhvwmUUu5Og4MbWPseSp/E1B7J6hD1WPXdnBGazMa/Lp5mBBBh+kD6TUNtZPwSjFN9ovUCnjIBzzZ2s44OYgnNWMUgo4+4QeC/vtVdTwGaM8HvAwzCEYKH7c04/THl/pP+pdad4GIMEztTbj5yXk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(396003)(136003)(376002)(366004)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(4744005)(2906002)(5660300002)(44832011)(6636002)(66556008)(66946007)(6862004)(4326008)(66476007)(41300700001)(316002)(8936002)(8676002)(82960400001)(38100700002)(478600001)(26005)(86362001)(6666004)(33716001)(6512007)(9686003)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XvLNlaW973jKF8NRAh5VXhnrwZT3gGwWKl3kdoscYWt++L+Yz6tsWsR05idr?=
 =?us-ascii?Q?rx6X/PhPzv99/IBw+IQJ8ZBoc2z1pkvpxgioSIlgH1dN7iJTFM8G2qePStrX?=
 =?us-ascii?Q?FU9jKtDvfcNLG+b0khyZVAixwFRO4dqjHdDpU1V5KKHQz6qHJNCIJgHgIIVn?=
 =?us-ascii?Q?MsYSZjroOl0o4FXrH3Aic9kFnM+zrEemjUODod2GAcS8rK55rekHVTKU4LC4?=
 =?us-ascii?Q?Yl05H210kjfKArrkVLfZwxPo/ozywl5KSleMqcV7Ls6ymgjnINlBJEAJzee0?=
 =?us-ascii?Q?ZelyhPn2TUrhW9NzjJHUsCn62XS92ZgtY+muZHuYChC7J10UBaxXY7r3uOdS?=
 =?us-ascii?Q?cH72VnucZOyYyX16Yj8xWi41mvlklhc8pUZoT1WwKeT1EvTk5scrdWNRlSuW?=
 =?us-ascii?Q?L4MpN/XvHlBT1ClSzMGacxN4uYrUIgZ1lHptjPIIzyVterVOgxFCwDhPsKAw?=
 =?us-ascii?Q?aUi8GKF1U0OdjPCTvK8eNkU1d/OeVcUa8hmvV82SsEahzYtHJcQfGZI+VLsb?=
 =?us-ascii?Q?eNDhRSEECc74Mrnky+sQ1ardOki/Ciw5pmVT+jB6iE7qqXBDL4ngJ+ZIbNww?=
 =?us-ascii?Q?RC+4CyiVI1nVln2dn+9azhCPWZivMvxj9KTQZRQMBAcMaY+0YFYhAf/JofSo?=
 =?us-ascii?Q?Swjwhos28kEomY9J/AFqAO4mOIZ7EiHovaRdfPvMSTXKx+kZ4pjGedhC/w9h?=
 =?us-ascii?Q?EpWaCO1Bx32Qb3ifgx/TRhxHpCNorFRqoaofXEUtRgmqNf9gUmbaf1aiFSKx?=
 =?us-ascii?Q?hPYYRUj/30jd3NzsFBsujktBh/UEjwGW0cIhchk6Jzbg/riYsA5qs2pp8Zpr?=
 =?us-ascii?Q?tWgS/0AI7v8Z3P/6Dkl2wuumLW9xnoBfT2VwRf3AXGln7lARisozhg+aojSP?=
 =?us-ascii?Q?ODeucpFve47qSNGORI6F9dIAvLfIXFQl2IhzZ27gIH7YEe4gNq1yxHizOnI0?=
 =?us-ascii?Q?n2xNDbp/5OkGQiI3Qtm1nBZfrjAF7YjBFp0byZwtV0upDK9Cp+5T225CAF2f?=
 =?us-ascii?Q?SwpJZ2R31pU8HVYbu90PCdD8H5wt6raXDuFUey45XhDxS2oySByoETRqea1H?=
 =?us-ascii?Q?cqNN8C437RYYuvrtuG9XEiuWj4LNvqueecjb5lbdW2H1sl7ulR4C6BYVkyZl?=
 =?us-ascii?Q?vomDIglxxRXZE549O4MUkNotuSm9//0PaZbW4vqQx5YeJicgoNJnmHoRuXvk?=
 =?us-ascii?Q?uYcZtQ14Di2/q9aPbY4zXpmV1cCivsWd5fuZ6tQwZCeKndQMFOGHTxg4ypGK?=
 =?us-ascii?Q?R+LRM2bUyt+Kj6FWOJiM/GCvORk6Nz4KI4yxJDrjv/w02tRqA4i+SKsH6gw6?=
 =?us-ascii?Q?I+z/u808XCRvekBI+84tqM+vTXmkeE7n6sdjoldrekDjYZ2a9OvzGGJwwXBq?=
 =?us-ascii?Q?X/DR+7pGv5NnzIByvxlR1kjI423B+kyVir4+agig5cbBKRLNLNjBuiifjwZP?=
 =?us-ascii?Q?20FmCDSS1SSdXAvssYv+hV8ONVuOBYYsQ3/VhZFnHIpEb4ojNGrQ8XKtcZug?=
 =?us-ascii?Q?khZUt5/SwgMGqcq6nK5sXH12wB4G6gUO2iwjtoBpAsnsotBPnfUj/HNJkjTr?=
 =?us-ascii?Q?SNFRp7wL+9arZ/zBs7B15V45fJ4QWEIwQ953IAzN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57db667e-45c5-4cf9-67c0-08dc1d91b6bb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 10:38:05.4143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tz0BkDfPQNjLo285YUJTCli6NwKnnF3UXTdyEK7xA91SLxQDzz6MbQOj4mksQMIxOuH1ZeUgCcNNUM8yKsExYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5972
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:45PM -0800, Yang Weijiang wrote:
>From: Sean Christopherson <seanjc@google.com>
>
>Add MSR_IA32_XSS to list of MSRs reported to userspace if supported_xss
>is non-zero, i.e. KVM supports at least one XSS based feature.
>
>Before enabling CET virtualization series, guest IA32_MSR_XSS is
>guaranteed to be 0, i.e., XSAVES/XRSTORS is executed in non-root mode
>with XSS == 0, which equals to the effect of XSAVE/XRSTOR.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

