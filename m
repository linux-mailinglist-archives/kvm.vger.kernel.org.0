Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86269FE8F
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 23:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbjBVWgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 17:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbjBVWf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 17:35:58 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348E143463;
        Wed, 22 Feb 2023 14:35:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaU7AVanvM9J4+jjhMeJLVcC/xpaqmQBtZqUcBeyNyj9DUJ3kdjvkLveHpxd6hTZ59BBi3mNBFoJHP8HASlF5lgzKDHsX5atz2KUwYsHIAycmufXO9Ulo3uyiJCBNrH2BtK4fCVqV3uqz5U+kVdaHsQ0eatMPmBOttc7amzdhKXGKtgNud6AhrXlf4RpJfvhnEFD/2tBJe/5dDcjub9aVshW34vQhl7mqsNK+eErGTcGMubOIMnD87j+384cl6elyM1r90R5+qTI5hYsUoXHXq1Oxj+uR7cOVogUnNt59LTXVDSn/DylRenPeRZjbduoIuGaoRQUU5IDltZbrJgVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sp+KGH/IwsCClbV7yKuf0/Wi1L+N1NzaMTt/xUlh9UE=;
 b=D77PgrBRGu8D82MDFXd83VuLnfHAQr24cMCD8rcsS+IqUZPTKP6vk5mnAmCdMu6kuhHKN1jAsBsOfuJrx9W9Hko9Ll5+ZQG4cCxYOLWTJ9C54ogS1k0U2oLpTHvLGDbSFyFBg8pOGK6cu10HohveUP10FiaTQCmuiZTTFLNiUVIPeTcW8qsk/o/2oltwGsMGPjx5MJphlEc7Vg3SD5biDf3+eRO0iMQse8Nqm7aXTMDE1jd4CBHcIWhSNOd7Dg4f7ptLUUe7Ds/z2mHPJKdrwa3S4IQ+0fvehmN7A7XLT0yN37WAP9MIjjCdYFPFjRnRv9Xv+ICCvjuhqhiH6iLi4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sp+KGH/IwsCClbV7yKuf0/Wi1L+N1NzaMTt/xUlh9UE=;
 b=ifzPtqvT/w1FssNQ9GX6YZKbse1nhCE9MUGbk/61cj1POFe7n0NodLxYowpPXD1X9k1JA2iORKYtt6PzAGYX/tntI71NJW5JDOR+x8z5tm4dX52sbTGr8PGPhUPvdKXqac3ZRgPsAIuDPDaOitwX+ip4I4Q3uSYR+gLvkE7JS3M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BY5PR12MB4997.namprd12.prod.outlook.com (2603:10b6:a03:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 22:35:50 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 22:35:50 +0000
Message-ID: <8462a7e8-f021-6b55-75b4-5dbdaf013897@amd.com>
Date:   Wed, 22 Feb 2023 16:35:43 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v8 28/56] crypto: ccp: Provide APIs to query extended
 attestation report
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-29-michael.roth@amd.com>
 <20230222222421.00001a62@gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20230222222421.00001a62@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0084.namprd04.prod.outlook.com
 (2603:10b6:610:74::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BY5PR12MB4997:EE_
X-MS-Office365-Filtering-Correlation-Id: b796c80e-9202-48fa-a8e3-08db152525db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Mlpt6mt7zen3oDVrOXUJJ6cCIIMUSMrAUUM9lTHKQkqkFovFdDKAqqsNE1Zz2J587g3Dilfnos18gW/uwBngOfCZMczXTG8CLKxzaO74L4XhP3XE4lpaZwJRhRr57o8cAQZWL/wGNs9dyfCB88El2J+9X6690Q51jUcU8JwGrc6xr/FkrXDcA0DT0kxlWqjI+f4dfgxiQ1lcHSDQ5tBDjv1XgS0q+0vy/XQRIDo5CwEf+aWLZSiS1CIGI0qmykaVnEuYSyIpL6Ll7hnIfJfIBSmp2iMOWNh3A+NrLereJhGF6JV1fPLEU4vCTk/DjxhW8chz6z7Ltc6npQyPW1+QyazBNI6Ab7sfEB7hi2X2815OJf/VXx878+NeKrGEbhJsv+1BB5dKA/gW3c2T4R885nSdHYWoPAdv0XBb/oIax2IU2IA+tVzKTisAaO+yWfW+v9cD+uepPLDBAH74Q3cd05jbaJZDh4oeWtr4q5N3wO/+nbNuNAGrRnK7K8N49rGvwmi6n5ngnMa+IVAoR2arkkI7gya+STtkvez6HYryLByGEhDynPZZvtgQ/xumzrjNsR3NYLsHm0Rmayad2ZB5Ive14WjZfu8a+YRz4/unpTo49elI567lg9W5cnJT5ZHALVjXzzQNKMPoOolNWJt+1Ru+HzvK9JGc8vymgqo01gI8PLlsM/hTMQvSQnI4NWRdnfX+q3eEGygI3TZvM58RskHUAzfP0JqJlrnVtm61yKv4nISYVtXxA2WN7dopuS3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(66556008)(31686004)(5660300002)(8936002)(38100700002)(7416002)(2906002)(41300700001)(7406005)(66476007)(66946007)(478600001)(2616005)(86362001)(966005)(6486002)(8676002)(4326008)(316002)(110136005)(6636002)(36756003)(53546011)(26005)(6666004)(6512007)(83380400001)(186003)(6506007)(31696002)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WElyMElZNUNwTTZ1T3FuQVVqSll2MW9yalRQYkViM2ZDa25qSWhyVzdtNUYr?=
 =?utf-8?B?RTVYbysyNGszSFBPTmxJMVRKL2N6RHNsTHhnMmlnUU9sK05aWFBaVmdxdGtp?=
 =?utf-8?B?TnJxbXJtRnlGVWRyc0tCSlJpdDNtOXVpMGUyOGRKQ0JEUjl1SjFvOVlSOWt2?=
 =?utf-8?B?dlJnTlVkeVU1cmVrL1FaS0xyOTErMVN0R2pwY3B6SnUrTkQ3TTRoTDdra1Ro?=
 =?utf-8?B?VFUwM1ZITUxsZmNubm9RWVZlTlM4bGhDTlpWY1JPTWhLc1RJY0hFRWRHaVhQ?=
 =?utf-8?B?RnVPRjZsN1o0c1dkTzRpK0hFcDYrMXJlN1R6VlNVTXhSNVZNZ3BPSXFsS1px?=
 =?utf-8?B?U3VSclBqc1htSmQxbkV6T0ppOTdzQXZlTEVLT2xwUk5IVkVGY1lnUWkvWjVq?=
 =?utf-8?B?UWxhK215WWFDdnpRbEFKV282bEdSWk9QZzRGNFpmWWlQYm9MbmlMakVXa1JY?=
 =?utf-8?B?RnNQYUdDc2FQK0xMSXNyVW9NM05PUlBuQy9IRjE2Q0FObEtsYjA1OEtDYVVa?=
 =?utf-8?B?ZVpuN2tqNVlDMVB1S2laRVRVQk9wUFoxbkRSTjZURy9yRHI4bkFxaXlXNmpR?=
 =?utf-8?B?NmZocGRYMnFJYlZhRFEzSW1vQVVuQXZna1o3QnFMeUdQd0dKMDRmWmpaVTE5?=
 =?utf-8?B?STI4SE5TRGF2dnByUzkxYzJwelhZMzMxaXZDM1RCVi90MkRpM1VHNHF2c3Jw?=
 =?utf-8?B?dHZOZ1dhUEJBVUdyY21kbWwrMUh0K1RJd3F6dGU0RkZLVWphTFkzNFRrU2U4?=
 =?utf-8?B?ck8vOWNFOFNDWUZqOEpQZVBxU1NVTFlUQjJhVUJNcnBldTQrSVRFYllocDZE?=
 =?utf-8?B?QmxaZ2pDUndFMG05MUhVc05DWDR0RXJEQ0ZVTWNVUUVnRzJpQkpkc2lHMjNB?=
 =?utf-8?B?bnEvM2JFM3J0Q0ROOEhBRERycWhBeDBSeFUwNzRGQlVtSitxcUVhalB3M3N5?=
 =?utf-8?B?cEtPd0pRTDVCdlcwa01SRjBpbStYMmZZSVllenJnMXBudFh0WHc0UlFrc2k0?=
 =?utf-8?B?TUI2cFdVTlNhVGZmRlh5RHl3bTF0UnhPV1pyK1NYSVVibHJKWkRKZTlSQ1U2?=
 =?utf-8?B?K2xOVDNuNTMyWTZ0N0pzcnE4dW40YUtiUFBpTGxWWjV6RE9GS2xzTFF4OGtK?=
 =?utf-8?B?ZHZtc1BFMmhsNExQVjR1SDAxdXdtN2doOVg3amJZSVp2bVUvZXVyOVp0VEdl?=
 =?utf-8?B?WU5yemJDWWx4WDVXN1hFSEhaNDMzRDlGS2gzYVlvSjR4UUJqdzdGQjdZV05q?=
 =?utf-8?B?Q1FDbTdONERvNmwzZmk2SE9NaFJmbVRZSktHSkpwUEVPaXBkRlp0ZG9aa0dm?=
 =?utf-8?B?MFhmYUpWTjhKR2dnNDlUTVNuWEc5cWhjUUF0Rm93bFR4N0dlK1JsQmhMZytI?=
 =?utf-8?B?TWNMajYxTERVVEM1YlhaQkFwR0JYZjZ3c1hiaUl6Znp3aGdnV1lqak1xeE0v?=
 =?utf-8?B?SE80WVRzWjB3cElJc1RZeWZBR3JBUlYrZkNxR1pZaEhkU1ZJamNjN1RDOGhZ?=
 =?utf-8?B?djhWQmQzN2Y1anZEOUxwOFVUeWk0UGo2RjY1K21wclkzeVFScThCMlVxSTJw?=
 =?utf-8?B?RUtaeklBMlp4Nkp3bHNwMGxyR2kxVE1mMlVzSGJzcVV5dXY2cnUxM2lTUEEy?=
 =?utf-8?B?d0ZGMmFlOTJBbkZ3dGd1RzNweWZ1d3cxOUtNT2xxSWIwVmJaVnprRkZlN2lL?=
 =?utf-8?B?andoNHh2QTQxVTk1Qks2Wk1mbUQrcG5meGpRTjlFK3Y0a3RwM0ZUT3ZqaE4x?=
 =?utf-8?B?ZVlZeksrVytXU1RUWGxtVGIxdUpLZU1NRHRFUGM4dHMvelVyRzhCMXQwek11?=
 =?utf-8?B?bU1JUDM1cE1HUkRnSEtpdVNYMzgyc3BCT2p5RW5tbHBkWDVyYlhkQWtzNDVm?=
 =?utf-8?B?bzQ3T0J5K3BpbHQwUzlKTmVGTUx0djNGeXExUnJUOXpIVmhSR1JVNFV1QWhr?=
 =?utf-8?B?TDJYa1kzTGozSDVWMloyK2lOcG81RWhuQWwyM0RETDRGR0R2Q1BPY3E2c0ln?=
 =?utf-8?B?T0cvSjJqSHNFMTdQYkh5Mm8vcWxsd2pzOTRzdWpLczJyb2xBaGwrMVpGUTlp?=
 =?utf-8?B?c3ZzbHVjbnJpU2J3bHh2ZkFKL2ZONjdxKzVHN1pwQ2tnbTVndGt5QWEyc2JX?=
 =?utf-8?Q?Uxvaf33i0Egcg0iKNZik8ES9s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b796c80e-9202-48fa-a8e3-08db152525db
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 22:35:49.9464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLh36W/HOhnnHYjC2wjQEVIYXDY7k5A7nmhZPr4ju8pcojRytHCVS31f5cYRQEdPgzhEZWgkhAp6NliWX5xcJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4997
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/2023 2:24 PM, Zhi Wang wrote:
> On Mon, 20 Feb 2023 12:38:19 -0600
> Michael Roth <michael.roth@amd.com> wrote:
> 
> It seems in the discussion:
> https://lore.kernel.org/lkml/f18fae8b-a928-cd82-e0b3-eac62ad3e106@amd.com/,
> this API is going to be removed. Will that fix land in this patch series or not?
> If not, It would be better to mention it in the comment message of this one
> or patch 45.
> If yes, I guess this patch is not needed.
> 

This API is definitely not going to be removed.

There will be some fixes and optimizations added to the API 
implementation (as per the discussions) and that will be included in v9.

Thanks,
Ashish

>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Version 2 of the GHCB specification defines VMGEXIT that is used to get
>> the extended attestation report. The extended attestation report includes
>> the certificate blobs provided through the SNP_SET_EXT_CONFIG.
>>
>> The snp_guest_ext_guest_request() will be used by the hypervisor to get
>> the extended attestation report. See the GHCB specification for more
>> details.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
>>   include/linux/psp-sev.h      | 33 +++++++++++++++++++++++++
>>   2 files changed, 80 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index b56b00ca2cd4..e65563bc8298 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -2017,6 +2017,53 @@ int sev_guest_df_flush(int *error)
>>   }
>>   EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>>   
>> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> +				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
>> +{
>> +	unsigned long expected_npages;
>> +	struct sev_device *sev;
>> +	int rc;
>> +
>> +	if (!psp_master || !psp_master->sev_data)
>> +		return -ENODEV;
>> +
>> +	sev = psp_master->sev_data;
>> +
>> +	if (!sev->snp_initialized)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&sev->snp_certs_lock);
>> +	/*
>> +	 * Check if there is enough space to copy the certificate chain. Otherwise
>> +	 * return ERROR code defined in the GHCB specification.
>> +	 */
>> +	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
>> +	if (*npages < expected_npages) {
>> +		*npages = expected_npages;
>> +		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
>> +		mutex_unlock(&sev->snp_certs_lock);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);
>> +	if (rc) {
>> +		mutex_unlock(&sev->snp_certs_lock);
>> +		return rc;
>> +	}
>> +
>> +	/* Copy the certificate blob */
>> +	if (sev->snp_certs_data) {
>> +		*npages = expected_npages;
>> +		memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
>> +	} else {
>> +		*npages = 0;
>> +	}
>> +
>> +	mutex_unlock(&sev->snp_certs_lock);
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
>> +
>>   static void sev_exit(struct kref *ref)
>>   {
>>   	misc_deregister(&misc_dev->misc);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index d19744807471..81bafc049eca 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -931,6 +931,32 @@ void snp_free_firmware_page(void *addr);
>>    */
>>   void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
>>   
>> +/**
>> + * snp_guest_ext_guest_request - perform the SNP extended guest request command
>> + *  defined in the GHCB specification.
>> + *
>> + * @data: the input guest request structure
>> + * @vaddr: address where the certificate blob need to be copied.
>> + * @npages: number of pages for the certificate blob.
>> + *    If the specified page count is less than the certificate blob size, then the
>> + *    required page count is returned with error code defined in the GHCB spec.
>> + *    If the specified page count is more than the certificate blob size, then
>> + *    page count is updated to reflect the amount of valid data copied in the
>> + *    vaddr.
>> + *
>> + * @sev_ret: sev command return code
>> + *
>> + * Returns:
>> + * 0 if the sev successfully processed the command
>> + * -%ENODEV    if the sev device is not available
>> + * -%ENOTSUPP  if the sev does not support SEV
>> + * -%ETIMEDOUT if the sev command timed out
>> + * -%EIO       if the sev returned a non-zero return code
>> + */
>> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> +				unsigned long vaddr, unsigned long *npages,
>> +				unsigned long *error);
>> +
>>   #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>>   
>>   static inline int
>> @@ -968,6 +994,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>>   
>>   static inline void snp_free_firmware_page(void *addr) { }
>>   
>> +static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> +					      unsigned long vaddr, unsigned long *n,
>> +					      unsigned long *error)
>> +{
>> +	return -ENODEV;
>> +}
>> +
>>   #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>>   
>>   #endif	/* __PSP_SEV_H__ */
> 
