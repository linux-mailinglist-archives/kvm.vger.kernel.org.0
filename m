Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B834001D8
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhICPST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:18:19 -0400
Received: from mail-dm6nam12on2061.outbound.protection.outlook.com ([40.107.243.61]:62945
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229789AbhICPSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:18:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdNIrYst1SB4K7OYrzKBmTWxdxlSY72Z54QjpXIxP7jvU/xHRrqR2MfffN+rqK3EE2Xz1+/mQTfYm4c/j8rikAQem9q4HGcWB1CEMVIEZkGTx9/jyx5hhHQIltmPDBIuWV6hl7V3gexeRPjGEp1k5YNvzqpjHRkEzGd4clgOtJPFwA24v3fkfayS/zaIBE5Jo5Jmhy7h4zfh3qOTJ++oOCwSAJOi2+JGMKx3yYqJHqUh1iQlOiGsjA4KqnU5+W6X4AkVKNHURmT2zLruqKM5k6bx3LszaP1usKLZ3LliZ6vPR3Uc3RhYGwOdsLchyriDBI7cPl/7mG2lMX0xD2X8Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FgtYbPtNTjiDnhBI++lRGmayXMinp8Psr4HkHZIPSAw=;
 b=A7g8sovTE9CnqQOu5sTXNO57VhKF2wq7WZsSAASVlcsSEKeilWJb9SsTxIAEL64aT2L/XC8a9BmReHnfHbTXguGXW/OsIQGeKe60oXv5tISTiWyPfpfOssmNhG+SEFEhbBunnEE0LEzPbC68NlqySGYpK4s0KUR9eKu3N4xrHYYYwmS8NTTI/99vV8o1BrAH/BEfb62mvKuGMYtXI2fe8RRSvWV7068fbG5GFFm41Gtg3o03Fakvx32f0eIqmif7k4C0gVWNd6i5F8EYJ6Z98J6c1yLspJEGC7BSnLvS2QBArcaRU8lMdF8xt7dS3WlALsxXcW73p8tGuVhxfJacWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgtYbPtNTjiDnhBI++lRGmayXMinp8Psr4HkHZIPSAw=;
 b=P7ssXHKFba/PT7vpjBl4isYtHqwChKIFGGR+e55Oc/h6t0c0CXqxhcRmyi8tzwz3LpnesQ3r6kwJRTSqccxj2hRkOyyXG5ogRJ0LwrOAzifaQWqwO7PJKrbAOimZWz+ffBwv2MapLStrxBmRm5aJnrY12JRUxu6gFrcEdGWbblw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4906.namprd12.prod.outlook.com (2603:10b6:610:6a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 15:17:16 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 15:17:16 +0000
Date:   Fri, 3 Sep 2021 10:11:07 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>, qemu-devel@nongnu.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC PATCH v2 01/12] i386/sev: introduce "sev-common" type to
 encapsulate common SEV state
Message-ID: <20210903151107.3chr6s2d3h76bkaw@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-2-michael.roth@amd.com>
 <87pmtsqt02.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmtsqt02.fsf@dusky.pond.sub.org>
X-ClientProxiedBy: BN0PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:408:e4::26) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (165.204.84.11) by BN0PR02CA0021.namprd02.prod.outlook.com (2603:10b6:408:e4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend Transport; Fri, 3 Sep 2021 15:17:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e7097b-5b0c-4d0b-2cfb-08d96eede9d0
X-MS-TrafficTypeDiagnostic: CH2PR12MB4906:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB49063A66BB6F11A138BC512F95CF9@CH2PR12MB4906.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7RuNZbLrVzVE/6HqblAi4/yWgwMsfh9YeaYQNWJehfQq67wGeFiuJryvxPt3lghZHLiycbXDcU1SmRwU3OPtKTdAUiHC/COTz99wSHw7FXp34VOUDqQGh1d95ub9BTZje1i/VXKIl7slvaD9YmWNfS+CJGTxJzUDCbtHCnHllp1lV29E3n0CefBHlFCjcm55+8RIfBLmoQ6KWzVPKNYlPmdnBFrTD3fCxtGWQ6T3HOSxesL3u0/vR2syBE3VZe5StLbceSAaPEYV+QX4YcnvRGFxW0zyYyWfE0ZiA5nm6jC73qSebchcWrDIIOS4vNdHIEVNTMmDrLOuvRcR8ogTJHxYc5ST1lXJ2m9qzSt9/Y4+XvYiS8yobaTdn1bv8gHOmUFarPbuK9rmU+YFFeQeZOGQrRD2VHOjsrQw36U+oLVUIZhi0n0A94bpPBIldAxg5+r70skADuylK1A19kwZP8876Z9xCjks8blRgYFEoBSwbwa2yt/4xlX/NeDd+9tmAwcFSI/hc/cFv9W8fz9F49Ik1KQ/cDveXLaf5B4p0+VZWRMhCSNSbrc0qFztXwAbYVbS3DjM8PnOHlRx+sRSjW8IPUkqMvHyJeB9ypN4kh5WZ+idFhiDD7wgHgYraLzn7HzMAOEUfTNAaQKwqYOtpKrX3kTAqrLyesq7l8b7oYEGjwLpjvDdAx81X1Ao6/vO1cC7UR29m1LVjjM2tYUcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(26005)(186003)(2906002)(2616005)(86362001)(44832011)(956004)(6486002)(1076003)(4326008)(66556008)(83380400001)(6916009)(54906003)(8936002)(316002)(38350700002)(66476007)(36756003)(8676002)(6666004)(6496006)(7416002)(478600001)(52116002)(66946007)(38100700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/B/0pu+VjBffI2E5r02cDYA6hCDBIZ7QMdbo2mW8SBCVmYIWtK4Te5Eaq231?=
 =?us-ascii?Q?Jw/lYD2bjOzovW9i6USrjSIDefcYtHU+bWCgfi4/LkpT68cAsEvBJkm2WeGF?=
 =?us-ascii?Q?urvd10XB3kCNXwhDnKJFjbV925ZXUPPSbHPuAEd7uXBdh+ZDReklkL+vV2SI?=
 =?us-ascii?Q?4qI+6nqihseAiVytOY2j1HD2Su6yQHrCgG2QdPyX5Eta6JWK4qEOxeHrmM8n?=
 =?us-ascii?Q?uv8MPoDcQwfiA9yNNsIq4QAHQ/NVvzV8yM7UIF80M8NqvmlAnaareoebmLZX?=
 =?us-ascii?Q?Pjivt0vVOC06UIQeDQPFG3prF4zO7G55E09JfrptgXx6EqSy7HbnBY1JSTS4?=
 =?us-ascii?Q?WqJofB0pkSzK1MavA9Yqts901er9raXIJHmYjiAu7hyIpwZmP8MdCKthJP6c?=
 =?us-ascii?Q?38j4BzYOTucnLaxX+Ug5pq93OPd0yhuh2TUvK3NOCxtG1bNUpDS0SEMRwzFj?=
 =?us-ascii?Q?yqur1rMjeBXi67sXWU/VIbRMS0+V6x4p+A7IcKUaQuqTSkY9G2hH3BpTLyFp?=
 =?us-ascii?Q?FerzEb484EupmLyP/+XQSJruD8DqFo7MJV6ilQjOCUlO0JC7iFe5yuKEqN2o?=
 =?us-ascii?Q?Sgq3ApY/vxO7kFKallZH4JwIF24b5iQcUk2X4vTineCqHCERdU6F67rf3aw+?=
 =?us-ascii?Q?5UdWNypU71MrgYoboGQgqAEJkLZbzYKJpABIT4vD4r7EbMHLtH4bhZ9g3nzz?=
 =?us-ascii?Q?/W84GSygAhogthB37JekTS/0RU96ESsj+OMeeNfNe1Ffa6t6iCr30n0eppl7?=
 =?us-ascii?Q?b00noZ27qhGV+Sj8beWcw+e5XrkQLbxxMg70rwVtNNaxDtiexuRfb20/vJMa?=
 =?us-ascii?Q?d0liDOJ+4yR2I4O8ElD1yTosjfw8hj0qKNNwybaTIeZZXDJK5XXqwOUgG3AK?=
 =?us-ascii?Q?x53Gs0tI1LQ3Zrt1cjL7VW31R55+Bs59iVODh6Q8812JimPpkGk0W8ZkeRNI?=
 =?us-ascii?Q?8wGXfs9HDUnC48Pb294+QDqpFOVrL06lPKRvr1C+/19mF2YzZUdGTqsAYkZM?=
 =?us-ascii?Q?Q0iKT7qISv9imGABEGyTxU71zLm5kd4kd9FudwwSk4lo+JVn+UqdgRO4QyJd?=
 =?us-ascii?Q?H/dHXVkwr+xwrZEDup2AfLp8bzI/r2qVAvuV+gSBywj0VwUTjPtgiFZkkxPO?=
 =?us-ascii?Q?3X0dGmNJvQ+ELdLcRFc3aIzefzFmLQRcumfpbjymSH7yaf1ZnQqF/HgdYZ71?=
 =?us-ascii?Q?YxYTyNJc+1/s4De/adkVw5+tbT5TiuuG78kZ2GbHaAoUb8MJeTYwnU2fS50s?=
 =?us-ascii?Q?aHy23ulCfUHIFvhAVZQp9wUgchZNvlbp4heubNknudHJM/SNg5GxYUxVxwWc?=
 =?us-ascii?Q?+YWel2Oj+lhTHE2FW+17HfkB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e7097b-5b0c-4d0b-2cfb-08d96eede9d0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 15:17:16.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u2AEeZVJIJFW3bzWtJIsPj/znOEnDkVNQnVxGNbfVuxYsia5OxxDtwmqcAxd2cb9g1GJnL+KssGE3uZGwsIwLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4906
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 04:18:21PM +0200, Markus Armbruster wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > Currently all SEV/SEV-ES functionality is managed through a single
> > 'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
> > same approach won't work well since some of the properties/state
> > managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
> > rely on a new QOM type with its own set of properties/state.
> >
> > To prepare for this, this patch moves common state into an abstract
> > 'sev-common' parent type to encapsulate properties/state that is
> > common to both SEV/SEV-ES and SEV-SNP, leaving only SEV/SEV-ES-specific
> > properties/state in the current 'sev-guest' type. This should not
> > affect current behavior or command-line options.
> >
> > As part of this patch, some related changes are also made:
> >
> >   - a static 'sev_guest' variable is currently used to keep track of
> >     the 'sev-guest' instance. SEV-SNP would similarly introduce an
> >     'sev_snp_guest' static variable. But these instances are now
> >     available via qdev_get_machine()->cgs, so switch to using that
> >     instead and drop the static variable.
> >
> >   - 'sev_guest' is currently used as the name for the static variable
> >     holding a pointer to the 'sev-guest' instance. Re-purpose the name
> >     as a local variable referring the 'sev-guest' instance, and use
> >     that consistently throughout the code so it can be easily
> >     distinguished from sev-common/sev-snp-guest instances.
> >
> >   - 'sev' is generally used as the name for local variables holding a
> >     pointer to the 'sev-guest' instance. In cases where that now points
> >     to common state, use the name 'sev_common'; in cases where that now
> >     points to state specific to 'sev-guest' instance, use the name
> >     'sev_guest'
> >
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  qapi/qom.json     |  34 +++--
> >  target/i386/sev.c | 329 +++++++++++++++++++++++++++-------------------
> >  2 files changed, 214 insertions(+), 149 deletions(-)
> >
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index a25616bc7a..211e083727 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -735,12 +735,29 @@
> >    'data': { '*filename': 'str' } }
> >  
> >  ##
> > -# @SevGuestProperties:
> > +# @SevCommonProperties:
> >  #
> > -# Properties for sev-guest objects.
> > +# Properties common to objects that are derivatives of sev-common.
> >  #
> >  # @sev-device: SEV device to use (default: "/dev/sev")
> >  #
> > +# @cbitpos: C-bit location in page table entry (default: 0)
> > +#
> > +# @reduced-phys-bits: number of bits in physical addresses that become
> > +#                     unavailable when SEV is enabled
> > +#
> > +# Since: 2.12
> > +##
> > +{ 'struct': 'SevCommonProperties',
> > +  'data': { '*sev-device': 'str',
> > +            '*cbitpos': 'uint32',
> > +            'reduced-phys-bits': 'uint32' } }
> > +
> > +##
> > +# @SevGuestProperties:
> > +#
> > +# Properties for sev-guest objects.
> > +#
> >  # @dh-cert-file: guest owners DH certificate (encoded with base64)
> >  #
> >  # @session-file: guest owners session parameters (encoded with base64)
> > @@ -749,21 +766,14 @@
> >  #
> >  # @handle: SEV firmware handle (default: 0)
> >  #
> > -# @cbitpos: C-bit location in page table entry (default: 0)
> > -#
> > -# @reduced-phys-bits: number of bits in physical addresses that become
> > -#                     unavailable when SEV is enabled
> > -#
> >  # Since: 2.12
> >  ##
> >  { 'struct': 'SevGuestProperties',
> > -  'data': { '*sev-device': 'str',
> > -            '*dh-cert-file': 'str',
> > +  'base': 'SevCommonProperties',
> > +  'data': { '*dh-cert-file': 'str',
> >              '*session-file': 'str',
> >              '*policy': 'uint32',
> > -            '*handle': 'uint32',
> > -            '*cbitpos': 'uint32',
> > -            'reduced-phys-bits': 'uint32' } }
> > +            '*handle': 'uint32' } }
> >  
> >  ##
> >  # @ObjectType:
> 
> External interface remains unchanged, as far as I can tell.
> 
> For the QAPI schema:
> Acked-by: Markus Armbruster <armbru@redhat.com>

Thanks!
