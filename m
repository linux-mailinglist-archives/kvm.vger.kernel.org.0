Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7042B73F8C1
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbjF0J3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbjF0J3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:29:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A691737
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 02:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687858189; x=1719394189;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VVjIuBjURl6xwY/HPyS0vLCNY6xA0IVDrtmFe8nFlS4=;
  b=NYyVJ4fdfmMalInRBv+HttDhJF0L7LMRelP/CPb9+xW6rKhFRtqm4lE9
   R5nYXm0bNcKPaCtUlkFP7yHLxGIpnxO22vOrHwz0GGbwQHnURgWj/ofBn
   vLLRSBcNWwVVFJ9x4jb+9TXaid/VHBpmHjGHDwnQUjOO/JLmfx/3mkHEh
   HuQ/BRVg40N5qqoBW566PegmpHwi2iFQ4EIidV6i5BHwi6SHscDyZ+xaf
   PQJoQ270g0bgRhhRpqwykurRNcTsl1YoJN3d0qxYXIBxibtHdVgy3tQB4
   qkJQMc+pOVzg4ML5ERdQbvzamv4mT8gAlZJfBw19/lPlCB1TFdD6XrzFv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="447907883"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="447907883"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:29:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="806398197"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="806398197"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Jun 2023 02:29:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 02:29:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 02:29:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 02:29:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 02:29:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dx6SHg9GSJfEdXx8ciuMQUL/+zbsAW5V9ueY3GHSIHFPxYFpJ0UbSv1iX11QAcVp5VZKBwKCWlJyEqR9O3LAps0LevybiBWfP7dkHK8T0lRX2PCsVGo3vQegIFkY58FhzH5pvztQyvs/30UwE6lNMimynbNCK0fOwNJp7xQrx6qhz4jTKeASBVUnyuvPTeWxLIpG0vLJ1+m3dbq6QBQN6EWETy8ThaCKbsC9wVaoDdbIzG5XeQ2rWVq3+zsSoPyV757H9s7FSRQyWEAIRXfaUOZD+Fd6RCh8e+hds9Qq1MU3n2XZ/oRSLcSVk9IP7S6FaUwxyaZuM9Js4DiT8aHaKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGjhcKVzUYX1fKInDdIlBPAsK11hCsShmKqb4mMiWmY=;
 b=II77A4zvNHqh26r6ks/WRJVsD8wITcVIm6xvbNCTD/JsQ8fsltSO6rZ8cyMMzKVhe8NNn4hLxQJAOk6xTgCXCPcjN/WyNLUcr6UznfcmiC3INM2ET/7xhTxsD8p9uZ6C8JJZgWPT+o+4ZX656pJXYKZJrDglNjZ8loz+m+rdXwRKF+IhCDAo1YW7OwnGR3CJ5bEI3cLnUq83J6Qt5zGMPCejG7S0+i4983OYM3OruVEYqFnBgrGMf/u7NW9UFnlkrXDN6kdXdNGAWOSFN4jIhbmbedZOl6kruql4wm9klbbME+8Inu1YEvoE6Kkq4IEym4iYoPMt/AIeOsTuZYmYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7043.namprd11.prod.outlook.com (2603:10b6:806:29a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Tue, 27 Jun
 2023 09:29:31 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 09:29:31 +0000
Message-ID: <0d230f89-363f-3088-331e-d72638029e2a@intel.com>
Date:   Tue, 27 Jun 2023 17:29:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 2/3] i386/cpuid: Remove subleaf constraint on CPUID
 leaf 1F
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20230613131929.720453-1-xiaoyao.li@intel.com>
 <20230613131929.720453-3-xiaoyao.li@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230613131929.720453-3-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0216.apcprd06.prod.outlook.com
 (2603:1096:4:68::24) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7043:EE_
