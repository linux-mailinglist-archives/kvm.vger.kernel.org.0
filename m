Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7AF47A427
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 05:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhLTEyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 23:54:02 -0500
Received: from mail-bn8nam08on2048.outbound.protection.outlook.com ([40.107.100.48]:30176
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234032AbhLTEx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Dec 2021 23:53:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQgCusx5xa1T4qwuUloSM/anO/rRA8Z8jozoN8T4evyStO6fLmJQj9S2U7j+g266uyJaQK1YliRLxmYuZKCeP3Vh3TrIuSPlDvVJn4yJLPrJAWyhoH2cIlemfQTvW3+gfkww0ikvSp51PU0vsSLKqx1nMg/fFoFPwAU92JDbHgxZDJYEW0puJy6VleNE+368hMJCzrabXooezry9omz3jfRHX1Aujvf8O24XfUXlaZIQAop3mmeUlkwWfwF2O+t4SJzf7QXA/KNrQ11zLakrMdJyJR58sbB/3uFqf7j2jkXhg52mBK+u8NpIs21ecARwGdc2VhgFieKIeKsuydVKEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxa2PguzPiE/pilqW7zUZ6BS7/yiwRzMSKyxoeKCTvQ=;
 b=Le+f8teNSHt9wfl5jns/voj5aoQp0k/dimd+JF51bCj880qEdxNXHDHCZ0r3bkdZVYNeKTngplf+cn2w2SZSwmXTw2+yclGwn0klpt9UeNF3ytfd4PwisvjFiEqsrekIMp6hYn6pjXABmmSBIlVvCas64ZaN4VfAAbkfVoG6+xqgUhYgwvSS0LQ0Y/zXT19lqV+CXmrGpPrXVLCA4oSUjLC9TTzGOPDn+M1NeAVbCZsz9A5eTPZ6ZSl5ulF0WBHfLP5CBld7V0esWRD1R/R1kZCTRKHutWHokIUaVg+pyGal/I0ngbZaVUq896/UhS8EK5YHu/aTUYx6xIyJP/UCLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxa2PguzPiE/pilqW7zUZ6BS7/yiwRzMSKyxoeKCTvQ=;
 b=EcfCZ5i/wigySBPtpNgK7IkY9ny+GNCUGClZKVFKnElRX+iIOPMKfJT4HSFuVXIi97Vdp/Zox6Bsj7XzFWjocKJxZ6eNFdvtLdkkP/85634KNu3RDGx+LsyglWa9Xv001NU/9EQCE+om38bYb1//AkKIybhPCXA03sZrVqaB/b0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5325.namprd12.prod.outlook.com (2603:10b6:5:39e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.17; Mon, 20 Dec 2021 04:53:57 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::998d:b63d:91a1:e4ac]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::998d:b63d:91a1:e4ac%3]) with mapi id 15.20.4801.017; Mon, 20 Dec 2021
 04:53:57 +0000
Message-ID: <81c268df-af27-33b2-5a07-5a559ca0bead@amd.com>
Date:   Mon, 20 Dec 2021 11:53:43 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v3 0/3] svm: avic: Allow AVIC support on system w/
 physical APIC ID > 255
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, seanjc@google.com,
        mlevitsk@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, peterz@infradead.org, hpa@zytor.com,
        thomas.lendacky@amd.com, jon.grimm@amd.com
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:3:18::25) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e57482a-9cc4-4dfe-7c9f-08d9c374baee
X-MS-TrafficTypeDiagnostic: DM4PR12MB5325:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53253CD8F8AE453CB0D472C4F37B9@DM4PR12MB5325.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jp/oLSbSAkukmjqyefhKktPKTi6m4GvqS07SuSUWyR2bV8tgfEKnNGRGPegJGBNPANN2XPf7oxbWXXv5RSjcKgM42hvbwxw1Jl4uRjyAF6AmVNvZkPNpxQxPBdKejpIqJNxbTeuJ+ZyQ8n8Og5sDLcDzkOK5NBE5mYbOprzwiCCkTm2Vikbe9JyQ7EKUQ1/NRf8mcSvkc/5SHe33QlSqicvC6I7WJ68tEbCQJKY4KKc+M2aiJU876dqEsdz3ozNul9Rb3iSFziTMsgfb1yNC07Wad/ly+RkJyTT1N9smj14mtIpWeKferqnS0y/CBjjTt+rYy3NlakpmJWDAJDQ8FADxzK9a5d1+H6DdVT61AK1pnVB7qNrkfVlNNyLQ90jr34+8jh3QImhGB9yfBRmdXEnfV8EgCItvKzg83lxQ4KLsjyBI2P9cEnJ60j2/UTclQB2/y86ESy5/LHJ05f88q7vVkTw/GpH7mPLgWPsUGqX/83ACNVehLmW1JdpKhQl/BoCFmXML3OQg7Xp/m2IwWf64mD86qzTisLedaIWleJF0WImTXg+b4v89JosUIzRIxFJD0z3suWUkPtqyaYElKHOz2gSVoTZIJigTY4vhpmBhYU/0+UNhGsI+Cp2Zv+P4lUAdOIx6QQHxH0m7zHs1nH4Fv/Vj6sUmogJO/qyD9OxCtHoodsSRy1FIY5r0V240Zi5SOuZnpiFgk5+Ol3Ks5362HmOhhSXF52H6T1uuq/glDnb/2Avuz2xJ7Gli+4N1VDRaSyOs2gQlCtZpeUzd0iJuuV0CR0PsbM6bdvV1HLMG3OFViBIkE7eZXsRVnKdc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(26005)(4326008)(66476007)(2616005)(66946007)(86362001)(508600001)(6512007)(7416002)(83380400001)(8676002)(36756003)(2906002)(186003)(8936002)(316002)(6666004)(66556008)(44832011)(5660300002)(31686004)(6486002)(53546011)(6506007)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHJUNEN6c3M3QlgxZno2Ly8wVTlhM2ZMRWVSZmhPSFFGaUphNmNibE0xVDFn?=
 =?utf-8?B?SCtFbnd1RFMyV2pOSlBscXp5dis4UTgyakFKM2p4OFE3enVLMTVrbEUwanZ1?=
 =?utf-8?B?bVdqN1A5dDROejdTaGx1SXhmQlQ1bmxUQWx3QitQMU12V1hKQks1dFRMODc4?=
 =?utf-8?B?b3ZxY0tWbVBwazNFcms3eTcwb0pHZGtrd2IwMEVlME5iNFFDMnZqYkZIQVZk?=
 =?utf-8?B?eFJGWStiTk1nR3FiVytMa1JzVmY2ZnF0Tmp6U2hWUGJwbG02dUZWYVRmRWkv?=
 =?utf-8?B?Y3BBelk3WSt6SzhuQkhiV3h5TXJDUGpPQWVPdFZuaG9KY1ZhY09TQ2s3ejFQ?=
 =?utf-8?B?ZGpKN3FqMXdLTi9QN0hSbUJJY3I4azFab29Ed3c3Q1pjL0FNVVAyOXJCWEtR?=
 =?utf-8?B?SFA2U2l2OVB2KzVKKzl1MGR3MzNjRmZQbm9lNVA4eEtHQjIxcGRGR282NVZI?=
 =?utf-8?B?MTVrMEY0ajNqUTZlcDM0WWp4am9aaGJUQzVGclBPVXlHYTJoWGgzMmcrbGJU?=
 =?utf-8?B?TlNVcnFRTnpNSU9oVjRSaDJ1a1JlMXA3VWRiT200ZFRFYy9YNlB6NzFzOGha?=
 =?utf-8?B?VFYySnVIc3hRY0M4TDdNb25oUTJjVVVtSFJ4TmNwaWxDUWZkZis1bU4xU0d4?=
 =?utf-8?B?WGxJL0pNdCtSd29uZENOQ2hEZlcydlFFcitsMTBNQXFwMlJaVi8zb3Via1Mx?=
 =?utf-8?B?NHVyT3kxNGtzZHF0TnFnTyt4RGFQTUpNd1JIa05wT2FUdlZiNHBCbUp3empJ?=
 =?utf-8?B?aEdoRkR0aW55Z0NrKzU2bE9NS2MxMkNOZ3padmhrczFOUmRaQXN3eU02dHBp?=
 =?utf-8?B?ZHpubkxuV0svd09sU2o0aCtsb0p0a2ZQcFMzUkI3TmlUb1JiSXhLNm0zMGZE?=
 =?utf-8?B?VWt4VFdLL0xnZDZ4SmNSRitUZ0Q5WGJBVkQ1L0IxMFc0UDJCV2thU3NkNXNs?=
 =?utf-8?B?VlFuMTB0WXNSU3lNVmJHd3l6a1ZGL1VnSjF6MWN5T2tPS0dKK1lLZUlPZkdu?=
 =?utf-8?B?Zmg0YlpRd0pvK21Dc3JHdzZJd1ZzcFlMdUF3Uld5VmJQdnk4bkZrY2NXN014?=
 =?utf-8?B?L3BCNkgxY0hRN3NReDk1MXQxYTVWeXlab0R0MlNsU0trQWtYU21QTzhyaWxo?=
 =?utf-8?B?aGo2WmZkdlBsRFNwOXBQdU5VcitIVEpGbHVzV2xkNEI0VEV6eWFGUTVQR3Jo?=
 =?utf-8?B?d1RzUW90QStGWmdrQTUrdCtYQ3hQQ1YvVEZwdmlxOGhxeFJ0WlVaSXl5Z09u?=
 =?utf-8?B?c0RPbjgyMEo0V0RwYnZyRUloNDNlZzczQStzekFDMExDcnpGL2tlVFNRaVNV?=
 =?utf-8?B?cVRUY1FFZkZQN3o4V285S1VyRGs1QTlwRkhITG5zUENJaEVUVjd3a3VqUGRi?=
 =?utf-8?B?QjZFcndjaW5lNzE1dWRlWHE5VlU2anVYM2pwemFLWnhYWmdyajJhZjhJK1c1?=
 =?utf-8?B?NncyeEV4NGNONy9jNGRCT0tNbDcra0ZzK3J4OVRjdTZWV1NVY0twVjRPU2lJ?=
 =?utf-8?B?VGpVUXhCamQ3QUdmQ2VQTW5HOGllVkQxalJOMDBmenBVZ2x3NUM0TVRJbHhm?=
 =?utf-8?B?UUN0Szdxc2U1YzVJNVd2VEZZWUJlMDVhenRHcmROQ2lRcmZ1MGNPMTV0K2Zk?=
 =?utf-8?B?U3NGQlkvSVpvWFNPak1tbGE3dDVhS1RpMTdXdGFLU2wzR1JYSEVNYVZoZjY3?=
 =?utf-8?B?QUs0SDU2enZIbEFXRDNWenF6blZRaDV3b1hUS3NnTnlhSURnNERwWG9LVjlB?=
 =?utf-8?B?L2FTSm1IclZMbDRYTDdhODBvRnBVOUJ2TVlncmQ0SXNITm1RSGlVZFA5QzJr?=
 =?utf-8?B?VE1rdk10MVh0QlF5aVM0eDVId2FKazg5Zm9lU3pmMFRuODNma3o4VVFLKzQx?=
 =?utf-8?B?ZGlQcko1ZmFYT1lMU254RnN1WUFIUGJJemdlYy8zSFQ5b01NSUd2NFgzMG12?=
 =?utf-8?B?YnBuVkprSnpvc3pjQ1dwMG1nZkpPN0ZWSklYWTExQi9CT0xacVFtRXZLTjdS?=
 =?utf-8?B?VnFnVTBZKzlrNkNVbTAxT3lscEdtc2U3cDFsUFRBSDluL2UwU21iUUhvODBp?=
 =?utf-8?B?ZXRJOXdGTVhBbm4ycmNjZzY0QU1tVkkzRkFiWGg0SjdpTDcybWlJekV4ZWls?=
 =?utf-8?B?VFRFL1NqVGRFYVp5TDBnU1dVZ3RYVnlmRExFVU0rVDlYd0NEMG04NjlVTnJM?=
 =?utf-8?Q?Gx1m9w0LoXIdsuoQWdIW1DY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e57482a-9cc4-4dfe-7c9f-08d9c374baee
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 04:53:57.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMV2IZciJtiDRRM5sBcScy1JafBmXyJhNtiUe1Hn1VDduUcguFssoGxh5mRzwEB+t7MvrguVnFy/JA3Eo1teQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5325
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Are there any other concerns with this series?

