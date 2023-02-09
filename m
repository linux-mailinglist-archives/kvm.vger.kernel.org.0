Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38FB69037A
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 10:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjBIJXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 04:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjBIJWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 04:22:55 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6923C611FB
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 01:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675934533; x=1707470533;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kt0juqwdwQSuoi6HpK6OmaLVIPiZRkaQIvFAXBDzIig=;
  b=LKyv+9Rj8x8l/rlAM8I3L9Ag2Xcg/UNyLZSoHEgPNu6OAP05Qyl6Ah5i
   CtF6NBybV7Bg/n3YmYSgF4IIx+HIa+KXctBXfD55X7DW6rp4VFEDlpIwO
   4qfau+idRZJjzlpxmkBF4IAoP4wf0yihbAWmbdH6uzaITF+UMvrWYT5JJ
   aAujB8ZqgDs+1DYPDnrVp5QFN8AwVleYWsq6oa8SXJpIu91cOqH3ffKqB
   EQ1qOGZMIM5NVJfyZZbzbjkD7sf5zF2gm/2XJKb1Y6qrZOZyjb2WZbE33
   tUMO1eBufeLq+5XYaYeDlVrRR6vwevo0+qCiFLkjduoFkrEUxVNINHiH5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309708460"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="309708460"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 01:21:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="699980859"
X-IronPort-AV: E=Sophos;i="5.97,283,1669104000"; 
   d="scan'208";a="699980859"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 09 Feb 2023 01:21:08 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:21:08 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 01:21:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 01:21:08 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 01:21:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNJ2SZ+U+xoq4NsDH2xwy/UQ8itk/uV35SKwVrc+U+ZRJ5KCxlo+HRRrAoM/vNQQPnn2zbXJ5rSCw0Bq3+VThXhcuLdzI+Ky6NZdLHoEfl7jqcLHk98BsB7kIfszcHzGGgj7cryplxT38SnIGZRMzdZF8HucUE+Cq9JUmBBr3W5OS869YOUWFKt8MTpWqJejagPCjSBfxOTuH7Qw9ybat+l6cK4YY8mB6LylRoC7SG0ZO9aNLoSJH5P6G/Ry0xG/mMSqZ/Wfx89c0CzxOo9N7BEovAlVOEu4jr2TWn5hmXKi2m8IyleaCoC+9ygeSQHDOZOOKW1CXB52M2tOGv37OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFrb/arQppWnpkgkWhgJ0pqGCVmCVO+3QM97CIdXzcA=;
 b=iJlUmNPbzh22oZviTNgkhb43ndIr/EzXwKRf27VjTDNXwKkU+Te9TZh2m1M7EekiV7c+BhZxGVubMXdRUhHqsupIA25PwLHpyNtJAppUVQKKrg133mY+5WKtoj8loHYZbcRaKl/wYseTHMc0/Ia09VeNWnRINPRzpOZ14nALnCR2aBARcwSymbCCcu8zNYObP1YpQQ8fLRFFrB46QCBbyvKwWaZe9ppk7Q4+vn6R8YTZZWJOHXT92itv1oxHYA09uy4V5jlSLyHYvQ3X8M0ggc/iLfl3oTl7Ud7FAxfibjmofYu8Ehufw0J05ZC9QKX71dOLEljUUzag5iYbZtJmhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by PH0PR11MB4983.namprd11.prod.outlook.com (2603:10b6:510:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 09:21:05 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%7]) with mapi id 15.20.6064.036; Thu, 9 Feb 2023
 09:21:05 +0000
