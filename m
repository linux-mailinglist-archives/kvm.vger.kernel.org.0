Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2422C673EB6
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 17:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjASQ05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 11:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjASQ0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 11:26:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3967875BB;
        Thu, 19 Jan 2023 08:26:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctJ9V97F9LD/TbCgqup18vSKQrYok5NY+Iisjxyrga0qYItswi7xdaTSnLaAP7lGwAlEp952M4P7sGuTRt6WNq4Z/vv23Ic5qde7TEmoTcLplo2DRAuz5jmdydjTWu6B1bOWCNlLVVynHvC3uRxpyx6zPv3ORYPxEq/6KRzE62A2EtF6b21nRD3XYQs5Xn54GvvIL7TiN7zoPhRvZ9enalgZiB4yS/n11ZXCrSFW7GKcQ+ssIRxNCt6kIxOVElJNiI3ArkoE0Nd1DMfqCgMhw4mNSrQG+knZeG85Lb8XB1vFJ+Ko0fuMi0vcOO7KC5eNXkCXkxvwiocEISImkt9B2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vruIbLVG+Tuu/GDPV/0LiSTgD1TOFB71/Ot/UCYD8pc=;
 b=VMWSnC/7viXkD6ZQYcj0Hg5Pwd6bCWAxqJs4fSVhRd62Fk7UEzqi4brKtTmPD3vEe6VyUYEbfKWM7ctzXLxhHOLtC+wx38fqIvDnIGkwDLTkuLvrRCGdC20yy5SK/49pjdB8F1WFhl1xOwpvkY6nHHzd+zFyHsIJc96p3CvALoYgGOtdc4lXo+aL2rKEF6PsNmn2f2REbT7QKPGndtbpXscClyuO7Cb9xKLsgV3+dI0fKYSapleXp12jtUMosBBjsYRnJ4ZveqP1qLEXcRnsTEITKXsZxXjxf4zm6kIW9HmtDSOI9ReGfzsKuh61Azi/WrZGmmTawpVvTvXNUVabJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vruIbLVG+Tuu/GDPV/0LiSTgD1TOFB71/Ot/UCYD8pc=;
 b=2VLm5OnOhEhdzgxEdw/xoL6X4nCQfoR2BxKVSwUqzA0i2gt5I7DG7f0KtRwnU65Ri59B6H9u57qGF3O1+G2JDllmaMJCGNrggO4q8HxKsN9p+qPss494c1X8KDPVxiI58r55nFq7agm+weeHI08X4tC6S65r8EU4TNrRgFJtXls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN7PR12MB8004.namprd12.prod.outlook.com (2603:10b6:806:341::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 16:26:48 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.023; Thu, 19 Jan 2023
 16:26:48 +0000
Message-ID: <b960b71c-5e68-a1ab-6dc0-6cfa0619ed93@amd.com>
Date:   Thu, 19 Jan 2023 10:26:42 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 14/64] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To:     Sabin Rapan <sabrapan@amazon.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-15-michael.roth@amd.com>
 <65f056ed-68ab-2541-7c83-3f1712e597ce@amazon.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <65f056ed-68ab-2541-7c83-3f1712e597ce@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR16CA0011.namprd16.prod.outlook.com
 (2603:10b6:610:50::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|SN7PR12MB8004:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d25bfd-df6e-43b3-c39b-08dafa39f60f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Hc1a5xuz1IkFM0SQnzzp6Zi0+pmLeAg5VwEOTX24lVAhKxrrIKIg+IjgieWXUavtCWukuonHhyJylbOTV5WeA2h70P0uYwyPp8gOC3o5LUry7cXKdYCBkdztAPd+Utg69w11vEL+00NbmtmrbR7u7Myu49HFCnZ3zHXROPUEQBwg5+35+78BFOd9FCHEM/nCVEpm/xY0OditP3Q+UCATiCNph1DhOKNBzVej9316MWDIlLDIfo6j1jyerKvQ1tf3isk8YKT+a7AnOKIQeiXcmO51ObQGxtpqb9VPnG+3YVQgcuc97wnJYCh/UTcGX/EqSfLk5LcBQzn/q6owlImv6/g+BzlU2yfrMQPrjFGo8tg6k9jp75V1sKWOOvrRHzVDTKiyJNG16Sx4V+ukKzcS6cIdQ6Ju4EbobvqzzWc9XPNinuTu7no+BFs54aOkpGYjYB2qol+Ag+Q7Dw/3XjraRWAuySJBTyQrEzt1MO+zWYXXbwXgTkMNpDnHlssNLxHkKudkHtv0oIig3NlaYttjnPeSiLBLTUR3eeNUpTbmpZcD9xImGrxYqCYnZiIGNrGl6AmmJ27qqu2O/h+Pa5l+K3Tk6jc/oUTtQh65D7iWDmgxZ5l0l5p5ybNohyqevXQS2gXHCNYWHrseZJ0nKKQEKgCFp3qymxYMoEcNFQOWH4d63m4AdbggvtEmz66S/T9aX4TyK5Ys9kbhzgstSi3iczMBdo+BvVK+jse1nZtFFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199015)(86362001)(6506007)(53546011)(31696002)(6486002)(478600001)(6666004)(36756003)(8936002)(5660300002)(316002)(26005)(38100700002)(4744005)(7406005)(66946007)(7416002)(66476007)(8676002)(4326008)(66556008)(41300700001)(6512007)(186003)(2616005)(2906002)(83380400001)(110136005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elJUU21PQklQaDBmTzNvNjlENHB2OHNVWDdvcEYrR0dQL0x1NjNOMm80S2p1?=
 =?utf-8?B?Sjk0WVFhZ09IS0c3OUozZU1NSzJNU1BGRWdPdW00QUx1Y3B5eEplL2wrQ0c0?=
 =?utf-8?B?UGxiVXhBWnlXNjcrUDRvTExXTmRzdnpCMGI4c2NCSjFFSXJVb1I2RmI0SHFW?=
 =?utf-8?B?WWU0L2ltWkFjcXhEdTBYYzZ3MWlUUFNIMFVkWENVbXhuSUV5STl2QXpQQ2Nx?=
 =?utf-8?B?VnQ5Q3JrL3AyWnhSc1RmeEQvNEFWSW1rTFRUaU1ZbjRhUU9WdndCTHZBMS92?=
 =?utf-8?B?anNFMTI4VFZnK3BKcEpEU0Q2SG5BVnhZTDk5bG96RnE1aDh1RVRoUXlTMHBp?=
 =?utf-8?B?bCt3SklhU0VXdm1MaFdVNDhHd1JzQXhpR1ZmdG1EM2p4SWF1dGE5Z2tYRW9I?=
 =?utf-8?B?Sm1DWDdHVkZJeGxJcUFTdUZPeEdDQkxmR1FRWVVNeHdtQXE4NTFiYTRHM0o0?=
 =?utf-8?B?YUZjOE00U1lyR2tGMHpFQVo4WWpCcVd3UkI2SVl3aXNRS251UzcrUGliTTIx?=
 =?utf-8?B?V0tJeVBJSGNXaDBzTjVNNWNQVkQvYWVWbnNNTE1laU8xdXozdzM2SmU4blB5?=
 =?utf-8?B?NjJoTk16cUtYUjVkNnFPNWtIN0V5ZFF0SDNoZkgrT1NGVjZHRW1Wak4zenN2?=
 =?utf-8?B?QkNDQ3RubEhTU09BK2U1eHlxWTJlaEJJOWdvYVkwcWYyRjZqQ1NxS3Q1NFlQ?=
 =?utf-8?B?ajlRdVRJRWNxb3hac2tydmlXT1NDeWxsaC9FZi9pN3NIdFg0Qk9BY05aZ0U0?=
 =?utf-8?B?eHZ5alhpS1dXWkNXWlVBMnlXNHFDaHV3VXBGSUdMVml5YXNIMFk0ZktZbW1W?=
 =?utf-8?B?UVVqc21CNXdGM2kxRDdTUVJvSUd2bHg1QVhSRFlzT290c0tGSSs4aW9aYWg5?=
 =?utf-8?B?L2lUTzNxbXhRVkQ2WTdOclZXS2hMRkZkVU81M2d3U0xKeHVJT3pMYnRZQ2Fm?=
 =?utf-8?B?T2JvZnA3eDJ1Y3BzL1NCd3lUM1orRk9Qb2k3RUZVNFBsVVlsUXlnM29WYXVh?=
 =?utf-8?B?Nnp4VHhUREZGd2lrUzdaUStMaUVET3RmdFhyLzNBeHRjY1RZNmVrYVU1Sndo?=
 =?utf-8?B?aTdPcTJXMXg3ZkxRN3lGYi96UmVGbDlvRi9ZdFcyREJkUVJOS2dWbW0rZnVo?=
 =?utf-8?B?YUFPanY5S24rdEo2TW1xR0s2a0tJUW5NVWEvTzF1NGdTdmF4dWZXeUI0ZEhM?=
 =?utf-8?B?cTRqUXN0VkJlRVpiU2wwd2pvV3ZUWGJIOVBQUjVmbnRXSzN4NHVYUmFwOSt5?=
 =?utf-8?B?ZmRVR1QwbFVZZjdWRTlzRU5lODNhWXJJVVRkSEZ4QmxleFFLMmtvaVZNZ3JI?=
 =?utf-8?B?bVB0Vm1ETmxtSHVjSWZnU1N5QWRsZkNjZzJoN0huMmJjLzhHeUQrNm8wVVF0?=
 =?utf-8?B?ZWhsN1gzV2dMTUR1aXNqQ3NUVWZRekl0Z045d2kvWHZKa1hoOVE4MlNBc2hD?=
 =?utf-8?B?Z1ppRlhORHY2RTBjZGtya0dBb2tIM2ViQlJ5Ui9wczhXNlowS1E5TWFZTmd2?=
 =?utf-8?B?ODN3SVRBbkJTUE5VWFY5WTczQTl1bWpVZGtCSWhlcUNRQ1hhOWRQbzB3MWF4?=
 =?utf-8?B?bmxTTGNkRDYzVEZDbUsyZW9PakN5WC9vV0hsMlJzL1F4ODk3WHN0ZWN6d0ZD?=
 =?utf-8?B?allQQyt0RTd3REdURVlDOVJMcUtxUCtNeDJ4TzR0WVpmbFJpTlNVY0FRZ2hZ?=
 =?utf-8?B?eDFrMHRhSFkvdWxvaEthZHVHVFdtY3RuUEU0M2RlMjJxMmFJcElSTHNiYUtm?=
 =?utf-8?B?RGQvRVpGS1RiOUt4TGhNRVUveWlLcVBjMjMzd1ZtL205RC9tWjB4QSt1djAz?=
 =?utf-8?B?cHdiOEVManE4VFlrUnh3YjZrcWVEK0lmcjVRZmYybktGdWppOEpEUEtWYWpk?=
 =?utf-8?B?MXYvaWhScFZaUFp2UitoWVBUd01xbmFjb25ISkxkTE1LSU9qUmM3VGt1Vlpp?=
 =?utf-8?B?MS9oNmNrWjFXZTIrWkREZURuYi9ZUmN5eUptbHNvalFPS3hsVUlVRlA4ZnN5?=
 =?utf-8?B?QmI5U2pXbG1oczVJUktuYi95NjRYY3RiZHRiVUlKS21RdlM3anZPNFZOZW5a?=
 =?utf-8?B?V1hKTVlzbk80M251OUhnRTBGQVJsSHhCdmFBKzdTajRNR1hZSXBQT2VKdFRZ?=
 =?utf-8?Q?QNkkpnlzjqxIM7ChTvJJHdpAY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d25bfd-df6e-43b3-c39b-08dafa39f60f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 16:26:47.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p88UHbSlINMAJ71eLoK7V0DWecqKQ0fod7XWMx7ihFo/YLtuCy0mIqI3e6kCc3ZngyEFMj2H0AOWKDIfPmrdFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8004
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/2023 8:50 AM, Sabin Rapan wrote:
> 
> 
> On 14.12.2022 21:40, Michael Roth wrote:
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +# define DISABLE_SEV_SNP       0
>> +#else
>> +# define DISABLE_SEV_SNP       (1 << (X86_FEATURE_SEV_SNP & 31))
>> +#endif
>> +
> 
> Would it make sense to split the SEV-* feature family into their own
> config flag(s) ?
> I'm thinking in the context of SEV-SNP running on systems with
> Transparent SME enabled in the bios. In this case, enabling
> CONFIG_AMD_MEM_ENCRYPT will also enable SME in the kernel, which is a
> bit strange and not necessarily useful.
> Commit 4e2c87949f2b ("crypto: ccp - When TSME and SME both detected
> notify user") highlights it.
> 

Yes, we plan to move the SNP host initialization stuff into a separate 
source file and under a different config flag such as CONFIG_KVM_AMD_SEV
or something.

Thanks,
Ashish
