Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEB641B14A
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 15:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241108AbhI1N4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 09:56:52 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:54575
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241069AbhI1N4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 09:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvycfFR17QuAwRBQlN1n3yJYaW4aQUzgoZFLwGRGtvGLH+E82ZEtIsRoh6d2p2viE5IeUcbE5aORyG2goga4cw1hLKLC/aUSUo+J56P7bKLdlL8Q/6vgeOjUi6+f7M+5i9ACx9x1lMAmYoY3hRMuinFq//2XyW8tJmZoPEYskccI6Rb2iNvPAQP35h4eH9Tqw4uno7dnlV7plMW7Pb7IirG41ugH3C+SaXg/BGP5t8l8W5Voq+x0pfLEL08+8n6h0HSs1JUL+ftkk2xKiLYwDWP6oNuQND0kO4DuPRNctHYsCyLzJUZqntI7YDzv5NBzjDrx9Ye0rfAymK77+IyIXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MCPL+L4Hf4JEfg3oTDBbY/MMEpXT6PP35glbzT3dmDU=;
 b=GmL1C6wGoY+TE3TWT+jPvo2qN5/b2nAlb6wrPH9uCQljhLeLn20HB/dPObecXeuKAGhWsgClRk/Ztj/mZx3UY3CDIb2qW8FgRvo6Dm7h5USqZrTO1KIs3kPtWqQtfHtTEJV1YXVMPThech1fX2Wn6slUt5Hp53YLZ52jGE1CAz+3pfq7PpUCkG1/94rXg7FopWrLqZYkV6JtuoZs+oFhhZcfjkcov2owqmY/+2IVt79wQItBSK4oYpE0KoS6t0kehNfpJU/VOec8FPr3e/jnIS1BZh8XCjyJ95nklze8rYskwQm4jXivfRvJo7DuLndMf4XoiOWgYmxWMhI2LFlmzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCPL+L4Hf4JEfg3oTDBbY/MMEpXT6PP35glbzT3dmDU=;
 b=JfRqvHH6JLlTTVi0jUbBxkc4eiMwLPmlhb0rjSSoxPUtSjFmb+BbU0ETMKgQUE29qK5S3JMiKb1ov83RnPtlYNEs/GnZ11rueCMN2F80Miushf4fsygXV7i94dHt5mTgsFB88ea/USZl2nEY44pkZOya5IKqGiMlctZ6S1bJZrA=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB5709.eurprd04.prod.outlook.com (2603:10a6:803:e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 13:55:10 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::e948:b382:34fc:c923%7]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 13:55:10 +0000
Subject: Re: [PATCH v2 2/2] vfio/fsl-mc: Add per device reset support
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>, linux-arm-kernel@lists.infradead.org
References: <20210922110530.24736-1-diana.craciun@oss.nxp.com>
 <20210922110530.24736-2-diana.craciun@oss.nxp.com>
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
Message-ID: <e356b582-7911-6c8e-3201-dbfdbd3e3b1d@nxp.com>
Date:   Tue, 28 Sep 2021 16:55:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20210922110530.24736-2-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32)
 To VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
