Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF06D489DAB
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 17:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbiAJQfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 11:35:52 -0500
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:50272
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231359AbiAJQfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 11:35:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anTazredi5UlA7zvI+pxpPqUFk8PjsDXpPNaq+y3KwlIPgCi/N4FGaFemp1LYh6wzSxNDLj0BTJmaekHbXYqApEjYfXx0LJEGq/wJFwZwAMJ9rBUnyvHpYl3hzBJkSpLbN2bETrhAvJet0KA/SS4rmel+TgxJ6JkCrztuzxSTp3HCawYqZRazU6XQBgv8PuELVm2lonPcn8ek/55Pbn5Y7qJsiTaD34gnsHr/i8+2yEeI40Z0tOSzAdXSMvWE+7zk9esLzAow/GuzGVbzFv1rdGjjEhML/ovhmYP4OrvBz+t/k8TH32lv/HTjtCVyB+ij2pmm4ogUrOlxSiMZ47FcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4hF83O4iUDv99z/TfWURV9xgtcq6pIquHQiBAOoBKk=;
 b=O0VdyEWD6xO6TOdxuYqOl9Ija8CbrNY0ijdw6IB57d/t901AqrP6AJS+zyDo9QRBiunPA3hhp98otP7sD3jcm9Oupnrh5FuJYD4l2X+p22QTG5AzWQY144KLrJLZ8P5ovj/+xXDgWpEPDQf2jI68VjscgS9LEh4oWGxk6diWHClJ71WPeOEG2w+HEfcVy3tMW+p/hr/IUB+9+xTtVi8jiH2lOIUmcAtZcgLQtomNnJNr0u0RJwiPj8eZRRwF3yhQO/NUFTk0efsEu/+/bkTa1mjEsmRUf9SJogaRO4z8q0MLU5uA43AfsSu2w9HL2Sf2xzxbxxZ3muf+ii97sgZZuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4hF83O4iUDv99z/TfWURV9xgtcq6pIquHQiBAOoBKk=;
 b=biLFb+YQyiqHpBes8R2DDqHtttrl5oqbfyjpZ8X8vlrJCxlGz+xD6CssjxGKNgnB0deilj0ddvCtzkFvYmR4e/Ht5W0XNcS11pNfYMy8rfpkKi/IAvou592rDMZzPkWLrJWm/1KRkwUkEL0RmNURAXQ/2L+dg1vD8R4o8FgC4A0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Mon, 10 Jan
 2022 16:35:48 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::35:281:b7f8:ed4c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::35:281:b7f8:ed4c%6]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 16:35:48 +0000
Cc:     brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        zhang.jia@linux.alibaba.com
Subject: Re: [PATCH 0/3] Allow guest to query AMD SEV(-ES) runtime attestation
 evidence
To:     Shirong Hao <shirong@linux.alibaba.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.co, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, thomas.lendacky@amd.com,
        john.allen@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, srutherford@google.com, ashish.kalra@amd.com,
        natet@google.com
