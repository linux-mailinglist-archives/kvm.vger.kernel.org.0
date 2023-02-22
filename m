Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DB169FEA8
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 23:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjBVWoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 17:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbjBVWoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 17:44:05 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF5F7298;
        Wed, 22 Feb 2023 14:44:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtpSlt+E9sr0UER+e6ROmVAzaiRSC96nM9aCv3sixNu5YornfIoiROeso5Fk0BR3hcof8ClwOJ3ePYTYOPuMDbQmNLW7FykMd50zbBL6aU7I/ZFN59u4zWBAJUICTJnn92/jradtjOIZD8al+9CYxDXncWtEW2qCfZBKh7Cr1I0l1g8UvPAtzDo4YAGtJu3YQqCTPtlXfWIyD8OkFis8KMpTjIbQVRU9/4SWnjA0FbHAVh+Fz6FZseoYvpVUySX8x6iI85S6mPaS+sL1L20NzOvxKWdpcAxqSVxuRLUjD23YkCWGQiWR3nYX6aovhvGkqgvQyXJnR4W2pK++2yDwNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hSyqaLBc2ysPdMHZPpBYOHtVqGQdKe0FG//lZrRf9Fs=;
 b=DPqTjLHXI2dfOZfkDF3w8j9bCgYT0mkix5e/mEQ9AmfdGwBM/JsNa/xYOeQKBlYHY7J+a6uFLjubz9tuuyKZxMP7etE/bJc4XuBzwNTYVd6TXC8Q4bzQ6EQxfMHeWHxiv0qmgzNaDceivB6vAQmLXOMxnqB3XaLEoVijVJj60Bus3awmYW4M9li7AEktO5nzS+IpAVu+1leTk3Eu2xTYvIMHJL71+EE4xSIzgUZD3VHXabtYUO2EjiLlRawe1Zs17jAqhUpL7ib542xmEB6b1uDS1/lXsKfeZyLRSntxLWZgzla6f7N34XT/RAJJLdOgIYT7GYtQL+/OCPt1i7FxAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSyqaLBc2ysPdMHZPpBYOHtVqGQdKe0FG//lZrRf9Fs=;
 b=fAlREwBptejUw89EpDHnIYWqglYi6bsilpEpq0DqPa0vLWP39X4MOR1S6Ph8eMx7NjjkYAbcYO3sMyV1Vg7ICaur5trcNo24SLgqiSi9BNcyyT3fxQHb53OM8cRypFgPJEDeLDvgn19Mim8BjVzDiRdKX1L/f+RV2fmTlblN9f4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 22:44:00 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 22:44:00 +0000
