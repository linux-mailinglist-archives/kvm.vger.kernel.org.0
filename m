Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23D2399C6D
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 10:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCIXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 04:23:13 -0400
Received: from mail-cy1gcc01bn2064.outbound.protection.outlook.com ([52.100.19.64]:57607
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S229479AbhFCIXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 04:23:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV0nvupFMiJ0+ArR/30qj7kcWD9bOOXQAa//c+iKnGIC2cbvEKGaYQFFqKyIQzYW7cOJlDyUC+45cjP/r9aAr/3zybndC1o8MCHzdU2efJkFMdQbW+647uBmg0K6LAnY5pKeNz0faZehwtG+WM7T9S9YsBUREiDySUCW2Drlu0DtedfyABbVpp64hkW7Y88q0HgtHC3kr7byl3jc/owbjeaENzFvyKta5/iQV5G+BsDRamOfaKHArvMwP3cJoY0UVklpsNRY772jp7EVwrXSV4GDgT3oZ0LvCYDFlAaEjx76ZCvxq8nfvA3vVuPJ+Rdrg1L+4Rnlm4aYcW0zjx/XJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWf5Bc0WoYlywTDE3lMFRzBR3XTAtIS0gi1wqtV41VY=;
 b=Q2/T54/Z9Sm5A7GUpkxYOZA0lbtQbG0EulwXRGJiuKi5gNtU1CV3AP3DS1B37VHjWDvDM7kAI3jkFIUG1cMsDJHLNHX29hu5+PZwjIYeVGUQ9uDd072K0tyYvjTFsSiAcny0Ycwr05Ktl6qcYUzf6eB5OvJ3ZEzy1/6rl1MFnINYQNVLPXJXfvbYGclbATQY775PrRaTI5/X4ZQNehOc3ILBHFDzevJlXoMSrNXYGAJGZWdGVO1sjcbo8tRVw1fDu9VAF6lwk95dKRu9RBDdR2zggigjE/qFm50RU2uK74x0HvnF34wQ1tl8YUvvfUdyO7bI8ZkKDJxjV0EMw3yCHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWf5Bc0WoYlywTDE3lMFRzBR3XTAtIS0gi1wqtV41VY=;
 b=GGGjmzbkjzW0PjCBRzRWjOheVi8H+jaf5uC6Gq+4I803dQW4C/Mb2zi5ozzAGTPW+6u86hvCd+iemnYpk2u1GLXA/k+t8p42mXN5oubJZEqQNYw/+pQs/3FN5MohU5rZNIxwQ93QdloaKL3wBUTCJWbZ1PRrXf9RCZLsPsyWWLI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM8PR08MB6419.eurprd08.prod.outlook.com (2603:10a6:20b:316::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 08:21:19 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f%7]) with mapi id 15.20.4195.022; Thu, 3 Jun 2021
 08:21:19 +0000
