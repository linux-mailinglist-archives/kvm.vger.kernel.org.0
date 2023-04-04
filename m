Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04126D71FD
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 03:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbjDEBcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 21:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbjDEBcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 21:32:51 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830802710;
        Tue,  4 Apr 2023 18:32:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exT2onnvHJMKhuoINKwKlzttf9F0OgsGeC0zvF5RB90KhddnGDWcwjOPTVNhrPsanSPmZ0+70YJl2ptS0e8wiO3KOML7o9zGWspb2EwzZqfEuSjsNhTTc/YCnVd6b48+9srnz1NLX3ob20zARqSOCvj0+yiHozQYfJQQtweCRWBBz23KSvDMVR/4hd8hqug/6WYvkQMOvdfczQlpzJe99ZdJB5SvPDDclxDrULXmYzAAQF5Kocm2QrZlm1DxDPG2Y+4I3NaRLI2gQ64aRm+JtUM32jEfNWq+y7auMb0Se65jZPWBPA8YTo9LJ3iS9Ta2tryO9EnupAiOJMvF8SgrgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FzslyonlON//o9itqOpGRm13XZjlfWaQ9nkmget7Do=;
 b=f5dihMrkoG7wQwk5/2WHKShjoIRrGKJgUBqoQTyOEkS6DaCrp6c8wjceskoIvkS3kC+KlkJeoQdsYQ85eZVh5t9aOh8+DpWtarlUZZpdjmLuhHjPDpR8QYGuKDlYYB4oCrQDsE48zmh1CfRNph6lBt1ByjU7rGcj1+PlMrBYAkoNzxDnQ6UA2u5Z8IkH9rn+0jBbNrigiQB44jl33hNv41sEJ/sFWiS8hgZcDUJM3HIXbHO4VGYrPMS6Zp4duDhfu1uHoTLmetWqWc6jbuwPfAEgi1L0skh7rFE398V/My3+GQGUbuQNGUseEJsdQHUOK7ht0ZyA9vJtJeU4VBFxdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=amazon.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FzslyonlON//o9itqOpGRm13XZjlfWaQ9nkmget7Do=;
 b=CMLQn4Vo2T5BQKAOso0r/5MuuQ9v1Gq1f5/7Zyh1ZG4I+djCsFKu1q9lFsrA9MBM7Avov7fwIT91BoRdMBsOyqsO49QopCYFS5cvQv6N1UbKZMW4pwITEcv4Qsz/LMUmJg8Ttq7io1PcMPuvv/ejItk7T1J+l2TwC0+BRipuK5k=
Received: from DM6PR11CA0003.namprd11.prod.outlook.com (2603:10b6:5:190::16)
 by PH0PR12MB7094.namprd12.prod.outlook.com (2603:10b6:510:21d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 01:32:47 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::3a) by DM6PR11CA0003.outlook.office365.com
 (2603:10b6:5:190::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Wed, 5 Apr 2023 01:32:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.16 via Frontend Transport; Wed, 5 Apr 2023 01:32:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 4 Apr
 2023 20:32:45 -0500
Date:   Tue, 4 Apr 2023 17:48:02 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Alexander Graf <graf@amazon.com>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v8 47/56] KVM: SVM: Support SEV-SNP AP Creation NAE
 event
Message-ID: <20230404224802.23fbe7kxa3h7tjps@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-48-michael.roth@amd.com>
 <09696af0-b72d-29e7-862b-22ae4a630299@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <09696af0-b72d-29e7-862b-22ae4a630299@amazon.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|PH0PR12MB7094:EE_
