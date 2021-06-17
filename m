Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34B63AB522
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 15:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhFQNtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 09:49:43 -0400
Received: from mail-vi1eur05hn2240.outbound.protection.outlook.com ([52.100.175.240]:28193
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231303AbhFQNtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 09:49:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gvy4fzR1jWpUokS2ulblHFwVHRZCVe7gDRwvZCLb3+ZAO/DGA74xdotaWndP7Qok9xJxcg41F1HLrBl9jJohWkSYKGbALEWnZiPZeB5fjarvDzv01Kin8KtnRHavyTKi9udSeJoilT3vynXMMaRSUS7kgluodbYrIzPznOe9FNYbW0cg0wNmKB6GiiHUfTtluwR98LNppHWjG8x1x3Gel5LSrSnpqaLBvscwSiUMrd49VOPY4mgIsuMmx9VyExpVSs74RwTfGQRAe5ebbbA5vAvfWHselmhv/k9juDPIv91KGPvgH5u9Z2jnmTXHi+YhEcqLEXjjB2MhS3wWKpJRhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tlp2Xqx6P3QuB9jY7x2m3YX7AejukuTh6Fu/MEWCA4E=;
 b=Jswma1QM6KAfyYBxdvee4CszDB5nOYFVxkACBuZ/ZQclSDfLdUvIRterL5YHx724H4vDXSSNg8KxHnCRv45fYcpzYIIaeGepycJaCQ/LnRYNSw9kS5l6LpKMPcxNtURpU0XxThu6YUi+h3Mz5lofMjr4ngWK1v/nOdMBKQ1KIlozv3o2J5F3ZEbFL+ZEbGRgKE+NHR2K3MmCDNtaXtj430Ocm0QOxoFf16tXmk2wOSc+pp85l50OcIyOXp2SEVAuX0igxFBj9WMeB1t6r1OSo2LULou1kXOsg+QXlhHZ46vt9GduL+BpZhRPiVkFrccSlfXjmG7KVePMMv1GO+AAMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tlp2Xqx6P3QuB9jY7x2m3YX7AejukuTh6Fu/MEWCA4E=;
 b=AgjfMURJ/1C/86Ac6FnJ58y2XNddwA5+fk/yCgidcBXCpX7NWikNAb9wLpZqzGF9JpTzt3W5X63KzNAuSK8IVdjCwUnuuuJI+u4al1LqPzsq+bCjH3hITfMQUaHnkNjRmT1BgR+ZmNHQgAX1MnQ7CY1gh4/dRTGyThgVvl7PkGs=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6116.eurprd08.prod.outlook.com (2603:10a6:20b:2d4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Thu, 17 Jun
 2021 13:47:23 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6%6]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 13:47:23 +0000
Date:   Thu, 17 Jun 2021 16:47:17 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Claudio Fontana <cfontana@suse.de>
Cc:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
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
Message-ID: <20210617134717.GA1013583@dhcp-172-16-24-191.sw.ru>
References: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
 <87im2d6p5v.fsf@dusky.pond.sub.org>
 <20210617074919.GA998232@dhcp-172-16-24-191.sw.ru>
 <353d222f-7fc1-61ea-d302-517af8f01252@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <353d222f-7fc1-61ea-d302-517af8f01252@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR10CA0076.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::29) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by AM0PR10CA0076.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 13:47:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe1a2df5-e1a2-4f55-0b2e-08d931966f4f
