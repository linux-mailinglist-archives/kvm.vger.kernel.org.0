Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640E54C8D63
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 15:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbiCAONu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 09:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiCAONt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 09:13:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C03860057;
        Tue,  1 Mar 2022 06:13:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFwpr/4rxxshPS/JdiOyt34Ljxm9flxg11FA8QHQ4XUHp2VduLBSprAfGAuu47fDNVqD4sx4rrCyWoYaG12PZZAOi+W51XBMLoudv9CUkgvulIonBdN+CW5f7vPDnq/08NkV8w1UZhbW0apxbjcQE4tm+2o0nFr4H0NQwjoNhi0pWx8VznKXK4x9/TvIF9QVjKYACWpcMcJQuVGLTLTSH+2Yaph+BGatS47I5bey6h9UMB2lFDDMyxB42y3aMPlTKiFQPz6ZQPmemA/CPV7jV7holrKrhQgflz4+Ca2we2pOSaqVEPfTRmCgF/F9zJ8XfIPFcAlb03bK3JoayPWXnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5fjFiDqjq1cxCrQLjPXrNnlc4GD4iSqoQCAe4IxQn0=;
 b=HhfBG+ZjVUmQk6c6pfPfF7MyquJllsitOQXtkgS9MWedUT48atI++cGJ0t/OoTLUrVNr0jJvFOGHTncaMIUb8vWuhHca9ZWj7u4lOOPaomNIUD/VdoKyLTopv8MqanjYqdsu1tP0zSs6V3epfyfHfB91uGZqCbl4Kv06CL8lgzCb4avLE+5H2A3yiLMPN9Dw2clR6jPlH/l0smtJ165AcOQiHkg9h8EZ7utrXWQUBZFuCMGZRPMx9nZas3UIUQNgVlXOTWEKs8xlV99pgNNwF+iM+OEEyypF8hr1sKnK9X5W65seOg0QGaeku6bfiY860T7kPPQeNqojMHskNDRH4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5fjFiDqjq1cxCrQLjPXrNnlc4GD4iSqoQCAe4IxQn0=;
 b=n3xMa7cbtNkVLL+M/PTlqUPXy0OPWfqDWZPSqRAl6qpHglH9JkhARIrbxAEQKhZRMVA9leGANdfwNauPsrX8B684hHXyhfrp7oyCvX47dC4Ofz+8XBXUAHvh6vW7Igw3X3dhAanMduWuk3ZPDbXhQoWkWn3DiIXxu/bc7CbLbKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by MN2PR12MB4781.namprd12.prod.outlook.com (2603:10b6:208:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 14:13:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::500e:b264:8e8c:1817]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::500e:b264:8e8c:1817%5]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 14:13:04 +0000
Message-ID: <77bdaf1e-4003-0ccc-cddb-8fc634abbcd3@amd.com>
Date:   Tue, 1 Mar 2022 08:12:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 14/45] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-15-brijesh.singh@amd.com>
 <CABpDEu=jm43jHhv2mA+C1Sz00xuzH_C-Cn9fRYrFkOCM_em1Fw@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <CABpDEu=jm43jHhv2mA+C1Sz00xuzH_C-Cn9fRYrFkOCM_em1Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:610:75::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccfb663a-cc8f-4a6b-d959-08d9fb8d9a01
