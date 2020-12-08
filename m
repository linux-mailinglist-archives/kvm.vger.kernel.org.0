Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D791D2D35F8
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731420AbgLHWJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:09:49 -0500
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:15968
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730697AbgLHWJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:09:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C962lhQ6uYJ5lU6QCGm5WnGG7qi5/e2f1KlOmtIvZdh90ie7MGy989ocGS3b04qMFqs8Tyg385JVOy15oKEdlwgG47dCvuBZiJjFKg/QuAtqDskGdA9xdSqQFCm3/cMk9mDUeX9/Z4XbZOAPOoWXByDWknyS3+aMnExAKISy3DmwQbfsm7tBwMQw609dyIyN8sfy1kWOcQfyvRYfDOSgvD5XfeRhqxTEt9g/5KnePQuSHUxg2hXHBdUtqSr4mTl17R84N2gfUqAZpRcR/bT06cXw9XS4pj8txJGWpHGn1TKQck0ydxkzP3olVx59600VLspBma1uOYciCwtZAHnaxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8gS01XJgSEW8j6D72RNHJqLJ4u86vTtL6/YJwKNssQ=;
 b=KwLuucvq/Fn84N+XTAAIyybM33GTJ+QUIwMOw7LbqaKx/EIk7t8sU02p07mxgp9VZtj6dE7v878K2y+dK4vonnwaScLd34FXMJbpmR5GgCIS9/BYbVuwXvgmqcVghavTdWldmlJdDaa3bCkd+K+FEC/ci4kVcZHlfXgeWCx5ELiEZE0Efq+DiDzcf45e6TnOv2ZtlyKxoTZGd04D2XgaklqaEf9DHUSkT/9RAf3gsxPvcZuaG3XILQBBNhku4inzqtsSjnS4psMRWHoaN/HA+YoaFQ5FRjGg4wjSDAo+1USzfY+PIzWdNZoLNGEFlSLicYpuZTiX1Mla2FRVY96n6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8gS01XJgSEW8j6D72RNHJqLJ4u86vTtL6/YJwKNssQ=;
 b=wsm0v2lWP0gs8t29PeIqNdzj3FQzfTkDwCMA7K01yqwZxslAjta4EL+Qlu1lGcpiVaTTibCz1vjXF4ue2djYsixONhZ2P1TnN+aMlYsLeQkijpzS10HTRXP2DeEjoVxYW90EbE+7QET9F6U3qeb7+ZQwdN9C3lWkeK5Ii5A7RzI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 22:08:55 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:08:55 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 16/18] KVM: x86: Mark _bss_decrypted section variables as decrypted in page encryption bitmap.
