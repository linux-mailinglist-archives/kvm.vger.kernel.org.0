Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B1E3C2B06
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhGIV64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:58:56 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:31937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229606AbhGIV6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blStnt+OCKGx7B6YibqfO+fIw1T+OPKjEuZ85OBs5hfsnXjbDaewMYMJoDwQQ6DP12jKAuUmc2uTmT5RKc/Gutg3MamJPjEkdBBafFSKJAlPjk5ePxVmF7cFPteiBuiWjA/+R6W/KJt8zI/XABekdSOZoDhO3CU+ESRs610eJhOAVeRgI5Y7BuOBuKSZ4arXg1rAyjsYxmq7c3Y1ueOM2r62zXTgyghOlIx68KwRbYx/ovPqVAlz80CR5ZQm2HUS4yafKEUdT6KxhdG5BBW6r6NiQe8uYP5bGIkE1w/Qan49Vy70pMrIaECtojNJBq4ICzHORT2V4r18ytbSVSYm8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAssQmr9qx+GZtyr5p9VW8nRiYgpmia750pPM0JvoSc=;
 b=hOffVaifyyIg9YL3w2GObXNPgSV8As8XQJysC6iUNso0nFXRjYtlUv/uXCjNhD4V7kQNCb9BCAvnv5JdyHzvEwyRsVSXG82b4/tOPyfhbFABC8r9MEdwclp+YWwci0AWjkPyba6Gpf3U9Z+u6dbaJQP6QDYbCP2skUqBQCsx+lL/mV90qUnp96Y/ZaO2lMqW5ysnOMldZnqhRbuoC5r6lR/uaZ0eCuGeKajvWCmauOHmB2LAh5bqee8/t5grTgj5yAMfewOVw4Uc0yyLiT+2KjCdkjLOmxFYkObiwo9JpdmOf1CYeHd1Lg8PcgH/iQ/Dd9XxS7Tjb7YIqN+eH1zCdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAssQmr9qx+GZtyr5p9VW8nRiYgpmia750pPM0JvoSc=;
 b=w5DHB+/8CEQqzym3S0WjbCVnd25Zr0+68jUT88EYgDRy0YCm9x1CI/HvKabzupiJK4p95LR5+XaOzrgZhjKP48W07SBwHA315SkVHy9VDecKp6iGPRvZR8fKIvpmnKDRw2oPUpVvMPtIC4DNaX4etcWf95J/rw1wsfC37wcADzs=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 21:56:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.022; Fri, 9 Jul 2021
 21:56:09 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 0/6] Add AMD Secure Nested Paging (SEV-SNP) support