X-MS-TrafficTypeDiagnostic: AM9PR08MB6116:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB61168D8D01EA5D455CEE0933870E9@AM9PR08MB6116.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(39830400003)(136003)(366004)(66556008)(6506007)(26005)(83380400001)(53546011)(55016002)(54906003)(8676002)(33656002)(36756003)(107886003)(316002)(956004)(478600001)(1076003)(8936002)(66476007)(7416002)(5660300002)(44832011)(52116002)(6666004)(66946007)(6916009)(16526019)(86362001)(38350700002)(9686003)(38100700002)(186003)(7696005)(2906002)(4326008)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jsnCk1QuCk+icSSd/MnpJvAFCwhqzeuWqzWsA0yiHG7gZW5g0d3RnHUSilOg?=
 =?us-ascii?Q?lOxxQoAabh5GoYtl7QCvp0RVpPGs6WYdQgNzkvryTABw3y/zg5/Kn2NNtskq?=
 =?us-ascii?Q?P4ecesKG0RS+GrYEV75mWMaN/b+aLl6ZJ6IWtrWOWykqLuJqtDAHJCxkOca1?=
 =?us-ascii?Q?sOCVAoIXD72Rt3jNmuxv4ZV34rOoesccFW3rvira/Ii519R5Cn6ClAgo+UwV?=
 =?us-ascii?Q?Bui+3aUzc/V/Q9kZnUhpInUjMCj3l3y81fqdbYKYgmEL2d0M3qlYARBQHfpC?=
 =?us-ascii?Q?jYgASdvF5prJ1NQJpjZs3S8Lv0ZOwKP5CrwLJcNkbbMSDOI5hhsoAC8Mt0lZ?=
 =?us-ascii?Q?2k93Gfa7tnAWkowFBEJOMJyBx1NH6WiwT1FXaRL0Er4566hs0gqReelGOaBu?=
 =?us-ascii?Q?zepQ4m45T81ArL6/W+1KYnP3RGIQdiUPpUjigaerltjn61YM6GwM79iZdQH/?=
 =?us-ascii?Q?z++5S8GlOZYBZ/1IAEAbSwe4iDMhqxzwVNP2Z/1UiZ9jg33NFB+DI7SIr39A?=
 =?us-ascii?Q?MtVibT4P2kWmItp+EzTfQrdZ1jGjIsLDsmDJBxWl8iGiwABS/1BUXbSo5PDD?=
 =?us-ascii?Q?NnY3CeVzSoYsNkCwKbvF0UiBk21LP4YkGaGM3ZxW+5wOvsI+nSSZKS9ta8ed?=
 =?us-ascii?Q?9cLoFeTCHYodfBPhYE5JAsg25hIXjTTtv2uzFO640HsWLxDRfkbZMFY9bIAO?=
 =?us-ascii?Q?vF8rQJZEeMPo68b0QNGYdIGz0U5o5XWQ7NIYO9LVoeYs2LLpxsBUPLz5PfCy?=
 =?us-ascii?Q?v312CEy81qcJqwNEUu3sW+/VM+mx1IeiUQLA4je2sIn7a4LFutBdjVfM4vJQ?=
 =?us-ascii?Q?B0VKmk5fufKkglp0ekVljCy9vQ3rRhWANnL1jyc5f6T1j0HTkQT1FJ9+LaEp?=
 =?us-ascii?Q?QN5zS0k4lJlKi0TF85kSVS4FOcHH5xqod9fOQE3BEPhpIWrO7f5A0wBoSFSr?=
 =?us-ascii?Q?7LgSj+l4NsykeZfF3/lfNVEX4HY6jxPpqGIW9zdUwVM=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Is4j3+G39zCIAfInTaLKSCRKAq2VylQ6n54ajETqgXoIzNL7R1YGTcOnZK2o?=
 =?us-ascii?Q?lytg+bbfAaJvc0lXUKzeMo703peDTKVp8EdR6NWqLbsg2+sZCXgQHIyT2uv9?=
 =?us-ascii?Q?WDx3oZII19TmNKD3v7UGIlZ9Wjb6TMcz5ehFQh21YZyEcv6qng6lkPNjq6Lo?=
 =?us-ascii?Q?DO2ap/I7u8pYjCbx5r0AggrC1eSJ/X9rLbaAtdi15XrXgSQ5w53bkQ3hm1Ed?=
 =?us-ascii?Q?92V0BJQ9pLC8x+CK5DA5wWbL/6wHkF3lwtfxsdZv8/K9hMMTpuKRXxIXn/mE?=
 =?us-ascii?Q?z5f3SHyUncTKueFAPaD1wn6RfoSHvGs2cgZHBMxXVQpG/UXW69OA/j1ycdYo?=
 =?us-ascii?Q?EbSfEiHMvXuCpthPi6tvGzY4jtGhkRsne1uHUUzXDRxCgp+vrmKM2/wYhtZF?=
 =?us-ascii?Q?O1KgdTZ5lMHiP9DaFv21Sk/G+AyaQF6g5uUL1gaYK4AihkjRK65lhzV9IEq9?=
 =?us-ascii?Q?uqFxal/hSDOpz1pD/SyFZW9+ryriEebyunR0iU/9aFIubjZGoNlZ2LrjFFeR?=
 =?us-ascii?Q?GY3FZLQrHYk8qAXIkMmuYJU27w1XQVG9AqkWFOaJWghYB2192kZR6NOBTRg8?=
 =?us-ascii?Q?UyEIwowgLn05Vz4pmsv3mvsdSOJayREzqQLia3tmHfMXV2LaJAPJVJBfXz4a?=
 =?us-ascii?Q?TenoWqcvponaIm/aLyDy+jEq3WaQUR6Q/3nMhgEsoJDKQi6ykX6chSGXuM1p?=
 =?us-ascii?Q?Ib+0hNnxr8t+xbX0X2H0RCAGUCesaez57UBBDz1ncIscuYf9iL+k0GZ9P6Jr?=
 =?us-ascii?Q?TY1DZjYgePhPiCw7vNeIS3VxXekiagg/+FYZ+MnsOUywKN/mr80yjwKJlIjV?=
 =?us-ascii?Q?6z00i06v7ahtyM5d2cwqunFJwGaLLmMW4T0x8QdyhoTY06AFY0wXU4aNQ36A?=
 =?us-ascii?Q?fLzyF6xlbI9CxrgQbO3QWvZeUMyP7kNamC+wqxFrbUT3+42ixtdax6WFUhdv?=
 =?us-ascii?Q?/SzoQnTAnEXp+dUmwbjP7Ia9EphsGKue9yOWKQSQLxNTchuP6JrjpImk4/p3?=
 =?us-ascii?Q?xVgsdMYmjU+iG8xUpw8dPOO+z2dH6VBYg4may6oHUmOc5fGz06TbjGzRGL/L?=
 =?us-ascii?Q?nCzRNRWaLz0x3GPtaTZOKRUBTYlQXJDvlN04nQjmvSWIievCoxoSrqRhENU1?=
 =?us-ascii?Q?eHhs+FVRcBQU78GTvFGYPRcfU5DbBeeB5SStNm8pcr8DS7XopcB4+dwO7tW3?=
 =?us-ascii?Q?b4mhkWdHu5pkZeoXZcihknmqKw/G6PZlUmtYpt2iSOia+pD+MQViUV744AOE?=
 =?us-ascii?Q?oXj98Yhk82Gg8MXC/odgYf2ZDFHciPzPcjE2d21TmQJkWmehwVUZybVGVxwP?=
 =?us-ascii?Q?3XsepXin+5Yq6hKC6WFO9Qz5?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1a2df5-e1a2-4f55-0b2e-08d931966f4f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 13:47:23.3575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +47oylT20Uu6pguTuxPuPltyBcF+lfkHqHMvUr8AstSSKVb9k+0c9/gtpfQovjO1HMkOgj4WjZmLpdoi6aQrWe3nj3AA7szEFK768DjZH7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 01:58:09PM +0200, Claudio Fontana wrote:
