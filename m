Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FEA395A44
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 14:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhEaMST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 08:18:19 -0400
Received: from mail-he1eur04hn0245.outbound.protection.outlook.com ([52.100.18.245]:9573
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhEaMSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 May 2021 08:18:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctZ4h4SQqxF1ab9gwRUbPQ+R+5x5vW76CLD3uw8fr4WC4gN00sVokCuFzU36Y6hRFgdQfPJBhCquZDs+4xlKp2v2TRdPlT6I1mg1sQNVqM1VuZtuDCt1JCJkfCiaTIorDr5F1jZpkgV+ev+SyXCFrp7Ehm1XugjRgybF/yGKjm9umctkCtPUFhixZ0EgL+ls8kVZCIXRRdJoZQcrgJ+6YuCYAhu0eG4eR7AvlBVTJ/zFW0PlLogYciQ4rTFSPGCyEFi7c+/Mw5Uke/IkM/XtNVXOqwLEqQOb5r0CLSqQ05uio20IGsRBp8ILaDawkpZ0DsaP/k1cDEt82EbYq6kEEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1baY99UpynxKWaccSvqBnpho7PIVsEUlwx9WVefCR/8=;
 b=CKeovVJ7oo+cL+eRsjUQwkrxbQz1rKudJs4r9RADhvEKT/uD+1D5j5ZZQ1doYQ8oR9Ic1Swzu+ocdV18iekkutReDwIbPp/nuf+eTeWJLNUOrORg3wVqywShaoFLtorKd7075g2VlEwvZxTGBdHgLpPWA4kMk1RZPH9s/RtdmULLp/D/8KMhQeZ4QEfRwvn9uPZjbVD/xx7rAsOLkeWp9okVbl1CII1tkFg87abx61h3WiZjmLuIvUdxILAwW0TXAwbm9TWyHpztSV25SYGoIN9uF8ClQ3UWQ91/DbCfKnOphNmpBCT4/cw8/l0+t0qZ8DilU9XEmnBRzFpOR+gcYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1baY99UpynxKWaccSvqBnpho7PIVsEUlwx9WVefCR/8=;
 b=hBFrPVjkEed6UlgUwA8esA4wgl8lKk6pd4lyhxxjQSRykWtSDRAYsyoAxSQKwj7nkttE1tsfk1RyY0f4kgqjDLLymwMHoYQhv+J2xZ987pdUsOTMlBmBfbRQzC080twkYvr8v7RIA5VKlydwhe8+EEn6tCo1KhDSd8eBhB9ZD2w=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6883.eurprd08.prod.outlook.com (2603:10a6:20b:30a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Mon, 31 May
 2021 12:16:27 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 12:16:26 +0000
Date:   Mon, 31 May 2021 15:16:19 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v7 1/1] qapi: introduce 'query-cpu-model-cpuid' action
Message-ID: <20210531121619.GA453713@dhcp-172-16-24-191.sw.ru>
References: <20210504122639.18342-1-valeriy.vdovin@virtuozzo.com>
 <20210504122639.18342-2-valeriy.vdovin@virtuozzo.com>
 <20210526214424.ndk2dwu2crae64y7@habkost.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526214424.ndk2dwu2crae64y7@habkost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR01CA0178.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::47) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by AM0PR01CA0178.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Mon, 31 May 2021 12:16:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 724ac60b-40f2-4c04-cfb2-08d9242dea01
