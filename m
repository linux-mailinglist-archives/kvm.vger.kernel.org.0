Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089DE3D1A99
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 02:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhGUXbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 19:31:41 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:12224
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229536AbhGUXbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 19:31:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDyZxmPQK1fDQt/JhjBbNgkR38UbnmIS1U4MjXvWmn/qzL/B8Sz/XytfRS+xxSyFlHE+sQhbe4tVPUSx45Mw7ZpuJPNG1g/KNmTkunFhW3OEnlmQnu/XN7prrJCiTO8bHE0Y2ie5rCQKqiKjSorVfstvL+Xw6E2yKa4QeXofweMyDHYZ/qh+pUxo+WvkH0zef5uRUIDGW8UjNzmIQ3r4jYBPY0TTECoBrPfMkyo8rXGXdQE5BnHPyhqxyGUzoKDMC9/8LnH+0VeuZuI0tYLuhC2x3RseVZPiVMcgs//AgFphsohdlrrL7sTyd59wLvbr8fw3mBz7o6wMWnRw3Fbr9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwxDe4QcHNcYusMJNLMkvL8WqNdwy35Ckq3iBCaqEFk=;
 b=W4HM01ytP4n4Va+XsZfIkukuuUNs1p+7W8eVRmerVFSLUUzhXbMfjRUKfU3SUz9SCqvvR/ffnSKjYp1wADO+3ITrW4MPI2Q7ZX9ozE4eITyO5pADIPuKq1PVbH5mMQyQXggH0lfhdEkYzE/WhM6O5gH81omQoAzAcWVeqZFWzshPID65t+VIBoZ4asAKxSbBJ5IGsno8nvmx980ST8ekkaYWcpKjlknobO7UxKfhTxVtmLIc3e57vLw3bLDRzAer8w+RSoVhs6L5iyIQWg58XoKaSGyRdaaFMw6OTMGMQIagO0zfUOritxYS8xwVIjngBJRjLzPhzkzcs+aCFGS5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwxDe4QcHNcYusMJNLMkvL8WqNdwy35Ckq3iBCaqEFk=;
 b=yeU2RwKZvda3vYP4Wwssu/Kg+B8H3/goK+ITYqKddQsAuEw3J1EpyAOpgBkvS9qzk9jsPzVf089iheXna67mWXgwcofSmcLKCDxl1cU5ARpihKzzx6B9GmedCIS2WbbvrI8CXMkCl1D8q3svbiwFr+LlvtSBJLRHycyjU2vfkTI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3910.namprd12.prod.outlook.com (2603:10b6:610:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 00:12:11 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%9]) with mapi id 15.20.4352.025; Thu, 22 Jul 2021
 00:12:11 +0000
Date:   Wed, 21 Jul 2021 19:02:59 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org,
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
Message-ID: <20210722000259.ykepl7t6ptua7im5@amd.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-3-brijesh.singh@amd.com>
 <87h7gy4990.fsf@dusky.pond.sub.org>
 <20210720194212.vjmsktx2ti3apv2d@amd.com>
 <YPdFfSI7RdXOSnhE@redhat.com>
 <87h7gnbyqy.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7gnbyqy.fsf@dusky.pond.sub.org>
