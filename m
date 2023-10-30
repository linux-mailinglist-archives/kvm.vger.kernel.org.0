Return-Path: <kvm+bounces-120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8557DBF5F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3689DB20CCF
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1389B18E37;
	Mon, 30 Oct 2023 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qI6TNeQN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B282FD262
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:51:50 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A431FE4;
	Mon, 30 Oct 2023 10:51:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+rBsq/pmnykKCKoQMeNrGazJ1Be2zJCsRGnG88UiWkRHE2ENITqtQY8MF9OTDI8aF8BtD++0/IH8HWxsgfwJkTUH7eB+5kcz+tBfqCjKWB+kQgqitmAOeliaoKOnCyslAmMcsFtzlQGI6yK84VOD/7mRUt6TO6Wcv8Sx28nJVQ2kABrhxxqxZH6sg1RiAvPnGWsqsbkl09+/mxa8hbKf0LDF+g9EI7XXPxFC+h4+DOsgKbPPVO8CcazRW7BxiuQ5Fi2oMZjuRXfQhF4QZf8U2T73bBtxBGCK9mwrcyEqCQ1atvNGbO2pWOCiVlEU3JMgeQa1OMuQSVtsO22Epvd1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MlM9mwuiO7ZdevP/PD0xBNFGLMDvCebRaKmz4xyPXj0=;
 b=dC5JK9GiNl0IYFP/6a8wvjVZy/mZigqmfx02JpCfj4Jk1jlA6EZgC6E0/pcH6lAPxU6JEEXuBLoJshGcCpOaZ8w7fJJK9YstENZjAwDOU8/egevcu8YVTAYFirZ8EWQUD0RkIQnoMrbEw6gwt71boxK48pDV8S5bdwZx3g9aszSKk+OoTnbs5stIjiy5xTEl7y0DTGorjY82r6y+LU4oYlkcO5rg1vsB9etjzyheklGpe2ZuwOEcGywnqAF06oOUgOSRV9NgXHGX1WSZNjpVuD+XTExBTAbW0kRrvFVrL2tgLgD569kfhRKqzJkpeYa7Hb38od9EZWFaW5J3BFI36A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlM9mwuiO7ZdevP/PD0xBNFGLMDvCebRaKmz4xyPXj0=;
 b=qI6TNeQNgQkjxfbQAgrpo2toI5G2kO3tVnKci3vVqz0NQXeyxAnYylk9NeuljHHdmBnXrD86nXbuIb5DX3ijgd97QcN05i7mF6m8GuHw4uXSg0hoDW9tjIspCJBSqx3fHwOHdwTsSYwuV3dAXI8L9RdXrZb3fAEjUv3KH/Xk85o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.26; Mon, 30 Oct
 2023 17:51:43 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::e16e:d7f1:94ad:3021%7]) with mapi id 15.20.6933.027; Mon, 30 Oct 2023
 17:51:43 +0000