X-MS-Office365-Filtering-Correlation-Id: eec5707b-1eb4-4223-1314-08db3575a90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmX5NKjNJlfscop6GfFb//wQFqtJ7CYZPN4Qsx4hKNNyoLjI98hij4NtOg1TeyHyJjiji6eBM9jjX7JVfOajYBoaYx0jM4I+gIsTn7oQ621hXqXCzOhJGmaU75oEatZP2eTZPBQpc0RJyPovqIcbf30qEJxSmUK0+KoLLa1RQUUnuRionqxWUnnKH9bcPl1m+28xnV5BusEyhjL+kHLkla+kO1BzNXKmNZySTBD7ilOVkMPYgCFPZy3bLglAIGZhhrxpcP7XiNNG/Ofqb2EpQtrvUYRxIXNCNpIPXuNpMeiIHrWMfDlGhcb5pbj5PgLs42vuk5Saru20ur4VtJfQchd2Nopt2nayIRFa9MWkswQxzgNiEUH8LSsWcxdILuepZzU47t/Vn45L9MJwX5/R28LVl7VgCCa6luPfi4Jlu7vT3ufR8JmPVsm7kkPMXnOST1jl+iqydPdFXA9kulsOIouCyipMB9xuj9ipYpRawboMUOCsbQq7uZlfPH+9DzIg6OEwOXm5u5vhckV0y3XW2gB1uX5pPe0D2Xm44x8ZDAkNpWuYgl6jgo6/HIAMgwW1DAv15TApH+hMOUS6RKxKAROZduK41rAirm/0CuPxo8LR1URs1c5qksvsdr11M6Vv0nyXg/r6TL7JSvw0xLoWJXW4mQ1y4BkwpQGvmFH99KhRkvLJj3LXvMVnpQy72YQAyg9WvPNcoZy57ELZ7EpMwI9JOWEtFE/BRFY0tgTY8Iw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199021)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(41300700001)(8676002)(4326008)(36860700001)(70586007)(478600001)(70206006)(7416002)(81166007)(54906003)(8936002)(316002)(356005)(44832011)(7406005)(5660300002)(6916009)(82740400003)(53546011)(186003)(83380400001)(16526019)(426003)(2616005)(6666004)(47076005)(26005)(1076003)(336012)(86362001)(36756003)(2906002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 01:32:46.5797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eec5707b-1eb4-4223-1314-08db3575a90b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7094
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 01:37:48PM +0100, Alexander Graf wrote:
> 
> On 20.02.23 19:38, Michael Roth wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
> > guests to alter the register state of the APs on their own. This allows
> > the guest a way of simulating INIT-SIPI.
> > 
> > A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
> > so as to avoid updating the VMSA pointer while the vCPU is running.
> > 
> > For CREATE
> >    The guest supplies the GPA of the VMSA to be used for the vCPU with
> >    the specified APIC ID. The GPA is saved in the svm struct of the
> >    target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
> >    to the vCPU and then the vCPU is kicked.
> > 
> > For CREATE_ON_INIT:
> >    The guest supplies the GPA of the VMSA to be used for the vCPU with
> >    the specified APIC ID the next time an INIT is performed. The GPA is
> >    saved in the svm struct of the target vCPU.
> > 
> > For DESTROY:
> >    The guest indicates it wishes to stop the vCPU. The GPA is cleared
> >    from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
> >    added to vCPU and then the vCPU is kicked.
> > 
> > The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
> > as a result of the event or as a result of an INIT. The handler sets the
> > vCPU to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will
> > leave the vCPU as not runnable. Any previous VMSA pages that were
> > installed as part of an SEV-SNP AP Creation NAE event are un-pinned. If
> > a new VMSA is to be installed, the VMSA guest page is pinned and set as
> > the VMSA in the vCPU VMCB and the vCPU state is set to
> > KVM_MP_STATE_RUNNABLE. If a new VMSA is not to be installed, the VMSA is
> > cleared in the vCPU VMCB and the vCPU state is left as
> > KVM_MP_STATE_UNINITIALIZED to prevent it from being run.
> > 
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > [mdr: add handling for restrictedmem]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> 
> What is the intended boot sequence for SEV-SNP guests? FWIW with this
> interface in place, guests will typically use in-guest VMSA pages to hold
> secondary vcpu state. But that means we're now allocating 4kb of memory for
> every vcpu that we create that will be for most of the guest's lifetime
> superfluous.
> 
> Wouldn't it make more sense to have a model where we only allocate the VMSA
> for the boot CPU and leave secondary allocation to the guest? We already
> need firmware changes for SEV-SNP - may as well make this one more.

