Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250D354CAF7
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349044AbiFOOOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 10:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354963AbiFOOOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 10:14:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A049192A5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 07:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655302458; x=1686838458;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ly2Narf+T8QOP8idHPDJntx075Yhg+1Y3oye4dp/1HI=;
  b=Qje7WWUCBCfitNXsdiJB8p8T1EPNQM/tyvIxfgfdahmD/S9b5m0OeDTC
   1j/aw3BRXBpYd4mGZ6Z207zt4IIIaOiDDTj411OmMoUBSTiGqDdcDbEOD
   nrPzmfFPilN3fhGTE/gCWsm+O7qqaYKt9CG9RI0Yy6gEsGp0Pd5Y4dFDQ
   lFdnnwqx4kAXX0LKPLS3j8HpXzI+GWwKGvM0E5OdgUJskXtAsIFwy8uNp
   VeIpTmSHRZo9w/vaIPD6l1ziKWk8kNqR5ymBohsYf7pmGSt01Sv184+Aj
   qz3yg0Zzw2MuwwWhejVcEy1CZ/rQtJ7P2Q+F98Uz1BxET8AqSZz/iS/Gd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="258827093"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="258827093"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 07:14:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="589131861"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2022 07:14:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 15 Jun 2022 07:14:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 15 Jun 2022 07:14:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 15 Jun 2022 07:14:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 15 Jun 2022 07:14:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8/SebZbicMzjpUnogFLi8kOiRcB6Wh3qMdesEqPll+5/WoQzFPGMO0Dff2J3jfnH0imn3dLse0iCxU+oAOD7JS0+2k9phR3SEgpi/dXLU/pfnJYo/Tfr0oJqjviaPPzLBDIW37wdfNDg2zvjgTpDH57NsX3X22Jht7fyZ3dfafBZcRC8v7lMy5orkXsDi6HZUFuJ1ZE0S2e6FC9chrKywJrEWQUzeR4KxJrHzXUuVY9lxp0imV8dB4/32aILYsVlaBEjlzr1zj9zTanFa9PUtVmpzL3xAk76oT9hYTFtZtH0FW1pqbC6/9MV+VLwdFguc3TMmEWjesHYZL1kYFuHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbEE2ktFuziJ23HddLZwp0+Xz4fe6TwhCTXmZfznxyo=;
 b=DZUH5yW/wbIfl57PmDJrwCy7vIGiR3Onx7uF6A1zcCCYdPTHLTCgLeelho3q8YqotM77RmPr4SGXlhW4SrHoATWS5b0Z2EF5F1Pt9e6WUcaW51XW/iMmM2ZVpf8zve5YrJLgmJAYgf/I9J21BBJKa8nH0mGAgwRI+/YS7QW2ujkZ7nZL1ziz+WgKuZJXJuxCAFpAiJvUn41Gtc2LNv1IbIMNnZ45uHhUs/Gn5DMMnVDfiQWKnV0zn+fQeWIh6RnaBDUznwlfJa/0MpVNeWyk/vOCimELFgWtPY+MJidcXGlVmMMpNF4uhJhrTT27eIISjRDCDYsPxYQ+DbiKQWZLVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by CH0PR11MB5330.namprd11.prod.outlook.com (2603:10b6:610:bd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 15 Jun
 2022 14:14:14 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d518:17a2:11e6:bd6%7]) with mapi id 15.20.5314.019; Wed, 15 Jun 2022
 14:14:14 +0000
Message-ID: <00724e48-b6db-4b80-8b53-dbf2b2ca4017@intel.com>
Date:   Wed, 15 Jun 2022 22:14:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: Bug report: vfio over kernel 5.19 - mm area
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     <akpm@linux-foundation.org>, jason Gunthorpe <jgg@nvidia.com>,
        "maor Gottlieb" <maorg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, <idok@nvidia.com>,
        <linux-mm@kvack.org>
References: <a99ed393-3b17-887f-a1f8-a288da9108a0@nvidia.com>
 <3391f2e5-149a-7825-f89e-8bde3c6d555d@nvidia.com>
 <20220615080228.7a5e7552.alex.williamson@redhat.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220615080228.7a5e7552.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:54::23) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3341cbba-6ba6-41b7-9487-08da4ed95338
