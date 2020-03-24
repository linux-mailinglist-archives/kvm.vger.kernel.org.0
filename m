Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2B191840
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 18:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCXR4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 13:56:33 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:60899
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727223AbgCXR4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 13:56:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDQN77hKbfqaz7Zne3BbIPQ2h2Ewa4y6m0SSPhl2+xJ+MpXEk/jLbP6/mvA+Q4k3qEuAz1NnzvHIyVlV90ofsk9s7ZL7vNE01fXWWdk+4NQ4JD4eGpIZiGU9inCK6FoayWkouEx16sVDcF6SoyaiS3M2u2F11u4/whjWy3ykdcr3e6wE0Pst0h/hMK2LW+mCExuTGFBod5T9WRFJk+Do2wWQGrl8G1bHLmgiRoPkQqrutbQ0S4rm6TXPvR+rV+TmExdH9Jw0AeoE2q/jwjPy3VoBtOJQ8vpLJVkZfIsmi4Mf6vS6jitYxt2bn7ePIGLI68vxd5J+IO/oMxX0EL5R3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9luINLXe7wXxKC/O0uiTgsyd+GCFmSch3vcrjpFnxY=;
 b=O3rzxhTCn4j/4y5Fi1VcRmompwCqQ4//W3bHgUgRvQoHfbafmDDuPBkPTRYfBpFFXUsSHRaomk2YYiAJOIiBv1v5g/Y9lCoAKYr8vYWDm71oRQOe43hbxN4F7tx3spMdTZ/C7Cbg7vGd6vBD6ijodcGtGrnc92m1GHlnEafrwDrLJgwst3AFaa77GsnGbgOk26f0X4ev1x7oyf3YF0afEWYaaGWGx++rjl1bDA3ASv1SNbCgyz+NYc5iABUmlqfHqxTKt8Y4nei6ZNTbEWFAH6h6UrXgSHe0PT9wtCZ+QR8oftQ354QQKPYRlZnrJLNbGfFYKecUmTBL7WaUGbFq6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9luINLXe7wXxKC/O0uiTgsyd+GCFmSch3vcrjpFnxY=;
 b=MAndgm5ykTp1O9GjmeRylEIBFhpWV0NZ5keoZyICjjZAycMp7TpJO3vXtLMoEqkdOveHvmelcpju0zzpMGsQN/ZdnxHyy5fKRVveFYlUfkdyWx9vJoWmbLrl78PLIdaGnC1p7kQphn0dr+wilY7xE7ISEzN44KzvXhDjSPGdnww=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1721.namprd12.prod.outlook.com (2603:10b6:3:10d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.19; Tue, 24 Mar 2020 17:56:29 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 17:56:29 +0000
Date:   Tue, 24 Mar 2020 17:56:24 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: SVM: Move and split up svm.c
Message-ID: <20200324175624.GA20121@ashkalra_ubuntu_server>
References: <20200324094154.32352-1-joro@8bytes.org>
 <33af4430-e19d-c414-3e78-bcbc69d5bfb7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33af4430-e19d-c414-3e78-bcbc69d5bfb7@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR1401CA0016.namprd14.prod.outlook.com
 (2603:10b6:4:4a::26) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR1401CA0016.namprd14.prod.outlook.com (2603:10b6:4:4a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Tue, 24 Mar 2020 17:56:29 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 278b094d-6ca3-45f1-b80a-08d7d01cae34
X-MS-TrafficTypeDiagnostic: DM5PR12MB1721:|DM5PR12MB1721:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1721D026E190FF75D3D85D3F8EF10@DM5PR12MB1721.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(6496006)(6916009)(66946007)(8936002)(1076003)(52116002)(86362001)(66556008)(8676002)(33716001)(33656002)(81156014)(81166006)(53546011)(66476007)(6666004)(956004)(478600001)(54906003)(316002)(9686003)(16526019)(44832011)(2906002)(4326008)(5660300002)(26005)(186003)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1721;H:DM5PR12MB1386.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sADc62j+FaZ3GYE6FPnWn3beQLLhyCpdaM02lRiQEy2LmQYcVu1Tu49oPckA3lwMnPz1W2kwI/CCXiPP4vP3IZ5jLjamqGDyXEC7eW94GGLBxk+jP3X8UFfVZp1Li0vrc60qbyQYPkwpVm99JAOZhbVLyAtwS0l7VyIMQpc8igDYYP3xLy9ei7WgwRkMhx/bOGpXIRHmWTPR3noRlgO3kBcD260henO1okwqGEHEwahPd7I8djyMeKrYzS0OMsWqZYwL1gNAgs/CqPmJMJ+b6EdW9jKjXsRH6jyMypUx/stJnQc988+4fo79QxziNRjHXk1p/V6VgKPvqPDdCGEGs0RVBCNTjjwpJTnLE2Zdm7jO/xAcmcF6kVqVxqwIBgtpy5zDNqHoCi4cRFtSOns80XFlW9W0MQIFkwy9BiZczkEC9aCj59X2jTtDraZg2/a
X-MS-Exchange-AntiSpam-MessageData: x1XkVl9qC3zalVVjHFdM3XZY/DQ3yzSXLqZpyKNnD8R6FcE/EDU/+YUOPdLRLYaLYiBYnVaUagrHCekhSYdf2tWc7AUQmQWHaRd2y4S74vrUPNlPpJtNxqN6nxl0l8jneL7Ho5cIDU1FZr2VS/ur1g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 278b094d-6ca3-45f1-b80a-08d7d01cae34
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 17:56:29.8256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLgPbCRdIBPjE8P4O9HLvxDA+5CgluQziv1bUnE10tTD8WksgcYg9+aagAuAlmytGhmk/VSXPR8QSav+DLsE7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1721
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

I am going to submit v5 of the SEV live migration patch-set in a
couple of days and my patch-set is based on the single svm.c
file, so do i need to rebase my patch-set gainst this queued 
patch ?

Thanks,
Ashish

On Tue, Mar 24, 2020 at 12:33:17PM +0100, Paolo Bonzini wrote:
> On 24/03/20 10:41, Joerg Roedel wrote:
> > Hi,
> > 
> > here is a patch-set agains kvm/queue which moves svm.c into its own
> > subdirectory arch/x86/kvm/svm/ and splits moves parts of it into
> > separate source files:
> > 
> > 	- The parts related to nested SVM to nested.c
> > 
> > 	- AVIC implementation to avic.c
> > 
> > 	- The SEV parts to sev.c
> > 
> > I have tested the changes in a guest with and without SEV.
> > 
> > Please review.
> > 
> > Thanks,
> > 
> > 	Joerg
> > 
> > Joerg Roedel (4):
> >   kVM SVM: Move SVM related files to own sub-directory
> >   KVM: SVM: Move Nested SVM Implementation to nested.c
> >   KVM: SVM: Move AVIC code to separate file
> >   KVM: SVM: Move SEV code to separate file
> > 
> >  arch/x86/kvm/Makefile                 |    2 +-
> >  arch/x86/kvm/svm/avic.c               | 1025 ++++
> >  arch/x86/kvm/svm/nested.c             |  823 ++++
> >  arch/x86/kvm/{pmu_amd.c => svm/pmu.c} |    0
> >  arch/x86/kvm/svm/sev.c                | 1178 +++++
> >  arch/x86/kvm/{ => svm}/svm.c          | 6546 ++++++-------------------
> >  arch/x86/kvm/svm/svm.h                |  491 ++
> >  7 files changed, 5106 insertions(+), 4959 deletions(-)
> >  create mode 100644 arch/x86/kvm/svm/avic.c
> >  create mode 100644 arch/x86/kvm/svm/nested.c
> >  rename arch/x86/kvm/{pmu_amd.c => svm/pmu.c} (100%)
> >  create mode 100644 arch/x86/kvm/svm/sev.c
> >  rename arch/x86/kvm/{ => svm}/svm.c (56%)
> >  create mode 100644 arch/x86/kvm/svm/svm.h
> > 
> 
> Queued, thanks (only cursorily reviewed for now).
> 
> Paolo
> 
