Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550671826D2
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 02:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbgCLBtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 21:49:16 -0400
Received: from mail-eopbgr750054.outbound.protection.outlook.com ([40.107.75.54]:19523
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387575AbgCLBtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 21:49:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kX4gJ2WkuXbhUE+33C7yIRq3+ywqQucwSh1qFYphMuauhMH2YlbKMEuv77gEFgmoSP+hfLgUhjlwQjzejbPlFDsyEy5lQVVfutIgr4mINv3HXlYuSRhE4aQnEKibeWduZQv2vLi52P8c7HL1EURZbBL+NyXgi/yHitYrSZxvIWLqJp3t5YreT56dWQ3ZbsxiCV8pYzzaHLilCyh++t4JWRyHP6fg+rCJUHyDsSqSuuWcHKxvqAqde0PrsE6w/Mf3ZWMRD767Jf+aE1GjchJzyq6sPx/OCECjpZ6rW+Z4kCQOcs+Vq6PO6LzXcv0Z6QTkW5xrGVW3N0WAIBEiLmMZOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ut0xvl+DgtXikvkQR4a6jNnmcKDxrSiiLdm74ZjIoTM=;
 b=QM3F74ELWEbYxcpqK/+55dRQDGj7vgmvDX4lAcB6CSiciGXRSz+BbKVfNb9hepPksRw+cPkN2EzhJCuwTZVpnAg7d5TfUueA7LIIME7AvIaKT9/SnRxXkZCt3SShDoWXvkAUiIEaf5nG6lRfYDwv0mUNK64NcfEB5QcSuWixTdN6CJS7XKySm/zNELORoOBghHuUurFbWGU7lpXXt3aOdr1lEZZb98QAZj+IXOO3DU+ikZHN9EvEtu7rWu3w4HeKg7dE4AMoQ1Kll20z+zaLyyh4XObuYpf8VRQl3FbWrCuLRwafG/8AW9pfQ2JJfkh6IIpyNBf8LbgeC1FxUfTN8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ut0xvl+DgtXikvkQR4a6jNnmcKDxrSiiLdm74ZjIoTM=;
 b=tm6Kx6JU+x1giCNICg8tQg5lmmYXg/uHXMy9TdcVU5e/K3JcQuBTVpS8T+70EXOkgbkSsIVS92VYbB7aRgR9HabOHInTBYNXZUtugSsqdpGV/Pcf7T2Zouct7Vut2aG3PdrqQ5KTjWyqeBsHd2RWfpJP9le8LkoaJNEplzCT3Yw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1691.namprd12.prod.outlook.com (2603:10b6:4:8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 01:49:13 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 01:49:13 +0000
Date:   Thu, 12 Mar 2020 01:49:10 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, brijesh.singh@amd.com
Subject: Re: [PATCH 02/12] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Message-ID: <20200312014910.GC26448@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <b1b4675537fc592a6a78c0ca1888feba0d515557.1581555616.git.ashish.kalra@amd.com>
 <CABayD+cZhCUkEAdCv+qTgvBOzsfDX5Vo8kYATHZDa4PwX_PYiQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+cZhCUkEAdCv+qTgvBOzsfDX5Vo8kYATHZDa4PwX_PYiQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:3:115::20) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR11CA0010.namprd11.prod.outlook.com (2603:10b6:3:115::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 01:49:12 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c7fd4c6b-ac54-4b85-899d-08d7c62790a8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1691:|DM5PR12MB1691:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB169101951C74060AB52108918EFD0@DM5PR12MB1691.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(199004)(1076003)(9686003)(4744005)(8936002)(66946007)(4326008)(66476007)(54906003)(55016002)(33716001)(8676002)(86362001)(81166006)(33656002)(66556008)(81156014)(5660300002)(16526019)(478600001)(7416002)(316002)(2906002)(186003)(956004)(6916009)(44832011)(6496006)(26005)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1691;H:DM5PR12MB1386.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m1ad7vQNSFeK+pIRWOXmd3AftGLuLi1y/BOMHyI6vZKtpSY85xeD4/IxWTpfQCmur1oLusu24IM2tWAjz6+h8k3z0RqE31lIrguWqYStEfp7L8CuOzbLUm/uQVgFSEv3MLsItpqCNI/aZpfYihk5GRiGlXtoZz4pc0AGfrPif6kZTQvZDRu0WcUFjN48/6iTmaZMN7+NqJj0aKDE1WqjvcPGhCAHetVm6v8KmB9VYkJz6IKRBV/1G9rqv/6xTsv7P6QpfxGtSYXjxF5TrKj0DmlH9ry1Hfa+XeTR95ZQ4k2sGvHZpYQxosThrt63yon1AGvBJVZF9t6X4J4n9h0lcfD4JUVxTicD0Kw/B0CCdIIGkdsiGwD4QbqG2O5/Xl13gLhv2D5lfMKgBg1JHOVIdvP3kIAUQyxXoG7PBZp/rA33OF6XvM3A2X1yvyDxk3kw
X-MS-Exchange-AntiSpam-MessageData: 9H1Bd3vq/YWU13WIDd2OfPnCa0yU9SbnBROzsDzRqjHUd9y2Y1DexVWhE8Tr2D8M7PPeeQHOUDi1tTFscdXI+c8BPTKcm3CbjTv3NwX0UZx86eQtdbjhQaFJ2vA9IFoUuOwZpIn/z1MxcSsfJsPXAw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7fd4c6b-ac54-4b85-899d-08d7c62790a8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 01:49:13.2791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w6BkB7CdP/yA0zUsch7TKZq05lhzF2B+3N1MwQaNJm/Dd5AuQ/oV+ESN/9/LfmHGFjNM5K1Flf3uAKq/2ZM+3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1691
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 06:04:56PM -0700, Steve Rutherford wrote:
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 17bef4c245e1..d9dc81bb9c55 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1570,6 +1570,15 @@ struct kvm_sev_send_start {
> >         __u32 session_len;
> >  };
> >
> > +struct kvm_sev_send_update_data {
> > +       __u64 hdr_uaddr;
> > +       __u32 hdr_len;
> > +       __u64 guest_uaddr;
> > +       __u32 guest_len;
> > +       __u64 trans_uaddr;
> > +       __u32 trans_len;
> > +};
> Input from others is welcome here, but I'd put the padding in
> intentionally (explicitly fill in the reserved u8s between *_len and
> *_uaddr). I had to double check that this pattern was intentional and
> matched the SEV spec.

struct kvm_sev_send_update_data{} is used to get/send the information 
from/to userspace, while struct sev_data_send_update_data{} has the
paddings and is packed as required by the SEV spec.

Thanks,
Ashish
