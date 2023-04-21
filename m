Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AA6EA302
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 07:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjDUFHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 01:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbjDUFHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 01:07:00 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4652944B7
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 22:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682053618; x=1713589618;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4AKgBprNZy2tg4tt4dKUvj00bfCOkpsfe4Du760mRl4=;
  b=cff9xxRxWvn/d9yxlO5xaLbzz2KZ8GiJizjxINqSHVV8KgMsTA3c/Rh0
   Wr8Yh06vgjlwptEGONKFY9EgYDr0c17hHi82GWbQk9r+L+/sijKyjbphs
   Na9kBMZM1IaoooDSgvyG9HEOmigF6kCnlKB6CIfngku3M+9bu07+yBgnB
   jC4rF+jS9J0BFohQTj8oSyBJ9h0OyfAf2AZ12QN+EV4gJiSAaEfRLl12T
   xePe30fLBInYr+zcTF8yWAIawr9UzwO/buXXjKQyN+hc5Z1fdLQ+JqqD0
   VvwORoLrpxmEdutBVHuypUl+e5z8ZKqsbswhEM0xwiJlFJH3PORrXnY3q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="344671337"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344671337"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 22:06:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="685622773"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="685622773"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 20 Apr 2023 22:06:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:06:17 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 22:06:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 22:06:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 22:06:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qu1iJaW4cE80s9i7DP3e0H4EtVVwwL93cM/7ln5Z6BcRSsiq3w0O1FTg2gn8UtgX/mzRF2uB3qINq3pFKEKzvphpKsPfNEsvjgq6GfPUNFBxngdYnSQPWSZWMUS7Z3fnHFtPosZVdvdIny6Uypzq2MVX8fk1ct78WJsk7h64PTpyfOeiu/kljs8YD/oZvvpi23TD0mpqm/IRTQKZjNM7xQ8bmybcWptQhoVLzDLE2Wb6pSYWx1LLwZ5w6z5897/PHH29hSQgvtH0TlItMUhZXTcqAQoeE1TPxi0MaeeZeJM9eHJjJDYrBp1woTPqWwwpwG0E10ERvpQC8ABlpnk+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hb/MrffeLF1Q1gCplmF4z3Igy9C3WmdXxCgVCnSS+vs=;
 b=eBzS06MZXs1JLUBCFUqTPO4i0oVZRXiEqgHGkb2ZG9OrfeYlDyjnPt2iqQpNAHA6X4H/71c7tHp4Kb8PbF/qxCPzgOrqS6RPIJHVXDwzCGGgW49JsBage+oRy1NfUlrVhnJxNKWgDEgEjz2NlQArm+bnA4fyFkzUE+G86/GC0RM5l3Ufn1Ede6m3t1ufKZQR/srshbEl4C0PD6QhgoutZwoEWyJrBBbB4bMEK0e1zUHPVeuNttLUeaJEE1IM+acbGNbsPbgYPa2QJL9mWPFhA/3ddvbB2ukOBFMhlO0Eruhd8JIAgmNVpjVQsUZE8xURTWFDjqzjpi4A0xRDUwIoKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA1PR11MB6896.namprd11.prod.outlook.com (2603:10b6:806:2bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Fri, 21 Apr
 2023 05:06:13 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%9]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 05:06:13 +0000