X-MS-TrafficTypeDiagnostic: CH0PR11MB5330:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB53309837DF3814CDD4480E52C3AD9@CH0PR11MB5330.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ryj2ZEoxzN8Thmi2itwsdgHa8KOsZvZ0D1pSEcMAwyzFtGAdL73fd+rsZ/xzx2/bmU3qVhfiYA1vF98Q+TWUEbofCPRJaJmUh/J4REAnXD9NS09JgF7tlzJzI9xRxw42uJO3/mq6CMHD7zByM/50xpnXWMQR3iszSRBwVUeKy0SyMZ3jbMUKZpXSb7FXsy1Z2u2F+fZ3r7uldwUaSBO9ZjCPQIKk/tB+B+hvNcjgIoh46lFQuJLPzW12yufQsWHEcUSCIA0VaC3xM8oBD9DUHm33PXQXmhJBzuOCZXJcbGEvupZV3F7ITfkIa7Sj0nyNeHmW7r8JtO3s90KypuubxzrI1xwWGuWdsRsLN62rY9CGb8htUgy9D7vrpoZj6OoXvQ0n7rK82ghSHr6qGdUtugmQ1z/BRY/FdXt0NqFUp0SIwm73nHCa9Ub6pBOCG5VzDIE/5k3Y06AJ5j1YonAXARZV/WOQn3F7vPB6HwBP17rcAhRe2qpvVvyj6TjRzXWIqfkn4QGEVuFzBShC+z7xPb6l+inG1qqHcEPmn7AazFXs7Fr7C+u1cJFnz6vOD3KIArRW6b9jTRvBCANiYHZ1YaWbW9Zr0rg1gHoOPsYinLvikla1tVW/AQ3cWvfg7EO5H7xF0GQsTyd2E7SJPWOPeKjyb4VMr0L+/haT/rKgCmy92DK95hq+uswPkWF/tUe39QvPHBITOhImz5FCVKDU0RjoeixYzwyIWU2dlLZ0UwNh1qHZcAnmoZKZVtt9xkUkHwdQj80QTIQssdDsmwbtofXpyG9tAcaWaMaRBLkPMR7/2H7A6PDpn6/DHie8QMqq4OoDGDeqCv5P0EW0l6iG1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(110136005)(82960400001)(966005)(8936002)(508600001)(54906003)(4326008)(31696002)(6486002)(38100700002)(66946007)(86362001)(8676002)(66556008)(6506007)(6666004)(186003)(2906002)(36756003)(2616005)(316002)(83380400001)(6512007)(26005)(31686004)(53546011)(66476007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2VGTFBYVUR3Ryt3eXVOTkw0NWJPcTIrQkhiQmtna3BIY1lEN1k1R3hjUytl?=
 =?utf-8?B?MXl2THJHMFVuWkcraWpKUXpTSXgyOGY4VkhsSGJFME93KzhUMUFVbVdDbSti?=
 =?utf-8?B?SkN2VzdaYlpqV1hEaGVuSFU4cTFIS0UvZkFCQnI4TERHM0k0VlVvemVIcGNU?=
 =?utf-8?B?L081T0EzdTNTdHBsS0ZhellObGZCdkpWWEhzNVAvSlBZOWNEOEQxMTU3WTYr?=
 =?utf-8?B?VGJXK1R4eGdUU3EwcnFzVFRiRTYvaEJlWVlXRmZ3VC9ZU2ZIUlo3RjYvUW92?=
 =?utf-8?B?eUppQWVpY0NvQTlpc0FzWCtMYWhNVEFhYUJXMWZ6Y1FpdEpKOEdvbFdZTFVD?=
 =?utf-8?B?bkJHQjQvK09WaU5yUnlYajlEUk8rdiswd3R0WXN2MjFNV1FHM0MwUm5CdFRs?=
 =?utf-8?B?VXkySDB6TDZ3eXNpV0xucU9hUmp3NXltVk5rVm9TMk5qVDlIUmdHdzVlZWFP?=
 =?utf-8?B?UkJFMzR0VjNJa2ZTOUkyVm9xaGtPS1VaVXpxY25YQ3BZYXZqQ0I1dzExdURk?=
 =?utf-8?B?ZXFmQjI2c3EwZVFpbFVXdzQrb095bEJnM211ZFlidk92UDNvajNBekVEVU1k?=
 =?utf-8?B?ZlU0a1REYXlycTJSeE1tYWhnYlZwaU84eTBXcDJKb2NHYS9mdUpEU2Ruc1Z1?=
 =?utf-8?B?eXo5VnpWak8vQy9acEFRQ1FKeGFTOU5LN2F2aUV4djQ1bDdRVXRid0srbU1Y?=
 =?utf-8?B?UEh2a2swMjRwRkpzOStlUmI3T2M3MG8xVlBUNzlpSjJTekJXLzJpSFEySUNK?=
 =?utf-8?B?cE1mSkpvWUk4V2VrcjlQVHNwaTh6SDNFaUw4RW9QOWhOZ0t3cnIwSXErTFBK?=
 =?utf-8?B?NVhQbC9oNXJTemVwVFYzRHNSRjRTT2gvUm5nVWY4RDZxd3N2UjltaGNVeUJa?=
 =?utf-8?B?KzBybFVWNldGL0NWbFJubTlpSGlBS3hON0FtYWpJb3ZRWmw1VmcxaWtPYWxB?=
 =?utf-8?B?NjBSdTFVR0podTVFVENGeEsvdVVZcDZ0MU51YnBTR1FWZmVldWZ0ME15Ny9i?=
 =?utf-8?B?ZThnQUZUejRzSjZDaFpFSDZSSUVCWms3NnVROWttSGlhczIwQVA5U01qdlhM?=
 =?utf-8?B?eFlsT2NFdnV2WFFWbEx4bU1VVXhXVDZhQjNwVVRBR2xqZkk5TXpRbkF5MS92?=
 =?utf-8?B?SVlLRzd1d2VHOFVqeFFYTko5Z2x1c3BBVU41U3BRWkFUaHhPNEM1aDFBUldP?=
 =?utf-8?B?Ly9Ob0YyUk1vL0VKM0MzbXRhZTJTTFRRUWJrMlhHSW84R0g1b2ExVFc0MzRC?=
 =?utf-8?B?MGk2aS8rRzhtTE0zK1BhZTRQcUtSVUltVm9PT0tVRHk4Y3BWa3IzV3NUWUEw?=
 =?utf-8?B?cFFORjFzVXRHVzRhdmdZVTdoemFubGdvR3NJUTZtaDJiN3dRN0loRGtURWVK?=
 =?utf-8?B?S3lyZTZ2b0tIaXQ4bk82VEZFNXd4VStSK3dudGtmMUdyTVI4TEFBMklzYjB2?=
 =?utf-8?B?RXUzV1RFbmNrNkMydjY2dmwxUHhJbEtQSjh3QUh1aE5KY0tNZDFRdG92T00z?=
 =?utf-8?B?T2w2bDF4Ri9vNUpadlJHbkRMOE11K0FwY1UxUXJPdUhqQkJYSnVlOUpCY3ZN?=
 =?utf-8?B?QnQwbXg0RTlxMzF1VzAvemZ6MFI0ZVNlNmZCa3JwTi90WXk5cm9ZcFVRR29v?=
 =?utf-8?B?R2dUTlZjZkpJYVcyT2lSdWxhTjhaa0pkREU0N004eDZYRGZCNDNBUllUTXhZ?=
 =?utf-8?B?bTJxcXNwWGVFdHFPS2oySklCdlpyc0xzOU1sNHRGYU9qRWs5REtiSGg2WXZR?=
 =?utf-8?B?NUZEQTVndS9GWitEZ2c3UThzWnptbmIxQk55Z1dCcmpZS3N5RkQ3a2FIZ1NH?=
 =?utf-8?B?Y0VubEkxV1dLSmJwWHdVRHJ6Z2QrRHFmeER3K1hpSEFQV0NOY0dHVkk3Q2xR?=
 =?utf-8?B?d0xGeGcyL2hvendIL0VHNUhZaTRKVjJId2lGemJjN3paaE03aURGaG5aZkkz?=
 =?utf-8?B?bXA3Rk1POVRkKzludTdXQzlpVExIUnQ0bzV3NE5raHh4ZXJ4VStpWmpjWldv?=
 =?utf-8?B?T0E2YityWWdGRUY2RmtiRE9oLzZTL3NzTzdFdDluejhDbUdieURYNHptOUxU?=
 =?utf-8?B?V2IzM2tyWlIyb09Ualhoa01OMjRSY0NwQTlSZURSRThRcTV4RXpWL0J4LzlB?=
 =?utf-8?B?Vm0rcmxmNExCbm8walBTVEJzOCtZNk83Wk9xTEZhUEtZOXVxdTY0aHFhbDcv?=
 =?utf-8?B?RndHMzVhd0xpMTFyMHBqQWl2SEFOa0xQL3krK2FXK0hTWG11OUxxS3lTNmJT?=
 =?utf-8?B?bGFkMDZwRXEveklwRHlOUUV5V3MvSFJubnd0dkJMSFIvTHg1Sm1XaHEzMllx?=
 =?utf-8?B?cVFrc242RU1kSHYrWXBaVlhsQ3FjNTl3QzZENkxNQnRoUStwOVZRZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3341cbba-6ba6-41b7-9487-08da4ed95338
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 14:14:14.0401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MsVWfC5ZdHq0wAadYuiHnL1U/SYArLOapv4Yh4aSspE8xZK3J2LrUBy10CU3ojw7knnGiRJs4vZ99rZAfKMZnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5330
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2022/6/15 22:02, Alex Williamson wrote:
> On Wed, 15 Jun 2022 13:52:10 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> Adding some extra relevant people from the MM area.
>>
>> On 15/06/2022 13:43, Yishai Hadas wrote:
>>> Hi All,
>>>
>>> Any idea what could cause the below break in 5.19 ? we run QEMU and
>>> immediately the machine is stuck.
>>>
>>> Once I run, echo l > /proc/sysrq-trigger could see the below task
>>> which seems to be stuck..
>>>
>>> This basic flow worked fine in 5.18.
> 
> Spent Friday bisecting this and posted this fix:
> 
> https://lore.kernel.org/all/165490039431.944052.12458624139225785964.stgit@omen/
> 
> I expect you're hotting the same.  Thanks,

I also hit a hang at calling pin_user_pages_remote() in the
vaddr_get_pfns(). With the fix in the link, the issue got fixed.
You may add my test-by to your fix. :-)

> Alex
> 
>>>
>>> [1162.056583] NMI backtrace for cpu 4
>>> [ 1162.056585] CPU: 4 PID: 1979 Comm: qemu-system-x86 Not tainted
>>> 5.19.0-rc1 #747
>>> [ 1162.056587] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>>> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>> [ 1162.056588] RIP: 0010:pmd_huge+0x0/0x20
>>> [ 1162.056592] Code: 49 89 44 24 28 48 8b 47 30 49 89 44 24 30 31 c0
>>> 41 5c c3 5b b8 01 00 00 00 5d 41 5c c3 cc cc cc cc cc cc cc cc cc cc
>>> cc cc cc <0f> 1f 44 00 00 31 c0 48 f7 c7 9f ff ff ff 74 0f 81 e7 81 00
>>> 00 00
>>> [ 1162.056594] RSP: 0018:ffff888146253b38 EFLAGS: 00000202
>>> [ 1162.056596] RAX: ffff888101461980 RBX: ffff888146253bc0 RCX:
>>> 000ffffffffff000
>>> [ 1162.056597] RDX: ffff88814fa22000 RSI: 00007f9f68231000 RDI:
>>> 000000010a6b6067
>>> [ 1162.056598] RBP: ffff888111b90dc0 R08: 000000000002f424 R09:
>>> 0000000000000001
>>> [ 1162.056599] R10: ffffffff825c2a40 R11: 0000000000000a08 R12:
>>> ffff88814fa22a08
>>> [ 1162.056600] R13: 000000010a6b6067 R14: 0000000000052202 R15:
>>> 00007f9f68231000
>>> [ 1162.056602] FS:  00007f9f6c228c40(0000) GS:ffff88885f900000(0000)
>>> knlGS:0000000000000000
>>> [ 1162.056605] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 1162.056606] CR2: 00005643994fd0ed CR3: 00000001496da005 CR4:
>>> 0000000000372ea0
>>> [ 1162.056607] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> [ 1162.056609] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>> 0000000000000400
>>> [ 1162.056610] Call Trace:
>>> [ 1162.056611]  <TASK>
>>> [ 1162.056611]  follow_page_mask+0x196/0x5e0
>>> [ 1162.056615]  __get_user_pages+0x190/0x5d0
>>> [ 1162.056617]  ? flush_workqueue_prep_pwqs+0x110/0x110
>>> [ 1162.056620]  __gup_longterm_locked+0xaf/0x470
>>> [ 1162.056624]  vaddr_get_pfns+0x8e/0x240 [vfio_iommu_type1]
>>> [ 1162.056628]  ? qi_flush_iotlb+0x83/0xa0
>>> [ 1162.056631]  vfio_pin_pages_remote+0x326/0x460 [vfio_iommu_type1]
>>> [ 1162.056634]  vfio_iommu_type1_ioctl+0x421/0x14f0 [vfio_iommu_type1]
>>> [ 1162.056638]  __x64_sys_ioctl+0x3e4/0x8e0
>>> [ 1162.056641]  do_syscall_64+0x3d/0x90
>>> [ 1162.056644]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>> [ 1162.056646] RIP: 0033:0x7f9f6d14317b
>>> [ 1162.056648] Code: 0f 1e fa 48 8b 05 1d ad 0c 00 64 c7 00 26 00 00
>>> 00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00
>>> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ed ac 0c 00 f7 d8 64 89
>>> 01 48
>>> [ 1162.056650] RSP: 002b:00007fff4fca15b8 EFLAGS: 00000246 ORIG_RAX:
>>> 0000000000000010
>>> [ 1162.056652] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
>>> 00007f9f6d14317b
>>> [ 1162.056653] RDX: 00007fff4fca1620 RSI: 0000000000003b71 RDI:
>>> 000000000000001c
>>> [ 1162.056654] RBP: 00007fff4fca1650 R08: 0000000000000001 R09:
>>> 0000000000000000
>>> [ 1162.056655] R10: 0000000100000000 R11: 0000000000000246 R12:
>>> 0000000000000000
>>> [ 1162.056656] R13: 0000000000000000 R14: 0000000000000000 R15:
>>> 0000000000000000
>>> [ 1162.056657]  </TASK>
>>>
>>> Yishai
>>>   
>>
> 

-- 
Regards,
Yi Liu
