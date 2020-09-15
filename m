Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9942326B748
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgIPAUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:20:53 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:28960
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726859AbgIOOVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 10:21:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0BD1bv0e3hq4jy2ggZs+HiswKXnFfez8u9bqdj1ICQPGwpUlydgxipmHV2XM+Vh/kdtSKqxgt/lCUIENpkns+gQffCpJUxk4ompRBpjr3Xdr1AGm6IuhD7nw5aD4SSRUcwtmWeu2YMirqWi0/zjQNHdD/+TPf9RQLi7pKlxqgJ5JVKe/j64iMvN3XgTBDFfSrVUIzmycIJX4CpH0Wq3yVQDxaDSQhDCY98LhXHBkVU51RUO5RCTN9CM0fB1FnwGyAR8nXS9gXvBAGd7geJoqQGQ9t/StYa7G/PJc4iLNO6FAH4ZRGJyY/MYcrLQ152UBIt/tp72y3Y0xd0bgsBupg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCMVhSiz/lELuX+gidZX0lDVOw0FwBqVaNCw5LdoK4E=;
 b=cbXE4r3/nrMdGRCfVps6I5luxYSxMF3Jsn7ELKS/A4JRot5m+NZAY9ngmqJ+E0RHcX0uX9u4BYOuH4EnBg4PoatkzyKwn26Ya20RepJTObA6MzOPm4brup13vy6sg/8mwTBZSYbdQlchQVxtgqXlpn9xMav3RB95wtU3IHqsQyLG2wPsxW5HSVgajM8BHmREj4RzU7WfFdKSty8AFNQoFb89E3ggwnac2c+M8e41jXgJVLgavzHZf1iavU+DxZW9Rt5uflwzSidEghjh+YL7Z3nvBOivozmjCSfdR0AZz/JPJWri/qBqYT47c1guaCj8vDbbbKg4qQFBtkbmgjPBcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCMVhSiz/lELuX+gidZX0lDVOw0FwBqVaNCw5LdoK4E=;
 b=ZW57NUE4UOfXbmzkTK2/Pf9omYpoEAXlo7Jz4PqrTjR07rulMXCb7sO+8dlxmU/WkeEbT3NghJWgQWOyM5xjGjXMDwf8+xpnXwxluXaeLPv2sVwK5IcxKNjKcieqb6rQxwO8efr5FktZHW+KAMTEmw7n/5R9Y96HoGrmR1ftZE4=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0214.namprd12.prod.outlook.com (2603:10b6:910:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 14:19:49 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 14:19:49 +0000
Subject: Re: [RFC PATCH 25/35] KVM: x86: Update __get_sregs() / __set_sregs()
 to support SEV-ES
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <e08f56496a52a3a974310fbe05bb19100fd6c1d8.1600114548.git.thomas.lendacky@amd.com>
 <20200914213708.GC7192@sjchrist-ice>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <7fa6b074-6a62-3f8e-f047-c63851ebf7c9@amd.com>
Date:   Tue, 15 Sep 2020 09:19:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200914213708.GC7192@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:5:120::49) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR06CA0036.namprd06.prod.outlook.com (2603:10b6:5:120::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 15 Sep 2020 14:19:47 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 253ffa66-89a1-4431-ab4a-08d859826752
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB021458A181470E3977E2FD81EC200@CY4PR1201MB0214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: avKFysuLcqjtgM3CMGFzfjoGJUSHpqdL9Qt6J9zl4otfkcL4fG9DJXLZdqQ02ugEVXBMaRF++DwBwl4aBF3jRPX5jszLqqUgU4FegG+H/l6bzUc0q9BPbLwEDazpUZVmhu2cXaKTC0WlKa3lUM4pXoJF+myVluafai7jJikpxxPAqN+Ju9TCDZm0oiZ0NzPgQFk53Seao84TVzuTk3MBJo/CdKTnvNaOqFrNz9Q+EoPvnf2Ja/k//kTxRHqUoRzfZ3MdZtrjo9i3CP5/OCi947qS5qn8CRVmSNS+j1sGjxiQHZSmAoW4hO0xHZmMbeDn0DS+Y2Xy+PXnE8A3wXDPnVq7TwC8irofZFWB3Dhu2gpedAYrFdqb08+yvLNVGPNs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(2906002)(53546011)(8936002)(478600001)(316002)(8676002)(186003)(26005)(6486002)(4326008)(52116002)(16526019)(31686004)(54906003)(31696002)(86362001)(6916009)(66946007)(66556008)(2616005)(16576012)(956004)(66476007)(36756003)(5660300002)(7416002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PkrvL2Vud22hTnrawOsn1H/NOowdKBzeqZXs29ZpKzZ85oGk5K1XaqYDRUy+mQQIBlgc6hcSafCmw2V26Ukx6ctBermpo/6S7M9PuExYlbmviYevfBO/V51ucMS+4efXwhZ2ZVLVNirANEMdsXEEryBlLMlBt+ubW24ebZjijBHVdhQw+RpPu3noGZCN11hm8rtqXvsZXg1B1kvPmGW3JpnzMeLdyG/G51Ol23l88HrxEhA7RP3jqbMvJ9cOsbKflhwD2ZKnhskrmx2lL6vAiMecBts+Duko5oJ14mGewZTf6dw/JPoMgkOUpBvwBUjsPQ45n45C+fVYVWFuDXh78U7oWKKVfF7HSoC5SnoKlzrVmK5YkPR6CRAyrioCovH8IY2vQiYbPtONbKyCXHmrYVQhhyKkxIFJ2tzkl4a60Hoz85uePRqEKVBX/2wgFrB7vpLMFocagOyWCFXywBn4xeqZzeZFJTwnWy/Vm8VJajS+xcpPKPbAYYcVLzyfl+Jt3pXlrVHT9Ur1A8zqhFsc6iTKS2sYMT4SOuIe+I0jgsODw3ZhSSLhKg8FpFCJbqI5ZU0TtqePgIxtgXSqoVXT1ThYJSB5j3ZvWLPpEHE3e8jAZyit39svf8Bvs4A7xZ8vjBPVVwWXxkq5MUcRAzwXqg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 253ffa66-89a1-4431-ab4a-08d859826752
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 14:19:48.9375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GnTtaQyv/kg9boLeDO6oJjOOZtfW0Wr0jxHz4HpaqWmIiL2dGhpbVnHB+6mPGaCMtHKoF2Mc61kqNfX8N1NyTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 4:37 PM, Sean Christopherson wrote:
> On Mon, Sep 14, 2020 at 03:15:39PM -0500, Tom Lendacky wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Since many of the registers used by the SEV-ES are encrypted and cannot
>> be read or written, adjust the __get_sregs() / __set_sregs() to only get
>> or set the registers being tracked (efer, cr0, cr4 and cr8) once the VMSA
>> is encrypted.
> 
> Is there an actual use case for writing said registers after the VMSA is
> encrypted?  Assuming there's a separate "debug mode" and live migration has
> special logic, can KVM simply reject the ioctl() if guest state is protected?

Yeah, I originally had it that way but one of the folks looking at live
migration for SEV-ES thought it would be easier given the way Qemu does
things. But I think it's easy enough to batch the tracking registers into
the VMSA state that is being transferred during live migration. Let me
check that out and likely the SET ioctl() could just skip all the regs.

Thanks,
Tom

> 
