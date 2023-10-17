Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05907CCA68
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343728AbjJQSMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjJQSMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:12:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C40798;
        Tue, 17 Oct 2023 11:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8d4HKczakRf03hYmq8VU7UliQeRXDMjEd+7vs2FwikCYUPmpifijRENBjH2oYgXUyAk66L+4mQrGS8vOt36OPrl0RRSPBloRjhP6kigrzApp/lSYWEZmx+/aQPN4xil8dhhc0MLoK10t0NbaN6++6jXSSRLiZsEWohLTCN2pGLozNpV2pXCHeoTA2y9Ia2lCu67YpdgQTd/0lh1qisJpR3eqP70hS0GYN2B+/4tP4//NMi0ttOC4doeoHMdWiGyatYu0eQGCERxSdtXEz8rh06g4UUMgIK7HRsJKGbNbeVoNb2tO9Fv/DF7OUXo28b8DGAzirHiprQYTPm/fEBx3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPd94CsQmNSu60R4DXhPxotB+cAHX7foAUOpCrJLiBg=;
 b=YxE5QANj3jwPiD+oSHKsn+V+sfQGm0FGdwReUrDyWkLp9ThoeKaJNzpgPms9Objg0BDRXC3LyTDxGGbHI/oxUoc9HMxy63L1mTHYDq2qCQbIRVON2fzXkKml8KDB3Q1wevP3+l7IQukqNIrfsmWC9grmt+sw/g2PVCVT01REE7Yz/kIHuTd0gnyeZt35IZqkbhq6OM5Ea0V50Qv4lvMC4ImZzLIVDBEUGZOCeHUwzstwhYGX4Mb0Pb9fW/HNh0jRZwEXq+xO1f7zrASX5VbhRw2oNxgnDaorutKC0eKP+5Ggxc0MoJ59rkSXLQO03mh7DvF7oAABvQREPccsjtRhDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPd94CsQmNSu60R4DXhPxotB+cAHX7foAUOpCrJLiBg=;
 b=ergInCAJ5QYaHJnj7bU/CyzEXYO5PLJdsglrwY5XA0qQA6YRUi6ccbIIPIL2DFwzvEAPJF2RWLogqNxzSjuscDrQmwYIxYpaYNQa/2IJnvR57Fz8XWbxnAhcL3R6Q2LjDL4M3MMPKxKGTTpV6/1CYKf8TB1P5kL9Rsfs2Yh6y6c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by PH8PR12MB8606.namprd12.prod.outlook.com (2603:10b6:510:1ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 18:12:35 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::5ff2:93e0:26f:74dd]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::5ff2:93e0:26f:74dd%4]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 18:12:35 +0000
Date:   Tue, 17 Oct 2023 13:12:30 -0500
From:   John Allen <john.allen@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, seanjc@google.com, x86@kernel.org,
        thomas.lendacky@amd.com
Subject: Re: [PATCH 7/9] x86/sev-es: Include XSS value in GHCB CPUID request
Message-ID: <ZS7OjlhJKI2xlbY/@johallen-workstation>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-8-john.allen@amd.com>
 <20231012125924.GFZSftrGx43ALVCtfS@fat_crate.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012125924.GFZSftrGx43ALVCtfS@fat_crate.local>