X-MS-Office365-Filtering-Correlation-Id: 126905aa-68a9-45d4-f6d8-08db76f102d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EYyvDMuAvdem9WfYNZk/n9Q7VEh2tjAUJGlxMGm2CaDAi7755k8sq6RDdBtswqoVDqqup4MYewQfvVoDY2rKpo5v6xlmE3DiA70uAie97tZ4gMb7FPHHCQYlE/HvNpfGuri/eRJvCNE4bU8NJFqsCtkOgXwiNOmOuwipPaFNxyr5mQ2lEAlJVvAy7Iw840NOvR8k+M3KDuJShQdkl0udcgEm82m24nt90gieE48V/Q1W4YqlwXRJWOMqDjlPm6aNDX7CO+ZUAI4Vyr70NhbciRkPBox1/CRiBLBXl6gHoWYVL+MIvjD2blycWVYIcA+x//Dxt7aOJo21g/C9K3Udj+PtN2CSmTh2Ot1CLJRg3KuyzloMJwjHdk2HJG0mVT6QgXtDBaLRDcobFrIOBKYzlpuyWRwfFQyPnG7SG42nowLvUNbsbGheHpXkbqy84gnUeG8CcNv+6tKwHbJ1HI7Ktehl+Efthd7BNEfRkCoSqXf6cWDZQhaHktAXBXM3BNjiP5h7L0vTWXgYPCHU/urLTdVQt06D19DSCZI4+qccVdqBxz8VMoXc1hoDLO6+ib2jjdPR6ls9AScx3BnZlAaMjVsgYadhuUfvlYGDrGw2lJ8/1G/reDPFjXEWD6wTZtYsrvwdt/T56tZ2OB+7yFKKxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199021)(54906003)(2906002)(4744005)(6666004)(6486002)(38100700002)(2616005)(83380400001)(82960400001)(26005)(6506007)(186003)(53546011)(31696002)(86362001)(41300700001)(37006003)(478600001)(6862004)(66556008)(6636002)(66946007)(66476007)(316002)(4326008)(36756003)(6512007)(5660300002)(31686004)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXlwK09Id3RCVDRFbXVOdGt1ODZQdVZzMzZoZDljcm1YRlBOUmRJblpyamU4?=
 =?utf-8?B?QmVXbDZvYVVPcHhjT0MyUlkxWUgveEUyY0ZsQ3RwbGYveW84cWJMOGRXYnpB?=
 =?utf-8?B?MjhKNWduYkVQT2ZQdXdIZUl4MElvTzNxYzdtY29kVmt2WS9obmV1eVN0T0Jr?=
 =?utf-8?B?THo2cjJ2dFNZeTIwOUFOUGFCbEZ5MXdMNWx5M0FzZUYvbk9SR3VEQVdLTHhT?=
 =?utf-8?B?UGROMjliVDZub1RPbE9FQ0FwRHoxRWFkZTVYSmFkT0xwN1RBckROem5iaGVi?=
 =?utf-8?B?MFdyb3g2d1o3YlZDb3hJcDFyblI0Tzh6YUNMZjJqZTFNNVUvR09hTE9Zanla?=
 =?utf-8?B?ZU5tQUJSenlkSURMY2locWc2UjFRTU93eTZDL244aGQ3VHZlUnZIUEhqeEZM?=
 =?utf-8?B?MXRiOHNZS2tqVHFSdHQ3ODB2MHl5WVlteFBRTmlPbEwwQkYxYXdHWDA1ekN2?=
 =?utf-8?B?UFA3QzYwNlJTSzB2Q0tJTHdKVVZmNlp2NGdKVjREY0dOdlg2MEVVaWJ2bHVG?=
 =?utf-8?B?SmJ3WWNRb3ZETER6WG5xY3JmSDhjV2UxeVIzei9vUlJHei9XNmZzbTFscHRj?=
 =?utf-8?B?N2NwbWFQUHl0VG5kc010QU85eWpBVmxGRSs1R0xsY05JbzdJMytuN2Qxc1hx?=
 =?utf-8?B?SmhpQ2VPODU3TXVxUzRNbkZlNWNzS0JlQ2N0Sm9qU2FKU3ltVHB4YWkzUTdu?=
 =?utf-8?B?WWdYYkVKZmZmcVc0Qkdicm5qT1R4cjFISnRrQzR2ZjRGOWhUYk95MUYxS1FF?=
 =?utf-8?B?U082bExpRlBsUENhTTJQazZKWVFqamQyQWxYLzh0dTlRSHg3cTBKZGtXQytF?=
 =?utf-8?B?ajBCVjF1ZzBXUVFFblNFRkkvbEVjN0czdTlsNGxkdllvM1dKTGdIV3RVMlVr?=
 =?utf-8?B?dy9CQVViYzgvZ1VjbmdIaktEVkdXMTFKR3pjY2FwVkFnOGxkY0xyY0Y5Y0J1?=
 =?utf-8?B?cHFqVFM4b0dWUHFwMGt6MjcwZ1hzUXF3d1VzUHhrTzFSeTk0Y3dpcEZNeHda?=
 =?utf-8?B?ZnlCUTFjcE9zeXBpbjgyaXJiVHlGTjlVNHZNc2x5T2FpNGllb3Y2eHVYeFN2?=
 =?utf-8?B?MXdCQmJ1YzJ6TjdJc2p2SFNpcDJvU0JPMUhVeHBGbGdTQ29KZnhXb2tvR3lx?=
 =?utf-8?B?Q25Zb2FvUzBRVnMxRHRBQ1RpYmxhMlgvVHVCQ0xvbEpVc2EreEZpRWpxUm10?=
 =?utf-8?B?eG9qeHVxTXVabklPdnhaVVRRM1NDcGd4R2F6WWR2cU96ZGFBSUdpS3UyMWpy?=
 =?utf-8?B?YkdpbEtyWERVa3hZMld3L0Z3S29MZUE2SXoxWjhDalpOaVZlaVlBN2Z4dFRT?=
 =?utf-8?B?TG91S0Exc0VIWGh6K1J1YXE0cGVvOTQzZ1Y4VG04empXVVBHZ3JOM2l2WWwr?=
 =?utf-8?B?NmRuQzZSUElST1dnVFhQak1kNXJMRDRGOWoybGVaQTQ3NkVRTkhMMTUrS2pY?=
 =?utf-8?B?d1VtY2dwVDNGYU14N05hNDRpckZ6RndhL05JUy9Gd2QzdHlGT1YzVEd2cGw0?=
 =?utf-8?B?LytuK2xER2RXY2UvYXMzTGxIODhDN1pQcHVZYVBhQ2c4UjBZVWpxc1ZzQStE?=
 =?utf-8?B?WXNqNFRkZFFMUHZIZ0xPV0xjYTRUUWpmQklhaE4yUDRSYU1LNURWUUpVRGYz?=
 =?utf-8?B?UHdmanF4QWo0Ujd5bjI0RkNCT0k3S2pieTJlWU5Lb0ZHMmRvOSt3ZnR5djVo?=
 =?utf-8?B?cUVJckd4NVdzRlRmT1ZiTFlKVWRoTFVKYUtPdSt4NndEbk9GSllZbDNLTGVj?=
 =?utf-8?B?blJVUThnYUcwcU1xOUJrRHlpNGF6NUlDYlJ5ZUlEUnB6KzZ1cHZwWlc0dXdv?=
 =?utf-8?B?N3NaU2kwUUlHWkRoNStnNW9DOVZFVGRONWQ3YUdHUTFlNFc2UEFrVmlxQ1hJ?=
 =?utf-8?B?Q0hzeVhFd2FXY1Y1S0YvcHhwSFJsaFlocTQ3QktqT3lYUjR0c2V1NEVEV1dD?=
 =?utf-8?B?ZUR4SDdtenJLV2ZjNmpUcDZoUEF1SUE5NWFESWtYcVovU0RNN2tYZXFFRGdR?=
 =?utf-8?B?bGt1TUtuS2ZpVjJKL2tBeVhLMTk4V1VkOVRJU1AyWWhieG91RnY1cXpYWjhL?=
 =?utf-8?B?NjJYdlR6cU9FbU1LMmlvMU1jenk5QzRDWlpjb3VOeDlSVTlpSjdoN2pTMmRC?=
 =?utf-8?B?cUNNSUVwdWkrQ1RjWHBTNS9UVUp4M2g4V1JhMFBtTFRsYWdFTUVCQndWWG9V?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 126905aa-68a9-45d4-f6d8-08db76f102d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 09:29:31.3409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIfCqArG4EIBUSX9Lso8zZALVnHyoyxNirqxjpOXAHsPstem+BagUulW1cRMRPUVp7oHSrD9NpxHkD0RWBgPsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7043
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/2023 9:19 PM, Xiaoyao Li wrote:

> No such constraint that subleaf index needs to be less than 64.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   target/i386/kvm/kvm.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index afa97799d89a..d7e235ce35a6 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1968,10 +1968,6 @@ int kvm_arch_init_vcpu(CPUState *cs)
>                       break;
>                   }
>   
> -                if (i == 0x1f && j == 64) {
> -                    break;
> -                }
> -
>                   c->function = i;
>                   c->flags = KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>                   c->index = j;
Reviewed-by:Yang Weijiang <weijiang.yang@intel.com>
