Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95B14634DD
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 13:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhK3M6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 07:58:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25640 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229572AbhK3M6S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 07:58:18 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AUCV84q009060;
        Tue, 30 Nov 2021 12:53:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=a1UYfC1KBPRESlKLcC6Ra9gaGzkdUtdmqsTaWj7SKiA=;
 b=f69XkjcLUQrL6bFtwzHOcbgeZwep0L/BgC7cY8pav+Zk0uswiUwJLGXQrDmtg1oyCA9f
 XLrnNkFJRz5Wc/Fz4NXCVjVkqMxKSSu3iA8ZIZrEYkrEFQVJpxG3c+usfmrnsl2/3dVp
 qld3yFKCjc1OOM91eg/+KK1SmnOyj+HhdkYw2g2D9g7FRqMKh+uxpFvZXPkq1U3DPxb3
 VSWrVMQOk4IodBq57I+UZ1sH+1Xk3D+QJb647lCJ2l4bUkGcsfLnxnLf4jlgKNCeo40d
 5gjjYvEWT2TZLTwthBP4VXi41Epp/WXW1WWNyREFDbmmLWAtV9rXzxeBb7EUF3+1MoOw 4Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmuc9rtb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 12:53:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AUCpiIp118808;
        Tue, 30 Nov 2021 12:53:55 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by aserp3020.oracle.com with ESMTP id 3cnhvcpeq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 12:53:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnDUrCUwijEE0vZBcm/KVdXZVCeJjVxVdaFHfy2nSfECpBbun7IITbhgumvbLq00XQjXZf6K1YXXXrPirL+5xZEyv12MDZsR42EwuwVoGw7/uCqDfzy9GMcts22vjbCRNas/jbA6NBZVYfprbTSXIYNW9fn1DwK0GD9WW0jWsdC3BjNW0QTFbB7Ld0j8Y9F/mC/syVfnmvkEx7+nq4Qkn3xkseJUGWzVKEj5U2S/cXSKRWLcjGWW+F3MnI/L2IBDaRR9vJPLeP/SaEnBwFRZYtRp+gdEDbjg6TRSmuigHkhpLbehTRjNMVOOJPuzao47nceb0hSnq0bQbNSXK1AeJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1UYfC1KBPRESlKLcC6Ra9gaGzkdUtdmqsTaWj7SKiA=;
 b=ghJYtpSA6HnFd7+Z3pLasYB5T2H/aFfYaWDfqtZCKdFvhRNhvE5uyNqE3F9UjY3hkVkEnujwLuThK4SyJhxV5dsXzM6dY0C8surGx/f3MLPu6hTyP+0VN75HJpik20vKgb0SBvI3+uk7GQAfpTowEW01y+VseuDwCuhmevOaxiXSOXyh1Jq+HHDk+jZu16XoTBIW9wx4avySEwwu2qY8mkZh2FgLLXu7ur30ZBbOKtvKRp4o+TKhcsgDpwTMCwL+s0eyyJrvxO68au+E2vczOyszBX8s1H+s4Mj4Y0EIjsPCMV1E4EtrgTkzMybpjgJI1Xz/gIRmR/nzdYd8tDlX4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1UYfC1KBPRESlKLcC6Ra9gaGzkdUtdmqsTaWj7SKiA=;
 b=zuNpwqjN63UA79ux5yvrg5KGmNbCESxK+73OSq71nenjIQKgdenH/UgSb5krsqfyza3MssMrv4XLXamjIABLUcD44GVaTYdrSrtsAVfLYDkxA6Mi/QjaBLJXIN3/j95WpyYIRnZDjFZTs3BOvfaCCdS+XFn+REIKKfOr0OkiZvE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2367.namprd10.prod.outlook.com
 (2603:10b6:301:30::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Tue, 30 Nov
 2021 12:53:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 12:53:53 +0000
Date:   Tue, 30 Nov 2021 15:53:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Peter Shier <pshier@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] KVM: VMX: Set failure code in prepare_vmcs02()
Message-ID: <20211130125337.GB24578@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0198.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by ZR0P278CA0198.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 12:53:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13ad40c2-23aa-4726-9722-08d9b4007651
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2367:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB23679C02B3CD0A10666FF0378E679@MWHPR1001MB2367.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D2hCQkW1Le+Wp+HrNjNkKgJ7C3nXyyilVPts30RVHSurizqJ4VD4NGYzgOB3laDq5JGo4OH0LZmhoUePApIcSu/it5FjKOEOJPGwh2VbAGyEdl1VmaN+N5z/K+GfjhL2W/6FupOynJFCrlxbq4pgsVmj58XNoYIOf2rIIFxM6oUQ8/HlkLLa8eL1f+iXc9ZFqJ2TiPwnNgvzjY3Jdm5SwSbY9Us7R2HaaU3yyM8fgYTHsT/XVngctem6FR+QzovLMopRPr/a0o0mjoPq1ghPSukgQAS6BvwIAHIYcvpD4NQH6DTivTbrReX+zziRGdwM2S6jaHXEHDy2V6ki1JYbq18Xp7CEAmJzDTPguf3MCxSEuRxO4+7cK8n7VyAS92TTGKxW1suQhw3Jqqc/Inbo21XZDVanEWbHa2mbu/2dL/nwJ7SQntfi/gFI2VVTHhy0xDbEhM6J+RMgE4LzY1ErlaexwAyvnh8mPd/5tjPBrstHb4qbFPUc0kgRNskyW81BFCL5Jx3lHyrTpvSerjXtyMck7spekHuq6M9EAkGDoZFB6LBNcV9hAxItM6IaCkea3XZxetPm8DTNhOQ1MMfeiKoWKZ3Z8xYrrmdpHZhbwSeu8qSW1AGtDzlYbl/zv1bg+F4JSUYjfVESAQBKA4dr/RmrWklZmQddCwjGWfNzVpaUKQZpsUhlDqXlsla6OuqLxaTHVFY0AtepzQJiVN3gLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(6496006)(8676002)(54906003)(2906002)(508600001)(33716001)(9576002)(38100700002)(38350700002)(52116002)(956004)(83380400001)(316002)(66946007)(66476007)(66556008)(86362001)(26005)(1076003)(5660300002)(4326008)(44832011)(186003)(7416002)(110136005)(6666004)(8936002)(55016003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z9U4RyTsXteCRmYzw3L8M3Wulr9zIUZxVTcLJHeGC0LEr1FEy+tyrCTsvHRZ?=
 =?us-ascii?Q?aFApFWkicEZgiPidOh8KPfKCkGE2J9kFUygSM50ltL+vOZcziThlc2EkaRoV?=
 =?us-ascii?Q?04OGrGn2udtcdHBzUMz6uR9Dt2nBkug0hCzBXuBYENHe6u5KUEL4dEx+ZYuT?=
 =?us-ascii?Q?OTt8P7h09FRr854/8a8PKtf50cny78MuKDIdnLnm1NbVx7TTH89AXxCy3dF8?=
 =?us-ascii?Q?QTj4HWd2I5MG/Hk0gLTe8RLBOtKMhEnmWhaoutinEGT6vEyop5/W24Nu5l46?=
 =?us-ascii?Q?gIYxBzrX+LGSDKcVObn0TF0i2+eFBfAqv00JXBQq2ZeV6yxl4FsIlE0j8Lzg?=
 =?us-ascii?Q?7wvqWy1slI6EINrD34JhG4vZ0sHw3f8fheept10S9MWUa/We3m7wCJeNg1Jp?=
 =?us-ascii?Q?wAwkBD28LQ81jOtZ9RoJJ6VSFXmgGgo3A3LoZZX4W2zzNrP3F7kyJTLTzsGK?=
 =?us-ascii?Q?cbEg8sXuAcBoX1hPpfBbrLgOWFHlc4qdr038iEV64fk0KFNoVXOQctqvamaQ?=
 =?us-ascii?Q?q1t2VJY5OpZq/xxUmGnRqDokm+FX+RsDJxhj1Ki3+XG7yQtxcPU7pdQSsjaP?=
 =?us-ascii?Q?N1F0Jg97FEiZG6cFiuzQ/s+VGSG3/nwfL+RjHhauewUcTKOAqcYwkUUBoyNg?=
 =?us-ascii?Q?wylaTcq/M7C2zb/JMWuF5WAZhvzrvEHnjfvlsyhtDy3HiNQBUXOE6O4cBQoz?=
 =?us-ascii?Q?+brEQbcOuz0kIhvSXEY+DwgrW7Sh0NwQosaQPW75arIL1xmZk1mxqgtUiq96?=
 =?us-ascii?Q?REkWx0B6f4MonfvX8cXSJSMf2CRp62wlSE23ThQ5N3w+IhDOexlGbwziO4J2?=
 =?us-ascii?Q?bFSL5Q/CaqyrmjSWu2dluWnhqFTV2xHkmAv0VcxI4TYd74Tfu2RsTm89J/0C?=
 =?us-ascii?Q?HzNEL+ufhHy3Hatgz9QpCcHP5z9kIKX+ycdj1DcjWHm7GKHc/UBcLHwwkNbo?=
 =?us-ascii?Q?WQltOeEnnlovDF9e9zryvi5YlVXCh68YdVAZlxE2wzl8iXv4H8zmz7IiUT5X?=
 =?us-ascii?Q?oDZekklpPZlydtFr7IGsZmkJYldmNN8d9Vtv5WzsEUrnJHb5LmwohD8U/K10?=
 =?us-ascii?Q?nJVz7ZUfkeXAOOG/ZqT2zzioYl+VRlHPZljfvwwTSHLRi6hpBlAnY3mmghku?=
 =?us-ascii?Q?WEMjq4p7AUv8Hk9EdN+aLrLP/gWGILTuenOk+E2AH+dHHHNgjPxny5rhoA7F?=
 =?us-ascii?Q?gDiFGzpI2CZFdvPlXTAg9wuwHQOlZi2jM2fKJsN+F4MyvqaifUaLu1CoU4bJ?=
 =?us-ascii?Q?I8sosPayqP1DnNBnIT+Mtq4ZYMqjCqSjCvTe5VmipRNKtAskQb9b1r+LGMxy?=
 =?us-ascii?Q?FDVB8RNOu10CGA1tmexdC1UFXKNz/MYDOxmDYgJ+CKxZPpHDlMk7QmS28/k3?=
 =?us-ascii?Q?4438bCFv4KqynozGEIvw8LF1Xuu/Q3qd41PkMDxrQgz7m6/XemlHTRGALuUo?=
 =?us-ascii?Q?Hhu2wHRSYLWDMB2a+eYGiFNuHLVXsY9I+pJMPWn0LqVa32vGq+mZNaR4XQZm?=
 =?us-ascii?Q?nnlXCSSPxWk+eqrByHA29B6WhW3VfdeoVaCiCwbqUbalGp4wqP6sDv2OuLh5?=
 =?us-ascii?Q?T0iFaC6aYBroxTiVsRwlswt0t+HP4JvvOW5hX5KUBPgP9oost5Ex3/5jWcpc?=
 =?us-ascii?Q?t3gn0/a8JcMWnud98hgwAm9gJnytfJci2kyamc7bBbkxa/91BUhK9hGqbnPQ?=
 =?us-ascii?Q?g1I8iJ8Zx9goWKb2et8k16c9XDE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ad40c2-23aa-4726-9722-08d9b4007651
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 12:53:53.0272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnYSs6BDFnbLKKJKlXNyk23NygzG8p8EieqUg6Hfljce+zbA7fnj2r/mESx803gCLs8nqQdE6QPu6HvaJqTXHCqN6egx/D/pX0IgLYoMwoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2367
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300074
X-Proofpoint-GUID: 6-JUWPskrbq0BLLFXsLVthkxHzftxyzO
X-Proofpoint-ORIG-GUID: 6-JUWPskrbq0BLLFXsLVthkxHzftxyzO
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The error paths in the prepare_vmcs02() function are supposed to set
*entry_failure_code but this path does not.  It leads to using an
uninitialized variable in the caller.

Fixes: 71f7347025bf ("KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on VM-Entry")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 315fa456d368..f321300883f9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2594,8 +2594,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-				     vmcs12->guest_ia32_perf_global_ctrl)))
+				     vmcs12->guest_ia32_perf_global_ctrl))) {
+		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
+	}
 
 	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
 	kvm_rip_write(vcpu, vmcs12->guest_rip);
-- 
2.20.1

