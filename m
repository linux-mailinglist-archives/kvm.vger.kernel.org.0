Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7682B113D
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 23:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgKLWRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 17:17:55 -0500
Received: from mail-bn8nam11on2060.outbound.protection.outlook.com ([40.107.236.60]:55520
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725962AbgKLWRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 17:17:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxvBLyDlO0kFvN9PkqjK/KVVBqfprGBRC/sosYzZUCnjhI8OBx3XWFDhrmNb40ZjY0aNMFbl0MQzhMuKbUCkWH51TJfgPTZK+eeUm2oVaQt2laZSfLZy7D6QK7kZ08NHl3oybe9TvEh8kfvpN3uvvV0PA41Xq8J/GtAGOJ7kxFmlWREEQJ8HmQQ8+Dh2qq2wIqpSif71L5zeTdALVY7Rgl7doDJxeQ0z/mTpMRgUZrg2Mw5uG17OCTjPiMoOXZ5xzszHMrfhbZdz++YDoLoyWr74vb53aMNgQ0ljobdlQU+/aEwb9U10B1EsICrwFe53jyhmwJSdXAC+A2JX77yBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q08ehynH9fh2+DeVR+YlEXnDXlLHHA3Nw/aPhtf+Evo=;
 b=MWnU289D3dDhC6TQm31AieRDVFf1/pc+99ToBzYgFrBowLHenMe1wlBtKZkyNGlj6HXOUM+QBqj3I/Im5SOFQXyU/bLA0FWK0FJ3SGblrN5cukGjZnYeFqHn13B2BxtxTfOx7aYyC/4V7ygoWWrRUzoi4t1XaMMVbinEBp/lHZxZyivcidNzYDubTShFXDxow0ss4dXCD7ufaOEmXVdRk2IN6dox4igIBPWNekwyUtjR8PWwP+mLYB82Xbcvz3PzmKfiidtSj/dC/J7axV80TyyCMAK+UrZPORLz6cLEdn28lpRY5QbZ2oBvkyf3CZDmvdSp6SWS7++zLKIyOmGe8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q08ehynH9fh2+DeVR+YlEXnDXlLHHA3Nw/aPhtf+Evo=;
 b=B598HUTkmQypG0O0k8nCJdiR+5fbdxt9FP0D+JMrT+UOQ6YQUo96zeRgJFrYFr6eVnj2yK+nUFFvOXU5f6Vqz1pOtBB/ATDPb7PesYzT96UcB7MAex5St7+WdP3YtmqdzjCGwCE14yuyDin+Vk+owPtRqWIwkBK+U4cxVf7cuVY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 22:17:51 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.026; Thu, 12 Nov 2020
 22:17:51 +0000
Subject: [PATCH v2 0/2] Fix AMD SEV guest boot issue with PCID feature
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
Date:   Thu, 12 Nov 2020 16:17:50 -0600
Message-ID: <160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0094.namprd12.prod.outlook.com
 (2603:10b6:802:21::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN1PR12CA0094.namprd12.prod.outlook.com (2603:10b6:802:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 22:17:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0a0d79b8-6e0b-4279-ebc1-08d88758cb3a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4445FEA0FA62793A705411BC95E70@SA0PR12MB4445.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pNxP1Lp2U+Jw5sMh9a1IRVw7Ejc8O3m07mKNxC0AdfMhCJ6AB2TIkhOAVCK5MWOnjpr9kTWp27iAGG5cgpPjIrpGi3WX5alnGDRqo8iaaCMfEfygYQmklDkFVG/ZmG/mUV6P8/XxVGJniKXT4sFDf7X4sDT964rdcvieTevrEWYDc5eDm66e35UOVTOa/LAhXE6iO5H6A3JscGWkUC+pYCL+RfBUVNzl4NYsBtBuEb8B78UMHa/NK5XSzYAff8BL4Cd5+91ngc8hFFfwpw3nICBQTNUmxAdQkCUyB2QwQZOfV+N3w6shMrlgzMtcAAmygYeDnkueNN+DwMVmjrjNcuc0kd0ZL8lFdQvS5fkAz9yl3CqsAQSMt3CH9ameHSeILCCcstA+QxKrNOqHj99UsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(52116002)(33716001)(16576012)(966005)(9686003)(16526019)(8676002)(86362001)(6486002)(103116003)(478600001)(956004)(6916009)(2906002)(66476007)(8936002)(66556008)(316002)(7416002)(26005)(4326008)(83380400001)(44832011)(5660300002)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4ut1MWxvfqvLBtr8Y8ZZJSkz3gzpifKLXk172cLiQiSpVVhnRl6zAFGsx85Ff7YST9E8tkuSprHaovyH5u9Y/44FgAkDSVxalFaoKb/xY8hYOAOA46Gbv1+IuM/HcxRnRGDVc8GWU72JYxuhZBzTgWuGm2gJn4ibJHTeOr5T5LvJ+z1i26huj274pWNC8vzC5R8XpZXtb3wPd4HVdJckOugSbvvc+d2B5rEinq66+bMzV+cVDpsNf/P/vwlhJwP+S6o9h0Q8s5hC4bX0+EHjuH1A1rhG2ABDN5KNjt7Zk3JsENnTckLvEcFV+/Xyd/JO/VwpxRvGv43KAT5shbCqkCVxf0MtYNGbD2j+yS5prSlrCMuzk9sHxehdZvYkbeiKsH9gInwYiMv2cidSugmyT0DN9e5jlMnDh2v6rlzi3WWio4DQtA0Sf7lYsySVOj/QL7yxIHLtraFygUD/AYPv81ARjfKyPBHNKM5Xed4uPJC8fCPCMBEyPlZVR23iQEDd/jpBql9LYsoRP+/Y7Dp9iZ04+sJoGaMg/b9mIjNwmL/Zdo/4PKx3i5quLj6Qj69o1IjkRE338ypgdwFxM3HPIiecx/Kn7iwP6bkKajl04Ik4AP5Esng0POFzZ2lnFRbr5CTwjiybM9JqBWjVgs49+w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0d79b8-6e0b-4279-ebc1-08d88758cb3a
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 22:17:51.1252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+LPKirxrnNAiHsxC2HlvSvS5miguFW8RKpwrFpwXZN+94IkjjKQqW3la9O60ywg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV guests fail to boot on systems that support the PCID feature.

The problem is observed with SMM enabled OVMF bios is used. The guest
crashes with the following messages on the console while loading.

----------------------------------------------------------------------
[    0.264224] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.264946] Calibrating delay loop (skipped) preset value.. 3194.00
                                                 BogoMIPS (lpj=1597000)
[    0.265946] pid_max: default: 65536 minimum: 512
KVM internal error. Suberror: 1
emulation failure
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00000000
ESI=00000000 EDI=7ffac000 EBP=00000000 ESP=7ffa1ff8
EIP=7ffb4280 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0020 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
CS =0000 00000000 00000fff 00009b00 DPL=0 CS16 [-RA]
SS =0020 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0020 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
FS =0020 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
GS =0020 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
LDT=0000 00000000 00000000 00000000
TR =0040 00003000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000001000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=ffff88817ffff000 CR3=0008000107e12000 CR4=000606b0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
DR3=0000000000000000 DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01
----------------------------------------------------------------------

The issue is root caused to the way kvm tries to validate the cr3
address in kvm_set_cr3(). The cr3 address in SEV guests have the encryption
bit set. KVM fails because the reserved bit check fails on this address.

This series fixes the problem by introducing a new field in kvm_vcpu_arch
structure. The new field cr3_lm_rsvd_bits is initialized to 
rsvd_bits(cpuid_maxphyaddr(vcpu), 63) in kvm_vcpu_after_set_cpuid
and clear the any reserved bit specific to vendor in
kvm_x86_ops.vcpu_after_set_cpuid
---
v2: Changed the code suggested by Paolo. Added a new field in kvm_vcpu_arch
    to hold the reserved bits in cr3_lm_rsvd_bits.

v1:
https://lore.kernel.org/lkml/160514082171.31583.9995411273370528911.stgit@bmoger-ubuntu/

Babu Moger (2):
      KVM: x86: Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch
      KVM:SVM: Update cr3_lm_rsvd_bits for AMD SEV guests


 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/cpuid.c            |    2 ++
 arch/x86/kvm/svm/svm.c          |   11 +++++++++++
 arch/x86/kvm/x86.c              |    2 +-
 4 files changed, 15 insertions(+), 1 deletion(-)

--