References: <20220110060445.549800-1-shirong@linux.alibaba.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <82f7e738-9d57-bc70-a3fb-ab8785c34a81@amd.com>
Date:   Mon, 10 Jan 2022 10:35:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20220110060445.549800-1-shirong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:610:4e::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ddf565d-1c56-49a5-a09a-08d9d45741ba
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2511DD02FC2645B52C3CB7D7E5509@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZcA7d7dETY7rzTsBwkxzIoiBOFr3kaFwOlqzQTczc8bA6YoW/13b39B9bL/sfN6MX+gV16Uiadudkoi9B0qQISFolp+Rd6JdOPUAYNs0ZpfMeTbCKpOlNlru3KFLKE0xP1hn9wIbsUpG3XO7qcPTzcOOydcDDQJdNNhHkietTR60Cfz0djUAJ6U399lrQcwMP6u9cSeW26SPztNfI/1oOdCLEe4whkkmgNB9aX0Dy///lbEzU9MkrfIxIkMoDQ3em2O0lPPZAwSG8CypZbDZhMFWlKZk3SG87P7taNqthcztdYS5yTGP17zJctPzA0G/03Q5RMr1UOT9yNHCjgG0+q4E/klC+YyphmZXNkDlLOAKv7WYQh6o/T4H3jMjsIEYeQIdAv8bR0Mf1U615hvHE95tJUW/J5tj5/sV0kV3QFePtJ54v3UYqaM0UFjRm4K2mFuR1ednoZIGZPKVk49KxO2x0Ee8OAlMd1CFqmNb7ZVGQVLuUS0Dn/xiasvbYnAgR406KvjgKs3X0ZKgS6CselFHeMz2RDIipppc5hwyGzIope7SJfs6n+bfWbB5ESfDH3VzHfujJa7h9P/Z9uTw37aTa6ZKOowHft8CKD+JDflvY3xsBlRayJ7t8ecpS46HhrrdvxbtbIoMUgAAqduYlnAwtE+YRk8O9tYrYqlfP5ZPZ5di1asRya4Ou318NIXzQFwRDxfzMNGx/Z3sjseiHUch3HW/AGqr3HLY30MSD5h5jZn4BHY+PooRpJJ5b8GBbsluUzPGlmcvE+WcUF5QqcvyYY0RKLW2a0j52fibXTV2zdGeBrUTux74ShQyzygOy/8GJyNzJSWHDPGleOQvJIKWYfxXqPnz5a/YmjT7XOwcs28q0ttPudB2ykZltwYc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(83380400001)(316002)(31686004)(6666004)(8676002)(6506007)(6512007)(26005)(966005)(7416002)(53546011)(508600001)(86362001)(2906002)(31696002)(36756003)(66946007)(186003)(38100700002)(66556008)(921005)(66476007)(8936002)(5660300002)(44832011)(6486002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzRUUnE3UUg3VFhKMmptSExjTDRKT09kTHhRUy9CSll0eG80QTZlNzZVdGo5?=
 =?utf-8?B?Vi9tOHZJNjc1cCtLL1Z1QzNDY2V4UldlRVY0cTl1dE43ZXQxbDRrbDJHYnlB?=
 =?utf-8?B?cmY1U2w0TkpTYTFvSGJYeTRvcVgzVmZub01hTHBmeFU3SXR2MmMraDVKdEZn?=
 =?utf-8?B?bGhVNXU2ZlhyV2phdmtGU2Uwb0FFb3NCeDZ1VkZBOU5kNnByL3M4UXUxUUha?=
 =?utf-8?B?OHZEdnNtVmVTTXpWU0VNczRRenU1Q1F3MDhVVWlIRHIvN2NNZXJ1VmRmTkNj?=
 =?utf-8?B?dE5rUjkrTUVzUXlidFQ3RzFDenZVYTc1RHZqS3BETEdQWFpDWDZzb2tDNlFo?=
 =?utf-8?B?dk14bzYzakZoSCthS2g0WTdnN1REMXZ6dTFZdjZWNUtlVEFqTXJzbTcyZTdm?=
 =?utf-8?B?VGMrZjB2LzJVTjhhOVluNURTaWsvTjVPVHFjRFV2R2dmQnV3R0dGUnJqQ1JX?=
 =?utf-8?B?c1BoOHoxdmNHUUNST2luQml0dXFpdmZyQ1kvb2JyRjhueUZGNmZkNWhnTHJG?=
 =?utf-8?B?blcyUENWNnNaSlZjRnpYaGhUT3VIT0dDVzFQYkNCbHppVXE0RDF5YWZUVXBy?=
 =?utf-8?B?WW56NGZTeVpJNGwrZk5aRkxDcThydUhLeTQrQmVHT1pnU3IwempJUGVMTysw?=
 =?utf-8?B?US9mOVV1QUsya25RN0tra1psKzNnMFpia0Fwai8yUnJFT2FBWWFnd2hGRE1M?=
 =?utf-8?B?VS9Ra2ZOb0c4WER6TzJZTnNRSHk1WlcybFBmUVBDcFpmR1pNekFld3M0ZFNt?=
 =?utf-8?B?UGNOOXhuZy9LNTd4elhqK01VLzVyWmFuWDlJY2w0QVMxNjRacU1iU3Y1cjd4?=
 =?utf-8?B?ZEhVRlNFeHhzMGFLN2dYbTJZcGpLakdSOFFnWGs2akdCMDQ1czJDRTV4Tksy?=
 =?utf-8?B?VC90SUFJeUdpY3VXRzJhRVRJa28wSFZDb2pmKzk1cWptcGlXbnpwa1hxc0RX?=
 =?utf-8?B?ei9kcXl2QlJ5QXJHNFdqUnFGQitEeDRHNkVtU0hoRlpsKzFoWTRFWG4yM1Rt?=
 =?utf-8?B?dnhqdUt2dEZOYUNBTHRKNkVCQ2hXSWlyOHVaTjBqb2Yxc1hNTCt3N21OeFNG?=
 =?utf-8?B?aGVUditUMXJmTDZUSzBEVEw1L0FvdXRWcTNmN2pzV0VVbURuSEROUnpqK3dn?=
 =?utf-8?B?aDc4QVFyN0ZycC9MSUVZZU1MakF3VXp6d05hYTNVaCtTZUJLcWFmVkVlQWtB?=
 =?utf-8?B?ME9FMXVIWnU4TTFNV0hZb1RLSEN0eThUYU95WXF0Unc1dGFGZ0drK3VIKzlS?=
 =?utf-8?B?Y3B1SGlmWnZYR1ZHbjdqbFc5WEh4b1FIMTRqZ05JaXJTRnV6blNVYjcrYmIy?=
 =?utf-8?B?MHh2UlZSWUFFSURicllwVmU4dWw4Y3RQaEt2ZHdWb2xLZmFoamJNQkxwR2xl?=
 =?utf-8?B?N2FFaTZTQ29XVUZNSUsvLzhHeXVpSmR3Q3IreittU3dNR2ZRU0tCSmxBcmtz?=
 =?utf-8?B?bmhtME02Q0p1b0MzRjJvb3ZMTW5aaXptamQ2RFdjTk1tL2xkNy9ST2ZGbWVX?=
 =?utf-8?B?OWwrNHVTMVo1bG9zT1RWS0lSTnM3RkNrSk10Y3ZDd2ZaWGQrdDRPRVdnRXhN?=
 =?utf-8?B?N2hOSEpRcWVqTktENFNjQXFRT1Z3ajhnVFNXWmVhZzNpOVdndWJNeWhaekJp?=
 =?utf-8?B?NDdFZ1R2NGNrSHJxUlkrUUdMSEtiRmNwdHg1amtSMTE4SWxNN2M4R2M3cnVp?=
 =?utf-8?B?SFlwTXh3bHptL3pCWno5RjhqZ1FjcXQ4elFHdEQyYVF4dmNjVnkybVBxR2o0?=
 =?utf-8?B?Z3B5OHVMaTdBckNpb0dXdUJlMDZKTkx4M3h4L0l0Y0NLbUI1WW9GWjBIUkZ0?=
 =?utf-8?B?ZmtFNjhXb1BUYlhVWnowc0FDOUJybFdMV3lmU0IrK1QrdkVySmw4Rmx1TUsx?=
 =?utf-8?B?NEtLOTVVTzNkWFYxTG1IL0pTZ0l2NmZxV1F3VUZsZ2hwN0FKMlFyZ0RCWVll?=
 =?utf-8?B?c3F6YWFKcDZYcU1HaE55c2N5eUkrSUNYQlk2NzNDT1R4eUpETGtaWUZ6Ry9I?=
 =?utf-8?B?RmRtZnNOT1QyQmZvM0RxMTlsWnZUdnBiQmNYR1VBcWdlZklLNW0vdmtCaG5w?=
 =?utf-8?B?RlpieVIxTGlnNUVZYU0xUXhPQzFOS0NoM1ErandwYUMyRjNSOFRaZ0VvazIx?=
 =?utf-8?B?NlkrQk51S01YVUErZGpUTDluc0JGRkc3UEZOMTh5VlU5eWVTUnBrRWtyZFI5?=
 =?utf-8?Q?N+H5GP2RpL1gGOUasWuzsZM=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddf565d-1c56-49a5-a09a-08d9d45741ba
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 16:35:48.2347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eOfxIwIUy94qVTZ1BZZxjA2Rb13Jt0J4ozkf0z0eX/mG4zOd+SUSr4sVDZZZ6cr0XfbbiUfNTS99FTzt91a8Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shirong,