Message-ID: <2a4bbe7b-31e5-7527-8e63-10fb318e0f46@amd.com>
Date: Mon, 30 Oct 2023 12:51:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 01/14] virt: sev-guest: Use AES GCM crypto library
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-2-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20231030063652.68675-2-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR14CA0059.namprd14.prod.outlook.com
 (2603:10b6:5:18f::36) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d576567-1dee-4de2-fc86-08dbd970e0ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oKJQfacm7AW1xfbURzgkc/KDJHLSIz4zpH0sbWk0BqVWQuNBebgLbsFtsIV5BYuMEYdpAD93WfZbDkkfl7VKKOKe4iFAsBnAUMRozeJy+qEkj/OchCKgaIaEMcwRN6QGcBNg5xwgaiHU5lRgfHm/uIQFkZU7QB96HlvJGWViH4ePX4U9FYQUlPsA7d7y3GbVzm0si4ghsDRun+W6+5m+6Hv+GDm1PeJxH78iP7YlTL4Ukd1pPmRY1bXstVAp4MulYmrBmeVbh2oEX2AjrZupGaqr2DOutJStm6a2O6cVqZZKhy8uIrXYhV9sQ3rVuqXx+YWXe9XTXrS7sE7rgXD0c6dlLo+jCuaL7XcI1aortyjPAfAey4mT4Fn8krlS/CWf2ErhjdkQ3AN/cHOHCLCTC6KwRs8CnCUwWzQ8WWexBwDTNr0roTa87eEbyI7gYoNbnqGBef2fcvpzM968WS6tExy91kyAkqncDJBn7+4zlzdCf7V1pvRvvBwnQoEVVzxtfoMlJnkVLmXe/Wqb0eT5HgWQ4bYVmmUm66vqqhILtJlLrNBaKmlv/80rFawyjvklCJJ+ESWOpFE34vGf4oH1Gm8/wB25d9wHQL2NbzHwDBtClzSMALPSNC5O+ddhhSWVEYhFh7lcyGbigVcU777l7w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(346002)(39860400002)(376002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(66476007)(66556008)(316002)(41300700001)(8676002)(8936002)(31696002)(478600001)(86362001)(4326008)(2906002)(38100700002)(6486002)(66946007)(31686004)(30864003)(83380400001)(7416002)(5660300002)(36756003)(6512007)(26005)(2616005)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZThId2RaOFVNYndCSTBqRmZCMVkrdHN2WDBBUXNiNkpRWlQ5Q0Y4YVc4MVFs?=
 =?utf-8?B?S3M4ZUErYXhaWURZVThMYUxQc0ZqY1BST0pLNUw2aUwyTW5sWW0zUzY1Q2dV?=
 =?utf-8?B?SVYxdUtJTTRZTzliSXRhVEJ1VlRWSVAvclQ1TlZhd1JibGZOdWlkUGF6bVNu?=
 =?utf-8?B?aVZOTE1WeHI2eWRjL1pvdVVxRi9maEg2dzVncmhxMXdBdHVYNnVOSHUxSVJq?=
 =?utf-8?B?UEorbm1wcmZaRm9jeEtuV2lyVy9wdTZpT0xHMVJ6ejNSL29PSlo1SWZ6R0Fu?=
 =?utf-8?B?WFFzQkdwUEVCTXJnQkIvTVJ4S2cweTA1MmFBVGk2UlpHYjAwcU9NVTI2TEY5?=
 =?utf-8?B?RnljVkxKLzduTi9jWnVXQlBBWHpCYzAxcGZQL1Jyc1BzdW5DczBma1EvVStG?=
 =?utf-8?B?MEZSZDVwRlhCYWwzWUxsSFhUZlkzVkc2QU9TQlFSQ0pCU0ZCYkhMcGdEenpO?=
 =?utf-8?B?em1JOGFZMGI0bTFWaDNuRS9WZUxUbnRpcWdWcVBHMHp2OWt0Y3lweXJFTS9n?=
 =?utf-8?B?Vk9Yb2UrWTEyVWw0ZVQybkppYXQvMzhZYnMvYVAwRUxtSDNTcy85VWxFVnMz?=
 =?utf-8?B?eE5DaXZZUFJBa09XeTh5dlBreHZlQVQ1WFlaY0RoZXd5QlovN084SHVjODlG?=
 =?utf-8?B?cVh4ejhqT2ZNSzFCakVDRDRvRk0zMStyVmppMWo3TlNmYkNGeUlrWWJSTk5v?=
 =?utf-8?B?NFJHb0pxQzdqTEZuK3RHaVhYSUZUSzIrUFJwTWhwZytvSG5Fb2NHcStUQWxW?=
 =?utf-8?B?M1AxNEJpeHRBWnhXTXEzU050WC9FVWhBUkNMTHdVN3Y2SS9zYTlyU0pDS29j?=
 =?utf-8?B?Z2RkaWYrRElzL2p1VnRJbXk3UUpaUTNGZlBiOTV6NGJFMjk0dnpuZkQ1b2dI?=
 =?utf-8?B?Ulc0MVRDOWhka2U1azhOWXYyeFo1QmoyUkpJSERzLzlacHNBSVZhbktHQ3RB?=
 =?utf-8?B?WGdrYWU2YlcyeFJtZUJYU1Jrcmc3OEZVZ2Vqa3h3aXhpdDB4L2VKR0IzcUxY?=
 =?utf-8?B?WG9vSXFjaWhmbGVGbDdmTDJZVFUwRHFpeGVhWXZ1VXdWOVltaVRrMDhXcGpl?=
 =?utf-8?B?b05mMEl4WEVnNVRYM2RXY1dGOFAzWVVnd0FGSURYZXlueWRZTU5yOEZBN2oy?=
 =?utf-8?B?eHdWK1RubmpPNE5XS3IyU0xHMzZCYzY2Nm4zVXVETGFpcndoazF3cGlRaDY5?=
 =?utf-8?B?U2tDclVjNG1lbEI5WGl6WWtpbHZaYndMOWdIaVRzSmQ1QnN6ek95aS9EcmFy?=
 =?utf-8?B?d3NFTEVhVEo5SVJMM2piWHpkUDh3SzZ3TmJ1clIyY00vRVd5UXBhMXN4aWg1?=
 =?utf-8?B?QTYrQXdZcEg3eHk1encxN2lNdW8reGJDZW1HMHA3dlNCSVpERGcvVU91K01u?=
 =?utf-8?B?allMRGNuREZzelFNcWFQMW1sSFI4emF6UUZwR1pnMWpXakoyTnhvaWZ5RmFj?=
 =?utf-8?B?QzhPVzFPNUxaZjBjOEIzYVhGS0FmSi9MUWZDU0hJcE1TOXQwaGdmczBHZlJh?=
 =?utf-8?B?QUFhY2l6ZXdnOUxlM3dKb0FzRGNSekt6U3U1aUU4SEgzUzFtaFNleVY5Ylkr?=
 =?utf-8?B?d3c1TVBlVjE0VnNmNktMeDRlWXZRMnZxU2NCSjRWdGhCb1ROUVJZd3FOUEFr?=
 =?utf-8?B?MDZYVmJMVVhvcXFkUzZNZ0RYa3UwNW5PYytvbytHT3FIc0dicXgzTGp1ZnBs?=
 =?utf-8?B?cERoS3RDL2lYMURPUUdFK1F1dzVKMmZ0NTN0WFlmd2NvclBuaWlXTkZKRXYw?=
 =?utf-8?B?NDhaQmxTbzUyR0NCVUIrWTBZclB4TkpOUmJrcnR2YnEvZFNxbkkrUWxtYlgz?=
 =?utf-8?B?V0RkNWpVUzk4K1NGd0JXREV2YUFjMGFnRUFrWUpGUUJ1dVJFWG5FUmFicG9I?=
 =?utf-8?B?eEwvV1hKUTcvd0p5MGEySEN2ekdrYXN4cGtncnpKeWx6TktqOVZMYlR4d0wr?=
 =?utf-8?B?V2MweC83WUFiVFFDU0xEb1dmZnZjRWJkZ0lPRVlTaXMrNjdQQWZvZmxyeFZC?=
 =?utf-8?B?L1prQXoyQ2c5NjNRMzhjbm5LNlRDMmpOMkhrV3MzQ1NUaC83dnlDcC9wWEl4?=
 =?utf-8?B?c3dBOFBzZmpTMmIzWllpOEk3YytwZEpFSnMrdXlPcXNXTnZwdCtXMWFYYmgx?=
 =?utf-8?Q?DY558Xi4uTNm4nNPR4Q5Hb+/4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d576567-1dee-4de2-fc86-08dbd970e0ad
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 17:51:43.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Z6sZy6cvWIjDP4UTUqQQOgQgdRheMzb/Da1XDn0prmzJGeri6QtmFj8Km4PTNjoYIkWt7ed7VPzh5fsId2YPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373

On 10/30/23 01:36, Nikunj A Dadhania wrote:
> The sev-guest driver encryption code uses Crypto API for SNP guest
> messaging to interact with AMD Security processor. For enabling SecureTSC,
> SEV-SNP guests need to send a TSC_INFO request guest message before the
> smpboot phase starts. Details from the TSC_INFO response will be used to
> program the VMSA before the secondary CPUs are brought up. The Crypto API
> is not available this early in the boot phase.
> 
> In preparation of moving the encryption code out of sev-guest driver to
> support SecureTSC and make reviewing the diff easier, start using AES GCM
> library implementation instead of Crypto API.
> 
> CC: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

I just a few nit comments that might be nice to cover if you have to do a 
v6...

> ---
>   drivers/virt/coco/sev-guest/Kconfig     |   4 +-
>   drivers/virt/coco/sev-guest/sev-guest.c | 163 ++++++------------------
>   drivers/virt/coco/sev-guest/sev-guest.h |   3 +
>   3 files changed, 44 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
> index da2d7ca531f0..bcc760bfb468 100644
> --- a/drivers/virt/coco/sev-guest/Kconfig
> +++ b/drivers/virt/coco/sev-guest/Kconfig
> @@ -2,9 +2,7 @@ config SEV_GUEST
>   	tristate "AMD SEV Guest driver"
>   	default m
>   	depends on AMD_MEM_ENCRYPT
> -	select CRYPTO
> -	select CRYPTO_AEAD2
> -	select CRYPTO_GCM
> +	select CRYPTO_LIB_AESGCM
>   	help
>   	  SEV-SNP firmware provides the guest a mechanism to communicate with
>   	  the PSP without risk from a malicious hypervisor who wishes to read,
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 97dbe715e96a..68044c436866 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -16,8 +16,7 @@
>   #include <linux/miscdevice.h>
>   #include <linux/set_memory.h>
>   #include <linux/fs.h>
> -#include <crypto/aead.h>
> -#include <linux/scatterlist.h>
> +#include <crypto/gcm.h>
>   #include <linux/psp-sev.h>
>   #include <uapi/linux/sev-guest.h>
>   #include <uapi/linux/psp-sev.h>
> @@ -28,24 +27,16 @@
>   #include "sev-guest.h"
>   
>   #define DEVICE_NAME	"sev-guest"
> -#define AAD_LEN		48
> -#define MSG_HDR_VER	1
>   
>   #define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
>   #define SNP_REQ_RETRY_DELAY		(2*HZ)
>   
> -struct snp_guest_crypto {
> -	struct crypto_aead *tfm;
> -	u8 *iv, *authtag;
> -	int iv_len, a_len;
> -};
> -
>   struct snp_guest_dev {
>   	struct device *dev;
>   	struct miscdevice misc;
>   
>   	void *certs_data;
> -	struct snp_guest_crypto *crypto;
> +	struct aesgcm_ctx *ctx;
>   	/* request and response are in unencrypted memory */
>   	struct snp_guest_msg *request, *response;
>   
> @@ -152,132 +143,59 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
>   	return container_of(dev, struct snp_guest_dev, misc);
>   }
>   
> -static struct snp_guest_crypto *init_crypto(struct snp_guest_dev *snp_dev, u8 *key, size_t keylen)
> +static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
>   {
> -	struct snp_guest_crypto *crypto;
> +	struct aesgcm_ctx *ctx;
>   
> -	crypto = kzalloc(sizeof(*crypto), GFP_KERNEL_ACCOUNT);
> -	if (!crypto)
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
> +	if (!ctx)
>   		return NULL;
>   
> -	crypto->tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
> -	if (IS_ERR(crypto->tfm))
> -		goto e_free;
> -
> -	if (crypto_aead_setkey(crypto->tfm, key, keylen))
> -		goto e_free_crypto;
> -
> -	crypto->iv_len = crypto_aead_ivsize(crypto->tfm);
> -	crypto->iv = kmalloc(crypto->iv_len, GFP_KERNEL_ACCOUNT);
> -	if (!crypto->iv)
> -		goto e_free_crypto;
> -
> -	if (crypto_aead_authsize(crypto->tfm) > MAX_AUTHTAG_LEN) {
> -		if (crypto_aead_setauthsize(crypto->tfm, MAX_AUTHTAG_LEN)) {
> -			dev_err(snp_dev->dev, "failed to set authsize to %d\n", MAX_AUTHTAG_LEN);
> -			goto e_free_iv;
> -		}
> +	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
> +		pr_err("SNP: crypto init failed\n");
> +		kfree(ctx);
> +		return NULL;
>   	}
>   
> -	crypto->a_len = crypto_aead_authsize(crypto->tfm);
> -	crypto->authtag = kmalloc(crypto->a_len, GFP_KERNEL_ACCOUNT);
> -	if (!crypto->authtag)
> -		goto e_free_iv;
> -
> -	return crypto;
> -
> -e_free_iv:
> -	kfree(crypto->iv);
> -e_free_crypto:
> -	crypto_free_aead(crypto->tfm);
> -e_free:
> -	kfree(crypto);
> -
> -	return NULL;
> -}
> -
> -static void deinit_crypto(struct snp_guest_crypto *crypto)
> -{
> -	crypto_free_aead(crypto->tfm);
> -	kfree(crypto->iv);
> -	kfree(crypto->authtag);
> -	kfree(crypto);
> -}
> -
> -static int enc_dec_message(struct snp_guest_crypto *crypto, struct snp_guest_msg *msg,
> -			   u8 *src_buf, u8 *dst_buf, size_t len, bool enc)
> -{
> -	struct snp_guest_msg_hdr *hdr = &msg->hdr;
> -	struct scatterlist src[3], dst[3];
> -	DECLARE_CRYPTO_WAIT(wait);
> -	struct aead_request *req;
> -	int ret;
> -
> -	req = aead_request_alloc(crypto->tfm, GFP_KERNEL);
> -	if (!req)
> -		return -ENOMEM;
> -
> -	/*
> -	 * AEAD memory operations:
> -	 * +------ AAD -------+------- DATA -----+---- AUTHTAG----+
> -	 * |  msg header      |  plaintext       |  hdr->authtag  |
> -	 * | bytes 30h - 5Fh  |    or            |                |
> -	 * |                  |   cipher         |                |
> -	 * +------------------+------------------+----------------+
> -	 */
> -	sg_init_table(src, 3);
> -	sg_set_buf(&src[0], &hdr->algo, AAD_LEN);
> -	sg_set_buf(&src[1], src_buf, hdr->msg_sz);
> -	sg_set_buf(&src[2], hdr->authtag, crypto->a_len);
> -
> -	sg_init_table(dst, 3);
> -	sg_set_buf(&dst[0], &hdr->algo, AAD_LEN);
> -	sg_set_buf(&dst[1], dst_buf, hdr->msg_sz);
> -	sg_set_buf(&dst[2], hdr->authtag, crypto->a_len);
> -
> -	aead_request_set_ad(req, AAD_LEN);
> -	aead_request_set_tfm(req, crypto->tfm);
> -	aead_request_set_callback(req, 0, crypto_req_done, &wait);
> -
> -	aead_request_set_crypt(req, src, dst, len, crypto->iv);
> -	ret = crypto_wait_req(enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req), &wait);
> -
> -	aead_request_free(req);
> -	return ret;
> +	return ctx;
>   }
>   
> -static int __enc_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
> +static int __enc_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>   			 void *plaintext, size_t len)
>   {
> -	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_guest_msg_hdr *hdr = &msg->hdr;
> +	u8 iv[GCM_AES_IV_SIZE] = {};
>   
> -	memset(crypto->iv, 0, crypto->iv_len);
> -	memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> +	if (WARN_ON((hdr->msg_sz + ctx->authsize) > sizeof(msg->payload)))
> +		return -EBADMSG;
>   
> -	return enc_dec_message(crypto, msg, plaintext, msg->payload, len, true);
> +	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> +	aesgcm_encrypt(ctx, msg->payload, plaintext, len, &hdr->algo, AAD_LEN,
> +		       iv, hdr->authtag);
> +	return 0;
>   }

