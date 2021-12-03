Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A690467B80
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382057AbhLCQiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 11:38:25 -0500
Received: from mail-dm6nam11on2074.outbound.protection.outlook.com ([40.107.223.74]:8566
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1382027AbhLCQiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 11:38:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8I/xYWJztSY4dmiBdalN44kIHX8b5H5t8xPJwYb10Zu3N/zymYZUrZ/ltmpMaCHTrRWSpsV9CwZYQIXWwJoRRFJ4MgEpRgUEZEil5APtp5Ox30LikY4fI/SdgPiHd2IIKdswFV0OUcPse7nuz72GVLbgeNEgxlsRGVy/a7rcU/jeV34iUcFnXivsqCD6Z7klxv4HITiUOhGYWB+gqUUjUXFsoRn/hRQMMfM6iqFwbGlSJou4Zq1YFgMatXCSRD0eqW59VY26hWHSvTkFPLu+CsBDCO+ju7xec+LZXnrGvL+6iFUNFn9WP22EItHFROyVTJhxDgaeTwoBnCUxbWZKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4QXUT0Bv1j70jxI/9Fa2wAS5oEiTpBhhsLcr9ZRuiE=;
 b=R2jsUm1n+u/Uaq64TGjc3LZOSBG0oUm+GZyCWtX80TF8hGiodXsm0qA0mf6q/+ncjw8n1FMlzu++IDQ2OgfE6gx3r0Nzuv0Rt8CozttjlUdWpWqFQGbUM82hOsnagqLDJ4AgqEYuhMApcwvXwhmTNQVfkH9DS6HqH7MhiKLAEyKSxpsuAL2PwTg60eCNkQNKJ9TH3l+e+/PEjGHq9uWomGbFtQh2WP+nK0DfPv9lC6WBY0FqJ4WzVfSMT0ZrGXnX1R+lGEFgBFhDWqopuvI/wzP7l1t7Fl6929e21fn6Q2RoSg1pOEvasQ6074QoxQ1GX7P87fy43Ln0dPXrweucUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4QXUT0Bv1j70jxI/9Fa2wAS5oEiTpBhhsLcr9ZRuiE=;
 b=p4nG15eQj3HDycJrnVeTc+42oDYs61MXlQw60M/43kdJoxAmi1jqWdBDyEl4Dc2sKvfO2HILqUS/A5yNgrdEjJfnJRXgycSWh6bBPxWkMf+f1tyu7KcJ5BM+blC4ufuczG61DOI2e5kiGS4JLpQGWE3yRIoLEj+60okzhs5YsU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 3 Dec
 2021 16:34:59 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 16:34:59 +0000
Subject: Re: [PATCH v2 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, jon.grimm@amd.com
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
 <20211202235825.12562-4-suravee.suthikulpanit@amd.com>
 <7dd1e7d1510f17f1140b7174dd42fed752eefc38.camel@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6cc9848a-9f04-b923-453a-6dbe03b73e58@amd.com>
Date:   Fri, 3 Dec 2021 10:34:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <7dd1e7d1510f17f1140b7174dd42fed752eefc38.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0113.namprd04.prod.outlook.com
 (2603:10b6:806:122::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN7PR04CA0113.namprd04.prod.outlook.com (2603:10b6:806:122::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Fri, 3 Dec 2021 16:34:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 947d2ea4-6624-4dd2-c8a8-08d9b67ad8d4
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:
X-Microsoft-Antispam-PRVS: <DM6PR12MB556518822A7B3FFA1F823470EC6A9@DM6PR12MB5565.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9JCPEdmPiYP988/kuTPC1lyG8LP/wtslJhc1WeBt5OOtQRFUfC9EhrNvqs6Avtl9RBU1jhi+3sD/xVVmocvTKWLqdge4ZTMSp/fle3syqJGv+6o7R56eqYZlZoGBhduQ18/O6DemMJ11Q+e5r0ZQGILYPOqLKnbANUV4zxwSoqEHyUq1MDF9HE2+dTLAcTwS7tuuVDHuZWi2Exk/5AC7JREvFo3azkQ56CPc/vwp3aBqGmaeQXtgs2UBz+oarf9o62QYXUCwSK0RBPkmIxbGAVF191wBFZ6xWRgBlxslb7h/lY0PkYyWzWYMbRugxaWI/iE/DiMsfOBaU+AJdZEt25CoNz+PQ/H96I5f4hWBoSJjE95PeAMCsI4BkZBB7seCyZVpTBqAHFZuAyU6L184ehN7cjjFMdgLjp9PZ+LHjun89emq+or3xMgk3qAwOQUnBCzWBRD//foATQeiMgq1xC4QJZV6FM49thZqhpPkK4Fh0JI317OocgRQ/bkpft7ulPVy4AEfDmKo6aElOvtazOF1zwXS302E+1aQDvgSk+7g1cDvc8ssvw8/7Ea7m4WcqqHdiy2GvEja3AbIShCD2h8gLwkFh9uGo3/1FAqxUT87SzJ3v2F07gWgISahfspNrBUux8N3fi09teI1I3LtmewvzbDALXz11uRV57OJb7TqIGNA2pbVHIroaCoKikBBa1a1r7HDJ9FvXbRf0BT0QS6S74+SWZ5zjriO9+8zkLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(26005)(83380400001)(508600001)(66946007)(5660300002)(110136005)(6512007)(31696002)(86362001)(36756003)(186003)(4326008)(316002)(2616005)(2906002)(66476007)(8936002)(66556008)(31686004)(8676002)(6486002)(38100700002)(956004)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGIrbTZrVTFCTUx5aVVzL09nTytqUWUrbVJ2NFo5KzVSRDEwS01PVmp4c3hW?=
 =?utf-8?B?NXBQNTlHYk5IamYrYytjT3lSb090ZzFFa21vOVVsY0V1dGlyZzJ1L2gyaDJm?=
 =?utf-8?B?TlQyVVVJbjJHbDhsSmhWbmw1SUNZaXZoUEFXdktuT1lsR2s2WlZIdUJvdjRz?=
 =?utf-8?B?bXIwOHg2bk9DWU1NM0NpWFF6M1VSMkYzS1VjVGdZMVVyVEpHczRNeThuWVho?=
 =?utf-8?B?S3RRa1phSXg2NFFpMTFNc3lrOHVZNHQ4VUh1cU1KMTNHbjJVQVdCRmZOWitS?=
 =?utf-8?B?djFiMFNhLy8vdTFHS3lFL3ZMeE1uTG1JQ0xLUEN6UjEyL014SmtyUjhQUGgz?=
 =?utf-8?B?Nys5MzNyTG5QVjVCTGF2L3hTU0tNN2VFWk1GcHh1RzYramVVTmtobm9BVzBJ?=
 =?utf-8?B?UExlK1JhV0VnblBnZWxLaXdhSmJ5YUlBcGkzQmZTeElCa2RYQ0xPV2g5bFVi?=
 =?utf-8?B?bDg3UDFKUDdpWUY4M05Ca3R3aGxuckhjd1cvSy9yektHMnAzQldGaDZDQnY5?=
 =?utf-8?B?K0pOYnpGbmY1V21uSG03ZjYwcUM2UElJaExvMjBxemdxSHMxUnIxc01pOFNB?=
 =?utf-8?B?OHl0anhKZ2I4YWFHRlVueGhxTWRVYXQvcitwUC8zSnBvcTFpcEZ5UExsVEFp?=
 =?utf-8?B?Rm1KR2hqR1d5dXBKbVNnKzJhT3FVSnE4RnZvZURyemtyMVExYkxERW5XVTlN?=
 =?utf-8?B?MnQzTXE0ZGN2WGRML3VuV1hWL3ZGMlQ0KzhibkVMNFM1V0JKT3J6QnJaNWd2?=
 =?utf-8?B?ak1WVktYd255VXgrL3NnOEc3SE5BYVdwM00rSTlzTGZuUjVLT1RGQ2h2Y210?=
 =?utf-8?B?Znk2SzkzTnBGbkd2YzJzN3VOWUM1dm5kbTZ5bXI4MDg5SDBUcHIvSC83NGdV?=
 =?utf-8?B?NlFmcTllMnI3RnI1YmNiOGtwSlJQMUg4YmgxLzJxSlFXRXhlcTBFVzQ4WW95?=
 =?utf-8?B?S1UwR0ZPUjQ1VGNRdTBpanZsbzFsMkNTaXJTSUlqUGNnNVA3ZW4wM1J4Rjk1?=
 =?utf-8?B?UkY2Y1RBeEx6Z3pNUFBaT0RWRFA5Wmd2SjU0b0hYWEJndUVnUW9YWDdnRGRU?=
 =?utf-8?B?WEx5WlVJQVI0cFBiNzlGY1d1SVJaQUhUaG5HNjhEdHZyNlloZFlSamtDMVJo?=
 =?utf-8?B?OVBwWUttOWVUSG5hS1Qxb2FGWU8yQlJhR2Y2N0xVNXVGbXh2UjNHRU1oVCsx?=
 =?utf-8?B?RHMvaFdmTXBzYmRaa2JVSitYaWJoVG05eXlSU1BmRTU1NEptdGtVejZXcXVK?=
 =?utf-8?B?VndNVXY5cHdNbmhDczYwcjdCbUVtODJkVjNjbGdaOVVxTVorTHlkSjF6ZURj?=
 =?utf-8?B?NmhydkcvczBTYXJsSVVFaDMwYVM4c3Vob0hHdU9vSHk3RUlYbURwVjNYWHdI?=
 =?utf-8?B?bVBPWnFncHNJeFVYakJwWE5xeTM3UEk2eHRwbnpiLzRLYWx3RzhTMVVNY3dj?=
 =?utf-8?B?RGV3OXJFNHQ0b3NsTkhaOTkwdUNjU2F0ck51dGw4SmN1bU9xM3dhajlrZnNR?=
 =?utf-8?B?SlpOTGRoZmRMTmVjOEY5Z1U5bTlrS25OZDhyM1pVRTUyWW9rUXdZV1J2V3pp?=
 =?utf-8?B?ZG83OHBPNXlYMVhlZXB1K2xpQ1hXMjlUc291RjhVM0RSdzh5KzQ1QWxWK1BI?=
 =?utf-8?B?MnJDZllOaERsa0p6Z3lPbWU1UTBoMGlEK1NvMmU2OWtteWN0aGw1K0hjMTJp?=
 =?utf-8?B?YVdQVUE4UmFXaEgzcVBtKzZ4b2o1WU1YM2FibzBZVHhoY1hqUXlQc25Sak5U?=
 =?utf-8?B?WnhDZlJlc2dIclpUZWtvNm04S2ErUmpNdXpkM2tFZ1V2eW5ZWlVCejl5czR5?=
 =?utf-8?B?cW9iZUV5bFhGUDRFMnRVaDJIVzNRZW1OT3paOTBRUmU0c1VOSEhsOXZFRzNZ?=
 =?utf-8?B?dWdYNllTWjYveVhLeG5wNk1kU2psQXBJU0wwMkdINkFlRllwMDBPeDI0ZlJy?=
 =?utf-8?B?OWlWTW01SlVVak5BL05XWVA0bnMwSFM4cmlPQnk4UVJPcXdSWnhCT1F0UDFP?=
 =?utf-8?B?UjA4bytnNTZaeG0vTVA1YXJmWGV4OXlZQ0twS0E5MFowZmhvc1pybVR3NXRY?=
 =?utf-8?B?akRrSFpnUUU0Q2wzUHdveGJXOS9MS0JEY0Z5bjZWUHJBSzBOVEV4WFdRZ25L?=
 =?utf-8?B?cGt0SUl1dXJzNFFiZmdXN3R2SEMxRnFZWFFNWE9KNFlBS05IWjlVZCszK0Ja?=
 =?utf-8?Q?FdCy6qcJd7nhxYh2f54NeTk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947d2ea4-6624-4dd2-c8a8-08d9b67ad8d4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 16:34:59.1497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUDIwB30ZjqJGwnY42jS2rLBxAThQyjvBdjmUyEx0BQoEeSZ/0MaIj/ax91x53by4X5bS2dQqSiZjqjtxrH1Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5565
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 1:46 AM, Maxim Levitsky wrote:
> On Thu, 2021-12-02 at 17:58 -0600, Suravee Suthikulpanit wrote:

>> @@ -63,6 +64,7 @@
>>   static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>>   static u32 next_vm_id = 0;
>>   static bool next_vm_id_wrapped = 0;
>> +static u64 avic_host_physical_id_mask;
>>   static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
>>   
>>   /*
>> @@ -133,6 +135,20 @@ void avic_vm_destroy(struct kvm *kvm)
>>   	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
>>   }
>>   
>> +static void avic_init_host_physical_apicid_mask(void)
>> +{
>> +	if (!x2apic_mode) {
> Wonder why this is a exported  global variable and not function.
> Not the patch fault though.
>> +		/* If host is in xAPIC mode, default to only 8-bit mask. */
>> +		avic_host_physical_id_mask = 0xffULL;
>> +	} else {
>> +		u32 count = get_count_order(apic_get_max_phys_apicid());
>> +
>> +		avic_host_physical_id_mask = BIT(count) - 1;
> I think that there were some complains about using this macro and instead encouraged
> to use 1 << x directly, but I see it used already in other places in avic.c so I don't know.

And I think it should be BIT_ULL() since avic_host_physical_id_mask is a u64.

Thanks,
Tom

> 
