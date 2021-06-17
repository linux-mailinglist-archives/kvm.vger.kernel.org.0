Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB56E3AB7B5
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhFQPmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 11:42:15 -0400
Received: from mail-db8eur05hn2234.outbound.protection.outlook.com ([52.100.20.234]:31808
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233364AbhFQPmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 11:42:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5cP0CzDYpLcjrcW+vDOv0INHO8MAJ57NrWqs8TU7HvRoR5x/310AMiFzKl6qOhj4V1PtB36MB9vyLiAjP3wjHyXQE8Jw+9+n8gFtPpvPfk/pH/gFcQVRbeKzaBWH7aH3t9X+QqCgCdj7A8CSSNa8UUJM9pshx4aO5e5nHF/bP7Y3OinY48+T9FBx+kWbOCkEKooy3FOWYS3WJoCUTy83ZLaqrG5HGQ/FsdQZ04v0+IiNHSu4t5lQiQUUKWNyUsoDeSMVSLqhsCVzvtWi6KST+eqtRBQ8cUlFZGKg5EzS2s3k0YpGQMGB4MhRJZ2yyrqM5MaXsMd/gx5RvjCumBkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGjRIDi+dTPVnU9Sn7Dq1G8oBeLKnbKjoL1EGSuUBLQ=;
 b=EWfE4tys1hdcivaw5zGLRzu5tvvPHPqH9wmwB0LFxy5iCOCXTtspVRRUPoVWdXncN42gu4nwJAbA98qKGpHGfs+2z685nalf7wUOR+yzvAIwnnNG3SG+bBqF/jtNrKT2Jrb+j8GgKzW7b8k8OqrX7mfny1Pxe1EmyrC4xPSe0Cqnwt5nwyPyakXS3WBJq79RnufSjzwbZjOONF2hSdHmvT10OPT/6w5+fW+zXDiVTPDUZgHBszSZGqOj11g1JbXqReu7tqaDAEpHswBnfBJLdF5ggzd8bzsH/qcuGCYm4Ey2R+KO2BXB/5q0NB6BtFWEGX8+TBjceyHme2eEJ6G6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGjRIDi+dTPVnU9Sn7Dq1G8oBeLKnbKjoL1EGSuUBLQ=;
 b=r+UiUwcMhestP4daLoPfr2QZKRqQfT+wikRXws4hWvhRmclo05uO9JRLYVL/dbQuN4jdpZCcS6CkYXDqR9FFOXvP3J8IBkdpzH5lG3Ud3RUbdu7ZvHDTp7I94cWX1Nq/48iDC8EkksgptiD7JcYfkWn8bWtJ3M3pIJYdDGQOlvE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6836.eurprd08.prod.outlook.com (2603:10a6:20b:302::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Thu, 17 Jun
 2021 15:39:58 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6%6]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 15:39:57 +0000
Date:   Thu, 17 Jun 2021 18:39:49 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Claudio Fontana <cfontana@suse.de>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Denis Lunev <den@openvz.org>, Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210617153949.GA357@dhcp-172-16-24-191.sw.ru>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
 <87im2d6p5v.fsf@dusky.pond.sub.org>
 <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
 <87a6no3fzf.fsf@dusky.pond.sub.org>
 <790d22e1-5de9-ba20-6c03-415b62223d7d@suse.de>
 <877dis1sue.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dis1sue.fsf@dusky.pond.sub.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: PR0P264CA0205.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::25) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by PR0P264CA0205.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 15:39:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cc1b379-72c3-45ba-4c25-08d931a62943