Date:   Tue,  8 Dec 2020 22:08:45 +0000
Message-Id: <45bf5465811db7bb22aff49728adb2b7dcebbcb8.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:806:23::9) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0064.namprd13.prod.outlook.com (2603:10b6:806:23::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Tue, 8 Dec 2020 22:08:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53fad189-4aa6-4629-b77c-08d89bc5da97
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26405B66265142DB6A125E5F8ECD0@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmtyhrlRPwKjPmsNQjSiBbYbYXaWmmj0EPCvdzkQtNCvFK7JPFeEcazqFlnYl3x3Vt1HJdIYSIT3AUVce7ZfD4fhZcqE7+cciK7ecfUbieJ8/xea0xC719NmHS117Pja64E9KeUbbYRcf0hBZsPcRaHsGox3HkfFh2cnwxuZtWil5G1jpfuGsqCt9HAYLA2tC81k022L2qUj+mmZSgmLriRVKi1xlkVFzW6WenP/HVpDVwtqi2eAdT+DUA4joo0+zS7/K3pYOfpjtbT+lqzXC9cdKeW6CTaRKUeQTdpFiG7GfPS130X760rMlT11uKo25s+k3sNghEGuYePVUz93AyJIyhS1HsavjkFVi5idWj0De3D7u5YOirrweumSnU9i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(2906002)(66556008)(83380400001)(508600001)(4326008)(5660300002)(6916009)(52116002)(7416002)(66476007)(6486002)(34490700003)(186003)(6666004)(8936002)(16526019)(8676002)(66946007)(86362001)(7696005)(26005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Oj8QoKgQV3hm5B5wGoZLpOpAz7EOVQ7wlHhEQuxB/SIjyQp7xM2Vr6+oIUgk?=
 =?us-ascii?Q?EZqmN8w9APWMUX2i/PY3uKrOiqSsgUTG3p3tjBmti5b8f2iPqmpu/bkzP71g?=
 =?us-ascii?Q?i9hUyXOTobC3obDmBMW55DYXTfNN53bkH3sdDSSk+IV22E39LxmETbWtEL5z?=
 =?us-ascii?Q?1ZP+m2bhkgJKdDATV9rNzEViXs6Q0n/h4hGrtkijsOSSFPLEThITGFqZXxlB?=
 =?us-ascii?Q?GioOx9JAMecufK5ZD03qnh8nWtFjAWupPmLFIuOZPj5rBMwiXf83oa2LycUo?=
 =?us-ascii?Q?pIDEwHc7UCiUNpDGXdjVkowMnEFli0pVLnyeXTmfqfa7ZVCrTpx3dDu50Mmt?=
 =?us-ascii?Q?dhvoH6LvnAeZ4Sh7PcBa+4RFcyGlV/bIl7pcX3WeN6JCF8Ve1MWuG2omwORR?=
 =?us-ascii?Q?AUhzsTJPNJNe0pWmWVLa/G0PMjzyipIwihpI8/zc7lNBvbcQhUFw/H44d1MU?=
 =?us-ascii?Q?HjyWwDfqFVdsCvjUHwJzPiBGvKoSimhT/v3a1zatczmQkb5wsbluEdl1s87M?=
 =?us-ascii?Q?oXf0s+ezGsRfZ0FT+IRXvylnm5KxWLcqkgKm+vBkl0cR60eU5XHHXY87Gsbg?=
 =?us-ascii?Q?iJZAWDZGRU97W7G8GwzePJOCW4dhSc8aIDqgNFyazTZazS5QA/BxaYxtfwms?=
 =?us-ascii?Q?eiOsDWSxuqecDt8gVOEu4U0U16ShUdeON+ztMAJVULC1gWXYwXBsyyYGL0VP?=
 =?us-ascii?Q?jYJAx28SGWC0kWUjDCQ1wCsUgccOTlPxIUOf1PomOkVpMUD2iQu7uuZDOri1?=
 =?us-ascii?Q?oKTBIEBF7Y43dx/BdO8sFkZrwy9RjZN+qdRUkEgv3loz+SLlAToFtmPSwcXZ?=
 =?us-ascii?Q?k7ie+WH0VxKHKJ0ftU3FpYVcLRkOi35K2DNEQT1/FsDSwSumYnIzGwyvQepv?=
 =?us-ascii?Q?zs+S3dJwyFcyPgxBNv8dCnzh8jt2DkGJwff6viftFZHNZkm7VznC0UrYu7h6?=
 =?us-ascii?Q?Fi+Jp1AL6SYRpTNEx1OsEVXv+dkFNbOXf34KNOfJfWBe/edyIpulQ0uEDs4d?=
 =?us-ascii?Q?C3bx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:08:55.0534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 53fad189-4aa6-4629-b77c-08d89bc5da97
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgeC5gJTT/nrTZ7QzlrH+oamXPiLXKMO+M8re+f5BHDcMyr9SEBzPqJHES/n1M7NF627xeRsDhV/tYFo++Vifg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Ensure that _bss_decrypted section variables such as hv_clock_boot and
wall_clock are marked as decrypted in the page encryption bitmap if
sev live migration is supported.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvmclock.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa593743acf6..f80cc637ff2c 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -333,6 +333,18 @@ void __init kvmclock_init(void)
 	pr_info("kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
+	if (sev_live_migration_enabled()) {
+		unsigned long nr_pages;
+		/*
+		 * sizeof(hv_clock_boot) is already PAGE_SIZE aligned
+		 */
+		early_set_mem_enc_dec_hypercall((unsigned long)hv_clock_boot,
+						1, 0);
+		nr_pages = DIV_ROUND_UP(sizeof(wall_clock), PAGE_SIZE);
+		early_set_mem_enc_dec_hypercall((unsigned long)&wall_clock,
+						nr_pages, 0);
+	}
+
 	this_cpu_write(hv_clock_per_cpu, &hv_clock_boot[0]);
 	kvm_register_clock("primary cpu clock");
 	pvclock_set_pvti_cpu0_va(hv_clock_boot);
-- 
2.17.1

