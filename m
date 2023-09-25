Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930497ADB48
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 17:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjIYPXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 11:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjIYPXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 11:23:53 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02549C;
        Mon, 25 Sep 2023 08:23:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAzv208Fkb2r4SXkuN+HqyIqw5MDURpdlE5IK9FZ7rdfffTkZH6lZsNO+PfbD1o6JLreYBl8bVWdGjU0LXn8U0moSslJcOX3pqu136mmndrfmIP5zChCKvE996RAu0f+YrIFWc+ahXZlcGa2TeufjPV3qcNjp51fhuispkSVG70sFaCWAfpbtUdiekxsswuAIgz0bhoceMYUzkw9aVpIrJyDTyhdpADEA+X31GClIcMHxKjJ3z++5L7fHVoEFP0sXczN7GNN5pzRnhykVcZ20HjAxUhQOVC7TdQ2KZDA3JbjuXAgw27l/K7MDENMRdk/ovfTb9HJfpVRTdveHlu40A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jm+4hziJFwHwqmJx1+lk8AlDdnwBU/NiGDpVvPivYQ=;
 b=De4G7tXQNfY+3hKCO80c/bnu7Ee8GTkLMR7QhZ/idglOdQ58CxZT0Nncn5CY12zY9uvQ5E5ItcOzDJAyYfgZS2Wh80Md0cKomxugqAwEeE08RBT5HUq8O6fVNnGJmrJkmbEZQriONqFrYs0++DkoTaXoRXVyNQh6UqZ8kq1FdsdWKZ1Q8Et1KYEYR6GwcW33oc4ZWlHqpH6LVgVDte0aOpBUBc03sP3Zmw8wZ4g6emsmdnqfy2NKfwsYde0B0aOlo/HaROcSjzX0PDBPGF1uDDufHZPXIITFxGuRNUYIxvtwxLmh5H14NeWMxLZg+/WVh3MRzlsUqchMe7bds1C6hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jm+4hziJFwHwqmJx1+lk8AlDdnwBU/NiGDpVvPivYQ=;
 b=mpiDrDx4t1TO1ORk1Qos67FRcYoznhYqyKahPyu2OhFFSomfWa1iv0nU5oihLV81QQd1HMd1P0oc1FFjDjEVyA3FgKRTeNxu5ySkQldavqhuluxvUaY5dGetzdCSdPFOo3ZkpBhATGal1OnhrWpVX0nS0GIzHlP1d8Df/Ajfp7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by DS0PR12MB8561.namprd12.prod.outlook.com (2603:10b6:8:166::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Mon, 25 Sep
 2023 15:23:44 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::29d3:8fd9:55f0:aee9]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::29d3:8fd9:55f0:aee9%6]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 15:23:44 +0000
