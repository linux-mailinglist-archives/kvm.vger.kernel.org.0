Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AF268C90C
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 22:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjBFV52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 16:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBFV51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 16:57:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386A22D142;
        Mon,  6 Feb 2023 13:57:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCbHYDtBbF50deQFvoJAHeWEGjax1hpaxIkcIvTg7zEIfZp5oDfbeXzykwFcVFRQoP/7s15IqnDKPnUjrVgVKoM6zro8COZd6EqR01YxzzvwsXVSq+JRXYKUsUwpRjr5HYl1YlQN6YhsecwWE3Gl41x/G5zdvAWmI19LIs17CfFr0mWk5AfpVO4ZenDzu98x5pNS9lgeKabZVMw77bJ/Mr/b0be+so0caWIQxWBRcCq2/PSkjhMNlQEfhxJuH/aPCDIuODYceWZRQfKemeF/Jbn1qGIIPpGpPxGbbvZG/uDOxSvAPtVhAXETn3KXmW8OoG/dmkIrecym8NcnGZD/LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiZvIB9nI0Z/pMqWTO/P0xbF3Qi81/RLnIEpjVdOMfw=;
 b=n/968T8nhE/u93CtW4sbXGmpAkVtVT6Gci3p7xqHdBVm5ZhWlJ/MmTjuX9tslI9Cblu2/keR1L4H4qNxReBNQN8hPnCZNuPvALTQGEQqB5m1txG40rap3Qi7vrPmJWeI9Nx/YShXOYLQe5yTn6FnxAgMorbEk7u74Rk8bHSW8AtyZQIdbjIPrlq3jgkvetXMiyIQ/RRFITj73tSzYQXMWo47/xrux8775scydFlVjAr+jz1BuegzOkHVPgiSFwyVE8/69UdndfV6VJZW8JZoQ9IjtM/juxSwYWFIXI7NPYkfRoi9j82k8eb0HBalv9IBv//fLIQnxgNekdtXwbWWtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiZvIB9nI0Z/pMqWTO/P0xbF3Qi81/RLnIEpjVdOMfw=;
 b=5pzK0sOe7qgeg3Ix/e+PSKQoGyB5t3RBAMYYv2uWTLDK02wlWFKGehNkAMJN6T/1n5+JpQ020ItKP4WbmrMIqN0TeLEsXsiYAIqVMvhxfHgRamOtYA6W/p+mUkBOrQEYo2hPGrG/UXuenIyjULGaafSCAZq01IrZU9Eyk89I434=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 21:57:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6064.029; Mon, 6 Feb 2023
 21:57:16 +0000
