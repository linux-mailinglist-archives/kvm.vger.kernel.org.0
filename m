Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936FB2A4C99
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 18:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgKCRTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 12:19:55 -0500
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:47584
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726581AbgKCRTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 12:19:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AePvTX30jkWUlhPpF45+NAmzoCO/pATCvYI8SjN75tilkQXVrFzJX1Q66cMU0bOLTEkZX8XFEBdlnjgvoD35dBjPKRV74x4CHPYUyfrnG90T4QzpQKHgb5s3Q+PXqPkGJ8zcAOfoSbXNlJMEkDhT5NQ9UjhAE454WkU0kCXU8xhOPd/3WK22phOW6McPtt8x1+45Yps8XOmkyTmveT8L2ZJ9GmvVsXjg6+a7dHPCDz0DopZmU4PUnsPdGA/qa/o/RA19mlUIGy8WEV+SAI3KgjYWs56N7p1m3nSq4BqBYfaRGjKdIK+hXGZllRtxY+CYZtwxNwBHA8YGy2WCtVHpeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cs2g/pkBry+XCb8x1KZJkwslZHxwuyzgQIJHgg9ImY=;
 b=XcPlCWhvL+NQpRqsH7DdWxfEjfbtKq2jT+tLlXNAtKO1xSj2HWwVosyc80QatdyJ6xtdkPCK12SQkMFyPLVfmLXgF6EntwW87p4And4PvYeB9oM3za1DGGmJvr+DKn8PEUPIAKgy1uii35CMZF+w41p+TzdgCTN338s5Bi0KcubvfwYUkgMkM4vGs21ewooqimSI59rPc0QkpHlf36fLSmNcjSg1WrTjZ61CubudBrshZqAn7QfoQA34Qt6SK0UqJ3foQpigMsqEA3XU8Wmrj67ruDFJhu201Sj4qG6Lx25MbZZcF2aHiPvQfTWKb9k4hxibqaLiUwcsugEL/l7GXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Cs2g/pkBry+XCb8x1KZJkwslZHxwuyzgQIJHgg9ImY=;
 b=CHywD4vd1eTYYseduQScwBOTmwiEQDNp6jKs6sHfdjRtni8HR3IvqCMy+Xfgj3rKwQuuqRX05iqrN+Q89mJ+iZCTzTbsMGrhd6JtfkvBK8OmSHCCOPwHZhW5MXWFqedzfGfERWzpbIBcK5ALkWMY+PHAkNTtEUzL/e3Oo9Og320=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16) by VI1PR0402MB3790.eurprd04.prod.outlook.com
 (2603:10a6:803:24::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Tue, 3 Nov
 2020 17:19:51 +0000
Received: from VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f]) by VI1PR0402MB2815.eurprd04.prod.outlook.com
 ([fe80::6cf3:a10a:8242:602f%11]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 17:19:51 +0000
Subject: Re: [PATCH 1/2] vfio/fsl-mc: return -EFAULT if copy_to_user() fails
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20201023113450.GH282278@mwanda>
 <20201102144536.42a0e066@w520.home>
From:   Diana Craciun OSS <diana.craciun@oss.nxp.com>
Message-ID: <28a51535-5f4f-6a06-254e-29ef3dc999ba@oss.nxp.com>
Date:   Tue, 3 Nov 2020 19:19:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101
 Thunderbird/83.0
In-Reply-To: <20201102144536.42a0e066@w520.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [86.121.79.46]
X-ClientProxiedBy: AM0PR03CA0104.eurprd03.prod.outlook.com
 (2603:10a6:208:69::45) To VI1PR0402MB2815.eurprd04.prod.outlook.com
 (2603:10a6:800:ae::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.122] (86.121.79.46) by AM0PR03CA0104.eurprd03.prod.outlook.com (2603:10a6:208:69::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.22 via Frontend Transport; Tue, 3 Nov 2020 17:19:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00e771a0-ad58-4464-8811-08d8801cac29
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3790:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3790757D7D009B94FA2E25FCBE110@VI1PR0402MB3790.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bJ1xcqpW39e0/PL/3mRgeoEczOX7OBSqjPp8UKSq5eRLW29evrmxKCOOXWiOe3mNoADh6pwJR3TmUot6rc291hSqHiOD2h8b5fv7IJnDuLj0gFzILStVAdUkOSTFRQEiDjv+mtixoYKcQhzvJl87anTPmxV80XwZbM3EK59liDl0tyaSzPoa6ZuIZWlFgP0nKGxR89LtwzM+gtCKNdbtQD4HMMMfKO1yf4a8xm48dYYqWcIqb/14vMqUoxMiS2J2pkL3PULGPpMDA6biJ7YZVjf4p7CHta/ODFRHoXeic2c8Ivh4ijgSgYh8zKPh0VkczWYdgVpn8v5bC7HIBIh3iAPkk91WK8jeqOp9LR2nITaJDEZxng527Hmkwbl9Dd83
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB2815.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39850400004)(366004)(6666004)(83380400001)(5660300002)(66556008)(66476007)(66946007)(8676002)(6916009)(16526019)(2906002)(2616005)(956004)(6486002)(86362001)(31696002)(53546011)(52116002)(26005)(4326008)(478600001)(186003)(16576012)(316002)(54906003)(31686004)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BTGu7LJ2tD1EI2UP59gggAcRpSVYqUwxuhWcSrBWOT+YQ70LWBFWJsuu4eGK32WaMKdxWECnmtL0JqUbCZv8nbdx1aeHo8icscO8H9ABr7DIbzVWs1Ec+HXv9HxgiV8RfPYINNwthvYAZY4wMfHkW/r0ynyophk8BFQSpYnniCKj202Wfg/qDOCmSTZSJU92HVqTQqrgAU5Ez7W0VQYcaS7axt53BscrB5zWZAyTQnIfDdlq3AJFKmPZSiRWTm65977Rgw+XdALeFINsPknMg/IKI39EmKPIuyrF6jJxX9XiPYeg7ZidDMnGCy3rqX0V18bnL6YDw1M8wEdNXL3SWKNWts+YTbylBMnhVZa3fi5c/y3S+WrxLzJQLEPOZv6/j2VaFJlfKZvW2aAh6CiMl71iUfWoY0HfIVbVSfFTT8E44CGF7wN+/NqEtg/+80EgEH+y9QPDoTACsvHgCsBrvOaMtJGEgJ3SNaRh+GJquOnR09L08Ug/rqlYJRWBj4vHELi1hBGEVrW5tc6aNCdt11VeuZXfnXpqN9eZm0cEN6AwwCQs2xJU4W+TujTTYlhLXwpF3Mu7hc2PzR9/uSIqyUsXGhgmedP051zECvqdRvrVrw0evys9IFA5QNn3gKKZr5PoHdDhBqbJFgUUdB4p0Q==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e771a0-ad58-4464-8811-08d8801cac29
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB2815.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 17:19:51.1684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pKrl5Nhy/cOGkyZ+lBVCoRRBrn6DqmdeYMk2TqjnThSYfbXIe2WvExR61UG/M8JuYh7TJuOnx6Atdvo3dg53uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3790
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/2020 11:45 PM, Alex Williamson wrote:
> 
> Thanks, Dan.
> 
> Diana, can I get an ack for this?  Thanks,


Yes, sure, I apologize for not doing it earlier.

Thanks,
Diana

> 
> Alex
> 
> On Fri, 23 Oct 2020 14:34:50 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
>> The copy_to_user() function returns the number of bytes remaining to be
>> copied, but this code should return -EFAULT.
>>
>> Fixes: df747bcd5b21 ("vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>>   drivers/vfio/fsl-mc/vfio_fsl_mc.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> index 0113a980f974..21f22e3da11f 100644
>> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
>> @@ -248,7 +248,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>   		info.size = vdev->regions[info.index].size;
>>   		info.flags = vdev->regions[info.index].flags;
>>   
>> -		return copy_to_user((void __user *)arg, &info, minsz);
>> +		if (copy_to_user((void __user *)arg, &info, minsz))
>> +			return -EFAULT;
>> +		return 0;
>>   	}
>>   	case VFIO_DEVICE_GET_IRQ_INFO:
>>   	{
>> @@ -267,7 +269,9 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>>   		info.flags = VFIO_IRQ_INFO_EVENTFD;
>>   		info.count = 1;
>>   
>> -		return copy_to_user((void __user *)arg, &info, minsz);
>> +		if (copy_to_user((void __user *)arg, &info, minsz))
>> +			return -EFAULT;
>> +		return 0;
>>   	}
>>   	case VFIO_DEVICE_SET_IRQS:
>>   	{
> 

