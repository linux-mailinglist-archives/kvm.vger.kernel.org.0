Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0535D15C
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbhDLTph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:45:37 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:31040
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237455AbhDLTpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:45:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSBD70xoNPP29ZLhsTkbl8yXq9QUJUcP/DnmXcyGD97QHX9utW2nz7XR+egzr7LTOjH+4/Al/SK/eaHBnKva3p3FcpweqTVZheNtjuW0VjIYveeFj/X2cEh1ePQDkoGnjo7c2LJVhfYO1hcYMm8CKtg0GBN7LWqDOK7hguTbwHq0qpmZJOdS76BaBBFjV8LBJxSHGXHqYuDrr5bfgQWZOStBZ3lyv3ElCqmSm0qvE1KWij4cmnqa4MFkZ3EoU2046CZQSxCgeW4B5eaq71Gr4wu+ZFm7lipY155HiUJtRCY8G3WIMsVO/n441vM5z/37UQ9QTN+MkRBaD1QtrBxxyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLNAo19buTg3Yb1D6/ZVJBYv5MP2n7HijI3gYDV3fvM=;
 b=D5E4q9WgKbuucfLowpHhHU7cS8cf8NpLe/pvPAdMunI+oz87phadao4OD6/5E8ZVekNtxhLo/ISgMrF0B/iaoQnQh9ayduj+721LEjf028kI39Gnn6JbTPxlcd73BvceNkPhjmBtSYyaV15E4Vousr6XT/P1b0ZN2kOAHpaXEC2jHgIFZI7IGEHHl2ukpv8R7n1Rr079UBXAfXxz1wO4Nv+vA+fVrAtqmsmJ3hNcawOMvG/jxFEteCPVAawEDKhNvEJRHnBQF+5mz1gpgQjOxb2QHaIDKaZih4lz43vKJxCSDWyRRpF1oHC8ep1kODw4+0LYP0LhF7ME1hwAaBA+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLNAo19buTg3Yb1D6/ZVJBYv5MP2n7HijI3gYDV3fvM=;
 b=mS40p0Nh7t7iVZxHhAGKc8KtmOrUxrgZDp1t2nJlQoSr2NBibFiBxHReWksyIHCqO0mWt6Nxg9WWouItOe3XwVVyaanA5sIGgwnT72UDrgOAvkyjPz5Y8TVZZYYZHBDcHqDY/uxNX6ys9oNm2eNZCwdSD3zB5B2aBufr7EZfBzI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 19:45:15 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:45:15 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 07/13] KVM: x86: Add AMD SEV specific Hypercall3
