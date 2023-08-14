Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA0B77B397
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjHNIM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 04:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbjHNIMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 04:12:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2115.outbound.protection.outlook.com [40.107.243.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87ED109
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 01:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtPkRDvNRxgS4+FVHlCCeLv0rv25AY/t7fY4mxfUe5fVR8lK+mAm+aLz29TSlAqedMxz5/jq4rNTRmp3kOxwbFizbS4Oysv1gebqpUqtFYa/Y1cdgl9nmz5lHLekqcFnx5jCQ6yllUKA6oRncnfXC/3iTpKmUbc7ZawHYaJZNg3ZVG/ihlzLuJn2iYTh3OE6Z8hnzoJdcqZ31sRaEzHB5hPTomVMcJbypHWb1Gsrw01XQJEeDN+3uziiXTm5RfIcJt+ONL8E4IOPlzLE2Q1WLC0iEQs2Gg25gBfFuODY9hgxohunGC2iYyMq1BMnPJm9g++o6b5dd7DsAVs51Bnj4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxMcAlB1OmYjeXeBwy7tNbWjYll7ywrhtM1NkyMckng=;
 b=dTRXzm/pfcNGvt7Sy623ggjOCxk6D8vvC5+Z8GXmRqEaE/iz+L1SE0C440N/E0pB9aP+zChrjm9ggSlseFw6DJEqqt55vebZpl3G7xgNGZefGe14UqVPdxp+tpRlix08iGH1xAeHkSOynJJ0AW4VIYAkiCdlG0bfr3CJ+6hHUzTU7tJhMN8Q89+6w+3DZF2wDWFJPJUOIYvyiGCx9EeGMqXZMfrmKbDwjD0uVOGeUhwhqkIi7vjHkzfj+LIqgKNqmZAUV5Gnom5ctKTsbSQeG5q1h3T6b5/aFzXeb9cHGqrLUYPmSmfGGbWTE8EUNxbujddOok5las8Q6gdoGRmjpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=amperemail.onmicrosoft.com; dkim=pass
 header.d=amperemail.onmicrosoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amperemail.onmicrosoft.com; s=selector1-amperemail-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxMcAlB1OmYjeXeBwy7tNbWjYll7ywrhtM1NkyMckng=;
 b=Jvslid2XHtgyTbbAyeLHCMBwTzBrFe5x9xp/QY258bsigS/ZwTrYFuryfiAjZqMf2fPna66i3QUgFPgqj5F0NZMrRP/t0zYO07MgXC4H04TijgIcfku3yINV/0HaQnpq/DT5R6pmQcEBt4A/2NNnWWKSOjt8O+xC/ezlPYdYmWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amperemail.onmicrosoft.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM8PR01MB7032.prod.exchangelabs.com (2603:10b6:8:1a::15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.24; Mon, 14 Aug 2023 08:12:37 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::d62f:d774:15b0:4a40%4]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 08:12:37 +0000
Message-ID: <5608d22d-47c3-2a03-a3d9-ba8ec51679a3@amperemail.onmicrosoft.com>
Date:   Mon, 14 Aug 2023 16:12:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
To:     Leo Yan <leo.yan@linaro.org>, Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Huang Shijie <shijie@os.amperecomputing.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
References: <20230811180520.131727-1-maz@kernel.org>
 <20230814071627.GA3963214@leoy-huanghe>
From:   Shijie Huang <shijie@amperemail.onmicrosoft.com>
In-Reply-To: <20230814071627.GA3963214@leoy-huanghe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:610:b2::25) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|DM8PR01MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: 84653681-420e-4f9c-9311-08db9c9e38c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tpNs+FJdisr/1Mt3Q95j1fbZ7ssIIwCmL0mpvGLatbFAvZETo4mf1PY8opeIfwfpAKQdVxvS0Ci46ZYzfcneTh45fEACBLXDBZa1mPINvW8Wa1E+bmTjjAnuogYcHCJu+xT5DXVAyObTP4/penfSVfDp+VsDomwg8vedF/keAk5So6pJqxvA1KXUCZoGY48KGfgpy9aItkueu8Ky9+O9lmyIk0EEtNbtwrBSLE1PpS+cD3PV1vMWvDwF5qn4hHfZ9K4gV0jLtPoM4ks309WwVs2pDqr95vu11ri/zxKPA9xs1PvmMbmivcXiddY2lJzdV+ZKurwWrDvvkBZwvuD0uzVlgqH7zhaced3yRdZgUXpRuOuhH7UD+xJ4KzyCwcFehvJs4vob05KNI7MDctm5jO/dn+FO6efT3DNdAzRNE2Hf1GPAGGYnQvZ0/UUimv1CFtHqCDcfvnkaLzSnasfwdDodvKkyVl2RHhEhAIRfSDc1TiDt579jjjiAWTp72+uqEhaOBGm2uEIDLQTLT3WUN6Z6M841OP5vBwQEIWcPwmUBeHNJghZ1xtToiX7/Zu/uiEZeVTFMkpfnl7NBJrx60YnWd8L/ItedBzghz6kJ0lx1LmD+RD5ZlVGgXibTvwdaCbLimv/hqT7OMsZfDjKETQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(346002)(396003)(366004)(376002)(136003)(451199021)(1800799006)(186006)(52116002)(6512007)(6666004)(6486002)(6506007)(478600001)(83380400001)(42882007)(2616005)(26005)(2906002)(66556008)(41300700001)(54906003)(7416002)(316002)(66946007)(66476007)(110136005)(4326008)(8676002)(8936002)(5660300002)(38100700002)(38350700002)(83170400001)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTlNb1NtNngyZW9zYkdWWEY0bGNsbGNnd24ySjE4cXhIN1F2ZzBDa0I5Nld6?=
 =?utf-8?B?c2J0MkxJQWhNbzNLRE93WDdtb2xnZEVCZ0RuR1plbnUrRzI3cFlBVUhxZ1RD?=
 =?utf-8?B?dXpoMFlyK0pYK21zcUxaTGpTb3N1RStGS2lQMGszYzc4MnlqZWJNV21wR1pv?=
 =?utf-8?B?SWNUbjdxUHRzODJ0Y1l1TjhMQWlYUXBDUHV2SmdiYlBvRENiZkEyTmE1RnMz?=
 =?utf-8?B?RkxHOW1hT2RZQ1hsRGFscUQvSzUwNExIbG82VElWeXNlRUxKajk5SmJTeHpT?=
 =?utf-8?B?bDNXc0dKUko5V2d5ckdadCtMSUdqdEFGRVU2S0hBbTh4cmE2amlnaEY1aDJZ?=
 =?utf-8?B?S1N6V1BTTWRzTkVDUEdWRXpUU3hrN3QxMWVmZ052SThvOGxsaytTMGIxVUJq?=
 =?utf-8?B?V3pacDhZamVoeG5lR0g1WnRUMmRKSnd2ZjI1Zzc2dytwQ1N6ZENNWDFRbUtw?=
 =?utf-8?B?a3hKWHczNWpjdk9WRkZVZ21iem53c0ZWS296dVJPZHpRMTlvMmdCRFBzMURk?=
 =?utf-8?B?NHNDUUozUlZlSGtBOEVNN0FBQmE3QjNsdlJyWFpORHo1TjlvWDR1TDg1d1Bw?=
 =?utf-8?B?eVlHVHY4NG1OdEZrVmEyL3pDTUV6aUxjVWx4U2J6NVFGZGNZZnFjM3BBZVVL?=
 =?utf-8?B?aTdiVm9STjZSRnB1dWdla1E0Y2YwK0Q0R3d2aEpveUlPVEl0WnlHUFdndFBU?=
 =?utf-8?B?bENqaDBrbEhoeEl6RjVoS05kMGRlUHFEVzZHNkp0MzJENlY1M1JTS1ZhVFY1?=
 =?utf-8?B?YXBhTXBIQUlzd3NXOUxTRERhVEhxc2hFV0VmYUN1NEZNM21XSkJwMlJZaWJM?=
 =?utf-8?B?dWN0WHpHY3c2S280NStxN01FdGJyV213SXg0MG9SOFE2dkc1dVA3WXlURDRa?=
 =?utf-8?B?TXh1Mm1TRmhGa0FySmg5TkJseDN5RXdTODBGTy9BVXBnQWJCOUdHU3NGNm1k?=
 =?utf-8?B?dG93eWhlaFdsZ0svZGdjdy8rZkErME1kNjNnSktLbk1RUmhUdHp0MGJEbTR3?=
 =?utf-8?B?VldjSm1OeEVhcm5ucnBHalpaNHpvMEZmU082TDdKaFdTUkwvUDFLT2pxVnVk?=
 =?utf-8?B?Ti9GdndZTXZkdWRxZXJHMVpLeDFpSklvN0RzY0xXUHpsQ3ExSmtHU2p1dWkv?=
 =?utf-8?B?M3E5Z3o5eVNMTU1VSFE5aGZKckhLYXlQZitkdDhobVNsQXh3N3pwWCtVWjVJ?=
 =?utf-8?B?d2tlMTZ3S3o2V0k5a200cVNjVVBpa2ZhWFV1Nm9oM0FpMTBrUXFsbFFWdjIy?=
 =?utf-8?B?NDN4TWxWN0ZmMkpmYk10NWVBT1pWVWtBcjVNWG1rOWJYMjFaUlJpRHk4OHJY?=
 =?utf-8?B?UDBNTFN4NTRVMHZoVnR5RXlqaEw1SDRjMUZ0NTF2Sjg2MmF5TVF0NXpRUUxy?=
 =?utf-8?B?ZStIRGc1SkdIR0x6TWpVOU1kT1dDRSs1YU5pVHhVSExMKzYzVHA2Mis3WDRT?=
 =?utf-8?B?VWRDZEJoV0x2REhVSlhzQWQwQ3FjWW5HeVE2V3NoSzNIS1k4WFhvVVFWallE?=
 =?utf-8?B?K0xrUThobnpRd2cwVFZ6THF5RUNjZUhGT01CT3VjZW9wd3ZpVVdWZVBmaVZZ?=
 =?utf-8?B?Y1lFN3pjWS9qYklUTlZhV0hqa0RBSjl3bm1tVE1rSWpET0gxSmk2dlMwcW5B?=
 =?utf-8?B?RDBmYW1jc2xtWVBRYXJlbklwWmI0eWJTZm91dStUdE5OTkl6RmdSdXRMei9D?=
 =?utf-8?B?Tm5oR3FTbmF5bGdDYmNKMUd5QzhualkrbSs3cnc2azltN3JVcGxpcWJCdzZJ?=
 =?utf-8?B?NzlPWmRlcXk1QjRNYXBxRTB4RHkzQitwSlhvRlBMSkpCRmdhSktmM1JvZ2dL?=
 =?utf-8?B?Vzg1L3NhZnVnM0J6VFV6dGhsTURJbEt2SXpVNlRSOWdTVVJybFRrdE5JK2pC?=
 =?utf-8?B?Q0k1VDBJR01NRmJHSGFJZ2ZLeEhHWGhER1JpOWNlcmJyUGhMVUFuUkhiN0Zo?=
 =?utf-8?B?eHdGODErYVlyMWdNVmFaTXFMUzZNaUowdXhKNjQ2aUF6WjFIWGdPZjFieVEr?=
 =?utf-8?B?bDkzdUpnRER5RTd3ek1EZWxUZ2pPdi81ZEN0V0JyL2hFbGRpOE50NlZ1cHp2?=
 =?utf-8?B?K21CbkRlelJ5UzhZUHI4RzJBQnZ2eGlYZGJtUGkvWVZDTlFTcDRrbm1qRkN4?=
 =?utf-8?B?WkMrNWdWdmh0M21nclJKTkRtU0FPVUFaa3RCQ0ZDMEY3aWxKQmVDeC9EZGVW?=
 =?utf-8?Q?El8JEVpo9dZQ6FkTUG4O7CA=3D?=
