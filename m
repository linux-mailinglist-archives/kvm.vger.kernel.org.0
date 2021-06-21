Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB21C3AED27
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 18:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFUQMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 12:12:21 -0400
Received: from mail-cy1gcc01bn2039.outbound.protection.outlook.com ([52.100.19.39]:37603
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S229719AbhFUQMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 12:12:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHQcw5K1aCH28n+AshwQr2u511bSzGBS81GYdYYJBqrpR2u0o3vtaGSv8DHHQlpsN+I/si1S5oAe4c5PKiOFcp/88UBOKJrLWzwkNayKQLwvfz8ohLA/F8KyShMAwTAl32+bYGZV+fbgBTtpw6b6zmcJOEKHcUWqVwer9OJ1yTS8+UB4d6y39VBI/pQwp80zPFZTCUA5Yrwq3Pe0uYX0dRZjl3FcETdN/Mr1DQywq0oAthO1o26sEJSX2XGdKdFKTUVPoLmiRL9cmD6ECFuxjEz2Inyys1q30RE+ZeeADc5sDbEnvL3g5TneXXZBM7JcS4VdXRnjc6To9+CqrUoRlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNpWFz5sQicS8V9SsEjZX13lx6OergKgXLqHEW7Sado=;
 b=lwVeXGQYNN5PeM4nhxUNLr8KIypOdhrBWOrh6Vmi7iW9i3GNmmzY5p4bE+bMRKiCCJ4kaDsAWRI8Y3rdKgry4YXSV9nUdlb9c3mFvdV5XifoaFara4O8UWvnc5ZixpXBKONl2Cvmku6BXRgHB4T3oz+dF0MrjCdMdTgelyejEpzkqUkeBh6vIWYyfnqMnKX55Eei0OeAEu0k6HIx3OQH5InK4aaQxMho5mR6aSx29zYmAUWg7OE9YaxmsGy+UfkZn8i88qRjuaRo1GCZDe1oHVbtqXnxQQPG5ioyOjNO/GbpwHG7Fz6di4dYnKnXL0IPmpjccEO1NBXG/8CXzDl7Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNpWFz5sQicS8V9SsEjZX13lx6OergKgXLqHEW7Sado=;
 b=bU20OHzZRHzabwYksHkLu4dJcZ/FJOCG61yZhvmcXzYhE0EEl9eE+pR2TJFXFnSiCyLweA1YFQlHp0VKNigIKHdLFWgSLBMev+k3G0Z3+Gss+L7guZaMDQsqmG5dU4poQGENOG1vkmtQmq21fZ7IXusp0NMF4MVShLkCTM6oO8g=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6673.eurprd08.prod.outlook.com (2603:10a6:20b:307::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Mon, 21 Jun
 2021 16:09:58 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6%6]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 16:09:58 +0000
Date:   Mon, 21 Jun 2021 19:09:51 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Denis Lunev <den@openvz.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210621160951.GA686102@dhcp-172-16-24-191.sw.ru>
References: <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
 <877dis1sue.fsf@dusky.pond.sub.org>
 <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
 <e69ea2b4-21cc-8203-ad2d-10a0f4ffe34a@suse.de>
 <20210617165111.eu3x2pvinpoedsqj@habkost.net>
 <87sg1fwwgg.fsf@dusky.pond.sub.org>
 <20210618204006.k6krwuz2lpxvb6uh@habkost.net>
 <6f644bbb-52ff-4d79-36bb-208c6b6c4eef@suse.de>
 <20210621142329.atlhrovqkblbjwgh@habkost.net>
 <874kdrkyhs.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kdrkyhs.fsf@dusky.pond.sub.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: PR0P264CA0280.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::28) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by PR0P264CA0280.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Mon, 21 Jun 2021 16:09:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25b3b5c1-2ad3-4614-e252-08d934cf0412
