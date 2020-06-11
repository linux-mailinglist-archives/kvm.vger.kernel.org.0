Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90171F6E03
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 21:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgFKTdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 15:33:23 -0400
Received: from mail-dm6nam11on2081.outbound.protection.outlook.com ([40.107.223.81]:27934
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725799AbgFKTdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 15:33:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRpSQOjLkf8w9VxfqR5g0mGl3AMBo1hrnTS2Mrw6GkAl2p+Oe3HTq68RLOOjcJIiLmmo5rAt2+qI+bgv1BAs9k2X3iOZfPynH1oe20Qa2s+6Do2FcJe+UtH3ucawqFpnaElRjl0jRvpy43VIcuoJgJfDtH0BOLyL6upYOBBbd38MtKtUOQNbmL+NPsDwmWNeVvfhp/b3ro/sHPTbfSI44VpQVaPL2TjSpaRRm/0nLoTZLkm+3vSS0GSU3ld3ac/vUniLBDgvORJgIUz9EIWQKUp6vC9zfxtXTS/MpjlwtF13Rpap2YR6Z6/GqsAGJOtqLnRxaHPfuKvN2NTLeYWxew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOeW8PL4E2enpvrFbtfdSHEAEEZV0FYcGpKhNSGHjmQ=;
 b=W1d2mpBjjRedudMfXrs+VB0p6zZu5TRMZPDuZs6Gnk9SyEdsD2Vw2MjwIXFw7GIg/WpbL0LXQbGAU+jHvBAJdO80j/JJg+6jPP2XAURwvFRarnZSelh4hCehwYdkaVhCXJwYAc+mJ+Pymd6KBZG0QnhixAeAHKjso4aVQGdz7wou9k0yi8lVFKko1Yb2jPX4jV/Z4Ymd+Clq1O6kUuYyYIBAb5+PyacctSodGWjzk5hcVHygu/k87vvpeB7OmST5YwLbOsy0J3Pi6Ry7mnnFWnA5xUlBBBBRX5HTV+0pZtPgCpAXpUn1RcvD3DINbfqOeYTvYK/b6PQD8zvqKqzOXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOeW8PL4E2enpvrFbtfdSHEAEEZV0FYcGpKhNSGHjmQ=;
 b=RdTab3Fb94XTd7gmvOzGiEbuJ2PmjQzKBT4lxFl3uP6/mPk6B0JhM1j0biRq4mnDohQimDVz4nv0XU6uL29yeGWpPQ3PCjmBfOtjK35tzlPxmhdLZbcZO9FsEubyJUK6HrJK5Gx15JrsmGXMJ7NyljrYht688VyGH0h9ZiTDCLk=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Thu, 11 Jun
 2020 19:33:15 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::39a1:fdeb:b753:e29b]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::39a1:fdeb:b753:e29b%9]) with mapi id 15.20.3088.018; Thu, 11 Jun 2020
 19:33:15 +0000
Subject: Re: [PATCH v3 59/75] x86/sev-es: Handle MONITOR/MONITORX Events
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-60-joro@8bytes.org>
 <20200520063845.GC17090@linux.intel.com> <20200611131045.GE11924@8bytes.org>
 <20200611171305.GJ29918@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <eac2d02f-951c-16d4-d4f7-55357e790bcd@amd.com>
