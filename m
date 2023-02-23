Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4276A0BCB
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 15:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbjBWOTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 09:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbjBWOTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 09:19:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE78351F87;
        Thu, 23 Feb 2023 06:19:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l73rERw1/lWZ8X6O57lulDCIIBxOElzvVQRfE+ko8UHrna/QSWiJijc2pk9/k/D80icm+wcz19HD4Pwmwsn9q3iHm8X+pEUf2IDqaeACc3wjR6uUeGV2u+PdhtPMoiz5gUgNv2LoDUcbQuGfkUht+1eNWv01YahNMb7sPr5uZkociMRFpLPKnifQ6H2bkiTEYT3ve1PqmxH73ydOXI5OWC4bqJmQZKXSaumvWN/xb5hNyL7iI5W0GSavfrgHHuRyOhj0YQjk6yhFBSweo3/o4EA58skBrc5/xTrmOm1SWv7KBqI+dHDkSrtV41P8aUV5B3MR7z/v8o/6fXgwn197ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaEfGzOQ+peTlTpFW/5I3ctbEeOImYp9PuC+rIsDsSg=;
 b=UjqaVmBNMEiaaz8dfVMLzyKHqbi18pvoMJguxPvmN80GK3rjj1McvJkMJ7yA9bf2KpiN+PBroM8ubL2fd9d0Q6NTRIRIbqnpVQ+XMBYVlAUGszvlHU0iIQ2/U40N5S4LwLPWneT7iXqBrLRaaOxrDesxC/5EApJbOodNKTiBYYSyqkQMCGwrirvHSXemRPUcqubRS8ihb3eAd4jMxYITTw2PliTwNboWy0ig7AqMZXUCzHDYVdKLfk7g8ilaJPF4kkisD3FV2sZb2G5HKZkze1UUONTYfuUaAnQ8bkjcNrZ+JYiRSODVqXQYl6i1qJZ04U8YOvCHD6BUGUABZs4g3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaEfGzOQ+peTlTpFW/5I3ctbEeOImYp9PuC+rIsDsSg=;
 b=TM0cK5GsfILHLRXRGJgWPrdhPoC9Ai2fYbyOYP3Sa00yBJO1gaiiccz64Rne9JVRDxjfzt2pMWo1Wg2hLeChkho45/a91pNGK+W5WE1FMIqVWFLlYgUXsTDCWh1AdNfxhWTvFUoeIWL0u6Ywsprm0VgWlmiG30EJudtPHSeQjio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN2PR12MB4336.namprd12.prod.outlook.com (2603:10b6:208:1df::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 14:19:35 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%4]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 14:19:35 +0000
