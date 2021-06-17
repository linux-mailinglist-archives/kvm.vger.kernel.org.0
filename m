Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8241B3AADF8
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhFQHvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:51:44 -0400
Received: from mail-am6eur05hn2234.outbound.protection.outlook.com ([52.100.174.234]:42593
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229515AbhFQHvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:51:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOWm3dJjTuOcG2sW2J1BdVsP9oO4q7YgpCHJo0wau+zl5/zLYx70QMYuJICEAU30peRpXvNNMpzezs90gQmZKdficofs8ZeppLIE84FBJ+IY05iEdIaHZTE57HM4cMr/z/FEi8Rk5CWXGT3WTWdkqEuiHqdEhOnJdWkCLoPu+7y2hIKdyVytL0fPdlSmkjw35k39NHM8HsewBwXZzO2Qaar+pirqoiDVuAhLUwtuLMM9AenSA+rtf3gubkVQQufhFWiqAV9eu7r9OhpX5+TdozlVZKVTxxcEO5vrqBCUVh6nXlYG8pYXsPFhv3lHutTCAqTeDA9oeNI7OOOppyWUNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RksO1VTnWWb28KEbjvELqvJpPrBR6db1ENSSFU84O0w=;
 b=CkIYkV6zJ01kO9BoJiHTjIxCE+JllNIIhgIKRzFzrc1paW9m/T9lhqPzIhbCKrYPiMszsPH56I4KprOmkNBEezz9qktnsyLNlGwDV8HW25HDR8Xu4v6TAjkFcUA0fMzChrQldgCD24ELucYSmw41+HJhB/e8D+EwkPgd7wfW8FnpfX4Vh0eQc15Nf8PhfP3hatQyOV1u/tv02z91F+3BRphQqH2jeVOD4cGzRCjd2wmLFy7yZbj2GDag0DyCgVlE3g99DiHhzpLNb0OhKJTnw7TziHs3VNmF2ilPeguPdKmCOkXIPy46r02FyO2GUq0+ul6/Ec8yPCkxuTG8oiToYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RksO1VTnWWb28KEbjvELqvJpPrBR6db1ENSSFU84O0w=;
 b=qAcrX7Eg6KAOlNDL1awGmIE2MaPOH7K8hNhTodhxgWw4x/TShFBEGaKOBozAEEHg1/vQhvKbT374vtUxREhfsXOgjwqMtVKGyLCbMZBjZ4za9GDdX7KcjwghAGH3nPa1QtTTS8ELX939IEOb+wwL5Sh+KjyNQgouvfQrfOzn0uQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6129.eurprd08.prod.outlook.com (2603:10a6:20b:284::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Thu, 17 Jun
 2021 07:49:26 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6%6]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 07:49:26 +0000
Date:   Thu, 17 Jun 2021 10:49:19 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
 <87im2d6p5v.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87im2d6p5v.fsf@dusky.pond.sub.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR04CA0037.eurprd04.prod.outlook.com
 (2603:10a6:208:1::14) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by AM0PR04CA0037.eurprd04.prod.outlook.com (2603:10a6:208:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Thu, 17 Jun 2021 07:49:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7618f60-a5b9-4140-b129-08d931646dee
X-MS-TrafficTypeDiagnostic: AM9PR08MB6129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB6129EDA1137BD2246F55C64F870E9@AM9PR08MB6129.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(39840400004)(366004)(396003)(346002)(136003)(1076003)(55016002)(7696005)(66476007)(8676002)(9686003)(7416002)(5660300002)(33656002)(66946007)(44832011)(6916009)(2906002)(956004)(66556008)(26005)(16526019)(8936002)(6666004)(38350700002)(38100700002)(83380400001)(478600001)(36756003)(86362001)(107886003)(54906003)(6506007)(316002)(4326008)(52116002)(186003)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ckkJAQi7yEKHVYBxP+ZwUkJV+bXrUOPf9M/xRcWf2ShtA75H1rWmW0ieuMl7?=
 =?us-ascii?Q?d4t5ZEag0g4RltbxbNDkZ/5wTgz/Cn4mEUL9AqAUg/P51rjE2SojGgisIgYe?=
 =?us-ascii?Q?UEQodkrcLklwsum9Dfyu8t8DoFAHOyVVue0ziQ6rObGyQmjSrR9LEkwK4Yw1?=
 =?us-ascii?Q?1iD1UiBeL/zmMtXYQDb7FaoRPjtl/bFw1R7hV+pbMCHp0JD6PjLHdjw0Kjxn?=
 =?us-ascii?Q?dor1dDvMTXWjvT/XY4t7AvmbdWLG+zDbYOO2oiX75AeToEhOQmcwv+f5SNRV?=
 =?us-ascii?Q?ywBKfUroCnwz44vskxIqrXKG+TsW4tcx50M3LbsCn0u/wDxuOTKeukh3QJgc?=
 =?us-ascii?Q?zj+dJB+YvjJzlIV3lGRsHlzETPb5Fd85n/NDcHahkEvCDKjDMkapf+wouGti?=
 =?us-ascii?Q?ZygFutRZRoGkhdiag9B/VfjFRknzmaacjPpHbom6TREM7zenV/kPgirrEZV0?=
 =?us-ascii?Q?/MFfd0pbsU7d+QgZxZVXZ8aHxIcoNaG8oZ8FS+8Xj4+F8TQfk1piaIlrNqvp?=
 =?us-ascii?Q?VIERIouBfNDHHTctrJ4esGb7MxX7xzScrzFydZs/Br/CyfbXFhRT/4bhx/cO?=
 =?us-ascii?Q?cbGw7tMPmtSVQS1XaABoMLBUrLcEYw3HPqpodY6TTX5f7bu4N8OqsdsrhfVK?=
 =?us-ascii?Q?rRahjJy5xGsWOQ64EPJfu720dfVc418qLDN0eCofrJe98RWpKv/uVx0CR0xU?=
 =?us-ascii?Q?6ciu3NhoewNMF3HD3QrEgbUbWfDVGNgIK+lSbCwPXcxHo9ti/g0PYClYdPzq?=
 =?us-ascii?Q?7qNRjrgpIWU2p5NwrEyLf7USKdUyuPpVL1y/H81AJRmVoQFQMJAEnRea1Fld?=
 =?us-ascii?Q?hFrqxqNnWLBxeGsXVuobqGhx97IQfa5sTggoAqAEl9fvP8DzGbLLPSjR9SGM?=
 =?us-ascii?Q?ariSBP+liGDN5KFOE5U9Um3L9EHrpVedUZ1jx8TsnB6Xm6zso+sqRAhm7vPk?=
 =?us-ascii?Q?RKMx4hypIQSx35/mI5AQU325nv7VA1hxR8NBBblH4Gc=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i+RZAnGENEYUivMernUmgvq/5Erj8kFAC0OJf8ot1HPZwSmfrZA7qObjnQaf?=
 =?us-ascii?Q?JRqG0YNxhgzTXX854+Xjr1envyyUkSkJ/6pCyT4zvniY9tCWTufjl+1a+AwG?=
 =?us-ascii?Q?L3H416GgQ2aBFUUakJqlXchJ2TFITJ2cuTOvUcLj7ZX2GbNcnrQAjmm8UmlM?=
 =?us-ascii?Q?Ub33h+uKoZg+b846HmY3HAKZs8p9jUM581pW84YtIiVGVOqJ24ozjqCnUIQv?=
 =?us-ascii?Q?zxH0CTnCZyEWZUVWg/CZP03yYyd1pzxBGvvKqR6fzjFwXuB0u99eKljUYKtC?=
 =?us-ascii?Q?OogfGI+d0Tm4yy32uNZbjhIaxBwdwpce25785uurPL9yuxst6sWqusukQwzg?=
 =?us-ascii?Q?HAkd2gKroy09VEK+FHcFjcZb/ejgKYoiRDxq2liY4g3XsNY/KJU8YsJ2KEDH?=
 =?us-ascii?Q?8TXNCR7fI2yyUM2bP5a6Q+Y72T+lFI/Irswf54T7aGR6MgPeEbZm1ldeN0WE?=
 =?us-ascii?Q?vDLSqFAc6dQITiUBb7rVvqliWs27DISJwg7ItM8BAxFBSpqf9cRoz6kS/n9h?=
 =?us-ascii?Q?CkvQAJgD0ABAYzxLNzU0PgMTU+ETcdUXYXzhRr3BR2Xn3AFbfnZg/cAeRD6P?=
 =?us-ascii?Q?oS+4XIs+tgorgGb9Sdk8Sk3TIPXvT2j5oeVfoeED8aEkkcZADV6UCKHZCp3G?=
 =?us-ascii?Q?Z/gkRLLWdSX5imXCX3XwynN6fvq9Ony0lvsOxazwvFpwXE3i9HNck8rwijEI?=
 =?us-ascii?Q?2qdBXvJPrftGyCZTEZgko1RvnBeZaz3EuwDBExPF+R4Z2nX7KLTXJBGwy3TU?=
 =?us-ascii?Q?699KCy+JDxgJbua1L/K1ZMb4/8zWup0G+nFx/n9UuJWQhq2qrmFdOoeucuvk?=
 =?us-ascii?Q?KYjh3niv7w2jhh8WglMrwr5+63l9mqGmPnFiQj8p9Tk7oW7j/B6Ln2c2OsBH?=
 =?us-ascii?Q?SYREUYo5qg+8++dVzW1ZmygvuESuw1LNCY6EKKknh4AZPBxggjXgxgi2ldsx?=
 =?us-ascii?Q?pVQCs4sODfo96Kf06ucyzcYuP/Db6RsKQj3EoujRFW/r2lb7An4IR10FsG7f?=
 =?us-ascii?Q?zKjnPJo87vlCaAKJdCegzcdzEU5+k9fLvf7ikYMoTMwUYRwuf/ahhvZK8rOs?=
 =?us-ascii?Q?e85HKhbGsRAsnWiWFt+smUzXswTs2SQKCQgWPQQYRSu8crvZDuV4u1DHDwvk?=
 =?us-ascii?Q?kRkXBnlvTmGO2luMPNeTlV0Uj9FgyiGeoKshYkuAA6NMZsopsYPzL8a2IbUT?=
 =?us-ascii?Q?ztrnebD7hnCpnIuoMcXuMtIdsHPTyKr7XKysd+kV0dZBvN6dmClM+wItAeV4?=
 =?us-ascii?Q?MRVDILicyppSLJknc+IaMicW3/1XRAicOxriBorlVzI6ub1s9cjZuEjkLYZ5?=
 =?us-ascii?Q?Maw1YftQ4BCkpxbYvc1bhOCQ?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7618f60-a5b9-4140-b129-08d931646dee
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 07:49:26.2546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFXbCasATEWyep0+sPQcnb0s+aCbPnGpAQu5p83kDf0ReTjGdOCJU8QpyDrgVe7sgEYnBwBw0WLjvVt2iri4EOF1MxMyh7BYrStNaGguoFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6129
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 07:22:36AM +0200, Markus Armbruster wrote:
> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
> 
> > Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
> 
> It's actually a QMP command.  There are no "qapi methods".
> 
> > get virtualized cpu model info generated by QEMU during VM initialization in
> > the form of cpuid representation.
> >
> > Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
> 
> virtual CPU
> 
> > command line option. From there it takes the name of the model as the basis for
> > feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
> > that state if additional cpu features should be present on the virtual cpu or
> > excluded from it (tokens '+'/'-' or '=on'/'=off').
> > After that QEMU checks if the host's cpu can actually support the derived
> > feature set and applies host limitations to it.
> > After this initialization procedure, virtual cpu has it's model and
> > vendor names, and a working feature set and is ready for identification
> > instructions such as CPUID.
> >
> > Currently full output for this method is only supported for x86 cpus.
> 
> Not sure about "currently": the interface looks quite x86-specific to me.
> 
Yes, at some point I was thinking this interface could become generic,
but does not seem possible, so I'll remove this note.

> The commit message doesn't mention KVM except in the command name.  The
> schema provides the command only if defined(CONFIG_KVM).
> 
> Can you explain why you need the restriction to CONFIG_KVM?
> 
This CONFIG_KVM is used as a solution to a broken build if --disable-kvm
flag is set. I was choosing between this and writing empty implementation into
kvm-stub.c
> > To learn exactly how virtual cpu is presented to the guest machine via CPUID
> > instruction, new qapi method can be used. By calling 'query-kvm-cpuid'
> 
> QMP command again.
> 
> > method, one can get a full listing of all CPUID leafs with subleafs which are
> > supported by the initialized virtual cpu.
> >
> > Other than debug, the method is useful in cases when we would like to
> > utilize QEMU's virtual cpu initialization routines and put the retrieved
> > values into kernel CPUID overriding mechanics for more precise control
> > over how various processes perceive its underlying hardware with
> > container processes as a good example.
> >
> > Output format:
> > The output is a plain list of leaf/subleaf agrument combinations, that
> 
> Typo: argument
> 
> > return 4 words in registers EAX, EBX, ECX, EDX.
> >
> > Use example:
> > qmp_request: {
> >   "execute": "query-kvm-cpuid"
> > }
> >
> > qmp_response: {
> >   "return": [
> >     {
> >       "eax": 1073741825,
> >       "edx": 77,
> >       "in-eax": 1073741824,
> >       "ecx": 1447775574,
> >       "ebx": 1263359563
> >     },
> >     {
> >       "eax": 16777339,
> >       "edx": 0,
> >       "in-eax": 1073741825,
> >       "ecx": 0,
> >       "ebx": 0
> >     },
> >     {
> >       "eax": 13,
> >       "edx": 1231384169,
> >       "in-eax": 0,
> >       "ecx": 1818588270,
> >       "ebx": 1970169159
> >     },
> >     {
> >       "eax": 198354,
> >       "edx": 126614527,
> >       "in-eax": 1,
> >       "ecx": 2176328193,
> >       "ebx": 2048
> >     },
> >     ....
> >     {
> >       "eax": 12328,
> >       "edx": 0,
> >       "in-eax": 2147483656,
> >       "ecx": 0,
> >       "ebx": 0
> >     }
> >   ]
> > }
> >
> > Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
> > ---
> > v2: - Removed leaf/subleaf iterators.
> >     - Modified cpu_x86_cpuid to return false in cases when count is
> >       greater than supported subleaves.
> > v3: - Fixed structure name coding style.
> >     - Added more comments
> >     - Ensured buildability for non-x86 targets.
> > v4: - Fixed cpu_x86_cpuid return value logic and handling of 0xA leaf.
> >     - Fixed comments.
> >     - Removed target check in qmp_query_cpu_model_cpuid.
> > v5: - Added error handling code in qmp_query_cpu_model_cpuid
> > v6: - Fixed error handling code. Added method to query_error_class
> > v7: - Changed implementation in favor of cached cpuid_data for
> >       KVM_SET_CPUID2
> > v8: - Renamed qmp method to query-kvm-cpuid and some fields in response.
> >     - Modified documentation to qmp method
> >     - Removed helper struct declaration
> > v9: - Renamed 'in_eax' / 'in_ecx' fields to 'in-eax' / 'in-ecx'
> >     - Pasted more complete response to commit message.
> >
> >  qapi/machine-target.json   | 43 ++++++++++++++++++++++++++++++++++++++
> >  target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
> >  tests/qtest/qmp-cmd-test.c |  1 +
> >  3 files changed, 81 insertions(+)
> >
> > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > index e7811654b7..1e591ba481 100644
> > --- a/qapi/machine-target.json
> > +++ b/qapi/machine-target.json
> > @@ -329,3 +329,46 @@
> >  ##
> >  { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
> >    'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
> > +
> > +##
> > +# @CpuidEntry:
> > +#
> > +# A single entry of a CPUID response.
> > +#
> > +# One entry holds full set of information (leaf) returned to the guest in response
> > +# to it calling a CPUID instruction with eax, ecx used as the agruments to that
> 
> Typi: agruments
> 
> > +# instruction. ecx is an optional argument as not all of the leaves support it.
> 
> Please wrap doc comment lines around column 70.
> 
> > +#
> > +# @in-eax: CPUID argument in eax
> > +# @in-ecx: CPUID argument in ecx
> > +# @eax: eax
> > +# @ebx: ebx
> > +# @ecx: ecx
> > +# @edx: edx
> 
> Suggest
> 
>    # @eax: CPUID result in eax
> 
> and so forth.
> 
> > +#
> > +# Since: 6.1
> > +##
> > +{ 'struct': 'CpuidEntry',
> > +  'data': { 'in-eax' : 'uint32',
> > +            '*in-ecx' : 'uint32',
> > +            'eax' : 'uint32',
> > +            'ebx' : 'uint32',
> > +            'ecx' : 'uint32',
> > +            'edx' : 'uint32'
> > +          },
> > +  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
> > +
> > +##
> > +# @query-kvm-cpuid:
> > +#
> > +# Returns raw data from the KVM CPUID table for the first VCPU.
> > +# The KVM CPUID table defines the response to the CPUID
> > +# instruction when executed by the guest operating system.
> > +#
> > +# Returns: a list of CpuidEntry
> > +#
> > +# Since: 6.1
> > +##
> > +{ 'command': 'query-kvm-cpuid',
> > +  'returns': ['CpuidEntry'],
> > +  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
> 
> Is this intended to be a stable interface?  Interfaces intended just for
> debugging usually aren't.
> 
It is intented to be used as a stable interface.
> [...]
> 