X-MS-TrafficTypeDiagnostic: MN2PR12MB4781:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB478111F38CFFCCA26118CECEE5029@MN2PR12MB4781.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDBrBKgL8JfIc51D9pyDlKgHA+fyDkagz5UfLtKYeW0eJ4nBTG7QkpsYWdqQYrLzjKrYoxSCatHf66aNcaGD1m4MgcjoRowr7gnQGl5gQXAhOXByxspofhafHw/j3ItyXBZJFiw+sOHspIPDzjhtt+F8MnE+XsaSV9CPQcuPbd4swa+h10gbXsNAehzysIyT3b+Zq8IwsmuM8VAebv1gAIrUkQGxEcBcy+56NhJRxwVG3djsLVmlGxULleS/1XyD07XJ3rzSwdzoiqjrW3rzERdh8XIaFB25v3cY6PcDfHEqSwnn0RlHzzvAxReMIihqfJPL97YSJInFNXDSZoI8GOIJ3tjGuBROtquC3PSci6Gnyn7ZMPCLovNbrUluOt369N3MAzJZkGZIVdmhCikSkPsCaRueQcOCGmdIdXCyNto3r074plLSAdWzsDp3g0t1mxV+fz8wnl1Safw/igdihPV/U2tAoh2IU97n6V0E+wH8dMMyTwaPIrJDXRz58vdFL1CUGxcfBH/nH8gzunTlUIBNiS/ZEL23svhXxHBfAmdSIZp4FBlB1oSx9xUFjOVj7VlzyadHOl3/NxtTepxP2Uh+DQBMXNyPGvLAmGYjOz0IUJ3fNEfoQzYikbsHS/GinpTU9zDwG94JAoMrXRXkZx16zyxrr/ddR0hs3iVr204Cz7kbb7P0Od14XcKjAIKvQ6xBx8hwFx1RjvWEFjYTdQbVFt7x5IEkLicS9RlVPKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7406005)(7416002)(53546011)(38100700002)(44832011)(4744005)(2616005)(6506007)(6666004)(2906002)(86362001)(31696002)(6512007)(83380400001)(4326008)(316002)(8676002)(66556008)(66476007)(66946007)(6916009)(54906003)(5660300002)(186003)(26005)(8936002)(508600001)(6486002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2VZZ3NkWFJKVkxnVlMrTVJKeGhjbWk1WUlUa0NhNkZXa2R6aGJKeEtMUmZY?=
 =?utf-8?B?Tk5SQXhhdSttYS9XdU5idlQ2VUxVaStvV0FzQnBmdjFOa0cvWWFncktZWjVR?=
 =?utf-8?B?NjhZVExVZW1SeVdQUVlNNjQ5Vks1aHpFMnYwZU00NHE5WmxXb2xBa3cyL2V3?=
 =?utf-8?B?eEdUZkFwUkFSRkdROUYyQmpPbFJmSWJGQkE1YjFqYm9hMnV3di9qS0NTWm1z?=
 =?utf-8?B?VktibDBqVVNZcE02ZUFaWXorcG55THpjaFQwcXRuVXlSTEdpVnNmZTU0RVFx?=
 =?utf-8?B?WGVraFhZTmRpaVEzRGFaNVQvYVdIaUppVlo3bVdxRDF6aGV4akg5eUsxWWJR?=
 =?utf-8?B?ZEkrUWc3Y1VqdFB4RUVXMmgwc2V3Vit1bWF6SlhENE1CbXhXNUVrUzBCUXN1?=
 =?utf-8?B?UlpIM1I4TE5XUDVnRDNSbXJacXVta0EvOVZyVzBjOWJqN3RNTHduaklOVVlZ?=
 =?utf-8?B?Z0l5eVhOY3JuemtnY2NaMWRkMFJxMEhlMEt6R3k5RHdJeTBRZ2JQbC9qWFNX?=
 =?utf-8?B?TzhySjljaTVJb21lRzRkdW1MSW9scmNmUnVEY2hjaFN1SWljR1YzcW8zaHVh?=
 =?utf-8?B?QWZGeFg0bi80anJqUXdZZ1F6bXhrdlJwSGd1S0lDRGkrMXZQVzFvU1hEKzMw?=
 =?utf-8?B?TmdTNmQ4Q2NGeGc1WXBVWXp4Q2VnalVCajYweG5hYldLeExjS1lrUWhEVDFQ?=
 =?utf-8?B?Zml3UTJiNXhvaDFpVHFESTZJb3FndUt6bm94ZzZHZWRjY0E4bWxJY2Y3cnJV?=
 =?utf-8?B?ZW04QUxSa1NaSHFwc3FsM0FvbzNCM0JYaWRMcWNDNjQwV1N4aGZYQjNrM0Fp?=
 =?utf-8?B?TGVpTGJrcDdFOURUOE9XMkhlbDJObWFDZ2FmakNhWmh4L3pSeklhQk9wSnVl?=
 =?utf-8?B?czRDVktvdEZOTVRaWGtlVS81YktEbGM2Y0RhUFczVE5Qb00zYzZWNGxoSnJP?=
 =?utf-8?B?UUNEdXJiWFp3WStKdzJMTHZCVG1yckEwd0ZjKzJndy9LdUFBVERCTDJmWTNm?=
 =?utf-8?B?ODY4SURCNGd1WVYrVjhNUjlieFVPajlDSkpNaEtET0tiL3RraWM1YmVOdmdz?=
 =?utf-8?B?MkgvbWt2aGt1RjVocWxjTjZRZ0xiSHVMcHA5cmNiejJ6cC85VnRBSk5XenR4?=
 =?utf-8?B?aXhtN3N6MFhUb2d0cjdSeGU4Q0NGdDI4blpoSWVVVzVNTXZzUHZHRG5rbnV3?=
 =?utf-8?B?bFlYckZzcDVNTDdxZW9Uai9zQ0ZtOXgwSW9xMkNPWm93RDVjN04xM3I1b0w3?=
 =?utf-8?B?MWJqdlgwOEtXcitGT3Z6UmNIYUtQOUZhZjFYUG9sWGFqejczcFk2S3NydGM3?=
 =?utf-8?B?YjFUS3JDRTBwK21qNENzMjVaTzB5YUJUZEE1NjBnT3hveE0yQXhQZ21wdVBo?=
 =?utf-8?B?dzFrZGEvdDlBZ0RmR004Q3ZDVHhHUHhucjROcDBLV3hXNm5CTFp6aDd1WDB1?=
 =?utf-8?B?ckZKU0xSTytJSnlzWWRTdE1VRVFGcllPd3lwQnpQSDlaK1d1ZGc4dlNrams4?=
 =?utf-8?B?ZjhMaXJ2Ym11dmdzdDI0SHhSL3NYY1M4VGY1RWN2MC8yczFQcUFHcU5GdWFF?=
 =?utf-8?B?ZTBDWXpRUkRXKzZaM3VhK1VQdmZqWFZiRjk1SWF6S1VtT1lxMCt0TlRYQnFw?=
 =?utf-8?B?Wjc0ZmhkWUJVeW1mUXNKZGI4QkZQTFpEem40dTc2cGNTaDV5aE1YOGYxdExl?=
 =?utf-8?B?OWp1aHFMNkR4bDYzZG1va3RlakMxTCswazNYOUlwdC93Q2MxQkoxREhKUkpk?=
 =?utf-8?B?WjQ5bjJNMGYyS1BFbTJ3RVJIaDNXNGczblRodEpaRWR6bU1EM0tIYlFwSXFt?=
 =?utf-8?B?UHhhRmJrbmw4NEJWU3Y5M05uRmpqK3ZacmRsV2IydXZBMEU3VEd6VFBXamVT?=
 =?utf-8?B?aG4wRXNxOUR4KzZKTlkzSktnUkpqQXZ1ZXJNVFM4Vm9KQU56SFdvYWNWcUFp?=
 =?utf-8?B?bURVT3NCVDRWaVgxUkl1am4yTWJDTWZBeGRVV3Q5Z1BqZkpxSWNaWXR3YlJB?=
 =?utf-8?B?dWNKRDRXZnY2dVA5aWVpdWZOTGRwTlVPY2hCWVZNYVNwZ2xGY0YyeTNTampy?=
 =?utf-8?B?aThHY2V3K1hFWTdZMFFJK3h0aUxJMGp5M1FkeHI5NHRhL0NKdjU5T1FYK3M4?=
 =?utf-8?B?ZlN0VjBlWHB0WFlzSzRhNURNbjFUMWZDSWY2ZC9SSWlNUy9HVTFjSHlVLy8x?=
 =?utf-8?Q?TMe8po0+diDLaXER1nRlb9M=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccfb663a-cc8f-4a6b-d959-08d9fb8d9a01
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 14:13:04.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBK9nN0IvivzruFXDINyFp6BuhZt4oybBC8SJBZA/zQX7cglv75GJhYaunM9sRrFHqIem97wWBfz8UjPZLSFsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4781
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alper,

On 2/25/22 12:03, Alper Gun wrote:

>>
>> -               free_pages((unsigned long)sev_es_tmr,
>> -                          get_order(SEV_ES_TMR_SIZE));
>> +               __snp_free_firmware_pages(virt_to_page(sev_es_tmr),
>> +                                         get_order(sev_es_tmr_size),
>> +                                         false);
> Shouldn't there be a check here for snp_inited before calling rmpupdate.
> TMR page can exist even if the SNP is not supported.
> 

Yes, I have this fix in my WIP branch and will be included in the v6.

thanks
