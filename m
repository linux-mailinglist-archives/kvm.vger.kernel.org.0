Return-Path: <kvm+bounces-367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B167DEC6D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76F63B212E4
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C185221;
	Thu,  2 Nov 2023 05:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="waBnpeah"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC134C90
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:42:12 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830112E;
	Wed,  1 Nov 2023 22:42:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVYMSh03tTDvaWP97yYWyNML35/kkd6lXFBzBTPkAfEm/8Zqaramx5TRUV+cgNH145+hVKZaqlqwHVSd5zkezgx/W/6QUTvcgMXO8i3ky068geazG33V5e3xu/HNSff4zktvBb7KmDMkOMtkazl40nixWVhZ/tjVujchHTmi8eofJWfYBAaefEDHCweyl7H7tA1XuStoIdjBDPjM/EWJH721K6rTkIgs0e8Fr3oZ1CfDSy/tiBkmfVO3TlP8v62ey8g/xwXyk3hivQrxw/Vd+/vwxxCWSJMYRkNS+tbczC5b8B8oGxj0VwKzVUyGd8o2hqrqKzrWhzgiu6Dx5/tTnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2I8pVVwdBVwl/20yanWRskVkmck5U6vfz+GIs/jU+0=;
 b=PyYv8NC3BZ8fXU7c41tfWmd9UDSvNMFU/j4DqgPdDFCwvDZw/GeKl1NT0qUrz3bkpPmKbiTs0alqqHe44ZkY0GvX3sVZDxa83eZDL0poQzqOYhmnlncm8nSuEZGzcyVoM8ufy2j9/waffX93j8TIUKjwOXjj769jcZk+Dxk4xjOzS82SD5mGt582/umYoQj3dWQQVM8QSUGMmzG1KIfquM/cMQGTI8JViilr5W7epDw4W8gNVnxk+RyzbDc0RZIpSi0DpJp43ZisGO+gKB99OQzkne6whzp4AGodtQL80ITkTu3ElLsUFKTYGWyHde2FE+YnGHNdm36QPn1tvCBzsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2I8pVVwdBVwl/20yanWRskVkmck5U6vfz+GIs/jU+0=;
 b=waBnpeahL41G6aDUr5ZxkrsF8llTbcn+EeQ2Flca/R1LWwY9ZZPMOLwBhwOdAGNaH/BEE5jNY9TQ7tYGSk3/pX/4uV/6orth+zJRNe6EppmHkTsH68ondrlpXMhXpIqu9oEY34Iigrm5+RwZL0agYL8S1+JlcerquiAUgsBWJao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BL1PR12MB5972.namprd12.prod.outlook.com (2603:10b6:208:39b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.28; Thu, 2 Nov 2023 05:42:03 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 05:42:03 +0000
Message-ID: <55de810b-66f9-49e3-8459-b7cac1532a0c@amd.com>
Date: Thu, 2 Nov 2023 11:11:52 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 09/14] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-10-nikunj@amd.com>
 <b5e71977-abf6-aa27-3a7b-37230b014724@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <b5e71977-abf6-aa27-3a7b-37230b014724@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0148.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BL1PR12MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 430ab452-0f97-498c-e9ad-08dbdb6670c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BadLFb/brRJWn47GuduR1tq1XmFMyCCA0IIhjqHl3KIQLQqSUCRQOzC3viyC5foFAjyALww8N9EYH+z3BkX4hTMfPkoCEaUmiyCgDIP54dNRIEOHbjWClQn+BT501XV6bqeqrXUcSfDFZ9PXxrJEhKd3QtVN9zReU+AM0Y5J5pQ1YC/VQ9UzhB683zlZ+f8eYZCIIg0Dxrzgu0IyA9GPhlRvYYGda7vfvYNeVDz5loOPMKewBUhR+k7mOXx4/L+Ov3nKs4OGzA8gJwWepdhDdtD11c5RUA40sdsLF1bAP3zm7CF17W9F5TwXbW60AQdImkhmLF/ikAio1f6gK+o2WOTr8ZspBKOqd7+hrg79b6rTlZnmXofB0lMAXUZddR9FXsuK5wUTjx0QmGGEKgSwTstLEm7kmdpHsL1cmfxSFWw5G5Gxl98Clfem+LuTTgVgwAdIW0huuYtc/9DBWLvUzh/oR8Yax04gtDkrRCnv0FUhtoBWajh4RFBZ/W3l4e3RR0RTdIKsQV5JyDPM9bXZg3jbRQ8+fulZaQxpjCdtY2dggxj7/JJKQTR5uq8DNXOvrJIEMoAL1WHJVo/nE+nyJRMHNpNbazCj3cKIjuZTg5sZ4xGvO/O6/mM01eSRru0QCeaWPOhWRAX3SgvUbnspoQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(346002)(39860400002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(110136005)(66476007)(5660300002)(31686004)(2906002)(41300700001)(478600001)(66556008)(6486002)(6512007)(6506007)(6666004)(53546011)(66946007)(4744005)(7416002)(26005)(2616005)(83380400001)(3450700001)(316002)(8936002)(4326008)(8676002)(38100700002)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFFhZSsvMmJjV1QxV2Fnb1Q1STlOUTBhNUs3VGU4MjFTRlBzZmtYSWlMK0tn?=
 =?utf-8?B?WmpUajZmd2ZoYTdZbk8vUzM4UEFZVFdpNTVpN0s3RmFWamQvM0JCdEpsK0hp?=
 =?utf-8?B?K2ZZUXUyeUNPK1laL0RDNFFucDhiRFgybU55cWVTTlNyQ2dERGV2MU81SW5E?=
 =?utf-8?B?NHQyTi9OUmlkVkpnTzBCS3lYYno5N2JTYVFoY1MxVWc3ZVBoNnV4ZFN3TWMv?=
 =?utf-8?B?SzYxSFJUSjJqaW5JUzFPL0pCeUgzVmpkZTE3alpDTThUZmlzUXlZNHpSY3d3?=
 =?utf-8?B?SVNIVVdnSnduRkFmZWl3eDJ5NHdvaXQydkFDeGR4eGZYV2lmQ1QxRFhmRHM3?=
 =?utf-8?B?WnBsaTEvd1hQaEpWVHdqbmp5ajRQVG1aT2VHQXhheWlBMWVtaDlmdTR3V1BW?=
 =?utf-8?B?dnBOZmxNZURIcDlsM1N4bmgvTDRmYzhSYWcwZytjY0NkOW9hQ3RsVWREYXNU?=
 =?utf-8?B?Y1ltVHp5ZEJ6VmVjSVZ6dndnSDlQMFJtM3duanVEUTM3V2NiTWZreFBhRU40?=
 =?utf-8?B?OGFHZVk5cEdMYnNhSFowdnhIWmNqUXJHc0JDU1R2dlJSbDcvQ3pWVFJQYmVx?=
 =?utf-8?B?SU50bVdQTVFCV1dodU9aaUZzZW93OTFUNWpROTJsRTM3eEJOdTIraWFUQ2k5?=
 =?utf-8?B?bTdCNHBQaExmcVN3UDE3ajZaWEtJalJqVEx0bVdPVEs5V1JVZ1YzK1ZZdFNQ?=
 =?utf-8?B?b01Dazl6TzFRbmxkOXVxbzJpeHZHOGQwWEh6ZThBYkRmbmI4Sk1YcUFqRCtk?=
 =?utf-8?B?T2pidW0rZCs3UTVZL0U2OHlmYkhJaEtLN3VjM05YQUVzdXI2WjhFdkhBdFRx?=
 =?utf-8?B?YVdMbEtGTHd0bUNLVEgwcTFTZXNDbC96bjNJK3V0Mjl6UHJXaVBlOStlN3k5?=
 =?utf-8?B?ZmUzbEMrMk4zMVU2VXVIMzVMRGtoWHRaYnNXN1JmdGNOK2tHT2dQTEp2OUtS?=
 =?utf-8?B?UWdFanVmeU1FN1FoRUl3SFdLQVhtMGhBTnEvWXZzVTZzVnc2MGRaeE56bzBx?=
 =?utf-8?B?RzhCL2hoZ1dOK01uZDJFQXJZL3loNVBldGtWdW12Nzc5c09RRnF0emYyUmR3?=
 =?utf-8?B?NU9kTEU2Z2NydkhrL0Y2QUp2QW16WFJ6ZlluVnhkZm9nS2JWK2lQYVRGMkZt?=
 =?utf-8?B?YndPY0VxdHM3clRyWGkxbFpsamFzU3FEY1hWZXFZeGp2ZHNnWjBkSWJneUQ3?=
 =?utf-8?B?blpLUjFlalBHTU5YekliajVXZ0hiMXR1ZmpjQkFSanc0cytIVjdGdkgySytx?=
 =?utf-8?B?ZFZXdlp4Yy9FNXlTRnVJMG4rQ1BBRkd2cnl6Rk5GZEI5RkhQWkwwbGliOW00?=
 =?utf-8?B?eFB2RmVFSHpvZ3NURGtLVlR2NzdMVysyMTkrQlZteURWaU10T3NnRm9VVEUx?=
 =?utf-8?B?bGxTbUxzaldOVXE5eDJNRDZ5cEhqTUNDc3B3UitoZWxDeHJMNkFFRjcrN2ZE?=
 =?utf-8?B?bjB3SjB6ektOaUhKZi84UWw5bVZRQlNlS1dBNEEwUnBrV0pETk55UkVrcnN5?=
 =?utf-8?B?MGo5UnBWQ2o4bDVjTmprOHpSWldMY0RvcXc0YTN0cFdIT0NmV2J5MGdwaVI4?=
 =?utf-8?B?eHhrQ05CSVBWQ05Vall4Y25ySHRaODdwVlptUmhxMDVqcjlYM2cwU1Ezb2Jy?=
 =?utf-8?B?bmpPd2RCOXIyY25YNG96NlFoYm85YUN1MEZOdmRhTVg5ZkRIRVVWUnp1b2ho?=
 =?utf-8?B?eTBBa2Q0czczeGRjMzBzSmxOVmR6Vm55d2FBZmJUcXpLZmwrb05iak1jSXhi?=
 =?utf-8?B?Y05vZlQ2eks2Qit3MUgvTGRNN1lrQ3Y3WGJmemFEVWE3ZFJZUUM0RnErMTNv?=
 =?utf-8?B?TGtZZUZwZzgveVBJOWFUcFUxVGJkSkFLSjBKck1lWWhuclY3Si90c3lLb0po?=
 =?utf-8?B?c1FvWXRqbzNoNHZrNHgyNW9vb2lURXJCOGxSelpwUHRFNVVidFBNSmp4Zkd1?=
 =?utf-8?B?UWpjd1k4Y0QydlVmcmUxTFh2RHZKRkNaaU8zS3ZWZFJHT0UyMjFPM0tsODJB?=
 =?utf-8?B?eUFab0lzbTZndkFnY3lPMDdvdGFjYkJnTmlRemNwcHUzUjlZQ2p2T3FCYWF3?=
 =?utf-8?B?L2k1MEw3dUlCZnlvckpCOHFEcjJDVFhwS2dpM1RYdzZXVVRhcDhCRFU0RzQ1?=
 =?utf-8?Q?v5Y5LtIOcNA1JZcJ8ZTxilskt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430ab452-0f97-498c-e9ad-08dbdb6670c3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 05:42:03.1659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vpq1lNJnaJc8YXScw/ZSYn0QMdwB/3GGOoffAfJPJz0dTmZSHAbjalZIljZgDRaMqgichNQUsnE6QVuon+R0Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5972

On 10/31/2023 1:56 AM, Tom Lendacky wrote:
>> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
>> index cb0d6cd1c12f..e081ca4d5da2 100644
>> --- a/include/linux/cc_platform.h
>> +++ b/include/linux/cc_platform.h
>> @@ -90,6 +90,14 @@ enum cc_attr {
>>        * Examples include TDX Guest.
>>        */
>>       CC_ATTR_HOTPLUG_DISABLED,
>> +
>> +    /**
>> +     * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
>> +     *
>> +     * The platform/OS is running as a guest/virtual machine and actively
>> +     * using AMD SEV-SNP Secure TSC feature.
> 
> I think TDX also has a secure TSC like feature, so can this be generic?

Yes, we can do that. In SNP case SecureTSC is an optional feature, not sure if that is the case for TDX as well.

Kirill any inputs ?

> 
> Thanks,
> Tom
> 
>> +     */
>> +    CC_ATTR_GUEST_SECURE_TSC,
>>   };
>>     #ifdef CONFIG_ARCH_HAS_CC_PLATFORM 

Regards
Nikunj