X-MS-TrafficTypeDiagnostic: AM9PR08MB6836:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB683639150AE0E9019FDEB0AB870E9@AM9PR08MB6836.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(39840400004)(376002)(346002)(366004)(136003)(396003)(6506007)(36756003)(7696005)(52116002)(956004)(8676002)(38100700002)(38350700002)(9686003)(53546011)(316002)(478600001)(26005)(55016002)(6666004)(33656002)(5660300002)(54906003)(1076003)(83380400001)(44832011)(2906002)(6916009)(86362001)(66476007)(16526019)(186003)(7416002)(4326008)(66946007)(66556008)(8936002)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?XTRx04aPpDYXvHC458qLUM/coyGD/edCGoOvLHQwQIEc/tAGJ6+atabbbOW3?=
 =?us-ascii?Q?dtUIZ94h7jUpm6M6mFE60hNjL4SxRNF75578jJ0NebzMy4UPRQMDCwYAssn7?=
 =?us-ascii?Q?uwPOtKWeB1ObAllX5pTo+kJmlfc+ei+pgamHAiMirDL10mHQiCoTiG+Jd3rq?=
 =?us-ascii?Q?OxLtBbr4yn/J+QV5z74NjczstpWAGrK59uKiOjbjGBf8b+9VDB2qb3ks5R4j?=
 =?us-ascii?Q?QeiuQr3He8j4/VqGDQb+jAxZLT1PsQCruituXeANBBTxe8fB1Qx3ar2o5+4p?=
 =?us-ascii?Q?LBgoTIEoDeeSFDN+yA4uPttEZ/TPfkAMQMJfsm6NMskF1FqVp7CQQbAW5Uup?=
 =?us-ascii?Q?2xBjc5Jo+vDbJYXkDKVd6wLHrjcTKXFMAEwJWo5eD9U14ZDDaETnS/OSSxh4?=
 =?us-ascii?Q?I90NnuD4HoHZtAa84KcqscN4lhxXPHcu5RM9fAfL90XGXjEZU9YyNzgJlvPl?=
 =?us-ascii?Q?X7RCCjCAo2aiY+v05nxmo3sD0fRMSHNsTHQwolbCBrG05eUbniZ52SBj97pP?=
 =?us-ascii?Q?d8TOH9QhwWahlYn78riFXBEj5Kx5Was1uHlgXiUOp5sR4d0wZSwuvh3/u6s5?=
 =?us-ascii?Q?rLLPer6UTu/V0yvYBPizQPY0/TEpdEwAWoy28lP3/A54OLzYqTzw1WvbgLNT?=
 =?us-ascii?Q?r0TqIe6RszpjFYDnVnGnpk8fD6z7yuDXPYfUy3QM1ECELvjij78r0isjZZ1g?=
 =?us-ascii?Q?ZnxemZ/dQmJVHzDnzQtogbtsc7OG8wW3FJL32eerczvOOv7u1j/IWC0cg63Q?=
 =?us-ascii?Q?LPj6OLAD1sDaKcIfmKOT162P2IrVU+UCM6lFbcLknZhmZoe946qQEPhCk7NU?=
 =?us-ascii?Q?5BdhZy9ZEd0GxkyalJjqhGRC1qSnKLEi2FaJd8l8pTgSNTB3RsV9g77BD7Z7?=
 =?us-ascii?Q?+dF8Du5Y/bt7W/6Teo0bWZr9lrVoXwGZ7HlYlEWL4+7t6ktaCz0439LwWugf?=
 =?us-ascii?Q?gi1Cd2Jd1JMP2XDyurIPiSeCEwxnckqWi4GfJYkSQ/Q=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SKtF1c2zI9MoLinV2wn5xN5/Cs74FR6bfgjG9kQqJNM3kHRPvfMAiO/JW9b7?=
 =?us-ascii?Q?B6GJOd8mniOwv852zhk0Z82vWoV7Ji+enu4nleXytWl0OlWrRmrv5WAZ/r1E?=
 =?us-ascii?Q?DNYxTP/Q1t6pQZs9Y+9SUet3uuBIFkjIgpLs1hx0/4RHhqEaIpDgH8x6xeFd?=
 =?us-ascii?Q?+6/E8rQayTjSLA9IIuPj9GTNisvp8K+oW0wmu/uIGjBS3+4emFinbEgnsjzi?=
 =?us-ascii?Q?N5jOxLqS3Hyg1OVm792veAYag+9Hzj6Uzc7BZ6gRov+a3GwVwidEuHZ6bKFb?=
 =?us-ascii?Q?od7iGDkqz1fa8aUvOwr6GyszFwTDFhGeVdc/fEnSnh+/6ZUDGsUB2+WA1RfY?=
 =?us-ascii?Q?onKLezFUW3Nx2U4kseJeKervdVUYm/dtyl1MHB60g1NlP9gtRlqBzW/h5iCY?=
 =?us-ascii?Q?lBlE2W7jY3aXvx6e7FAodr5WIQ16uOn2cs7QySigZJmz7Oo7rj4ivs1x3hUy?=
 =?us-ascii?Q?WwOvLC9I+4vquQ0XW4/uSc/jsPN/RMC0mGQO5LoDY1n02TY70W/nL37H2UWW?=
 =?us-ascii?Q?lwZJZ1s7Ihp2BkPgfnXzWHWM+VaIlX2ZpflX0ecNErDot6uIM48RzdcnbB7T?=
 =?us-ascii?Q?G8aJUUkJ4+AqWG5PAbkozzb4Y7XXA6RK0zpeYlWPffZkNiR830RIIu2v5g6b?=
 =?us-ascii?Q?kL5x82sRJs/Nb3qCb/r3uUF/liPGEiF84EH2QV38jR3FVAB5FEvssK7Mc4Uo?=
 =?us-ascii?Q?Zmbpbp+0P45fAVAkoUwm90aXXZOKK+wUOzsCoJy8T5wS0F+CAjIP8iphnvmo?=
 =?us-ascii?Q?TCpx6Jkh5lB5vMzqZzkEnYGO3yMeaO6+77Vmm02G0+hFeoDKAH+370+NeA0v?=
 =?us-ascii?Q?ENUtBP/BqpU8UWnzXX1ZEMbSF/cvLKQ+LPrsBRqOk+2Vqsao8oUheCw4zc3F?=
 =?us-ascii?Q?7n1VVI8DiA6RUmpP5uODbWoiGaCBOFviccUPB7JhPr6kGItX9jnDY8xeczK5?=
 =?us-ascii?Q?AbbzJdDJk/96tJ3cAlrHBcMCJxNu8cUasPVVqPEXPeebcyrlz1kkhSXiUyPE?=
 =?us-ascii?Q?qyE/PSSmd8Msmq2teSHFG+tB9I9qAP7rNu7bHYQtIAJSgTYkJB1WAxR50sL+?=
 =?us-ascii?Q?zMJeXM70NFy0XhWoBogUusAP2hman32WJ9P3FwW8Zc0wt/SIEpkwbORODE4S?=
 =?us-ascii?Q?q3Xw4+oz5o/EcuxeOAwgGzi5l4w7p2RqGoJ/Z5dnbswA7o32s2N5MyS2hBrW?=
 =?us-ascii?Q?7lKPzhtgWlh1pbzCkzOXssOUcQC5+af4n5jqyDoJ33qooyzwTIB2QnQ16ihP?=
 =?us-ascii?Q?KMFkecF95f4RuFTTD+U9stHp9yErwd9XEewFvpA5GaqGDX8bth57OnOAf6Dh?=
 =?us-ascii?Q?sk31h+2P99Xe42wNYZ2FBXyK?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc1b379-72c3-45ba-4c25-08d931a62943
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 15:39:57.8056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7j9sU4Odp/OnnEsLUjMYiOtyQ4oURdZUT7M/b1yOyyggVz4jMof8PBfBi/fm1dzwNy1yq0KCwx/3FyDFnTPqIrdcceLDjubDMtgEExFW3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6836
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 04:14:17PM +0200, Markus Armbruster wrote:
> Claudio Fontana <cfontana@suse.de> writes:
> 
> > On 6/17/21 1:09 PM, Markus Armbruster wrote:
> >> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
> >> 
> >>> On Thu, Jun 17, 2021 at 07:22:36AM +0200, Markus Armbruster wrote:
> >>>> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
> >>>>
> >>>>> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
> >>>>
> >>>> It's actually a QMP command.  There are no "qapi methods".
> >>>>
> >>>>> get virtualized cpu model info generated by QEMU during VM initialization in
> >>>>> the form of cpuid representation.
> >>>>>
> >>>>> Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
> >>>>
> >>>> virtual CPU
> >>>>
> >>>>> command line option. From there it takes the name of the model as the basis for
> >>>>> feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
> >>>>> that state if additional cpu features should be present on the virtual cpu or
> >>>>> excluded from it (tokens '+'/'-' or '=on'/'=off').
> >>>>> After that QEMU checks if the host's cpu can actually support the derived
> >>>>> feature set and applies host limitations to it.
> >>>>> After this initialization procedure, virtual cpu has it's model and
> >>>>> vendor names, and a working feature set and is ready for identification
> >>>>> instructions such as CPUID.
> >>>>>
> >>>>> Currently full output for this method is only supported for x86 cpus.
> >>>>
> >>>> Not sure about "currently": the interface looks quite x86-specific to me.
> >>>>
> >>> Yes, at some point I was thinking this interface could become generic,
> >>> but does not seem possible, so I'll remove this note.
> >>>
> >>>> The commit message doesn't mention KVM except in the command name.  The
> >>>> schema provides the command only if defined(CONFIG_KVM).
> >>>>
> >>>> Can you explain why you need the restriction to CONFIG_KVM?
> >>>>
> >>> This CONFIG_KVM is used as a solution to a broken build if --disable-kvm
> >>> flag is set. I was choosing between this and writing empty implementation into
> >>> kvm-stub.c
> >> 
> >> If the command only makes sense for KVM, then it's named correctly, but
> >> the commit message lacks a (brief!) explanation why it only makes for
> >> KVM.
> >
> >
> > Is it meaningful for HVF?
> 
> I can't see why it couldn't be.
Should I also make some note about that in the commit message?
> 
> Different tack: if KVM is compiled out entirely, the command isn't
> there, and trying to use it fails like
> 
>     {"error": {"class": "CommandNotFound", "desc": "The command query-kvm-cpuid has not been found"}}
> 
> If KVM is compiled in, but disabled, e.g. with -machine accel=tcg, then
> the command fails like
> 
>     {"error": {"class": "GenericError", "desc": "VCPU was not initialized yet"}}
> 
> This is misleading.  The VCPU is actually running, it's just the wrong
> kind of VCPU.
> 
> >> If it just isn't implemented for anything but KVM, then putting "kvm"
> >> into the command name is a bad idea.  Also, the commit message should
> >> briefly note the restriction to KVM.
> 
> Perhaps this one is closer to reality.
> 
I agree.
What command name do you suggest?
> >> Pick one :)
> >> 
> >> [...]
> 