Date:   Thu, 11 Jun 2020 14:33:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200611171305.GJ29918@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:806:a7::27) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR10CA0022.namprd10.prod.outlook.com (2603:10b6:806:a7::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23 via Frontend Transport; Thu, 11 Jun 2020 19:33:13 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 869e598c-c57b-4e0e-473e-08d80e3e4923
X-MS-TrafficTypeDiagnostic: CY4PR12MB1352:
X-Microsoft-Antispam-PRVS: <CY4PR12MB13529472AFB88319B8C9BB72EC800@CY4PR12MB1352.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gi9jKdOfeNEwAa5TJAjYBB5ZCw9J2GlFdw5sFr+duEFgVRT28K5efMBBZBl6qM7P7n13NGIyBUtotkh50nUD8ppylv099PbOmY2igbDrDIUS0niFfyxoZgOsJK5R0GyrDBIzjUwIbeLXEH0SVLltszbZvpCFCblJQ6TQ836YZUMUnlMESbJN2ptO1/Qdq59Z7wmijfAHF7gkf+9USzlYElI4PxuAGb8S/JmH/7Bhd1ysnx/kgxcCeZ/2pM41YcAFk963s0YDizFrGnFO2NIGg2ItnaAcYNym4Wg+OLtcmbKsGlVmiXmnGYB+hV/DhTjK22PGijpql6t4xE25cV6s3G05mQsEqYauBPBcZXC+/SsnutClxKWU/cee7INwpH9w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(8936002)(186003)(54906003)(26005)(31686004)(6486002)(110136005)(2906002)(2616005)(86362001)(478600001)(16526019)(66556008)(956004)(36756003)(6512007)(31696002)(5660300002)(316002)(7416002)(66476007)(66946007)(8676002)(53546011)(52116002)(6506007)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kMuVgSNUe9cZDIWVDiflMxidfw6DRA2DxfO3NvsV4iQQlfndF32PYjsbCDEyY/ah+ZFawkAPRIvOzPUAJcwkI/jPwR7g3rob8oQQQPR7PyxK/zOn8/2iApnYTuuy68SXB1uJa3EFQseVnfiFXJ8jScnWBixgPXBzUFLWcTfyEiW7GCd7hhU0cfrXBwwkElGU68XqdHHZvACfHndk3g8CwL70/ZLvd8YETd9XX7P/aui8hSiur48//FW/JiD8saccx/uAqSS4kUTYpQDxjOLxyuAOCPzGCxSq9pZXdP96issSFskAuoR1OZBFje7z4p6CdRGiX2eW/vE1j472KjGZg/7xTSgcRSG3zxlOQQHP8svLT3FW8OZUZUmXhJvQv/ml4bVIHpPdAC0EeZGPJvSwMfklhRM8mUySGhPrgSnPcrZ8v31eFQsp9SN0yePeL8s5gdokWRPsLXOP1s6UMk08hpWoZo/PE8JOM/sNS2oZgP0LRzjiuUqSLyOCIm666nvT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 869e598c-c57b-4e0e-473e-08d80e3e4923
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 19:33:15.4093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LFr/50ZczW/9r51Du/A0g/X5kAB5A5QKmZmgmmbPspvQUTUUfU7WJGxDHedjWxjuHoI+rV9kZ8JxJKVWxhzpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1352
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/11/20 12:13 PM, Sean Christopherson wrote:
> On Thu, Jun 11, 2020 at 03:10:45PM +0200, Joerg Roedel wrote:
>> On Tue, May 19, 2020 at 11:38:45PM -0700, Sean Christopherson wrote:
>>> On Tue, Apr 28, 2020 at 05:17:09PM +0200, Joerg Roedel wrote:
>>>> +static enum es_result vc_handle_monitor(struct ghcb *ghcb,
>>>> +					struct es_em_ctxt *ctxt)
>>>> +{
>>>> +	phys_addr_t monitor_pa;
>>>> +	pgd_t *pgd;
>>>> +
>>>> +	pgd = __va(read_cr3_pa());
>>>> +	monitor_pa = vc_slow_virt_to_phys(ghcb, ctxt->regs->ax);
>>>> +
>>>> +	ghcb_set_rax(ghcb, monitor_pa);
>>>> +	ghcb_set_rcx(ghcb, ctxt->regs->cx);
>>>> +	ghcb_set_rdx(ghcb, ctxt->regs->dx);
>>>> +
>>>> +	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MONITOR, 0, 0);
>>>
>>> Why?  If SVM has the same behavior as VMX, the MONITOR will be disarmed on
>>> VM-Enter, i.e. the VMM can't do anything useful for MONITOR/MWAIT.  I
>>> assume that's the case given that KVM emulates MONITOR/MWAIT as NOPs on
>>> SVM.
>>
>> Not sure if it is disarmed on VMRUN, but the MONITOR/MWAIT instructions
>> are part of the GHCB spec, so they are implemented here.
> 
> Even if MONITOR/MWAIT somehow works across VMRUN I'm not sure it's something
> the guest should enable by default as it leaks GPAs to the untrusted host,
> with no benefit to the guest except in specific configurations.  Yeah, the
> VMM can muck with page tables to trace guest to the some extent, but the
> guest shouldn't be unnecessarily volunteering information to the host.
> 
> If MONITOR/MWAIT is effectively a NOP then removing this code is a no
> brainer.
> 
> Can someone from AMD chime in?

I don't think there is any guarantee that MONITOR/MWAIT would work within 
a guest (I'd have to dig some more on that to get a definitive answer, but 
probably not necessary to do). As you say, if KVM emulates it as a NOP, 
there's no sense in exposing the GPA - make it a NOP in the handler. I 
just need to poke some other hypervisor vendors and hear what they have to 
say.

Thanks,
Tom


> 
