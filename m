Return-Path: <kvm+bounces-12336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF34881971
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 571131F22AB2
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33F985C74;
	Wed, 20 Mar 2024 22:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nMY2vkjm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13BD6A01A
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 22:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710973421; cv=fail; b=AlGkOieCKz8UWM1SIfJW42WJ1Xkn1fm/XZ6HdKDPqKUVO2uQnQkQdZbP3MnjB5GeuGP2vhwSailmjNpc5nwGaV9nHB1qyWDrOTw0IthY96zRvRMXnGrJphyY971Boq20Vprz/Q5SLDfuCtGhAxOW6pvMCmW1tZUHeNzqL63njGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710973421; c=relaxed/simple;
	bh=ptbnc6udzwBx08oC99cLeyHsjSp6z/s3IyF173SlaAY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeUV8V9SKWRM2FxkOW65gRn2UjEYwCgGH15MqoDi3BqhqazoTTDNTA4IrX4xNrjPn6N0+dJmzj24fDAjQ6tKNFVFCM+jn4F0byo4h3Cw2kNHPYJ36vS8+ngBvSlLjVSjoyPMe4deQbCoY6/wK3IP/tnIzoUnQsxIHfoEMQhJbnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nMY2vkjm reason="signature verification failed"; arc=fail smtp.client-ip=40.107.93.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPAt5KyUvL7mPsF/nzu/QVOA3DRa1VOJvmCcdIN3AQ0EM5G0iYjSlnX/oVM/oorBIZuvG6O3b/7qAk1ow6SfvQ4BECPTfSPbxUv+wWCn6Q9eui3ix3Tj/lPWwsPXqpPW1+FpifLOy+9Md7JUOB0H7P+Fe75nBMYDtD5sYlxhOaQ/HxXNNYd3NuNzc9DCsQD3NUiRXHpAOdAbGOHRrnW9yyD+je2+SgBZa+y/2ZVVr/ayfevu+9+zjVxXT8LuSCBWfNXjuPalwlxU9r8a1FZcRaJMZAyGJoRb9P2xGK+NixX/c/xG1IlDzh8YZr7sH10QLKq9M2uN7s776ayma3fyqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNDkGTd5AVKdfcU+t5XjJOqJddwkH1NUvrCVYf3fRDU=;
 b=JD1kg72Atl0InyVJKkpPmUA5o9U8+nYzfb0YDgu2T9nEe/zqo9xxRZ1MLaBfxQtskIo9olAt1vDBWPbN0g6Y9/80Y1h24IYr67fJ8zqR+3zLYEMNTsrc+Q6SDbNEa6RlQqsS/tXe6MXtIZtabJWee0POqP4zZMN87lwG7cnDQQKjZ2ChL16znUdbsMrj/jKxOQbxb/PGLFBGD8m7TfwmlYQxF85QKkBAlgUnN9BPGfo5l3Gs8/n2q4suoRq7Nw7Liaw3JhOyoJISP80f1Kyc158ZPvRFGMNjHKR8DUH2hDqMHsf5zQycSzBEX+v512fnBCekbZ6S4FmtNwL63bAYNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNDkGTd5AVKdfcU+t5XjJOqJddwkH1NUvrCVYf3fRDU=;
 b=nMY2vkjmd9A6QkWCUS6a3qVs2XRTlKDahMtumkz/wvVdDYJQZOTnu1MUm7Xap94TmEVN6Lx9EjKAUBLWvNj+Qyb/haPYaAU4b3H+iaWVB3SAd2lzGc+EYh9ZwdgIi4wTg2FboWt8/6UHdvBoXli/0LbUVBu6srvxQ5Wr3RHQhD8=
Received: from CH2PR08CA0006.namprd08.prod.outlook.com (2603:10b6:610:5a::16)
 by BY5PR12MB4083.namprd12.prod.outlook.com (2603:10b6:a03:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 22:23:32 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::44) by CH2PR08CA0006.outlook.office365.com
 (2603:10b6:610:5a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Wed, 20 Mar 2024 22:23:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 22:23:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 17:23:31 -0500
Date: Wed, 20 Mar 2024 17:23:18 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	"Xiaoyao Li" <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 31/49] i386/sev: Update query-sev QAPI format to
 handle SEV-SNP
