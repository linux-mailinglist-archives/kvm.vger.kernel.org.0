Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0BD41A3CE
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 01:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbhI0X0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 19:26:16 -0400
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:29536
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238153AbhI0X0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 19:26:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQFpjZ1Rg2nBUgkaFgG264OcPA/QijidNh2QSJdd2GOZmNF6RRMXRwFxxQz8/TlJStOX2xOWMFmdj42y9wNZg3py6d9ww+aptWeMpSBKAevhwMfBo20DqzGvb4jQF/NM6MyUqoYhxcBoDUcGiazv+pEiqrp4hy9bY6z4ccGR7YvPlfKIAsspQYDBbEgpLoMeyPtHK3oEDLnC2CpAb2JOHjsJiemP6C3Y4TCCeD+bTVis5gaLF+lCCF2IrA/c9HY6VX9CT0wX0HxPv6zpVq8Mozcmh+e2d/iwcTrPoTqEgZTLVDLAIbgWF2m1n9plfS1gFcnSP2H7QGXlZ17GSy9T4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BK6wTemQ8x+UBJtfyauXC+xrKoUffWFaZxzs/ngDxps=;
 b=nHuHoNnM+4qran7+jPda08N4ptQVNFIQ1XWGO/zrEBWkT5s58EbGCkJGJ/x4Kw2tY/W3lZ70wwNJnYeCTkQrboZKBxpvqng1pUqVgtjDZyannovzAkc3pnI5JJg4Z5FaQb9doZjde92364MI/873nYWWSyuiHIU1coZi4u+u7/T9VlOkyYLNlIWpYDramOYCSxHbQHucgrpKq81sJ4Yl+JXcwqfjEbUdZbn/Yr7Fl0ZKU8SdlWWzKvejjofD19JfwlMafWqPAqBW54JjBhsZ0th+mH30lA1nVOn67V4aLNXu2WSbycrSbdgAtqXPLJDTSmvf/+ckqIDUpYdaDxWN8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BK6wTemQ8x+UBJtfyauXC+xrKoUffWFaZxzs/ngDxps=;
 b=Le1XchdzM0mhamqBTO5+RZzpltax9TBsjulGqvx7ShFe5DecD50D9lu4XOTWwcFhg+qfZOlbnJXskSYF9dlmhAFS85uV5U4eWqaplaZm3UtB45CXRxAHZYBKK6/c5S3ELuHJuEYxMryOkbLUCy7mi0zLg4Js3ASzhYY+JMvKEM8=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Mon, 27 Sep
 2021 23:24:33 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 23:24:33 +0000
