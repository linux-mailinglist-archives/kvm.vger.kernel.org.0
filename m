Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7527843BBD7
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 22:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239303AbhJZUv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 16:51:26 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:31457
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235817AbhJZUvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 16:51:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frvtx1stFqkwrYuyQewY0vaoWQU12G+7S+hjRGD+1s0uv3J4W0qi3b9vSuCnYWx9R4la7W+UNorHfowBYJloIOKH0AI5OLrv4VxKAxU1USQWE4rxd/wjXUYEs/24rlrRgGMQnbVIYAT2xqbrGx0dqyHXDtvjrsyclCzUnnUrQ5dAX126ahjLYkBWH2VwM5ud4naOjOWOXO1cxKIKQhKcwqJMdPYUU84hPlq42mJ0OxTnWARRRds458V8rGeQ+OqsY9PsajLqdO67fVqd9DsFPtEtNlpqEdMgNpKbwVLJXCZCvaT1Y3sD9jv2yMzh6WTtih1vibI0n2vUQvsKAaml5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yU1MdBXrNsUgMI/mdBRPJSRktI4Cmctb2pT9bxUG6NE=;
 b=G2CSgOlj0EuXJJ8CHy3wcufqE0FSMoQgVdCurrRhE936vQvWmXUIF45BoA8zD/RFNxKtKN7zmOysHTcVzsZeXh4yR0xc4BZ7SZulHusaoJmgCnoFhSCwmh/loQlyizs6WDE1DPW+HSimBXwU1SiFuj7P8ZbauaQfhgIJvbBkGituAKMKCGIA8Tzc20Zp39wHHri3qitcMcbDtU0DZQaMF8z/ZlI/cd50Hu+PWTbnje67bi6GzG/tRu5SqCz6g2crAhBsZDIWQM900GrFcOt5JE/cEQJgCnR8b8PS0jcDK7elYAOTsbIuI6ksGGFuA+yEjdCUeedP3MLeikE5qE145A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yU1MdBXrNsUgMI/mdBRPJSRktI4Cmctb2pT9bxUG6NE=;
 b=caxxGs96CsWH7CxYkq5w+1zPCKXGp24/pB+d6bYZ7eE+xUlCCZFrv5jnWXwvnJU2qvX9T3miTZ1kby5S3zdNrnQaJbYacoDQAVMly3wPfck+QloHE7bdjbBMRd61Iax6pLxX4jRB64uWD2aCxHpRCon7bb/ttckLNUyPMYJ96uU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 20:48:58 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::a542:dd6d:9511:38d9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::a542:dd6d:9511:38d9%6]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 20:48:58 +0000
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
To:     Borislav Petkov <bp@alien8.de>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@linux.ibm.com" <tobin@linux.ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
References: <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server> <YUnjEU+1icuihmbR@google.com>
 <YUnxa2gy4DzEI2uY@zn.tnic> <YUoDJxfNZgNjY8zh@google.com>
 <YUr5gCgNe7tT0U/+@zn.tnic> <20210922121008.GA18744@ashkalra_ubuntu_server>
 <YUs1ejsDB4W4wKGF@zn.tnic>
 <CABayD+eFeu1mWG-UGXC0QZuYu68B9wJNWJhjUo=HHgc_jsfBag@mail.gmail.com>
 <2213EC9B-E3EC-4F23-BC1A-B11DF6288EE3@amd.com> <YVRRsEgjID4CbbRS@zn.tnic>
