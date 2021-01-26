Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44740305D3B
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313378AbhAZWfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731393AbhAZRFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:05:23 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A646CC061A2D
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 08:49:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lhu3ObSs3XS/KTf/lCBls0pz5JOPYJu9DMzrOd97q9w+qjoiLS3d5F8FNawGbDcQW/6ASC2+jk09dNJPLYF7+C8PeRFwhC4zzP7w/hf41QmxumF8qJiwBY9rvFre1cWu4IwlvndwD8zbLFv83Qeud9a5zWO6ZK2YOy3kBK9Fg4Daq8pkxSUC/fZhAn4SLVFeoJ6LC8jfZebvKslNSASV4lIMroDDNoGE8MkMshPXUmdo5NsZ3TkFrpMJbW3XA6/GQamUGRJymc0kg85+jUG+xmNSmdYlRHIgLzeiAvRDvImks2lv1PDGwXhGv2HUcXtzheUiQEnQ4WB2Lg1GYLxQxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doPTqSkooEfVhWHUa+Tp/9B9fpnMCI4ts/Lqy4JD2vc=;
 b=eDzAPlsJt2UApH5Hi3SL7I78lnJJvGtv1r/ctsXXBoccvK395T36Rp3MmK3Ehzuzh7FnlRUfqm8MlbWXTNt87p8Z15awGcTrgWiRnxgYu0H84BjMA9u4j1EBbnWfAazQXhR4rT4pLBhkZLUdjlZ9DYxMwwbv92P0jIg5GQyl+9GeL/K0TW6fjKmf1JCZEMt4Rwwk3beuUjdr1JRthXngEyekkMwX3EugwVIaNNVnNO42t8U3YfvPUnMYB6V1VNfra9JRWp4qj7LsAsrYrMmK/2MooYENBA0jkQBncuBNm0e0zIfiK9FCfcKd17YcVYLPv6BZDw9y1rfpCcqLAqg1Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doPTqSkooEfVhWHUa+Tp/9B9fpnMCI4ts/Lqy4JD2vc=;
 b=lTby7AYAbV8+mVLwayZ5NUmv9tA4iGy0N0SSWs1m3Wkyf9E1OuOw2CurBxDyowSNhcrS2intigf6ChbhNObYZn+BQeOkze4N1XzH1wydKzvqxadIYSKggnBTeyO1t/0fqFvWKqovlKeGfmYzM0EKkjPDuL2JR3rboXg9f1yJRlY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2889.namprd12.prod.outlook.com (2603:10b6:5:18a::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.17; Tue, 26 Jan 2021 16:49:32 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 16:49:32 +0000
Subject: Re: [PATCH v4 0/6] Qemu SEV-ES guest support
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
 <30164d98-3d8c-64bf-500b-f98a7f12d3c3@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b0c14997-22c2-2bfc-c570-a1c39280696b@amd.com>
Date:   Tue, 26 Jan 2021 10:49:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <30164d98-3d8c-64bf-500b-f98a7f12d3c3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:610:57::13) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR12CA0003.namprd12.prod.outlook.com (2603:10b6:610:57::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 16:49:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c3bf3b9-3996-47c8-feac-08d8c21a5ac7
X-MS-TrafficTypeDiagnostic: DM6PR12MB2889:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2889C3E92B11312D8701ABF9ECBC9@DM6PR12MB2889.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5QpRTCZHDpDp3RsEyL5RdDqvox0rmL2E71MaVeT7LRC4aAlC5t3I1gkbO2aS5hjZL9hkRFCcegd6zITfQw5qR/khot5y2DKP8ZEqbYNUAbyK7ukXx4uFxfxGQl5ETNGVAqi0bLcwf0VAYp6c1TEwsy8GEJUkbYBwoquqbL7alfTU2vsCG7G9uQMbMCxUjg4Z7HiLtvKgLlnl0agD5G+a3FTeqC5lK43vz3Nokeqo6hAKXOG2D1iiuMhnKUU+vyTO/b5I50a6Jo0c6Z5Fi7ZLhMYqmuZ/UCQXTRNxIkvhJs7RowRglCpRt0oVgM7khYBuNqIAoSKbU57yKxm7bLPD+AKp2BdeDInelmS12ComNA6eO6FX630t7jtSPojy6OQ8SqOdikZaEYzAmWMrZ1eIQoENcS1LlxJrKbYRqvvw4+vwbfOGnOJdtbZ0eMGaGtA0zmZQIVadoxi2hBppKe+yrDusVr66N5qvrAGGXYXvXULZqVaFjC5nXp8UNDd/ZRFFE5SGaPRBEshkjNSmfEYJBIn2/UC8sMH22qjByEzMF4KnB4HCwoMokhN6lGpPknKNI7WoqMZr5BBO3obC+wsnVhZRy8fsArJga2G9VY82DCA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(8936002)(8676002)(6486002)(31686004)(52116002)(5660300002)(2906002)(31696002)(7416002)(956004)(26005)(86362001)(2616005)(4326008)(316002)(16576012)(36756003)(478600001)(53546011)(4744005)(66556008)(54906003)(16526019)(186003)(66946007)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bmhlb2JxSWNUbTZrdkJZZG1OMU4rOWU2S3N6MUdjZDZzTno0YXRreXUvc2dW?=
 =?utf-8?B?ZC9XTm92ZW5obGZUNmtXcFRZNC92a2dpalNvUHdtajg0T2dyandWc3FFcGEy?=
 =?utf-8?B?NUJyUitONmIwWDRhSFp4RkFTVFB6b2JVMXFka1ZzODRCam9FbEFFMFJCcUlT?=
 =?utf-8?B?RUhnUTBGU0J4V3NPUzdSeU04UkFVa21XaVZ2SlJiWEFIcmZFUCswRUFqM2xC?=
 =?utf-8?B?V1Eya3pPT05OaEhCUzBDd0xGYzFJVmlncm40NEVvcERkWEYyMHJCMWNrdWk3?=
 =?utf-8?B?RDdyT2hteE5zd3BxK2NaZjlTa1psVU1veG10a2ZCUVI5RXU4TlFXK3RHNjg4?=
 =?utf-8?B?clUxQzd6dHp1L01lbDNUYXdZTVFtcEdKUDVXTHhQMDdpaHROd0ZTRldiZ1JZ?=
 =?utf-8?B?Z2JFMFhncGlYRDBoekJHS1dnTnd5cVgzZEZJZU9MRWwwZEZmVnhqZCtZSXd1?=
 =?utf-8?B?dXAwWURwaG9xM2EwQTFaQ0dLLzhPQ3AzRElJSmNpYzVZTExIenZENGpyQzlH?=
 =?utf-8?B?ZXAzcjNBV1FoeEhRSXl0Uk1TWUNHS1FxMHhwOEVIcTllM2tKNkFGWHJaSm9Q?=
 =?utf-8?B?VHhJajZYTVZuYjU3SUE5SHVwaWd2c0JXOTJjYVc2NkVLZFF6UjEzOC81NXNM?=
 =?utf-8?B?L01YNVRKbTMvc0xNZThsZjNzSzlrZTdrc3BYRFp4OWkxY2dDS2kyaUVyK3pJ?=
 =?utf-8?B?S3ExMDdGdUZVcXBqYU5iVnE0T1pGclRoeW0yMkE4NVhXcHNVelNwd3FNVm84?=
 =?utf-8?B?a2diMlFZbGIxdDZnZ3pJcWM5TUs4c1JoWG1aOGN4TVp3cUZqbWlwSUFsN1A1?=
 =?utf-8?B?UDVBSGJVdzJ0dGlFZ3lWNXFHbDVScm9kM2VlOU5Pb2NlS3lwREw2aUxBNEdE?=
 =?utf-8?B?aVppRzJXY2RlMXhxQnhXSUxMSWpmUUU0dXh3TkxaS3o5U3h6QjFuWTNqWkpR?=
 =?utf-8?B?d2J5WEpwbldIa0FZUUZIVU9WNCtoK1NMRS9IaDFCczEwN0tsK3Q1U29iZ2NM?=
 =?utf-8?B?QWc1RlljcVE3TkxZV2liTi95alNER0xJZmhSbjBVazhKTHFLSEdaN1JKanZT?=
 =?utf-8?B?SXJwdUJ5a2hrbWU5djNOMkdmS3ZaMWRoZUk1Z2dZV0l2a3hlMlVid05sbEsw?=
 =?utf-8?B?WnY1czVncit1SThtWjhsTCt3OWo2dUZ4dzJFSEFKVVU0N1J5TTUzeXM3Uzll?=
 =?utf-8?B?b3dhNTlNS2dwVHpJdEpudVJIanRJWjBDdjQrMGJhVUZPWW1PNXJRRGMvOGJ5?=
 =?utf-8?B?R3MraElFYjlRUE5pRmtKQTlTc0ZOdDZSL29mMEJsTE0yR2U1SWhPVGRwSzFP?=
 =?utf-8?B?UFFZTlM3UWVnTUNSVE5obDhRcnF6MEhXdndNeWpLWS9nTkVXc2FkMUVCR2Vq?=
 =?utf-8?B?bmpwdEplS3l2MDlDd0NtaXBmU3JCSUdxVUVFcXV6SVo1bytWcFlGNERrV2xz?=
 =?utf-8?Q?HYOWEleF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3bf3b9-3996-47c8-feac-08d8c21a5ac7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 16:49:32.2808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuMvj0VpBiirX9R87V4qqiArYvQwK0YKk9DD0xa02Q3D593Onx0gx2740wDPWvaHbHeOXYVh9FoSbBtth+wczw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2889
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/21 10:21 AM, Paolo Bonzini wrote:
> On 25/09/20 21:03, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> This patch series provides support for launching an SEV-ES guest.
>>

...

>>
> 
> Looks good!  Please fix the nit in patch 4 and rebase, I'll then apply it.

There's a v5 on the list that was rebased on the latest tree, but still
has the patch 4 issue. I'm updating that now, so look for the v6 version
for merging.

Thanks,
Tom

> 
> Thanks,
> 
> Paolo
> 
