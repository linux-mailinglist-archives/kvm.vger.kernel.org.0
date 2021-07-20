Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E883D023C
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 21:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhGTTCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 15:02:07 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:50529
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229554AbhGTTB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 15:01:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwvMQ4V0KZklGP2EQ3Eky4xN8bdwJa6+OmXpHa7yjDy6sGTV1inr2zukdNLwYO43r0h4cl7at9exr8E5XpUcyysWBQTRKn84xF0+jMCKertkLxkeeFiSCft8f037OR6XF+D4r/UvisFNAgwJyY2QVxoXEcy1jWCwGxkprFcYl12TH9ujDhcK5gpAO1deV1R8CUowyf73SW699sANTsqrd8RF2sX0XQmgu4i0JIaPeNU3akwhFg6bc4VLI0WXB/Jchn7XROwlj5u2Lnfvoa5zQ4xPqfMUgoGulfLodqwcDSVoDqRoivdBmDAu1Ip/iO9KOBFSU1pqSnWBP6LVuViVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxQ+D5CbxONi4hIPUlXYl/984y7Io33oqCyobhdciM0=;
 b=X8ihJWV1Yj8OmJVe9V6vEXhGc+awWfc7Mfrw0AknQsUoerqUhfM9Wx5qz0DhA9bWDMSetZyWdUG7PhU2q99Tv4ULkJuFi3yK8RyFZJyf5bHAJRWsdMYCvG4RLm2g4pS0tjG6BRcbo3Dq8eONxlA1vSTzHiLGQkp5/gw+BtOjXYBOrq9kYuG0L6wjg9SFa4BKfp984hphNbRocSLZCsCU7LpWirQZ9xpTqma591YGOKgMQwTcYzo2VqnILFW8OpCcP69yPtRvZ36z2P4U74Zm6JRxggJt7LaRqt5+19n77FbmEbTvE12EMgdtrhucbQljWXFfyMGirhV7XFnqLIF7Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxQ+D5CbxONi4hIPUlXYl/984y7Io33oqCyobhdciM0=;
 b=5P8LmKUECAnatdjRLSYcIUwt+LufJWSVp9E/+rWlIUh39TT6H87Xjul+QNHJha8I5aae31oss9+WiF124pn+G3dk4sP0oS19WB5GMkKYoP51pD0WZyuLyqdKvm3nwwvVrIMUdGEy2Vcx/NifGqhEw/bciJpbpybffdNdeCqlQlQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Tue, 20 Jul
 2021 19:42:29 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%9]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 19:42:29 +0000
Date:   Tue, 20 Jul 2021 14:42:12 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Markus Armbruster <armbru@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 2/6] i386/sev: extend sev-guest property to include
 SEV-SNP
Message-ID: <20210720194212.vjmsktx2ti3apv2d@amd.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
 <87h7gy4990.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7gy4990.fsf@dusky.pond.sub.org>