__enc_payload() is pretty small now and can probably just be part of the 
only function that calls it, enc_payload().

>   
> -static int dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
> +static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>   		       void *plaintext, size_t len)
>   {
> -	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_guest_msg_hdr *hdr = &msg->hdr;
> +	u8 iv[GCM_AES_IV_SIZE] = {};
>   
> -	/* Build IV with response buffer sequence number */
> -	memset(crypto->iv, 0, crypto->iv_len);
> -	memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> -
> -	return enc_dec_message(crypto, msg, msg->payload, plaintext, len, false);
> +	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
> +	if (aesgcm_decrypt(ctx, plaintext, msg->payload, len, &hdr->algo,
> +			   AAD_LEN, iv, hdr->authtag))
> +		return 0;
> +	else
> +		return -EBADMSG;

This would look cleaner / read easier to me to have as:

	if (!aesgcm_decrypt(...))
		return -EBADMSG;

	return 0;

But just my opinion.

And ditto here on the size now, can probably just be part of 
verify_and_dec_payload() now.

Thanks,
Tom

>   }
>   
>   static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
>   {
> -	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_guest_msg *resp = &snp_dev->secret_response;
>   	struct snp_guest_msg *req = &snp_dev->secret_request;
>   	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
>   	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
> +	struct aesgcm_ctx *ctx = snp_dev->ctx;
>   
>   	dev_dbg(snp_dev->dev, "response [seqno %lld type %d version %d sz %d]\n",
>   		resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version, resp_hdr->msg_sz);
> @@ -298,11 +216,11 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
>   	 * If the message size is greater than our buffer length then return
>   	 * an error.
>   	 */
> -	if (unlikely((resp_hdr->msg_sz + crypto->a_len) > sz))
> +	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
>   		return -EBADMSG;
>   
>   	/* Decrypt the payload */
> -	return dec_payload(snp_dev, resp, payload, resp_hdr->msg_sz + crypto->a_len);
> +	return dec_payload(ctx, resp, payload, resp_hdr->msg_sz);
>   }
>   
>   static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
> @@ -329,7 +247,7 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
>   	dev_dbg(snp_dev->dev, "request [seqno %lld type %d version %d sz %d]\n",
>   		hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
>   
> -	return __enc_payload(snp_dev, req, payload, sz);
> +	return __enc_payload(snp_dev->ctx, req, payload, sz);
>   }
>   
>   static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
> @@ -472,7 +390,6 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
>   
>   static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>   {
> -	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_report_resp *resp;
>   	struct snp_report_req req;
>   	int rc, resp_len;
> @@ -490,7 +407,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>   	 * response payload. Make sure that it has enough space to cover the
>   	 * authtag.
>   	 */
> -	resp_len = sizeof(resp->data) + crypto->a_len;
> +	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
>   	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
>   	if (!resp)
>   		return -ENOMEM;
> @@ -511,7 +428,6 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
>   
>   static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>   {
> -	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_derived_key_resp resp = {0};
>   	struct snp_derived_key_req req;
>   	int rc, resp_len;
> @@ -528,7 +444,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>   	 * response payload. Make sure that it has enough space to cover the
>   	 * authtag.
>   	 */
> -	resp_len = sizeof(resp.data) + crypto->a_len;
> +	resp_len = sizeof(resp.data) + snp_dev->ctx->authsize;
>   	if (sizeof(buf) < resp_len)
>   		return -ENOMEM;
>   
> @@ -552,7 +468,6 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
>   
>   static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
>   {
> -	struct snp_guest_crypto *crypto = snp_dev->crypto;
>   	struct snp_ext_report_req req;
>   	struct snp_report_resp *resp;
>   	int ret, npages = 0, resp_len;
> @@ -590,7 +505,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
>   	 * response payload. Make sure that it has enough space to cover the
>   	 * authtag.
>   	 */
> -	resp_len = sizeof(resp->data) + crypto->a_len;
> +	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
>   	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
>   	if (!resp)
>   		return -ENOMEM;
> @@ -802,8 +717,8 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   		goto e_free_response;
>   
>   	ret = -EIO;
> -	snp_dev->crypto = init_crypto(snp_dev, snp_dev->vmpck, VMPCK_KEY_LEN);
> -	if (!snp_dev->crypto)
> +	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck, VMPCK_KEY_LEN);
> +	if (!snp_dev->ctx)
>   		goto e_free_cert_data;
>   
>   	misc = &snp_dev->misc;
> @@ -818,11 +733,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>   
>   	ret =  misc_register(misc);
>   	if (ret)
> -		goto e_free_cert_data;
> +		goto e_free_ctx;
>   
>   	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
>   	return 0;
>   
> +e_free_ctx:
> +	kfree(snp_dev->ctx);
>   e_free_cert_data:
>   	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
>   e_free_response:
> @@ -841,7 +758,7 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
>   	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
>   	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
>   	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
> -	deinit_crypto(snp_dev->crypto);
> +	kfree(snp_dev->ctx);
>   	misc_deregister(&snp_dev->misc);
>   
>   	return 0;
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
> index 21bda26fdb95..ceb798a404d6 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.h
> +++ b/drivers/virt/coco/sev-guest/sev-guest.h
> @@ -13,6 +13,9 @@
>   #include <linux/types.h>
>   
>   #define MAX_AUTHTAG_LEN		32
> +#define AUTHTAG_LEN		16
> +#define AAD_LEN			48
> +#define MSG_HDR_VER		1
>   
>   /* See SNP spec SNP_GUEST_REQUEST section for the structure */
>   enum msg_type {

