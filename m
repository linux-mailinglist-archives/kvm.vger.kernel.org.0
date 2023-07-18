Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36911758669
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 23:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjGRVDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 17:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjGRVDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 17:03:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9CDC0;
        Tue, 18 Jul 2023 14:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdrCY3j1LOF987MlsQPtIHdoZThiHcH2lk95JRfixczSGZTTxhqvgWV1DrxDrzsEiqF6SxhoR4JTHqWxcY5RG7t5qyR3RKNkjv3AbbPOcVD7m8tWgGQdYKlq+edg8g8S9e5hgRDuRqVniMIUcrdHVoZ4epmxzQN8Ok4NTW4Z5vpvbxMnQdyCBeeERpTcObK5QEpL71Q95+L4SyIkCTxzytd8TZtQex0D+aYBlYkBl9iS7CgVuSREQcs7zSbOCY+j8BM4Qz2YBW+iB++caz0v9r/4qMMLRY/KE8zLkgwgCTAp70aKIK9z+ZPWlAOKSaLwXCAGA4jUyrDPTJYZbhkyGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=732s8hCenZ2uI8bN9F3NsEmzykefme6Vz2jBT0usn6M=;
 b=VOWwbZYDO8xXH4iEQkBDxhuYIIb2orgOpGG8fiRo7hgyXCYxuMKQm3BCfQrBc/aiqGMSULcLtd+RwlOsUagxLDhP53iG9Lgcl7biP8u5nGG6gYAWMSNAph1dAtj3ROlJMVwCllmFZvKAMs0bdBQyxHIR9fxSscNyzt4uB1/2Mmq67vc/XsPwMf3odcInficen5RfSUkx/sPc4nVVoRrxyXwSdOsdqIlj/H42RuXXjLyxEJbyKoHQarMQ41r4DB0SS1c5khCoIZLP/U6VxIVgb61C8HE4hgj7xd80Pf2UMdzYepqgJQWYf6mU83aKr/0QDYlgxR0EDEOoiSVhwzc9vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=732s8hCenZ2uI8bN9F3NsEmzykefme6Vz2jBT0usn6M=;
 b=ps0rpxzbrabkqzDEpIo2ZtwgdnPTy5mNHsSblF73DvVj8VHC2Tah7jAoOijDotpZhvtzeoqagZ+V47GeawotpZ0ca06W7DgUeOv5ZvzeyONhBNxHG7kgZ8PIzfqU3xmUdZ1Duye/zMNb3m7U9ZZM9X0clqVR/MHtuFSOfbrUxnE=
Received: from MW2PR16CA0017.namprd16.prod.outlook.com (2603:10b6:907::30) by
 SA0PR12MB4543.namprd12.prod.outlook.com (2603:10b6:806:9d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6588.31; Tue, 18 Jul 2023 21:03:43 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::c5) by MW2PR16CA0017.outlook.office365.com
 (2603:10b6:907::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33 via Frontend
 Transport; Tue, 18 Jul 2023 21:03:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.20 via Frontend Transport; Tue, 18 Jul 2023 21:03:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 18 Jul
 2023 16:03:42 -0500
Date:   Tue, 18 Jul 2023 16:00:19 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     <isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, <chen.bo@intel.com>,
        Sagi Shahar <sagis@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH] KVM: x86: Make struct sev_cmd common for
 KVM_MEM_ENC_OP
Message-ID: <20230718210019.rqdk2azgf546b3qq@amd.com>
References: <2f296c5a255936b92cffde5e7d6414edfb93f660.1689645293.git.isaku.yamahata@intel.com>
 <20230718193918.rgluetgaiuib662g@amd.com>
 <20230718202930.GB25699@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230718202930.GB25699@ls.amr.corp.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT037:EE_|SA0PR12MB4543:EE_