X-ClientProxiedBy: SA9PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:806:a7::7) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA9PR10CA0002.namprd10.prod.outlook.com (2603:10b6:806:a7::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 19:42:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77f043ec-d94d-4324-0c23-08d94bb68256
X-MS-TrafficTypeDiagnostic: CH2PR12MB4277:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4277D39CD43F8D6C480D161F95E29@CH2PR12MB4277.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TUQuG1lW/YHlBy6AO5Ikwa3v6zMRw8DH+Fy6AeEMJh5oxPyE4G9kyIc/kQjAQSRT1x6ZbCD7X9TMNkZoqmiz3FmSQlPEx65hQWiZorHpuexB5BwMuQX5BlNWnv+On/MrV2XZ5EktPju+uNKta8cLcsbopcSCIzLHdr2Z0q4mQDLQvQ97w+AOH6ngQ+2yM2724JkHw3OAdQs39W0BCMzCGd0L9iYCq8bp24PwT3E47eCitHAj07T+NFiQ5+oW33/Qw4E/XO9AIS9YcP0kBI9XPxEg7mQnvYyQ75R2vHi4Vpcx5oQc08iT2ktVGVLgqwBwwlMB1a9hWd2Krsq7OK/UamawLmdr2hIZ4Wo4CvbObfGuHztvB5WS8nGxCuZIdLMDPyVXKnAvOKg7rJA2hHaUnX9f06hOHgjxz8FIho7M4eMWQPG+nzZJKYBJoEnHhcEjJnVG19HE5zGjHQHODgy4IKy8m96lcwL2704Dk3Qnx+waZVtv5lXN/3fjP5/uhzbUZJreP6M/Njl4UaiPJR92LvTQc+c7cawdkgfS0zOTiYh98Ammor0N22DTdWBBohjRBDIncZDI13UQgMzYMtkns1lAyCY+KILpIatebu5T74Ab9UbrVfLs+aaqRJoYMncZWz1GdC6HtrNvvR6Hf3Rsw/o4EyKLZbE6HIp445frUgzpXcgwleF7OsCtrX7UkCM12OyLeWQNYewWbQTJ6I0Qm8OWD1OSr7IKmdHsfR+6enZCzptxir6JeuBgjMOZxgw8yOeCoJhykyw4WFGKOVDqC3/STHTwLxZKsGa8dqBa7WY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(4326008)(6666004)(478600001)(66946007)(36756003)(186003)(7416002)(8676002)(66556008)(8936002)(86362001)(83380400001)(110136005)(54906003)(66476007)(6486002)(5660300002)(956004)(966005)(26005)(2616005)(6496006)(52116002)(2906002)(44832011)(316002)(1076003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jUEiv9GmhDVHyNpIOnZLtfUEqkGcrTbE8wIp4rf4DEOqikAhycroHkSCcJRT?=
 =?us-ascii?Q?LaUtArgFzA1sksiUQYEuZNQdaLYED5t/GtwCHx3iFtEJLWLL0WbS8ZgjeH9k?=
 =?us-ascii?Q?Cu6Cd6pZSpRQ+CnH2nDvfIpkP7Cyj8TTnE+d9Zx3opq/l0xz47uxMe7UaqGN?=
 =?us-ascii?Q?2RuP8sf+F+ls/dOrZNDZX2y089+IfmVly5O/Wlk157hTyIrdrTOdTJeu4FCt?=
 =?us-ascii?Q?O9iuwcYerDyOsnfvbq0KBuT7tJtjxSKxgQIklF9BbGf+7seorpQEuT+il/bK?=
 =?us-ascii?Q?11JmlSWq64GyZ/y6h4Jo85AqeCDHdMfiHfmH2tBqCMyGjuZLWtOnn38z1NXH?=
 =?us-ascii?Q?IPVyNvK1j0sEjRBrG7LLKnvF8ILGNp+Y0whKypgY6G0yxJbFGkuRxmq9NoKQ?=
 =?us-ascii?Q?iEECrujdkS0t5Q+93KN49W1wUD9viW8ydAD1uecbCtmZO8ubAhd32Sj/wh7N?=
 =?us-ascii?Q?jvz5PMxMLKhM1oJFBLqfVnz9Iqm1dyn7++MDPtUS++AIxFPs3xEkKrGoAP39?=
 =?us-ascii?Q?WnhCTLFcvTpX9gvXPxmp8Ne9Q3Qp+BBu1KEroa2KrUglT44meAKcDHPU4YyA?=
 =?us-ascii?Q?3bhklXsXVF29olRPRq4DScS1IoWTOWD0UAp0mrErSrMGtj3OiqWHR541eTOM?=
 =?us-ascii?Q?dmmeCqTSuctfQTlb0DHHicqkh8f9vFQKsaslvdlgKKRLExwB7v7kuY6bbPXg?=
 =?us-ascii?Q?ckubAxxJezrHYiK9SM2nkbf6GHRUTVOjU0SEWpKtgy1GOOCWN+eaKb89TexY?=
 =?us-ascii?Q?7wPpNJECWtvq6DfQouNbBhUWgYpQ8zkNMkssF45Sq3YXWQgNOZYB9sNBnP4H?=
 =?us-ascii?Q?cLzPFXS2Erq5dvRT24wgWxNh1Ham/lrrbA7xAUHHA3DjcBQfPAB8JZAElrLG?=
 =?us-ascii?Q?XuFZ/qI8AdUEyQfgv9EKZi9DQSWLx0vHC3/TfbfSg2FntsBIP4L7Q/LS06Mm?=
 =?us-ascii?Q?17DtMrjACOP3pMC+7LJlcXL8F4SB3gMCGKiE5dsN+l0TCvAMaNr4bUWSn4/V?=
 =?us-ascii?Q?MdxZvav/81aBjWlBOsQtAOHTIZW1hWrncgMOoqm/MpcDIgff8fuDL6W7yrl5?=
 =?us-ascii?Q?PsCbPDLKPSo6l/GZRlE4EJ/3tPhZL+pL+3AEiugO/9U3crHq3QwgLxkN88p7?=
 =?us-ascii?Q?Tz812Lp03GqoVs+C7eRlC76bHfHWhn1LMea/U3MuGEpk5J47lSCPtWYhe3a6?=
 =?us-ascii?Q?FjETrkhs0D4bfmAyKbB310gIar8ZRqMfMTwQpN3g8fHyTMQNzk9K2qGn6w6Z?=
 =?us-ascii?Q?M4KlzZZsZOK+37Kq0SOtEY1suHN+t90W8T1TDhGSnqJOeHAicDX2TRzr/7iE?=
 =?us-ascii?Q?fsET1AYK9iJn9kpYOpdQpvzg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f043ec-d94d-4324-0c23-08d94bb68256
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 19:42:29.5271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: spqPzsncBBF6pTAdG+OoZUmyLbvcsGHxuU4nO6IVk+YlxaIHQAJGHtBZsrivElIK7G1pSqXWbub0Io7LMeGdXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 03:46:19PM +0200, Markus Armbruster wrote:
> Brijesh Singh <brijesh.singh@amd.com> writes:
> 
> > To launch the SEV-SNP guest, a user can specify up to 8 parameters.
> > Passing all parameters through command line can be difficult. To simplify
> > the launch parameter passing, introduce a .ini-like config file that can be
> > used for passing the parameters to the launch flow.
> >
> > The contents of the config file will look like this:
> >
> > $ cat snp-launch.init
> >
> > # SNP launch parameters
> > [SEV-SNP]
> > init_flags = 0
> > policy = 0x1000
> > id_block = "YWFhYWFhYWFhYWFhYWFhCg=="
> >
> >
> > Add 'snp' property that can be used to indicate that SEV guest launch
> > should enable the SNP support.
> >
> > SEV-SNP guest launch examples:
> >
> > 1) launch without additional parameters
> >
> >   $(QEMU_CLI) \
> >     -object sev-guest,id=sev0,snp=on
> >
> > 2) launch with optional parameters
> >   $(QEMU_CLI) \
> >     -object sev-guest,id=sev0,snp=on,launch-config=<file>
> >
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> 
> I acknowledge doing complex configuration on the command line can be
> awkward.  But if we added a separate configuration file for every
> configurable thing where that's the case, we'd have too many already,
> and we'd constantly grow more.  I don't think this is a viable solution.
> 
> In my opinion, much of what we do on the command line should be done in
> configuration files instead.  Not in several different configuration
> languages, mind, but using one common language for all our configuration
> needs.
> 
> Some of us argue this language already exists: QMP.  It can't do
> everything the command line can do, but that's a matter of putting in
> the work.  However, JSON isn't a good configuration language[1].  To get
> a decent one, we'd have to to extend JSON[2], or wrap another concrete
> syntax around QMP's abstract syntax.
> 
> But this doesn't help you at all *now*.
> 
> I recommend to do exactly what we've done before for complex
> configuration: define it in the QAPI schema, so we can use both dotted
> keys and JSON on the command line, and can have QMP, too.  Examples:
> -blockdev, -display, -compat.
> 
> Questions?

