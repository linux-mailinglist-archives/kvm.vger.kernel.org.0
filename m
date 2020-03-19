Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C926718BC45
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 17:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgCSQSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 12:18:44 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:34651
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbgCSQSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 12:18:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByX+eqvW4UDQAUoLwLjA7/mez/QOShj/Hw710TYRIp8KfgoCiJcfdojpk5X81CwE1Uj/V4rwlrMRP1cOpNA5SXHiRwduu71nmCa5Yn3qwC2M2GFyOY6VVOHFntZf6QyMz+gDMo9r73UPTo7x6df+3aCuHdD2U99LKbGhonVsohew4wXBToKwGlqsEMuPwCjdgdRtVww3pJwsKDGqAVpQMfsMKb87vrs48ZM7nEUNFduSTIPtiD64JlIIsNc30iFXajxCwLzHpR1UeLZknZwbKxZmyuPveMNrHQ3mSzPf4BIpNP7LF3AjjDOzr3grtPWpvDbwVUUTkuftKTPj13GSgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGrjj271fVXqrKKgVZao3+0sDYARhI/dSd5hKAGzzM0=;
 b=KKrF66m9pwOPR95WzdqV5McJJEgiTA5LdprHJyRqmdqwJ4IuMihiSJhdHRvXWiF2iYdwV4AaKTsSqHmE4G28gbJfwPzQnxl5eUQs/GFm9XQI4RFy3VF9Lkbwj+I6rmiwEaMCAyM2fEOBPxfQHzPEHT9m28lkq+jNnkw8kmdq/SHGW7XosIX14oaQmo1wgKBL1ABhfQ2XaXFHxucjUBpNp40NyBtcLcrEr7g41+Pdya6LfqHwzk4Apsrc5qQ1avR4Ff1ne5y+8nXsOz6/JwBGxZkZRNUslsCzr4hhzE8Q0jzJK5Y6Alnf6+AWD7IRUpxqRwE/lKbAm+fuDRYnMKk5Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGrjj271fVXqrKKgVZao3+0sDYARhI/dSd5hKAGzzM0=;
 b=Eulmfx7t+EpwA51ZCW8wlm7YNabChO8CTYi0adyDqJVYpXFjadeLMvRFtkCqjPmsDwYQMICQi1zodkeIRudAMu2JUorxJJd8RzMLdEqi2JoP3JMGwO6w6fCt7J5FWCX1yDuwHvRoVLfg5jvUML5j77u92bWgIR2y4fTC+9M2Wgs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2472.namprd12.prod.outlook.com (2603:10b6:4:b9::39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.21; Thu, 19 Mar 2020 16:18:39 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2814.021; Thu, 19 Mar 2020
 16:18:39 +0000
Date:   Thu, 19 Mar 2020 16:18:31 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 00/12] SEV Live Migration Patchset.
Message-ID: <20200319161831.GA10038@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <CALCETrXE9cWd3TbBZMsAwmSwWpDYFsicLZ=amHLWsvE0burQSw@mail.gmail.com>
 <20200213230916.GB8784@ashkalra_ubuntu_server>
 <CALCETrUQBsof3fMf-Dj7RDJJ9GDdVGNOML_ZyeSmJtcp_LhdPQ@mail.gmail.com>
 <20200217194959.GA14833@ashkalra_ubuntu_server>
 <101d137c-724a-2b79-f865-e7af8135ca86@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <101d137c-724a-2b79-f865-e7af8135ca86@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:5:120::29) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR06CA0016.namprd06.prod.outlook.com (2603:10b6:5:120::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.22 via Frontend Transport; Thu, 19 Mar 2020 16:18:37 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ce5a3e42-1a47-4346-4660-08d7cc212ec6
X-MS-TrafficTypeDiagnostic: DM5PR12MB2472:|DM5PR12MB2472:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB247282CD6C83D1B3F74A66658EF40@DM5PR12MB2472.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0347410860
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(478600001)(956004)(316002)(6916009)(52116002)(6496006)(44832011)(2906002)(1076003)(186003)(8676002)(86362001)(16526019)(53546011)(7416002)(33716001)(33656002)(5660300002)(66556008)(4326008)(66946007)(66476007)(81156014)(8936002)(81166006)(54906003)(9686003)(55016002)(6666004)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2472;H:DM5PR12MB1386.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9TZ+kWYXAIObR6nDIR7A0S9Z7WOlcZzCJRLiedfdcCrCrF3GRml5qIh0lNNlVAWbisXlb3TFjeyOY8hCssgTI17ZsRngRl2yucRSK6dobU4pWfPV2Ry2YEgiq1RbUFXM/SokSR7pB/7omj5RT0+WNV1rRBkJWyM+4V0lpT0nfeS3rk+dCmM61tWt+8eQSf1a2SI+AM0uuMJmjvrHhGYA0KJTNEhhUa8otga+u/PXWBhuvaHvMz1e7Ngsfz++7hMiL0+3x3guCIA8NvwxRJ91YcKZUrPYz8IrOsciBvePy20L0ZPWzt7DXnoCkXmir+V9TGPZ3I220x1yRjosVeDCnHXZw40HcZ5OMMb18NFjlMAEY7UZQp/ZY+oSyJpuB75AQ3cGVFKIaIvKlbDe7nKdqWBmWtI99oZq4t5uxIIj+H6UNqnLz/7rm9AQd3yTrC2
X-MS-Exchange-AntiSpam-MessageData: WmYpG90IHUWy2ujkRepnvg6637wMRLmevYlL+EPoUgXASHv5MO5+0cNvXpEq6PWOY1HRER1D21B4tJTOyvRsQHhMglit7cdC9w8Ohst8oKjSrYqe4StslPzqU8U44GYB59r4wp2ikJ9/sssbaZ3ENQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5a3e42-1a47-4346-4660-08d7cc212ec6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2020 16:18:39.2085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zaQXt/dec/ylFsdjWomVCP5lu4EeK6rd+z8vW9UngStU8WjuvCKEINgle6YkBH9RUI2eCr1BMzxu6jlQx9ne4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2472
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Thu, Mar 19, 2020 at 02:05:21PM +0100, Paolo Bonzini wrote:
> On 17/02/20 20:49, Ashish Kalra wrote:
> >> Also, you're making guest-side and host-side changes.  What ensures
> >> that you don't try to migrate a guest that doesn't support the
> >> hypercall for encryption state tracking?
> > This is a good question and it is still an open-ended question. There
> > are two possibilities here: guest does not have any unencrypted pages
> > (for e.g booting 32-bit) and so it does not make any hypercalls, and 
> > the other possibility is that the guest does not have support for
> > the newer hypercall.
> > 
> > In the first case, all the guest pages are then assumed to be 
> > encrypted and live migration happens as such.
> > 
> > For the second case, we have been discussing this internally,
> > and one option is to extend the KVM capabilites/feature bits to check for this ?
> 
> You could extend the hypercall to completely block live migration (e.g.
> a0=a1=~0, a2=0 to unblock or 1 to block).  The KVM_GET_PAGE_ENC_BITMAP
> ioctl can also return the blocked/unblocked state.
> 

Currently i have added a new KVM para feature
"KVM_FEATURE_SEV_LIVE_MIGRATION" to indicate host support for the SEV
live migration feature and a custom KVM MSR "MSR_KVM_SEV_LIVE_MIG_EN"
for the guest to enable SEV live migration. The MSR also has other
flags for future SEV live migration extensions.

Thanks,
Ashish
