Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9264955F08D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 23:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiF1VwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 17:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiF1VwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 17:52:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907862E0A2;
        Tue, 28 Jun 2022 14:52:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ic4xEdB5sUKPkEiiipRijGi8aDe5ngCvFm1WPxwVOmPAvEKm7oIxHj8EKRaDk6ThDCEyeeMGiBA6FdY44X5aiPv9HFP3NIspJJfrA75W/cnIJbKE2/X3ssE7NwhUYA6i9bHzC873mguq/6p4PpqHgo9xscolbYK2BYirFPzzDalrzHd1GhPHVIGyziIhI5L6gnKftBjXHAF4JYOo9LjtSgUmEERXtjEKauLovjcQiZ9fwdvQmqB1JVXqgC6tYfw/iGXxYhYxlmcapTngHqImCj/qRUfRKYGQ6T4vrczlBL85IgNRQrI9tKsLVEGY8w682KhgmMGFTUeaC9xslowU1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4uIo1j2w4hqloygxo/pPinnp5uHnuVLeKc94HB+Ziw8=;
 b=nM0wMZ4BaleWjaGndho9leLRFFgGmfLcEnzaG6FqG6tGt6Z64TD3b2FA0t242gxXMeqG2zm3WIC4q0+kjINMUvIdCjVn8HktXkWvs072CpInOj4DobPsqTqk8WNWQLczfCrmKKD6i4XEt2wETrr7Y6pWoNf0Q37OAWTERgncFfO0R0NOXm3cJDm2T9NZkIUQ4NoAzNrlIOpOMRum+mRFfzynvaisOORfAzmdU1uvKUWUZui14nWIGNUfHoVhtwx30PHdu2IQYuSAhC+J/NPM2FgNZBJHmfplpsFih2va7RMMMCKoIyImLdtNbMpNLpm2i0AyMqwEyebjScT4BvvSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uIo1j2w4hqloygxo/pPinnp5uHnuVLeKc94HB+Ziw8=;
 b=hf/iGxgiDnX33S+Px803K0Qedu9mwnC6+kG85uKQVyPrd5qLMTOy//vWw2TeqItT+dPVnUvythyBaJz2vO9D1oIYDw16aGVSaVU6f4ioLH0bRIKtvvycxHLXSb5Xxpl0n2mA/oUnx32urtfJbnj7VL6/p3AS7a0uwn3EHivbOu1xBB2uWrAPyphg07JcOs0XRcg3MD48XlRaYy4cK0D2YNMFtz5QLK5j+xPqnS67oTwLu1UnXcUUYEvfyStgYHo4c/EJLmapxQT7M69vQS+WLvp5ldrwEPZMGr1VmBpeH8apaecXsIZxHL79O1OWyDd91D6xBy8g72YD3OELfmMnEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BN9PR12MB5365.namprd12.prod.outlook.com (2603:10b6:408:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 28 Jun
 2022 21:52:06 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%4]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 21:52:06 +0000
Message-ID: <02831f10-3077-8836-34d0-bb853516099f@nvidia.com>
Date:   Tue, 28 Jun 2022 14:52:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com>
 <c047c213-252b-4a0b-9720-070307962d23@nvidia.com>
 <Yrtar+i2X0YjmD/F@xz-m1.local>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <Yrtar+i2X0YjmD/F@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::49) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 232e98b0-0566-4101-6c68-08da5950719e