X-ClientProxiedBy: BN9PR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:408:fe::29) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|PH8PR12MB8606:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db78e83-38d3-4927-5ef2-08dbcf3ca36f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3YIF5v3HUYX+6c1+wky9yVNPt5Tt2ueIyQfBxbSFnqkzIDv9Csw3PjYhxE/F5QRMX1mgr3ATRkq3dRdWZBpJyu0N1s6KxqXWxJdM7TBcOVGcBh6R33aatcA5W6DA4hKyvk9oHgS72tvWXeTxMKLijcMc6xhfhV96VTlQCSNg0eulZaua/ugesOBqsxOWOIuIkZYU4CVF+5gNI5thsSPSNKjmyTC2AMH0wzaCCWfQRLIIVaE4P5khytcESQKfgkUDgs4dgooljAe8eaiBvZsTNjHWQgFYrNQBnFUZVaLSQDIxXPoqZgu3ux4CdHIXNTzrPf/vCAytzXvBG3edIZ88HD15Tgq9WRjXyg5POCekrmHTorGr9FfKtgdAFhNfz8L8+NiCFMLn+aVXMzMAulpHdCl2BskXUAx7g2jjtnnMeCc4hIzIS3Salok8dC8tOabnFqyoMouSiuIjOi07oAXiL4NWyNOy0B5kcrpd+ofw0icGtb3qq2BQ07cC0/QF3ofAe1yyq7qX9bxjc3cppJ/BbdMs8pRw0BlPQz+okafyZrdc4jjBLbpxqYA6q14CR9uj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(396003)(376002)(366004)(39860400002)(136003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(86362001)(33716001)(83380400001)(44832011)(66476007)(8676002)(8936002)(5660300002)(41300700001)(4326008)(66556008)(2906002)(6916009)(66946007)(316002)(478600001)(6506007)(6666004)(6512007)(9686003)(26005)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DtZjb10978bxxR0JVix3FNaexGC0GRCIo/ybMaMmtxPG0AAaar+shNActOxX?=
 =?us-ascii?Q?v/1U2l+1NCoZBA5uF0Lhqpjv4VWJswI/McfOB7YbUJhK93dYv4zgXJCk3rJe?=
 =?us-ascii?Q?sAgyKRXZDD9gx02x3yHp4oh96w+bZ7JkHFbEn7rFun56V3/pazqtaHyl1/el?=
 =?us-ascii?Q?Fz2wCrF8vITMd+1oRwS4dXlf5P9cpqQW4Cbj8xNLD+pKjv5MpdLgBQp/OQ12?=
 =?us-ascii?Q?ajJO4DukAC91eNTdLGtV+gXR+wmNsTMhE5IvD2WoDE6Pdmj/qDoAiI1glj8q?=
 =?us-ascii?Q?lJcjI6hRlwsuImmwA2sOq8JEDtTD+Fo+h4VGGHaB8wcN+ThLKErlQsFUnadW?=
 =?us-ascii?Q?GrKScLfht1LeVIgtfTgPTD7bKJvn6Vnuw6Qb5MuAcmeUEFYpsYIhRcvXLdm6?=
 =?us-ascii?Q?It7U+FMSFIEGdQ8nffa0Y60AfknL1m1l8RpBFexJRaEWvyfeo6aTNxCGJFox?=
 =?us-ascii?Q?h/yCFh3meFGnDc6Jnuyw9iRoE5MTYsPnYn280O7BQOZQjzO/0qYmdFli0sqF?=
 =?us-ascii?Q?GMbnMu7KNjJv9tFneifZhmAMHiUZU2wcoJmqrxySlLF/ph5COMh9Urs1EZ9g?=
 =?us-ascii?Q?+oIqAJfLGGBCB8UTsGPtSpegs+2dL15AXdIfUHa9FLcBz215N1hrzx9RZwZw?=
 =?us-ascii?Q?+M9765gyYxEk5/oUw2q0rz01/TbmU0J38kn8FM5nhMRUXps6H/G/MZVubljQ?=
 =?us-ascii?Q?c7dDJEAYf1dRfI91PeGaDPs0AH9Sgg+xAAUU+m21/BTIKEQPaliagA5wBKpe?=
 =?us-ascii?Q?KPE3vMs2E7JtVDCfYfJh2no5sO6qUa7LwrgFwuYQzjgIqQa+kNAAqvBSwB1h?=
 =?us-ascii?Q?xJFdJXQtzMveelalNxLAcsd3PCt+nEdZYW4ho2q2ejbhfZ6NFd5U4ME7Dxc/?=
 =?us-ascii?Q?r7q5MZCXL5io9FRVVEil7mJIyKFc723vyu3s3NSjGKT3LuzTHJEGlRKS5bZb?=
 =?us-ascii?Q?Utey7H2QK+ae78bY6gBWPX5RJF8qLVpkba2GIVNzLjB/uw+U7abzFhmOpi3o?=
 =?us-ascii?Q?eDrqdwBYu2Av0EqxrNswuK//9orLKeESyDiGSrf7OvO2i9sQjxbp+KIK6nmC?=
 =?us-ascii?Q?KnMmcOectLjOvQBxrmsNutdD+kq2v97Mfl7IPKbmJ4rPUPfUiQCRYyzISREW?=
 =?us-ascii?Q?i5BBfVRLudI+KLPr4BehtDQ7/Me8Mgr8b6S6x6LsZj7+FKfwOn56zVxX4pih?=
 =?us-ascii?Q?QVOjkBjbQVyE/G5DSn/17gcW0AAC081hAsFXu722yERfCD4vAqJSXcKarKr2?=
 =?us-ascii?Q?YTtFl3YhbQWhr9QuGqwrSrixUE5htMMBxZnbv4/9+/DM3xQnyBDQPTyYxz3x?=
 =?us-ascii?Q?R1tw463R4Oa0SeAUeH6FXo0Irg3558A0DgII3jMy/JPDRxspqNiEnuxSGMt0?=
 =?us-ascii?Q?QeGYkGlmNROViBncNWu8yzM4JLs0DrRQkX9Rg8cAm0oYx36utOLokjeKhAL1?=
 =?us-ascii?Q?JwqMedGJ1HqWQy/lxozUFoLhWx+2fLBWvO5NsBakyUhlMjg3CKHkWyYzFPUk?=
 =?us-ascii?Q?Hjve2njBAGl9xWiGAKE1yXQ1e3NqmVZaRx7u3NnZH5dALD2uzTjbRVU8xY9g?=
 =?us-ascii?Q?o1GX2VjBBlTrveHmD0UtGiadSvsubKy3aCOWp9mz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db78e83-38d3-4927-5ef2-08dbcf3ca36f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 18:12:35.2875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75EIEsrJinL0cMWoQ/6CtRXr7H6MD9Qa5T3+a3A3xoPhI0kZ/Q8MUg59l5FA2q2yyvAK51SQP1MUv2W+03wjmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8606
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 12, 2023 at 02:59:24PM +0200, Borislav Petkov wrote:
> On Tue, Oct 10, 2023 at 08:02:18PM +0000, John Allen wrote:
> > When a guest issues a cpuid instruction for Fn0000000D_x0B (CetUserOffset), the
> > hypervisor may intercept and access the guest XSS value. For SEV-ES, this is
> > encrypted and needs to be included in the GHCB to be visible to the hypervisor.
> > The rdmsr instruction needs to be called directly as the code may be used in
> > early boot in which case the rdmsr wrappers should be avoided as they are
> > incompatible with the decompression boot phase.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> > index 2eabccde94fb..e38a1d049bc1 100644
> > --- a/arch/x86/kernel/sev-shared.c
> > +++ b/arch/x86/kernel/sev-shared.c
> > @@ -890,6 +890,21 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
> >  		/* xgetbv will cause #GP - use reset value for xcr0 */
> >  		ghcb_set_xcr0(ghcb, 1);
> >  
> > +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
> > +		unsigned long lo, hi;
> > +		u64 xss;
> > +
> > +		/*
> > +		 * Since vc_handle_cpuid may be used during early boot, the
> > +		 * rdmsr wrappers are incompatible and should not be used.
> > +		 * Invoke the instruction directly.
> > +		 */
> > +		asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
> > +			     : "c" (MSR_IA32_XSS));
> 
> Does __rdmsr() work too?
> 
> I know it has exception handling but a SEV-ES guest should not fault
> when accessing MSR_IA32_XSS anyway, especially if it has shadow stack
> enabled. And if it does fault, your version would explode too but
> __rdmsr() would be at least less code. :)

I looked into using __rdmsr in an earlier revision of the patch, but
found that it causes a build warning:

ld: warning: orphan section `__ex_table' from `arch/x86/boot/compressed/sev.o' being placed in section `__ex_table'

This is due to the __ex_table section not being used during
decompression boot. Do you know of a way around this?

Thanks,
John

