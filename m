Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71919691723
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 04:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjBJD3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 22:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjBJD3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 22:29:36 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495F1EB42
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 19:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675999775; x=1707535775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hxf863rt8jX87IXRedl+42fKsvuJmSSjbHvzS8eDQpI=;
  b=ZUqTSdkJLdSI4kXJLD9YdrTqZ+xEcaCvGfnWDf3pZ/nbPk5VY7Np9xsj
   AD6wE2lSdvw3FOarMGpval9u3/pbWdj/MBn7e5rcjfJete7GAYl3kxGZR
   QUM2sDjso8SwTwtn0sCTzSGZ23yGH4eG2okAP5c/7Q6fwO/UolNB4qYoR
   uKGbXjlMA0Zb4R4Ynvwjd0Fkvx4kGm2FPy12R3EFnYFfZoaY8s9kskdrA
   ISiFG5KmxiuVL5LQ0S9sufkYAWUTPz0UAEeEujQ2HhRDGN+0DnmTskH+v
   ixjp1fH91upLIggOHQEhrhytsHLkR4b2XtkiP+ioQNw2mSL1HtxC6LX9f
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="331628142"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="331628142"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 19:29:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="810655382"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="810655382"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 09 Feb 2023 19:29:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 19:29:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 19:29:32 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 19:29:32 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 19:29:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoFcQv7P3LBF0GwVN8o9dzvc/dlC6yUZC0XKYq/RkOEJeN0e/zMYWjHoy9i5qxH9A2sQ1AFEW+6cXu1b70cA4nqUANKKKsxmGprEpAIljpk3hnMCvYgbuDNsKjxkT08ZUP8Tun2wqxGOmJPJNdq8MSddy4GDB1kMQBNKKYEtXNSov91rntdnBxc6s/NQ+kS8Qfz454cUqpPKwGnhcBPvFBeq6+iRNY6rOpUGI8R5toa23dyQbuLJ5iq2kOst9iEgaoESc+ErfHZWqOq0gUA6RjgQKy49OJYVgYvz7Nha/ZAMpSg8W7ZtXaelBwnHIJWD+yNr6i6XbWlJ7XXoeL8aIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcKJuPtxceFg9M9nbQcMSq/bBLS+O6jr7KRHnB14pJg=;
 b=azs8B7/qjA4nL2svGSyO2yOqZm3BgivmhgrGSb9I2xTatEylabrOLJPf65KdmkApnRz8VOKJZTiMZIivj/Ue6lJQUC7DyehjQDF1DA91uVQJE1bTYDtoZlm3uyo+67ccPlmDsTmrQws5mDq+UbLDvmK2TJrlUBn78cQYMW66Dn8KUZRJNbma1ChlJuujQvQYzK63CZuFlZuWYu6TZXknDXyqlJecryUojqEFI6wy48Ks1x9np6Mm7VRNKmJf5e85tUlX5+lnA+NmP3rtFhhrBdCuVkSiZfoF1hehcleo8MhQkv9qiAh/t79dfUwAk71ieAWvtyso9KjidYnszWl8sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7678.namprd11.prod.outlook.com (2603:10b6:208:3f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 03:29:29 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6086.021; Fri, 10 Feb 2023
 03:29:29 +0000
Message-ID: <63c23749-f0c1-28b8-975e-a5b01d070b54@intel.com>
Date:   Fri, 10 Feb 2023 11:29:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature
 is enabled in guest
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <kirill.shutemov@linux.intel.com>, <kvm@vger.kernel.org>,
        <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <chao.gao@intel.com>,
        <isaku.yamahata@intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-2-robert.hu@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230209024022.3371768-2-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:4:188::16) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c9a711a-b84d-47d1-469d-08db0b1704b7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aaowp/AG9FHCEYL6jROEXE+k7rHQ9KNVyawXrsAOwtGRkn+EW6oDzFc8jqTmoWRjzmE5zCLDLBONd25RlTCNFZZz7+NIpk+1zNfDhsWMh3rBU31aJ2tWHBtzs/aPXlxc++Logg/lMAxDig4KjzjvYYYjhox5mLn8e7w/83FtsRUmNMGHOa6JhYjyjjoXCLDtr2opLhxCmeLTSV0gC8QV0zxrJbTfJaQpR/KJlNLH0vQho45JC4Z5vyjU/izac8WVYO2GC9JT0+F+VpklZ892AoBtZJbQ468r5YVN6C7Vu0AiBSFhGz9mdHUFwbnOsgz/47EYfkcwWe4ebos1DnxizoffDh788W1EVcLu0kZm/LL6kS2p1ulKOiw+DDQ4zFlcEXBaglcn7Z/g8jCSdddyb13TKrnLPw6KNxm9F1LDFFJBiomZB2XOhmGtfh9BDSjVE/huBhzXWn7/nYhu/mUXBtId+xx4J38RqM4wrze4LHQdGUpUGpmP71EkL4KMszNmpfjC0pc6YcF1nlP0u/GcojyXUg1dKVtvW2sMfvvt0+BH3J97FcIfH9KMtwAlKPhoS9oAEyLbyNVsknGg732LA2DIRXhYICLTdvPiz+9XaFtdeu6UdxsDHfXdY1CzOUB+dgP0nJktGy4h47oVDHX4+WOi8p2uO3n+cPKEi9zb1TcQ/Z9y33sBbHJKYHdH0y+vaS6T85B73UK2z2vZjhA2UHFUiRsGU8Db9F2uUKSW+bAe8wnZ0lON/ZUbqGzNr8OR8yRtoSN0clt/Es8JFPLK2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199018)(8936002)(4744005)(2906002)(2616005)(186003)(478600001)(316002)(66556008)(66476007)(8676002)(4326008)(6916009)(6486002)(66946007)(26005)(6512007)(6506007)(53546011)(6666004)(41300700001)(31696002)(5660300002)(82960400001)(38100700002)(36756003)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1JwK0hGM0t2TDJwbjZtQnNLc2tzQkllZ3ZIZmw0eGkxU2R3VjNDblFMN3pI?=
 =?utf-8?B?bEJ4NzlVTHg3SDVURDhKaVFSL1NzWmdEdXdqMnYwUXdaNXk3YWplWEtSa1lD?=
 =?utf-8?B?Ly9pZ012UkFNYW4yQkxpTFFremtwUVorQ21kYXl0ZENJZWFBM1hOdkhweVdZ?=
 =?utf-8?B?K29McVRrd1RsRmRiYkJMNERYSis4K2pXbHZQYUpGM0FLbkl4NndCb3RtSTlQ?=
 =?utf-8?B?T2J0dy9CN3diaE9XdG9Ba2JSeDBzUzJNb3VEZEd0WGVzOUpiSGQySFpJQ25Z?=
 =?utf-8?B?WHh2bXhVRWFFZ0lRMXhNMGRMWUpQR1hueWF0aWdsUWpiQ2FWUFlsbm5xVlBO?=
 =?utf-8?B?NVFrZ1dUcEYxRDRXSkcycmNSeHZFQ2dTL0N1S0JRclBNVmRCbzM0T3FHZUMx?=
 =?utf-8?B?NDRaSDh0RVhGQndMQ0svSEtyS0tUdG4wOTVQL2VzNytWaFpxOFRsMHFHc09B?=
 =?utf-8?B?M3pyTVcrVXNIZjRLOG9YTTVvaTdkbWs4YTdMTnc4MHFzbGZnMUgySDAwK1VE?=
 =?utf-8?B?YXJZUzBYQm1YcGMrV3k4UDJ6VXAzYkdoQ3dIVTNwRzBKQ1p4WHBGWERHRDEy?=
 =?utf-8?B?dnd2bi9qb0pYUkxzYjdDYlVXNXo1TXFoRVJtYnl2VFU5eTBua0trMGNnWENY?=
 =?utf-8?B?eHp0bk1nNytnUjNDOUFPWWl2ZDFnR1h6L0QxNTRYUUZESVp1Y3lVQWtTTkQ4?=
 =?utf-8?B?TVZPdXJKYUV5V3YyQjRpcGZUekxvRUVZNjdqa1N6SFY0MVYweHVHRGJIdGFC?=
 =?utf-8?B?QXNXclI0aE5MR2pnMzhFWStkbUxUUUtOR0hVSVRWUmhRWlorRFZ2OXJ5RC9P?=
 =?utf-8?B?TitreTVSc3NVRWlzcDRmdFFDZ0tXYXZ3bjEvd1hqVnJQRWx0a2JvS1JIcGNt?=
 =?utf-8?B?TTVNTWxmekRaTEtWRWVQZTltZ2w1M1N3cVI0amdlVXhEaWRNWGp3NEZDY0VO?=
 =?utf-8?B?bmE4b0wvSDJjUUdTcjcrK3pEcTd2TWU5NjF0S2F6T2ROa2JPRlQwbjZoSlFM?=
 =?utf-8?B?WXFIR2ZOQUFJQ2tWZ0dTNDE0ZHNGd3ZuSFVOakVWQWVBaCtoUkxkR2RWbTBC?=
 =?utf-8?B?S25hclVlVy9oRmNyand3TjIveUo0UGlTdFlFeGZGUUgrZTZqb1ZuMkVvRTM0?=
 =?utf-8?B?TCtJdU9Za0xCNmw3bnoxVlFCaXFuN1AwR1J4cllSUi9XZnFIakNkbkxoZ3Jy?=
 =?utf-8?B?NHV1T0VGTzRvN2wyck9HY2Y2MnJYa0c3dWkyaEs1NGJZdENYbGFxWTdHaFpB?=
 =?utf-8?B?Z1ZBeThMdWxxNU9IKzFQaHFUK2EwMTlHSnB5U29hdUlxaTZDeTMzRkorOHp3?=
 =?utf-8?B?NWpVbXBLcTloZi94cUJEZEtLOU9sWHpoNFhtZ0YrL0p5QmdzeTVlcDVJZFRI?=
 =?utf-8?B?ZG4zbEI2blFkSW0wemdMSi9vZkM3WEhRb3JwcWVPVk5kYzU5K3BEaVp4Uytj?=
 =?utf-8?B?THNReHhHNHp6aU1sYTJZUEN3b05aRlp4S2swTFBwLzdSQ3N5SkJsd1M3S1BN?=
 =?utf-8?B?NGE0OG0zM2xUZTV6WWh3R3F0cERqeVV5ZzNDYnpwbHU4UGplN1ZBd2VIWTBs?=
 =?utf-8?B?ZEpOQVRQU0QvTHp2azFXcVRIWEcrcGlrbFdpZXBrNGJzUDRsMkxBVDhzS2ph?=
 =?utf-8?B?ZUNCczFSNXB5L0FKZTkxMDN1SmMzZmFJdUxudE1zbHNrVGNBSDJRUDRTVlV5?=
 =?utf-8?B?dEFjOUlaZGdoM0tiekl2MlF1VVpBYUhvalU3dkRuNE1OSnloQ0llV095SWJa?=
 =?utf-8?B?OXVtR2d5ejd6S08rRzdJa2trcWhvZDlKREx0dXhHQklsU0krc3JTdlZlTHlw?=
 =?utf-8?B?a0xBN0lKWmQ5aVNHVVFLaWVCNGN4aG5zNDMzU0wvNXhjZ0hVNnBxeG1MN1gv?=
 =?utf-8?B?dWN2djJrY1BQb1hGK0lDeEI0TFBDTk9IK2JMc09kdklMb2puR2UrcmlKQUJ5?=
 =?utf-8?B?OE4wVHhZdytqSmcvSUlsdTFxdlZTYnZBUjdEMm5VYVhuaWxUUjJsTlQ0SVBB?=
 =?utf-8?B?eERtZXlZY0k5L3dLYUxqWFNwM3pLTlpGbVRTTmZ4RGhhQVM4OGVmWmNWUDFh?=
 =?utf-8?B?SlE5MUl1dFVVQkZDTzhIc1JpYXFlMVpGK25rb0YyTmJxR0U5Q1d2R0Y4NHBw?=
 =?utf-8?B?WkNDUlBhNWJKSE54aFBZcEU1WXJMYnJjblc1bE4xZmwxaGhWVC9uWk9jSlVm?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9a711a-b84d-47d1-469d-08db0b1704b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 03:29:29.7455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dAC+yxpLbnfUwGWneQ1IDHhCiR81FdT8nRjJO3myP/jrg/76qr+ZZnha2bYDk7pcI4hPoXphPXfnzgrtFYe3uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/9/2023 10:40 AM, Robert Hoo wrote:
> Remove CR4.LAM_SUP (bit 28) from default CR4_RESERVED_BITS, while reserve
> it in __cr4_reserved_bits() by feature testing.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>

As Sean pointed out in[*], this Reviewed-by is for other purpose, please 
remove all of

them in this series.

[*] Re: [PATCH 7/7] x86/kvm: Expose LASS feature to VM guest - Sean 
Christopherson (kernel.org) 
<https://lore.kernel.org/all/Y+Uq0JOEmmdI0YwA@google.com/><https://lore.kernel.org/all/Y+Uq0JOEmmdI0YwA@google.com/>

[...]

