Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46524620D1
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 20:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351709AbhK2Tsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 14:48:39 -0500
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:61793
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234464AbhK2Tqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 14:46:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/8C3PcmO8zokZmid+Uv9cDMVQ9nBZZbxwsPvV4/qh2dlE6GSm1926qs1wX4/yRfB/E8IpvDZ9o1jnekS+muLZoJS6veulp1PvvCELZntrG61w4JC5O3tkS6MqUAgdRo+7ZDp0S/yZbN7AlvGVsJv5MWuAxZNHY6vBp6omcOEf0LUd6ioi5jNjYLhcz8t9aOQVkdyvn3+5clBwj3/sLWz49KhV1+5Piz7x6rdhpA0mNhNTRxtUOqDhCfBO/8vMOzbeiFR/7e8HOOwTD2IIgZydM21qVTj0SLtPu1pzmC8GifVmVV8iwaWF0CqEg00vRFGDiUl19chvF9LyO0z/t2jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vooy8hX7DNyk95LhYHCuwnfygtQ7RFTAVrLgo0MxUz4=;
 b=dmJqQCXUMJxr6GsD1+CM4aHSqLE5cLtEFNvnSfOAVq+7/2HhvGka7XKeFh+mkHnlSZ67+aVJdDOgu63FXIcC9D9fGR/ni+tAnu078MhNIogyqHCUckLwxiiITbERgC9WYcjpvKl08/ECANAtZHHPHkyCJDYKLXQA+whY9TnRAFzv0sLUhy1+w+WdZOZyCOYdQxCiXgl3nokpo7WFu3vulUXrG6BbBwb0KpANNh93sezH10npm4LboVbk7HZsD+ajyLjGdTAAcV2rclSj2nfkdHvTxjc9IGV7NIz24jEmXF4EYwaPzKjEsgBZpteP5lFG/UXTER85l5ZXZiIpX/2tZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vooy8hX7DNyk95LhYHCuwnfygtQ7RFTAVrLgo0MxUz4=;
 b=A4O5LIqc189l8RG2VOvHLFiyuJ0nd+6xOygSn2SVA2C6W7qHqD/QvaCEyc6v1eFd2fHASqNYEs+lg9O5D6RjnhgW+Op/MOnBsm8xUw14e5ZssiCAEy2ZqmzmyiqholoD+pGOLW5OVza/BOC/D3HVSWT19KaMU/QgsiCD13TgdfU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW2PR12MB2539.namprd12.prod.outlook.com (2603:10b6:907:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Mon, 29 Nov
 2021 19:43:19 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::d9d8:7051:7185:6c3c]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::d9d8:7051:7185:6c3c%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 19:43:19 +0000
Subject: Re: [kvm-unit-tests PATCH 10/14] x86: Look up the PTEs rather than
 assuming them
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
References: <20211110212001.3745914-1-aaronlewis@google.com>
 <20211110212001.3745914-11-aaronlewis@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <5a08da0c-e0e1-c823-b9ca-173a15aa341a@amd.com>
