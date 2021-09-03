Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BF14001DA
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349583AbhICPSX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:18:23 -0400
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:7719
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239566AbhICPSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:18:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiL7oRRxX/L6BMtyE7oWmad9ZYAbUuMoninCOqclDKzkk9MpyxAmXBR7Q33whRcva5EDzp2gu8JBJgfZDQsPjkq1B85R+eUuq5xflyN6wuj47I3HSh92zpZdgzPxScoFPmNVCKBdTauWjzBkf6bScalWSeM2+M8snMlw6rd2nkPgzLpSeO6Z+kDboByuo0jhnsE1D3NVjvkPkidHIMJlA7BnQET6rjtXbWmXqH6+ckZmYxf0v+LkZUNQSp/5zAUdvdL6m26FxjBztm54pl+NBhzNVghr+vD00TwSucgU63r3UIxlQsIg8rjVFP3Lsz9TKhiGOYJrwnFokMJibPmJIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dV2xkct3QWh8h/vhHZZx7nLNOTHYT84ZZ0pgpsQaTi8=;
 b=h9u+z874Ikjv634Y5D7EDYWeSJPM/+3VsSKEfPPHfTVmrPOdnq1txglFN+gyIjU0VgMANfCUhG7AKKrY8is7Seu2l8enhCWP2bLSU1j8urkGHUXuiydrHNpiGtNDOZSteYoNLvS1nU+cR8jiJnTutG+I/x2s8NdKByUu7+jANow77VFuwBs/aAsZsqI6hWs19CQpRscyaNsdQYWweIXCd+Nk+qX87mvtxI3xY7BAlGOHwyoMLpfOozSTOoKah/LAc2SPCoBU6ByQ4JRdik9fsQRpirIoh1Ldj+nxadWoxgCHIdLWnu53RG77Ru7zBvYygWOhWEwQa6jzh0NVKC+oew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV2xkct3QWh8h/vhHZZx7nLNOTHYT84ZZ0pgpsQaTi8=;
 b=h5M0/QIRT+7BpEHSyDebGhZuINCu+28Uxhps2LPkTLPuR/lOv/uQQaYUuiQoa4QeCVKlmiqaRqWfWG5tFiOSF8kq8CxhkShCYcl3+1bdUEK4GhwVWNRbc/WANDm+QSdCXWXkp9c5jluZe0I6WubKFN73gtdmQClEif5uBzXAtWE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Fri, 3 Sep
 2021 15:17:20 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 15:17:20 +0000
Date:   Fri, 3 Sep 2021 10:15:43 -0500
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
Subject: Re: [RFC PATCH v2 03/12] i386/sev: introduce 'sev-snp-guest' object
Message-ID: <20210903151543.5wfmjygthzbuhqfq@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-4-michael.roth@amd.com>
 <87bl5cqsi8.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bl5cqsi8.fsf@dusky.pond.sub.org>
