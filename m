Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA082DC50E
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 18:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgLPRIl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 12:08:41 -0500
Received: from mail-dm6nam12on2041.outbound.protection.outlook.com ([40.107.243.41]:11613
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726155AbgLPRIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 12:08:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loPcJpiJCJX+ytnA7wA++X2qCC6Amb+X9ILl9Qa+qMTxkdMh5QHJW18bGFocW3irs/ObykBTfR/7+9YJOJLao9DGAAXOW55djQmCC73kTg4Ia2C57ScEK4QTwTJWqjgKAsI0x+yAfSSe3Z912Fu8FmLtG+NcGaBcHV9JQskgTo+ayHissndcPGPAVkY+1NZvDv0JxuKqpoIxT6f1T24UUl77D4wmhrUEnGwAvfchztQUaVrbHuCkOxPvFG4dA0uaevkKFTh+KT9aAqecApy0KKnEbj8Dwfx9w7OxVevb1MfxzRPsOzN8HH0LTtgtruuqBfCdvM2goCJD7qBo+49kJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtFEL5Je8izR+KzPa8s3kQzrz8liliCiop4X8/3vITw=;
 b=j4Rn6ZUBXhjAtSXebRDrBEEfuYB4jWMAjRkrPHXVPF1tAZ6MHMB9HsPuzfCiHgFeGpuylIFeNfCFaCrqiBJBvcMAjvB7T/aRU52NiaaKtfhTiMKQtYIA4vgaitbbvakIc9o8M1NCjKEJqPsToMKVj9u6WtM25Ww0nwWjD9g0ickf6xZBcXCC9H40fJmHw6xD/KCC/exQq83l+GO/QJE+XA8kEaunTwrtQWRPrSIJ6A1zhlQCwrVNocMR26VcyhDa6DC2MRUDdyC+xNXuVX49OjeKJ7vMyRwiXK5x0PGOrNreoQpefwuRnAnWhiIs7O6oxATeArpuRpfEPl/coWO//g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtFEL5Je8izR+KzPa8s3kQzrz8liliCiop4X8/3vITw=;
 b=kUhZl4tAuJH5X5gJ6AL1apNhVjFPPsQZUP6Q1syvdj4MBBrJpplGVkmCHgh3hTh4TNWH/Js2EyrbXJjwc2lNThU5LlevALWUpyW4U7WVtkecoQDSGHatdgmr7jZMzUpAuF/Z4tfEUVH6Et8oiY6eH93Ytr6TpcPwEDq+w1Pv/Ko=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4213.namprd12.prod.outlook.com (2603:10b6:610:a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.25; Wed, 16 Dec
 2020 17:07:47 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::b965:3158:a370:d81e%6]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 17:07:47 +0000
Date:   Wed, 16 Dec 2020 11:07:40 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <20201216170740.d73xomotx4c3oxql@amd.com>
References: <20201214220213.np7ytcxmm6xcyllm@amd.com>
 <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
 <20201215181747.jhozec5gpa4ud5qt@amd.com>
 <20201216151203.utpaitooaer7mdfa@amd.com>
 <f22e2410-d4e3-f5fd-8e40-4225a83851c0@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22e2410-d4e3-f5fd-8e40-4225a83851c0@redhat.com>
X-Originating-IP: [165.204.11.250]
X-ClientProxiedBy: MN2PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:208:e8::31) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.11.250) by MN2PR20CA0018.namprd20.prod.outlook.com (2603:10b6:208:e8::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 17:07:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44478b30-d26a-46c7-91a8-08d8a1e51cf7
X-MS-TrafficTypeDiagnostic: CH2PR12MB4213:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB42135CF206B03F0E1160EABB95C50@CH2PR12MB4213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T26tNXrmhokciZJyyOaf1SraTFqFtPKRI0LNWI+b7Pgin8r7j4OFra7qr0CxGCIYvdsnrgBmmjKkt0PeeDTJyUzri0wara0NYtPwd9oNEYRf9enAURLRCsddegdrnHHE77oT2P1nKup9Fh15sgIyC85YE6BZ+9YzCeXwNyRLTZmkts+yFH5mcmK9YBpXT4Hk/P8GqBRqb7QQg0N5MMLqXdypsBAIqwkgLYF0ZjGF3AW38NVCPIoLjfEpXv40/PFWa4Zapz6rn4BGrvrkq/1LBoZiYnXafjWNLO4QObMTaOTb+Lvf1/1w1uXlb2UaHcx5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(54906003)(478600001)(36756003)(66946007)(52116002)(8936002)(6486002)(44832011)(6666004)(2906002)(1076003)(186003)(4326008)(16526019)(2616005)(66556008)(316002)(26005)(53546011)(6496006)(6916009)(5660300002)(7416002)(86362001)(956004)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kyhuQ5o+Nqo5NH9J8A9OOdOkFgCCZvDBk0HSa4cPehv1kx36b/hs3tJeVbD5?=
 =?us-ascii?Q?qVDwxPTJZZ8aNUjrya/ggxll2zqULvyt+FcV15awt+yWQO4gFl/n7BLUjGZA?=
 =?us-ascii?Q?WZvX6QmYq0r/AgGCa4KAs+WGB3doHt4J/foLf63ozUFXZcjCJfnXOzOmL902?=
 =?us-ascii?Q?oVvIvZRdxYyMZH0ylkqtcBKOTBDV3A4H8vJgM5fx1R8sgDIVOVYj6PBbzIh+?=
 =?us-ascii?Q?KeQ3vYokPmD8oS+oX9OrMgDjGFYHopLayJzRTMKLqQU/xksYtqRHxFOcGcdX?=
 =?us-ascii?Q?/WaLzIvUpGH3AhXnmGIGGEzAuxGT4vRGhQQja3j/Nx3soZgkiYlMcygh9hIw?=
 =?us-ascii?Q?bR1CNyUzhvAXl8sCJvQJStTUOTrtpU43mO6PLDlsuDuH4qwDfyIx72MDg+AE?=
 =?us-ascii?Q?gx5KXy1H65YY9Eah0lqpzq0PGjrYJhsOwib12Cn4V9FoxEcuOAHcbABnd7Qf?=
 =?us-ascii?Q?f9M9KEnJ4IUTOWiiQkj8SwnS3WpumyBvts0fV2ZAFrvAc8eNhBlD3iz4LpGl?=
 =?us-ascii?Q?lJr3wBKWEMTM83vXPe6SJ+I05P0E32X0U77fd2OeAyz9Kj+fysg7C1TolsQ0?=
 =?us-ascii?Q?pr2TkNK1g85zgx6VT0dbVuu7MRjOGzO2pG5n69fSdhd7UT9mWglQqJCdvWHp?=
 =?us-ascii?Q?K9Dgb5Pb8V11uGMLwID0V7RXmWZN5vYhOtIZ1EBiMcXcWww62wru6tpHSn3q?=
 =?us-ascii?Q?bqd294kvGZK/plLcuONb+thA+q1hdE89F4XSEoAolWjrVnKkBlW0gO0MOlVY?=
 =?us-ascii?Q?eZl7EQC11CYaMY63gIQR0pmyNrw67t5nYeoUVj34D5HWRtf0q/sF3ym6is2o?=
 =?us-ascii?Q?1tLn4kbghiWSRS1xbMXUvBLsIrfCr20KIhBFIFL2YnKWtByhzE5LV2WwcofI?=
 =?us-ascii?Q?ciMfveOlPp55CugxAPKIolI6FbGPiNQv6izYFaHyque3Ug7dqO7r7s4aRfHH?=
 =?us-ascii?Q?DFIuIm2dyLw7cdDTRmsyAt2nKLtGsNK0VAHP1G119GmLvdugSypgMkJ7o1kp?=
 =?us-ascii?Q?hRCe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 17:07:47.8086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 44478b30-d26a-46c7-91a8-08d8a1e51cf7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Vyx652DLpk/r+BEnnIdJqL869U1zfAFqwEYgEAujh5WmjZB5uZfE3vkX7cRjWBh/V81WlRDszqAzPRBDIaGiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4213
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 04:23:22PM +0100, Paolo Bonzini wrote:
> On 16/12/20 16:12, Michael Roth wrote:
> > It looks like it does save us ~20-30 cycles vs. vmload, but maybe not
> > enough to justify the added complexity. Additionally, since we still
> > need to call vmload when we exit to userspace, it ends up being a bit
> > slower for this particular workload at least. So for now I'll plan on
> > sticking to vmload'ing after vmexit and moving that to the asm code
> > if there are no objections.
> 
> Yeah, agreed.  BTW you can use "./x86/run x86/vmexit.flat" from
> kvm-unit-tests to check the numbers for a wide range of vmexit paths.

Wasn't aware of that, this looks really useful. Thanks!

> 
> Paolo
> 
> > current v2 patch, sample 1
> >    ioctl entry: 1204722748832
> >    pre-run:     1204722749408 ( +576)
> >    post-run:    1204722750784 (+1376)
> >    ioctl exit:  1204722751360 ( +576)
> >    total cycles:         2528
> > 
> > current v2 patch, sample 2
> >    ioctl entry: 1204722754784
> >    pre-vmrun:   1204722755360 ( +576)
> >    post-vmrun:  1204722756720 (+1360)
> >    ioctl exit:  1204722757312 ( +592)
> >    total cycles          2528
> > 
> > wrgsbase, sample 1
> >    ioctl entry: 1346624880336
> >    pre-vmrun:   1346624880912 ( +576)
> >    post-vmrun:  1346624882256 (+1344)
> >    ioctl exit:  1346624882912 ( +656)
> >    total cycles          2576
> > 
> > wrgsbase, sample 2
> >    ioctl entry: 1346624886272
> >    pre-vmrun:   1346624886832 ( +560)
> >    post-vmrun:  1346624888176 (+1344)
> >    ioctl exit:  1346624888816 ( +640)
> >    total cycles:         2544
> > 
> 