Message-ID: <f18fae8b-a928-cd82-e0b3-eac62ad3e106@amd.com>
Date:   Mon, 6 Feb 2023 15:57:11 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH kernel] KVM: SVM: Fix SVM_VMGEXIT_EXT_GUEST_REQUEST to
 follow the rest of API
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        John Allen <john.allen@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dionna Glaze <dionnaglaze@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>
References: <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
 <20230206031343.1646916-1-aik@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20230206031343.1646916-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:610:118::28) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: e4dd7be3-b8db-4743-adfc-08db088d1c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a25Nbslp3e3JYC8fJSwkKPW2Y0+BipXk3ynppu7QU1cxwMTamDRgMmMGxIkKiMxv+B/PwjLt5R6boCes2OIlsjBHUoPQHThlyNpEmdBUkpusznY4ZZIsULeoAU5ixrXsGq/rMFtAwovGaK/FvmEQpMac9yC4DeZu6fNupuW5xyRCVywdzU1npALPXGf0Ra1NMEgojx1uoT32c4f0xbW/FH/pgv2r08rTyAMFdDjLkyQMMp122RYPtT5BDimeQgaaWxPvvVb+0VoZNiDHTKXEj0/oMO+rlAWfV9zxF+S64r0IOScV6sIXyGcNiDuPvAI95QSICpOMnMZIKF//UNqPPcYCuZ2addFl974WYMAE2Yd5UTxi/qz1wqdc931lbzMPhtDySKNMbN3Odg6P9WM2qZ92rVPOGzrK7pNjNdNpT0QnImw3S2k+1a3FQIvXuOxtqDifJlGM7QVvg2pvSfKCHq7nUl62fVc9kSgPrf8/bjbJFjN0yuUgY8RMtlCRi+4LCIVyqksI/R3/45yvB6M77Qa8+wTCRpMQMasJoriGR7aVD45ZPNShO7HcPGTjz8TXZWOJd4O4AbQGu5RKzHLQBqFsTu4Q3nOb0ButshgrbjgtGWoLuwAZ8zM2Thek3rn1IBGz1Haud+i3HiTp8SYckm2UhbNvBa5aE5pecCs9R0qBWKxLNwViZqtOea07i0PnkWmfjF2Buf7caV1D7kWdfO+oiRN1tjw9qu9Y1LarrjKQcYgpBMjRl13e8hgiPPelMmr5vTfQ18A32cYro5JVNOM3RXf+3eLI54wNeNqgjJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199018)(31686004)(316002)(6486002)(966005)(478600001)(54906003)(36756003)(31696002)(86362001)(38100700002)(41300700001)(2616005)(53546011)(6666004)(83380400001)(5660300002)(66556008)(4326008)(66946007)(8676002)(8936002)(30864003)(6506007)(2906002)(7416002)(66476007)(6512007)(186003)(26005)(43740500002)(45980500001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajJqTjdYWTN3dW8yc3JWc0pRSHN3N0ZndTJlTm9qZEU5T1dZemdOZTBUWWRr?=
 =?utf-8?B?THdiWk9EcGxybGNyeUtWdDgwb0lRMUZMeVpoRnJNem5YRGFNUGs4d0RORkMr?=
 =?utf-8?B?bDNZQWh4MWQxL3FOdmp6Wkh5Vm9vdlZvN0xHNndpWnNxU3FKTkEzVXZ1Mi9s?=
 =?utf-8?B?RjU4eENYQUNYYkJtdFE0RGxjejVaM3RvVGZJZDF2TFU3VlhwN0xUZVBQRFJ5?=
 =?utf-8?B?WHRzMFNiQ0lrOTRDTmVua3krZHNGRlEzTFZiaXBRU2pJMElNMktsb1lHZm15?=
 =?utf-8?B?MDhFbVBhOGhCbkxpRlAwbktCNFhNZXQvemtqeHRWUXg3TXoxUHgzYTNDSmha?=
 =?utf-8?B?enNzbklCcmRoYUloc0xqSHpKMHpmQTg2MzYzTkwyWUpRdloyUkgxU01IQVlr?=
 =?utf-8?B?ZDlGRU9GLzhWTks5WWlrV3hDR3VrSURXZ3NJU00yRUkxSndlZ0pWalNJUHNv?=
 =?utf-8?B?NDVhVmdFU1o5bnUxU1lEb2dodm1qc1V4WlRIVVRsbmVHdEMzWmhyc0d1OWda?=
 =?utf-8?B?R25SeWxQdW1oM21LT0VySys0UXhqM3VEQjBrSXdJTHRHWVdPM1pBdW9kQ01T?=
 =?utf-8?B?QmVuSE5CeWNLZUlFS3Y0WGpUMU5BTU5SQitOb3NGWlFvTC9rbnlPTXlRSDlp?=
 =?utf-8?B?NU4wUkJLZi9WTUo4REFmQ2Q4RW8wZSs1NEJzczhpZlpBZzhENUZDOUdyUTRE?=
 =?utf-8?B?RXZJWkxyMmtYUTB0RzFpamlkRFliV1FQOGRzZHJSTVZXbEZTRHJxWkxMV3Nq?=
 =?utf-8?B?NDhLT0lpM04zdDQ4L1ZLNW0vRFBxb2hpS3FNOWdxY1NjZjN4VUw4NUdhTi9K?=
 =?utf-8?B?V01vWjJyckdEMHVRc1REQnBYRUViOGpkT0FaZWxMREh5MWZkbDgxOGlPUGhl?=
 =?utf-8?B?OGtRaVAvNXhsanFkMHpYaGMyVVlzM1Q5cUZIMWduR24wd2kvU3NsM2FieExr?=
 =?utf-8?B?empiK3RQdlpFcUJndzRCZ0pxcU9TVXYyOWhoRGZBMFNucG5xcFhSU3FjK3ph?=
 =?utf-8?B?KzNsTGNyMDV5MTRtMWVqSTFJL3hDMWhwMmQwQlE3WmNjZklwMHVPTVNrQmM4?=
 =?utf-8?B?YUdjeE5Td2hUNHBCeXVFNHlUaWlDYXJXZnVrcVcxN1N5ajVOTmdwVk9sdERY?=
 =?utf-8?B?N3lEaUh0YS94REtwc3JHZmNvc2N6RE02NnBCL1ZYekZhcnQ4VnMxL1NyUnZr?=
 =?utf-8?B?TlQ0Zm01L0NyU2NEMjJVaS85cjEyM1cxY2dqeHRPWTdSdzZGQUVUTWhNR3VO?=
 =?utf-8?B?dlZuM3lHTWFxWXdmdzRFajEwYVZBdnpNME9sSEJCaTUwbHR2dGkySHZ4SEM4?=
 =?utf-8?B?QmlXRUU5aXQ5QXUzaXdNOGY1WkFnSTZRM0ZheXNXVmFDYkVVUllpNzF2Z2JY?=
 =?utf-8?B?MjkzNTNVMHVmSVVNaWNpQ3NVdnlJV0grdFBkR2N1ak5zRDRiZUlYKzN5Sytl?=
 =?utf-8?B?UnRHMTdnemlwL0ovSytZNThBVjZLRWZDOUxESHlCWmQ5WlRNOGZnOWdDdHBS?=
 =?utf-8?B?eGRYbFBnalNUZDMraUdpOU13a0J5dXY1OTVBZFgxTHUvbDV0M1hNamxaZ0NI?=
 =?utf-8?B?eXh6TG4xN1RhU2hpdDQwWXR0V1ZBL3I4Z2NTMGZveGF2Sm5RRGRJc2VyYytr?=
 =?utf-8?B?c2p4ckNtK0kyOXVUWWhjS1lzMldhNmlzN1JRTTZ0UGJaNWJveEpqZlRtR0p2?=
 =?utf-8?B?YmpraFFNZXVKb3BabjhZQzNQVC9xQ3UyN1UxTkQxQW14UGJ2em9rSDJNZkhU?=
 =?utf-8?B?OXdkbXFTRitBVWFrc2tvbkkxb0R2cHFFaGxaUEQ5eEs5V0JIc3lGL2hLVERZ?=
 =?utf-8?B?OG1PdWZucTVlM1NUT1BjL3VRajF5aTQyeXBjcVo3RWYzbllhSHRiNk54TGZZ?=
 =?utf-8?B?SDRYbWF0SmtJUjhJVGxKZUcyZG5pY3BYcmZKOVlJQ3VhbVNJRWN6UEp4YUdw?=
 =?utf-8?B?U3RxQ2s4N1VOTXAzdUhGTExmaThDa3lJNjJRRVpiZ1dTRSs4cURRNlhmZlZX?=
 =?utf-8?B?dFBIb1hJMlhiSFZEcUJCUWhQbHhlSllGMlRkQy9YTno1THhDNUVUQ3hEUlli?=
 =?utf-8?B?ZHBOYWo5cXlFZXpURUluMlE5UG8rbVVScVV6UTJBYUpCd2Jld2wvK1VRRzJT?=
 =?utf-8?Q?HnvYkFIDbP7jI+oyICE4lqlN2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4dd7be3-b8db-4743-adfc-08db088d1c0e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 21:57:16.0160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXVjcGCkWmX+bhac6NV3yuCKTuWstd5AaaY9/YnxJXQuritbUOa2NREzXoAjft0QIGVHxI+WYw/lbPhPPZgeiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/5/2023 9:13 PM, Alexey Kardashevskiy wrote:
> When SVM VM is up, KVM uses sev_issue_cmd_external_user() with an open
> /dev/sev fd which ensures that the SVM initialization was done correctly.
> The only helper not following the scheme is snp_guest_ext_guest_request()
> which bypasses the fd check.
> 
> Change the SEV API to require passing a file.
> 
> Handle errors with care in the SNP Extended Guest Request handler
> (snp_handle_ext_guest_request()) as there are actually 3 types of errors:
> - @rc: return code SEV device's sev_issue_cmd() which is int==int32;
> - @err: a psp return code in sev_issue_cmd(), also int==int32 (probably
> a mistake but kvm_sev_cmd::error uses __u32 for some time now);
> - (added by this) @exitcode: GHCB's exit code sw_exit_info_2, uint64.
> 
> Use the right types, remove cast to int* and return ENOSPC from SEV
> device for converting it to the GHCB's exit code
> SNP_GUEST_REQ_INVALID_LEN==BIT(32).
> 
> Fixes: 17f1d0c995ac ("KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event")
> While at this, preserve the original error in snp_cleanup_guest_buf().
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> This can easily be squashed into what it fixes.
> 
> The patch is made for
> https://github.com/AMDESE/linux/commits/upmv10-host-snp-v7-rfc
> ---
>   include/linux/psp-sev.h      | 62 +++++++++++---------
>   arch/x86/kvm/svm/sev.c       | 50 +++++++++++-----
>   drivers/crypto/ccp/sev-dev.c | 11 ++--
>   3 files changed, 73 insertions(+), 50 deletions(-)
> 
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 970a9de0ed20..466b1a6e7d7b 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -848,6 +848,36 @@ int sev_platform_status(struct sev_user_data_status *status, int *error);
>   int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
>   				void *data, int *error);
>   
> +/**
> + * sev_issue_cmd_external_user_cert - issue SEV command by other driver with a file
> + * handle and return certificates set onto SEV device via SNP_SET_EXT_CONFIG;
> + * intended for use by the SNP extended guest request command defined
> + * in the GHCB specification.
> + *
> + * @filep - SEV device file pointer
> + * @cmd - command to issue
> + * @data - command buffer
> + * @vaddr: address where the certificate blob need to be copied.
> + * @npages: number of pages for the certificate blob.
> + *    If the specified page count is less than the certificate blob size, then the
> + *    required page count is returned with ENOSPC error code.
> + *    If the specified page count is more than the certificate blob size, then
> + *    page count is updated to reflect the amount of valid data copied in the
> + *    vaddr.
> + *
> + * @error: SEV command return code
> + *
> + * Returns:
> + * 0 if the sev successfully processed the command
> + * -%ENODEV    if the sev device is not available
> + * -%ENOTSUPP  if the sev does not support SEV
> + * -%ETIMEDOUT if the sev command timed out
> + * -%EIO       if the sev returned a non-zero return code
> + * -%ENOSPC    if the specified page count is too small
> + */
> +int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int cmd, void *data,
> +				     unsigned long vaddr, unsigned long *npages, int *error);
> +
>   /**
>    * sev_guest_deactivate - perform SEV DEACTIVATE command
>    *
> @@ -945,32 +975,6 @@ void snp_free_firmware_page(void *addr);
>    */
>   void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
>   
> -/**
> - * snp_guest_ext_guest_request - perform the SNP extended guest request command
> - *  defined in the GHCB specification.
> - *
> - * @data: the input guest request structure
> - * @vaddr: address where the certificate blob need to be copied.
> - * @npages: number of pages for the certificate blob.
> - *    If the specified page count is less than the certificate blob size, then the
> - *    required page count is returned with error code defined in the GHCB spec.
> - *    If the specified page count is more than the certificate blob size, then
> - *    page count is updated to reflect the amount of valid data copied in the
> - *    vaddr.
> - *
> - * @sev_ret: sev command return code
> - *
> - * Returns:
> - * 0 if the sev successfully processed the command
> - * -%ENODEV    if the sev device is not available
> - * -%ENOTSUPP  if the sev does not support SEV
> - * -%ETIMEDOUT if the sev command timed out
> - * -%EIO       if the sev returned a non-zero return code
> - */
> -int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> -				unsigned long vaddr, unsigned long *npages,
> -				unsigned long *error);
> -
>   #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>   
>   static inline int
> @@ -1013,9 +1017,9 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>   
>   static inline void snp_free_firmware_page(void *addr) { }
>   
> -static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> -					      unsigned long vaddr, unsigned long *n,
> -					      unsigned long *error)
> +static inline int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int cmd,
> +						   void *data, unsigned long vaddr,
> +						   unsigned long *npages, int *error)
>   {
>   	return -ENODEV;
>   }
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d0e58cffd1ed..b268c35efab4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -394,6 +394,23 @@ static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
>   	return __sev_issue_cmd(sev->fd, id, data, error);
>   }
>   
> +static int sev_issue_cmd_cert(struct kvm *kvm, int id, void *data,
> +			      unsigned long vaddr, unsigned long *npages, int *error)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct fd f;
> +	int ret;
> +
> +	f = fdget(sev->fd);
> +	if (!f.file)
> +		return -EBADF;
> +
> +	ret = sev_issue_cmd_external_user_cert(f.file, id, data, vaddr, npages, error);
> +
> +	fdput(f);
> +	return ret;
> +}
> +
>   static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   {
>   	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -3587,11 +3604,11 @@ static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsig
>   	int ret;
>   
>   	ret = snp_page_reclaim(pfn);
> -	if (ret)
> +	if (ret && (*rc == SEV_RET_SUCCESS))
>   		*rc = SEV_RET_INVALID_ADDRESS;
>   
>   	ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> -	if (ret)
> +	if (ret && (*rc == SEV_RET_SUCCESS))
>   		*rc = SEV_RET_INVALID_ADDRESS;
>   }

