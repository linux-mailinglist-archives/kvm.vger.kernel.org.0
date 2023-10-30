Return-Path: <kvm+bounces-127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 326487DC03E
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 20:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B4E228162C
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 19:16:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9D319BDD;
	Mon, 30 Oct 2023 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e9AXbyC0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC0219BB4
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 19:16:36 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C289A9;
	Mon, 30 Oct 2023 12:16:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSUx4g6uGwBtlUmiCJdw7Y6h8cJPvXsqqXsP5nsW0UB/HjcJl4nhe5w1c9Ff6JO7mw5bcBR34SbXuwI+8vr5IyplZfJn2Me+orFJTGP84OrJVX1FbrQPC/WYX6S/hpVNpiwDiQi6g+CWWxQChzVu7+Lnr4Pu/kPpHF5nh7yw8b9fwBXfnUTur+x34sh4FtCqrsd4MI+xh5uC+Kp/ePk5GzgsVzf6ZayKkWQrsPbQvbSt8pXqtZmhJznCQK3UvjtTGrCH69G3Xm4tK0LfEzJcxTCbfk9mCiE2ZYhsy4y9PiOZO/shhGDhu98mPcxRfIjZhb11Je6mG2N2ClPMK3+kRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7XHHu9pPfAffYwhGoaSlLoLFDOKDFrJ2OCa/89KqQcc=;
 b=WAZu3eBCx9ZCbHdublvx+Ed1oG2cTb8soq2gMRFDRVIrd+8Zp7Pg3dlG9R+byFm/2YlDbBpcaQkL0vr+as+sUoYfoxvbHgpS9lllySLEEjg1MwDC9frfRVKicj0fFu+eg1u8uPm5lRHr86AXP0xurNZmwgUYxgncpUVSqCB56IgqB9C2Qg1WL9AzcV9smXHHNMXWm/kFceW7yssocUh/w2ecPxJAWAbT1eX5xA479KxM0IzSfP1wHXEwllSheGe6tfli/dFyU7WtWm8QuwjMPBirXuWDpiNuxDkXMlo0QahuPakGIXJSo6rZt6d75Iu5qYRi+yQSnHreJEsWIBzuqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XHHu9pPfAffYwhGoaSlLoLFDOKDFrJ2OCa/89KqQcc=;
 b=e9AXbyC0FJC24Og3EOosQn2ovolhvZ/4c70DhJPFEgQoPMHab3b1JkxuBT9Y6cZylGhWLrlZIB3fpvTemGwLfqoMq3IBccdF+oZwKSVnta7o3+3B7q+BKDAo1iDNV07qPxzfPjYqtLjYSOcKGYUsimvuIHd/RUl43aPp3cZ4m2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by BY5PR12MB4855.namprd12.prod.outlook.com (2603:10b6:a03:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Mon, 30 Oct
 2023 19:16:28 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 19:16:28 +0000
Message-ID: <d34d280d-badb-18e1-c17e-bcf079f368de@amd.com>
Date: Mon, 30 Oct 2023 14:16:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 07/14] x86/sev: Move and reorganize sev guest request
 api
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-8-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-8-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:806:f2::30) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|BY5PR12MB4855:EE_
X-MS-Office365-Filtering-Correlation-Id: d49f8f1e-e49d-41f2-9111-08dbd97cb79f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8A6B8YOZ5urQsb9vWO+m9iOsVNUCI4mzfN769h8UI5LYwp2gZ4HGvXWw8CAUyB1+WDPkR88lFvLT5jFo3QdFrzf0iy1af5qC6n5kqylvqgVR/kvpvPo5QQA8MUTVfd9Xbz/WKIJby3g5olin9XKpWsb0pCYd7khiMowV3atuWxyKvAKXP+in+O/cIWu1lgRI/j0aOUVImzaWTbiIrN65+r4b0RKKC12pPbYa8zZ4rwJTjmgwtdLRjUcaaqY4I8zdBZcYD335o/9LwPJtmYykY30VmOlPuwYBSCX26EOR7aZDKbPlbemcLKqzLq3oIzmsv8V4IA36TQp0tyhvxzpkAOh1f03tUIy5++kjLaXhsUM70KLxpyFSRgoPJ40p9ud1C+TuznkpPjigc/w/MWW/szmTT5jVHqFeT3b6hR/LUIcOWUqcJsIcp0WSwq0VTsCaSDso0wxG3GnPjH7bieP/YrEvmK36kmn7dTyPiYIS2K8JtedAAc0pqkJP/Zhd9YKLo51uKNlxC7vFx69OG4/gGkw6O6xpiHNPNOc6HnHqqfd53Sdcv7fPGALypPrgTn2ON/zXtWB44DNw7tE7f0EDNoczyA4FxiWMPKFUDfiS8VD9hMOuTfVQMLB6297bMIGLrHAlHKJp5BrEn221LrNkFQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(31686004)(478600001)(66946007)(6666004)(6506007)(6486002)(83380400001)(36756003)(38100700002)(66556008)(2616005)(30864003)(66476007)(41300700001)(2906002)(316002)(6512007)(26005)(53546011)(86362001)(4326008)(31696002)(8676002)(8936002)(5660300002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlFaTmsrOEh6SEVTdERJSUo2WVEvNEx4YlZjaGJHWHpkMEFCOXpmRzB6eUgx?=
 =?utf-8?B?Y2ZnT0FEMUJYczR6S3k3R0x6dlNZZHNaVys2S2I2SEtNT3kzdndWQUE4S2p4?=
 =?utf-8?B?cVB1MzEvM3VtYXlZNDdRL29KeFdWaUZjODBmR0VDZ2xYalBlWS95SThEamh5?=
 =?utf-8?B?WWJ3NzJVUGoyWlE4ZW8yT3Btd05YMXF6NWlXNGErZ2EzQTRrYWo1K1ltQVhi?=
 =?utf-8?B?Z1d2bXBQdEZYVnk0THgvQTMvK1pTREV5Rk8xdHRHTXROU1JUWStGMGZ6dWFQ?=
 =?utf-8?B?cjFnUHhESVpncWI3MUxPZDVDc05MTWU1RzhEditjWHBhdUNiNjduN0FVanhr?=
 =?utf-8?B?ZjhrQkc4VVc1dkEzeWJxUVRwWERVSU41UU1TTFlVNysyVHQxUUllclVkc3Nn?=
 =?utf-8?B?VXk5OTlSSmZEWHpMWklmcEszNzNNVWpEUVZRS0VHckcydno5VzFhZUlTdVJ5?=
 =?utf-8?B?NWhXQVhXcUNvei9NUGxQRnIzNDBYbVY3MlNJR2NaSDlndWRZSzF3aFVvYWRI?=
 =?utf-8?B?cnJCZldZaEdBYzFBUnJuWjV4d2MvVFQ4emJqdXRINEs5aHdoek0yRXZNU1F6?=
 =?utf-8?B?bDk5RGQ4OExmUnFEdnJoTC9xMklZczZkdDhKd0diM1djamZvaEZUY0cwNTZr?=
 =?utf-8?B?SllqVlZ1WnA4RWJRbTVUSHJKVHhVR1lFS0pPMnhQbHVuVzhUN29TaUYvZGIy?=
 =?utf-8?B?NjlKRG5oOUc4d3hyTjR6M1k4WTRQWmRpQTlaMmZta1kwYW0vZjZvakMyMDZH?=
 =?utf-8?B?TkQ5VHNobHc2RFp0b3E5V3NTa25hV1BYZ1FWZTBqQzhCbTkxZ1RzMUUwN05G?=
 =?utf-8?B?aGpRRGZyUmFPRENOZ1FReXlEZitpTEJyU3NHZ1graW5PZTIydk5jRzhBdlhy?=
 =?utf-8?B?elppejBaekEzZ2lPRkRDVExTZkI0LzByYThnUWRublpkcEJQL1gwWk9zRjNp?=
 =?utf-8?B?SEpKR2NVYjcrdkczd1VmVmljL2drMU5zamFvaVh1aHAzNGJPT21yaGtmVTlZ?=
 =?utf-8?B?Q25haGFkZVBPSTdLd3lvUHhLeitoSFlTQkxRNnJnY2ZQbHJKVTBNc1dhS3NF?=
 =?utf-8?B?MGVNNjlVZWgzWGl6VzNaaWN0YVpqMGc2Z0tNUWVDcFVSSWhSU3dBMVVFRy9v?=
 =?utf-8?B?UDF6cURCU2c0NnNVY2VIQ0cvd1hpYVd2Vk44VHROT2xWdmtmZDFPcGxMbkEy?=
 =?utf-8?B?Q0lET2kwdUI5c2NJaXpJU3d4Rm5BTGsxRjMvRTV0NFJpcXBPcm8rN1NRell5?=
 =?utf-8?B?MFpCby9saFRJdnRjeVNBc1YwOERBMVB3bFluRjRXY0U0NXhJdlpiRkc5OHNM?=
 =?utf-8?B?aStLVUtJS1N3eGw2dDZzQkc3SkpzNEVVSmdONUU0cU5NVi9GbVpYSGQwL1Mx?=
 =?utf-8?B?UDIydDNwMTBIQm5MZVhJQWczbUlSaEpMOVZLN0tYQllrVFR1dWxRK1JIRTBx?=
 =?utf-8?B?bGIyUTNyb3BoK2wrMFgrdWVUSzIxa3FQUlIwSVV5Y1A3RTVlenl5K0dNSkIr?=
 =?utf-8?B?MmtTaDRlaUQ0QmpjMGFqMmJ2eGRhYXNOZk1ObGNBQ25JT1p4WmpJcjUxc3pt?=
 =?utf-8?B?Vkp2SWREZDZNYm1qRi81Unp1cDl4Z00zVjNBZU9DOG9zOTR5bllWTEdMZGNT?=
 =?utf-8?B?cUFQeWtLQmMzWW5Hekp3TlI5UzROclp5anRPVG1kYldVSXRzYkpmWUM2eDhQ?=
 =?utf-8?B?NFVRR0M2WWxkWHphaTcrSHQ4enRxMVgwWXMydHovOVQ0NmFjYXJLbnpoOWl3?=
 =?utf-8?B?QjdrQkhlNUNSYjFBa0xkVnpnT1N3OUpmRkNlL3M4Uk9sbUtIeGw0RWU2RjFL?=
 =?utf-8?B?Q0F3Z1RPL2tOWHZYZUg4eFNYNm9KMFBJWTJvWGRnM0RNQnF4dENJV0ZuY2Ju?=
 =?utf-8?B?bTFJdDl1d0tuVFVDZDd5VjV4emhUV29vdnlzTzArWjlVL2k4bXdyZTZUdlMv?=
 =?utf-8?B?VWZabXk4anlLeXpJUmtLNXBqcy9nbDJnK0h5OXRtaUJmZXhZaHlwZDRDL3Bz?=
 =?utf-8?B?R1R3cGNWSXhLUDFVZHAzN0xrZTJneXlTN2tJMWVQSXFXWTMzeW5YZ1NqNG9u?=
 =?utf-8?B?MmVkaWxOcVdkbnpWQ0hrYllTNUp2WTlvVjh4Y3Bqc3JDbEFhWHc5cWdzNUZn?=
 =?utf-8?Q?IDxvdA3nyPcOGD+4AjBYfd/Kx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d49f8f1e-e49d-41f2-9111-08dbd97cb79f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 19:16:28.4942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oLgHdJtuXu1db4uTwLrgn5uYAouei028BvuYEi31gf7Pxd3XeJlgDVaW4u38X8mVhnIqd1F4+kTS8p/v/EWkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4855

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> For enabling Secure TSC, SEV-SNP guests need to communicate with the
> AMD Security Processor early during boot. Many of the required
> functions are implemented in the sev-guest driver and therefore not
> available at early boot. Move the required functions and provide an
> API to the driver to assign key and send guest request.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>   arch/x86/Kconfig                        |   1 +
>   arch/x86/include/asm/sev-guest.h        |  84 +++-
>   arch/x86/include/asm/sev.h              |  10 -
>   arch/x86/kernel/sev.c                   | 466 ++++++++++++++++++++++-
>   drivers/virt/coco/sev-guest/Kconfig     |   1 -
>   drivers/virt/coco/sev-guest/sev-guest.c | 486 +-----------------------
>   6 files changed, 555 insertions(+), 493 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 66bfabae8814..245a18f6910a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1509,6 +1509,7 @@ config AMD_MEM_ENCRYPT
>   	select ARCH_HAS_CC_PLATFORM
>   	select X86_MEM_ENCRYPT
>   	select UNACCEPTED_MEMORY
> +	select CRYPTO_LIB_AESGCM
>   	help
>   	  Say yes to enable support for the encryption of system memory.
>   	  This requires an AMD processor that supports Secure Memory
> diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
> index 22ef97b55069..e6f94208173d 100644
> --- a/arch/x86/include/asm/sev-guest.h
> +++ b/arch/x86/include/asm/sev-guest.h
> @@ -11,6 +11,11 @@
>   #define __VIRT_SEVGUEST_H__
>   
>   #include <linux/types.h>
> +#include <linux/miscdevice.h>
> +#include <asm/sev.h>
> +
> +#define SNP_REQ_MAX_RETRY_DURATION    (60*HZ)
> +#define SNP_REQ_RETRY_DELAY           (2*HZ)
>   
>   #define MAX_AUTHTAG_LEN		32
>   #define AUTHTAG_LEN		16
> @@ -58,11 +63,45 @@ struct snp_guest_msg_hdr {
>   	u8 rsvd3[35];
>   } __packed;
>   
> +/* SNP Guest message request */
> +struct snp_req_data {
> +	unsigned long req_gpa;
> +	unsigned long resp_gpa;
> +};
> +
>   struct snp_guest_msg {
>   	struct snp_guest_msg_hdr hdr;
>   	u8 payload[4000];
>   } __packed;
>   
> +struct sev_guest_platform_data {
> +	/* request and response are in unencrypted memory */
> +	struct snp_guest_msg *request, *response;
> +
> +	struct snp_secrets_page_layout *layout;
> +	struct snp_req_data input;
> +};
> +
> +struct snp_guest_dev {
> +	struct device *dev;
> +	struct miscdevice misc;
> +
> +	/* Mutex to serialize the shared buffer access and command handling. */
> +	struct mutex cmd_mutex;
> +
> +	void *certs_data;
> +	struct aesgcm_ctx *ctx;
> +
> +	/*
> +	 * Avoid information leakage by double-buffering shared messages
> +	 * in fields that are in regular encrypted memory
> +	 */
> +	struct snp_guest_msg secret_request, secret_response;
> +
> +	struct sev_guest_platform_data *pdata;
> +	unsigned int vmpck_id;
> +};
> +
>   struct snp_guest_req {
>   	void *req_buf, *resp_buf, *data;
>   	size_t req_sz, resp_sz, *data_npages;
> @@ -72,6 +111,47 @@ struct snp_guest_req {
>   	u8 msg_type;
>   };
>   
> -int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
> -			    struct snp_guest_request_ioctl *rio);
> +int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
> +int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_req *req,
> +			   struct snp_guest_request_ioctl *rio);
> +bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id);
> +bool snp_is_vmpck_empty(unsigned int vmpck_id);
> +
> +static void free_shared_pages(void *buf, size_t sz)

