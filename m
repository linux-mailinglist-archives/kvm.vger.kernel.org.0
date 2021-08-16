Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151063ED779
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbhHPNdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:33:36 -0400
Received: from mail-mw2nam10on2064.outbound.protection.outlook.com ([40.107.94.64]:50304
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240881AbhHPNbn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:31:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXUPTjjzIP90U5ZTNpWGCJc8Dx/ySgWeU+G9hUj1rXt0bzjzX0r9Psol89nuI3w0Slw27GZh2B9VO3nUWzp8p849M4nek03I/kqbJfTZi1Z+DeIdyb1MjAaQ5LMfHGj2XyapDPBifbOZwpypD8w8ItqTluSAjQnmTDpbobUfVZSTZZnboSI4HZ880xTHMaq9SR3MOCShJoimsRtzsucQekfzX+cwVDbHs+h/H0+BqAygOVXBsepyv+Rfqqyme3s70ng55BFXnCpvRBCfBpz2fsAPddzvPKAFNeNO2vo4JHwk0TCY1XHB06a59T084ObdGZwBbia7F5eNTtm3QBkePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9Xy+DBwrDWhWTgV6TnjMJgWgZW5gHEWKrQEGWQ59a4=;
 b=F7HHDr/ROR3vXhsqoNYZ1Y2syQCKZjmzI4k9zmhDddceC+tax+fBQW3e2uWOqZc4KbV4oGXWitlBgUW1pw2ucqy26fyR9wmkACFlN/ZIxS2SorqWCpFwBYa4h7xI5uqfDRKChtPu5bmk69yRPRPM9gdOjNksqtDco+skRNSxIyZ+C6UEbYNxpyTOlE12x7Zqg+eeYD7ebiOkPQs1rD9swKLongHkn5SpfuJ1gnBZtMO6AvSsZb2KFPzh7DblnK712WGJCXyWwnyZT9/WQb8FgQ2G2x3Kk7SjSkywm12KHUQJCBiMlDeqRzslTPXvDOUmdooqgLRnl2x1jKlVbvrsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9Xy+DBwrDWhWTgV6TnjMJgWgZW5gHEWKrQEGWQ59a4=;
 b=v4dV1m9Xlrzi3L9zeq7sE4U31ZmhAYzWdO93+47bEfml9wt9vhZJn9covqweEQUNclgwZXCRS9HnCLzwhvdCHRuEmjUzP22BNaUV/N2QmI4h41evVyjpUFVB9po9mNUGbdLn8KMI3vjlR+zWLmi91Nky98kUIjJ2b6Tc2xa0J/M=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Mon, 16 Aug
 2021 13:31:06 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:31:06 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 11/13] kvm/apic: Disable in-kernel APIC support for mirror vcpu's.
