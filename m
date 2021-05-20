Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD86E38B556
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhETRmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:42:06 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:19552
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232607AbhETRmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:42:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLwsBC5KV6qQWjth+skLi7MBYW8SMWP2FyKGoOBOXHW8cEnJoIBQDaT1XtV0gj7L5yO4cObKG1DNsGoT9Ahzf0CwjmLRBPZQ1nEyfUgQoX3DtwMhu/vlUgxAkz2EKWbDUG47qUIKPRFrjc+AdRY45zI49i0AVXPrv3NgSAdEq5boBoj/Hp+1/SjK4/7A7FS3TfirGTV+gkGP9z0KGgqtx1MaL1Z9JDO94piOSz36m9rv+Mw0PTVIIe9oRVFm2UmRBdXtyZEB0lzYjzincDMreZpEZ4sktApwP9BtTq//VQ+KBZiDK9/+g7RNC8OaKfJ7U7xkHiJzTOl9Z2r3jeeeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8hnzxByfyqxqAtZh9JAuDcFZ62b/ygUo5ZS5IRSR98=;
 b=aExERyGa5vpMoqQ48oHDuv/hKQzJqcD2UwYtAtmDFpStEcTx6NnDpFsT7t+K1HJSnDYhoJKQpWyEogrRWWX0DXf239+T3x38UwF7vbOsQz7HHNztWgYyaKkRSE438WKlwFYt7xh428YHM730m1TZBAiSaUZaIky8cbcNehMIe4Asrv4uOQyz3ZT6nVIEAzH9BYBuSpKoTefUKjFexxDrAX6xyaomtL4sJARwfzrjGAH/RMgAY07FLY30+Lo+e0Z/8Pk9/TBmkxp4zFMuK2/UEH0Es8PhqtYlFS5nALVGj5gCUY+l5+sMuVnWLHy5yDYQrB7h5LEIRpvnHP8jaN+RYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8hnzxByfyqxqAtZh9JAuDcFZ62b/ygUo5ZS5IRSR98=;
 b=RPIg0lujJswHSBX3TIRFvtdx3aqrfXDavChYArdf42eDvcoUzXV6yP5aLsxdQ2/5oNkCsqkiLi7Vnkdgaa2CbWDu3Ecsbf6q+d3v0wQ/UUvXccuyDnp0VztC9VvT/Phje9MWgNtgPUhi1ITU/uxNN1MOFzpQKUXVubg4i7upbbk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 17:40:42 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 17:40:42 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 09/20] x86/sev: check SEV-SNP features
 support
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-10-brijesh.singh@amd.com> <YKaIDAHOz4+soLxi@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <8b23f813-d437-507b-b46b-c8f907688d21@amd.com>
Date:   Thu, 20 May 2021 12:40:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKaIDAHOz4+soLxi@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0601CA0005.namprd06.prod.outlook.com
 (2603:10b6:803:2f::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0601CA0005.namprd06.prod.outlook.com (2603:10b6:803:2f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 17:40:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8d0974e-52d7-4608-7d05-08d91bb663d6
X-MS-TrafficTypeDiagnostic: SA0PR12MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43657E6EF49B49BF4525A40FE52A9@SA0PR12MB4365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gm4E69q2XEy7oGjH+S7wQFD0begg8CrDGPRQb/Btzqqy5QWCpd10bDaJjx/Xy6Y2aTY7z443W8wxsUSwVslTmh50PIodw8lMDH6xHgdu48yP01RKygqjicyQa1aw0gNztK97mgrBGwiLGL/hAJzNBqxR7SbNESCjT4BnpRSLw4vzs6MvfGGLXYtC2e9KQW0m7+w4a06EqYuy5cELxhOZTJtMyETZFdgR+eGAZAFTCiGESUhZ7v9mEth7HEkiKrHx7qJZsXD2MlF1a9M1HDt+7z0smI9H5/+JYUVijemJkPVsx8RjLCKz3CvEKYbhK/jD46sNPap+h9mIKSkm+VDGpM+YSY4FgrJJRUxL15/42TQh4BNGNmeTTb91AuhizHJFARe0akIXY2cNRZF9eDz3N/ts3isZoxfL2tAD2PlYjWfyT++Y9L3rk+mTOMc3Zwlc9r1HRcOgkzV9Hi2vD8gI/DTo6gLJQZXNAKETXbr+ec5fGU1KzSTnU7l2Hk1qFfsPW0QstvdfeSl3hl9A955Sia9kxirMRdfSrnOKYkpFifetvnh86JAOP1fOdNTX1CnMu+bdXiny8dODeXZ7PAnxGcypxZYR08UHd3jEZMkL3HO8LNzMgbtDVtdKvH4SCykpFcKI6CjcnD3izFE3UFZoXy8DL2ty7mr6f60QoCpLMs/kA7kDgYrr4/hM19q9yLt5rttF7tNZXtAp7UsrdIvm9ohR8OMzEkkHzOvT7TyA5fS00Beo5TXCHYIqMVYwc+j7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39830400003)(346002)(376002)(5660300002)(6486002)(6512007)(38100700002)(16526019)(8936002)(4326008)(52116002)(44832011)(38350700002)(31686004)(2906002)(66946007)(66476007)(66556008)(508600001)(6506007)(31696002)(956004)(2616005)(86362001)(6916009)(7416002)(186003)(26005)(34490700003)(53546011)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c2F4NCt1d0N4Tm5CWUFyaHJQVzJuUXVPbGdJYjNuQklhMnFZYmJWajVDYUFx?=
 =?utf-8?B?S3NpSmhzd25VWGZyNlJEWDQ4V0lLOU50OTc2WXA3aDJFTFV6VWFKalVpOGZN?=
 =?utf-8?B?dkM5TlByVWIvTnNqT0N0eGdQV09jeHMvNk03c3JOVSt4aTJDN3QzYXN1bDNG?=
 =?utf-8?B?aHF2eHliYlVCZDBPVnh2N1JNR3k5di8zdW9EU1JqdERjTm93enIzeExkdVVi?=
 =?utf-8?B?aHkyWS92TTRPemFPTmk1ajh1WXA5ZWgzOHlwc0xxVW1zYUY5ZGE0dmVUWmtp?=
 =?utf-8?B?ZkRJWTVvRHgreTdURFBSN3pNRFprK1RzSkZCYWFmYTZONDhodFpnVWJLWXIw?=
 =?utf-8?B?ZmhVOHRHcUdpaUxPanM4MXl4YW9YSHdDVVhxRFhJNVc5cm9tOFkrbnlra3ZT?=
 =?utf-8?B?R0YxZFFHS1cyUVRmQU5LSUt3cm90VzYxdHl5MUJPQVEySTVMMlI5NkJmZkFy?=
 =?utf-8?B?dnBZKzJYMmc1VStFckVQZm80RGZKaDk5N3FsWDcwV1o5N2Q2SHVxc0xjU3hS?=
 =?utf-8?B?Q1o0akxpN3E0bjdWUmwrc3d1UUhBSmxRNU1PNDJTbmwwVEtCUzJUUjZ5UnRC?=
 =?utf-8?B?YkgrWlhrVGE2Z1NBS3R4Rjk2K3cxQU1XV0pWaE5SWjkxMFJmNjV2Tnl2b0sx?=
 =?utf-8?B?SmhLRFE2Q0JtNng2dmpnMmppcmVCd0Urc2FoRkFaVDBRbm9zcnRRMmdhb1U4?=
 =?utf-8?B?Q3M0OHZJcjhZelNIVVBmMmxVVEs0VXpQSWNyZWJTeW9aQW9MZEluc0dGdkpa?=
 =?utf-8?B?eldrb3FINWp6aHlaOWVLVlc5d0JwRzNHYTZ1U2ZnS1FqRkF4QVdBalVWMFlI?=
 =?utf-8?B?dENJZXZISXhzd2RBaE9POWZydXJiV0g2ZytaSGJ5MHBvS01RSWNEVFJ2alNj?=
 =?utf-8?B?allqTW1GTzFHYmNqaTMxUzF6cG9hM3VOQkpISXVJaWxVYUk2dVBxWXhtR3NI?=
 =?utf-8?B?VVlvdUt6V0FjczFscWlDRXhsZmpMZnZiRHhJWjZQcnQxclBKY2FBb3FJanVm?=
 =?utf-8?B?MEFXcUVQdmxiWk8ra0NGMGZOOVppbzd2bkgvL0VOS2YxalJqVXhjUi92Vjhj?=
 =?utf-8?B?OWVGeVlQbEIwb2RhZDdaN28vSEx1WkI4dU50L2MwNWpCNVBKVklERy9hZ0xk?=
 =?utf-8?B?S3VZa3djUUtyM2w3QXczU2FOQ1pSTG9SSmplQTd5dEhnY2pMeEJTMzF2dWlV?=
 =?utf-8?B?SjRySVA5bTUyNjM2K3hMTGIrbmNsK1RHcm0wVGF6ZHRlak11RWd4aFRlZnFG?=
 =?utf-8?B?T2F0Rk8wd2NwWmRtYTlueTVwNk1hN2diYVRNZmFmS293RzhWVkt3RlJ0ZDlR?=
 =?utf-8?B?QVJzVnR5QmcvbUhZdnJGOGRvUm1nR0RXeVNkekFNTFp1UFFzeVY0NlZ1RnlP?=
 =?utf-8?B?bStHVmJ3NTh4SWRvWXJZL1BqcVRnd3FoT2t3czdiT0N5V2ZyRFJCMHV1a2c4?=
 =?utf-8?B?MDdXOFBSQytvV1lhWlRvUXVzSnBxMWNZVnI1NFdlVjVGTGRBU09rNG1OSlpU?=
 =?utf-8?B?dUI5T2RXb293dXVISmpweFJtZUJsdThFZXVBRGJKOWZxZnl1clBWUmlpRENh?=
 =?utf-8?B?a0RoK0lRN01vQUVXaHpCaTgreGljbkpSNS9iWFZkUFBkaUc4T3VBUEltMzBn?=
 =?utf-8?B?RW1rSkE2RDlUVklTcFdqRG84VkJkWGRvZlkxSXEzcHBDeWRuWXJiWmRsdlBW?=
 =?utf-8?B?MUljN1YyRGN4b0JCRHViYndpK1RPZ1NhOU1qaTBadERkeGd0bVVtZThhUkpX?=
 =?utf-8?Q?xTgC4tqgWLPFQM6Zk0I23wVl5j+i/lnjvC2FHil?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d0974e-52d7-4608-7d05-08d91bb663d6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 17:40:42.5673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aA9Zi144LgbmN8sDngnfKBZIunGX3tNQIXURRHB6FK6h/DgRsk31UAbITwkEVXX7jq3Peb5OABAXiAgy+pYFhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/20/21 11:02 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:05AM -0500, Brijesh Singh wrote:
>> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
>> index 6d9055427f37..7badbeb6cb95 100644
>> --- a/arch/x86/boot/compressed/sev.c
>> +++ b/arch/x86/boot/compressed/sev.c
>> @@ -25,6 +25,8 @@
>>  
>>  struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
>>  struct ghcb *boot_ghcb;
>> +static u64 sev_status_val;
> msr_sev_status should be more descriptive.
Noted.
>
>> +static bool sev_status_checked;
> You don't need this one - you can simply do
>
> 	if (!msr_sev_status)
> 		read the MSR.

Agreed.


>
>>  /*
>>   * Copy a version of this function here - insn-eval.c can't be used in
>> @@ -119,11 +121,30 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>>  /* Include code for early handlers */
>>  #include "../../kernel/sev-shared.c"
>>  
>> +static inline bool sev_snp_enabled(void)
>> +{
>> +	unsigned long low, high;
>> +
>> +	if (!sev_status_checked) {
>> +		asm volatile("rdmsr\n"
>> +			     : "=a" (low), "=d" (high)
>> +			     : "c" (MSR_AMD64_SEV));
>> +		sev_status_val = (high << 32) | low;
>> +		sev_status_checked = true;
>> +	}
>> +
>> +	return sev_status_val & MSR_AMD64_SEV_SNP_ENABLED ? true : false;
> 	return msr_sev_status & MSR_AMD64_SEV_SNP_ENABLED;
>
> is enough.

Noted.


>> +}
>> +
>>  static bool early_setup_sev_es(void)
>>  {
>>  	if (!sev_es_negotiate_protocol())
>>  		sev_es_terminate(0, GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
>>  
>> +	/* If SEV-SNP is enabled then check if the hypervisor supports the SEV-SNP features. */
> 80 cols like the rest of this file pls.

Noted.


>
>> +	if (sev_snp_enabled() && !sev_snp_check_hypervisor_features())
>> +		sev_es_terminate(0, GHCB_SEV_ES_REASON_SNP_UNSUPPORTED);
>> +
>>  	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
>>  		return false;
> Thx.
>