X-ClientProxiedBy: BN0PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:408:e4::26) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (165.204.84.11) by BN0PR02CA0021.namprd02.prod.outlook.com (2603:10b6:408:e4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend Transport; Fri, 3 Sep 2021 15:17:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f9726dd-77d3-4343-b2f2-08d96eedec9d
X-MS-TrafficTypeDiagnostic: CH2PR12MB4200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB42002B7356BE608F6FB7D99395CF9@CH2PR12MB4200.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ip38lIBAYOs75S2iOWTd5M5no+kFHPpFh9rkPN9XUtvu5aZHYyRS/KaIbTlDZEkda1lqKhC4tfKfeX9vM8fG+Yq40mdUnsDXwFiKhZlg0p4cwKZhHp5/OgjWhGyWOyPrx4cGo1bC5jyuiMsBadp+JlzBD8F8do4ycL33Nac3zGYrfXe2w61V3ZecD6yYeNV9LHL1siI01c5aISp8mjNZDL1E8fQ77fENmbIy6D+BedQraTsQyopjG3/ubob0F9KqMu8H6k8ehDzm4OeIXPo8S/odwMUeHMlE7/hO0E9DcSR4Mf7qPk9cjN8doSCLG9ICp5rSJCc1nz+Y2e7PhWX5bWR3z8lHJ8YgkLllawMFG2JMcp/7wAnkhnccRkPh8teMCiOEI8oD0oURFKCtiuXimNMkTeo//2P7/tecwrviK5MjTz50bEj3v3vvlq3wOpcIjEd3ak0FLXa/JRY2MkZrI1KvK0c+VQN2v7WPLcavtD6RcHS87u1/P8ckZ65YWLQEQ2ZCOlzektCvRngmS5a0exAtoeOJSN/KPzLfRgaQmRjuJBytGATC+abG+cEZZFVutC0i2Ih/o7E9fmHHvQ7OIzejHETYzWe6PIt8EGD6h2Mpg5yboLsNpHoGPeYFPme75KyRLGMTyqZfiBrGRjdMDs9eIvyAU98LMmgqF2EhokCT3YW+iTKYQcIZooppAE0TZ6OZapLvvpOS15KmqfXPzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(83380400001)(30864003)(26005)(54906003)(6916009)(7416002)(1076003)(4326008)(6486002)(186003)(66556008)(8936002)(66946007)(36756003)(66476007)(44832011)(956004)(2616005)(316002)(5660300002)(2906002)(52116002)(478600001)(38100700002)(38350700002)(6496006)(86362001)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+tnvhuRvPXO+/qr/9jsiobidNsxw/E9TiWVSaGGh+I0uSLBdWCMeBafv+KaM?=
 =?us-ascii?Q?548gpava285V+v/YTlxdCmREfEozZmPzpM/+b0CIOK/m8fgiSIdBmdaq+2tw?=
 =?us-ascii?Q?6a6/Rt9YwfN5BXl5qso5SGj6k6Tm2+ynPLpGLHIeDqvvqd88mWtVYxmdXX+S?=
 =?us-ascii?Q?PrVKWgoxd2Or13Rs5yM2h9YgQhMzZQJF4/blOxCXK8fg+NSAEw2qy1+v12b2?=
 =?us-ascii?Q?ldV0YQNU6HI0u2w2uew+LMscS3s4twD5kJ9xeOXx2laspS5GJgZtXaXjDkoY?=
 =?us-ascii?Q?ngDuoQA5yFCMaFTL9LD0XaemcXon1rJ8yOTtqfW2/ZkXB/ZDQM6aCb0IRVQ5?=
 =?us-ascii?Q?qv3YpFDNeEYqApBQ43R6IroWCDd2f5fFlBhuaNdROq7TIYtecG0FqbylcxQN?=
 =?us-ascii?Q?MjCQ2cbtQOGnADWKCyqE7Zj2zrFwAC4zJ9yGthITPTLxj6Atk4mpPn8RDT0X?=
 =?us-ascii?Q?mFx84o9V1Vp6Y7d3Sbu1SCHM1iYwghfACkyfxABACdBEAE2vBscUOkYi+UFZ?=
 =?us-ascii?Q?NokhEZ5OJDKQeAtlqPH3FORiIa17bEl5k4gH0rkXFD7eqHtX1iGAmUhdTUuI?=
 =?us-ascii?Q?oGbkPwdLE9xwMuiN86Ykc/q99E72uG6trYPeEIqjyNu8ZuizohbgA4lv7RQf?=
 =?us-ascii?Q?gB7Zqm6GUj/qlMJGRnA9M6b/aeX2xTIk2ekK/R3VZ+qw5sYdgnVsKN88rXpB?=
 =?us-ascii?Q?wrcHRjvbBMIkpaOkISfSpwWPA1QXNTgeLBR5lFVqizEF5YGk/7qOnD4c12E2?=
 =?us-ascii?Q?cTQKWURYp5EvlAC3T1vSC2v6rl4OvPjTNU51dPF3HVRP2fJmshB7uDgZtzAE?=
 =?us-ascii?Q?PaXllWnKCNFnd+bS10I3ItGrNq8lsWqb66sShQj1UxhCgJjGwsBkFAC31fj4?=
 =?us-ascii?Q?wZmgtnbbYfr7rPZkPwiUyh+8WfruMC1OQsbk/OnU0BBxao39t0wXUn4gckr4?=
 =?us-ascii?Q?SHsK8wgFXOjF0pumKbUnUBMO80+JHLgrZQGW0YJYTYlUHugwEjuEJ1NWTPwD?=
 =?us-ascii?Q?RPKGxxy67YzNLuvjx6ojfxLiC1In4qyL2rabVEBnmQqJ7hvu97gqIPHmbv/2?=
 =?us-ascii?Q?7V8GXot2ZQT/DH2OwTdPCS2Rx8PRRTrryNby/iwSkkOW66vGIoyIfwr4tQr9?=
 =?us-ascii?Q?CyBmuCO1226Zd8vwlcM3DnZluEwg7WMrzR+SEPW9NR3Y24oj7jyDOhJt2CVV?=
 =?us-ascii?Q?GJ4McFw7cnOtvlm5A6DUIG51Itbm4X+X0ZWolKm4KQvkV/PEVR8PeRTyDp+5?=
 =?us-ascii?Q?o85n/2anDKTkXKACx/SoSZTMY1ETU/wB2AoOhHY91T9WS6wyA5jg4MW6HZ7z?=
 =?us-ascii?Q?0Hpa0IevjhHyKb2vwxbmdtKJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9726dd-77d3-4343-b2f2-08d96eedec9d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 15:17:20.7181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RQsY1Rrj/S9O8JGnpWTQheUuA8qlcTup1GriRSCfql90VM4j9oVjsTT0jZof0qXMyDsOGHPBMHPU+U4XkH96Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 04:29:03PM +0200, Markus Armbruster wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > From: Brijesh Singh <brijesh.singh@amd.com>
> >
> > SEV-SNP support relies on a different set of properties/state than the
> > existing 'sev-guest' object. This patch introduces the 'sev-snp-guest'
> > object, which can be used to configure an SEV-SNP guest. For example,
> > a default-configured SEV-SNP guest with no additional information
> > passed in for use with attestation:
> >
> >   -object sev-snp-guest,id=sev0
> >
> > or a fully-specified SEV-SNP guest where all spec-defined binary
> > blobs are passed in as base64-encoded strings:
> >
> >   -object sev-snp-guest,id=sev0, \
> >     policy=0x30000, \
> >     init-flags=0, \
> >     id-block=YWFhYWFhYWFhYWFhYWFhCg==, \
> >     id-auth=CxHK/OKLkXGn/KpAC7Wl1FSiisWDbGTEKz..., \
> >     auth-key-enabled=on, \
> >     host-data=LNkCWBRC5CcdGXirbNUV1OrsR28s..., \
> >     guest-visible-workarounds=AA==, \
> >
> > See the QAPI schema updates included in this patch for more usage
> > details.
> >
> > In some cases these blobs may be up to 4096 characters, but this is
> > generally well below the default limit for linux hosts where
> > command-line sizes are defined by the sysconf-configurable ARG_MAX
> > value, which defaults to 2097152 characters for Ubuntu hosts, for
> > example.
> >
> > Co-developed-by: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  docs/amd-memory-encryption.txt |  77 ++++++++++-
> >  qapi/qom.json                  |  60 ++++++++
> >  target/i386/sev.c              | 245 ++++++++++++++++++++++++++++++++-
> >  3 files changed, 379 insertions(+), 3 deletions(-)
> >
> > diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
> > index ffca382b5f..0d82e67fa1 100644
> > --- a/docs/amd-memory-encryption.txt
> > +++ b/docs/amd-memory-encryption.txt
> > @@ -22,8 +22,8 @@ support for notifying a guest's operating system when certain types of VMEXITs
> >  are about to occur. This allows the guest to selectively share information with
> >  the hypervisor to satisfy the requested function.
> >  
> > -Launching
> > ----------
> > +Launching (SEV and SEV-ES)
> > +--------------------------
> >  Boot images (such as bios) must be encrypted before a guest can be booted. The
> >  MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images: LAUNCH_START,
> >  LAUNCH_UPDATE_DATA, LAUNCH_MEASURE and LAUNCH_FINISH. These four commands
> > @@ -113,6 +113,79 @@ a SEV-ES guest:
> >   - Requires in-kernel irqchip - the burden is placed on the hypervisor to
> >     manage booting APs.
> >  
> > +Launching (SEV-SNP)
> > +-------------------
> > +Boot images (such as bios) must be encrypted before a guest can be booted. The
> > +MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images:
> > +KVM_SNP_INIT, SNP_LAUNCH_START, SNP_LAUNCH_UPDATE, and SNP_LAUNCH_FINISH. These
> > +four commands together generate a fresh memory encryption key for the VM,
> > +encrypt the boot images for a successful launch.
> > +
> > +KVM_SNP_INIT is called first to initialize the SEV-SNP firmware and SNP
> > +features in the KVM. The feature flags value can be provided through the
> > +'init-flags' property of the 'sev-snp-guest' object.
> > +
> > ++------------+-------+----------+---------------------------------+
> > +| key        | type  | default  | meaning                         |
> > ++------------+-------+----------+---------------------------------+
> > +| init_flags | hex   | 0        | SNP feature flags               |
> > ++-----------------------------------------------------------------+
> > +
> > +Note: currently the init_flags must be zero.
> > +
> > +SNP_LAUNCH_START is called first to create a cryptographic launch context
> > +within the firmware. To create this context, guest owner must provide a guest
> > +policy and other parameters as described in the SEV-SNP firmware
> > +specification. The launch parameters should be specified as described in the
> > +QAPI schema for the 'sev-snp-guest' object.
> > +
> > +The SNP_LAUNCH_START uses the following parameters (see the SEV-SNP
> > +specification for more details):
> > +
> > ++--------+-------+----------+----------------------------------------------+
> > +| key    | type  | default  | meaning                                      |
> > ++--------+-------+----------+----------------------------------------------+
> > +| policy | hex   | 0x30000  | a 64-bit guest policy                        |
> > +| imi_en | bool  | 0        | 1 when IMI is enabled                        |
> > +| ma_end | bool  | 0        | 1 when migration agent is used               |
> > +| gosvw  | string| 0        | 16-byte base64 encoded string for the guest  |
> > +|        |       |          | OS visible workaround.                       |
> > ++--------+-------+----------+----------------------------------------------+
> > +
> > +SNP_LAUNCH_UPDATE encrypts the memory region using the cryptographic context
> > +created via the SNP_LAUNCH_START command. If required, this command can be called
> > +multiple times to encrypt different memory regions. The command also calculates
> > +the measurement of the memory contents as it encrypts.
> > +
> > +SNP_LAUNCH_FINISH finalizes the guest launch flow. Optionally, while finalizing
> > +the launch the firmware can perform checks on the launch digest computing
> > +through the SNP_LAUNCH_UPDATE. To perform the check the user must supply
> > +the id block, authentication blob and host data that should be included in the
> > +attestation report. See the SEV-SNP spec for further details.
> > +
> > +The SNP_LAUNCH_FINISH uses the following parameters, which can be configured
> > +by the corresponding parameters documented in the QAPI schema for the
> > +'sev-snp-guest' object.
> > +
> > ++------------+-------+----------+----------------------------------------------+
> > +| key        | type  | default  | meaning                                      |
> > ++------------+-------+----------+----------------------------------------------+
> > +| id_block   | string| none     | base64 encoded ID block                      |
> > ++------------+-------+----------+----------------------------------------------+
> > +| id_auth    | string| none     | base64 encoded authentication information    |
> > ++------------+-------+----------+----------------------------------------------+
> > +| auth_key_en| bool  | 0        | auth block contains author key               |
> > ++------------+-------+----------+----------------------------------------------+
> > +| host_data  | string| none     | host provided data                           |
> > ++------------+-------+----------+----------------------------------------------+
> > +
> > +To launch a SEV-SNP guest (additional parameters are documented in the QAPI
> > +schema for the 'sev-snp-guest' object):
> > +
> > +# ${QEMU} \
> > +    -machine ...,confidential-guest-support=sev0 \
> > +    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1
> > +
> >  Debugging
> >  -----------
> >  Since the memory contents of a SEV guest are encrypted, hypervisor access to
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 211e083727..ea39585026 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -775,6 +775,64 @@
> >              '*policy': 'uint32',
> >              '*handle': 'uint32' } }
> >  
> > +##
> > +# @SevSnpGuestProperties:
> > +#
> > +# Properties for sev-snp-guest objects. Many of these are direct arguments
> > +# for the SEV-SNP KVM interfaces documented in the linux kernel source
> > +# documentation under 'amd-memory-encryption.rst'. Additional documentation
> > +# is also available in the QEMU source tree under
> > +# 'amd-memory-encryption.rst'.
> > +#
> > +# In addition to those files, please see the SEV-SNP Firmware Specification
> > +# (Rev 0.9) documentation for the SNP_INIT and
> > +# SNP_LAUNCH_{START,UPDATE,FINISH} firmware interfaces, which the KVM
> > +# interfaces are written against.
> > +#
> > +# @init-flags: as documented for the 'flags' parameter of the
> > +#              KVM_SNP_INIT KVM command (default: 0)
> > +#
> > +# @policy: as documented for the 'policy' parameter of the
> > +#          KVM_SNP_LAUNCH_START KVM command (default: 0x30000)
> 
> These expose the host kernel's numerical encoding of over QMP.  I'm not
> sure that's a good idea.

