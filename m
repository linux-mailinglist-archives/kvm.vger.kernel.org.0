Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7911969F950
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 17:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjBVQuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 11:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjBVQuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 11:50:23 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1846D3B86F;
        Wed, 22 Feb 2023 08:50:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C30KFbkr2QYToYOnVtJ/mRcJzeLzWsGldwYr/Ch2RuFrfWFcMOvGoF95FXr9BiUneoLIBip+SSO1YvxqLStQaTHr+kUJyX62DJFOk6zXv5115NefDeDnqd8D+dWOo8oDjIgp8gn8e2zM8iKFEchi9IyZvlSJ8yij/eFBbp8Py0UP0o6/GkuLfjoQsHiaXTAV374t+7QpImaH5aNb3Xi9OiCZOvl2QZpPWY2adB/g3GBXiQyrojwVUVVRgLDJIN7fq7AvBaSqBTUxI6hH+atfJNMj9bCrKigLj9wcH/FOFYQ57Ekk1nF1Zqg0M8YY+oerERBpuIHDQfgKWBbSgvGk3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3qLZ8+dTnHYIPOZElMlLeFVgTw6EBaJR3PBakS+yS8=;
 b=Q4gEPjHwcblV0MWHXqXen+/WROhrCqFzBmmne8SKTAMOtyb2Kc50sZ5yxf4k5V/Ml+Ab7AsETjDwAgTbVqTQ554QS6I2KJdJTUxZkKAdiEp5sJC5vAqz/EwIAaOoLH/GNzq8Z+R9aoJ6KHXWd+EaSK1JuBUOF2hw66sI+bqPiQw7RFvonIiXOQv/7yhWZDtrQ07kfnFtiztp1otxL5Z0llwtx5Wmq4YzwaiSQvryCQhSsEPxyVobf8CMFWoPgUZukenMNBCrlSWKJ6PE6DorOxV521JhObENMwh402SqqYN2MeM8fvFYiyOT/TPTVyKLpvRG9tm8h16XVx9jhDMj/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3qLZ8+dTnHYIPOZElMlLeFVgTw6EBaJR3PBakS+yS8=;
 b=uxhPQOzkPR3R48SJjz1uQo24qbhUVMXQoqqf561qqZ+R5vdECkFUaGbhMoIfVN/bf5GLzZ4kYP6nQa8E9ShCTrtSlTs2JjWEJzFF1unfplsRQAWkNHj8QxOm8ey+qyZmLqy9z6VYqvma9DLhV4dtBW3Wts8iyqfMenUBRtH1crE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 16:50:16 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%5]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 16:50:16 +0000
Message-ID: <fd62ecf6-631f-f55f-dc1c-827008aa0e56@amd.com>
Date:   Wed, 22 Feb 2023 10:50:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 27/56] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
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
 <20230220183847.59159-28-michael.roth@amd.com>
 <20230222143205.00007635@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230222143205.00007635@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:610:b0::18) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM8PR12MB5400:EE_