These should probably be marked __inline if you're going to define them in 
a header file.

> +{
> +	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +	int ret;
> +
> +	if (!buf)
> +		return;
> +
> +	ret = set_memory_encrypted((unsigned long)buf, npages);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
> +		return;
> +	}
> +
> +	__free_pages(virt_to_page(buf), get_order(sz));
> +}
> +
> +static void *alloc_shared_pages(size_t sz)
> +{
> +	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
> +	struct page *page;
> +	int ret;
> +
> +	page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
> +	if (!page)
> +		return NULL;
> +
> +	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
> +	if (ret) {
> +		pr_err("%s: failed to mark page shared, ret=%d\n", __func__, ret);
> +		__free_pages(page, get_order(sz));
> +		return NULL;
> +	}
> +
> +	return page_address(page);
> +}
> +
>   #endif /* __VIRT_SEVGUEST_H__ */
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 78465a8c7dc6..783150458864 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -93,16 +93,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
>   
>   #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
>   
> -/* SNP Guest message request */
> -struct snp_req_data {
> -	unsigned long req_gpa;
> -	unsigned long resp_gpa;
> -};
> -
> -struct sev_guest_platform_data {
> -	u64 secrets_gpa;
> -};
> -
>   /*
>    * The secrets page contains 96-bytes of reserved field that can be used by
>    * the guest OS. The guest OS uses the area to save the message sequence
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index fd3b822fa9e7..fb3b1feb1b84 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -24,6 +24,7 @@
>   #include <linux/io.h>
>   #include <linux/psp-sev.h>
>   #include <uapi/linux/sev-guest.h>
> +#include <crypto/gcm.h>
>   
>   #include <asm/cpu_entry_area.h>
>   #include <asm/stacktrace.h>
> @@ -941,6 +942,457 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
>   		free_page((unsigned long)vmsa);
>   }
>   
> +static struct sev_guest_platform_data *platform_data;
> +
> +static inline u8 *snp_get_vmpck(unsigned int vmpck_id)
> +{
> +	if (!platform_data)
> +		return NULL;
> +
> +	return platform_data->layout->vmpck0 + vmpck_id * VMPCK_KEY_LEN;
> +}
> +
> +static inline u32 *snp_get_os_area_msg_seqno(unsigned int vmpck_id)
> +{
> +	if (!platform_data)
> +		return NULL;
> +
> +	return &platform_data->layout->os_area.msg_seqno_0 + vmpck_id;
> +}
> +
> +bool snp_is_vmpck_empty(unsigned int vmpck_id)
> +{
> +	char zero_key[VMPCK_KEY_LEN] = {0};
> +	u8 *key = snp_get_vmpck(vmpck_id);
> +
> +	if (key)
> +		return !memcmp(key, zero_key, VMPCK_KEY_LEN);
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(snp_is_vmpck_empty);
> +
> +/*
> + * If an error is received from the host or AMD Secure Processor (ASP) there
> + * are two options. Either retry the exact same encrypted request or discontinue
> + * using the VMPCK.
> + *
> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> + * cannot tolerate IV reuse.
> + *
> + * The ASP FW v1.51 only increments the sequence numbers on a successful
> + * guest<->ASP back and forth and only accepts messages at its exact sequence
> + * number.
> + *
> + * So if the sequence number were to be reused the encryption scheme is
> + * vulnerable. If the sequence number were incremented for a fresh IV the ASP
> + * will reject the request.
> + */
> +static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
> +{
> +	u8 *key = snp_get_vmpck(snp_dev->vmpck_id);
> +
> +	pr_alert("Disabling vmpck_id %d to prevent IV reuse.\n", snp_dev->vmpck_id);
> +	memzero_explicit(key, VMPCK_KEY_LEN);
> +}
> +
> +static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> +{
> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev->vmpck_id);
> +	u64 count;
> +
> +	if (!os_area_msg_seqno) {
> +		pr_err("SNP unable to get message sequence counter\n");
> +		return 0;
> +	}
> +
> +	lockdep_assert_held(&snp_dev->cmd_mutex);
> +
> +	/* Read the current message sequence counter from secrets pages */
> +	count = *os_area_msg_seqno;
> +
> +	return count + 1;
> +}
> +
> +/* Return a non-zero on success */
> +static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
> +{
> +	u64 count = __snp_get_msg_seqno(snp_dev);
> +
> +	/*
> +	 * The message sequence counter for the SNP guest request is a  64-bit
> +	 * value but the version 2 of GHCB specification defines a 32-bit storage
> +	 * for it. If the counter exceeds the 32-bit value then return zero.
> +	 * The caller should check the return value, but if the caller happens to
> +	 * not check the value and use it, then the firmware treats zero as an
> +	 * invalid number and will fail the  message request.
> +	 */
> +	if (count >= UINT_MAX) {
> +		pr_err("SNP request message sequence counter overflow\n");
> +		return 0;
> +	}
> +
> +	return count;
> +}
> +
> +static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
> +{
> +	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev->vmpck_id);
> +
> +	if (!os_area_msg_seqno) {
> +		pr_err("SNP unable to get message sequence counter\n");
> +		return;
> +	}

