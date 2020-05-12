Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE8F1CFBDA
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 19:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgELRSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 13:18:08 -0400
Received: from mail-dm6nam10on2053.outbound.protection.outlook.com ([40.107.93.53]:6232
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbgELRSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 13:18:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muAwqAQAUWVEAbxk2uoBtiUQVppEGNa7e/pMDA3pg7momEHnQcdTt+sedDHxrRvr245y8H9AqQr3ZPEw6FMRWGjvJ6v8CJTep2Vp6iBw4m0BCzahtQz+KYMxlhEL2XE/mlsYLMMlmxknIymHi7mU9IOfkhf1SRkEsNdXfyckNeQ7dAijlITmT1AVLyBxfzZtHEn0ks40YiYJs3K1NibhzTNZVkwPYsgRSpEGWTdvUy7fV5gp9fvpGeffcDcxup1LvXJ/S43ZUkqCHH2KZB7TK9Cin4BsIZGTY9QVvd+U8PpPGdwh1kLOjDx2DH8B7hAJi/EYuoxfV3u12olxGVuJNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcwdzCjX1g5vOGblzHo1JE0LEYfsueJLYhJaVfRpVQg=;
 b=FqQLKcXv/tTtFkzUEDh23H5F+Y592ClHtN8iKcw/Wtaz5jPqw4YuaA3f++WURxIP3oQ+Jn6OGUC52Hj56MBdyoyXpneO74ax5H1GuHkGeYpUD/l9dlB0jYiiMa5G4p2AUaeWR9AIUGibvd5E8tDm+I0Q2u6dVWs8JvpNpnCdKrn9cD6dxc9UQC5i2uSP+E1To1MNnCPR40uXdGccsMFJWoLSWS7+LSyK88FMeRxanwN7aIGzsGQWGBjdiBX+DUX4FpwC/WC2nna0yAQC3befd1w8r/OT3JVXsjbycncx8++vybDzIkZH/WPikSDBGSJ4151c2T4ADpRLJAhOgw4o/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcwdzCjX1g5vOGblzHo1JE0LEYfsueJLYhJaVfRpVQg=;
 b=1Id9qAAJ3WayjtEFyWQL3rR8dl9sQlN05hGzXRrssq7IkLfUEwd+x14yZpnzOFn2szwRnwW4FfYMLPW8VJ0ejiu++Hl4uyGNjEfQHT7u0WNfd5FyvGmmfuVmG2X5wEZolvE6UdakOb8JR0d+1qZGvFxvvzVz/R3p1WKUf743mF4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2480.namprd12.prod.outlook.com (2603:10b6:802:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Tue, 12 May
 2020 17:18:03 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 17:18:03 +0000
Subject: Re: [PATCH v3 2/3] KVM: x86: Move pkru save/restore to x86.c
To:     Jim Mattson <jmattson@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mchehab+samsung@kernel.org, changbin.du@intel.com,
        Nadav Amit <namit@vmware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        yang.shi@linux.alibaba.com,
        Anthony Steinhauser <asteinhauser@google.com>,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>,
        Arjun Roy <arjunroy@google.com>, logang@deltatee.com,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        pawan.kumar.gupta@linux.intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923998430.20128.2992701977443921714.stgit@naples-babu.amd.com>
 <CALMp9eSAnkrUaBgtDAu7CDM=-vh3Cb9fVikrfOt30K1EXCqmBw@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <e84b15c2-ec9d-8063-4cf4-42106116fdd9@amd.com>
Date:   Tue, 12 May 2020 12:17:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <CALMp9eSAnkrUaBgtDAu7CDM=-vh3Cb9fVikrfOt30K1EXCqmBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by DM6PR17CA0004.namprd17.prod.outlook.com (2603:10b6:5:1b3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 17:18:00 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 13435f4c-db88-4f05-18b5-08d7f6986dd1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2480:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2480386B39E5308F713E556195BE0@SN1PR12MB2480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSL6GHOQqDsJ0CDa1xeVM3jTjucS8a3T4fJ5E/G8Ji4OIpXBJDsK6NK79OQLb0LHbtw0Z9PnKMTssrCyk12JX99TyyRlm/LHo7JOIJtfu1VGoL0DYtcZuE2ffh+MYCAx/kJooV5HrDwf6H9IOBVu+v3jR9Rpg69DJYfBLnv1Zo/VmV0Un4cIqwTeQIe/nRC4JubIDwddldFmTl0+UA5t417k0/1L0vEUrTVtjY32lXJkLacG9DSznuC0K8bIKTkhhY+MmENUqapS8d1VmxQgZQLMvyoMF048PXQq+TWB1aRF12ON1nvun8Sl+Rl/jmALUxzrr8yDx5TG2o15Q+uUtIWfm9bLbKKN1Ou95kj5HzpPFo2qaG4VtPBD/oRIQtBpV4QnurAvh8j1Hw//tLjFeFZINj/uhHi1566d2M+k4G/6xZVaWrUY1x5DuDAiw29C1ZSbSrhKhpR9xDQ2XLfD6cAZeZDqSP24OH/G43yCXh8odj6jUXfWs8ScyD/x8THnF1bGgdBrsGI+P62ZU8TQIFJGOcM0H/nsGhW80tNlJUol9fZz+n32nIJhsJkZZgPI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(33430700001)(2906002)(956004)(6916009)(54906003)(66556008)(31696002)(86362001)(16526019)(7416002)(66946007)(36756003)(5660300002)(66476007)(8936002)(8676002)(7406005)(52116002)(44832011)(2616005)(4326008)(6486002)(4744005)(33440700001)(53546011)(26005)(478600001)(31686004)(186003)(316002)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OTZJzPNwo13whiNile7YIrEcwM+6HLluuaQzSaPXvPVhsWZbxLkUMpuVmSJF2AfaGfCg86VA8yp/IGjL3x1TISkpA2jvRdv+8/Ukbmaloq1cR+1KLpu+7FowEhkcmw5FqI1o55FKhthYI0L/GPyKfS6R5A2uQSMTcAwDkDhc0BQCrt8jRTNhPPPfCN/7TGkkr5GsbrOp8HRkLNY8ur2oWs2ONuK6s1HBdSGf8h6UT4WD6WEdrxbR3/dSh/6h9BbPeccjkwPWloS40MZvD1wj5D2BLZC7KdRbefc7/LjQqtaAi8GzfSjU+HaTt5Xw4NqSvvD8MBalJGcG/M+BElHSceELNALL0n5JHLwJWDs6Ok1nR9+kiE48DIYAqMXEfU27zKknXJDPL9uwXoQS6fXZIm+ifIJdOsTZcM8JnyUGFkzC6R1kAs20aDKjNftHH9vj0wKa5Xyt6EDOlBdvJhjXI+VYJjLcA1trhl5lVOokCGM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13435f4c-db88-4f05-18b5-08d7f6986dd1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 17:18:03.5825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4JZVE3WvaHVu7yBWFqdTJ0Zt1hB7BV0Uf83qBm6MPMK2otc+ASk0NHfoQq3uMRk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2480
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/12/20 11:39 AM, Jim Mattson wrote:
> On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>> MPK feature is supported by both VMX and SVM. So we can
>> safely move pkru state save/restore to common code. Also
>> move all the pkru data structure to kvm_vcpu_arch.
>>
>> Also fixes the problem Jim Mattson pointed and suggested below.
>>
>> "Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
>> resource isn't. It can be read with XSAVE and written with XRSTOR.
>> So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
>> the guest can read the host value.
>>
>> In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
>> potentially use XRSTOR to change the host PKRU value"
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
> 
> I would do the bugfix as a separate commit, to ease backporting it to
> the stable branches.

Ok. Sure.
