Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14304607E96
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 21:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJUTCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJUTCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 15:02:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266102764DD;
        Fri, 21 Oct 2022 12:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1Pb3M5knGenxza1++VgyRilfTNHzDp6xl/4h9ZahHphPqbRbOvePHcu5RVPlTHufo4381xCl+xtT34qn/3hyOoem4U8NQ5gnwHa2Ps1dV/lr/9yqaHcGF3qxhicyyZ+SFlra/VXmOEugk60lms+Syyf9ighM0M2rCCTz3IDtZewxySEJ1dhL773tmg3OuYze7ulzS81rm8A8rWlJCygqx78VlEYOTJ7X2zd5rRjxfLXsAek5s0Iu9wiUyzvioQMM4+JbmQHgEeaz33wmWQZ8C+IeNKOA3Bnn/X9NmmezfDb8dqvZFokfY6vXITuoZ/zJ1e1oh0Z3fZdF+6/P+9tUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUscHsuG6TfwC4jDJg3ZNO5fLQ3AUsK1DiNrj+2unE4=;
 b=ct0Oy32O512y9HO+JFdjrSKIumxquQ/YRrM5qFGBMRxEibsNKTwCwwmGD3Je66OrJ4kGibLzx7MwrFaiMpcPsLmafqxzPVpcPTM9yezUsPv1cUM3SfpX7K/WoQKNjgXDxG504AkHFly/raUk1OgypWEk7ML2B1JnxBZL8Z9rXVbvPXITac9rVt3PzdcsMoCXi+RI7xpjejyahUQzCr3mC9eKKIsJO5OTmml4getf+0cnEi2RdsvyTJ5kzC52dFMf1Z7S7ScWhIHrelWUYJJRVtHdynfvq6u6mDJP7r/wMdguZPWrUvkCeJ+rRvCS4GpVw4YN/wT2mRIos8Mg6FLk6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUscHsuG6TfwC4jDJg3ZNO5fLQ3AUsK1DiNrj+2unE4=;
 b=G0qfcXoP3B1TRRckOu//vWLoBNPKVF8sdzK+rTZWV/SV8AguTb627PQgwLFr2EbNYCR4z74mSfqWMXWYdtfidgV8W14oNzlkSuSE5LfXzvnUvdn1ngjyzew22xQqojvMOA7BexSg90IYjMyty+pwIteANhUUeJR/8TJthqWolYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH3PR12MB7523.namprd12.prod.outlook.com (2603:10b6:610:148::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Fri, 21 Oct
 2022 19:02:01 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 19:02:01 +0000
