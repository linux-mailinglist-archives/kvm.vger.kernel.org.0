Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4F425FC5E
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 16:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgIGO4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 10:56:24 -0400
Received: from mail-am6eur05on2084.outbound.protection.outlook.com ([40.107.22.84]:48193
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729990AbgIGOzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 10:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMFNHpB8/22+MZot45LzIyQPpIOnqiJ2WZT9MLcYG7eAgtH0e0HztMNiveK9kkH1JJY5vl70ITcRGMu7a0PGpwJC7xEOlX7QdvQeE4i5ADgpDzIQr1Mvk/7p3bEDLMEfZq5TcHwCZzYXNcFBHLk0sxzAT7JkAKbQMwufMEiz4wFzheducCVP07XzL9TO3QNdvZYQHgUZQv8I9zoIX6PZ7U8IJGyeJ3iX4JfUTBKtwWm8/PrT0zIGlW9Kz+QYM0vmSwID+6k5kGbrRT0znX//FbyZVbT7QSD7mC/pgDypUmczGOwCoqfOW8gyjeK/rlMYT5lCZ0tc4NDS+7272fQTkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toc77OndJ53Wm/RgRIJL4BDIR3hJH3aRcNaHQURk8XE=;
 b=YQzZWFQMlrjSNGZYRufwctR/OeVx2TJm+5UYiMZkbdgs5Ja1Bkf4VGdiBpuoZ4yOT8QytCa4p/rdHPfhAy30b7Bs3h8yXLWcxJjiQvOIEyu6/JhB4qxPK+Hqp78/GY8uezVViZw0xW5xqBsm3Z6PouP0QuV6alVJpLX+z9qcBm4cLW6cXyfiPMRinHuY9pqCbJIYDsF6pK8dNo9c/UFNgn/JNmqpq42Rw03xrIgrCpmvhZc2ilt2jLGv8AM8rs8qikUp2Sj+KRdB8KdvhspZuiS+Zg4m9Nqj6yp7XUBxZzz4w+snrppR59gn3i2Kl3gngMTC5g5xr955Eqlc+iByCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toc77OndJ53Wm/RgRIJL4BDIR3hJH3aRcNaHQURk8XE=;
 b=IPf14NJNl1Wxt4tcd7Hx2oNKMk39JJzlAmrQVAhgeq1Ucg4FvzENEfvW9/biJc9428qLeudhHdgoQ5Bv4AR71O+lNTdwNWMAYH0gLBn96dYf/FtYK4ZskCg0+pKHJoWf7QXsL9slBYuIFhWztrzfvHDtD8fMuNGiyD98rJEKztU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR04MB5872.eurprd04.prod.outlook.com
 (2603:10a6:803:e2::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 14:36:54 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::a508:19fb:5b7e:5607%9]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 14:36:54 +0000
Subject: Re: [PATCH v4 10/10] vfio/fsl-mc: Add support for device reset
To:     Auger Eric <eric.auger@redhat.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-11-diana.craciun@oss.nxp.com>
 <629498a6-8329-1045-c1a4-ab334f3c8107@redhat.com>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <665b9fbc-90f9-8a7c-4ea7-73583ae30d69@oss.nxp.com>
Date:   Mon, 7 Sep 2020 17:36:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <629498a6-8329-1045-c1a4-ab334f3c8107@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0004.eurprd04.prod.outlook.com
 (2603:10a6:208:122::17) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (188.27.189.94) by AM0PR04CA0004.eurprd04.prod.outlook.com (2603:10a6:208:122::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Mon, 7 Sep 2020 14:36:53 +0000
X-Originating-IP: [188.27.189.94]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 283f659c-cbcc-40d2-e056-08d8533b7752
X-MS-TrafficTypeDiagnostic: VI1PR04MB5872:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB58724C4ED2325F730C37DE74BE280@VI1PR04MB5872.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ORr5LMQASRhPhroi/LiY5AqNGJpMfEcezj3crRZgt1aKh/gSGD8nXjC+gqze0qX4IjpO+KJHEtOLeqm4uJ+9VrBQKpTYLhUGO7V2dEsJpViw48Os6vyvMy7VDyVLX2y8e2/EmSxgYN2wPkJVT8EOz/k7oGHNklIU+TsfqI2jvgRnH06/4QNvsX6/h4J/UfCIm/Nl+2qYoL9BBT/UZFB62DzmjPWUY8rT5QMG+tFymrryrkszYjt96dh7cVBwRsf2PjZLjPbhoNtXeX6R1d+wh2I3x0hE6zkj7loSI3rIg2Ew3dowFmiUhT2KN1Dq3gZITXWAFYTXE0Sy9l9nhyJMDf3SYDRHFLa+TC6/sDnmRVaxqjQFCSoqnYpfq6KQg3px
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(26005)(52116002)(186003)(16526019)(86362001)(66556008)(31696002)(5660300002)(66946007)(31686004)(66476007)(956004)(6486002)(4326008)(53546011)(2616005)(16576012)(83380400001)(478600001)(8936002)(316002)(8676002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lRFbFKflJ/t2xnKLvc/7w55UTPBhO9YkgvxJXYLFPsA/40UTDT6RS9oOt4RVn83JllvzkPrLK0w1qDDJsSN74PJRVJgk8DYiagrq9OGH/xb0IJphOgYJ+cTgl9ekhKtfpv/a8nzpOELTssHtKlGRJz+vf6Yw6e8apMTE0WF1IKxm1r1I6mDZM1+Ry/uYBj6NXBXMa/ZIT7rMRK43BboDcFQ0QDxB86JDFo73+VH/zwDuja3ANtWGGQOQwaHpVyy1j5mnrTizE5HW4/ZjCwmWKw3J233UsH1TSXPu/OsZztsylz3POabHZ8elBlaVYrWHafXzyg1FwGFo1BXPqMMGlohAelR+3q0dzS9xF8iBCF1ZjiancHdP7w6vJnAXaMaSYvYQv4uVZnfyF4B7aI8Vfw/NJIpuVsRlvJwzxZ6AYsIgpM0vsK25zVC+WSqPKIpWn58T0hbVlcFwPxRVtIUE4I4ghFrhKFcof9b7Vj1ZpHXhMF8SoQ0YakUZt/DCebMoavPVpwDPLkkbR53p+YuSCXUiqmA2OcDNS/zbtiURcnsBYFiYuy/qclLhafa4tkNj55+6vSOu5n/pEIPy1ucumgee7mmqRbLbkx2Pwc98KuaQaw/NeOC5t802wgdiLGWYBEnJZcrRg3gtlvCoxSYx3A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283f659c-cbcc-40d2-e056-08d8533b7752
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 14:36:54.5600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8mrMTBOr4ZnsCW803ptBdo0DLeOXcTKWg/jbw89LqOUMTLxJQySBQAYZpYRfnmMBWs1kOgVaflyXzaZ8yT0sHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5872
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 9/4/2020 11:21 AM, Auger Eric wrote:
> Hi Diana,
> 
> On 8/26/20 11:33 AM, Diana Craciun wrote:
>> Currently only resetting the DPRC container is supported which
>> will reset all the objects inside it. Resetting individual
>> objects is possible from the userspace by issueing commands
>> towards MC firmware.
>>
>> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 27713aa86878..d17c5b3148ad 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -310,7 +310,20 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>   	}
>>   	case VFIO_DEVICE_RESET:
>>   	{
>> -		return -ENOTTY;
>> +		int ret = 0;
> initialization not needed
>> +
> spare empty line
>> +		struct fsl_mc_device *mc_dev = vdev->mc_dev;
>> +
>> +		/* reset is supported only for the DPRC */
>> +		if (!is_fsl_mc_bus_dprc(mc_dev))
>> +			return -ENOTTY;
> it is an error case or do we just don't care?


I rather don't care, but shouldn't the userspace know that the reset for 
that device failed?

>> +
>> +		ret = dprc_reset_container(mc_dev->mc_io, 0,
>> +					   mc_dev->mc_handle,
>> +					   mc_dev->obj_desc.id,
>> +					   DPRC_RESET_OPTION_NON_RECURSIVE);
>> +		return ret;
>> +
>>   	}
>>   	default:
>>   		return -ENOTTY;
>>
> Thanks
> 
> Eric
> 

Thanks,
Diana
