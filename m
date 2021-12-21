Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F33847BA84
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 08:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhLUHMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 02:12:47 -0500
Received: from mail-mw2nam08on2103.outbound.protection.outlook.com ([40.107.101.103]:57857
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234778AbhLUHMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 02:12:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0YRUZhS0fzkSjvezR9bjPOJT3wBjvhyOIVg6kGJcCVSwJvbRSKRj5MTiD5YkHixxMSZel4IWnGZ6mDflz0aAtOnk26sNbIA07t6+R/ZTyeAiIe5hSBVvgw+FcB9MgF8Ebg3S/mWg4j/GKCtOO3nxqfxq24f6+litSZWTwelvkLG+oqnV6Gzf3Lp6GwZQWKBJQK8eFWNTwYH0N7xbeycQmCpK79/TwcrYpdYWYhDMxr3EOIQYoIwSeC5szR1qh+qjnsfEeO7PKDFdgv3RLdgoPMQgJYbKq4XORCbsZPyi7uUXzjEHq+rIA+Ue9JyQk/+46q3Nn+sf+nPwhLIhJo4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/1XSFK7CtBTP7ye54G0MZUHNCxRmHxJ8PB0x2p39RQ=;
 b=SlxpDKSDJZyJKDzABo+wGNoWSwYnCnvRCWtCDJQagvS8UUHxcYLhhMwIjMeV7SIgF9D4W43KzU7TjUrwD1HzzvGzI5DI6HZwFHmRFmMtGUNePMwJtOYw/jHzlvWEgsd9QdK7/4JyyUVZnowNh3O3rrWSaCDI4hGg6si8fSw0OKTUA/PVNPhtK9QDJGy4XJCfn4tZwNV8RnntgA6gEpkWixz9O9xdJc0R6RRTj6XvYQbX7mP1BpnKC55t3FUb8Rv7nEQ4bdhDtpFr1L0+74H4QLFndoDL3YjMPCTR7qTLfMUJgzsdKC4AF5Ctn0UdLRXCdzuvY9dGyVo705cRwswj0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/1XSFK7CtBTP7ye54G0MZUHNCxRmHxJ8PB0x2p39RQ=;
 b=jS3Q7q2rky5l121KLyA/RVi+9ZMTFo8e59SZ85YeEJXBwv00F1xakDeBcZ6Nma0oYkej/AqIH7mROvYF3Wo1XrJLnaMECep8uPRI+rxbr/u8LY2OIk8sJXwa4WqryB+uS5nq8ks44j/m0kechxBwk1iX3fdwKXdV85p0Mst4X6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR01MB2716.prod.exchangelabs.com (2603:10b6:3:f8::19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.19; Tue, 21 Dec 2021 07:12:43 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::209e:941a:d9f9:354e%4]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 07:12:43 +0000
Message-ID: <ccfc064b-55d1-470d-5815-94935e785279@os.amperecomputing.com>
Date:   Tue, 21 Dec 2021 12:42:36 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 18/69] KVM: arm64: nv: Handle virtual EL2 registers in
 vcpu_read/write_sys_reg()
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-19-maz@kernel.org>
 <13046e57-b7e5-7f0b-15bd-38c09e21807a@os.amperecomputing.com>
 <87lf0fwsj5.wl-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87lf0fwsj5.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0262.namprd03.prod.outlook.com
 (2603:10b6:610:e5::27) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78921089-f735-4051-36fa-08d9c4514804
