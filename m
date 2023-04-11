Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CC26DE523
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 21:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDKT5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 15:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDKT5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 15:57:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E73A35B3
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 12:57:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iL/pp2ls2rQVu8BAKbwT/pLUc+9Bm01ccgczA2MKhTOEqhN64OCPyMXv2iRJbdhLWQqrcE3svX3RL/oNIyRN9ABFgdjUdXLxrDxXIWforRM4PSnyjCf0fAB1siQok4NAEIG73SkOicI0cpmhhAKC8eJeMU8X1Rs1VWpQp40AXHus+Emgb8WvkmDvL3cVIXDO+/rtMZho2cI1dOOIPS2LVyyBlzFvXZ+see7xjnbsFSm8PaxlXfOWTAksj2+D93owVmRNEx0zC5Bf16aTuUEF+x12DnMugdUv7qq1/CgCdVPtI6zdGGwzU4IhoCpqY1p4k22cVo2HnOm9GKS/gOKq/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwUV3EDaWKgW6fc3yXH9aYT1z28Eybnk7lGg7153Xdc=;
 b=bh97pCYpS6BklEmsr/AczDfGdkC9gBL7FgqRagyosXsj+P/AjlR9MeE7k2RWy8qzOEzQnSZ6JDLtTDNcNf7RrQcKYkPbG3dpM5cukZQe7+bahPcFdraMFSSNMMKSS0XSmxce2tJOVrlwsVAsh6Fv09K9aXhaR3/DFhQWih/VvY+TXkEZ/THa6alfv2NDo5RGV8e5j3bYCok4XZdBLr5f6AeS7VSkglmwPy1yVmX1PoKUl+R+aK4ig/dFjzEPSWwW2PMK0QlqkWl4RvEXIrD8a2mYWgvKOzgnkHUXT3xYg3dj11pbPvT/8Z9+VygEHJEWcRpzGqlqXpPlB8mrjzPZDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwUV3EDaWKgW6fc3yXH9aYT1z28Eybnk7lGg7153Xdc=;
 b=SBQg7SyRXrSHrUW6Ac4HF7nwCXyR2XjlKxJqCDFd8l+aKdM5SRDUwTOuuy9iHN5fcRFHk3fyuOmw+JOPtDlEotd8wgg+de8Tkr3Ey6O+vRhVy062MaD0JzSNovQ5sQmLY1vbEXPWIZxmoBuI+Z+ftAfDGiCpvltDc18BI6XbNZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Tue, 11 Apr
 2023 19:57:04 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%6]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 19:57:04 +0000