X-MS-TrafficTypeDiagnostic: BN9PR12MB5365:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mciBMw+/S1xl2Wq1AGdKLQBBwzVBp54yH1c1e6DvbXDq17wA8lvOGNjb6+fWD2vD3IQg57yye5kBpHa4iiffpuG4QTx9rDCDKN24bRY5nhHtMZqkZ4xCegS/AX2nca3ebF9rBlmJaXE3LI98lLwlhEx/kmgce5GqzBft6MkOmw2e7EGwktrML0BCkuk6wwqdlGXbj2Wt09kYNpeWO5KGhOE+rnylWb+hXNf3NIGf3Qm2xIRNeS+R3HOu544DB0PvcJeKPyPsc54VlEzLqf88jCfNquFZL6eaG0ZZ9QT2Vga8awPHS4o+8XreOvq7K/IpVtqucaSaUBxxHWqeXcz3ah8H2iru/fYRm+k6PyxJqvaTAeTTYfoWbnSJDPAX5O7apSILS1utiPE++Z8+CHjhk53exs2iDZcpLIT5JclouNrlW2CnNlRa/wCIIa+JCfzRjPph4gVth7znzcw0Z31ou0IsHVJO6fnMaFbgpfUptLn4dhQmUYdLkHpe2CodYzsr5vHeq4hdifGn8P/Kw9KBd/v3E8/CDzRQF8iyTFpeW5t1AmK/mGCKsmNTBf8qp5wALbvzd6yuwWrKy07Mb9+1chBh8DmFZblHPgX+iYt5/bstiuO7k0LdyigCyHqXaph4eqvKhota/go5CQB2OEPx7uCI/lmASmyshQwRPOoHFfOAYdRy3JdxU0D5ZXmad71d1kb1e6KRz72KuL3xUlzs8lVrA6ieucozFJLGNBYmO2KboGDeKqYKZE9Tkff/03GZiXTG0VQ3NWJkkOlciy6cBOzyACrjSfnWb/ni6spIt1qhvICzwWZeXO1TqiZavzgq7NGAkFDfxX7FOvSo+cEEYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(4744005)(38100700002)(7416002)(36756003)(31686004)(4326008)(5660300002)(66946007)(66556008)(2906002)(8676002)(66476007)(6512007)(316002)(53546011)(26005)(83380400001)(478600001)(54906003)(6916009)(186003)(8936002)(86362001)(2616005)(6486002)(41300700001)(31696002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXdhR09DVEgrUnJBRERFakN0dER2V3hrM0lnd0ZIaXFUbUx4MzhKZWFNY3hD?=
 =?utf-8?B?T3E1NFgwU2RNQkxpODBtS2g5RWloZ3NVcGYwVFV6bUo4Y21SbVRDbVQyd25j?=
 =?utf-8?B?NVJ1WFpaMml4QlZia0VtVE42dXVGUlJiR2NPbHRxVVVVMVRFWFpxcUtad1Jj?=
 =?utf-8?B?c0FyZlY2THQrdi94ZDBaZnkrOVhTNng3UndlMUo2ckhhQ0dmWjNZZ29XTE1n?=
 =?utf-8?B?c0QyOUtRbnk2R2RUYS96Z0Q4UDZURkFDZ1VGOGhRcHpmOG04RjArSWNGNlpO?=
 =?utf-8?B?ckFubmI1QzY1SUVxdVBjcEJML2x1RW5oUGFBRFdxZlFFQXBiSU9lVmVVMEY2?=
 =?utf-8?B?blBIZ05KYTB2SXc1YmY2bWhGbWl0TEwrVGdibEt1T2VmejBIUEVkNEM4UEN5?=
 =?utf-8?B?WWFYZWppbmZZcWxLS2gvbXl0K3pKbXAwSDBmcW04cFAwZXgwakdMMlZuNCtE?=
 =?utf-8?B?ODFZNXRhc1I5Y2tIZVJhOUdQeFV5RnF1UEFZelRTTjNjNUl2VncvMFRlMk9Q?=
 =?utf-8?B?RjJqVXJtd3dmKzRBQVlRc1phekZsYTFjR2YzQUp2NmVrV1N2djV4MVJ4K3g1?=
 =?utf-8?B?dzFMV0xXOTJ0Mkw2dzU0NUJiWDFDQVRZcFpNaERHaWdKWVRMbG1uQ0F0U3kz?=
 =?utf-8?B?eUVWMDdlN09hTGppVk05VTdFMm02NEo1eDNmRWNLVm9NTmhjVUMvNUcrTi9j?=
 =?utf-8?B?MGl6cXRiN284OEQ5dlRhb012a1IvSkVtR09QZk8ra2dTb0dtNFZpWFJuWE4x?=
 =?utf-8?B?WFhsdy9tZXNxM29ETlJpWkI4aVNUazVWTUJXUlMwdEltQVloL3ZpRGJPakps?=
 =?utf-8?B?Vm5kdVROK2tzdVVhQzNCNi9WSm9IM3hxeENjaC9ZdGRGeWxrVDhkYVVSZ3Rx?=
 =?utf-8?B?YmcvMXN4a281RTBmUERma3BNQVd2dHhmUmZ4eENLVkdpdVU2dFBlRHFDdjQy?=
 =?utf-8?B?T2JzazJMTTM0MmtZNGNkbjBSQklKZHJMMnNaUzFwSGR5T3YyS3dSNTdTVVZz?=
 =?utf-8?B?S0pqQ1NWVHNHNTJmU1FCYmJ5dTNmWkxQUVp2NTlydFZWU1FNOFVYL082czJ4?=
 =?utf-8?B?a094TUdYRXVKamRRWnorbENYZzBPU3ZTOXZINXBaSFhZZUVqeitGeStKUFlZ?=
 =?utf-8?B?dnhJeWxyUk5MWVJQZzd4cGd2UVE0WC93NHVnU05QZDNScFljZEdGcFJGUWRV?=
 =?utf-8?B?bjhnaFlLd0dubGo4UFpqZ1ExRzJES3pMamRTS0pMcVdIT0J0U3ROWDllTVJu?=
 =?utf-8?B?ZmlOcG9wZ0lBY3VRZmJ0U0FwejlybHNmSG5lNTlWM2NrMTJCZ0UzakRPSkYz?=
 =?utf-8?B?TEZlZG9QaG5kV3BYK1p2Nk9BZmZoUlp2eU0vWVdkUzFUcU82T2dUcWQrSDA1?=
 =?utf-8?B?QnpFTHN5cythV0lZc2d5MTJaNHBwRjZLaHRwUmtPTUpwa0hNMWd3UmkvKzIr?=
 =?utf-8?B?TWlkRkgybE16Mlhwd1pQeXdtL3g5U2krTUc1ZU5SanBRTkc3THhGZWFHY29Y?=
 =?utf-8?B?M1YyQzZ3NmlrbXJ1Q2ZVMFg4cHJMWXk2Yk5jL1N3aUZId1ZJV3k4YitlbERX?=
 =?utf-8?B?aWkxaEgvRmFUc1MyUTlpV3FmVHgwTUgxek9YTEtmMFBLVUJnUEhzT0dNbmY0?=
 =?utf-8?B?L0J1VXR4anp3amxOUXRqR3RzMUVDcXhOOEF3a21sQm84b3RNMXpGRUJiTlNL?=
 =?utf-8?B?R0M1RExJWXBac3Q0a0QvZ2tGUHo4Q1R5MVRQSFRvVlhQaGtIbjB0RDV2RGZR?=
 =?utf-8?B?Z1owOXN1dHZRSEl2ZGNoVkQzVERydTZDVlRkUFBVTlBKWXU4SlBEM2lLNG9h?=
 =?utf-8?B?UHhrWG9aZjFsa1ZTTUwrT0JRTTFOMGNNakJObGVqV081S1dkSXIyNXc3N1Nw?=
 =?utf-8?B?TUdCTjBvYklvTnMvU1Z6Uklrcmx6YkF0ZnIvajRxNVpCcTAwNGRneVd0djlu?=
 =?utf-8?B?ZE0yY3g4NVpWMS9ycnJaZFFMcG8xQXFmTmZVMHUxZFVuZ3FRUUU3cmZGZUFB?=
 =?utf-8?B?cmNuNHhMRkNEcGpGU2RkdVF0djR0bE1GU1VqcVJRbEwvaERHcXgvNkZ2cm5i?=
 =?utf-8?B?L0dSUHR0NUZheG9IRDR0MFB2UlRVekxmcndYWkxramllcW9OOWRGM085dWVy?=
 =?utf-8?Q?Verb9rNji8xSnqOKU+X6dapzj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 232e98b0-0566-4101-6c68-08da5950719e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 21:52:06.6059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJkS4b0ijeLUl7zbMzhquCshu+N0Fs2TkHi6EL0KUuI8S/7wAc+Gj9ViLSvL38eOkU90qDkUTY1fTJITcBxjfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5365
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/22 12:46, Peter Xu wrote:
> I'd try to argu with "I prefixed it with kvm_", but oh well.. yes they're a
> bit close :)
> 
>>
>> Yes, "read the code", but if you can come up with a better TLA than GTP
>> here, let's consider using it.
> 
> Could I ask what's TLA?  Any suggestions on the abbrev, btw?

"Three-Letter Acronym". I love "TLA" because the very fact that one has
to ask what it means, shows why using them makes it harder to communicate. :)

As for alternatives, here I'll demonstrate that "GTP" actually is probably
better than anything else I can come up with, heh. Brainstorming:

     * GPN ("Guest pfn to pfn")
     * GTPN (similar, but with a "T" for "to")
     * GFNC ("guest frame number conversion")

ugggh. :)

thanks,
-- 
John Hubbard
NVIDIA