I don't think we'd necessarily need a firmware change. We could just
free original VMSA back to the hypervisor as soon as those APs come
online. The down-side to that versus deferring cleaning till guest
shutdown is there is some flushing activity (see:
sev_flush_encrypted_page()) that would now likely be occuring during
guest boot up where the overhead might be more noticeable. But for SNP
the host likely supports X86_FEATURE_SME_COHERENT so the overhead
probably isn't that bad.

> 
> [...]
> 
> > +
> > +static int sev_snp_ap_creation(struct vcpu_svm *svm)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
> > +       struct kvm_vcpu *vcpu = &svm->vcpu;
> > +       struct kvm_vcpu *target_vcpu;
> > +       struct vcpu_svm *target_svm;
> > +       unsigned int request;
> > +       unsigned int apic_id;
> > +       bool kick;
> > +       int ret;
> > +
> > +       request = lower_32_bits(svm->vmcb->control.exit_info_1);
> > +       apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
> > +
> > +       /* Validate the APIC ID */
> > +       target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
> 
> 
> Out of curiosity: The target CPU can be my own vCPU, right?

I don't think that would be the normal behavior, but maybe with some
care it's possible for a guest to do things that way. I haven't seen
anything strictly prohibiting this in the relevant specs.

> 
> 
> > +       if (!target_vcpu) {
> > +               vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
> > +                           apic_id);
> > +               return -EINVAL;
> > +       }
> > +
> > +       ret = 0;
> > +
> > +       target_svm = to_svm(target_vcpu);
> > +
> > +       /*
> > +        * The target vCPU is valid, so the vCPU will be kicked unless the
> > +        * request is for CREATE_ON_INIT. For any errors at this stage, the
> > +        * kick will place the vCPU in an non-runnable state.
> > +        */
> > +       kick = true;
> > +
> > +       mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
> > +
> > +       target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
> > +       target_svm->sev_es.snp_ap_create = true;
> > +
> > +       /* Interrupt injection mode shouldn't change for AP creation */
> > +       if (request < SVM_VMGEXIT_AP_DESTROY) {
> > +               u64 sev_features;
> > +
> > +               sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
> > +               sev_features ^= sev->sev_features;
> > +               if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
> > +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
> > +                                   vcpu->arch.regs[VCPU_REGS_RAX]);
> > +                       ret = -EINVAL;
> > +                       goto out;
> > +               }
> > +       }
> > +
> > +       switch (request) {
> > +       case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> > +               kick = false;
> > +               fallthrough;
> > +       case SVM_VMGEXIT_AP_CREATE:
> > +               if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
> > +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
> > +                                   svm->vmcb->control.exit_info_2);
> > +                       ret = -EINVAL;
> > +                       goto out;
> > +               }
> > +
> > +               /*
> > +                * Malicious guest can RMPADJUST a large page into VMSA which
> > +                * will hit the SNP erratum where the CPU will incorrectly signal
> > +                * an RMP violation #PF if a hugepage collides with the RMP entry
> > +                * of VMSA page, reject the AP CREATE request if VMSA address from
> > +                * guest is 2M aligned.
> 
> 
> This will break genuine current Linux kernels that just happen to allocate a
> guest page, no? In fact, given enough vCPUs you're almost guaranteed to hit
> an aligned structure somewhere. What is the guest supposed to do in that
> situation?

The initial SNP support for guest kernels already made use of
snp_alloc_vmsa_page() to do the appropriate workaround to avoid allocating
2MB-aligned VMSA pages.

-Mike

> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
