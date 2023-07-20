Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283C775B9DD
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 23:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjGTVxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 17:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjGTVxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 17:53:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064B41719;
        Thu, 20 Jul 2023 14:53:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOy6LwCCLbiR+TOeNrQiRFyL/VKAFagTZo238T03r/CM702zpJ06tf+H4lOjSSczBTq+HyRXwIITMjI1xP48hln94wHM4XEnLQ5mch/WGMT3UDPhAfItcwbtiekhsIa+wVmHwql+WoLDfFWprvCf3zm/7A4uHnaGDiMrfknhYDv8T1Scxh11/VKPBFOwS1W1jldnPq8GcHsA4jyhaLp56znxkVzZ7Dtd8dKvwO7/DZdg5c2kVXHYp55xlklPQoLa0W8oZtR78fbvudRnW1t9r2x8PI1mdjGh9ziK+qAB4fpeYENglYQbh700mRV2PAoGLMyZXlqYmHvD3XJI+1UJFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgxdfsaflM2nZkdxZ5yCPVSkw1ggTly0tYWaJAbSPe4=;
 b=N6E0MtNn75WFyLuhvyaOuERQtk9GwGjzcZyPIQGKUUBIEKw0ELzNyrDHj5ugdBRvpZQi7eNuW5ABy3XMJYEqtfVEkzjI+i46Aqwd4qHEnYi9VJYg2ppu0PnL1nIV6K+/3P50VB8M+1Xx3W81enn9zTTXzSSMtubGp6M3EGLXjedDP5EDXtzwtocSilbZmKrztfsEsCnXjS5DMU4fhFTt1p+3fW3foVfTv/cvdWLHEg/NwZCTAB1mof5UZB9j+ddaMW1TpxpixXpUyKGnu4svTBaq/O37HBpB7GHaTjIw4OcN2shNHuQ+oZAw4jrWkI80mZbwB411CRFRxu+HpA/qFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgxdfsaflM2nZkdxZ5yCPVSkw1ggTly0tYWaJAbSPe4=;
 b=WKEqOHVT0WmD799LIC5/mHs0aOoB6onqxo2sqhGYnZK3cXnMFijPD/A2yI/gsMj0IvVSVFso1fMlkFqqk4Nn4rR8K9pAl47zXXtr+QaRMYzKgIoemgr6IPVomBaxyOe5nyziZLHr+Dj6Z/GkDofJ1NGTMIuki7k9PlwtNyoLpBs=
Received: from BY3PR05CA0057.namprd05.prod.outlook.com (2603:10b6:a03:39b::32)
 by PH0PR12MB7885.namprd12.prod.outlook.com (2603:10b6:510:28f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 21:53:34 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:39b:cafe::2c) by BY3PR05CA0057.outlook.office365.com
 (2603:10b6:a03:39b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.12 via Frontend
 Transport; Thu, 20 Jul 2023 21:53:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6609.28 via Frontend Transport; Thu, 20 Jul 2023 21:53:32 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 20 Jul
 2023 16:53:29 -0500
Message-ID: <6a43b05b-ffdd-0e6f-56a0-5b78532ee383@amd.com>
Date:   Thu, 20 Jul 2023 16:53:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
CC:     <x86@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20230720194727.67022-1-kim.phillips@amd.com>
 <CALMp9eTBWWcApb50432zZEGg+PMCzUELaZvdkzYngNSrriimWA@mail.gmail.com>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH] x86/cpu: Enable STIBP if Automatic IBRS is enabled
In-Reply-To: <CALMp9eTBWWcApb50432zZEGg+PMCzUELaZvdkzYngNSrriimWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT059:EE_|PH0PR12MB7885:EE_
X-MS-Office365-Filtering-Correlation-Id: a8078f53-77e7-4c0f-f8ee-08db896bc2e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNrk0JfUtGT4wls72NdsnXMpHiVQWdoLCrIvMMheMistZ0l4+EXRxLVvUrAFq+59vY/ZdkpOZ4JSTyaxC2IMy0W3LKVX8yubsHQjS4JClfLA+uuuJ+vjNe5SUOa+qAEzLkH5aHytHB2Ww5BI3uBMzrrhSitwM0TtieU7Wp1UCST5svim9XnMfuBltKk/+OP3T7s16k4xUUUeyckpLN/Ax0OZVub1717FI+e4J1nueSKexwymNRuAdZk6MedNmSwHnNpf8SX+pAk4U6F8GkO5forJsC0UwdZDlf87WnpeCWmBPWLE/ZbWDKvJ/FDHpAzOutSmcCJMF2EGHoKAzvM7rwsPS8pOPz1E+yRrMmpEHFRGurgMmrrF6BxmYHjRLu+E+nyrkfQIB4zXbhItRgmMRpreHY9lV98cItWw+6YyVmKNDzXSHt5kdegmXWODkF/O4YZWSup6T8Z35PkWcoAz4YiPhcscNRBuy0MnWMAv9VGe33lutCmYEaf3Jl6IodgFqRriuWtNOXF4nZ87DmRaPnrK/EIlj6z170hPiGHlZFwmr2lstM2yeBhtnrjc2T0WKmcQzNxSgQlOE0+w9QdHU9haemWYiF5hYab4kCq7rA7umx/wqpeUhDDtSc+kyubcVmc/VpFElf+QwyBuq+qqU59pL7KOmUuDzdWPCelzLpvAqhbTsHqf2WBiUxf9NEI6OV8eFru0LfTYDGqWSUZHXLPDc5/qCYOEAFZh9AtUFHtiMXKH6KsKmtYJPyxGnk7lrmqbbpLhDJ28rzXlU5g/YgobWpXLj+p5FovfRyLvA4b26AFy8hQnslP4Lmlfro8P
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(82310400008)(36840700001)(46966006)(40470700004)(40480700001)(47076005)(40460700003)(54906003)(356005)(81166007)(6666004)(70206006)(41300700001)(5660300002)(82740400003)(6916009)(8936002)(4326008)(8676002)(16576012)(2616005)(70586007)(478600001)(316002)(16526019)(36860700001)(336012)(186003)(53546011)(426003)(26005)(86362001)(31696002)(36756003)(44832011)(2906002)(4744005)(7416002)(31686004)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 21:53:32.6829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8078f53-77e7-4c0f-f8ee-08db896bc2e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7885
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/20/23 3:58 PM, Jim Mattson wrote:
> On Thu, Jul 20, 2023 at 12:48 PM Kim Phillips <kim.phillips@amd.com> wrote:
>>
>> Unlike Intel's Enhanced IBRS feature, AMD's Automatic IBRS does not
>> provide protection to processes running at CPL3/user mode [1].
>>
>> Explicitly enable STIBP to protect against cross-thread CPL3
>> branch target injections on systems with Automatic IBRS enabled.
> 
> Is there any performance penalty to enabling STIBP + AUTOIBRS, aside
> from the lost sharing?

Not to my knowledge.

> Or does this just effectively tag the branch
> prediction information with thread ID?

I don't know the implementation, but AFAIK, AUTOIBRS and STIBP
are independent of each other.

Thanks,

Kim
