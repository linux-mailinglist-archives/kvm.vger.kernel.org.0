Return-Path: <kvm+bounces-12333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90381881966
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:10:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0B29284A12
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43EE8614B;
	Wed, 20 Mar 2024 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4F5bHd39"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA7D85C6C
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710972629; cv=fail; b=CXbAkpB5qTZMvaCRYxs8c5tsjheRyPJ9EOGWuSJzKKORac9aCxl/SFjbZdSkSIojfipcM11TgjOXUNbFVdpAQGpHzix9/wrT/PiCdzO7GfxEGCTpAGFs5gJu3+GmCQIt+i9IbgU60mV8qKVXIMSb1mhZgFlrztK4+XmIkWbVShQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710972629; c=relaxed/simple;
	bh=PK2VtqDmsjKOnhWU0NHYfk7MszuNc7c5jHY0PtZuEEM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cw0PrRXIB+DHPXx1jVdX24Z4EdJV6OE2Jat7CD3o5WDjqDjmNjaTS+hZFQaAv/9VrIwaQQYLIX3BqaJOZNQ2IGZMEP3TUohSNJDjppMuuvgJKjxXmd+afRcE0k4geNwwKNrT88TisOKTUDkg5mQD6AhKAG1ZWlJVunk8AWggiF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4F5bHd39 reason="signature verification failed"; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSSSUOUtAwYNtZKUnslg4C3sGHv4zKS5OlqhkZl9YLLWD/LpIDGxG0nhWHhXSqOxKTQGXgmRnyCvu/06mGiYUnlcs8QHpTAmo0QR9zOVUOq4Set8uE1Qn86rM8gTfDpUZuANDIJtsCF2cp9vQjyhR9HUARdhKIl+2uzn+FoczHwp0NXrFFtQmG1BAvzpoVQYkPbA7mfjkwBWWXKjDbfkxJU2sZEk7Y7jWIPt7e11t7QAmcjUhGNeOou23vvC3APBosvBIiD0cFnPMoQ9f83fo624D6uwyfGeKdHdGRpl5yBKLLHfwKdmknm/xX2nmOkieUf2HP7ssxZSoV7lumoNJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vV4nAmBE0M3gaHEqXwy0F5IdVyyIYWVAJu8X/2eq7c=;
 b=XriGw0Gl7V6ssLD5IeuXSXVEOII9mT30iLrROiC/zzKawN46ILZS1EthfTC+JiND74fyr8c0pK5oWC6AtM4717ugHvwD3sR7ffMd7fr3hcRHm7aeLB34EaTUOUkePXudn2gopwiahVhbwIvxe3s7kOtqkaj53neURQoN3GigfswsBH0033LxR1rx9Jn3k52b27YHOcSRmMx8pxBpk8+9qMUP+QmifFHvP8zGJnOfv6wWlFXI57gz0xW1prDMXL/OfntIaa0UB4j9XShNm+g8ic5fgLcJOY87VW3GZywWLYo8yLa9Y2Sew8vEqF56wju1E7syaP1zAu15EKB+U8SwWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vV4nAmBE0M3gaHEqXwy0F5IdVyyIYWVAJu8X/2eq7c=;
 b=4F5bHd39iB7oeMXDjNASqfLznDnrWJtaqvp4ESSxEVegsKl0gh29DLW9FuFvLIX6H814LrIPpZDjaEdWBZmVJz2oqjnQGjPJWuPNOAlSMQ7YQBs9TeU/8+v2HvGxj1KkYua90vRjemW1iakG+RbwSS1p/O8wE7mvbvymenREX+c=
