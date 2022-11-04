Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D28619EF3
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 18:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiKDRjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 13:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiKDRjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 13:39:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6C0B842;
        Fri,  4 Nov 2022 10:39:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQu0AA6DDhyg3rOtEH76GsHZK2xt8n322B9qEwfaU/DdaPP0+4Xym2DGnIWuag9KN46wxtcT176C7Dq/+7n2qjmuc4faOC8Qebf87BTm9/vEHH2Wb0J6rhUuACHsi4QFb1nLP7cDp0yUIIv/0k3aj0ZPOF5SidYqkYJrXaxybQFpRHaF4/HBGUgvmuTI466obHsLmQKN5bQ93KyEPdqvpDtHdYETY8OSYp9krn5O5JNvVWWDpk/4iEyMmdNrcXVqyvuov0hei9JaHq/fgVxmuqDaoBuMlM3TXuMmK8QivsB7Cz9bWVboVwNBoVBjOSTMZXTZOYC6PVUasL3E29sExA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7y4YD8udR2ZKSnCv21Hto/3MaepryS/R+Ke1hx7Wi8=;
 b=kjoJiXNUHK0v3Kt4T0PIRmjgvB84nJzovMLYVGznLroAl+jo7F+m3X5IfDwpYq96e94+8bcAQZTZXs7ehKrjPLPiUfjw8jGT8Fjhw0TqHEoZWcu6NgnNem5WfaUQECjm42PMgcPTahg3Bl4Vm6Yei3lqPm4/Tac4++fs5qP5VYFf5QEgSzTw4nbpV0j+Rjm/I8Md3u+XddHl5NFJBPLpX3Bw0DN7PaqwWfvgjHf1u1APOklS0gH2pbTLbcyDAtiABF6KOXj9WxDyl3sJYHrNQEH0j7rphT+u66GpkXU3pW0PctCJyWfiM/xpV4txhUoAGFkLvTUK+HblKm522sNzGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7y4YD8udR2ZKSnCv21Hto/3MaepryS/R+Ke1hx7Wi8=;
 b=HCZI+twFhlhWhNj+yYMxVKuCTDS09lGs6/B6LC0VCxMZFpjtqKo20s1a3+ENFZJKQWD4KvEOoossVfl4v2nZOswQZOJUjcuUYdBhJehMj9FUDIlt8uUcNOb1A8Bqn2ySCXV0Y3NTmCqc4yDpOE7QW0lVDUg6EZlYBcvA7HY2DoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 17:39:09 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 17:39:09 +0000