Date:   Fri,  9 Jul 2021 16:55:44 -0500
Message-Id: <20210709215550.32496-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 21:56:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c191492-2929-433d-8346-08d943245c1d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4575CEB8C5B2CDE458CE3701E5189@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2+U8pY4tkLAahi9zOsw6BwXeVyeL6V112ztWKf17jLgEnO9lJ6KGe8vg+Ko2x238IOEW87jR2a1r8RpSwayJ/P6SOZC25EDf4XkAjk7GpLFg4AKb6fS3iSzkFRvTPa3duLvRCSw9/SQ9chBqTYjhhgR7J29wcKy15M4HwUWaGAFwXg+91xBV9UGHj6Y9hu1IEF3igNc9rfUbaGEfdiu0vol1EyMMkcp2HscEjmVXxOuvUR/kKapMvpOshmi7X/GgbGTQ9KFRis8SxF/DQNrfQpI3koZ64QHQ91L3A112hNt2k6h24yHb+c9UU4a+ePzUcDoGlf+WMjD5aOzrIS4XJkcCjWvTq1vywDTEMCXmuzVLPGnwbJN/U1RygK2Z5lp/VwgHdHM6qjDs7rpjN1o5R87gmS1ZXqJDrsPih+vVVjTMvwpryRmHdE0XVxIyuVqxSM0ArWnyTejn+Orm6arckEjk2yyO/vTsGkLi46DKwuyomFFz60mIkuxqmLxkyeGE1Onrc9CYpgWius0LrhGagkPSWhTZ1wUKgYG2LgRLjFFH38jP/Tvhu06UbqqZ+DwnhxyOL4ITFa7JwAEg64gCdiRU8n5aHUGkAVeSwuR95EHwxLw8efK2GO7Nipl8pmjAelmrPDih5tNQkr9pIiboZf5CN56WAWsv+aIkr6kVton5bD7Zi0gWJegNZ+quhRg65c9oTYm4CCU4nA3CH/9/lSMelsuNV8lyTu6UEtuMBv+8qYKufaTC1Fw6HwXEYPZnlElM5Ikjme1Kf0rAV7PM3mvZNWW0hNygoA5zLfd0FN7a8wadcgJ9WSjMoqLwHdR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(6916009)(2616005)(66556008)(36756003)(6666004)(6486002)(83380400001)(7696005)(52116002)(2906002)(66476007)(316002)(4326008)(186003)(38100700002)(66946007)(38350700002)(8676002)(8936002)(956004)(86362001)(5660300002)(44832011)(966005)(54906003)(478600001)(1076003)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hB6a9zy/B0E2F/NENvYkOdEleWTURdzdORMK1S/bCySOn8F6/D+NTcv6lTw2?=
 =?us-ascii?Q?fUEbHte4QPPQ9KIQpgl5ZRJ6fPy939LKTknX3Wzt5AY7wgW+uWJWRgynk7J5?=
 =?us-ascii?Q?C3+3B1RLf4UT9TYrdstiqsiLMFps/V5heNgARirLZhxHwrxOAGneuGABKY3P?=
 =?us-ascii?Q?fzrk6y+0eLeWrnsquKp5fvOZ0BfErYDcpnjiYnMO4sH6DTNsrzrmupC/zGfR?=
 =?us-ascii?Q?ZwnBqDakNMOfjRF/YZzaAKF87lrx4tN8RWFW9gNlrZumZnnetlm39P9MP95/?=
 =?us-ascii?Q?S2ohpytAR2Mjt+a8JVRcxKJ4DB9cqT8zXZ6TxfvmApxSkRwI6GfcJrihIwhF?=
 =?us-ascii?Q?yjS/ZLrSft5j7bGl0j1rzGgWuE/aIr5WoOx38br1by7Nj4cc2TYE5BihdyBv?=
 =?us-ascii?Q?W/wZiBvORW+P1VDIFkTGUQHORTrtciOFB7N0f2HSlG1RwEOzcYbMSAqGmzen?=
 =?us-ascii?Q?/QkKDvXKi6kV1mL53DE5YbCvLAXJRZ6P8wbSItGrzA1dD2NgtiL4o/YNVcsr?=
 =?us-ascii?Q?E+fKHwcDqzcrIya05fr6486K6+h7e5DPtVTlOiVUmK5FafRsFM2vGD+2rEU+?=
 =?us-ascii?Q?+NXc174APDEtCL/Y1k2FlAusWbLvD8orjbTnpk9bXG0QPQ5joFSGWWWUwYPs?=
 =?us-ascii?Q?CrTIpZnNe1ZYSN56iQEld9VbDz+mxbzgTVf0S0RIpnpDXf4KM5acCg/bmT2t?=
 =?us-ascii?Q?99l/1QwHDYuL0qULUmWjsWI95RTKG+tc9F30qQ3wIchpwcFw22wiJAQ/mr/Q?=
 =?us-ascii?Q?jghJCJ7yI6XCERtvTWe9iOeESvgjRCw0dcBwlN7E2P6I50Li1h0SbXxzF2Ml?=
 =?us-ascii?Q?F3HWhv3pOuiCKFLDGz5vhfItIw+UHWoy+VaKD/NuHl0sECB0RdZ3fWNZl8bm?=
 =?us-ascii?Q?RJFBq0JGNf8UoQ6P/l+F5P7OPQFAA78YEF/G9oRF8MMRHFBsUX750MzFR9gE?=
 =?us-ascii?Q?tWVg/bVaCN1d1veRC7J0ODbTHCDRdPIzSBekjnMVvU1kAb2gmhpuGjKEZJix?=
 =?us-ascii?Q?xfx7t3BIuTRtrrtJiTGYotz4b8yustNyEZj8yKCtjG3lLI2cetgIWLJV25z6?=
 =?us-ascii?Q?mIpg37kvMrKoRmsa9omtWKzRsFUprH+SHhWVMiPYEhxd0MldYg5VtuZkoM2Z?=
 =?us-ascii?Q?y7xh7aoCN8XxPsroHgIg0bQS64+YETcQ1YC0pVBeH1/PM2zSYjZ5DQ3m6pfM?=
 =?us-ascii?Q?eINHvzrLopC1pZXltyvO+sHjgYeQmTvDYZLCQ3Mkcz0rj4i8pwNv6iFQVOv6?=
 =?us-ascii?Q?9v12eORGxuFEgeltUYOJ4hzntdkDg1L0trKzqeuGj9j3MVJYIIvRq5nSfjzo?=
 =?us-ascii?Q?gB0Drp7jo+XlAZjuvRW0lt8S?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c191492-2929-433d-8346-08d943245c1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 21:56:09.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7jHxiIMEBQSxC6IAAFbH6nuD3AJqpOJmfdqNikSHV9xm7b/YfH9L5IrqWDaSQwkDHcefQ8/BnbBWeS0SJ/1DHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based memory protections. SEV-SNP adds strong memory integrity
protection to help prevent malicious hypervisor-based attacks like data
replay, memory re-mapping and more in order to create an isolated memory
encryption environment.

The patches to support the SEV-SNP in Linux kernel and OVMF are available:
https://lore.kernel.org/kvm/20210707181506.30489-1-brijesh.singh@amd.com/
https://lore.kernel.org/kvm/20210707183616.5620-1-brijesh.singh@amd.com/
https://edk2.groups.io/g/devel/message/77335?p=,,,20,0,0,0::Created,,posterid%3A5969970,20,2,20,83891508

The Qemu patches uses the command id added by the SEV-SNP hypervisor
patches to bootstrap the SEV-SNP VMs.

TODO:
 * Add support to filter CPUID values through the PSP.

Additional resources
---------------------
SEV-SNP whitepaper
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf

APM 2: https://www.amd.com/system/files/TechDocs/24593.pdf (section 15.36)

GHCB spec:
https://developer.amd.com/wp-content/resources/56421.pdf

SEV-SNP firmware specification:
https://www.amd.com/system/files/TechDocs/56860.pdf

Brijesh Singh (6):
  linux-header: add the SNP specific command
  i386/sev: extend sev-guest property to include SEV-SNP
  i386/sev: initialize SNP context
  i386/sev: add the SNP launch start context
  i386/sev: add support to encrypt BIOS when SEV-SNP is enabled
  i386/sev: populate secrets and cpuid page and finalize the SNP launch

 docs/amd-memory-encryption.txt |  81 +++++-
 linux-headers/linux/kvm.h      |  47 ++++
 qapi/qom.json                  |   6 +
 target/i386/sev.c              | 498 ++++++++++++++++++++++++++++++++-
 target/i386/sev_i386.h         |   1 +
 target/i386/trace-events       |   4 +
 6 files changed, 628 insertions(+), 9 deletions(-)

-- 
2.17.1