Regards,
Suravee

On 12/13/21 6:31 PM, Suravee Suthikulpanit wrote:
> Originally, AMD SVM AVIC supports 8-bit host physical APIC ID.
> However, newer AMD systems can have physical APIC ID larger than 255,
> and AVIC hardware has been extended to support upto the maximum physical
> APIC ID available in the system.
> 
> This series introduces a helper function in the APIC subsystem to get
> the maximum physical APIC ID allowing the SVM AVIC driver to calculate
> the number of bits to program the host physical APIC ID in the AVIC
> physical APIC ID table entry.
> 
> Regards,
> Suravee Suthikulpanit
> 
> Changes from V2 (https://www.spinics.net/lists/kvm/msg261351.html)
> 
>   * Use global variable npt_enabled instead (patch 1/3)
> 
>   * Use BIT_ULL() instead of BIT() since avic_host_physical_id_mask
>     is 64-bit value (patch 3/3)
> 
> Suravee Suthikulpanit (3):
>    KVM: SVM: Refactor AVIC hardware setup logic into helper function
>    x86/apic: Add helper function to get maximum physical APIC ID
>    KVM: SVM: Extend host physical APIC ID field to support more than
>      8-bit
> 
>   arch/x86/include/asm/apic.h |  1 +
>   arch/x86/kernel/apic/apic.c |  6 ++++++
>   arch/x86/kvm/svm/avic.c     | 38 +++++++++++++++++++++++++++++--------
>   arch/x86/kvm/svm/svm.c      |  8 +-------
>   arch/x86/kvm/svm/svm.h      |  2 +-
>   5 files changed, 39 insertions(+), 16 deletions(-)
> 