Date:   Thu, 9 Feb 2023 17:21:22 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
Message-ID: <Y+S7ErkCpUADAn1x@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-2-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-2-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2PR04CA0177.apcprd04.prod.outlook.com
 (2603:1096:4:14::15) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|PH0PR11MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: a592090e-9305-4f3c-8bd9-08db0a7ef84f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b6mtdjB8VbFLQMG+fAINPI/4pm82ht3P0Kj3GLZQTGIYAjQ1r6jRFbOdImrMonPx4WHGWmcb0TfaHf/Ui8sL4BN4tKrleB48BSJ8bz04rpf4wKoF/ZfRt3oezVM5aqGfcrhTSmvOL7a+86zAeAYNBEVw1hu/MFpLrfCGeaKJKqxw5fMDL9WyG/xabetkJCZEcNFU9Cts6b5bgtmJ2uWki/WORJoNXow3ZbQre9UvO9obsa9Qiej9naIQP5JpymuYdRy/UOloxwhm4NGDForKo68+ysr2RwZh2tdip/Xc6rmzkyervY+7DA0DXBcTgGorln8gRS7F7jgynij6vyoGPfTJ+H4erd+m6Gpnh1so62TqEySc9nsu/kOlgHXdi7nTcCYYgr46mhabKT80nehMQXSZRs/YaSxmYzJnLUCwjyfX6/kmPb1E1l/BwUAZRFrcd6phxWkPOHJGqdDGLCPCn6ex9pamEEMGyaKuf3EyD+gBz0VAymv8aHDL7FJZYvmGQ/+2Xkk6lUjWsJ1VHaltoviaDaH+/ApAX40P3fDabrZR53v70WUDq3yISqeRo59AtkEb51ez3uPCz+o6hknBinaGzp2AV6nOLA2gSaEJKgFLlFWXXkiXoc/vTccf9/4qxKAdwexPO+xK1WdxISz9uZFoA33VyeK9tupaMTzdqeenuUvT2rYyM3Kl+BMFZX1Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199018)(6666004)(41300700001)(8676002)(6916009)(4326008)(66946007)(66556008)(66476007)(82960400001)(33716001)(38100700002)(86362001)(6506007)(4744005)(44832011)(2906002)(6512007)(9686003)(8936002)(5660300002)(26005)(186003)(6486002)(478600001)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jQhYtDZbRPdM+1BwcOieWasEKHPqD6NQzWNzBBDzGCEku7cRFwZtSjgi6w52?=
 =?us-ascii?Q?Ug3iW2Iorqfr2Px9FHVuNsVjAkelMILz9WR/V0pQnTDM2keQKjt0yMN6ZJiG?=
 =?us-ascii?Q?Xpi6ldCoc6oPsi+wSku8NDoKZ/iC0M3e2xZbLjbnt9fxHSFv+u7P86Gb24Cr?=
 =?us-ascii?Q?bwRXMo8Ra1FUQQN2R1WyRx0mvCl8+zg4e6ympauM2Ah4sIToqWtMLGy/s/gH?=
 =?us-ascii?Q?f/SzdG2B3sVZA9Jp5bLKeIoNBNhkOQu9YJIFE6fT4r4Y+E9klYW11A7zWyGS?=
 =?us-ascii?Q?DJ/kOqWMqlP76QWm1eu7UWKuTfWuJmvXwx6ismZVmIhTSITNIx8KPklgzpin?=
 =?us-ascii?Q?XA5ksYIDvAPdBtELOUflg89z9ctnudnoc0fqWUdjmlLQ2xa6FdkFsxH/bOT6?=
 =?us-ascii?Q?+sHctKgrM61BMTK8rsA6AZYKYTtH2LlFtJea8GISn3fofie9rISL7AegucxC?=
 =?us-ascii?Q?B3jso7z+VmYC4o6LqPQpbT7EaCZH7qQfL3f1MAb88O2virs+ZlhkGExuWXAQ?=
 =?us-ascii?Q?g/D9ESjHRGyr0JOqCTm4oK5zC1AxXoCscsQ7A1ZIfAKEqVZJsQIzEC2VvYcC?=
 =?us-ascii?Q?j+3TCJdZenXLnr3xKdyiXfyHv4Bux2b0s+YeDtRae1yPIumzek4go79j5OoQ?=
 =?us-ascii?Q?hCriUTJXMMGm6k7HcfWHsk6Y4N/b7Kh3FVuFwFetI0olUQlvimNJP79HfOEu?=
 =?us-ascii?Q?1OFJdGC3NTBFXcobq+WqWHVkoEl0qq47ZsjXbqW/V8d1CHJIbf/MDo78PbKB?=
 =?us-ascii?Q?HAwdgI2XJcY8zeCJvl29qToUOsVYjbvixCIbGNhK8SjWSlTZ0pzu9sba3IyG?=
 =?us-ascii?Q?o24Dd8KZp11x5RTRloCFH960RpNLW1L6vX4kI+5Gq/lXZZJuYODYsYr7IzM2?=
 =?us-ascii?Q?psb5IGhiHBtyxw5few184+iZki1bUD0kwj3vTPpqtaC47NZ6HaOKjebW7V4c?=
 =?us-ascii?Q?Y3UGfLirrmgsX/tyA9nFdKue7niBOzlufzAqqXH3Tf9GcffbTSGicNWO5wkw?=
 =?us-ascii?Q?98JNclEXLVjQeh2HZbhBaAH1UcR2Hi89u9TPgRHZ6lrEviU6v7al7LwnJ8gy?=
 =?us-ascii?Q?ci/XqS1CSzbncVhDjrDUt2s8+2zTKWTy5CmwNdeRXYEnZFmCnlV27BbQNSac?=
 =?us-ascii?Q?qXkkf6GrTyW8WPOEAKWTVQV/utqfO0Z8hx/H3Oy523DQbJBDXgTcp2t4Zn9m?=
 =?us-ascii?Q?blAMhlWFtyb3O1VE2OitHISI6DnKCavIALL4uhZEkEOEmfTOzflnHHzBT328?=
 =?us-ascii?Q?tzojuZRarD7cDzEK0M9Y4/KQaTNgVG/lUEWNP761BsiYnNH8WpDe9QIZ0T9A?=
 =?us-ascii?Q?JloX0/zr2lmE7N0asx5rzmIVHUTBSOEH1fAackuIMt6w33kG6u0Rs1iatWy2?=
 =?us-ascii?Q?yXvuhpLMgwzgKWoXY0NY4Az0V+wzRVO1puibgxNSJ/+LVTGdSr04R3d7PbVQ?=
 =?us-ascii?Q?mniU8ImEeDBftoWpYcRM12qQosizje/Ulr8ZuRLcJVtl+Pgrq5GrVwjtJR1I?=
 =?us-ascii?Q?Z8cnKtYxHWFlW3Nkp2wlWtXeLFTXLkzEImt7g81t8jwATsp+MYJw4LUdZko+?=
 =?us-ascii?Q?qwtJrlrRiADa9Lg5FQ1yp7DqKd97ThNx3iz2G8sx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a592090e-9305-4f3c-8bd9-08db0a7ef84f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 09:21:05.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rqo1aGFP1Y9HQzFWHR09yYGUD9XGxqnnUi/TH4DUg7vK54vbuzNaXtCPeFF7X8Vzbha9CcO/dyreLMltM47HxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4983
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The subject doesn't match what the patch does; intercepting 
CR4.LAM_SUP isn't done by this patch. How about:

	Virtualize CR4.LAM_SUP

and in the changelog, explain a bit why CR4.LAM_SUP isn't
pass-thru'd and why no change to kvm/vmx_set_cr4() is needed.

On Thu, Feb 09, 2023 at 10:40:14AM +0800, Robert Hoo wrote:
>Remove CR4.LAM_SUP (bit 28) from default CR4_RESERVED_BITS, while reserve

s/(bit 28)//

>it in __cr4_reserved_bits() by feature testing.
>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