Message-ID: <c79eeb20-98c1-824c-9572-1474aa12a0f8@amd.com>
Date:   Fri, 4 Nov 2022 12:39:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH V4] virt: sev: Prevent IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221103152318.88354-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221103152318.88354-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:806:21::32) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ1PR12MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: 32da53d3-b91d-47e5-4092-08dabe8b7a93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /am30YGtwqNw/ZirJVP2d7ttvGnMoHRQk7z5cEgtsqBEXfFCWDLI9utWRO/z8ciEgUMZf9HYkoCfoYubCwHajEhKju7lg9s4SO2ANyPrOu3hOCSpAD9klzekrSEGXf1MXqLbj2QL6xuSnx1+UfaugJixyyq4JQd26eMON4k6UKtQp0UCXWIvBOiuZs7k8LyaJ1Kpn7/SKQqN+VJPPab+0K6eQzKOubkxpOAd355NQRMUdcsR/PDIvN2vqSd/G+TkAIL4GTct1mvOpziSzaNjuihjIgSHkOP0+Wx4m2EqEFT+M2ymXoGYKJ+87YKIaEDHxHHcYT3IOeoYjG2IUIpup73t4J3oSBBXhD/ETxllBwxcGty6FrERiJ7cJmkdQth0/P46EaArJv7Abwr6F08D6PUFWjmMXhCHz+/AFHPUdROJbqhsY5oN/32mz8T0K+r3zM0cIVnLQ5O/W7MdOptALLOkpJKlWryIrtMw4CtiWPMNJrYH57d1TinzlKvt0ovHdnY+W5tjIQ5v4yQXIOH0GSvLYhSmVWnIEz4a3VDmZGA987NsMJ/HRG2zfNQSATn9K9g/+zAUZa9G3etyBWvaMbevtl6iA5qMIaIssqOWeM3sEvpRW4mwmZBCOYH23753N7vsQWfHmdhjDIouoKPNLSznAds3PVGH8kv7m1U6TA8u6zXr0Jhyq65yOYz8lviv8/7dtqR3SFYimkiPG+2lMhfvZWZ0x5FtV9i1N+wAGTOmgcchHsKdwO7cs6FerczjkZ7anw9f/SPi+cI+0PyuzsxHx9wTbRBDq11tqmQ4gnKQdwkDlmAVQSm2be3Mu3Hsn26rvTWunnggS+egumPBNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2616005)(186003)(36756003)(8676002)(4326008)(2906002)(66476007)(66556008)(66946007)(86362001)(966005)(6486002)(6512007)(26005)(478600001)(31696002)(6916009)(316002)(54906003)(8936002)(53546011)(5660300002)(6506007)(41300700001)(31686004)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVYvWURjemZtNVIySVlIUTlmdHkxM1h2VnpqTEYyOG9QWklpMS9ieW1GcERN?=
 =?utf-8?B?YTJibmVFNTluUXc0Qm9sNWxXa3ViMENlV2hNMUY1ZnFqNTNmUE1BbEM1M01l?=
 =?utf-8?B?ejRrUE9sNWRIR3Y0anU4dkdaeEE2WXAybXVjRHZZa2hzVUoyRExldjZmVkVJ?=
 =?utf-8?B?RHl4azV4cTJUbmVwUGYzUTBGbzhoU2lrOTdubk5oRHlBZnE4NzU1U2FRNE4r?=
 =?utf-8?B?OGlsR2hwVmlMbzllTUw5NG9YcnlycFBFVWEvdGFMZ2hXcWxRditHa0trb3Jv?=
 =?utf-8?B?Q0xtdldOd2hEWHdobEVjUmw0SnZCRTVhWU0vOGNRK0MzKzNIOUFYTjQrM1pD?=
 =?utf-8?B?Zy9WeUxnQnRqSjB2NjJ3My9GNU5pOXAxTENrMWszU2JZZ3BzeU1sQndJcW84?=
 =?utf-8?B?aXZMdkc4SGtIZjZCSjI4dkQ3L2pjdC92c1Q3MDlqbE5ORWs4ZGo2Mk9LU3Ev?=
 =?utf-8?B?eGdMcFg1NTZYVzNKTTNKcVZZSVRBMWM4ZjRXQVc4c3AwUGdqcFhaakdpYmdj?=
 =?utf-8?B?Y051VDE2MytVMWxhK0RQVnhERUYrbDNHUTB0ZnlkNUx4TTJFdVJ4UUlPNGM1?=
 =?utf-8?B?ZVNoay94VnZsQ05hYXdJK1F6K1lMVHpzcXJBSjhCTFoyTENWL1dtOE9mS0J6?=
 =?utf-8?B?clRjWnJKaENFMXVFTmdXWGhBcitaZ0RKM2czSlpFWlMrbEtKZ1FRa3RnQTJJ?=
 =?utf-8?B?UzdMWjJ3anlvLzljV2FrQUFvckk2RHROcFJCdjJvcE1YWDYrTEJqbm45ZzVN?=
 =?utf-8?B?SElqVHNEWjYyN3ZpYkg3c3NDU1YzYk1jd0xxUEcrRGJmei9OZkJwMU9VeVow?=
 =?utf-8?B?MjA1dXJVSmdNOWxZTWkrZVN1N1hXQ2IrRUNWd2RSaS9Ub1ZENTJOVSsrWEFE?=
 =?utf-8?B?L21mUC82bTZhNzJ1QjBUM2JFV0JqRHptWnJKbTl3OUdvaHV0UEVkazZNSU9C?=
 =?utf-8?B?aEh2UGJ5VUNzcHhnVTBIWU95Zlh5NjVvTVNzcUw0akdyc3gwZm51RDRVR1o3?=
 =?utf-8?B?dUF0SzR4bk1lZldRcENJZ2FQZmpQN3A2THVBTjhHU2QzTVEyWGs1Z2ZhQVNH?=
 =?utf-8?B?anJBa1c5Q2oyT2UwZ1RQd2tUalRJS0hVZVgxYllvdUJ0VHJObnE4ZG8wWXNL?=
 =?utf-8?B?dnBjL2doZG9IcUd0T0pQd0RnVTJPZHI5WXhsM2JrOVFwK2hqeFlWbDU4U1I4?=
 =?utf-8?B?dEtkaWQ1WjBOTHdEc04xUlY2L1ROQkZsZUFzQnRRbS9RUHFCQzFBdG1VMzNO?=
 =?utf-8?B?VzA4VVVaWmxuVWpjcEZmeVNIbjBZdERlaU5xSkswbHJrYkZzaDh3WFIvSTVU?=
 =?utf-8?B?dG0vWWVrMmlxeXNRMXFPeDRhRmRpNG05NktlV0ZOZTZRR2NlYW1oS1h0T1FT?=
 =?utf-8?B?UEN5YzdnVXpDcWRTOWdPdmdLV2FSVG1vdm10NjNRQ3lzM2tqMHhSWDJwWGxl?=
 =?utf-8?B?dXhrN3lhQjhTSFl2Y203alVnY1NoMjFkWWF6MHEyRmpXeHRUZ1ZJQWJ5eEVn?=
 =?utf-8?B?NDM1blY2RFU1dVlqdGttaFJQYzh4N2ZvUVgrVDUxUFlMeHNubXBwa3lCd2J2?=
 =?utf-8?B?Vy8vMW0vekdJL2FFcWEyTkpMUHB0U2NySTRtSHZnOGlzeXNQOHdwQURyd3Ux?=
 =?utf-8?B?NUgrVFQxcmJOVmNEQkt6c0I2N1BZQVpXSjhNUnA5NVVKYVZ0OWxZMDRpTktD?=
 =?utf-8?B?dXFINmEwYXBxQlUxY2k2Uml6VXVGcG5MVWtZc3lqNEluTHF2bnpvWnhJV3JI?=
 =?utf-8?B?TENTNWQ4R05KdXg3eVZQbVU4OU0wRlZHUWdlNXVlZlhXSTJSS3QzT1M5ZXNO?=
 =?utf-8?B?QnpoNjZqYTlOcEZudEV5Mm5iWmNJR0pKWmFPYklJaUpRa0pJelRTY3daK2wx?=
 =?utf-8?B?b09zWTArTjlMMU1rN0QxekpLazBCUWVyU2tJT3E0UCszODBuT2JkK0tsNzdy?=
 =?utf-8?B?R3RiVlE1ek5lU1NuUWxoTG5mY0pKNmhXRXdZd0JJZzlUOUQwU2JucmVCeVhv?=
 =?utf-8?B?WUFjbVFKRnFSSzgrdmFBMFZ0Mk5pRGZPU05QOWp6bkdtUjZpamtzSzZrZjUv?=
 =?utf-8?B?Z3Q1K0tqZ3M0NFFUWVFiZVNsL3NJR0ZjemsxYWhzSWRCNDREZlZuc0JUYUhS?=
 =?utf-8?Q?2EZXBaOWTOGd3zNUnSCWgKWMO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32da53d3-b91d-47e5-4092-08dabe8b7a93
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 17:39:09.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9N+5ojVwJ4IZKuEleAyD/KooE4FgkO8QOH2Ql78AbbYoX+rr6Avi1G+dnpXNX8wPPmI3Feg3sS23fqnDId8Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6217
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 10:23, Peter Gonda wrote:
> The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> communicate securely with each other. The IV to this scheme is a
> sequence number that both the ASP and the guest track. Currently this
> sequence number in a guest request must exactly match the sequence
> number tracked by the ASP. This means that if the guest sees an error
> from the host during a request it can only retry that exact request or
> disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> reuse see:
> https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
> 
> To handle userspace querying the cert_data length handle_guest_request()
> now: saves the number of pages required by the host, retries the request
> without requesting the extended data, then returns the number of pages
> required.
> 
> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reported-by: Peter Gonda <pgonda@google.com>
> Cc: Dionna Glaze <dionnaglaze@google.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Haowen Bai <baihaowen@meizu.com>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> Tested by placing each of the guest requests: attestation quote,
> extended attestation quote, and get key. Then tested the extended
> attestation quote certificate length querying.
> 
> V4
>   * As suggested by Dionna moved the extended request retry logic into
>     the driver.
>   * Due to big change in patch dropped any reviewed-by tags.
> 
> ---
