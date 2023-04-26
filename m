Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02B06EF9C4
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbjDZSC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 14:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbjDZSCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 14:02:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5017298;
        Wed, 26 Apr 2023 11:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAZ0+flcKIhuriArptHZSHIltRr/h+1GsO5Pqx3c6G47M9nTHiNGMZdjPoTZDIu6S3z5w3PDm0V2nUCOdIiPQQpbLyFyjUbATRxtrh5xpJNP4QHlxPlIYAAU3UQbO8AqdX1xSzRM5U9i6oahSU0pP0z2MscelCwGv+Pce4WLDF+lIZxnRHCgRFJ9rKRlACKHILFZdSYB5s9NNAH7ZftTeamQ8jZ7zOoKUmmSo6EVoXf2jN4yfWOeNxPucjJVdrXudu6ah2xYZDwnY1QskcVUZK5aHnEPTwdqxOBHz+B7jGLVQR7tWc6KE5k8JKyD42ZEx9XuDinpEGzZ7q+zjxN25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8e3FYcbl9lAbCZOhx6XG6uqENoByyXy8y13wYxrhkjI=;
 b=FY+G8S4OlGw0+HpQOnXkmOsIq7yxAF7bUnPOFrY9Bjoxt8N9readjGJzTcTEnSR2wQsOiV687Rpkkq+yHcb5xAsJTPftS7m4NXTVHClIxahMmyqHr3hg+5RfmD/spCYdZfJHyhM2Q/mjw1YiUh9PIphmQKaV4YXqW8KqTGHCOm3sNEmWvLJNkiFpnqidSOqsgBp/Q4ppXnqrAeVpmn6aGdeBAcxh/S9SXQGBn7cDkhpldrNOZKPZA1KxdkoAFRSc0X2kbgIyerEtXrnmveelLnlXTMRK/+QZaXo1PkwR/u7C+8g7eW2nJwOS+3gAzfCZTDd8cu0ZTMEUbFCCVHWjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e3FYcbl9lAbCZOhx6XG6uqENoByyXy8y13wYxrhkjI=;
 b=rfRIC9KOHxzh4WWSnLS2qLxqku+PheHO3ZGXWeGlz7IistE5EQZTxKxge7gB/19s4PL13PxZBDdZ27aX6eQRGT4yqJeA0eBcrQ5+QHxaBYD8gAn3/lJamgtn4rURYlejegaebyma+azaXUh6mnAKs7RvFN0bov3rUdKlyVx0YK8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 18:02:51 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ea32:baf8:cc85:9648]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ea32:baf8:cc85:9648%7]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 18:02:51 +0000
Message-ID: <629c89dd-4892-28c7-74ac-b3fcacb1550d@amd.com>
Date:   Wed, 26 Apr 2023 13:02:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RFC v8 34/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START
 command
