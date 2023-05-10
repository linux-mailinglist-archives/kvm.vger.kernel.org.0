Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EECC6FDAD4
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 11:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbjEJJf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 05:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236759AbjEJJfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 05:35:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2042.outbound.protection.outlook.com [40.107.212.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D5B4200;
        Wed, 10 May 2023 02:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikbBXqYS/2bFYrIs77BuxNUCxhidtDxalQ6O8FmM7MbWcmhm1qYg3YFIersjx8dVp2UZ2XBaDhUAKu06i+do7ubnJymJCpa/teHtFU+nzHCHsQ6STYlsB9rOnJBwXhxoRCle/hX14gppERE7dxHUd/Z3e22BZkl9/lpddAb80Jsi24h7UxtCYc1mCAOQuKjdKWIwmDz2oipNGJuLpHnV1rYBD7twIXZSp/Ng215jBrYinpBcZrhswNPAjQezCuVYQYsci6BECdYs8D1lk9mwqrfg3t5fTzivr+d/KQ+ZXhLnBqEbGHyPZCGFXxXqmJe3RS8V/e0TZn88GuCGBMi1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFMurI/ats/395K7JxM8cjtUhIWUY12sF4OAnRGLqL4=;
 b=ZGooNE9opzs24/sAqEH8DZBga6iQ7YaK3a8XJ6Bc5KAOHXXIC9rUZKN5jZszpTeo599sEEhNlLgWeX5u2VLlwwr8fGSxz4O+h/i3AXaAf7lDK74z3K92J4muKhsn7RxueBfYkuwUtwVOfRMKNeYYnZ18We8t2cKKkXWyByRozdZKngoYrvEJPzjaWJOz1sIrZnTMkg62pEeYpAXnnyfHBZPzjTWxehUokbAh6FqWe8XwNPs9C4/2NXhTtY8t00i9ntSd/1go64aygsCns6rW7U4UbmMebkfHPN/o4JC8q3Kwi3hRz4dHy8PVs8c/yCx9o/FOfpkrwkQMDw7fknOk/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFMurI/ats/395K7JxM8cjtUhIWUY12sF4OAnRGLqL4=;
 b=ny8uLlVvwXBCLARcmBUpsUIl0/WGYhO0ENy7fwvYakpAffYov17pGmLPe4nd4NOMyrLFeJW+gXcLawcnOW38AJy+WgDZ3tKFTvgxd10kB1g7BllQBxOumYlUo0SLrUxa/OZn8FO261w2//tdDAXUgF0rBTQjIkSl/JQ8pBSS6FM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2810.namprd12.prod.outlook.com (2603:10b6:5:41::21) by
 CH2PR12MB4295.namprd12.prod.outlook.com (2603:10b6:610:a7::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33; Wed, 10 May 2023 09:35:22 +0000
Received: from DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::f8b0:cf29:9e21:380]) by DM6PR12MB2810.namprd12.prod.outlook.com
 ([fe80::f8b0:cf29:9e21:380%5]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 09:35:22 +0000
Message-ID: <bdd24f91-16a4-a258-81ff-8ffd5a0a7623@amd.com>
Date:   Wed, 10 May 2023 11:35:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
Content-Language: en-US
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
 <20230411125718.2297768-6-aik@amd.com>
 <be291727-052a-7e0c-64a0-0950e1c8b44c@amd.com>
In-Reply-To: <be291727-052a-7e0c-64a0-0950e1c8b44c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::9) To DM6PR12MB2810.namprd12.prod.outlook.com
 (2603:10b6:5:41::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2810:EE_|CH2PR12MB4295:EE_
X-MS-Office365-Filtering-Correlation-Id: ac2594bb-072e-400b-c0d2-08db5139e056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9H26vu4ahh/+wA4Jz8iBlyRs9qL6BLwasGk9kKoDhmYt9p4Yc9VoOWGjkPFpqO9Qy5r9NXNwwy+uVeuCv3QIhzGss+8L2pHTyCSr80hdeKHJNOlP5As5E/Eckush6lRJtYmNYd7whibqq6iZx3XMMfgHNpsntLRbIGAwyQqynPc73k9Xjqyi4hF4RM4TyBPo8owucWhgTIXNpz32DA4gLg4Xi0uKbDxbBddxWN/3eJZSkWeW8cDCpqETP6A5dpkdZMIYodj+eCxkI4iiN/3NrZg+wRBpkwPKcYucE21aip8Aj4Z30665/NmGGlInG2R2cmEo7aeljeQ67Kb/9YEgYUyBtzfiqNLcU+Ezo02u3eBFuCbyOH/BCQIdcegIA5XVFv/LMjkXAYwzv2aj3vnzj0FBRGYYOmBl/Im+N5QKG940bnAXQaabg0LGnTqRCfSXoGRWM95A/lnhHCg3saw1nI8y6vfGTKnqE4Go1/MTvrT3OjhX4q+EVdwqRZ08eNzDK3z6lx0GLqzRsfFjcZe5/9SnhNH2B7Xt4mCKSvnoh+fDxV5zRWxpLliJ+96R6yyx6aQh6GGfFdSeLITBaeVnlgfzO4XS7fXhy1rhEBsl0EAXS13fcf2dqPzeiHxVIKeJkeZMrQ6c6LdOpUCI7flxKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2810.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199021)(186003)(2616005)(2906002)(4744005)(36756003)(38100700002)(31696002)(86362001)(6486002)(8676002)(8936002)(316002)(41300700001)(6666004)(5660300002)(31686004)(478600001)(54906003)(26005)(66946007)(66556008)(66476007)(4326008)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUZ5cVRPaExZKytvckpkVXVTbUZ1VXIzci9xbXQzQ3VNeGZiQnV4WXBzOTdR?=
 =?utf-8?B?VnhTNWNGTkIrQ1piVmw4c2JmR2ZWcmVWMzRsWmdPUDJUK3BLZk90eW8wUjI0?=
 =?utf-8?B?aCtqRnNJbVVWL1N2aDlsTmxUOXZhYXIvVmpzWVUzL0k2MmdtQ1dKUzJTQW0v?=
 =?utf-8?B?clh1bExSSnpCSlVmSWx1emdub3BvWGE4a1dnZkhuK3g0WnNqYkhJdFhiTExM?=
 =?utf-8?B?anVtaTVUeVNmRTFzT2xDMDFxSXhUM2RGMnc1K20rWGJIM0RXYUVaNTIwNFky?=
 =?utf-8?B?aXFOaTMvKzgvZDZjK2lIa1RESUFyUGNOTjRjdlphd0ZBcjIwN3JVYm9tTHB2?=
 =?utf-8?B?TmdLNURSYUc1UzdKUU16aTNJSlFCbXlaZXZYYXV1dkVaRlk0alZaWGFUa1c3?=
 =?utf-8?B?MlhJQk5oRW9yK0NEejhZVWd5MWs4UWpSSC9FN2dqYXNhbjZ2SjVlcG9JRzkw?=
 =?utf-8?B?WFlVUExPUFc5bnBuN0lVSE10RTY2ZVplMldLbEVzdWF0RzZTckZBZHg2cFJt?=
 =?utf-8?B?Y3pvTGozRUNLUDRNRk5Ja3dYUGdlenBoS1BiNDdiTm1JYUkvRlVMSSt4M1RJ?=
 =?utf-8?B?S015VmVaRTFXbS9RS2JtVHBvOE5EeHhMdjJXSlRhZ2VuZ0NQOXVBdHZCUkg2?=
 =?utf-8?B?dm0xejAxMHRFbmhYYVJRSTQ5aWxJWUFUSnJTRGJnSWY4L2hFMm1zUzlzNC82?=
 =?utf-8?B?OFhwbUJUQmNDQTNmeUtxemh2YlRXZ0xSM0h6VFlkY2RtUWJCVjNsZXpWc3VX?=
 =?utf-8?B?RG96SkpKRGRnNElCS0ZIZ1ZDQmJQWkJFS2tNcHpTZHMvaUIwZVVHaXY1eWtp?=
 =?utf-8?B?bnZ5Y1lRbTNBMzBBS2tMS3lsT21wVU5ubnJEcjV4WnRYNWlTa2NNenVnWXMv?=
 =?utf-8?B?Yzh6M1VxOW5OMUR5czJVa21TZUpuTCtVTHRLTEU3eEhpdm51TGtsSXlIUWEr?=
 =?utf-8?B?NzB0bDZhbFhIUGQ0Y2FGcnR5Q1E2VHhDWG81aUNEOXdnbzVJdVZURmZQbFJN?=
 =?utf-8?B?SlFXZGJNMEg1YnRqcytmdHRLbzM4eFNvOUo2dG91c0pBcDZrOHZ6T0Z2cGxX?=
 =?utf-8?B?MGRSZXhURzJ0OGhsL2RveGFqRk5nQXA2QitrZFJqOXJ3blBNSEJRNG92endx?=
 =?utf-8?B?alZKQjBoTHVPNlMzRFJkRnVpcW1RWlcrUUpNbWNhM2NkVDZ6VjBkb3FRQjAy?=
 =?utf-8?B?MVNnQ0RoYk80UUhqazRDNWx2ZTBFS3VuVElsdVVRVlNoYjZ0Q0dVbDhOZFZ6?=
 =?utf-8?B?ZWFubUROeUoxTWc3VHpHMTNrMjF6SnAzWE9MSHNPamNnL3g3NDFpVU9MdjVP?=
 =?utf-8?B?cUt6OVpFR29lOUZ4RnM4b2QxNXhFOWlUSnVuWmhrSnFFdzIvWncrZGtXYi8z?=
 =?utf-8?B?Q05oTks1NXhJMGo5TkJBMFp6NER1b29nbXowdTMrSGtnZzViVGV5SExKM3Jh?=
 =?utf-8?B?UnJ3VHhvdzhCblAzcDFyTVBQcCtla3dYc09vY1hiSExjSUZLTUtVZDJsVk9q?=
 =?utf-8?B?YndCS05RSjFkeEVUdmpyY0l6VUNyQjRNUndvRkUycms0MXd6SUpUOWRhSWVJ?=
 =?utf-8?B?Mm5uZXZub0J1V3BqU3JNV0plY0VrUzlFSmE5ekx1ZVJsdjVSaFFSZkR3RkJ6?=
 =?utf-8?B?R0xuME5FNzQxd3A3RVRvMnF1a3FVRDgzcnN6UHAxUlcrNFRaSzZoVHo2d3Nw?=
 =?utf-8?B?UjFsT1AwTzh1aVJld0ZqbHFQZUVtMUpBQzlkbmZVeWpRSEpBMUU1L0duZU5i?=
 =?utf-8?B?cWpRdWt5UjMwKzFoNVJORGFxZ0dRSGUrUmRFcVM5TVMwbzhUZzZ3ck1lamFT?=
 =?utf-8?B?WTQvSytZV0x1emNMaXE5a3U0dmplUENqbUJtSzExSjhFMENEdGFjYXpOSUgy?=
 =?utf-8?B?Sml0a3lDcUJDSkdheUZ1RkhWMTJBMk1tdnNzTGFDbEhXR1luUDg1ZlhpeWVX?=
 =?utf-8?B?eFRjYVR2OWtxUlZMdm1OQWx0K1dkKzRrQnVkNGllcDVCOVR3aE9CM3I5SjRj?=
 =?utf-8?B?T2p2cStQdGhZdHdJRkttUVFldlNQQzhBbTdkMzBuV0R1TjZUa0N1L1NiMitN?=
 =?utf-8?B?enVxSm9MclFyYVE1cFBUWjE4a1dKV1Z6S2d2aDNyTThNOFl1WHV0d2pLZE1t?=
 =?utf-8?Q?BpqLrxdHqz7x6Qvdz4JwGsJ8X?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac2594bb-072e-400b-c0d2-08db5139e056
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2810.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:35:22.5425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTNNEtq4KhNmYNquGUpgy+I0ECu037LGOhZcuYbSOE70BZiUb6yiMYLQQmxWP76Yfg2VX6jy8d6qf2DhmDSPmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4295
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


>> Enable DebugSwap for a VMSA but only do so if CPUID Fn80000021_EAX[0]
>> ("NoNestedDataBp", "Processor ignores nested data breakpoints") is
>> supported by the SOC as otherwise a malicious SEV-ES guest can set up
>> data breakpoints on the #DB IDT entry/stack and cause an infinite loop.
> 
> You mean #DB => #BP here
Indeed its #DB. Was thinking something else.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
