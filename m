Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE685AE091
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 09:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbiIFHJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 03:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiIFHJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 03:09:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0297565663;
        Tue,  6 Sep 2022 00:09:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dY1wPXHnrMEnxZciiGfS4XSgRUh/IXWahcmOFtN/+OdybMsqd+W9x/lxWaIUsqZoTHsH4rsItI3kf/WVJyG9N4L1/3650PE0b5ekY7q7/TkyYk1kaFTRV71pcqZg0cYrsNOH50wqJfo+3oaq1+hLEdabZ+g0ZXt8ot9tZR/4nLnlzrX7nNcByzU06t59VYkKLaeR5Ca7notRErd3djgctnEd0RhZjM82yjSahbJ+wXD8lh6GP3XvVrWWQZ0NK6ie5ynRxZ4jtoffE5znaOCBXc1E5adrXc9H20HBkP+h+M2P4AsoPbXJZVz0STnp89ZuoKucMcF56QktfLboXeanuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVqjBGkFgXrs31AA2OHw7MU01gBpvRs6t5y6CM6f2Tg=;
 b=lOjDBVufiEWaMCHFThqVBpo69/Ca31qNmAVV5ydA1N/za1AnL70f597eaeTUBLXh7c5GOQ8Cx1iP3NgeHOT/gpLn9pkmeyCzmcVRxIDxq3GRLtBeaYyTT+bQZt4vVfZGcjnMHn5XMX5nisIerqCYxNqztaQBm686q3OA1EwFNuEh4Uo0fxQoJN1wvBrLQcVSnIaEJZLsd+aYS94sZ8qLcjGPPwAKg/8L83hf9DmRz+kTHdVJEaVbrIdJxk9/TIuA21lA8Db30Mp7jWNW0m40fbeWAT4dB4iZbyzWe270UXcfEKsTJfKpSGMP7n8rD821EzIvoB4/5Vw7pE3xM0srww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVqjBGkFgXrs31AA2OHw7MU01gBpvRs6t5y6CM6f2Tg=;
 b=zn+MsRJlDS55rB9koppwTf9JIKLqRyfwc9/3fsa+EyQq1LsG/Ej88qKLWxqlQ9HMBg9TQdzHm5bHYB8dNb5HZ77UVn+5BWw2vEp6rM6MeB/yDVsMEcgd9VZRx+u8GRb4FhMwPCoBW+1jbfjxu8akK3rfxsEI3r68Bek3vxInxPI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from PH0PR05MB8703.namprd05.prod.outlook.com (2603:10b6:510:bd::5)
 by DM6PR05MB4970.namprd05.prod.outlook.com (2603:10b6:5:31::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.5; Tue, 6 Sep
 2022 07:09:11 +0000
Received: from PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::95af:33a4:b350:c335]) by PH0PR05MB8703.namprd05.prod.outlook.com
 ([fe80::95af:33a4:b350:c335%8]) with mapi id 15.20.5612.012; Tue, 6 Sep 2022
 07:09:11 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     helgaas@kernel.org, bhelgaas@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     x86@kernel.org, hpa@zytor.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        srivatsab@vmware.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        vsirnapalli@vmware.com, er.ajay.kaher@gmail.com,
        willy@infradead.org, namit@vmware.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        jailhouse-dev@googlegroups.com, xen-devel@lists.xenproject.org,
        acrn-dev@lists.projectacrn.org
