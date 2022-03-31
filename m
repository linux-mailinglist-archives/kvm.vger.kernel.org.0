Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9384ED308
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 06:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiCaEuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 00:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiCaEuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 00:50:44 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AF3B82CA;
        Wed, 30 Mar 2022 21:48:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ft4TxKSilPCQKUyybv4Sq9cgqwYR1B5jj2Us7nWHzLQKRnjSAoUs4JLYdJ9eRSltL70/xx0V/+JK99Wk+FdSI9alolSDsKBUcv4oIQbEppVzxvr/sizKAa6NWFTbHh+vpO/Y7xpe/Me3ixGJDBBevS67Y2UI1z7eRlYK6DKuEJUimBYth0gT68gVCF+cTxuxL5o6CS8AreUyqZ26RWOiwppRxoBWmhbNvMhr+JlozqUG0aWDmVVSakoENJosSGdxZoq8GaNHa240cQELxbDLFYa2P46Zr5MN5sUE0xvZopYge8RqydnFES6A7hZe5K7wZgDsF/39SnTWl6q+37WXcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwATXmzMjyPxraW9vkODx5+aTekpgqFIuqvqGMyT/ow=;
 b=eNtyaREk6A81P+YDgbXCnSZVRbHc8nj3hDSBCVhUUD6tB33iVGaNLDbLAEtgONJO6AGSlMTeIXn41jgULhgjWbD2kbwPtVb/O41BK5nOxv1E/j/CX8fhW0ds7UEQAcZd4r/3ouRtBUzCEov5z8QBOi07jBF2HWR3lIulwhvnWUUZtVxKIkQXyaXeZWOHP1T8AVUzSPy4vGS8LLTOZfsca7oQhkpOaDqCF4c2SGvGMhj93Xo+yooimi5+Q0eX61FVAz6N6y87YlipOx4HJF7R+mhHEm2ONseMES9hRPJ6AxdEOEkS6dWXvV5+uGFPCcaAionmuuDwIRyDIwPjyH3/Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwATXmzMjyPxraW9vkODx5+aTekpgqFIuqvqGMyT/ow=;
 b=ZYoN9aFXYJ3++P4XibqGrUxw1Gc/+lPBxOoH1lUniEzkM2f0YimLchtENNqJ0ktm7ZjIp+++32Ti+TedIeXZdL6FO6p/01ZlDOIXyyqQXDRIa1SPVmNg8XSyhJIw1mH9jMkGiytJp0HDoTObcPX7SwKZvzcEPQx/1vRgGoRTj8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 DM6PR12MB2844.namprd12.prod.outlook.com (2603:10b6:5:45::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Thu, 31 Mar 2022 04:48:53 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::8547:4b1f:9eea:e28b%3]) with mapi id 15.20.5102.023; Thu, 31 Mar 2022
 04:48:53 +0000
Message-ID: <5567f4ec-bbcf-4caf-16c1-3621b77a1779@amd.com>
Date:   Thu, 31 Mar 2022 10:18:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH RFC v1 0/9] KVM: SVM: Defer page pinning for SEV guests
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Bharata B Rao <bharata@amd.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Mingwei Zhang <mizhang@google.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220308043857.13652-1-nikunj@amd.com>
 <YkIh8zM7XfhsFN8L@google.com> <c4b33753-01d7-684e-23ac-1189bd217761@amd.com>
 <YkSz1R3YuFszcZrY@google.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <YkSz1R3YuFszcZrY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::10) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6982e96a-0d3a-4db4-2c9b-08da12d1c1a9