> On 6/17/21 9:49 AM, Valeriy Vdovin wrote:
> > On Thu, Jun 17, 2021 at 07:22:36AM +0200, Markus Armbruster wrote:
> >> Valeriy Vdovin <valeriy.vdovin@virtuozzo.com> writes:
> >>
> >>> Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
> >>
> >> It's actually a QMP command.  There are no "qapi methods".
> >>
> >>> get virtualized cpu model info generated by QEMU during VM initialization in
> >>> the form of cpuid representation.
> >>>
> >>> Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
> >>
> >> virtual CPU
> >>
> >>> command line option. From there it takes the name of the model as the basis for
> >>> feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
> >>> that state if additional cpu features should be present on the virtual cpu or
> >>> excluded from it (tokens '+'/'-' or '=on'/'=off').
> >>> After that QEMU checks if the host's cpu can actually support the derived
> >>> feature set and applies host limitations to it.
> >>> After this initialization procedure, virtual cpu has it's model and
> >>> vendor names, and a working feature set and is ready for identification
> >>> instructions such as CPUID.
> >>>
> >>> Currently full output for this method is only supported for x86 cpus.
> >>
> >> Not sure about "currently": the interface looks quite x86-specific to me.
> >>
> > Yes, at some point I was thinking this interface could become generic,
> > but does not seem possible, so I'll remove this note.
> 
> 
> Why is it impossible? What is the use case, is it something useful for example for ARM?

