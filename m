Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75B2390446
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 16:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhEYOs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 10:48:58 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:62404
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232939AbhEYOs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 10:48:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFyB4skyLJTaRldSRN+xBU56TaN9Zo4Fl7agSMOT7nimP9EQY5RxdxCd1AT3bZ70zlFbZ3nTcGUH+w9igL1Wf0vi9Hgvwrgt8Cs331c290bIyX+vQDxclZQQzVvTlFlqGgLiXNS1Kx5sWnU2H8MPKtmSenau9MrPP8tPaTSJiUEA5Zb76gywfzfD9JL7aYR7NSwVVTrUp4GPVcWaVzJNCxXUXoGhLtI3RbYr146JYe5V1Vsw6kVjdrO4U2O7ViGRbZ0XJidIQ5c/wdQv/wx3snu2OrxENzW6xWfTWu+dwCKhxLC0a8KrXLc+TXIgwHTzF4d7IZcmyUptIjUNtid2Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toVhVM1zxIj1a1fuV2lvGlAwebaTd3jU/xY6r7AK1wk=;
 b=MXZhC/gdsa8kfNoOJs6askRWa37g+E3w6jhooj19WeiKA3SpQFzMtkwnE7hvKpXsEUDEn90VYQXbsiOSW0IF3I9Py/sOy9UpvnH4Pk4zbzVjWGjC803/TyXokdWUm4F6NxnDmF3XOV0vzvFUkdnl3oEg6xSPZsIHL5grMLxqRg4LSvWfolb9eBzX+uei7N62fmWkB079Tx7NNF06k34gAefLyAhEw88GaIu+hlifB/cHkxUujidrjxJb3CnrmJ31Uw2Ev6tI1KySYC+Af94jSd/t4fHMdhi5NUJR7gZpniUF2pejdORijqNmlH6shLAWagXevigFv8HKEPyKVh7GwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toVhVM1zxIj1a1fuV2lvGlAwebaTd3jU/xY6r7AK1wk=;
 b=o+tpjsaVDjlruZKbrvm71/tuoHXDKKPrsQJG7yv2ND/z6Aus9xeX0Z4oMiH+91x/wUMthnS74d0TfXnKVH843/vFWXciRzChA9VeTQx57gjbyDVHOAq8B+8kQQJwRDCTPwn6I4epjKV1Cn1J4xq/Yk6aVOHE45tqxsQDkyGY5pI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 25 May
 2021 14:47:26 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Tue, 25 May 2021
 14:47:26 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 13/20] x86/sev: Register GHCB memory when
 SEV-SNP is active
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-14-brijesh.singh@amd.com> <YKzbfwD6nHL7ChcJ@zn.tnic>
 <b15cd25b-ee69-237d-9044-84fba2cf4bb2@amd.com> <YK0LFk3xMjfirG9E@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <9e7b7406-ec24-2991-3577-ce7da61a61ca@amd.com>
