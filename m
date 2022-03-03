Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5644CC031
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 15:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiCCOmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 09:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiCCOmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 09:42:17 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCA918E411;
        Thu,  3 Mar 2022 06:41:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mboqR8JsinnLply9pq/r1PNvvHWbvA/P7Y0+tiv6HHCbujdct59Y2hScO3HJmp4QZlYTMWQMyjGrUUash3bx4Oy66cum9J9O9yuPJeMYbg2mPqDo+RE7Qh2TrgLZuJMo0ajM1ryzJGhbwI8A0pDnwN4fMrEudzB8YI5DOC63Guo07M5gLklwtb4cdEQDfWYwFsKDWq4pvWwIcFsZSZNO5EU4m5PwroIpaJh2BdIX+fiQxK9XOti/6X87EdVuzeT94umP7KEE723s10N6be6Pa66Dxgx5JigigmgXYKWZ5apSdSNPwYwGxtZylFE24BCFm/S142R5cKXan+O7MfByvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wm8LGgwgMvLQZFyThHzZ/0NyNhfJ+NR7h3uWUGVcXzw=;
 b=AENj/79QchwsAGqdIJ7luKzFDE+rtBdAkl7dfdaK5FIDLrhFq2Loqc7NEYLaOcLn83WnS/BpNgXYvKLy0sBAZrEzdIrl9uetgGvBeeNjMTQ8oANKXbUOVgumLepfY9EF8Eah9wjDc5do/5QtJ51yBKZd6E+R/pF/H5h0zcXMJQGppsinWYXmxHUKjSTmgMAjif+EFkhZ141o+KTHq+VSXXg5LTKzXUFORlIVHhsiVw0tB1dlMnXz2mxKfHvJOVbAQJsFfUi7O8X6uMVBUoNk7YT2qxbiT275bOkzmJWY5O0SaBTWYszI7XIAqQawfr1ElIYXtVjDo3pTr/99zFHj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wm8LGgwgMvLQZFyThHzZ/0NyNhfJ+NR7h3uWUGVcXzw=;
 b=OxHq8b7D34QO+EC3mk6T8rVcCjddvcf7cYW12xDmcof8MwU/n/dYI+Mu8vERMksMayX8FdcUkKItsjmZWrfRGiE1qEs07Qzc+0hVy085Pglq79iRjCM3mCl/72m+HWSoOdqPUQDNfNngPcealp5UYGytdP+6pZyAJBob9uPrfsg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.24; Thu, 3 Mar 2022 14:41:30 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 14:41:30 +0000
Message-ID: <25254b24-c4d7-b5eb-d67d-1415c6625448@amd.com>
Date:   Thu, 3 Mar 2022 21:41:19 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [RFC PATCH 07/13] KVM: SVM: Update avic_kick_target_vcpus to
 support 32-bit APIC ID
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-8-suravee.suthikulpanit@amd.com>
 <977ff8b8801a99aaaaa15c9f2f0ffa2e360984a9.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <977ff8b8801a99aaaaa15c9f2f0ffa2e360984a9.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0081.apcprd04.prod.outlook.com
 (2603:1096:202:15::25) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2b8b5c9-62de-4084-70b6-08d9fd23e744