X-MS-Office365-Filtering-Correlation-Id: 68ea34e7-8d7c-4468-99cb-08db14f4df90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BoAiOkWvQmBShsQmqe1+cmG9YUOCA//rGf10nykX1JwJpxKEgI0EQh/ZJ7tWCCKR5W3/P7BoWwdkGy/+3aCa8zwSxQThtQrHgT0gDOSMAlhxOjdhjI9fe1UHXHIJOdJ8PqRXdRCdhH2zRKg5ku+vD/F7Ddacj0lPiMs5lYvUCUzjGLQU8UHh8eIXwlpx5j4YS3kEttFjzpSuAxe6S+I0rMWHayKI8RkYSUDPSSi//UA2cy+9s2Fh8IJpibw0Th7hgsDegmijjfJOK8tk95bOYxPL+WEUJCF/vkgkgewwApbYkub2I3EzFIaaZte4j0LzAYDERRrK8aMY3VuUSoqiNcBeU9YyVIHJUiG7k+M4be2InKrKs7zUNLF2Ky3uO5kHGEoYlDOmupIkiKEdiZrTuzZNXEVZvNg/PtpzBOvGe3tWtOnzoUkLvLXeDCK/cEqfpPU7DPslSVKHn3UjwWbaMZMWNsEDxWBqTVcucWGCqx5Iogb/ZrhxBWNItbE4DhJlU93u7UKPObWb1OhA5i9h+CS5icbRYWYFYTGpIj76bw23Zm3AjpvZ+kU/yxIQOEbCWMqvYj4EBzTVKdylXCVIcVX2O+ZFmdTy/1XQlkVXqqpmZzFbOVBh572M9DZmsKumPFd56+TMCh3/ijAJdBbo2oHXYzmlYYaU0G7YeKBuWMqf9LPXBiv3aVVHzMfjfjxBjmhZlD4VfC3rTaz8+me/f3A4QR9nUvWVt/Tz6NEv6ZY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199018)(36756003)(5660300002)(31696002)(2906002)(7416002)(7406005)(86362001)(6636002)(83380400001)(8676002)(66556008)(66946007)(66476007)(316002)(110136005)(38100700002)(6666004)(26005)(6512007)(6486002)(186003)(31686004)(478600001)(2616005)(53546011)(6506007)(41300700001)(4326008)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qm1Da0lHclFQMWFUUUZ3QUQ3N2VTNXhPVWRHVEZjdFJKOEFaanRNV2VDSzZu?=
 =?utf-8?B?VDlHWjdXZitDS0ZlUDVLMTBXNTk5S3g5bHVzSWliNm5sOTlETmJPZVVHYzFa?=
 =?utf-8?B?SWRkd1NPT0Q2UStsOThpZUFPZHhmdnU5Y2FPRDdKS0JCM3c5MEEwbER4UGhD?=
 =?utf-8?B?Z3VMRCszUHJ0UGZWditzRk9CaTRBVVUvaXFObmduSlczTmxaYWNWcEdOY1dT?=
 =?utf-8?B?NFF2SUNqZjhtNFlWQW1USzJIbVUzZGp5aTYzd0xHVUR1VlFYblE5VW1TOFdv?=
 =?utf-8?B?MXNkYk1tMWxzQU1qOFM5cjVwbFd6QjZmNmUvWnk0UHBNdE5VU0lMK1ZjaW9P?=
 =?utf-8?B?eFpWZ1JUUURaaVB5eVFuMHhYWkh2Y0I5MDUxQm9PME9VV2RrOVBwT1RIT2NI?=
 =?utf-8?B?VTA1NmJFRG1vaU8rdGlyVzI2dlprQ3pCQlZQSmhYYjY0UUJ2dkZ1VFpMTnJV?=
 =?utf-8?B?amJabjVmUDBiWC9FSzVFdEVtUDJaUzROM205WEJMUXNMTXd3NVZCejZsVVZW?=
 =?utf-8?B?dWI5cC95QlpIREV5eVVTekcrZ2E0eFUwblc2YWZoNU5OOHZXQ0ZjMncvUnhR?=
 =?utf-8?B?blN3QXVUT3RoMDNMZG9aL0IvaGFnWEpSbW5aMENvVGR4RnJiU2lscElWb080?=
 =?utf-8?B?NFdMbEMyOTJpQ1F1T2g0RklhOHBxQzNxVGt3N1UrL0JCdXVIRDFLMm1uVjRi?=
 =?utf-8?B?Q2I2ZDlyU01tMlJsVzJUbG54SzFER29hWC91QklyU3N1bGtJV0J4VjFra1JO?=
 =?utf-8?B?M0JERnZtRFhwU2ZkN09aY0FtbEFHVXRZRHlpMDJQc2ZsaW5FckVFWGExWUZk?=
 =?utf-8?B?bWY0cW1NME0xZ09kQjcvYnZkR2VaUVQrc1BLbThjangzY2xyMjlMc3B1eDMy?=
 =?utf-8?B?eDUwdTRzQ1RFd2dXcnIrRDVFWUxjckkxTHVxSjhiaHlpeW1GQ2dEc01CbWJY?=
 =?utf-8?B?eFFoRXNKdkcvaGtSc1NCU2lNcnl6V1NLYzlvdlVkV1FBdlVHSzREVHJQYXJy?=
 =?utf-8?B?amdpZDJ5UXZVK1ZHKzdYSVRtWnB4Ni9IWG5uU1pLVklXZ0F3WGVJcmhHWUdz?=
 =?utf-8?B?VHdwTmxveGtmMTZ2dkpITUQvRG5CVEFjd1dJcmZTNEYrYU9LTDZjL2taMVlL?=
 =?utf-8?B?UkU1eHJJbzkxOUdyY3IvQXcxTDR5K1FYS1llVUlBanVJdG00dEdVZEhObXdm?=
 =?utf-8?B?K25Cdmx6ZGI4ZzNxTFN0ZkVqNmNUcjdXUXhGT05ibHNHTkdwSjBUQkYrRG1Y?=
 =?utf-8?B?Rldzd1ZwMzJlRWVYdmJGaFlKT3hYWElyS3V6ZWszOVNjeTlLUFVkbHI5NDRv?=
 =?utf-8?B?aEExcUd2Yzhrd3NpVjRqVDJaRXpLaCtCZ1h2N2JpY3dqUytjdlh0QXhjV2l5?=
 =?utf-8?B?QjN1Mkd3ckQ4VWhSdVFKMEdROVVyR1Rwa3JlcXV2K1ZBT3pJRCtSN29IY1pM?=
 =?utf-8?B?NS9zQVdnc3Z6MGNqMEkyRmx2bmRmejlXMTVmZEk5ZG1Wc0V4WVUrTTlSN1ZW?=
 =?utf-8?B?ck80TWk2RUtPYkQ2NnFTU0J4OVlmWUlCcU1ISE8xZ2VwVyt5TElKcHQ2bmVY?=
 =?utf-8?B?TFRabEtSTHg2KzNUNmNaUW9PanpaNHdvKzlVN0FrQmRZM3RDTDdoWFVra1k5?=
 =?utf-8?B?K045NWFnZ1BPMTZROU55bHhCU0YzTTA0UGZvdXZHaEs3MXpMTkprK3AxV09i?=
 =?utf-8?B?di9vRW9weDk3UjRQUkNwalhKMUNLTVVYU2haUkd0ZzFBdkRpc2R3czBxeTY3?=
 =?utf-8?B?eFdmNzZOTDFlc014alpHYmZLSldDZ3J6ak5jTnBLYjBkUjd5bTdhNCtRYmRL?=
 =?utf-8?B?OEhmWG5JZFJYOU1YUno0WDE2MGdTbkdicVVEMTd2R0RuT0MxM3NqUTRMV1M0?=
 =?utf-8?B?MDNEbXRENy9zWjB5K0JFc0dLSCtGNkdzUHFoSWRnRHpTSmdsRHdIK2RMNWk2?=
 =?utf-8?B?dnUwM3NQOU1QUG9JYUYvSmFoS0VsOFdPTnhsVVdyWGhlVVp4R1VqaXBiQlF3?=
 =?utf-8?B?bmhtRXRFcm5RZEV3d2FLTStlRjRWU0pFcUJaaXNrbU5xeGt4R1JRK2RXdjkx?=
 =?utf-8?B?TWFCWmRXcXRpOXRaMXgwbWZRdldPQmp0Rk9qUlJzbkVSWGV3OFFNd3A4bWYv?=
 =?utf-8?Q?t9zv5AkavW4GInqLhIU0GI2nh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ea34e7-8d7c-4468-99cb-08db14f4df90
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 16:50:16.1396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uU/wfA0fHutL2F7/e5TYNXDFzG+7ISyjQdFSX20AsP8L51ip2ozFMffiR2ByJ90one0Raj326sLD6X1sGMR2/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5400
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/23 06:32, Zhi Wang wrote:
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

We should be consistent with the other SEV ioctls that return required 
lengths and return -EIO here instead -ENOSR.

Thanks,
Tom

>> +			goto e_done;
>> +		}
>> +
> 
> What about if input.certs_len > sev->snp_certs_len? Is it possbile for the
> userspace to know the length of data in the buffer? (I guess it might be able
> to know the certs len through the blob data, but a comment here would be nice)
> 
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