X-MS-TrafficTypeDiagnostic: AM9PR08MB6673:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB66738367742F967A9EE5C7F2870A9@AM9PR08MB6673.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(366004)(53546011)(66476007)(66556008)(66946007)(2906002)(4326008)(6506007)(26005)(956004)(186003)(16526019)(1076003)(6666004)(6916009)(44832011)(38100700002)(38350700002)(83380400001)(86362001)(33656002)(966005)(55016002)(36756003)(8936002)(5660300002)(52116002)(7416002)(7696005)(8676002)(498600001)(54906003)(9686003)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dA6IgUIuWGkIyPxJ4BUXTxSMRPzGg9WrwiEXGWSGSGMxn0+0Xilu/pf9A/Lw?=
 =?us-ascii?Q?js5AHHCOUF3Vkf3jDaxMG7VH+fwurUS/76llM9ozNaqR41dC72bUgmMP9EQi?=
 =?us-ascii?Q?a9q+TcdWP7Ip/9BSRtvuuE2ql/gjksXZ5HO5EBZ6l9PQ8h6clSC5CFSIc4CP?=
 =?us-ascii?Q?O4cn1mpaqOY8g0Qqw5ZVLNAZ9Jfa748XvBI/SyGsqU41uwAZM4wmnDgbqYt3?=
 =?us-ascii?Q?CGsrZj/t2njtynJzJOnOGilrdFCkEDAt6SIH/zCYmmK02aqiPV8uqYWvTkSQ?=
 =?us-ascii?Q?en2egqoJDFI07NpbT29eKhQ/nNDeD+C9LEimPWo+mjVQsaE47/QqUR8k1hvR?=
 =?us-ascii?Q?Ri6ckh3JJrer+0J0Xy7dXYugILfB5aREehrqFuk54vwbOczT1dP90xK4LauL?=
 =?us-ascii?Q?82ndWxB0zKnm5GszN0N+X4lfRyIorgmKxyfJY2UWvxEU9eX+Uz02qcG4t/8t?=
 =?us-ascii?Q?9PdW8+t5K0uMvXidybWKC1v5PUNSC3WMBJOLVYnlfrl9dZrTVUQNMma9gKqy?=
 =?us-ascii?Q?uZPTrEuqW7a0aglD1Tf1x9wGASI3HFekwtWjDMhNhoJhDQUnSd94uw3aGM+h?=
 =?us-ascii?Q?AoDgZD4/4y6Uej7YyX5ypAm6ljtHtMpfq/2pDLPY0IDl0tZHGJ3HUwdtSOrR?=
 =?us-ascii?Q?3N5rFhWGD5UP5CRfqg87tJplKidzpQX1sjPLCrE6QgoRKCKa1BDr/Jf8tHEG?=
 =?us-ascii?Q?kr7UV8SHcGu9nyCEPLLzA0U3A/qAuQ7NVKuiXof9zgYYPyPc+f0Xa3zOZVeE?=
 =?us-ascii?Q?0OgcHtD/0W2u1oPv51Wh1iFgfemu6sanARx9568h2RUm8Ti3TWnS4qXN90tZ?=
 =?us-ascii?Q?tfk8CkBibysTo3fI8qbcK6gPYRTK9QsKxhXeFcPhbg0ZxA3JqdyRm4oGouc2?=
 =?us-ascii?Q?e9nzI3hfi02KnUlp6ojRPe7nJ/IU9OZ7o2Zjr890NP9S+Z5ygesQbjItp4Eg?=
 =?us-ascii?Q?XP4phwev7Kxx2r3vkpI1zpN4twC3/K4m7AJ72jv6BuB0pdTeH0+vdKzUocxJ?=
 =?us-ascii?Q?foyh/QNh03cNsS9DRXN/KMWuXhBvwgS1NMvo8sLZ4NTfunGMKsDaFHWwDIHX?=
 =?us-ascii?Q?yuR2D9+13w9m7SzHLWC9JKmSr53pnlEuLkAZa+c9gVuqoFSfG1U=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0BE8F3h5C262phxvfy3bNTezcihfXdFTuwdcQL6IQf3VpFCgsn5CsvSVYrqs?=
 =?us-ascii?Q?4TAJlr/QZGcX5bNsvAgPIVX84a2btKA3deGxKODCignRgC2hlueP1CUk5aU2?=
 =?us-ascii?Q?nxFsJYyV1Kz5FJy7HsabM7RrardjzZzLggIEA4iwvpHVJoaRdCzJiRvcgNev?=
 =?us-ascii?Q?Q2F9vUTfHmpIuYyqX/gi+/VQ+rDV4n//QhXTuKmIAVo3AJtgIachtocGNNAS?=
 =?us-ascii?Q?Q6gpG4MA9bTRQ5WyJtxLPtwI09oOi4DCMY7gfwa7EQOOn6R3h23eTz9bjpSH?=
 =?us-ascii?Q?H4MLkFSvTc1tQKOlsymDis+XZZq+TZsT5WFQKRKXgr0XnOA3jml4hXpqR2YN?=
 =?us-ascii?Q?FBHViFsAeXnoiKfpNmsw2P7apIrah7BVf1SGczfJwURCNlLApSxTzoJdfliN?=
 =?us-ascii?Q?xhn4jdMNReq1ebbMiIdQVst85opsoPfu71A3dcQPI2WmMjllSFK5aZ1TyMbM?=
 =?us-ascii?Q?lo21V4ZW2RnMZ0MC7F2ENsw+ZTZPKRiN0fnw3pnZfRRpJjfFwEY8qNj9hHuQ?=
 =?us-ascii?Q?3J5rIxadAd5D1cFg3VoYKvLFwwxp0suHilytOW9VwAMzc9a0roojBM/UZwpO?=
 =?us-ascii?Q?uUVX/p+agcYadHqaV5XGGXgISXfSIkBTLU1npb8yYlcitIiagJtuujQd7nlh?=
 =?us-ascii?Q?+pTr501sVZ49NbDEcsCwVAYsbW9MuX9sprqvc/KmECWSDH5f73W708GLo4po?=
 =?us-ascii?Q?zFTlM0wdJtdKFopRLZCUqoDNVWfKiC1Xi/SCRvuTYHxF4g4fKaHaXTIzEBu/?=
 =?us-ascii?Q?0+3RH8o4LBt7gnwtxNG9kC5qUGN4fuNus6xlM9R6FWRaWsJ/lo5eJe1EF3yV?=
 =?us-ascii?Q?5pVo3eQ56eXbq9m+Mmh25yWVuNDkQDlUyQYui1pYnpPTd6GiUFaB9FuLzFCV?=
 =?us-ascii?Q?p9wsdgrh/RzNE9mvUbT4SVTr0LEmRDeeiStSL1o9/lEcxjsVCICWzXyODnro?=
 =?us-ascii?Q?wV1taoOHRl3EdaRpIaf0rTntIcgOLgF27b0xBPa+YRVdzH+UzDDWO9fwAElh?=
 =?us-ascii?Q?xlqJDa9hOXMREUmLN9k2gBa2RQtpHqq2R/1LE0Y4p7w7+06e+YReFvJ+Jfu3?=
 =?us-ascii?Q?jRmgNfclMZ5ch2oQY8PPqC86F2BBxnZh14I9zqsblZIRboE+Yv0EEiF3d+23?=
 =?us-ascii?Q?7K4fgPtpcsmt4IG8CL0fqg1nvfd6CeT2Tg36UybMZnYvxw2R47ivjrxtwBRc?=
 =?us-ascii?Q?ZvUy4KbEhwivYBiQl8g7Vyoyzaa4Zn/7tXSeAlDrvF8E91iEthO69QYq4rhD?=
 =?us-ascii?Q?YF8cUeViBcR0TvM/7xN8cr5lPFOOEmLzxCy568GII23Bd+9Ru4oYgRF39/ak?=
 =?us-ascii?Q?zwFJnqn1GOZ6TmqstgqPrnMg?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b3b5c1-2ad3-4614-e252-08d934cf0412
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 16:09:58.2838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7IEw1pw4qfQmKIIIshI9FjNUXkO0SDHBLOehwsXNa0kRALO4YQt/YbflTGQmS8dZVQCMTEaNID5IufWZuteKKxSPOPmrSl30Bjg5ZjVZamQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6673
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021 at 05:50:55PM +0200, Markus Armbruster wrote:
> Eduardo Habkost <ehabkost@redhat.com> writes:
> 
> > On Mon, Jun 21, 2021 at 10:07:44AM +0200, Claudio Fontana wrote:
> >> On 6/18/21 10:40 PM, Eduardo Habkost wrote:
> >> > On Fri, Jun 18, 2021 at 07:52:47AM +0200, Markus Armbruster wrote:
> >> >> Eduardo Habkost <ehabkost@redhat.com> writes:
> >> >>
> >> >>> On Thu, Jun 17, 2021 at 05:53:11PM +0200, Claudio Fontana wrote:
> >> >>>> On 6/17/21 5:39 PM, Valeriy Vdovin wrote:
> >> >>>>> On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
> >> >>>>>> Claudio Fontana <cfontana@suse.de> writes:
> >> >>>>>>
> >> >>>>>>> On 6/17/21 1:09 PM, Markus Armbruster wrote:
> >> >>
> >> >> [...]
> >> >>
> >> >>>>>>>> If it just isn't implemented for anything but KVM, then putting "kvm"
> >> >>>>>>>> into the command name is a bad idea.  Also, the commit message should
> >> >>>>>>>> briefly note the restriction to KVM.
> >> >>>>>>
> >> >>>>>> Perhaps this one is closer to reality.
> >> >>>>>>
> >> >>>>> I agree.
> >> >>>>> What command name do you suggest?
> >> >>>>
> >> >>>> query-exposed-cpuid?
> >> >>>
> >> >>> Pasting the reply I sent at [1]:
> >> >>>
> >> >>>   I don't really mind how the command is called, but I would prefer
> >> >>>   to add a more complex abstraction only if maintainers of other
> >> >>>   accelerators are interested and volunteer to provide similar
> >> >>>   functionality.  I don't want to introduce complexity for use
> >> >>>   cases that may not even exist.
> >> >>>
> >> >>> I'm expecting this to be just a debugging mechanism, not a stable
> >> >>> API to be maintained and supported for decades.  (Maybe a "x-"
> >> >>> prefix should be added to indicate that?)
> >> >>>
> >> >>> [1] https://lore.kernel.org/qemu-devel/20210602204604.crsxvqixkkll4ef4@habkost.net
> >> >>
> >> >> x-query-x86_64-cpuid?
> >> >>
> >> > 
> >> > Unless somebody wants to spend time designing a generic
> >> > abstraction around this (and justify the extra complexity), this
> >> > is a KVM-specific command.  Is there a reason to avoid "kvm" in
> >> > the command name?
> >> > 
> >> 
> >> If the point of all of this is "please get me the cpuid, as seen by the guest", then I fail to see how this should be kvm-only.
> >> We can still return "not implemented" of some kind for HVF, TCG etc.
> >> 
> >> But maybe I misread the use case?
> >
> > A generic interface would require additional glue to connect the
> > generic code to the accel-specific implementation.  I'm trying to
> > avoid wasting everybody's time with the extra complexity unless
> > necessary.
> 
> If I read the patch correctly, the *interface* is specific to x86_64,
> but not to any accelerator.  It's *implemented* only for KVM, though.
> Is that correct?
> 
Yes, it's a x86 specific instruction, and KVM is a bit of implementation
detail right now. It could actually have stubs in other accels instead
of CONFIG_KVM.

