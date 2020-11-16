Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535D92B504E
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgKPSwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:52:42 -0500
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:2047
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728757AbgKPSwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:52:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qgn/FV6PYle1OO8pJ1OKBZK8PF93KIWC+pcpX5QciPGn39FQZ6R9uatXScF3RwdCkn6G5LjP23/GcLqoVMBPAva5opLqp+sDjNmu6GBgxhiyHKDqpcYS6fiuM0yY4dQHprIJGiCq5cNLEPDwJkrH5eKK0EDKe7c5AnS2JFEgAPkGjkqiF+39lzkZvcIV3Bx5bLOWpM3Tx3iRJPZkJZrf4oOq4kfYji2rhfuJ31vpa6VUzYbXUU/CVVcfNkP6o74pm22rook/cKwDQreaZKvXVAzbP1W0eQVlsf1/ZTlcqY+w1ifPEoriN3yJiABzFAPi+x9YzOYYDurSn9U8V5+TAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saSJH9H2CfgXz0bDJfF8295ijeMeqMLuM37DA6kaYVU=;
 b=EgzvX7GGkDqFnYS3uKk1mYdo6cGo68yro/mRaufw0bRrvCxkG7395Gerz/aN8IcL0RJ/Xb+2KMhETmUwZWSrmLbx3xbZQcYfAt8FDQnBL1OF3awOxHYGo7Ezz1TTnX6tpEm+CjS+ObH46GQpgWazywn4WGPkDaeg6mzU11RcteprMf8bXGnkkm+6jLYB2oOn9i53orGQ9BDl/W3N4DpmX58CVS/NYc3/y10Rr6MLeIcoXij6EvdXLB+9lXkUT+LRja01bOx6UyVRhwoTBEuKQC9zoC/ufNyFagjpT00IYZzEd3D7dgO4SqABsBgAFuHA18z4Faw/RJMRNRie14Vx/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saSJH9H2CfgXz0bDJfF8295ijeMeqMLuM37DA6kaYVU=;
 b=sFsHuQn600heDUY4otM0SnQrfBRO2jPYWazLiK3nlJVD+A6GKIbSyxKnOTXmGxIigPsPREo6SfCxvwMJxU4TSMRr5RiKG0ip3SlOK5Y/iPBJlNgsjf/zb9bxrODAFEpSjA+DjXGeMDb9/zA1P7yk8Wy5kxUliw1uo+F74MYEVuU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 18:52:40 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:52:40 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 09/11] hw/i386: set ram_debug_ops when memory encryption is enabled