Subject: [PATCH v2] x86/PCI: Prefer MMIO over PIO on VMware hypervisor
Date:   Tue,  6 Sep 2022 12:38:37 +0530
Message-Id: <1662448117-10807-1-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:74::38) To PH0PR05MB8703.namprd05.prod.outlook.com
 (2603:10b6:510:bd::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR05MB8703:EE_|DM6PR05MB4970:EE_
X-MS-Office365-Filtering-Correlation-Id: 361688ab-6f30-4422-58aa-08da8fd6b2f1
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpEmG/ZTZD41ci8rzga319nfcfWs6F4whtCEkJI1igtHShj/5o1VLFdArTGqtjMdJUQ3j1333o5vV/Px1O0GG2Uj3zj4cq7EBbEGguwtuYnG5WIzK014XG1a0SNRRgHxy+QGhgx78DPW/4hP/rPKdkm46Fq32f/JlnYXfu9fAgz3YWw6gWVRZ1uLE9Wk41ANTglPoqfvyd1FcExNpN3JePJe4sH7NLghX6okgRdiytGbNtziY91ftsvWi29UMKDMINRi6zUmWJZpuv5MPmedTsHEu0m1L1QttboRINoi06f0XUdZXfLYw5MTbIsktHtLW33/6Y46vb4nt2jCe269qOC9cXOy4nQHmZTBL7j4jq4mYUEtRuiKN51HVsLHxts5DVJxTmG3pK/89SJKCisLEDJ6zIC/ib/p3bZ2vvQyJKUfxzcfkErOwElh4SEXu5yJ7swQ8PiEghfIm0g2kc8nFLG3skw8+p01cV3BkoKkxArc7qtWQUDYczpG+TJEs+gZXNp2TfgFvX69zGcuhV16L05T83k9fi5MHBweme39oWZYLD1PXSJ4DBHvkTEXmMrK+OPt6NjIbuCdWOty8rltMwG+zYD4+ZaCzZobICxj/++mWLqADs7AixCOHeN9sNIplsC374NGmwCnH1vmWGSVj29LORst5AuIwRxWUKbF92Q4ee4VRAjEGZOlb+Qd5wTOhuAtFMiJrTWcvOMzkK/VbE/ocOYSloUCw7SUZd4AUcgfrKYFhnkJgpTdnwMIh3oVz6eR6dz2TT9zucNl6YOmTGKhfQFshJnL4y0VEi1NzK3XWey4TwqPevATsZhAuBHb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB8703.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(38350700002)(38100700002)(4326008)(8676002)(66946007)(66556008)(66476007)(316002)(2906002)(7416002)(26005)(5660300002)(8936002)(6512007)(52116002)(83380400001)(2616005)(186003)(6666004)(41300700001)(6486002)(6506007)(86362001)(36756003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmthdHdLNFUwaVhQU08zS2ZzaUQwd3ppUUpKM3BFeVVnTDZYTzRjZGQ5NHcy?=
 =?utf-8?B?Y0kyRWhmVkY3dTZyd1VnWVEyNkNBM3VnU1ZvZE1ZMmFTWDM5Q2l0dGs1WWk0?=
 =?utf-8?B?UU5zWTVGMU1ianJsdldkNHk2elk0K0xHcEZEWXNrQndlZFV1cmhyeHhVcGhR?=
 =?utf-8?B?NjRjQnh2MUhkKzRFSThZT093M0U1MUR3OVZhUkFTWmdaSTg1SmUrT3EzYWpz?=
 =?utf-8?B?cE9oaUdJWjZtb2IrZ1h6SERzSDI2Ni9oaGVaNHBIS1RRNC9YNHAyamNSSjIw?=
 =?utf-8?B?cHpNaXpsU25RaFJBY0lZcGFkS2JIU2xDNFdvSHpWTjJVcVJsMmZURHBNSWJU?=
 =?utf-8?B?NjI0NVFSS0NyOGFBdWdBU1pQRTB6eDZZdG1HbzRUdjZQZWVFWExxVlBaMklB?=
 =?utf-8?B?L3gyNDc5a1ZoczAraXc5d1E4ZDNPYkJhOG1FejNXMFBieEcrVG1zQzg3RkxZ?=
 =?utf-8?B?VWYxNFM3QnN2QkZTZEg4WWJuUXRrUHJYdTZwYy9GM2JjL1pLNTdtcW5JaVZn?=
 =?utf-8?B?RkRPTnQ0a1ptKzhuTDdldUhXWk9XNFdXSVpYTWpJSW8rdHBQcno5MEg0MzVX?=
 =?utf-8?B?bzk3RTBCazl1eFpyTGl0WHFvcnFTaGVqS1pSOUFGWE1KNm9CVWY4Y1hpRVJ3?=
 =?utf-8?B?VVoxZ1ZzaHliR0VNWW4xTGk3VHRLZnV0djVjVnJTRUUvUmJXNnVUZnpBNGQv?=
 =?utf-8?B?bEY5QWZQNzRYc2JRdzhQUDNYY2xyVHhJQWsyb1o0QzQ2YlBma3JWUy8rZzdu?=
 =?utf-8?B?ZGMycC9YRjZTTGsrKzVaTGVaRmIvRlNiaVl0SGVrckRoY2R5cndpVjFoZ2k1?=
 =?utf-8?B?N3RSQmFBSEpNR2s4QnoySVNOdGFFR0VnOEFTOTB6Q01tZWF4bFRwRTZwaFdv?=
 =?utf-8?B?Zkl1ZzRNZXZiNS8rSHFESmpZMSt1bUEzUExKUUtPRFpQUzNkaWFQaDUvQnFE?=
 =?utf-8?B?WXNJa1ZGcndETUkzTmgxem1QUlJWMDhOb2k1R0xTNytwWmh4cXo5d0xvcW9k?=
 =?utf-8?B?enVhVFFPcndROGliRHlOaXMzdUZiSmFyNFZ3dVptbW82dWg1Q0N6NFNXeHFx?=
 =?utf-8?B?NHFMazJuSHR5QU8xNXUrNThURTQxV2YzcHFJMWhSN2w5TlV6RklscVVQSTBX?=
 =?utf-8?B?bUN0aytXbjV4cnpSWDkweXhNOW02UTNMdHZSSFJxN1Z4QmFyQ3FnMFo4bU1i?=
 =?utf-8?B?c2NVeEp5NlBJR2xlemJ0U2xtUUl1S3RUOG90VUgxck1OeGU4RVZHL2RXL3hJ?=
 =?utf-8?B?T2duVnJOTWE0Wmt5aUNEYlhWZ1A0Sm4yL3JXdWFiYU9VVGhTUU5iQ2hORUVG?=
 =?utf-8?B?QWNueGlEVGZsOHpwVnU1cTZQRTZET3l4Z2VaY3VKQy8vRE9Hd2gxaU1HYzIr?=
 =?utf-8?B?OGMrNHhVOTJETkFxUkpyT2hlSEZqT1ZFeHpFTGxpb0pkSG9tWXA0cHpxcEIv?=
 =?utf-8?B?NmFiZzVYaWYxM212L01YRFJVR1NiZVNaaTFrOUlUcjk1ZDgzRE00ZWRKazVm?=
 =?utf-8?B?TTBHeFBqb1ArMEMzSHNOWUlHYmxPM3Z0TlRLUGxoNDNkd3BjWjc1M1NrN2U0?=
 =?utf-8?B?VjFuK1JYQWt4ZWphSU90TWxIYmhLVGpoWTlpSlhrbWNrWjVWSWllemIzMVF0?=
 =?utf-8?B?ZnFqcVJ6alFhWVhvVE1DUlE5TmJYWndzc3l2cW1VNVJQSVNhZXNlR3FkVW9k?=
 =?utf-8?B?WnY2aTRjbWNiZmdVNWlvS3dMdXhndVZxYU13ZEQvc2hLSDFnWG9sZXpDTVB0?=
 =?utf-8?B?V1FtUHBTcy9RNHRNbzBkSWlENk9CWGFoUjVYWXRWa2hzWkdCeEtnNFhKSjJ2?=
 =?utf-8?B?VEMxT0Z3QXEySTBjZmppRTBOVlpHQjhKL2VEd3lSY2I2SmpyejRRRElOKzR4?=
 =?utf-8?B?eHRRZWwwZG1zcHRobDhOVkNIL3dEWGtUSlZ5ZDhEQXFlRG9rY05BR2NhYjVM?=
 =?utf-8?B?WWpQbUlsckhyb1NZRGxrVXlhTHBzYktvQTVzeWc0MG9JMUg3QzBFVW9qaTJ3?=
 =?utf-8?B?eTVOUVZjQnI1VmJwQjZIQ1M2YVpVTVA3MW9GWnM2eW1MZ0p0dmUzSzFmZzY1?=
 =?utf-8?B?ckdBY0FibkhWUHVydFFZVFhtTDZLZDV6emQ0SE5UZVBRVFFBSHdWRDV5ZDh0?=
 =?utf-8?Q?3d+euH4uv/iBa1JTsHAqiuoX8?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4970
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During boot-time there are many PCI config reads, these could be performed
either using Port IO instructions (PIO) or memory mapped I/O (MMIO).

PIO are less efficient than MMIO, they require twice as many PCI accesses
and PIO instructions are serializing. As a result, MMIO should be preferred
when possible over PIO.

Virtual Machine test result using VMware hypervisor
1 hundred thousand reads using raw_pci_read() took:
PIO: 12.809 seconds
MMIO: 8.517 seconds (~33.5% faster then PIO)

Currently, when these reads are performed by a virtual machine, they all
cause a VM-exit, and therefore each one of them induces a considerable
overhead.

This overhead can be further improved, by mapping MMIO region of virtual
machine to memory area that holds the values that the “emulated hardware”
is supposed to return. The memory region is mapped as "read-only” in the
NPT/EPT, so reads from these regions would be treated as regular memory
reads. Writes would still be trapped and emulated by the hypervisor.

Virtual Machine test result with above changes in VMware hypervisor
1 hundred thousand read using raw_pci_read() took:
PIO: 12.809 seconds
MMIO: 0.010 seconds

This helps to reduce virtual machine PCI scan and initialization time by
~65%. In our case it reduced to ~18 mSec from ~55 mSec.

MMIO is also faster than PIO on bare-metal systems, but due to some bugs
with legacy hardware and the smaller gains on bare-metal, it seems prudent
not to change bare-metal behavior.

Signed-off-by: Ajay Kaher <akaher@vmware.com>
---
v1 -> v2:
Limit changes to apply only to VMs [Matthew W.]
---
 arch/x86/pci/common.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index ddb7986..1e5a8f7 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -20,6 +20,7 @@
 #include <asm/pci_x86.h>
 #include <asm/setup.h>
 #include <asm/irqdomain.h>
+#include <asm/hypervisor.h>
 
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
@@ -57,14 +58,58 @@ int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
 	return -EINVAL;
 }
 
+#ifdef CONFIG_HYPERVISOR_GUEST
+static int vm_raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 *val)
+{
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
+	if (domain == 0 && reg < 256 && raw_pci_ops)
+		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
+	return -EINVAL;
+}
+
+static int vm_raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 val)
+{
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
+	if (domain == 0 && reg < 256 && raw_pci_ops)
+		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
+	return -EINVAL;
+}
+#endif /* CONFIG_HYPERVISOR_GUEST */
+
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
+#ifdef CONFIG_HYPERVISOR_GUEST
+	/*
+	 * MMIO is faster than PIO, but due to some bugs with legacy
+	 * hardware, it seems prudent to prefer MMIO for VMs and PIO
+	 * for bare-metal.
+	 */
+	if (!hypervisor_is_type(X86_HYPER_NATIVE))
+		return vm_raw_pci_read(pci_domain_nr(bus), bus->number,
+					 devfn, where, size, value);
+#endif /* CONFIG_HYPERVISOR_GUEST */
+
 	return raw_pci_read(pci_domain_nr(bus), bus->number,
 				 devfn, where, size, value);
 }
 
 static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
 {
+#ifdef CONFIG_HYPERVISOR_GUEST
+	/*
+	 * MMIO is faster than PIO, but due to some bugs with legacy
+	 * hardware, it seems prudent to prefer MMIO for VMs and PIO
+	 * for bare-metal.
+	 */
+	if (!hypervisor_is_type(X86_HYPER_NATIVE))
+		return vm_raw_pci_write(pci_domain_nr(bus), bus->number,
+					  devfn, where, size, value);
+#endif /* CONFIG_HYPERVISOR_GUEST */
+
 	return raw_pci_write(pci_domain_nr(bus), bus->number,
 				  devfn, where, size, value);
 }
-- 
2.7.4