Content-Language: en-US
To:     Sabin Rapan <sabrapan@amazon.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-35-michael.roth@amd.com>
 <f708da54-b99c-2ce8-f68f-6f3ba28ec2ff@amazon.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <f708da54-b99c-2ce8-f68f-6f3ba28ec2ff@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:805:de::42) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 623a9a2a-6915-4dd2-b3f8-08db4680739c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8n4FsamL1FlWUaZ2uIHp7La5BWXvrrkySl667sEmdUzpVy05SuzZJRqGywCUv5wipjxBATxqW+98HdKUNRWjNPepEuFOy/xAoggALeaBK1l86FMNeEdaK5ITwGk9eIw0GtPErbPl/k6DkS9lGa8+IKWkBaVgGT2FtXAsYPruobI6VFV51Ej41+fu0h1m+UOekO/UdC+UuHv54HHoy1CGBzAJqjmoCxqVjP0rI9OPeXegYK/QOGOfg+bG1Rm10x5/ZLlw1KRmzVEWjQKsXjy6jKKhLpSWJ8WjReiCgH57OFPwC+cTE+/TcOfs/8wsI9xROApNQTKDX1cSt3EZlcHIgMra9PWygWe/aswYqqk6GE5XhxkcNW00v8Bw7BxQhI7Bv5PUFCzlBya+AHFbbLU3VJDcmOXj5YFKIIbbdbxbb2T8NET0ZQryA9Y7GcJ4EL4cRQ3jf6ZSpWki5EbqdRrqz3F2LD22sIUeFGSJ/sbw/6mdrKEMg+rTrdTpPpKXz02vZcGn3dquD9ZAhGTFdrpwgQk9cXMy987KUfjYsdUZAvftaZv1vaJoYuV/OzXXgwxAVAZYEIuDs4i9rLpWYOV9k6XTYguCoqD48rRqEuqaSFklJ8g37srPV/rsArlE1nUqKB9dd4CvGwppgeGzduBuqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199021)(2616005)(31686004)(83380400001)(186003)(6512007)(26005)(6506007)(53546011)(316002)(86362001)(31696002)(4326008)(66476007)(38100700002)(66556008)(66946007)(2906002)(7406005)(41300700001)(478600001)(110136005)(5660300002)(6666004)(8676002)(6486002)(36756003)(8936002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjVDeFY3NldMMzZiWU1KbW5hanRnSjRjQzltTExVMkZXR2lkKzk0K0xGZnJv?=
 =?utf-8?B?NHl4SFhWSDBTMVFySmpYUnUrOWJwWjR5THpxbGVPQ0U3Skp6T09kL2Y2cmJj?=
 =?utf-8?B?dm1SRHpKSHBzVmlCOWk2SFVtYkZKYWJzcnBiTFBQT2VHMWlhSEUycEh6bE1t?=
 =?utf-8?B?emNWeWpnT3k0Zzl2SUZjUzFiUUFrZmZ0bkQ5SzJrbVZIV0s3dW1qVDhUSVBO?=
 =?utf-8?B?QjIxSW5mM3prNUlRcWFpTzBSd0h2ZU4raWVmY2NWdlpxdXpLWkU0VnAvTDdY?=
 =?utf-8?B?alhTTmxhQUx1aFR1RkJqMDI5VGljUzVhM2hVZHVYSnRYaTBnbEt4YjJiVVVV?=
 =?utf-8?B?ak0yZlpPS21ldHpiMmJDNnRPbzRycFFqWDJ1WHV2V010eE5HZkt3ZXJvQ0V3?=
 =?utf-8?B?UTBqeGV1dmpESTFsQXFHQzl6eXpWYXBmaEZmV0FNek81VG11K2JmdzB5MWcz?=
 =?utf-8?B?Snd6cEpSZ1lWQndHTndFbHZ0aHZ6VmZWeU1xOHJaRmluTE9JdEIvZGxhWnRU?=
 =?utf-8?B?c0xwVStWZkNsd3NJR2k1UnZCNmNSOWt6ZldzQnJmeHR4VHhGbXZnM1hQdHhz?=
 =?utf-8?B?czRrTXVDM0RML1RmdXV4ay94VFJqK0huakZEejBERlRnMHlGVjQySDRMK0Fw?=
 =?utf-8?B?eFhvUWI5SmIyUmdJWGp3YnFqbnI0RDZDZlovMFg3M1JuLzBHSzhHU3JTMGpP?=
 =?utf-8?B?R1drUTA0MjBJcWkzY0pXV2N4c3ROQW82emJ4Z0ZDZ0RadDkzbnM5SjFxR0tC?=
 =?utf-8?B?dm9STWxhNG1Md296YnBRdGV0ZVJlWDhLdDZyeUF3NS94VDhzV2IxdXFabHlL?=
 =?utf-8?B?WTk0NDZxaEVVQVIyQWJnRGZYQk9kdXFhRDhMQnYzcXY2QmRmS280TFFGSDl2?=
 =?utf-8?B?YlBFeldrbVpSWWFkekxPeVh0S2g5T2JELzlrTzlmYndDT1lUaktBRzhxQUFz?=
 =?utf-8?B?S1pCSzBrbnA4QVZUd1ArTmZubFlOdlZoa2pGVlh2Z2lCZzU5SGtoU3hWclpz?=
 =?utf-8?B?VThTYitnMEpoZ1hxRjFJeVRDenVNUGlZZDFtZnU0d0tMYnpBWmEyVG9sWG5W?=
 =?utf-8?B?bmNDMjgxZk9MVUZQakhVNlRodEpOcGtJVTBQZG1rVXNGY2dSdk40ZHpNL29X?=
 =?utf-8?B?SWZ4YVFkR0hacVlYakg3VVBiSVd5QXFRYWt5V1N2SndRNklaRzFLRW9LRUVS?=
 =?utf-8?B?ZDJkaG9HSlAvcU5CeVRDdjBHZW5qMGwxWllIZkZ3elpmSXVVOU1HNllnS3RU?=
 =?utf-8?B?L0h5V1VIMVFJblFGUjQzem5mNGJhVmVWeVBrd3BLQytycXNNZzAyZml1SHBW?=
 =?utf-8?B?RnBLZXN0a1NJSk5pbFhPUFU2MVRhREM1eEM4Z090MHZCSUQyeUR6bDExWjhI?=
 =?utf-8?B?cEdCSVh2QW52OG53b0pKWnR6c05mbHJLaHUxa3JxWnpXVUh1Y0dENERoNnRk?=
 =?utf-8?B?ZnNYYnVrL2ZqUEhBZFRwV0pRUHJLbzg5Z0FyMjkxTGhwd0xkZFA4Yk9iVDBu?=
 =?utf-8?B?aVorREg0ckhqTGFXcUZsUGZlOHNjN0NPUGVZaE10NnI4Q0lDekRrOGRZT2xj?=
 =?utf-8?B?NjE0QmdxMjFVQXROUitmd3NJdTA1U2d4aEJPWWt3cHpOMHdtei84TStqTUti?=
 =?utf-8?B?dWtFTGN0YmcydkQ5dHBwLy9aYmJQYzdNSUZjWmVhRHA1Wm9iTTVMOThpcU40?=
 =?utf-8?B?SmtFTkt5REJ6YThQZVBoem9LQnRMMVZVaEZnZEpKTGxkbldpY2k2OUdsSWc2?=
 =?utf-8?B?U2VYUGhSU05rdXpmZVh5ekl3SHZNRUdnMnJJUHhBUlk3eVMzb3VSSnBwU00v?=
 =?utf-8?B?SWE1NTg2SmE3S0t2ZWRPYlVoWm11YzhkUlhsMm9BMG5wRmVtd0pmRkUyYWRx?=
 =?utf-8?B?UDdIQUxPR2VzazFSdmhMb0VhY3grR016bUxLLzRhd05ucDhidkd6a25wYzhq?=
 =?utf-8?B?dGUvc2oxVGZhS0lXN1FTSExVcHQ5cWhZUTJmajNBUExjYzdVQXMrVUtLRkRO?=
 =?utf-8?B?Ykx4RmtUeE9QT1NJUzVFbVd1czUxd1FvbjNGRFBvZFhGM3Z0b2EyODRYdTRI?=
 =?utf-8?B?OVE5NnF0dmFrK1djb3pseERIc0lEQ0k1eE5VTEZ1ZmVXbjkwM1ppUlhYczZT?=
 =?utf-8?Q?52YTSOb6m2L+g4q3Ux5R+SBb+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623a9a2a-6915-4dd2-b3f8-08db4680739c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 18:02:51.4358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jo4+Jy0COOGm215ZjXtj0K0Y2V98+0zh3pXWyiv5hH1qwwwvZRbFIusChb8v9hBcdU8cFoorCPApgyn/2iCqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/23 12:06, Sabin Rapan wrote:
> On 20.02.2023 20:38, Michael Roth wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>>   
>> +static int snp_decommission_context(struct kvm *kvm)
>> +{
>> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> +	struct sev_data_snp_addr data = {};
>> +	int ret;
>> +
>> +	/* If context is not created then do nothing */
>> +	if (!sev->snp_context)
>> +		return 0;
>> +
>> +	data.gctx_paddr = __sme_pa(sev->snp_context);
>> +	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
>> +	if (WARN_ONCE(ret, "failed to release guest context"))
>> +		return ret;
>> +
>> +	/* free the context page now */
>> +	snp_free_firmware_page(sev->snp_context);
>> +	sev->snp_context = NULL;
>> +
>> +	return 0;
>> +}
>> +
> 
> Even though it's not documented, SNP_DECOMMISSION seems to clear the
> WBINVD indicator just like DEACTIVATE does for SEV.
> Won't ASID recycling race with SNP_DECOMMISSION if the latter isn't
> guarded with sev_deactivate_lock?

Good catch, yes, this needs to use the sev_deactivate_lock around the 
DECOMMISSION command.

Thanks,
Tom

> 
> 
>>   void sev_vm_destroy(struct kvm *kvm)
>>   {
>>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>> @@ -2333,7 +2440,15 @@ void sev_vm_destroy(struct kvm *kvm)
>>   		}
>>   	}
>>   
>> -	sev_unbind_asid(kvm, sev->handle);
>> +	if (sev_snp_guest(kvm)) {
>> +		if (snp_decommission_context(kvm)) {
>> +			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
>> +			return;
>> +		}
>> +	} else {
>> +		sev_unbind_asid(kvm, sev->handle);
>> +	}
>> +
>>   	sev_asid_free(sev);
>>   }
>>   
> 
> 
> 
> Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