From:   Ashish Kalra <ashkalra@amd.com>
Message-ID: <bb98ca70-9bdb-553a-17bc-43b68b57ac55@amd.com>
Date:   Tue, 26 Oct 2021 20:48:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YVRRsEgjID4CbbRS@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: BL1PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:208:256::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
Received: from [10.236.31.125] (165.204.77.1) by BL1PR13CA0021.namprd13.prod.outlook.com (2603:10b6:208:256::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Tue, 26 Oct 2021 20:48:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86072a17-0b5f-4dca-e55f-08d998c2085d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2767D977D11725310FD2106F8E849@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K5Zvt/hxRu6Fg7hThN1CVTR5jwk0xDb5ibA4SQP8xaYDaAwPyouv3x2QuUzrfueKoBKlM7z8Szl1SSn7LCptbdL8VH98JLNtZ45B+ZB/FUEe+t+kIJPrCVz8bnKIPaSC91HlEERkzQpoIolVaZRZPUFo7qI69YZh8UbO7ZHlKjjiuOvNj0TqdY8oPMs5GFwT5AGoRzWmLEpw+xakmR2TFchPZzyYXDfWnBxFkC55rzm5gySnoJm2uT65GIa1t5C+ubK40fSKELE5PPp+WkTTGoh4Mr4yGerYhw+avl/lkMXnygihacFVkR8WC7bSDbNsOKq6hni5SrO6iFxeID2I4iLX8tYgCfjOgjEw4iWtDXbjfw57/3I5ivLMSeNKzGdT7tz/VKbDDrXgx6IRHT5ERPNkwMiIf0JkDjm7rv6GuYqw9lkMA773het6iNSBmwWc+eOu6J4qphYudnwl9IYuCMvJRybHlp1LfMXWT7IjtQD1pntgQLm2YtxJAvi1U7LMFB3phO46YEh8gvtqyDPpBHAsU70FxeVyoVUeDJwyK4SquCWp91OvsFgmnSSUY1BjCJgPE6pHwo/ucUJvdyVLmOlUfTl8yfeGJmk8s8aFn9cBdo2DWw4U1Bc7GJeG3SGnfOl9BBN128gGMI/OuPrQik56+nRuOgMxPSgT6lYW1fECsDNVGhSYCuoLeBwXaSxsImwpfAheSEUWMdyjmjKDWUNMiZhvCTfmNHC+kD5OZy6QnaPsZHKKmCYud/HSlyf+A4tGKgkFrMl20G46Glyz07RUwLLcWr8XC85d6qHOxnsAurJOFf5Ltqvilokdc9+N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(316002)(16576012)(110136005)(45080400002)(966005)(54906003)(2616005)(38100700002)(2906002)(5660300002)(6486002)(508600001)(186003)(6636002)(66476007)(8676002)(31696002)(26005)(8936002)(66946007)(53546011)(7416002)(31686004)(4326008)(956004)(83380400001)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWp3U1FoR01xcXlIaEcvbUJoVDMxWkE0Z3RkZ0Ztb1ZmQ1V4R2Framg4ZWJX?=
 =?utf-8?B?UWxZNjhTTi9PdUN2SHlaWjlRdHpUbVZMWWc3cjltRkNiUmRKQkR3Rzl3ZWtw?=
 =?utf-8?B?Tlcxb0tWNld3U1hUS09ZM2dEZEZ1S0tsNWIxZEZjVFRLcENOcVV2VTcvUlY4?=
 =?utf-8?B?djV3a3E3d1lEZmJoNFRwSjVieEtRM29QK1RGbW1YY0k0VWRoZ3F6bWVTL01R?=
 =?utf-8?B?VDBodFNCZ0FqcXU1Qkt1NWVzZHV4Snl4YVVHeWYwWldDTmc0YUNSOTlnWmFi?=
 =?utf-8?B?YWY4eC90Q1hVWElEYThieE5qVHZ4M0Y5elF3aEgyYTU4M2xieWN1dUVwTGFl?=
 =?utf-8?B?SEh0YkExSFZRSkdNUCtnV2ZMaUkzd2pPbFU5YTJ0Q044N2xHM3N5UVZFaXQ1?=
 =?utf-8?B?MmlwazJZRzZ1eityL3RQU2U3T3R5RU9DYjZ4Nkg0SG11UmtWREtxM0x2RlZY?=
 =?utf-8?B?dVRpTVRqNUpKZ0JUTENDT3ZSV1YrdUxYd09jaFZCcmlHaHZhd0tVM1M4U1VM?=
 =?utf-8?B?aHF1anFPRllQckx5bTVKcFQra1BJd1orN0Q3OUJpQ2hsY20rY2I2QS9FZzYv?=
 =?utf-8?B?VjN3WXd0R0RNa041d3lxRXlxN3NhUXlXVmpyb2gza1hFdGVaSGwwbUZVcXNB?=
 =?utf-8?B?T01udkZNWmlHWGhZaStUMkVvbWlRclpvWDBPalE5Q2hHS202QkkwTGVWYW5w?=
 =?utf-8?B?YWdqSk03ME8yUzJBblNQSllZblhBK1V4ajZpS2hPSHhJd1dsMjQ5Z0xHZGxQ?=
 =?utf-8?B?YXB4b2czNVUydHdmNUJ1VGtyMmhDQjVDbTl5cE5mMEpVTG55YWlnb0RwbENC?=
 =?utf-8?B?eDBTYVVPdms2d0NPUWhod3JNNkxnQ2d1U2k4OEpPVEJUUHZWQ2szanhUbG1J?=
 =?utf-8?B?MUJTT1pLZUFUWFVOY2FyeVF4UVpLWGxKTmtwcGJRK0ZGWSszYUFMSFZocHlk?=
 =?utf-8?B?QmV6WGFCZGhTTW9qdDVGNUhiM2doYm53ZEZyUUhUakRNUVEzeDZ4N1FFalFD?=
 =?utf-8?B?R1Bxa2MvcmwrRGVSOEY2MjJLeFlpVGd4ck5YT3dMaTU2blFNMnI3MkJ6ME15?=
 =?utf-8?B?SHJnL1l4U0Jtc0JrS2djREFmWDA0ZXYzWXJPK3pkcVFlS3lHVnozRzNsNGw1?=
 =?utf-8?B?R3lqNFVLclZlQ1FibGkxckFteGlYWU5pU3k1c0ovTUZWZGtrazZHdGxxYmZK?=
 =?utf-8?B?dVU1cEIwYkFMRnM2cDZQb2FKRjM2Vy9sNlFBSDhjYTF0U2hXbi94K2xsY3Fv?=
 =?utf-8?B?VU1PdWtiTXpyQWFIODhQUUxidm0xam5XdEZUNVNVY1hVNEhpOUVxT0hoWEox?=
 =?utf-8?B?QkJXS2phQVVuMXk4cVpDalFhM28vZTR1Z3JxdlA4NWM0MHJNdDVCZmo4MDdV?=
 =?utf-8?B?dnpxVk1yOEhrWExWTEp0NzA5bXdDeXJXYy9QZ1JsVUVFZGY5TWNUNGtUR0pa?=
 =?utf-8?B?Wm1pSy81bE5mMFU2UmNCakxUR2JUeS8xL0sxeHJxRDJVQzJZVVRnOWxwOUVa?=
 =?utf-8?B?Z2ZmWDk1YlJWUEZkRVQycjN1R3FqT3NzbHlMZHlGTG42amgyU21adEM4YTMw?=
 =?utf-8?B?RGMzWlovYXdROVNUaUpnbml2dlNCM1NkaG9Hc2hUVENhdnY3MkZjMVdueEtC?=
 =?utf-8?B?OXhXYW1zaDQyWWZ0WjRIRlJleVliTE1uOTJZSEFqOVNqcUNVVTVuQzBMNzRh?=
 =?utf-8?B?bUNJcGxCYUNWRXRncnRFREwxSWN2UGpMNkFlZGZtNHlUSksrNUN1eDhUd0Rh?=
 =?utf-8?B?VksrYk5qLzk2TG9pV21TVU9yVlRDTDdxUnhVbFV4MnZ3TzczbmNQZ3IyMzFP?=
 =?utf-8?B?Qmdsb1ZTYy9hMjlZTENMWVRCbStTS1o2aXFidGhWZmh0SGxEZkhzeWR2cTNP?=
 =?utf-8?B?VEpOY3BnR3lUL2xlbGZxd2Vha2RVdTQ4ZWd6OFVqL0ZiSTJuTU9vWnNqWjBD?=
 =?utf-8?B?NmsvMVVHSyt4K3hqM2NQVUZvVFpEa0U3ckxvZnJ2Z0RkTDlneXBmYU52YStY?=
 =?utf-8?B?THZueHFLaHRVSzE3QldaeUY4aG5DVU45bFpIczdDclB6VDd1YmhGTXJKczhu?=
 =?utf-8?B?aU1HYUZUUmk2eThnc1JhcGZ3YzJ5YklxY2RzWjdZQ3B5OWQ1UFFtM2xrcFZJ?=
 =?utf-8?B?d3FlYzZodHgwSnAvMGo2VnBpemVXaDlhMDFhTWxXRkcwNWFUaitrVXBXZ2Q4?=
 =?utf-8?Q?QHFxOmDdwMVny8F56kMaryc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86072a17-0b5f-4dca-e55f-08d998c2085d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 20:48:58.4112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIAS+mLUeiXKAAor7dhALEuHBcHaA3d0o2Up7b6QEZpYp59Tnu//DuBg8QDp5r/MqkzEeo6wEug4YcSlA6augg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

With reference to Boris's ack below, are you going to go ahead and queue 
this patch-set to kvm tree ?

Or do you want me to work on improving on or fixing anything on this 
patch-set?

Thanks,

Ashish

On 9/29/21 11:44 AM, Borislav Petkov wrote:
> On Tue, Sep 28, 2021 at 07:26:32PM +0000, Kalra, Ashish wrote:
>> Yes that’s what I mentioned to Boris.
> Right, and as far as I'm concerned, the x86 bits look ok to me and I'm
> fine with this going through the kvm tree.
>
> There will be a conflict with this:
>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20210928191009.32551-1-bp%40alien8.de&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7Cbfa692635e9d4247a8f708d9833e8bcd%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637685126945432007%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=vZU8ZijdqiSiVpCquIMqu2yz3Z7sWgD3vvNiiQyszzo%3D&amp;reserved=0
>
> resulting in:
>
> arch/x86/kernel/kvm.c: In function ‘setup_efi_kvm_sev_migration’:
> arch/x86/kernel/kvm.c:563:7: error: implicit declaration of function ‘sev_active’; did you mean ‘cpu_active’? [-Werror=implicit-function-declaration]
>    563 |  if (!sev_active() ||
>        |       ^~~~~~~~~~
>        |       cpu_active
> cc1: some warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:277: arch/x86/kernel/kvm.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [scripts/Makefile.build:540: arch/x86/kernel] Error 2
> make: *** [Makefile:1868: arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
>
> but Paolo and I will figure out what to do - I'll likely have a separate
> branch out which he can merge and that sev_active() will need to be
> converted to
>
> 	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>
> which is trivial.
>
> Thx.
>