X-ClientProxiedBy: SN4PR0501CA0109.namprd05.prod.outlook.com
 (2603:10b6:803:42::26) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.78.25) by SN4PR0501CA0109.namprd05.prod.outlook.com (2603:10b6:803:42::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.14 via Frontend Transport; Thu, 22 Jul 2021 00:12:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea2e685e-a64e-4f81-cfca-08d94ca559ba
X-MS-TrafficTypeDiagnostic: CH2PR12MB3910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB39108706F98062106506B06095E49@CH2PR12MB3910.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kreqa+q1ItvJKqx9ILPnKQeoAOZfiJDeQDHNDAnVAARjPN3cwHUsDX0JSJFQKYYRWkyRgPKjmgnHa7rZ5MJwFw7m+ZfqBB+q92FyrbZCtIxS/01ssmGh1WFGQq2CdKKdZdLEGXG+eo7bZJQCyxASbvS6yMw350zd0ncwVBAJJoqF9S9gnGTXNuB4G19c7w2A9iEoAmbF6h+m254Qif6O09YwScmmEiZY2H4IIgMqNH7NVtshvQ3CLbxZI7Dj4JVVMlAgrI53OUJ71ivlzijoo/83izYJIh2SAQprhmjbNTwvzRMC/IMrZ26NtwXTerD/RCV2XdOuLIVOts3lv0EAavKvTwUPbYkF/EPgXIPcV7VHkU/dRTHwhD5r2NXg8SJ4KB+NAD7SRwCoPMn6zMrgTk1fgR7RMfxU7/MnbpmtF6K53O80SFAp/jtRUeA8YruKTZQPldXc8PNZMqzTCF/ra06MC3rekQl187QY9szDCQGvmBXLntuM0M0runY/7TFglQluy5BV+86+Jkt4wXiuSLcPoZp0AQg4rAD1mQ3MzXL33r0KHKAjqnfZCvHLY0CgNLejTSVAsa7yOGznfj3fX6nudPW6Z19vXJS2qTcVV/CGFES9L5ZbkrffAskR4v+Bo0zauC/E28pJdEZo8RZOmZ9KMFZSrm9B/f4TDJpOrPAhoSrvhCIDUPcIY0tsuheCOY6d0u/aqJSH4Ppx4WkxPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(2906002)(86362001)(38100700002)(6666004)(956004)(1076003)(66556008)(66476007)(7416002)(5660300002)(52116002)(66946007)(38350700002)(54906003)(316002)(6496006)(478600001)(8676002)(2616005)(6916009)(26005)(186003)(6486002)(36756003)(83380400001)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Fcsz8adqyMq7alAmczBCi3CUjVwLlJ4FfovZXcvK0U5uaxRayRgsWqKd0s?=
 =?iso-8859-1?Q?Au5N+2D9kryfoAd6y6ou6i3GKdBein/awpXTvMkzWca/iYVrqXW7okEv8Y?=
 =?iso-8859-1?Q?JBX6HNgsuRE82Cut+eUNKLxraC+d2AxbK9zwcD5UxWVVeUrCD3B1IkJ2Ps?=
 =?iso-8859-1?Q?Axjb6yqrABlamJ0DDQ38NdiZOSSwfO4+J2tHajJiCVovVA83kQAVfP5rrw?=
 =?iso-8859-1?Q?7wBJRAglwK7SKBainosiLyT3Yoq3SXC8YQnbexl22nQZ6JCxW0BqIK38QK?=
 =?iso-8859-1?Q?zMFve7QrGi3Grmv+qW9VgFdV9xXsK2gCPD4a+lZmTlp638milOfJSJhGc7?=
 =?iso-8859-1?Q?ax4HKNQzUuQArMEbc2Je/dyaI1adUxaU2/Sm7q/uKQfguYP/JnhewhbPDq?=
 =?iso-8859-1?Q?4Wonz0w0GlDLqJbU0oqwYOEUX/bVwq8GCons2NKD9q2BGZxnn4ETnUjyp4?=
 =?iso-8859-1?Q?FEX0AzzwswMP1Pqv5SOYv0kRPyobiFqxbJzvK1R5Wy0oCNKTFmKbAjA0fc?=
 =?iso-8859-1?Q?1UzpM96BZs/p5XcNaCKcUfvpCUHUR400ftUw3/NeT+GWVpuTqx6WshUZSl?=
 =?iso-8859-1?Q?e1ZJyCheW2HQRk+m8G3y0ESR76VQ/EsugCzBwOolRKAq5tCcWufO8Mcncd?=
 =?iso-8859-1?Q?MLuqJuYq2HONIdwbeFPWlTZ683dERi5Hr2bpVk1YCqBSPHExuQ50VNWbTK?=
 =?iso-8859-1?Q?RHfVWxyCCvth41oNsSIVcVYRNtdLyAYoxranbRwNmftXEWrvvE/W8lsCya?=
 =?iso-8859-1?Q?V8TssH0qSx+TF36fulZ8254flHGtl+Yg7ply3Yt6+gZNEz9FB1Ch93SppH?=
 =?iso-8859-1?Q?/+tPMXb3e5prUMzDr1U981+y7B9WyegohB55gjCd4fE/yIzOxP2Ku/kVyE?=
 =?iso-8859-1?Q?rb/DhjyiyuUz4Kxes5zjwXCbSBP19LxMSems50iOAor5b7rHQBFtlbBH0V?=
 =?iso-8859-1?Q?zP+zUeD2zknLoya6Y+KKWpX4vlMGYKeJYkmfRb6lgpP+9DB10jO+tuhHfH?=
 =?iso-8859-1?Q?LLyzPhDhEgfbLYhwNGtXLFNLLcfGoD8gDucbdPAM2uE94Ny+z4cB4fwR67?=
 =?iso-8859-1?Q?ub34fUGjSEeLcwAmOvLM8BHV3wFHKJVUu71wnfnYwHbLdgVK29zTgkrypi?=
 =?iso-8859-1?Q?F7KI+ZualjfXu/EuimSNaLOim3M22/rRFFC18RQKzRhvMJLKwT3+qnrQWH?=
 =?iso-8859-1?Q?wTQcZF+3qPNgfoRb3985Pi2aEEYpTjt4QnxdjBmfcMAHeHzvMH40Cnnl8B?=
 =?iso-8859-1?Q?wAh0Ts7rW3erJW5/HPpXJHXuRsaK+ycq59d/puVRDiG8Lvjtx0nmuIHqrq?=
 =?iso-8859-1?Q?I0CrglJuQp5FE8tSX4H7mnWkJU/sG+cwd8gQyUximft0Uq/nuAHsPS+LQE?=
 =?iso-8859-1?Q?uwY6kzy83Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2e685e-a64e-4f81-cfca-08d94ca559ba
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 00:12:11.1571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zG0ReZFQ42nYNi3+Xz4zD4c1FIM+UeZ0J+avXmTQVlKljK1D8MDd4bp+iCH6Euy3LDO7W8Um4TKak2TGOH23sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3910
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021 at 03:08:37PM +0200, Markus Armbruster wrote:
> Daniel P. Berrangé <berrange@redhat.com> writes:
> 
> > On Tue, Jul 20, 2021 at 02:42:12PM -0500, Michael Roth wrote:
> >> On Tue, Jul 13, 2021 at 03:46:19PM +0200, Markus Armbruster wrote:
> 
> [...]
> 
> >> > I recommend to do exactly what we've done before for complex
> >> > configuration: define it in the QAPI schema, so we can use both dotted
> >> > keys and JSON on the command line, and can have QMP, too.  Examples:
> >> > -blockdev, -display, -compat.
> >> > 
> >> > Questions?
> >> 
> >> Hi Markus, Daniel,
> >> 
> >> I'm dealing with similar considerations with some SNP config options
> >> relating to CPUID enforcement, so I've started looking into this as
> >> well, but am still a little confused on the best way to proceed.
> >> 
> >> I see that -blockdev supports both JSON command-line arguments (via
> >> qobject_input_visitor_new) and dotted keys
> >> (via qobject_input_vistior_new_keyval).
> 
> Yes.  Convenience function qobject_input_visitor_new_str() provides
> this.
> 
> >> We could introduce a new config group do the same, maybe something specific
> >> to ConfidentialGuestSupport objects, e.g.:
> >> 
> >>   -confidential-guest-support sev-guest,id=sev0,key_a.subkey_b=...
> >
> > We don't wnt to be adding new CLI options anymore. -object with json
> > syntx should ultimately be able to cover everything we'll ever need
> > to do.
> 
> Depends.  When you want a CLI option to create a single QOM object, then
> -object is commonly the way to go.

So if I've read things correctly the fact that this is a question of how to
define properties of a single QOM object lends itself to using -object rather
than attempting a new -blockdev-like option group, and as such if we
want to allow structured parameters we should use pure JSON instead of
attempting to layer anything on top of the current keyval parser.

> 
> >> and use the same mechanisms to parse the options, but this seems to
> >> either involve adding a layer of option translations between command-line
> >> and the underlying object properties, or, if we keep the 1:1 mapping
> >> between QAPI-defined keys and object properties, it basically becomes a
> >> way to pass a different Visitor implementation into object_property_set(),
> >> in this case one created by object_input_visitor_new_keyval() instead of
> >> opts_visitor_new().
> 
> qobject_input_visitor_new_str() provides 1:1, i.e. common abstract
> syntax, and concrete syntax either JSON or dotted keys.  Note that the
> latter is slightly less expressive (can't do empty arrays and objects,
> may fall apart for type 'any').  If you run into these limitations, use
> JSON.  Machines should always use JSON.
> 
> qobject_input_visitor_new_str() works by wrapping the "right" visitor
> around the option argument.  Another way to provide a human-friendly
> interface in addition to a machine-friendly one is to translate from
> human to the machine interface.  HMP works that way: HMP commands wrap
> around QMP commands.  The QMP commands are generated from the QAPI
> schema.  The HMP commands are written by hand, which is maximally
> flexible, but also laborious.
> 
> >> In either case, genericizing it beyond CGS/SEV would basically be
> >> introducing:
> >> 
> >>   -object2 sev-guest,id=sev0,key_a.subkey_b=...
> 
> That's because existing -object doesn't use keyval_parse() + the keyval
> QObjct input visitor, it uses QemuOpts and the options visitor, for
> backward compatibility with all their (barely understood) features and
> warts.
> 
> Unfortunate, because even new user-creatable objects can't escape
> QemuOpts.
> 
> QemuOpts needs to go.  But replacing it is difficult and scary in
> places.  -object is such a place.
> 
> >> Which one seems preferable? Or is the answer neither?
> >
> > Yep, neither is the answer.
> 
> Welcome to the QemuOpts swamp, here's your waders and a leaky bucket.

*backs slowly away from swamp* :)

