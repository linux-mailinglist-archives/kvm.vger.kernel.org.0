Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324413EFF5B
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbhHRIjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:39:21 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:51863 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239399AbhHRIjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 04:39:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1629275910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kc51P4XEcqU0++0IhQwKDIQV7isn4FEOhxnak9DGNjs=;
        b=PyNkvOMY8rbBRdQkAADV4rlgdh8IffI28pOcCuss9A+GmsuMTyi81Dy2uZhJEICl6Bkdsi
        bvBAWoTys9whVnGBJSQGAusdl+eptpdt6nSwsRQJ35xKTJ0gwV2n4uxCn4ylHrxlXyo2gQ
        GC/5g6uRnT6hgelQOLl4ofjIqNTofl0=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2056.outbound.protection.outlook.com [104.47.0.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-h-ybBG7fOw2NbtBPQIKtMA-1; Wed, 18 Aug 2021 10:38:29 +0200
X-MC-Unique: h-ybBG7fOw2NbtBPQIKtMA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvbNF62EOTZLbO/QA/aBYfMvnnNNI2hjH5dcjw10aLvTRMvXrXq7oSEXCXFaJ4HLn1x2U9nVUyHlRJIV6pE3w2rUwZ1Ir2N6rM4LHwzkt+VWsVX4II5OYNpnLFtMso8khggL3mBD1oJevgwhrYhyBmoiHXJ4X5yjzDb46FiEIBzd9UqJDOPQ1LpktBB0Kpn+5yylRWTynbjv37EdgWtRqODvFL3yJHgVktjw+0BlnDnQpHAPuWNVUnQw+jxLy5mF0dm/toHXjFgOlh1DZPVeA9Ty90GERNqIxpmi3bY6Ckx6dbhVUtdAwEL4cqGTk6+vXnbC1JbPWF9PgRXMvRO5zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh4MX63R/yo4LpmqPBaKc+1Ly4DCddWJx5tiT7KnSQg=;
 b=IYyo5SbuOtck09MogFj77ex1X/aNut+wiHGvNH7UrCFSBRcfCVqPE1rWqKUFGreLxNIFCN4SXIZ9UMtjBDYiDGcjrJn799xG+RaQDaajjID8EKdOGAw0UfiYoqlkB6VxQJK56+0dEOO88iR9S+hrFsznTrrUfAV4DWPffSxNCCt5ZDd9GXT8B8y0VLMx+dkUPxkiXIcpYhzmggMjKObb148YwXoAEd7INOUCCHsaOOEwBmVZR8cEDumB/GhBrsmzzYN6LkvCGegAGP49i6eZhB4ycYlPG2/6KUa3n3wOFjrTeFBFf6B6W3xRfA9q5XLZEDccIRk1HjOA6SjvkGBw6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB4833.eurprd04.prod.outlook.com (2603:10a6:208:c2::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.24; Wed, 18 Aug
 2021 08:38:27 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::3d8a:3492:1e60:36af]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::3d8a:3492:1e60:36af%7]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 08:38:26 +0000
To:     Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>
CC:     kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
 <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <YRuURERGp8CQ1jAX@suse.de>
 <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