Hi Markus, Daniel,

I'm dealing with similar considerations with some SNP config options
relating to CPUID enforcement, so I've started looking into this as
well, but am still a little confused on the best way to proceed.

I see that -blockdev supports both JSON command-line arguments (via
qobject_input_visitor_new) and dotted keys
(via qobject_input_vistior_new_keyval).

We could introduce a new config group do the same, maybe something specific
to ConfidentialGuestSupport objects, e.g.:

  -confidential-guest-support sev-guest,id=sev0,key_a.subkey_b=...

and use the same mechanisms to parse the options, but this seems to
either involve adding a layer of option translations between command-line
and the underlying object properties, or, if we keep the 1:1 mapping
between QAPI-defined keys and object properties, it basically becomes a
way to pass a different Visitor implementation into object_property_set(),
in this case one created by object_input_visitor_new_keyval() instead of
opts_visitor_new().

In either case, genericizing it beyond CGS/SEV would basically be
introducing:

  -object2 sev-guest,id=sev0,key_a.subkey_b=...

Which one seems preferable? Or is the answer neither?

I've also been looking at whether this could all be handled via -object,
and it seems -object already supports JSON command-line arguments, and that
switching it from using OptsVisitor to QObjectVisitor for non-JSON case
would be enough to have it handle dotted keys, but I'm not sure what the
fall-out would be compatibility-wise.

All lot of that falls under making sure the QObject/keyval parser is
compatible with existing command-lines parsed via OptsVisitor. One example
where there still seems to be a difference is lack of support for ranges
such as "cpus=1-4" in keyval parser. Daniel had a series that addressed
this:

  https://lists.gnu.org/archive/html/qemu-devel/2016-09/msg08248.html

but it doesn't seem to have made it into the tree, which is why I feel like
maybe there are complications with this approach I haven't considered?

Thanks!

-Mike

> 
> 
> [1] https://www.lucidchart.com/techblog/2018/07/16/why-json-isnt-a-good-configuration-language/
> 
> [2] Thanks, but no thanks.  Let's make new and interesting mistakes
> instead of repeating old and tired ones.
> 