So back to the question of whether we need structured parameters. The
main driver for this seems to be that the options are currently defined
via a config file, which was originally introduced to cope with:

a) lots of parameters (8)

   - not really that significant compared to some other objects/options.

b) large page-size parameters

   - mainly applies to 'id_auth', which could be broken out as individual
     files/blobs and passed in via normal file path string arguments
   - already how we handle dh-cert-file and session-file

c) separating SNP-specific parameters from the base sev-guest object
   properties

   - could possibly be done with a new 'sev-snp-guest' object, which
     would also help disambiguate stuff like the 32-bit sev/sev-es
     'policy' arguments from the 64-bit version in SNP, and can still
     re-use common properties like 'cbitpos' via some base object
   - maybe some other benefits, need to look into it more.

If they aren't any objections I'll take a stab at this early next week.
Will be on PTO until then, but will follow-up soon as I'm back in office.

> > Ultimately I think we've come to the conclusion that QemuOpts is an
> > unfixable dead end that should be left alone. Our future is trending
> > towards being entirely JSON, configured via the QMP monitor not the
> > CLI. As such the json support for -object is a step towards the pure
> > JSON world.
> 
> QemuOpts served us well for a while, but we've long grown out of its
> limitations.  It needs to go.
> 
> QemuOpts not providing an adequate CLI language does not imply we can't
> have an adequate CLI language.  The "everything QMP" movement is due to
> other factors.  I have serious reservations about the idea, actually.
> 
> > IOW, if you have things that work today with QemuOpts that's fine.
> >
> > If, however, you're coming across situations that need non-scalar
> > data and it doesn't work with QemuOpts, then just declare that
> > -object json syntax is mandatory for that scenario. Don't invest
> > time trying to improve QemuOpts for non-scalar data, nor inventing
> > new CLI args.
> 
> I agree 100% with "don't mess with QemuOpts".  That mess is complete.
> 
> Whether a new CLI option makes sense should be decided case by case.
> 
> "Must use JSON" feels acceptable for things basically only management
> applications use.

Yah, it's great that QAPI/object_add already takes care of the management
side of things, but giving up the option of using human-readable/non-JSON
command-line args is still a tough pill to swallow, at least as a developer
where I know some significant portion of my life will be spent debugging
parser errors from bash.

*backs up too far, walks into adjacent swamp with no waders*

If more cases where structured arguments for Objects really make sense and
thus necessitate JSON-only, it would be great if there was some developer
tool, e.g. scripts/qemu-cmdline-helper-devs-only that could handle this
translation to JSON or QMP and maybe serve as a test-bed for this awesome
new cmdline syntax that provides all the expressiveness of QAPI and could
abstract away the QemuOpts-specific option formats while still allowing
for periodic reworks.

Or maybe -readconfig is the better starting point? Or is it too late for
that already? -x-readconfig2 ? :)

*disappears into swamp*
