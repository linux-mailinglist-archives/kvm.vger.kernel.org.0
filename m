Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B635543CA
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 10:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352808AbiFVHdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 03:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350820AbiFVHdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 03:33:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1632237035;
        Wed, 22 Jun 2022 00:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCCeZTQ9ie0nSnuGJnmjHu9JgKD9bIUp1++tVtJ3x1naFFmvxSX9HVm6l9Lb6VLft5uL64pXvjDZVNZkDbbeTkuXohDYJYC+eHWqCU6Er5N2SUmq+4tR3P4J+XDU3Cj4X2KJelWPg+g/w+C71Td9gKxw8cz3mgLOB9rHcgHSW3Mec6kBSVleDL2Sh0jXB29NvN93HaPfJWOGijz87ETHk9xelMTGUeo4j+Q7MiUzFT/7jQqeccnkk/g7QI6GbUFhVEIQCyzWDWwjHN0XXQw2E2zcSHb8hwjonqPdRqJL8H4Tn/Wb72Is3y/YV+Wq5jy/VBR1Wn7cJiVkwgSxMgAVkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhN1Lo5tLDqFXK2Iz6lFsG9WMsqZR5UcXCn2/qUbWR0=;
 b=fpNYdGLStXQxqq2YX3taE0T2D7T7deBj0F/oxaUBu2dLhwCsZGBIJt03OxbV0v24oCk+FPQQKD61Tz003Oh+SRrcKb92F6WtWFAHN2nGuiHEnltXP+5IIQn4obHZu9SKJ88DqtM0MszfbitxFqvRnqGOIliHH9CYAchqc6KE0Ji/eXgNXoicAFoL6kYvVRTm/qZTGqL9QVhxGxjhdjmByuDpMPhQFo4wVEGXOIPXsniNEikea70wjb26CRUECqrD1FBAN+6dmZDkgB6H3KMgVurWtCCqxKPpclbbkIpkoCcU+xVskKEpcex/UBdx7yt95+cE8n1+bqKHMqiPDYdPmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhN1Lo5tLDqFXK2Iz6lFsG9WMsqZR5UcXCn2/qUbWR0=;
 b=J9fud3U8WX4fqyiWBbX+MwAKrzONoyNGQu8kuRVr6p7oV1mP1hWmyXzwls+J4q+n8GP8DLyWT62kT04pND1NrUsx0GfVqwG+W9AAyEOu0VvBAYS9w1+7gRG74lftQD8cRW4H/Gsv1QvOEB5QwA98tgkhaG4FY4N8ZNVuK4Cu31A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM8PR12MB5414.namprd12.prod.outlook.com (2603:10b6:8:3e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Wed, 22 Jun 2022 07:33:34 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::14b:372d:338c:a594%9]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 07:33:34 +0000
Message-ID: <e45beb9c-684a-4485-d6c4-29bc1455c161@amd.com>
Date:   Wed, 22 Jun 2022 14:33:16 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>,
        "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
 <CAMkAt6r+WSYXLZj-Bs5jpo4CR3+H5cpND0GHjsmgPacBK1GH_Q@mail.gmail.com>
 <SN6PR12MB2767A51D40E7F53395770DE58EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6qorwbAXaPaCaSm0SC9o2uQ9ZQzB6s1kBkvAv2D4tkUug@mail.gmail.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <CAMkAt6qorwbAXaPaCaSm0SC9o2uQ9ZQzB6s1kBkvAv2D4tkUug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18b95b09-f6bb-4f90-1046-08da54218355
