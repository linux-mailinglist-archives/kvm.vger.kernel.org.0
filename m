Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25F668B5B
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 06:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjAMFbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 00:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjAMFab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 00:30:31 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2686130D;
        Thu, 12 Jan 2023 21:29:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiThprUJtWEt/tVyEizNqGlIOSPl+MYVzg32CH6/Fu1xt98eQ6ZQWDd3nS10UY8Dr7gExNPC4+c8eo7J1FxojzlQyt7zM5WqPkOelxDzgucKsJ+wGmXwrcNXjjnB0ms8S/XdWPQq5dU7NRV1ZkUUjek1znyAIleMOX7b3f17peb/kumZCA5C9yyGYHS+ndhBfXULM9ie4WOUVDKC64sJV6lU9X0kgfLU6miW3IzV7ThshQYJg85KU5WwSb1zyX4I8u6sUExfmqBhmBSEK1/S+wRRcJbxDjFDroiZMBHFb8wnq9Tu81hAHGohJorrS9zzLjVZ5bsEUf4cv8GQ9SsFaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdIDLJXk9V4ymMeIUFPDy1hLr4RddNVB4QAstKy5GTQ=;
 b=Y/i+PZ5E4kCoRyhmuDHpiTk5HPbNnFBH1+VNFMIRgDyI20KxxQzVdV5ybVLyQZaaQc/5N8uv9F3jHEoLu28d0ZF5tTXHcou4zVNBrbuoMC6lkzCaatqxz1Xp2rLbTim4ogrCZe7yzNO3+Mj6ljMwpQ7e+qktUQwWJGfWZjuZngw2UGNpXP8aCVx9aAMswBmUvvSijNwqJTa5gJNMBvYIrTAs8Vg4yUSBBI0H5aS5cBaL5FUlm7+Xb/VADbPSJUgz5yZSg4KVNFahRKd/wwnwYMYHadEUhmnAqu9ZRGcker14EdfUgKo5vlhE0PY6Z72t+a8LUlfbAiXky1krpT1uhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdIDLJXk9V4ymMeIUFPDy1hLr4RddNVB4QAstKy5GTQ=;
 b=E6uz2N/qzPImN72ddcFGDX+9VJh4TF8dVbWkWG7zK2gEPFr4ahjAJl87SOR38U6EShZ5FZJak4IA3atT7a1JUhmwdKdHz60p8U4iI2hKDr+ydPnT07LG1ACvs/YaofidMIYal6C9f0UJcr33haiJlssaxAmsGYYjZ1DL4ECuoA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB5183.namprd12.prod.outlook.com (2603:10b6:5:396::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.19; Fri, 13 Jan 2023 05:29:15 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 05:29:15 +0000
Message-ID: <bac878be-acaa-e373-f5fc-fb6b35964eb5@amd.com>
Date:   Fri, 13 Jan 2023 10:59:01 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation support
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de
Cc:     mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230112084139.12615-1-nikunj@amd.com>
 <4cf6a6aa-81f9-4fae-2a39-1825433f9ee4@amd.com>
Content-Language: en-US
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <4cf6a6aa-81f9-4fae-2a39-1825433f9ee4@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB5183:EE_
X-MS-Office365-Filtering-Correlation-Id: e5c67a55-fe5e-44e4-7d8e-08daf5271bbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IXl7ngI3C7SvtfUlncT+55atOKBh5u7Jw6n2PD2+ML5y4FC/P9qxIdmFbEZuDPHwZR9aJuKQr6Rc5N6WVz5G9ZdYDu5pbCVjvdSAiXumEdCzyUf0eSDZJOBiu0TFqdZ2GVsTOa5X9RKn/ivBt6gjAUhFdzxmqFyK7FD1YNZ7gA68aLMYrE4JbT9M2eBeDEIhuqf0Rau6XR07kTcMouq1mz3uGkuYhihQXxOa15RhLzOYqFDuCxXhJiNne87RHenrkXH1tZGCbd5pzk5IGN0ambD8bclMKeherbJBfiGyZ/COjlOKp7BaUavFoi4bROLVIG0Y7O1ghlDT8BrtB6cYWnyAHM3shdsQHMHwr9bIa74IPkkYhZEUDC05azaMRJMXvHh+xOG5dCFaWtVEKLebGjiT49c4oRxxQuWfuh1ZM/koSzkwZQZE8vGBFsbFDhHSy1dMY+dZIPSgLMq/DLzTKGC+InghYqRjf7V14aPyQG7MnBsUXUnoSMXVZewxngc2bam1JU63MxEDI/224lNvHVgxo3ZK00o5AdTDsO+ej4Kosv8Vygk4YKnsmjZ39KGeT25gtmmBDf5dLEAGRyDZLzAplG6A01OqGJAZqprbOWPtZRSiGz5pUk/u1Aql9Dboys2EC/L5gdBHEuhTcrpfsPpAnTPvAHo1wxFndR2Q94mBjTaSmEb3NAz+nz1wb7Tf82W+H1P4vTjHpi+prNkqKbYGF81I5AQiTX4n1pYdj3M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199015)(31696002)(41300700001)(36756003)(5660300002)(6512007)(7416002)(8936002)(4744005)(53546011)(26005)(186003)(66946007)(478600001)(6486002)(6506007)(2616005)(6666004)(83380400001)(316002)(4326008)(8676002)(66476007)(66556008)(38100700002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVowMEFLWEk0aGdHSzEzSTlNakllcjVDNGdjSUw1NHVHaVZiSVdCMCtodDNr?=
 =?utf-8?B?ZEFHcGI0RWlXRVRMY3dWUnpKTmtURWh4YmhkeWVPS2dKRXpoV1VPQUpsdTdN?=
 =?utf-8?B?aEEvNWFzYmRac1JKNzFSNWRhZzNjS0p6UWlMTEtHdkt5R3p4aS84NFljNjQ4?=
 =?utf-8?B?WWlNZTQyNnBhQ0FYOWdwYWVVenN3Mmo1aWhmZ0lZQlhydlZjcEIrcE42Z2cz?=
 =?utf-8?B?YzZpUHB0dG5YOHJWNEJ3UlZFQStPcnZFV28yMVRrWkUveDg2SERXMWxRUXI4?=
 =?utf-8?B?STJNZVZZOE5La0NWWGxESENvWXFXbkpDZ29ydmlvU1NZVElvTHpGV2dzbURy?=
 =?utf-8?B?blNGUmw3L0ZUcVlxZ2licFFuTVo1amhjSE12KzU4TDB0czlOdVhPL01KRmpj?=
 =?utf-8?B?TGx6SW01WUNod3BCM2lmaVNCYXhwcEZyaThSclpUeUJqU2I1RjllcXd2K2VV?=
 =?utf-8?B?V2Zzb3BENGw4bDJ2NW1jMDlqU0FrZHJ6QjVoR3FEaW1lc0RKNGJhMWZoVGo4?=
 =?utf-8?B?aDhFWTdiOUI1S1VpWGt1L1A4Vk1xWXo2OVJLT010UXloZ3J4UFFuVEE3eWJ3?=
 =?utf-8?B?NThFQSsvSGF6aVBTUEVucWE1YmtRV3RRdm90OG8rK1ArUkNPblhPVWVRczNp?=
 =?utf-8?B?enNzb1hGV0VtaHIrMWFCMVhCVVk1S2F0OHZNWjU5TG1weGFTMGx0Y2E5T3pR?=
 =?utf-8?B?cVhsTytkYkg0bkllUGR5eGxUWVdISDR4UW1jVmdON245UmlmK1VKdG4wWlFB?=
 =?utf-8?B?elhNZXFtT0UxdW4xS3hXTVBkWjdoVk9zbVJzZnVGRFd3WXI1blh5ZEZnc2ZD?=
 =?utf-8?B?dDVMVkViWGtZamNJa0FRUzIrRWZsSmgxbk9VQ2JYSnMrdEtPVTNocjVBUS9Y?=
 =?utf-8?B?ejlScDRISGlramgwN1FmN3NvNFNEVWlUQ3FTVnFZMEVadm5nUE45NW5wUkFX?=
 =?utf-8?B?czE0S0dMenRoNGJNRFE2Vlo0YmRzVXRReVZkQ3RsZTNiaEhlaGpDY0cwS0ls?=
 =?utf-8?B?UVNVN2pnWDVjRzdDVXZoNTNBNDBKTWpadE5nSzZZYU1YZUtQTjhuUzZZMFQx?=
 =?utf-8?B?MzlyWmkrWEsrbEZtVVZOdEVRZXNsdHUxYnR0aisvc1E5NitLZTRzL0JzbXkv?=
 =?utf-8?B?dmhXcUYzRDlidTlUdzhOU1RrOG9XakVCaUYzWXJWM25FQTRiM2d1V2F1b01x?=
 =?utf-8?B?dXA5Z01FQm55RytxYUR3VzZxbFBCUW82bDcrWUtSVEhwS2xaWkNsMVdMbTYx?=
 =?utf-8?B?dVBnWGZJMmtsR0xHbHQzOUZtQ3k2M1poc1EwaTRmMVNJZ2xHMVRPSTNHV2JZ?=
 =?utf-8?B?eTQ2N215TmYvUkc2TmdFOTFqWDl4c2Q5cEVjWW1ic2c3YkgrWk5pRm1IUkdU?=
 =?utf-8?B?eTkvazIwOHVXSHlLYUtQcmRLL29uQ3luL1hLd3dJSUl2OVFZalZuOFhUVVVt?=
 =?utf-8?B?VExaYyt3VndFZXVoeXVnY2hrWm9PZk1jT1lLT1Q2MndlMDdnY0EvenpNS2c1?=
 =?utf-8?B?L05udFRoNDVlRmRxejk5WmJBVWhvNVdLK3lKUjhYR2dpN3ArbEVtQmhJbHBx?=
 =?utf-8?B?UGRUYmNCL3VIUlA2cTJ1UjRhT2NFam9FMWlDeWR4cDM4R1hGQ3Z6eE9qQ0kx?=
 =?utf-8?B?c2NPRTRDZ2tLbmpSUXYwT3h3LzZJa3VqaC91YVAwYnU3OHZiL2NLQkJnRmIv?=
 =?utf-8?B?a1k0aFdVZjNGT05oT0JGakl6VlNZUnc0MDh4QlhyY09LQVc5YnJ2WGdDWGpq?=
 =?utf-8?B?TzdFUzA3QUNSTlNUbVVlWmlwOHBYZk8zVkJSeWFVSlVHemVZZUJQN1hIeTM5?=
 =?utf-8?B?dXgxZTBqTnI0NzJXdnVhbDBMV0VqUkUzSWgvakQxWm9rMHJ5d0VFOVkyZHNL?=
 =?utf-8?B?TlVnWElHcDlscHVLTmg4eno2WjNIUFNHcXgzZGkxQ1pVYWphc050a1FnNlVa?=
 =?utf-8?B?RDAvOWpIT0V6TlRjckUyVTV4cXJ5R3luRWY0aGVkbjM0UnF3dnhBMDlKc3V3?=
 =?utf-8?B?L2gxUndtdG1YeXJyN2t5aE9KK3JHOUllMmxZYUU3MThWSFUweVNpZk9OV2o4?=
 =?utf-8?B?U1FLSm9ndHYzQzE0UHVIVWsxbWtER3g0VkFHZlhkVUFoS2t4b2U5cjdaeTA2?=
 =?utf-8?Q?gFfmbsf5lKm4S6I/jmFSxoBHi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c67a55-fe5e-44e4-7d8e-08daf5271bbb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 05:29:14.8679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5aCZepI8c5TjUv3qCTxeJJJNAxi58zoihUho6LCmOHIKTH6jRTgnIq5RJnYTyCmSw0JkKgkm2IHtkHu+FuKDcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5183
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/01/23 20:12, Tom Lendacky wrote:
> On 1/12/23 02:41, Nikunj A Dadhania wrote:
>> +
>> +        if (sev_es_get_ghcb_version() < 2 ||
> 
> I would just use ghcb_version directly here.

Right, that will work.

> But if you really want a function, that should be a pre-patch that also updates the other areas that directly use ghcb_version.

There is only one such reference other than this one, will use ghcb_version directly.

Regards
Nikunj

 