Message-ID: <d3cb39e3-439e-7a29-0576-11d83c88b0fb@amd.com>
Date:   Thu, 23 Feb 2023 08:19:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 27/56] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
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
        dgilbert@redhat.com, jarkko@kernel.org, nikunj.dadhania@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-28-michael.roth@amd.com>
 <20230222143205.00007635@gmail.com>
 <c548c555-279e-4ec4-d51f-7f8cdd501010@amd.com>
 <20230223083839.000014ee@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230223083839.000014ee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:610:38::14) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN2PR12MB4336:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c49f020-3fbc-4619-2d3c-08db15a8fce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ktWn0cLSbXU5USA3RcUMxuiuLz5T9gvP/7hZsnD82BRuUI5V+l4Q/eWGPdVEWphX/UDteSd9RsODfm6rsKSGKTg21A1llp13RTz8qhMM3leCrcAvU6pHiQthCXSHcfFh7xJMcx8O5byr2pTvWdXp7hkwIbqf0vU6KcV5xaEfUbzbcu67GtGdJbc3cG5ZTF7JHOOUOvMm9AEczFrXuhaplu+D5Gs5p71WsfRzWFo5If102LhpQVSRRLaJIvuW01b7e/Y9fCthW2I6GZ0Eh+jujdyzw7K4qgvBwbWSrqeRlOonRpXReInA26pecukf5HnMMONo5PbU1Zw6fR/jWsNALghvhkQ/R+fw0ApZEM2/GyJxCAV9OtwEGQZFFIESO1itJMjhL/h5tz9Ojch/nt7thlxhjGWldAHscJm8r28DMwaugm6/kwMS4BU79++jSHA3B5LpzYjGfm8uDkoGQVjflJD4cwMj8Nc84JASICVklQwe1eoQ3/26Zjz6AdlLKfY9a2jitr39Jixoj1jUTekFJmxfILcNziPUzo75IqxzIhw8NTO3HuvA0tgUtpFeYJVQk06y2w6+7nPZsUMyJAHlSEX2yNUPP+hDG5gqPN5V2YVyvtv9GJdIJpFSgxJm7GIn7y77Ut2XKGEIn9JiHMBnUDa4BllyvWq1MDRO6kkPw1nMWfbCEnjFR6haOCoV2BGnAAlORSpL4RQPLJLmRJ7rZcRNlfRIBlU/4XpoSxjksEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199018)(54906003)(66946007)(66476007)(66556008)(83380400001)(6636002)(110136005)(8676002)(8936002)(5660300002)(4326008)(41300700001)(316002)(6506007)(2616005)(6666004)(53546011)(6512007)(26005)(186003)(478600001)(6486002)(36756003)(86362001)(31696002)(2906002)(7416002)(7406005)(30864003)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1Fuc2FrYmkrNVFwQ1VxcDdrd0pvRjBLS2tMdzJZcmNoaUpieUI2M2dwQUFt?=
 =?utf-8?B?Qk9SdkY2WnhXbXM3OGhGT1NtQXpkZnB6QWtIZU1iRnVhcG1lS0NiVHFoQzNN?=
 =?utf-8?B?bUVaT0JUckxNWUVhbU00K09FQlUrdEROSjRHNnJCeEFRUEJ1WWEySEdsdC9h?=
 =?utf-8?B?a2RVQzI3bTlTTG5zbW9uOFRqMUpIaW9qdXJCMWQzeDhuRlNqbnlLNG9rVEJz?=
 =?utf-8?B?VEE4WUhxMlh6S3BFc2hBMkFmV1FJK1VTb0tFem5WSi8wWHhkalVKZlNDbGkx?=
 =?utf-8?B?UjQxN2dsamVQSWVldWFta2xvWjhEREp2V0cyRHR4TmtyczhrMS9PRmYzQkxL?=
 =?utf-8?B?WEZhOTFzVGF0Y0hHMHJ1ZUF5UmNGR2YvY3JhUG1UTEtIaThDSW5YR1AvNHJK?=
 =?utf-8?B?TUVIYytLK2NDeFp3V1doSVpva042NHZVcERvQmNNWkkwV1VWUnp4a0MrSS8w?=
 =?utf-8?B?QnhhdFAwenYxTVhFbWdaNUZUclBWZDhpblV1MklzTkxWZlJDcXEwT0NQaklG?=
 =?utf-8?B?S2RPQUszbHY0SzlZSmtFOGpFKzRTaG10UEVMMzZ2ZTdoL1d1ZDU5Qzd2ZVFC?=
 =?utf-8?B?YUkzVHJxRFZReG1wZER2OXlCV3BPV0xlWlFDaUdja1l2RHpSWlBzYkpnMVpv?=
 =?utf-8?B?MEVkOWJTV0dtVEY1eFZ6cmRSc2xqZzJhYWJCSzRPRG5nMWNvUFdrdWhhbXBq?=
 =?utf-8?B?NzhJcytobEtLU0x0dHpralNsWVhFdzJZcXNyVmhWbVBRNE1jSkYrakZxclAr?=
 =?utf-8?B?YTZLRGZsQVRkeHdSbTIwMWVVOWFhakxoeHpzeVU2WVk0UC8yYThtTHFjMVM1?=
 =?utf-8?B?Yi9KVVdMS3ZnTnFaTlU1djBrY1gyYjFrVWZrNGZvMzZZYlR6S0l3WVczY0tt?=
 =?utf-8?B?WGpBNVdlN00vaTMzMHM4RkgxdldXVVpKNEpWamI5WXhrSm5NaWl4WXVHOTdh?=
 =?utf-8?B?aGRPOVFoeGVuZkxtRDBSTjU2VkxsNWgxL2I4c1M1RFY3MW8vd1drRGJiV0pq?=
 =?utf-8?B?dHdpMkVTbEkzSlJGTWpXU21MRkp6TjdWN09xOEpmT1VxRTFZaTNUZlB2WXAv?=
 =?utf-8?B?SWtSSVcwV3VhR3crQ0w0Wk5KWXF3UDQwR2dVVEVZS3VsanpNOVZtdUQ4RmQ2?=
 =?utf-8?B?Sm4wZnlScFpIaVNEOGpkTjJxbWpJcEd0MWc4WHpGbzlwanNSWnFrUENXNm5i?=
 =?utf-8?B?ZExjS0hicUNqZ1RjdkN6UWNMckRoOXRiRG5vcUluRnpORkkvZVY3THhYemJl?=
 =?utf-8?B?Vmh2RFNzS2svTUJBM09DNGViL0xybWVpRG1BVldnaTZBRHdGK0txWVhzNmdY?=
 =?utf-8?B?aUUyRUZjL3c2VXduSGVvWk1wYWxHR2N1SGRTTDRNRkZaOUtqWFptbHpIR3Bn?=
 =?utf-8?B?Y0dMaVpvQ0hXNmJHdG5XMEx5b3B5Z2FzZWxyYTRKVFZVL1hmUWJKaXVITk0v?=
 =?utf-8?B?cU9HTlNtS1Q3UUtqRlFpM0VVUFErN28yRUtPbWtJMVJQc1NxczhpS2R2cTdQ?=
 =?utf-8?B?RVF2RjViOWRKdTFrRDU0YkF5WmZzV2lZSE1lTzFhZi9vT290RGhHNW5xQis5?=
 =?utf-8?B?UHZwbjZLZkhOaGJqMmtDLzY0eFlvTHJHTFFaR1QwZHhnQS8rT2VvU2hqUFZj?=
 =?utf-8?B?Ymp1ckg5TmN0NmFsTVFJK3M3QzFuMUlHVmJCbXZpUWxLZkozQUgrcHBOdFI0?=
 =?utf-8?B?VTFncjZlWDMvSG5BV1F2akhvVnFkdndHaFd3T2k3Q202NnZ4M0c2RzBtNUZM?=
 =?utf-8?B?amorTkFIUk51YnVibFBGN0ZTY0lzd01pNG1zTTc2eVEveVJPR0hNZ3BmQTZr?=
 =?utf-8?B?MGVnNWF3RW5nbW5tZGZhakp6Y0F1ZUY2YXlFcVRCUkdtOEx6eXZveGVUSGJN?=
 =?utf-8?B?UDZxT1hJSlFHdS9LZU1lZVlqWWZ0aTVzWitvTFZWMWNNUEJIQ0RSZUg4eTdj?=
 =?utf-8?B?Y3lSbDNVSG5zN0pya1hyT3VlV29oL2ZsdEFxK3d1NFRjTC95d1Z1SU5INnl1?=
 =?utf-8?B?UHZyWkNYWXZzTTN4VmlPMjAyamNMaGQ2TWdGdFlLK0tTVEdqaWNOYStqK0tX?=
 =?utf-8?B?RXdRcm9DQWZDTFl0LzRwVDlsSXpVMXBRSWJQcmEzd1FJNFYrWW9DdjZkRzNR?=
 =?utf-8?Q?zXY8NcxacyVH42Xk+3UFt6GrW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c49f020-3fbc-4619-2d3c-08db15a8fce1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 14:19:34.7955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8034gjO4PPmhfruje1f4HcxWJ6JZgAp/OkmlSruSWoR+dd31kD3NYxhr4QU/r+h2z6hqvy9rp1WzjQDv0QqCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4336
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/23 00:38, Zhi Wang wrote:
> On Wed, 22 Feb 2023 16:43:54 -0600
> "Kalra, Ashish" <ashish.kalra@amd.com> wrote:
> 
>> On 2/22/2023 6:32 AM, Zhi Wang wrote:
>>> On Mon, 20 Feb 2023 12:38:18 -0600
>>> Michael Roth <michael.roth@amd.com> wrote:
>>>
>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>
>>>> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
>>>> system-wide configuration value for SNP guests. The information includes
>>>> the TCB version string to be reported in guest attestation reports.
>>>>
>>>> Version 2 of the GHCB specification adds an NAE (SNP extended guest
>>>> request) that a guest can use to query the reports that include additional
>>>> certificates.
>>>>
>>>> In both cases, userspace provided additional data is included in the
>>>> attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
>>>> command to give the certificate blob and the reported TCB version string
>>>> at once. Note that the specification defines certificate blob with a
>>>> specific GUID format; the userspace is responsible for building the
>>>> proper certificate blob. The ioctl treats it an opaque blob.
>>>>
>>>> While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
>>>> command that can be used to obtain the data programmed through the
>>>> SNP_SET_EXT_CONFIG.
>>>>
>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>> ---
>>>>    Documentation/virt/coco/sev-guest.rst |  27 ++++++
>>>>    drivers/crypto/ccp/sev-dev.c          | 123 ++++++++++++++++++++++++++
>>>>    drivers/crypto/ccp/sev-dev.h          |   4 +
>>>>    include/uapi/linux/psp-sev.h          |  17 ++++
>>>>    4 files changed, 171 insertions(+)
>>>>
>>>> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
>>>> index 11ea67c944df..6cad4226c348 100644
>>>> --- a/Documentation/virt/coco/sev-guest.rst
>>>> +++ b/Documentation/virt/coco/sev-guest.rst
>>>> @@ -145,6 +145,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>>>>    status includes API major, minor version and more. See the SEV-SNP
>>>>    specification for further details.
>>>>    
>>>> +2.5 SNP_SET_EXT_CONFIG
>>>> +----------------------
>>>> +:Technology: sev-snp
>>>> +:Type: hypervisor ioctl cmd
>>>> +:Parameters (in): struct sev_data_snp_ext_config
>>>> +:Returns (out): 0 on success, -negative on error
>>>> +
>>>> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
>>>> +reported TCB version in the attestation report. The command is similar to
>>>> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
>>>> +command also accepts an additional certificate blob defined in the GHCB
>>>> +specification.
>>>> +
>>>> +If the certs_address is zero, then the previous certificate blob will deleted.
>>>> +For more information on the certificate blob layout, see the GHCB spec
>>>> +(extended guest request message).
>>>> +
>>>> +2.6 SNP_GET_EXT_CONFIG
>>>> +----------------------
>>>> +:Technology: sev-snp
>>>> +:Type: hypervisor ioctl cmd
>>>> +:Parameters (in): struct sev_data_snp_ext_config
>>>> +:Returns (out): 0 on success, -negative on error
>>>> +
>>>> +The SNP_GET_EXT_CONFIG is used to query the system-wide configuration set
>>>> +through the SNP_SET_EXT_CONFIG.
>>>> +
>>>>    3. SEV-SNP CPUID Enforcement
>>>>    ============================
>>>>    
>>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>>> index 65e13a562f3b..b56b00ca2cd4 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>> @@ -1481,6 +1481,10 @@ static int __sev_snp_shutdown_locked(int *error)
>>>>    	data.length = sizeof(data);
>>>>    	data.iommu_snp_shutdown = 1;
>>>>    
>>>> +	/* Free the memory used for caching the certificate data */
>>>> +	kfree(sev->snp_certs_data);
>>>> +	sev->snp_certs_data = NULL;
>>>> +
>>>>    	wbinvd_on_all_cpus();
>>>>    
>>>>    retry:
>>>> @@ -1793,6 +1797,118 @@ static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
>>>>    	return ret;
>>>>    }
>>>>    
>>>> +static int sev_ioctl_snp_get_config(struct sev_issue_cmd *argp)
>>>> +{
>>>> +	struct sev_device *sev = psp_master->sev_data;
>>>> +	struct sev_user_data_ext_snp_config input;
>>>> +	int ret;
>>>> +
>>>> +	if (!sev->snp_initialized || !argp->data)
>>>> +		return -EINVAL;
>>>> +
>>>> +	memset(&input, 0, sizeof(input));
>>>> +
>>>> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>>>> +		return -EFAULT;
>>>> +
>>>> +	/* Copy the TCB version programmed through the SET_CONFIG to userspace */
>>>> +	if (input.config_address) {
>>>> +		if (copy_to_user((void * __user)input.config_address,
>>>> +				 &sev->snp_config, sizeof(struct sev_user_data_snp_config)))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	/* Copy the extended certs programmed through the SNP_SET_CONFIG */
>>>> +	if (input.certs_address && sev->snp_certs_data) {
>>>> +		if (input.certs_len < sev->snp_certs_len) {
>>>> +			/* Return the certs length to userspace */
>>>> +			input.certs_len = sev->snp_certs_len;
>>>> +
>>>> +			ret = -ENOSR;
>>>> +			goto e_done;
>>>> +		}
>>>> +
>>>
>>> What about if input.certs_len > sev->snp_certs_len? Is it possbile for the
>>> userspace to know the length of data in the buffer? (I guess it might be able
>>> to know the certs len through the blob data, but a comment here would be nice)
>>>
>>
>> If userspace provides an input buffer/length smaller then snp_certs_len,
>> then the above returns the "required" certs length back to userspace.
>>
>> And what is the issue if input.certs_len > sev->snp_certs_len, the
>> buffer returned back to userspace is sev->snp_certs_len as below.
>>
> 
> My point is: How can the userspace know the length of return data is shorter
> than input.certs_len when input.certs_len > sev->snp_serts_len? as the length
> is only returned when input.certs_len < sev->snp_certs_len.

The returned data has a defined format that can be used to calculate the 
overall length.

Thanks,
Tom

> 
>> Thanks,
>> Ashish
>>
>>>> +		if (copy_to_user((void * __user)input.certs_address,
>>>> +				 sev->snp_certs_data, sev->snp_certs_len))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	ret = 0;
>>>> +
>>>> +e_done:
>>>> +	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
>>>> +		ret = -EFAULT;
>>>> +
>>>> +	return ret;
>>>> +}
>>>> +
>>>> +static int sev_ioctl_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>>>> +{
>>>> +	struct sev_device *sev = psp_master->sev_data;
>>>> +	struct sev_user_data_ext_snp_config input;
>>>> +	struct sev_user_data_snp_config config;
>>>> +	void *certs = NULL;
>>>> +	int ret = 0;
>>>> +
>>>> +	if (!sev->snp_initialized || !argp->data)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (!writable)
>>>> +		return -EPERM;
>>>> +
>>>> +	memset(&input, 0, sizeof(input));
>>>> +
>>>> +	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>>>> +		return -EFAULT;
>>>> +
>>>> +	/* Copy the certs from userspace */
>>>> +	if (input.certs_address) {
>>>> +		if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
>>>> +			return -EINVAL;
>>>> +
>>>> +		certs = psp_copy_user_blob(input.certs_address, input.certs_len);
>>>> +		if (IS_ERR(certs))
>>>> +			return PTR_ERR(certs);
>>>> +	}
>>>> +
>>>> +	/* Issue the PSP command to update the TCB version using the SNP_CONFIG. */
>>>> +	if (input.config_address) {
>>>> +		memset(&config, 0, sizeof(config));
>>>> +		if (copy_from_user(&config,
>>>> +				   (void __user *)input.config_address, sizeof(config))) {
>>>> +			ret = -EFAULT;
>>>> +			goto e_free;
>>>> +		}
>>>> +
>>>> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>>>> +		if (ret)
>>>> +			goto e_free;
>>>> +
>>>> +		memcpy(&sev->snp_config, &config, sizeof(config));
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * If the new certs are passed then cache it else free the old certs.
>>>> +	 */
>>>> +	mutex_lock(&sev->snp_certs_lock);
>>>> +	if (certs) {
>>>> +		kfree(sev->snp_certs_data);
>>>> +		sev->snp_certs_data = certs;
>>>> +		sev->snp_certs_len = input.certs_len;
>>>> +	} else {
>>>> +		kfree(sev->snp_certs_data);
>>>> +		sev->snp_certs_data = NULL;
>>>> +		sev->snp_certs_len = 0;
>>>> +	}
>>>> +	mutex_unlock(&sev->snp_certs_lock);
>>>> +
>>>> +	return 0;
>>>> +
>>>> +e_free:
>>>> +	kfree(certs);
>>>> +	return ret;
>>>> +}
>>>> +
>>>>    static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>>>    {
>>>>    	void __user *argp = (void __user *)arg;
>>>> @@ -1847,6 +1963,12 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>>>>    	case SNP_PLATFORM_STATUS:
>>>>    		ret = sev_ioctl_snp_platform_status(&input);
>>>>    		break;
>>>> +	case SNP_SET_EXT_CONFIG:
>>>> +		ret = sev_ioctl_snp_set_config(&input, writable);
>>>> +		break;
>>>> +	case SNP_GET_EXT_CONFIG:
>>>> +		ret = sev_ioctl_snp_get_config(&input);
>>>> +		break;
>>>>    	default:
>>>>    		ret = -EINVAL;
>>>>    		goto out;
>>>> @@ -1962,6 +2084,7 @@ int sev_dev_init(struct psp_device *psp)
>>>>    		goto e_sev;
>>>>    
>>>>    	sev->cmd_buf_backup = (uint8_t *)sev->cmd_buf + PAGE_SIZE;
>>>> +	mutex_init(&sev->snp_certs_lock);
>>>>    
>>>>    	psp->sev_data = sev;
>>>>    
>>>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>>>> index 19d79f9d4212..41d5353d5bab 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.h
>>>> +++ b/drivers/crypto/ccp/sev-dev.h
>>>> @@ -66,6 +66,10 @@ struct sev_device {
>>>>    
>>>>    	bool snp_initialized;
>>>>    	struct snp_host_map snp_host_map[MAX_SNP_HOST_MAP_BUFS];
>>>> +	void *snp_certs_data;
>>>> +	u32 snp_certs_len;
>>>> +	struct mutex snp_certs_lock;
>>>> +	struct sev_user_data_snp_config snp_config;
>>>>    };
>>>>    
>>>>    int sev_dev_init(struct psp_device *psp);
>>>> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
>>>> index 5adfaea7df97..c20d37586d21 100644
>>>> --- a/include/uapi/linux/psp-sev.h
>>>> +++ b/include/uapi/linux/psp-sev.h
>>>> @@ -29,6 +29,8 @@ enum {
>>>>    	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
>>>>    	SEV_GET_ID2,
>>>>    	SNP_PLATFORM_STATUS,
>>>> +	SNP_SET_EXT_CONFIG,
>>>> +	SNP_GET_EXT_CONFIG,
>>>>    
>>>>    	SEV_MAX,
>>>>    };
>>>> @@ -192,6 +194,21 @@ struct sev_user_data_snp_config {
>>>>    	__u8 rsvd1[52];
>>>>    } __packed;
>>>>    
>>>> +/**
>>>> + * struct sev_data_snp_ext_config - system wide configuration value for SNP.
>>>> + *
>>>> + * @config_address: address of the struct sev_user_data_snp_config or 0 when
>>>> + *		reported_tcb does not need to be updated.
>>>> + * @certs_address: address of extended guest request certificate chain or
>>>> + *              0 when previous certificate should be removed on SNP_SET_EXT_CONFIG.
>>>> + * @certs_len: length of the certs
>>>> + */
>>>> +struct sev_user_data_ext_snp_config {
>>>> +	__u64 config_address;		/* In */
>>>> +	__u64 certs_address;		/* In */
>>>> +	__u32 certs_len;		/* In */
>>>> +};
>>>> +
>>>>    /**
>>>>     * struct sev_issue_cmd - SEV ioctl parameters
>>>>     *
>>>
> 