MIME-Version: 1.0
Received: from [192.168.0.30] (95.76.3.165) by AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 28 Sep 2021 13:55:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 564575ab-1562-43a0-87c5-08d9828795e0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5709C3A110A981180B70210AECA89@VI1PR04MB5709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7KmeRL9jJphjnFPxP8a/bSleuJjXq43wdBfgXdbFMVyGkrGMj+/oZn5MqKFEUwpyrXiATUZtKjUPW73Ju1g3LLnizq0y4zO2uqpng61EcSNIcsEs8YgYe/e6Yk6a/KPyYhfTMkN2V1Fx0ulsUTSc87tuaL6VTx3ELArsZ8AOCzF7c6cytGC2PmvuVDI7Py11jfpB7CN0AOxb7/ACGFc/obu39yxaKDcHVFCWm7KT5yLBu8yL6wM/swfkdlQ76jRKW5lr6Yo9IIlG7V3ErN67z3a0DbE6Tk2oTf3MYrLeuZe/SftVrm/lYj5kCfSuYbBtKDqExiS3mYAzfTU43TpVQ/QmWPQB5djhjlcBK8xvrSNRWq9sZ7TqGcoCLxRGubloIYKo9a2jcyQHABonHmBeCf2/91J6FKQ8kvSlBhmDgmEDR6Q4rbInoREZZ/Tw2uynmFPI8F3SlR1G4N939uwmtm4pLIDviuVwaUS1H/n/XAGEX4cdccSIZPTZ3p8OvG54Ph4YPsVFFCKIoEwKae/9ZeKjmwyAu0cVlDkgLDmBhfpKfJa9hO2ilfN8ddib9li3NN6bgb1V9LcrnrEOkFFjZfdq/m6aj6AkWOPIUtAJgR357NUgAeghYp0iFV5d40V7N6/PI2BY6rTbmVc2uMftjGfNx8TW+88USW64xZQ/cHURzhgG61iiY34qQ9m5N9jhVfHVDO3qxxtQNwsgh4kZ+1HkO+ca60sixsrZyvE8MgllH+1bwBaKVR7iH4D27G8wLWbLETH05qIQ6ZT4eXHZAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(86362001)(4326008)(2616005)(956004)(5660300002)(38100700002)(38350700002)(44832011)(16576012)(83380400001)(8936002)(31686004)(66946007)(498600001)(110136005)(6486002)(186003)(31696002)(2906002)(8676002)(53546011)(26005)(6666004)(66556008)(36756003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmdLdmJiV2krVmllY3JJa2lPTmlSN01qU2puOTdWa3BLb1VIZzlDSTg5emg3?=
 =?utf-8?B?NStDUy9IZkVmdEVvTzJFTmRmVndDU3Bac09pdHYyRVZ6b2hNNkZXUHI5b3Iv?=
 =?utf-8?B?RTMzY3VvbVJ6blZFVGkwT1RFRXRNQW1BbTVRaFJtRkZ1MTlWbW1UNVo1ckx0?=
 =?utf-8?B?WEVLbGtKRXpobEpOcmR1eSs0cjFldS9YbjBtK3Bibm9uSG5QSnBaM2d6cVNx?=
 =?utf-8?B?V3p6UFRtNjh0eHNFYUUyd2lucWJaQ1cxajEyUjhBS3BZNGphclprb1lDUHBV?=
 =?utf-8?B?Z0lKMWloTjZ4SmRzcE1mZTdTOXRrTUVxUVFmLzZMbHZmN3lPV2l2U3M0MVBT?=
 =?utf-8?B?d0YyZXc0WmFxZWFCNGI4QVBXRSs0M3pRajhwZWl1dGpNazY5NFNkVHF5QzdW?=
 =?utf-8?B?amNzTnBIcnp6OS9ncTJWYWJBVDVlOUx5d01HdENVNUp1b3pNUFV4U0RaQVBn?=
 =?utf-8?B?Ymp0UEpjZ3RYY0xBRjQzZCt3Q0ZYNUVTVDBjV0NMRkpmMXZUbGtJLzFsbG5i?=
 =?utf-8?B?TUpPK3pyL1IreU9Yek4rUTYyZnBhZXBOZnduZ2s2VHUrNEtiSytUTEZYTWFk?=
 =?utf-8?B?aUNUdEZjWWgya08wM1JNb2xkQUYzWUdQRm9nZzhGTTVtK1ArbXllN2trcXcv?=
 =?utf-8?B?dmNIVEg2REwvUUUvWGJpSnZPaytqR3J3Ny9XbEJiZVl3OThuOVJpdXJxWkdN?=
 =?utf-8?B?RERSUk1rR3FwTEVFS2JkMkxzSjVoRmZjZ0ZsMjFEbGUzcDFsZUc2ajh3L1R6?=
 =?utf-8?B?amxXWUJrMmpNL3N5VXluWlo4MENiN3VoOXRTQlFPbTR2dHcySndXbGUzVUFL?=
 =?utf-8?B?amxiNm1KRWpsTlV2YVdNNGhkVndkMjdMaVdseENqY2Vjb1JzdENicWJzMjE3?=
 =?utf-8?B?cnNOZy9NM3hXMkJuODFKby9mdEk3S0hkV2JUVjJrUklaNldPblBSbGJqcXdF?=
 =?utf-8?B?MmZ3N3daU3cxMGN2N05iYVVpazRkdFNwMHl6WkxUUS9YWVp0R1Z5OFBnbE1S?=
 =?utf-8?B?dGpiZHF0V3BGYVBmRkUrbGtBcGtySWcrUDVDUnZEcUN5c3o1OHFBT3V4cFg3?=
 =?utf-8?B?NmFvZFc2MTZyRHZnNEt0aXBQdkQ0azJGS2h6aUpKM1pHbWVRYnFnbjJyY0Ur?=
 =?utf-8?B?QldaR0I0cVBsakVlTG96Z29SaEF1V0ZBNWtScEo2ZzVibktsSlJKbkUxSGlr?=
 =?utf-8?B?M3RqT0g2ejZmdHNDWjlWTmw4cHNNM2dySXdaS2lXZ3hTOFNWc2x5dVZMVE53?=
 =?utf-8?B?Zkk2Z213c0hyMkdJWFY4UHRsRzJJSEp0RWJ3MGMvNGJ1TVBtSDVTTGlpUlVE?=
 =?utf-8?B?Ums4bEdrQWczZjhkSEIzUWZKOHVZVlVzeENIcjdQRVhlTUVhbEFsRFBpWXR4?=
 =?utf-8?B?ak0rM2x3dHZjblEzY0xjTjVYT2RDSmRPRFRIZno3RnhVRUpteE1uemE4K1Y2?=
 =?utf-8?B?VXBiaG5JUERxMHptNlBkU3hhenlrUTNXUGFvaUtsc1pyb2UyYW9nZ1JvdEYr?=
 =?utf-8?B?cFNKVUlwVmZqZS8vM2x2NFVHNVhCTGN6Um50Mk5uaHRMZDVDcDB3ZmlJbzJh?=
 =?utf-8?B?eVlibjNoMnVxbTFRTTNudlQ2VmQzbHRDVmlIejdtMkxpRStrR0lldVBsM3po?=
 =?utf-8?B?MjNTOEM2NnFTNkZmWkJHSVhXbmVNaWlydmZEK3M1WXI3MDdiZGtBSDdkQURn?=
 =?utf-8?B?dnhYdXpPWTJqa2NRNDB3RnR4N3dhNGFsS1FDMHYvc3FlUGovaVJ5L3RkUkUy?=
 =?utf-8?Q?0XzrfVggfFsGRaXIS51QDULyan/rOlwEwBc3Vqt?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564575ab-1562-43a0-87c5-08d9828795e0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 13:55:10.1718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brff/qIdMbw/TcO1PjthqndOGl0t5OIEd6MYvtKmtLkc5/eF5NZ9IvEOrzk8kZ8qTXgzVf6oQJERZR9SMu8U7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5709
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/22/2021 2:05 PM, Diana Craciun wrote:
> Currently when a fsl-mc device is reset, the entire DPRC container
> is reset which is very inefficient because the devices within a
> container will be reset multiple times.
> Add support for individually resetting a device.
> 
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---

Reviewed-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

---
Best Regards, Laurentiu

>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 45 ++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 0ead91bfa838..6d7b2d2571a2 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -65,6 +65,34 @@ static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
>  	kfree(vdev->regions);
>  }
>  
> +static int vfio_fsl_mc_reset_device(struct vfio_fsl_mc_device *vdev)
> +{
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int ret = 0;
> +
> +	if (is_fsl_mc_bus_dprc(vdev->mc_dev)) {
> +		return dprc_reset_container(mc_dev->mc_io, 0,
> +					mc_dev->mc_handle,
> +					mc_dev->obj_desc.id,
> +					DPRC_RESET_OPTION_NON_RECURSIVE);
> +	} else {
> +		u16 token;
> +
> +		ret = fsl_mc_obj_open(mc_dev->mc_io, 0, mc_dev->obj_desc.id,
> +				      mc_dev->obj_desc.type,
> +				      &token);
> +		if (ret)
> +			goto out;
> +		ret = fsl_mc_obj_reset(mc_dev->mc_io, 0, token);
> +		if (ret) {
> +			fsl_mc_obj_close(mc_dev->mc_io, 0, token);
> +			goto out;
> +		}
> +		ret = fsl_mc_obj_close(mc_dev->mc_io, 0, token);
> +	}
> +out:
> +	return ret;
> +}
>  
>  static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
>  {
> @@ -78,9 +106,7 @@ static void vfio_fsl_mc_close_device(struct vfio_device *core_vdev)
>  	vfio_fsl_mc_regions_cleanup(vdev);
>  
>  	/* reset the device before cleaning up the interrupts */
> -	ret = dprc_reset_container(mc_cont->mc_io, 0, mc_cont->mc_handle,
> -				   mc_cont->obj_desc.id,
> -				   DPRC_RESET_OPTION_NON_RECURSIVE);
> +	ret = vfio_fsl_mc_reset_device(vdev);
>  
>  	if (WARN_ON(ret))
>  		dev_warn(&mc_cont->dev,
> @@ -203,18 +229,7 @@ static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
>  	}
>  	case VFIO_DEVICE_RESET:
>  	{
> -		int ret;
> -		struct fsl_mc_device *mc_dev = vdev->mc_dev;
> -
> -		/* reset is supported only for the DPRC */
> -		if (!is_fsl_mc_bus_dprc(mc_dev))
> -			return -ENOTTY;
> -
> -		ret = dprc_reset_container(mc_dev->mc_io, 0,
> -					   mc_dev->mc_handle,
> -					   mc_dev->obj_desc.id,
> -					   DPRC_RESET_OPTION_NON_RECURSIVE);
> -		return ret;
> +		return vfio_fsl_mc_reset_device(vdev);
>  
>  	}
>  	default:
> 
