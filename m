Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD037982D
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 22:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhEJUPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 16:15:17 -0400
Received: from mail-mw2nam10on2050.outbound.protection.outlook.com ([40.107.94.50]:62049
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230254AbhEJUPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 16:15:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTTLzszmZ4l4Ldtlps9abW+sE9QhJ0Aj5sUCdgkbyL0+bDuCG8Bh6SC6icXxf3+L2ewG2I+1bStuQtDGOgtwdks7jEt1B5v83TAinHzbWkl/oZclEdcThdlVcn2WPSAmRzAYaH3AeiJUilHobHs6QEYkH7Ct8nPI9GJ914iAW+65i4/Q9vGPeseuzlioz7GZ1aT2zaacSOS0/Rj37o06AaLlQcDWvmsYI1T0Nhg/NiveHzF+Wjrt62wV0TA4WVsrBR+ZHCBzTUIOmlqEl66ggR9Xi1iEQpXcpVPeYpnGDPhYzUdnu8e30azQgAdX9SqsbH9v7qEfWtf3Z+5r19NlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fTA9BrWMDAINk3uqzB/q5i28Q7W8GOmv4OtCsu8CSM=;
 b=dgn4JrTc2twY3xTcJm2FkRMO3RyiRa/NvVBeoBM0NzPac6j2hpqCVrTmGuN4l/weY62mcnnwTWIyWBsmK1mRMa1yPtZuVlDgTO8P9wClXIHN4F4BJg0w8DH8ogYRfevlujiiT63n59DU97T04A0f4/D4AIAHn3F6q0u2jKb9Vp5IOahhK9RXggTSr8ERfkdbcCsvmPZ1hzc76eWZVmSqNKqK+7s4X0OVWPreJEyk9ZczF7790hNyBMZe0v/2gp0BqhSA+oC570kPLoTZyAD6saaWNp9uZQILpbQtoEXbKaMl+gyGOSoEcPw3V2ye07Gyjm5abMQcmrPPt9nxhWar2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fTA9BrWMDAINk3uqzB/q5i28Q7W8GOmv4OtCsu8CSM=;
 b=ae8eryUERD8RLoQepKs1XciWBykL6e/VTBOz8k37C9JJOKeaaRTP5/hWWICi9wFFFt/dgdbJnqyd/yj7ccxPfYnniA9uMkCFU08y5ADiz/6PCqbQ0df788gx4JHOBHs9kPNk9lj+0WBkabO+v7WjwyRZdnJuOTuFJmWlGtmGYs0=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Mon, 10 May
 2021 20:14:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 20:14:09 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, jroedel@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>, peterz@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 36/37] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     Peter Gonda <pgonda@google.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-37-brijesh.singh@amd.com>
 <CAMkAt6ottZkx02-ykazkG-5Tu5URv-xwOjWOZ=XMAXv98_HOYA@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f357d874-a369-93b6-ffa1-75c643596c81@amd.com>