> > But if you all believe the extra complexity is worth it, I won't
> > object.
> 
> I'm not arguing for a complete implementation now.
> 
> I think the command name is a matter of taste.
> 
> The command exists only if defined(TARGET_I386).  Putting -x86_64- or
> similar in the name isn't strictly required, but why not.  Maybe just
> -x86-.
> 
> Putting -kvm- in the name signals (1) the command works only with KVM,
> and (2) we don't intend to make it work with other accelerators.  If we
> later decide to make it work with other accelerators, we get to rename
> the command.
> 
> Not putting -kvm- in the name doesn't commit us to anything.
> 
> Either way, the command exists and fails when defined(CONFIG_KVM) and
> accel!=kvm.
> 
> Aside: I think having the command depend on defined(CONFIG_KVM)
> accomplishes nothing but enlarging the test matrix:
> 
>     defined(CONFIG_KVM) and accel=kvm   command exists and works
>     defined(CONFIG_KVM) and accel!=kvm  command exists and fails
>     !defined(CONFIG_KVM)                command does not exist
> 
> Simpler:
> 
>     accel=kvm                           command exists and works
>     accel!=kvm                          command exists and fails
> 
Well, it accomplishes not having stub implementations all over the place.
But looks like having the right error message in stubs really seems more
appropriate.

Your reasoning is pretty clear and in the light of it I now fill that
platform in the name is better that one of the possible accel implementations
in the name.

So should the command name be renamed from 'query-kvm-cpuid' to
'query-x86-cpuid'?

And considering CONFIG_KVM, I guess it would be better to drop this ifdef and 
instead put stub functions in several places? If yes, please let me know
the exact list of places that should have that stub, as well as the right way
to state the "unimplemented" error for these stubs, (sorry, this last
one is just to shorten some of the iterations)

Thanks.
