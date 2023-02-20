Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56F869D27B
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjBTSBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjBTSBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:01:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30659211F3;
        Mon, 20 Feb 2023 10:01:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cq6nYlCindlYBnW2USj5A+zE1/hb9mZwELE73UAQ+BBUJAchjwl6E/SVs04tjfThdk9nLHjZY1PWWCnuag7GIDns501/YvAPsOjO1RRwGwnAsYEttVfaPkFxe9e42RN/iV4HaIq+tHNj97q9WMXWWgbSiOCcLCjj8Ae0psw1EyNmP4MiZ/gPNY/SFg2DBJ5XhEMAZEwPFv7EUr8/TAnRR7NapzNO+Mn0nqzXGi78V78maHWae1exmYosZ62rpGzlR2mAciCFxmH8YQae9naaQHECBVHB4vigHS8pMtCVeUlW6uSkxueWS8mIp1SHO9lL9R5sQPsyAO18XClnPKJZsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jIXoXIh/rCS4FT7VmzFZqmscBIzGRTFQqENB1R9pdE=;
 b=f/qoM+mRcBWW4Qwc2U6za+1fG2fyXl51H89F04tJDpRT+lFP+Qqm6VThw5by5O0ayR2WN308fyME3zOU6xLTC3cH2aodD8iaTcro+CKJrGl2f4yGhXG1/OJOaBkeSK84xgYZhD/8s90GZRn8goG3qDuLeMUvfb3/JU9x963uHTqUjQ6hpgPKfX+SZCFcmzTVNXSXEPP6uzy7WFA9Xf/c2k2QglHMgg2SqUfQ0CTq75CAktLsJYI6lwcFmwz/7OYEFpSa4QTJimhEoMeJlavyJS3MNRFZdiuBjTVsk1bfNMqimf/Q5ZcmkIUuJIYCdKu9RF4Z282IIwPaw4m5YiApBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jIXoXIh/rCS4FT7VmzFZqmscBIzGRTFQqENB1R9pdE=;
 b=5hs8N2Y3uB2Vy/PWeYHLLj74UXFh+pyTJy3FbaYipqFX07nFXTsEGbzgQSS4u9d9JI/9HHB0WE0nb9YUHUhdSpZ/x4JY074zdcOjRBSJJtwC/2pZcTjApF4LIh7YbGPV2LhsTdnB7LWMjWUQAlkRxChs0B26sKEB1yZ4E72PU24=
Received: from DM6PR14CA0065.namprd14.prod.outlook.com (2603:10b6:5:18f::42)
 by DM4PR12MB6400.namprd12.prod.outlook.com (2603:10b6:8:b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.20; Mon, 20 Feb 2023 18:01:35 +0000
Received: from DS1PEPF0000E648.namprd02.prod.outlook.com
 (2603:10b6:5:18f:cafe::77) by DM6PR14CA0065.outlook.office365.com
 (2603:10b6:5:18f::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:01:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E648.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:01:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:01:34 -0600
Date:   Mon, 20 Feb 2023 12:00:38 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH RFC v7 13/64] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20230220180038.bkypwkjkzsb4xc4b@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-14-michael.roth@amd.com>
 <Y9qx5NbZIRdpHy5J@zn.tnic>
 <20230220162647.czmii5swwsz2wdhy@amd.com>
 <Y/Oy0cvhXIm5kLTh@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y/Oy0cvhXIm5kLTh@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E648:EE_|DM4PR12MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 42965bd7-2543-4da6-e6d1-08db136c8160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sb1jROt16KjoHkqlrb0EltNjHHIiSmxTsEAgT+GKsRr7sMTTmjRjDVNrJu8nhNlh6lFUnMdzCGKgoptZpVmftZp0N+ZUUfJbJU30rl0Rk06HABIQLd7o9wHDJ4u9/AIC9HQD5h59Meo+2QEdl4TUMZxdCBUf+mIAPH02+yx5jz8XhXRoIXo6HSwQloeS0PgiolhvrhQ4lOPFUp7RcGEpeRAFlGJ410UJjHLiWEzkJT1DfSdJHxoUlNf+aL8k0puVYNPWOmKJiQ8YC518g/Ua6XwzI3dEQ3/2J/cZzgDrW6K2+gmfaYPM4owxl25DJmiVSakvilaxULJyiwd6AV4buOGmFqND4Hh2VCoNzb9eKB0mjAQt+1A+/3SiWZqKJBJBQkPYkMqIkmDX/lfLEKIcvv+HbRR/OCzTMTVsv6rjz0QRUSZGSRRExtA6PWDc6eY4xDMEZ7X3uasNt3Q7pJKdSnjLJfmZgJ8+342muzdsKGOVdkL8Y4vrgaGPwrAKPeJQdhBYSSt8ar4H9DGK7yUBl6p48lvLOMXx66128evMzerrb94wT9hJLSyeqEIofGM77T8DnuspJrz9OXL+IIN46wYC9/NN3vzo6RPYXfCQWkg1DPBcdqN0dszuxhGtlWhffZSaTjvQopb1FLUD7oaoAbSyBgjZuImdyj/71Tg3EGUg4GqKjPlYXsZSCt8pkkcg0yu3XftKq9SZu9uKhNQnnCpS4sNko4iMab/s/BLLsw0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(26005)(186003)(16526019)(5660300002)(2906002)(81166007)(8936002)(40460700003)(2616005)(36860700001)(82740400003)(7406005)(7416002)(44832011)(356005)(1076003)(41300700001)(70586007)(70206006)(8676002)(4326008)(966005)(6916009)(86362001)(316002)(83380400001)(478600001)(82310400005)(54906003)(40480700001)(47076005)(336012)(426003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:01:34.9970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42965bd7-2543-4da6-e6d1-08db136c8160
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E648.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6400
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 06:50:09PM +0100, Borislav Petkov wrote:
> On Mon, Feb 20, 2023 at 10:26:47AM -0600, Michael Roth wrote:
> > On Wed, Feb 01, 2023 at 07:39:32PM +0100, Borislav Petkov wrote:
> > > On Wed, Dec 14, 2022 at 01:40:05PM -0600, Michael Roth wrote:
> > > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > > 
> > > > Add CPU feature detection for Secure Encrypted Virtualization with
> > > > Secure Nested Paging. This feature adds a strong memory integrity
> > > > protection to help prevent malicious hypervisor-based attacks like
> > > > data replay, memory re-mapping, and more.
> > > > 
> > > > Link: https://lore.kernel.org/all/YrGINaPc3cojG6%2F3@zn.tnic/
> > > 
> > > That points to some review feedback I've given - dunno if it is
> > > relevant.
> > > 
> > > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> > > 
> > > I read this as Jarkko has handled this patch too. Is that the case?
> > 
> > Yes we shared some patches via an internal tree at some stages.
> 
> In the sense that, he took Brijesh's patch, then he did something with
> it(?) and then Ashish took it from him and then you took it from Ashish?

Yes, I think he rebased Ashish's tree on a newer tree and added his SoB on
patches that required any conflict resolutions or changes on his end, so
we kept those intact since then.

-Mike

> 
> This is how I'm reading this SOB chain at least...
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