X-MS-TrafficTypeDiagnostic: DM6PR12MB3116:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3116D24296754711834A040DF3049@DM6PR12MB3116.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H4CpHiABN0DECaBRQ97BQlt6AC5UymlQzY+8eVZbqs78pKL5lUz3iIBKtXPEI2paz7u5l1CGH15ONn+DGnNo5/gzBXtyGYAuSrgyCX5OEMBK1rqBBxHjiPuFLCZ0mTHGNWSzeNtTT0ENcC7S2cNJ8ekJ02SX1fFI9ttE64Ou13UiG0vi5Fc03btLi7so0HDxmciONrRNoF9UAmiYlmxIbWgQOEed1LXPLOiz0cvj8BuP1wPy3f+fhUJEHjl4gMpMOCV/BtURVvN4jKoGs1GhcQhDbdomuC25wjbA+Sn8Dpxk7wCl/+rhGDDx5N7hPkYdAzv2mIpRITN+xmlpR6m0zha7q31C35yC+hGyup4lxKgp9viB+gj4S1KJya6ZPxT/f1wO7uAmXA2+zY8lcEGQnFfnMmg7Jb2SZiwMLcXdoZLde1oy5qvYZUg1/h5qX8RT+uJdvXWPfkDbJfm0ZfSfkzd6ovGIecwAxuBOp+wisSQGumWzPNhfRK5E+CUXwTqeCsQymvioO01skD/Jv0ycqSVeG4g4QVMOUagOL3RPEQWbxjgJEHSGs9MKbMt54RF8rKqCKzFyU5OE+TZ/sXd91fK7DNeLtrs2kT9n4fsyn0sZgDVr8k6zk9f1bAiT6Ow+vNDPPoonFA1PI2G7BHRhW7fVTMix7qBwqZ68NigUQlWCPESNjkK1uImshPSGDu6wDwZ71/rB5HfYHR3M6QpCAnt+hl3zSHGHPTQLzOLdd+HO8Vc7Ue2uRzLWqjSY2dEE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(31686004)(6486002)(6512007)(31696002)(83380400001)(44832011)(316002)(508600001)(8936002)(8676002)(4326008)(66946007)(66476007)(66556008)(36756003)(5660300002)(15650500001)(53546011)(186003)(38100700002)(86362001)(26005)(2616005)(6666004)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVU0d3plblNDTWxFVld0QVdWWHhNeitvS1VKdDVRWUlKenFocThGNllsdzRX?=
 =?utf-8?B?K1dURmZNNG81ay9jT3ZqTjc1L29sOGtWOHJxYVJSRFczVFZmRE1ES0lIb3hE?=
 =?utf-8?B?MUt2ZjlKVnlYNk1pU2tkdGtLeGtKdzBZVXdvTTlOOEIrVldZWUxvVEdQcFYw?=
 =?utf-8?B?Ny9hRjVvaVY1RUNjY2wzUVhrZENnRDg5bXQzV2lDZldHNkIvaERoMDh2QlhW?=
 =?utf-8?B?S0NVM2o3WEN2ZFlwdlBIR3NPK1FqNmlrQWFLTlprWDlSZ2NtYUU4VSsvdEUx?=
 =?utf-8?B?MTdjRDJwMlkrSnBRbXR0NWI2ZnJqemwxU2NhU0JJNll5aVJ3bzAyYk9hUXlu?=
 =?utf-8?B?bktUc3FzWjNsQ0hDZ0RXMVlGQitPSFgwSjREc1RRcXR5czE4cmMxSkU4em96?=
 =?utf-8?B?Q1Y5U3YxZk1TWVByVUhLYmg0aXRWRUhMbm14bmkzbmFmdC85TjFnVndOT2dV?=
 =?utf-8?B?RHFrbWNVbit3c0EwbUJrWk1MMm9YU1dLU0wzbjRuV2dTanhaVyt2ZkxlL0NC?=
 =?utf-8?B?eDJHZjQ5bkw0VHJVT2lTc3l3L3ppZUUrY1Nnc2hYS1phaG4zMmhpZEVQaXNt?=
 =?utf-8?B?OGlVYTJDdVVOVVUyTjlkaUkvWVVmeElncFE2UXdyYU5TaTY5eFlLTHV6dWo0?=
 =?utf-8?B?bEs4L24zQXEzbW1Id2xsOWxoTWl5VTlwTDE5NjQ2WnlGQ1NoTVBxUzNEelVj?=
 =?utf-8?B?RUhMdFV5MzBMSGFnWkV6TFNsdnZhdzlxTFFnYWgvQTkrMEdvR08vcVZ1Yk5j?=
 =?utf-8?B?MDhQN1hPVWRlNnRURTdEOHRPeFZiSjJyNzBZZDR0U0g2RGo0eXFxM3l5YzN5?=
 =?utf-8?B?UGg4VnR4Z09rRFBtd1JxY2ZqSlVkeGUzM0REVGZxQ3BZRWFkY3BZNzEya2sw?=
 =?utf-8?B?dFFPaitWam90a2lQSDEvTHpGK0pUZ2pQeGJjR0VOaTU1VTVha1pYK0dNQUtK?=
 =?utf-8?B?WitxMUtXajZRR285MmlQQ0gxb1R6enhNQXF4VWZjY2VxRjJ3VnJpSTJ4djRE?=
 =?utf-8?B?aG1TbDliLzlHc0ExdGdUc1RQTDN4SG1UeGYyQnV4d2RidHc3dGtjS3pKa2s0?=
 =?utf-8?B?U1NtSUFuaVQwcmRkK2R1a0FPam11T1NUUUdhNWY5eVRHbjkrdS9qT212QUZn?=
 =?utf-8?B?bktnU1hHYUdEWURTcWt1UEdZdWpYL2laSmVib0FPanVWNWFUTXM1dHdxUHha?=
 =?utf-8?B?WEVLbUhSWlIzR21hc0lRMThQL2QvV04zMEpEUDQ5ekQ4VXpOSkRaSE5qZVBz?=
 =?utf-8?B?Wmt6a0JITjR0ZHBLUWlrNUp6M1VRT2F5SElVbjU2TWI5R0VTSkV4bEpzdWtr?=
 =?utf-8?B?VHZoRmZSTVRxaE1aQWpnZllrNVlYUDFjSksxdXp6VjRFWUcxNDM0RGlzM1Vq?=
 =?utf-8?B?dlUwM2toMTRQeTFmYzZWUGlDQTJ2UDBqb3gvdHU2dVZhNmJSdmZSYW1teTZ1?=
 =?utf-8?B?bXU3V056Z1lwM2tRRC9NbXhESDRqNlpWZ0Y5RmNRRG9KRlpMYXlLV0w5SVhO?=
 =?utf-8?B?anh3QnE0VVpkL1dXSjdNYVBzNW5KZHl3OTg2dUxhQzRmMzBDb21YWlAyTFgw?=
 =?utf-8?B?cW9JOHBzOUh5MEF6Z1dYV25hSVBBRktoeWNWWDgyaXJxMW9LTjJXZC9vejRK?=
 =?utf-8?B?ZFBDaFFBR0ZONnlvQS9QZHJ2dGwyWFRoV3VjN1c5WVdPaGJ2bzRnOGFURXhy?=
 =?utf-8?B?Nmd3T0R6ek1PbVJFcU9USUQ2NVpES3RaZkwwMjBkU3YwaTF4bDRYVGdCeGI0?=
 =?utf-8?B?V0pGWDN3OCt2aHRyT00vaGxZdlE4NW5yRFVtaG5GdG8xeDUrOHpZclZpOHZt?=
 =?utf-8?B?ZXNMQjVTaVFyL2NLb2lhZjl6RlN1MjltVVl4cjBCc0FuRHdNbjVFeFVpVGpp?=
 =?utf-8?B?c0tCVldxMStOaHkxZytOSTBEQ0E1QjByeGZzTk5PUWFIQlFWSkpKczhMREd5?=
 =?utf-8?B?RFR6bTB4TDcyb2I3NmwwdzdZTmUxWXlZV1VNQXFKKzIvWWdDNnhuQnlyVk5z?=
 =?utf-8?B?RTh6aGtGcTNoYkJsVHdHUDZLK2xFRTZJRmlOcGxCQWswKzlsNnV6dHhmU2RT?=
 =?utf-8?B?V25XeDE0cFhDTm85YWF1QjhRdlNHWHdweGFQdzZDN3ZsOCtwWXdVOFZISDVS?=
 =?utf-8?B?K3NUdmJSSXorSEQzeDBSVE12bWlGdlZVTUw2M1RZSkZnK2szSCtmZ1VTRVhx?=
 =?utf-8?Q?bvsXHy0+eSyu0RwkdTyUj0o=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b8b5c9-62de-4084-70b6-08d9fd23e744
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:41:30.0027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: duIoBoNFvY0sPGF7OYaAZzf4hHsx1tMqIwIpn2CI+XLzD7prE9eU0JiFyuvRFGIDJ2rSDDHjXVPfZNofI9p0Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 2/25/22 12:35 AM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> In x2APIC mode, ICRH contains 32-bit destination APIC ID.
>> So, update the avic_kick_target_vcpus() accordingly.
>>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 60f30e48d816..215d8a7dbc1d 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -307,10 +307,16 @@ void avic_ring_doorbell(struct kvm_vcpu *vcpu)
>>   }
>>   
>>   static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>> -				   u32 icrl, u32 icrh)
>> +				   u32 icrl, u32 icrh, bool x2apic_enabled)
>>   {
>>   	struct kvm_vcpu *vcpu;
>>   	unsigned long i;
>> +	u32 dest;
>> +
>> +	if (x2apic_enabled)
>> +		dest = icrh;
>> +	else
>> +		dest = GET_APIC_DEST_FIELD(icrh);
> 
> Just use 'apic_x2apic_mode(apic)', no need for x2apic_enabled parameter
> as I said in patch 6.
> 
> Also maybe rename GET_APIC_DEST_FIELD to GET_XAPIC_DEST_FIELD or something as it is
> wrong for x2apic.

I'll send a separate patch to rename the macros as you suggested.

Regards,
Suravee