Message-ID: <20240320222318.kxxujqse7ypkc44j@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-32-michael.roth@amd.com>
 <ZfrSHOWHb3qt3Ap8@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfrSHOWHb3qt3Ap8@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|BY5PR12MB4083:EE_
X-MS-Office365-Filtering-Correlation-Id: 14ededbc-ee51-4c20-1b80-08dc492c606e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ArPrSOqEIlWZiYeTvOz+n1t7UcqGPfsnJm14DJPwtivk31Qoz3xu311vM835GcDSYrE2e3HfcMy/49/k228fNtiQz4MPPkViFoaJu0dndb9PwdSOahA5nHeGxJZRiLbZ8daVSaIpZ1JwNw6USJmlprrpVueP/30xSuWMmFtGWBnwQJRXEZIgLcO4CXxRFb6j7dzFTmDYhQT+dAUjXRarrgJD3pCisssht1KoTzZHeE6w90v9MgQcxbLHKHhvcmki2pdV5PDdbFP3c+rq3rxC6mjg+ReZ1RziUltM/WG1IF94hyc7ht18yTrW/IEQmz6hJGRaxEIAYvsnT6LUtdXEsBWW2y6efK7u8OWVEANVV6SyojbISMu66sg+r3nhh9HSBozDs/jx8fLx0f4p3UP4lJuOkA1GikJ2jnUS7dS8sbKrya7HI0R6zluiCoiXSILiLiQpcZDv+he46z0fYmyizujJGrftClXY11hsdNDsiHW4gPtWEi88X5V1dy/sXEVsCnTpp4lM1aI+9HdUndGXWOprn6RcT1lBsXoh2YC+4/kTSQnLEzzzebl4BIMFl6l9zg6aE2dEkREpSsHMQ9uF27sDERmZ6ifICAkdexijtMnP2EUwS4x0dOBoh/dstJ2MA+cl0nLgRiNadM0unghZP0CNgS3t/WnCPTGcEC6a3e5arXxs9y3BBtyL5haa5/M8wWGhfqc1ZKjwnyPg27QhoQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 22:23:32.4360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ededbc-ee51-4c20-1b80-08dc492c606e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4083