CPUID is an x86 instruction that KVM virtualizes and which responses we would like
to retrieve(the usecase) here via this new command.

In ARM there is no single CPUID instruction as such, so to get equivalent information
one would read a list of system registers with say an MRS instruction.

At first I was thinking that it would be easy to fit this into some
sophisticated abstraction of a key-value type with some conditionals,
but then I understood some things:
 - the data types are conceptually different.
 - By the comments in the first versions I've figured out complex code for nothing is
   not welcome here, and this generalization will bring additional complexity and
   confusion 100%.

I said it's impossible to generalize them, well of course actully it is possible to have
one command and one data structure that can represent both, but it would get uglier with
each new architecture added and each new architecture will bring the risk of expanding
the existing data structure potentially breaking old tools.
So what for?

> 
> 
> > 
> >> The commit message doesn't mention KVM except in the command name.  The
> >> schema provides the command only if defined(CONFIG_KVM).
> >>
> >> Can you explain why you need the restriction to CONFIG_KVM?
> >>
> > This CONFIG_KVM is used as a solution to a broken build if --disable-kvm
> > flag is set. I was choosing between this and writing empty implementation into
> > kvm-stub.c
> >>> To learn exactly how virtual cpu is presented to the guest machine via CPUID
> >>> instruction, new qapi method can be used. By calling 'query-kvm-cpuid'
> >>
> >> QMP command again.
> >>
> >>> method, one can get a full listing of all CPUID leafs with subleafs which are
> >>> supported by the initialized virtual cpu.
> >>>
> >>> Other than debug, the method is useful in cases when we would like to
> >>> utilize QEMU's virtual cpu initialization routines and put the retrieved
> >>> values into kernel CPUID overriding mechanics for more precise control
> >>> over how various processes perceive its underlying hardware with
> >>> container processes as a good example.
> >>>
> >>> Output format:
> >>> The output is a plain list of leaf/subleaf agrument combinations, that
> >>
> >> Typo: argument
> >>
> >>> return 4 words in registers EAX, EBX, ECX, EDX.
> >>>
> >>> Use example:
> >>> qmp_request: {
> >>>   "execute": "query-kvm-cpuid"
> >>> }
> >>>
> >>> qmp_response: {
> >>>   "return": [
> >>>     {
> >>>       "eax": 1073741825,
> >>>       "edx": 77,
> >>>       "in-eax": 1073741824,
> >>>       "ecx": 1447775574,
> >>>       "ebx": 1263359563
> >>>     },
> >>>     {
> >>>       "eax": 16777339,
> >>>       "edx": 0,
> >>>       "in-eax": 1073741825,
> >>>       "ecx": 0,
> >>>       "ebx": 0
> >>>     },
> >>>     {
> >>>       "eax": 13,
> >>>       "edx": 1231384169,
> >>>       "in-eax": 0,
> >>>       "ecx": 1818588270,
> >>>       "ebx": 1970169159
> >>>     },
> >>>     {
> >>>       "eax": 198354,
> >>>       "edx": 126614527,
> >>>       "in-eax": 1,
> >>>       "ecx": 2176328193,
> >>>       "ebx": 2048
> >>>     },
> >>>     ....
> >>>     {
> >>>       "eax": 12328,
> >>>       "edx": 0,
> >>>       "in-eax": 2147483656,
> >>>       "ecx": 0,
> >>>       "ebx": 0
> >>>     }
> >>>   ]
> >>> }
> >>>
> >>> Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
> >>> ---
> >>> v2: - Removed leaf/subleaf iterators.
> >>>     - Modified cpu_x86_cpuid to return false in cases when count is
> >>>       greater than supported subleaves.
> >>> v3: - Fixed structure name coding style.
> >>>     - Added more comments
> >>>     - Ensured buildability for non-x86 targets.
> >>> v4: - Fixed cpu_x86_cpuid return value logic and handling of 0xA leaf.
> >>>     - Fixed comments.
> >>>     - Removed target check in qmp_query_cpu_model_cpuid.
> >>> v5: - Added error handling code in qmp_query_cpu_model_cpuid
> >>> v6: - Fixed error handling code. Added method to query_error_class
> >>> v7: - Changed implementation in favor of cached cpuid_data for
> >>>       KVM_SET_CPUID2
> >>> v8: - Renamed qmp method to query-kvm-cpuid and some fields in response.
> >>>     - Modified documentation to qmp method
> >>>     - Removed helper struct declaration
> >>> v9: - Renamed 'in_eax' / 'in_ecx' fields to 'in-eax' / 'in-ecx'
> >>>     - Pasted more complete response to commit message.
> >>>
> >>>  qapi/machine-target.json   | 43 ++++++++++++++++++++++++++++++++++++++
> >>>  target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
> >>>  tests/qtest/qmp-cmd-test.c |  1 +
> >>>  3 files changed, 81 insertions(+)
> >>>
> >>> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> >>> index e7811654b7..1e591ba481 100644
> >>> --- a/qapi/machine-target.json
> >>> +++ b/qapi/machine-target.json
> >>> @@ -329,3 +329,46 @@
> >>>  ##
> >>>  { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
> >>>    'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
> >>> +
> >>> +##
> >>> +# @CpuidEntry:
> >>> +#
> >>> +# A single entry of a CPUID response.
> >>> +#
> >>> +# One entry holds full set of information (leaf) returned to the guest in response
> >>> +# to it calling a CPUID instruction with eax, ecx used as the agruments to that
> >>
> >> Typi: agruments
> >>
> >>> +# instruction. ecx is an optional argument as not all of the leaves support it.
> >>
> >> Please wrap doc comment lines around column 70.
> >>
> >>> +#
> >>> +# @in-eax: CPUID argument in eax
> >>> +# @in-ecx: CPUID argument in ecx
> >>> +# @eax: eax
> >>> +# @ebx: ebx
> >>> +# @ecx: ecx
> >>> +# @edx: edx
> >>
> >> Suggest
> >>
> >>    # @eax: CPUID result in eax
> >>
> >> and so forth.
> >>
> >>> +#
> >>> +# Since: 6.1
> >>> +##
> >>> +{ 'struct': 'CpuidEntry',
> >>> +  'data': { 'in-eax' : 'uint32',
> >>> +            '*in-ecx' : 'uint32',
> >>> +            'eax' : 'uint32',
> >>> +            'ebx' : 'uint32',
> >>> +            'ecx' : 'uint32',
> >>> +            'edx' : 'uint32'
> >>> +          },
> >>> +  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
> >>> +
> >>> +##
> >>> +# @query-kvm-cpuid:
> >>> +#
> >>> +# Returns raw data from the KVM CPUID table for the first VCPU.
> >>> +# The KVM CPUID table defines the response to the CPUID
> >>> +# instruction when executed by the guest operating system.
> >>> +#
> >>> +# Returns: a list of CpuidEntry
> >>> +#
> >>> +# Since: 6.1
> >>> +##
> >>> +{ 'command': 'query-kvm-cpuid',
> >>> +  'returns': ['CpuidEntry'],
> >>> +  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
> >>
> >> Is this intended to be a stable interface?  Interfaces intended just for
> >> debugging usually aren't.
> >>
> > It is intented to be used as a stable interface.
> >> [...]
> >>
> > 
> 