Received: from SJ0PR13CA0100.namprd13.prod.outlook.com (2603:10b6:a03:2c5::15)
 by CH3PR12MB7546.namprd12.prod.outlook.com (2603:10b6:610:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 22:10:19 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::d4) by SJ0PR13CA0100.outlook.office365.com
 (2603:10b6:a03:2c5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 22:10:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 22:10:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 17:10:18 -0500
Date: Wed, 20 Mar 2024 17:09:21 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	"Xiaoyao Li" <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v3 22/49] i386/sev: Introduce 'sev-snp-guest' object
Message-ID: <20240320220921.6gi3quxddwleje33@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-23-michael.roth@amd.com>
 <ZfrPgeF4nDCa3lPm@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfrPgeF4nDCa3lPm@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|CH3PR12MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: c2860f2f-791a-4bb5-db1d-08dc492a87f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NXhBqT3wxIffuibiW7rTWywlZtod4aNuVL23QE+jMJAVtTLk+abUup3RjVh5eWjByfYFASzjSt2hcbOKBNIFaPWBxCWF4O1dXMsApq8MFOqiT6rI4nx0RYj8Z0nK9VNaEgqiVR3Esu2HUTZy0YAUdfXC6/JVMY94UYUi80fxR4DyQ2LX/XW2XMjrc77oMjcemu6G7Ol90k2TlhklISNQnpoZ8rtaaNORalnISuVF0p7jAdnNS/HTjw8P/qcZ6mdFF9+feBaUDNiyrkK0QfkhGN0fRhWRQ6qrSIb1xGgp9de6HJoANwEKG9QzT9CnP6GY+oTtfI0qVB2KXQlWwuLHfYcgULllsLaITgppSO36bxAhOvBJfaYc4ocQ4JCaJBFIIAo3R3nfEYkZZxVUylvnPTcv+e6lrOIBqXL3KZtDWewJ5tjjKlNjp17c1MNRpWiz8PtbBT5+/iPhagTaAua4+SZwMa4yL2OfJky0c/ZS+sn9NHe3mIdDcFZXnO5T/XchMmFjirRbk7uY2CpAN21lAY6Y1qKgy5d4TvHhJo41a2nDEGL+aU+Y8jtfyfScce1IUJ6Y3y8C6GsiszzwKaf+b8IZ1NdTi0bMpz9wS9imQq7TuOv8SEesgRdIKiyrxEj17NYic4LTT3egmAms15UArCgaCZSkG29ssn7/dJrQSEsXaNVHnZtLNWFruxeKGqnGmxUxsCSVlGsphv8CdZkRUA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 22:10:19.7205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2860f2f-791a-4bb5-db1d-08dc492a87f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7546

On Wed, Mar 20, 2024 at 11:58:57AM +0000, Daniel P. Berrangé wrote:
> On Wed, Mar 20, 2024 at 03:39:18AM -0500, Michael Roth wrote:
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
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Co-developed-by: Michael Roth <michael.roth@amd.com>
> > Acked-by: Markus Armbruster <armbru@redhat.com> (for QAPI schema)
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  docs/system/i386/amd-memory-encryption.rst |  78 ++++++-
> >  qapi/qom.json                              |  51 +++++
> >  target/i386/sev.c                          | 241 +++++++++++++++++++++
> >  target/i386/sev.h                          |   1 +
> >  4 files changed, 369 insertions(+), 2 deletions(-)
> > 
> 
> > +##
> > +# @SevSnpGuestProperties:
> > +#
> > +# Properties for sev-snp-guest objects. Most of these are direct arguments
> > +# for the KVM_SNP_* interfaces documented in the linux kernel source
> > +# under Documentation/virt/kvm/amd-memory-encryption.rst, which are in
> > +# turn closely coupled with the SNP_INIT/SNP_LAUNCH_* firmware commands
> > +# documented in the SEV-SNP Firmware ABI Specification (Rev 0.9).
> > +#
> > +# More usage information is also available in the QEMU source tree under
> > +# docs/amd-memory-encryption.
> > +#
> > +# @policy: the 'POLICY' parameter to the SNP_LAUNCH_START command, as
> > +#          defined in the SEV-SNP firmware ABI (default: 0x30000)
> > +#
> > +# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
> > +#                             hypervisor-defined workarounds, corresponding
> > +#                             to the 'GOSVW' parameter of the
> > +#                             SNP_LAUNCH_START command defined in the
> > +#                             SEV-SNP firmware ABI (default: all-zero)
> > +#
> > +# @id-block: 96-byte, base64-encoded blob to provide the 'ID Block'
> > +#            structure for the SNP_LAUNCH_FINISH command defined in the
> > +#            SEV-SNP firmware ABI (default: all-zero)
> > +#
> > +# @id-auth: 4096-byte, base64-encoded blob to provide the 'ID Authentication
> > +#           Information Structure' for the SNP_LAUNCH_FINISH command defined
> > +#           in the SEV-SNP firmware ABI (default: all-zero)
> > +#
> > +# @auth-key-enabled: true if 'id-auth' blob contains the 'AUTHOR_KEY' field
> > +#                    defined SEV-SNP firmware ABI (default: false)
> > +#
> > +# @host-data: 32-byte, base64-encoded, user-defined blob to provide to the
> > +#             guest, as documented for the 'HOST_DATA' parameter of the
> > +#             SNP_LAUNCH_FINISH command in the SEV-SNP firmware ABI
> > +#             (default: all-zero)
> > +#
> > +# Since: 7.2
> 
> This will be 9.1 at the earliest now.

Amazing how good I am at remembering these once I see a reply to a
schema patch I'd already hit 'send' on :)

> 
> > +##
> > +{ 'struct': 'SevSnpGuestProperties',
> > +  'base': 'SevCommonProperties',
> > +  'data': {
> > +            '*policy': 'uint64',
> > +            '*guest-visible-workarounds': 'str',
> > +            '*id-block': 'str',
> > +            '*id-auth': 'str',
> > +            '*auth-key-enabled': 'bool',
> > +            '*host-data': 'str' } }
> > +
> 
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 63a220de5e..7e6dab642a 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -42,6 +42,7 @@
> >  
> >  OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
> >  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> > +OBJECT_DECLARE_SIMPLE_TYPE(SevSnpGuestState, SEV_SNP_GUEST)
> >  
> >  struct SevCommonState {
> >      X86ConfidentialGuest parent_obj;
> > @@ -87,8 +88,22 @@ struct SevGuestState {
> >      bool kernel_hashes;
> >  };
> >  
> > +struct SevSnpGuestState {
> > +    SevCommonState sev_common;
> > +
> > +    /* configuration parameters */
> > +    char *guest_visible_workarounds;
> > +    char *id_block;
> > +    char *id_auth;
> > +    char *host_data;
> > +
> > +    struct kvm_sev_snp_launch_start kvm_start_conf;
> > +    struct kvm_sev_snp_launch_finish kvm_finish_conf;
> > +};
> > +
> >  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
> >  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> > +#define DEFAULT_SEV_SNP_POLICY  0x30000
> >  
> >  #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
> >  typedef struct __attribute__((__packed__)) SevInfoBlock {
> > @@ -1473,11 +1488,237 @@ static const TypeInfo sev_guest_info = {
> >      .class_init = sev_guest_class_init,
> 
> > +
> > +static char *
> > +sev_snp_guest_get_guest_visible_workarounds(Object *obj, Error **errp)
> > +{
> > +    return g_strdup(SEV_SNP_GUEST(obj)->guest_visible_workarounds);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_guest_visible_workarounds(Object *obj, const char *value,
> > +                                            Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
> > +    g_autofree guchar *blob;
> > +    gsize len;
> > +
> > +    if (sev_snp_guest->guest_visible_workarounds) {
> > +        g_free(sev_snp_guest->guest_visible_workarounds);
> > +    }
> 
> Redundant 'if' test - g_free is happy with NULL
> 
> > +
> > +    /* store the base64 str so we don't need to re-encode in getter */
> > +    sev_snp_guest->guest_visible_workarounds = g_strdup(value);
> > +
> > +    blob = qbase64_decode(sev_snp_guest->guest_visible_workarounds, -1, &len, errp);
> > +    if (!blob) {
> > +        return;
> > +    }
> > +
> > +    if (len > sizeof(start->gosvw)) {
> 
> The QAPI docs said this property must be '16 bytes', so I'd
> suggest we do a strict equality test, rather than min size
> test to catch a wider set of mistakes.

Makes sense.

> 
> > +        error_setg(errp, "parameter length of %lu exceeds max of %lu",
> > +                   len, sizeof(start->gosvw));
> > +        return;
> > +    }
> > +
> > +    memcpy(start->gosvw, blob, len);
> > +}
> > +
> > +static char *
> > +sev_snp_guest_get_id_block(Object *obj, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +
> > +    return g_strdup(sev_snp_guest->id_block);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_id_block(Object *obj, const char *value, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> > +    gsize len;
> > +
> > +    if (sev_snp_guest->id_block) {
> > +        g_free(sev_snp_guest->id_block);
> > +        g_free((guchar *)finish->id_block_uaddr);
> > +    }
> 
> Assuming 'id_block_uaddr' is also initialized to 0, when id_block
> is NULL, then you can remove the 'if' conditional.

id_block_uaddr only ever gets initialized after id_block gets
initialized via g_strdup() below, and the SevSnpGuestState struct is
zero'd during creation time so no need to worry about uninitialized
values. So I think we can indeed drop the if check.

> 
> > +
> > +    /* store the base64 str so we don't need to re-encode in getter */
> > +    sev_snp_guest->id_block = g_strdup(value);
> > +
> > +    finish->id_block_uaddr =
> > +        (uint64_t)qbase64_decode(sev_snp_guest->id_block, -1, &len, errp);
> > +
> > +    if (!finish->id_block_uaddr) {
> > +        return;
> > +    }
> > +
> > +    if (len > KVM_SEV_SNP_ID_BLOCK_SIZE) {
> 
> Again, lets do a strict equality test to match the documented
> required size.
> 
> > +        error_setg(errp, "parameter length of %lu exceeds max of %u",
> > +                   len, KVM_SEV_SNP_ID_BLOCK_SIZE);
> > +        return;
> > +    }
> > +
> > +    finish->id_block_en = (len) ? 1 : 0;
> > +}
> > +
> > +static char *
> > +sev_snp_guest_get_id_auth(Object *obj, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +
> > +    return g_strdup(sev_snp_guest->id_auth);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_id_auth(Object *obj, const char *value, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> > +    gsize len;
> > +
> > +    if (sev_snp_guest->id_auth) {
> > +        g_free(sev_snp_guest->id_auth);
> > +        g_free((guchar *)finish->id_auth_uaddr);
> > +    }
> 
> Same probably redundant 'if'

Looks like it. Will address these and recurring cases below.

-Mike

> 
> > +
> > +    /* store the base64 str so we don't need to re-encode in getter */
> > +    sev_snp_guest->id_auth = g_strdup(value);
> > +
> > +    finish->id_auth_uaddr =
> > +        (uint64_t)qbase64_decode(sev_snp_guest->id_auth, -1, &len, errp);
> > +
> > +    if (!finish->id_auth_uaddr) {
> > +        return;
> > +    }
> > +
> > +    if (len > KVM_SEV_SNP_ID_AUTH_SIZE) {
> 
> Equality test.
> 
> > +        error_setg(errp, "parameter length of %lu exceeds max of %u",
> > +                   len, KVM_SEV_SNP_ID_AUTH_SIZE);
> > +        return;
> > +    }
> > +}
> > +
> > +static bool
> > +sev_snp_guest_get_auth_key_en(Object *obj, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +
> > +    return !!sev_snp_guest->kvm_finish_conf.auth_key_en;
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_auth_key_en(Object *obj, bool value, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +
> > +    sev_snp_guest->kvm_finish_conf.auth_key_en = value;
> > +}
> > +
> > +static char *
> > +sev_snp_guest_get_host_data(Object *obj, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +
> > +    return g_strdup(sev_snp_guest->host_data);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> > +    g_autofree guchar *blob;
> > +    gsize len;
> > +
> > +    if (sev_snp_guest->host_data) {
> > +        g_free(sev_snp_guest->host_data);
> > +    }
> 
> Redundant 'if'
> 
> > +
> > +    /* store the base64 str so we don't need to re-encode in getter */
> > +    sev_snp_guest->host_data = g_strdup(value);
> > +
> > +    blob = qbase64_decode(sev_snp_guest->host_data, -1, &len, errp);
> > +
> > +    if (!blob) {
> > +        return;
> > +    }
> > +
> > +    if (len > sizeof(finish->host_data)) {
> 
> Equality test
> 
> > +        error_setg(errp, "parameter length of %lu exceeds max of %lu",
> > +                   len, sizeof(finish->host_data));
> > +        return;
> > +    }
> > +
> > +    memcpy(finish->host_data, blob, len);
> > +}
> > +
> > +static void
> > +sev_snp_guest_class_init(ObjectClass *oc, void *data)
> > +{
> > +    object_class_property_add(oc, "policy", "uint64",
> > +                              sev_snp_guest_get_policy,
> > +                              sev_snp_guest_set_policy, NULL, NULL);
> > +    object_class_property_add_str(oc, "guest-visible-workarounds",
> > +                                  sev_snp_guest_get_guest_visible_workarounds,
> > +                                  sev_snp_guest_set_guest_visible_workarounds);
> > +    object_class_property_add_str(oc, "id-block",
> > +                                  sev_snp_guest_get_id_block,
> > +                                  sev_snp_guest_set_id_block);
> > +    object_class_property_add_str(oc, "id-auth",
> > +                                  sev_snp_guest_get_id_auth,
> > +                                  sev_snp_guest_set_id_auth);
> > +    object_class_property_add_bool(oc, "auth-key-enabled",
> > +                                   sev_snp_guest_get_auth_key_en,
> > +                                   sev_snp_guest_set_auth_key_en);
> > +    object_class_property_add_str(oc, "host-data",
> > +                                  sev_snp_guest_get_host_data,
> > +                                  sev_snp_guest_set_host_data);
> > +}
> > +
> > +static void
> > +sev_snp_guest_instance_init(Object *obj)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +
> > +    /* default init/start/finish params for kvm */
> > +    sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
> > +}
> > +
> > +/* guest info specific to sev-snp */
> > +static const TypeInfo sev_snp_guest_info = {
> > +    .parent = TYPE_SEV_COMMON,
> > +    .name = TYPE_SEV_SNP_GUEST,
> > +    .instance_size = sizeof(SevSnpGuestState),
> > +    .class_init = sev_snp_guest_class_init,
> > +    .instance_init = sev_snp_guest_instance_init,
> > +};
> 
> Use the OBJECT_DEFINE_TYPE_WITH_INTERFACES macro here.
> 
> > +
> >  static void
> >  sev_register_types(void)
> >  {
> >      type_register_static(&sev_common_info);
> >      type_register_static(&sev_guest_info);
> > +    type_register_static(&sev_snp_guest_info);
> >  }
> >  
> >  type_init(sev_register_types);
> > diff --git a/target/i386/sev.h b/target/i386/sev.h
> > index 668374eef3..bedc667eeb 100644
> > --- a/target/i386/sev.h
> > +++ b/target/i386/sev.h
> > @@ -22,6 +22,7 @@
> >  
> >  #define TYPE_SEV_COMMON "sev-common"
> >  #define TYPE_SEV_GUEST "sev-guest"
> > +#define TYPE_SEV_SNP_GUEST "sev-snp-guest"
> >  
> >  #define SEV_POLICY_NODBG        0x1
> >  #define SEV_POLICY_NOKS         0x2
> > -- 
> > 2.25.1
> > 
> 
> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 

