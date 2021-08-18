Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220103F09E7
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhHRRIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 13:08:02 -0400
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:36961
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229784AbhHRRIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 13:08:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxVQ10/Hc59gWB7mBew0zze1l1OnxXtb0N0u/b3RbMysrFQBXDEue8xUIlagTZOwVnjC2nNQKNfhKJhU3BS2N8JPmkreC/7OEloh/KYGoR/XNkU5bEjT179rgLiUNhjP2W6LmJoXE7VNAuWi2tKJRf3RT6LHjfUHrcVvYBbHMmqKmOGh2XU52fRa7ARmLWi8pVegfEMYaWzh2Qs1YtGsXOCUoJ0xm+ITN9LWu54hV2CYlOWKxNYFDhEW7A9LgevoXW05PKHTE6yAFdXPQbRuMPHzY7FvxHNkKruSHn1oBWjdq0vB6FFFdD1DON1qQPvTF1LH8BLn0RuLuMQkke0iqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61r9TJ3XTxeaXxSUATCpmunRaz4+YF0zA3527HSj/Vc=;
 b=UCGftC3U3NdB5KunMYp+NOlyFWE7d0NDcR6j1j3dIuq5RgQx+u+f0uUHkizb5RgLta93Uei4VizR1O4OyUMv7j6BTK6MBJ6YRcoU/KBd8zASqvUdYehT6YkfzV1jCsgGY82vCdX/4+62Xu66P7WZQ+BTMHiLpkEj1EkiT8xFNqR7LuK/3uo8kPiVjawSJ2ZXSRj+TEXmKvHg7rEMhN0Rl0dgq/jSOVd6JNZo/pVcQ7U7sHEnplG3YzFho3KfF+mYKf8LgPPvCZNcB4mteUGJ4zhlB3ipxRu9ivUxO45jkptk8SJqoc91XQIumSy7P7QsREVen5/p3WAPJ/FK2s9ulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61r9TJ3XTxeaXxSUATCpmunRaz4+YF0zA3527HSj/Vc=;
 b=k58PO/MM8WFJQh97L3KA843VCgq1Rsf7mOwLA8VLwKroJZLXB8JHiZpomrU6b7FoCL5C/5griSQcoaRi/GWDyLS4080WGK2f+4gmWnUpwMSbuEbpuw/HJlLP7EYbbWWJG56tWuaJAl4kBN4AoLcapIHPHfjhsKrrwbHe/fP1H7E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2768.namprd12.prod.outlook.com (2603:10b6:805:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 18 Aug
 2021 17:07:23 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 17:07:23 +0000
Date:   Wed, 18 Aug 2021 17:07:17 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Thomas Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Habkost, Eduardo" <ehabkost@redhat.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        David Gilbert <dgilbert@redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <20210818170717.GA32572@ashkalra_ubuntu_server>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <CABayD+d4dHBMbshx_gMUxaHkJZENYYRMrzatDtS-a1awGQKv2A@mail.gmail.com>
 <CABgObfZbyTxSO9ScE0RMK2vgyOam_REo+SgLA+-1XyP=8Vx+uQ@mail.gmail.com>
 <20210818140625.GA32492@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818140625.GA32492@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN1PR12CA0102.namprd12.prod.outlook.com
 (2603:10b6:802:21::37) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN1PR12CA0102.namprd12.prod.outlook.com (2603:10b6:802:21::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 17:07:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd09e118-a4bd-4031-16c4-08d9626aa5b4
X-MS-TrafficTypeDiagnostic: SN6PR12MB2768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27689B84E1ADE054B49E7EE28EFF9@SN6PR12MB2768.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jhnmg/LeClsYWCynUKWK8H624QtQ1ry3IyXK1nIO9KIgO0XpYI/RSS4GZSPtRoO1yx5MjCCOj97mvt41CvfEUPCXJnLNj9gqY97mKBZ3laCPhzUo9fsFBXiOEQhOY0zSin0aFgve7neca8vSnbmEiAqpfXHRvVwf1Sd6wjpMKHaePiPyE0APlS2t6vdldoRo6Frk27gH0sIfk03QP+lepeYCQkeqRbIq1Y6f/2pC3z95FLe1OCj96WXZ9hVHfvhNQr6MmA+9AhegUt6ASUo4SX7pSRRg+fjmP6O3x9IPT9rDX8/lR/x6Uc0iYUBUipdRoFl3A03JfKonCTrqeP+wR4e609jaK7+AZ7usIu0vmms61y9/aM+25QVJJdtIJtytouv5pSGDgeC7bLz968ImnjhkFmnf3lmETFex5prjD7OP+mRkLTz9OCIJj6EOzOA8BtTpGcvQ7a8UittHbNMb4aZUWtm+F29gIVikxJL9av3FAunoElbjxj3sUZeDAHkWREVDMQasld4FhyPCHT5SVHEA0pvI0gJov23yUJHoIjHKVoYPRRFXEDqFOJ5N6GsZw+Q2hoJMdP1dXSI4Lue7ol6ElcSNHOsIDK+GxwiopdD1kJ3YJBQfq+CXOw/GaySz5Y9YRxUG9cWGqs8f2QRb0RTlpcB044jL8BxFqLNEnSmKZNaWVhg4h7YYNT/god9/vydGw4zTUpaYNNk3tg/rgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(33716001)(52116002)(1076003)(8676002)(8936002)(86362001)(956004)(54906003)(26005)(186003)(53546011)(4326008)(66476007)(2906002)(66556008)(6916009)(316002)(33656002)(55016002)(6496006)(44832011)(5660300002)(478600001)(38350700002)(9686003)(38100700002)(66946007)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R/TvzVomzHXcjryniqNNcDWAM5bg6TeSVBVTVFNtJP8biJcQKQKLnDOni+R+?=
 =?us-ascii?Q?XFVBSwYRHqde6gQFVAkmhau96t3V+QnmAQMRibSTHa4BoX51/hU/+dfR05ra?=
 =?us-ascii?Q?mqCcefVfmQDPfK4ljInnf+UI5gUasP0nrYS/l0gJx1ywxUvS9r0m/85PQf5z?=
 =?us-ascii?Q?hBXUymwJ3hHulZlmNYpDXOJLEK9eBzWpm/8pVALlZVkgu7SGKe9K081TbR8X?=
 =?us-ascii?Q?IsP9RfTn/a5fDBiO9QGr4+TzLzvebF7fwHB9wM3JWi65CglYDrVhjXH1q6ks?=
 =?us-ascii?Q?wFRL7xPjQT8DsIXPdagPPLMPmI1LFJWTnuwjSTkJbg9tfL4NKf+b8eVZybzS?=
 =?us-ascii?Q?gnLAX9pIqBlMap75V3OR3Z6h0GAcBUBKX9K8eCJ03oHoG3mSsCfCZ1tKtWu3?=
 =?us-ascii?Q?RzOLGtx66i4zyHse0rS82cFnULG9L3TX6//HxEDm3B2KIQ7w7UC2CZ5NSzF0?=
 =?us-ascii?Q?dJM4oAH4k1CrJ3uruqbz2fPfbmPR+6I/rjxdAI8/CsiqKUpHVS4+E+DHVitc?=
 =?us-ascii?Q?v7QYt2YmFRk1qylyYbXsGRb0jkK7kxWNU4JDjti66SeJp85LJy9/fobBVEcd?=
 =?us-ascii?Q?bfXAXQ2fd7OyntYvzn02NXkmOxTdgquKcsQBtXanvGkG49MYaFyIZqUo7Kju?=
 =?us-ascii?Q?5tqgbunWQteTTJjNtb/+VzwT3B48pgdpLCSvW/+F1040tDX5qjNGUlyy3kWl?=
 =?us-ascii?Q?zH5uj2qP+DwwaRpgXhc4X43o0tZsTpuA/lMYUDeXoTLUFtGUfPtWti35omPL?=
 =?us-ascii?Q?akz+gE0kDyuCZGtnpEFNSYfbQ9ZD3+vezggyPj64SS/uK24kOy0Ney3y3vB3?=
 =?us-ascii?Q?zLni9E9f73pmTj+USGOhdG3Fkrtsx/QJgINTtkNekuPRMUZHhJHFvA9A3nZj?=
 =?us-ascii?Q?45akfB8aAneqZjuVrvuqFwEh6gsSrfzZ4NqaRWWil1LNoexFoVrDGdTA+2bx?=
 =?us-ascii?Q?bXO7y5kHJsXJHj4SEw9tKgUL+mx2b2UUSnxwIVtaMficrLJFcVhN/wKsD0Q9?=
 =?us-ascii?Q?y7GpgwkpGSAn+sPE2UTN1XEoGz+YD2qlCIdgrNSJJ5TNPLP19qYmNmuBAoS5?=
 =?us-ascii?Q?CEE4fsiua7EYIXHGGOl/fGzbCi6w5dHXIXxm8c7m/DKsvhIWv0+zzERdCcPt?=
 =?us-ascii?Q?gaYmRMpyGLFPJpPINqgck2ojz95jgWf/QCiaMEIx7w+vRdPZyQ6upkMalA8y?=
 =?us-ascii?Q?ygyC1yvy8fXPZM3DQA7ZjruhhDTH8qf82qdyLXlFMZ0B2OX37sO+OVJlVaWz?=
 =?us-ascii?Q?ra9/xn45lQKI+hOF/FvRxLfrPspFb10jy5a3g45vwBpS26YS9Oej0nWDfBPa?=
 =?us-ascii?Q?9ezFY/T3KqsVQhZfh5CCSdvt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd09e118-a4bd-4031-16c4-08d9626aa5b4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 17:07:23.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJpBHGyckCe5Bw0rBgFDvjlOYQr6CpOteU61r7oQN3lofxKG7DQ4p8ljKXX5oIEfcSH5ACM/EuEhhcWFz3LinA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2768
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 02:06:25PM +0000, Ashish Kalra wrote:
> On Wed, Aug 18, 2021 at 12:37:32AM +0200, Paolo Bonzini wrote:
> > On Tue, Aug 17, 2021 at 11:54 PM Steve Rutherford
> > <srutherford@google.com> wrote:
> > > > 1) the easy one: the bottom 4G of guest memory are mapped in the mirror
> > > > VM 1:1.  The ram_addr_t-based addresses are shifted by either 4G or a
> > > > huge value such as 2^42 (MAXPHYADDR - physical address reduction - 1).
> > > > This even lets the migration helper reuse the OVMF runtime services
> > > > memory map (but be careful about thread safety...).
> > >
> > > If I understand what you are proposing, this would only work for
> > > SEV/SEV-ES, since the RMP prevents these remapping games. This makes
> > > me less enthusiastic about this (but I suspect that's why you call
> > > this less future proof).
> > 
> > I called it less future proof because it allows the migration helper
> > to rely more on OVMF details, but those may not apply in the future.
> > 
> > However you're right about SNP; the same page cannot be mapped twice
> > at different GPAs by a single ASID (which includes the VM and the
> > migration helper). :( That does throw a wrench in the idea of mapping
> > pages by ram_addr_t(*), and this applies to both schemes.
> > 
> > Migrating RAM in PCI BARs is a mess anyway for SNP, because PCI BARs
> > can be moved and every time they do the migration helper needs to wait
> > for validation to happen. :(
> > 
> > Paolo
> > 
> > (*) ram_addr_t is not a GPA; it is constant throughout the life of the
> > guest and independent of e.g. PCI BARs. Internally, when QEMU
> > retrieves the dirty page bitmap from KVM it stores the bits indexed by
> > ram_addr_t (shifted right by PAGE_SHIFT).
> 
> With reference to SNP here, the mirror VM model seems to have a nice
> fit with SNP:
> 
> SNP will support the separate address spaces for main VM and mirror VMs
> implicitly, with the MH/MA running in VMPL0. 
> 

Need to correct this statement, there is no separate address space as
such, there is basically page level permission/protection between VMPL
levels. 

> Additionally, vTOM can be used to separate mirror VM and main VM memory,
> with private mirror VM memory below vTOM and all the shared stuff with
> main VM setup above vTOM. 
> 

I need to take back the above statement, memory above vTOM is basically
decrypted memory. 

Thanks,
Ashish

> The design here should probably base itself on this model to probably
> allow an easy future port to SNP and also make it more futurer-proof.

> > > > 2) the more future-proof one.  Here, the migration helper tells QEMU
> > > > which area to copy from the guest to the mirror VM, as a (main GPA,
> > > > length, mirror GPA) tuple.  This could happen for example the first time
> > > > the guest writes 1 to MSR_KVM_MIGRATION_CONTROL.  When migration starts,
> > > > QEMU uses this information to issue KVM_SET_USER_MEMORY_REGION
> > > > accordingly.  The page tables are built for this (usually very high)
> > > > mirror GPA and the migration helper operates in a completely separate
> > > > address space.  However, the backing memory would still be shared
> > > > between the main and mirror VMs.  I am saying this is more future proof
> > > > because we have more flexibility in setting up the physical address
> > > > space of the mirror VM.
> > >
> > > My intuition for this leans more on the host, but matches some of the
> > > bits you've mentioned in (2)/(3). My intuition would be to put the
> > > migration helper incredibly high in gPA space, so that it does not
> > > collide with the rest of the guest (and can then stay in the same
> > > place for a fairly long period of time without needing to poke a hole
> > > in the guest). Then you can leave the ram_addr_t-based addresses
> > > mapped normally (without the offsetting). All this together allows the
> > > migration helper to be orthogonal to the normal guest and normal
> > > firmware.
> > >
> > > In this case, since the migration helper has a somewhat stable base
> > > address, you can have a prebaked entry point and page tables
> > > (determined at build time). The shared communication pages can come
> > > from neighboring high-memory. The migration helper can support a
> > > straightforward halt loop (or PIO loop, or whatever) where it reads
> > > from a predefined page to find what work needs to be done (perhaps
> > > with that page depending on which CPU it is, so you can support
> > > multithreading of the migration helper). Additionally, having it high
> > > in memory makes it quite easy to assess who owns which addresses: high
> > > mem is under the purview of the migration helper and does not need to
> > > be dirty tracked. Only "low" memory can and needs to be encrypted for
> > > transport to the target side.
> > >
> > > --Steve
> > > >
> > > > Paolo
> > > >
> > >
> > 
