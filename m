Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253957411A2
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjF1MtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 08:49:12 -0400
Received: from mail-db5eur01on2087.outbound.protection.outlook.com ([40.107.15.87]:10401
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231367AbjF1MsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 08:48:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5JECT1lRlEQUPXLh56363g7RlpIEN0IYU3AS+8Ckbeb8DAgcIOmubNLfV4MCS6l3rXngW89B7OkVUfuIYb/w1/VVxfC+tD/sVm3D1SUKEIGBWVAY7wnhkkeJMMLAHxRBGdCfyYmNqQIv3CXNuh8tnbla+DjXIqwbKqWb5+uuzA2QeLVZtb7xGQod8yAHnfEfxjBGzpFlR71987aAl6XnzJVA6VWA+s75XmxPoxbi6A1otKBX7Pfgy1m6jtdn5A7rmCeQ4Oi0X4n1YYlQh9Y40cigTNyjC7e1BOoBUe8qXhm/qLSBQFH8q3uY5GRcRBQLh+c/G2c9QtTJG4+YXjhow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWP60YNjl512jQwFnUSBPhB0iF9igOrLIknJb+2Hxjk=;
 b=N6DBXPq077PnLkXZvNw+4irU84aUdZj/BfxpxSTNkuRX+tIqcBJl+gDzF6iH+KKrId9qPTlr7RtTgh39kMAqYr2k3iUGHw5aXIa6xMjqem/2dEKb3arVWCsqLL0mcz/a5q5E1NdtBfRrlFwJrsBRGWbvMV1aKCbBgEr/n5ZS8rPWfW7Ny97jvqAu4iYtVvFwJOg91Ogs+AqbJqWFZaphgCyADGK6EvleFfBIUOAhpGVHMTln9Iq43FNrN6YDUdd0SzfgSA+t7i3GRf55c1/YS3Jo2T0CBHRtie0t0X9Sq/QbMb3bGkE97hWZLfnMst4bO8HK20Nkzg9cidRDMEm2YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWP60YNjl512jQwFnUSBPhB0iF9igOrLIknJb+2Hxjk=;
 b=oUGm/jpm6eh27jlHAcOm4m0084CC9U3llO954LPAOYiDMvHCdtt7yp6sQ1IrnQflZ39cx/3NDWG2b1yvfbjZXedMMFuG25C0L3ZeAEz6tCYFZutFob5/8T59pSbhag7bc4y0SyIn70aqHrcjvRiZYOpL7mAZKBEj41NvLLsxjFsIyrVe8mjiP0c0jb9ocZ7cIKd2yeV/IdigqOunPg21pxV0wDlTO6haclWBLLuBvtSoFK78HJhHWYuPiSe/ShmjoBTHkVHZcX7PbCy+SWbGM+VH1hHb5e9CDwODo7vkXhDq5FiuhXKjilPqGH5S0XzEs7isFdIA61+QPLyJXPMW7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by DUZPR04MB9984.eurprd04.prod.outlook.com (2603:10a6:10:4dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 12:48:19 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::66a2:8913:a22a:be8d%4]) with mapi id 15.20.6521.026; Wed, 28 Jun 2023
 12:48:18 +0000
Message-ID: <fd7e5b2b-57ca-efcb-9295-29dfb41cc061@suse.com>
Date:   Wed, 28 Jun 2023 15:48:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Content-Language: en-US
To:     kirill.shutemov@linux.intel.com, Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1687784645.git.kai.huang@intel.com>
 <7d06fe5fda0e330895c1c9043b881f3c2a2d4f3f.1687784645.git.kai.huang@intel.com>
 <20230628122342.zdnqsgnugalqj6ix@box.shutemov.name>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20230628122342.zdnqsgnugalqj6ix@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P195CA0033.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::22) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|DUZPR04MB9984:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e4c6377-1ec8-4433-c864-08db77d5f28f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuDlviVuJzqSF6royccK2h4MvuUpo5Ttly03KkYat1pFqLedVYvdAWZKTN/UDWajsF5rDugMfv0N4w8ov8Xa6ivNABp62B9g+N5TJv+f+vlUwzylIrDqsiyg7CrHLqXkDwRD/VYcind8wF18gh1eLivmLgwAtSo/vcKwqJfXVg45KtVw6wL3ffIb8fKLXE1qClxzLPUVEBCYF9sYxzmKnhUOrtNrfgbU+v1dpW4wMR5q2TNwCx+oftyMwl8FbRUw6ejMEGaShFCl4b0xl6qLu2kX0tqnmqDz/cNy1/JbwYH9x+TVF1spp2CmgW+EJJgASuEhUPT0XbEBlnx8Pa7uC0HEolwljrd9/txZ2IWhOtoO2rWwAz1TGh8sSiLFdrzypIZg1GtPCG1f9Nwu85T3mmMB1+hjI+c1mBDuxyqHkCWWchc32gGMCbwad2EufdZSTv0uCuhxcyec/nyu7ByuJvSsyXoxvYXQi50/MCAv+Ecftqyxv6DfPrSBm4zpIqZYgIEaL7ZUvV02/rt4Z4CP6HShgjdkku75uNt+G+uj/g5msklIEj44MfIMZG6D2rGDui9p0IWOWJGt4N7bb0+qb4EAXVyngjahLI3vwOY06sxlVAOdVsnX1ACwWmmFaSNNOut0Oar3e7wRprvJ8Ke2xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199021)(31686004)(6666004)(478600001)(6486002)(83380400001)(2616005)(86362001)(31696002)(66476007)(66556008)(6506007)(186003)(2906002)(6512007)(66946007)(4326008)(36756003)(6916009)(8936002)(41300700001)(38100700002)(316002)(7416002)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzNMZG1OVWdFaStqMWljdFk2UDRRQ1VJSmI3Z0dKZjF5aGVkbW1kR29hQ2o0?=
 =?utf-8?B?bnJGZ2JwaE05TEJrM28rdjgvNHpWRjBwaGNYR2xtR1E3WHhqdFBWb3IzTHly?=
 =?utf-8?B?UGwveUErRkRaemJLNDRKL2dPREY0eXNreWRvTkpuVTBqM25sN1V3bzVWeHlU?=
 =?utf-8?B?aVZQZDBEVG85NFJWTnRsdjQyYnI0enpoS2RNMG1tc0xzNlpnb2Q3T1h0ZC9B?=
 =?utf-8?B?c2IwLzVtbk5NYnVLa1NpVW1LYXF5OHFmcDZPMVk1V3JxVDRQa2VWWFJXRkx5?=
 =?utf-8?B?U3d5RkE3QytqZWRsSHZpZDhKSjhGQTA2OGFRQlViWDhkZzNvRU56YlpSbitP?=
 =?utf-8?B?SXRqQkFsUUErVjByTEZReFY1dHlSMWxDL1hFYTg4dW1YN25FMndtTUgwOGxQ?=
 =?utf-8?B?SWVSQnUxUmY5SzQyMFZlbGw3WDh0K3U3K1JlV1QrYzltaUMxV25PZC9uNUVh?=
 =?utf-8?B?LzBLUTJGYzVnYUt1NlJWRjNtVklaWHZSVkoxMFNiUlZQVGdScWlzWUdzcitn?=
 =?utf-8?B?RGpnZXJRY0IyYTg3aUo5OGs4WktnL1gwN2wrMTBMU3hleVhaWUFtQmVja1oz?=
 =?utf-8?B?QmdvR0NqY1BwME81NzYzVWMzMW5BQmVpQmR4a3JQSlV3MS9xczJKT2UrNmFZ?=
 =?utf-8?B?Sk9wMUd1TnZoMXlUQVdrZ3Q5bFRUcmRnNm42dklHcXVQSEN0cFJEUzhzY0ln?=
 =?utf-8?B?UkZtYWJTUG1ob2QvOTdCb0padWRzZXR4SnZ6YjVvWEowQTdUTFduNFJTdW9i?=
 =?utf-8?B?WWJkdTZsOElkdmdQMnowY1VPR1NwTStyMm1rUVNLZUoxUXpraFVubWxSUG9D?=
 =?utf-8?B?R2krZFRHSDZvL0pYZG9HVXBrR3FtQ3NTb1pPamVLd3JkY0NZNnlrdnNwbHhh?=
 =?utf-8?B?UWpMWmZRbThBWlJMNTJjS2VVbDhBMFBMRHN0NHZWWFdnZThqeVlOK04rQ1Bx?=
 =?utf-8?B?cWE4MkR0YXo3eDhvVUhORW55c0YvMFoyWktoM0ZMcDFHV2tQWFlnSzNmeDVx?=
 =?utf-8?B?RjNrTHBmVjV6b0hjZDRJRzQyMVpOR0hxUTlFNHNBL1JNRFNqV2p2U2ZkVlFq?=
 =?utf-8?B?cjhkMTExcTVXejFpcTFtOGgvc0N0SzU3OWMxbGFxUnYzbm9CMUx3VzBkbml6?=
 =?utf-8?B?cXlCbjZlMVRGZ3VxcE5KMW5pclJOaElvSHI2SUJXaWwvUkU2b01OaENKRUNK?=
 =?utf-8?B?Uk8rLzZKRlppN3VGclViYXlscHYzYnhLcFJUNjBkNGlIcklLbXBZdmprMC8v?=
 =?utf-8?B?M2xvNzhaU3NYL3kxQTBwd2M5TkVXQkRDQVE2dk0rclk2TktIOVBuYmR4cGww?=
 =?utf-8?B?ck4yY3J2NlNZaWEremJEME1LdnpmTUhEcGU2eVJ4eWpDT0piMlZuOGM0dE5C?=
 =?utf-8?B?WG1iTitHd2FUNGYrTE43a2laNnNuUjVId0RiYTVXakt4RkdtUStwbXExVXVs?=
 =?utf-8?B?MjVxc2FGQ2I1YWx1K3NxVHZGTmt2c2NnZGdleGN4ZUx1eDhVM0lLSGo0enlH?=
 =?utf-8?B?WUtTdDUvVkJaRHhHci82aDVESVJYeWw2cTlya05ubTFwek85V0JjbzMvdWdP?=
 =?utf-8?B?eDMxRkQwUTArU3YvTmc4R2FJSzZRbmtSRFdxRDF5MFJEQWdyekZTTzluUFBN?=
 =?utf-8?B?Tm55VXN3dVJZRWE4Y0hsNUszbVFqQldWOWpJbnFsWDd2SVk0Q2ZXUUhrdGds?=
 =?utf-8?B?d3dpb2RpUXhPRVZxamtyV0V4UWxORUN3RGF3MTdlbXZJVFBlUWxMekIrcE13?=
 =?utf-8?B?aVJES0tzVlFtbjZnMDV4QXdCQnlTSFFlM2hIQjFxelZYRFRFazNCTnpOTWdy?=
 =?utf-8?B?TDM1S0c3eEVMK3BucUVGekw0MUxqNTVxcW9Gc3dzSytHZzVYbzIvK0FkWEoz?=
 =?utf-8?B?S0JuTHk5dlFUU0x1NUgzTHIvRkU3VE1UeXN3cFBJU1NVLzZVSFJVL0d1Z1BE?=
 =?utf-8?B?RjNaeFVDZlgrOVhmTzl3TFI4T3VDRG9Od0x0Y3ZMRFZqcnU1RzFkblN1eFBM?=
 =?utf-8?B?SkM3SGZWT2ViMnRzL1RBVGlzN3NMZFFmUWxRU0xFS1NpbXNIa05GbXNnL3FX?=
 =?utf-8?B?OE1ldDlwMUdqaXFORDYwKzBZcW85TXBPMXZjc3IyTitCV3pveDlRZEtmNzFG?=
 =?utf-8?B?SkRGdncwc1V6RHBENHVtUmU1b1RoR2E5SnZnRHhESElQdFBqYlpwMURaS3Nh?=
 =?utf-8?Q?Z3jFEkUOHj0hBbk11jcyVwGamt7CE7UKycVYgnhTeMS5?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4c6377-1ec8-4433-c864-08db77d5f28f
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 12:48:18.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jWOh2zXrRTxWoBkT+ck63po89o4tMYQlT1+UA16l90CNxZ+vGlnZjvSt3lY+f3vUVt9mtpoGkQXMWcrDRxbCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9984
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28.06.23 г. 15:23 ч., kirill.shutemov@linux.intel.com wrote:
> On Tue, Jun 27, 2023 at 02:12:48AM +1200, Kai Huang wrote:
>> On the platforms with the "partial write machine check" erratum, the
>> kexec() needs to convert all TDX private pages back to normal before
>> booting to the new kernel.  Otherwise, the new kernel may get unexpected
>> machine check.
>>
>> There's no existing infrastructure to track TDX private pages.  Change
>> to keep TDMRs when module initialization is successful so that they can
>> be used to find PAMTs.
>>
>> With this change, only put_online_mems() and freeing the buffer of the
>> TDSYSINFO_STRUCT and CMR array still need to be done even when module
>> initialization is successful.  Adjust the error handling to explicitly
>> do them when module initialization is successful and unconditionally
>> clean up the rest when initialization fails.
>>
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>> ---
>>
>> v11 -> v12 (new patch):
>>    - Defer keeping TDMRs logic to this patch for better review
>>    - Improved error handling logic (Nikolay/Kirill in patch 15)
>>
>> ---
>>   arch/x86/virt/vmx/tdx/tdx.c | 84 ++++++++++++++++++-------------------
>>   1 file changed, 42 insertions(+), 42 deletions(-)
>>
>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>> index 52b7267ea226..85b24b2e9417 100644
>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>> @@ -49,6 +49,8 @@ static DEFINE_MUTEX(tdx_module_lock);
>>   /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
>>   static LIST_HEAD(tdx_memlist);
>>   
>> +static struct tdmr_info_list tdx_tdmr_list;
>> +
>>   /*
>>    * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>>    * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
>> @@ -1047,7 +1049,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>>   static int init_tdx_module(void)
>>   {
>>   	struct tdsysinfo_struct *sysinfo;
>> -	struct tdmr_info_list tdmr_list;
>>   	struct cmr_info *cmr_array;
>>   	int ret;
>>   
>> @@ -1088,17 +1089,17 @@ static int init_tdx_module(void)
>>   		goto out_put_tdxmem;
>>   
>>   	/* Allocate enough space for constructing TDMRs */
>> -	ret = alloc_tdmr_list(&tdmr_list, sysinfo);
>> +	ret = alloc_tdmr_list(&tdx_tdmr_list, sysinfo);
>>   	if (ret)
>>   		goto out_free_tdxmem;
>>   
>>   	/* Cover all TDX-usable memory regions in TDMRs */
>> -	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, sysinfo);
>> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, sysinfo);
>>   	if (ret)
>>   		goto out_free_tdmrs;
>>   
>>   	/* Pass the TDMRs and the global KeyID to the TDX module */
>> -	ret = config_tdx_module(&tdmr_list, tdx_global_keyid);
>> +	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
>>   	if (ret)
>>   		goto out_free_pamts;
>>   
>> @@ -1118,51 +1119,50 @@ static int init_tdx_module(void)
>>   		goto out_reset_pamts;
>>   
>>   	/* Initialize TDMRs to complete the TDX module initialization */
>> -	ret = init_tdmrs(&tdmr_list);
>> +	ret = init_tdmrs(&tdx_tdmr_list);
>> +	if (ret)
>> +		goto out_reset_pamts;
>> +
>> +	pr_info("%lu KBs allocated for PAMT.\n",
>> +			tdmrs_count_pamt_kb(&tdx_tdmr_list));
>> +
>> +	/*
>> +	 * @tdx_memlist is written here and read at memory hotplug time.
>> +	 * Lock out memory hotplug code while building it.
>> +	 */
>> +	put_online_mems();
>> +	/*
>> +	 * For now both @sysinfo and @cmr_array are only used during
>> +	 * module initialization, so always free them.
>> +	 */
>> +	free_page((unsigned long)sysinfo);
>> +
>> +	return 0;
>>   out_reset_pamts:
>> -	if (ret) {
>> -		/*
>> -		 * Part of PAMTs may already have been initialized by the
>> -		 * TDX module.  Flush cache before returning PAMTs back
>> -		 * to the kernel.
>> -		 */
>> -		wbinvd_on_all_cpus();
>> -		/*
>> -		 * According to the TDX hardware spec, if the platform
>> -		 * doesn't have the "partial write machine check"
>> -		 * erratum, any kernel read/write will never cause #MC
>> -		 * in kernel space, thus it's OK to not convert PAMTs
>> -		 * back to normal.  But do the conversion anyway here
>> -		 * as suggested by the TDX spec.
>> -		 */
>> -		tdmrs_reset_pamt_all(&tdmr_list);
>> -	}
>> +	/*
>> +	 * Part of PAMTs may already have been initialized by the
>> +	 * TDX module.  Flush cache before returning PAMTs back
>> +	 * to the kernel.
>> +	 */
>> +	wbinvd_on_all_cpus();
>> +	/*
>> +	 * According to the TDX hardware spec, if the platform
>> +	 * doesn't have the "partial write machine check"
>> +	 * erratum, any kernel read/write will never cause #MC
>> +	 * in kernel space, thus it's OK to not convert PAMTs
>> +	 * back to normal.  But do the conversion anyway here
>> +	 * as suggested by the TDX spec.
>> +	 */
>> +	tdmrs_reset_pamt_all(&tdx_tdmr_list);
>>   out_free_pamts:
>> -	if (ret)
>> -		tdmrs_free_pamt_all(&tdmr_list);
>> -	else
>> -		pr_info("%lu KBs allocated for PAMT.\n",
>> -				tdmrs_count_pamt_kb(&tdmr_list));
>> +	tdmrs_free_pamt_all(&tdx_tdmr_list);
>>   out_free_tdmrs:
>> -	/*
>> -	 * Always free the buffer of TDMRs as they are only used during
>> -	 * module initialization.
>> -	 */
>> -	free_tdmr_list(&tdmr_list);
>> +	free_tdmr_list(&tdx_tdmr_list);
>>   out_free_tdxmem:
>> -	if (ret)
>> -		free_tdx_memlist(&tdx_memlist);
>> +	free_tdx_memlist(&tdx_memlist);
>>   out_put_tdxmem:
>> -	/*
>> -	 * @tdx_memlist is written here and read at memory hotplug time.
>> -	 * Lock out memory hotplug code while building it.
>> -	 */
>>   	put_online_mems();
>>   out:
>> -	/*
>> -	 * For now both @sysinfo and @cmr_array are only used during
>> -	 * module initialization, so always free them.
>> -	 */
>>   	free_page((unsigned long)sysinfo);
>>   	return ret;
>>   }
> 
> This diff is extremely hard to follow, but I think the change to error
> handling Nikolay proposed has to be applied to the function from the
> beginning, not changed drastically in this patch.
> 


I agree. That change should be broken across the various patches 
introducing each piece of error handling.
