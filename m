Return-Path: <kvm+bounces-12332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAB5881960
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21C4A1F23E03
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D60585C65;
	Wed, 20 Mar 2024 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k4QZoQey"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2077.outbound.protection.outlook.com [40.107.101.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F92CA6
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 22:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710972615; cv=fail; b=GFFpCowZ8ryOhXrEUWZ1roJZjN6c9LWEdCOQtBRmvzP/J7kHeXf/kWpzTpE1QU8FRsI6SQ7xgHNulyk5Yv2SnxaJzx2W4gvkTrQCTQgMaKDenyhWbin97+g3gQJ1uK5xmpXh8cH/P1bOkQe2rVSk62YeIkNyQ3gIxhRsWC2BE1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710972615; c=relaxed/simple;
	bh=Pc5FAm1lO4XxL2g3qiK5QPpUmaVQLJLYy2vlnIWFgqs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HA0z6rirgPJ/h639TOtEIxgKF0IndHoU3GkckJTum3L0UNydMzR+QHy4VO44EynbHuLPgP4G8KzYArVPxxpB2OguuNpbbL5VHJyCmzP+HTdMfgGv/jd5hVFECG9aOfYBvYjzqKUVlYSyfn7mpUqtuDrK+V4BGDSXFCHBmSFCjuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k4QZoQey reason="signature verification failed"; arc=fail smtp.client-ip=40.107.101.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaloNNtOlxdQI82T3fSZVd8uaN57xv3tNZkeFzwnqj2yIWAqbZHpqdEJLOTaGUROaK60yKJNB3c8S28kjnxECHrTi65auOnNcKF3IS6iDgeVbLVwQio2jhHBVA2OMdRQttrjNzA2S6/2xMIPPosiqI6DrKJKeqNvlumoo7NzWig4QHQHV7sVOvCVnXdEaq7Tu6Wi/00VVROrcemhmBSDzkzqI56r8nwrfEl2TQBnJ17bM1T/kHBFaBf4ViL+g5mQfaMdE8HgiP8kY6NhGytcivOag+72uSxv0bMpeAoNgZ0KxFvYHgPFoCgjcXGrXCq15srCferzbQ9sr7MuubmYuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8kE3NnTFg467SUQKAu5cy3BIExieW2sn+9C4yH9ceqw=;
 b=ZhrEF4tqnbEO6sZmYkvIej33oOLpNa4pyHfQx8vGmamlieE949N0h1B2iyjvyI/MHXoDMGxfmMo4MQUVYnCEOS0R5BCKMxYt5bK3/St5ek+6V/OCFq84oOaWVQZQc4bnplTjiOcVda12AAxg/W1ZIq4RkGSRVjv8Cwsmv0Z1D7JNl45Mf0tQ+uKQnl42GiGgoYLAMGxv2d77pI/gjiqgITKjog1jGEfkoZwoLy4NaPz5LNoLfqpgqRTmzIDOLZQui5DtOwT15k5uLdhdPloWf8Nzu7Wu+I0L7NZVRrpxKDpkr0zUpoOKGl5beBhfYCkJz5A4/Jnz+X9l6pKWQ52TYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kE3NnTFg467SUQKAu5cy3BIExieW2sn+9C4yH9ceqw=;
 b=k4QZoQeySKH2ZahQpS/5Xzf6+MaF0GVFMDb941gSjI1yFFb2Aih9/+SIvXI9KBzzZTm9HkkGOiojF01LJJHVsiFbAO3T4mpzZZjjQXlL1clMCy1QeLgHfVl1dnkynLfKN7mBJY7mb3PUFZ3zcXqP0nXC4Ksm3FDEgUDMWA+OXN8=
Received: from SJ0PR13CA0106.namprd13.prod.outlook.com (2603:10b6:a03:2c5::21)
 by SJ2PR12MB9116.namprd12.prod.outlook.com (2603:10b6:a03:557::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 22:09:59 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::fe) by SJ0PR13CA0106.outlook.office365.com
 (2603:10b6:a03:2c5::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 22:09:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 22:09:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 17:09:58 -0500
Date: Wed, 20 Mar 2024 16:45:12 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	"Xiaoyao Li" <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 21/49] i386/sev: Introduce "sev-common" type to
 encapsulate common SEV state
Message-ID: <20240320214512.5m3xe2qve5mwyg4i@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-22-michael.roth@amd.com>
 <ZfrM0KJ78pv53O4j@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfrM0KJ78pv53O4j@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|SJ2PR12MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: fb87c9b0-52fb-46f7-d8e2-08dc492a7b9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vJdslEudel7OJVILK2tF3XPhgal/HvztqX5bqYJtIyVaVthYkCba1bOn4q9C7b/HsE/dwmLuWVyXB29Dlh+U+0EozAKD0HznGFKpvX0KKdC2Nwyj0T7KijGM9b7QgC+BzTKq7KElk2ZyUJiByKGoJSrs3H/nfmFlUgkV+JBvyg07LSwgsQENBOqPk3C0GKvBmiML7R8alYTyKoqymCr5J5LmANxdx+apkUV18+jN+XV8oxtn/os2EWRRlHxYiZbSGDR2cXQNuCKHY/I77TcMgmpXcTBEfABElj/MK2veMezgq54U6gUFu+OoZFAognufsicSwFcqcI2iBcR52FZQkmmFEdtNDmNh3fSkf8qZXtAnVgm1qu53dvk/SQRHY1poioc2sQ+AKEbtRjgVPC7mBJjTnPNaIQK8F3ps4zRsNPEq8yy+kn3/i5vLMm5YY2vjUgkSMoFCxiF+/J6sUDgQexyC6NW3fqCnHSkM0rOjrRjtbtyr9KsFwPid19agMSCSgO0Ez4WaQSVt26iViIlJUYjeVO1V0ZDEqkala86Dr/lgw1qSye54lGeydxPdQ6J6GrBUR18HzH66/4xCvSg4MAkMAsdk81WhP/OARW1Hyg0EwAIbzpLGoywmESZC/cEAA7huBopWdPoV/LY4XJ3T3D73xc0XCSZ+4+4FyP2zWjHhGycq4h4kWgXATwOrK2qbPmvYzsCgEIQRFdSEG7yzwg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 22:09:58.9888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb87c9b0-52fb-46f7-d8e2-08dc492a7b9f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9116

On Wed, Mar 20, 2024 at 11:47:28AM +0000, Daniel P. Berrangé wrote:
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
> 
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
> 
> If we're not going to provide a value for 'handle', then
> we should update the QAPI for this to mark the property
> as optional, which would then require doing
> 
>   info->has_handle = true;
> 
> inside this 'if' block.

I think this is another temporarily-awkward case that gets resolved
with:

  i386/sev: Update query-sev QAPI format to handle SEV-SNP

With that patch 'handle' is always available for SEV guests, and never
available for SNP, and that's managed through a discriminated union
type. I think that info->handle should be treated the same as the
other fields as part of this patch and any changes in how they are
reported should be kept in the above-mentioned patch.

This might be another artifact from v2's handling. Will get this fixed
up.

-Mike

> > +        }

> 
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
> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 