Date:   Mon, 10 May 2021 15:14:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <CAMkAt6ottZkx02-ykazkG-5Tu5URv-xwOjWOZ=XMAXv98_HOYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SA0PR11CA0129.namprd11.prod.outlook.com
 (2603:10b6:806:131::14) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SA0PR11CA0129.namprd11.prod.outlook.com (2603:10b6:806:131::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 20:14:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3aa15da-ffb0-422e-8e0f-08d913f02b94
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4512123D45F7FE90E696812DE5549@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BGAmbiurcaqBV8be3qAzN+CK54Ur8bveZN1/IJR64d1mCbDD11Cbi9mFGsXW4FDiE/xzMzS4JU7hLA4rWycxKPtPVoEurnldju6oxOqZpMhF5O1SV4Gk7Zp5/fnRpx4ogZ+jGTMhZdKSGkMnlaSKsBY6Xohi2XF9XX8w2dYGJQTVNzzk7NwUQ2LVbuPtcXy6MEZxbO7m4sd279IiyDSrP6AR16RBFWGLrVYW22OaopC+AZGZNZ8jnCz8H4gacvstqxQ1CufKJZUHyvdDEmfRySy9oS4eaNT2TJkdtr7A6o/PfYPvOuazNPosy+BkcJMN8eKsNPTJSTqrrlDL//7xdXpV60aOro8hhDzc/9gi+TNYmfaou3stj4rWXEPv+6TxfkAeQ+lN0OqcHY+u9b0CutvLZj9SlxXbZRH3q4zG00o7yv7xyv+MBOoPr6bmekBC9BZVAZEn6em9/dmEb+fjWqLu9h/3IxHG3Ae3+oVkXwh0VCylXOACB6ricZ6I6Gvv/ZnYI8QjvdP5XD2/+aZ4pIpYWbPF19KilMJ28Gi8oAR+TsI7wi3jtCWc/p5iHdNw3hKCONwXvD0k6aI1iT3i/E+aZdXa5l5fRFvRIgf+5AbWPsri6EygfyumNDZjKXs7YjH48wylZzSOQAuTb0ovmR3qjKxg7tSAF/gV89cpaE1aV/SzZ2tI1empRXG2S5iDVj53M0kIyOMXKvQIorgqjIKpAq8ZyQqRp9D1xyz3M7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(83380400001)(36756003)(8676002)(316002)(478600001)(5660300002)(7416002)(2906002)(6512007)(54906003)(31696002)(86362001)(52116002)(6506007)(6486002)(8936002)(66556008)(66946007)(53546011)(16526019)(38350700002)(38100700002)(66476007)(4326008)(31686004)(26005)(6916009)(44832011)(186003)(956004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MEdabW5JQmNyZFRBUndtT0FHYXNwVVhVdDdxVVoySm9HbEF1Szlua1ROUFJX?=
 =?utf-8?B?ZWMzbTNiSlR1V3NWakdmSFp6bzJEUWx4alNjazg4L0FxdGhXZkowdVRtZzlB?=
 =?utf-8?B?eTN0SFhGUTBNRUxnRXlYdjRGUzFocnJNakxCMjQwbXlhTXBhcGVUUG5SNENE?=
 =?utf-8?B?U3JZY0VsaklnblZiNnA5WG1TdlA3RDBXUi9FOTVtYzFKVTgvSnZJM3p4U0VX?=
 =?utf-8?B?Y3l2M1QzbmpsWXppRjA5dDlVSWk4STFxeitYWG9vNVdKUFBLWmhLcGc0aWoy?=
 =?utf-8?B?ay8rcWJ1dnNna2k1YWU3SThRK0dTb09ZeWQxU1V2UGdMc3NycWVDQjlvR3B2?=
 =?utf-8?B?MUxTc2pqSitIWjVYdHl3NllRb09XN29vK2tMTUtTclFoNjNpQ0daRSt5T2oz?=
 =?utf-8?B?UHZRN0JkU1VoWVRXRWtGOWxUciszUWF5VGYrRS9VVjhtcVBPVjhyZGtPMXFW?=
 =?utf-8?B?SllQNloyZm40c3Fia2M2aGNzN3NCN0tkRU5pVFFpQ1FqdVlwd0Viajg3THFN?=
 =?utf-8?B?THVoMy9oanF5R241MWQzS2VtVXZmR3JuUE1HT05DOTJ1UVl5MkxPSmdMRHMv?=
 =?utf-8?B?MmhZcCs1aE1vZnZIZDJEcUhudUMyN245VGV6b3hkbTR6QkF6aXR5b2NNQkxR?=
 =?utf-8?B?YkVFcDh5dlppcVNmdzdTQ2w4c2RHL2hJR1drc3BaVWRrQkliWndtK2dvUlF3?=
 =?utf-8?B?b3crTTVrQmlQR2VYQ3V2RkkwZ0E4MUVBOGh6NzFXeEdDYzVZeEJkY2EvUmp6?=
 =?utf-8?B?K0ZTTDAvRnhnbGs5aWpiWStqL2UrWnBMRU0ybE1OMTQyR0w1N3ZERWp1ZGUv?=
 =?utf-8?B?cXVZaFVucUFRVHFuY1Bsc0xTUVFSRFk0bTBjdFhDaitkZndqVE1abTdpc3pn?=
 =?utf-8?B?dkZ2SWg3eGk2cklnc0dKcmZpVHpEMzFoSGlhN0JLTmd2cVNTNm1pOFR5Qnpo?=
 =?utf-8?B?VWRTNnZ3dllaa1FXQUZEQ3h2ZFEvdzMxVlFKWElVdjBPdXRDek93NUt1RCtl?=
 =?utf-8?B?amorQTdTU1ArWG1YZ0l6L0IvRWRINHpoaFJGZldYcEFGR3NyMHZqRnRqMXlO?=
 =?utf-8?B?dlBYSjVUVEFhbEM1YWlteGRiczhXQnJyV1Q4MUtiOUQyQ1Q3VkdvTXoyak9w?=
 =?utf-8?B?dFpiNzhNR3RGSFpwSEtpLzJzZkxrK1MyUjhER1d1ck1CTGJ6NDI5VXhzWmhG?=
 =?utf-8?B?QTZ1bWpzQTA3bGx1aEQ2ZzZnbmp2Mm12ZkNsd2s3UWlmQXF1dWJyRWlyVytN?=
 =?utf-8?B?YWUvcVh2SnBrYnQwbUJnSHJIRnc3aVFvRmhNcFMxSE5ObU5IdEVTZlhSNTlL?=
 =?utf-8?B?STRCTVFGV3ZxdnZwK0xlQTVMZ0ZhaGpSK2FoNDdNaFIyR0pjV0UzZ0FlblJ3?=
 =?utf-8?B?K2tHcW9QNk4weWg1U1lMejk4QU82TzdPck5UdmVwUG9CT2JwdENBWEhqK0s4?=
 =?utf-8?B?bnp2N3l1ZVlmMG5tL3FKWkNNcEV2bXhPMG41WGhXRUpBQmVJS2xWQnppZnlX?=
 =?utf-8?B?bWlOY1JCaWcvNjZhWnFUNkdUOHVuQ3dITk1BT1Z1ZUNRbTc1RkVKL3d6OHNa?=
 =?utf-8?B?TVZDWFB0SHpRUHJQeGpDMlRCR3I1Y3EyWm5oSk9sZHBqZUUvT2svOGx1ZXls?=
 =?utf-8?B?cGZmMXIyQS9mSGxkNXBtZHIzRjZNRXhKcmJ4L25NaFp1TUpHMlNvOXM0bHht?=
 =?utf-8?B?WnhKbnhkV093KzR4NVFUTFgrVmErOFJMQXIrNTJ1Sk5UcUZhaGVPZDVFSWht?=
 =?utf-8?Q?7ZwdqzJOK68JAkTt5GW/Zsyfg2u+GpZcSTKJmRJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3aa15da-ffb0-422e-8e0f-08d913f02b94
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 20:14:09.5799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qjpUYHWSzenVqNiQc+U2KUvmH5jGQcfMfwNVKY6AHD4PWp9rBDEJfO0Do9bv5bsa44m/D1DUDuiU2ElUuIVWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/21 1:57 PM, Peter Gonda wrote:
>> +static void snp_handle_guest_request(struct vcpu_svm *svm, struct ghcb *ghcb,
>> +                                   gpa_t req_gpa, gpa_t resp_gpa)
>> +{
>> +       struct sev_data_snp_guest_request data = {};
>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>> +       struct kvm *kvm = vcpu->kvm;
>> +       kvm_pfn_t req_pfn, resp_pfn;
>> +       struct kvm_sev_info *sev;
>> +       int rc, err = 0;
>> +
>> +       if (!sev_snp_guest(vcpu->kvm)) {
>> +               rc = -ENODEV;
>> +               goto e_fail;
>> +       }
>> +
>> +       sev = &to_kvm_svm(kvm)->sev_info;
>> +
>> +       if (!__ratelimit(&sev->snp_guest_msg_rs)) {
>> +               pr_info_ratelimited("svm: too many guest message requests\n");
>> +               rc = -EAGAIN;
>> +               goto e_fail;
>> +       }
>> +
>> +       if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE)) {
>> +               pr_err("svm: guest request (%#llx) or response (%#llx) is not page aligned\n",
>> +                       req_gpa, resp_gpa);
>> +               goto e_term;
>> +       }
>> +
>> +       req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>> +       if (is_error_noslot_pfn(req_pfn)) {
>> +               pr_err("svm: guest request invalid gpa=%#llx\n", req_gpa);
>> +               goto e_term;
>> +       }
>> +
>> +       resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>> +       if (is_error_noslot_pfn(resp_pfn)) {
>> +               pr_err("svm: guest response invalid gpa=%#llx\n", resp_gpa);
>> +               goto e_term;
>> +       }
>> +
>> +       data.gctx_paddr = __psp_pa(sev->snp_context);
>> +       data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>> +       data.res_paddr = __psp_pa(sev->snp_resp_page);
>> +
>> +       mutex_lock(&kvm->lock);
>> +
>> +       rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
>> +       if (rc) {
>> +               mutex_unlock(&kvm->lock);
>> +
>> +               /* If we have a firmware error code then use it. */
>> +               if (err)
>> +                       rc = err;
>> +
>> +               goto e_fail;
>> +       }
>> +
>> +       /* Copy the response after the firmware returns success. */
>> +       rc = kvm_write_guest(kvm, resp_gpa, sev->snp_resp_page, PAGE_SIZE);
>> +
>> +       mutex_unlock(&kvm->lock);
>> +
>> +e_fail:
>> +       ghcb_set_sw_exit_info_2(ghcb, rc);
>> +       return;
>> +
>> +e_term:
>> +       ghcb_set_sw_exit_info_1(ghcb, 1);
>> +       ghcb_set_sw_exit_info_2(ghcb,
>> +                               X86_TRAP_GP |
>> +                               SVM_EVTINJ_TYPE_EXEPT |
>> +                               SVM_EVTINJ_VALID);
>> +}
> I am probably missing something in the spec but I don't see any
> references to #GP in the '4.1.7 SNP Guest Request' section. Why is
> this different from e_fail?

The spec does not say to inject the #GP, I chose this because guest is
not adhering to the spec and there was a not a good error code in the
GHCB spec to communicate this condition. Per the spec, both the request
and response page must be a valid GPA. If we detect that guest is not
following the spec then its a guest BUG. IIRC, other places in the KVM
does something similar when guest is trying invalid operation.

-Brijesh

