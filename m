Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E04F732465
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 03:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjFPBAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 21:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFPBAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 21:00:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37931296C;
        Thu, 15 Jun 2023 18:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686877244; x=1718413244;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cY7QdoDo/EgftrS+FHo8f7STXF+yncSx3wqt0FHlkUk=;
  b=KpPTX19OuNBYdVHxWIb9K6Og76g2ZB4pB60YO/mVWVHo4RMp4rv6+D/j
   xd+vyEXHUS7a5KdxGAbwuE09RnDxef1IwA+Qh69kHUkLijJ01kkmdETA+
   locQTJf6CYTPaXh7+ORudQ5OWXc5ELNAnqaXJ7iv314w/FVJp34WpIivN
   wrJhC0AetYd+O0K8XpU7NkZ51WmO3SfNJ7tLOgTwle+c43rrIn+jU60Ou
   kT0og4hc8ct6N5ILwtsx8gyrr6dB+7h1dauAOohhFtGQb3Vf5MhkTEVc7
   fqZNY8gR+uAC84oqGcCyFowb97POrWlDy5I5GOi7GyhTz0/7QbxWRvh7m
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="359083502"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="359083502"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 18:00:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715813738"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="715813738"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2023 18:00:43 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 18:00:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 18:00:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 18:00:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 18:00:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hn8idS2MuF/l9lQVVv8oYbhyRgWrOu+dNqzG9UXTPzedaO5oE/U1ZsLRYNi7w8rVPgKde+7WR+E5jh5DiwIGXXNsrrmxeKoT1s8Ythj+0jbPKZnR2Zx3MiM1ViDU/ZP0IzWUNvrDfrr5lmZALXVijmKkoyMv/4WreadogLiKj5jdm/TEBrzL0yofza1BzHlL6A0Dwr0Y4B+kcE4aXzX5oIYMX8fqGUYAfvUSqwI+YbgqjD8rQI0dESvnp2jMG+X0gPG9sg9CqzPoiBNi1/50RPzlxFFQvjDev4kYUkEA65AGvuAyg3fe+FJuoorqpE0T9nG32h55DNEFpE63c6ua2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jznKofOZ9Euh7i/sx94cSSeZ6eWeD9cCsEcNxI4A9/Q=;
 b=aLiFL243PeBor8Scw9/IMsZ8huixixhF/B9D3Gq1IwNPkqL0pfl+unm/ZzqKUE3IjEar7KQE5qi09Fm9gC+HrLHh903jF4OeF6I6z7cFE1BVWvdlNwkOoSdJ8o8kiMcdyOa1AoiQrG1otTEkklPvjAa+PCVkfBWMdghN3yI1j2u72T0jtPNp+suvWT6D7aDjpu03ry/G9SlvCECSl0Lo1Z8ymTEo+lk3AdXAc9W8pWAPQhQUZ7+U9W30L4mZHeEyWX0IJkAp/r/dBLrSbTwTkJXWkn3GfHv2bDBIS+cw4LdJIm9b5vjeLfXRS4GU5hScOrlU30+U2pdf9WcGJqL+iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA3PR11MB8022.namprd11.prod.outlook.com (2603:10b6:806:2fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Fri, 16 Jun
 2023 01:00:39 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 01:00:39 +0000
Message-ID: <3a241bc5-0fb9-7d80-1746-84c822a81a27@intel.com>
Date:   Fri, 16 Jun 2023 09:00:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 00/21] Enable CET Virtualization
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <ZIufL7p/ZvxjXwK5@google.com> <ZIumMeRxDzzcKpUh@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIumMeRxDzzcKpUh@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::22)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA3PR11MB8022:EE_
X-MS-Office365-Filtering-Correlation-Id: c9a7b338-c0c0-4437-b83c-08db6e051a0b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7BQVFTU71aOoHc8QqM8hRa2mBHw3WSihWKWd8pW04k9xoYG+Qr+3x9aVlcwaby5fgz5IWMBKDfIoscDkHfw8m0g8yjL/H0wvOYHZSWJ7CXIcdTZqmG2CGn/87YVaJrZ/IyQomJz7KuWtpMekBTnrwai8RBbF202bG6xfO9Zt7jD96kLf0TfvlKwuwmfeW0dKH4sOm2i+JeV6Tzx+eqi4rypUOiAAOBu/4KcFuBSdFjTYFueE+22KpCGcU/hKE1LRYvjoZBs1j148jYkq7/0DY0F8jyH1VUv3UhQmz1yW6col7irlSHlHKCx2sVqu6VD+WkQaI9Z3UR+ohWO67TmT3toHkUo+3o3nzPJG+Gji0AqbIH1zTxFnrsWGJOja56SLFAuY4ke2vAVgiSMHBXXieugbBYt2aVkvxEnghya+V8LyFLLbr9/rFFheLqKmu+N/51FGir7FICr2ODFj9e0SMkGt+rlBF0vOu8t5mYZwmuPS++ofu3x+f4ab00mKRZMRBD3ek0u9kYgtSHBCMnlQQeokjdqrFYPAwYfOh9sBEkpihpKciTCXJBQKbvCaGVOhGz/iBcy1szz9+7wAnbDUlZ4XoI9AH7cHm6FymNDOLfLNXqm5frb4VdUuWVw4GsfCDLOdIgO5FTqyuovfYdmG4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199021)(2616005)(82960400001)(478600001)(38100700002)(5660300002)(66476007)(41300700001)(8676002)(8936002)(4326008)(66556008)(316002)(66946007)(6916009)(186003)(6666004)(6486002)(26005)(6512007)(6506007)(53546011)(31696002)(86362001)(2906002)(4744005)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmdxMWJnZFIvd2RDNW5sSklLWnByUThuazcvWTRpcjhCOTJFa0lCbFVzME9i?=
 =?utf-8?B?R1lmRzE3YTkvUmZwUlpVNmpsVkxXVTdtUWxUTFVTck5zT3F2OVQ4MUVZRzlL?=
 =?utf-8?B?b2RnOHgxZXErYmRYS1NKSzFzcURqVUNxN2tjUGVJdlRUZVFLemNsdGlLd3VN?=
 =?utf-8?B?Wi9mWlQ0UmpodTRiUXowSkdHWWR2OFJYU2hwRlhUYURhRk5za0QvNmp5cXoz?=
 =?utf-8?B?dXYyZFhLckwxUFJlNmZ5ZWFmWW1RUjhpd25TUklGanBFM0FJcGwzZmkrYXhQ?=
 =?utf-8?B?eUpCdGVKa0dNakZmY24wSDB3cGJxbWh0VHdBUzkycktTalZMdGoremo5Y1B0?=
 =?utf-8?B?eTVlV3hFeUcwQkpaemNZd3hDbDNEUjZmdXBURHZYSXBTckdyTDdkdmtUbmVD?=
 =?utf-8?B?d2lRZ3dSbWdocC93ODBCVTFQUzRVUHZKVmhZcTV6eitnZm1DWUs5VEhGQ3Ft?=
 =?utf-8?B?T0ZXazdlOFRNMDBscnpLOVVBUWZMbFJzd0lKNWFSUHpNOGNjN0FoMVhGUGkr?=
 =?utf-8?B?bTF4bGJyRUk5SVhmTVZRR211K2NNUjZORWlwWXJpVE5URkF1dU5ad0FLUi92?=
 =?utf-8?B?d2hsaFpkRVMzUEg1UVYyYTJRL29iWGdhYUdnNDh0MnNhbGdQSEswbENKQU9a?=
 =?utf-8?B?bmZMbTlRd2dyZUFVZGRqTzdqWUptbS9NaGs3WUNBc3M3ajJkbWQzcXl0dXZO?=
 =?utf-8?B?T01yQmhrV01QM2Z3ZGtMZkptekl4ZXJYTzAzYWZtTmV0aGFiVEFmOXJLTExZ?=
 =?utf-8?B?SUN2MkxJOXlPSUNrWkpramx5dmhNczZJRmFyd2F1eUs1bFpNMlhKUU85eWVL?=
 =?utf-8?B?MzAyMzJ5YitBVHNvclNlSGw4QUdHU1lWOFRueE9LY0xYUHNaOTFtVERkOTdP?=
 =?utf-8?B?c081YXlpT2M5TzJTYTA2OHVrZWN3anI2WHY2WldDQ2RxS05uaGNzaGcrTXVF?=
 =?utf-8?B?ZXRPZjN1dURuSTBzTU1aRWRDanFuR3h3QVU4RGdRTnNPN3B0UXY1djIxaFYy?=
 =?utf-8?B?VFZQY2VvL2VSQXhqQmY1OU0xWHZCQ1NwM3VTbjFBaFBsOVBib1dLenpzUy84?=
 =?utf-8?B?TW5nSTZEUEtoekV6QS9JME91NzdZZG1pc2hEL2pwcGh5TzU3dlI5am5xN3Yr?=
 =?utf-8?B?ajMvWDlleWNoNXN5R0xZSnoxcFEzdUZNZmxuaWxiWmtsOXBCY0YvWUc0RURR?=
 =?utf-8?B?UUJ2TFlCZE9FWTJYd2ZCTS82Yk9kQzh2a1lVMmxUb1NRWEExWUpGNFBvdEFa?=
 =?utf-8?B?RFhqcVc1cWpOUUFaS296UzZoUE9XKzdGT2RvcXV5NWlWOWw5OGpqQVNMVW1m?=
 =?utf-8?B?VFF0b3BDZEhjdkw3NGJjeTVweC9SVlFlaWdpWURHYU9pOFZsRGxPTDRQakhT?=
 =?utf-8?B?cDBKNnk4Q0pRUVUvWFVqS1RBcHZyNXJSTk9iakh6amRUUFY5Q20za0RwTXpk?=
 =?utf-8?B?VHdBNE1saVh4R2tYSkM1VW5IUlhqQklYaFJiWDYxckliVFNMeUI0bXFCalAx?=
 =?utf-8?B?azRDUUV2WEJoU255Q1hmRVF4UmtnVVJqMWNCMGpJOWJKSy9HSVJSdlExN2hy?=
 =?utf-8?B?Tzh5ZU93OTVQd1dRL2lGMWwvS0NjalcwaXZMWlF6b1B0SEJyNWZzSXBDTjIy?=
 =?utf-8?B?b2pldDRpWENEZms4SVEwdzZzbGY5VFRQSlpnbzc4S3hIaE9iZnc0Y0ZHU1Ji?=
 =?utf-8?B?VWdvd0l6ak45bkhsaHpqbHAvKzJwZEtDdzhWOE9PcFBCSnM0Q1IwM2c0ZEhE?=
 =?utf-8?B?aVlCZk4yVmZMdHlzMGRRT3ZTcXVhbmJnM21PVllEVURDNDA0TkJoNGtrcWtR?=
 =?utf-8?B?Y0dQVXZ2M1pwZzJlZHkvdDMxVFEra1BZK3d3cExxQjRzTy8yWTkzNEhNeDJM?=
 =?utf-8?B?cVhPWkZEYXNGQVBIK1RVRHRZQmMyclpDN2pCbUNNaTF1MVJpeXRLK2p6bXBU?=
 =?utf-8?B?MDgzWEhVNUpLemxuZ3VzMVJ2U052VjlSK1BkMzUwcjhudUpOdG9xOGlYUnNF?=
 =?utf-8?B?bGZ5aUx3TmNOQU9LZk5WNGh2c011UDZEZUFKNnZhY0w0cDlpSzJQTDNvS2lE?=
 =?utf-8?B?YW9UTnZKRmxvMnRmVzQ1N1QxUDJjYkxlRTRUZjNIVXJGL1IzZjZWc2xQaFI5?=
 =?utf-8?B?dkN6SEs1cXpHYmpURXpjVnpNbC9SOW9SK29rdURRMTQ0bXJybU85T1I5NC96?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a7b338-c0c0-4437-b83c-08db6e051a0b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 01:00:39.7083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUiX+ZZXmYwS4PeET7p5p8QItZ3xJICIRIpy9hIhOeNOeoYQGyrkPyXVYr7twKzYpjnA9lZsdYlR8RT1A5pD7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8022
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


On 6/16/2023 8:00 AM, Sean Christopherson wrote:
> On Thu, Jun 15, 2023, Sean Christopherson wrote:
>> Your cover letter from v2 back in April said the same thing.  Why hasn't the patch
>> been posted?  And what exactly is the issue?  IIUC, setting CR4.CET with
>> MSR_IA32_S_CET=0 and MSR_IA32_U_CET=0 should be a nop, which suggests that there's
>> a KVM bug.  And if that's the case, the next obvious questions is, why are you
>> posting known buggy code?
> Ah, is the problem that the test doesn't set CR0.WP as required by CR4.CET=1?

Thanks for taking time to review this series!

Yes, due to CR0.WP bit is not set while CR4.CET is being set.

The check is imposed by patch-12.

I'll add the fixup patch together with next the version.