Message-ID: <bf7f82ab-3cd3-a5f6-74ec-270d3ca6c766@amd.com>
Date:   Tue, 11 Apr 2023 14:57:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Content-Language: en-US
To:     =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
References: <ZBl4592947wC7WKI@suse.de>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZBl4592947wC7WKI@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:610:32::24) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b18325b-90b8-4f63-f692-08db3ac6ec1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJx1a6w0i3JyaGK6PIBGYhDWchr5qZA//gsNT8BJwmG5I/aKcqEzXHtQqYx0Cr6NfE2Lh3NUVlKJHShp5Vjk4z2BdixsUtH9cwKfthrAKm2P5PWE4EgsQ1W7R7hsVDgCuyJDmM4TQR9gkhcOfuxt+KCZLdyOOON2somsMG26VbuNKlyHouSCN45uTTQDkGMPJvHJSTpdG77uVVcZmctD0OhAUx54hT5oR8HUAIDuWmuP0JOVIZckOKtNC2sBDD7kccRfZ9UG3Wm+iN9qMEcL83Xl+h8VruErJ+HI2VnuFhM8jdIasye6OwIhhLtIRyOKDAZ28f7zzaZxhW7eCnCyzJ/HDyPM/v2rs5jp5yT+/oeRd2BtgD2+69aDvA4gPlCs9/UAdbBFnu6lG2GhtD4w8a6SUfPECJs2+I1rrYKsNO/TgCmomwy6h+Hx49w3rR4PqY80asCoorsFMd3N2/XhXrEbMPtoMW2hmamXgMB0X0NvtrcmnMUujfSy0QElnvvSTxRrz2/oLlHjLSMcdB6/b9MuRZLa+BkKlS4cNL4T0R6g++Pwj2Z6K+K6wwuNQuAR2dvzqwJYqHVztublnua3Hk7ubSUajzomnh5g13MPzAShn8pfDGDjMYfCsRTqUL6S4by5WeObXji3aGaruHa1NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199021)(26005)(31696002)(86362001)(53546011)(966005)(6506007)(6512007)(6486002)(36756003)(316002)(186003)(478600001)(66476007)(66556008)(66946007)(8676002)(5660300002)(38100700002)(31686004)(83380400001)(2906002)(41300700001)(8936002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHk0ZzlZZjF2cHdzeisyWXdxUlNkMTNpdEN0K3VhRVJLMHAxSEJXR0hBS245?=
 =?utf-8?B?TUNqUUF4VzJUd1E4dURESC9vZkpmSWlhSjNnYTBTcjl3eXhjcW1SM2lRSVM1?=
 =?utf-8?B?V2NNZE9PNWh1cE5HN3ZvYjd6eE5jUGRJcjNNYU9ybW1pai83dXRweTQwZlE5?=
 =?utf-8?B?RFVOWmpVOGJUcStOcml2Q1BXOFBEb0pJcExsMHJWbVlEU3RDNndrYUVtZFhE?=
 =?utf-8?B?Z01JYmpnSVZ6alYvb0Y2a2xXMjdIMFVyS3I1OE1qY2Vnd1lDNml5VG12Y2sw?=
 =?utf-8?B?TFc5Zmh4MDhsKzRFVUovL210ejVRK3B0OThHNFF3TUZCY2hVMUlxZlp3ZVMr?=
 =?utf-8?B?TG9WR1ArdFQzQk9IdWJDY2RHeldJK0dIcU1CY3czNWlJb3hqcWZWbWUybkhX?=
 =?utf-8?B?VWZ4YXBFRTljTkpOTUtjcWpLd3pNTC9hNGRsMEgrWUtRcXF3VUFqdlJFTDBj?=
 =?utf-8?B?bHFPNnVHYzV4aFd6ZGRTVW42TStKL09zU2JRcTJka1ptZTV1TG9VaDRmczFu?=
 =?utf-8?B?TnVQRFh4blpPTVVybVhRaGRUditjUWRXd3ZjZUVGRm10ZHkva2FBTm1jTHBE?=
 =?utf-8?B?WlVDS2VaTzdPV2s3aGxWcURneFBtdzBOazF2V3BtMXREcFZwT3pGL284T2RI?=
 =?utf-8?B?YVhBWDF4bVU3ajRHWFB1MlRjeVI2YmNyT0t1QXJsTjl0ZlMrTkFxdU5WeXZK?=
 =?utf-8?B?T21td3BRdG45ZWhQVi9PeEtXVklQYVlYajRjWGlrSVR5VldGZndiM09hQ2wr?=
 =?utf-8?B?VWg1UFBlcXp5YjFnWGlRSHAvbk9LRkU2Sk5KOUNTM2gzQk5VTjFidURpZUpP?=
 =?utf-8?B?YURQcXFrYXhCMmFEZEVWd082dEV5TzNjSDhORmUvVTNZNkJIbnU3KzV0Qnpw?=
 =?utf-8?B?L0Jhc1RTY1BHUWxVNjJEMFRRSjNpbHo5aFNWM2pLZkp5Ti83MThSTWhXKzM0?=
 =?utf-8?B?dlZXUEhaN29zYjV1WE1qVWRmeHlYMnluaXVpeU95SzFQWGZudHRIeEJoRG56?=
 =?utf-8?B?WGlFSXJtUEUwUTAveFJZWUxhbS8walc1Wm5sKzNuaEpBMEs4K3R0Uk56Szdu?=
 =?utf-8?B?Uy9NdHVJUFByaWQxYlN3TG8zNW5Hd1k2QmNlMmRzdDdNejJzNmhqdm9DS3Iy?=
 =?utf-8?B?ZlYwWitPaFVaNjNVT2JxU09UUUdZM3lTNmpvYTZWM1UvMStlUzBNUmFnV0ZZ?=
 =?utf-8?B?UnNQMGZqZzBrQjNjaTNEMldYNzl5cVR0aVJHWUZxVGdxSlFqTGpsc1Vpdjlr?=
 =?utf-8?B?Q2oxRktiV2ZiN3pQdVNnVDZwb2pVN3dza01ieUxzNHBxUEFaMUR3WDhmNlRG?=
 =?utf-8?B?UmwvdTJWY25GeFA5dTFuOUozYWRuOUpLVmlVdzJzMVVnOUFhYkRnZE84TUY4?=
 =?utf-8?B?L2tjcG93NUlnaGJNMDJYQ3RsR09rV2IwN3V6VkF6c1JCd3p0anpRUWowd2VD?=
 =?utf-8?B?b2tBVlJIWWxVZ3c4UVJPYy8rMWhsZUp6WThkZndhM01QZ05pd25IL1dLZ3Zo?=
 =?utf-8?B?QWl0YmNCU2JUMU8ybVlNNThjVTQ5TVdZK1RHbDZCeG5IaG5JSmNVbng0b1U4?=
 =?utf-8?B?enV0VUd1UXd5K2VNanJVemxkNm02VUpvS2t5MUM3dGJqb3ZLNFVyK1N6RFFp?=
 =?utf-8?B?Y2tKNGV4MExEd2RYOTFrR0pacVlTN3VBZ0daeXJVVkFia0Fic0piNlFHR0oy?=
 =?utf-8?B?V3gwV3hPYnZOQ3VacVd5QTBDaUM4UDVWZEEwTkR6RU95SGVzNEVta2l2MDlL?=
 =?utf-8?B?cHdVbmo4QW9tcHhTR3h4d2tKV1FCVFZ0Y0lRMFhIU05VbW10NzZjVThtR2pV?=
 =?utf-8?B?WHp5NDdCVWV1KzNCaVN1QUM1TnhpRENpYVdaZE9kSTV1UC85NEdlZlFsdTBY?=
 =?utf-8?B?NjdNTmw2UVNsSW5xWFBHL2FNbitTc3ltcVFONDJmVS9zVXgrWjdNazZkMVBR?=
 =?utf-8?B?ZjQ4TlJrOUliT3pZKzJ1Rk9YNFQ4N1Y5b2RERHAxeVNJZnlqUlJqaXRDRGFr?=
 =?utf-8?B?ZmNFODlycGk4Q0FacDFTZHdtV3VRVlR5dTlHT05RblU3MXJINmtYNWJYelh2?=
 =?utf-8?B?K2QxeWNJR2d3Z3RROHp3bENhdGRoS0wvNFdaZ2QvVDYxMlBuSzh2UVBHS084?=
 =?utf-8?Q?TW8ku71xozstwBt2kmLt01NIH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b18325b-90b8-4f63-f692-08db3ac6ec1b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 19:57:04.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48r3t4/MAP0DAtnaQ7Ns8+jRtsJ0au5Xi66TIhUcz2XqBwj+1wvN4NdjmH2HCREx5mfuuBDeyajT/V580R+K9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/23 04:29, Jörg Rödel wrote:
> Hi,
> 
> We are happy to announce that last week our secure VM service module
> (SVSM) went public on GitHub for everyone to try it out and participate
> in its further development. It is dual-licensed under the MIT and
> APACHE-2.0 licenses.
> 
> The project is written in Rust and can be cloned from:
> 
> 	https://github.com/coconut-svsm/svsm
> 
> There are also repositories in the github project with the Linux host and
> guest, EDK2 and QEMU changes needed to run the SVSM and boot up a full
> Linux guest.
> 
> The SVSM repository contains an installation guide in the INSTALL.md
> file and contributor hints in CONTRIBUTING.md.
> 
> A blog entry with more details is here:
> 
> 	https://www.suse.com/c/suse-open-sources-secure-vm-service-module-for-confidential-computing/
> 
> We also thank AMD for implementing and providing the necessary changes
> to Linux and EDK2 to make an SVSM possible.

Just wanted to let everyone know that I'm looking into what we can do to 
move towards a single SVSM project so that resources aren't split between 
the two.

I was hoping to have a comparison, questions and observations between the 
two available by now, however, I'm behind on that... but, I am working on it.

Thanks,
Tom

> 
> Have a lot of fun!
> 