On 1/10/22 12:04 AM, Shirong Hao wrote:
> This patch series is provided to allow the guest application to query
> AMD SEV(-ES) runtime attestation evidence by communicating with the host
> service (Attestation Evidence Broker).
> 
> The following is the design document.
> 
>> Background
> 
> Compared with SEV-SNP and Intel TDX, the runtime attestation of
> SEV(-ES) does NOT support guest-provided data included in the
> attestation report [1,2]. In addition, SEV(-ES) also does NOT support
> the dynamic measurement. During runtime, it can only generate static
> attestation report with the constant launch digest reflecting the
> initial measurement.
> 
> Although SEV(-ES) has above limitations, its runtime attestation is
> still useful. When the SEV(-ES) guest is running, it can report the
> attestation report with fixed launch digest as a heartbeat for trusted
> healthy check.
> 
> SEV(-ES) runtime attestation includes two participants:
> attester and verifier.
> 
> - The attester running in a SEV(-ES) guest is responsible for
>    collecting attestation evidence.
> - The verifier running in a trusted environment is responsible for
>    verifying the attestation evidence provided by the attester. Note
>    that the verifier can run on any platform even non-TEE.
> 
>> SEV(-ES) Attestation Evidence
> 
> Verifier uses the following SEV(-ES) certificate chains to verify the
> signature of the attestation report generated by the `ATTESTATION`
> command [2]:
> 
> 1. certificate chain for device identity:
> ARK -> ASK -> CEK -> PEK -> report
> 2. certificate chain for platform owner identity:
> OCA -> PEK -> report
> 
> - `foo -> bar` indicates using the public key of `foo` to verify the
>    signature of `bar`.
> - ARK is the root of trust of AMD and OCA is the root of trust for
>    platform owners. OCA has two ways:
>      1. Self-owned: The OCA Key Pair and self-signed OCA certificate
>         are automatically generated by the SEV(-ES) firmware.
>      2. Externally-owned: External users use OCA Key Pair to generate
>         self-signed OCA certificates in a trusted environment.
> 
> Verifier needs to verify the attestation report with the certificate chain.
> ARK and ASK can be obtained directly from the AMD KDS server. CEK, PEK,
> OCA, and attestation report are related to the specific SEV(-ES) platform,
> therefore SEV(-ES) Attestation Evidence collected by attester should
> include attestation report (with the constant launch digest), PEK, CEK,
> and OCA certificate.
> 
> | Contents of SEV(-ES) Attestation Evidence 	| SEV(-ES) firmware command	|
> | :-: | :-: |
> | attestation report				| ATTESTATION			|
> | CEK						| GET_ID			|
> | OCA,PEK					| PDH_CERT_EXPORT		|
> 
>> Query SEV(-ES) Attestation Evidence
> 
> According to the official feedback[3], SEV(-ES) firmware APIs don't support
> query attestation report in SEV(-ES) guest and there is no plan to support
> it in the future. Instead, this capability will be available in SEV-SNP.
> 
> In some scenarios, the guest application needs to query the attestation
> report to establish an attested channel with the remote peer. There are
> two approaches for a guest application to query an attestation evidence:
> 
> - Hypercall approach
> - VSOCK approach
> 
> Considering time and cost, we only need to implement one of them.
> 
> - Hypercall approach
> 
> SEV(-ES) guest exits to VMM using `hypercall` and then interacts with SEV
> firmware to query the components composing an attestation evidence,
> including attestation report, PEK, CEK, OCA certificate. To build an
> attestation evidence, the steps include:
> 
> 1. The guest application requests a shared memory page, initiates a
>     hypercall, and switches from the guest mode to the host mode.
> 2. In the host mode, KVM sends the `GET_ID, PDH_CERT_EXPORT, ATTESTATION`
>     command requests to SEV firmware.
> 3. The shared memory page is filled with the data returned by the
>     SEV firmware.
> 4. The guest application can obtain attestation evidence by reading the
>     data in the shared memory.
> 
> Although this method can meet our requirements, it requires a lot of
> modifications to the guest kernel and KVM.
> 
> - VSOCK approach
> 
> In the current implementation, QEMU provides the QMP interface
> "query-sev-attestation-report" to query the attestation report in the host.
>   However, QEMU is not the only VMM. In order to support various VMM in
> different scenarios, it is necessary to design a general host service, such
> as attestation evidence Broker (AEB) to query attestation evidence from the
> host.
> 
> The workflow of AEB is as followed:
> 
> 1. The user-level application in the guest sends a request
>     (including guest firmware handle) to AEB through VSOCK.
> 2. AEB requests to query attestation report, PEK, CEK, OCA certificate by
>     calling multiple SEV firmware APIs (refer to the table above for
>     specific API commands) and assembles these information into the
>     attestation evidence.
> 3. AEB returns the attestation evidence to the application in the guest.
> 
> To query the attestation report in host with AEB, we provides three patches
> to achieve the following two goals.
> 
> 1. It is necessary to add a `SEV_GET_REPORT` interface in ccp driver so
>     that AEB can execute `ioctl` on the `/dev/sev` device and then call
>     the `SEV_GET_REPORT` interface to send the `ATTESTATION` command to
>     the SEV firmware to query attestation report.
>  > 2. In order to obtain the guest handle required by the `ATTESTATION`
>     command to the SEV firmware, a new hypercall needs to be added to the
>     KVM. The application in the guest obtains the guest handle through this
>     newly added hypercal, and then sends it to the AEB service through
>     VSOCK. The AEB service uses the guest handle as the input parameter
>     of the `ATTESTATION` command to interact with the SEV firmware.