Date:   Mon, 27 Sep 2021 23:24:27 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Habkost, Eduardo" <ehabkost@redhat.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm <kvm@vger.kernel.org>, Tobin Feldman-Fitzthum <tobin@ibm.com>
Subject: Re: Fw: [EXTERNAL] Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <20210927232427.GA10775@ashkalra_ubuntu_server>
References: <6213e737-66ec-f8f0-925b-eeb847b7b790@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6213e737-66ec-f8f0-925b-eeb847b7b790@linux.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN4PR0201CA0029.namprd02.prod.outlook.com
 (2603:10b6:803:2e::15) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0201CA0029.namprd02.prod.outlook.com (2603:10b6:803:2e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 23:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 913541e4-c039-4fae-752a-08d9820df6a8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4510D71C9CA9417FAB2C9D838EA79@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRR/YcPUIutst6pH5/NH8WLly/vlUSThUgYuyZJW5GybgUZBVxKbcQsxvY4QJLeUgAvGCk4RAJ7OvC7p06SWJca/tg9Kt+/P0SV+7A904ZhuSACHGYBbc1goIjVT0FES8HXAY4s5UEsKtlwIY8PEYvW7SuQDVezOWKLkU9Y8dw7vPSRQi3OYygaVD7u5iSn9DhH4feUPMUlXZg1+8fMiRrQVN5sFpAJfm+iqN9G1jnrT64Dpb+9mZ0ck39mIs245fFv/SAg1qL98USZI33jVJxsV88esyEkMLFFiNcds06aTO0y2JeST6mydjic7P3jReSH02MpT6qn2kDWZEBMVgJ1N9N5kZc+wrklZAfyQgUhcKFKXZvymCYYn1iCiMMPz+vK4+oMsGC6kVtp03uEniOq1jnOBHqMv9eJ+pDrbtFQKAxH2x8wrac7JHJrN4jbqcrlW4csLqbUxsLJc24Ce4anAmdCQnuMciUyWlFYt7GdRyvHwa+YXrtAXmitFBXNXh+sWGtQKnN7kAX6QXvldJYPCEjcGt1GrUZKquZgwZNcs9tIbzIv8Y1x+TEsNoZwgoGCYQ+Wz2XBCTZ4xSZdukHfZv7Rr9p8hl9G++hVTnKDL8uU3JTzWPcQ+iMKEc+eL6V2Oq37e1HjGwqfUSDPsArCFv6kv4od+qimazSLZHAPUP9JXdsXh9yuWm3qb7enmT9/sf4IUiWIYEhFXs0tczw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(8676002)(8936002)(1076003)(86362001)(956004)(54906003)(316002)(4326008)(83380400001)(186003)(33716001)(7416002)(9686003)(2906002)(5660300002)(66476007)(66556008)(38100700002)(38350700002)(66946007)(508600001)(55016002)(33656002)(26005)(44832011)(6496006)(6916009)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HoNhB3oP7tCRYhLV/Sazn5yQQ3dYQHm9reFjZuZWf/Zeng7PT6Z0JdkXU3Z0?=
 =?us-ascii?Q?TGKcBgMxwvByredk0j2s0auqJd46N3Zebne5toxp2I/7tLhR+QRNVdduiqZc?=
 =?us-ascii?Q?jmLqIDjhvbjQMs1f4kjiMfvUZsf2yyN1oe0srJxmrYcaoPbL10vh0rpY8OmY?=
 =?us-ascii?Q?YqtgyFxqrJ5ZNopfscpaD6st7npKdP/EXbVcQPjFOeIZds2iakVoDUQ3P3MV?=
 =?us-ascii?Q?Pwd/wE1K4WwFC69e0d+JnFyRDr3Nj6qzQIR68hrIeH7iDHyrK5NtWmNMva49?=
 =?us-ascii?Q?vBoIjOrQ6pAGmjBqn8YNTGlAh8BnV1b+/OxhwFATqoJ+HhGziCxHyRaWisMs?=
 =?us-ascii?Q?YPvDaO79oplEqjeWos3t1r+NQkASwtMEIH5WY9f9lwjFmEAA6ueklWMY8C9b?=
 =?us-ascii?Q?vtkmO37BADm6WWkiYDwts2uC/rXksGrxuIqsEMxgqb1OuwZ+A9csgHDIH6E8?=
 =?us-ascii?Q?Gmp3wvrZ6vI+LQZqppWHkaSBbqxiDWxletbRwhoRooFbeHS5+vjfNXB+09Ia?=
 =?us-ascii?Q?Zkw8ZlRpF97C37U/ruscQU0H7DYoFif7zPN7fZO88kGfzwQOUEcvvaDqRxTA?=
 =?us-ascii?Q?B2tL5RjzMhXkqd6m4FgRn7hk5Kt0dmh7bP06mAVaEJEKZFgtWqSLx4IGfjDb?=
 =?us-ascii?Q?faHDVQycZLUO59z2hemc3h7pXf8BFUy5j175D+jrA4Pbt085s5lAYtz3bxH8?=
 =?us-ascii?Q?MhaLg/fFuNNFiADyIn/AEWaNd1r68OGZr8DfzRrh7HGr3e7Iq38mScoYeePB?=
 =?us-ascii?Q?8DSwgcfUfyqd7hAYN1w8QRSQOkzvH7y6dyI6BEd1dLypWWQJKD9YKNk2OCzp?=
 =?us-ascii?Q?AQSu5rW5j8uB2NisTq1DR7YUGZubRXkKV/wBAtnDyvenK3SywmjSc8gL9gTI?=
 =?us-ascii?Q?hH5518ek8MEdXs56md4Th/Dxw+zk58PKj2ndY/z9/hRYHVnqDRxILtH3umHi?=
 =?us-ascii?Q?X7D3PvoIY1FkewAc8ylAQD2efe7I0/X46GxT+kvjSyIuWUL0kEwE/2Z4xNok?=
 =?us-ascii?Q?STLqv6f2M3uz31taL9GSyoz6CDnbXNv3k/Rj3MvhK/2ImhvMt0UGBZOqdghY?=
 =?us-ascii?Q?1uLaJfMvOBBtHnbbgHIuWbEfitVtzpJXAWHvVSDxK4DE5CGSyRvER8Mk9twT?=
 =?us-ascii?Q?biIU/AEzXF8bH+yTZSrLi5TDxK9U+jwNXEeH+ZDx/t8aaG4UOJBh/6mSTLL7?=
 =?us-ascii?Q?6odow2QN/rXBlvoKETCpgPsl1BLsMMpQrUa7aSTzMszPDO9+Ai7O4D8Ykm3u?=
 =?us-ascii?Q?rUkPyEubfRO/HqEGiH8QpP8Vsp7QZoJhJnDOk+U7Z7ITq3ZMKyRP6zdgU9eC?=
 =?us-ascii?Q?9etjVOfQYYNj8AKs3CbI/tep?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 913541e4-c039-4fae-752a-08d9820df6a8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 23:24:33.6925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKAIMOf9QcjXNSZAb8gwlXuz4AC3r4TUdmdrFjEZU+SauU4hPdaR584M93UEsO/p0XqNcZ39QV5SJ8rewSmGVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 06:00:51PM -0400, Tobin Feldman-Fitzthum wrote:
> On Mon, Aug 16, 2021 at 04:15:46PM +0200, Paolo Bonzini wrote:
> 
> > Hi,
> >
> > first of all, thanks for posting this work and starting the discussion.
> >
> > However, I am not sure if the in-guest migration helper vCPUs should use
> > the existing KVM support code.  For example, they probably can just
> > always work with host CPUID (copied directly from
> > KVM_GET_SUPPORTED_CPUID), and they do not need to interface with QEMU's
> > MMIO logic.  They would just sit on a "HLT" instruction and communicate
> > with the main migration loop using some kind of standardized ring buffer
> > protocol; the migration loop then executes KVM_RUN in order to start the
> > processing of pages, and expects a KVM_EXIT_HLT when the VM has nothing
> > to do or requires processing on the host.
> > The migration helper can then also use its own address space, for
> > example operating directly on ram_addr_t values with the helper running
> > at very high virtual addresses.  Migration code can use a
> > RAMBlockNotifier to invoke KVM_SET_USER_MEMORY_REGION on the mirror VM
> > (and never enable dirty memory logging on the mirror VM, too, which has
> > better performance).
> >
> > With this implementation, the number of mirror vCPUs does not even have
> > to be indicated on the command line.  The VM and its vCPUs can simply be
> > created when migration starts.  In the SEV-ES case, the guest can even
> > provide the VMSA that starts the migration helper.
> 

This also depends on the mirror VM and it's vCPUs being launched and
measured indepedently on the target side. If the MH VM is measured on the
source and then migrated to the target then it cannot be simply created
only when the migration starts, in that case it is launched, measured at
the source, migrated to the target and it remains suspended till the
migration code activates it.

Thanks,
Ashish

> It might make sense to tweak the mirror support code so that it is more
> closely tied to migration and the migration handler. On the other hand,
> the usage of a mirror VM might be more general than just migration. In
> some ways the mirror offers similar functionality to the VMPL in SNP,
> providing a way to run non-workload code inside the enclave. This
> potentially has uses beyond migration. If this is the case, do maybe we
> want to keep the mirror more general.
> 
> It's also worth noting that the SMP interface that Ashish is using to
> specify the mirror might come in handy if we ever want to have more than
> one vCPU in the mirror. For instance we might want to use multiple MH
> vCPUs to increase throughput.
> 
> -Tobin
> 
> > The disadvantage is that, as you point out, in the future some of the
> > infrastructure you introduce might be useful for VMPL0 operation on
> > SEV-SNP.  My proposal above might require some code duplication.
> > However, it might even be that VMPL0 operation works best with a model
> > more similar to my sketch of the migration helper; it's really too early
> > to say.
> >
> > Paolo