X-MS-Office365-Filtering-Correlation-Id: a64cbc83-be74-4b1e-a458-08db87d2783d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0SkmskceijA87Ofn6P32AIjqXuk9Dqw6CpoAlfIFR7fxMEPFvdvYh1A+IsuqfxKz7pm8FQRkprc/9uCEMgnytmv0hvvkZXnHAfKRHklxrsRbTtpOIoYpgGfbDBaCyVosJxmUZeR27agP243Ac8I5Lh2C7qoGp4KcehJvMpkaeysLokep7+Gktb/0sm359z/fePQr5dEwcWon7dHDwuLPvBAlz0C/ZO5Ln0zHGHl2gBauRnE7VfUNwdhhenkgthSEewjTQhDisCg0LGShPyqAWyw/pcVDhjFljWbmVli9Y3pDbVToMLTj1bM51Nqizg4uWGVAtYnqzzdvTV7fanFl2ZGcR/cIYrlRD2y8lL4/6XAmDTdrXiT5VRMFe322viRBWNLw5a78fMqNUrp0inP9fQ9hl3OsuTrypiTYLOMU9HHhqkTJYo8ijg6TtVzQkwMptp4iVxCU+av3WPXhfueOidgsLOsbA2a2FC2MuyoV8mHqePHdYNNIrOdDJECUhX7kek7ca2zF+kCgtLepq4Keyv+8/XvmjTb/cuc4aNKOU+psbWF6zR+PHCKbDJqjt0EKDaQfT63a88FDN4PhgTf5xrVHh1r3KZ4WDfNGc8X1T/9i5fZz23O1kJq+2Gc5H9tcOV7EmjjR9ODj75boPHRwNKSEy2QFFn0FXgtbxnHJHQGEQC4JoR+MJ+VkvkxrdhAGz5a741QhHv2fCJGyaMtdRiiHaBrMf7FbsI8Pws63Yog+LjPB0cj4yCKlM4y0LG3lKZZRX4+jhQHU9x1yoN2dA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199021)(82310400008)(40470700004)(36840700001)(46966006)(54906003)(6666004)(478600001)(82740400003)(2616005)(36860700001)(83380400001)(47076005)(426003)(86362001)(40460700003)(40480700001)(2906002)(70586007)(44832011)(16526019)(186003)(1076003)(26005)(356005)(81166007)(336012)(70206006)(41300700001)(4326008)(316002)(6916009)(36756003)(8676002)(5660300002)(8936002)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 21:03:43.1682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a64cbc83-be74-4b1e-a458-08db87d2783d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4543
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 01:29:30PM -0700, Isaku Yamahata wrote:
> On Tue, Jul 18, 2023 at 02:39:18PM -0500,
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > On Mon, Jul 17, 2023 at 06:58:54PM -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > TDX KVM will use KVM_MEM_ENC_OP.  Make struct sev_cmd common both for
> > > vendor backend, SEV and TDX, with rename.  Make the struct common uABI for
> > > KVM_MEM_ENC_OP.  TDX backend wants to return 64 bit error code instead of
> > > 32 bit. To keep ABI for SEV backend, use union to accommodate 64 bit
> > > member.
> > > 
> > > Some data structures for sub-commands could be common.  The current
> > > candidate would be KVM_SEV{,_ES}_INIT, KVM_SEV_LAUNCH_FINISH,
> > > KVM_SEV_LAUNCH_UPDATE_VMSA, KVM_SEV_DBG_DECRYPT, and KVM_SEV_DBG_ENCRYPT.
> > > 
> > > Only compile tested for SEV code.
> > > 
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  2 +-
> > >  arch/x86/include/uapi/asm/kvm.h | 22 +++++++++++
> > >  arch/x86/kvm/svm/sev.c          | 68 ++++++++++++++++++---------------
> > >  arch/x86/kvm/svm/svm.h          |  2 +-
> > >  arch/x86/kvm/x86.c              | 16 +++++++-
> > >  5 files changed, 76 insertions(+), 34 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 28bd38303d70..f14c8df707ac 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1706,7 +1706,7 @@ struct kvm_x86_ops {
> > >  	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
> > >  #endif
> > >  
> > > -	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
> > > +	int (*mem_enc_ioctl)(struct kvm *kvm, struct kvm_mem_enc_cmd *cmd);
> > >  	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> > >  	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
> > >  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> > > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > > index 1a6a1f987949..c458c38bb0cb 100644
> > > --- a/arch/x86/include/uapi/asm/kvm.h
> > > +++ b/arch/x86/include/uapi/asm/kvm.h
> > > @@ -562,4 +562,26 @@ struct kvm_pmu_event_filter {
> > >  /* x86-specific KVM_EXIT_HYPERCALL flags. */
> > >  #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
> > >  
> > > +struct kvm_mem_enc_cmd {
> > > +	/* sub-command id of KVM_MEM_ENC_OP. */
> > > +	__u32 id;
> > > +	/* Auxiliary flags for sub-command. */
> > > +	__u32 flags;
> > 
> > struct kvm_sev_cmd doesn't have this flags field, so this would break for
> > older userspaces that try to pass it in instead of the struct kvm_mem_enc_cmd
> > proposed by this patch. Maybe move it to the end of the struct? Or
> > make it part of a TDX-specific union field.
> 
> Please notice the padding. We don't have __packed attribute.
> 
> struct kvm_sev_cmd {
>         __u32 id;
>         <<<<< 32bit padding here
>         __u64 data;
>         __u32 error;
>         __u32 sev_fd;
> };

Ah, true, I didn't notice that. I guess I don't see issues with the
proposed format then. This flags field could allow for new fields to be
added over time without breaking old userspaces, so it seems like we
still have some flexibility in the future as well.

> 
> 
> 
> > But then you might also run into issues if you copy_to_user() with
> > sizeof(struct kvm_mem_enc_cmd) instead of sizeof(struct kvm_sev_cmd),
> > since the former might copy an additional 4 bytes more than what userspace
> > allocated.
> > 
> > So maybe only common bits should be copy_to_user()'d by common KVM code,
> > and the platform-specific fields in the union should be separately copied
> > by platform code?
> > 
> > E.g.
> > 
> >   struct kvm_mem_enc_sev_cmd {
> >       __u32 error;
> >       __u32 sev_fd;
> >   }
> > 
> >   struct kvm_mem_enc_tdx_cmd {
> >       __u64 error;
> >       __u32 flags;
> >   }
> > 
> >   struct kvm_mem_enc_cmd {
> >       __u32 id;
> >       __u64 data;
> >       union {
> >         struct kvm_mem_enc_sev_cmd sev_cmd;
> >         struct kvm_mem_enc_tdx_cmd tdx_cmd;
> >       }
> >   };
> > 
> > But then we'd need to copy_from_user() for common header, then for
> > platform-specific sub-command metadata like sev_fd, then for the
> > sub-command-specific parameters themselves.
> > 
> > Make me wonder if this warrants a KVM_MEM_ENC_OP2 (or whatever) that
> > uses the new structure from the start so that legacy constaints aren't
> > an issue.
> 
> I'm fine with a new ioctl and deprecating the existing one.  I'm looking
> for the least painful way to avoid unnecessary divergence.
> Not only for creation/attestation, but also for debug, migration, etc in near
> future.  Thoughts?

Based on the above doesn't seem like we need to deprecate just yet. If
there's some major benefit we'd gain in doing so then maybe, but if
current approach still allows for backward-compatibility and future
extension then it doesn't seem like there's much to gain there.

-Mike

> -- 
> Isaku Yamahata <isaku.yamahata@gmail.com>