Date:   Thu, 3 Jun 2021 11:21:12 +0300
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     Eric Blake <eblake@redhat.com>
Cc:     qemu-devel@nongnu.org, Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Subject: Re: [PATCH v8] qapi: introduce 'query-kvm-cpuid' action
Message-ID: <20210603082112.GA473080@dhcp-172-16-24-191.sw.ru>
References: <20210531123806.23030-1-valeriy.vdovin@virtuozzo.com>
 <20210602205102.icdqspki66rwvc3n@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602205102.icdqspki66rwvc3n@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM0PR03CA0001.eurprd03.prod.outlook.com
 (2603:10a6:208:14::14) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-172-16-24-191.sw.ru (185.231.240.5) by AM0PR03CA0001.eurprd03.prod.outlook.com (2603:10a6:208:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Thu, 3 Jun 2021 08:21:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a71ec6e1-df4b-46da-e1c7-08d92668908c
X-MS-TrafficTypeDiagnostic: AM8PR08MB6419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR08MB64197995C9B7349274F15BDE873C9@AM8PR08MB6419.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(39840400004)(366004)(376002)(396003)(346002)(136003)(7416002)(52116002)(7696005)(6506007)(6916009)(83380400001)(478600001)(107886003)(4326008)(2906002)(1076003)(38350700002)(38100700002)(6666004)(5660300002)(33656002)(36756003)(9686003)(16526019)(186003)(26005)(54906003)(316002)(66556008)(66476007)(66946007)(55016002)(956004)(8676002)(86362001)(44832011)(8936002)(30126003);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Lc78FTdQtFo7rtdTcNpmlFf6jt6FappOBcQdA18THif+9lkO8QKhAWuY6lwz?=
 =?us-ascii?Q?CIv0ptxjCZnV/bVlCrRsEflOgJO6Unm+rr1GYI2+pU1m2xOHltSrAY4CNi7q?=
 =?us-ascii?Q?d7E40vTp/7splihUbQ6voOkYd9lRqHdP7JJtR89ELwUz0cbBydfs4iX2gi3L?=
 =?us-ascii?Q?yfTG+3Ymqv+OUfQfsVW+vuhlJ4su0k5vSXP0qZFzlwyDY1SN7BnfagFD1AJZ?=
 =?us-ascii?Q?xbtSDhB33FhPyBfXa22axkywE5RS77vEVdd/HxU1u7YzuVAhE1fOGlJ+0PCQ?=
 =?us-ascii?Q?LUJI/WxzIYaKZ+ihJzI3egFHEZgWlne+Sr+6jP2I6gPQTDHi+f9ZZXmX0/Gi?=
 =?us-ascii?Q?ibYdj4gg/VDqrkJ6+VZaZZr8p18LNa2DHOBF69AEFuQZxEhdAcGdjsNYxSlJ?=
 =?us-ascii?Q?3K4ggSoVyifqKPPbnH1BituaRlD/HdoIytWI6WohB28fgjEWbtM+c+ja1Cid?=
 =?us-ascii?Q?b/p9TXcWy0BXMFX/Nm4q3OYe1MrEs2uYot21gFgIStSD3Y5PLDbHDKboeK4/?=
 =?us-ascii?Q?MP5OQI7kA02rz8GTVIlJanBpQTynRDMjEXw/agf8oCvlIZT+GaNOA5rvNFgb?=
 =?us-ascii?Q?GtaJX6z2OKsKWV5Eufx0cTk2pBgSAlyU65gVjdSYtNNRJexKPfoD/qvBjuMk?=
 =?us-ascii?Q?LP327+fr9QyIXUWIl1aB7+Tord74deqdv1yd77Bh91qzSQhtvUF+upkiyAfG?=
 =?us-ascii?Q?BsM53VDW1A9NyIDDxGWQUiURQit2U4+br9FehUdZbg4LNJuwIHQbPlEzynGM?=
 =?us-ascii?Q?gJ843DaPxJYN2laHlE2dApnNrNYjTaijNMXj9J8SwVAdw3gn2i+fUP3Ek/nj?=
 =?us-ascii?Q?MXqKJWJXRuMfpjyZuoBHkqywv+K5AooM080aEPZ/zVq1ReznGvxyUQHgULAa?=
 =?us-ascii?Q?uwQzasExYGm5AFXwqCD3dW1f/lsOP1s3rpG8DHRmWrhySztN2PYSS+u5rVJ2?=
 =?us-ascii?Q?b3r39xQcL6L91inbu/F0SqFj99KrzE7NGV7IA96lnxI=3D?=
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LFcmAvActGaOjXzn1tbXT91fPpkj1ZE1lhzzmBTkg4nOWkmaSq0Vb1BJUJti?=
 =?us-ascii?Q?IcAWpU/N1VqsAUacAcBPEYjPhPGWOs9BQN5ba43DqwxTECfkmocsxkn3Uk4U?=
 =?us-ascii?Q?UiqAeXpiPObdcOMwCOxwwGM1afWvp2z/K/UYOHQiXbXwiMEaeWSw4rMLxvui?=
 =?us-ascii?Q?hPVparJ6R44rkgLJRfrgamXM6gFc6kR+3TN9dnfmSEHs6ar/N34NrmKg1cyh?=
 =?us-ascii?Q?YAT+rW3t9V8FtGv2GyLJe3sHmRQqAojTcoC9tPcUKjG2V9fKnjFiY8SRW5fa?=
 =?us-ascii?Q?Lqm2d/ZoLqQEOlPyoZYLoxF6rCnyEwltVLgLCbvdJO8bvsPFPgblaf4KAdgJ?=
 =?us-ascii?Q?UZLbhQBCs6q4HsC19OTxCagvrTrH+eOWSMMJTm8hCg3fSzdnPTgtEJjm3NSI?=
 =?us-ascii?Q?wRLk2zEI+HuNII75rk8aR+Zjxz63gnSvJwX52GnYYVdBXSyARnYKcQ5tj7wB?=
 =?us-ascii?Q?ZKLndwTD85Gg4ZPHcdxBzFTI08auu/txeyQu5h+Esg5veZMWaSN4bwjAIpaF?=
 =?us-ascii?Q?gm67kS0NnLx8dCD7khJxU+knwjRB8O3vzfTeQ7ty9hSALUy+WaS8cuhnF5Zu?=
 =?us-ascii?Q?xKH51qzgda5/qhyAYa6GPNZ8EUPL0d+hPIA/7ODTDWGghr5drp0J3YNVARHU?=
 =?us-ascii?Q?YVhN4nH1iq8Y4cmrj3EDonZ4jLSgFtUHGw8IZMP7G+cCvbqlR3IdHlA9QM53?=
 =?us-ascii?Q?e4RNx1kidYaG01zNggyc9zAuYshiATxRXisWhVYDdrAGhsKrgQ08zW0yzFhj?=
 =?us-ascii?Q?vXMA7SSS9U/HNEzDGOgH2xgQDblnRC1Zed3AwO6nVlYtZg7AyLgtA3Iwbv6h?=
 =?us-ascii?Q?PNGubv8+kQBKtDHfpcS1YOuDS5DEZHsubgUagWT+jaOUXlIPEr2UM6bcoHKM?=
 =?us-ascii?Q?EdEh45g5LdhDdvlefnXRuCcwZVcdu40/UIu7Zc62T9bUnwIDtZN/5GtNC8b2?=
 =?us-ascii?Q?9KNq8LB0Z5wlZKFZ2+lHy3BRWeGhj3XvkwOw1BjjeK1QizgumAb00pxPTtiq?=
 =?us-ascii?Q?dY9/vIPJ2FNzLT2SbfCQu/bGkiCFVHuq2mPLpYytkHSk7OXeDC0nLLTGxAIa?=
 =?us-ascii?Q?WkCsUQqsjZ/BO8CdZocLvR/5r1CCEitTan6NKUWqiEQeHyfmC1Vz5d20q7kj?=
 =?us-ascii?Q?vIrQGS4Zk6iS0bu1ECg3AmOEZKSOnPHohS4DIlYox4PoNuXhyil4CNI0/I3K?=
 =?us-ascii?Q?PwCfLcBdWJBUz79gd3dyCBSgSeLMGa0OzG+3CFneQp5ecpob0QWgsihY2hmL?=
 =?us-ascii?Q?3nDKdmwqFk4VYzwQvHEYNYkdbawjsR9ryQbEBh5a9bL9UnNN6nS5etC0zuzi?=
 =?us-ascii?Q?OqX1hq3Gqj3xzAXSrIfRCdui?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71ec6e1-df4b-46da-e1c7-08d92668908c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 08:21:19.5322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvPHC//Sck83tSPPHPi4GpRO71uOpdsrCI/stQH757TgLI0kDLgyNkyffqyawhGOsl+Oe/r9FrbHDv/OSFEx7w2OPGL5jgbI0x28f/+PB7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6419
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 03:51:02PM -0500, Eric Blake wrote:
> On Mon, May 31, 2021 at 03:38:06PM +0300, Valeriy Vdovin wrote:
> > Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
> > get virtualized cpu model info generated by QEMU during VM initialization in
> > the form of cpuid representation.
> > 
> > 
> > Use example:
> > qmp_request: {
> >   "execute": "query-kvm-cpuid"
> > }
> > 
> > qmp_response: [
> >   {
> >     "eax": 1073741825,
> >     "edx": 77,
> >     "in_eax": 1073741824,
> >     "ecx": 1447775574,
> >     "ebx": 1263359563,
> >   },
> 
> JSON does not permit a trailing ',' before '}'; which means you did
> not actually paste an actual QMP response here.
> 

I actually did paste it. Here is a python code-snippet of my test script
that I've used to extract the above response:

  self.__p.stdin.writelines([cmdstring])
  self.__p.stdin.flush()
  out = self.__p.stdout.readline()
  print(out)
  resp = json.loads(out)['return']
  pretty = json.dumps(resp, indent=2)
  print('qmp_response: {}'.format(pretty)) <- this is what I've copied.
> > ---
> >  qapi/machine-target.json   | 43 ++++++++++++++++++++++++++++++++++++++
> >  target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
> >  tests/qtest/qmp-cmd-test.c |  1 +
> >  3 files changed, 81 insertions(+)
> > 
> > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > index e7811654b7..a83180dd24 100644
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
> arguments
> 
> > +# instruction. ecx is an optional argument as not all of the leaves support it.
> 
> Is there a default value of ecx for when it is not provided by the
> user but needed by the leaf?  Or is it an error if ecx is omitted in
> that case?  Similarly, is it an error if ecx is provided but not
> needed?
> 
> > +#
> > +# @in_eax: CPUID argument in eax
> > +# @in_ecx: CPUID argument in ecx
> 
> Should be in-eax, in-ecx.
> 
> > +# @eax: eax
> > +# @ebx: ebx
> > +# @ecx: ecx
> > +# @edx: edx
> > +#
> > +# Since: 6.1
> > +##
> > +{ 'struct': 'CpuidEntry',
> > +  'data': { 'in_eax' : 'uint32',
> > +            '*in_ecx' : 'uint32',
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
> -- 
> Eric Blake, Principal Software Engineer
> Red Hat, Inc.           +1-919-301-3266
> Virtualization:  qemu.org | libvirt.org
> 