Message-ID: <b7414cda-9924-33c3-68da-9b26b2bcc0b6@amd.com>
Date:   Fri, 21 Oct 2022 14:01:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH V2] virt: Prevent IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221021173328.2489411-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221021173328.2489411-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0095.namprd06.prod.outlook.com
 (2603:10b6:5:336::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH3PR12MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e183139-0969-4b12-d974-08dab396bc1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QHo9bFT8bczl75FpGvoVWDRTaTRUMnfxfWRy4kvOrzPuo7jRBNMMtB8a2gtzZxW5EY5iEDQBzwj3LfqG1KWSp/tckidDULRYlAkRZP/wXhZ7k0Un8AyG/AbJtGwSbZbE9rQArOi1bq3ZhxMbqqcnXby3hiCwcZmHNoYpEvRAK7n4OhK8ANTBTva5SM/O9CzpqwFLtxmZ2zWABXwMuPBLGCqGnBmcO41szmV80dra8SmZxSQ1AI8PIZoJ7qchjZBiIRUodVkD/SxqSEz1DYm0hR1ssvlDOU+vOUq49H4WEuNGu+qMbvA1eTDok8ZKKcG5cQbQwMBlf0nN9VTN1FWnF5zJeTLs30MxzEYLuvvzaN4/IhyNEFmrfAPhARf8D0qpzsLiFiYzX6ckOAmrsd0FpLiSSGAlgYO/3/d/mfL38rSkjwRqvj1iX9eZu7H/BUmHq3l3vlBa0x1QtISCZoyZWGenUxRkJYBP/GT4upIqQaJfVZGzKqge/8YpDc25KGJOmRt4SoGbHKBP9bcTLFrkvoTcJ/QgEVNEZCAdDb6VJKKApDkvKz0NYpZsRba+8OUgkdHdA48qIWCB5/9bgXXpL3sxgNn0U3K3J42+0M8zbMk86FMwJ5IKupnGUzZ7FVjXAEKQcNI0hiCQFj9ycggV2W6T5g0PVbXL3RQmkuu4HEZzlp5kLbQYQpjLejZKboR22IDGU8hzJEh4JlmuGYxcr4L5KodjkkTbeplrLdGQ7OYpXp9wCs2vKmaN0iTUk1+ZL8cb1nnxRReQt7R6izEB6jd+oIKOjvXW5ZQVFeI/Dk/PhMXhSVBtSIFXJKHfmU6+gt7Cu09j2Eq55yJT8V9noQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(4326008)(66946007)(66556008)(5660300002)(8936002)(26005)(8676002)(66476007)(41300700001)(6512007)(53546011)(6506007)(36756003)(6916009)(54906003)(316002)(86362001)(31696002)(83380400001)(2906002)(38100700002)(186003)(2616005)(478600001)(31686004)(966005)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVExQXQ3aU4vWllXV0o4NDcvRkdxSnR0L1NBZnZpZ0hpNVc3VHlHUjlJNXN6?=
 =?utf-8?B?QVNVcWVTTXZnNWxvcnFYYWsvcExDYW5pMzhLRGxGNzc3cDJlNzVpRzZNSDlY?=
 =?utf-8?B?M2RJbElWWTRtdEFLbjZuRjFzSjlvdTdxcEo0R1BJaWVudzlYNGdEMFA0NjAv?=
 =?utf-8?B?WkQrK3o5Nk8waWhJeGZFWE1HWkVvT3BuMGw3Nms4M3Z4WE5qSkQybmJhNHRm?=
 =?utf-8?B?Z2plTUlNUWFuZ3RFT0FEdWladWtWS2dHM3ZRV1N1bzVzQW45K0Y0S2dqWGxM?=
 =?utf-8?B?Wk9SeTN4NkxnSzk3SVJGSUlCV2RZdE96QlJjUm9HRzcvd3hWV3dpRkJCazdK?=
 =?utf-8?B?NVkyRkh6czJCWmczS2lGaEZuVzk5TitidW1ZRExQMTB3QjNlUUJQdXhkblVE?=
 =?utf-8?B?S2N3Ym9xbUd5M2VDNmU0alRvTVBQZEhOeVFnMFp6TkxVUlN5QUlPRkRySU5u?=
 =?utf-8?B?OVdRYUhPczhjZ1dOaW1JYloyVEEyUHA0TGJvaFBIL1J3WURocDFGc2VUL0ow?=
 =?utf-8?B?Mk9FUkdRMHpEc1d3d3hGZW5DaGY2UkU0T2JlNTU2Z21ZcTVIUFQ5U0xSWkdS?=
 =?utf-8?B?OTVSVEM1Q1NkdXJpR3UwV2l6a3FKTDEzRWlGUkVpZEJiZGZ3aGZnQzVJMm1v?=
 =?utf-8?B?bFNRZjBzRlViTjNWZXpic1F2UFJabXQ2T1lQOTF6RnBXTlJGMnJiMkVKQjVT?=
 =?utf-8?B?SzNkbSt6T2xBa0VxVStmdnMyREg1T3lUVWhwK25PSDNCT2NCbW5tb3FtVWtT?=
 =?utf-8?B?akplazFxemZSZXR2UGo0czY3dHpiYjlGbXZ3NW94MEFnMTA2cVBpZU1WVU8v?=
 =?utf-8?B?M1dUa2NNVUdqVnNVVzlSZW1ZMkRabkpQOWsybUdWWWczVHg2TVFUazdqU3FC?=
 =?utf-8?B?OUFmTWw3bVVDbVN2QzAxanM4d3BNVEN0REpodkR1MGRYR0xpenI1dWR2Z1R3?=
 =?utf-8?B?ZWxTY1IxTDE2MG1NYWIrOWhyTDR3MEVCR0tRdkRlYmVHTmJ3RVBhdE1WZlIx?=
 =?utf-8?B?cUVvYkV0RHVuOVZoS0ZVQVJiMERFbit1M01lUE5tQ254LzdTNnZHMjJyWEV2?=
 =?utf-8?B?SmxVcjY3KzdiL0hvcjBTYlVXN2hVSllKVFVFZ2xhL2FpNG02M0kyMmU3Qlcv?=
 =?utf-8?B?SE9jOElucEgwLy9XdXhGWmt3NldXemxwRndOWjY3aHVjd2ZmcEpXTUZoREll?=
 =?utf-8?B?dGtpRnJ3aVpmVnZHVHI4UmVmckdDMG1QVCsvUEl0dld3TGxsV2RFRFlTN0Fo?=
 =?utf-8?B?TlNRMDh4MGZ4bTRyWGdiNG9QVC84ZTFkczlhendhVmx4TnRobW9qaTJDU0Zv?=
 =?utf-8?B?WUd5dk53dkF1ZzNiTUZqbEFENUJnYWJNa0hrMkRpMnJOZE1vdm96S0ZQRHVy?=
 =?utf-8?B?M3BPaGlDRmJ6cUZGdUtSMjdLcEx2WmZPZ2V1OW5aa0ZHQUJMaWRvVTFLRjNH?=
 =?utf-8?B?OEUyRXliU2k5aTdXT1BHTUN2V2dKN2ZqTnlIdmR1cmJlN01PNlJOVnV1RjY4?=
 =?utf-8?B?YlhHNDBQbUFuZ3FLNmhscjhrNFB2NzdHdnpML3MxMkxPWHpwSlBUVjdCcmJI?=
 =?utf-8?B?SnhMRHFkb1pUSlpvdkkxbzVQLzNIREpFMGp6WkI2cHJGWXo4MWtMbUUveCtN?=
 =?utf-8?B?SUJhV2x5Y3FIbzJ6UmExTGFPcVRzbmJONE1wb2pmY0lVM0x6VnJhS0NzZWJ3?=
 =?utf-8?B?UkNBQlBUZ0tyczkzdTlFcmd6SG15ci9NTFhyc2c0OWE2K0MrbzRzTXpjYUpI?=
 =?utf-8?B?MG9KczYveGNtUXFpWHRTVTdIVFQyZ2V0THdKdnFCajRYZzFFeUx1dlVJWmJM?=
 =?utf-8?B?UXN1cnhOSjZ1a21ySVdmZTdOZk93Y3RhbnZlR2U5WEI0NEI3NUhLc1VCZ3px?=
 =?utf-8?B?TWZWQVBhaGI0d0lxMEhDbTVPN3ZVUlJpZXg5dlliejhWaks5NDJTKzVrQk5M?=
 =?utf-8?B?SnJBNitZeHpQVXdRS2hsYTBhZ0FtWE1RSzlEMFY4RnNqTCtyU0NTZzkzQlpa?=
 =?utf-8?B?M1BUNEEySktJMjVRcDVsNGY3N2JjTTJlMUt3TU8wQk5RcFFlR1BZVzJiY09F?=
 =?utf-8?B?dFYvSVkvbFVLdzdaUWx6Mk5TSzl2ZmJTUEFRVUQrSlkzTTh4SUoraURyOVRO?=
 =?utf-8?Q?F4J+NFmkMk/LcYYlnBrEkZ6Nt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e183139-0969-4b12-d974-08dab396bc1a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 19:02:01.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxR9vH2AOj4Qyo9UGZWP40GxNl8XlNa7X13d4JytMzxeWI3WWiWAqK+G87j+rJ2Nq9jCcP39axkTVOb/HTBvyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7523
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/22 12:33, Peter Gonda wrote:
> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> communicate securely with each other. The IV to this scheme is a
> sequence number that both the ASP and the guest track. Currently this
> sequence number in a guest request must exactly match the sequence
> number tracked by the ASP. This means that if the guest sees an error
> from the host during a request it can only retry that exact request or
> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> reuse see:
> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
> 
> To handle userspace querying the cert_data length. Instead of requesting
> the cert length from userspace use the size of the drivers allocated
> shared buffer. Then copy that buffer to userspace, or give userspace an
> error depending on the size of the buffer given by userspace.
> 
> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reported-by: Peter Gonda <pgonda@google.com>
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Haowen Bai <baihaowen@meizu.com>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
>   drivers/virt/coco/sev-guest/sev-guest.c | 93 ++++++++++++++++---------
>   1 file changed, 62 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index f422f9c58ba7..8c54ea84bc57 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -41,7 +41,7 @@ struct snp_guest_dev {
>   	struct device *dev;
>   	struct miscdevice misc;
>   
> -	void *certs_data;
> +	u8 (*certs_data)[SEV_FW_BLOB_MAX_SIZE];
>   	struct snp_guest_crypto *crypto;
>   	struct snp_guest_msg *request, *response;
>   	struct snp_secrets_page_layout *layout;
> @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>   	return true;
>   }
>   
> +/*
> + * If we receive an error from the host or ASP we have two options. We can
> + * either retry the exact same encrypted request or we can discontinue using the
> + * VMPCK.
> + *
> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> + * cannot tolerate IV reuse.
> + *
> + * The ASP FW v1.51 only increments the sequence numbers on a successful
> + * guest<->ASP back and forth and only accepts messages at its exact sequence
> + * number.
> + *
> + * So if we were to reuse the sequence number the encryption scheme is
> + * vulnerable. If we encrypt the sequence number for a fresh IV the ASP will
> + * reject our request.
> + */
>   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>   {
> +	dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
> +		  vmpck_id);
>   	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>   	snp_dev->vmpck = NULL;
>   }
> @@ -326,29 +345,29 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
>   	if (fw_err)
>   		*fw_err = err;
>   
> -	if (rc)
> -		return rc;
> +	if (rc) {
> +		dev_alert(snp_dev->dev,
> +			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
> +			  rc, *fw_err);
> +		goto disable_vmpck;
> +	}
>   
> -	/*
> -	 * The verify_and_dec_payload() will fail only if the hypervisor is
> -	 * actively modifying the message header or corrupting the encrypted payload.
> -	 * This hints that hypervisor is acting in a bad faith. Disable the VMPCK so that
> -	 * the key cannot be used for any communication. The key is disabled to ensure
> -	 * that AES-GCM does not use the same IV while encrypting the request payload.
> -	 */
>   	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
>   	if (rc) {
>   		dev_alert(snp_dev->dev,
> -			  "Detected unexpected decode failure, disabling the vmpck_id %d\n",
> -			  vmpck_id);
> -		snp_disable_vmpck(snp_dev);
> -		return rc;
> +			  "Detected unexpected decode failure from ASP. rc: %d\n",
> +			  rc);
> +		goto disable_vmpck;
>   	}
>   
>   	/* Increment to new message sequence after payload decryption was successful. */
>   	snp_inc_msg_seqno(snp_dev);
>   
>   	return 0;
> +
> +disable_vmpck:
> +	snp_disable_vmpck(snp_dev);
> +	return rc;
>   }
>   
>   static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
> @@ -437,7 +456,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_ext_report_req req;
>   	struct snp_report_resp *resp;
> -	int ret, npages = 0, resp_len;
> +	int ret, resp_len, req_cert_len, resp_cert_len;
>   
>   	lockdep_assert_held(&snp_cmd_mutex);
>   
> @@ -448,14 +467,15 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   		return -EFAULT;
>   
>   	/* userspace does not want certificate data */
> -	if (!req.certs_len || !req.certs_address)
> +	req_cert_len = req.certs_len;
> +	if (!req_cert_len || !req.certs_address)
>   		goto cmd;
>   
> -	if (req.certs_len > SEV_FW_BLOB_MAX_SIZE ||
> -	    !IS_ALIGNED(req.certs_len, PAGE_SIZE))
> +	if (req_cert_len > sizeof(*snp_dev->certs_data) ||
> +	    !IS_ALIGNED(req_cert_len, PAGE_SIZE))
>   		return -EINVAL;
>   
> -	if (!access_ok((const void __user *)req.certs_address, req.certs_len))
> +	if (!access_ok((const void __user *)req.certs_address, req_cert_len))
>   		return -EFAULT;
>   
>   	/*
> @@ -464,8 +484,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	 * the host. If host does not supply any certs in it, then copy
>   	 * zeros to indicate that certificate data was not provided.
>   	 */
> -	memset(snp_dev->certs_data, 0, req.certs_len);
> -	npages = req.certs_len >> PAGE_SHIFT;
> +	memset(snp_dev->certs_data, 0, sizeof(*snp_dev->certs_data));
>   cmd:
>   	/*
>   	 * The intermediate response buffer is used while decrypting the
> @@ -477,25 +496,37 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	if (!resp)
>   		return -ENOMEM;
>   
> -	snp_dev->input.data_npages = npages;
> +	snp_dev->input.data_npages = sizeof(*snp_dev->certs_data) >> PAGE_SHIFT;
>   	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg->msg_version,
>   				   SNP_MSG_REPORT_REQ, &req.data,
>   				   sizeof(req.data), resp->data, resp_len, &arg->fw_err);
>   
> +	resp_cert_len = snp_dev->input.data_npages << PAGE_SHIFT;

The hypervisor is not required to update the number of pages that the 
certificates actually used/required if enough pages were supplied. So this 
value could always remain as 4 (based on SEV_FW_BLOB_MAX_SIZE) on 
successful return.

And if that's the case, we could always just return 4 for the number of 
pages no matter what. Otherwise you'll have to update the logic here if 
you want to obtain the actual number.

Thanks,
Tom

> +
>   	/* If certs length is invalid then copy the returned length */
>   	if (arg->fw_err == SNP_GUEST_REQ_INVALID_LEN) {
> -		req.certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
> +		dev_alert(snp_dev->dev,
> +			  "Certificate data from host: %d, Max size allocated by driver: %lu.\n",
> +			  resp_cert_len, sizeof(*snp_dev->certs_data));
> +		ret = -EFAULT;
> +	}
> +
> +	if (ret)
> +		goto e_free;
> +
> +	/* Pass the actual certificate data size back to userspace */
> +	req.certs_len = resp_cert_len;
> +	if (resp_cert_len > req_cert_len) {
> +		arg->fw_err = SNP_GUEST_REQ_INVALID_LEN;
>   
>   		if (copy_to_user((void __user *)arg->req_data, &req, sizeof(req)))
>   			ret = -EFAULT;
> -	}
>   
> -	if (ret)
>   		goto e_free;
> +	}
>   
> -	if (npages &&
> -	    copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
> -			 req.certs_len)) {
> +	if (copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
> +			 resp_cert_len)) {
>   		ret = -EFAULT;
>   		goto e_free;
>   	}
> @@ -676,7 +707,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   	if (!snp_dev->response)
>   		goto e_free_request;
>   
> -	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
> +	snp_dev->certs_data = alloc_shared_pages(dev, sizeof(*snp_dev->certs_data));
>   	if (!snp_dev->certs_data)
>   		goto e_free_response;
>   
> @@ -703,7 +734,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   	return 0;
>   
>   e_free_cert_data:
> -	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> +	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
>   e_free_response:
>   	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
>   e_free_request:
> @@ -717,7 +748,7 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
>   {
>   	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
>   
> -	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> +	free_shared_pages(snp_dev->certs_data, sizeof(*snp_dev->certs_data));
>   	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
>   	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
>   	deinit_crypto(snp_dev->crypto);