X-OriginatorOrg: amperemail.onmicrosoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84653681-420e-4f9c-9311-08db9c9e38c7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2023 08:12:37.5273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NaTCFWFCIqF4uMiUWYsPHZFCslCC8kTbI1S4vwwTl3GMuPskaV4cvSBcGdMzpL5bdQq4EVjs3REvJsBpFKeyjZzIUPIP3SwzXpggHHqiyC2LiNzDU0rE5TXboS8NIo/w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7032
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Leo,

在 2023/8/14 15:16, Leo Yan 写道:
> On Fri, Aug 11, 2023 at 07:05:20PM +0100, Marc Zyngier wrote:
>> Huang Shijie reports that, when profiling a guest from the host
>> with a number of events that exceeds the number of available
>> counters, the reported counts are wildly inaccurate. Without
>> the counter oversubscription, the reported counts are correct.
>>
>> Their investigation indicates that upon counter rotation (which
>> takes place on the back of a timer interrupt), we fail to
>> re-apply the guest EL0 enabling, leading to the counting of host
>> events instead of guest events.
> Seems to me, it's not clear for why the counter rotation will cause
> the issue.
>
> In the example shared by Shijie in [1], the cycle counter is enabled for
> both host and guest, and cycle counter is a dedicated event which does
> not share counter with other events.  Even there have counter rotation,
> it should not impact the cycle counter.