X-MS-TrafficTypeDiagnostic: DM8PR12MB5414:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB5414204D37B8CAE1A85A9EC9F3B29@DM8PR12MB5414.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9tBPFOT2l1qMwpUmJDiSq/MvDBfiRedsE+I7GcbZTBJT7v/I9QqdzYBbIcLmD1x5HZUrzeOZEl1Cv/7j9uVIEGjEEoIgkbDOHANs5U0qyUWc4124ejaexFvEo+seat4P9iuuNfrqNs2eCl3vmuCEACxwap0u1S8P44GzojXf+UyikZPbymyQSSsAUhnY60GEFmN1E6kk8AkfDLxhT1/GpQFi4k8zXCLw7gMTDh8LSd5gGGznEkQhA4LBHGAo4CDM4794c3ugcfyya3Oa4ri1HBnTUEs5HqdlfCQKjmRpeixCZ0s36vci9kOoIfUJDnGWi2MRG2vDwQUzsAcSWBnrquEyKjtYF1aiVrF/sZ+U4+Y/vuwNx21kRASxf4XsowJ06QBZ1ymEpUzJ3ahypKDvuoYzCJzdjsfj8m3E71wwAfNDdka4o7nJHB67kS5Ntdw/q6kCCOH+H8JCFBYfk6ZmwaLEd/w5gVbXTfYDVdtE7WIOlmMU57OY1DIFeaDM1MMiqeVOzA/efCNUtNYNp2eemGa6G/UsIctGRZvgSS1f1CR7HWZB6a50pCu5syvw+bggvPvdSok3Wjww4NligXms7EmB7YLTSBAboX8n+Vmf7xW8G6R1kXb3roeJV90M+CqDHMV7FPLsnRLFgy8EJEpl7FS6hf1Yp6kBqEp91xlN4JgJq04Dte+zPvSHZSCX0VMMKVmAeOeoM3SoJy3DWfJMOLSZT7LFTkXNXDqo+EsV4EdkO8OytgaqMHbTPxjJ2bpg5cN7zGw9tn5AliJVloaUBbWW/avw0BgDqwdBqfkovjMCjrt/lTmwQ1J4WO1mhTyMB+4AdJNW8b4/7GNJJOC5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(6506007)(6666004)(186003)(6512007)(26005)(7416002)(6636002)(54906003)(31686004)(2616005)(8936002)(31696002)(53546011)(2906002)(5660300002)(316002)(36756003)(7406005)(8676002)(83380400001)(66476007)(38100700002)(66946007)(66556008)(478600001)(41300700001)(110136005)(966005)(4326008)(6486002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkFXR3FqZC9ZQnh3bURzMDE3Vm1wTEhoRXVWS2RidXlmUllJeXZjNjVUNnVO?=
 =?utf-8?B?NHpDTXRQdkp1QjVNZ2xjS0k1b3ZCYzRyM3diK3JtRHZQSzFEK0FMUWFldHlX?=
 =?utf-8?B?bDRDb2tSRG9INW9taThSUXVsVVlIS05FZ0pDVVV0d3I0QWJYb04wMTAra3Vv?=
 =?utf-8?B?K3dGNVdldlhaUmxDdi9sRWhlQmQwdVg0M0ptQmJvYnEvdVFSSW53QnNTSG5i?=
 =?utf-8?B?YWwvUVpSQzVMQ0pWUThtZ1gyNmcreVpTbG1rTjFCT2JndkZkemxjdWt5dnI2?=
 =?utf-8?B?YlVLUTJYNVlxMlJrbk1OR0dSMDJxWjNqYUdSZTZ2Vkd4OXpTR2Z3Y2lsaWVS?=
 =?utf-8?B?ZytBcHVJVDdVbFZBbGV6dENpK2VlaENwbHA2V1hRbEoxRVkwdmE1VW0xS0tY?=
 =?utf-8?B?Y0lXUDBvNStZSTZrL2dxWlluYUxTdDdTRzR2ZXFIK1lBWnNlamE5dmVQUHpF?=
 =?utf-8?B?VGNQNzNDaW1Hb0dyejE5Q0RjMmswZmQweFlsRWw4bllsZHozc2s2RDZvNzNX?=
 =?utf-8?B?TFdmcEFnYjdDeU40cXRDcktEQTcxTFdDZ09CclNGNTh4TzhnVThRSU1wK292?=
 =?utf-8?B?TzdlTzRmZzFsWlBtWWNmMVdHSnNrRVpNeDBGZTBrVmgwbVlIekI3SWdXZmVM?=
 =?utf-8?B?VVdlU2I5aHJjNktLUWNVeGlUVjhicm9uTEQycSs1S1ZkaTRPUUJHaHQ2MU1t?=
 =?utf-8?B?UmJzK3IvUk8weVNma3cxUDFPWktyYXpVam5GYnpQM3kwTm00N0kzNVh1Rlky?=
 =?utf-8?B?ZUdSMk5BakppWXppbjhFcE9COXgwQml3N093RmdZZGRLNTRvSUlOODB5cUlN?=
 =?utf-8?B?Z0NxMitpYm9kdWZhSkpkTFExSzBwaHJOY2FWOU1TZnB3RWtKZUtlTE96eFl2?=
 =?utf-8?B?Rjd4Z0xQaFlXMmx4bWZjcXpZeU15bXhIOGJJQlVhL3pRVkhVL1Q2R24zNkNZ?=
 =?utf-8?B?cjl3ME9pSDVQVHZxMzlUazg0N0N0cjY5UDRJcFdpS2JLNU5yZHFURndYcmx3?=
 =?utf-8?B?akh0UWh4YUZSaWJLRGxaMEZRcVBFM0FIb01tVUY3SkVueWJWelBrb01HbUE2?=
 =?utf-8?B?dTRNdXcvOVZCS1lPU3NteFRtL3I5V1hzY0tFRDJ0VjBocE5sWWlxdkRUWXBm?=
 =?utf-8?B?TGR0aUk4TlFvK1lsdk9JQjVSU3NScit6ZjF3YnM0VkQ3L3A5cmV5MldnZThC?=
 =?utf-8?B?ZkpzV0Rrb3Y4RHVuVDdhZmltVVZaRys3ZkpjbTlham5lZ0dLM05CRUJGeWZt?=
 =?utf-8?B?WENmSjhYL3JkRER5N3gxbHpOTTRLTmtnNDk3RlVNZnl5STNpUGlFdWltbmJr?=
 =?utf-8?B?WHh4N0lhTnNoc0tLbWNZSTVkWmxoUmtPb1Brb2d3ZThrYVZPUjI5am9NcGV3?=
 =?utf-8?B?UU9VZTRIU21vMG5XQXpyWkIwcDVSYS9XUnJnbkk3b1ZaUFo2Sm55YkRJVFFi?=
 =?utf-8?B?UC9QbkQ0czJnWG44ZUI1MGFZZUFmK0RFUDdxbVFLQUZyYXFuREN6VzRDUXA5?=
 =?utf-8?B?bDFMMmZxVVdhNUdFTXJXUFpxQVhyVnYxODlzUXpBVDNUSlMvbFpjQ2R1Q3FC?=
 =?utf-8?B?UytZaE9nY0o2T0tHWXFTTXQ2Wk8yQmhDdHVSamt2SVYvK1ltc0orbXlOT0di?=
 =?utf-8?B?QzB3RzVlVVljMTFvTXRvc214dTQ0VFRJN2hOYWk3S1A5cE5mSjhyNmdGTThO?=
 =?utf-8?B?cUs0cGJyUWVaenhCYUlORzE3SG5VbWIxcEYrdmdiUnhwcHgzZGNwaTBFVXFq?=
 =?utf-8?B?dkgxcVJyVmh3bjlxdTY2em9UdEM1R05PdkhXdGZRbXRhYVY4U3djbS82a3hH?=
 =?utf-8?B?RTdWS3BiWWF0cjRYTHd6azBjSG9sQmZuK2N6T1ZXWHhIbVh2MnAvdkE0YjdH?=
 =?utf-8?B?czJTMzdCOGpQTXFMN3BWaUlPNDM5Ujg3enNqeW5IYkpUUkdsYnFZMU53V2Fy?=
 =?utf-8?B?ZXZaSmhPVThxRUNQQWxxWUE2K1NVSTN4RGJzV2RFbWJRVnBVUWxMRFowZ2Ru?=
 =?utf-8?B?VVJFeW9vZWQwZDZRZU9JVHV1Y1FaVG9EdHB1Z1pUT0N0RmJnT241WDMrZFE4?=
 =?utf-8?B?ckFGc1VCNXBZWlNaMCtZRXpzTld2MzZwTzYrWjdodVBtUHRXRmhobGp3ejV2?=
 =?utf-8?B?N0FDMDFlMEQya3JvV2VMeTZIK3BaSitpMmI1U0lQakxmS2JKTlBsOTNsMklv?=
 =?utf-8?B?cktmakIzWnVvNTRLTU5zQ1pBQndMV3Z2VmtHQmFsOHh1R3M0a0dLbElIdVM4?=
 =?utf-8?B?elBVMG9TVEU4TEVlQlNiS3FWS2RpMzJGd0U0S3NDR1J0OUMydWZWUGxvN3Ns?=
 =?utf-8?B?bTVjOUtpVGl4ZkdGMUU1SFgrNHVYMTF4RjhMZzFoNlRicytDVmRydz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b95b09-f6bb-4f90-1046-08da54218355
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 07:33:34.3671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TE8V4bF5sP8nbJC5aikovDXmDobrNUvCFqB7UWZet4N7/RwjPB/WSUywLs6KDBOA4mVeh3cOz/lubC83+fI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/22/2022 12:50 AM, Peter Gonda wrote:
> On Tue, Jun 21, 2022 at 11:45 AM Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
>>
>> [AMD Official Use Only - General]
>>
>> Hello Peter,
>>
>>>> +bool iommu_sev_snp_supported(void)
>>>> +{
>>>> +       struct amd_iommu *iommu;
>>>> +
>>>> +       /*
>>>> +        * The SEV-SNP support requires that IOMMU must be enabled, and is
>>>> +        * not configured in the passthrough mode.
>>>> +        */
>>>> +       if (no_iommu || iommu_default_passthrough()) {
>>>> +               pr_err("SEV-SNP: IOMMU is either disabled or
>>>> + configured in passthrough mode.\n");
>>
>>> Like below could this say something like snp support is disabled because of iommu settings.
>>
>> Here we may need to be more precise with the error information indicating why SNP is not enabled.
>> Please note that this patch may actually become part of the IOMMU + SNP patch series, where
>> additional checks are done, for example, not enabling SNP if IOMMU v2 page tables are enabled,
>> so precise error information will be useful here.
> 
> I agree we should be more precise. I just thought we should explicitly
> state something like: "SEV-SNP: IOMMU is either disabled or configured
> in passthrough mode, SNP cannot be supported".

I can update this in the other patch series here

https://lists.linuxfoundation.org/pipermail/iommu/2022-June/066399.html

Thank you,
Suravee
