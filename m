Return-Path: <kvm+bounces-12331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A98D388195F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67A5028497D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409E085C65;
	Wed, 20 Mar 2024 22:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H1nzUDJZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E3A2CA6
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 22:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710972585; cv=fail; b=lY43+TRfojVaLvkaQ+EWWXYJL/FBUhSJsu/746SViITlLh/xou166RZneo5HPUZX8HGaNcyL2CIEQmmTBuvrMC/m5QXljHxb5Chsd1kshFY6GOf3wAq/8uK0jbrh2veoGn0iKvvANiZdTJ6qp7S2s20PNXDzCtwVIVZ/5SpjpJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710972585; c=relaxed/simple;
	bh=zUxC6HzUXGLsibj0MN4CGDE932Tx1Mz0KCayBiYgcEg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAB1tu09paTPqM5YmKxVKdkV1t85teu/XPROq8+GHwOOUWGvMhtp5H2HqSeVhAYpRMqi53VafPwLXGH4IM46LuZptnGg9Y03c9MO7AaUxOIwuM8GV9zb7d5a6kDwU7qx/l8p6vUxcyh9YBr5BZMq+utY4QTowF9hM5h94L7t7ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H1nzUDJZ reason="signature verification failed"; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsx6crFrdksF3bK0tpKQ6TCfB8jr+P0e2JCs+T1O8So+3JnKW8/X7CtwGev9s8sKy9n7xRjpFuwGSDMv7uC180zAXBek7qS2aQ1Oqlq5yOJD5Dtf7tgNhmB8m57qhRqpHjfw5b0fcQXHqnXe297yffn9ETNj3lCqKFTysHJtzZxwGqZp4jYE7CtovvyASdDsg0wQlDlBf/+zwJaeS/Ktw88rap4F8AG1uOCIOJtmPKsq1ZxUJW71c8i2ey5DowG6BUOLgd8PsRXAcyGkO6CbSg3l8ZX1LWCgptMEznpfIVWhm4+wvZBMixOq2At+OVlvpwFGHCPt8yRiCIOphxbVMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnyyD6jgDzKC2PBBuc7EA1ac8pVWFDccEiqVen1Zazc=;
 b=OfF6YrCaBzAqz+bcGAgdyjUtTF8yLdPnW71j3Vtco7gKO6YBzvfh9x3MEoU+EAtuIIOZNqE2dQeC61nwMuH+no6tbl9cYLC23/FmfZYDIqXB3y7W/yRi4dPvgQauwohf3b2RrDWDNZNMXboHB9TqE6g8Q89eUMb9JUB6xU5N0G33AIvisWXwkCQmOqX0zWT8MDJ1p4BqtPkRlfS6hDtKThjWSlXKiJk/SKDGBu5vrIt9c2bPcSCp9WiK0r1BPS5i/hDssr4tNha2bl885XnFOcD+Ya7bPo5MYEhldJWiBXyEOFEnHdW5lyw5MvOfXTdy0NHn2qIanyj75pxXUb2jWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnyyD6jgDzKC2PBBuc7EA1ac8pVWFDccEiqVen1Zazc=;
 b=H1nzUDJZ3N3jPJhKUh4Ioqz0i2XtlB0ASh/uxmMUzSHgSLMWS2++2xpVR5NkxtATLYzhceLQ4OU2xR2N9KKNyPa0O5MI5TXNX8iYtai4gtgnVof09ZRY90FZz2LaNiw8Pd+B24hkVZi81LPFoRljlhZd9CHbkZ3q+IU0o7fpHwQ=
Received: from SJ0PR13CA0104.namprd13.prod.outlook.com (2603:10b6:a03:2c5::19)
 by PH7PR12MB5710.namprd12.prod.outlook.com (2603:10b6:510:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 22:09:38 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::a8) by SJ0PR13CA0104.outlook.office365.com
 (2603:10b6:a03:2c5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11 via Frontend
 Transport; Wed, 20 Mar 2024 22:09:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 22:09:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 17:09:37 -0500
Date: Wed, 20 Mar 2024 16:36:17 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	"Xiaoyao Li" <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 21/49] i386/sev: Introduce "sev-common" type to
 encapsulate common SEV state
Message-ID: <20240320213617.frro6gesyxnuyiwm@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-22-michael.roth@amd.com>
 <ZfrMDYk-gSQF04gQ@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfrMDYk-gSQF04gQ@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|PH7PR12MB5710:EE_