I probably missed this in the other patch or even when the driver was 
first created, but shouldn't we have a lockdep_assert_held() here, too, 
before updating the count?

> +
> +	/*
> +	 * The counter is also incremented by the PSP, so increment it by 2
> +	 * and save in secrets page.
> +	 */
> +	*os_area_msg_seqno += 2;
> +}
> +
> +static struct aesgcm_ctx *snp_init_crypto(unsigned int vmpck_id)
> +{
> +	struct aesgcm_ctx *ctx;
> +	u8 *key;
> +
> +	if (snp_is_vmpck_empty(vmpck_id)) {
> +		pr_err("SNP: vmpck id %d is null\n", vmpck_id);
> +		return NULL;
> +	}
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
> +	if (!ctx)
> +		return NULL;
> +
> +	key = snp_get_vmpck(vmpck_id);
> +	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
> +		pr_err("SNP: crypto init failed\n");
> +		kfree(ctx);
> +		return NULL;
> +	}
> +
> +	return ctx;
> +}
> +
> +int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev)
> +{
> +	struct sev_guest_platform_data *pdata;
> +	int ret;
> +
> +	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
> +		pr_err("SNP not supported\n");
> +		return 0;
> +	}
> +
> +	if (platform_data) {
> +		pr_debug("SNP platform data already initialized.\n");
> +		goto create_ctx;
> +	}
> +
> +	if (!secrets_pa) {
> +		pr_err("SNP no secrets page\n");

Maybe "SNP secrets page not found\n" ?

> +		return -ENODEV;
> +	}
> +
> +	pdata = kzalloc(sizeof(struct sev_guest_platform_data), GFP_KERNEL);
> +	if (!pdata) {
> +		pr_err("SNP alloc failed\n");

Maybe "Allocation of SNP guest platform data failed\n" ?

> +		return -ENOMEM;
> +	}
> +
> +	pdata->layout = (__force void *)ioremap_encrypted(secrets_pa, PAGE_SIZE);
> +	if (!pdata->layout) {
> +		pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");

Maybe "Failed to map SNP secrets page\n" ? Not sure where the AP jump 
table came in on this...

> +		goto e_free_pdata;
> +	}
> +
> +	ret = -ENOMEM;
> +	/* Allocate the shared page used for the request and response message. */
> +	pdata->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
> +	if (!pdata->request)
> +		goto e_unmap;
> +
> +	pdata->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
> +	if (!pdata->response)
> +		goto e_free_request;
> +
> +	/* initial the input address for guest request */
> +	pdata->input.req_gpa = __pa(pdata->request);
> +	pdata->input.resp_gpa = __pa(pdata->response);
> +	platform_data = pdata;
> +
> +create_ctx:
> +	ret = -EIO;
> +	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck_id);
> +	if (!snp_dev->ctx) {
> +		pr_err("SNP init crypto failed\n");

Maybe "SNP crypto context initialization failed\n" ?

> +		platform_data = NULL;
> +		goto e_free_response;
> +	}
> +
> +	snp_dev->pdata = platform_data;