Date:   Fri, 21 Apr 2023 13:06:03 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [kvm-unit-tests v3 3/4] x86: Add test cases for LAM_{U48,U57}
Message-ID: <ZEIZu7Qp5jaYsgLn@chao-email>
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
 <20230412075134.21240-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230412075134.21240-4-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0034.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::21)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA1PR11MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e8840a-3a8b-4ff0-313b-08db422620f6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mA/hU+zD8E16byQn1LQMpz7EF1ySbtRpV0SbfDkKNZESR/pi1hiAkhHvsV5rnX+QbzgvSCLnSPQtASq08md/kOf+VN8H5sRCFjxoWzvymZBG4ZuBiZ+O/M5Ndzw/h4RzekHE8iICH5a6cVgoTBlNhIfVFSU6GK21tBCSemYyil92vi8gAflhK6DdkVHjBqXeEjfmOfMYRgw+e4PDKXAD6lUC9+rukhU0MS+fGaLsutIVzieMRgqQ1cK77dZsn1GSDjnF2LNj+6feQq/bZ/woMN9Rvb2Ih1O8iI6YW6T8HbcKFPCBSuFdE2WPxEy2Cghj1OroW+DwvJUN2ZpSZTQ2aNrxovKBTJHopysWb+lKC/qseRFUMeJLfkQGFPW115d5r69TaYjtr8qrT+6x7WorlVW+EJHNh2PxD1f6UL4SlR2iEF2/xL0yDB+4DkRfNc6qIGV3Q7+uxcNIJGEaturU/yZeqbfNh3HutXQyTc6ojKGcoE6wVZ0y/S9mHPtYT+taqHGSNUTP2ZAYFfBDm1cwx4syEmh704eZuRpdET0pSVpwuShGI5a8jxuiOxxWo3Jy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199021)(26005)(86362001)(6916009)(316002)(4326008)(6512007)(478600001)(6506007)(8676002)(66946007)(186003)(9686003)(66556008)(6486002)(66476007)(33716001)(6666004)(8936002)(38100700002)(5660300002)(83380400001)(44832011)(2906002)(41300700001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NFAq+29rInCmUDww8nW8HTfB1nGzV+FDfyChbqtf/OGc3HEW3fHPDf7G9KBB?=
 =?us-ascii?Q?6LQo/XDs5UD8raH1EsZ1qNrZCiFOU9Eg3QPyGrwbvep9gosIB6vmenQ5nQWh?=
 =?us-ascii?Q?fFI9snSZlD3AZbfuO1qzaSYX+1XlDq6RPEl3b9QFmLJJdjR5LNKV9SH76zWs?=
 =?us-ascii?Q?TdrGHYysPMh+g+ihgFIVeeTTjeh5bn8n9rCWvW1r6s7Fw3T4XNB41a2upfmH?=
 =?us-ascii?Q?xQOXJ3/fQwcdDaLONGKEEOmGOGd/TCxTBHnX0aUE8MOB3IH5VSL8pFm1pIdd?=
 =?us-ascii?Q?zqDXoEukOBH2HdGh/WX1sEHSqpF7vCQ0RCBV6kPeRs6CRTJoMBkQcK3dC4Kc?=
 =?us-ascii?Q?N4cCjIavT32JpViFGItzEqMutxx4ziT1PG50Dq2g2dMvjuuufjJoXhDu4+4U?=
 =?us-ascii?Q?GxR7gfgLnmZ7QNE/Xfyl5v0nlFtc2CvyUCmC0aaL9r0jAH8/CPsa6ivCAUKb?=
 =?us-ascii?Q?4qqWgxEKOhXVuChj0dW2JlBVTCF4IHWKbXo8NGJYTVUVrzH616Qxnz8XfRGN?=
 =?us-ascii?Q?e43QaARXNujWSUHcsar/vrKqG1TsLncIxYuGIVT+xrSN3WHehyN2EwClxk+v?=
 =?us-ascii?Q?9Q9PFi/LwazkKdcEwlmdrabsLAN9BTVMTd91HmpO4P+LHTl+n/t8MRZHr73/?=
 =?us-ascii?Q?SQk3jhTohw931c8TsrMVlL345mWeArMwqcX3g52ENO0G+Ab41I02HK/xQPKg?=
 =?us-ascii?Q?vlAsKR5VBDTnb8vNkoR6uc/Xg6GGSldt7QisPpbWumztmKlus1w7iet/i04m?=
 =?us-ascii?Q?H9ToJVR8A5VutRVdbj5aLyW1fFWB3dDfcHJRd4//o+KwXySE7k3H9Lg5I91J?=
 =?us-ascii?Q?6gRY67xcpAGGQkObpwSk4OgCAmPin3GWDsj4vwt/OpRu6i63PqMs2zK1lLGG?=
 =?us-ascii?Q?QkK3I6ZjzQP7jSPsQiZNAXlNwwG3id4E1rgjQjQRSCsSnw+3Rf821D7VNx7u?=
 =?us-ascii?Q?IRjF58BNBo0qzQx3+f289KyMKgn93y9cHHUFPxwMFTaVaZ0Q6bH+hH152GA0?=
 =?us-ascii?Q?a16u8+ehMbN0HdQIXgZ8scUmAdB3zEpkcZZEx9/otW5YwpGRyZ9RVLJOerLT?=
 =?us-ascii?Q?cecqNjR0iRQic6tRE6ScQa0K05fUNx6yKkl3riC45qT9Kkke1kR1oJiuvUcE?=
 =?us-ascii?Q?XL0X+1XGqGswLNQfEFYuUDtmj8pbawPiHubudWCCMDOE8yylLPZHYEDwZGDm?=
 =?us-ascii?Q?3EbsZZIXNncLaR8WRZ4H5CabkZG6LMgra1Utpw/u8qXesTAGBfgZmdwrONrw?=
 =?us-ascii?Q?ZkpJxAPJniVfbnk3l/GyPuUNFrpjjdvlpkCjvx0eG2UtHYlHTkMYKSBzcr+s?=
 =?us-ascii?Q?eI5R56XeLRsdeoakRfwek3ysKg3KvfDO4rzJq2kuCeMJgFBx7Hgvgg99czmy?=
 =?us-ascii?Q?gr16EO5yxLGU+TjiObCAZE2P0SPBvSadWiJsEq9w0TfgeK7b+eHgBsJ+GLek?=
 =?us-ascii?Q?Th1mkFRvjmkS0edQf2FkODHJU8JDyC4Sesr1wbuASPNWlq3DfAVrWdPNjwNs?=
 =?us-ascii?Q?ezOC7XsJag7G1uwWJcnu6LRdMUeIhKQXLEhqSkNNk1Ppjrs8+wQbMMo6wS3+?=
 =?us-ascii?Q?KrbQm3NdpWE/Pj3/Mf3BuK5ZSdVVCOOqPpDis029?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e8840a-3a8b-4ff0-313b-08db422620f6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 05:06:13.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SVW4Ve6/LQNX2eAZ7n14pOYr0118BrFxiL7vRTsBcYIVjaZS5t9VfKIgzHdIUhxmtMFhyUIDPJ/dsTquLv6QnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6896
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

On Wed, Apr 12, 2023 at 03:51:33PM +0800, Binbin Wu wrote:
>This unit test covers:
>1. CR3 LAM bits toggles.
>2. Memory/MMIO access with user mode address containing LAM metadata.
>
>Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

two nits below:

>---
>+static void test_lam_user(bool has_lam)
>+{
>+	phys_addr_t paddr;
>+	unsigned long cr3 = read_cr3();
>+
>+	/*
>+	 * The physical address width is within 36 bits, so that using identical
>+	 * mapping, the linear address will be considered as user mode address
>+	 * from the view of LAM.
>+	 */

Why 36 bits (i.e., 64G)?

would you mind adding a comment in patch 2 to explain why the virtual
addresses are kernel mode addresses?

>+	paddr = virt_to_phys(alloc_page());
>+	install_page((void *)cr3, paddr, (void *)paddr);
>+	install_page((void *)cr3, IORAM_BASE_PHYS, (void *)IORAM_BASE_PHYS);

are the two lines necessary?

>+
>+	test_lam_user_mode(has_lam, LAM48_MASK, paddr, IORAM_BASE_PHYS);
>+	test_lam_user_mode(has_lam, LAM57_MASK, paddr, IORAM_BASE_PHYS);
>+}
>+
> int main(int ac, char **av)
> {
> 	bool has_lam;
>@@ -239,6 +309,7 @@ int main(int ac, char **av)
> 			    "use kvm.force_emulation_prefix=1 to enable\n");
> 
> 	test_lam_sup(has_lam, fep_available);
>+	test_lam_user(has_lam);
> 
> 	return report_summary();
> }
>-- 
>2.25.1
>