SEV (-ES) is not designed to support the runtime attestation. Still, 
your approach here somehow gives the impression to the guest application 
that it's getting the runtime attestation report from the hardware. I am 
not sure if it's a good idea.

In your above example, what stops KVM from providing a wrong handle on 
step #2. How does the guest owner (=customer) know that it is getting 
the report from their VM? Maybe one way to create an association is for 
the guest owner to inject a nonce during the launch flow, and the guest 
application uses this nonce to request the report once.

Alternatively, you can implement a virtual device that can be used by 
guest applications to request the attestation report from the VMM. In 
this approach, the VMM can emulate virtual device, and on read, it can 
call down to PSP to get the attestation report. Now it all starts 
sounding like a vTPM ;)

thanks

> 
> Note that hypercall is not the only way to obtain the guest handle.
> Actually the qmp interface `query-sev` can query the guest handle as well.
> However, as mentioned previously, qemu is not the only VMM.
> 
>> Communication protocol
> 
> Below is the communication protocol between the guest application and AEB.
> 
> ```protobuf
> syntax = "proto3";
> ...
> message RetrieveAttestationEvidenceSizeRequest{
>      uint32 guest_handle = 1;
> }
> message RetrieveAttestationEvidenceRequest{
>      uint32 guest_handle = 1;
>      uint32 evidence_size = 2;
> }
> message RetrieveAttestationEvidenceSizeResponse{
>      uint32 error_code = 1;
>      uint32 evidence_size = 2;
> }
> message RetrieveAttestationEvidenceResponse{
>      uint32 error_code = 1;
>      uint32 evidence_size = 2;
>      bytes evidence = 3;
> }
> service AEBService {
>      rpc RetrieveAttestationEvidenceSize
>           (RetrieveAttestationEvidenceSizeRequest)
>           returns (RetrieveAttestationEvidenceSizeResponse);
>      rpc RetrieveAttestationEvidence(RetrieveAttestationEvidenceRequest)
>           returns (RetrieveAttestationEvidenceResponse);
> }
> ```
> 
>> Reference
> 
> [1] https://www.amd.com/system/files/TechDocs/
> 55766_SEV-KM_API_Specification.pdf
> [2] https://www.amd.com/system/files/TechDocs/56860.pdf
> [3] https://github.com/AMDESE/AMDSEV/issues/71#issuecomment-926118314
> 
> Shirong Hao (3):
>    KVM: X86: Introduce KVM_HC_VM_HANDLE hypercall
>    KVM/SVM: move the implementation of sev_get_attestation_report to ccp
>      driver
>    crypto: ccp: Implement SEV_GET_REPORT ioctl command
> 
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/sev.c          | 49 +++-------------------
>   arch/x86/kvm/svm/svm.c          | 11 +++++
>   arch/x86/kvm/x86.c              |  7 +++-
>   drivers/crypto/ccp/sev-dev.c    | 74 +++++++++++++++++++++++++++++++++
>   include/linux/psp-sev.h         |  7 ++++
>   include/uapi/linux/kvm_para.h   |  1 +
>   include/uapi/linux/psp-sev.h    | 17 ++++++++
>   8 files changed, 123 insertions(+), 44 deletions(-)
> 