Message-ID: <c548c555-279e-4ec4-d51f-7f8cdd501010@amd.com>
Date:   Wed, 22 Feb 2023 16:43:54 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v8 27/56] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
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
 <20230220183847.59159-28-michael.roth@amd.com>
 <20230222143205.00007635@gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20230222143205.00007635@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:610:59::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM4PR12MB5311:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c7908d0-7a59-467b-8346-08db15264a50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kF1GoO9/F69sgvHaE9Qp65gXkPdmMMa3WHTQvrDbxUXIzNEAsOmDx6HPfapqKL3ReB6eUaCLDvsMA3HHHRWRwupXKCOGFt/BaLE31DeTk+nZd8YWOP3RxkSDkhVqwbsR6jOFYE3ot13nhZ6g+o+5NFlLnt5QChIHz/OgFHSOD5ywo0T8uHTQViijUm+BIoYRFSo+OSZiTL+GEd1nhLfzJ0YPQqxU+08zQwBR3N3Z6hvboSZ3/D0fj/UpIMrJr6oUGXvB+jDYjnwFimq+vSMjJVz+nyVjE/v9+ujMEyAnPjLaFxrO0wAinV8z0UFL8r8WrqAUdJMo0AQPmjQPqsIr+/SFw/3kMTlSHq3Fi9MIAiHJhwgUBAwT7Hw9AsOXEzRm0mYoR0Jm+4W1jlyTZvHqyZ5YWta9pOmHLy7ovtOqeZpONh3EnfvtRlHWE5cP2dOWAsurap1HpoaPYTpRFvqpGsW6anL8JrupG4URiy2C22S4b8ZxFxubTvD0Kze99Ugess0exbT1IJEuytwLRrFNGP+cWi+0U/tNaHMQ+QAzE8eLGZO9Jg/6hr5kmaPtNDUIWM88goSrXruqKMmuiNlqUQsVgLNmNGo3/FpCzzmX22lI1pVz+5ezbrqmA1d7OwPJjY6ZmaO+9IE2Yv+d7CjoIheF8hJtOcTWokr3JLyxLbLIMUOpnKW8UpxQrqD+YjopwR+HXHTh5cjth/KI2DZ/xoMLDgZoEXp01gKD/YLRy/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199018)(66946007)(31686004)(31696002)(86362001)(36756003)(2906002)(7406005)(5660300002)(41300700001)(8936002)(38100700002)(83380400001)(7416002)(6486002)(66556008)(110136005)(6636002)(8676002)(66476007)(53546011)(26005)(2616005)(186003)(478600001)(4326008)(6666004)(316002)(6512007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXNRU0xGRU1sRFRXVmFVNTBYaFg5VWJxeWp0TDZ2REtiaFpYRVBLYUZ5dHFV?=
 =?utf-8?B?MnR2TzhZV0VlTE5yQ0d5SnFMb243NlBwbW1EUzJBYkFSdUNPUnRoNEhGamFF?=
 =?utf-8?B?MEhBMnAyL0VHdTVheDRaRTNWWHJyd3YzcWdqRFoyNzI5YTVHczh5RG5NbDZJ?=
 =?utf-8?B?eWpoQ09memJpdDRadjUyUlRBcklrNmhoQzViWXVmL0E1bzc2NDVGYTBXMGJV?=
 =?utf-8?B?Zjc5UDJvNnRycnE2T1JYV1J6MkhHdUhMRllhanlSMlcxT1ZFT3k1TU9ZaXBG?=
 =?utf-8?B?RXFTQVpFSEh4eGJ1WHJ2emhDbktuTnNGeXdwZ3N2Z0hNUXluMnR3QXJmREdF?=
 =?utf-8?B?VnVEbWlTaXRjTmR4bzVLNGltUU9ReldSdXg3NENrSzJOY3YxT0hXSzhnc1Vp?=
 =?utf-8?B?WVdaZFF2K0NDUmUyK3pnS0pVWUpMaWthRHdhd2FyMjlObVhUNW4yMEs2MW9o?=
 =?utf-8?B?VzEyRnlOZmNjdXFlblZyS01zUDllWGkwbUhEV2l2ci9ZM1prc2o3MVhpajBL?=
 =?utf-8?B?V0R3OWJIalRXYWIvK2ppb3JTZ1JZTjhwTjM1MW1OZHEzVzNnQmdhNnlYTjlm?=
 =?utf-8?B?RDhmU1B0WktDWWRyZ1JML2pDMFpBVWFaSEpzSUdYaEZTU1FKTVZ0bFY4Qm5s?=
 =?utf-8?B?RHdoRE1hKzVoVnVJd3gxVlVuekN1a0pvZVZoZkQzR0U4ckVnU1NjWTB0dVNE?=
 =?utf-8?B?VzFQeWxvVkRvYzJoMXQ5ZHRtcndIR1hBNEFaZXArUmNVQ1UzTXFGOFJZNzNE?=
 =?utf-8?B?SEFkWCtxUmQzY0wxMENaWERDbEZkWXYwT29hbUdtSktETHEwdUFzQzlBSXFv?=
 =?utf-8?B?M0xSNUZ3VzJaZE9uRElRYUd4WS9jKzRSWVZOTjZuL1E5WVNjREJLOWhlNVI4?=
 =?utf-8?B?SHExa25qVDJINFZVTi9XWnNOZ25aTldWOStBVWtiYjBTR1VnaUFtbjZyQW1Y?=
 =?utf-8?B?Z3N6ZU1wellxNHZ6aDluWWdxczhkV0lZK0xTb1NYOEhybThrTlNMUHM1WU0v?=
 =?utf-8?B?djVQRGJTakVqNCtXYSswK3Nra25uMGloOUQ5bFBiOVd6L0NEWEE4WXZWcTkx?=
 =?utf-8?B?VWtIWnZYeXhoUmtHQTZVZWhLb0lUd2VONmZYY2tCOGVwYUt0OW5hMUtMQ3Nt?=
 =?utf-8?B?bDd4UXFFSjFtL3FFT0YvTXB5N1FiNUM3MXlwdDV1RlI2dVIwaXk1V05qcmJl?=
 =?utf-8?B?YmdvK1d5Z2c1U3pNS1RJRzdNVmE5am5MdGo5b2lScWlaOHMzUzlaY3l1Yk1w?=
 =?utf-8?B?SzU4RGF2akloanpHMTUwbWFTSlBaeml4Wk5XVmM2bSsxWWVQNm1Ubkl3N3ly?=
 =?utf-8?B?ZGNOWU9zL1hjYlhNWDZreUJkRDRCUG1YazVYSW43SWw0TUVxR252U1VHeFd1?=
 =?utf-8?B?OVY5UVo4UzMwT1pnT0hocWJOdVhTelVaOXYzTnA1WlNJSFk1SXlwY2E4Vldw?=
 =?utf-8?B?cFgwSUJvWVR6L0kzajVXdnhEd0ZEY0YweE01VE9Fd0NGaUFkSGNyLzAxZVB4?=
 =?utf-8?B?TjJ4Y21FL1VyakcybUs0NENKUTMvZ3pPcDV4RFVGb1RQT2VrQzdya29IVDVR?=
 =?utf-8?B?UzNxL3pEVDJrU3JwZTkxODFWSjdvMkNQK0xUUnBFQW5sSmtKejRwUmU2YURJ?=
 =?utf-8?B?UzRUZTZNNThkZFVZSWhUREIzdGRPZnVzN2Y1WWVYMzRFQ2p2bmI2bHNGVmxE?=
 =?utf-8?B?N25wZ0hWWElodTNyQUpQY3U3cElDUksvOTAwZy9tSzYwaXRiczFpdHk2ZlhG?=
 =?utf-8?B?dlpNcFdYZ3dvWklOMy9FR2UyU3FGTnBYbFQ2YVBwQjBudFhpdnV2SkNkd3ZH?=
 =?utf-8?B?aWc4S3d3THN1ZVZ4bFBXU3lGWE9iZnlZRXlSYmZsUkFvR1VISVNWK1g2OVRm?=
 =?utf-8?B?MzVldEtsVDNOSS9sM0NGcVplQXBKcy95d2wzazFnRURFdjF6cWE4YUF0aG1i?=
 =?utf-8?B?KzNRTUlqdFExMWtGUzREeUNGLzd0R3BCTHRqODFaNzJJUjhyWG1FNEdHcThj?=
 =?utf-8?B?T3QxaFhKYXlYVGFmM3FYVlNXbVc1VnNleWJCbk43K3IvT2tuMDdmUUhFTUl6?=
 =?utf-8?B?NlZvZ2Z0d0pBVXlSOE8wVjdOcXBhL2YxTXlJRXVkNDhKYzRjOXlxZXMrdVY0?=
 =?utf-8?Q?IIkxU21UTKIBxyapdw5sGOgD0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7908d0-7a59-467b-8346-08db15264a50
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 22:44:00.5131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpNAsHmazlGAVjG8nBTq8NZNXCX6okarn+NvGkd5ZfcFTUN36+UaefYmFvRCJXXPnOzRnJjdAIr0Gwzl7KnpnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/2023 6:32 AM, Zhi Wang wrote:
> On Mon, 20 Feb 2023 12:38:18 -0600
> Michael Roth <michael.roth@amd.com> wrote:
> 
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
>> system-wide configuration value for SNP guests. The information includes
>> the TCB version string to be reported in guest attestation reports.
>>
>> Version 2 of the GHCB specification adds an NAE (SNP extended guest
>> request) that a guest can use to query the reports that include additional
>> certificates.
>>
>> In both cases, userspace provided additional data is included in the
>> attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
>> command to give the certificate blob and the reported TCB version string
>> at once. Note that the specification defines certificate blob with a
>> specific GUID format; the userspace is responsible for building the
>> proper certificate blob. The ioctl treats it an opaque blob.
>>
>> While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
>> command that can be used to obtain the data programmed through the
>> SNP_SET_EXT_CONFIG.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   Documentation/virt/coco/sev-guest.rst |  27 ++++++
>>   drivers/crypto/ccp/sev-dev.c          | 123 ++++++++++++++++++++++++++
>>   drivers/crypto/ccp/sev-dev.h          |   4 +
>>   include/uapi/linux/psp-sev.h          |  17 ++++
>>   4 files changed, 171 insertions(+)
>>
>> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
>> index 11ea67c944df..6cad4226c348 100644
>> --- a/Documentation/virt/coco/sev-guest.rst
>> +++ b/Documentation/virt/coco/sev-guest.rst
>> @@ -145,6 +145,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>>   status includes API major, minor version and more. See the SEV-SNP
>>   specification for further details.
>>   
>> +2.5 SNP_SET_EXT_CONFIG
>> +----------------------
>> +:Technology: sev-snp
>> +:Type: hypervisor ioctl cmd
>> +:Parameters (in): struct sev_data_snp_ext_config
>> +:Returns (out): 0 on success, -negative on error
>> +
>> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
>> +reported TCB version in the attestation report. The command is similar to
>> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
>> +command also accepts an additional certificate blob defined in the GHCB
>> +specification.
>> +
>> +If the certs_address is zero, then the previous certificate blob will deleted.
>> +For more information on the certificate blob layout, see the GHCB spec
>> +(extended guest request message).
>> +
>> +2.6 SNP_GET_EXT_CONFIG
>> +----------------------
>> +:Technology: sev-snp
>> +:Type: hypervisor ioctl cmd
>> +:Parameters (in): struct sev_data_snp_ext_config
>> +:Returns (out): 0 on success, -negative on error
>> +
>> +The SNP_GET_EXT_CONFIG is used to query the system-wide configuration set
>> +through the SNP_SET_EXT_CONFIG.
>> +
>>   3. SEV-SNP CPUID Enforcement
>>   ============================
>>   
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 65e13a562f3b..b56b00ca2cd4 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1481,6 +1481,10 @@ static int __sev_snp_shutdown_locked(int *error)
>>   	data.length = sizeof(data);
>>   	data.iommu_snp_shutdown = 1;
>>   
>> +	/* Free the memory used for caching the certificate data */
>> +	kfree(sev->snp_certs_data);
>> +	sev->snp_certs_data = NULL;
>> +
>>   	wbinvd_on_all_cpus();
>>   
>>   retry:
>> @@ -1793,6 +1797,118 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>>   	return ret;
>>   }
>>   
>> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
>> +{
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	struct sev_user_data_ext_snp_config input;
>> +	int ret;
>> +
>> +	if (!sev->snp_initialized || !argp->data)
>> +		return -EINVAL;
>> +
>> +	memset(&input, 0, sizeof(input));
>> +
>> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>> +		return -EFAULT;
>> +
>> +	/* Copy the TCB version programmed through the SET_CONFIG to userspace */
>> +	if (input.config_address) {
>> +		if (copy_to_user((void * __user)input.config_address,
>> +				 &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
>> +			return -EFAULT;
>> +	}
>> +
>> +	/* Copy the extended certs programmed through the SNP_SET_CONFIG */
>> +	if (input.certs_address && sev->snp_certs_data) {
>> +		if (input.certs_len < sev->snp_certs_len) {
>> +			/* Return the certs length to userspace */
>> +			input.certs_len = sev->snp_certs_len;
>> +
>> +			ret = -ENOSR;
>> +			goto e_done;
>> +		}
>> +
> 
> What about if input.certs_len > sev->snp_certs_len? Is it possbile for the
> userspace to know the length of data in the buffer? (I guess it might be able
> to know the certs len through the blob data, but a comment here would be nice)
> 

If userspace provides an input buffer/length smaller then snp_certs_len, 
then the above returns the "required" certs length back to userspace.

And what is the issue if input.certs_len > sev->snp_certs_len, the 
buffer returned back to userspace is sev->snp_certs_len as below.

Thanks,
Ashish

>> +		if (copy_to_user((void * __user)input.certs_address,
>> +				 sev->snp_certs_data, sev->snp_certs_len))
>> +			return -EFAULT;
>> +	}
>> +
>> +	ret = 0;
>> +
>> +e_done:
>> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
>> +		ret = -EFAULT;
>> +
>> +	return ret;
>> +}
>> +
>> +static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>> +{
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	struct sev_user_data_ext_snp_config input;
>> +	struct sev_user_data_snp_config config;
>> +	void *certs = NULL;
>> +	int ret = 0;
>> +
>> +	if (!sev->snp_initialized || !argp->data)
>> +		return -EINVAL;
>> +
>> +	if (!writable)
>> +		return -EPERM;
>> +
>> +	memset(&input, 0, sizeof(input));
>> +
>> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>> +		return -EFAULT;
>> +
>> +	/* Copy the certs from userspace */
>> +	if (input.certs_address) {
>> +		if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
>> +			return -EINVAL;
>> +
>> +		certs = psp_copy_user_blob(input.certs_address, input.certs_len);
>> +		if (IS_ERR(certs))
>> +			return PTR_ERR(certs);
>> +	}
>> +
>> +	/* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
>> +	if (input.config_address) {
>> +		memset(&config, 0, sizeof(config));
>> +		if (copy_from_user(&config,
>> +				   (void __user *)input.config_address, sizeof(config))) {
>> +			ret = -EFAULT;
>> +			goto e_free;
>> +		}
>> +
>> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +		if (ret)
>> +			goto e_free;
>> +
>> +		memcpy(&sev->snp_config, &config, sizeof(config));
>> +	}
>> +
>> +	/*
>> +	 * If the new certs are passed then cache it else free the old certs.
>> +	 */
>> +	mutex_lock(&sev->snp_certs_lock);
>> +	if (certs) {
>> +		kfree(sev->snp_certs_data);
>> +		sev->snp_certs_data = certs;
>> +		sev->snp_certs_len = input.certs_len;
>> +	} else {
>> +		kfree(sev->snp_certs_data);
>> +		sev->snp_certs_data = NULL;
>> +		sev->snp_certs_len = 0;
>> +	}
>> +	mutex_unlock(&sev->snp_certs_lock);
>> +
>> +	return 0;
>> +
>> +e_free:
>> +	kfree(certs);
>> +	return ret;
>> +}
>> +
>>   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>   {
>>   	void __user *argp = (void __user *)arg;
>> @@ -1847,6 +1963,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>   	case SNP_PLATFORM_STATUS:
>>   		ret = sev_ioctl_snp_platform_status(&input);
>>   		break;
>> +	case SNP_SET_EXT_CONFIG:
>> +		ret = sev_ioctl_snp_set_config(&input, writable);
>> +		break;
>> +	case SNP_GET_EXT_CONFIG:
>> +		ret = sev_ioctl_snp_get_config(&input);
>> +		break;
>>   	default:
>>   		ret = -EINVAL;
>>   		goto out;
>> @@ -1962,6 +2084,7 @@ int sev_dev_init(struct psp_device *psp)
>>   		goto e_sev;
>>   
>>   	sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
>> +	mutex_init(&sev->snp_certs_lock);
>>   
>>   	psp->sev_data = sev;
>>   
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index 19d79f9d4212..41d5353d5bab 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -66,6 +66,10 @@ struct sev_device {
>>   
>>   	bool snp_initialized;
>>   	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
>> +	void *snp_certs_data;
>> +	u32 snp_certs_len;
>> +	struct mutex snp_certs_lock;
>> +	struct sev_user_data_snp_config snp_config;
>>   };
>>   
>>   int sev_dev_init(struct psp_device *psp);
>> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
>> index 5adfaea7df97..c20d37586d21 100644
>> --- a/include/uapi/linux/psp-sev.h
>> +++ b/include/uapi/linux/psp-sev.h
>> @@ -29,6 +29,8 @@ enum {
>>   	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
>>   	SEV_GET_ID2,
>>   	SNP_PLATFORM_STATUS,
>> +	SNP_SET_EXT_CONFIG,
>> +	SNP_GET_EXT_CONFIG,
>>   
>>   	SEV_MAX,
>>   };
>> @@ -192,6 +194,21 @@ struct sev_user_data_snp_config {
>>   	__u8 rsvd1[52];
>>   } __packed;
>>   
>> +/**
>> + * struct sev_data_snp_ext_config - system wide configuration value for SNP.
>> + *
>> + * @config_address: address of the struct sev_user_data_snp_config or 0 when
>> + *		reported_tcb does not need to be updated.
>> + * @certs_address: address of extended guest request certificate chain or
>> + *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
>> + * @certs_len: length of the certs
>> + */
>> +struct sev_user_data_ext_snp_config {
>> +	__u64 config_address;		/* In */
>> +	__u64 certs_address;		/* In */
>> +	__u32 certs_len;		/* In */
>> +};
>> +
>>   /**
>>    * struct sev_issue_cmd - SEV ioctl parameters
>>    *
> 