Message-ID: <e1fb2e84-4fd8-3c28-b3ac-519f5b9173ba@amd.com>
Date:   Mon, 25 Sep 2023 10:23:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/3] SEV-ES TSC_AUX virtualization fix and optimization
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
References: <20230922212453.1115016-1-pbonzini@redhat.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230922212453.1115016-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0042.namprd05.prod.outlook.com
 (2603:10b6:803:41::19) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:EE_|DS0PR12MB8561:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f88860d-6385-4cb0-b7c3-08dbbddb67f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRjXl6ZgcwVHosYBr7BUfMdbfsh+cg6vpIuFROVernUcWBkVtVTXDn+OL081mSOPMITXKK/BD00SVdFsZ4W8muWIxrsqvpFkQ7xtydRoMeAGsAwRjU4/mf/MEc6mHqPAJJPZOTgiF2mt2ztkNNF+AfNX7upDeubmpBHEqPLjID3nxJCuwd9kDf574eYX4CpuW2NrkBPQA1XoRv92huWOxeoGAZv8dyZmtcIbXblYulJxKtNBIur2U+VdAG+ybKf35Xvsocli9Cvxn0vOAAQKQxfLsYfuZTDDp9oH/9xuk5eiGePn25MZPpzx5Yt6xRExMH8ParTTAeWyb0BMO599Ob1v2si70FsR3WnYIQk94ptxzAVtxEPkhpx028PK+6Qz/jAY5j8R96by2VAV3LHkQth60+9/HHAcKGOh/rqNEjCZIAPt9v/3a63W1sg3CBHeEVjuojVqWy1tkC1It5Yn8AKpcbX4rK2gpFpBV0Kw6+f+DiTQZvWRkn2qR9rgG12FD8AAVp0BSjP4Mk6RMNJyf8EhbqPXYtnDSUVz3UIn8K7tLejljR0pDyZCxkSCLbMyCshgxU/ExZPe+PkPfmNU9QKSxEIGRxpbZrCLOmIDNexCu5+MPVwtp+u3JO3COE86ZJ1Xk5PAXdRBI9ZwDqgVkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(39860400002)(376002)(366004)(230922051799003)(451199024)(1800799009)(186009)(2616005)(6486002)(6506007)(53546011)(4326008)(5660300002)(8676002)(2906002)(66946007)(26005)(478600001)(4744005)(66476007)(316002)(66556008)(54906003)(6916009)(8936002)(41300700001)(36756003)(6512007)(31696002)(86362001)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZCtPUXc0d0doZHVGQTJuVll5OGJScFNhVUh1NnZvT0kyTk9Rai85M21vSUJ6?=
 =?utf-8?B?a1AzTjlQbVdXR0VWeWFRV08xUkhXWHA3VW5FYlhGemlUSkwxQkxzNlZFNi91?=
 =?utf-8?B?OWVFOER2QzFNbkQ2ekk1THREbnR0QUFkU1JNQ2RCVHY4Wlh4TXJScXpEY1FM?=
 =?utf-8?B?U3BaRndPL3pZY25laXpTdnJHTVh3TVFidHZLUmdGL3RQQmM3SWprSFQyRWJp?=
 =?utf-8?B?aU9NNUJGRzdXZHJwbVhkYXdBb0JIUGNna3FSYk0rM0dMMVgxU3VQeHpMZlpx?=
 =?utf-8?B?Wi9xR3krT1RHVDRXMEJDWGFKV3pBd09IK1FmVDNDKy9iMFk3NDVSVXJlenBr?=
 =?utf-8?B?K0JEc3NvR1d5c0xZRUptY0hUaFUzM2d1NmhQZ09XNEpxRnY1K2ZJdjV5cEpS?=
 =?utf-8?B?Y21Fa21TNmZGa2M1WTRWREdxMHJYN2phNFZJWVQwVHcrd1lrUjQyMGZIVWxh?=
 =?utf-8?B?WjZkSVlJWUhOWWhwMkNwS25YQno1WExzc2FXTmw4dDZTQzR3Nmx4UnppaGxv?=
 =?utf-8?B?WEFVKzlwc1M0ZzJaM1pqSkdGWFhkOVNObjh0NkZXaHN4SGN4OE85WlFHWWFM?=
 =?utf-8?B?TUtDT1JFWjcrL2lEZUFOUWdLaXQ2ZWd3K2cwMEFTM3hTOURMeVp1RWozcGNL?=
 =?utf-8?B?Y2NCby9ZUjJhcW1meHpmQlh5SVkveVE4VHhpTGZoM3ZJYUx1QWlCcUlLeDRI?=
 =?utf-8?B?TWEwTlpnVnNFcnY0RHpMeGk5UHFiRjNJRkVDNHNUL2Y2QUVpdGpqM3cxbTR3?=
 =?utf-8?B?cUdoNVlXSUtNVXRKRWplZGxOTEJKbjJBU0NnaklCcXFuMjVHU0FlYldwdTc1?=
 =?utf-8?B?L1ZLZWFMWEROTFdJWW5xQ2crZ2h5cUNlTFlwZEkzaE1zWjRTeFdqWFhnL0oy?=
 =?utf-8?B?M0FLZmJQcyt5VFpiZWJVVDNtTjhsK0tKczlJalZRaXNpcEhXRTJnTUU4VG5K?=
 =?utf-8?B?RHJBMGFhWlBSMGE2Yi8yaXBRREloeTg2UVpyQk80cVdOeEJ1L1pZYUYzL0JY?=
 =?utf-8?B?WWVHMnZ5ejNCSjZ1M1p2QkRpelF5NSs2K3dFdFhjWUJrenY4WjhHb05NZDlM?=
 =?utf-8?B?czMyanc5Y0cyV0RJUGQvS3dmNGN2QnM1eEg0OTQ3YmJGa3VnaFpINWxDb21o?=
 =?utf-8?B?ZWlVZzBlZkFWTVMwc1VWYXJqS0V3a2R2UzdDVVliZVpRNkdpNVljSDBvaUJS?=
 =?utf-8?B?aG9VTWFxbUxsS0M1bFlNQno0bHJBVWRseWFZR0NZWmprY2Nhd3NqMzFyazhL?=
 =?utf-8?B?dEJqUkhUbmdOMXhlTmZ3UWZSOU9Vd0tEMGtHeTdsNkVPV25INjFIVldKTlVP?=
 =?utf-8?B?UTk1MmlNQXlHME01NlFSV1VpdWV1c0RpQkF5TmJSZ2VmTGZGZVZnSml6ZVJQ?=
 =?utf-8?B?Y1lxcVg1RjZoODNtd0c5SUk0KzNJR2h0K01rYmcrbXlmTDNHbi93c1BGK3dn?=
 =?utf-8?B?Q3hZbTkzdW83TU90dG1sYmlOWXUxK20zQW5ZU2QrRE9NL3dBOUVTK2hPcXBw?=
 =?utf-8?B?VjJvZ1UvVjFobjYyd0l2WE9aSjVKK0dNWS8xenErY3FVN2FUYUNGRU42UVBt?=
 =?utf-8?B?TGFkenNLbTBQV0J0Q3pZbjZuWTNxWFN0WEc5K0tKUjc5ekU2SmFVSzF5Zzly?=
 =?utf-8?B?KzdjdHhKd1loUVJmT2hmL05Nd2pjR0c2aG1yRjcxT3RmZUZRTGRiMS9keEhO?=
 =?utf-8?B?di9VQVFCSHBmTHkxL3JFTnMrMitWbWNZZ1NueC9SQTh3STNJaEt4ZnQreXFt?=
 =?utf-8?B?SmVvS1hLcGJ5aW9KMzlLM1RtYzh3UzBwaGNJMG82OGtyM01yam9WeGhBb0tG?=
 =?utf-8?B?b0JoOGR4QVBGalMyVnVmeG5FclpwWitPNDNTQ0Z1VS9tNTdFbDc5SWxWTm9Q?=
 =?utf-8?B?TWh1Y1E3bXVZY3ZTMEdwQUJGeDdpcnFVcUlJaDQxOXN5bXNSQSsrenhnWjBq?=
 =?utf-8?B?S25udFphcGNZcnBKWHF6MmhoZnZiQnBQVjlLbU0zSllIMWdGRGhiTklqcW53?=
 =?utf-8?B?U2FJSmV5ZWlJMXNBbGVERUlUbWphK2Z5ZXdad2FTTjZhZXpSOTJJS1RFZVJE?=
 =?utf-8?B?SGVBVFVNbmdZNy95cjBDWTFKMGxUbGtPZTkxbUJ3VnhaekFqNnowdTBKc1cv?=
 =?utf-8?Q?AIffKTlntlF5sJSFU3WpKUvbf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f88860d-6385-4cb0-b7c3-08dbbddb67f5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2023 15:23:44.4125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K9xpkZDz8QY6SDcJV5ahvRr8cEfyacvkVYk3wWlj7IOjguF3i+ACYlInDxugF4feUtVH1pZA7CVfIItNocn8nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8561
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/23 16:24, Paolo Bonzini wrote:
> Queued, thanks.  The part that stood out in patch 2 is the removal of
> svm_clr_intercept(), which also applies when the initialization is done
> in the wrong place.  Either way, svm_clr_intercept() is always going
> to be called by svm_recalc_instruction_intercepts() if guest has the
> RDTSC bit in its CPUID.
> 
> So I extracted that into a separate patch and squashed the rest of
> patch 2 into patch 1.

Works for me. Thanks, Paolo!

> 
> Paolo
> 
> 
