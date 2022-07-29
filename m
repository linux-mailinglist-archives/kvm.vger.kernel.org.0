Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17930584944
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 03:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiG2BMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 21:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG2BMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 21:12:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CFC17064;
        Thu, 28 Jul 2022 18:12:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsuRUypriGbhY8eFfCyx/zMPErRkVQji5x6v9u5COv7RXdnpCjffdnf4rqDelnTDSVbCbN5ipSXmMDJtty8spS+Vydw92FbppcP+RNr9YRLeveDCFSumndxbKWdrKpIDefeWodwr+duNL1CukLmfB+XBPV01qLopUmfpv3hQ6KlKR9xGi4XCa7thqlDQCS2NT/7tElf+Ln1hHsnRTndfcNYeRyp9/eekULCFFArPDEM9olslqftrQZeelakUvP4r6qmLKunHabf5dtJfCHExfupVJaAiw5szQ8YyBfn+vNc0L087uNTHRyo43bUyyIvZ2oaqYIbOKPmrDuliYCj9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ozwOIchTLTJBxc1bbIfDkOrwJ07Hj7JmmoLGUiA8n1M=;
 b=L22MZGn/6GFa527qakAwPvAGV72fUAmLlpAin72n80YLj+KO5vzGLlxaw9PRBw8J50KQakBSb0j/ZfDY2Gs5mkq/VLTGafeA5m4gmVuoX9e9kTsxvNXun6A0iLbrVQjlquKfcW+a3xa808VjDiNElqiYZPRQ8f7wuUc7fL6CObu4o5uhE2HWJon92hgoQcmn8/wxA8cVxRvk6UidIGTUpL43xmF3z1T92Ig3zhvdRGe011Z0ZDyz0onTweTqokfQzshcZHvFyC6BU2xAVhZi1Z4q6C9j0Q2w2o7DcqgbzYcPlSUgtZN5mA5EKFI8Ln2SN0//Uo5tzUqd2Cg+sUh5Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozwOIchTLTJBxc1bbIfDkOrwJ07Hj7JmmoLGUiA8n1M=;
 b=xvy05IxzWVMcmZja/hGzvW80hlJIQvFunsw1EnTn+Uty2Gl74NhQGjhrjCOPSQip4yQZUKIPMSWMSiwZVzyXkZyTlVItxCwZSJCm/4oetef4YXFVKQvDY3RqEtBG7nWG3EuCEh5Hda1e8XiTZt82PgL0gcpLMSmfGzmD9kyvaSY=