Date:   Mon, 12 Apr 2021 19:45:06 +0000
Message-Id: <999bdd6f4e9e2d7f4bdc20cea9459182327f505b.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0087.namprd13.prod.outlook.com
 (2603:10b6:806:23::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0087.namprd13.prod.outlook.com (2603:10b6:806:23::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6 via Frontend Transport; Mon, 12 Apr 2021 19:45:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3220036f-1663-4134-f981-08d8fdeb7e3d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27177D0CCA7CB8AD9BAA5A308E709@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BkpWVGZXibayCtbHDCslx3/fV3IBmwoT849hrjb+N5adUtsi1ydBKETJxlmX8Tcw8sGytOX2JLNMDP23w80PNrhsNoZKh0eOr9tDq9IpUJIAcNWVj8KtnkUZT8NbF1NO8g49qVdCuqusQY2nqhel9gSQKzSr1o8Se/nhrGyPLYnnbRtMyMu6+nboETu1cMiKeHxqMwsK55Nhxcz9HoCulRTT2WY8ZnDNWXFeYOUqEvMd0GC+yPGZ6jOSIW7aIlzAx07zJlxppQLZCXK6reVB4igJSb1QNyCMpcBDRC/N7kNdKJfbk5zCy11TFwoWFcB5rjDfs63ah7gifNAWKh/YfHQ6y1475Md2f4bL0Gp3PsuE7nzArexliYu2pW2P4Aulh4Gf/zDwgU8n5Ic2G1qtfO30vsO0Se9hkqoMnErdvsabGGZp513+QwnP0nBSO5MDiofhnrSEGuiDtLLTWgh5/EWrBw3RNacVtDHHf78Zr7wfOhGY7EYqTHh6UOl4nChTZKEnZSF/wMGu4WnwAIZbupQ4ukrXPIPrmIfZ9RBijUNaOp1CG5QyvKkFOcInIyPsCKDLYSIWLmbEKx8iN533mutY0ZErXrTM0EdQ/6d53xceWe++C4sTLbx/aocPZbtRenGuVQJ/8pd/ygXumEVhPTu7nqKd3kxmYbrHRE+m47k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(36756003)(8676002)(6916009)(4326008)(316002)(86362001)(2906002)(52116002)(66556008)(2616005)(8936002)(6666004)(38350700002)(956004)(186003)(478600001)(26005)(38100700002)(5660300002)(66476007)(7416002)(66946007)(6486002)(16526019)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L3MwSTVXOU5XZ1IzVGtSdzJzbzNSZzNkZkFwSEdMZGEzc2NncWFUaXAwWnVK?=
 =?utf-8?B?YzhOS0Z4UGphTDhHM0JTZXZ4RC9Ubk9JbEY3bG1BNmFjRVplZFlVWVViOFVK?=
 =?utf-8?B?NWJNM2xSV2MzVjMyZDVEWUd0Q1ExbHRaUFVUM2dONklCM0VhRG55Q0NNNXdB?=
 =?utf-8?B?NzNqVlNJc1NMTElUd1AvVUJnRTZ1MkVCZmFmRkRBVTh0RGFuSHU5VUprUlM5?=
 =?utf-8?B?SzBwN05KZE51VW5JaHRMWmRlbjM1eElHcS9CVDFBNVJvcGpCM1ZQeGxPemNG?=
 =?utf-8?B?RDBveC9uMnlyWnhkOW43R1krRi8wdm5wbGo1cndjSUQ3TWdkeG40RURUT3Va?=
 =?utf-8?B?OThMcUJjdkFxbHh1VGNQdGtXT2txejdPbVNUeGcvc3ZVSjF3QW54TWNYTlJO?=
 =?utf-8?B?NnZZYVVRSmtDR2kvRUN3enc3dlFFNzlUVVo1TXY4TVZCREdhOS9ES2Q0MWc2?=
 =?utf-8?B?MUtQZllIaFArTWxPV2VVdXhvd2lDZUxTS2MwRVZVM3laM2x1Y0QwMyt0UTdp?=
 =?utf-8?B?a3piZWczcS92R0hmWjRxYVVHNlR1SVUxVWdBUkl1WjdTWHFRaFh2SFVDajJn?=
 =?utf-8?B?akVnSDNnazZ4YUdrdW5RZlhhdy9GZm9SaTVteWFCSi9WSDJFQ1J4dUlJSTN3?=
 =?utf-8?B?bVl0ZHdQZ2VtNGdUZXQzYUxQbUI4ZU9qMGFCNThueElUMG1aeWc2bjlyWUNr?=
 =?utf-8?B?c2tMRXVLcVJzZld2L09lV1lXK1BTTW1KcjFhUzh0S2toQkxKVjhUQnlKZzh4?=
 =?utf-8?B?cG1Na3hsTk5KNGtmZmdLV2RpOVJZajhVUEJ6dEh2MkgvZ3lnOW5qRjVmVFAz?=
 =?utf-8?B?akpJTmI4OVNqQ2twdTZvMFBVdU5ibEVrRzNoSG1DVDF5T3BkU1RhaWlCTE8y?=
 =?utf-8?B?YkdiczFaUTZsaGh5bjA2YURESnpWakxUYjhhOXplZG50aU1pelJVS3gxTVJn?=
 =?utf-8?B?ZkhJaUhoYnFYaXZUNDlXcjFoUEJ6eDZGNWxjTEQwazQ4bHMzY1A3dTQvcU42?=
 =?utf-8?B?ckJaOEU5Sjh2cDAvSGpjRmJaVGFtQnkrWUJmYmJHd2l2VWRNaHJxeURobHg1?=
 =?utf-8?B?YUoyYkdlZzM3ZlB4UkFTS1FKR1pFQ0lFdlE0bUtpZDRobWgyV2U0SHRBNWhp?=
 =?utf-8?B?SUcwS29GdWVhLzB1eXJYbGVWY01sOE1PWnY1Q2JCTWIxSFJleEpGOGxVajNu?=
 =?utf-8?B?aHQ3dXVUSk41SENCM0pWTk5NViszTDhNSjlYWGJiYTBtaHVtakFrU05RN1k4?=
 =?utf-8?B?VmlEcjN3eHN1WmQzMHd5enIzRXZwRnM5Q3k1cEN4QVhPbWFkaHJWRUJzdFJ1?=
 =?utf-8?B?S3JFQ2h4aDF3S2h0WFJ6U2FyTkI5aDFuRk5nUEtjcnpXUXNYKzBqVWpaR0RD?=
 =?utf-8?B?bHUxQWpQRkdXamc2UEVYRG1lUXg5YVJSak9qZXhpZkZMZ1lqNjhEOThZU1Jq?=
 =?utf-8?B?bHFCZ1VaWnN4YnUxK0liaENBOWVycUpsQkdBdEFoR3ROb3JnVjFha3FyUFhN?=
 =?utf-8?B?bklWWkFNaEx0NERPVHY1K0diZjYyVnVlTkY2OTBMWEZ2cjlteVJ0bXBEbHNi?=
 =?utf-8?B?cWErU2ZCc2FOOWthZGU1T2JKcXdPb1MxM0hWODJHdDl5MmRPT0ZEZVowamRF?=
 =?utf-8?B?Wnl4SVpkVW5lQmJ3eW5UOFBxUWNscmxWS1FBWjUyK2FteXhSQXNSZXUybE9q?=
 =?utf-8?B?LzZBb2pFa1phYzEvY2RHZ1ZxeXNlWjlpcDBsNWFPdTF4SHI2T3VkaVVvN0gw?=
 =?utf-8?Q?yj7xHb/oAGxtZpb6o9w30o/bzH98wFhcpIblllH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3220036f-1663-4134-f981-08d8fdeb7e3d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:45:15.1327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2QseD/rwfJJjbsjUxQPNQrIEZFGP5SaUH0T8l+aDbVWam3Do3tPfbHiZlfkW20sHjq1vrG+/er8ywGjVoaFgzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

KVM hypercall framework relies on alternative framework to patch the
VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
apply_alternative() is called then it defaults to VMCALL. The approach
works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
will be able to decode the instruction and do the right things. But
when SEV is active, guest memory is encrypted with guest key and
hypervisor will not be able to decode the instruction bytes.

Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
will be used by the SEV guest to notify encrypted pages to the hypervisor.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 338119852512..bc1b11d057fc 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -85,6 +85,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 	return ret;
 }
 
+static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
+				      unsigned long p2, unsigned long p3)
+{
+	long ret;
+
+	asm volatile("vmmcall"
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
+		     : "memory");
+	return ret;
+}
+
 #ifdef CONFIG_KVM_GUEST
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
-- 
2.17.1

