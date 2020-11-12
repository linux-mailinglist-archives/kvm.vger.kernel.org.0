Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB82AFD44
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgKLBby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:54 -0500
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:10913
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728060AbgKLA2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 19:28:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5tMhbtBbYIsEEE0m64sOE4Iuc2EyZEj+LqT4/BvyOt5SYoUQyunVp4sA1AE1a/2YZz0ihOYgARm1xv9rd7+2AF6Lz7OWi8qGWRWEzjS54Z0Xm0ObM1cygC4qc/+rEcYiYjhD2IdWTN/5lwWhKaxkWsg2NtnyKAXc+AA3wwDAbGf88g1v09gUfBE2rN8xC7LdZdEex7QgYA3rLd/S1+ktGz7sW/z5SkW1T2EF933YSoa57Z4yJPxT+OM/92QHSVsMhapyIa6s00sdJ9f3LVcQPymFuJl4mZlvh3uhdkSgVEGoN4FpjaeCjtvlgeOuZHq5Xrhc22ytfWiZvcm+zNZFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXWP/pqgaf6ycheaTGEUkYexDy0qC61GELpWs1z5IIQ=;
 b=gQ3L0QXSxMiHRAYKihj8jk6HwUBKFqlO3+TPkquUQiX2U8NaMVNYmzDOW3D7jXBfPNyvEVu/jJ2BylQ1H3m1H28zqp8pYCn/3ik+xsco6Do3UfOOjSNWtG2x13pVcXZgEl+O9JRgvn+kTCaqk0PbbugJ+3FDKTPuPl18HgizcBEKYqAXEYDzaoaQPG7lSgLeb9LLeTXtf6/kHEnm95JGkUTWZDmjV1IFkWafZyt5qDZ7urB3Gr9kk2We9YjhkiDsc3ovs5JwlXV2LS8JqHQPk0TuHwnWYtcIxgN5GCf0Qk2RfYGqwFr2EqpA7lphEoa9IAXx9LRBo7yWKQaCzgbp8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXWP/pqgaf6ycheaTGEUkYexDy0qC61GELpWs1z5IIQ=;
 b=uvCICGrmkq50OTGVwPp0uesWAUDYCNwmC/Ta3EdO5xF+q2cyHzMfDzUZDH5R2qYxlxkXa5jD5u5V09qo7lhrX/Zx64QHfPkR+m6oeZoRLGkmeF1ycfEFAwuIiAYp33RBK1ktkUER0Xv+zvuHdXqFjtStRO18am3delVbkq8fcIM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2797.namprd12.prod.outlook.com (2603:10b6:805:6e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 00:28:14 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.026; Thu, 12 Nov 2020
 00:28:13 +0000
Subject: [PATCH 0/2] Fix AMD SEV guest boot issue with PCID feature
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
Date:   Wed, 11 Nov 2020 18:28:11 -0600
Message-ID: <160514082171.31583.9995411273370528911.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR12CA0022.namprd12.prod.outlook.com (2603:10b6:4:1::32)
 To SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by DM5PR12CA0022.namprd12.prod.outlook.com (2603:10b6:4:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25 via Frontend Transport; Thu, 12 Nov 2020 00:28:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3445ed42-68a7-40b4-b20d-08d886a1d769
X-MS-TrafficTypeDiagnostic: SN6PR12MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2797618029B362462BBD8AC395E70@SN6PR12MB2797.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6loHngtGbl4CbgfmCfW0IYZFfJmEvTlUiOMqa6E+Rc1C1+7xWYe6P5ePszJdSVid7KG32rP/qExgGCq1hjXkTr+i8gL+KrTXxvyohYzPZveoMx+X1NWshBBnZFSNDtOdqWV5I+T3ctP1weZaKkTWmWjUPEqO+qqkFiKXyW//ZLGvmYVJNwJj7mhv3K5b73/KfqSdCWwtocH8ZjIOPWdpgp5l1YOAh7TpCpMywRQLiibgRNFevzNABIZrUK8H6ZK/KdVQtnO2T+58T2knxhptmKc95fD8sWFFGTMFQDHIzJYRIa4bTAimdUrdksCeMs1Vtc6sRaMUQ6A3Rq/yV9k2GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(396003)(136003)(376002)(39860400002)(86362001)(6486002)(5660300002)(52116002)(9686003)(4326008)(186003)(26005)(66946007)(478600001)(66556008)(33716001)(44832011)(66476007)(2906002)(83380400001)(16576012)(8676002)(6916009)(316002)(7416002)(956004)(8936002)(103116003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tHfJn3VdOR7bCHfdxmmGuhkL0Jw7coLcru/DLocn59UEQlQ6EuCwDuWzlO++IFFBcHds4uYpjNfSHZvaw7UPZ0fd9j8kCUTeDgHoodU3tFCdCFujqnwYmtENpRygpmHNWkdMweyQfo3+V3cQfxUjELfkPJW+0J6/WsBMqenxeccrfcD2Z/R5D8HB19E6Twcvi1MZG+TPHL9uoxSSLdv5SCobAZ5+08Noquvr0+ekpf+Ii1MtHavn04hH1B8wlKyI72DOMD2UGQk9g3iZGfN5Sx24EOst6DPF8rcVZuIihU6YYJJR5I+ApM+buLzZVBCvN0ChIH02FZxszmNAyRKayRVVybAHRZGpWCDdZ6HAIzJ0UP+bi7rqInOC5alt04O0HeFhbusprdjNgMOo8s5N+AFOJSbg0Lg9+gEn/ntGWE2HywX/UVcc2+jc/0noilmfOlbR0i4fFy9djT2jX6mv7eYNDX5v2CDWcT7kJoD9YLBqfOM0CUiZATws+tF3wFIVhckRQZZL7+m/WeOWOnlxg0TbF2l0NrcHTFV5VXF/3osDM7J5jVc0iyCnM3w5K1oHQWpV9hD1u1Wbct4/iSuNlewvyL3M/Q7EMyVEMhVn3wlZwlu+795ea6wofJsYaYMR6WKYBOlNVa7zOyIYQnt36w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3445ed42-68a7-40b4-b20d-08d886a1d769
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 00:28:13.8817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h85AgRN2oJcKEGip5eSawAQkWcSnG/ugx6BkmgUxeW88/yJzeE76E4YiNa1Fl6i4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2797
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV guests fail to boot on systems that support the PCID feature.

The problem is observed with SMM enabled OVMF build. The guest
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

This series fixes the problem by introducing a new kvm_x86_ops callback
function to detect the encryption bit and mask it during the check.
---

Babu Moger (2):
      KVM: x86: Introduce mask_cr3_rsvd_bits to mask memory encryption bit
      KVM:SVM: Mask SEV encryption bit from CR3 reserved bits


 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm/svm.c          |   15 +++++++++++++++
 arch/x86/kvm/svm/svm.h          |    3 +++
 arch/x86/kvm/vmx/vmx.c          |    6 ++++++
 arch/x86/kvm/x86.c              |    3 ++-
 5 files changed, 28 insertions(+), 1 deletion(-)

--