Date:   Tue, 25 May 2021 09:47:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YK0LFk3xMjfirG9E@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA9PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:806:6e::12) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA9PR11CA0007.namprd11.prod.outlook.com (2603:10b6:806:6e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Tue, 25 May 2021 14:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c009e932-1c34-481e-023a-08d91f8c0344
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382BDE0EFF4CF024AD2FDE6E5259@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3V5t6b4BQFWVwTcouEdROWRZ8LpOdkDuSe2YX76ABw9MAplemiUR+E0td+w4l1F1lxPD4lbfTtgMlGkj326C1RShRZ8ZzjXiq7xmBGOOTNRL4MSZ+7EwDCGgr4mfoB9Q+LKRCQTsCVSW1i8KBSOGdYOwP8bF9RjrQYNloU76wBEgPsEX8KeKGSIhlpcqnoFjwi/yjvgNmkaI/u2DxSU/dnUZao6JwcBeR0hBOz4DV+ak4RzcFBrCUeTCwMzR5UC4L681enYsZ/0dQEVh3Oe9gDMESwu1+TKLlKDildRiD0SzfHP9iwb0OnUXAdXLNkF/yOPwfpMeAVEyNXrGCmNouPFuhSPOT6MYxV1VUBe47zEhxhvd0c/Y7l+zSlzLcvOM1NIs6+Pkz845c73dBciDARJ0y7whK9PL3aHJuO4EUwQlvk02xP4cmhkw3SRrRpnHSe9DuzhsuSW8YIsFXZiObyW3P6UG7DhqdH96NMvUEwo9oxBMQWKZizoh+s5zMQSDuZvemFgGBGVKDNzw9tA1BoDTkM5jDF4bXggvVjPv25SkM2sWyJ3Gsz+dJQ+g0XKhXUrSGEt1PVbygYeuW39NV6CR2bCZbZ3VxiUPQFRtV6EDi8Gynq1VEvDlYetY674MUojEjAarDR2gN5xgRkpeW+9b57HCKaS1rRAQN4ZBZOHO2P/y+2iOkMcLCrNFs9F2j5ew2sdXOG3DWFNpomRIOvB+ggg7GKVo0f1vpN8tawE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(52116002)(2616005)(44832011)(86362001)(956004)(31696002)(4744005)(16526019)(186003)(316002)(31686004)(26005)(6506007)(53546011)(5660300002)(7416002)(38100700002)(36756003)(6512007)(38350700002)(8676002)(6916009)(6486002)(4326008)(2906002)(8936002)(66476007)(478600001)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q21VeTkvQVFjY3V0c1dnckxBMVArMmxiNkl2ZUxvbFJ3K2NNOHd0Skl2QXVO?=
 =?utf-8?B?U3lJT2c3QnNFUjVFWFZ6T2pieUU2UTZaV2djK0FId2JhRGw2SkZYNHd1TE40?=
 =?utf-8?B?RDd3dmhoVklUOXdWcFRtYVVxNytHWUIyc253Z0crcmVVT1NjUzZwRGhQcDFH?=
 =?utf-8?B?eHNVeDdtU3BFTGt2ZGxheHJJbGwxSElWelBaSVBBWCtLalZGUDZ0bGNqbDFy?=
 =?utf-8?B?UXBCbG4zNG5pS2QrTlJXWm5kMGhNQ2RyMk9kZHB2S3d5MHJjSUpUNmhuSUg2?=
 =?utf-8?B?YUptS1hjWkd1YU5BNlJmNkNOOVp1OThZbHVZSVhqTkRzYjloUnNSVEwwT0R2?=
 =?utf-8?B?STRZWG91NVF0MWw2V0lVdGQ0dHNlZmc3T3pHMTRwbjFkZ29rczlMS3RPTnVl?=
 =?utf-8?B?VDN4MzgxeGttaExSY3ZXNnhHZnJCTE40WE5CWWVNNlVBUjgrT0syeEVKN1Aw?=
 =?utf-8?B?RFpnV0JmaWY1a3hYMFNrVE5WL0gvVHEvR2dUR1A1eGVDaGcrUkpQZjZDdEI5?=
 =?utf-8?B?S21zOXZJNlZ1blZCMWdBSGR4Q0d6Y1ZQTGlsWDAvVFFpYVlGTGFQRnkxUHZD?=
 =?utf-8?B?d0h6dHZNaFdaVXo3cDhtN09yL1l2MmtsaDlGK1dqazFsd2xaVlhPM0VHZnhD?=
 =?utf-8?B?OUovWXVXTklWSCtFQTdMMzZkYmhZclJud3VNNGY2M05VelZMU284Q1lpdmdT?=
 =?utf-8?B?Y080d085V3RCMGhkTmJ0OER5OEFvY2JMZDhJb1Y5U1o1VU8zTWRKYlRJemV2?=
 =?utf-8?B?a3Z1S2RnV1Z0QlJkQXc4VlcyVWNKck1rSmc3K3JxT1NmZnBTL1RFVm5ucU1Z?=
 =?utf-8?B?NTRPZm9CNUVxdGpMVFFtcmlvczloK0gxamhGQmVlMDZRZW1yNlBxMHBPalg5?=
 =?utf-8?B?djdYRURuNkZFK0dEYnZkNmpQTnYwYlZDRXlScFBXRmVuL2dZSGd5T1N5QkhJ?=
 =?utf-8?B?TVhkcXNJZ21hRnJqVnF1clNJQVM5Sm43RFliSG1iVnkwSnRIZkVzT04xRGsx?=
 =?utf-8?B?SnZiWWhNcXprekh6YzhZbjNRWUgxM252RWxvVEFsMzBUNXFGcnlBWENaTHZW?=
 =?utf-8?B?OUs0MmJSWjNUZm9pQjBtOTdDTTNQUTJaRU8rQkttNWF2Z3VyUHlhaXZqRWdq?=
 =?utf-8?B?QlFscWtiSzU2SWtkOFNZK3FlVzEzVE5qc1QzbXl0bEJhM0M1ODBZV1BXMlBI?=
 =?utf-8?B?Y0VlaUtndE5XOGtEMFRHd1ZUbmtFMTRSTVZ4Zmh5bm1oY29CcVVPVmJXQkhP?=
 =?utf-8?B?cVd0aWlQU29BTGhsdE5aV09tU0YwRmU0aTBkSmtKS0hRUGx1b3AvM1l4REtM?=
 =?utf-8?B?RXhKYS9vQ2pXdkk5ZlV1N3NmTlFmM2RsYXVTUlNiNUZKMmRKYi84MFhzdlFi?=
 =?utf-8?B?ajlPZHk2Vit3ak9FNDJ1bldEZURtbkVJZjd4MHczUVRaUFhvODE1SkROeVNt?=
 =?utf-8?B?LzkrNno5WWVWcnpIWjc0SXpVdFEzM2ExdWdqbVVHUUlxZ0ZKZlljWmFSeVJR?=
 =?utf-8?B?RlBYNVNxWWVjcTVxclRsTlBURHRCMitpZlFxYnF1RHBoYnBHcGZKeDVKQUJa?=
 =?utf-8?B?M1pUL0NpZHJsWC9KYmdGOUVYdlJQa0ZsdTJJNjVJaFVkVFNtdVVTT2xqRjlM?=
 =?utf-8?B?QlJBaHloQ21IUXVWalJLR2NTNzhOS2FtdC9Zb3hYL1NZM2hjYXE1aUNPbmFT?=
 =?utf-8?B?NDFqWVBmaG4yWjdlanU5U1Mxb2EydW14eURhY1R5NnczckdQSjZGOVdyT1JK?=
 =?utf-8?Q?zjBg1nD4RwU9yDN9UeHrWxGM99ZQIbg6Rg+xGZf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c009e932-1c34-481e-023a-08d91f8c0344
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 14:47:26.2145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: auJH7gGRpToy4cM4xlBbu4Xxc8kAQzaLDFWd7xvGZ2+w9f0Fyqkd48EWfLYot+j3iyXymq/d7vWkWVI4inhopA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/25/21 9:35 AM, Borislav Petkov wrote:
>> In this particular case, the snp_register_ghcb() is shared between the
>> decompress and main kernel. The variable data->snp_ghcb_registered is
>> not visible in the decompressed path,
> Why is it not visible?

Maybe I should have said, its not applicable in the decompressed path.

The snp_ghcb_register is defined in the per-CPU structure, and used in
the per-CPU #VC handler. We don't have the per-CPU #VC handler in the
decompression code path.

Please see the arch/x86/kernel/sev.c

/* #VC handler runtime per-CPU data */

struct sev_es_runtime_data {

 ...

 ...

 bool snp_ghcb_registered;

}