X-MS-TrafficTypeDiagnostic: DM6PR12MB2844:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB284484B2696E25CD8C06B3B4E2E19@DM6PR12MB2844.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emPkJKZ/Wh0m6T6sEA/bHOHq/CcFiK3DLnXFsfrgREdZ+UFWA0ybV5XNnMAk1NlO2+PYRZEViD3MC1DdP/QBwODI4tufs7b8pIO2gXIjdEQRTlsxnUHEVGj074hRdL9yD7pMEAor8PN0WnKvcdgCUASIUuPjDzl18ko/LFdQ7T4Iri37idMA1KYITTwvPFv9cUXZeQiaZFS54PWcLQ6GJiHPyVSc2OK+Na+nNHIW2zMY9lYqSNzLEXZ7YvKS11ieGarUQL5R8+ZQspiwqhVo3BQAA6PY/G3JaN23rIc6oaZNz5gaaRYGtYvl2pDtjMSlsOeWir5D13Jhss6b36nmAESWz4w/TfC6qR2QyiEIzSg2JZFQk67We54Q4MXEkLxY8o5ecxTUP66K73Ntobtpz+8jHtvdy+ktDesn1OL7Tj0ow89U31su1/3asdMpGMDe7fxBJyjKUPk11q5HBjC1EMANghM+BnWb1O5p8MA133o52iNsPVzet+3HJQ7nxTZkueDx5uP0FEi11xlAK7h0HFJ14dGQ1ecQxniIxatZSVwLA7CDXjtjFYd2BXtv4V5vy5B4JCln6FhCN5VyxKAzrlXJhmidk1WYKyUqOxQtYRFcQbVzU6jhDmZR0/dbHdxp/6PJaBCNuS3VLetTzZuBPNxLuOT5GEVv6QlT925Oz+Z540OhNE8NnzFkdkMJwpAUdZs8NS6ke33JXKHPWbJZPRN+Qlc1UoUtjo7paoUHqGY1JWR7UqDsWOoF6is+eikb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(36756003)(26005)(186003)(2616005)(54906003)(2906002)(83380400001)(31686004)(53546011)(4326008)(8676002)(66946007)(66476007)(66556008)(6666004)(6486002)(5660300002)(8936002)(6512007)(508600001)(6916009)(38100700002)(316002)(31696002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R05kUE1UQ0dMTDl4bzd6VXB6U3lGelVkcUNoUVFhY291YTVwK1YyUm80dGZj?=
 =?utf-8?B?V2xlemloNk5NUStNWlFpYXpCOTlNTE1qYk1EbTkyMG1MN3JJT0VmSGlwQnpU?=
 =?utf-8?B?Q2hRaHdDRGEyRHE3YVRoZ1ZmRU1vdGdDbk5NVWhKQ2grREE2ZDlpcy9pS3RI?=
 =?utf-8?B?a1BGNE9tcXQ1Y0NmcnZpRkhoVUdyeDVEUnVMbEJqdlg0aCt2eW5qRVlCbUFH?=
 =?utf-8?B?R3NBMDU0cU9vRjVrOHBEc3BLSlRDa3BJb1NBbTV1Rno1Nks2emoyT2pjbDV6?=
 =?utf-8?B?R3BzUjJoU2FCK2RlSHpEU2xMdWVlR0lvZXZGSEk5c0h0TXhyK2tsUHc3ckl4?=
 =?utf-8?B?N2RhSy9vYk00aWZ6Y21oTG5VMVhWOUFZRmNZT2Y2Q1QvYVZvdjd5RGFmYkdn?=
 =?utf-8?B?SFVDSmZtUk9LdmZxTGkxSkp2YkpZM3YyclJYbG1MYUhlMjl1N3ZRTGt1UFNM?=
 =?utf-8?B?ckpWYWpHYkdUN3M3VUpBcUxqM2ZZeUVTUlltUmN1UWRrNmozZDFmSXprVnJW?=
 =?utf-8?B?RHJzMW9XL2JqQ2JrbloxZnVLeCtsOWlCbzhUeVlWbU9oWDRoakN5NnVTdzM4?=
 =?utf-8?B?S0h4SVZ6VUlPR3ZCdXNKYytJWVI5bkRGOURzN1pqZUZDSnhuWVpYWjc0blZy?=
 =?utf-8?B?UzFXWERZd0MxTUE2eFViR1lqUUhLeldqWE1sOXhkdzZpOE9rRGswWFdzdTBN?=
 =?utf-8?B?QmNJOUxGQ2Erdjh1MGVRSlNPVHMyeittNktib3pEK1QrSlN3SGRHOVJMYVBJ?=
 =?utf-8?B?eUk4KzM2ZkJpOUUwRWUxQjNjYm9OVTJCa1lFbUhFQVc2dlJNdUFPV2xvSnhS?=
 =?utf-8?B?TzUwT25xdUlpTzJGVmFheFUxTCsyREQrS2FBSWxzODcwbjN6eW5xVkRoaVpi?=
 =?utf-8?B?bnE2UjR5dUpZUHhQeUtaYzJvRDZnMXVnWG14a2lodXVZZ1l6b29qcE8valBN?=
 =?utf-8?B?Q3ZyTndXMzNSUlUyODJ2REFVZUo2YkR2dFFqcDNzRnhUUm5OYjk4NjlOa2dB?=
 =?utf-8?B?b1hBeUs2SExnZW85cjFxTmRYSDFYZTNTNjd1UFZUOFJST01TZ1U4R3FvNStE?=
 =?utf-8?B?WE1tZmMzbUhBUFNRaWFGWWc4RWNPSE82dG9lUTdENTlrZlczK3BQSzFkWWcr?=
 =?utf-8?B?dDUwcUtUSmFLTmdDT1llQXc0Qkh0aC80a0c2Z2czOWVSNVJwL1d0TjN1bWdL?=
 =?utf-8?B?YlEzZVRFTUNmS25JVVZYdkEyZnY4NGcrTU84U0ZyNGh6SEs4M2dzV1J6aG1D?=
 =?utf-8?B?OGNkUmJYOFpKR2lFUyt6VlpyRTNYNEVMRHY3SjVPNmUzZlFlSjdrOExaQjlG?=
 =?utf-8?B?Rjg3em5WMDRYUHJ2UXpFaW81bUhsV3F5aWFpeEFDbzRsbXdkS0ROczNaSDNS?=
 =?utf-8?B?WWY5TzIzMEF0QmpNVmJvdFVSaDdzU1h3T2Z1MjhmQkI1TTdXVDN0S0lLM29S?=
 =?utf-8?B?bjVKTklaeE45YjkyVEcxakNJWk16UC92OGxZQklOR1NKNVY4QUk1L3piK1Bp?=
 =?utf-8?B?eWpKL1hxYThvRnE0MnhLZFhrTkJJaTQzYmY5dUlVUUNYRlhDZHhjdVdHUFha?=
 =?utf-8?B?ckNXcmpKZkQvZjk4NXpTeksvLzVvYXd5dWVyNzN2RDBmWEtTeXhuSTkzM2xn?=
 =?utf-8?B?WDJLQ2tMYXhQSXQ0eFJFZCtFZ2ZOQkU0Y0xJV0ZZSGJLKzNSYStWQ08xdlps?=
 =?utf-8?B?R2t1a0lROEJRVWRWYmJXT09tUzkvWGFXc3dsaXJSUGdHK0V4b2VrbzBBOG5R?=
 =?utf-8?B?bTFSdGZrcXRSYitRNStmL04vOFZCQ0x4RGhkTWVvWG1pTVlNblU4K3hGRm9E?=
 =?utf-8?B?ajhpUk0ra2hPZEhleUwzM1VnUm01UzMxaVR6STlKdjRRbFZtNmNjZVp3VSsz?=
 =?utf-8?B?V1ozc0hOTlFza0h5dUhiZ2N3Y21rTWdiT3QxSXJ2c2orRVVlMVIyUGdlWDAw?=
 =?utf-8?B?Z0NKcHorL282d04rd1VINWVuaHlyRWtUeEpIWGtMT1VETENMM0lub21RV0U3?=
 =?utf-8?B?NThNdkt0TXV0MVlXWndMT1NHYWF3aEhWZ05kV21jd01YYTBhSmRXZ2N3SDJi?=
 =?utf-8?B?NUR1blFubUtiRkJDeXJSV0VFTW5PazU3U0tpaURYdXpwQnlSUVB5MHZpd1pm?=
 =?utf-8?B?MmhLSzNFNjM5eG1ibXIvQWxYRzVCT0ZIc0VJRzhhdi9YSXFVOUFaZjRSTEg5?=
 =?utf-8?B?MHpaakZVUGZUY1pQVytFeFEveE5zWEc5WVRMaUxtdmlBWXJPSFV2OTFBbmpD?=
 =?utf-8?B?enBHekFNUlFIcjl1dHFIVkdZNERjUVdXdjBINVJKaCsycWtvSFZkK1RIQU1T?=
 =?utf-8?B?RTVKOHc1SHJYU3VZa1ZxMjg3SnM0bDhTZm4xd0dEOUcrcUJqdC8xZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6982e96a-0d3a-4db4-2c9b-08da12d1c1a9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 04:48:53.6338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mey4JW2QzTgJ3GA2xdCCyLP7MF5Xsikta7AdSfN91S5RbHrMnttLFn0ctEvSzLbdI0Cr3wyzazOTU2mHr6DFWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2844
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/31/2022 1:17 AM, Sean Christopherson wrote:
> On Wed, Mar 30, 2022, Nikunj A. Dadhania wrote:
>> On 3/29/2022 2:30 AM, Sean Christopherson wrote:
>>> Let me preface this by saying I generally like the idea and especially the
>>> performance, but...
>>>
>>> I think we should abandon this approach in favor of committing all our resources
>>> to fd-based private memory[*], which (if done right) will provide on-demand pinning
>>> for "free".  
>>
>> I will give this a try for SEV, was on my todo list.
>>
>>> I would much rather get that support merged sooner than later, and use
>>> it as a carrot for legacy SEV to get users to move over to its new APIs, with a long
>>> term goal of deprecating and disallowing SEV/SEV-ES guests without fd-based private
>>> memory.  
>>
>>> That would require guest kernel support to communicate private vs. shared,
>>
>> Could you explain this in more detail? This is required for punching hole for shared pages?
> 
> Unlike SEV-SNP, which enumerates private vs. shared in the error code, SEV and SEV-ES
> don't provide private vs. shared information to the host (KVM) on page fault.  And
> it's even more fundamental then that, as SEV/SEV-ES won't even fault if the guest
> accesses the "wrong" GPA variant, they'll silent consume/corrupt data.
> 
> That means KVM can't support implicit conversions for SEV/SEV-ES, and so an explicit
> hypercall is mandatory.  SEV doesn't even have a vendor-agnostic guest/host paravirt
> ABI, and IIRC SEV-ES doesn't provide a conversion/map hypercall in the GHCB spec, so
> running a SEV/SEV-ES guest under UPM would require the guest firmware+kernel to be
> properly enlightened beyond what is required architecturally.
> 

So with guest supporting KVM_FEATURE_HC_MAP_GPA_RANGE and host (KVM) supporting 
KVM_HC_MAP_GPA_RANGE hypercall, SEV/SEV-ES guest should communicate private/shared 
pages to the hypervisor, this information can be used to mark page shared/private.

Regards,
Nikunj