X-MS-Office365-Filtering-Correlation-Id: cf51da77-c7e7-4116-5b3c-08dc492a6f48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QbWi3NMJEAn+zpKFdH/fuE/y9hfJ8T08tbmFj0wA7KYngfO4Lj9+sMg7cCnUp5yxpmXEU3Po7fcyCZGkCWp34RPmJyDyQds01BqccE9Vj0U8XusYp1ptikxgM3+6XQApSgXPazlLlNKYDVHpLRL6LAw6qe6OxhE6w7O3u0DVR4IUrXJHYJse6rIiDdMH58p9hJUluVtypzhqYTC/dp5bXqb3aASp0cEuwgPDxZhRDOHZrGG+0CJPYwVGCbnrtqysn4rJWkGbizFuiAEj4ZVfJXKTyLn2xzSXrsk81yJODy41UgwY4m/5EKsWOTlLlfCbv0K6MVfOHjtigA7Y30hfFd9vzNlwwmGZhBi4FenIfBeIJMU3pVm/knAPZAF+KB/y+a0JxNlsdOhCs1TdyVM7x+e2458/kuQE3s0lhB2txixWD1FET8pdIYmeToZgY+4/+9Ftmol+51/xQMpzsOJtxOHrIfAus07UJh3l7+++ELV6XCAfj3V1ONp0C0gpdLOAa06qScCrYGxCEtFMdbz6SICFDhjRwli+Vk7OGZtuGE0VRxsoHApMR8cZKKr2v0GMK/8p6sC62MxFFzQ2TLOYPeaHadsDyygZJ0E7sydte+yLTOvxNXf1gmp9LB9mPAPXpCHwDr9/Xd4Bvvo9AkAxd58Ej+gIVnZvo+ZnBvhzoNUIMSDoeZioPQBsm6ieLx+VkRf2jy8kRZ91dkWgMOAK+g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 22:09:38.2984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf51da77-c7e7-4116-5b3c-08dc492a6f48
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5710

On Wed, Mar 20, 2024 at 11:44:13AM +0000, Daniel P. Berrangé wrote:
> On Wed, Mar 20, 2024 at 03:39:17AM -0500, Michael Roth wrote:
> > Currently all SEV/SEV-ES functionality is managed through a single
> > 'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
> > same approach won't work well since some of the properties/state
> > managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
> > rely on a new QOM type with its own set of properties/state.
> > 
> > To prepare for this, this patch moves common state into an abstract
> > 'sev-common' parent type to encapsulate properties/state that are
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
> >  qapi/qom.json     |  32 ++--
> >  target/i386/sev.c | 457 ++++++++++++++++++++++++++--------------------
> >  target/i386/sev.h |   3 +
> >  3 files changed, 281 insertions(+), 211 deletions(-)
> > 
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index baae3a183f..66b5781ca6 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -875,12 +875,29 @@
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
> > +#     unavailable when SEV is enabled
> > +#
> > +# Since: 2.12
> 
> Not quite sure what we've done in this scenario before.
> It feels wierd to use '2.12' for the new base type, even
> though in effect the properties all existed since 2.12 in
> the sub-class.
> 
> Perhaps 'Since: 9.1' for the type, but 'Since: 2.12' for the
> properties, along with an explanatory comment about stuff
> moving into the new base type ?
> 
> Markus, opinions ?

My thinking is that the internal details are less important than what's
actually exposed to users in the form of command-line options/etc. So
in that context the "Since: 2.12" sort of becomes the "default" for when
those properties were first made available to users, and then anything we
add after would then get special treatment with the per-property
versioning. But no issue with taking a different approach if that's
preferred.