I believe we need to fix this as per the GHCB specifications.

As per GHCB 2.0 specifications:

SW_EXITINFO2
...
State from Hypervisor: Upper
32-bits (63:32) will contain the
return code from the hypervisor.
Lower 32-bits (31:0) will contain
the return code from the firmware
call (0 = success)

So i believe the FW error code (which is the FW error code from 
SNP_GUEST_REQUEST or *rc here) should be contained in the lower 32-bits 
and the error code being returned back due to response buffer pages 
reclaim failure and/or failure to transisition these pages back to 
shared state is basically hypervisor (error) return code and that should 
be returned in the upper 32-bit of the exitinfo.

There is work in progress to check conformance of SNP v7 patches to GHCB 
2.0 specifications, so probably this fix can be included as part of 
those patches.

>   
> @@ -3638,8 +3655,9 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>   	struct kvm *kvm = vcpu->kvm;
>   	unsigned long data_npages;
>   	struct kvm_sev_info *sev;
> -	unsigned long rc, err;

This needs to be looked at more carefully. The SEV firmware status code 
is defined as 32-bit, but is being handled as unsigned long in the 
KVM/SNP code and as int in the CCP driver. So this needs to be fixed 
consistently across, snp_setup_guest_buf() return value will need to be 
fixed accordingly.

