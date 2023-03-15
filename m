Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6346BA679
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 06:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjCOFGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 01:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCOFGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 01:06:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EB511176;
        Tue, 14 Mar 2023 22:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9Nytmbu2yGB/U80h3mnNoyT7GckIVFxszplFmOt+qG2MlTy+A8a5hKjk1pA4BVu6unlo4BvsQey2Cz7TY00u4fshpUpOiTT9oR+Y0Cz25SUhQf2QRmiqcou3uxlD+AdJHsO4TltPRFvfOzo5wqwImx6+27P8NgOPxMqKLFLcR0E0+CqMyD5J3MA1mZx+w+VHkPJFfzNBQR8t7ZSAoPhA0VFVPJwYIPzqQ1Bbqx7WwaB8VZ0dxkvwJCaKFEOPVZZrXI1KW9rAyGOHBKcGAf+EBLmle6he3h/k5e8N61vU2FQr66xxOLNx9HJs6sY1kLNDQ2MdsIn3Mt7gZqA/InkAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6g46H+QqGDxOf4bnECMo38C4vDqn48y+lK+PQtUroU=;
 b=WmXzb99HFtzUaxLxHT7ebB3vagYhJIP2/qixhYEIRzGHo1PweWXFUq3aofVy0AC0kO1etctYXSqNOXpbio1fac2zvyW4TR3h9O0Et0gDj4Z+qhwxsDyUbMzPIIQoiOOS5IPBwRpW7jBMcxBwOybGjqQgpHdAU8JplkjTEho/LTBL0KaZO7iZCKRWaUIWLB0muaj/8hWgfV5YMHtaACyz5XkFj5AKmM7bumNdFmF1tDXpB03gx/XubdEvY1zSv2L8K6E5UOb/PXKUcE+Bn43jzejySbDy35R9WXNxPSj0O8y4OkRVS9KlEqMHNmyDcgu4PABgWGKCh17PPra+Igm2GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6g46H+QqGDxOf4bnECMo38C4vDqn48y+lK+PQtUroU=;
 b=2Mq1Z/Hss3IULfhXl5LL4rDTgQkrlwVl7sQh/ZSKGMXnFvHqJYHQ1dnON2CQWbw33pw9zqW4moRL7dVRFbVlo5o0RApYV8EsEo07GblR/pzMSdbTiSXrHdEWgQ3pMp3RM1ZqpVPSzwPFFXNYxrSI8pD5JZUVb8QZoHDdD5lHC3Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB4120.namprd12.prod.outlook.com (2603:10b6:610:7b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Wed, 15 Mar 2023 05:06:10 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6c34:2aaf:bf7:c349]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6c34:2aaf:bf7:c349%5]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 05:06:10 +0000
Message-ID: <1b6740e6-677a-fbad-e7ed-a9cf89badfec@amd.com>
Date:   Wed, 15 Mar 2023 10:35:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH kernel 2/2] KVM: SEV: PreventHostIBS enablement for
 SEV-ES and SNP guest
To:     Manali Shukla <manali.shukla@amd.com>, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jpoimboe@kernel.org,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        sandipan.das@amd.com, jmattson@google.com, thomas.lendacky@amd.com,
        ravi.bangoria@amd.com, eranian@google.com, irogers@google.com,
        kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org
References: <20230206060545.628502-1-manali.shukla@amd.com>
 <20230206060545.628502-3-manali.shukla@amd.com>