On Wed, Mar 20, 2024 at 12:10:04PM +0000, Daniel P. Berrangé wrote:
> On Wed, Mar 20, 2024 at 03:39:27AM -0500, Michael Roth wrote:
> > Most of the current 'query-sev' command is relevant to both legacy
> > SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
> > 
> >   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
> >     the meaning of the bit positions has changed
> >   - 'handle' is not relevant to SEV-SNP
> > 
> > To address this, this patch adds a new 'sev-type' field that can be
> > used as a discriminator to select between SEV and SEV-SNP-specific
> > fields/formats without breaking compatibility for existing management
> > tools (so long as management tools that add support for launching
> > SEV-SNP guest update their handling of query-sev appropriately).
> > 
> > The corresponding HMP command has also been fixed up similarly.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  qapi/misc-target.json | 71 ++++++++++++++++++++++++++++++++++---------
> >  target/i386/sev.c     | 50 ++++++++++++++++++++----------
> >  target/i386/sev.h     |  3 ++
> >  3 files changed, 94 insertions(+), 30 deletions(-)
> > 
> > diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> > index 4e0a6492a9..daceb85d95 100644
> > --- a/qapi/misc-target.json
> > +++ b/qapi/misc-target.json
> > @@ -47,6 +47,49 @@
> >             'send-update', 'receive-update' ],
> >    'if': 'TARGET_I386' }
> >  
> > +##
> > +# @SevGuestType:
> > +#
> > +# An enumeration indicating the type of SEV guest being run.
> > +#
> > +# @sev:     The guest is a legacy SEV or SEV-ES guest.
> > +# @sev-snp: The guest is an SEV-SNP guest.
> > +#
> > +# Since: 6.2
> 
> Now 9.1 at the earliest.
> 
> > +##
> > +{ 'enum': 'SevGuestType',
> > +  'data': [ 'sev', 'sev-snp' ],
> > +  'if': 'TARGET_I386' }
> > +
> > +##
> > +# @SevGuestInfo:
> > +#
> > +# Information specific to legacy SEV/SEV-ES guests.
> > +#
> > +# @policy: SEV policy value
> > +#
> > +# @handle: SEV firmware handle
> > +#
> > +# Since: 2.12
> > +##
> > +{ 'struct': 'SevGuestInfo',
> > +  'data': { 'policy': 'uint32',
> > +            'handle': 'uint32' },
> > +  'if': 'TARGET_I386' }
> > +
> > +##
> > +# @SevSnpGuestInfo:
> > +#
> > +# Information specific to SEV-SNP guests.
> > +#
> > +# @snp-policy: SEV-SNP policy value
> > +#
> > +# Since: 6.2
> > +##
> > +{ 'struct': 'SevSnpGuestInfo',
> > +  'data': { 'snp-policy': 'uint64' },
> > +  'if': 'TARGET_I386' }
> 
> IMHO it can just be called 'policy' still, since
> it is implicitly within a 'Snp' specific type.
> 
> 
> > +
> >  ##
> >  # @SevInfo:
> >  #
> > @@ -60,25 +103,25 @@
> >  #
> >  # @build-id: SEV FW build id
> >  #
> > -# @policy: SEV policy value
> > -#
> >  # @state: SEV guest state
> >  #
> > -# @handle: SEV firmware handle
> > +# @sev-type: Type of SEV guest being run
> >  #
> >  # Since: 2.12
> >  ##
> > -{ 'struct': 'SevInfo',
> > -    'data': { 'enabled': 'bool',
> > -              'api-major': 'uint8',
> > -              'api-minor' : 'uint8',
> > -              'build-id' : 'uint8',
> > -              'policy' : 'uint32',
> > -              'state' : 'SevState',
> > -              'handle' : 'uint32'
> > -            },
> > -  'if': 'TARGET_I386'
> > -}
> > +{ 'union': 'SevInfo',
> > +  'base': { 'enabled': 'bool',
> > +            'api-major': 'uint8',
> > +            'api-minor' : 'uint8',
> > +            'build-id' : 'uint8',
> > +            'state' : 'SevState',
> > +            'sev-type' : 'SevGuestType' },
> > +  'discriminator': 'sev-type',
> > +  'data': {
> > +      'sev': 'SevGuestInfo',
> > +      'sev-snp': 'SevSnpGuestInfo' },
> > +  'if': 'TARGET_I386' }
> > +
> >  
> >  ##
> >  # @query-sev:
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 43e6c0172f..b03d70a3d1 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -353,25 +353,27 @@ static SevInfo *sev_get_info(void)
> >  {
> >      SevInfo *info;
> >      SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
> > -    SevGuestState *sev_guest =
> > -        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
> > -                                             TYPE_SEV_GUEST);
> >  
> >      info = g_new0(SevInfo, 1);
> >      info->enabled = sev_enabled();
> >  
> >      if (info->enabled) {
> > -        if (sev_guest) {
> > -            info->handle = sev_guest->handle;
> > -        }
> >          info->api_major = sev_common->api_major;
> >          info->api_minor = sev_common->api_minor;
> >          info->build_id = sev_common->build_id;
> >          info->state = sev_common->state;
> > -        /* we only report the lower 32-bits of policy for SNP, ok for now... */
> > -        info->policy =
> > -            (uint32_t)object_property_get_uint(OBJECT(sev_common),
> > -                                               "policy", NULL);
> > +
> > +        if (sev_snp_enabled()) {
> > +            info->sev_type = SEV_GUEST_TYPE_SEV_SNP;
> > +            info->u.sev_snp.snp_policy =
> > +                object_property_get_uint(OBJECT(sev_common), "policy", NULL);
> > +        } else {
> > +            info->sev_type = SEV_GUEST_TYPE_SEV;
> > +            info->u.sev.handle = SEV_GUEST(sev_common)->handle;
> > +            info->u.sev.policy =
> > +                (uint32_t)object_property_get_uint(OBJECT(sev_common),
> > +                                                   "policy", NULL);
> > +        }
> >      }
> 
> Ok, this is fixing the issues I reported earlier.
> 
> For 'policy' I do wonder if we really need to push it into the
> type specific part of the union, as oppposed to having a common
> 'policy' field that is uint64 in size.
> 
> As mentioned earlier, on the wire there's no distinction between
> int32/int64s, so there's no compat issues with changing it from
> int32 to int64.