> +	unsigned long exitcode;
>   	u64 data_gpa;
> +	int err, rc;
>   
>   	if (!sev_snp_guest(vcpu->kvm)) {
>   		rc = SEV_RET_INVALID_GUEST;
> @@ -3669,17 +3687,16 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>   	 */
>   	if (sev->snp_certs_len) {
>   		if ((data_npages << PAGE_SHIFT) < sev->snp_certs_len) {
> -			rc = -EINVAL;
> -			err = SNP_GUEST_REQ_INVALID_LEN;
> +			rc = -ENOSPC;

Why do we need to introduce ENOSPC error code?

If we continue to use SNP_GUEST_REQ_INVALID_LEN we don't need to map 
ENOSPC to SNP_GUEST_REQ_INVALID_LEN below.

And the CCP driver can return SNP_GUEST_REQ_INVALID_LEN as earlier via 
the fw_err parameter.

Thanks,
Ashish

>   			goto datalen;
>   		}
> -		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
> -				   (int *)&err);
> +		rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req, &err);
>   	} else {
> -		rc = snp_guest_ext_guest_request(&req,
> -						 (unsigned long)sev->snp_certs_data,
> -						 &data_npages, &err);
> +		rc = sev_issue_cmd_cert(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req,
> +					(unsigned long)sev->snp_certs_data,
> +					&data_npages, &err);
>   	}
> +
>   datalen:
>   	if (sev->snp_certs_len)
>   		data_npages = sev->snp_certs_len >> PAGE_SHIFT;
> @@ -3689,27 +3706,30 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
>   		 * If buffer length is small then return the expected
>   		 * length in rbx.
>   		 */
> -		if (err == SNP_GUEST_REQ_INVALID_LEN)
> +		if (rc == -ENOSPC) {
>   			vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
> +			exitcode = SNP_GUEST_REQ_INVALID_LEN;
> +			goto cleanup;
> +		}
>   
>   		/* pass the firmware error code */
> -		rc = err;
> +		exitcode = err;
>   		goto cleanup;
>   	}
>   
>   	/* Copy the certificate blob in the guest memory */
>   	if (data_npages &&
>   	    kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
> -		rc = SEV_RET_INVALID_ADDRESS;
> +		exitcode = SEV_RET_INVALID_ADDRESS;
>   
>   cleanup:
> -	snp_cleanup_guest_buf(&req, &rc);
> +	snp_cleanup_guest_buf(&req, &exitcode);
>   
>   unlock:
>   	mutex_unlock(&sev->guest_req_lock);
>   
>   e_fail:
> -	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
> +	svm_set_ghcb_sw_exit_info_2(vcpu, exitcode);
>   }
>   
>   static kvm_pfn_t gfn_to_pfn_restricted(struct kvm *kvm, gfn_t gfn)
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 6c4fdcaed72b..73f56c20255c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2070,8 +2070,8 @@ int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *erro
>   }
>   EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
>   
> -int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
> -				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
> +int sev_issue_cmd_external_user_cert(struct file *filep, unsigned int cmd, void *data,
> +				     unsigned long vaddr, unsigned long *npages, int *error)
>   {
>   	unsigned long expected_npages;
>   	struct sev_device *sev;
> @@ -2093,12 +2093,11 @@ int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>   	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
>   	if (*npages < expected_npages) {
>   		*npages = expected_npages;
> -		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
>   		mutex_unlock(&sev->snp_certs_lock);
> -		return -EINVAL;
> +		return -ENOSPC;
>   	}
>   
> -	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);
> +	rc = sev_issue_cmd_external_user(filep, cmd, data, error);
>   	if (rc) {
>   		mutex_unlock(&sev->snp_certs_lock);
>   		return rc;
> @@ -2115,7 +2114,7 @@ int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>   	mutex_unlock(&sev->snp_certs_lock);
>   	return rc;
>   }
> -EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
> +EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user_cert);
>   
>   static void sev_exit(struct kref *ref)
>   {
> 