> 
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
> > @@ -889,11 +906,6 @@
> >  #
> >  # @handle: SEV firmware handle (default: 0)
> >  #
> > -# @cbitpos: C-bit location in page table entry (default: 0)
> > -#
> > -# @reduced-phys-bits: number of bits in physical addresses that become
> > -#     unavailable when SEV is enabled
> > -#
> >  # @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
> >  #     designated guest firmware page for measured boot with -kernel
> >  #     (default: false) (since 6.2)
> > @@ -901,13 +913,11 @@
> >  # Since: 2.12
> >  ##
> >  { 'struct': 'SevGuestProperties',
> > -  'data': { '*sev-device': 'str',
> > -            '*dh-cert-file': 'str',
> > +  'base': 'SevCommonProperties',
> > +  'data': { '*dh-cert-file': 'str',
> >              '*session-file': 'str',
> >              '*policy': 'uint32',
> >              '*handle': 'uint32',
> > -            '*cbitpos': 'uint32',
> > -            'reduced-phys-bits': 'uint32',
> >              '*kernel-hashes': 'bool' } }
> >  
> >  ##
> 
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 9dab4060b8..63a220de5e 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -40,48 +40,53 @@
> >  #include "hw/i386/pc.h"
> >  #include "exec/address-spaces.h"
> >  
> > -#define TYPE_SEV_GUEST "sev-guest"
> > +OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
> >  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> >  
> > -
> > -/**
> > - * SevGuestState:
> > - *
> > - * The SevGuestState object is used for creating and managing a SEV
> > - * guest.
> > - *
> > - * # $QEMU \
> > - *         -object sev-guest,id=sev0 \
> > - *         -machine ...,memory-encryption=sev0
> > - */
> > -struct SevGuestState {
> > +struct SevCommonState {
> >      X86ConfidentialGuest parent_obj;
> >  
> >      int kvm_type;
> >  
> >      /* configuration parameters */
> >      char *sev_device;
> > -    uint32_t policy;
> > -    char *dh_cert_file;
> > -    char *session_file;
> >      uint32_t cbitpos;
> >      uint32_t reduced_phys_bits;
> > -    bool kernel_hashes;
> >  
> >      /* runtime state */
> > -    uint32_t handle;
> >      uint8_t api_major;
> >      uint8_t api_minor;
> >      uint8_t build_id;
> >      int sev_fd;
> >      SevState state;
> > -    gchar *measurement;
> >  
> >      uint32_t reset_cs;
> >      uint32_t reset_ip;
> >      bool reset_data_valid;
> >  };
> >  
> > +/**
> > + * SevGuestState:
> > + *
> > + * The SevGuestState object is used for creating and managing a SEV
> > + * guest.
> > + *
> > + * # $QEMU \
> > + *         -object sev-guest,id=sev0 \
> > + *         -machine ...,memory-encryption=sev0
> > + */
> > +struct SevGuestState {
> > +    SevCommonState sev_common;
> > +    gchar *measurement;
> > +
> > +    /* configuration parameters */
> > +    uint32_t handle;
> > +    uint32_t policy;
> > +    char *dh_cert_file;
> > +    char *session_file;
> > +    bool kernel_hashes;
> > +};
> > +
> >  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
> >  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> >  
> > @@ -127,7 +132,6 @@ typedef struct QEMU_PACKED PaddedSevHashTable {
> >  
> >  QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
> >  
> > -static SevGuestState *sev_guest;
> >  static Error *sev_mig_blocker;
> >  
> >  static const char *const sev_fw_errlist[] = {
> > @@ -208,21 +212,21 @@ fw_error_to_str(int code)
> >  }
> >  
> >  static bool
> > -sev_check_state(const SevGuestState *sev, SevState state)
> > +sev_check_state(const SevCommonState *sev_common, SevState state)
> >  {
> > -    assert(sev);
> > -    return sev->state == state ? true : false;
> > +    assert(sev_common);
> > +    return sev_common->state == state ? true : false;
> >  }
> >  
> >  static void
> > -sev_set_guest_state(SevGuestState *sev, SevState new_state)
> > +sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
> >  {
> >      assert(new_state < SEV_STATE__MAX);
> > -    assert(sev);
> > +    assert(sev_common);
> >  
> > -    trace_kvm_sev_change_state(SevState_str(sev->state),
> > +    trace_kvm_sev_change_state(SevState_str(sev_common->state),
> >                                 SevState_str(new_state));
> > -    sev->state = new_state;
> > +    sev_common->state = new_state;
> >  }
> >  
> >  static void
> > @@ -289,111 +293,61 @@ static struct RAMBlockNotifier sev_ram_notifier = {
> >      .ram_block_removed = sev_ram_block_removed,
> >  };
> >  
> > -static void
> > -sev_guest_finalize(Object *obj)
> > -{
> > -}
> > -
> > -static char *
> > -sev_guest_get_session_file(Object *obj, Error **errp)
> > -{
> > -    SevGuestState *s = SEV_GUEST(obj);
> > -
> > -    return s->session_file ? g_strdup(s->session_file) : NULL;
> > -}
> > -
> > -static void
> > -sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
> > -{
> > -    SevGuestState *s = SEV_GUEST(obj);
> > -
> > -    s->session_file = g_strdup(value);
> > -}
> > -
> > -static char *
> > -sev_guest_get_dh_cert_file(Object *obj, Error **errp)
> > -{
> > -    SevGuestState *s = SEV_GUEST(obj);
> > -
> > -    return g_strdup(s->dh_cert_file);
> > -}
> > -
> > -static void
> > -sev_guest_set_dh_cert_file(Object *obj, const char *value, Error **errp)
> > -{
> > -    SevGuestState *s = SEV_GUEST(obj);
> > -
> > -    s->dh_cert_file = g_strdup(value);
> > -}
> > -
> > -static char *
> > -sev_guest_get_sev_device(Object *obj, Error **errp)
> > -{
> > -    SevGuestState *sev = SEV_GUEST(obj);
> > -
> > -    return g_strdup(sev->sev_device);
> > -}
> > -
> > -static void
> > -sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
> > -{
> > -    SevGuestState *sev = SEV_GUEST(obj);
> > -
> > -    sev->sev_device = g_strdup(value);
> > -}
> > -
> > -static bool sev_guest_get_kernel_hashes(Object *obj, Error **errp)
> > -{
> > -    SevGuestState *sev = SEV_GUEST(obj);
> > -
> > -    return sev->kernel_hashes;
> > -}
> > -
> > -static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
> > -{
> > -    SevGuestState *sev = SEV_GUEST(obj);
> > -
> > -    sev->kernel_hashes = value;
> > -}
> > -
> >  bool
> >  sev_enabled(void)
> >  {
> > -    return !!sev_guest;
> > +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> > +
> > +    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
> >  }
> >  
> >  bool
> >  sev_es_enabled(void)
> >  {
> > -    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
> > +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> > +
> > +    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
> >  }
> >  
> >  uint32_t
> >  sev_get_cbit_position(void)
> >  {
> > -    return sev_guest ? sev_guest->cbitpos : 0;
> > +    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> > +
> > +    return sev_common ? sev_common->cbitpos : 0;
> >  }
> >  
> >  uint32_t
> >  sev_get_reduced_phys_bits(void)
> >  {
> > -    return sev_guest ? sev_guest->reduced_phys_bits : 0;
> > +    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> > +
> > +    return sev_common ? sev_common->reduced_phys_bits : 0;
> >  }
> >  
> >  static SevInfo *sev_get_info(void)
> >  {
> >      SevInfo *info;
> > +    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> > +    SevGuestState *sev_guest =
> > +        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
> > +                                             TYPE_SEV_GUEST);
> >  
> >      info = g_new0(SevInfo, 1);
> >      info->enabled = sev_enabled();
> >  
> >      if (info->enabled) {
> > -        info->api_major = sev_guest->api_major;
> > -        info->api_minor = sev_guest->api_minor;
> > -        info->build_id = sev_guest->build_id;
> > -        info->policy = sev_guest->policy;
> > -        info->state = sev_guest->state;
> > -        info->handle = sev_guest->handle;
> > +        if (sev_guest) {
> > +            info->handle = sev_guest->handle;
> > +        }
> > +        info->api_major = sev_common->api_major;
> > +        info->api_minor = sev_common->api_minor;
> > +        info->build_id = sev_common->build_id;
> > +        info->state = sev_common->state;
> > +        /* we only report the lower 32-bits of policy for SNP, ok for now... */
> > +        info->policy =
> > +            (uint32_t)object_property_get_uint(OBJECT(sev_common),
> > +                                               "policy", NULL);
> >      }
> 
> I think we can change this 'policy' field to 'int64'.
> 
> Going from int32 to int64 doesn't change the encoding in JSON
> or cli properites. SEV/SEV-ES guests will still only use values
> that fit within int32, so existing users of QEMU won't notice
> a change.
> 
> Apps that want to use SEV-SNP will know that they can have
> policy values exceeding int32, but since that's net new code
> to suupport SEV-SNP there's no back compat issue.

In subsequent patch:

  "i386/sev: Update query-sev QAPI format to handle SEV-SNP"

we end up reporting SNP policy via a new 64-bit field, 'snp_policy',
based on a discussion:

  https://lore.kernel.org/kvm/YTdSlg5NymDQex5T@work-vm/T/#mac6758af9bfc41ee49ff3ef5c3ec3779ec275ff9

I think the concern was some 'old_mgmt' tool trying to interact with an
SNP guest launched through other means and misinterpreting SNP-specific
policy bits as SEV ones.

So because if that, there isn't really a need to make the policy bit
64-bit as part of this patch.

One thing that does need to be addressed here in the confusing comment:

  /* we only report the lower 32-bits of policy for SNP, ok for now... */

which I think was a relic from v2 that can be dropped now.

> 
> 
> > @@ -519,6 +473,8 @@ static SevCapability *sev_get_capabilities(Error **errp)
> >      size_t pdh_len = 0, cert_chain_len = 0, cpu0_id_len = 0;
> >      uint32_t ebx;
> >      int fd;
> > +    SevCommonState *sev_common;
> > +    char *sev_device;
> 
> Declare 'g_autofree char *sev_device = NULL;'
> 
> >  
> >      if (!kvm_enabled()) {
> >          error_setg(errp, "KVM not enabled");
> > @@ -529,12 +485,21 @@ static SevCapability *sev_get_capabilities(Error **errp)
> >          return NULL;
> >      }
> >  
> > -    fd = open(DEFAULT_SEV_DEVICE, O_RDWR);
> > +    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> > +    if (!sev_common) {
> > +        error_setg(errp, "SEV is not configured");
> > +    }
> 
> Missing 'return' ?
> 
> > +
> > +    sev_device = object_property_get_str(OBJECT(sev_common), "sev-device",
> > +                                         &error_abort);
> > +    fd = open(sev_device, O_RDWR);
> >      if (fd < 0) {
> >          error_setg_errno(errp, errno, "SEV: Failed to open %s",
> >                           DEFAULT_SEV_DEVICE);
> > +        g_free(sev_device);
> >          return NULL;
> >      }
> > +    g_free(sev_device);
> 
> These 'g_free' are redundant with g_autofree usage on the declaration.
> 
> >  
> >      if (sev_get_pdh_info(fd, &pdh_data, &pdh_len,
> >                           &cert_chain_data, &cert_chain_len, errp)) {
> > @@ -577,7 +542,7 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
> >  {
> >      struct kvm_sev_attestation_report input = {};
> >      SevAttestationReport *report = NULL;
> > -    SevGuestState *sev = sev_guest;
> > +    SevCommonState *sev_common;
> 
> I think it would have been nicer to just keep the variable
> just called 'sev', except in the few cases where you needed to
> have variables for both parent & subclass in the same method.
> This diff would be much smaller too.
> 
> That's a bit bikeshedding though, so not too bothered either
> way.

Yah, I think at the time I'd considered that, but always anchoring
the variable name to the underlying type makes it easy to always
know what type of instance you're working with which I'm hoping is
worth the initial investment of doing the conversion consistently.

> 
> >      g_autofree guchar *data = NULL;
> >      g_autofree guchar *buf = NULL;
> >      gsize len;
> > @@ -602,8 +567,10 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
> >          return NULL;
> >      }
> >  
> > +    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> > +
> >      /* Query the report length */
> > -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> > +    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> >              &input, &err);
> >      if (ret < 0) {
> >          if (err != SEV_RET_INVALID_LEN) {
> > @@ -619,7 +586,7 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
> >      memcpy(input.mnonce, buf, sizeof(input.mnonce));
> >  
> >      /* Query the report */
> > -    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> > +    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
> >              &input, &err);
> >      if (ret) {
> >          error_setg_errno(errp, errno, "SEV: Failed to get attestation report"
> 
> > +
> > +/* sev guest info common to sev/sev-es/sev-snp */
> > +static const TypeInfo sev_common_info = {
> > +    .parent = TYPE_X86_CONFIDENTIAL_GUEST,
> > +    .name = TYPE_SEV_COMMON,
> > +    .instance_size = sizeof(SevCommonState),
> > +    .class_init = sev_common_class_init,
> > +    .instance_init = sev_common_instance_init,
> > +    .abstract = true,
> > +    .interfaces = (InterfaceInfo[]) {
> > +        { TYPE_USER_CREATABLE },
> > +        { }
> > +    }
> > +};
> 
> It feels wierd to declare a type as "abstract", and at
> the same time declare it "user creatable". I know this
> was a simple short-cut to avoid repeating the .interfaces
> on every sub-class, but I still think it would be better
> to put the "user creatable" marker on the concrete impls
> instead.
> 
> Also how about using OBJECT_DEFINE_ABSTRACT_TYPE here
> and also converting the subclasses to use
> OBJECT_DEFINE_TYPE_WITH_INTERFACES ?

Makes sense, will implement these for v4.

-Mike

> 
> 
> 
> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 