X-MS-TrafficTypeDiagnostic: DM5PR01MB2716:EE_
X-Microsoft-Antispam-PRVS: <DM5PR01MB271609B2E5D80772CF59819D9C7C9@DM5PR01MB2716.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qL/wdTm9Dyf3Oi0rAKu+6WgMiSyAGBrz9NuLAWMBrgyWJppPYDWkhOGoRixZXFaZlvRL++R1S7bXyFQ9reIGOBDKDRMZK2PM2nHzEkSPg+ETkaG1q04N50QqYJ9oNFkz7BC4g1yEYsXIrLJ2OHUgvzS4MXEoZ6xSvyLA9GF+NpJzFEbPLr+0ZmwsAjo2ZVrwiHJtqoXd/rZGMcInVarYZzGNaPOsFvfaT8Rc4C9Q6A9rS2+4Q6xf64l6on3WSEpH8gMV3SeIxH+y3SGVjUljXToZWzGJNno2euEzer9gdQ74VvOJP9U7dD8E/NLnxhwDxza9Dp9GSj6d8THg65aToK7Uock5NNR3Ks5q46flCsAIQDWIx5zFzaJPDvyNkLRh353Jx7cmScsl2kg8psj/xsug9XTScpSBHLuSWy1nvBkIB9CIyWS2f1oupIiU9CcZKQYVZ6q/WVd4p98jEZOUvJeDOh7ObwJlNHSxyIYtefBPyRaGfQjK/iz7SBWHq2sGlDrjWsVGawKSVO8Dlbyu9aBeZkzpmO7x3S45t1wErp5vxEvMk2ew/zh7HZiGmffOk6+vtl84it5LwdkgVPkYahKZQqTYNyEeeQqIhn3A6MQROUJi56CvJfs93b22LVP48Syh09pPK0ToyaDSqek7+7yDkyW5keYpcRO3Nr2W2dBso7Q/8Uk66crs5C0T+z2iznz4gl5WJdT0QVZ8EJmgFwrL6WqxTwnB/bAqyccZOjU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(26005)(2616005)(52116002)(7416002)(186003)(6506007)(8676002)(31696002)(6916009)(8936002)(66556008)(38100700002)(38350700002)(55236004)(31686004)(5660300002)(66476007)(54906003)(6666004)(86362001)(66946007)(6512007)(6486002)(508600001)(83380400001)(2906002)(53546011)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmR2S3IxNkg1bnV5QnB1Z0NzZkpYMjJsL1l6bVhybFAyL3FzbXZPNVVBd29Q?=
 =?utf-8?B?cW11bHRMcUlHcGtERkYrb0hLTjBrcjhuS1g3OTRaK1BnK1kydWxqWmpuaGhP?=
 =?utf-8?B?M01ZajhFYVdIaG00R0tJc2N2S3BKTE5FVkxxcFhBcTJxOFUxWGpKZG1NOU5Q?=
 =?utf-8?B?Q1J5UnE0NEpmcERraUtVaFEvcnV3eWgxaTZGdXRWVlBmN1ZSLzhuUHJVaThH?=
 =?utf-8?B?QWJ5REUrSk9meXZjcjJzdjhtVjlyZ0V3RWlYMDM1bWxKS0Y2Rzg5RStvbFNo?=
 =?utf-8?B?NTJQRURseEVydUF3djBmWFU1MUlWbDMrVGNpUzh1dzFmNS9HZDlpeGNRb1B1?=
 =?utf-8?B?cXdmZk9FUUk5dXk5K0trVzdaa255NzZpelo0MEFsVmZNb2h1UDMrajQ4cy82?=
 =?utf-8?B?Q2FrNjUyVmRXTThDNVpESU82dGhKME5kczV0NVZuWW9DYWFJMHdrVjh1U1RB?=
 =?utf-8?B?UGpkOXZYam1DUHV3NnJsbDhVeEhxVkoyZnhzekpKVWpaRWxqM2NEdStobTlI?=
 =?utf-8?B?a1dZbThzbE5IVUl0NVc3U1kzYk42S3FEbHVibnJJS1NkL20wTDZXU3NUaVFi?=
 =?utf-8?B?NTRhbDBaS1lreWVpSzJxcUJtcVdEclNoNVJCWnQyTC8xaldIRnhqRnhtVVF3?=
 =?utf-8?B?WkdNbFh5S3hRNDNYOXN4enpjeGQxTmNUVTNGM2RUNndqUEkrN3QzUloxWm1D?=
 =?utf-8?B?dHh3b3ZoT0d6cWk3WmovYXNzc0pzdVNaQnJKSWtmVjFOU2xoYmZncEw3MUps?=
 =?utf-8?B?bC9nVlRLZFBaaW53VkhCdldBWXR0SWVMa1BUcXN4TnEybU1BVmc4VUFUMmZF?=
 =?utf-8?B?NFBCUWhweUxEckhKbERYUm5SUVpFQmZBdGtURUs0ZVdMRUEvcDM0MDBjMDdJ?=
 =?utf-8?B?VXZHUU5WcUxiL3R3cXhWdURhTnY5SlV4bXpDTDFOaGJxSnJzbEp6TEVJbkNx?=
 =?utf-8?B?d1JYMUdDTWFJclBQTFpQSEt6bEFvMFE1VUNMU1JYb01oaHpOdTlNVnpjOTZs?=
 =?utf-8?B?ZUd2LzhXRTVYNCs0dkwzc3l2VlVMZzZpOWdWZGZ5ZnBpdUQxMTEva0FiVEpZ?=
 =?utf-8?B?cTd4VDNYWnJsYTZMSWl4cld5REhCT0grc3B0VVYvazQ0UGROQi9rREwzVWFa?=
 =?utf-8?B?NzB5MUxDS2VNUXFJQU1ORFYvbFhDaHJmbjJEN1VlQTZiMWNHTC9jVmIzZ05m?=
 =?utf-8?B?ZTgya0hGcXM2L1BZSW1aQUFrQlBwT1k5QzR0NVUzYkd3NnMvNHRyNGloTHRr?=
 =?utf-8?B?OCtUQnFjWkwxK0tLOXc1VmNINitRMnlDTDQ3Wm9wc0xXY1lBVXR5cEpiZXZV?=
 =?utf-8?B?bmRQV0RndCtNS1NzdHhMVUtya2J5N1NqMnhTZEdkOUJ0bWtwUDFJbldpajYy?=
 =?utf-8?B?UVRhNUhESlB2TGpyb01YcS82bDZBcXEvMnlSdHlpV1JKbldCaGczZ3dDenNY?=
 =?utf-8?B?MVNocXZiMXN3djBXRysxMnhiZWlsZ2x0VXF1UTVOSnl2Q1pKenlVN055K1RS?=
 =?utf-8?B?Z3ZselNjZEV5NW5LZUVhUDFmNE80bFgzdWk2UjVzWGREK283V0lNZUpnODJB?=
 =?utf-8?B?WHBjaVI0Nzg3UUVwSjRrOXVGMVJaTWlNdmYzZis4SXh6Nk1JTVBFb2txckt4?=
 =?utf-8?B?Mk4zbHdUUHcvbXl2MzRLV3RWdmt1WVAvd0Z4Smtmc0RNOGp5T05PZzZZSlRS?=
 =?utf-8?B?M1NqclRoRVBhT0JxdlhRZnVTSEF1cFc5MDQ0OXQ0cElyQXJkb2JlVlExam5z?=
 =?utf-8?B?TTFNV0J2TGhhaTRTdkFYZkJmUnYrc3I0UDltRFpYZWNUWm80d3JhWDdjQ2dT?=
 =?utf-8?B?TG9WZldlVVFLbjhjNlFVemRpM2I2aVo1Y21tcWdkbUhnYzMrR0Z4Zmk2aW9Z?=
 =?utf-8?B?YjhDWG9hUU5kdXdwSHpyNHVVNGtmeU1nSjFzcFJoN3BjcGtOUHBtNnoyTWRK?=
 =?utf-8?B?ZkU0ZE0wUEZSZHl4YkJxZjZGdWhGZXVnSVp1RXczZHNYV3JVOUF0K28wUFoz?=
 =?utf-8?B?QjU0QjFOS25acTRBT1VHNm45UnJodGdXM3dnT0dySjNxaThtY3BGK0h0N1lt?=
 =?utf-8?B?ZTh3NFN0RlVucHU4R2ZVc0tjc2tqQXVIdDlmVFdHUU9scUlkSkFBV2doMVVw?=
 =?utf-8?B?L01JdjIxcmg0Nm9Ddi93clk2d0hBb05RSkV0WXBpZnRMM1U0RXhucVMrNFRz?=
 =?utf-8?B?RmFRQXgxSmxCTHgvY2JXTTAzcHMyYTUrRStkeWliclI0Z0dpNUFMYlRuUmhw?=
 =?utf-8?B?TXJ1Sk5aK3dYQXlEVFlhTEVRaXA0SHdIeW4vaWdKVDRJaEtldEo5WC9iQ3Jv?=
 =?utf-8?B?UjJIN2RBZjJ0WWVDNzh5dlF0MFB1ajdvWmRNQnRqdFRUMVRjQk1rZz09?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78921089-f735-4051-36fa-08d9c4514804
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 07:12:43.0203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orcYZcEIE/U/Ub5tf2oENrrNSoDKIptspJyjE/Bs9JLfWj3iIwlrRzqOaHh+R1jq37Gx52m615ChuHpsrDB2yVML6SE16dWiZOfGJbl0LiyQ5GLHA9uA1LGS3Ade2J6S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2716
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20-12-2021 02:40 pm, Marc Zyngier wrote:
> On Mon, 20 Dec 2021 07:04:44 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> On 30-11-2021 01:30 am, Marc Zyngier wrote:
>>> KVM internally uses accessor functions when reading or writing the
>>> guest's system registers. This takes care of accessing either the stored
>>> copy or using the "live" EL1 system registers when the host uses VHE.
>>>
>>> With the introduction of virtual EL2 we add a bunch of EL2 system
>>> registers, which now must also be taken care of:
>>> - If the guest is running in vEL2, and we access an EL1 sysreg, we must
>>>     revert to the stored version of that, and not use the CPU's copy.
>>> - If the guest is running in vEL1, and we access an EL2 sysreg, we must
>>
>> Do we have vEL1? or is it a typo?
> 
> Not a typo, but only a convention (there is no such concept in the
> architecture). vELx denotes the exception level the guest thinks it is
> running at while running at EL1 (as it is the case for both vEL1 and
> vEL2).
> 

OK got it, this is to deal with Non-VHE case.

> Depending on the exception level and the running mode (VHE or not) you
> emulate at any given time, you access the sysregs differently: they
> can be either live in the CPU, stored in memory, with or without
> translation. That's why I'm using these 'parallel' exception levels to
> denote which is which...
> 
> HTH,

Thanks.
> 
> 	M.
> 

Looks good to me, please feel free to add,
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

Thanks,
Ganapat