Content-Language: en-US
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230206060545.628502-3-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0122.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::7) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB4120:EE_
X-MS-Office365-Filtering-Correlation-Id: a6baf065-166b-4396-f446-08db2512fda7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43909T0PlIRU94f0ekO7YGmsP4O9wl2Oz1MzQnxRyERjyTm+EO9zO60nfbbdz4V5cAlrcf1IMyTaZxiz6sPmK1G0lkxhUWLbkdfk9j5HMzZhmmrkKjwZAaYOxSfhObl6Qyl7YhHz0moDklbNgbJMliXP8qdF1N/pdEx3znyWwH5sXGvUuIa3CY2GgECZKq+R+I/Of9kx55JBO1sOYe4+sgfPOg0DQF4mZ5ky0hRFxV6+ewzXONPrQsljgf9lXSldB3mcKclT5d/aqsWVpPJ2C/CN2gHHU1XQyo9L7SPVRh54imw7aGDsdSX+286M1T/HbbkjP7/b3phO7S3VYQWmAtl15XZO856PmKH9X0NZQUWmLvVHqaSwhc7yL6M1VWyii7EwbWGlCyz3KTXrrRcyrL3lGzYmjWLodu7bFQz6xTfBGGzwXs00xVLeTfFV7manqQuVPrfLsPffJuccXdB7G0YxVRKkjRE0trcfFxErClozrKCU0EfrWBWmzvNrxRzeY5qPuKupVLjTNtK1N69degHi1TAvka0NblTCBpiyyfMvQCBeDNzIAE0djPxMMLeKx/+v3/TMVJ/uVdPKlMaVkXQSCnOFL7zsYGUvrCnaAJtu38AfbUCXvQYAO6yM4wA18FP75DlK+NYzMjYIUr2hsEj6LS0LJ4gfAVK7P9SmkIm7ZjJEuqlwCUhkG9wFyGNXCth/PMCC+Ft+aatQYmCo4H/bC6D5kjHcWUvFz1Krq7I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199018)(31686004)(41300700001)(7416002)(4744005)(8936002)(5660300002)(2906002)(31696002)(38100700002)(36756003)(478600001)(66556008)(8676002)(6486002)(66476007)(6666004)(66946007)(4326008)(83380400001)(316002)(2616005)(53546011)(26005)(186003)(6512007)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXN1TjNaQXNUUWs3d2NxQU5QK2dIQmNPNE9lcDB2eGVMUE5yVVlqVElHZmN4?=
 =?utf-8?B?WlRWQmtIU09kWlNlTXFXaVRqdWE0amwxV01PdnZaUVRwTjhnZ3hackVzT2tk?=
 =?utf-8?B?cXZDZlFtcy9nTTQ4NmdlQUdQdG9RZVRFeTNrTG5SN1dvaW1HUTdYV1dUNEcv?=
 =?utf-8?B?eHlOeXRoQ3piUVFKdzM5VDJkVXY3eW5HTXdBTGtHbEZJNjVNd0MyT1FXdHAx?=
 =?utf-8?B?K214Q05QYmpIbndEWmlPTnpqM0JGZGpna09nUkFNQmtUczlJcjY5Z2d0UDYx?=
 =?utf-8?B?WlZNQ0d0SWZUanBvMzl3T1NVQXF4SUtPZjJBeXZFSnpvT3RpUVpxcUdvc1hC?=
 =?utf-8?B?Kzd5UEZ6K2dGZEpQNlUvQ1ZxZHp2bGFlMEh3TXNabDAzU1gwdmJHMVRJL2hH?=
 =?utf-8?B?ZzVxSjdkYzA0QW5NaitoVFdWeVlkMU5kM2tZbENRa0Q2bC9ZS1ZXNitZVTJu?=
 =?utf-8?B?WmNIT1pndmRXekFBYStqYWNxdnZYRHp3OXo4eHVqa3ZtdkZpdTZLbUk2ck5U?=
 =?utf-8?B?Y3Y4QmF2V01tN2xqNGs3WHE0WVhUZHUvS0prc0VPZzZPTS9MdmVsM25KQVQx?=
 =?utf-8?B?VzI5bjBHVGxoSFprRmdyWEJSS2gyRm0xdTNCdVNOV2Zpb0xjS0QybFozYXhB?=
 =?utf-8?B?aENMZGhsT0pGMGV3RkFpYW16THEzYjJnb3dsYnYxTmZPYTEwR3I2azZFVDNY?=
 =?utf-8?B?aHVoanBzTWdPSmt6RXNqUUZwS0s2aElob0dLdWIwQ2hBVy9aWUQ1VHNqdFNX?=
 =?utf-8?B?L2p4TkhUU1c3c0VoSWsvU2piSUxYUW9LWlIrYTNtV3NRV2pWVE1HbnlKWWRE?=
 =?utf-8?B?TG12MFhzY0toNDRVQktKSVdROXhjYy9maTM3TVJWbSsrYlQxNlBJUjNnUUcz?=
 =?utf-8?B?ajNPU2dQNjJWZ1IvL08wK0dCdVF1NHlZdFVVQ0dkTVUzdC9xTTd3c3dvbUlz?=
 =?utf-8?B?V2JkMkNudzNaQlo1VS9KcXIyU05iMTRid0tyWEk0NjQ1cGw0RnlkbGFzaVUr?=
 =?utf-8?B?ZlVmUFEvelpvbEt2QlZCeE5vRUZ6OTQweWtmTXkxZVFFWWlXalF1MTdqbXJP?=
 =?utf-8?B?OXRhbnhPZmxxR3FHZHJlMUtTZGRzU0Z5Nm4rMHhrK1BhT09CUEpTUVhQTTVu?=
 =?utf-8?B?b2xvUDZFSmIxQVlWdWZSRXFDM0d2YllFSGMwRjlONmp1NzRwMitqQ2hIQ0tR?=
 =?utf-8?B?ZDYxbTJOaExkYTMzVmVwSW1oZUpEV1hiRlZFNXlKY1Q2dlhteTgzVWxPNnA2?=
 =?utf-8?B?a0NhOUJ5TnFSTDQvYm94VUFTM0thTVgzdmM4c1dOSWNBRWpqQVRQL0xkSFRB?=
 =?utf-8?B?ZUJLdnJEOCtVOVBMQUxLdDBSdDVqVzNIanA2bDBMYWFuUUdFNE1CQ3c0MnRw?=
 =?utf-8?B?ZllGem52NjlhK1ZPS1pIeExVeE9Nbk04M0w5SkxoZHdZd0l4Rmp1ZzY1OFhY?=
 =?utf-8?B?TElnS2pKUFdyeWw1WndVdVF1T3FBK0FXRmJsMCs1V05Ub0N3ckpyRnZMRWdD?=
 =?utf-8?B?NDF4bHgzWlFka3Y2U2JnNzBXZGtCT0VsUnU1RTUxYWVpQis1UVcxTHBlU0pq?=
 =?utf-8?B?RGRQSFFGYmZqS2tvanlhZUMyRGVZU1N3VkpvblpqWnR0eUdnaTcrRTFaRWty?=
 =?utf-8?B?WFpZSXBoQmpybTVlYW10VjlJODVHeTc0L0lmK2RVUmhGeG5teE5KcHl5MUZW?=
 =?utf-8?B?cGlIT0lUSTJ1amsxcDloemVkUTMramtIeS9HS3Awdkhvci9wTFRYWHUwOCtC?=
 =?utf-8?B?SlpCL0VKaTRKMHRCaG9vdXVPdjhrZU1mWWVYc2VLbS8zSXVQemdaWHEva0Yx?=
 =?utf-8?B?OWpDNS9SbTNodWF0dy9RMlp0V2poMnROQ3ZFWjRTcDdFZVR3azF6M0JxSTU2?=
 =?utf-8?B?VzF5a2tOVHU5NzNHcGp5c0tmTzhBYWVnNGljekt0QVgrckFUUTFqMTlROWY2?=
 =?utf-8?B?cFVUOHI2Um85N3pyN1dyc29ybDZLMytRcUtZUWN1YXk5dnNwR0I2V3FhZktS?=
 =?utf-8?B?M2tNL2Y1elNRUkhONWJTV1ZFdGNwdE1FL0ZTVEs2TjhkZnprSHFxNnhlMG0x?=
 =?utf-8?B?M2RoZjlNTDYrazFNOTlIbU8wdkUxaGNYUWIyS0cxc0JYK3R1YjdXSEJFWVlG?=
 =?utf-8?Q?4wid3qqFGxNtxC4zo2bcJIhep?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6baf065-166b-4396-f446-08db2512fda7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 05:06:10.2911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +DH9K4r4oNxnc3SxdlxrTvpx5kgoPd6TggAe8Aec90fGYQKgKjYQGXxyyvyp9V6XEQ/8Qxq+krHDXI5vZppz6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4120
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/02/23 11:35, Manali Shukla wrote:
> Currently, the hypervisor is able to inspect instruction based samples
> from a guest and gather execution information. SEV-ES and SNP guests
> can disallow the use of instruction based sampling by hypervisor by
> enabling the PreventHostIBS feature for the guest.  (More information
> in Section 15.36.17 APM Volume 2)
> 
> The MSR_AMD64_IBSFETCHCTL[IbsFetchEn] and MSR_AMD64_IBSOPCTL[IbsOpEn]
> bits need to be disabled before VMRUN is called when PreventHostIBS
> feature is enabled. If either of these bits are not 0, VMRUN will fail
> with VMEXIT_INVALID error code.
> 
> Because of an IBS race condition when disabling IBS, KVM needs to
> indicate when it is in a PreventHostIBS window. Activate the window
> based on whether IBS is currently active or inactive.
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>

Looks good.

Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