Most of these are the same as the actual arguments to firmware as defined by
the SNP spec, but I'll see if I can make the documentation here more
agnostic to the kernel interfaces and try to stick more to the SNP/firmware
spec.

> 
> > +#
> > +# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
> > +#                             hypervisor-defined workarounds, as documented
> > +#                             for the 'gosvm' parameter of the
> > +#                             KVM_SNP_LAUNCH_START KVM command.
> > +#                             (default: all-zero)
> > +#
> > +# @id-block: 8-byte, base64-encoded blob to provide the ID Block
> > +#            structure documented in SEV-SNP spec, as documented for the
> > +#            'id_block_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
> > +#            command (default: all-zero)
> > +#
> > +# @id-auth: 4096-byte, base64-encoded blob to provide the ID Authentication
> > +#           Information Structure documented in SEV-SNP spec, as documented
> > +#           for the 'id_auth_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
> > +#           command (default: all-zero)
> > +#
> > +# @auth-key-enabled: true if 'id-auth' blob contains the Author Key
> > +#                    documented in the SEV-SNP spec, as documented for the
> > +#                    'auth_key_en' parameter of the KVM_SNP_LAUNCH_FINISH
> > +#                    command (default: false)
> > +#
> > +# @host-data: 32-byte, base64-encoded user-defined blob to provide to the
> > +#             guest, as documented for the 'host_data' parameter of the
> > +#             KVM_SNP_LAUNCH_FINISH command (default: all-zero)
> > +#
> > +# Since: 6.2
> > +##
> > +{ 'struct': 'SevSnpGuestProperties',
> > +  'base': 'SevCommonProperties',
> > +  'data': {
> > +            '*init-flags': 'uint64',
> > +            '*policy': 'uint64',
> > +            '*guest-visible-workarounds': 'str',
> > +            '*id-block': 'str',
> > +            '*id-auth': 'str',
> > +            '*auth-key-enabled': 'bool',
> > +            '*host-data': 'str' } }
> > +
> >  ##
> >  # @ObjectType:
> >  #
> > @@ -816,6 +874,7 @@
> >      'secret',
> >      'secret_keyring',
> >      'sev-guest',
> > +    'sev-snp-guest',
> >      's390-pv-guest',
> >      'throttle-group',
> >      'tls-creds-anon',
> > @@ -873,6 +932,7 @@
> >        'secret':                     'SecretProperties',
> >        'secret_keyring':             'SecretKeyringProperties',
> >        'sev-guest':                  'SevGuestProperties',
> > +      'sev-snp-guest':              'SevSnpGuestProperties',
> >        'throttle-group':             'ThrottleGroupProperties',
> >        'tls-creds-anon':             'TlsCredsAnonProperties',
> >        'tls-creds-psk':              'TlsCredsPskProperties',
> 
> Pretty much all Greek to me, but there are no obvious QAPI schema
> no-nos, so
> 
> For the QAPI schema
> Acked-by: Markus Armbruster <armbru@redhat.com>
> 
> [...]

Thanks!