Add a blank line here.

> +	return 0;
> +
> +e_free_response:
> +	free_shared_pages(pdata->response, sizeof(struct snp_guest_msg));
> +e_free_request:
> +	free_shared_pages(pdata->request, sizeof(struct snp_guest_msg));
> +e_unmap:
> +	iounmap(pdata->layout);
> +e_free_pdata:
> +	kfree(pdata);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(snp_setup_psp_messaging);
> +
> +static int __enc_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
> +			 void *plaintext, size_t len)
> +{
> +	struct snp_guest_msg_hdr *hdr = &msg->hdr;
> +	u8 iv[GCM_AES_IV_SIZE] = {};
> +
> +	if (WARN_ON((hdr->msg_sz + ctx->authsize) > sizeof(msg->payload)))
> +		return -EBADMSG;
> +
> +	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> +	aesgcm_encrypt(ctx, msg->payload, plaintext, len, &hdr->algo, AAD_LEN,
> +		       iv, hdr->authtag);
> +	return 0;
> +}
> +
> +static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
> +		       void *plaintext, size_t len)
> +{
> +	struct snp_guest_msg_hdr *hdr = &msg->hdr;
> +	u8 iv[GCM_AES_IV_SIZE] = {};
> +
> +	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> +	if (aesgcm_decrypt(ctx, plaintext, msg->payload, len, &hdr->algo,
> +			   AAD_LEN, iv, hdr->authtag))
> +		return 0;
> +	else
> +		return -EBADMSG;
> +}
> +
> +static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req,
> +				  struct sev_guest_platform_data *pdata)
> +{
> +	struct snp_guest_msg *resp = &snp_dev->secret_response;
> +	struct snp_guest_msg *req = &snp_dev->secret_request;
> +	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
> +	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
> +	struct aesgcm_ctx *ctx = snp_dev->ctx;
> +
> +	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
> +		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
> +		 resp_hdr->msg_sz);
> +
> +	/* Copy response from shared memory to encrypted memory. */
> +	memcpy(resp, pdata->response, sizeof(*resp));
> +
> +	/* Verify that the sequence counter is incremented by 1 */
> +	if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
> +		return -EBADMSG;
> +
> +	/* Verify response message type and version number. */
> +	if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
> +	    resp_hdr->msg_version != req_hdr->msg_version)
> +		return -EBADMSG;
> +
> +	/*
> +	 * If the message size is greater than our buffer length then return
> +	 * an error.
> +	 */
> +	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
> +		return -EBADMSG;
> +
> +	return dec_payload(ctx, resp, guest_req->resp_buf, resp_hdr->msg_sz);
> +}
> +
> +static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
> +{
> +	struct snp_guest_msg *msg = &snp_dev->secret_request;
> +	struct snp_guest_msg_hdr *hdr = &msg->hdr;
> +
> +	memset(msg, 0, sizeof(*msg));
> +
> +	hdr->algo = SNP_AEAD_AES_256_GCM;
> +	hdr->hdr_version = MSG_HDR_VER;
> +	hdr->hdr_sz = sizeof(*hdr);
> +	hdr->msg_type = req->msg_type;
> +	hdr->msg_version = req->msg_version;
> +	hdr->msg_seqno = seqno;
> +	hdr->msg_vmpck = req->vmpck_id;
> +	hdr->msg_sz = req->req_sz;
> +
> +	/* Verify the sequence number is non-zero */
> +	if (!hdr->msg_seqno)
> +		return -ENOSR;
> +
> +	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
> +		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
> +
> +	return __enc_payload(snp_dev->ctx, msg, req->req_buf, req->req_sz);
> +}
> +
> +static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
> +				   struct snp_guest_request_ioctl *rio);

Could all of these routines been moved down closer to the bottom of the 
file to avoid this forward declaration?

> +
> +static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
> +				  struct snp_guest_request_ioctl *rio,
> +				  struct sev_guest_platform_data *pdata)
> +{
> +	unsigned long req_start = jiffies;
> +	unsigned int override_npages = 0;
> +	u64 override_err = 0;
> +	int rc;
> +

...

>   
> -e_free_ctx:
> -	kfree(snp_dev->ctx);
>   e_free_cert_data:
>   	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
> -e_free_response:
> -	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
> -e_free_request:
> -	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
> -e_unmap:
> -	iounmap(mapping);
> + e_free_ctx:
> +	kfree(snp_dev->ctx);
> +e_free_snpdev:
> +	kfree(snp_dev);
>   	return ret;
>   }
>   
> @@ -780,11 +332,9 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
>   {
>   	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
>   
> -	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);

Looks like this one should still be here, right?

Thanks,
Tom

> -	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
> -	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
> -	kfree(snp_dev->ctx);
>   	misc_deregister(&snp_dev->misc);
> +	kfree(snp_dev->ctx);
> +	kfree(snp_dev);
>   
>   	return 0;
>   }