Date:   Mon, 29 Nov 2021 13:43:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211110212001.3745914-11-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: BL1PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:208:256::11) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
Received: from [10.236.30.47] (165.204.77.1) by BL1PR13CA0006.namprd13.prod.outlook.com (2603:10b6:208:256::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.9 via Frontend Transport; Mon, 29 Nov 2021 19:43:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3eb1cba-06f1-4651-3923-08d9b3707e44
X-MS-TrafficTypeDiagnostic: MW2PR12MB2539:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2539DCAE65BA9282754305E095669@MW2PR12MB2539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7XItXQwbcOe9d1AkKcTZmdKw2x0UigD26moU0xrL/4uDcQcQ5aj3uItPqND9Y2jo+GWFdhGmYRbwGLa/stF+Oh+3T8Y+lRZHOXLY6xyJJPy3yLwM4fglijm4x4A6r/3nCGSCRnxJx+J0N2yzI6q19Jd918u1LmI9mAN/QH7QlNAmWtams3R81DOA+tm5x3j6jFYGuLiLG9h+c30NB9QFu+hle76AAjaO0yfgY+3LdPUgFi+jT8HqXpL4ZNZeSDAQATd7FKuGyC599m0ODorx4QFsjjqq5wuEZRktIESWisFnbumWRwIOctNyvgiRXP7oAT1dWP5MkhwY+JfM/HBImCw4up08aw0Ge5vbBblAFm09cX2qFuxF/K3VtID44gU8WdMnuiwsFbxiHksGjuNSl8XdXbvV326Ng0iMel5JSXTT12tJoZwsyqNlJAuK1xVByuQTl8MNIUbf6w5k2wy0azZAnQzUR8fEFWEfl0mkdcg+PC4eScDbLUVo/Ukx5gNmQWuaTaTYpLKaVG6YOBZX3SDmNmFu1XvWqzwqX72/Bo6h89Ok2oF6K1QNSahLe2a4QSobfw31ujCKsv7u0OUqjqUH+a6V665S0O/EOoaLuSTOZ6Q/7kuSmr8O0o+kmnZOwkkW0XsDmiSJoAqMiBp8x8LJ5lfBl0HbIGUnrBsKFLOGgyicwq6ZYaNzata0vafCGAOLcIQ11y4m8XNWqJrezC9udpR765cE+VGZEYYMk1Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(16576012)(36756003)(2906002)(83380400001)(38100700002)(508600001)(5660300002)(19627235002)(53546011)(44832011)(4326008)(8676002)(956004)(31686004)(86362001)(26005)(2616005)(66946007)(186003)(8936002)(66476007)(66556008)(6486002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk5sQlJneDNHc29LbVBDSVd4c3p0S3BqdEM0Kzh4a1JRaVNSN01RbXllbEtz?=
 =?utf-8?B?b3pMK3BDWEY3cHF0OFRNRy9CYUQ2NGJ3VnRFY0FiUGY0UzdTazlzZ0dxVzB3?=
 =?utf-8?B?cEgrWnpvdFZmYnBQcnVPSUhVa3psall5SnNxTGZiN3QvbXhpUVdpNGlyWTgy?=
 =?utf-8?B?dVFzUDRJWERLU2g2NmZiR21XdjU5SitQRDBreDRBQVkyYmE3SDZKV29wSVVh?=
 =?utf-8?B?WFVPcWlMbmtRaGFTODQxdmp6dmQ2ZmpiTjFLckFncEF1dXJNUzFMSnVLaE5N?=
 =?utf-8?B?d1p2VDhGVGFzUHI1aTNTV054bVpTbVNFSjk4aHkzYjJ5MlJTWm5uNFBheWFx?=
 =?utf-8?B?ZnJKblQ0TWFlTW03T1dIVUo0RERhR0tVSnRsWjRQOFZqb0gvK1E1YVhTU29V?=
 =?utf-8?B?Y0w4bmJHYzMzeHdZaGowUnE3OXlRTElzMDlZS3lrY3JQYkh2OWp6YVJ6VWhn?=
 =?utf-8?B?elpRL3RuQWJZZWhIc1Z2bXEwdWI0bUFWNkYrR0I5cWdVUFRHL3l3TE00M29Z?=
 =?utf-8?B?dzQ3OWxDREJEVUVrR05LWDE4TzFMYzV0Vk9TcER5VzlYejZhMWNNS09xVnpS?=
 =?utf-8?B?YkZKK2hHQTlLR0s1bXpTK3VBOWc3TTBCa1BhMk5ZREV4TndhWG1jNm5lcHRL?=
 =?utf-8?B?NWRUeDJDZy9EZS9WL2N1S2l3Q0VDN2F4SlA3RkQ1UGFJbENPZlZzTitqcmZR?=
 =?utf-8?B?UkVwWjFXR2dXTVVTbDBweUpXdVNzczBubWVncHdEWDk5M0JsMmZqcUlRSXZ3?=
 =?utf-8?B?VTNzUU03a1BtUmxvdW5LQmd1d3VXWUVjWk9WSnJMZm1ad1FUd0U4M0duam1D?=
 =?utf-8?B?dzR1WllWQVZIdXFoY3c2a3pteFYxK1dudEN5VW82WWtSdlpTcC92bEJ6eFpn?=
 =?utf-8?B?ZDlEUFJZUEJtWDNPa25Jclo0TDdrbms1VkdRcmJSa2xpeU90SHZ4S1EvNWNK?=
 =?utf-8?B?aUo2VDVobDZXVU9KbUhmNlVPQWxZTXIzMnU3a1hwLzc0YURBT2NpVitPWFdm?=
 =?utf-8?B?aCtUZ1RtNlI1Vysrdk4vN0t6ZG0yeExoMXpoTHNsMWw5QmY0VzZCNk5rbDBC?=
 =?utf-8?B?M0FyVEVycnhiME9zbFgwTlRZdDM0VFRxVGJTQnFVeklCbW1DalRxU1huNU9Z?=
 =?utf-8?B?OGFRblRDelhNZjFrSXJQSlNuOUhseC9kcmdQMUVGWFdMM25WMTBTWUtwUVZn?=
 =?utf-8?B?S3hyT2QveUgyTjZ6ZVVkSmJQSDRIbHYwYVc5OFFGK2d1V2RTMWVlWVgxZ21k?=
 =?utf-8?B?clN6dFJ4VFR3L3hUOXVLNFgwMU5qUnlGRmwvUVQxa1JHZGsvTlIrZDIwUmRT?=
 =?utf-8?B?ejJRekwwTFdERkV6VUxGUU1IckFGVU1LbzBWVUxESEluNWFFOUxNMHJxYXo1?=
 =?utf-8?B?cEZFQkpodUdhbEt3bDR5bGZwc016L25DZ0dzMU1KN3lLb3cyMm9Lam9NNW5U?=
 =?utf-8?B?NnVlbnBjZFZ0VWdZUXVJbE5iWE4vcm9IWU9ialladUJMNmRuZWpBYXM2dW10?=
 =?utf-8?B?OUxvbnNxb2huNUhmdXczS0ZMa3lweW82YVVhc3hFQTN5cDFrZkk2QkRLcXlo?=
 =?utf-8?B?Q1MwRWpxOC9CSVVtVnFRdncrVjJJbEtkYktBY05YdHIzanI3dXFsUVRBNHZR?=
 =?utf-8?B?Q2VEQjVqVjZyNEZ2MGxNb1VjNDRUU3cyVHQwUW4yZkhpTmlhUEVmb3BMNnVo?=
 =?utf-8?B?MmVaTkJxa1VHK1ZQcE9sR1p0a0svWVZVZ0pWd2xuY01ERFZwanJNZ0dIcWYr?=
 =?utf-8?B?VjVIaTRBMm5ybEdBSjVaU294S2dwL1MrenFJaG5zdENCLzlHMHRCa3hTTGYw?=
 =?utf-8?B?TzJMWnNhOGRGRzY5YkwwRmNPVkFyNGp1RWtGT055cWhJRW45UlBibnJ2UUNM?=
 =?utf-8?B?RnFhcEkvWC9GNTFIcExwU2lOWXlLTU1mZU82MUdEVWJXbzRsYXdUcGNHQVJt?=
 =?utf-8?B?RGprS21oajBuV1U1SWFPeWpHZ0EzSVVaS2wrdVFVZ2hZYXNtZzh1eTNRcVhF?=
 =?utf-8?B?M0FkYjlZUzM0T0pRYkVuUUc0TU9nTTBFTzgxN04xKzY4RlVHZkwzNzExalRV?=
 =?utf-8?B?ZVFnZ3lONWp1b0Fyc2w2Q3M0L2U4UDJlcWFVMGhoTW13QzFUYjN0SXNBRUZj?=
 =?utf-8?Q?g8r4=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3eb1cba-06f1-4651-3923-08d9b3707e44
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 19:43:18.8662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MU1AINNN7OujyE1Kl9kuhKuFXyau4ZPKLZgUH5mOTUBux3EEBsJbsT6SuNsBMj+W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2539
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch caused the regression. Here is the failure. Failure seems to
happen only on 5-level paging. Still investigating.. Let me know if you
have any idea,

#./tests/access
BUILD_HEAD=f3e081d7
timeout -k 1s --foreground 180 /usr/local/bin/qemu-system-x86_64
--no-reboot -nodefaults -device pc-testdev

-device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio
-device pci-testdev -machine accel=kvm

-kernel /tmp/tmp.w1JL6jhyfN -smp 1 -cpu max # -initrd /tmp/tmp.9coF1FJSwD
enabling apic
starting test

starting 5-level paging test.

run
............................FAIL access

=============================

Git bisect log.

 git bisect log
git bisect start
# bad: [68aa4e32f2b717b991e4dce7dfdde2247366abbc] x86: do not run
vmx_pf_exception_test twice
git bisect bad 68aa4e32f2b717b991e4dce7dfdde2247366abbc
# good: [c90c646d7381c99ac7d9d7812bd8535214458978] access: treat NX as
reserved if EFER.NXE=0
git bisect good c90c646d7381c99ac7d9d7812bd8535214458978
# good: [c90c646d7381c99ac7d9d7812bd8535214458978] access: treat NX as
reserved if EFER.NXE=0
git bisect good c90c646d7381c99ac7d9d7812bd8535214458978
# good: [c73cc92d8060dd79b71cbd2ded1454a6e924b771] s390x: uv-host: Fence a
destroy cpu test on z15
git bisect good c73cc92d8060dd79b71cbd2ded1454a6e924b771
# good: [c73cc92d8060dd79b71cbd2ded1454a6e924b771] s390x: uv-host: Fence a
destroy cpu test on z15
git bisect good c73cc92d8060dd79b71cbd2ded1454a6e924b771
# good: [2e88ad238a19253b94e9f410e4c86ed632c134a0] unify field names and
definitions for GDT descriptors
git bisect good 2e88ad238a19253b94e9f410e4c86ed632c134a0
# good: [91abf0b9aa0bac4ca17df0be63871ca6e1562eac] Merge branch
'gdt-idt-cleanup' into master
git bisect good 91abf0b9aa0bac4ca17df0be63871ca6e1562eac
# bad: [0f10d9aea13631a414a3023699dd2dfd47dfd02f] x86: Prepare access test
for running in L2
git bisect bad 0f10d9aea13631a414a3023699dd2dfd47dfd02f
# good: [7a14c1d9468626d4cdd0d883097c7caaa36a91bf] x86: Fix operand size
for lldt
git bisect good 7a14c1d9468626d4cdd0d883097c7caaa36a91bf
# bad: [f3e081d74812ee05be7e744eb8be3f04a2f65c87] x86: Look up the PTEs
rather than assuming them
git bisect bad f3e081d74812ee05be7e744eb8be3f04a2f65c87
# good: [f7599ce50db691c4281479002f03d611927bed1c] x86: Add a regression
test for L1 LDTR persistence bug
git bisect good f7599ce50db691c4281479002f03d611927bed1c
# first bad commit: [f3e081d74812ee05be7e744eb8be3f04a2f65c87] x86: Look
up the PTEs rather than assuming them

Thanks

Babu


On 11/10/21 3:19 PM, Aaron Lewis wrote:
> Rather than assuming which PTEs the SMEP test runs on, look them up to
> ensure they are correct.  If this test were to run on a different page
> table (ie: run in an L2 test) the wrong PTEs would be set.  Switch to
> looking up the PTEs to avoid this from happening.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  lib/libcflat.h |  1 +
>  lib/x86/vm.c   | 21 +++++++++++++++++++++
>  lib/x86/vm.h   |  3 +++
>  x86/access.c   | 26 ++++++++++++++++++--------
>  x86/cstart64.S |  1 -
>  x86/flat.lds   |  1 +
>  6 files changed, 44 insertions(+), 9 deletions(-)
>
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 9bb7e08..c1fd31f 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -35,6 +35,7 @@
>  #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
>  #define __ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
>  #define ALIGN(x, a)		__ALIGN((x), (a))
> +#define ALIGN_DOWN(x, a)	__ALIGN((x) - ((a) - 1), (a))
>  #define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
>  
>  #define MIN(a, b)		((a) < (b) ? (a) : (b))
> diff --git a/lib/x86/vm.c b/lib/x86/vm.c
> index 5cd2ee4..6a70ef6 100644
> --- a/lib/x86/vm.c
> +++ b/lib/x86/vm.c
> @@ -281,3 +281,24 @@ void force_4k_page(void *addr)
>  	if (pte & PT_PAGE_SIZE_MASK)
>  		split_large_page(ptep, 2);
>  }
> +
> +/*
> + * Call the callback on each page from virt to virt + len.
> + */
> +void walk_pte(void *virt, size_t len, pte_callback_t callback)
> +{
> +    pgd_t *cr3 = current_page_table();
> +    uintptr_t start = (uintptr_t)virt;
> +    uintptr_t end = (uintptr_t)virt + len;
> +    struct pte_search search;
> +    size_t page_size;
> +    uintptr_t curr;
> +
> +    for (curr = start; curr < end; curr = ALIGN_DOWN(curr + page_size, page_size)) {
> +        search = find_pte_level(cr3, (void *)curr, 1);
> +        assert(found_leaf_pte(search));
> +        page_size = 1ul << PGDIR_BITS(search.level);
> +
> +        callback(search, (void *)curr);
> +    }
> +}
> diff --git a/lib/x86/vm.h b/lib/x86/vm.h
> index d9753c3..4c6dff9 100644
> --- a/lib/x86/vm.h
> +++ b/lib/x86/vm.h
> @@ -52,4 +52,7 @@ struct vm_vcpu_info {
>          u64 cr0;
>  };
>  
> +typedef void (*pte_callback_t)(struct pte_search search, void *va);
> +void walk_pte(void *virt, size_t len, pte_callback_t callback);
> +
>  #endif
> diff --git a/x86/access.c b/x86/access.c
> index a781a0c..8e3a718 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -201,10 +201,24 @@ static void set_cr0_wp(int wp)
>      }
>  }
>  
> +static void clear_user_mask(struct pte_search search, void *va)
> +{
> +	*search.pte &= ~PT_USER_MASK;
> +}
> +
> +static void set_user_mask(struct pte_search search, void *va)
> +{
> +	*search.pte |= PT_USER_MASK;
> +
> +	/* Flush to avoid spurious #PF */
> +	invlpg(va);
> +}
> +
>  static unsigned set_cr4_smep(int smep)
>  {
> +    extern char stext, etext;
> +    size_t len = (size_t)&etext - (size_t)&stext;
>      unsigned long cr4 = shadow_cr4;
> -    extern u64 ptl2[];
>      unsigned r;
>  
>      cr4 &= ~CR4_SMEP_MASK;
> @@ -214,14 +228,10 @@ static unsigned set_cr4_smep(int smep)
>          return 0;
>  
>      if (smep)
> -        ptl2[2] &= ~PT_USER_MASK;
> +        walk_pte(&stext, len, clear_user_mask);
>      r = write_cr4_checking(cr4);
> -    if (r || !smep) {
> -        ptl2[2] |= PT_USER_MASK;
> -
> -	/* Flush to avoid spurious #PF */
> -	invlpg((void *)(2 << 21));
> -    }
> +    if (r || !smep)
> +        walk_pte(&stext, len, set_user_mask);
>      if (!r)
>          shadow_cr4 = cr4;
>      return r;
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index ddb83a0..ff79ae7 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -17,7 +17,6 @@ stacktop:
>  .data
>  
>  .align 4096
> -.globl ptl2
>  ptl2:
>  i = 0
>  	.rept 512 * 4
> diff --git a/x86/flat.lds b/x86/flat.lds
> index a278b56..337bc44 100644
> --- a/x86/flat.lds
> +++ b/x86/flat.lds
> @@ -3,6 +3,7 @@ SECTIONS
>      . = 4M + SIZEOF_HEADERS;
>      stext = .;
>      .text : { *(.init) *(.text) *(.text.*) }
> +    etext = .;
>      . = ALIGN(4K);
>      .data : {
>            *(.data)

-- 
Thanks
Babu Moger