Received: from DS7PR05CA0078.namprd05.prod.outlook.com (2603:10b6:8:57::24) by
 DM5PR12MB1675.namprd12.prod.outlook.com (2603:10b6:4:5::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Fri, 29 Jul 2022 01:12:36 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::f9) by DS7PR05CA0078.outlook.office365.com
 (2603:10b6:8:57::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.4 via Frontend
 Transport; Fri, 29 Jul 2022 01:12:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Fri, 29 Jul 2022 01:12:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 20:12:20 -0500
Date:   Thu, 28 Jul 2022 20:09:24 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 0/4] KVM: x86/mmu: MMIO caching bug fixes
Message-ID: <20220729010924.zatnwgprojuqspna@amd.com>
References: <20220728221759.3492539-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220728221759.3492539-1-seanjc@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f342b6d-6e6b-4d73-6f7a-08da70ff6c79
X-MS-TrafficTypeDiagnostic: DM5PR12MB1675:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WC5J3SyqeFtY3ZCYVJM6C499fSmOz6VH/c9kSEofrSDyP5XjbzSS0yEit2NxoCYtd+Iaxhpj1iK+sSeBsmMETk4OTcr2E5A7iqAk+zHDr5pSnh2pxTQhS6gVt/cQC6yHTLDRvILubpbIBddjubXaCZmbaWyN12EhCKxUq1SoGV+T+/UHFEKLdzf1EX7tJnREwlAvfAi4FPWP8gfWH9qtFuZLa7zdMfbGhep8QsMJv++Ch+CilmQQ7XdCrhcWmJZwAGlMtdaM1iLQHapUElg+9ERP/zo0xIXAd6ICKcyJgFdQjemi6PZskBqRYVaiB173eXwVcrR2hdUaWjObCDm892vWaW+Kfs43KSU2RTTWKso35jUuRKrgh3VlOhYL8OLV129ifKUgdusm2/jzNuFFYYyMtv6DlRF5SK1Fka5ydYWgwzg1zpgofY+30Rre04l7cmFR81epCk2YQmq1mTzpVMguvCcIf0yZap0O4fagClkAiqXRqsACJmWu+key9XynNeBSTjQVn5jNNZ46qrnNYIpGhftiT+LUIrRg7oCFL1kX+fgE1XRz6AT7vSROLyyXamYOZVIG+XFf8Pt15/zgZ2Ix5LjXWXoz8mLnfqhwoSynbo16GijN3TNNBo/VfofMeIBd+Ju4Ag7MkQT2+sdbK5GFhIcxESAANlSnTXVVt4QCGTAeLYfE0cFr79LAywh9g+pEePNMa7YQTffpkJETEX3KqyedVWQ7XqlK2TxLfWsWdq+R93LXkb5F871UnYLNrpsVH+I75XDKxLppHAxRVpOcdqNbq2PRwLR9QOothU60Vi0Pm50o8cfrMTfzW0XIepscZRQuTKHrsvjnhliX+A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(376002)(136003)(40470700004)(36840700001)(46966006)(36860700001)(83380400001)(54906003)(3716004)(356005)(16526019)(336012)(70586007)(2906002)(426003)(81166007)(186003)(2616005)(70206006)(47076005)(36756003)(5660300002)(82310400005)(8936002)(82740400003)(4326008)(41300700001)(478600001)(44832011)(40460700003)(8676002)(316002)(40480700001)(86362001)(26005)(1076003)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 01:12:36.4121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f342b6d-6e6b-4d73-6f7a-08da70ff6c79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 10:17:55PM +0000, Sean Christopherson wrote:
> Fix two bugs I introduced when adding the enable_mmio_caching module param.
> 
> Bug #1 is that KVM unintentionally makes disabling caching due to a config
> incompatibility "sticky", e.g. disabling caching because there are no
> reserved PA bits prevents KVM from enabling when "switching" to an EPT
> config (doesn't rely on PA bits) or when SVM adjusts the MMIO masks to
> account for C-bit shenanigans (even if MAXPHYADDR=52 and C-bit=51, there
> can be reserved PA bits due to the "real" MAXPHYADDR being reduced).
> 
> Bug #2 is that KVM doesn't explicitly check that MMIO caching is enabled
> when doing SEV-ES setup.  Prior to the module param, MMIO caching was
> guaranteed when SEV-ES could be enabled as SEV-ES-capable CPUs effectively
> guarantee there will be at least one reserved PA bit (see above).  With
> the module param, userspace can explicitly disable MMIO caching, thus
> silently breaking SEV-ES.
> 
> I believe I tested all combinations of things getting disabled and enabled
> by hacking kvm_mmu_reset_all_pte_masks() to disable MMIO caching on a much
> lower MAXPHYADDR, e.g. 43 instead of 52.  That said, definitely wait for a
> thumbs up from the AMD folks before queueing.

I tested the below systems/configurations and everything looks good
to me.  Thanks for the quick fix!

  AMD Milan, MAXPHYADDR = 48 bits, kvm.mmio_caching=on (on by default)
  normal: pass
  SEV:    pass
  SEV-ES: pass
  
  AMD Milan, MAXPHYADDR = 48 bits, kvm.mmio_caching=off
  normal: pass
  SEV:    pass
  SEV-ES: fail (as expected, since kvm_amd.sev_es gets forced to off)
  
  AMD unreleased, MAXPHYADDR = 52 bits, kvm.mmio_caching=on (on by default)
  normal: pass
  SEV:    pass
  SEV-ES: pass
  
  AMD unreleased, MAXPHYADDR = 52 bits, kvm.mmio_caching=off
  normal: pass
  SEV:    pass
  SEV-ES: fail (as expected, since kvm_amd.sev_es gets forced to off)

> 
> Sean Christopherson (4):
>   KVM: x86: Tag kvm_mmu_x86_module_init() with __init
>   KVM: x86/mmu: Fully re-evaluate MMIO caching when SPTE masks change
>   KVM: SVM: Adjust MMIO masks (for caching) before doing SEV(-ES) setup
>   KVM: SVM: Disable SEV-ES support if MMIO caching is disable

Series:

Tested-by: Michael Roth <michael.roth@amd.com>

-Mike