X-MS-TrafficTypeDiagnostic: AM9PR08MB6883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB6883F932E1403523D9CC07AD873F9@AM9PR08MB6883.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(346002)(366004)(396003)(39830400003)(136003)(8936002)(30864003)(66476007)(66946007)(9686003)(86362001)(2906002)(1076003)(66556008)(7416002)(107886003)(956004)(52116002)(7696005)(83380400001)(8676002)(6506007)(36756003)(26005)(6916009)(5660300002)(38350700002)(16526019)(55016002)(4326008)(6666004)(44832011)(316002)(478600001)(54906003)(186003)(33656002)(38100700002)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?S+87cNKufhEiUPnu1YIvJtpADhymdct5K7cwJnFwYM/Ao+UO7l08HdXmF6q2?=
 =?us-ascii?Q?D5wCUL3TAFA1wiKbJZn7u+T3WxN9YE1nev0nSJEeCoygSVdgA2+d/Ufbds3M?=
 =?us-ascii?Q?8ZxoeyDyMYnXgIgURXJf335LQBEHRnvfEOKxezmTmCkLq2Pey5v31jxLOBXH?=
 =?us-ascii?Q?I3crxCezZdGqYV8zNe2FESaqHlHk3BlU+cEZ4R/sZJKnkZYVXeV0FZl2h0lL?=
 =?us-ascii?Q?Uvk2HZwLZsg0Zf2Yf8350csyIQyDx/ZN2E0AUz44siBF1D41sQsnr1SWUZxo?=
 =?us-ascii?Q?qW+PI6EVaung/sJ5nF5o3JEVJkM3IJz1eExoe4N7aX/A+gHe2GUj1W0iN/it?=
 =?us-ascii?Q?ij+0rm80HtSAPzD//CMOeWDyJQpVTFIx3lECokOpW72r/XMWkClHtif4YZgW?=
 =?us-ascii?Q?cAjWAstfcfvsz7U9JIRSMiFMfKeDI9MjCPekTEpsiDPE80whTAhTy296/a+7?=
 =?us-ascii?Q?zV8Wo9RbNhP5Il4MvbzYKe7BesDa1OlJZSDqWptzV0+QM64M88M2fykcY3cT?=
 =?us-ascii?Q?xIIjCspG9Wff6Rbi4UipTfJpZzBJMqoxbrR9AhxZSqyle/ULibMYqHV3V3LK?=
 =?us-ascii?Q?PjoxVGl1GZZVk4cL5f1C7MkeoKRJNzwpIJwF9c93B6CoUmjGFlucXXw8L1jo?=
 =?us-ascii?Q?0robb9lMvTSmRhMUdmIaEy01tFD0238dTU4ZMOAXvk7D6sfPj7cqf+OjI20U?=
 =?us-ascii?Q?I+fJ3Ne5DFjzEzl2gPmPkoKkEQfvBsHZzB5gjVH8e4eqwpf+eGFDWzsZaIgg?=
 =?us-ascii?Q?hoJwDC1cf4d59AfrhAz12GQm+PjtXdkky3eoqbUJ+PwV/MhFL3eYLDejtQCX?=
 =?us-ascii?Q?hjvdhoBeEFcXZJVTlKD+/9yIGegou9sNXkdNvZm2bfdvhPKiAeW+PyYrf1kM?=
 =?us-ascii?Q?3oa7TmJ9NnfpupSHhxx0nRsK3au0PXRpvawkYTFa/inxtjrp7fLU/Vd9eG0k?=
 =?us-ascii?Q?ghZ5Tj6WTxdkFITQ/VcIyloDS4i4Z4kkY6CCF+GZ1ek=3D?=
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a6z8iaVQN3BqADT7vlHeqENi4GD7DNVY7IZtnPMIlvfK33p2jgZbnls0IQc5?=
 =?us-ascii?Q?u2tIKYRw5k1BH4iYOm3AMxI3mGQu2s+WXnq8XQmsgqT2Ucp80uwajQam8fzf?=
 =?us-ascii?Q?XLoO6YNrZhLEFR3YmeoyeFFIH++9tS+GfDUVxh3iUdAi2CPTnNn83rM3XsLd?=
 =?us-ascii?Q?OM10DRxqLhsIDAG/erMOKP1iZXEpZPTx4VSb1gFeeiu/UiSyFf/9Gde/gkOf?=
 =?us-ascii?Q?KdMo7mIss93sxynQzpwFsPJfnOmOYFArqK1mlbrvGENZ3l7u2mTfZo0wpuSj?=
 =?us-ascii?Q?tlzaQYDSDj6kji4rOjSeEH1NsU0CErX1LzsCF1gvd78MnckNKgNOKRlfbMp4?=
 =?us-ascii?Q?sHUylpLeFqJiEbzh6LhrBG4adeW2an8qRVjEwtVT7Y2Pzivo/pOFe3BvgVkf?=
 =?us-ascii?Q?jbjMzDC+H04lxxgvbcdQnaFqX5YPsq9muhZr6XvTnNU8oA+vpl5IjjlSfRWx?=
 =?us-ascii?Q?Th4si76/Dlpe4W0Or8SVE3jBia4jX2+Rif2nb0gbVGjMKMKn2x0Ckbe+zSNG?=
 =?us-ascii?Q?jfJcJcQcVTICpja6xgK8HSBI2nrFASpX7HwrbburW17ncXxg1oiD2UuEwLPV?=
 =?us-ascii?Q?z5WtugbylFhiRTdwekbQUEK9uMBCjNEbs416OuBBihc5oi70FLCHRU3/TAVg?=
 =?us-ascii?Q?WpPzVl2MWeodkp4lLhpSAe0egE4RTYTlMzsXhyOYI0zm7MZsSkqOONYfc3vx?=
 =?us-ascii?Q?2bVc/dsyf06EuzX+PVQgFTJkl6YXc7gxn4zsjrS2zFSStICQKtWw8khpfYaY?=
 =?us-ascii?Q?J7ODCIEa7k8ifOs04ln/Peb7B6/bKxIbHMPhcg1huP7F31lIno7d1a1Q4qm9?=
 =?us-ascii?Q?j0KtXx3kp2Rql2vuVIR29YCRbDLtAZgpiec1mjrFZC7xy/eshv3zd7CqtbBo?=
 =?us-ascii?Q?ZP9MR9QIDWVGKFg0Yig7rrEsc/Pn88Bu/yjKc09+ixIufyLzdbkyZiYBBtzY?=
 =?us-ascii?Q?kygv2aeujDjTJYOr8AOh/C+TeayE/pDphBN+MarCAW4abZMGdlVvkLGjawRb?=
 =?us-ascii?Q?E6/lNbr2IajIIEhFl3jia51LEqiESINmkT8fRnJowgser9Es91TyIii+UMnC?=
 =?us-ascii?Q?uxvKVRRmYo3hyQfojkAqx932iVkU6y4FcErw0Z5ClaMgdz1y3+DJLgcQGav/?=
 =?us-ascii?Q?xflXsnj80agHcZlAsyvpjGdvqoP1QTedkN317gALlPFS5cOp3tUAzvHs+hgg?=
 =?us-ascii?Q?EDPh5VHdT+qMgVXCsTNg9SqcsUCCk7A/8s9MYHvbfEIqYqmnRFjUWFtopsmH?=
 =?us-ascii?Q?/0u3kc4uf1uVl8p0hPzGwzaS4drK21TOZ6zQDPtr7So+uRvkLUInIFmK+uis?=
 =?us-ascii?Q?4tUg14dklCEp+ijbywjg28QC?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724ac60b-40f2-4c04-cfb2-08d9242dea01
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 12:16:26.9115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qdWMDa8mc+h00frln6u8UAARxec+xDRjh2CkjZkZLkXPTmMnpG/h5aAg9qzwpw9vg9RBS6Q4OhPo912gDzURhpZOGCLFWmZyULyikfHmdF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6883
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 05:44:24PM -0400, Eduardo Habkost wrote:
> On Tue, May 04, 2021 at 03:26:39PM +0300, Valeriy Vdovin wrote:
> > Introducing new qapi method 'query-cpu-model-cpuid'. This method can be used to
> > get virtualized cpu model info generated by QEMU during VM initialization in
> > the form of cpuid representation.
> > 
> > Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
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
> > 
> > To learn exactly how virtual cpu is presented to the guest machine via CPUID
> > instruction, new qapi method can be used. By calling 'query-cpu-model-cpuid'
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
> > return 4 words in registers EAX, EBX, ECX, EDX.
> > 
> > Use example:
> > qmp_request: {
> >   "execute": "query-cpu-model-cpuid"
> > }
> > 
> > qmp_response: [
> >   {
> >     "eax": 1073741825,
> >     "edx": 77,
> >     "leaf": 1073741824,
> >     "ecx": 1447775574,
> >     "ebx": 1263359563,
> >     "subleaf": 0
> >   },
> >   {
> >     "eax": 16777339,
> >     "edx": 0,
> >     "leaf": 1073741825,
> >     "ecx": 0,
> >     "ebx": 0,
> >     "subleaf": 0
> >   },
> >   {
> >     "eax": 13,
> >     "edx": 1231384169,
> >     "leaf": 0,
> >     "ecx": 1818588270,
> >     "ebx": 1970169159,
> >     "subleaf": 0
> >   },
> >   {
> >     "eax": 198354,
> >     "edx": 126614527,
> >   ....
> > 
> > Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
> 
> This breaks --disable-kvm builds (see below[1]), but I like the
> simplicity of this solution.
> 
> I think it will be an acceptable and welcome mechanism if we name
> and document it as KVM-specific.
> 
> A debugging command like this that returns the raw CPUID data
> directly from the KVM tables would be very useful for automated
> testing of our KVM CPUID initialization code.  We have some test
> cases for CPU configuration code, but they trust what the CPU
> objects tell us and won't catch mistakes in target/i386/kvm.c
> CPUID code.
> 
> [1] Build error when using --disable-kvm:
> 
>   [449/821] Linking target qemu-system-x86_64
>   FAILED: qemu-system-x86_64
>   c++  -o qemu-system-x86_64 qemu-system-x86_64.p/softmmu_main.c.o libcommon.fa.p/hw_char_virtio-console.c.o [...]
>   /usr/bin/ld: libqemu-x86_64-softmmu.fa.p/meson-generated_.._qapi_qapi-commands-machine-target.c.o: in function `qmp_marshal_query_cpu_model_cpuid':
>   /home/ehabkost/rh/proj/virt/qemu/build/qapi/qapi-commands-machine-target.c:278: undefined reference to `qmp_query_cpu_model_cpuid'
>   collect2: error: ld returned 1 exit status
> 
> 
I'll add if defined(CONFIG_KVM) to this qmp method description.
> > 
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
> > KVM_SET_CPUID2
> >  qapi/machine-target.json   | 51 ++++++++++++++++++++++++++++++++++++++
> >  target/i386/kvm/kvm.c      | 45 ++++++++++++++++++++++++++++++---
> >  tests/qtest/qmp-cmd-test.c |  1 +
> >  3 files changed, 93 insertions(+), 4 deletions(-)
> > 
> > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > index e7811654b7..ad816a50b6 100644
> > --- a/qapi/machine-target.json
> > +++ b/qapi/machine-target.json
> > @@ -329,3 +329,54 @@
> >  ##
> >  { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
> >    'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
> > +
> > +##
> > +# @CpuidEntry:
> > +#
> > +# A single entry of a CPUID response.
> > +#
> > +# CPUID instruction accepts 'leaf' argument passed in EAX register.
> > +# A 'leaf' is a single group of information about the CPU, that is returned
> > +# to the caller in EAX, EBX, ECX and EDX registers. A few of the leaves will
> > +# also have 'subleaves', the group of information would partially depend on the
> > +# value passed in the ECX register. The value of ECX is reflected in the 'subleaf'
> > +# field of this structure.
> > +#
> > +# @leaf: CPUID leaf or the value of EAX prior to CPUID execution.
> > +# @subleaf: value of ECX for leaf that has varying output depending on ECX.
> 
> Instead of having to explain what "leaf" and "subleaf" means,
> maybe it would be simpler to just call them "in_eax" and
> "in_ecx"?
> 
> > +# @eax: eax
> > +# @ebx: ebx
> > +# @ecx: ecx
> > +# @edx: edx
> > +#
> > +# Since: 6.1
> > +##
> > +{ 'struct': 'CpuidEntry',
> > +  'data': { 'leaf' : 'uint32',
> > +            'subleaf' : 'uint32',
> 
> I would make subleaf/in_ecx an optional field.  We don't need to
> return it unless KVM_CPUID_FLAG_SIGNIFCANT_INDEX is set.
> 
> > +            'eax' : 'uint32',
> > +            'ebx' : 'uint32',
> > +            'ecx' : 'uint32',
> > +            'edx' : 'uint32'
> > +          },
> > +  'if': 'defined(TARGET_I386)' }
> > +
> > +##
> > +# @query-cpu-model-cpuid:
> 
> I would choose a name that indicates that the command is
> KVM-specific, like "query-kvm-cpuid" or "query-kvm-cpuid-table".
> 
> > +#
> > +# Returns description of a virtual CPU model, created by QEMU after cpu
> > +# initialization routines. The resulting information is a reflection of a parsed
> > +# '-cpu' command line option, filtered by available host cpu features.
> 
> I don't think "description of a virtual CPU model" is an accurate
> description of this.  I would document it as "returns raw data
> from the KVM CPUID table for the first VCPU".
> 
> I wonder if the "The resulting information is a reflection of a
> parsed [...] cpu features." part is really necessary.  If you
> believe people don't understand how "-cpu" works, this is not
> exactly the right place to explain that.
> 
> If you want to clarify what exactly is returned, maybe something
> like the following would work?
> 
>   "Returns raw data from the KVM CPUID table for the first VCPU.
>   The KVM CPUID table defines the response to the CPUID
>   instruction when executed by the guest operating system."
> 
> 
> 
> > +#
> > +# Returns:  @CpuModelCpuidDescription
> > +#
> > +# Example:
> > +#
> > +# -> { "execute": "query-cpu-model-cpuid" }
> > +# <- { "return": 'CpuModelCpuidDescription' }
> > +#
> > +# Since: 6.1
> > +##
> > +{ 'command': 'query-cpu-model-cpuid',
> > +  'returns': ['CpuidEntry'],
> > +  'if': 'defined(TARGET_I386)' }
> > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > index 7fe9f52710..edc4262efb 100644
> > --- a/target/i386/kvm/kvm.c
> > +++ b/target/i386/kvm/kvm.c
> > @@ -20,6 +20,7 @@
> >  
> >  #include <linux/kvm.h>
> >  #include "standard-headers/asm-x86/kvm_para.h"
> > +#include "qapi/qapi-commands-machine-target.h"
> >  
> >  #include "cpu.h"
> >  #include "sysemu/sysemu.h"
> > @@ -1464,16 +1465,48 @@ static Error *invtsc_mig_blocker;
> >  
> >  #define KVM_MAX_CPUID_ENTRIES  100
> >  
> > +struct CPUIDEntriesInfo {
> > +    struct kvm_cpuid2 cpuid;
> > +    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
> > +};
> 
> You don't need this new struct definition, as
> (&cpuid_data.cpuid.entries[0]) and (&cpuid_data.entries[0]) are
> exactly the same.  a kvm_cpuid2 pointer would be enough.
> 
> > +
> > +struct CPUIDEntriesInfo *cpuid_data_cached;
> > +
> > +CpuidEntryList *
> > +qmp_query_cpu_model_cpuid(Error **errp)
> > +{
> > +    int i;
> > +    struct kvm_cpuid_entry2 *kvm_entry;
> > +    CpuidEntryList *head = NULL, **tail = &head;
> > +    CpuidEntry *entry;
> > +
> > +    if (!cpuid_data_cached) {
> > +        error_setg(errp, "cpuid_data cache not ready");
> > +        return NULL;
> 
> I would return a more meaningful error message.  Nobody except
> the developers who wrote and reviewed this code knows what
> "cpuid_data cache" means.
> 
> A message like "VCPU was not initialized yet" would make more
> sense.
> 
> 
> > +    }
> > +
> > +    for (i = 0; i < cpuid_data_cached->cpuid.nent; ++i) {
> > +        kvm_entry = &cpuid_data_cached->entries[i];
> > +        entry = g_malloc0(sizeof(*entry));
> > +        entry->leaf = kvm_entry->function;
> > +        entry->subleaf = kvm_entry->index;
> > +        entry->eax = kvm_entry->eax;
> > +        entry->ebx = kvm_entry->ebx;
> > +        entry->ecx = kvm_entry->ecx;
> > +        entry->edx = kvm_entry->edx;
> > +        QAPI_LIST_APPEND(tail, entry);
> > +    }
> > +
> > +    return head;
> > +}
> > +
> >  int kvm_arch_init_vcpu(CPUState *cs)
> >  {
> > -    struct {
> > -        struct kvm_cpuid2 cpuid;
> > -        struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
> > -    } cpuid_data;
> >      /*
> >       * The kernel defines these structs with padding fields so there
> >       * should be no extra padding in our cpuid_data struct.
> >       */
> > +    struct CPUIDEntriesInfo cpuid_data;
> >      QEMU_BUILD_BUG_ON(sizeof(cpuid_data) !=
> >                        sizeof(struct kvm_cpuid2) +
> >                        sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
> > @@ -1833,6 +1866,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
> >      if (r) {
> >          goto fail;
> >      }
> > +    if (!cpuid_data_cached) {
> > +        cpuid_data_cached = g_malloc0(sizeof(cpuid_data));
> > +        memcpy(cpuid_data_cached, &cpuid_data, sizeof(cpuid_data));
> 
> You are going to copy more entries than necessary, but on the
> other hand I like the simplicity of not having to calculate the
> struct size before allocating.
> 
> 
> > +    }
> 
> Now I'm wondering if we want to cache the CPUID tables for all
> VCPUs (not just the first one).
> 
> Being a debugging command, maybe it's an acceptable compromise to
> copy the data only from one VCPU.  If the need to return data for
> other VCPUs arise, we can extend the command later.
> 
> 
Yes.
As long as there is no specific demand for having multiple VCPU's cached
we can get away with less code. But extending this command would be pretty
straightforward.
> >  
> >      if (has_xsave) {
> >          env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
> > diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
> > index c98b78d033..f5a926b61b 100644
> > --- a/tests/qtest/qmp-cmd-test.c
> > +++ b/tests/qtest/qmp-cmd-test.c
> > @@ -46,6 +46,7 @@ static int query_error_class(const char *cmd)
> >          { "query-balloon", ERROR_CLASS_DEVICE_NOT_ACTIVE },
> >          { "query-hotpluggable-cpus", ERROR_CLASS_GENERIC_ERROR },
> >          { "query-vm-generation-id", ERROR_CLASS_GENERIC_ERROR },
> > +        { "query-cpu-model-cpuid", ERROR_CLASS_GENERIC_ERROR },
> >          { NULL, -1 }
> >      };
> >      int i;
> > -- 
> > 2.17.1
> > 
> 
> -- 
> Eduardo
> 