Mentioned this in response to your earlier reply, but the renaming of
'policy' to 'snp_policy' was in response to Dave's query about old
management tools who don't understand/parse the new sev-type field
and blinding misinterpret an SNP 'policy' as an SEV one:

  https://lore.kernel.org/kvm/YTdSlg5NymDQex5T@work-vm/T/#mac6758af9bfc41ee49ff3ef5c3ec3779ec275ff9

I think the thinking is that it's better that they see nothing at all
(likely treating as policy 0x0) versus getting unexpected values and
reporting random policy features.

> 
> >  
> >      return info;
> > @@ -394,20 +396,36 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
> >  {
> >      SevInfo *info = sev_get_info();
> >  
> > -    if (info && info->enabled) {
> > -        monitor_printf(mon, "handle: %d\n", info->handle);
> > +    if (!info || !info->enabled) {
> > +        monitor_printf(mon, "SEV is not enabled\n");
> > +        goto out;
> > +    }
> > +
> > +    if (sev_snp_enabled()) {
> >          monitor_printf(mon, "state: %s\n", SevState_str(info->state));
> >          monitor_printf(mon, "build: %d\n", info->build_id);
> >          monitor_printf(mon, "api version: %d.%d\n",
> >                         info->api_major, info->api_minor);
> >          monitor_printf(mon, "debug: %s\n",
> > -                       info->policy & SEV_POLICY_NODBG ? "off" : "on");
> > -        monitor_printf(mon, "key-sharing: %s\n",
> > -                       info->policy & SEV_POLICY_NOKS ? "off" : "on");
> > +                       info->u.sev_snp.snp_policy & SEV_SNP_POLICY_DBG ? "on"
> > +                                                                       : "off");
> > +        monitor_printf(mon, "SMT allowed: %s\n",
> > +                       info->u.sev_snp.snp_policy & SEV_SNP_POLICY_SMT ? "on"
> > +                                                                       : "off");
> >      } else {
> > -        monitor_printf(mon, "SEV is not enabled\n");
> > +        monitor_printf(mon, "handle: %d\n", info->u.sev.handle);
> > +        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
> > +        monitor_printf(mon, "build: %d\n", info->build_id);
> > +        monitor_printf(mon, "api version: %d.%d\n",
> > +                       info->api_major, info->api_minor);
> 
> This set of three fields is identical in both branches, so the duplication
> in printing it should be eliminated.

Makes sense.

> 
> > +        monitor_printf(mon, "debug: %s\n",
> > +                       info->u.sev.policy & SEV_POLICY_NODBG ? "off" : "on");
> > +        monitor_printf(mon, "key-sharing: %s\n",
> > +                       info->u.sev.policy & SEV_POLICY_NOKS ? "off" : "on");
> >      }
> > +    monitor_printf(mon, "SEV type: %s\n", SevGuestType_str(info->sev_type));
> 
> I'd say 'SEV type' should be printed  before everything else, since
> that value is the discriminator for interpreting the other data that
> is printed.

Will do.

Thanks,

Mike

> 
> >  
> > +out:
> >      qapi_free_SevInfo(info);
> >  }
> 
> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 

