Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0D12A44BB
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 13:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728805AbgKCMDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 07:03:22 -0500
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:34248
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727109AbgKCMDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 07:03:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTKdOpCxuAJ69wroTTUeQiHluRYjBgAUpyO4T5zxBiL35MDqe0ftr+lEIfSzfxJbckYDz+fFmiqI86yS+zNgTKCUJ91Bp0txjVW5ZNe1IRUhUUf8Y+gK/NXswvH3DQ02fTYqvGEDFdWqVJ456sZH0sta73ivJwkGPIwfckq7B/n+P7Vx1hcbyc8xh3zOW+Q7J8mNKGrnOz/+vfgF3NE7WuZw998j30tX7k2+MOHtOP3Ww/rsAuXToODMJhrmlMIlufxM+Y3AW+ee35jtTTjE2ph69ONp5RU2b3HJ2k2pr/3b2qvJ/de1cclVMQKUPS7NtJ7phcFrFwcoLGLVR+eJOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeoG2CNB2cUdm2sYBea10OIYbnZ31E6cUojCNSkx6UE=;
 b=VHbjRytOIY25FiMV21pRINcKz1/RbEyh2Qs139uv49PrZ5+HvowEYIgllJSwNBDTDR5u8KbgDIZO9neAqVohE+7v1wK9dZwHEDxrzruX83aCRstdK8+4iBwJFI+2aXpbNVneg3BcBPhMvypOZcVajvGueu0GAnnYufefeoaDErL4pDAj5eCZiBXFbgqROXmY3p1yxpc2k3hBe+6mF0KOHoyJqR8OaD7SNm3ROhuFDyAvF1+Qi0Gc60EQOTSZx831PcjVNW3stHSirZrMFNG4A38KjQgttlGLEKWOR/qfyCZwTrcTGsU5CR1+G9xaOtJcd/edwhvAnpQWuNY5gxCRBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeoG2CNB2cUdm2sYBea10OIYbnZ31E6cUojCNSkx6UE=;
 b=Sl75WhJczyug6YKsb3GyE1+zcBbuOrc+/AwuMSB8RKalkMhtOu/ohLP1hF2D3fG9yyjMwpFQoI/BMiAdx4EEVbBjzi2ABMvqt8iz5a3m/NwDu37/9l3KXLVV5v59w59CB7JQ63o+8UiJ37jVGa3mw+lf9M38YctuqllY/u9hqVM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR0402MB2814.eurprd04.prod.outlook.com
 (2603:10a6:800:ad::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 12:03:15 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f%11]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 12:03:15 +0000
Subject: Re: [PATCH 2/2] vfio/fsl-mc: prevent underflow in vfio_fsl_mc_mmap()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20201023112947.GF282278@mwanda>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <de18ce14-9138-dcc4-253f-fa50d63b3ae2@oss.nxp.com>
Date:   Tue, 3 Nov 2020 14:03:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
In-Reply-To: <20201023112947.GF282278@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [86.121.79.46]
X-ClientProxiedBy: AM0PR08CA0024.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::37) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (86.121.79.46) by AM0PR08CA0024.eurprd08.prod.outlook.com (2603:10a6:208:d2::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 12:03:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 40023dd4-8d26-47a4-61c0-08d87ff071a0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2814:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2814DCE6486EDEB6AB8BFDD9BE110@VI1PR0402MB2814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E4949qcrkLACU6n2Emt6KW4nnuZQF0DP6HkzJSnh4v6OvMeLspWGeLzbw/sVkuoprW52yL8TkjX3rlLb17wh4/JtXMuBIykpnyDIdxLd6Oi2Mq+woYUZAli3hyZBwcGXoXQYntve3LpMHN1slKCJCHWotzvWmqZw4T9c+3C0amgJMh+CBy0oxPleyeLZw+MuV3dGA8bof0cJTwT6WqBAUYQiGmH4XLEAutZddijaFUE+CL+NR8dNWOXH+ud2BBtDM3B+17sOHnbDUqJalRArVhTohYoQ1zYxcsbpg5mOYAJBiq+zCFL921ThPjZJRvPgk/FpHuZi794Xac2RuDwQG+Q/NiCT8D6bzbEEE1fbUM9HqnZ/fnrIcUjJWvQuUYpH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(66556008)(6666004)(5660300002)(8936002)(54906003)(16576012)(6486002)(8676002)(316002)(31696002)(83380400001)(66946007)(66476007)(86362001)(52116002)(2616005)(6916009)(4326008)(2906002)(53546011)(31686004)(26005)(956004)(478600001)(16526019)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: siLpbegvHl43KVALtD2tl25rKUwiyv/hrroX+D4A8hBwGj1GLJvwI6AaNG+bg0X3hL3JJap/Ubh1Rb9avQhffp78MTdJ1SH/4XRlBeCI0NexQNU7QeioMVhgTgaGvf7VKYxegCKsMBgD3f+dqgfH00KVNvryCtkudtGrHNIFTG2vUqVwuCcmHoNW7qQ5pzD90wFK0b4Gk7EMqkPhblAz+Qt/gTm2n+40WDLtRMcGtQfS1K42eb4vGn3hLe8Y695W8H07w73RRHG7k0cIm0sVBZ+VpCk2V2/uVUV7PnMTUIEarZI0c+dp5hx0TG0A3KRYZBB5F+WSUP2GHly9gDPQZ6XR+r0kuzbz0o6PgFR7AIwEViWDfXCQU1y4NxTvCfbkPmVmTU72+gxmr7YJLMF0alT8ZgWnnoyqUGFjJXjCKtECepIyoDtwSFwnjwip+oDUN2zhKDbpaRVVRYoRucKdIYnrvaV2j+WZAtox/WcXINb8+CzcMvXL+56xm1DUFbhBA8kblegEJmpCGNYBKhx9NERP1Klyn0fSckuQ8ufa03Cs0fND0VcdhfY5t9+loMesk7Mqt0vJzQkoR99AD+p6TEtyp7JOAGs4Hiw7uHeBf6BDphjrh0/HXb0FM8PtjuVhO4b300cyFpV+ZunydP3HHg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40023dd4-8d26-47a4-61c0-08d87ff071a0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 12:03:15.0189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IeivYJoikbRKNnzr+SsQ6rgyLjcPaWerJKdmlkjS1DhvbOLyRqnreayjB/hUPI1H/lw7ALKdMErPO198Y0+23w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2814
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acked-by: Diana Craciun <diana.craciun@oss.nxp.com>

On 10/23/2020 2:29 PM, Dan Carpenter wrote:
> My static analsysis tool complains that the "index" can be negative.
> There are some checks in do_mmap() which try to prevent underflows but
> I don't know if they are sufficient for this situation.  Either way,
> making "index" unsigned is harmless so let's do it just to be safe.
> 
> Fixes: 67247289688d ("vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 21f22e3da11f..f27e25112c40 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -472,7 +472,7 @@ static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
>   {
>   	struct vfio_fsl_mc_device *vdev = device_data;
>   	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> -	int index;
> +	unsigned int index;
>   
>   	index = vma->vm_pgoff >> (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT);
>   
> 