Date:   Mon, 16 Nov 2020 18:52:29 +0000
Message-Id: <0afaef32bcf868297eff2837e2462a3c5efd21ba.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM6PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:5:335::7) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR05CA0038.namprd05.prod.outlook.com (2603:10b6:5:335::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Mon, 16 Nov 2020 18:52:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12f37d1b-6481-40b8-b40f-08d88a60cb0d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557DAAA038076A523BDA2B88EE30@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Er6b46T2y2XEl1UbEbylb4LkuZ8vIt/dv15KFb5WSk5entKvyZUSMs+mJ/y9rRY8Atu5lPIMITaXDN0En8v3S5jsvy2iewhQKj50aYd5gFUDYUick7zTg/OPLUD5LqRrNteZf3YUlU82466uJUaV9ZKKde8du88HnTOvrOIfzo6ruXpsCdmQHKFS3acKZy+RW0IX3HiIUOK1Ux13sLJdbS0T28gYUjVIjjUdYKYGm9by2TqFOY1f7sw5aOy04bw3gaxBMNMD5OcPXk0pq6r5SyIDWo41IVIlxNRSg+jUoSEpDNL8IxI9kMmGW5owvzRtKGVMd4EcDFDwFwZRMmw8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(66946007)(36756003)(86362001)(2616005)(956004)(8936002)(83380400001)(66476007)(66556008)(5660300002)(6666004)(2906002)(6486002)(478600001)(7696005)(8676002)(6916009)(16526019)(186003)(26005)(52116002)(316002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Mbqa4elDzTns/SvsQMhHHY7cBxNkepBTSyCuOWzv8OgK3rvQ2FhbO5gkNc/Id4yIaftSn5jGcXpOVmzJDIXHDeZQRrdMfAWnS4f41ckPHVbNqET/g3ydQ+1M0v7QIrkEuwvtnbvhfs6P44IhkbqrNp5HOOi+vvibQcC69ua98pbMJqblrGiPuaZvZsuwYxNorGA3mOGerIA1qw0aj0nA6JAxiC0cE8Ow5WjNpl7lkKl/HDQJGSk0kGKvod0J0XSzIiP5J6/ogDA7spKNoIQ0uXx7He978ZfqgXltt1ZGwrbRXend9T1wSXfnzfkFznmpHXvvU7sXkqOW7721pCA0kJb/zNMbDu8JOrw7DURy9n4+QC5be87BjHibiFqQxN1Q7cGq8+AxvwUJ+18pG1RXUf3lVMiOp+ft8nG8JhemE7W66y42M553Kf+rHoPi1EDjGSN7iaBQ58o7HBZ4FAfTK9iEWhQBXbHWWObdA900YhBXSQgkbYUgVkiYz+EAJHuTcmadKDAmS2AHO0Xa8eMId7l7msMTxNJurXkMW5yjlBEErebAPihs5vYv4SN+KfMzWJ0mR1hLXyGpmHgJwTTn39wjKlPs2QgiTO/hJ9PwIiaSQuWgqV302ehWfkRHacOhAK3GJsY3+wp9/9KGyIlj6I2WjdKQRS/+aBD7P4ElV8ZXtRCHCEHIkuGxJ3fTaCYDxcSXfHKDaWJl72j0WuHRtk4SNv9D8yJXHZnjFbQBvcVK89Ia8/1LqZM6oGcixjf9T2UrFQYAf+gqWxhMo7FtRuESYE6pKQ3ufXfHXn38+rGVeix9etLShYSAd+rbUBRcl/ECNOC08fU7bcIH0g7QiIwwTvREZDFw0T4bE8Mh/YIbHcxtR8B6kAPLh7ie4j0kmUAK8x/AVmvg6oER3YmUGg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f37d1b-6481-40b8-b40f-08d88a60cb0d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:52:40.3800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DKwTQLiV7Gu42pA3CxoUHyOdJY3DLiZzZJFMj6qGauczk3qDfVv/cn9GKOYGEg+UBg/6rPyQRPIFthqWY5oBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

When memory encryption is enabled, the guest RAM and boot flash ROM will
contain the encrypted data. By setting the debug ops allow us to invoke
encryption APIs when accessing the memory for the debug purposes.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/i386/pc.c       | 9 +++++++++
 hw/i386/pc_sysfw.c | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 5e6c0023e0..dfb63cd686 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -913,6 +913,15 @@ void pc_memory_init(PCMachineState *pcms,
         e820_add_entry(0x100000000ULL, x86ms->above_4g_mem_size, E820_RAM);
     }
 
+    /*
+     * When memory encryption is enabled, the guest RAM will be encrypted with
+     * a guest unique key. Set the debug ops so that any debug access to the
+     * guest RAM will go through the memory encryption APIs.
+     */
+    if (kvm_memcrypt_enabled()) {
+        kvm_memcrypt_set_debug_ops_memory_region(*ram_memory);
+    }
+
     if (!pcmc->has_reserved_memory &&
         (machine->ram_slots ||
          (machine->maxram_size > machine->ram_size))) {
diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
index b6c0822fe3..9f90c9d761 100644
--- a/hw/i386/pc_sysfw.c
+++ b/hw/i386/pc_sysfw.c
@@ -209,6 +209,12 @@ static void pc_system_flash_map(PCMachineState *pcms,
                     error_report("failed to encrypt pflash rom");
                     exit(1);
                 }
+
+                /*
+                 * The pflash ROM is encrypted, set the debug ops so that any
+                 * debug accesses will use memory encryption APIs.
+                 */
+                kvm_memcrypt_set_debug_ops_memory_region(flash_mem);
             }
         }
     }
-- 
2.17.1