Date:   Mon, 16 Aug 2021 13:30:54 +0000
Message-Id: <6bd4f9bd3612ad64459fb8bd0478fe02b70adbb2.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0151.namprd05.prod.outlook.com
 (2603:10b6:803:2c::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0151.namprd05.prod.outlook.com (2603:10b6:803:2c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Mon, 16 Aug 2021 13:31:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc2967f2-2697-4df4-13ab-08d960ba19a0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592EF2A71674760CEE03C808EFD9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: btpuqwg2xtjKbePRg2+rA6rHrnL8dd1WqW6OovjPdR3btY7lMiTHkBLj+x/8qultwBFByyfyDLqysmkh7fwUaYNI9CIWvf+w72vYF+PsK8s1pSaa5ksiw0OtqGf4idOn+6elA2fgriAIddzW7WsI5UphBC4b2hguV6UE6hPUnVPbYGsHp+b16lPWkFRc/TPwRwekXAymry93TK0wwUNi1ucPdsJdyZwUzj8A2pduhg6NYxcPfIiBW8UDR58Of/dszlSLk6Kd9y1pLwJirF6Eh/uzo2p9BjmdvFRQX7e75gfD8zqXleMC91PjPNUlxqP8wW7Rk2wDvObLvMUKn27fFJeXO+yzKRgMfdsnkhvJMACG7P2l0Obs2K8QDEuj6fI0qJ0AQKCaIJdv5bhY6z7ySQVrPcqBfmujcFjy7g+yR5hquqfoa2IZBEe73wpBcC9a5N/fK17eqQnO5iZGSrpw1qTD3cwEpzNTABymjIVp6FlozNWnFsZQEhuM+VSe/ahIX9oXyZYiVDSEBFq3eE0Rq1c52tO3TeUG3Uq4UqRgcc5ib2pQFwbmauC807Rxfq6gag0c+MfUH0k9sLgOiBL7/ImiyJ1bEGWwvJq+qQZ4CUxlartxRwCdb54lPLSeiXFoYhXQ+1aOvWK8hZDCiY42kImMLXtqLSzlEJ9LT0YSKcGDZ1B+Pmmhp+Z9BkdW3z9u3oG+hJzjR5wB7wLpUAWMHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(38350700002)(38100700002)(8936002)(5660300002)(2906002)(66946007)(6486002)(52116002)(66556008)(6916009)(186003)(2616005)(478600001)(26005)(66476007)(86362001)(956004)(7416002)(8676002)(4326008)(36756003)(7696005)(6666004)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ItTOAxgYL/4PKzjt0jNs4JlQcZZkjNlOCo6N6T4Kzw4r8a/PM9uJUEByfaNg?=
 =?us-ascii?Q?Vp0fln0/do049+S3gDIDNAqZEM8S5nBlGO7U6fXHMJCIcSIabakD7NTy01yS?=
 =?us-ascii?Q?yGJ9rMwlrCBjoXsOFFp4lrkyQG1rwdq9K9iL5iWKx0b1ttlfeqgmcjZUwjtA?=
 =?us-ascii?Q?NnQUHgasF3oz2Ybx9Le711s9PyrY9c9FqzRoH3YqOopL4ISDzKdVgXb0ZeeP?=
 =?us-ascii?Q?Y14iuA2QHvNPayKj/AnAEBgATMTiiwZRkPyo79iV4ZLQeBwDIoFo3PF3eFlH?=
 =?us-ascii?Q?VuA7j5lHOt8YTRfTTgHU2L2rxKZdZkoA/88l468HC4zKlXT319pOdB3xX+ew?=
 =?us-ascii?Q?P05XduAJ7dC04+0nY6UhdSdhEHQobNRwkptJm+s/A2Dqb99z3z2kjZJjYkUz?=
 =?us-ascii?Q?srBoZk8X6vTuEcTOapUV37AZSN1jZDoIp+WAg0iRnR76AGe9JX0fuKH0scm2?=
 =?us-ascii?Q?+HFeW2sV5Jz7NOZHJ1uDZLiWMYoJE53KteypOdayMQjw1X4yLjKjwyB9Bwi+?=
 =?us-ascii?Q?UWpPzgkUNsHwa9TlJt5joA2PeZkYq3Nw7AGNod3DHV7mkAwRvYhW1llRdgsj?=
 =?us-ascii?Q?Xv2znhwPVbQ5q6AYDYczFM5FNE23pdV9vn9dmpElC+twslaHbjRNnD8r7VeG?=
 =?us-ascii?Q?63GO6ETS7SqjynmF5/JrXVvohnpjDnqQPKc//+VGMgQgkATxhB/4J5tYija6?=
 =?us-ascii?Q?HOyl3GFy9Y5fTNI1uA2clf8RG+VkZg0q4OZmtRpDnOvPP3q+rXJYHAt1rVe0?=
 =?us-ascii?Q?0XzDZCR6Z+IAkHWp5ScSiHSEoth+dSRaaP+HVkoJ5+2pwxHz1PAOwQ5O0VpX?=
 =?us-ascii?Q?z4yczEBLtiY5HuF4+AI8K8OMyRuwbBLBRlIeFV3y0zpDTgWWcEfy4mVrzjG6?=
 =?us-ascii?Q?3BkrEuU2p7umQznViRskp8BcMpTksx7KPl97/w63Fd1hv0s7D4MeT6FYwxr9?=
 =?us-ascii?Q?MQuijAetTN+XuiHAceHcNtZ6gZJFUehXFGoUM0spGbqV/4ECI2Lf24pS8n6A?=
 =?us-ascii?Q?WfzINnkms2eRMuLODkb6BEC/M1wl1vvCxeNXEpJ6RnsYTPjE+ANPGEXZrPAJ?=
 =?us-ascii?Q?JVH85vZwPlKigauxj0bwCAOzSajKVnH5128zxOU4Hggq8XZ7aoyEOhCrO7Pv?=
 =?us-ascii?Q?xntFHkjmLhJVZn2xlYpRx63qM+vnDuL6sfp2zvKJWbsREIkWriEUF5pE84Lt?=
 =?us-ascii?Q?HxyenQzzHpliU5vSL05bc5GlAUgqkbtKeXYIdxzi+vn9EJOpMpKAG/TE9fgG?=
 =?us-ascii?Q?59+ujNq2NDvMp9N5rcyaHxV+yj126X7OgD0d61jM3chiyAXgbkwlos4IPlYz?=
 =?us-ascii?Q?XIiqQI6Wui3oBbWJS7TDPRFP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2967f2-2697-4df4-13ab-08d960ba19a0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:31:06.1599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYaXFTqKWXAVeyw44XYZbHYCjezOT5L6uiyXCTpVAIxC5KnErsID/VCtHXAU49RXYvwe48lTrKKlP2Qd9HK6mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Mirror VM does not support any interrupt controller and this
requires disabling the in-kernel APIC support on mirror vcpu's.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/i386/kvm/apic.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 1e89ca0899..902fe49fc7 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -125,6 +125,11 @@ static void kvm_apic_vapic_base_update(APICCommonState *s)
         .vapic_addr = s->vapic_paddr,
     };
     int ret;
+    CPUState *cpu = CPU(s->cpu);
+
+    if (cpu->mirror_vcpu) {
+        return;
+    }
 
     ret = kvm_vcpu_ioctl(CPU(s->cpu), KVM_SET_VAPIC_ADDR, &vapid_addr);
     if (ret < 0) {
@@ -139,6 +144,11 @@ static void kvm_apic_put(CPUState *cs, run_on_cpu_data data)
     APICCommonState *s = data.host_ptr;
     struct kvm_lapic_state kapic;
     int ret;
+    CPUState *cpu = CPU(s->cpu);
+
+    if (cpu->mirror_vcpu) {
+        return;
+    }
 
     kvm_put_apicbase(s->cpu, s->apicbase);
     kvm_put_apic_state(s, &kapic);
@@ -227,6 +237,11 @@ static void kvm_apic_reset(APICCommonState *s)
 static void kvm_apic_realize(DeviceState *dev, Error **errp)
 {
     APICCommonState *s = APIC_COMMON(dev);
+    CPUState *cpu = CPU(s->cpu);
+
+    if (cpu->mirror_vcpu) {
+        return;
+    }
 
     memory_region_init_io(&s->io_memory, OBJECT(s), &kvm_apic_io_ops, s,
                           "kvm-apic-msi", APIC_SPACE_SIZE);
-- 
2.17.1

