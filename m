Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B0C162A88
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgBRQaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:30:18 -0500
Received: from mail-vi1eur05on2104.outbound.protection.outlook.com ([40.107.21.104]:54076
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbgBRQaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:30:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbxDpIH7u9K09iSOZotpy/fjfcuUeMPU3iheDAZ0nh/DKBLQbEzAtZLJ0aLlCz7sBg8iMQHiQGDw3eyL1xtmCm2NzGYcI1CrO+HPmrt6hbOSC5+QKupgYfkVk1upXpjVD+c4QUmgsscAPc2e6GTM+EjG7+DrJxiNKp3Hf7VCw9yLfiP7tr7SrF2/adBOxGaK/OqKcTvD/OV8EHf5Gt0wilIizqvU0HGRis7NamSc12qhdJnzi2V35JhpFnTfp0TVYmEx2078SP4EA1zLf5Xi55txqQEmC6272cwCoqaNkbj1O71lkgfFxE94qKnZNmhgPydMfnBLRBzd/uFenSmL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej2ue1lLgmdf5zJdSOtLbPx813U8Q7wRBefSJNpzJ3o=;
 b=Swsn1bw5vCchPa0sf4RFeF3FIMjkP7LA1yPm1c+dsshgTbqsxj8JEWNKD988BYhiKul6dyqyHalCVBeVmPMbAmtiwHrCL7HQ9v6Nz/CpFQTAP7ZsIUtqnDhq8KbaQayJCkhLkiEwtAxl68jQDr2vDFE1iK/0WNAtlM4FOmwwYbfHQmfgmhrzky+Sdj7TUblxeAdbg4v8vks16pfYGH7l1IvhTlV9tFyWreb0C0ThZXG+M9aQ2kGgU5ZBF5/0XCrtue3tQCeUYwHL76i2MK7uajPMR9jtHUYAKmpW2lPrsBLsi+B0Pknz2+t5PEpzLCSce+YS9xT+M5yba+2U5PK0sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej2ue1lLgmdf5zJdSOtLbPx813U8Q7wRBefSJNpzJ3o=;
 b=qB5DAraBJoAr5LPniXJ5XQNE+8AAwCqpth2kK51kPFjZ0GGbcEV4OzvaWChvHcWI/CDdI9N1ruklF3QuiyFzhL+Vvm3aq9St1ufBsQ37uTjhLbvhHsuB38vwyVL0Gbak/IhJyBWpuoAPFTorrHPe4bs+RibSOuuFuOL1s0r579U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=e.velu@criteo.com; 
Received: from AM6SPR01MB0017.eurprd04.prod.outlook.com (20.177.39.10) by
 AM6PR04MB4744.eurprd04.prod.outlook.com (20.177.33.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Tue, 18 Feb 2020 16:30:12 +0000
Received: from AM6SPR01MB0017.eurprd04.prod.outlook.com
 ([fe80::adee:74cd:cdd3:3e40]) by AM6SPR01MB0017.eurprd04.prod.outlook.com
 ([fe80::adee:74cd:cdd3:3e40%4]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 16:30:12 +0000
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Erwan Velu <erwanaliasr1@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmattson@google.com
References: <20200214143035.607115-1-e.velu@criteo.com>
 <20200214170508.GB20690@linux.intel.com>
From:   Erwan Velu <e.velu@criteo.com>
Message-ID: <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com>
Date:   Tue, 18 Feb 2020 17:28:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <20200214170508.GB20690@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: LO2P265CA0396.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::24) To AM6SPR01MB0017.eurprd04.prod.outlook.com
 (2603:10a6:20b:1c::10)
MIME-Version: 1.0
Received: from [192.168.4.193] (91.199.242.236) by LO2P265CA0396.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25 via Frontend Transport; Tue, 18 Feb 2020 16:30:12 +0000
X-Originating-IP: [91.199.242.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7153df1f-1e4a-43a7-bdd1-08d7b48fd3d7
X-MS-TrafficTypeDiagnostic: AM6PR04MB4744:
X-Microsoft-Antispam-PRVS: <AM6PR04MB474411A38884BA3B040ABD21F2110@AM6PR04MB4744.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(189003)(199004)(4326008)(66556008)(52116002)(66476007)(66946007)(31696002)(26005)(16526019)(7416002)(53546011)(6666004)(186003)(86362001)(110136005)(6486002)(2906002)(31686004)(36756003)(478600001)(2616005)(956004)(8936002)(8676002)(81156014)(81166006)(54906003)(5660300002)(16576012)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR04MB4744;H:AM6SPR01MB0017.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2aKLyl4eXfkWPeTiu5Q1rCfizXSZsnyHnHiAOcpHVrnpABzWsYWsvqA+ti01FBB34pn50bo82LB4L1qsHnIfjVjuBnyLK8+fhxDwlMnC+oMq/ufB4ZOM9SK2FSwmAW/AiScF/mfRbYgkFwb55xC2Mq6m70NBmtSnCH9YUsUdTYwCI5+HGvisKZHtrugCDiUlo+0jVNa6Y+YwqNf0BqNkRDgTi12LtJ1VwpK73exsewu49wWRXlExibEGkvD4wd4A3rT8yTqjHQTb6rTWHk9UoFwjGCcYrpksuAjvVBtIXbMx0qTMuxGTgEeGHSR+DemPgh4zfgm7DHV4eQq0SnKW8kFP7RRPyI4W8Kn2X+9SD76nVyxk/azKroRM4Zzk+TgYbdo8zlt3wFAFH33ySIk4W3z1Q6AXok8eEEXq9EJU1yzG8vXVpDbYGUJbYhJMPI8N
X-MS-Exchange-AntiSpam-MessageData: +RakYntgVh+QenPHD3E/BcreRTNHD0XQvqNx5LBstMBBwyWa96lFobmTe5YQjgcUfiaCZy+gUyZGOF4geSQ9XN4R/NvVW+Ws+/oAp4dvPq3FMWhZCgqh14Kbm0i1WgJD+ccWQfr43V46F95a1/266Q==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7153df1f-1e4a-43a7-bdd1-08d7b48fd3d7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 16:30:12.5587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNjAu4Ezg3OT2GHlZzI3Wxjrg96fqwOwAhQnrQMF7le8+LgMtcyoAMUD++ezanezNeLmLcIOytEx8vcpI/306A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4744
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/2020 18:05, Sean Christopherson wrote:
> This has come up before[*].  Using _once() doesn't fully solve the issue
> when KVM is built as a module.  The spam is more than likely a userspace
> bug, i.e. userspace is probing KVM on every CPU.

I made some progress on this.


That's "/usr/bin/udevadm trigger --type=devices --action=add" the culprit.

It does echo "add" in /sys/devices/system/cpu/cpu<x>/uevent

For the each cpu, it does the 'add' which trigger the "disabled by bios" 
message from kvm_arch_init.

Note that doing a "add" on the same processor will trigger the same 
message at every "add" event.


So I tried the patch of using pr_err_once() instead of printk() and the 
behavior is fine : despite the number of "add" generated, there is a 
single line being printed out.

Without the patch, every "add" generates the "disabled by bios" message.


So the question is : do we want to handle the case where a possible bios 
missed the configuration of some cores ?

If no, then the patch is fine and could be submitted. I don't see the 
need of printing this message at every call as it pollute the kernel log.

If yes, then we need to keep a trace of the number of enabled/disabled 
cores so we can report a mismatch. As this message seems printed per 
cpu, that would kind of mean a global variable right ?


What are your recommendations on this ?


Erwan,