Just take a simple case:

    perf stat -e cycles:G,cycles:H, e2,e3,e4,e5,e6,e7 ....


Assume we have 8 events, but PMU only privides 7 counters(cycle + 6 normal)

1.) The initial:

          event 0 (cycles:G) ---> used cycle counter

          event 1 (cycles:H)  ---> used counter 1

           event 2 ---> used counter 2

           event 3 ---> used counter 3

            event 4 ---> used counter 4

            event 5 ---> used counter 5

            event 6---> used counter 6

  2.) After the event rotation , the event0 will put to the tail of the 
list, please see rotate_ctx()

the first round, it will like this:

          event 1(cycles:H) ---> used cycle counter

          event 2 ---> used counter 1

         event 3 ---> used counter 2

         event 4 ---> used counter 3

         event 5 ---> used counter 4

          event 6 ---> used counter 5

          event 7 ---> used counter 6


  3.) Rotation it again, event 1 will in the tail.

      In the second round, it will like this:

         evnet 0(cycles:G) ---> used cycle counter

        event 2 ---> used counter 1

         event 3 ---> used counter 2

         event 4 ---> used counter 3

         event 5 ---> used counter 4

          event 6 ---> used counter 5

          event 7 ---> used counter 6


  4.) Rotation it again, in the third round, it will like this:

          evnet 0(cycles:G) ---> used cycle counter

        event 3 ---> used counter 1

         event 4 ---> used counter 2

         event 5 ---> used counter 3

         event 6 ---> used counter 4

          event 7 ---> used counter 5

          event 2(cycles:H) ---> used counter 6


....

So it will impact the cycle counter..:)


Thanks

Huang Shijie