Message-ID: <71db10eb-997f-aac1-5d41-3bcbc34c114d@suse.com>
Date:   Wed, 18 Aug 2021 10:38:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR0P264CA0183.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::27) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.69] (95.90.166.153) by PR0P264CA0183.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 08:38:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7b0e84b-0d1b-4cc9-7310-08d962238c55
X-MS-TrafficTypeDiagnostic: AM0PR04MB4833:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4833979DB1014D9FBE228B3BE0FF9@AM0PR04MB4833.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Fbgdr+OKMLXG+qtLIsquV2kpY+6YpX5bymsd+1owh+Q8QrysPhQT6aopsXGhYYjTsE9CJlLaC7APlF6yQBbqimC14Ioah9+7L7COwyHzfZAmsHZL9Asdlj1B445p21yjvLhWOfaeq74TzXEahBq02eGOG9td2jvgSr/i0Emu014t+zpxl9EnchM4Q5ropNQ9DuG0Fj4JHyCLrAIFRHPAjw2DovUedRrtIT5gtvFUmc+Y32A26JW86LaanlIzembYdVPR7MWcV6S+U8Dw3gYWB5JXU06OG9Khmbx+oeyyk6D6H8KWQD6nD3Eyl80d5laxe9VyP0TFKUEAMK29ANRadzcZNEydV7Olgqzr/iG8p5sZr+aOeQlMW+gpZlGON7VY9R7W242F3TtZnVNJF1aJVre9gvVMSCZNnBxnl011+yOwkrblp00xISLAEPZz4G7MhTgXBo3DHIHt27F2OLJg/qdPrHfENnvVQUq91ayCSIIVTUwqYv1xILiI0OYiZHGBlQ8WNnP2ztLXJfRcuzeC8cOM2vfZcxc5z/BW6waJdtLqizs3IL49SztnNSaaBLN146ReSsk3dWssqqSNj9pA4m16Pd3lJCxKgI52PAN9n+WQyD0fbAJGSdszFeGBdRDDy7jLaYwOuyJ9/tIRQ+Hms3CD/UVpSaG+cVXdiH/kCsG+cYK23vgg+J6dPK/PGWjmVx2h+ojXgNl4QmJLsgwVa6Aytyqucl6R/AzODcsZ7zil0yuExlAhqQGe7ox5svBuvqh5KyzNJxGln4zxAOw3ukt98BTTWk5vV0c26oCJV/L/my+Opifph811sBeiJsNQkOS4qMM/46YbHLuQH+Tkf3w2DgPQvgrpTns/qFnR4s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(66556008)(966005)(508600001)(66476007)(53546011)(31686004)(36756003)(8936002)(2906002)(54906003)(26005)(5660300002)(316002)(110136005)(16576012)(31696002)(86362001)(6486002)(956004)(8676002)(4326008)(66574015)(7416002)(44832011)(38100700002)(186003)(83380400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PJCeMXbT6OKCE3XD7n2j1Bx6PEor682ofoQzZTG93dDs2QMOk//3mUL13ijV?=
 =?us-ascii?Q?WRAlIvFgRQmZ7X3nyA4F8qV98dXFYNjB2ilnzZiaIVySD02IV+iVX5eyBUXZ?=
 =?us-ascii?Q?WiEAbFoDccNgX9ULtuO+3A9lq0c6Urxfx0phE7Nl9NhyO0YxdgX1hDevrJQl?=
 =?us-ascii?Q?ykWHcCQjbAzvM2cfu8KVC9tMb7GhFWwTU637IYfvt9SinQqDLAHo0tDraRzW?=
 =?us-ascii?Q?0YG2KK3rwxdjklKuiI/+9xEP3TYc76uWiVyQKVR2WiJk6XHCNwdbvNWu1pgi?=
 =?us-ascii?Q?G/U7Gx5vKCLx18cYoYWgxSFFdhWd3cxMKghCA0Knl8eSKuFrrJbMYu6bi5fP?=
 =?us-ascii?Q?5eNyn0E4KBHgHK39Oy5GHLsWcoNbFl4uGwQDkWYRb+ykR2w7k9xXho+3ZtcR?=
 =?us-ascii?Q?9ULG80J+MFSbVt1XrIWgmGAWrLLcONJTI3OluwSPdGHqN+nQ/plCZq4SHnYU?=
 =?us-ascii?Q?3XWLusvEmMtmVQyrZftgE+hMgjNsgZOASj514hnmJAxkS28TxN4EVjU1BLsr?=
 =?us-ascii?Q?7cuL8fL1Wu/yoq4BrkA0hQh31MSSB54lxVLEOMP76rw90FdZL8KxUTY15t4H?=
 =?us-ascii?Q?K7wx0pt/Q1S5AhaHM83+UPPy6sNFkZmeAD3ouXZFNp565MQH/QaJ7jVrz7md?=
 =?us-ascii?Q?h2USier4SHBUe5NHmv3N08qtcc32/qi8C0Suz2c3uHnPIa9dwrugDBcOUL/e?=
 =?us-ascii?Q?A5irGXdrHhBb111WdbD0GJR8fCO5ubOYQLaYgN5CtQjkoJzoVmkLIFaBXlyG?=
 =?us-ascii?Q?EiM68atAxfrYA2TL86xqnSuoyufvs1vwf7WczLjzCuPYISmcYu3Dn37Rsuec?=
 =?us-ascii?Q?6dgzsBPsSowczX0tuLOPi8Su23KdM0KRlA9NOduD3HKtl87IFbUolliJERU7?=
 =?us-ascii?Q?2h732VDu7NuIWVWH4oBxrgtEMHwFfCoKq8kRBwzWfZsam5nnepB911LH/6Hn?=
 =?us-ascii?Q?fp3AcbIpz6UaTUt+el4nZtN1oC8kdNWqGX8u98DKy+nWUwYnZGATOLD9NLo5?=
 =?us-ascii?Q?/+65bPE1EHndS8Ag7slUi+YZa3GYinxGmHBhqgQXmJRfWHCaIJfxer6h5ihI?=
 =?us-ascii?Q?51dfoxkedM9hDBIAMEc1XbAkwJz7TCAsVJ35xDW6vGfgKLaAyceWagqVosqC?=
 =?us-ascii?Q?XnbNu0pPTShBHexlvfiUR6lPZLYdxdKogqyBW1m4EyQuyB3Ug4IHXXH4oUz+?=
 =?us-ascii?Q?E52cf95Hzvp7jCOKvHG17PizFnWgZhsDRCFvs5z2kFYLe7tJQNVYWwdwOUa8?=
 =?us-ascii?Q?gUcmZcTKGabP04OJ1ZDWtldcKls5xwyw2Y2rvidj0/o/YPG2L96ZAjd6RLeT?=
 =?us-ascii?Q?zkv0v1rfvtSZMeTQPtVnUc62?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b0e84b-0d1b-4cc9-7310-08d962238c55
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 08:38:26.8732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQ0r/iEVbp+cHj91cpMs5u7m+lkDWMmyoYsQCdpAYfgq0yffVhS3LArLYq3/9DoqWeM92s72GlbTrK4HP4NAvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4833
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc, Zixuan,

On 8/18/21 3:52 AM, Marc Orr wrote:
> On Tue, Aug 17, 2021 at 3:49 AM Joerg Roedel <jroedel@suse.de> wrote:
>>
>> Hi Marc,
>>
>> On Fri, Aug 13, 2021 at 11:44:39AM -0700, Marc Orr wrote:
>>> To date, we have _most_ x86 test cases (39/44) working under UEFI and
>>> we've also got some of the test cases to boot under SEV-ES, using the
>>> UEFI #VC handler.
>>
>> While the EFI APP approach simplifies the implementation a lot, I don't
>> think it is the best path to SEV and TDX testing for a couple of
>> reasons:
>>
>>         1) It leaves the details of #VC/#VE handling and the SEV-ES
>>            specific communication channels (GHCB) under control of the
>>            firmware. So we can't reliably test those interfaces from an
>>            EFI APP.
>>
>>         2) Same for the memory validation/acceptance interface needed
>>            for SEV-SNP and TDX. Using an EFI APP leaves those under
>>            firmware control and we are not able to reliably test them.
>>
>>         3) The IDT also stays under control of the firmware in an EFI
>>            APP, otherwise the firmware couldn't provide a #VC handler.
>>            This makes it unreliable to test anything IDT or IRQ related.
>>
>>         4) Relying on the firmware #VC hanlder limits the tests to its
>>            abilities. Implementing a separate #VC handler routine for
>>            kvm-unit-tests is more work, but it makes test development
>>            much more flexible.
>>
>> So it comes down to the fact that and EFI APP leaves control over
>> SEV/TDX specific hypervisor interfaces in the firmware, making it hard
>> and unreliable to test these interfaces from kvm-unit-tests. The stub
>> approach on the other side gives the tests full control over the VM,
>> allowing to test all aspects of the guest-host interface.
>=20
> I think we might be using terminology differently. (Maybe I mis-used
> the term =E2=80=9CEFI app=E2=80=9D?) With our approach, it is true that a=
ll
> pre-existing x86_64 test cases work out of the box with the UEFI #VC
> handler. However, because kvm-unit-tests calls `ExitBootServices` to
> take full control of the system it executes as a =E2=80=9CUEFI-stubbed
> kernel=E2=80=9D. Thus, it should be trivial for test cases to update the =
IDT
> to set up a custom #VC handler for the duration of a test. (Some of
> the x86_64 test cases already do something similar where they install
> a temporary exception handler and then restore the =E2=80=9Cdefault=E2=80=
=9D
> kvm-unit-tests exception handler.)
>=20
> In general, our approach is to set up the test cases to run with the
> kvm-unit-tests configuration (e.g., IDT, GDT). The one exception is
> the #VC handler. However, all of this state can be overridden within a
> test as needed.
>=20
> Zixuan just posted the patches. So hopefully they make things more clear.
>=20

Nomenclature aside, I believe Zixuan's patchset [1] takes the same approach
as I posted here. In the end, we need to:
- build the testcases as ELF shared objs and link them to look like a PE
- switch away from UEFI GDT/IDT/pagetable states on early boot to what
  kvm-unit-tests needs
- modify the testcases that contain non-PIC asm stubs to allow building
  them as shared objs

I went with avoiding to bring in gnu-efi objects into kvm-unit-tests
for EFI helpers, and disabling the non-PIC testcases for the RFC's sake.

I'll try out "x86 UEFI: Convert x86 test cases to PIC" [2] from Zixuan's
patchset with my series and see what breaks. I think we can combine
the two patchsets.

[1] https://lore.kernel.org/r/20210818000905.1111226-1-zixuanwang@google.co=
m/
[2] https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@google.c=
om/

Thanks,
Varad

> Thanks,
> Marc
>=20

--=20
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer

